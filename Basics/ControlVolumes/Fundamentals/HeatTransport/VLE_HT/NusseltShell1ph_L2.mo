within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltShell1ph_L2 "Shell Geo || L2 || HTC || Nusselt || 1ph"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferVLE;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellTypeVLE_L2;

  outer ClaRa.SimCenter simCenter;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes geo;

  ClaRa.Basics.Units.ReynoldsNumber Re "Reynolds number";
  ClaRa.Basics.Units.NusseltNumber Nu "Nusselt number one tube row";
  ClaRa.Basics.Units.PrandtlNumber Pr "Prandtl number of fluid";
  Real failureStatus "True, if limits of validity are violated";

protected
  constant Real MIN=1e-5 "Limiter";
  final parameter ClaRa.Basics.Units.HeatCapacityMassSpecific cp_w_nom=fluidFunction_cp(iCom.mediumModel,iCom.p_nom,iCom.h_nom,iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DynamicViscosity eta_w_nom=fluidFunction_eta(iCom.mediumModel,iCom.p_nom, iCom.h_nom, iCom.xi_nom);
  final parameter ClaRa.Basics.Units.ThermalConductivity lambda_w_nom=fluidFunction_lambda( iCom.mediumModel, iCom.p_nom,iCom.h_nom, iCom.xi_nom);
  final parameter ClaRa.Basics.Units.HeatCapacityMassSpecific cp_nom = fluidFunction_cp( iCom.mediumModel,iCom.p_nom, iCom.h_nom,iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DynamicViscosity eta_nom = fluidFunction_eta( iCom.mediumModel, iCom.p_nom, iCom.h_nom,iCom.xi_nom);
  final parameter ClaRa.Basics.Units.ThermalConductivity lambda_nom = fluidFunction_lambda( iCom.mediumModel, iCom.p_nom, iCom.h_nom, iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom = fluidFunction_rho(iCom.mediumModel,iCom.p_nom,iCom.h_nom, iCom.xi_nom);

  ClaRa.Basics.Units.NusseltNumber Nu_lam "Nusselt number of laminar flow, one tube";
  ClaRa.Basics.Units.NusseltNumber Nu_turb "Nusselt number of turbulent flow, one tube";
  ClaRa.Basics.Units.NusseltNumber Nu_B "Average Nusselt number of whole tube bundle";
  ClaRa.Basics.Units.PrandtlNumber Pr_w "Prandtl number of fluid near wall";
  Real K "Heat flow direction coefficient";
  ClaRa.Basics.Units.MassFlowRate m_flow=noEvent(max(Modelica.Constants.eps, abs(iCom.m_flow_in)));
  ClaRa.Basics.Units.ThermalConductivity lambda=fluidObjectFunction_lambda(
        iCom.p_out,
        iCom.h_out,
        iCom.xi_out,
        iCom.fluidPointer_out);
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

  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_pT fluid_wall(
    T=heat.T,
    p=iCom.p_bulk,
    vleFluidType=iCom.mediumModel,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true) annotation (Placement(transformation(extent={{70,70},{90,90}})));

public
  final parameter ClaRa.Basics.Units.Length L=Modelica.Constants.pi/2*geo.diameter_t "Characteristic length";
  final parameter Real C=if geo.staggeredAlignment then 1 else 0.8 "Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8" annotation (Dialog(tab="General", group="Geometry"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

  //calculation of NOMINAL heat transfer coefficient:
  final parameter ClaRa.Basics.Units.ReynoldsNumber Re_nom=abs(iCom.m_flow_nom)/geo.A_front/rho_nom*L/max(MIN,geo.psi)/eta_nom*rho_nom "Laminar Reynolds number one tube";
  final parameter ClaRa.Basics.Units.PrandtlNumber Pr_nom=eta_nom*cp_nom/max(MIN,lambda_nom) "Prandtl number of fluid";
  final parameter ClaRa.Basics.Units.PrandtlNumber Pr_w_nom=eta_w_nom*cp_w_nom/max(MIN,lambda_w_nom)  "Prandtl number of fluid near wall";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu_lam_nom=0.664*sqrt(Re_nom)*max(MIN,Pr_nom)^(1/3) "Nusselt number of laminar flow, one tube";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu_turb_nom=(0.037*Re_nom^0.8*Pr_nom)/(1 + 2.443*max(MIN,Re_nom)^(-0.1)*(max(MIN,Pr_nom)^(2/3) - 1)) "Nusselt number of turbulent flow, one tube";
  final parameter Real K_nom=if Pr_nom/Pr_w_nom > 1 then (max(MIN,Pr_nom/Pr_w_nom))^0.25 else (max(MIN,Pr_nom/Pr_w_nom))^0.11 "Heat flow direction coefficient";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu_nom=K_nom*(0.3 + sqrt((Nu_lam_nom^2 + Nu_turb_nom^2))) "Nusselt number one tube";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu_B_nom=Nu_nom*(if geo.N_rows>=10 then geo.fa else (((geo.N_rows-1)*geo.fa+1)/geo.N_rows)) "Average Nusselt number of whole tube bundle";
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom = Nu_B_nom*lambda_nom/L;

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha "Heat transfer coefficient";
  ClaRa.Basics.Units.ThermalResistance HR "Convective heat resistance";
  ClaRa.Basics.Units.ThermalResistance HR_nom "Nominal convective heat resistance";

equation

//calculation of heat transfer coefficient: // defining the HTC for a shell area, either heated or cooled ONE-PHASE flow. Evaporation and condensation are NOT supported

  Re = abs(m_flow)/geo.A_front/rho*L/geo.psi/eta*rho;
  Pr   = eta*cp/max(MIN,lambda);
  Pr_w   = eta_w*cp_w/max(MIN,lambda_w);
  Nu_lam = 0.664*sqrt(Re)*max(MIN,Pr)^(1/3);
  Nu_turb = (0.037*Re^0.8*Pr)/(1 + 2.443*max(MIN,Re)^(-0.1)*(max(MIN,Pr)^(2/3) - 1));
  K = SM(1.01,0.99,Pr/Pr_w)*(max(MIN,Pr/Pr_w))^0.25+SM(0.99,1.01,Pr/Pr_w)*(max(MIN,Pr/Pr_w))^0.11;
  Nu = K*(0.3 + sqrt((Nu_lam^2 + Nu_turb^2)));
  Nu_B = Nu*(if geo.N_rows>=10 then geo.fa else (((geo.N_rows-1)*geo.fa+1)/geo.N_rows));
  alpha =  if useHomotopy then homotopy(Nu_B*lambda/L, alpha_nom) else Nu_B*lambda/L;
  failureStatus =  noEvent(if (Re<10e6 and Re>10) and (Pr<10e3 and Pr>0.6)  then 0 else 1);

// end of calculation of heat transfer coefficient

//calculation of NOMINAL heat resistance
  HR_nom = 1/(alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]);

//calculation of ACTUAL heat resistance
  HR=1/max(Modelica.Constants.eps,alpha*geo.A_heat_CF[heatSurfaceAlloc]);

  heat.Q_flow = if useHomotopy then homotopy(alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean, alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean) else alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;

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
</html>"),
    Icon(graphics),
    Diagram(graphics));
end NusseltShell1ph_L2;
