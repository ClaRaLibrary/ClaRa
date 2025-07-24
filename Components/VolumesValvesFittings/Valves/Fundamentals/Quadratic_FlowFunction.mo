within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model Quadratic_FlowFunction "Quadratic | Area and Kd/zeta definition | choked flow | compressible"

//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2024, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//


  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom;
  outer Boolean checkValve;
  outer Boolean useHomotopy;
  parameter Real CL_valve[:, :]=[0, 0; 1, 1] "|Valve Characteristics|Effective apperture as function of valve position in p.u.";
  parameter Integer valveDefinition=1 "How valve characteristic is defined" annotation(Dialog(group="Valve Characteristics"), choices(
      choice=1 "Zeta value",
      choice=2 "Valve cross area"));
  parameter Basics.Units.Area A_cross=1 "Valve cross section" annotation (Dialog(group="Valve Characteristics", enable=(valveDefinition == 2)));
  parameter Real Kd=1 "Outflow number, reduction of maximum outflow due to non ideal behaviour of valve" annotation(Dialog(group="Valve Characteristics", enable=(valveDefinition==2)));
  parameter Real zeta= 100 "Pressure Loss coefficient" annotation(Dialog(group="Valve Characteristics", enable=(valveDefinition==1)));
  final parameter Real Kvs(unit="m3/h") = A_cross*sqrt(2/zeta) *sqrt(1e5/1000)*3600 "|Valve Characteristics|Flow Coefficient at nominal opening (Delta_p_nom = 1e5 Pa, rho_nom=1000 kg/m^3(cold water))";

  parameter Basics.Units.MassFlowRate m_flow_nom=Kvs/1000/3600 "|Valve Characteristics|Only for homotopy-based initialisation: Nominal mass flowrate at full aperture_";

  parameter Basics.Units.Pressure Delta_p_eps=100 "|Expert Settings||Small pressure difference for linearisation around zero flow";
  Real aperture_ "Effective apperture";
  Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";
  Modelica.Blocks.Tables.CombiTable1Dv ValveCharacteristics(table=CL_valve, columns={2});
  Basics.Units.PressureDifference Delta_p_choke=max(iCom.p_in, iCom.p_out) - max(iCom.p_in, iCom.p_out)*(2/(gamma + 1))^(gamma/(max(1e-3, gamma) - 1)) "Critical pressure difference, always positive i.e. independent of flow direction";

protected
  Real Psi;
  Basics.Units.Pressure p_in=max(iCom.p_in, iCom.p_out);
 final parameter Real zeta_=if valveDefinition==1 then zeta else 1/A_cross^2/Kd^2;
  Real gamma "Quotient of isobaric and isochoric heat capacity";
equation
  flowIsChoked=SM(min(iCom.p_in/iCom.p_out,iCom.p_out/iCom.p_in)+0.001,min(iCom.p_in/iCom.p_out,iCom.p_out/iCom.p_in)-0.001,(2/(gamma+1))^(gamma/(max(1e-3,gamma)-1))) "1 if flow is choked, 0 if not";
  PR_choked=(-1*(Delta_p_choke-max(iCom.p_in,iCom.p_out)))/max(iCom.p_in,iCom.p_out) "Pressure ratio at which choking occurs";
  ValveCharacteristics.u[1] = noEvent(min(1, max(iCom.opening_, iCom.opening_leak_)));
  aperture_=noEvent(max(0,ValveCharacteristics.y[1]));
  gamma = if (checkValve == true and iCom.opening_leak_ <= 0) or iCom.opening_ < iCom.opening_leak_ then iCom.gamma_in else (if useHomotopy then homotopy(ClaRa.Basics.Functions.Stepsmoother(10, -10, Delta_p)*iCom.gamma_in + ClaRa.Basics.Functions.Stepsmoother(-10, 10, Delta_p)*iCom.gamma_out, iCom.gamma_in) else ClaRa.Basics.Functions.Stepsmoother(10, -10, Delta_p)*iCom.gamma_in + ClaRa.Basics.Functions.Stepsmoother(-10, 10, Delta_p)*iCom.gamma_out);
  Delta_p = iCom.p_in - iCom.p_out;
//____________Hydraulics____________________________________________

  Psi = noEvent(if min(iCom.p_in/iCom.p_out,iCom.p_out/iCom.p_in)> (2/(gamma+1))^(gamma/(gamma-1)) then sqrt(gamma/(gamma-1))*sqrt(min(iCom.p_in/iCom.p_out, iCom.p_out/iCom.p_in)^(2/gamma) - min(iCom.p_in/iCom.p_out,iCom.p_out/iCom.p_in)^((gamma+1)/gamma)) else sqrt(gamma/(gamma+1))*(2/(gamma+1))^(1/(gamma-1)));
 // m_flow = noEvent(if checkValve then if Delta_p >0 then if useHomotopy then homotopy(sign(iCom.p_in-iCom.p_out)*aperture_*Psi *ClaRa.Basics.Functions.ThermoRoot(2*iCom.rho_in*p_in/zeta_, 2*iCom.rho_in/zeta_* Delta_p_eps), aperture_*Psi*m_flow_nom)
 //else
 //    sign(iCom.p_in-iCom.p_out)*aperture_*Psi *ClaRa.Basics.Functions.ThermoRoot(2*iCom.rho_in*p_in/zeta_, 2*iCom.rho_in/zeta_* Delta_p_eps) else 0 else if useHomotopy then homotopy(sign(iCom.p_in-iCom.p_out)*aperture_*Psi *ClaRa.Basics.Functions.ThermoRoot(2*iCom.rho_in*p_in/zeta_, 2*iCom.rho_in/zeta_* Delta_p_eps), aperture_*Psi*m_flow_nom)
 //else
 //    sign(iCom.p_in-iCom.p_out)*aperture_*Psi *ClaRa.Basics.Functions.ThermoRoot(2*iCom.rho_in*p_in/zeta_, 2*iCom.rho_in/zeta_* Delta_p_eps));
       m_flow = if checkValve then if useHomotopy then homotopy(SM(Delta_p_eps/10,0, Delta_p)*sign(iCom.p_in-iCom.p_out)*aperture_*Psi *ClaRa.Basics.Functions.ThermoRoot(2*iCom.rho_in*p_in/zeta_, 2*iCom.rho_in/zeta_* Delta_p_eps), aperture_*Psi*m_flow_nom)
 else
     SM(Delta_p_eps/10,0, Delta_p)*sign(iCom.p_in-iCom.p_out)*aperture_*Psi *ClaRa.Basics.Functions.ThermoRoot(2*iCom.rho_in*p_in/zeta_, 2*iCom.rho_in/zeta_* Delta_p_eps) else if useHomotopy then homotopy(sign(iCom.p_in-iCom.p_out)*aperture_*Psi *ClaRa.Basics.Functions.ThermoRoot(2*iCom.rho_in*p_in/zeta_, 2*iCom.rho_in/zeta_* Delta_p_eps), aperture_*Psi*m_flow_nom)
 else
     sign(iCom.p_in-iCom.p_out)*aperture_*Psi *ClaRa.Basics.Functions.ThermoRoot(2*iCom.rho_in*p_in/zeta_, 2*iCom.rho_in/zeta_* Delta_p_eps);
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end Quadratic_FlowFunction;
