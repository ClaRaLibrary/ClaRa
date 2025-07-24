within ClaRa.Components.Utilities.Blocks.Check;
model TestMinMax
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

  import      Modelica.Units.SI;

  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    startTime=100,
    height=+420)
    annotation (Placement(transformation(extent={{-68,26},{-48,46}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=25,
    f=0.1,
    offset=-300) annotation (Placement(transformation(extent={{-62,-24},{-42,-4}})));
  Modelica.Blocks.Math.Add T
    annotation (Placement(transformation(extent={{-20,6},{0,26}})));
  ClaRa.Components.Utilities.Blocks.TimeExtrema timeExtrema
    annotation (Placement(transformation(extent={{20,6},{40,26}})));
initial equation



equation
  connect(ramp.y, T.u1) annotation (Line(
      points={{-47,36},{-34,36},{-34,22},{-22,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, T.u2) annotation (Line(
      points={{-41,-14},{-32,-14},{-32,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T.y, timeExtrema.u) annotation (Line(
      points={{1,16},{18,16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=300), experimentSetupOutput);
end TestMinMax;
