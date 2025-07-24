within ClaRa.Components.TurboMachines.Compressors;
model CompressorGas_L1_stageStacked "Advanced compressor or fan for ideal gas mixtures using the stage stacking method according to N. Gasparovic"
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
    ClaRa.Basics.Records.FlangeGas  inlet;
    ClaRa.Basics.Records.FlangeGas  outlet;
  end Summary;

  import SI = ClaRa.Basics.Units;

  inner parameter TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel;

  final parameter Boolean allow_reverseFlow = false;

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium, m_flow(final start=
          m_flow_nom, min=if allow_reverseFlow then -Modelica.Constants.inf
           else 1e-5)) "inlet flow"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium, m_flow(max=if
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
  TILMedia.Gas.Gas_pT flueGas_inlet(
    p=inlet.p,
    T=inStream(inlet.T_outflow),
    xi=inStream(inlet.xi_outflow),
    gasType=medium) annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));

  TILMedia.Gas.Gas_pT flueGas_outlet(
    gasType=medium,
    T=T_out,
    p=outlet.p,
    xi=flueGas_inlet.xi) annotation (Placement(transformation(extent={{70,-12},{90,8}})));

  Modelica.Blocks.Interfaces.RealInput Delta_alpha_input=Delta_alpha if useExternalVIGVangle "VIGV angle input"
                       annotation (Placement(transformation(extent={{-128,60},{-88,100}})));

  //__________________________/ Parameters \_____________________________
  parameter Integer N_stages = 12 "Number of Compressor Stages";
  parameter Integer N_VIGVstages = 1 "Number of VIGV Stages";
  parameter ClaRa.Basics.Units.RPM rpm_nom=3000 "Nomial rotational speed" annotation(Dialog( group = "Nominal Values"));
  parameter Real eta_isen_stage_nom = 0.9 "Nominal isentropic stage efficiency (axial: ca. 0.9, radial: ca. 0.82)" annotation(Dialog( group = "Nominal Values"));
  parameter Boolean useExternalVIGVangle= false "True, if an external source should be used to set VIGV angle" annotation(Dialog( group = "Nominal Values"));
  parameter ClaRa.Basics.Units.Angle Delta_alpha_fixed=0 "Fixed angle of VIGV (variable inlet guide vanes)" annotation (Dialog(enable=not useExternalVIGVangle));
  parameter Real eta_mech = 0.99 "Mechanical efficiency";
  parameter Modelica.Units.SI.Inertia J "Moment of Inertia" annotation (Dialog(group="Fundamental Definitions", enable=not steadyStateTorque));
  parameter Boolean useMechanicalPort=false "True, if a mechenical flange should be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean steadyStateTorque=false "True, if steady state mechanical momentum shall be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean useBoundaryAssert=true "True, if simulation should stop when surge or choke boundary is hit"
                                                                           annotation(Dialog(tab = "Advanced"));
  parameter ClaRa.Basics.Units.RPM rpm_fixed=3000 "Constant rotational speed of pump" annotation (Dialog(group="Fundamental Definitions", enable=not useMechanicalPort));
  parameter ClaRa.Basics.Units.Time Tau_aux=0.1 "Time constant of auxilliary kappa states" annotation (Dialog(tab="Advanced"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=100 "Nominal mass flow" annotation(Dialog( group = "Nominal Values"));
  parameter Real Pi_nom = 7 "Nominal pressure ratio" annotation(Dialog( group = "Nominal Values"));
  parameter ClaRa.Basics.Units.Temperature T_in_nom=293.15 "Nominal inlet temperature" annotation(Dialog( group = "Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_in_nom=1.01325e5 "Nominal inlet pressure" annotation(Dialog( group = "Nominal Values"));
  parameter ClaRa.Basics.Units.MassFraction xi_nom[medium.nc - 1]={0,0,0,0,0.76,0.23,0,0,0} "Nominal gas composition" annotation(Dialog( group = "Nominal Values"));
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
  Real kappa "Overall heat capacity ratio";

  //SI.HeatCapacityMassSpecific cp_m;
  Real Delta_alpha "Angle of VIGV (variable inlet guide vanes)";
  Real Delta_alpha_int[i] "Angle of VIGV (variable inlet guide vanes) for internal calculation";
  Modelica.Units.SI.SpecificEnergy Y_st[i] "Specific delivery work of each stage";
  Modelica.Units.SI.SpecificEnergy Y "Specific delivery work";

  //______//Stage variables\\______________________________________________
  Real kappa_st[i] "Stage heat capacity ratio";
  Real kappa_in;
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
  Real epsilon_rel_st_max[i](each final start = 1) "Relative stage pressure characteristic";
  Real epsilon_rel_st_vigv[i](each final start = 1) "Relative stage pressure characteristic for VIGV";

  Real C_1_st[i] "Constant";
  Real C_2_st[i] "Constant";

  Real tau_st[i](each final start = 1.001) "Stage temperature ratio";
  Real Pi_st[i]( each final start = Pi_nom^(1/N_stages)) "Stage pressure ratio";
  Real Pi_st_max[i]( each final start = Pi_nom^(1/N_stages)) "Maximum stage pressure ratio at surge line";
  Real Pi_prod_st[i](  each final start = 1) "Overall pressure ratio until actual stage"; //not important, just for evaluation

  ClaRa.Basics.Units.Temperature T_out_st[i](each final start=T_in_nom) "Calculated outlet stage temperature";
  ClaRa.Basics.Units.Pressure p_out_st[i](each final start=1e5) "Calculated outlet stage pressure";

//Stufenvariablen nominal
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_in_nom "Nominal isobaric heat capacity at stage inlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cv_in_nom "Nominal isochoric heat capacity at stage inlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp_out_nom_st[i] "Nominal isobaric heat capacity at stage outlet";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cv_out_nom_st[i] "Nominal isochoric heat capacity at stage outlet";
  Real Pi_nom_st[i](each final start = Pi_nom^(1/N_stages)) "Nominal stage pressure ratio";
  Real Pi_nom_st_vigv[i](each final start = Pi_nom^(1/N_stages)) "Nominal stage pressure ratio for VIGV";
  Real Pi_prod_nom_st[i]( each final start = 1) "Overall nominal pressure ratio until actual stage";
                                                                            //(not important for design point calculation, just for evaluation)
  Real kappa_nom_st[i] "Nominal stage heat capacity ratio";
  Real kappa_nom_st_vigv[i] "Nominal stage heat capacity ratio for VIGV";
  ClaRa.Basics.Units.Temperature T_out_nom_st[i](each final start=T_in_nom) "Nominal stage outlet temperature";
  ClaRa.Basics.Units.Efficiency eta_isen_nom_st[i](each final start=eta_isen_stage_nom) "Nominal isentropic stage efficiency";
  Real tau_nom_st[i](each final start = 1.001) "Nominal stage temperature ratio";
  Real tau_nom_st_vigv[i](each final start = 1.001) "Nominal stage temperature ratio for VIGV";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_out_nom_st[i] "Nominal stage outlet enthalpy";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_in_nom_st "Nominal compressor inlet enthalpy";
  ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_nom_st[i] "Nominal stage enthalpy difference";
  ClaRa.Basics.Units.Pressure p_out_nom_st[i](each final start=1e5) "Nominal outlet stage pressure";

protected
 Real kappa_aux_st[i] "Auxiliary state for kappa (needed when composition changes)";
 Real kappa_aux "Auxiliary state for kappa over whole machine (needed when composition changes)";
 Real kappa_nom_aux_st[i] "Auxiliary state for kappa (needed when composition changes)";
 Real count_surge[i];
 Real count_choke[i];

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
 Real Delta_h_nom_rp2;
  ClaRa.Basics.Units.MassFlowRate m_flow_aux(start=m_flow_nom);

//Version 4 mit eta neu (passt sehr gut)
 final parameter Real vigv_coeff_eta_a = if VIGVInfluence=="Lower" then 7e-7 else if VIGVInfluence=="Higher" then 3e-6 else 2e-6;
 final parameter Real vigv_coeff_eta_b = if VIGVInfluence=="Lower" then -0.0003 else if VIGVInfluence=="Higher" then -0.0006 else -0.0004;
 final parameter Real vigv_coeff_eta_c = if VIGVInfluence=="Lower" then 0.0011 else if VIGVInfluence=="Higher" then 0.0014 else 0.0013;
 final parameter Real vigv_coeff_phi_a = if VIGVInfluence=="Lower" then -0.00004 else if VIGVInfluence=="Higher" then -0.0002 else -0.0001;
 final parameter Real vigv_coeff_phi_b = if VIGVInfluence=="Lower" then 0.0176 else if VIGVInfluence=="Higher" then 0.0294 else 0.0228;
 final parameter Real vigv_coeff_psi_a = if VIGVInfluence=="Lower" then -0.0001 else if VIGVInfluence=="Higher" then -0.0002 else -0.0001;
 final parameter Real vigv_coeff_psi_b = if VIGVInfluence=="Lower" then 0.0131 else if VIGVInfluence=="Higher" then 0.0218 else 0.0169;

 final parameter Integer i = N_stages;


public
  inner Summary summary(outline(
   V_flow = V_flow,
   P_hyd = P_hyd,
   Pi = Pi,
   Delta_p = outlet.p - inlet.p,
   rpm = rpm,
   Delta_alpha = Delta_alpha,
   eta_isen = eta_isen,
   eta_mech = eta_mech,
   Y = Y,
   m_flow_rel = m_flow_corr_rel_st[1],
   Pi_rel=Pi/Pi_nom),
    inlet(mediumModel=medium, m_flow = inlet.m_flow,
          T = inStream(inlet.T_outflow),
          p = inlet.p,
          h = flueGas_inlet.h,
          xi = inStream(inlet.xi_outflow),
          H_flow = inlet.m_flow* flueGas_inlet.h),
    outlet(mediumModel=medium, m_flow = -outlet.m_flow,
          T = outlet.T_outflow,
          p = outlet.p,
          h = flueGas_outlet.h,
          xi = outlet.xi_outflow,
          H_flow = -outlet.m_flow* flueGas_outlet.h)) annotation (Placement(transformation(extent={{-100,
            -114},{-80,-94}})));

public
  ClaRa.Basics.Interfaces.EyeOutGas
                           eyeOut(medium=medium) annotation (Placement(transformation(extent={{72,-78},
            {112,-42}}),          iconTransformation(extent={{92,-70},{112,-50}})));
protected
  ClaRa.Basics.Interfaces.EyeInGas
                          eye_int[1](each medium=medium) annotation (Placement(transformation(extent={{48,-68},
            {32,-52}}),           iconTransformation(extent={{90,-84},{84,-78}})));

protected
  TILMedia.Gas.Gas Rp2OutNom(gasType=medium);
  TILMedia.Gas.Gas Rp2Out(gasType=medium);
  TILMedia.Gas.Gas InletNom(gasType=medium);
  TILMedia.Gas.Gas OutletNom[i](each gasType=medium);
  TILMedia.Gas.Gas Inlet(gasType=medium);
  TILMedia.Gas.Gas Outlet[i](each gasType=medium);
  TILMedia.Gas.Gas OutletVigv[i](each gasType=medium);
initial equation

inlet.m_flow = m_flow_corr_st[1]*flueGas_inlet.p/ flueGas_inlet.T^0.5;

     if N_stages > 1 then
      for i in 1:N_stages loop
       kappa_st[i] =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        flueGas_inlet.p,
        flueGas_inlet.T,
        flueGas_inlet.xi,
        Inlet.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        flueGas_inlet.p,
        flueGas_inlet.T,
        flueGas_inlet.xi,
        Inlet.gasPointer);
       kappa_nom_st[i] =  kappa_st[i];
       kappa_nom_st_vigv[i] = kappa_st[i];
      end for;
       kappa =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      flueGas_inlet.p,
      flueGas_inlet.T,
      flueGas_inlet.xi,
      Inlet.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      flueGas_inlet.p,
      flueGas_inlet.T,
      flueGas_inlet.xi,
      Inlet.gasPointer);
     else
      for i in 1:N_stages loop
       kappa_st[i] =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        flueGas_inlet.p,
        flueGas_inlet.T,
        flueGas_inlet.xi,
        Inlet.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        flueGas_inlet.p,
        flueGas_inlet.T,
        flueGas_inlet.xi,
        Inlet.gasPointer);
       kappa_nom_st[i] =  kappa_st[i];
       kappa_rp2 =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        flueGas_inlet.p,
        flueGas_inlet.T,
        flueGas_inlet.xi,
        Inlet.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        flueGas_inlet.p,
        flueGas_inlet.T,
        flueGas_inlet.xi,
        Inlet.gasPointer);
       kappa_nom_rp2 = kappa_rp2;
       kappa_nom_st_vigv[i] = kappa_st[i];
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT////DESIGN POINT//////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if N_stages == 1 then  ////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY////FOR A SINGLE STAGE ONLY/////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    cp_in_nom =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer);
    cv_in_nom =TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer);
    cp_out_nom_st[1] =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].gasPointer);
    cv_out_nom_st[1] =TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].gasPointer);
    kappa_nom_aux_st[1] = (cp_in_nom/cv_in_nom + cp_out_nom_st[1]/cv_out_nom_st[1]) / 2;
    der(kappa_nom_st[1]) = 1/Tau_aux*(kappa_nom_aux_st[1]-kappa_nom_st[1]);
    //kappa_nom_st[1] =1.4;

    tau_nom_st[1] = 1 + (Pi_nom_st[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1) * 1/eta_isen_nom_st[1];
    T_out_nom_st[1] = tau_nom_st[1] * T_in_nom; //eq. 18
    p_out_nom_st[1] = p_in_nom * Pi_nom;
    h_in_nom_st =TILMedia.Gas.ObjectFunctions.specificEnthalpy_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer);
    h_out_nom_st[1] =TILMedia.Gas.ObjectFunctions.specificEnthalpy_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].gasPointer);
    Delta_h_nom_st[1] = h_out_nom_st[1] - h_in_nom_st;

    //_______/Alternative design point for efficiency on new rpm-curve\________________________________________
    //See also Goettlich for documentation of this corrected calculation for a single stage only

    eta_isen_nom_st[1] = eta_isen_stage_nom;

    Pi_prod_nom_st[1] = Pi_nom; //Overall pressure ratio until actual stage
    Pi_nom_st[1] = Pi_nom;

    tau_nom_st[1] = tau_nom;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
else   ////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE/////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   cp_in_nom =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer);
   cv_in_nom =TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer);
   cp_out_nom_st[1] =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].gasPointer);
   cv_out_nom_st[1] =TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].gasPointer);
   kappa_nom_aux_st[1] = (cp_in_nom/cv_in_nom + cp_out_nom_st[1]/cv_out_nom_st[1]) / 2;
   der(kappa_nom_st[1]) = 1/Tau_aux*(kappa_nom_aux_st[1]-kappa_nom_st[1]); //Auxiliary state for kappa (needed when composition changes)
   //kappa_nom_st[1] =1.4;

   tau_nom_st[1] = 1 + ((p_out_nom_st[1] / p_in_nom)^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1) * 1/eta_isen_nom_st[1];
   T_out_nom_st[1] = tau_nom_st[1] * T_in_nom; //eq. 18
   p_out_nom_st[1] = p_in_nom * Pi_nom_st[1];
   h_in_nom_st =TILMedia.Gas.ObjectFunctions.specificEnthalpy_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer);
   h_out_nom_st[1] =TILMedia.Gas.ObjectFunctions.specificEnthalpy_pTxi(
      p_out_nom_st[1],
      T_out_nom_st[1],
      xi_nom,
      OutletNom[1].gasPointer);
   Delta_h_nom_st[1] = h_out_nom_st[1] - h_in_nom_st;

   eta_isen_nom_st[1] = eta_isen_stage_nom;

   Pi_prod_nom_st[1] = Pi_nom_st[1]; //Overall pressure ratio until actual stage

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   for i in 2:N_stages loop  ////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

       cp_out_nom_st[i] =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_nom_st[i],
        T_out_nom_st[i],
        xi_nom,
        OutletNom[i].gasPointer);
       cv_out_nom_st[i] =TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_nom_st[i],
        T_out_nom_st[i],
        xi_nom,
        OutletNom[i].gasPointer);
       kappa_nom_aux_st[i] = (cp_out_nom_st[i-1]/cv_out_nom_st[i-1] + cp_out_nom_st[i]/cv_out_nom_st[i]) / 2;
       der(kappa_nom_st[i]) = 1/Tau_aux*(kappa_nom_aux_st[i]-kappa_nom_st[i]); //Auxiliary state for kappa (needed when composition changes)
       //kappa_nom_st[i] =1.4;

       tau_nom_st[i] = 1 + (Pi_nom_st[i]^((kappa_nom_st[i]-1)/kappa_nom_st[i])-1) * 1/eta_isen_nom_st[i]; //eq. 25
       T_out_nom_st[i] = tau_nom_st[i] * T_out_nom_st[i-1]; //eq. 18
       Pi_nom_st[i] = p_out_nom_st[i] / p_out_nom_st[i-1];
       h_out_nom_st[i] =TILMedia.Gas.ObjectFunctions.specificEnthalpy_pTxi(
        p_out_nom_st[i],
        T_out_nom_st[i],
        xi_nom,
        OutletNom[i].gasPointer);
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
      kappa_in =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      inlet.p,
      inStream(inlet.T_outflow),
      inStream(inlet.xi_outflow),
      Inlet.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      inlet.p,
      inStream(inlet.T_outflow),
      inStream(inlet.xi_outflow),
      Inlet.gasPointer);
      kappa_out_st[1] =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      outlet.p,
      outlet.T_outflow,
      inStream(inlet.xi_outflow),
      Outlet[1].gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      outlet.p,
      outlet.T_outflow,
      inStream(inlet.xi_outflow),
      Outlet[1].gasPointer);
      kappa_aux_st[1] = (kappa_in + kappa_out_st[1])/2.0;
      der(kappa_st[1]) = 1/Tau_aux*(kappa_aux_st[1]-kappa_st[1]);
      //kappa_st[1] =1.4;

      //_____________/Corrected RPM\_______________________________________________________
      rpm_corr_nom_st[1] = (rpm_nom/60)/T_in_nom^0.5;
      rpm_corr_st[1] = (rpm/60)/inStream(inlet.T_outflow)^0.5;
      rpm_corr_rel_st[1] = rpm_corr_st[1]/rpm_corr_nom_st[1];

      //_____________/Corrected mass flow\_________________________________________________
      m_flow_corr_nom_st[1] = m_flow_nom * T_in_nom^0.5 / p_in_nom * (1 + vigv_coeff_phi_a*Delta_alpha_int[1]^2 + vigv_coeff_phi_b*Delta_alpha_int[1]);//* (1 + 0.014 * Delta_alpha_int[1]); //eq. 33 (multiplied with additional inlet guide vane function)
      m_flow_corr_st[1] = m_flow_aux * inStream(inlet.T_outflow)^0.5 / inlet.p;
      m_flow_corr_rel_st[1] = m_flow_corr_st[1]/(m_flow_corr_nom_st[1]);

      //_____________/Stage performance characteristic\____________________________________
      phi_rel_st[1] = m_flow_corr_rel_st[1]/rpm_corr_rel_st[1]; //eq. 34 //1.0 wg behandlung als Bezugsdrehzahl

       //_____________/Additional values for stage enthalpy characteristic\_________________
       if useFixedEnthalpyCharacteristic == false then
         psi_nom_st[1] = Delta_h_nom_st[1]/(Modelica.Constants.pi^2 * diameter[1]^2 * (rpm_nom/60)^2/2) * (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);//(1 + 0.014 * Delta_alpha_int[1]);//eq. 19 (multiplied with additional inlet guide vane function)
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
      //psi_rel_st_vigv[1] = (C_1_st[1] + C_2_st[1]) * (1 + 0.014 * Delta_alpha_int[1]);
      psi_rel_st_vigv[1] = 1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]; // 1 + 0.014 * Delta_alpha_int[1];
      epsilon_rel_st_vigv[1] =(-C_1_st[1]*(psi_rel_st_vigv[1]^2+1) + (C_1_st[1]^2+1)* psi_rel_st_vigv[1])/C_2_st[1]^2;

      der(kappa_nom_st_vigv[1]) =1/Tau_aux*((TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer) + TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].gasPointer))/2 - kappa_nom_st_vigv[1]);

      // tau_nom_st_vigv[1] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1) * 1/(eta_isen_od_rpm *min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1)) else tau_nom_st[1]; //(1 - 0.000111 * Delta_alpha_int[1]^2)
      // Pi_nom_st_vigv[1] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[1] * (Pi_nom_st[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1))^(kappa_nom_st[1]/(kappa_nom_st[1]-1)) else Pi_nom_st[1];

       tau_nom_st_vigv[1] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1) * 1/(eta_isen_od_rpm *min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1)) else tau_nom_st[1]; //(1 - 0.000111 * Delta_alpha_int[1]^2)
       Pi_nom_st_vigv[1] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[1] * (Pi_nom_st[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1))^(kappa_nom_st_vigv[1]/(kappa_nom_st_vigv[1]-1)) else Pi_nom_st[1];

      //_____________/Stage temperature ratio\_____________________________________________
      tau_st[1] = 1 + psi_rel_st[1] * rpm_corr_rel_st[1]^2 * (tau_nom_st_vigv[1]-1);  //eq. 22
      //tau_st[1] = 1 + (Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1) * 1/eta_isen_st[1];
      T_out_st[1] = tau_st[1] * flueGas_inlet.T; //eq. 18

      //_____________/Stage pressure ratio\________________________________________________
      //Pi_st[1] = (1 + epsilon_rel_st[1] * rpm_corr_rel_st[1]^2 * (Pi_nom_st_vigv[1]^((kappa_st[1]-1)/kappa_st[1])-1))^(kappa_st[1]/(kappa_st[1]-1)); //eq. 31
      epsilon_rel_st[1] = 1/rpm_corr_rel_st[1]^2 * ((Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1)/(Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1)); //eq. 31
      Pi_st[1] = outlet.p/inlet.p;

      //_____________/Isentropic stage efficiency\_________________________________________
      eta_isen_st[1] = (Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1) / (tau_st[1] - 1); //eq. 23
      eta_isen_rel_st[1] = eta_isen_st[1]/(eta_isen_od_rpm * min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1));
      //eta_isen_st[1] = eta_isen_rel_st[1]*(eta_isen_od_rpm * min(1 - 0.0004*Delta_alpha_int[1]^2 + 0.0007*Delta_alpha_int[1],1));//(1 - 0.000111 * Delta_alpha_int[1]^2)
      //eta_isen_rel_st[1] = epsilon_rel_st[1]/psi_rel_st[1];

       p_out_st[1] = inlet.p * Pi_st[1];
       T_out = T_out_st[1];
       Pi = Pi_st[1];
       tau = tau_st[1];
       kappa = kappa_st[1];
       kappa_aux=kappa;
       eta_isen = eta_isen_st[1];
       Pi_prod_st[1] = Pi_st[1];

       Y_st[1]=(p_out_st[1] - inlet.p)/(0.5*(TILMedia.Gas.ObjectFunctions.density_pTxi(
      inlet.p,
      inStream(inlet.T_outflow),
      inStream(inlet.xi_outflow),
      Inlet.gasPointer) + TILMedia.Gas.ObjectFunctions.density_pTxi(
      outlet.p,
      outlet.T_outflow,
      inStream(inlet.xi_outflow),
      Outlet[1].gasPointer)));

   //____________/Surge line\____________________________________________________________
   if psi_nom_st[i] <= 0.9 then
     phi_surge_rel_st[1] = 1/3 +  (2 + psi_nom_st[1])/6; //eq. 66 and 40 (axial machine)
   else
     phi_surge_rel_st[1] = 2/7 + 5/7 * (2 + psi_nom_st[1])/4; //eq. from goettlich and 40 (radial machine)
   end if;

   epsilon_rel_st_max[1] = (1 + C_1_st[1] - C_1_st[1]*phi_surge_rel_st[1])*phi_surge_rel_st[1];
   Pi_st_max[1] = (1 + epsilon_rel_st_max[1]*rpm_corr_rel_st[1]^2*(Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1))^(kappa_st[1]/(kappa_st[1]-1));

   /////////////////////////////////////////////////////////////////////////////////////////////////////////
   //___________/Auxilliary reference point (rp2) for calculation of new reference efficiency at off design speed
   //This correction is only necessary if a single compressor stage is calculated.
   //For this correction a new reference point (rp2, on nominal speed line) is calculated for each off design speed line.
   //See also Goettlich for documentation of this corrected calculation for a single stage only.
   /////////////////////////////////////////////////////////////////////////////////////////////////////////

   rpm_corr_rel_rp2 = 1.0;
   m_flow_corr_rel_rp2 = rpm_corr_rel_st[1];

   m_flow_corr_rp2 = m_flow_corr_rel_rp2 * m_flow_nom * T_in_nom^0.5 / p_in_nom;// * (1 - 0.0005*Delta_alpha_int[1]^2 + 0.0231*Delta_alpha_int[1]);//(1 + 0.014 * Delta_alpha_int[1])

   phi_rel_rp2 = rpm_corr_rel_st[1]; // Goettlich eq. 6.12 (error in Goettlich betw. eq. 6.11 and 6.12: phi_rel_1 = 1.0)

   if useFixedEnthalpyCharacteristic == false then
     psi_nom_rp2 = Delta_h_nom_rp2/(Modelica.Constants.pi^2 * diameter[1]^2 * (rpm_nom/60)^2/2);// * (1 - 0.0003*Delta_alpha_int[1]^2 + 0.0176*Delta_alpha_int[1]);//(1 + 0.014 * Delta_alpha_int[1])
   else
     psi_nom_rp2 = psi_nom_fixed[1]; //* (1 - 0.0003*Delta_alpha_int[1]^2 + 0.0176*Delta_alpha_int[1]);//(1 + 0.014 * Delta_alpha_int[1])
   end if;

   epsilon_rel_rp2 = (1 + (2/psi_nom_rp2) - (2/psi_nom_rp2) * phi_rel_rp2) * phi_rel_rp2;
   psi_rel_rp2 = (2/psi_nom_rp2) + (1- 2/psi_nom_rp2) * phi_rel_rp2;

   //eta_isen_rel_od_rpm = epsilon_rel_rp2/psi_rel_rp2;
   //eta_isen_od_rpm = eta_isen_rel_od_rpm * eta_isen_stage_nom;

   tau_nom_rp2 = 1 + (Pi_nom^((kappa_nom_rp2-1)/kappa_nom_rp2)-1) * 1/eta_isen_stage_nom;//* min(1 - 0.0004*Delta_alpha_int[1]^2 + 0.0007*Delta_alpha_int[1],1));//*(1 - 0.000111 * Delta_alpha_int[1]^2)
   tau_rp2 = 1 + psi_rel_rp2 * rpm_corr_rel_rp2^2 * (tau_nom_rp2-1);
   T_out_rp2 = tau_rp2 * flueGas_inlet.T;
   Delta_h_nom_rp2 =TILMedia.Gas.ObjectFunctions.specificEnthalpy_pTxi(
      p_in_nom*Pi_nom,
      T_in_nom*tau_nom_rp2,
      xi_nom,
      Rp2OutNom.gasPointer) - h_in_nom_st;

   kappa_out_nom_rp2 =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom*Pi_nom,
      T_in_nom*tau_nom_rp2,
      xi_nom,
      Rp2OutNom.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom*Pi_nom,
      T_in_nom*tau_nom_rp2,
      xi_nom,
      Rp2OutNom.gasPointer);
   kappa_aux_nom_rp2 = (cp_in_nom/cv_in_nom + kappa_out_nom_rp2)/2.0;
   der(kappa_nom_rp2) = 1/Tau_aux*(kappa_aux_nom_rp2-kappa_nom_rp2);
   //kappa_nom_rp2 =1.4;

   kappa_out_rp2 =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      inlet.p*Pi_rp2,
      T_out_rp2,
      inStream(inlet.xi_outflow),
      Rp2Out.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      inlet.p*Pi_rp2,
      T_out_rp2,
      inStream(inlet.xi_outflow),
      Rp2Out.gasPointer);
   kappa_aux_rp2 = (kappa_in + kappa_out_rp2)/2.0;
   der(kappa_rp2) = 1/Tau_aux*(kappa_aux_rp2-kappa_rp2);
   //kappa_rp2 =1.4;

   Pi_rp2 = (1 + epsilon_rel_rp2 * rpm_corr_rel_rp2^2 * (Pi_nom^((kappa_rp2-1)/kappa_rp2)-1))^(kappa_rp2/(kappa_rp2-1));
   eta_isen_od_rpm = (Pi_rp2^((kappa_rp2-1)/kappa_rp2)-1) / (tau_rp2 - 1);
   eta_isen_rel_od_rpm = eta_isen_od_rpm/eta_isen_stage_nom;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  else ////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE////FIRST STAGE/////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    kappa_in =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      inlet.p,
      inStream(inlet.T_outflow),
      inStream(inlet.xi_outflow),
      Inlet.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      inlet.p,
      inStream(inlet.T_outflow),
      inStream(inlet.xi_outflow),
      Inlet.gasPointer);
    kappa_out_st[1] =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_out_st[1],
      T_out_st[1],
      inStream(inlet.xi_outflow),
      Outlet[1].gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_out_st[1],
      T_out_st[1],
      inStream(inlet.xi_outflow),
      Outlet[1].gasPointer);
    kappa_aux_st[1] = (kappa_in + kappa_out_st[1])/2.0;
    der(kappa_st[1]) = 1/Tau_aux*(kappa_aux_st[1]-kappa_st[1]);
    //kappa_st[1]=1.4;

    //_____________/Corrected RPM\_______________________________________________________
    rpm_corr_nom_st[1] = (rpm_nom/60)/T_in_nom^0.5;
    rpm_corr_st[1] = (rpm/60)/inStream(inlet.T_outflow)^0.5;
    rpm_corr_rel_st[1] = rpm_corr_st[1]/rpm_corr_nom_st[1];

    //_____________/Corrected mass flow\_________________________________________________

    m_flow_corr_nom_st[1] = m_flow_nom * T_in_nom^0.5 / p_in_nom * (1 + vigv_coeff_phi_a*Delta_alpha_int[1]^2 + vigv_coeff_phi_b*Delta_alpha_int[1]);//(1 + 0.014 * Delta_alpha_int[1]); //eq. 33 (multiplied with additional inlet guide vane function);
    m_flow_corr_st[1] = m_flow_aux * inStream(inlet.T_outflow)^0.5 / inlet.p;
    m_flow_corr_rel_st[1] = m_flow_corr_st[1]/(m_flow_corr_nom_st[1]);

    //_____________/Stage performance characteristic\____________________________________
    phi_rel_st[1] = (m_flow_corr_rel_st[1]/rpm_corr_rel_st[1]); //eq. 34

    //_____________/Additional values for stage enthalpy characteristic\_________________
    if useFixedEnthalpyCharacteristic == false then
        psi_nom_st[1] = Delta_h_nom_st[1]/(Modelica.Constants.pi^2 * diameter[1]^2 * (rpm_nom/60)^2/2) * (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);//(1 + 0.014 * Delta_alpha_int[1]);//eq. 19 (multiplied with additional inlet guide vane function)
    else
        psi_nom_st[1] = psi_nom_fixed[1] * (1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1]);//(1 + 0.014 * Delta_alpha_int[1]);
    end if;

    C_1_st[1] = 2/psi_nom_st[1];
    C_2_st[1] = 1 - C_1_st[1];

    //_____________/Stage enthalpy characteristic\_______________________________________
    psi_rel_st[1] = (C_1_st[1] + C_2_st[1] * phi_rel_st[1]);//* (1 + 0.014 * Delta_alpha_int[1]); //eq. 15

    //_____________/Stage pressure characteristic\________________________________________________
    epsilon_rel_st[1] = (1 + C_1_st[1] - C_1_st[1] * phi_rel_st[1]) * phi_rel_st[1]; //eq. 39

    //_____________/Reference point adjustion for VIGV\________________________________________________
    //psi_rel_st_vigv[1] = (C_1_st[1] + C_2_st[1]) * (1 + 0.014 * Delta_alpha_int[1]);
    psi_rel_st_vigv[1] = 1 + vigv_coeff_psi_a*Delta_alpha_int[1]^2 + vigv_coeff_psi_b*Delta_alpha_int[1];//1 + 0.014 * Delta_alpha_int[1];
    epsilon_rel_st_vigv[1] =(-C_1_st[1]*(psi_rel_st_vigv[1]^2+1) + (C_1_st[1]^2+1)* psi_rel_st_vigv[1])/C_2_st[1]^2;

    der(kappa_nom_st_vigv[1]) =1/Tau_aux*((TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom,
      T_in_nom,
      xi_nom,
      InletNom.gasPointer) + TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
      p_in_nom*Pi_nom_st_vigv[1],
      T_in_nom*tau_nom_st_vigv[1],
      xi_nom,
      OutletVigv[1].gasPointer))/2 - kappa_nom_st_vigv[1]);

    //tau_nom_st_vigv[1] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1) * 1/(eta_isen_nom_st[1] * min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1)) else tau_nom_st[1];
    //Pi_nom_st_vigv[1] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[1] * (Pi_nom_st[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1))^(kappa_nom_st[1]/(kappa_nom_st[1]-1)) else Pi_nom_st[1];

    tau_nom_st_vigv[1] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1) * 1/(eta_isen_nom_st[1] * min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1)) else tau_nom_st[1];
    Pi_nom_st_vigv[1] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[1] * (Pi_nom_st[1]^((kappa_nom_st[1]-1)/kappa_nom_st[1])-1))^(kappa_nom_st_vigv[1]/(kappa_nom_st_vigv[1]-1)) else Pi_nom_st[1];

    //_____________/Stage temperature ratio\_____________________________________________
    //psi_rel = 1/rpm_corr_rel^2*(tau-1)/(tau_nom-1); //eq. 22
    tau_st[1] = 1 + psi_rel_st[1] * rpm_corr_rel_st[1]^2 * (tau_nom_st_vigv[1]-1);
    //tau_st[1] = 1 + (Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1) * 1/eta_isen_st[1];
    T_out_st[1] = tau_st[1] * flueGas_inlet.T; //eq. 18

    //_____________/Stage pressure ratio\________________________________________________
    //Pi_st[1] = (1 + epsilon_rel_st[1] * rpm_corr_rel_st[1]^2 * (Pi_nom_st[1]^((kappa_st[1]-1)/kappa_st[1])-1))^(kappa_st[1]/(kappa_st[1]-1)); //eq. 31
    epsilon_rel_st[1] = 1/rpm_corr_rel_st[1]^2 * ((Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1)/(Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1)); //eq. 31
    p_out_st[1] = inlet.p * Pi_st[1];

    //_____________/Isentropic stage efficiency\_________________________________________
    eta_isen_st[1] =(Pi_st[1]^((kappa_st[1]-1)/kappa_st[1])-1) / (tau_st[1] - 1); //eq. 23
    eta_isen_rel_st[1] = eta_isen_st[1]/(eta_isen_nom_st[1]*min(1 + vigv_coeff_eta_a*Delta_alpha_int[1]^3 + vigv_coeff_eta_b*Delta_alpha_int[1]^2 + vigv_coeff_eta_c*Delta_alpha_int[1],1));
    //eta_isen_st[1] = eta_isen_rel_st[1]*(eta_isen_nom_st[1]*min(1 - 0.0004*Delta_alpha_int[1]^2 + 0.0007*Delta_alpha_int[1],1));
    //eta_isen_rel_st[1] = epsilon_rel_st[1]/psi_rel_st[1];

    Pi_prod_st[1] = Pi_st[1];

    Y_st[1]=(p_out_st[1] - inlet.p)/(0.5*(TILMedia.Gas.ObjectFunctions.density_pTxi(
      inlet.p,
      inStream(inlet.T_outflow),
      inStream(inlet.xi_outflow),
      Inlet.gasPointer) + TILMedia.Gas.ObjectFunctions.density_pTxi(
      p_out_st[1],
      T_out_st[1],
      inStream(inlet.xi_outflow),
      Outlet[1].gasPointer)));

    //____________/Surge line\____________________________________________________________
    if psi_nom_st[i] <= 0.9 then
      phi_surge_rel_st[1] = 1/3 +  (2 + psi_nom_st[1])/6; //eq. 66 and 40 (axial machine)
    else
      phi_surge_rel_st[1] = 2/7 + 5/7 * (2 + psi_nom_st[1])/4; //eq. from goettlich and 40 (radial machine)
    end if;

   epsilon_rel_st_max[1] = (1 + C_1_st[1] - C_1_st[1]*phi_surge_rel_st[1])*phi_surge_rel_st[1];
   Pi_st_max[1] = (1 + epsilon_rel_st_max[1]*rpm_corr_rel_st[1]^2*(Pi_nom_st_vigv[1]^((kappa_nom_st_vigv[1]-1)/kappa_nom_st_vigv[1])-1))^(kappa_st[1]/(kappa_st[1]-1));

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 for i in 2:N_stages loop ////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP////STAGE LOOP///////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     kappa_out_st[i] =TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_st[i],
        T_out_st[i],
        inStream(inlet.xi_outflow),
        Outlet[i].gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_st[i],
        T_out_st[i],
        inStream(inlet.xi_outflow),
        Outlet[i].gasPointer);
     kappa_aux_st[i] = (kappa_out_st[i-1] + kappa_out_st[i])/2.0;
     der(kappa_st[i]) = 1/Tau_aux*(kappa_aux_st[i]-kappa_st[i]);
     //kappa_st[i]=1.4;

     //_____________/Corrected RPM\_______________________________________________________
     rpm_corr_nom_st[i] = (rpm_nom/60)/T_out_nom_st[i-1]^0.5;
     rpm_corr_st[i] = (rpm/60)/T_out_st[i-1]^0.5;
     rpm_corr_rel_st[i] = rpm_corr_st[i]/(rpm_corr_nom_st[i]);

     //_____________/Corrected mass flow\_________________________________________________
     m_flow_corr_nom_st[i] = m_flow_nom * T_out_nom_st[i-1]^0.5 / p_out_nom_st[i-1] * (1 + vigv_coeff_phi_a*Delta_alpha_int[i]^2 + vigv_coeff_phi_b*Delta_alpha_int[i]);//(1 + 0.014 * Delta_alpha_int[i]);
     m_flow_corr_st[i] = m_flow_aux * T_out_st[i-1]^0.5 / p_out_st[i-1];
     m_flow_corr_rel_st[i] = m_flow_corr_st[i]/(m_flow_corr_nom_st[i]);

     //_____________/Stage performance characteristic\____________________________________
     phi_rel_st[i] = m_flow_corr_rel_st[i]/rpm_corr_rel_st[i]; //eq. 34

     //_____________/Additional values for stage enthalpy characteristic\_________________
     if useFixedEnthalpyCharacteristic == false then
       psi_nom_st[i] = Delta_h_nom_st[i]/(Modelica.Constants.pi^2 * diameter[i]^2 * (rpm_nom/60)^2/2) * (1 + vigv_coeff_psi_a*Delta_alpha_int[i]^2 + vigv_coeff_psi_b*Delta_alpha_int[i]);//(1 + 0.014 * Delta_alpha_int[i]);//eq. 19
     else
       psi_nom_st[i] = psi_nom_fixed[i] * (1 + vigv_coeff_psi_a*Delta_alpha_int[i]^2 + vigv_coeff_psi_b*Delta_alpha_int[i]);//(1 + 0.014 * Delta_alpha_int[i]);
     end if;

     C_1_st[i] = 2/psi_nom_st[i];
     C_2_st[i] = 1 - C_1_st[i];

     //_____________/Stage enthalpy characteristic\_______________________________________
     psi_rel_st[i] = C_1_st[i] + C_2_st[i] * phi_rel_st[i]; //eq. 15

     //_____________/Stage pressure characteristic\_______________________________________
     epsilon_rel_st[i] = (1 + C_1_st[i] - C_1_st[i] * phi_rel_st[i]) * phi_rel_st[i]; //eq. 39

    //_____________/Reference point adjustion for VIGV\________________________________________________
    psi_rel_st_vigv[i] = 1 + vigv_coeff_psi_a*Delta_alpha_int[i]^2 + vigv_coeff_psi_b*Delta_alpha_int[i];//1 + 0.014 * Delta_alpha_int[i];
    epsilon_rel_st_vigv[i] =(-C_1_st[i]*(psi_rel_st_vigv[i]^2+1) + (C_1_st[i]^2+1)* psi_rel_st_vigv[i])/C_2_st[i]^2;

    der(kappa_nom_st_vigv[i]) =1/Tau_aux*((TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_nom_st[i - 1],
        T_out_nom_st[i - 1],
        xi_nom,
        OutletNom[i - 1].gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_nom_st[i - 1],
        T_out_nom_st[i - 1],
        xi_nom,
        OutletNom[i - 1].gasPointer) + TILMedia.Gas.ObjectFunctions.specificIsobaricHeatCapacity_pTxi(
        p_out_nom_st[i - 1]*Pi_nom_st_vigv[i],
        T_out_nom_st[i - 1]*tau_nom_st_vigv[i],
        xi_nom,
        OutletVigv[i].gasPointer)/TILMedia.Gas.ObjectFunctions.specificIsochoricHeatCapacity_pTxi(
        p_out_nom_st[i - 1]*Pi_nom_st_vigv[i],
        T_out_nom_st[i - 1]*tau_nom_st_vigv[i],
        xi_nom,
        OutletVigv[i].gasPointer))/2 - kappa_nom_st_vigv[i]);

    //tau_nom_st_vigv[i] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[i]^((kappa_nom_st[i]-1)/kappa_nom_st[i])-1) * 1/(eta_isen_nom_st[i] *min(1 + vigv_coeff_eta_a*Delta_alpha_int[i]^3 + vigv_coeff_eta_b*Delta_alpha_int[i]^2 + vigv_coeff_eta_c*Delta_alpha_int[i],1)) else tau_nom_st[i];
    //Pi_nom_st_vigv[i] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[i] * (Pi_nom_st[i]^((kappa_nom_st[i]-1)/kappa_nom_st[i])-1))^(kappa_nom_st[i]/(kappa_nom_st[i]-1)) else Pi_nom_st[i];

     tau_nom_st_vigv[i] = if N_VIGVstages > 0 then 1 + (Pi_nom_st_vigv[i]^((kappa_nom_st_vigv[i]-1)/kappa_nom_st_vigv[i])-1) * 1/(eta_isen_nom_st[i] *min(1 + vigv_coeff_eta_a*Delta_alpha_int[i]^3 + vigv_coeff_eta_b*Delta_alpha_int[i]^2 + vigv_coeff_eta_c*Delta_alpha_int[i],1)) else tau_nom_st[i];
     Pi_nom_st_vigv[i] = if N_VIGVstages > 0 then (1 +  epsilon_rel_st_vigv[i] * (Pi_nom_st[i]^((kappa_nom_st[i]-1)/kappa_nom_st[i])-1))^(kappa_nom_st_vigv[i]/(kappa_nom_st_vigv[i]-1)) else Pi_nom_st[i];

     //_____________/Stage temperature ratio\_____________________________________________
     tau_st[i] = 1 + psi_rel_st[i] * rpm_corr_rel_st[i]^2 * (tau_nom_st_vigv[i]-1); //eq. 22
     //tau_st[i] = 1 + (Pi_st[i]^((kappa_st[i]-1)/kappa_st[i])-1) * 1/eta_isen_st[i];
     T_out_st[i] = tau_st[i] * T_out_st[i-1]; //eq. 18

     //_____________/Stage pressure ratio\________________________________________________
     //Pi_st[i] = (1 + epsilon_rel_st[i] * rpm_corr_rel_st[i]^2 * (Pi_nom_st_vigv[i]^((kappa_st[i]-1)/kappa_st[i])-1))^(kappa_st[i]/(kappa_st[i]-1)); //eq. 31
     epsilon_rel_st[i] = 1/rpm_corr_rel_st[i]^2 * ((Pi_st[i]^((kappa_st[i]-1)/kappa_st[i])-1)/(Pi_nom_st_vigv[i]^((kappa_nom_st_vigv[i]-1)/kappa_nom_st_vigv[i])-1)); //eq. 31
     p_out_st[i] = p_out_st[i-1] * Pi_st[i];

     //_____________/Isentropic stage efficiency\_________________________________________
     eta_isen_st[i] = (Pi_st[i]^((kappa_st[i]-1)/kappa_st[i])-1) / (tau_st[i] - 1);//eq. 23
     eta_isen_rel_st[i] = eta_isen_st[i]/(eta_isen_nom_st[i]*min(1 + vigv_coeff_eta_a*Delta_alpha_int[i]^3 + vigv_coeff_eta_b*Delta_alpha_int[i]^2 + vigv_coeff_eta_c*Delta_alpha_int[i],1));  //Nicht wirklich benoetigt
     //eta_isen_st[i] = eta_isen_rel_st[i]*(eta_isen_nom_st[i]*min(1 - 0.0004*Delta_alpha_int[i]^2 + 0.0007*Delta_alpha_int[i],1));
     //eta_isen_rel_st[i] = epsilon_rel_st[i]/psi_rel_st[i];

     Pi_prod_st[i] = product(Pi_st[j] for j in 1:i); //Overall pressure ratio until actual stage

     //____________/Surge line\____________________________________________________________
     if psi_nom_st[i] <= 0.9 then
       phi_surge_rel_st[i] = 1/3 +  (2 + psi_nom_st[i])/6; //eq. 66 and 40 (axial machine)
     else
       phi_surge_rel_st[i] = 2/7 + 5/7 * (2 + psi_nom_st[i])/4; //eq. from goettlich and 40 (radial machine)
     end if;

     epsilon_rel_st_max[i] = (1 + C_1_st[i] - C_1_st[i]*phi_surge_rel_st[i])*phi_surge_rel_st[i];
     Pi_st_max[i] = (1 + epsilon_rel_st_max[i]*rpm_corr_rel_st[i]^2*(Pi_nom_st_vigv[i]^((kappa_nom_st_vigv[i]-1)/kappa_nom_st_vigv[i])-1))^(kappa_st[i]/(kappa_st[i]-1));

     Y_st[i]=(p_out_st[i] - p_out_st[i - 1])/(0.5*(TILMedia.Gas.ObjectFunctions.density_pTxi(
        p_out_nom_st[i - 1],
        T_out_nom_st[i - 1],
        xi_nom,
        OutletNom[i - 1].gasPointer) + TILMedia.Gas.ObjectFunctions.density_pTxi(
        p_out_st[i],
        T_out_st[i],
        inStream(inlet.xi_outflow),
        Outlet[i].gasPointer)));

 end for;

    Pi = product(Pi_st);
    tau = product(tau_st);

    kappa_aux = (kappa_in + kappa_out_st[N_stages])/2.0;
    der(kappa) = 1/Tau_aux*(kappa_aux-kappa);
    //kappa=1.4;
    eta_isen = (Pi^((kappa-1)/kappa)-1) / (tau - 1);

    Pi = outlet.p/inlet.p;
    tau = flueGas_outlet.T/flueGas_inlet.T;

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
    if noEvent(phi_rel_st[i] <= phi_surge_rel_st[i]) then
      count_surge[i]=1;
    else
      count_surge[i]=0;
    end if;
   if noEvent(m_flow_corr_rel_st[i] >= 1.5 and time >0) then
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
  P_hyd = (flueGas_outlet.h - flueGas_inlet.h) * inlet.m_flow;
  P_shaft = P_hyd*1/eta_mech;
  Y=sum(Y_st);
  V_flow = inlet.m_flow / flueGas_inlet.d;

  der(inlet.m_flow) = 1/0.01*(m_flow_aux-inlet.m_flow);
  //inlet.m_flow = m_flow_aux;

  inlet.m_flow + outlet.m_flow = 0.0;
  outlet.xi_outflow = inStream(inlet.xi_outflow);
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.T_outflow = flueGas_outlet.T;
  inlet.T_outflow = inStream(outlet.T_outflow);

  //______________Eye port variable definition________________________
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = flueGas_outlet.T-273.15;
  eye_int[1].s = flueGas_outlet.s/1e3;
  eye_int[1].p = flueGas_outlet.p/1e5;
  eye_int[1].h = flueGas_outlet.h/1e3;
  eye_int[1].xi=flueGas_outlet.xi;

  connect(eye_int[1],eyeOut)  annotation (Line(
      points={{40,-60},{92,-60}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(shaft, getInputsRotary.rotatoryFlange)
    annotation (Line(points={{0,100},{0,100},{0,30}}, color={0,0,0}));
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
end CompressorGas_L1_stageStacked;
