within ClaRa.Components.Utilities.Blocks.Check;
model TestSlidingmean
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  Components.Utilities.Blocks.Noise noise(
    startTime=0,
    Tau_sample=0.1,
    mean_const=5,
    varMeanValue=true,
    varStandardDeviation=true)
    annotation (Placement(transformation(extent={{-36,0},{-16,20}})));
  Components.Utilities.Blocks.SlidingMean slidingMean(Tau_mean=20)
    annotation (Placement(transformation(extent={{12,0},{32,20}})));
  Modelica.Blocks.Sources.Step step(          startTime=50,
    height=50,
    offset=500)
    annotation (Placement(transformation(extent={{-82,6},{-62,26}})));
  Modelica.Blocks.Sources.Step step1(
    startTime=100,
    height=-1,
    offset=1)
    annotation (Placement(transformation(extent={{-78,-30},{-58,-10}})));
equation
  connect(noise.y, slidingMean.u) annotation (Line(
      points={{-15,10},{10,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, noise.mean) annotation (Line(
      points={{-61,16},{-36,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step1.y, noise.sigma) annotation (Line(
      points={{-57,-20},{-46,-20},{-46,5.8},{-36,5.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                      graphics),
    experiment(StopTime=150),
    __Dymola_experimentSetupOutput);
end TestSlidingmean;
