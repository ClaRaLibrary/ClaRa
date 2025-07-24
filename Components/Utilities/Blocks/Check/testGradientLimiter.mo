within ClaRa.Components.Utilities.Blocks.Check;
model testGradientLimiter
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  Components.Utilities.Blocks.VariableGradientLimiter variableGradientLimiter(
      Nd=1) annotation (Placement(transformation(extent={{10,-12},{30,8}})));
  Modelica.Blocks.Sources.Ramp sine(
    height=100,
    duration=15,
    startTime=2)
    annotation (Placement(transformation(extent={{-96,-6},{-76,14}})));
  Modelica.Blocks.Sources.Step step(
    offset=1,
    startTime=5,
    height=20)
    annotation (Placement(transformation(extent={{-78,28},{-58,48}})));
  Modelica.Blocks.Sources.Step step1(
    height=-30,
    offset=-1,
    startTime=35)
    annotation (Placement(transformation(extent={{-94,-78},{-74,-58}})));
  Modelica.Blocks.Sources.Ramp sine1(
    duration=15,
    height=-100,
    startTime=25)
    annotation (Placement(transformation(extent={{-92,-38},{-72,-18}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-38,-36},{-18,-16}})));
equation
  connect(variableGradientLimiter.maxGrad, step.y) annotation (Line(
      points={{8,6},{-12,6},{-12,10},{-32,10},{-32,38},{-57,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(variableGradientLimiter.minGrad, step1.y) annotation (Line(
      points={{8,-10},{-10,-10},{-10,-68},{-73,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u1, sine.y) annotation (Line(
      points={{-40,-20},{-58,-20},{-58,4},{-75,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine1.y, add.u2) annotation (Line(
      points={{-71,-28},{-54,-28},{-54,-32},{-40,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, variableGradientLimiter.u) annotation (Line(
      points={{-17,-26},{-12,-26},{-12,0},{8,0},{8,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end testGradientLimiter;
