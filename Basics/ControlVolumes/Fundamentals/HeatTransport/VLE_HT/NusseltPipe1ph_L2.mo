within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltPipe1ph_L2 "Pipe Geo || L2 || HTC || Nusselt || 1ph"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeTypeVLE_L2;

  import sm = ClaRa.Basics.Functions.Stepsmoother;
  // TILMedia VLEFluidFunctions
   import fluidFunction_cp = TILMedia.VLEFluid.MixtureCompatible.Functions.specificIsobaricHeatCapacity_phxi;
   import fluidFunction_lambda = TILMedia.VLEFluid.MixtureCompatible.Functions.thermalConductivity_phxi;
   import fluidFunction_eta = TILMedia.VLEFluid.MixtureCompatible.Functions.dynamicViscosity_phxi;
   import fluidFunction_rho = TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi;


  // TILMedia VLEFluidObjectFunctions
  import fluidObjectFunction_cp = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_lambda = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.thermalConductivity_phxi;
  import fluidObjectFunction_eta = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dynamicViscosity_phxi;
  import fluidObjectFunction_rho = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi;

  outer ClaRa.SimCenter simCenter;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry geo;

  parameter Integer boundary = 1 "Choice of heat transfer boundary condition, relevant for laminar flow heat transfer" annotation(choices(choice=1 "Uniform wall temperature in developed fluid flow (UWT+DFF)",
                           choice=2 "Uniform heat flux in developed fluid flow (UHF+DFF)",
                           choice=3 "Uniform wall temperature in undeveloped fluid flow (UWT+UFF)",
                           choice=4 "Uniform heat flux in undeveloped fluid flow (UHF+UFF)"));
  parameter Integer correlation = 2 "Cprrelation type" annotation(choices(choice=1 "Gnielinski | VDI Heat Atlas | roughness considered", choice = 2 "Ditttus and Boelter | Bejan | roughness neglected"));

  parameter Real CF_alpha_tubes=1 "Correction factor due to fouling";
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

public
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha "Heat transfer coefficient used for heat transfer calculation";
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_lam "Heat transfer coefficient - laminar part";
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_turb "Heat transfer coefficient - turbolent part";
  ClaRa.Basics.Units.ThermalResistance HR "Convective heat resistance";
  Real failureStatus "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
  ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate";
  ClaRa.Basics.Units.Velocity velocity "Mean velocity";
  ClaRa.Basics.Units.ReynoldsNumber Re "Reynolds number";
  ClaRa.Basics.Units.PrandtlNumber Pr "Prandtl number";

protected
  constant ClaRa.Basics.Units.ReynoldsNumber laminar=2200 "Maximum Reynolds number for laminar regime";
  constant ClaRa.Basics.Units.ReynoldsNumber turbulent=1e4 "Minimum Reynolds number for turbulent regime";
  constant Real MIN=Modelica.Constants.eps "Limiter";

  parameter ClaRa.Basics.Units.NusseltNumber Nu0=if boundary == 1 or boundary == 3 then 0.7 else if boundary == 2 or boundary == 4 then 0.6 else 0 "Help variable for mean Nusselt number";
  parameter ClaRa.Basics.Units.NusseltNumber Nu1=if boundary == 1 or boundary == 3 then 3.66 else if boundary == 2 or boundary == 4 then 4.364 else 0 "Help variable for mean Nusselt number";

  ClaRa.Basics.Units.NusseltNumber Nu2 "Help variable for mean Nusselt number";
  ClaRa.Basics.Units.NusseltNumber Nu3 "Help variable for mean Nusselt number";

  ClaRa.Basics.Units.NusseltNumber Nu_lam "Mean Nusselt number";

  ClaRa.Basics.Units.ThermalConductivity lambda;
  ClaRa.Basics.Units.DensityMassSpecific rho;
  ClaRa.Basics.Units.DynamicViscosity eta;
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp;
  Real zeta "Pressure loss coefficient";


// Nominal alpha calculation:
  final parameter ClaRa.Basics.Units.HeatCapacityMassSpecific cp_nom=fluidFunction_cp(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DynamicViscosity eta_nom=fluidFunction_eta(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  final parameter ClaRa.Basics.Units.ThermalConductivity lambda_nom=fluidFunction_lambda(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom=fluidFunction_rho(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  final parameter ClaRa.Basics.Units.Velocity velocity_nom=abs(iCom.m_flow_nom)/max(MIN, rho_nom*geo.A_cross);
  final parameter ClaRa.Basics.Units.ReynoldsNumber Re_nom=(rho_nom*velocity_nom*geo.diameter_hyd/max(MIN, eta_nom)) "Reynolds number";
  final parameter ClaRa.Basics.Units.PrandtlNumber Pr_nom=abs(eta_nom*cp_nom/max(MIN, lambda_nom)) "Prandtl number";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu2_nom=if boundary == 1 or boundary == 3 then 1.615*(Re_nom*Pr_nom*geo.diameter_hyd/geo.length)^(1/3) else if boundary == 2 or boundary == 4 then 1.953*(Re_nom*Pr_nom*geo.diameter_hyd/geo.length)^(1/3) else 0 "Help variable for mean Nusselt number";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu3_nom=if boundary == 3 then (2/(1 + 22*Pr_nom))^(1/6)*(Re_nom*Pr_nom*geo.diameter_hyd/geo.length)^0.5 else if boundary == 4 then (0.924)*(Pr_nom^(1/3))*(Re_nom*geo.diameter_hyd/geo.length)^(1/2) else 0 "Help variable for mean Nusselt number";

  final parameter ClaRa.Basics.Units.NusseltNumber Nu_lam_nom=(Nu1^3 + Nu0^3 + (Nu2_nom - Nu0)^3 + Nu3_nom^3)^(1/3) "Mean Nusselt number";
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_lam_nom=Nu_lam_nom*lambda_nom/max(MIN, geo.diameter_hyd);
   final parameter Real zeta_nom=abs(1/max(MIN, 1.8*Modelica.Math.log10(abs(Re_nom)) - 1.5)^2)
    "Pressure loss coefficient";
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_turb_nom=if correlation == 2 then abs(lambda_nom/geo.diameter_hyd)*0.023*Re_nom^0.8*Pr_nom^(1/3) else if correlation == 1 then abs(lambda_nom/geo.diameter_hyd)*(abs(zeta_nom)/8)*abs(Re_nom)*abs(Pr_nom)/(1 + 12.7*(abs(zeta_nom)/8)^0.5*(abs(Pr_nom)^(2/3) - 1))*(1 + (geo.diameter_hyd/geo.length)^(2/3)) else 0;
public
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=CF_alpha_tubes*(sm(
      laminar,
      turbulent,
      Re_nom)*alpha_lam_nom + sm(
      turbulent,
      laminar,
      Re_nom)*alpha_turb_nom) "Nominal HTC (used for homotopy)";
  final parameter ClaRa.Basics.Units.ThermalResistance HR_nom=1/(alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]) "Nominal convective heat resistance";
equation

//////////////MEDIA DATA CALCULATION ////////////////////////
    lambda = fluidObjectFunction_lambda(iCom.p_out,iCom.h_out,iCom.xi_out[:],iCom.fluidPointer_out);
    rho=fluidObjectFunction_rho( iCom.p_out,iCom.h_out,iCom.xi_out[:],iCom.fluidPointer_out);
    eta=fluidObjectFunction_eta(iCom.p_out,iCom.h_out,iCom.xi_out[:], iCom.fluidPointer_out);
    cp=fluidObjectFunction_cp(iCom.p_out,iCom.h_out,iCom.xi_out[:],iCom.fluidPointer_out);

//////////////////////////LAMINAR ALPHA /////////////////////
    m_flow = noEvent(max(0.0000001, abs(iCom.m_flow_in))) "Mass flow rate (sum of all N_tubes)";
    velocity= abs(m_flow)./max(MIN, rho*geo.A_cross) "Mean velocity";
    Re=(rho*velocity*geo.diameter_hyd/max(MIN,eta)) "Reynolds number";
    Pr = abs(eta*cp/max(MIN, lambda)) "Prandtl number";
    Nu2 = if boundary == 1 or boundary == 3 then  1.615 *(Re*Pr*geo.diameter_hyd/geo.length)^(1/3)
                                                   else if boundary ==  2 or boundary == 4 then 1.953 *(Re.*Pr*geo.diameter_hyd/geo.length)^(1/3)
                                                        else 0 "Help variable for mean Nusselt number";
    Nu3 = if boundary == 3 then (2 /(1 + 22 *Pr))^(1/6)*(Re*Pr*geo.diameter_hyd/geo.length)^0.5
                                                   else if boundary == 4 then  (0.924) *(Pr^(1/3))*(Re*geo.diameter_hyd/geo.length)^(1/2)
                                                        else 0 "Help variable for mean Nusselt number";

    Nu_lam=(Nu1^3 + Nu0^3 + (Nu2 - Nu0)^3 + Nu3.^3)^(1/3) "Mean Nusselt number";
    alpha_lam =  Nu_lam*lambda/max(MIN, geo.diameter_hyd);

//////////////////////////TURBULENT ALPHA ///////////////////
    zeta=abs(1/max(MIN, 1.8*Modelica.Math.log10(abs(Re)) - 1.5)^2)
    "Pressure loss coefficient";
    alpha_turb = if correlation == 2 then abs(lambda/geo.diameter_hyd)*0.023*Re^0.8*Pr^(1/3)
               else if correlation == 1 then abs(lambda/geo.diameter_hyd)*(abs(zeta)/8)*abs(Re)*abs(Pr)/(1 + 12.7*(abs(zeta)/8)^0.5*(abs(Pr)^(2/3) - 1))*(1 + (geo.diameter_hyd/geo.length)^(2/3))
               else 0;

/////////////////////////OVERALL ALPHA //////////////////////
    alpha =  if useHomotopy then homotopy(CF_alpha_tubes*(  sm(laminar, turbulent, Re)*alpha_lam
                                                          + sm(turbulent, laminar, Re)*alpha_turb), alpha_nom)
                            else CF_alpha_tubes*(  sm(laminar, turbulent, Re)*alpha_lam
                                                 + sm(turbulent, laminar, Re)*alpha_turb);

  //failure status
    if noEvent(Re > 1e6) then
      failureStatus =  1;
    else
       if noEvent(Pr < 0.6 or Pr > 1e3) then
         failureStatus = 1;
       else
         if noEvent(geo.diameter_hyd/max(MIN, geo.length*geo.N_passes) > 1) then
            failureStatus = 1;
         else
            failureStatus = 0;
         end if;
       end if;
    end if;

// defining the HTC for a straight pipe for ONE PHASE FLOW:
   heat.Q_flow = alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean "Index 1 for shell surface";

//calculation of actual heat resistance
   HR=1/max(Modelica.Constants.eps,alpha*geo.A_heat_CF[heatSurfaceAlloc]);
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
end NusseltPipe1ph_L2;
