within ClaRa.StaticCycles.Machines.Check;
model TestTurbineDrivenPump
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  inner parameter Real P_target_ = 1;
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  Pump1_mech pump1 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,50})));
  Turbine_mech2 SPAT1 annotation (Placement(transformation(extent={{-36,40},{-24,60}})));
  ClaRa.StaticCycles.Boundaries.Source_grey source_grey(P=0) annotation (Placement(transformation(extent={{-72,40},{-52,60}})));
  ClaRa.StaticCycles.Boundaries.Source_green source_green(
    m_flow=100,
    h=600e3,
    p=10e5) annotation (Placement(transformation(extent={{40,0},{60,20}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue sink_blue(p=300e5) annotation (Placement(transformation(extent={{80,80},{100,100}})));
  ClaRa.StaticCycles.Boundaries.Source_yellow source_yellow(h=3000e3, p=50e5) annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue sink_blue1(p=5e5) annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Pump1_mech pump2 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,-50})));
  Turbine_mech2 SPAT2 annotation (Placement(transformation(extent={{-36,-60},{-24,-40}})));
  ClaRa.StaticCycles.Boundaries.Source_grey source_grey1(P=0) annotation (Placement(transformation(extent={{-118,-60},{-98,-40}})));
  ClaRa.StaticCycles.Boundaries.Source_green source_green1(
    m_flow=100,
    h=600e3,
    p=10e5) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue sink_blue2(p=300e5) annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue sink_blue3(p=5e5) annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  ClaRa.StaticCycles.Machines.Turbine_mech turbine2 annotation (Placement(transformation(extent={{-66,-60},{-54,-40}})));
  ClaRa.StaticCycles.Boundaries.Source_green source_green2(
    m_flow=5,
    h=3000e3,
    p=50e5) annotation (Placement(transformation(extent={{-98,-38},{-78,-18}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue sink_blue4(p=5e5) annotation (Placement(transformation(extent={{-46,-100},{-26,-80}})));
  ClaRa.StaticCycles.Boundaries.Source_grey source_grey2(P=0) annotation (Placement(transformation(extent={{104,40},{84,60}})));
  ClaRa.StaticCycles.Boundaries.Source_grey source_grey3(P=0) annotation (Placement(transformation(extent={{104,-60},{84,-40}})));
  Fittings.Mixer4 mixer4_1(splitRatio=0.7) annotation (Placement(transformation(extent={{-54,12},{-44,18}})));
  ClaRa.StaticCycles.Boundaries.Source_yellow source_yellow1(h=2000e3, p=6e5)
                                                                             annotation (Placement(transformation(extent={{-110,8},{-90,28}})));
  ClaRa.StaticCycles.Boundaries.Source_yellow source_yellow2(h=3000e3, p=6e5) annotation (Placement(transformation(extent={{-110,-16},{-90,4}})));
  ValvesConnects.Valve_dp_nom4 valve_dp_nom4_1(Delta_p_nom=0.5e5) annotation (Placement(transformation(extent={{-80,16},{-70,20}})));
  ValvesConnects.Valve_dp_nom4 valve_dp_nom4_2(Delta_p_nom=0.5e5) annotation (Placement(transformation(extent={{-82,-8},{-72,-4}})));
  ClaRa.StaticCycles.Quadruple quadruple annotation (Placement(transformation(extent={{-30,-26},{-2,-16}})));
  ClaRa.StaticCycles.Quadruple quadruple1 annotation (Placement(transformation(extent={{-62,20},{-34,30}})));
  ClaRa.StaticCycles.Quadruple quadruple2 annotation (Placement(transformation(extent={{-66,-18},{-38,-8}})));
  ClaRa.StaticCycles.Quadruple quadruple3 annotation (Placement(transformation(extent={{-6,-78},{22,-68}})));
equation
  connect(SPAT1.power_out, pump1.powerIn) annotation (Line(points={{-23.6,50},{49.6,50}}, color={118,124,127}));
  connect(source_grey.outlet, SPAT1.power_in) annotation (Line(points={{-52.4,50},{-36.4,50}}, color={118,124,127}));
  connect(source_green.outlet, pump1.inlet) annotation (Line(points={{60.5,10},{60,10},{60,39.5}}, color={0,131,169}));
  connect(sink_blue.inlet, pump1.outlet) annotation (Line(points={{79.5,90},{60,90},{60,60.5}}, color={0,131,169}));
  connect(source_yellow.outlet, SPAT1.inlet) annotation (Line(points={{-39.5,90},{-36.5,90},{-36.5,54}}, color={0,131,169}));
  connect(sink_blue1.inlet, SPAT1.outlet) annotation (Line(points={{-20.5,10},{-20,10},{-20,42},{-23.5,42}}, color={0,131,169}));
  connect(SPAT2.power_out, pump2.powerIn) annotation (Line(points={{-23.6,-50},{49.6,-50}}, color={118,124,127}));
  connect(source_green1.outlet, pump2.inlet) annotation (Line(points={{60.5,-90},{60,-90},{60,-60.5}}, color={0,131,169}));
  connect(sink_blue2.inlet, pump2.outlet) annotation (Line(points={{79.5,-10},{60,-10},{60,-39.5}}, color={0,131,169}));
  connect(sink_blue3.inlet, SPAT2.outlet) annotation (Line(points={{-20.5,-90},{-20,-90},{-20,-58},{-23.5,-58}}, color={0,131,169}));
  connect(turbine2.power_out, SPAT2.power_in) annotation (Line(points={{-53.6,-50},{-36.4,-50}}, color={118,124,127}));
  connect(source_green2.outlet, turbine2.inlet) annotation (Line(points={{-77.5,-28},{-74,-28},{-74,-46},{-66.5,-46}}, color={0,131,169}));
  connect(sink_blue4.inlet, turbine2.outlet) annotation (Line(points={{-46.5,-90},{-50,-90},{-50,-58},{-53.5,-58}}, color={0,131,169}));
  connect(source_grey1.outlet, turbine2.power_in) annotation (Line(points={{-98.4,-50},{-66.4,-50}}, color={118,124,127}));
  connect(source_grey2.outlet, pump1.power_in) annotation (Line(points={{84.4,50},{70.4,50}}, color={118,124,127}));
  connect(source_grey3.outlet, pump2.power_in) annotation (Line(points={{84.4,-50},{70.4,-50}}, color={118,124,127}));
  connect(valve_dp_nom4_1.inlet, source_yellow1.outlet) annotation (Line(points={{-80.5,18},{-89.5,18}}, color={0,131,169}));
  connect(valve_dp_nom4_1.outlet,mixer4_1. inlet_1) annotation (Line(points={{-69.5,18},{-62,18},{-62,17},{-54.5,17}},
                                                                                                  color={0,131,169}));
  connect(source_yellow2.outlet,valve_dp_nom4_2. inlet) annotation (Line(points={{-89.5,-6},{-82.5,-6}}, color={0,131,169}));
  connect(valve_dp_nom4_2.outlet,mixer4_1. inlet_2) annotation (Line(points={{-71.5,-6},{-49,-6},{-49,11.5}},
                                                                                                         color={0,131,169}));
  connect(mixer4_1.outlet, SPAT2.inlet) annotation (Line(points={{-43.5,17},{-36.5,17},{-36.5,-46}},
                                                                                                 color={0,131,169}));
  connect(quadruple.steamSignal, SPAT2.inlet) annotation (Line(points={{-30,-20.8},{-34,-20.8},{-34,-20},{-36.5,-20},{-36.5,-46}}, color={0,131,169}));
  connect(quadruple1.steamSignal, valve_dp_nom4_1.outlet) annotation (Line(points={{-62,25.2},{-66,25.2},{-66,18},{-69.5,18}}, color={0,131,169}));
  connect(quadruple2.steamSignal, valve_dp_nom4_2.outlet) annotation (Line(points={{-66,-12.8},{-66,-6},{-71.5,-6}}, color={0,131,169}));
  connect(quadruple3.steamSignal, SPAT2.outlet) annotation (Line(points={{-6,-72.8},{-14,-72.8},{-14,-72},{-20,-72},{-20,-58},{-23.5,-58}}, color={0,131,169}));

  annotation (experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
end TestTurbineDrivenPump;
