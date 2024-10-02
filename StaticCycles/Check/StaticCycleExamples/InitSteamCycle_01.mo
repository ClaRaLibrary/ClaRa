within ClaRa.StaticCycles.Check.StaticCycleExamples;
model InitSteamCycle_01
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

  HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{340,-20},{360,0}})));
  Machines.Pump1 Pump_cond(efficiency=efficiency_Pump_cond) annotation (Placement(transformation(extent={{338,-70},{318,-50}})));
  HeatExchanger.Preheater1 preheater_LP1(p_tap_nom=preheater_LP1_p_tap, m_flow_tap_nom=preheater_LP1_m_flow_tap) annotation (Placement(transformation(extent={{130,-70},{110,-50}})));
  Machines.Pump1 pump_preheater_LP1(efficiency=efficiency_Pump_preheater_LP1) annotation (Placement(transformation(extent={{108,-92},{88,-72}})));
  ValvesConnects.Valve_dp_nom3 valvePreFeedWaterTank(Delta_p_nom=valvePreFeedWaterTank_Delta_p_nom) annotation (Placement(transformation(extent={{102,-63},{92,-57}})));
  Storage.Feedwatertank4 feedwatertank(m_flow_nom=m_flow_nom*P_target_, p_FWT_nom=p_FWT) annotation (Placement(transformation(extent={{45,-64},{25,-52}})));
  Fittings.Mixer1 join_LP_main annotation (Placement(transformation(extent={{74,-65},{64,-59}})));
  Machines.Pump1 Pump_FW(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{-40,-100},{-60,-80}})));
  HeatExchanger.Preheater1 preheater_HP(m_flow_tap_nom=preheater_HP_m_flow_tap, p_tap_nom=preheater_HP_p_tap) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-76,-20})));
  Furnace.Boiler_simple boiler(
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    Delta_p_LS_nom=Delta_p_LS_nom,
    Delta_p_RS_nom=Delta_p_RS_nom,
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_Delta_p_HP_mLS_,
    CharLine_Delta_p_IP_mRS_=CharLine_Delta_p_IP_mRS_,
    m_flow_LS_nom=m_flow_nom,
    m_flow_RS_nom=m_flow_nom) annotation (Placement(transformation(extent={{-86,18},{-66,38}})));
  Machines.Turbine Turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-56,40},{-44,60}})));
  Fittings.Split1 join_HP annotation (Placement(transformation(extent={{-40,-2},{-50,4}})));
  ValvesConnects.Valve_dp_nom1 valve_HP(Delta_p_nom=valve_HP_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-45,-11})));
  ValvesConnects.Valve_cutPressure1 valve_cut annotation (Placement(transformation(
        extent={{-5.5,-3},{5.5,3}},
        rotation=180,
        origin={-61.5,3})));
  ValvesConnects.Valve_cutPressure1 valve2_HP annotation (Placement(transformation(extent={{-52,-44},{-42,-38}})));
  Machines.Turbine Turbine_IP1(efficiency=efficiency_Turb_IP1)
                                                              annotation (Placement(transformation(extent={{-26,40},{-14,60}})));
  Machines.Turbine Turbine_LP1(efficiency=efficiency_Turb_LP1) annotation (Placement(transformation(extent={{124,40},{136,60}})));
  Fittings.Split1 split_LP1 annotation (Placement(transformation(extent={{146,37},{156,43}})));
  ValvesConnects.Valve_cutPressure2 valve_IP1 annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={35,11})));
  ValvesConnects.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={151,11})));
  Machines.Turbine Turbine_LP4(efficiency=efficiency_Turb_LP4) annotation (Placement(transformation(extent={{244,40},{256,60}})));
  Triple triple annotation (Placement(transformation(extent={{-40,34},{-28,44}})));
  Triple triple1 annotation (Placement(transformation(extent={{0,50},{12,60}})));
  Triple triple2 annotation (Placement(transformation(extent={{-92,48},{-80,58}})));
  Triple triple3 annotation (Placement(transformation(extent={{-70,44},{-58,54}})));
  Triple triple5 annotation (Placement(transformation(extent={{146,50},{158,60}})));
  Triple triple6(decimalSpaces(p=2))
                 annotation (Placement(transformation(extent={{292,48},{304,58}})));
  Triple triple7 annotation (Placement(transformation(extent={{144,-14},{156,-4}})));
  Triple triple8 annotation (Placement(transformation(extent={{-38,-40},{-26,-30}})));
  Triple triple9(decimalSpaces(p=2))
                 annotation (Placement(transformation(extent={{360,-34},{372,-24}})));
  Triple triple10 annotation (Placement(transformation(extent={{-34,-76},{-22,-66}})));
  Triple triple11 annotation (Placement(transformation(extent={{60,-50},{72,-40}})));
  Triple triple12 annotation (Placement(transformation(extent={{-82,-108},{-70,-98}})));
  Triple triple13 annotation (Placement(transformation(extent={{-72,-8},{-60,2}})));
  Triple triple15
                 annotation (Placement(transformation(extent={{-30,-12},{-18,-2}})));
  Triple triple16
                 annotation (Placement(transformation(extent={{-102,-16},{-90,-6}})));
  Triple triple17
                 annotation (Placement(transformation(extent={{126,-86},{138,-76}})));
  Triple triple18
                 annotation (Placement(transformation(extent={{106,-50},{118,-40}})));
  Triple triple19
                 annotation (Placement(transformation(extent={{330,-90},{342,-80}})));
  Triple triple20
                 annotation (Placement(transformation(extent={{26,-12},{38,-2}})));
  Machines.Turbine Turbine_IP2(efficiency=efficiency_Turb_IP2)
                                                              annotation (Placement(transformation(extent={{10,40},{22,60}})));
  Machines.Turbine Turbine_IP3(efficiency=efficiency_Turb_IP3)
                                                              annotation (Placement(transformation(extent={{46,40},{58,60}})));
  Fittings.Split2 splitIP2(p_nom=IP2_pressure)        annotation (Placement(transformation(extent={{30,37},{40,43}})));
  Fittings.Split2 splitIP3(p_nom=IP3_pressure)        annotation (Placement(transformation(extent={{68,37},{78,43}})));
  ValvesConnects.PressureAnchor_constFlow1 pressureAnchor_constFlow1_1(p_nom=IP1_pressure)
                                                                       annotation (Placement(transformation(extent={{-5,39},{5,45}})));
  Machines.Turbine Turbine_LP3(efficiency=efficiency_Turb_LP3) annotation (Placement(transformation(extent={{204,40},{216,60}})));
  Machines.Turbine Turbine_LP2(efficiency=efficiency_Turb_LP2) annotation (Placement(transformation(extent={{164,40},{176,60}})));
  ValvesConnects.Valve_cutPressure1                    valve2 annotation (Placement(transformation(
        extent={{-4.5,2.5},{4.5,-2.5}},
        rotation=0,
        origin={179.5,-83.5})));
  Fittings.Mixer3                    mixerIP2 annotation (Placement(transformation(extent={{208,-14},{218,-20}})));
  HeatExchanger.Preheater1 preheater_LP2(p_tap_nom=preheater_LP2_p_tap, m_flow_tap_nom=preheater_LP2_m_flow_tap) annotation (Placement(transformation(extent={{180,-70},{160,-50}})));
  HeatExchanger.Preheater1 preheater_LP3(p_tap_nom=preheater_LP3_p_tap, m_flow_tap_nom=preheater_LP3_m_flow_tap + preheater_LP2_m_flow_tap)
                                                                                                                 annotation (Placement(transformation(extent={{240,-70},{220,-50}})));
  HeatExchanger.Preheater1 preheater_LP4(p_tap_nom=preheater_LP4_p_tap, m_flow_tap_nom=preheater_LP4_m_flow_tap) annotation (Placement(transformation(extent={{290,-70},{270,-50}})));
  ValvesConnects.Valve_cutPressure2 valve_IP2
                                             annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={73,11})));
  Fittings.Split1 split_LP2 annotation (Placement(transformation(extent={{186,37},{196,43}})));
  Fittings.Split1 split_LP3 annotation (Placement(transformation(extent={{226,37},{236,43}})));
  ValvesConnects.Valve_dp_nom1 valve_LP2(Delta_p_nom=valve_LP2_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={191,11})));
  ValvesConnects.Valve_dp_nom1 valve_LP3(Delta_p_nom=valve_LP3_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={231,11})));
  Machines.Pump1                    pump_preheater_LP3(efficiency=efficiency_Pump_preheater_LP3) annotation (Placement(transformation(extent={{226,-100},{206,-80}})));
  Fittings.Mixer1 join_preheater_LP3 annotation (Placement(transformation(extent={{205,-65},{195,-59}})));
  ValvesConnects.Valve_cutPressure1 valve_cutPressureLP4 annotation (Placement(transformation(extent={{324,-103},{334,-97}})));
  Fittings.Mixer2 mixer_condenser annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={352,-40})));
  Triple triple4 annotation (Placement(transformation(extent={{66,-12},{78,-2}})));
  Triple triple14
                 annotation (Placement(transformation(extent={{150,-50},{162,-40}})));
  Triple triple21
                 annotation (Placement(transformation(extent={{212,-50},{224,-40}})));
  Triple triple22
                 annotation (Placement(transformation(extent={{186,-14},{198,-4}})));
  Triple triple23
                 annotation (Placement(transformation(extent={{228,-14},{240,-4}})));
  Triple triple24
                 annotation (Placement(transformation(extent={{256,-50},{268,-40}})));
  Triple triple25(decimalSpaces(p=2))
                 annotation (Placement(transformation(extent={{228,50},{240,60}})));
  Triple triple26(decimalSpaces(p=2))
                 annotation (Placement(transformation(extent={{188,50},{200,60}})));
  Triple triple27
                 annotation (Placement(transformation(extent={{32,50},{44,60}})));
  Triple triple28
                 annotation (Placement(transformation(extent={{70,50},{82,60}})));
  Triple triple29
                 annotation (Placement(transformation(extent={{204,-84},{216,-74}})));
  Triple triple30
                 annotation (Placement(transformation(extent={{190,-87},{202,-77}})));
  Triple triple31(decimalSpaces(p=2))
                 annotation (Placement(transformation(extent={{342,-98},{354,-88}})));
  ValvesConnects.Tube2 downComer_feedWaterTank(
    z_in=downComer_z_in,
    Delta_p_nom=downComer_Delta_p_nom,
    z_out=downComer_z_out)                     annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=270,
        origin={-10,-76})));
  Triple triple32
                 annotation (Placement(transformation(extent={{-68,8},{-56,18}})));
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
      points={{-76,-30.5},{-76,-90},{-60.5,-90}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.liveSteam, Turbine_HP.inlet) annotation (Line(
      points={{-76,38.4},{-76,54},{-56.5,54}},
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
      points={{-45,-16.5},{-45,-20},{-65.5,-20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_cut.inlet, join_HP.outlet_1) annotation (Line(
      points={{-55.45,3},{-50.5,3}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2_HP.inlet, preheater_HP.tap_out) annotation (Line(
      points={{-52.5,-41},{-94,-41},{-94,-20},{-86.5,-20}},
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
  connect(triple2.steamSignal, boiler.liveSteam) annotation (Line(
      points={{-92.375,51.9286},{-84,51.9286},{-84,38.4},{-76,38.4}},
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
      points={{-72.375,-4.07143},{-74,-4.07143},{-74,-9.5},{-76,-9.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple15.steamSignal, join_HP.outlet_2) annotation (Line(
      points={{-30.375,-8.07143},{-38,-8.07143},{-38,-2.5},{-45,-2.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple16.steamSignal, preheater_HP.tap_out) annotation (Line(
      points={{-102.375,-12.0714},{-104,-12.0714},{-104,-20},{-86.5,-20}},
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
      points={{-41.5,-41},{31,-41},{31,-51.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple8.steamSignal, valve2_HP.outlet) annotation (Line(
      points={{-38.375,-36.0714},{-24.1875,-36.0714},{-24.1875,-41},{-41.5,-41}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.hotReheat, Turbine_IP1.inlet) annotation (Line(points={{-70,38.4},{-70,72},{-34,72},{-34,54},{-26.5,54}},
                                                                                                         color={0,131,169}));
  connect(boiler.hotReheat, triple3.steamSignal) annotation (Line(points={{-70,38.4},{-70,47.9286},{-70.375,47.9286}}, color={0,131,169}));
  connect(valve_cut.outlet, boiler.coldReheat) annotation (Line(points={{-67.55,3},{-72,3},{-72,17.6}}, color={0,131,169}));
  connect(preheater_HP.cond_out, boiler.feedWater) annotation (Line(points={{-76,-9.5},{-76,17.6}}, color={0,131,169}));
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
  connect(valve_cut.outlet, triple32.steamSignal) annotation (Line(points={{-67.55,3},{-67.55,6.5},{-68.375,6.5},{-68.375,11.9286}}, color={0,131,169}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{380,100}})), Icon(coordinateSystem(initialScale=0.1)));
end InitSteamCycle_01;
