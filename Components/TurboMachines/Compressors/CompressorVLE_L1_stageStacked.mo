within ClaRa.Components.TurboMachines.Compressors;
model CompressorVLE_L1_stageStacked "Advanced compressor or fan for VLE mixtures using the stage stacking method  according to N. Gasparovic"
  import ClaRa;
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

  outer ClaRa.SimCenter simCenter;
extends ClaRa.Basics.Icons.Compressor;
parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_th=0,
    powerOut_elMech=0,
    powerAux=P_shaft)  if contributeToCycleSummary;

  model Outline
   extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.VolumeFlowRate V_flow "Volume flow rate";
    input ClaRa.Basics.Units.Power P_hyd "Hydraulic power";
   input Real Pi "Pressure ratio";
    input ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference";
    input ClaRa.Basics.Units.RPM rpm "Rotational speed";
   input Real Delta_alpha "Angle of VIGV";
   input Real eta_isen "Hydraulic efficiency";
   input Real eta_mech "Mechanic efficiency";
   input Real Y "Specific delivery work";
   input Real m_flow_rel "Relative mass flow";
   input Real Pi_rel "Relative pressure ratio";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE  inlet;
    ClaRa.Basics.Records.FlangeVLE  outlet;
  end Summary;
  import SI = ClaRa.Basics.Units;

  inner parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1;

  final parameter Boolean allow_reverseFlow = false;

  Basics.Interfaces.FluidPortIn     fluid_inlet(Medium=medium, m_flow(final start = m_flow_nom, min=if
          allow_reverseFlow then -Modelica.Constants.inf else 1e-5)) "inlet flow"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.FluidPortOut     fluid_outlet(Medium=medium, m_flow(max=if
          allow_reverseFlow then Modelica.Constants.inf else -1e-5)) "outlet flow"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

   Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft if useMechanicalPort
     annotation (Placement(transformation(extent={{-10,90},{10,110}})));
protected
  ClaRa.Components.TurboMachines.Fundamentals.GetInputsRotary getInputsRotary
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,20})));
public
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_pT VLEFluid_inlet(
    vleFluidType=medium,
    p=fluid_inlet.p,
    T=T_in,
    xi=inStream(fluid_inlet.xi_outflow)) annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));

  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_pT VLEFluid_outlet(
    vleFluidType=medium,
    T=T_out,
    p=fluid_outlet.p,
    xi=VLEFluid_inlet.xi) annotation (Placement(transformation(extent={{70,-12},{90,8}})));

  Modelica.Blocks.Interfaces.RealInput Delta_alpha_input=Delta_alpha if useExternalVIGVangle "VIGV angle input"
                       annotation (Placement(transformation(extent={{-128,60},{-88,100}})));

      parameter Boolean showExpertSummary = simCenter.showExpertSummary "True, if expert summary should be applied"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  //__________________________/ Parameters \_____________________________
  parameter Integer N_stages = 12 "Number of Compressor Stages";
  parameter Integer N_VIGVstages = 1 "Number of VIGV Stages";
  parameter ClaRa.Basics.Units.RPM rpm_nom=3000 "Nomial rotational speed" annotation(Dialog( group = "Nominal Values"));
  parameter Real eta_isen_stage_nom = 0.9 "Nominal isentropic stage efficiency (axial: ca. 0.9, radial: ca. 0.82)"  annotation(Dialog( group = "Nominal Values"));
                                                                                              //Axial compressor: ca. 0.9, Radial compressor: 0.82
  parameter Boolean useExternalVIGVangle= false "True, if an external source should be used to set VIGV angle";
  parameter ClaRa.Basics.Units.Angle Delta_alpha_fixed=0 "Fixed angle of VIGV (variable inlet guide vanes)" annotation (Dialog(enable=not useExternalVIGVangle));
  parameter Real eta_mech = 0.99 "Mechanical efficiency";
  parameter Modelica.Units.SI.Inertia J "Moment of Inertia" annotation (Dialog(group="Fundamental Definitions", enable=not steadyStateTorque));
  parameter Boolean useMechanicalPort=false "True, if a mechenical flange should be used"  annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean steadyStateTorque=false "True, if steady state mechanical momentum shall be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean useBoundaryAssert=true "True, if simulation should stop when surge or choke boundary is hit"
                                                                           annotation(Dialog(tab = "Advanced"));
  parameter ClaRa.Basics.Units.RPM rpm_fixed=3000 "Constant rotational speed of pump" annotation (Dialog(group="Fundamental Definitions", enable=not useMechanicalPort));
  parameter ClaRa.Basics.Units.Time Tau_aux=0.1 "Time constant of auxilliary kappa states" annotation (Dialog(tab="Advanced"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=100 "Nominal mass flow" annotation(Dialog( group = "Nominal Values"));
  parameter Real Pi_nom = 7 "Nominal pressure ratio" annotation(Dialog( group = "Nominal Values"));
  parameter ClaRa.Basics.Units.Temperature T_in_nom=293.15 "Nominal inlet temperature" annotation(Dialog( group = "Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_in_nom=1.01325e5 "Nominal inlet pressure" annotation(Dialog( group = "Nominal Values"));
  parameter ClaRa.Basics.Units.MassFraction xi_nom[medium.nc - 1]=medium.xi_default "Nominal gas composition" annotation(Dialog( group = "Nominal Values"));
  parameter Boolean useFixedEnthalpyCharacteristic=false "True, if a fixed nominal stage enthalpy characteristic should be used" annotation(Dialog( group = "Nominal Values"));
  parameter ClaRa.Basics.Units.Length diameter[N_stages]=ones(N_stages)*1.5 "Individual or mean stage diameter" annotation (Dialog(group="Nominal Values", enable=not useFixedEnthalpyCharacteristic));
  parameter Real psi_nom_fixed[N_stages]=ones(N_stages)*0.8 "Fixed nominal enthalpy stage characteristic (axial: 0.2 to 0.9, radial: 0.9 to 1.4)"
                                                                                           annotation(Dialog( group = "Nominal Values", enable = useFixedEnthalpyCharacteristic));
  parameter String VIGVInfluence= "Lower" "Influence of VIGV on psi, phi and eta"
                                            annotation(Dialog(group="Parameters"), choices(choice="Higher", choice="Medium",  choice="Lower"));

  //________________________/ Variables \___________________________________
  Real Pi(final start=Pi_nom) "pressure ratio";
  ClaRa.Basics.Units.Power P_hyd "Hydraulic power";
  ClaRa.Basics.Units.VolumeFlowRate V_flow "Volume flow rate";
  Modelica.Units.SI.AngularAcceleration a "Angular acceleration of the shaft";
  ClaRa.Basics.Units.Power P_shaft "Mechanical power at shaft";
  ClaRa.Basics.Units.RPM rpm "Rotational speed";
  Modelica.Units.SI.Torque tau_fluid "Fluid torque";
  //SI.EnthalpyMassSpecific Delta_h;
  Real tau "Overall temperature ratio";
  Real tau_nom "Overall nominal temperature ratio";
  Real eta_isen "Overall isentropic efficiency";
  Real T_out;
  Real T_in;
  Real kappa "Overall heat capacity ratio";

  //SI.HeatCapacityMassSpecific cp_m;
  Real Delta_alpha "Angle of VIGV (variable inlet guide vanes)";
  Real Delta_alpha_int[i] "Angle of VIGV (variable inlet guide vanes) for internal calculation";
  Modelica.Units.SI.SpecificEnergy Y_st[i] "Specific delivery work of each stage";
  Modelica.Units.SI.SpecificEnergy Y "Specific delivery work";

  //______//Stage variables\\______________________________________________
  Real kappa_st[i] "Stage heat capacity ratio";
  Real kappa_in_st[i];
  Real kappa_out_st[i];

  Real psi_nom_st[i](each final start=1) "Nominal stage enthalpy characteristic";
  Real psi_rel_st[i]( each final start=1) "Relative stage enthalpy characteristic";
  Real psi_rel_st_vigv[i]( each final start=1) "Relative stage enthalpy characteristic for VIGV";

  Real phi_rel_st[i](each final start=1) "Relative stage performance characteristic";
  Real phi_surge_rel_st[i]( each final start=1) "Relative stage performance characteristic at surge point";
  // Real phi_max_rel_st[i]
  //   "Maximum relative stage performance characteristic";

  Real eta_isen_st[i]( each final start=eta_isen_stage_nom) "Nominal stage efficiency";
  Real eta_isen_rel_st[i](each final start = 1) "Relative stage efficiency";

  Real rpm_corr_st[i]( each final start = (rpm_nom/60)/T_in_nom^0.5) "Corrected rotational stage speed";
  Real rpm_corr_nom_st[i]( each final start = (rpm_nom/60)/T_in_nom^0.5) "Corrected nominal rotational stage speed";
  Real rpm_corr_rel_st[i](each final start = 1) "Relative corrected rotational speed";

  Real m_flow_corr_st[i]( each final start = m_flow_nom * T_in_nom^0.5 / p_in_nom) "Corrected stage mass flow";
  Real m_flow_corr_nom_st[i]( each final start = m_flow_nom * T_in_nom^0.5 / p_in_nom) "Corrected nominal stage mass flow";
  Real m_flow_corr_rel_st[i](each final start = 1) "Relative stage mass flow";

  Real epsilon_rel_st[i](each final start = 1) "Relative stage pressure characteristic";
  Real epsilon_rel_st_vigv[i](each final start = 1) "Relative stage pressure characteristic for VIGV";

  Real C_1_st[i] "Constant";
  Real C_2_st[i] "Constant";

  Real tau_st[i](each final start = 1.00001) "Stage temperature ratio";
  Real Pi_st[i]( each final start = Pi_nom^(1/N_stages)) "Stage pressure ratio";
  Real Pi_prod_st[i](  each final start = 1) "Overall pressure ratio until actual stage"; //not important, just for evaluation

  ClaRa.Basics.Units.Temperature T_out_st[i](each final start=T_in_nom) "Calculated outlet stage temperature";
  ClaRa.Basics.Units.Pressure p_out_st[i](each final start=1e5) "Calculated outlet stage pressure";

//Stufenvariablen nominal
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_in_nom_st[i] "Nominal isobaric heat capacity at stage inlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_in_st[i] "Isobaric heat capacity at stage inlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cv_in_st[i] "Isobaric heat capacity at stage inlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cv_in_nom_st[i] "Nominal isochoric heat capacity at stage inlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_out_nom_st[i] "Nominal isobaric heat capacity at stage outlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_out_nom_st_vigv[i] "Nominal isobaric heat capacity at stage outlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_out_st[i] "Isobaric heat capacity at stage outlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cv_out_st[i] "Isobaric heat capacity at stage outlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cv_out_nom_st[i] "Nominal isochoric heat capacity at stage outlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cv_out_nom_st_vigv[i] "Nominal isochoric heat capacity at stage outlet";

// Real gamma_in_nom_st[i];
// Real gamma_in_st[i];
// Real gamma_out_nom_st[i];
// Real gamma_out_st[i];

  Real Pi_nom_st[i](each final start = Pi_nom^(1/N_stages)) "Nominal stage pressure ratio";
  Real Pi_nom_st_vigv[i](each final start = Pi_nom^(1/N_stages)) "Nominal stage pressure ratio for VIGV";
  Real Pi_prod_nom_st[i]( each final start = 1) "Overall nominal pressure ratio until actual stage";
                                                                            //(not important for design point calculation, just for evaluation)
  Real kappa_nom_st[i] "Nominal stage heat capacity ratio";
  ClaRa.Basics.Units.Temperature T_out_nom_st[i](each final start=T_in_nom) "Nominal stage outlet temperature";
  ClaRa.Basics.Units.Efficiency eta_isen_nom_st[i](each final start=eta_isen_stage_nom) "Nominal isentropic stage efficiency";
  Real tau_nom_st[i](each final start = 1.00001) "Nominal stage temperature ratio";
  Real tau_nom_st_vigv[i](each final start = 1.00001) "Nominal stage temperature ratio for VIGV";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_out_nom_st[i] "Nominal stage outlet enthalpy";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_in_nom_st "Nominal compressor inlet enthalpy";
  ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_nom_st[i] "Nominal stage enthalpy difference";
  ClaRa.Basics.Units.Pressure p_out_nom_st[i](each final start=1e5) "Nominal outlet stage pressure";

protected
 Real kappa_aux_st[i] "Auxiliary state for kappa (needed when composition changes)";
 Real kappa_aux "Auxiliary state for kappa over whole machine (needed when composition changes)";
 Real kappa_nom_aux_st[i] "Auxiliary state for kappa (needed when composition changes)";
 Integer count_surge[i];
 Integer count_choke[i];

// Real thExpCoef_in_nom_st[i];//isobaric thermal expansion coefficient
 Real isothComp_in_nom_st[i]; //isothermal compressibility
 Real spVol_in_nom_st[i]; //specific volume
// Real thExpCoef_out_nom_st[i];//isobaric thermal expansion coefficient
 Real isothComp_out_nom_st[i];//isothermal compressibility
 Real spVol_out_nom_st[i]; //specific volume
// Real thExpCoef_in_st[i];//isobaric thermal expansion coefficient
 Real isothComp_in_st[i]; //isothermal compressibility
 Real spVol_in_st[i]; //specific volume
// Real thExpCoef_out_st[i];//isobaric thermal expansion coefficient
 Real isothComp_out_st[i];//isothermal compressibility
 Real spVol_out_st[i]; //specific volume
// Real h_out_st[i];
 Real isothComp_out_nom_st_vigv[i];//isothermal compressibility
 Real spVol_out_nom_st_vigv[i]; //specific volume

//  Real thExpCoef_out_nom_rp2;//isobaric thermal expansion coefficient
  Real isothComp_out_nom_rp2;//isothermal compressibility
  Real spVol_out_nom_rp2; //specific volume
//  Real thExpCoef_out_rp2;//isobaric thermal expansion coefficient
  Real isothComp_out_rp2;//isothermal compressibility
  Real spVol_out_rp2; //specific volume
//   Real h_out_rp2;
//   Real h_out_nom_rp2;
  Real cp_out_nom_rp2;
  Real cp_out_rp2;
  Real cv_out_nom_rp2;
  Real cv_out_rp2;

// Real gamma_out_nom_rp2;
// Real gamma_out_rp2;

 Real kappa_in_nom_st[i];
 Real kappa_out_nom_st[i];
 Real kappa_out_nom_st_vigv[i];
 Real kappa_nom_aux_st_vigv[i];
 Real kappa_nom_st_vigv[i];

 Real eta_isen_od_rpm;
 Real eta_isen_rel_od_rpm(final start = 1);
 Real kappa_out_nom_rp2;
 Real kappa_aux_nom_rp2;
 Real kappa_nom_rp2;
 Real kappa_out_rp2;
 Real kappa_aux_rp2;
 Real kappa_rp2;
 Real T_out_rp2;
 Real tau_rp2;
 Real tau_nom_rp2;
 Real Pi_rp2;
 Real m_flow_corr_rel_rp2;
 Real m_flow_corr_rp2;
 Real rpm_corr_rel_rp2(final start = 1);
 Real phi_rel_rp2(final start = 1);
 Real psi_rel_rp2(final start = 1);
 Real psi_nom_rp2;
 Real epsilon_rel_rp2(final start = 1);
 //Real Pi_nom_rp1;
 Real Delta_h_nom_rp2;
  ClaRa.Basics.Units.MassFlowRate m_flow_aux(start=m_flow_nom);

 final parameter Integer i = N_stages;

//Version 4 mit eta neu (passt sehr gut)
 final parameter Real vigv_coeff_eta_a = if VIGVInfluence=="Lower" then 7e-7 else if VIGVInfluence=="Higher" then 3e-6 else 2e-6;
 final parameter Real vigv_coeff_eta_b = if VIGVInfluence=="Lower" then -0.0003 else if VIGVInfluence=="Higher" then -0.0006 else -0.0004;
 final parameter Real vigv_coeff_eta_c = if VIGVInfluence=="Lower" then 0.0011 else if VIGVInfluence=="Higher" then 0.0014 else 0.0013;
 final parameter Real vigv_coeff_phi_a = if VIGVInfluence=="Lower" then -0.00004 else if VIGVInfluence=="Higher" then -0.0002 else -0.0001;
 final parameter Real vigv_coeff_phi_b = if VIGVInfluence=="Lower" then 0.0176 else if VIGVInfluence=="Higher" then 0.0294 else 0.0228;
 final parameter Real vigv_coeff_psi_a = if VIGVInfluence=="Lower" then -0.0001 else if VIGVInfluence=="Higher" then -0.0002 else -0.0001;
 final parameter Real vigv_coeff_psi_b = if VIGVInfluence=="Lower" then 0.0131 else if VIGVInfluence=="Higher" then 0.0218 else 0.0169;


public
   inner Summary summary(outline(
   V_flow = V_flow,
   P_hyd = P_hyd,
   Pi = Pi,
   Delta_p = fluid_outlet.p - fluid_inlet.p,
   rpm = rpm,
   Delta_alpha = Delta_alpha,
   eta_isen = eta_isen,
   eta_mech = eta_mech,
   Y = Y,
   m_flow_rel = m_flow_corr_rel_st[1],
   Pi_rel=Pi/Pi_nom),
    inlet(      showExpertSummary=showExpertSummary,
      m_flow=-fluid_inlet.m_flow,
      T=VLEFluid_inlet.T,
      p=fluid_inlet.p,
      h=VLEFluid_inlet.h,
      s=VLEFluid_inlet.s,
      steamQuality=VLEFluid_inlet.q,
      H_flow=-VLEFluid_inlet.h*fluid_inlet.m_flow,
      rho=VLEFluid_inlet.d),
    outlet(      showExpertSummary=showExpertSummary,
      m_flow=-fluid_inlet.m_flow,
      T=VLEFluid_outlet.T,
      p=fluid_outlet.p,
      h=VLEFluid_outlet.h,
      s=VLEFluid_outlet.s,
      steamQuality=VLEFluid_outlet.q,
      H_flow=-VLEFluid_outlet.h*fluid_outlet.m_flow,
      rho=VLEFluid_outlet.d)) annotation (Placement(transformation(extent={{-100,
            -114},{-80,-94}})));

public
  Basics.Interfaces.EyeOut eyeOut annotation (Placement(transformation(extent={{72,-78},
            {112,-42}}),          iconTransformation(extent={{92,-70},{112,-50}})));
protected
  Basics.Interfaces.EyeIn eye_int[1] annotation (Placement(transformation(extent={{48,-68},
            {32,-52}}),           iconTransformation(extent={{90,-84},{84,-78}})));

protected
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid Rp2OutNom(vleFluidType=medium);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid Rp2Out(vleFluidType=medium);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid InletT(vleFluidType=medium);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid InletNom(vleFluidType=medium);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid OutletNom[i](each vleFluidType=medium);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid Inlet(vleFluidType=medium);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid Outlet[i](each vleFluidType=medium);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid OutletVigv[i](each vleFluidType=medium);
initial equation

  fluid_inlet.m_flow = m_flow_corr_st[1]*VLEFluid_inlet.p/ VLEFluid_inlet.T^0.5;

  kappa =-TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
    fluid_inlet.p,
    T_in,
    xi_nom,
    Inlet.vleFluidPointer)/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
    fluid_inlet.p,
    T_in,
    xi_nom,
    Inlet.vleFluidPointer)*(1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
    fluid_inlet.p,
    T_in,
    xi_nom,
    Inlet.vleFluidPointer)/fluid_inlet.p*(-1/(
    TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
    fluid_inlet.p,
    T_in,
    xi_nom,
    Inlet.vleFluidPointer)*(1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
    fluid_inlet.p,
    T_in,
    xi_nom,
    Inlet.vleFluidPointer)))));

   if N_stages > 1 then
    for i in 1:N_stages loop
     kappa_st[i] =  kappa;
     kappa_nom_st[i] =  kappa_st[i];
     kappa_nom_st_vigv[i] =  kappa_st[i];
    end for;

   else
    for i in 1:N_stages loop
     kappa_st[i] =  kappa;
     kappa_nom_st[i] =  kappa_st[i];
     kappa_nom_st_vigv[i] =  kappa_st[i];
     kappa_rp2 = kappa;
     kappa_nom_rp2 = kappa_rp2;
    end for;
   end if;

equation
//____________________ Mechanics ___________________________
    if useMechanicalPort then
      der(getInputsRotary.rotatoryFlange.phi) = (2*Modelica.Constants.pi*rpm/60);
      J*a - tau_fluid + getInputsRotary.rotatoryFlange.tau = 0 "Mechanical momentum balance";
    else
      rpm = rpm_fixed;
      getInputsRotary.rotatoryFlange.phi = 0.0;
    end if;

    if (steadyStateTorque) then
      a = 0;
    else
      a = 2*Modelica.Constants.pi/60*der(rpm);
    end if;
    tau_fluid = if noEvent(2*Modelica.Constants.pi*rpm/60<1e-8) then 0 else P_shaft/(2*Modelica.Constants.pi*rpm/60);

  //__________Angle of VIGV_______________
   if (not useExternalVIGVangle) then
     Delta_alpha=Delta_alpha_fixed;
   end if;

   for i in 1:N_stages loop
    Delta_alpha_int[i] = if i <= N_VIGVstages then Delta_alpha else 0;
   end for;

T_in =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.temperature_phxi(
    fluid_inlet.p,
    inStream(fluid_inlet.h_outflow),
    inStream(fluid_inlet.xi_outflow),
    InletT.vleFluidPointer);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT//////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if N_stages == 1 then  ////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY/////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    cp_in_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);
    cv_in_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);
    isothComp_in_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);
    spVol_in_nom_st[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);

    cp_out_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);
    cv_out_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);
    isothComp_out_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);
    spVol_out_nom_st[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);

    kappa_in_nom_st[1]=  -cp_in_nom_st[1]/cv_in_nom_st[1]* (spVol_in_nom_st[1]/p_in_nom * (-1/(isothComp_in_nom_st[1]*spVol_in_nom_st[1])));
    kappa_out_nom_st[1]= -cp_out_nom_st[1]/cv_out_nom_st[1]* (spVol_out_nom_st[1]/p_out_nom_st[1] * (-1/(isothComp_out_nom_st[1]*spVol_out_nom_st[1])));
    kappa_nom_aux_st[1] = (kappa_in_nom_st[1] + kappa_out_nom_st[1]) / 2;
    der(kappa_nom_st[1]) = 1/Tau_aux*(kappa_nom_aux_st[1]-kappa_nom_st[1]);
//kappa_nom_st[1]=1.4;

    tau_nom_st[1] = 1 + (Pi_nom_st[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1) * 1/eta_isen_nom_st[1];
    T_out_nom_st[1] = tau_nom_st[1] * T_in_nom; //eq. 18
    p_out_nom_st[1] = p_in_nom * Pi_nom;
    h_in_nom_st =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.vapourSpecificEnthalpy_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);
    h_out_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.vapourSpecificEnthalpy_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);
    Delta_h_nom_st[1] = h_out_nom_st[1] - h_in_nom_st;

    eta_isen_nom_st[1] = eta_isen_stage_nom;

    Pi_prod_nom_st[1] = Pi_nom; //Overall pressure ratio until actual stage
    Pi_nom_st[1] = Pi_nom;

    tau_nom_st[1] = tau_nom;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
else   ////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE/////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    cp_in_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);
    cv_in_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);
    isothComp_in_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);
    spVol_in_nom_st[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);

    cp_out_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);
    cv_out_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);
    isothComp_out_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);
    spVol_out_nom_st[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);

    kappa_in_nom_st[1]=  -cp_in_nom_st[1]/cv_in_nom_st[1]* (spVol_in_nom_st[1]/p_in_nom * (-1/(isothComp_in_nom_st[1]*spVol_in_nom_st[1])));
    kappa_out_nom_st[1]=  -cp_out_nom_st[1]/cv_out_nom_st[1]* (spVol_out_nom_st[1]/p_out_nom_st[1] * (-1/(isothComp_out_nom_st[1]*spVol_out_nom_st[1])));
    kappa_nom_aux_st[1] = (kappa_in_nom_st[1] + kappa_out_nom_st[1]) / 2;
    der(kappa_nom_st[1]) = 1/Tau_aux*(kappa_nom_aux_st[1]-kappa_nom_st[1]); //Auxiliary state for kappa (needed when composition changes)
//kappa_nom_st[1]=1.4;
    tau_nom_st[1] = 1 + ((p_out_nom_st[1] / p_in_nom)^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1) * 1/eta_isen_nom_st[1];
    T_out_nom_st[1] = tau_nom_st[1] * T_in_nom; //eq. 18
    p_out_nom_st[1] = p_in_nom * Pi_nom_st[1];
    h_in_nom_st =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEnthalpy_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.vleFluidPointer);
    h_out_nom_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEnthalpy_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].vleFluidPointer);
    Delta_h_nom_st[1] = h_out_nom_st[1] - h_in_nom_st;

    eta_isen_nom_st[1] = eta_isen_stage_nom;

    Pi_prod_nom_st[1] = Pi_nom_st[1]; //Overall pressure ratio until actual stage

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   for i in 2:N_stages loop  ////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

       cp_in_nom_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_nom_st[i - 1],
        T_out_nom_st[i - 1],
        xi_nom,
        OutletNom[i - 1].vleFluidPointer);
       cv_in_nom_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_nom_st[i - 1],
        T_out_nom_st[i - 1],
        xi_nom,
        OutletNom[i - 1].vleFluidPointer);
       isothComp_in_nom_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
        p_out_nom_st[i - 1],
        T_out_nom_st[i - 1],
        xi_nom,
        OutletNom[i - 1].vleFluidPointer);
       spVol_in_nom_st[i] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
        p_out_nom_st[i - 1],
        T_out_nom_st[i - 1],
        xi_nom,
        OutletNom[i - 1].vleFluidPointer);

       cp_out_nom_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_nom_st[i],
        T_out_nom_st[i],
        xi_nom,
        OutletNom[i].vleFluidPointer);
       cv_out_nom_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_nom_st[i],
        T_out_nom_st[i],
        xi_nom,
        OutletNom[i].vleFluidPointer);
       isothComp_out_nom_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
        p_out_nom_st[i],
        T_out_nom_st[i],
        xi_nom,
        OutletNom[i].vleFluidPointer);
       spVol_out_nom_st[i] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
        p_out_nom_st[i],
        T_out_nom_st[i],
        xi_nom,
        OutletNom[i].vleFluidPointer);

       kappa_in_nom_st[i]=  -cp_in_nom_st[i]/cv_in_nom_st[i]* (spVol_in_nom_st[i]/p_out_nom_st[i-1] * (-1/(isothComp_in_nom_st[i]*spVol_in_nom_st[i])));
       kappa_out_nom_st[i]=  -cp_out_nom_st[i]/cv_out_nom_st[i]* (spVol_out_nom_st[i]/p_out_nom_st[i] * (-1/(isothComp_out_nom_st[i]*spVol_out_nom_st[i])));
       kappa_nom_aux_st[i] = (kappa_in_nom_st[i] + kappa_out_nom_st[i]) / 2;
       der(kappa_nom_st[i]) = 1/Tau_aux*(kappa_nom_aux_st[i]-kappa_nom_st[i]); //Auxiliary state for kappa (needed when composition changes)
//kappa_nom_st[i]=1.4;
       tau_nom_st[i] = 1 + (Pi_nom_st[i]^((kappa_nom_st[i]-1)/kappa_nom_st[i])-1) * 1/eta_isen_nom_st[i]; //eq. 25
       T_out_nom_st[i] = tau_nom_st[i] * T_out_nom_st[i-1]; //eq. 18
       Pi_nom_st[i] = p_out_nom_st[i] / p_out_nom_st[i-1];
       h_out_nom_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEnthalpy_pTxi(
        p_out_nom_st[i],
        T_out_nom_st[i],
        xi_nom,
        OutletNom[i].vleFluidPointer);
       Delta_h_nom_st[i] = h_out_nom_st[i] - h_out_nom_st[i-1];

       eta_isen_nom_st[i] = eta_isen_stage_nom;

       Pi_prod_nom_st[i] = product(Pi_nom_st[j] for j in 1:i); //Overall pressure ratio until actual stage

       tau_nom_st[i]=2-1/tau_nom_st[i-1];

   end for;

   Pi_nom = product(Pi_nom_st);
   tau_nom = product(tau_nom_st);

end if;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////OFF DESIGN////OFF DESIGN////OFF DESIGN////OFF DESIGN////OFF DESIGN////OFF DESIGN////OFF DESIGN////OFF DESIGN////OFF DESIGN////OFF DESIGN////OFF DESIGN////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 if N_stages == 1 then ////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY/////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      cp_in_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer);
      cv_in_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer);
      isothComp_in_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer);
      spVol_in_st[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer);

     // h_out_st[1] = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_pTxi(fluid_outlet.p,T_out,inStream(fluid_inlet.Xi_outflow),VLEFluidPointer);
      cp_out_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      fluid_outlet.p,
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer);
      cv_out_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      fluid_outlet.p,
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer);
      isothComp_out_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      fluid_outlet.p,
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer);
      spVol_out_st[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      fluid_outlet.p,
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer);

    kappa_in_st[1]=  -cp_in_st[1]/cv_in_st[1]* (spVol_in_st[1]/fluid_inlet.p * (-1/(isothComp_in_st[1]*spVol_in_st[1])));
    kappa_out_st[1]=  -cp_out_st[1]/cv_out_st[1]* (spVol_out_st[1]/fluid_outlet.p * (-1/(isothComp_out_st[1]*spVol_out_st[1])));
    kappa_aux_st[1] = (kappa_in_st[1] + kappa_out_st[1]) / 2;
      der(kappa_st[1]) = 1/Tau_aux*(kappa_aux_st[1]-kappa_st[1]);
//kappa_st[1]=1.4;
      //_____________/Corrected RPM\_______________________________________________________
      rpm_corr_nom_st[1] = (rpm_nom/60)/T_in_nom^0.5;
      rpm_corr_st[1] = (rpm/60)/T_in^0.5;
      rpm_corr_rel_st[1] = rpm_corr_st[1]/rpm_corr_nom_st[1];

      //_____________/Corrected mass flow\_________________________________________________
      m_flow_corr_nom_st[1] = m_flow_nom * T_in_nom^0.5 / p_in_nom * (1 + vigv_coeff_phi_a*Delta_alpha_int[1]^2 + vigv_coeff_phi_b*Delta_alpha_int[1]); //eq. 33 (multiplied with additional inlet guide vane function)
      m_flow_corr_st[1] = m_flow_aux * T_in^0.5 / fluid_inlet.p;
      m_flow_corr_rel_st[1] = m_flow_corr_st[1]/(m_flow_corr_nom_st[1]);

      //_____________/Stage performance characteristic\____________________________________
      phi_rel_st[1] = m_flow_corr_rel_st[1]/rpm_corr_rel_st[1]; //eq. 34

       //_____________/Additional values for stage enthalpy characteristic\_________________
       if useFixedEnthalpyCharacteristic == false then
         psi_nom_st[1] = Delta_h_nom_st[1]/(Modelica.Constants.pi^2 * diameter[1]^2 * (rpm_nom/60)^2/2) * (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);//eq. 19 (multiplied with additional inlet guide vane function)
       else
         psi_nom_st[1] = psi_nom_fixed[1] * (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);
       end if;

      C_1_st[1] = 2/psi_nom_st[1];
      C_2_st[1] = 1 - C_1_st[1];

      //_____________/Stage enthalpy characteristic\_______________________________________
      psi_rel_st[1] = C_1_st[1] + C_2_st[1] * phi_rel_st[1]; //eq. 15

      //_____________/Stage pressure characteristic\_______________________________________
      epsilon_rel_st[1] = (1 + C_1_st[1] - C_1_st[1] * phi_rel_st[1]) * phi_rel_st[1]; //eq. 39

      //_____________/Reference point adjustion for VIGV\________________________________________________
      psi_rel_st_vigv[1] = (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);
      epsilon_rel_st_vigv[1] =(-C_1_st[1]*(psi_rel_st_vigv[1]^2+1) + (C_1_st[1]^2+1)* psi_rel_st_vigv[1])/C_2_st[1]^2;

      cp_out_nom_st_vigv[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].vleFluidPointer);
      cv_out_nom_st_vigv[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].vleFluidPointer);
      isothComp_out_nom_st_vigv[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].vleFluidPointer);
      spVol_out_nom_st_vigv[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].vleFluidPointer);
      kappa_out_nom_st_vigv[1]= -cp_out_nom_st_vigv[1]/cv_out_nom_st_vigv[1]* (spVol_out_nom_st_vigv[1]/(p_in_nom*Pi_nom_st_vigv[1]) * (-1/(isothComp_out_nom_st_vigv[1]*spVol_out_nom_st_vigv[1])));
      kappa_nom_aux_st_vigv[1] = (kappa_in_nom_st[1] + kappa_out_nom_st_vigv[1]) / 2;
      der(kappa_nom_st_vigv[1]) = 1/Tau_aux*(kappa_nom_aux_st_vigv[1]-kappa_nom_st_vigv[1]);

      tau_nom_st_vigv[1] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1) * 1/(eta_isen_od_rpm *min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1)) else tau_nom_st[1];
      Pi_nom_st_vigv[1] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[1] * (Pi_nom_st[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1))^(kappa_nom_st_vigv[1]/(kappa_nom_st_vigv[1]-1)) else Pi_nom_st[1];

      //_____________/Stage temperature ratio\_____________________________________________
      tau_st[1] = 1 + psi_rel_st[1] * rpm_corr_rel_st[1]^2 * (tau_nom_st_vigv[1]-1);  //eq. 22
      T_out_st[1] = tau_st[1] * VLEFluid_inlet.T; //eq. 18

      //_____________/Stage pressure ratio\________________________________________________
      epsilon_rel_st[1] = 1/rpm_corr_rel_st[1]^2 * ((Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1)/(Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1)); //eq. 31
      Pi_st[1] = fluid_outlet.p/fluid_inlet.p;

      //_____________/Isentropic stage efficiency\_________________________________________
      eta_isen_st[1] = (Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1) / (tau_st[1] - 1); //eq. 23
      eta_isen_rel_st[1] = eta_isen_st[1]/(eta_isen_od_rpm *min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1));

       p_out_st[1] = fluid_inlet.p * Pi_st[1];
       T_out = T_out_st[1];
       Pi = Pi_st[1];
       tau = tau_st[1];
       kappa = kappa_st[1];
       kappa_aux=kappa;
       eta_isen = eta_isen_st[1];
       Pi_prod_st[1] = Pi_st[1];

   Y_st[1]=(p_out_st[1] - fluid_inlet.p)/(0.5*(TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer) + TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
      fluid_outlet.p,
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer)));

   //____________/Surge line\____________________________________________________________
   if psi_nom_st[i] <= 0.9 then
     phi_surge_rel_st[1] = 1/3 +  (2 + psi_nom_st[1])/6; //eq. 66 and 40 (axial machine)
   else
     phi_surge_rel_st[1] = 2/7 + 5/7 * (2 + psi_nom_st[1])/4; //eq. from goettlich and 40 (radial machine)
   end if;

   /////////////////////////////////////////////////////////////////////////////////////////////////////////
   //___________/Auxilliary reference point (rp2) for calculation of new reference efficiency at off design speed
   //This correction is only necessary if a single compressor stage is calculated.
   //For this correction a new reference point (rp1) is needed for each off design speed line.
   //See also Goettlich for documentation of this corrected calculation for a single stage only.
   /////////////////////////////////////////////////////////////////////////////////////////////////////////

   rpm_corr_rel_rp2 = 1.0;
   m_flow_corr_rel_rp2 = rpm_corr_rel_st[1];

   m_flow_corr_rp2 = m_flow_corr_rel_rp2 * m_flow_nom * T_in_nom^0.5 / p_in_nom;

   phi_rel_rp2 = rpm_corr_rel_st[1]; // Goettlich eq. 6.12 (error in Goettlich betw. eq. 6.11 and 6.12: phi_rel_1 = 1.0)

   if useFixedEnthalpyCharacteristic == false then
     psi_nom_rp2 = Delta_h_nom_rp2/(Modelica.Constants.pi^2 * diameter[1]^2 * (rpm_nom/60)^2/2);
   else
     psi_nom_rp2 = psi_nom_fixed[1];
   end if;

   epsilon_rel_rp2 = (1 + (2/psi_nom_rp2) - (2/psi_nom_rp2) * phi_rel_rp2) * phi_rel_rp2;
   psi_rel_rp2 = (2/psi_nom_rp2) + (1- 2/psi_nom_rp2) * phi_rel_rp2;

   // eta_isen_rel_od_rpm = epsilon_rel_rp2/psi_rel_rp2;
   // eta_isen_od_rpm = eta_isen_rel_od_rpm * eta_isen_stage_nom;

   tau_nom_rp2 = 1 + (Pi_nom^((kappa_nom_rp2-1)/kappa_nom_rp2)-1) * 1/eta_isen_stage_nom;
   tau_rp2 = 1 + psi_rel_rp2 * rpm_corr_rel_rp2^2 * (tau_nom_rp2-1);
   T_out_rp2 = tau_rp2 * VLEFluid_inlet.T;
   Delta_h_nom_rp2 =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEnthalpy_pTxi(
      p_in_nom*Pi_nom,
      T_in_nom*tau_nom_rp2,
      xi_nom,
      Rp2OutNom.vleFluidPointer) - h_in_nom_st;

   // h_out_nom_rp2 = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_pTxi(fluid_inlet.p*Pi_nom_st[1],T_in_nom*tau_nom_rp2,inStream(fluid_inlet.Xi_outflow),VLEFluidPointer);
    cp_out_nom_rp2 =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom*Pi_nom,
      T_in_nom*tau_nom_rp2,
      xi_nom,
      Rp2OutNom.vleFluidPointer);
    cv_out_nom_rp2 =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom*Pi_nom,
      T_in_nom*tau_nom_rp2,
      xi_nom,
      Rp2OutNom.vleFluidPointer);
    isothComp_out_nom_rp2 =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      p_in_nom*Pi_nom,
      T_in_nom*tau_nom_rp2,
      xi_nom,
      Rp2OutNom.vleFluidPointer);
    spVol_out_nom_rp2 =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      p_in_nom*Pi_nom,
      T_in_nom*tau_nom_rp2,
      xi_nom,
      Rp2OutNom.vleFluidPointer);

    kappa_out_nom_rp2 = -cp_out_nom_rp2/cv_out_nom_rp2* (spVol_out_nom_rp2/(fluid_inlet.p*Pi_nom_st[1]) * (-1/(isothComp_out_nom_rp2*spVol_out_nom_rp2)));
    kappa_aux_nom_rp2 = (kappa_in_nom_st[1] + kappa_out_nom_rp2)/2.0;
    der(kappa_nom_rp2) = 1/Tau_aux*(kappa_aux_nom_rp2-kappa_nom_rp2);
//kappa_nom_rp2=1.4;
  //  h_out_rp2 = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_pTxi(fluid_inlet.p*Pi_rp2,T_out_rp2,inStream(fluid_inlet.Xi_outflow),VLEFluidPointer);
    cp_out_rp2 =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      fluid_inlet.p*Pi_rp2,
      T_out_rp2,
      inStream(fluid_inlet.xi_outflow),
      Rp2Out.vleFluidPointer);
    cv_out_rp2 =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      fluid_inlet.p*Pi_rp2,
      T_out_rp2,
      inStream(fluid_inlet.xi_outflow),
      Rp2Out.vleFluidPointer);
    isothComp_out_rp2 =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      fluid_inlet.p*Pi_rp2,
      T_out_rp2,
      inStream(fluid_inlet.xi_outflow),
      Rp2Out.vleFluidPointer);
    spVol_out_rp2 =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      fluid_inlet.p*Pi_rp2,
      T_out_rp2,
      inStream(fluid_inlet.xi_outflow),
      Rp2Out.vleFluidPointer);

    kappa_out_rp2 = -cp_out_rp2/cv_out_rp2* (spVol_out_rp2/(fluid_inlet.p*Pi_rp2) * (-1/(isothComp_out_rp2*spVol_out_rp2)));
    kappa_aux_rp2 = (kappa_in_st[1] + kappa_out_rp2)/2.0;
    der(kappa_rp2) = 1/Tau_aux*(kappa_aux_rp2-kappa_rp2);
//kappa_rp2=1.4;
   Pi_rp2 = (1 + epsilon_rel_rp2 * rpm_corr_rel_rp2^2 * (Pi_nom^((kappa_rp2-1)/kappa_rp2)-1))^(kappa_rp2/(kappa_rp2-1));
   eta_isen_od_rpm = (Pi_rp2^((kappa_rp2-1)/kappa_rp2)-1) / (tau_rp2 - 1); //oder auch eta_isen_rel_od_rpm=epsilon_rel_rp2/psi_rel_rp2;
   eta_isen_rel_od_rpm = eta_isen_od_rpm/eta_isen_stage_nom;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  else ////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE/////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      cp_in_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer);
      cv_in_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer);
      isothComp_in_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer);
      spVol_in_st[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer);

    //  h_out_st[1] = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_pTxi(p_out_st[1],T_out_st[1],inStream(fluid_inlet.Xi_outflow),VLEFluidPointer);
      cp_out_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_out_st[1],
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer);
      cv_out_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_out_st[1],
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer);
      isothComp_out_st[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      p_out_st[1],
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer);
      spVol_out_st[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      p_out_st[1],
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer);

    kappa_in_st[1]=  -cp_in_st[1]/cv_in_st[1]* (spVol_in_st[1]/fluid_inlet.p * (-1/(isothComp_in_st[1]*spVol_in_st[1])));
    kappa_out_st[1]=  -cp_out_st[1]/cv_out_st[1]* (spVol_out_st[1]/p_out_st[1] * (-1/(isothComp_out_st[1]*spVol_out_st[1])));
    kappa_aux_st[1] = (kappa_in_st[1] + kappa_out_st[1]) / 2;
    der(kappa_st[1]) = 1/Tau_aux*(kappa_aux_st[1]-kappa_st[1]);
//kappa_st[1]=1.4;
    //_____________/Corrected RPM\_______________________________________________________
    rpm_corr_nom_st[1] = (rpm_nom/60)/T_in_nom^0.5;
    rpm_corr_st[1] = (rpm/60)/T_in^0.5;
    rpm_corr_rel_st[1] = rpm_corr_st[1]/rpm_corr_nom_st[1];

    //_____________/Corrected mass flow\_________________________________________________
    m_flow_corr_nom_st[1] = m_flow_nom * T_in_nom^0.5 / p_in_nom * (1 + vigv_coeff_phi_a*Delta_alpha_int[1]^2 + vigv_coeff_phi_b*Delta_alpha_int[1]); //eq. 33 (multiplied with additional inlet guide vane function);
    m_flow_corr_st[1] = m_flow_aux * T_in^0.5 / fluid_inlet.p;
    m_flow_corr_rel_st[1] = m_flow_corr_st[1]/(m_flow_corr_nom_st[1]);

    //_____________/Stage performance characteristic\____________________________________
    phi_rel_st[1] = m_flow_corr_rel_st[1]/rpm_corr_rel_st[1]; //eq. 34

    //_____________/Additional values for stage enthalpy characteristic\_________________
    if useFixedEnthalpyCharacteristic == false then
      psi_nom_st[1] = Delta_h_nom_st[1]/(Modelica.Constants.pi^2 * diameter[1]^2 * (rpm_nom/60)^2/2) * (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);//eq. 19 (multiplied with additional inlet guide vane function)
    else
      psi_nom_st[1] = psi_nom_fixed[1] * (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);
    end if;

    C_1_st[1] = 2/psi_nom_st[1];
    C_2_st[1] = 1 - C_1_st[1];

    //_____________/Stage enthalpy characteristic\_______________________________________
    psi_rel_st[1] = C_1_st[1] + C_2_st[1] * phi_rel_st[1]; //eq. 15

    //_____________/Stage pressure characteristic\________________________________________________
    epsilon_rel_st[1] = (1 + C_1_st[1] - C_1_st[1] * phi_rel_st[1]) * phi_rel_st[1]; //eq. 39

    //_____________/Reference point adjustion for VIGV\________________________________________________
    psi_rel_st_vigv[1] = (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);
    epsilon_rel_st_vigv[1] =(-C_1_st[1]*(psi_rel_st_vigv[1]^2+1) + (C_1_st[1]^2+1)* psi_rel_st_vigv[1])/C_2_st[1]^2;

    cp_out_nom_st_vigv[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].vleFluidPointer);
    cv_out_nom_st_vigv[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].vleFluidPointer);
    isothComp_out_nom_st_vigv[1] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].vleFluidPointer);
    spVol_out_nom_st_vigv[1] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].vleFluidPointer);
    kappa_out_nom_st_vigv[1]= -cp_out_nom_st_vigv[1]/cv_out_nom_st_vigv[1]* (spVol_out_nom_st_vigv[1]/(p_in_nom*Pi_nom_st_vigv[1]) * (-1/(isothComp_out_nom_st_vigv[1]*spVol_out_nom_st_vigv[1])));
    kappa_nom_aux_st_vigv[1] = (kappa_in_nom_st[1] + kappa_out_nom_st_vigv[1]) / 2;
    der(kappa_nom_st_vigv[1]) = 1/Tau_aux*(kappa_nom_aux_st_vigv[1]-kappa_nom_st_vigv[1]);

    tau_nom_st_vigv[1] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1) * 1/(eta_isen_nom_st[1] *min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1)) else tau_nom_st[1];
    Pi_nom_st_vigv[1] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[1] * (Pi_nom_st[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1))^(kappa_nom_st_vigv[1]/(kappa_nom_st_vigv[1]-1)) else Pi_nom_st[1];

    //_____________/Stage temperature ratio\_____________________________________________
    tau_st[1] = 1 + psi_rel_st[1] * rpm_corr_rel_st[1]^2 * (tau_nom_st_vigv[1]-1); //
    T_out_st[1] = tau_st[1] * VLEFluid_inlet.T; //eq. 18

    //_____________/Stage pressure ratio\________________________________________________
    epsilon_rel_st[1] = 1/rpm_corr_rel_st[1]^2 * ((Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1)/(Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1)); //eq. 31
    p_out_st[1] = fluid_inlet.p * Pi_st[1];

    //_____________/Isentropic stage efficiency\_________________________________________
    eta_isen_st[1] = (Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1) / (tau_st[1] - 1); //eq. 23
    eta_isen_rel_st[1] = eta_isen_st[1]/(eta_isen_nom_st[1]*min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1));

    Pi_prod_st[1] = Pi_st[1];
    //Y_st[1]= (p_out_st[1] - fluid_inlet.p)/ TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi((p_out_st[1]+fluid_inlet.p)/2,(inStream(fluid_inlet.h_outflow)+T_out_st[1])/2,inStream(fluid_inlet.Xi_outflow),VLEFluidPointer);
    Y_st[1]=(p_out_st[1] - fluid_inlet.p)/(0.5*(TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
      fluid_inlet.p,
      T_in,
      inStream(fluid_inlet.xi_outflow),
      Inlet.vleFluidPointer) + TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
      p_out_st[1],
      T_out_st[1],
      inStream(fluid_inlet.xi_outflow),
      Outlet[1].vleFluidPointer)));

    //____________/Surge line\____________________________________________________________
    if psi_nom_st[i] <= 0.9 then
      phi_surge_rel_st[1] = 1/3 +  (2 + psi_nom_st[1])/6; //eq. 66 and 40 (axial machine)
    else
      phi_surge_rel_st[1] = 2/7 + 5/7 * (2 + psi_nom_st[1])/4; //eq. from goettlich and 40 (radial machine)
    end if;

    //___________/Dummies (only needed as corr. of eta_isen during calulation of a single stage)\___________
    eta_isen_od_rpm=0;
    eta_isen_rel_od_rpm=0;
    kappa_out_nom_rp2=0;
    kappa_aux_nom_rp2=0;
    kappa_nom_rp2=0;
    kappa_out_rp2=0;
    kappa_aux_rp2=0;
    kappa_rp2=0;
    T_out_rp2=0;
    tau_rp2=0;
    tau_nom_rp2=0;
    Pi_rp2=0;
    m_flow_corr_rel_rp2=0;
    rpm_corr_rel_rp2=0;
    phi_rel_rp2=0;
    psi_rel_rp2=0;
    psi_nom_rp2=0;
    epsilon_rel_rp2=0;
    m_flow_corr_rp2=0;
    Delta_h_nom_rp2=0;

     isothComp_out_nom_rp2=0;
     spVol_out_nom_rp2=0;
     isothComp_out_rp2=0;
     spVol_out_rp2=0;
     cp_out_nom_rp2=0;
     cp_out_rp2=0;
     cv_out_nom_rp2=0;
     cv_out_rp2=0;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 for i in 2:N_stages loop ////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP///////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      cp_in_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_st[i - 1],
        T_out_st[i - 1],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i - 1].vleFluidPointer);
      cv_in_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_st[i - 1],
        T_out_st[i - 1],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i - 1].vleFluidPointer);
      isothComp_in_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
        p_out_st[i - 1],
        T_out_st[i - 1],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i - 1].vleFluidPointer);
      spVol_in_st[i] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
        p_out_st[i - 1],
        T_out_st[i - 1],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i - 1].vleFluidPointer);

    //  h_out_st[i] = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_pTxi(p_out_st[i],T_out_st[i],inStream(fluid_inlet.Xi_outflow),VLEFluidPointer);
      cp_out_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_st[i],
        T_out_st[i],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i].vleFluidPointer);
      cv_out_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_st[i],
        T_out_st[i],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i].vleFluidPointer);
      isothComp_out_st[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
        p_out_st[i],
        T_out_st[i],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i].vleFluidPointer);
      spVol_out_st[i] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
        p_out_st[i],
        T_out_st[i],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i].vleFluidPointer);

    kappa_in_st[i]=  -cp_in_st[i]/cv_in_st[i]* (spVol_in_st[i]/p_out_st[i-1] * (-1/(isothComp_in_st[i]*spVol_in_st[i])));
    kappa_out_st[i]=  -cp_out_st[i]/cv_out_st[i]* (spVol_out_st[i]/p_out_st[i] * (-1/(isothComp_out_st[i]*spVol_out_st[i])));
    kappa_aux_st[i] = (kappa_in_st[i] + kappa_out_st[i]) / 2;
    der(kappa_st[i]) = 1/Tau_aux*(kappa_aux_st[i]-kappa_st[i]);
//kappa_st[i]=1.4;
     //_____________/Corrected RPM\_______________________________________________________
     rpm_corr_nom_st[i] = (rpm_nom/60)/T_out_nom_st[i-1]^0.5;
     rpm_corr_st[i] = (rpm/60)/T_out_st[i-1]^0.5;
     rpm_corr_rel_st[i] = rpm_corr_st[i]/(rpm_corr_nom_st[i]);

     //_____________/Corrected mass flow\_________________________________________________
     m_flow_corr_nom_st[i] = m_flow_nom * T_out_nom_st[i-1]^0.5 / p_out_nom_st[i-1] * (1 + vigv_coeff_phi_a*Delta_alpha_int[i]^2 + vigv_coeff_phi_b*Delta_alpha_int[i]);
     m_flow_corr_st[i] = m_flow_aux * T_out_st[i-1]^0.5 / p_out_st[i-1];
     m_flow_corr_rel_st[i] = m_flow_corr_st[i]/(m_flow_corr_nom_st[i]);

     //_____________/Stage performance characteristic\____________________________________
     phi_rel_st[i] = m_flow_corr_rel_st[i]/rpm_corr_rel_st[i]; //eq. 34

     //_____________/Additional values for stage enthalpy characteristic\_________________
     if useFixedEnthalpyCharacteristic == false then
       psi_nom_st[i] = Delta_h_nom_st[i]/(Modelica.Constants.pi^2 * diameter[i]^2 * (rpm_nom/60)^2/2) * (1 + vigv_coeff_psi_a*Delta_alpha_int[i]^2 + vigv_coeff_psi_b*Delta_alpha_int[i]);//eq. 19
     else
       psi_nom_st[i] = psi_nom_fixed[i] * (1 + vigv_coeff_psi_a*Delta_alpha_int[i]^2 + vigv_coeff_psi_b*Delta_alpha_int[i]);
     end if;

     C_1_st[i] = 2/psi_nom_st[i];
     C_2_st[i] = 1 - C_1_st[i];

     //_____________/Stage enthalpy characteristic\_______________________________________
     psi_rel_st[i] = C_1_st[i] + C_2_st[i] * phi_rel_st[i]; //eq. 15

     //_____________/Stage pressure characteristic\_______________________________________
     epsilon_rel_st[i] = (1 + C_1_st[i] - C_1_st[i] * phi_rel_st[i]) * phi_rel_st[i]; //eq. 39

     //_____________/Reference point adjustion for VIGV\________________________________________________
     psi_rel_st_vigv[i] = (1 + vigv_coeff_psi_a*Delta_alpha_int[i]^2 + vigv_coeff_psi_b*Delta_alpha_int[i]);
     epsilon_rel_st_vigv[i] =(-C_1_st[i]*(psi_rel_st_vigv[i]^2+1) + (C_1_st[i]^2+1)* psi_rel_st_vigv[i])/C_2_st[i]^2;

     cp_out_nom_st_vigv[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_st[i - 1]*Pi_nom_st_vigv[i],
        T_out_nom_st[i - 1]*tau_nom_st_vigv[i],
        xi_nom,
        OutletVigv[i].vleFluidPointer);
     cv_out_nom_st_vigv[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_st[i - 1]*Pi_nom_st_vigv[i],
        T_out_nom_st[i - 1]*tau_nom_st_vigv[i],
        xi_nom,
        OutletVigv[i].vleFluidPointer);
     isothComp_out_nom_st_vigv[i] =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.isothermalCompressibility_pTxi(
        p_out_st[i - 1]*Pi_nom_st_vigv[i],
        T_out_nom_st[i - 1]*tau_nom_st_vigv[i],
        xi_nom,
        OutletVigv[i].vleFluidPointer);
     spVol_out_nom_st_vigv[i] =1/TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
        p_out_st[i - 1]*Pi_nom_st_vigv[i],
        T_out_nom_st[i - 1]*tau_nom_st_vigv[i],
        xi_nom,
        OutletVigv[i].vleFluidPointer);
     kappa_out_nom_st_vigv[i]= -cp_out_nom_st_vigv[i]/cv_out_nom_st_vigv[i]* (spVol_out_nom_st_vigv[i]/(p_out_st[i-1]*Pi_nom_st_vigv[i]) * (-1/(isothComp_out_nom_st_vigv[i]*spVol_out_nom_st_vigv[i])));
     kappa_nom_aux_st_vigv[i] = (kappa_in_nom_st[i] + kappa_out_nom_st_vigv[i]) / 2;
     der(kappa_nom_st_vigv[i]) = 1/Tau_aux*(kappa_nom_aux_st_vigv[i]-kappa_nom_st_vigv[i]);

     tau_nom_st_vigv[i] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[i]^((kappa_nom_st_vigv[i]-1)/kappa_nom_st_vigv[i])-1) * 1/(eta_isen_nom_st[i] *min(1 + vigv_coeff_eta_a*Delta_alpha_int[i]^3 + vigv_coeff_eta_b*Delta_alpha_int[i]^2 + vigv_coeff_eta_c*Delta_alpha_int[i],1)) else tau_nom_st[i];
     Pi_nom_st_vigv[i] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[i] * (Pi_nom_st[i]^((kappa_nom_st[i]-1)/kappa_nom_st[i])-1))^(kappa_nom_st_vigv[i]/(kappa_nom_st_vigv[i]-1)) else Pi_nom_st[i];

     //_____________/Stage temperature ratio\_____________________________________________
     tau_st[i] = 1 + psi_rel_st[i] * rpm_corr_rel_st[i]^2 * (tau_nom_st_vigv[i]-1); //eq. 22
     T_out_st[i] = tau_st[i] * T_out_st[i-1]; //eq. 18

     //_____________/Stage pressure ratio\________________________________________________
     epsilon_rel_st[i] = 1/rpm_corr_rel_st[i]^2 * ((Pi_st[i]^((kappa_st[i]-1)/kappa_st[i])-1)/(Pi_nom_st_vigv[i]^((kappa_nom_st_vigv[i]-1)/kappa_nom_st_vigv[i])-1)); //eq. 31
     p_out_st[i] = p_out_st[i-1] * Pi_st[i];

     //_____________/Isentropic stage efficiency\_________________________________________
     eta_isen_st[i] = (Pi_st[i]^((kappa_st[i]-1)/kappa_st[i])-1) / (tau_st[i] - 1);//eq. 23
     eta_isen_rel_st[i] = eta_isen_st[i]/(eta_isen_nom_st[i]*min(1 + vigv_coeff_eta_a*Delta_alpha_int[i]^3 + vigv_coeff_eta_b*Delta_alpha_int[i]^2 + vigv_coeff_eta_c*Delta_alpha_int[i],1));  //Nicht wirklich benoetigt

     Pi_prod_st[i] = product(Pi_st[j] for j in 1:i); //Overall pressure ratio until actual stage
     //Y_st[i]= (p_out_st[i] - p_out_st[i-1])/TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_pTxi((p_out_st[i]+p_out_st[i-1])/2,(T_out_st[i]+T_out_st[i-1])/2,inStream(fluid_inlet.Xi_outflow),VLEFluidPointer);
     Y_st[i]=(p_out_st[i] - p_out_st[i - 1])/(0.5*(TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
        p_out_st[i - 1],
        T_out_st[i - 1],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i - 1].vleFluidPointer) + TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_pTxi(
        p_out_st[i],
        T_out_st[i],
        inStream(fluid_inlet.xi_outflow),
        Outlet[i].vleFluidPointer)));

     //____________/Surge line\____________________________________________________________
     if psi_nom_st[i] <= 0.9 then
       phi_surge_rel_st[i] = 1/3 +  (2 + psi_nom_st[i])/6; //eq. 66 and 40 (axial machine)
     else
       phi_surge_rel_st[i] = 2/7 + 5/7 * (2 + psi_nom_st[i])/4; //eq. from goettlich and 40 (radial machine)
     end if;

 end for;

    Pi = product(Pi_st);
    tau = product(tau_st);

    kappa_aux = (kappa_in_st[1] + kappa_out_st[N_stages])/2.0;
    der(kappa) = 1/Tau_aux*(kappa_aux-kappa);
    //kappa = 1.4;
    eta_isen = (Pi^((kappa-1)/kappa)-1) / (tau - 1);

    Pi = fluid_outlet.p/fluid_inlet.p;
    tau = VLEFluid_outlet.T/VLEFluid_inlet.T;

 end if;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END////END/////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////Original functions for VIGV correction from [Goettlich1984]:
////eta_rel = (1 - 0.000111 * Delta_alpha_int[i]^2);
////psi_rel = (1 + 0.014 * Delta_alpha_int[i]);
////phi_rel = psi_rel = (1 + 0.014 * Delta_alpha_int[i]);
////These functions are not in use but newer spline fittings (same source new splines)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////SURGE AND CHOKE LINE////SURGE AND CHOKE LINE////SURGE AND CHOKE LINE////SURGE AND CHOKE LINE////SURGE AND CHOKE LINE////SURGE AND CHOKE LINE//////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  for i in 1:N_stages loop
    if phi_rel_st[i] <= phi_surge_rel_st[i] then
      count_surge[i]=1;
    else
      count_surge[i]=0;
    end if;
   if m_flow_corr_rel_st[i] >= 1.5 and time >0 then
      count_choke[i]=1;
    else
      count_choke[i]=0;
    end if;
  end for;

  if (useBoundaryAssert) then
     assert(sum(count_surge)<=4,
            "************StackedCompressorStages: Surge line exceeded in four or more stages************");
     assert(phi_rel_st[N_stages] > phi_surge_rel_st[N_stages],
            "************StackedCompressorStages: Surge line exceeded in last stage************");
     assert(sum(count_choke)<1,
             "************StackedCompressorStages: Choke line exceeded************");
  end if;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //___________________________________________________
 //Verhalten einer einzelnen Stufe wird noch nicht
 //korrekt berechnet und muss noch korrigiert werden!!
 //___________________________________________________
  P_hyd = (VLEFluid_outlet.h - VLEFluid_inlet.h) * fluid_inlet.m_flow;
  P_shaft = P_hyd*1/eta_mech;
  V_flow = fluid_inlet.m_flow / VLEFluid_inlet.d;
  der(fluid_inlet.m_flow) = 1/0.01*(m_flow_aux-fluid_inlet.m_flow);
  Y=sum(Y_st);
  fluid_inlet.m_flow + fluid_outlet.m_flow = 0.0;
  fluid_outlet.xi_outflow = inStream(fluid_inlet.xi_outflow);
  fluid_inlet.xi_outflow = inStream(fluid_outlet.xi_outflow);
  fluid_outlet.h_outflow = VLEFluid_outlet.h;
  fluid_inlet.h_outflow = VLEFluid_inlet.h;

  //______________Eye port variable definition________________________
  eye_int[1].m_flow = -fluid_outlet.m_flow;
  eye_int[1].T = VLEFluid_outlet.T-273.15;
  eye_int[1].s = VLEFluid_outlet.s/1e3;
  eye_int[1].p = VLEFluid_outlet.p/1e5;
  eye_int[1].h = VLEFluid_outlet.h/1e3;

  connect(eye_int[1],eyeOut)  annotation (Line(
      points={{40,-60},{92,-60}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(getInputsRotary.rotatoryFlange, shaft)
    annotation (Line(points={{0,30},{0,100}},         color={0,0,0}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(graphics),
    Documentation(info="<html>
<p><b>Model description: </b>A multi stage compressor model based on the stage stacking method of Gasparovic able to calculate off-design behaviour according to nominal values</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Stationary mass and energy balances are used</li>
<li>Modeled according to the stage stacking method of Gasparovic</li>
<li>Supports multi stage VIGV&apos;s</li>
<li>Calculation of surge and choke margins (assert triggers when crossed)</li>
</ul></p>
<p><br/><b>NOTE: </b> If the design point is not known please determine all needed values with simplier compressor models to ensure the model to run.</p>
</html>
<html>
</ul></p>
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
end CompressorVLE_L1_stageStacked;
