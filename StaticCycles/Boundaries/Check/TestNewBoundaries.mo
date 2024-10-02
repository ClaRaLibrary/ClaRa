within ClaRa.StaticCycles.Boundaries.Check;
model TestNewBoundaries
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

inner parameter Real P_target_=1;

  Source_grey source_grey(P=10) annotation (Placement(transformation(extent={{-56,46},{-36,66}})));
  Sink_grey sink_grey annotation (Placement(transformation(extent={{-10,46},{10,66}})));
  Source_blue   boundary_blue(
    m_flow=10,
    h=3000e3)    annotation (Placement(transformation(extent={{-4,-30},{16,-10}})));
  Sink_green     boundary_green               annotation (Placement(transformation(extent={{56,-30},{76,-10}})));
  ClaRa.StaticCycles.ValvesConnects.PressureAnchor_constFlow1 fixedPressure(p_nom=10e5)
                                                                                    annotation (Placement(transformation(extent={{28,-22},{38,-18}})));
  ClaRa.StaticCycles.Triple
         triple annotation (Placement(transformation(extent={{16,-14},{30,-2}})));
  ClaRa.StaticCycles.Triple
         triple1 annotation (Placement(transformation(extent={{54,-4},{66,8}})));
  ClaRa.StaticCycles.Machines.Turbine turbine annotation (Placement(transformation(extent={{24,-90},{36,-70}})));
  Source_green   boundary_green1(
    m_flow=10,
    h=3000e3,
    p=20e5) annotation (Placement(transformation(extent={{-4,-90},{16,-70}})));
  Sink_blue     boundary_blue1(              p=5e5) annotation (Placement(transformation(extent={{56,-90},{76,-70}})));
  ClaRa.StaticCycles.Triple
         triple2 annotation (Placement(transformation(extent={{52,-74},{66,-62}})));
  ClaRa.StaticCycles.Triple
         triple3 annotation (Placement(transformation(extent={{4,-60},{16,-48}})));
  Source_yellow   boundary_yellow(
    h=200e3,
    p=2e5) annotation (Placement(transformation(extent={{-2,20},{18,40}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure2 valve_cutFlow annotation (Placement(transformation(extent={{30,27},{40,33}})));
  Sink_red     boundary_red(
    m_flow=10,
    p=1e5) annotation (Placement(transformation(extent={{52,20},{72,40}})));
  ClaRa.StaticCycles.Triple
         triple4 annotation (Placement(transformation(extent={{24,40},{44,52}})));
  ClaRa.StaticCycles.Triple
         triple5 annotation (Placement(transformation(extent={{52,40},{72,54}})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  Dispatcher dispatcher(P_el_nom=5e6, eta_el_nom=0.4) annotation (Placement(transformation(extent={{-84,-8},{-64,12}})));
equation
  connect(source_grey.outlet, sink_grey.inlet) annotation (Line(points={{-36.4,56},{-9.6,56}},
                                                                                            color={118,124,127}));
  connect(boundary_green.inlet,fixedPressure. outlet) annotation (Line(
      points={{55.5,-20},{38.5,-20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_blue.outlet,fixedPressure. inlet) annotation (Line(
      points={{16.5,-20},{27.5,-20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple.steamSignal,boundary_blue. outlet) annotation (Line(
      points={{15.5625,-9.28571},{15.5625,-14.6428},{16.5,-14.6428},{16.5,-20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple1.steamSignal,boundary_green. inlet) annotation (Line(
      points={{53.625,0.714286},{53.625,-7.6428},{55.5,-7.6428},{55.5,-20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_green1.outlet,turbine. inlet) annotation (Line(
      points={{16.5,-80},{20,-80},{20,-76},{23.5,-76}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_blue1.inlet,turbine. outlet) annotation (Line(
      points={{55.5,-80},{46,-80},{46,-88},{36.5,-88}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple2.steamSignal,boundary_blue1. inlet) annotation (Line(
      points={{51.5625,-69.2857},{51.5625,-74.6428},{55.5,-74.6428},{55.5,-80}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple3.steamSignal,boundary_green1. outlet) annotation (Line(
      points={{3.625,-55.2857},{3.625,-67.6428},{16.5,-67.6428},{16.5,-80}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_cutFlow.outlet,boundary_red. inlet) annotation (Line(points={{40.5,30},{40.5,30},{51.5,30}},color={0,131,169}));
  connect(triple5.steamSignal,boundary_red. inlet) annotation (Line(points={{51.375,45.5},{51.375,37.75},{51.5,37.75},{51.5,30}},
                                                                                                                              color={0,131,169}));
  connect(boundary_yellow.outlet,triple4. steamSignal) annotation (Line(points={{18.5,30},{20,30},{20,44.7143},{23.375,44.7143}},   color={0,131,169}));
  connect(boundary_yellow.outlet, valve_cutFlow.inlet) annotation (Line(points={{18.5,30},{24,30},{24,30},{29.5,30}}, color={0,131,169}));
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
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
 Icon(graphics,    coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1));
end TestNewBoundaries;
