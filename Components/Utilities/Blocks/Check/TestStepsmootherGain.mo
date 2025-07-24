within ClaRa.Components.Utilities.Blocks.Check;
model TestStepsmootherGain
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  Modelica.Blocks.Sources.Sine sine(
    amplitude=1,
    f=1,
    offset=0) annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=1,
    startTime=0)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  StepSmootherGain stepSmootherGain annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    startTime=0,
    height=-0.2,
    duration=0.2,
    offset=0.2)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=0.5,
    offset=0.5,
    duration=0.01,
    startTime=0.6)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(sine.y, stepSmootherGain.u) annotation (Line(points={{-39,10},{-39,10},{-2,10}}, color={0,0,127}));
  connect(ramp.y, stepSmootherGain.x) annotation (Line(points={{-39,-30},{10,-30},{10,-2}}, color={0,0,127}));
  connect(ramp1.y, stepSmootherGain.noFunc) annotation (Line(points={{-19,-10},{-19,-12},{3,-12},{3,-2}}, color={0,0,127}));
  connect(ramp2.y, stepSmootherGain.func) annotation (Line(points={{-59,-50},{-10,-50},{16.8,-50},{16.8,-2}}, color={0,0,127}));
    annotation (Icon(graphics, coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=2));
end TestStepsmootherGain;
