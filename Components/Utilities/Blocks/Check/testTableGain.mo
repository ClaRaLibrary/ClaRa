within ClaRa.Components.Utilities.Blocks.Check;
model testTableGain
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

  Components.Utilities.Blocks.TableGain tableGain(table=[0,0; 1,5; 2,10])
    annotation (Placement(transformation(extent={{0,-2},{20,18}})));
  Modelica.Blocks.Sources.Ramp sine(
    height=1,
    offset=1,
    duration=0.6,
    startTime=0.2)
    annotation (Placement(transformation(extent={{-78,-2},{-58,18}})));
  Modelica.Blocks.Tables.CombiTable1Dv tableGain1(table=[0,0; 1,5; 2,10]) annotation (Placement(transformation(extent={{0,-42},{20,-22}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{30,-76},{50,-56}})));
equation
  connect(sine.y, tableGain.u[1]) annotation (Line(
      points={{-57,8},{-2,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, tableGain1.u[1]) annotation (Line(
      points={{-57,8},{-30,8},{-30,-32},{-2,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tableGain1.y[1], product1.u1) annotation (Line(
      points={{21,-32},{24,-32},{24,-60},{28,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.u2, sine.y) annotation (Line(
      points={{28,-72},{-8,-72},{-8,-70},{-57,-70},{-57,8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), experiment(StopTime=1));
end testTableGain;
