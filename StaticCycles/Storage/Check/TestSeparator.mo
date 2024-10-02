within ClaRa.StaticCycles.Storage.Check;
model TestSeparator
  //__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  ClaRa.StaticCycles.Storage.Separator steamDrum annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  ClaRa.StaticCycles.Boundaries.Source_blue source_blue(m_flow=10, h=2200e3)
    annotation (Placement(transformation(extent={{48,-10},{28,10}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue sink_blue(p=10e5)
    annotation (Placement(transformation(extent={{6,-44},{26,-24}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue sink_blue1(p=10e5)
    annotation (Placement(transformation(extent={{6,14},{26,34}})));
  inner ClaRa.SimCenter simCenter
    annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
equation
  connect(source_blue.outlet, steamDrum.inlet)
    annotation (Line(points={{27.5,0},{17.75,0},{8,0}}, color={0,131,169}));
  connect(sink_blue.inlet, steamDrum.outlet1) annotation (Line(points={{5.5,-34},
          {-2,-34},{-2,-32},{-2,-10}}, color={0,131,169}));
  connect(sink_blue1.inlet, steamDrum.outlet2)
    annotation (Line(points={{5.5,24},{-2,24},{-2,10}}, color={0,131,169}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
end TestSeparator;
