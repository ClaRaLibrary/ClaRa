within ClaRa.Components.Sensors.Check;
model TestFuelSensors

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  BoundaryConditions.BoundaryFuel_Txim_flow                      boundaryVLE_hxim_flow(
                                                                 m_flow_const=10,
    variable_m_flow=true)                                                                         annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  BoundaryConditions.BoundaryFuel_pTxi                      boundaryVLE_phxi(
                                                       p_const=1e5,
    variable_p=true,
    T_const=270.15)                                                 annotation (Placement(transformation(extent={{76,0},{56,20}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,10; 1,10; 1.1,-10; 2,-10; 2.1,10; 3,10]) annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,1e5; 3,1e5; 4,-1e5; 5,1e5; 6,1e5]) annotation (Placement(transformation(extent={{102,22},{82,42}})));
  SensorFuel_L1_T sensorFuel_L1_T   annotation (Placement(transformation(extent={{-16,10},{4,30}})));
  SensorFuel_L1_m_flow sensorFuel_L1_m_flow annotation (Placement(transformation(extent={{14,10},{34,30}})));
  SensorFuel_L1_LHV sensorFuel_L1_LHV(unitOption=1) annotation (Placement(transformation(extent={{-42,10},{-22,30}})));
equation
  connect(timeTable.y, boundaryVLE_hxim_flow.m_flow) annotation (Line(points={{-79,30},{-72,30},{-72,16},{-60,16}}, color={0,0,127}));
  connect(timeTable1.y, boundaryVLE_phxi.p) annotation (Line(points={{81,32},{80,32},{80,16},{76,16}}, color={0,0,127}));
  connect(sensorFuel_L1_T.port, sensorFuel_L1_m_flow.inlet) annotation (Line(
      points={{-6,10},{14,10}},
      color={27,36,42},
      thickness=0.5));
  connect(sensorFuel_L1_m_flow.outlet, boundaryVLE_phxi.fuel_a) annotation (Line(
      points={{34,10},{56,10}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_hxim_flow.fuel_a, sensorFuel_L1_T.port) annotation (Line(
      points={{-40,10},{-6,10}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sensorFuel_L1_LHV.port, boundaryVLE_hxim_flow.fuel_a) annotation (Line(
      points={{-32,10},{-40,10}},
      color={27,36,42},
      thickness=0.5));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=6, __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput);
end TestFuelSensors;
