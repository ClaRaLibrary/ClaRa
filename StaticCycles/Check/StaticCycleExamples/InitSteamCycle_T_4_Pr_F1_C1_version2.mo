within ClaRa.StaticCycles.Check.StaticCycleExamples;
model InitSteamCycle_T_4_Pr_F1_C1_version2
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
  extends ClaRa.Basics.Icons.Init;
  import TILMedia.VLEFluid.MixtureCompatible.Functions.*;
  import SI = ClaRa.Basics.Units;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component" annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"), Dialog(group="Fundamental Definitions"));
  parameter Basics.Units.MassFlowRate m_flow_nom=416;
  inner parameter Real P_target_=1;
  // Heat Exchangers
  parameter Basics.Units.Pressure p_condenser=3800 annotation (Dialog(tab="Heat exchangers", group="Condenser"));
  parameter Basics.Units.Pressure preheater_HP_p_tap=55.95e5 annotation (Dialog(tab="Heat exchangers", group="Preheater HP"));
  parameter Basics.Units.MassFlowRate preheater_HP_m_flow_tap=42.812 annotation (Dialog(tab="Heat exchangers", group="Preheater HP"));
  parameter Basics.Units.Pressure preheater_LP1_p_tap=0.207e5 annotation (Dialog(tab="Heat exchangers", group="Preheater LP1"));
  parameter Basics.Units.MassFlowRate preheater_LP1_m_flow_tap=14.5 annotation (Dialog(tab="Heat exchangers", group="Preheater LP1"));
  // Feedwater tank
  parameter Basics.Units.Pressure p_FWT=12.81e5 annotation (Dialog(tab="Heat exchangers", group="Feedwater tank"));
  // Valves
  parameter Basics.Units.PressureDifference valve1_HP_Delta_p_nom=4e5 annotation (Dialog(group="Valve1_HP", tab="Valves"));
//  parameter SI.PressureDifference valve_IP_m_flow_nom= (m_flow_nom - preheater_HP_m_flow_tap)/10 annotation(Dialog(group="Valve_IP",tab="Valves"));

  parameter Basics.Units.PressureDifference valve_LP1_Delta_p_nom=0.001e5 annotation (Dialog(group="Valve_LP1", tab="Valves"));
  parameter Basics.Units.PressureDifference valve_LP2_Delta_p_nom=0.001e5 annotation (Dialog(group="Valve_LP2", tab="Valves"));
  // Boiler
  parameter Basics.Units.Temperature T_LS_nom=823 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Temperature T_RS_nom=833 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure p_LS_out_nom=250.2e5 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure p_RS_out_nom=51e5 annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.PressureDifference Delta_p_LS_nom=89e5 annotation (Dialog(tab="Boiler"));
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
  parameter Real efficiency_Pump_FW=1 annotation(Dialog(tab="Pumps"));
  // Turbines
  parameter Basics.Units.Pressure tapping_IP_pressure=15e5 annotation (Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_HP=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_IP=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP1=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP2=1 annotation(Dialog(tab="Turbines"));

  HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{74,-20},{94,0}})));
  Machines.Pump1 Pump_cond(efficiency=efficiency_Pump_cond) annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  HeatExchanger.Preheater1 preheater_LP1(p_tap_nom=preheater_LP1_p_tap, m_flow_tap_nom=preheater_LP1_m_flow_tap) annotation (Placement(transformation(extent={{54,-70},{34,-50}})));
  Machines.Pump1 Pump_preheater_LP1(efficiency=efficiency_Pump_preheater_LP1) annotation (Placement(transformation(extent={{34,-90},{14,-70}})));
  ValvesConnects.Valve_dp_nom3 valve_LP2(Delta_p_nom=valve_LP2_Delta_p_nom) annotation (Placement(transformation(extent={{24,-63},{14,-57}})));
  Storage.Feedwatertank4 feedwatertank(m_flow_nom=m_flow_nom*P_target_, p_FWT_nom=p_FWT) annotation (Placement(transformation(extent={{-11,-64},{-31,-52}})));
  Fittings.Mixer1 join_LP_main annotation (Placement(transformation(extent={{8,-65},{-2,-59}})));
  Machines.Pump1 Pump_FW(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{-40,-70},{-60,-50}})));
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
  Machines.Turbine Turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-56,30},{-44,50}})));
  Fittings.Split1 join_HP annotation (Placement(transformation(extent={{-40,-2},{-50,4}})));
  ValvesConnects.Valve_dp_nom1 valve1_HP(Delta_p_nom=valve1_HP_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-45,-11})));
  ValvesConnects.Valve_cutPressure1 valve_cut annotation (Placement(transformation(
        extent={{-5.5,-3},{5.5,3}},
        rotation=180,
        origin={-61.5,3})));
  ValvesConnects.Valve_cutPressure1 valve2_HP annotation (Placement(transformation(extent={{-52,-44},{-42,-38}})));
  Machines.Turbine Turbine_IP(efficiency=efficiency_Turb_IP) annotation (Placement(transformation(extent={{-26,42},{-14,62}})));
  Fittings.Split2 split1(p_nom=tapping_IP_pressure) annotation (Placement(transformation(extent={{-2,38},{8,44}})));
  Machines.Turbine Turbine_LP1(efficiency=efficiency_Turb_LP1) annotation (Placement(transformation(extent={{20,30},{32,50}})));
  Fittings.Split1 split2 annotation (Placement(transformation(extent={{40,26},{50,32}})));
  ValvesConnects.Valve_cutPressure2 valve_IP annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={3,-11})));
  ValvesConnects.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={45,-11})));
  Machines.Turbine Turbine_LP2(efficiency=efficiency_Turb_LP2) annotation (Placement(transformation(extent={{60,16},{72,36}})));
  Triple triple annotation (Placement(transformation(extent={{-40,34},{-28,44}})));
  Triple triple1 annotation (Placement(transformation(extent={{-8,46},{4,56}})));
  Triple triple2 annotation (Placement(transformation(extent={{-92,48},{-80,58}})));
  Triple triple3 annotation (Placement(transformation(extent={{-70,44},{-58,54}})));
  Triple triple4 annotation (Placement(transformation(extent={{12,22},{24,32}})));
  Triple triple5 annotation (Placement(transformation(extent={{38,46},{50,56}})));
  Triple triple6(decimalSpaces(p=2))
                 annotation (Placement(transformation(extent={{76,24},{88,34}})));
  Triple triple7 annotation (Placement(transformation(extent={{54,-26},{66,-16}})));
  Triple triple8 annotation (Placement(transformation(extent={{-38,-40},{-26,-30}})));
  Triple triple9(decimalSpaces(p=2))
                 annotation (Placement(transformation(extent={{94,-60},{106,-50}})));
  Triple triple10 annotation (Placement(transformation(extent={{-34,-80},{-22,-70}})));
  Triple triple11 annotation (Placement(transformation(extent={{6,-56},{18,-46}})));
  Triple triple12 annotation (Placement(transformation(extent={{-82,-78},{-70,-68}})));
  Triple triple13 annotation (Placement(transformation(extent={{-72,-8},{-60,2}})));
  Triple triple14
                 annotation (Placement(transformation(extent={{56,-48},{68,-38}})));
  Triple triple15
                 annotation (Placement(transformation(extent={{-30,-12},{-18,-2}})));
  Triple triple16
                 annotation (Placement(transformation(extent={{-102,-16},{-90,-6}})));
  Triple triple17
                 annotation (Placement(transformation(extent={{56,-96},{68,-86}})));
  Triple triple18
                 annotation (Placement(transformation(extent={{30,-46},{42,-36}})));
  Triple triple19
                 annotation (Placement(transformation(extent={{66,-86},{78,-76}})));
  Triple triple20
                 annotation (Placement(transformation(extent={{8,-26},{20,-16}})));
equation
  connect(condenser.outlet, Pump_cond.inlet) annotation (Line(
      points={{84,-20.5},{84,-60},{80.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{34.5,-80},{44,-80},{44,-70.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.outlet, join_LP_main.inlet_2) annotation (Line(
      points={{13.5,-80},{3,-80},{3,-65.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(join_LP_main.outlet, feedwatertank.cond_in) annotation (Line(
      points={{-2.5,-60},{-10.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_FW.inlet, feedwatertank.cond_out) annotation (Line(
      points={{-39.5,-60},{-31.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP.cond_in, Pump_FW.outlet) annotation (Line(
      points={{-76,-30.5},{-76,-60},{-60.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.liveSteam, Turbine_HP.inlet) annotation (Line(
      points={{-76,38.4},{-76,44},{-56.5,44}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_HP.outlet, join_HP.inlet) annotation (Line(
      points={{-43.5,32},{-28,32},{-28,3},{-39.5,3}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1_HP.inlet, join_HP.outlet_2) annotation (Line(
      points={{-45,-5.5},{-45,-2.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1_HP.outlet, preheater_HP.tap_in) annotation (Line(
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
  connect(split1.inlet, Turbine_IP.outlet) annotation (Line(
      points={{-2.5,43},{-13.5,43},{-13.5,44}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP1.inlet, split1.outlet_1) annotation (Line(
      points={{19.5,44},{20,44},{20,43},{8.5,43}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP1.outlet, split2.inlet) annotation (Line(
      points={{32.5,32},{38,32},{38,31},{39.5,31}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP.inlet, split1.outlet_2) annotation (Line(
      points={{3,-5.5},{3,37.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split2.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{45,25.5},{45,-5.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP1.outlet, preheater_LP1.tap_in) annotation (Line(
      points={{45,-16.5},{44,-16.5},{44,-49.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP2.inlet, split2.outlet_1) annotation (Line(
      points={{59.5,30},{50.5,30},{50.5,31}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP2.outlet, condenser.inlet) annotation (Line(
      points={{72.5,18},{84,18},{84,0.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP2.outlet, join_LP_main.inlet_1) annotation (Line(
      points={{13.5,-60},{8.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, valve_LP2.inlet) annotation (Line(
      points={{33.5,-60},{24.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, Pump_cond.outlet) annotation (Line(
      points={{54.5,-60},{59.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple.steamSignal, Turbine_HP.outlet) annotation (Line(
      points={{-40.375,37.9286},{-42,37.9286},{-42,32},{-43.5,32}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple1.steamSignal, Turbine_IP.outlet) annotation (Line(
      points={{-8.375,49.9286},{-12,49.9286},{-12,44},{-13.5,44}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple2.steamSignal, boiler.liveSteam) annotation (Line(
      points={{-92.375,51.9286},{-84,51.9286},{-84,38.4},{-76,38.4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple4.steamSignal, split1.outlet_2) annotation (Line(
      points={{11.625,25.9286},{10,25.9286},{10,26},{3,26},{3,37.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple5.steamSignal, Turbine_LP1.outlet) annotation (Line(
      points={{37.625,49.9286},{36,49.9286},{36,32},{32.5,32}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple6.steamSignal, Turbine_LP2.outlet) annotation (Line(
      points={{75.625,27.9286},{74,27.9286},{74,18},{72.5,18}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple7.steamSignal, valve_LP1.outlet) annotation (Line(
      points={{53.625,-22.0714},{50,-22.0714},{50,-16.5},{45,-16.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple9.steamSignal, Pump_cond.inlet) annotation (Line(
      points={{93.625,-56.0714},{88,-56.0714},{88,-60},{80.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple10.steamSignal, Pump_FW.inlet) annotation (Line(
      points={{-34.375,-76.0714},{-38,-76.0714},{-38,-60},{-39.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple11.steamSignal, feedwatertank.cond_in) annotation (Line(
      points={{5.625,-52.0714},{-2,-52.0714},{-2,-60},{-10.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple12.steamSignal, Pump_FW.outlet) annotation (Line(
      points={{-82.375,-74.0714},{-72,-74.0714},{-72,-60},{-60.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple13.steamSignal, preheater_HP.cond_out) annotation (Line(
      points={{-72.375,-4.07143},{-74,-4.07143},{-74,-9.5},{-76,-9.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple14.steamSignal, preheater_LP1.tap_in) annotation (Line(
      points={{55.625,-44.0714},{52,-44.0714},{52,-49.5},{44,-49.5}},
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
      points={{55.625,-92.0714},{52,-92.0714},{52,-92},{44,-92},{44,-70.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple18.steamSignal, preheater_LP1.cond_out) annotation (Line(
      points={{29.625,-42.0714},{29.625,-60},{33.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple19.steamSignal, Pump_cond.outlet) annotation (Line(
      points={{65.625,-82.0714},{64,-82.0714},{64,-82},{59.5,-82},{59.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple20.steamSignal, valve_IP.outlet) annotation (Line(
      points={{7.625,-22.0714},{7.625,-19.0357},{3,-19.0357},{3,-16.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP.outlet, feedwatertank.tap_in2) annotation (Line(
      points={{3,-16.5},{3,-28},{-21,-28},{-21,-51.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2_HP.outlet, feedwatertank.tap_in1) annotation (Line(
      points={{-41.5,-41},{-25,-41},{-25,-51.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple8.steamSignal, valve2_HP.outlet) annotation (Line(
      points={{-38.375,-36.0714},{-24.1875,-36.0714},{-24.1875,-41},{-41.5,-41}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.hotReheat, Turbine_IP.inlet) annotation (Line(points={{-70,38.4},{-70,56},{-26.5,56}}, color={0,131,169}));
  connect(boiler.hotReheat, triple3.steamSignal) annotation (Line(points={{-70,38.4},{-70,47.9286},{-70.375,47.9286}}, color={0,131,169}));
  connect(valve_cut.outlet, boiler.coldReheat) annotation (Line(points={{-67.55,3},{-72,3},{-72,17.6}}, color={0,131,169}));
  connect(preheater_HP.cond_out, boiler.feedWater) annotation (Line(points={{-76,-9.5},{-76,17.6}}, color={0,131,169}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end InitSteamCycle_T_4_Pr_F1_C1_version2;
