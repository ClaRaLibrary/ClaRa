within ClaRa.Components.Sensors.Check;
model TestVLESensors

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  SensorVLE_L1_T temperature(unitOption=3) annotation (Placement(transformation(extent={{-12,10},{8,30}})));
  BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(m_flow_const=10, h_const=2000e3,
    variable_m_flow=true,
    variable_h=false)                                                                             annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=1e5,
    variable_p=true,
    h_const=10)                                                     annotation (Placement(transformation(extent={{76,0},{56,20}})));
  SensorVLE_L1_p pressure(unitOption=3) annotation (Placement(transformation(extent={{-38,10},{-18,30}})));
  SensorVLE_L1_m_flow flow_(unitOption=2) annotation (Placement(transformation(extent={{16,10},{36,30}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,10; 1,10; 1.1,-10; 2,-10; 2.1,10; 3,10]) annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,1e5; 3,1e5; 4,-1e5; 5,1e5; 6,1e5]) annotation (Placement(transformation(extent={{102,22},{82,42}})));
protected
  Modelica.Blocks.Interfaces.RealOutput p1 "pressure in port medium" annotation (Placement(transformation(extent={{-13,43},{-11,45}})));
protected
  Modelica.Blocks.Interfaces.RealOutput T1 "Temperature in port medium" annotation (Placement(transformation(extent={{13,43},{15,45}})));
protected
  Modelica.Blocks.Interfaces.RealOutput m_flow1 "Mass flow rate" annotation (Placement(transformation(extent={{43,45},{45,47}})));
equation
  connect(boundaryVLE_hxim_flow.steam_a, temperature.port) annotation (Line(
      points={{-40,10},{-40,10},{-2,10}},
      color={0,131,169},
      thickness=0.5));
  connect(boundaryVLE_hxim_flow.steam_a, pressure.port) annotation (Line(
      points={{-40,10},{-40,10},{-28,10}},
      color={0,131,169},
      thickness=0.5));
  connect(boundaryVLE_hxim_flow.steam_a, flow_.inlet) annotation (Line(
      points={{-40,10},{16,10}},
      color={0,131,169},
      thickness=0.5));
  connect(flow_.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{36,10},{46,10},{56,10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(timeTable.y, boundaryVLE_hxim_flow.m_flow) annotation (Line(points={{-79,30},{-72,30},{-72,16},{-62,16}}, color={0,0,127}));
  connect(timeTable1.y, boundaryVLE_phxi.p) annotation (Line(points={{81,32},{80,32},{80,16},{76,16}}, color={0,0,127}));
  connect(pressure.p, p1) annotation (Line(points={{-17,20},{-14,20},{-12,20},{-12,44}}, color={0,0,127}));
  connect(temperature.T, T1) annotation (Line(points={{9,20},{14,20},{14,44}}, color={0,0,127}));
  connect(flow_.m_flow, m_flow1) annotation (Line(points={{37,20},{44,20},{44,46}}, color={0,0,127}));
    annotation (Icon(graphics,    coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=6, __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput);
end TestVLESensors;
