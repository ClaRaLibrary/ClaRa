within ClaRa.StaticCycles.Machines.Check;
model CheckPumpModels
  inner parameter Real P_target_= 0.5 "Value of load in p.u."    annotation(Dialog(group="Global parameter"));
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  Pump1 pump annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Boundaries.Source_blue source_blue(m_flow=1, h=100e3) annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Boundaries.Sink_blue sink_blue(p=5e5) annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Boundaries.Source_green source_green(
    m_flow=1,
    h=100e3,
    p=1e5) annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Boundaries.Sink_blue sink_blue1(p=5e5) annotation (Placement(transformation(extent={{30,10},{50,30}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  Boundaries.Source_yellow source_yellow(h=100e3, p=1e5) annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Boundaries.Sink_blue sink_blue2(p=5e5) annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Pump3 pump3 annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Pump2 pump2(Pi_nom=5) annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(source_green.outlet, pump.inlet) annotation (Line(points={{-29.5,20},{-10.5,20}}, color={0,131,169}));
  connect(pump.outlet, sink_blue1.inlet) annotation (Line(points={{10.5,20},{29.5,20}}, color={0,131,169}));
  connect(source_blue.outlet, pump2.inlet) annotation (Line(points={{-29.5,-20},{-10.5,-20}}, color={0,131,169}));
  connect(pump2.outlet, sink_blue.inlet) annotation (Line(points={{10.5,-20},{29.5,-20}}, color={0,131,169}));
  connect(source_yellow.outlet, pump3.inlet) annotation (Line(points={{-29.5,-60},{-10.5,-60}}, color={0,131,169}));
  connect(pump3.outlet, sink_blue2.inlet) annotation (Line(points={{10.5,-60},{29.5,-60}}, color={0,131,169}));
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
 Icon(graphics,    coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                Text(
          extent={{-100,82},{184,35}},
          lineColor={0,128,0},
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="____________________________________________________________________________________________
PURPOSE:
test and compare different StaCy pump models
____________________________________________________________________________________________
LOOK AT:
the calculated pump power and in dependence of the top level parameter P_target
____________________________________________________________________________________________")}),
    experiment(StopTime=1));
end CheckPumpModels;
