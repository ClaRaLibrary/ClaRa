within ClaRa.StaticCycles.Check;
model TestBoundaries

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;

  inner parameter Real P_target_=1;

  ClaRa.StaticCycles.Boundaries.Source_blue boundary_blue(m_flow=10, h=3000e3) annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  ClaRa.StaticCycles.Boundaries.Sink_green boundary_green annotation (Placement(transformation(extent={{0,0},{20,20}})));
  ValvesConnects.PressureAnchor_constFlow1 fixedPressure(p_nom=10e5)
                                                                 annotation (Placement(transformation(extent={{-28,8},{-18,12}})));
  Triple triple annotation (Placement(transformation(extent={{-40,16},{-26,28}})));
  Triple triple1 annotation (Placement(transformation(extent={{-2,26},{10,38}})));
  Machines.Turbine turbine annotation (Placement(transformation(extent={{-32,-60},{-20,-40}})));
  ClaRa.StaticCycles.Boundaries.Source_green boundary_green1(
    m_flow=10,
    h=3000e3,
    p=20e5) annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  ClaRa.StaticCycles.Boundaries.Sink_blue boundary_blue1(p=5e5) annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Triple triple2 annotation (Placement(transformation(extent={{-4,-44},{10,-32}})));
  Triple triple3 annotation (Placement(transformation(extent={{-52,-30},{-40,-18}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  ClaRa.StaticCycles.Boundaries.Source_yellow boundary_yellow(h=200e3, p=2e5) annotation (Placement(transformation(extent={{-58,50},{-38,70}})));
  ValvesConnects.Valve_cutPressure2 valve_cutFlow annotation (Placement(transformation(extent={{-26,57},{-16,63}})));
  ClaRa.StaticCycles.Boundaries.Sink_red boundary_red(m_flow=10, p=1e5) annotation (Placement(transformation(extent={{-4,50},{16,70}})));
  Triple triple4 annotation (Placement(transformation(extent={{-32,70},{-12,82}})));
  Triple triple5 annotation (Placement(transformation(extent={{-4,70},{16,84}})));
equation
  connect(boundary_green.inlet, fixedPressure.outlet) annotation (Line(
      points={{-0.5,10},{-17.5,10}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_blue.outlet, fixedPressure.inlet) annotation (Line(
      points={{-39.5,10},{-28.5,10}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple.steamSignal, boundary_blue.outlet) annotation (Line(
      points={{-40.4375,20.7143},{-40.4375,15.3572},{-39.5,15.3572},{-39.5,10}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple1.steamSignal, boundary_green.inlet) annotation (Line(
      points={{-2.375,30.7143},{-2.375,22.3572},{-0.5,22.3572},{-0.5,10}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_green1.outlet, turbine.inlet) annotation (Line(
      points={{-39.5,-50},{-36,-50},{-36,-46},{-32.5,-46}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_blue1.inlet, turbine.outlet) annotation (Line(
      points={{-0.5,-50},{-10,-50},{-10,-58},{-19.5,-58}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple2.steamSignal, boundary_blue1.inlet) annotation (Line(
      points={{-4.4375,-39.2857},{-4.4375,-44.6428},{-0.5,-44.6428},{-0.5,-50}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple3.steamSignal, boundary_green1.outlet) annotation (Line(
      points={{-52.375,-25.2857},{-52.375,-37.6428},{-39.5,-37.6428},{-39.5,-50}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boundary_yellow.outlet, valve_cutFlow.inlet) annotation (Line(points={{-37.5,60},{-26.5,60}},
                                                                                              color={0,131,169}));
  connect(valve_cutFlow.outlet, boundary_red.inlet) annotation (Line(points={{-15.5,60},{-15.5,60},{-4.5,60}},
                                                                                                            color={0,131,169}));
  connect(triple5.steamSignal, boundary_red.inlet) annotation (Line(points={{-4.625,75.5},{-4.625,67.75},{-4.5,67.75},{-4.5,60}},
                                                                                                                              color={0,131,169}));
  connect(boundary_yellow.outlet, triple4.steamSignal) annotation (Line(points={{-37.5,60},{-36,60},{-36,74.7143},{-32.625,74.7143}},
                                                                                              color={0,131,169}));
  annotation (experiment(StopTime=1),
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end TestBoundaries;
