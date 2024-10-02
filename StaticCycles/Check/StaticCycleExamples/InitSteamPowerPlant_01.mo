within ClaRa.StaticCycles.Check.StaticCycleExamples;
model InitSteamPowerPlant_01
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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
  extends ClaRa.Basics.Icons.Init;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.*;
  import SI = ClaRa.Basics.Units;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

  parameter Basics.Units.MassFlowRate m_flow_FG=643;
                                          //574.1;//591+82;//1.2587*m_flow_nom;
  //parameter SI.MassFlowRate m_flow_Fuel=10.5;//0.030116*m_flow_nom;

  parameter Basics.Units.MassFlowRate m_flow_nom=420;
  inner parameter Real P_target_=1;
  // Heat Exchangers
  parameter Basics.Units.Pressure p_condenser=3800 annotation (Dialog(tab="Heat exchangers", group="Condenser"));
  parameter Basics.Units.Pressure preheater_HP_p_tap=55.95e5 annotation (Dialog(tab="Heat exchangers", group="Preheater HP"));
  parameter Basics.Units.MassFlowRate preheater_HP_m_flow_tap=42.812 annotation (Dialog(tab="Heat exchangers", group="Preheater HP"));
  parameter Basics.Units.Pressure preheater_LP1_p_tap=4.5e5 annotation (Dialog(tab="Heat exchangers", group="Preheater LP1"));
  parameter Basics.Units.MassFlowRate preheater_LP1_m_flow_tap=29 annotation (Dialog(tab="Heat exchangers", group="Preheater LP1"));
  parameter Basics.Units.Pressure preheater_LP2_p_tap=1e5 - 0.05e5 annotation (Dialog(tab="Heat exchangers", group="Preheater LP2"));
  parameter Basics.Units.MassFlowRate preheater_LP2_m_flow_tap=17 annotation (Dialog(tab="Heat exchangers", group="Preheater LP2"));
  parameter Basics.Units.Pressure preheater_LP3_p_tap=0.25e5 annotation (Dialog(tab="Heat exchangers", group="Preheater LP3"));
  parameter Basics.Units.MassFlowRate preheater_LP3_m_flow_tap=4 annotation (Dialog(tab="Heat exchangers", group="Preheater LP3"));
  parameter Basics.Units.Pressure preheater_LP4_p_tap=0.1e5 - 0.004e5 annotation (Dialog(tab="Heat exchangers", group="Preheater LP4"));
  parameter Basics.Units.MassFlowRate preheater_LP4_m_flow_tap=8 annotation (Dialog(tab="Heat exchangers", group="Preheater LP4"));
  // Feedwater tank
  parameter Basics.Units.Pressure p_FWT=12.4e5 annotation (Dialog(tab="Heat exchangers", group="Feedwater tank"));
  parameter Basics.Units.Length downComer_z_in=0 annotation (Dialog(tab="Heat exchangers", group="Feedwater tank"));
  parameter Basics.Units.Length downComer_z_out=-8 annotation (Dialog(tab="Heat exchangers", group="Feedwater tank"));
  parameter Basics.Units.Pressure downComer_Delta_p_nom=1e4 annotation (Dialog(tab="Heat exchangers", group="Feedwater tank"));
  // Valves
  parameter Basics.Units.PressureDifference valve_HP_Delta_p_nom=11e5 annotation (Dialog(group="Valve1_HP", tab="Valves"));
//  parameter SI.PressureDifference valve_IP_m_flow_nom= (m_flow_nom - preheater_HP_m_flow_tap)/10 annotation(Dialog(group="Valve_IP",tab="Valves"));

  parameter Basics.Units.PressureDifference valve_LP1_Delta_p_nom=0.05e5 annotation (Dialog(group="Valve_LP", tab="Valves"));
  parameter Basics.Units.PressureDifference valve_LP2_Delta_p_nom=0.01e5 annotation (Dialog(group="Valve_LP", tab="Valves"));
  parameter Basics.Units.PressureDifference valve_LP3_Delta_p_nom=0.004e5 annotation (Dialog(group="Valve_LP", tab="Valves"));

  parameter Basics.Units.PressureDifference valvePreFeedWaterTank_Delta_p_nom=0.001e5 annotation (Dialog(group="Valve_condensate", tab="Valves"));
  // Boiler
  parameter Basics.Units.Temperature T_LS_nom=823 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Temperature T_RS_nom=833 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure p_LS_out_nom=262e5 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure p_RS_out_nom=51e5 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.PressureDifference Delta_p_LS_nom=40e5 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.PressureDifference Delta_p_RS_nom=5e5 annotation (Dialog(tab="Boiler"));
  parameter Real CharLine_Delta_p_HP_mLS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(tab="Boiler"));
  parameter Real CharLine_Delta_p_IP_mRS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(tab="Boiler"));
  // Pumps
  parameter Real efficiency_Pump_cond=1 annotation(Dialog(tab="Pumps"));
  parameter Real efficiency_Pump_preheater_LP1=1 annotation(Dialog(tab="Pumps"));
  parameter Real efficiency_Pump_preheater_LP3=1 annotation(Dialog(tab="Pumps"));
  parameter Real efficiency_Pump_FW=1 annotation(Dialog(tab="Pumps"));
  // Turbines
  parameter Basics.Units.Pressure IP1_pressure=26e5 annotation (Dialog(tab="Turbines"));
  parameter Basics.Units.Pressure IP2_pressure=14e5 annotation (Dialog(tab="Turbines"));
  parameter Basics.Units.Pressure IP3_pressure=5e5 annotation (Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_HP=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_IP1=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_IP2=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_IP3=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP1=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP2=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP3=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP4=1 annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{340,-20},{360,0}})));
  ClaRa.StaticCycles.Machines.Pump1 Pump_cond(efficiency=efficiency_Pump_cond) annotation (Placement(transformation(extent={{338,-70},{318,-50}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP1(p_tap_nom=preheater_LP1_p_tap, m_flow_tap_nom=preheater_LP1_m_flow_tap) annotation (Placement(transformation(extent={{130,-70},{110,-50}})));
  ClaRa.StaticCycles.Machines.Pump1 pump_preheater_LP1(efficiency=efficiency_Pump_preheater_LP1) annotation (Placement(transformation(extent={{108,-92},{88,-72}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom3 valvePreFeedWaterTank(Delta_p_nom=valvePreFeedWaterTank_Delta_p_nom) annotation (Placement(transformation(extent={{102,-63},{92,-57}})));
  ClaRa.StaticCycles.Storage.Feedwatertank4 feedwatertank(m_flow_nom=m_flow_nom*P_target_, p_FWT_nom=p_FWT) annotation (Placement(transformation(extent={{45,-64},{25,-52}})));
  ClaRa.StaticCycles.Fittings.Mixer1 join_LP_main annotation (Placement(transformation(extent={{74,-65},{64,-59}})));
  ClaRa.StaticCycles.Machines.Pump1 Pump_FW(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{-40,-100},{-60,-80}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_HP(m_flow_tap_nom=preheater_HP_m_flow_tap, p_tap_nom=preheater_HP_p_tap) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-76,-34})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-56,40},{-44,60}})));
  ClaRa.StaticCycles.Fittings.Split1 join_HP annotation (Placement(transformation(extent={{-40,-2},{-50,4}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_HP(Delta_p_nom=valve_HP_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-45,-11})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve_cut annotation (Placement(transformation(
        extent={{-5.5,-3},{5.5,3}},
        rotation=180,
        origin={-63.5,11})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve2_HP annotation (Placement(transformation(extent={{-52,-54},{-42,-48}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_IP1(efficiency=efficiency_Turb_IP1) annotation (Placement(transformation(extent={{-26,40},{-14,60}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_LP1(efficiency=efficiency_Turb_LP1) annotation (Placement(transformation(extent={{124,40},{136,60}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP1 annotation (Placement(transformation(extent={{146,37},{156,43}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure2 valve_IP1 annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={35,11})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={151,11})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_LP4(efficiency=efficiency_Turb_LP4) annotation (Placement(transformation(extent={{244,40},{256,60}})));
  ClaRa.StaticCycles.Triple triple annotation (Placement(transformation(extent={{-40,34},{-28,44}})));
  ClaRa.StaticCycles.Triple triple1 annotation (Placement(transformation(extent={{0,50},{12,60}})));
  ClaRa.StaticCycles.Triple triple2 annotation (Placement(transformation(extent={{-52,74},{-40,84}})));
  ClaRa.StaticCycles.Triple triple3 annotation (Placement(transformation(extent={{-70,56},{-58,66}})));
  ClaRa.StaticCycles.Triple triple5 annotation (Placement(transformation(extent={{146,50},{158,60}})));
  ClaRa.StaticCycles.Triple triple6(decimalSpaces(p=2)) annotation (Placement(transformation(extent={{292,48},{304,58}})));
  ClaRa.StaticCycles.Triple triple7 annotation (Placement(transformation(extent={{144,-14},{156,-4}})));
  ClaRa.StaticCycles.Triple triple8 annotation (Placement(transformation(extent={{-38,-40},{-26,-30}})));
  ClaRa.StaticCycles.Triple triple9(decimalSpaces(p=2)) annotation (Placement(transformation(extent={{360,-34},{372,-24}})));
  ClaRa.StaticCycles.Triple triple10 annotation (Placement(transformation(extent={{-34,-76},{-22,-66}})));
  ClaRa.StaticCycles.Triple triple11 annotation (Placement(transformation(extent={{60,-50},{72,-40}})));
  ClaRa.StaticCycles.Triple triple12 annotation (Placement(transformation(extent={{-82,-108},{-70,-98}})));
  ClaRa.StaticCycles.Triple triple13 annotation (Placement(transformation(extent={{-72,-8},{-60,2}})));
  ClaRa.StaticCycles.Triple triple15 annotation (Placement(transformation(extent={{-30,-12},{-18,-2}})));
  ClaRa.StaticCycles.Triple triple16 annotation (Placement(transformation(extent={{-96,-16},{-84,-6}})));
  ClaRa.StaticCycles.Triple triple17 annotation (Placement(transformation(extent={{126,-86},{138,-76}})));
  ClaRa.StaticCycles.Triple triple18 annotation (Placement(transformation(extent={{106,-50},{118,-40}})));
  ClaRa.StaticCycles.Triple triple19 annotation (Placement(transformation(extent={{330,-90},{342,-80}})));
  ClaRa.StaticCycles.Triple triple20 annotation (Placement(transformation(extent={{26,-12},{38,-2}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_IP2(efficiency=efficiency_Turb_IP2) annotation (Placement(transformation(extent={{10,40},{22,60}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_IP3(efficiency=efficiency_Turb_IP3) annotation (Placement(transformation(extent={{46,40},{58,60}})));
  ClaRa.StaticCycles.Fittings.Split2 splitIP2(p_nom=IP2_pressure) annotation (Placement(transformation(extent={{30,37},{40,43}})));
  ClaRa.StaticCycles.Fittings.Split2 splitIP3(p_nom=IP3_pressure) annotation (Placement(transformation(extent={{68,37},{78,43}})));
  ClaRa.StaticCycles.ValvesConnects.PressureAnchor_constFlow1 pressureAnchor_constFlow1_1(p_nom=IP1_pressure) annotation (Placement(transformation(extent={{-5,39},{5,45}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_LP3(efficiency=efficiency_Turb_LP3) annotation (Placement(transformation(extent={{204,40},{216,60}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_LP2(efficiency=efficiency_Turb_LP2) annotation (Placement(transformation(extent={{164,40},{176,60}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve2 annotation (Placement(transformation(
        extent={{-4.5,2.5},{4.5,-2.5}},
        rotation=0,
        origin={179.5,-83.5})));
  ClaRa.StaticCycles.Fittings.Mixer3 mixerIP2 annotation (Placement(transformation(extent={{208,-14},{218,-20}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP2(p_tap_nom=preheater_LP2_p_tap, m_flow_tap_nom=preheater_LP2_m_flow_tap) annotation (Placement(transformation(extent={{180,-70},{160,-50}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP3(p_tap_nom=preheater_LP3_p_tap, m_flow_tap_nom=preheater_LP3_m_flow_tap + preheater_LP2_m_flow_tap) annotation (Placement(transformation(extent={{240,-70},{220,-50}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP4(p_tap_nom=preheater_LP4_p_tap, m_flow_tap_nom=preheater_LP4_m_flow_tap) annotation (Placement(transformation(extent={{290,-70},{270,-50}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure2 valve_IP2 annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={73,11})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP2 annotation (Placement(transformation(extent={{186,37},{196,43}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP3 annotation (Placement(transformation(extent={{226,37},{236,43}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP2(Delta_p_nom=valve_LP2_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={191,11})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP3(Delta_p_nom=valve_LP3_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={231,11})));
  ClaRa.StaticCycles.Machines.Pump1 pump_preheater_LP3(efficiency=efficiency_Pump_preheater_LP3) annotation (Placement(transformation(extent={{226,-100},{206,-80}})));
  ClaRa.StaticCycles.Fittings.Mixer1 join_preheater_LP3 annotation (Placement(transformation(extent={{205,-65},{195,-59}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve_cutPressureLP4 annotation (Placement(transformation(extent={{324,-103},{334,-97}})));
  ClaRa.StaticCycles.Fittings.Mixer2 mixer_condenser annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={352,-40})));
  ClaRa.StaticCycles.Triple triple4 annotation (Placement(transformation(extent={{66,-12},{78,-2}})));
  ClaRa.StaticCycles.Triple triple14 annotation (Placement(transformation(extent={{150,-50},{162,-40}})));
  ClaRa.StaticCycles.Triple triple21 annotation (Placement(transformation(extent={{212,-50},{224,-40}})));
  ClaRa.StaticCycles.Triple triple22 annotation (Placement(transformation(extent={{186,-14},{198,-4}})));
  ClaRa.StaticCycles.Triple triple23 annotation (Placement(transformation(extent={{228,-14},{240,-4}})));
  ClaRa.StaticCycles.Triple triple24 annotation (Placement(transformation(extent={{256,-50},{268,-40}})));
  ClaRa.StaticCycles.Triple triple25(decimalSpaces(p=2)) annotation (Placement(transformation(extent={{228,50},{240,60}})));
  ClaRa.StaticCycles.Triple triple26(decimalSpaces(p=2)) annotation (Placement(transformation(extent={{188,50},{200,60}})));
  ClaRa.StaticCycles.Triple triple27 annotation (Placement(transformation(extent={{32,50},{44,60}})));
  ClaRa.StaticCycles.Triple triple28 annotation (Placement(transformation(extent={{70,50},{82,60}})));
  ClaRa.StaticCycles.Triple triple29 annotation (Placement(transformation(extent={{204,-84},{216,-74}})));
  ClaRa.StaticCycles.Triple triple30 annotation (Placement(transformation(extent={{190,-87},{202,-77}})));
  ClaRa.StaticCycles.Triple triple31(decimalSpaces(p=2)) annotation (Placement(transformation(extent={{342,-98},{354,-88}})));
  ClaRa.StaticCycles.ValvesConnects.Tube2 downComer_feedWaterTank(
    z_in=downComer_z_in,
    Delta_p_nom=downComer_Delta_p_nom,
    z_out=downComer_z_out) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=270,
        origin={-10,-76})));
  ClaRa.StaticCycles.Triple triple32 annotation (Placement(transformation(extent={{-70,20},{-58,30}})));
  ClaRa.StaticCycles.ValvesConnects.Tube1 eco_riser(
    Delta_p_nom=0.1e5,
    Delta_x=fill(30, 3),
    z_in=0,
    z_out=100) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={-353,-230})));
  ClaRa.StaticCycles.ValvesConnects.Tube2 sh4_down(
    z_in=50,
    z_out=0,
    Delta_p_nom=0.3e5) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=0,
        origin={-242,28})));
  ClaRa.StaticCycles.Triple triple33 annotation (Placement(transformation(extent={{-352,-201},{-320,-173}})));
  ClaRa.StaticCycles.Triple triple34 annotation (Placement(transformation(extent={{-271,17},{-239,45}})));
  ClaRa.StaticCycles.Triple triple35 annotation (Placement(transformation(extent={{-487,-187},{-455,-159}})));
  ClaRa.StaticCycles.Triple triple36 annotation (Placement(transformation(extent={{-397,169},{-365,197}})));
  ClaRa.StaticCycles.Boundaries.Sink_brown flueGasSink(
    p_fg_nom=1.010e5,
    m_flow_fg_nom=m_flow_FG,
    T_fg_nom=398 + 273.15)   annotation (Placement(transformation(extent={{-517,272},{-497,252}})));
  ClaRa.StaticCycles.Boundaries.Source_purple flueGasSource(
    xi_fg_nom={0,0,0,0,0.77,0.23,0,0,0},
    m_flow_fg_nom=0.1,
    T_fg_nom=293.15) annotation (Placement(transformation(extent={{-576,-364},{-556,-344}})));
  ClaRa.StaticCycles.Boundaries.Source_orange flueGasSource2_2(xi_fg_nom={0,0,0,0,0.77,0.23,0,0,0}, T_fg_nom=643)          annotation (Placement(transformation(extent={{-614,-338},{-594,-318}})));
  ClaRa.StaticCycles.Furnace.Burner1 brnr1(
    CharLine_h_P_target_=[0.6,1.37; 0.8,0.99; 1,1], h_vle_wall_out_nom=1400e3,
    z_wall_in=0,
    z_wall_out=5,
    Delta_p_vle_wall_nom=2.087e5*2)                 annotation (Placement(transformation(extent={{-538,-324},{-518,-304}})));
  ClaRa.StaticCycles.Furnace.Burner2 brnr2(
    CharLine_h_P_target_=[0.6,1.27; 0.8,0.99; 1,1],
    h_vle_wall_out_nom=1500e3,
    z_wall_in=5,
    z_wall_out=10,
    lambda=dispatcher.lambda,
    Delta_p_vle_wall_nom=2.087e5)                   annotation (Placement(transformation(extent={{-538,-288},{-518,-268}})));
  ClaRa.StaticCycles.Boundaries.Source_orange flueGasSource2_1(xi_fg_nom={0,0,0,0,0.77,0.23,0,0,0}, T_fg_nom=643)          annotation (Placement(transformation(extent={{-616,-292},{-596,-272}})));
  ClaRa.StaticCycles.Furnace.Burner2 brnr3(
    CharLine_h_P_target_=[0.6,1.20; 0.8,1.01; 1,1],
    h_vle_wall_out_nom=1600e3,
    z_wall_in=10,
    z_wall_out=15,
    lambda=dispatcher.lambda,
    Delta_p_vle_wall_nom=2.087e5)                   annotation (Placement(transformation(extent={{-538,-238},{-518,-218}})));
  ClaRa.StaticCycles.Boundaries.Source_orange flueGasSource2_3(xi_fg_nom={0,0,0,0,0.77,0.23,0,0,0}, T_fg_nom=643)          annotation (Placement(transformation(extent={{-618,-242},{-598,-222}})));
  ClaRa.StaticCycles.Furnace.Burner2 brnr4(
    CharLine_h_P_target_=[0.6,1.16; 0.8,1.01; 1,1],
    h_vle_wall_out_nom=1700e3,
    z_wall_in=15,
    z_wall_out=20,
    lambda=dispatcher.lambda,
    Delta_p_vle_wall_nom=2.087e5)                   annotation (Placement(transformation(extent={{-538,-192},{-518,-172}})));
  ClaRa.StaticCycles.Boundaries.Source_orange flueGasSource2_4(xi_fg_nom={0,0,0,0,0.77,0.23,0,0,0}, T_fg_nom=643)          annotation (Placement(transformation(extent={{-616,-198},{-596,-178}})));
  ClaRa.StaticCycles.Furnace.FlameRoom3 eco(
    CharLine_h_bundle_P_target_=[0.6,1.52; 0.8,0.96; 1,1],
    h_vle_wall_out_nom=2500e3,
    h_vle_bundle_out_nom=1200e3,
    Delta_p_vle_bundle_nom=2e5,
    z_wall_in=90,
    z_wall_out=100,
    z_bundle_in=100,
    z_bundle_out=90,
    Delta_p_vle_wall_nom=2.087e5)                          annotation (Placement(transformation(extent={{-543,228},{-523,248}})));
  ClaRa.StaticCycles.Furnace.FlameRoom3 sh3(
    CharLine_h_bundle_P_target_=[0.6,0.99; 0.8,1.06; 1,1],
    h_vle_wall_out_nom=2300e3,
    h_vle_bundle_out_nom=3200e3,
    z_wall_in=70,
    z_wall_out=80,
    z_bundle_in=80,
    z_bundle_out=70,
    Delta_p_vle_bundle_nom=1e5,
    Delta_p_vle_wall_nom=2.087e5)
                                 annotation (Placement(transformation(extent={{-541,116},{-521,136}})));
  ClaRa.StaticCycles.Furnace.FlameRoom3 rh1(
    CharLine_h_bundle_P_target_=[0.6,1; 0.8,1; 1,1],
    h_vle_wall_out_nom=2400e3,
    h_vle_bundle_out_nom=3300e3,
    z_wall_in=80,
    z_wall_out=90,
    z_bundle_in=90,
    z_bundle_out=80,
    Delta_p_vle_bundle_nom=2e5,
    Delta_p_vle_wall_nom=2.087e5)
                                 annotation (Placement(transformation(extent={{-541,168},{-521,188}})));
  ClaRa.StaticCycles.Furnace.FlameRoom3 sh1(
    CharLine_h_bundle_P_target_=[0.6,1.03; 0.8,1.02; 1,1],
    h_vle_wall_out_nom=1900e3,
    h_vle_bundle_out_nom=2900e3,
    z_wall_in=30,
    z_wall_out=40,
    z_bundle_in=40,
    z_bundle_out=30,
    Delta_p_vle_bundle_nom=1e5,
    Delta_p_vle_wall_nom=2.087e5)
                                 annotation (Placement(transformation(extent={{-539,-76},{-519,-56}})));
  ClaRa.StaticCycles.Furnace.FlameRoom2 rh2(
    CharLine_T_bundle_P_target_=[0.6,0.998; 0.8,1; 1,1],
    h_vle_wall_out_nom=2200e3,
    z_wall_in=60,
    z_wall_out=70,
    z_bundle_in=70,
    z_bundle_out=60,
    Delta_p_vle_bundle_nom=2e5,
    T_vle_bundle_out_nom=T_RS_nom,
    p_vle_bundle_out_nom=p_RS_out_nom + 0.22e5,
    Delta_p_vle_wall_nom=2.087e5)
                                 annotation (Placement(transformation(extent={{-541,66},{-521,86}})));
  ClaRa.StaticCycles.Furnace.FlameRoom3 sh2(
    CharLine_h_bundle_P_target_=[0.6,1.01; 0.8,1.02; 1,1],
    h_vle_wall_out_nom=2000e3,
    h_vle_bundle_out_nom=3000e3,
    z_wall_in=40,
    z_wall_out=50,
    z_bundle_in=50,
    z_bundle_out=40,
    Delta_p_vle_bundle_nom=1e5,
    Delta_p_vle_wall_nom=2.087e5)
                                 annotation (Placement(transformation(extent={{-541,-26},{-521,-6}})));
  ClaRa.StaticCycles.Furnace.FlameRoom2 sh4(
    CharLine_T_bundle_P_target_=[0.6,0.83; 0.8,0.86; 1,1],
    h_vle_wall_out_nom=2100e3,
    z_wall_in=50,
    z_wall_out=60,
    z_bundle_in=60,
    z_bundle_out=50,
    Delta_p_vle_bundle_nom=1e5,
    T_vle_bundle_out_nom=T_LS_nom,
    p_vle_bundle_out_nom=p_LS_out_nom,
    Delta_p_vle_wall_nom=2.087e5)
                               annotation (Placement(transformation(extent={{-541,20},{-521,40}})));
  ClaRa.StaticCycles.ValvesConnects.FlowAnchor_constPressure1 fixedFlow(m_flow_nom=376.9)  annotation (Placement(transformation(
        extent={{-4.5,-2},{4.5,2}},
        rotation=90,
        origin={-500,-164.5})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas annotation (Placement(transformation(extent={{-586,-293},{-554,-265}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas1 annotation (Placement(transformation(extent={{-584,-339},{-552,-311}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas2 annotation (Placement(transformation(extent={{-586,-243},{-554,-215}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas3 annotation (Placement(transformation(extent={{-580,-199},{-548,-171}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas4 annotation (Placement(transformation(extent={{-562,-214},{-530,-186}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas5 annotation (Placement(transformation(extent={{-562,-264},{-530,-236}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas6 annotation (Placement(transformation(extent={{-560,-312},{-528,-284}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas7 annotation (Placement(transformation(extent={{-532,-364},{-500,-336}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas8 annotation (Placement(transformation(extent={{-570,-94},{-538,-66}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas9 annotation (Placement(transformation(extent={{-576,-54},{-544,-26}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas10 annotation (Placement(transformation(extent={{-572,-6},{-540,22}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas11 annotation (Placement(transformation(extent={{-570,40},{-538,68}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas12 annotation (Placement(transformation(extent={{-570,92},{-538,120}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas13 annotation (Placement(transformation(extent={{-570,136},{-538,164}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas14 annotation (Placement(transformation(extent={{-572,194},{-540,222}})));
  ClaRa.StaticCycles.Triple triple37 annotation (Placement(transformation(extent={{-473,-332},{-441,-304}})));
  ClaRa.StaticCycles.Triple triple38 annotation (Placement(transformation(extent={{-511,-304},{-479,-276}})));
  ClaRa.StaticCycles.Triple triple39 annotation (Placement(transformation(extent={{-511,-260},{-479,-232}})));
  ClaRa.StaticCycles.Triple triple40 annotation (Placement(transformation(extent={{-513,-218},{-481,-190}})));
  ClaRa.StaticCycles.Triple triple41 annotation (Placement(transformation(extent={{-485,-92},{-453,-64}})));
  ClaRa.StaticCycles.Triple triple42 annotation (Placement(transformation(extent={{-490,-42},{-458,-14}})));
  ClaRa.StaticCycles.Triple triple43 annotation (Placement(transformation(extent={{-458,26},{-426,54}})));
  ClaRa.StaticCycles.Triple triple44 annotation (Placement(transformation(extent={{-460,79},{-428,107}})));
  ClaRa.StaticCycles.Furnace.FlameRoom_woBundle
                                        evap_rad(h_vle_wall_out_nom=1800e3,
    z_wall_in=20,
    z_wall_out=30,
    Delta_p_vle_wall_nom=2.087e5*2)
                                 annotation (Placement(transformation(extent={{-539,-160},{-519,-140}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas15 annotation (Placement(transformation(extent={{-560,-176},{-528,-148}})));
  ClaRa.StaticCycles.Fittings.Mixer1 inj_rh1 annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-465,165})));
  ClaRa.StaticCycles.ValvesConnects.FlowAnchor_constPressure1 fixedFlow2(CharLine_m_flow_P_target_=[0,0; 0.8,0.03; 1,1], m_flow_nom=0.1)  annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={-433,165})));
  ClaRa.StaticCycles.Fittings.Split1 split1_3 annotation (Placement(transformation(extent={{-314,-272},{-324,-278}})));
  ClaRa.StaticCycles.Triple triple45 annotation (Placement(transformation(extent={{-318,-202},{-286,-174}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve_cutPressure2 annotation (Placement(transformation(extent={{-340,-280},{-350,-274}})));
  ClaRa.StaticCycles.Triple triple46 annotation (Placement(transformation(extent={{-335,-264},{-303,-236}})));
  ClaRa.StaticCycles.Fittings.Split1 split1_1 annotation (Placement(transformation(extent={{-213,-272},{-223,-278}})));
  ClaRa.StaticCycles.Triple triple47 annotation (Placement(transformation(extent={{-217,-206},{-185,-178}})));
  ClaRa.StaticCycles.ValvesConnects.FlowAnchor_constPressure1 fixedFlow1(m_flow_nom=28)    annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={-339,-39})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom3 valve_dp_nom3_1(Delta_p_nom=37.1e5)
                                                                                    annotation (Placement(transformation(extent={{-370,-42},{-380,-36}})));
  ClaRa.StaticCycles.Fittings.Mixer1 inj_hp1 annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=90,
        origin={-431,-39})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve_cutPressure annotation (Placement(transformation(extent={{-234,-280},{-244,-274}})));
  ClaRa.StaticCycles.Triple triple48 annotation (Placement(transformation(extent={{-256,154},{-224,182}})));
  ClaRa.StaticCycles.Triple triple49 annotation (Placement(transformation(extent={{-293,-258},{-261,-230}})));
  ClaRa.StaticCycles.Triple triple50 annotation (Placement(transformation(extent={{-231,-262},{-199,-234}})));
  ClaRa.StaticCycles.ValvesConnects.FlowAnchor_constPressure1 fixedFlow3(m_flow_nom=15)   annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={-431,56})));
  ClaRa.StaticCycles.Fittings.Mixer1 inj_hp2 annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-499,56})));
  ClaRa.StaticCycles.Triple triple51 annotation (Placement(transformation(extent={{-500,98},{-468,126}})));
  ClaRa.StaticCycles.Triple triple52 annotation (Placement(transformation(extent={{-646,196},{-614,224}})));
  ClaRa.StaticCycles.Triple triple53 annotation (Placement(transformation(extent={{-648,146},{-616,174}})));
  ClaRa.StaticCycles.Triple triple54 annotation (Placement(transformation(extent={{-648,86},{-616,114}})));
  ClaRa.StaticCycles.Triple triple55 annotation (Placement(transformation(extent={{-648,42},{-616,70}})));
  ClaRa.StaticCycles.Triple triple56 annotation (Placement(transformation(extent={{-650,-52},{-618,-24}})));
  ClaRa.StaticCycles.Triple triple57 annotation (Placement(transformation(extent={{-491,-154},{-459,-126}})));
  ClaRa.StaticCycles.Triple triple58 annotation (Placement(transformation(extent={{-492,249},{-460,277}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom3 valve_dp_nom3_2(                    CharLine_Delta_p_P_target_=[0,0; 0.8,0.7; 1,1], Delta_p_nom=38.7e5)
                                                                                                                                      annotation (Placement(transformation(extent={{-446,53},{-456,59}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom3 valve_dp_nom3_3(Delta_p_nom=248.8e5) annotation (Placement(transformation(extent={{-448,162},{-458,168}})));
  ClaRa.StaticCycles.Triple triple59 annotation (Placement(transformation(extent={{-383,-288},{-351,-260}})));
  ClaRa.StaticCycles.ValvesConnects.Tube1 eco_down(
    z_out=0,
    Delta_p_nom=0.3e5,
    z_in=100) annotation (Placement(transformation(
        extent={{10,-4},{-10,4}},
        rotation=90,
        origin={-473,-290})));
  ClaRa.StaticCycles.Triple triple60 annotation (Placement(transformation(extent={{-472,-279},{-440,-251}})));
  ClaRa.StaticCycles.Triple triple61 annotation (Placement(transformation(extent={{-424,-15},{-392,13}})));
  ClaRa.StaticCycles.Triple triple63 annotation (Placement(transformation(extent={{-418,-49},{-386,-21}})));
  ClaRa.StaticCycles.Triple triple64 annotation (Placement(transformation(extent={{-328,-50},{-296,-22}})));
  ClaRa.StaticCycles.Triple triple66 annotation (Placement(transformation(extent={{-652,-10},{-620,18}})));
  ClaRa.StaticCycles.Furnace.FlameRoom_woBundle ct(h_vle_wall_out_nom=2600e3,
    z_wall_in=100,
    z_wall_out=100,
    Delta_p_vle_wall_nom=0.5e5)                                               annotation (Placement(transformation(extent={{-539,-116},{-519,-96}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas16
                                                          annotation (Placement(transformation(extent={{-570,-138},{-538,-110}})));
  ClaRa.StaticCycles.Fittings.Split1 split1_2 annotation (Placement(transformation(extent={{-151,-272},{-161,-278}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve_cutPressure1
                                                                         annotation (Placement(transformation(extent={{-186,-280},{-196,-274}})));
  ClaRa.StaticCycles.ValvesConnects.Tube2 rh2_down(
    z_out=0,
    Delta_p_nom=0.3e5,
    z_in=60) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=0,
        origin={-244,74})));
  ClaRa.StaticCycles.Triple triple65 annotation (Placement(transformation(extent={{-264,79},{-232,107}})));
  ClaRa.StaticCycles.ValvesConnects.Tube1 rh1_riser(
    Delta_p_nom=0.1e5,
    Delta_x=fill(30, 3),
    z_in=0,
    z_out=90) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=180,
        origin={-243,-116})));
  ClaRa.StaticCycles.Boundaries.Dispatcher dispatcher(
    N_burner_levels=4,
    P_el_nom=(Turbine_HP.P_turbine + Turbine_IP1.P_turbine + Turbine_IP2.P_turbine + Turbine_IP3.P_turbine + Turbine_LP1.P_turbine + Turbine_LP2.P_turbine + Turbine_LP3.P_turbine + Turbine_LP4.P_turbine)*0.96,
    xi_pa_in={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    eta_el_nom=0.45,
    xi_c={0.84,0.07},
    lambda=1.2)                                                                                                                                                                                            annotation (Placement(transformation(extent={{-666,-240},{-626,-220}})));
equation
  connect(pump_preheater_LP1.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{108.5,-82},{120,-82},{120,-70.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater_LP1.outlet, join_LP_main.inlet_2) annotation (Line(
      points={{87.5,-82},{69,-82},{69,-65.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(join_LP_main.outlet, feedwatertank.cond_in) annotation (Line(
      points={{63.5,-60},{45.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP.cond_in, Pump_FW.outlet) annotation (Line(
      points={{-76,-44.5},{-76,-90},{-60.5,-90}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_HP.outlet, join_HP.inlet) annotation (Line(
      points={{-43.5,42},{-28,42},{-28,3},{-39.5,3}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_HP.inlet, join_HP.outlet_2) annotation (Line(
      points={{-45,-5.5},{-45,-2.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_HP.outlet, preheater_HP.tap_in) annotation (Line(
      points={{-45,-16.5},{-45,-34},{-65.5,-34}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_cut.inlet, join_HP.outlet_1) annotation (Line(
      points={{-57.45,11},{-52,11},{-52,3},{-50.5,3}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2_HP.inlet, preheater_HP.tap_out) annotation (Line(
      points={{-52.5,-51},{-94,-51},{-94,-34},{-86.5,-34}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP1.outlet, split_LP1.inlet) annotation (Line(
      points={{136.5,42},{145.5,42}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{151,36.5},{151,16.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP4.outlet, condenser.inlet) annotation (Line(
      points={{256.5,42},{350,42},{350,0.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valvePreFeedWaterTank.outlet, join_LP_main.inlet_1) annotation (Line(
      points={{91.5,-60},{74.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, valvePreFeedWaterTank.inlet) annotation (Line(
      points={{109.5,-60},{102.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple.steamSignal, Turbine_HP.outlet) annotation (Line(
      points={{-40.375,37.9286},{-42,37.9286},{-42,42},{-43.5,42}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple1.steamSignal, Turbine_IP1.outlet) annotation (Line(
      points={{-0.375,53.9286},{-12,53.9286},{-12,42},{-13.5,42}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple5.steamSignal, Turbine_LP1.outlet) annotation (Line(
      points={{145.625,53.9286},{140,53.9286},{140,42},{136.5,42}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple6.steamSignal,Turbine_LP4. outlet) annotation (Line(
      points={{291.625,51.9286},{292,51.9286},{292,42},{256.5,42}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple7.steamSignal, valve_LP1.outlet) annotation (Line(
      points={{143.625,-10.0714},{151,-10.0714},{151,5.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple10.steamSignal, Pump_FW.inlet) annotation (Line(
      points={{-34.375,-72.0714},{-38,-72.0714},{-38,-90},{-39.5,-90}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple11.steamSignal, feedwatertank.cond_in) annotation (Line(
      points={{59.625,-46.0714},{58,-46.0714},{58,-60},{45.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple12.steamSignal, Pump_FW.outlet) annotation (Line(
      points={{-82.375,-104.071},{-72,-104.071},{-72,-90},{-60.5,-90}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple13.steamSignal, preheater_HP.cond_out) annotation (Line(
      points={{-72.375,-4.07143},{-74,-4.07143},{-74,-23.5},{-76,-23.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple15.steamSignal, join_HP.outlet_2) annotation (Line(
      points={{-30.375,-8.07143},{-38,-8.07143},{-38,-2.5},{-45,-2.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple16.steamSignal, preheater_HP.tap_out) annotation (Line(
      points={{-96.375,-12.0714},{-96,-12.0714},{-96,-34},{-86.5,-34}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple17.steamSignal, preheater_LP1.tap_out) annotation (Line(
      points={{125.625,-82.0714},{120,-82.0714},{120,-70.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple18.steamSignal, preheater_LP1.cond_out) annotation (Line(
      points={{105.625,-46.0714},{105.625,-60},{109.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple19.steamSignal, Pump_cond.outlet) annotation (Line(
      points={{329.625,-86.0714},{324,-86.0714},{324,-86},{318,-86},{318,-84},{317.5,-84},{317.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple20.steamSignal, valve_IP1.outlet) annotation (Line(
      points={{25.625,-8.07143},{25.625,-9.0357},{35,-9.0357},{35,5.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP1.outlet, feedwatertank.tap_in2) annotation (Line(
      points={{35,5.5},{35,-51.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2_HP.outlet, feedwatertank.tap_in1) annotation (Line(
      points={{-41.5,-51},{31,-51},{31,-51.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple8.steamSignal, valve2_HP.outlet) annotation (Line(
      points={{-38.375,-36.0714},{-24.1875,-36.0714},{-24.1875,-51},{-41.5,-51}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_IP2.outlet, splitIP2.inlet) annotation (Line(points={{22.5,42},{29.5,42}}, color={0,131,169}));
  connect(splitIP2.outlet_1, Turbine_IP3.inlet) annotation (Line(points={{40.5,42},{45.5,42},{45.5,54}}, color={0,131,169}));
  connect(Turbine_IP3.outlet, splitIP3.inlet) annotation (Line(points={{58.5,42},{67.5,42}}, color={0,131,169}));
  connect(splitIP2.outlet_2, valve_IP1.inlet) annotation (Line(points={{35,36.5},{35,16.5}}, color={0,131,169}));
  connect(Turbine_IP1.outlet, pressureAnchor_constFlow1_1.inlet) annotation (Line(points={{-13.5,42},{-5.5,42}}, color={0,131,169}));
  connect(pressureAnchor_constFlow1_1.outlet, Turbine_IP2.inlet) annotation (Line(points={{5.5,42},{9.5,42},{9.5,54}}, color={0,131,169}));
  connect(splitIP3.outlet_1, Turbine_LP1.inlet) annotation (Line(points={{78.5,42},{120,42},{120,54},{123.5,54}}, color={0,131,169}));
  connect(split_LP1.outlet_1, Turbine_LP2.inlet) annotation (Line(points={{156.5,42},{160,42},{160,54},{163.5,54}}, color={0,131,169}));
  connect(splitIP3.outlet_2,valve_IP2. inlet) annotation (Line(points={{73,36.5},{73,16.5}},                       color={0,131,169}));
  connect(valve_IP2.outlet, preheater_LP1.tap_in) annotation (Line(points={{73,5.5},{73,-20},{120,-20},{120,-49.5}},   color={0,131,169}));
  connect(valve_LP1.outlet, preheater_LP2.tap_in) annotation (Line(points={{151,5.5},{151,-10},{170,-10},{170,-49.5}}, color={0,131,169}));
  connect(preheater_LP2.cond_out, preheater_LP1.cond_in) annotation (Line(points={{159.5,-60},{130.5,-60}}, color={0,131,169}));
  connect(preheater_LP2.tap_out, valve2.inlet) annotation (Line(points={{170,-70.5},{170,-83.5},{174.55,-83.5}}, color={0,131,169}));
  connect(valve2.outlet,mixerIP2. inlet_1) annotation (Line(points={{184.45,-83.5},{188,-83.5},{188,-20},{207.5,-20},{207.5,-19}}, color={0,131,169}));
  connect(mixerIP2.outlet, preheater_LP3.tap_in) annotation (Line(points={{218.5,-19},{230,-19},{230,-49.5}}, color={0,131,169}));
  connect(Turbine_LP2.outlet, split_LP2.inlet) annotation (Line(points={{176.5,42},{185.5,42}}, color={0,131,169}));
  connect(split_LP2.outlet_1, Turbine_LP3.inlet) annotation (Line(points={{196.5,42},{200,42},{200,54},{203.5,54}}, color={0,131,169}));
  connect(Turbine_LP3.outlet, split_LP3.inlet) annotation (Line(points={{216.5,42},{225.5,42}}, color={0,131,169}));
  connect(split_LP3.outlet_1, Turbine_LP4.inlet) annotation (Line(points={{236.5,42},{240,42},{240,54},{243.5,54}}, color={0,131,169}));
  connect(split_LP2.outlet_2, valve_LP2.inlet) annotation (Line(points={{191,36.5},{191,27.25},{191,27.25},{191,16.5}}, color={0,131,169}));
  connect(valve_LP2.outlet, mixerIP2.inlet_2) annotation (Line(points={{191,5.5},{191,0},{213,0},{213,-13.5}}, color={0,131,169}));
  connect(split_LP3.outlet_2, valve_LP3.inlet) annotation (Line(points={{231,36.5},{231,26.25},{231,26.25},{231,16.5}}, color={0,131,169}));
  connect(valve_LP3.outlet, preheater_LP4.tap_in) annotation (Line(points={{231,5.5},{231,-10},{280,-10},{280,-49.5}}, color={0,131,169}));
  connect(Pump_cond.outlet, preheater_LP4.cond_in) annotation (Line(points={{317.5,-60},{290.5,-60}}, color={0,131,169}));
  connect(preheater_LP4.cond_out, preheater_LP3.cond_in) annotation (Line(points={{269.5,-60},{240.5,-60}}, color={0,131,169}));
  connect(preheater_LP3.cond_out, join_preheater_LP3.inlet_1) annotation (Line(points={{219.5,-60},{205.5,-60}}, color={0,131,169}));
  connect(join_preheater_LP3.outlet, preheater_LP2.cond_in) annotation (Line(points={{194.5,-60},{180.5,-60}}, color={0,131,169}));
  connect(preheater_LP3.tap_out, pump_preheater_LP3.inlet) annotation (Line(points={{230,-70.5},{230,-90},{226.5,-90}}, color={0,131,169}));
  connect(pump_preheater_LP3.outlet, join_preheater_LP3.inlet_2) annotation (Line(points={{205.5,-90},{200,-90},{200,-65.5}}, color={0,131,169}));
  connect(condenser.outlet, mixer_condenser.inlet_1) annotation (Line(points={{350,-20.5},{350,-34.5}}, color={0,131,169}));
  connect(mixer_condenser.outlet, Pump_cond.inlet) annotation (Line(points={{350,-45.5},{350,-60},{338.5,-60}}, color={0,131,169}));
  connect(valve_cutPressureLP4.outlet, mixer_condenser.inlet_2) annotation (Line(points={{334.5,-100},{368,-100},{368,-40},{355.5,-40}}, color={0,131,169}));
  connect(preheater_LP4.tap_out, valve_cutPressureLP4.inlet) annotation (Line(points={{280,-70.5},{280,-100},{323.5,-100}}, color={0,131,169}));
  connect(triple4.steamSignal,valve_IP2. outlet) annotation (Line(points={{65.625,-8.07143},{73,-8.07143},{73,5.5}}, color={0,131,169}));
  connect(preheater_LP2.cond_out, triple14.steamSignal) annotation (Line(points={{159.5,-60},{149.625,-60},{149.625,-46.0714}}, color={0,131,169}));
  connect(preheater_LP3.cond_out, triple21.steamSignal) annotation (Line(points={{219.5,-60},{211.625,-60},{211.625,-46.0714}}, color={0,131,169}));
  connect(triple22.steamSignal, valve_LP2.outlet) annotation (Line(points={{185.625,-10.0714},{185.625,-10.0357},{191,-10.0357},{191,5.5}}, color={0,131,169}));
  connect(triple23.steamSignal, valve_LP3.outlet) annotation (Line(points={{227.625,-10.0714},{231,-10.0714},{231,5.5}}, color={0,131,169}));
  connect(triple24.steamSignal, preheater_LP4.cond_out) annotation (Line(points={{255.625,-46.0714},{255.625,-60},{269.5,-60}}, color={0,131,169}));
  connect(triple25.steamSignal, Turbine_LP3.outlet) annotation (Line(points={{227.625,53.9286},{220.813,53.9286},{220.813,42},{216.5,42}}, color={0,131,169}));
  connect(triple26.steamSignal, Turbine_LP2.outlet) annotation (Line(points={{187.625,53.9286},{180,53.9286},{180,42},{176.5,42}}, color={0,131,169}));
  connect(triple27.steamSignal, Turbine_IP2.outlet) annotation (Line(points={{31.625,53.9286},{26,53.9286},{26,42},{22.5,42}}, color={0,131,169}));
  connect(triple28.steamSignal, Turbine_IP3.outlet) annotation (Line(points={{69.625,53.9286},{62,53.9286},{62,42},{58.5,42}}, color={0,131,169}));
  connect(pump_preheater_LP3.outlet, triple29.steamSignal) annotation (Line(points={{205.5,-90},{203.625,-90},{203.625,-80.0714}}, color={0,131,169}));
  connect(valve2.outlet, triple30.steamSignal) annotation (Line(points={{184.45,-83.5},{187.225,-83.5},{187.225,-83.0714},{189.625,-83.0714}}, color={0,131,169}));
  connect(condenser.outlet, triple9.steamSignal) annotation (Line(points={{350,-20.5},{350,-30.0714},{359.625,-30.0714}}, color={0,131,169}));
  connect(valve_cutPressureLP4.outlet, triple31.steamSignal) annotation (Line(points={{334.5,-100},{340,-100},{340,-94.0714},{341.625,-94.0714}}, color={0,131,169}));
  connect(feedwatertank.cond_out,downComer_feedWaterTank. inlet) annotation (Line(points={{24.5,-60},{-10,-60},{-10,-65.5}}, color={0,131,169}));
  connect(downComer_feedWaterTank.outlet, Pump_FW.inlet) annotation (Line(points={{-10,-86.5},{-10,-90},{-39.5,-90}}, color={0,131,169}));
  connect(valve_cut.outlet, triple32.steamSignal) annotation (Line(points={{-69.55,11},{-69.55,6.5},{-70.375,6.5},{-70.375,23.9286}},color={0,131,169}));
  connect(triple33.steamSignal, eco_riser.outlet) annotation (Line(points={{-353,-190},{-353,-219.5}}, color={0,131,169}));
  connect(triple34.steamSignal, sh4_down.inlet) annotation (Line(points={{-272,28},{-252.5,28}}, color={0,131,169}));
  connect(brnr1.inletPrimAir,flueGasSource2_2. outlet) annotation (Line(points={{-538.4,-317},{-563.2,-317},{-563.2,-328},{-593.6,-328}},
                                                                    color={118,
          106,98}));
  connect(brnr1.outletGas,brnr2. inletGas) annotation (Line(points={{-532,-303.6},{-532,-288.5}},
                                      color={118,106,98}));
  connect(flueGasSource2_1.outlet,brnr2. inletPrimAir) annotation (Line(points={{-595.6,-282},{-538.4,-282},{-538.4,-281}},
                                                  color={118,106,98}));
  connect(flueGasSource2_3.outlet,brnr3. inletPrimAir) annotation (Line(points={{-597.6,-232},{-538.4,-232},{-538.4,-231}},
                                                  color={118,106,98}));
  connect(flueGasSource2_4.outlet,brnr4. inletPrimAir) annotation (Line(points={{-595.6,-188},{-538.4,-188},{-538.4,-185}},
                                               color={118,106,98}));
  connect(brnr2.outletGas,brnr3. inletGas) annotation (Line(points={{-532,-267.5},{-532,-238.5}},
                                    color={118,106,98}));
  connect(brnr3.outletGas,brnr4. inletGas) annotation (Line(points={{-532,-217.5},{-532,-192.5}},
                                   color={118,106,98}));
  connect(eco_riser.outlet, eco.inletBundle) annotation (Line(points={{-353,-219.5},{-355,-219.5},{-355,240},{-522.6,240}}, color={0,131,169}));
  connect(flueGasSource.outlet,brnr1. inletGas) annotation (Line(points={{-555.6,-354},{-532,-354},{-532,-324.4}},
                                          color={118,106,98}));
  connect(flueGasSink.inlet,eco. outletGas) annotation (Line(points={{-517.4,262},{-537,262},{-537,248.4}},
                                       color={118,106,98}));
  connect(brnr2.inletWall,brnr1. outletWall) annotation (Line(points={{-517.6,-284},{-512,-284},{-512,-308},{-517.6,-308}},
                                               color={0,131,169}));
  connect(brnr2.outletWall,brnr3. inletWall) annotation (Line(points={{-517.6,-272},{-512,-272},{-512,-234},{-517.6,-234}},
                                            color={0,131,169}));
  connect(brnr3.outletWall,brnr4. inletWall) annotation (Line(points={{-517.6,-222},{-512,-222},{-512,-188},{-517.6,-188}},
                                          color={0,131,169}));
  connect(sh3.outletGas,rh1. inletGas)
    annotation (Line(points={{-535,136.4},{-535,167.6}},
                                                       color={118,106,98}));
  connect(rh2.outletGas,sh3. inletGas)
    annotation (Line(points={{-535,86.4},{-535,115.6}},color={118,106,98}));
  connect(sh4.outletGas,rh2. inletGas)
    annotation (Line(points={{-535,40.4},{-535,65.6}}, color={118,106,98}));
  connect(sh1.outletGas, sh2.inletGas) annotation (Line(points={{-533,-55.6},{-533,-26.4},{-535,-26.4}}, color={118,106,98}));
  connect(sh2.outletGas, sh4.inletGas) annotation (Line(points={{-535,-5.6},{-535,19.6}}, color={118,106,98}));
  connect(rh1.outletGas,eco. inletGas) annotation (Line(points={{-535,188.4},{-535,227.6},{-537,227.6}},
                                         color={118,106,98}));
  connect(sh4.outletBundle, sh4_down.inlet) annotation (Line(points={{-520.6,28},{-252.5,28}}, color={0,131,169}));
  connect(brnr4.outletWall,fixedFlow. inlet) annotation (Line(points={{-517.6,-176},{-500,-176},{-500,-169.45}},
                                                  color={0,131,169}));
  connect(triple35.steamSignal,fixedFlow. inlet) annotation (Line(points={{-488,-176},{-500,-176},{-500,-169.45}},
                                                                                                        color={0,131,169}));
  connect(tripleFlueGas.gasSignal,flueGasSource2_1. outlet) annotation (Line(
        points={{-587,-282},{-595.6,-282}},            color={118,106,98}));
  connect(tripleFlueGas1.gasSignal,flueGasSource2_2. outlet) annotation (Line(
        points={{-585,-328},{-593.6,-328}},               color={118,106,98}));
  connect(tripleFlueGas2.gasSignal,flueGasSource2_3. outlet) annotation (Line(
        points={{-587,-232},{-597.6,-232}},            color={118,106,98}));
  connect(tripleFlueGas3.gasSignal,flueGasSource2_4. outlet)
    annotation (Line(points={{-581,-188},{-595.6,-188}},
                                                     color={118,106,98}));
  connect(tripleFlueGas4.gasSignal,brnr4. inletGas) annotation (Line(points={{-563,-203},{-532,-203},{-532,-192.5}},
                                           color={118,106,98}));
  connect(tripleFlueGas5.gasSignal,brnr3. inletGas) annotation (Line(points={{-563,-253},{-532,-253},{-532,-238.5}},
                                            color={118,106,98}));
  connect(tripleFlueGas6.gasSignal,brnr2. inletGas) annotation (Line(points={{-561,-301},{-532,-301},{-532,-288.5}},
                                               color={118,106,98}));
  connect(tripleFlueGas7.gasSignal,brnr1. inletGas) annotation (Line(points={{-533,-353},{-533,-324.4},{-532,-324.4}},
                                                color={118,106,98}));
  connect(tripleFlueGas8.gasSignal,sh1. inletGas) annotation (Line(points={{-571,-83},{-533,-83},{-533,-76.4}},
                                    color={118,106,98}));
  connect(tripleFlueGas9.gasSignal,sh1. outletGas) annotation (Line(points={{-577,-43},{-533,-43},{-533,-55.6}},
                                      color={118,106,98}));
  connect(tripleFlueGas10.gasSignal, sh2.outletGas) annotation (Line(points={{-573,5},{-535,5},{-535,-5.6}}, color={118,106,98}));
  connect(tripleFlueGas11.gasSignal,sh4. outletGas) annotation (Line(points={{-571,51},{-535,51},{-535,40.4}},
                                       color={118,106,98}));
  connect(tripleFlueGas12.gasSignal,sh3. inletGas) annotation (Line(points={{-571,103},{-535,103},{-535,115.6}},
                                       color={118,106,98}));
  connect(tripleFlueGas13.gasSignal,rh1. inletGas) annotation (Line(points={{-571,147},{-535,147},{-535,167.6}},
                                       color={118,106,98}));
  connect(tripleFlueGas14.gasSignal,eco. inletGas) annotation (Line(points={{-573,205},{-537,205},{-537,227.6}},
                                       color={118,106,98}));
  connect(brnr1.inletWall, triple37.steamSignal) annotation (Line(points={{-517.6,-320},{-474,-320},{-474,-321}}, color={0,131,169}));
  connect(brnr2.inletWall, triple38.steamSignal) annotation (Line(points={{-517.6,-284},{-512,-284},{-512,-293}}, color={0,131,169}));
  connect(brnr3.inletWall, triple39.steamSignal) annotation (Line(points={{-517.6,-234},{-512,-234},{-512,-249}}, color={0,131,169}));
  connect(triple40.steamSignal, brnr4.inletWall) annotation (Line(points={{-514,-207},{-512.5,-207},{-512.5,-188},{-517.6,-188}}, color={0,131,169}));
  connect(triple42.steamSignal, sh2.outletBundle) annotation (Line(points={{-491,-31},{-505,-31},{-505,-18},{-520.6,-18}}, color={0,131,169}));
  connect(triple44.steamSignal,rh2. inletBundle) annotation (Line(points={{-461,90},{-461,78},{-520.6,78}},
                                      color={0,131,169}));
  connect(triple43.steamSignal,sh4. inletBundle) annotation (Line(points={{-459,37},{-459,32},{-520.6,32}},
                                      color={0,131,169}));
  connect(brnr4.outletGas,evap_rad. inletGas) annotation (Line(points={{-532,-171.5},{-533,-165.8},{-533,-160.4}},
                                        color={118,106,98}));
  connect(tripleFlueGas15.gasSignal,brnr4. outletGas) annotation (Line(points={{-561,-165},{-532,-165},{-532,-171.5}},
                                          color={118,106,98}));
  connect(triple36.steamSignal,rh1. inletBundle) annotation (Line(points={{-398,180},{-520.6,180}},
                                      color={0,131,169}));
  connect(split1_3.outlet_1,valve_cutPressure2. inlet) annotation (Line(points={{-324.5,-277},{-339.5,-277}},
                                                                                                    color={0,131,169}));
  connect(inj_rh1.inlet_1,rh1. outletBundle) annotation (Line(points={{-467,170.5},{-467,176},{-520.6,176}},
                                 color={0,131,169}));
  connect(inj_rh1.outlet,rh2. inletBundle) annotation (Line(points={{-467,159.5},{-467,78},{-520.6,78}},
                                 color={0,131,169}));
  connect(eco_riser.inlet, valve_cutPressure2.outlet) annotation (Line(points={{-353,-240.5},{-353,-277},{-350.5,-277}}, color={0,131,169}));
  connect(valve_cutPressure2.inlet,triple46. steamSignal) annotation (Line(points={{-339.5,-277},{-336,-277},{-336,-253}},
                                                                                                    color={0,131,169}));
  connect(split1_3.outlet_2,triple45. steamSignal) annotation (Line(points={{-319,-271.5},{-319,-191}},
                                                                                                 color={0,131,169}));
  connect(split1_1.outlet_2,fixedFlow1. inlet) annotation (Line(points={{-218,-271.5},{-218,-39},{-333.5,-39}},
                                                                                                    color={0,131,169}));
  connect(inj_hp1.inlet_2,valve_dp_nom3_1. outlet) annotation (Line(points={{-427.5,-39},{-380.5,-39}},
                                                                                                    color={0,131,169}));
  connect(valve_dp_nom3_1.inlet,fixedFlow1. outlet) annotation (Line(points={{-369.5,-39},{-344.5,-39}},
                                                                                                    color={0,131,169}));
  connect(inj_hp2.outlet,sh4. inletBundle) annotation (Line(points={{-501,50.5},{-501,32},{-520.6,32}},
                                  color={0,131,169}));
  connect(sh3.outletBundle,inj_hp2. inlet_1) annotation (Line(points={{-520.6,124},{-501,124},{-501,61.5}},
                                       color={0,131,169}));
  connect(sh3.outletBundle,triple51. steamSignal) annotation (Line(points={{-520.6,124},{-501,124},{-501,109}},
                                     color={0,131,169}));
  connect(valve_cutPressure.inlet,split1_1. outlet_1) annotation (Line(points={{-233.5,-277},{-223.5,-277}},         color={0,131,169}));
  connect(valve_cutPressure.inlet,triple50. steamSignal) annotation (Line(points={{-233.5,-277},{-232,-277},{-232,-251}},
                                                                                                    color={0,131,169}));
  connect(split1_1.outlet_2, triple47.steamSignal) annotation (Line(points={{-218,-271.5},{-218,-195}}, color={0,131,169}));
  connect(fixedFlow.outlet,evap_rad.inletWall)  annotation (Line(points={{-500,-159.55},{-500,-156},{-518.6,-156}},
                                                                                                           color={0,131,169}));
  connect(sh4.outletWall,rh2.inletWall)  annotation (Line(points={{-520.6,36},{-512,36},{-512,70},{-520.6,70}}, color={0,131,169}));
  connect(rh2.outletWall,sh3.inletWall)  annotation (Line(points={{-520.6,82},{-516,82},{-516,120},{-520.6,120}},         color={0,131,169}));
  connect(sh3.outletWall,rh1.inletWall)  annotation (Line(points={{-520.6,132},{-516,132},{-516,172},{-520.6,172}},
                                                                                                                color={0,131,169}));
  connect(rh1.outletWall,eco.inletWall)  annotation (Line(points={{-520.6,184},{-516,184},{-516,232},{-522.6,232}},       color={0,131,169}));
  connect(triple52.steamSignal,eco.inletWall)  annotation (Line(points={{-647,207},{-516,207},{-516,232},{-522.6,232}},
                                                                                                                     color={0,131,169}));
  connect(triple53.steamSignal,rh1.inletWall)  annotation (Line(points={{-649,157},{-516,157},{-516,172},{-520.6,172}},        color={0,131,169}));
  connect(triple54.steamSignal,sh3.inletWall)  annotation (Line(points={{-649,97},{-516,97},{-516,120},{-520.6,120}},color={0,131,169}));
  connect(triple55.steamSignal,rh2.inletWall)  annotation (Line(points={{-649,53},{-512,53},{-512,70},{-520.6,70}},  color={0,131,169}));
  connect(triple56.steamSignal, sh2.inletWall) annotation (Line(points={{-651,-41},{-582,-41},{-582,-42},{-514,-42},{-514,-22},{-520.6,-22}}, color={0,131,169}));
  connect(triple57.steamSignal,sh1.inletWall)  annotation (Line(points={{-492,-143},{-492,-144},{-504,-144},{-504,-144},{-512,-144},{-512,-72},{-518.6,-72}},
                                                                                                                         color={0,131,169}));
  connect(triple58.steamSignal,eco.outletWall)  annotation (Line(points={{-493,260},{-492,260},{-492,244},{-522.6,244}},
                                                                                                          color={0,131,169}));
  connect(valve_dp_nom3_2.inlet,fixedFlow3. outlet) annotation (Line(points={{-445.5,56},{-436.5,56}},
                                                                                                     color={0,131,169}));
  connect(valve_dp_nom3_2.outlet,inj_hp2. inlet_2) annotation (Line(points={{-456.5,56},{-495.5,56}},
                                                                                                    color={0,131,169}));
  connect(fixedFlow2.outlet,valve_dp_nom3_3. inlet) annotation (Line(points={{-438.5,165},{-447.5,165}},        color={0,131,169}));
  connect(valve_dp_nom3_3.outlet,inj_rh1. inlet_2) annotation (Line(points={{-458.5,165},{-461.5,165}},        color={0,131,169}));
  connect(triple59.steamSignal,valve_cutPressure2. outlet) annotation (Line(points={{-384,-277},{-350.5,-277}},
                                                                                                    color={0,131,169}));
  connect(eco_down.outlet, brnr1.inletWall) annotation (Line(points={{-473,-300.5},{-473,-320},{-517.6,-320}}, color={0,131,169}));
  connect(eco_down.inlet, eco.outletBundle) annotation (Line(points={{-473,-279.5},{-473,236},{-522.6,236}}, color={0,131,169}));
  connect(eco_down.inlet, triple60.steamSignal) annotation (Line(points={{-473,-279.5},{-473,-268}}, color={0,131,169}));
  connect(valve_cutPressure.outlet,split1_3. inlet) annotation (Line(points={{-244.5,-277},{-313.5,-277}},       color={0,131,169}));
  connect(triple49.steamSignal, split1_3.inlet) annotation (Line(points={{-294,-247},{-294,-277},{-313.5,-277}}, color={0,131,169}));
  connect(fixedFlow2.inlet, triple48.steamSignal) annotation (Line(points={{-427.5,165},{-257,165}}, color={0,131,169}));
  connect(fixedFlow3.inlet,split1_3. outlet_2) annotation (Line(points={{-425.5,56},{-319,56},{-319,-271.5}},
                                                                                                    color={0,131,169}));
  connect(triple61.steamSignal,inj_hp1. outlet) annotation (Line(points={{-425,-4},{-425,-18},{-433,-18},{-433,-33.5}},
                                                                                                        color={0,131,169}));
  connect(inj_hp1.inlet_2, triple63.steamSignal) annotation (Line(points={{-427.5,-39},{-426.25,-39},{-426.25,-38},{-419,-38}}, color={0,131,169}));
  connect(fixedFlow1.inlet,triple64. steamSignal) annotation (Line(points={{-333.5,-39},{-329,-39}},           color={0,131,169}));
  connect(triple66.steamSignal, sh2.outletWall) annotation (Line(points={{-653,1},{-614,1},{-614,-10},{-520.6,-10}}, color={0,131,169}));
  connect(evap_rad.outletWall, sh1.inletWall) annotation (Line(points={{-518.6,-144},{-512,-144},{-512,-72},{-518.6,-72}}, color={0,131,169}));
  connect(sh2.outletWall, sh4.inletWall) annotation (Line(points={{-520.6,-10},{-514,-10},{-514,24},{-520.6,24}}, color={0,131,169}));
  connect(sh1.outletWall, sh2.inletWall) annotation (Line(points={{-518.6,-60},{-514,-60},{-514,-22},{-520.6,-22}}, color={0,131,169}));
  connect(triple41.steamSignal, sh1.outletBundle) annotation (Line(points={{-486,-81},{-486,-68},{-518.6,-68}}, color={0,131,169}));
  connect(sh1.outletBundle, inj_hp1.inlet_1) annotation (Line(points={{-518.6,-68},{-433,-68},{-433,-44.5}}, color={0,131,169}));
  connect(inj_hp1.outlet, sh2.inletBundle) annotation (Line(points={{-433,-33.5},{-433,-14},{-520.6,-14}}, color={0,131,169}));
  connect(sh2.outletBundle, sh3.inletBundle) annotation (Line(points={{-520.6,-18},{-508,-18},{-508,128},{-520.6,128}}, color={0,131,169}));
  connect(evap_rad.outletGas, ct.inletGas) annotation (Line(points={{-533,-139.6},{-533,-116.4}}, color={118,106,98}));
  connect(ct.outletGas, sh1.inletGas) annotation (Line(points={{-533,-95.6},{-533,-76.4}}, color={118,106,98}));
  connect(tripleFlueGas16.gasSignal, ct.inletGas) annotation (Line(points={{-571,-127},{-533,-127},{-533,-116.4}}, color={118,106,98}));
  connect(eco.outletWall, ct.inletWall) annotation (Line(points={{-522.6,244},{-414,244},{-414,-112},{-518.6,-112}}, color={0,131,169}));
  connect(ct.outletWall, sh1.inletBundle) annotation (Line(points={{-518.6,-100},{-504,-100},{-504,-64},{-518.6,-64}}, color={0,131,169}));
  connect(split1_1.inlet, valve_cutPressure1.outlet) annotation (Line(points={{-212.5,-277},{-204.25,-277},{-204.25,-277},{-196.5,-277}}, color={0,131,169}));
  connect(valve_cutPressure1.inlet, split1_2.outlet_1) annotation (Line(points={{-185.5,-277},{-173.75,-277},{-173.75,-277},{-161.5,-277}}, color={0,131,169}));
  connect(split1_2.outlet_2, fixedFlow2.inlet) annotation (Line(points={{-156,-271.5},{-156,165},{-427.5,165}}, color={0,131,169}));
  connect(rh2.outletBundle, rh2_down.inlet) annotation (Line(points={{-520.6,74},{-254.5,74}}, color={0,131,169}));
  connect(triple65.steamSignal, rh2_down.inlet) annotation (Line(points={{-265,90},{-266,90},{-266,74},{-254.5,74}}, color={0,131,169}));
  connect(rh1_riser.outlet, rh1.inletBundle) annotation (Line(points={{-253.5,-116},{-292,-116},{-292,180},{-520.6,180}}, color={0,131,169}));
  connect(sh4_down.outlet, Turbine_HP.inlet) annotation (Line(points={{-231.5,28},{-200,28},{-200,54},{-56.5,54}}, color={0,131,169}));
  connect(triple3.steamSignal, Turbine_HP.inlet) annotation (Line(points={{-70.375,59.9286},{-63.1875,59.9286},{-63.1875,54},{-56.5,54}}, color={0,131,169}));
  connect(rh2_down.outlet, Turbine_IP1.inlet) annotation (Line(points={{-233.5,74},{-34,74},{-34,54},{-26.5,54}}, color={0,131,169}));
  connect(triple2.steamSignal, Turbine_IP1.inlet) annotation (Line(points={{-52.375,77.9286},{-52.375,74},{-34,74},{-34,54},{-26.5,54}}, color={0,131,169}));
  connect(split1_2.inlet, preheater_HP.cond_out) annotation (Line(points={{-150.5,-277},{-124,-277},{-124,-22},{-76,-22},{-76,-23.5}}, color={0,131,169}));
  connect(rh1_riser.inlet, valve_cut.outlet) annotation (Line(points={{-232.5,-116},{-176,-116},{-176,11},{-69.55,11}}, color={0,131,169}));
  connect(dispatcher.fuelSignal_black[1], brnr1.inletFuel) annotation (Line(points={{-625.6,-230.75},{-626,-230.75},{-626,-314},{-538.4,-314}}, color={27,36,42}));
  connect(dispatcher.fuelSignal_black[2], brnr2.inletFuel) annotation (Line(points={{-625.6,-230.25},{-620,-230.25},{-620,-278},{-538.4,-278}}, color={27,36,42}));
  connect(dispatcher.fuelSignal_black[3], brnr3.inletFuel) annotation (Line(points={{-625.6,-229.75},{-614,-229.75},{-614,-228},{-538.4,-228}}, color={27,36,42}));
  connect(dispatcher.fuelSignal_black[4], brnr4.inletFuel) annotation (Line(points={{-625.6,-229.25},{-626,-229.25},{-626,-182},{-538.4,-182}}, color={27,36,42}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-660,-380},{380,280}})), Icon(coordinateSystem(initialScale=0.1)));
end InitSteamPowerPlant_01;
