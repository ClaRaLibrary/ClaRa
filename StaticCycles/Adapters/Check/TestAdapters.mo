within ClaRa.StaticCycles.Adapters.Check;
model TestAdapters
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  GainVLE1 gainVLE1_1(gain=1/2) annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  GainVLE2 gainVLE2_1(gain=1/2) annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
  GainVLE3 gainVLE3_1(gain=1/2) annotation (Placement(transformation(extent={{-28,-30},{-8,-10}})));
  ClaRa.StaticCycles.Boundaries.Source_blue source_blue(m_flow=10, h=500e3) annotation (Placement(transformation(extent={{-72,20},{-52,40}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue sink_blue(p=1e5) annotation (Placement(transformation(extent={{72,20},{92,40}})));
  GainVLE1 gainVLE1_2(gain=2) annotation (Placement(transformation(extent={{10,20},{30,40}})));
  ClaRa.StaticCycles.Boundaries.Sink_green sink_green annotation (Placement(transformation(extent={{74,-4},{94,16}})));
  GainVLE2 gainVLE2_2(gain=2) annotation (Placement(transformation(extent={{16,-4},{36,16}})));
  ClaRa.StaticCycles.Boundaries.Source_green source_green(
    m_flow=10,
    h=500e3,
    p=1e5) annotation (Placement(transformation(extent={{-80,-4},{-60,16}})));
  ClaRa.StaticCycles.Boundaries.Source_red source_red(h=500e3) annotation (Placement(transformation(extent={{-78,-30},{-58,-10}})));
  ClaRa.StaticCycles.Boundaries.Sink_red sink_red(m_flow=10, p=1e5) annotation (Placement(transformation(extent={{72,-30},{92,-10}})));
  GainVLE3 gainVLE3_2(gain=2) annotation (Placement(transformation(extent={{14,-30},{34,-10}})));
  ClaRa.StaticCycles.Quadruple quadruple annotation (Placement(transformation(extent={{-48,-25},{-28,-15}})));
  ClaRa.StaticCycles.Quadruple quadruple1 annotation (Placement(transformation(extent={{-6,-25},{14,-15}})));
  ClaRa.StaticCycles.Quadruple quadruple2 annotation (Placement(transformation(extent={{36,-25},{56,-15}})));
  ClaRa.StaticCycles.Quadruple quadruple3 annotation (Placement(transformation(extent={{-8,1},{12,11}})));
  ClaRa.StaticCycles.Quadruple quadruple4 annotation (Placement(transformation(extent={{-56,1},{-36,11}})));
  ClaRa.StaticCycles.Quadruple quadruple5 annotation (Placement(transformation(extent={{46,1},{66,11}})));
  ClaRa.StaticCycles.Quadruple quadruple6 annotation (Placement(transformation(extent={{-8,25},{12,35}})));
  ClaRa.StaticCycles.Quadruple quadruple7 annotation (Placement(transformation(extent={{-46,25},{-26,35}})));
  ClaRa.StaticCycles.Quadruple quadruple8 annotation (Placement(transformation(extent={{38,25},{58,35}})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{-100,-72},{-60,-52}})));
equation
  connect(source_blue.outlet, gainVLE1_1.inlet) annotation (Line(points={{-51.5,30},{-30.5,30}}, color={0,131,169}));
  connect(gainVLE1_1.outlet, gainVLE1_2.inlet) annotation (Line(points={{-9.5,30},{9.5,30}},   color={0,131,169}));
  connect(gainVLE1_2.outlet, sink_blue.inlet) annotation (Line(points={{30.5,30},{71.5,30}}, color={0,131,169}));
  connect(gainVLE2_1.outlet, gainVLE2_2.inlet) annotation (Line(points={{-9.5,6},{15.5,6}}, color={0,131,169}));
  connect(gainVLE2_2.outlet, sink_green.inlet) annotation (Line(points={{36.5,6},{73.5,6}}, color={0,131,169}));
  connect(source_green.outlet, gainVLE2_1.inlet) annotation (Line(points={{-59.5,6},{-30.5,6}}, color={0,131,169}));
  connect(source_red.outlet, gainVLE3_1.inlet) annotation (Line(points={{-57.5,-20},{-28.5,-20}}, color={0,131,169}));
  connect(sink_red.inlet, gainVLE3_2.outlet) annotation (Line(points={{71.5,-20},{34.5,-20}}, color={0,131,169}));
  connect(gainVLE3_2.inlet, gainVLE3_1.outlet) annotation (Line(points={{13.5,-20},{-7.5,-20}},  color={0,131,169}));
  connect(quadruple.steamSignal, gainVLE3_1.inlet) annotation (Line(points={{-48,-19.8},{-48,-20},{-28.5,-20}}, color={0,131,169}));
  connect(quadruple1.steamSignal, gainVLE3_1.outlet) annotation (Line(points={{-6,-19.8},{-6,-20},{-7.5,-20}},  color={0,131,169}));
  connect(gainVLE3_2.inlet, quadruple1.steamSignal) annotation (Line(points={{13.5,-20},{6.25,-20},{6.25,-19.8},{-6,-19.8}}, color={0,131,169}));
  connect(source_red.outlet, quadruple.steamSignal) annotation (Line(points={{-57.5,-20},{-52.75,-20},{-52.75,-19.8},{-48,-19.8}}, color={0,131,169}));
  connect(sink_red.inlet, quadruple2.steamSignal) annotation (Line(points={{71.5,-20},{53.75,-20},{53.75,-19.8},{36,-19.8}}, color={0,131,169}));
  connect(source_green.outlet, quadruple4.steamSignal) annotation (Line(points={{-59.5,6},{-57.75,6},{-57.75,6.2},{-56,6.2}}, color={0,131,169}));
  connect(gainVLE2_1.outlet, quadruple3.steamSignal) annotation (Line(points={{-9.5,6},{-8.75,6},{-8.75,6.2},{-8,6.2}}, color={0,131,169}));
  connect(gainVLE2_2.outlet, quadruple5.steamSignal) annotation (Line(points={{36.5,6},{41.25,6},{41.25,6.2},{46,6.2}}, color={0,131,169}));
  connect(gainVLE1_1.outlet, quadruple6.steamSignal) annotation (Line(points={{-9.5,30},{-10.25,30},{-10.25,30.2},{-8,30.2}},  color={0,131,169}));
  connect(source_blue.outlet, quadruple7.steamSignal) annotation (Line(points={{-51.5,30},{-49.75,30},{-49.75,30.2},{-46,30.2}}, color={0,131,169}));
  connect(gainVLE1_2.outlet, quadruple8.steamSignal) annotation (Line(points={{30.5,30},{25.75,30},{25.75,30.2},{38,30.2}}, color={0,131,169}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
end TestAdapters;
