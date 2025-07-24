within ClaRa.Visualisation.Check;
model TestDynamicDiagram
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1,
    f=0.1,
    offset=10) annotation (Placement(transformation(extent={{-82,-12},{-62,8}})));
  Scope scope(
    inputVar=sine.y,
    Unit="Sine",
    t_sample=2,
    t_end=100,
    t_start=50,
    hideInterface=false,
    y_min=9,
    y_max=11,
    Tau_stab=1)  annotation (Placement(transformation(extent={{-36,-66},{56,20}})));
equation
  connect(sine.y, scope.u) annotation (Line(
      points={{-61,-2},{-50,-2},{-50,-3.81538},{-39.9429,-3.81538}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                      graphics), experiment(StopTime=200));
end TestDynamicDiagram;
