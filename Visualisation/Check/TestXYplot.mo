within ClaRa.Visualisation.Check;
model TestXYplot
extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  XYplot xYplot(
    title="test",
    x_label="x",
    y_label="y",
    x_min=0,
    activateSecondSet=true,
    x_max=20,
    y_max=20,
    decimalSpaces(x=0)) annotation (Placement(transformation(extent={{0,0},{40,40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5,
    offset=0,
    startTime=0.2,
    height=0) annotation (Placement(transformation(extent={{-68,62},{-48,82}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=0.5,
    startTime=0.2,
    height=10,
    offset=5) annotation (Placement(transformation(extent={{-94,40},{-74,60}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=0.5,
    offset=0,
    startTime=0.2,
    height=10) annotation (Placement(transformation(extent={{-92,10},{-72,30}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{-56,-70},{-36,-50}})));
  Modelica.Blocks.Sources.Ramp const1(
    duration=0.1,
    startTime=0.7,
    height=10,
    offset=5) annotation (Placement(transformation(extent={{-58,-96},{-38,-76}})));
  Modelica.Blocks.Sources.Constant const2(k=20) annotation (Placement(transformation(extent={{6,-96},{26,-76}})));
  Scope scope(hideInterface=false) annotation (Placement(transformation(extent={{26,54},{40,66}})));
  Modelica.Blocks.Sources.Ramp ramp3[3](
    each duration=0.5,
    each startTime=0.2,
    height={20,15,10},
    offset={0,5,10}) annotation (Placement(transformation(extent={{-92,-36},{-72,-16}})));
equation
  connect(ramp.y, xYplot.y1[1]) annotation (Line(points={{-47,72},{-38,72},{-38,26.6667},{-1.42857,26.6667}}, color={0,0,127}));
  connect(ramp1.y, xYplot.y1[2]) annotation (Line(points={{-73,50},{-40,50},{-40,26.6667},{-1.42857,26.6667}}, color={0,0,127}));
  connect(ramp2.y, xYplot.y1[3]) annotation (Line(points={{-71,20},{-38,20},{-38,26.6667},{-1.42857,26.6667}}, color={0,0,127}));
  connect(const.y, xYplot.x1[1]) annotation (Line(points={{-35,-60},{-8,-60},{-8,-64},{14.2857,-64},{14.2857,-1.33333}}, color={0,0,127}));
  connect(const1.y, xYplot.x1[2]) annotation (Line(points={{-37,-86},{24,-86},{24,-1.33333},{14.2857,-1.33333}}, color={0,0,127}));
  connect(const2.y, xYplot.x1[3]) annotation (Line(points={{27,-86},{14.2857,-86},{14.2857,-1.33333}}, color={0,0,127}));
  connect(ramp.y, scope.u) annotation (Line(points={{-47,72},{-18,72},{-18,62.6769},{25.4,62.6769}}, color={0,0,127}));
  connect(const2.y, xYplot.x2[3]) annotation (Line(points={{27,-86},{25.7143,-86},{25.7143,-1.33333}}, color={0,0,127}));
  connect(const1.y, xYplot.x2[2]) annotation (Line(points={{-37,-86},{26,-86},{26,-1.33333},{25.7143,-1.33333}}, color={0,0,127}));
  connect(const.y, xYplot.x2[1]) annotation (Line(points={{-35,-60},{-4,-60},{-4,-1.33333},{25.7143,-1.33333}}, color={0,0,127}));
  connect(ramp3.y, xYplot.y2) annotation (Line(points={{-71,-26},{-42,-26},{-42,13.3333},{-1.42857,13.3333}}, color={0,0,127}));
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
   Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1));
end TestXYplot;
