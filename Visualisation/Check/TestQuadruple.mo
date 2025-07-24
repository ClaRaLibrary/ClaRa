within ClaRa.Visualisation.Check;
model TestQuadruple
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
  Modelica.Blocks.Sources.Ramp m(
    height=-20,
    duration=1,
    offset=10)
    annotation (Placement(transformation(extent={{-82,66},{-62,86}})));
  Modelica.Blocks.Sources.Ramp T(          offset=300,
    height=20,
    duration=1,
    startTime=0.3)
    annotation (Placement(transformation(extent={{-82,26},{-62,46}})));
  Modelica.Blocks.Sources.Ramp h(
    duration=10,
    height=-1000e3/1000,
    offset=3000e3/1000)
    annotation (Placement(transformation(extent={{-82,-14},{-62,6}})));
  Modelica.Blocks.Sources.Ramp p(
    duration=10,
    height=1,
    offset=1)
    annotation (Placement(transformation(extent={{-82,-54},{-62,-34}})));
  Modelica.Blocks.Sources.Ramp s(
    duration=10,
    height=1e3,
    offset=1e3)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  DynDisplay dynDisplay(
    x1=s.y,
    unit="kJ/kg",
    varname="Test",
    provideConnector=true)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Quadruple quadruple(decimalSpaces(T=2, p=3))
                      annotation (Placement(transformation(extent={{-6,-7},{44,11}})));
  Basics.Interfaces.EyeOut eyeOut annotation (Placement(transformation(extent={{-44,-8},{-24,12}}), iconTransformation(extent={{-164,24},{-154,34}})));
  inner SimCenter simCenter                    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
equation
  m.y=eyeOut.m_flow;
  T.y=eyeOut.T;
  h.y=eyeOut.h;
  p.y=eyeOut.p;
  s.y=eyeOut.s;
  connect(quadruple.eye, eyeOut) annotation (Line(
      points={{-6,2},{-34,2}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(h.y, dynDisplay.u) annotation (Line(points={{-61,-4},{-52,-4},{-52,-30},{-1,-30}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    experiment(StopTime=12));
end TestQuadruple;
