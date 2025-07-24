within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltShell2ph_L2 "Shell Geo, Horizontal Piping || L2 || HTC || Nusselt || 2ph"
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
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellTypeVLE_L2;

  outer ClaRa.SimCenter simCenter;
//  outer parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium;

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinderWithTubes geo;

  // TILMedia VLEFluidFunctions
  import fluidFunction_cp = TILMedia.VLEFluid.MixtureCompatible.Functions.specificIsobaricHeatCapacity_phxi;
  import fluidFunction_lambda = TILMedia.VLEFluid.MixtureCompatible.Functions.thermalConductivity_phxi;
  import fluidFunction_eta = TILMedia.VLEFluid.MixtureCompatible.Functions.dynamicViscosity_phxi;
  import fluidFunction_rho = TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi;
  import fluidFunction_rho_bubble = TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleDensity_pxi;
  import fluidFunction_h_bubble = TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi;
  import fluidFunction_rho_dew = TILMedia.VLEFluid.MixtureCompatible.Functions.dewDensity_pxi;
  import fluidFunction_h_dew = TILMedia.VLEFluid.MixtureCompatible.Functions.dewSpecificEnthalpy_pxi;
  import fluidFunction_T_dew = TILMedia.VLEFluid.MixtureCompatible.Functions.dewTemperature_pxi;
  import fluidFunction_x = TILMedia.VLEFluid.MixtureCompatible.Functions.steamMassFraction_phxi;

  // TILMedia VLEFluidObjectFunctions
  import fluidObjectFunction_cp = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_lambda = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.thermalConductivity_phxi;
  import fluidObjectFunction_eta = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dynamicViscosity_phxi;
  import fluidObjectFunction_x = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi;
  import fluidObjectFunction_h_bubble = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.bubbleSpecificEnthalpy_pxi;
  import fluidObjectFunction_cp_bubble = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.bubbleSpecificIsobaricHeatCapacity_pxi;
  import fluidObjectFunction_rho_bubble = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.bubbleDensity_pxi;
  import fluidObjectFunction_h_dew = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dewSpecificEnthalpy_pxi;
  import fluidObjectFunction_rho_dew = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dewDensity_pxi;
  import fluidObjectFunction_T_dew = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dewTemperature_pxi;
  import fluidObjectFunction_rho = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi;

  import SM = ClaRa.Basics.Functions.Stepsmoother;

protected
 ClaRa.Basics.Units.ReynoldsNumber Re_1ph "Reynolds number for one phase";
 ClaRa.Basics.Units.NusseltNumber Nu_1ph "Nusselt number one tube row for one phase";
 ClaRa.Basics.Units.PrandtlNumber Pr_1ph "Prandtl number of fluid for one phase";
 Real failureStatus_1ph "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
 ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_1ph "HTC for single phase case";

 ClaRa.Basics.Units.ReynoldsNumber Re_2ph "Reynolds number for one phase";
 ClaRa.Basics.Units.NusseltNumber Nu_2ph "Nusselt number one tube row for one phase";
 ClaRa.Basics.Units.PrandtlNumber Pr_2ph "Prandtl number of fluid for one phase";
 Real failureStatus_2ph "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";
 ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_2ph "HTC for two phase case";


//  Real smoother;
 ClaRa.Basics.Units.EnthalpyMassSpecific h_bubble=fluidObjectFunction_h_bubble(
      iCom.p_in,
      iCom.xi_in,
      iCom.fluidPointer_in);
 ClaRa.Basics.Units.EnthalpyMassSpecific h_dew=fluidObjectFunction_h_dew(
      iCom.p_in,
      iCom.xi_in,
      iCom.fluidPointer_in);
//constant Real Teps=1e-3;
  constant ClaRa.Basics.Units.EnthalpyMassSpecific heps=1000 "Small enthalpy difference for smooth switching between 1ph and 2ph HT";

public
  final parameter Real C=if geo.staggeredAlignment then 1 else 0.8 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8"
                                                                                        annotation (Dialog(tab="General", group="Geometry"));
  parameter Boolean heating_nom=false "True, if nominal state implies heating, else fasle" annotation (Dialog(group="Heat Transfer"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha;
  ClaRa.Basics.Units.ThermalResistance HR "Convective heat resistance";
  ClaRa.Basics.Units.ThermalResistance HR_nom "Nominal convective heat resistance";

  Real failureStatus "True, if limits of validity are violated";

protected
  constant Real MIN=1e-5 "Limiter";
  ClaRa.Basics.Units.NusseltNumber Nu_lam "Nusselt number of laminar flow, one tube";
  ClaRa.Basics.Units.NusseltNumber Nu_turb "Nusselt number of turbulent flow, one tube";
  ClaRa.Basics.Units.NusseltNumber Nu_B "Average Nusselt number of whole tube bundle";
  ClaRa.Basics.Units.PrandtlNumber Pr_w "Prandtl number of fluid near wall";
  ClaRa.Basics.Units.FroudeNumber Fr "Froude number";
  Real Xi;
  Real G;
  Real Ph "Phase change number";
  Real K "Heat flow direction coefficient";

  final parameter ClaRa.Basics.Units.Length L=Modelica.Constants.pi/2*geo.diameter_t "Characteristic length";

  //Nominal parameters
  final parameter Real steamQuality_nom = TILMedia.VLEFluid.MixtureCompatible.Functions.steamMassFraction_phxi(                                     iCom.mediumModel, iCom.p_nom,iCom.h_nom,iCom.xi_nom);
  final parameter ClaRa.Basics.Units.HeatCapacityMassSpecific cp_w_nom=fluidFunction_cp(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DynamicViscosity eta_w_nom=fluidFunction_eta(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
  final parameter ClaRa.Basics.Units.ThermalConductivity lambda_w_nom=fluidFunction_lambda(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
  final parameter ClaRa.Basics.Units.HeatCapacityMassSpecific cp_nom = fluidFunction_cp(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DynamicViscosity eta_nom = fluidFunction_eta(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
  final parameter ClaRa.Basics.Units.ThermalConductivity lambda_nom = fluidFunction_lambda(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom = fluidFunction_rho(
        iCom.mediumModel,
        iCom.p_nom,
        iCom.h_nom,
        iCom.xi_nom);

  //Two phase nominal parameters
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_dew_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.dewDensity_pxi(
        iCom.mediumModel,
        iCom.p_nom);
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_bub_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleDensity_pxi(
        iCom.mediumModel,
        iCom.p_nom);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_evap_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.dewSpecificEnthalpy_pxi(
        iCom.mediumModel,
        iCom.p_nom) - TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(
        iCom.mediumModel,
        iCom.p_nom);
  final parameter ClaRa.Basics.Units.Temperature T_w_nom=if heating_nom then T_s_nom + 5 else T_s_nom - 5;
  final parameter ClaRa.Basics.Units.Temperature T_s_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.dewTemperature_pxi(
        iCom.mediumModel,
        iCom.p_nom);
  final parameter ClaRa.Basics.Units.HeatCapacityMassSpecific cp_bub_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.specificIsobaricHeatCapacity_phxi(
         iCom.mediumModel,
         iCom.p_nom,
         TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(
         iCom.mediumModel,
         iCom.p_nom));
  final parameter ClaRa.Basics.Units.ThermalConductivity lambda_bub_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.thermalConductivity_phxi(
         iCom.mediumModel,
         iCom.p_nom,
         TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(
         iCom.mediumModel,
         iCom.p_nom));
  final parameter ClaRa.Basics.Units.DynamicViscosity eta_dew_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.dynamicViscosity_phxi(
         iCom.mediumModel,
         iCom.p_nom,
         TILMedia.VLEFluid.MixtureCompatible.Functions.dewSpecificEnthalpy_pxi(
         iCom.mediumModel,
         iCom.p_nom));
  final parameter ClaRa.Basics.Units.DynamicViscosity eta_bub_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.dynamicViscosity_phxi(
         iCom.mediumModel,
         iCom.p_nom,
         TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(
         iCom.mediumModel,
         iCom.p_nom));

//calculation of NOMINAL single phase heat transfer coefficient
  final parameter ClaRa.Basics.Units.ReynoldsNumber Re_nom=abs(iCom.m_flow_nom)/geo.A_front/rho_nom*L/max(MIN,geo.psi)/eta_nom*rho_nom "Laminar Reynolds number one tube";
  final parameter ClaRa.Basics.Units.PrandtlNumber Pr_nom=eta_nom*cp_nom/max(MIN,lambda_nom) "Prandtl number of fluid";
  final parameter ClaRa.Basics.Units.PrandtlNumber Pr_w_nom=eta_w_nom*cp_w_nom/max(MIN,lambda_w_nom)  "Prandtl number of fluid near wall";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu_lam_nom=0.664*sqrt(Re_nom)*max(MIN,Pr_nom)^(1/3) "Nusselt number of laminar flow, one tube";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu_turb_nom=(0.037*Re_nom^0.8*Pr_nom)/(1 + 2.443*max(MIN,Re_nom)^(-0.1)*(max(MIN,Pr_nom)^(2/3) - 1))  "Nusselt number of turbulent flow, one tube";
  final parameter Real K_nom=if Pr_nom/Pr_w_nom > 1 then (max(MIN,Pr_nom/Pr_w_nom))^0.25 else (max(MIN,Pr_nom/Pr_w_nom))^0.11 "Heat flow direction coefficient";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu_nom=K_nom*(0.3 + sqrt((Nu_lam_nom^2 + Nu_turb_nom^2)))  "Nusselt number one tube";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu_B_nom=Nu_nom*(if geo.N_rows>=10 then geo.fa else (((geo.N_rows-1)*geo.fa+1)/geo.N_rows))  "Average Nusselt number of whole tube bundle";
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_1ph_nom= Nu_B_nom*lambda_nom/L;

//calculation of NOMINAL two phase heat transfer coefficient
  final parameter Real Ph_nom=cp_bub_nom*(T_s_nom - T_w_nom)/Delta_h_evap_nom;
  final parameter ClaRa.Basics.Units.PrandtlNumber Pr_2ph_nom=eta_bub_nom*cp_bub_nom/lambda_bub_nom;
  final parameter Real G_nom=Ph_nom/Pr_2ph_nom*(rho_bub_nom*eta_bub_nom/(rho_dew_nom*eta_dew_nom))^0.5;
  final parameter Real Xi_nom=0.9*(1 + 1/G_nom)^(1/3);
  // According to original paper (Fujii et. al) Reynolds number is calculated with tube diameter "d" instead of characteristic length of film flow "L" = (eta_liq^2/rho_liq^2/g)^(1/3).
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom= iCom.m_flow_nom;
  final parameter ClaRa.Basics.Units.ReynoldsNumber Re_2ph_nom=abs(m_flow_nom)/geo.A_front/rho_dew_nom*geo.diameter_t/(eta_bub_nom/rho_bub_nom);
  final parameter ClaRa.Basics.Units.FroudeNumber Fr_nom=(max(Modelica.Constants.eps, abs(m_flow_nom))/geo.A_front/rho_dew_nom)^2/Modelica.Constants.g_n/geo.diameter_t;
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_2ph_nom=lambda_bub_nom/geo.diameter_t*C*Xi_nom*(1 + (0.276*Pr_2ph_nom)/(Xi_nom^4*Fr_nom*Ph_nom))^0.25* sqrt(Re_2ph_nom);

  //calculation of NOMINAL overall heat transfer coefficient
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=if steamQuality_nom >= (1 - eps) or steamQuality_nom <= eps or heating_nom == true then alpha_1ph_nom else alpha_2ph_nom;

//Variables
  ClaRa.Basics.Units.ThermalConductivity lambda=fluidObjectFunction_lambda(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.MassFlowRate m_flow=noEvent(max(Modelica.Constants.eps, abs(iCom.m_flow_in)));
  ClaRa.Basics.Units.ThermalConductivity lambda_w=if heat.T < (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) + 1e-6) and heat.T > (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - 1e-6) then lambda_w_nom else fluid_wall.transp.lambda;
   ClaRa.Basics.Units.DynamicViscosity eta_w=if heat.T < (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) + 1e-6) and heat.T > (fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - 1e-6) then eta_w_nom else fluid_wall.transp.eta;
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp=fluidObjectFunction_cp(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.DensityMassSpecific rho=fluidObjectFunction_rho(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.DynamicViscosity eta=fluidObjectFunction_eta(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_w=fluid_wall.cp;

  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_bub=fluidObjectFunction_cp_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.ThermalConductivity lambda_bub=fluidObjectFunction_lambda(
        iCom.p_out,
        fluidObjectFunction_h_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.DensityMassSpecific rho_dew=fluidObjectFunction_rho_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.DensityMassSpecific rho_bub=fluidObjectFunction_rho_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.DynamicViscosity eta_dew=fluidObjectFunction_eta(
        iCom.p_out,
        fluidObjectFunction_h_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.DynamicViscosity eta_bub=fluidObjectFunction_eta(
        iCom.p_out,
        fluidObjectFunction_h_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out),
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.Temperature T_s=fluidObjectFunction_T_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
  ClaRa.Basics.Units.Temperature T_w=min(T_s - 1e-5, heat.T);
  ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_evap=max(1e-3, fluidObjectFunction_h_dew(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out) - fluidObjectFunction_h_bubble(
        iCom.p_out,
        iCom.xi_out,
        iCom.fluidPointer_out));

  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_pT fluid_wall(
    T=heat.T,
    p=iCom.p_bulk,
    vleFluidType=iCom.mediumModel,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true) annotation (Placement(transformation(extent={{80,80},{100,100}})));

equation

//////////////////////////////////////////////////////////Calculation of HTC for 1phase case //////////////////////////////
  Re_1ph = abs(m_flow)/geo.A_front/rho*L/geo.psi/eta*rho;
  Pr_1ph = eta*cp/max(MIN,lambda);
  Pr_w = eta_w*cp_w/max(MIN,lambda_w);
  Nu_lam = 0.664*sqrt(Re_1ph)*max(MIN,Pr_1ph)^(1/3);
  Nu_turb = (0.037*Re_1ph^0.8*Pr_1ph)/(1 + 2.443*max(MIN,Re_1ph)^(-0.1)*(max(MIN,Pr_1ph)^(2/3) - 1));
  K = SM(1.01,0.99,Pr_1ph/Pr_w)*(max(MIN,Pr_1ph/Pr_w))^0.25+SM(0.99,1.01,Pr_1ph/Pr_w)*(max(MIN,Pr_1ph/Pr_w))^0.11;
  Nu_1ph = K*(0.3 + sqrt((Nu_lam^2 + Nu_turb^2)));
  Nu_B = Nu_1ph*(if geo.N_rows>=10 then geo.fa else (((geo.N_rows-1)*geo.fa+1)/geo.N_rows));
  alpha_1ph = if useHomotopy then homotopy(Nu_B*lambda/L, alpha_nom) else Nu_B*lambda/L;
  failureStatus_1ph =  noEvent(if (Re_1ph<10e6 and Re_1ph>10) and (Pr_1ph<10e3 and Pr_1ph>0.6)  then 0 else 1);
////////////////////////////////////////////////////////// end of calculation of single phase heat transfer coefficient////////

////////////////////////////////////////////////////////// Calculation of two phase HTC ///////////////////////////////////////
  Ph = cp_bub*(T_s - T_w)/Delta_h_evap;
  Pr_2ph = eta_bub*cp_bub/lambda_bub;
  G = Ph/Pr_2ph*(rho_bub*eta_bub/(rho_dew*eta_dew))^0.5;
  Xi = 0.9*(1 + 1/G)^(1/3);
  // According to original paper (Fujii et. al) Reynolds number is calculated with tube diameter "d" instead of characteristic length of film flow "L" = (eta_liq^2/rho_liq^2/g)^(1/3).
  Re_2ph = abs(m_flow)/geo.A_front/rho_dew*geo.diameter_t/(eta_bub/rho_bub);
  Fr = (max(Modelica.Constants.eps, abs(m_flow))/geo.A_front/rho_dew)^2/Modelica.Constants.g_n/geo.diameter_t;

  alpha_2ph = lambda_bub/geo.diameter_t*C*Xi*(1 + (0.276*Pr_2ph)/(Xi^4*Fr*Ph))^0.25* sqrt(Re_2ph);
  Nu_2ph = alpha_2ph*geo.diameter_t/lambda_bub;
  failureStatus_2ph =  noEvent(if Re_2ph<5e5 then 1 else 0)
    "The greater the steam velocity (Re), the better the accuracy | for Re>5e5 the deviation is below 5%";
//////////////////////////////////////////////////////end of Calculation of two phase HTC /////////////////////////////////////

//calculation of NOMINAL heat resistance
  HR_nom = 1/(alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]);

  heat.Q_flow = if useHomotopy then homotopy(alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean, alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean) else alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

  // defining the HTC for a shell area, either heated or cooled flow supporting laminar film condensation and one phase heat transfer. Evaporation is NOT supported

  //alpha = smoother*alpha_2ph + (1 - smoother)*alpha_1ph;
  alpha = SM(h_bubble, h_bubble + heps, iCom.h_out)*alpha_1ph
        + SM(h_dew, h_dew - heps, iCom.h_out)*alpha_1ph
        + SM(h_bubble + heps, h_bubble, iCom.h_out)*SM(h_dew - heps, h_dew, iCom.h_out)*alpha_2ph;
  failureStatus = noEvent(if iCom.h_out > h_bubble and iCom.h_out < h_dew then failureStatus_2ph else failureStatus_1ph);

  //calculation of ACTUAL heat resistance
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
</html>", revisions=
      "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"), Icon(graphics));
end NusseltShell2ph_L2;
