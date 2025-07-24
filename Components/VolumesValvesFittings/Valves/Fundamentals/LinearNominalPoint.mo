within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model LinearNominalPoint "Linear | Nominal operation point | unchoked flow"

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


//   "A linear pressure loss using a constant pressure loss coefficient"
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss;
  outer ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom;
  parameter Real CL_valve[:, :]=[0, 0; 1, 1] "|Valve Characteristics|Effective apperture as function of valve position in p.u." annotation(Dialog(group="Valve Characteristics"));
  import SI = ClaRa.Basics.Units;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  parameter Basics.Units.PressureDifference Delta_p_nom=1e5 "Nominal pressure difference for Kv definition" annotation (Dialog(group="Valve Characteristics"));

  parameter Basics.Units.MassFlowRate m_flow_nom=1 "Nominal mass flow rate" annotation (Dialog(group="Valve Characteristics"));
 // parameter SI.PressureDifference Delta_p_check=0;

 // parameter SI.PressureDifference Delta_p_hyst=0;
  Modelica.Blocks.Tables.CombiTable1Dv ValveCharacteristics(table=CL_valve, columns={2});
 // Boolean ValveOpen;
  Real aperture_ "Effective apperture";
  Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";

equation
  flowIsChoked=0 "1 if flow is choked, 0 if not";
  PR_choked=-1 "Pressure ratio at which choking occurs";
  ValveCharacteristics.u[1] = noEvent(min(1, max(iCom.opening_, iCom.opening_leak_)));
  aperture_=noEvent(max(0,ValveCharacteristics.y[1]));
  Delta_p = iCom.p_in - iCom.p_out;
//  m_flow = noEvent(if checkValve then if Delta_p >0 then aperture_* m_flow_nom * Delta_p/Delta_p_nom else 0 else aperture_* m_flow_nom * Delta_p/Delta_p_nom);

//   m_flow = noEvent(if checkValve then if Delta_p >=0 then aperture_* m_flow_nom * Delta_p/Delta_p_nom else (if iCom.opening_leak_ >=1e-6 then iCom.opening_leak_* m_flow_nom * Delta_p/Delta_p_nom else Modelica.Constants.eps) else
//                                                                                                     aperture_* m_flow_nom * Delta_p/Delta_p_nom);

//ValveOpen= if m_flow>0 then true else false;

// m_flow = noEvent(
// if checkValve then
//   if Delta_p >Delta_p_check + Delta_p_hyst and not pre(ValveOpen) or Delta_p >= Delta_p_check and pre(ValveOpen)  then
//   aperture_* m_flow_nom * (Delta_p-Delta_p_check)/Delta_p_nom
//   else
//   iCom.opening_leak_* m_flow_nom * Delta_p/Delta_p_nom
//  else
// aperture_* m_flow_nom * (Delta_p-Delta_p_check)/Delta_p_nom);

//m_flow= if checkValve then SM(50,0, Delta_p)*aperture_* m_flow_nom * (Delta_p)/Delta_p_nom + SM(-10,0, Delta_p)*(-1e-5) else aperture_* m_flow_nom * (Delta_p)/Delta_p_nom;
m_flow= if checkValve then SM(50,0, Delta_p)*aperture_* m_flow_nom * (Delta_p)/Delta_p_nom else aperture_* m_flow_nom * (Delta_p)/Delta_p_nom;
//or
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
end LinearNominalPoint;
