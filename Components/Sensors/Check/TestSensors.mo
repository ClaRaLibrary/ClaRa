within ClaRa.Components.Sensors.Check;
model TestSensors
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
  ClaRa.Components.Sensors.SensorGas_L1_m_flow
                      sensorGas_L1_m_flow annotation (Placement(transformation(extent={{10,62},{30,82}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow boundaryGas_Txim_flow(
    variable_m_flow=true,
    variable_T=true,
    m_flow_const=10,
    xi_const=simCenter.flueGasModel.xi_default) annotation (Placement(transformation(extent={{-54,52},{-34,72}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi(variable_p=true, xi_const=simCenter.flueGasModel.xi_default) annotation (Placement(transformation(extent={{70,52},{50,72}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=300,
    duration=0.1,
    offset=273.15,
    startTime=0.3) annotation (Placement(transformation(extent={{-98,52},{-78,72}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=100e5,
    duration=0.2,
    offset=1.01325e5,
    startTime=0.6) annotation (Placement(transformation(extent={{98,58},{78,78}})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=-20,
    duration=0.1,
    offset=10,
    startTime=1) annotation (Placement(transformation(extent={{-98,80},{-78,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow boundaryGas_Txim_flow1(
    variable_m_flow=true,
    variable_T=true,
    m_flow_const=10,
    xi_const=simCenter.flueGasModel.xi_default) annotation (Placement(transformation(extent={{-54,-2},{-34,18}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi1(variable_p=true, xi_const=simCenter.flueGasModel.xi_default) annotation (Placement(transformation(extent={{70,-2},{50,18}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    height=100e5,
    duration=0.2,
    offset=1.01325e5,
    startTime=0.6) annotation (Placement(transformation(extent={{98,4},{78,24}})));
  ClaRa.Components.Sensors.TinySensorGas_L1_V_flow sensorGas_L1_V_flow(normalise=false, unitOption=1) annotation (Placement(transformation(extent={{-12,-30},{0,-18}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow boundaryGas_Txim_flow2(
    variable_m_flow=true,
    variable_T=true,
    m_flow_const=10,
    xi_const={0,0,0,0,0.77,0.23,0,0,0})         annotation (Placement(transformation(extent={{-56,-40},{-36,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi2(variable_p=true, xi_const=simCenter.flueGasModel.xi_default) annotation (Placement(transformation(extent={{68,-40},{48,-20}})));
  Modelica.Blocks.Sources.Ramp ramp4(
    height=100e5,
    duration=0.2,
    offset=1.01325e5,
    startTime=0.6) annotation (Placement(transformation(extent={{96,-34},{76,-14}})));
  ClaRa.Components.Sensors.TinySensorVLE_L1_p sensorVLE_L1_p(unitOption=2) annotation (Placement(transformation(extent={{-6,-60},{6,-48}})));
  ClaRa.Components.Sensors.TinySensorVLE_L1_T sensorVLE_L1_T annotation (Placement(transformation(extent={{14,-60},{26,-48}})));
  ClaRa.Components.Sensors.TinySensorVLE_L1_m_flow sensorVLE_L1_m_flow(unitOption=3) annotation (Placement(transformation(extent={{-32,-60},{-20,-48}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=10e5) annotation (Placement(transformation(extent={{64,-70},{44,-50}})));
  Modelica.Blocks.Sources.Ramp ramp5(
    height=300,
    duration=0.1,
    offset=273.15,
    startTime=0.3) annotation (Placement(transformation(extent={{-114,-74},{-94,-54}})));
  Modelica.Blocks.Sources.Ramp ramp6(
    height=-20,
    duration=0.1,
    offset=10,
    startTime=1) annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  ClaRa.Components.Sensors.TinySensorVLE_L1_Ex_flow sensorVLE_L1_Ex_flow annotation (Placement(transformation(extent={{-52,-60},{-40,-48}})));
  ClaRa.Components.Sensors.TinySensorGas_L1_Ex_flow sensorGas_L1_Ex_flow annotation (Placement(transformation(extent={{-16,62},{-4,74}})));
  ClaRa.Components.Sensors.TinySensorGas_L1_m_flow sensorGas_L1_m_flow1 annotation (Placement(transformation(extent={{8,8},{20,20}})));
  ClaRa.Components.Sensors.TinySensorGas_L1_V_flow sensorGas_L1_V_flow1 annotation (Placement(transformation(extent={{-16,8},{-4,20}})));
  ClaRa.Components.Sensors.TinySensorGas_L1_p sensorGas_L1_p annotation (Placement(transformation(extent={{28,8},{40,20}})));
  ClaRa.Components.Sensors.TinySensorGas_L1_T sensorGas_L1_T annotation (Placement(transformation(extent={{-32,8},{-20,20}})));
  ClaRa.Components.Sensors.TinySensorGas_L1_O2 sensorGas_L1_O2dry(unitOption=2) annotation (Placement(transformation(extent={{18,-30},{30,-18}})));
equation
  connect(sensorGas_L1_m_flow.outlet, boundaryGas_pTxi.gas_a) annotation (Line(
      points={{30,62},{32,62},{50,62}},
      color={118,106,98},
      thickness=0.5));
  connect(ramp.y, boundaryGas_Txim_flow.T) annotation (Line(points={{-77,62},{-54,62}}, color={0,0,127}));
  connect(ramp1.y, boundaryGas_pTxi.p) annotation (Line(points={{77,68},{70,68}}, color={0,0,127}));
  connect(ramp2.y, boundaryGas_Txim_flow.m_flow) annotation (Line(points={{-77,90},{-68,90},{-68,88},{-62,88},{-62,68},{-54,68}}, color={0,0,127}));
  connect(ramp.y, boundaryGas_Txim_flow1.T) annotation (Line(points={{-77,62},{-68,62},{-68,10},{-62,10},{-62,8},{-54,8}}, color={0,0,127}));
  connect(ramp3.y, boundaryGas_pTxi1.p) annotation (Line(points={{77,14},{70,14}}, color={0,0,127}));
  connect(ramp2.y, boundaryGas_Txim_flow1.m_flow) annotation (Line(points={{-77,90},{-68,90},{-68,34},{-62,34},{-62,14},{-54,14}}, color={0,0,127}));
  connect(sensorGas_L1_V_flow.outlet, boundaryGas_pTxi2.gas_a) annotation (Line(
      points={{0,-30},{48,-30}},
      color={118,106,98},
      thickness=0.5));
  connect(boundaryGas_Txim_flow2.gas_a, sensorGas_L1_V_flow.inlet) annotation (Line(
      points={{-36,-30},{-12,-30}},
      color={118,106,98},
      thickness=0.5));
  connect(ramp.y,boundaryGas_Txim_flow2. T) annotation (Line(points={{-77,62},{-70,62},{-70,-28},{-64,-28},{-64,-30},{-56,-30}},
                                                                                                                           color={0,0,127}));
  connect(ramp4.y,boundaryGas_pTxi2. p) annotation (Line(points={{75,-24},{68,-24}},
                                                                                   color={0,0,127}));
  connect(ramp2.y,boundaryGas_Txim_flow2. m_flow) annotation (Line(points={{-77,90},{-70,90},{-70,-4},{-64,-4},{-64,-24},{-56,-24}},
                                                                                                                                   color={0,0,127}));
  connect(sensorVLE_L1_m_flow.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{-20,-60},{12,-60},{44,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sensorVLE_L1_m_flow.outlet, sensorVLE_L1_p.port) annotation (Line(
      points={{-20,-60},{-10,-60},{0,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_phxi.steam_a, sensorVLE_L1_T.port) annotation (Line(
      points={{44,-60},{20,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(ramp5.y, boundaryVLE_Txim_flow.T) annotation (Line(points={{-93,-64},{-88,-64},{-88,-60},{-82,-60}}, color={0,0,127}));
  connect(ramp6.y, boundaryVLE_Txim_flow.m_flow) annotation (Line(points={{-99,-24},{-90,-24},{-90,-54},{-82,-54}}, color={0,0,127}));
  connect(boundaryVLE_Txim_flow.steam_a, sensorVLE_L1_Ex_flow.inlet) annotation (Line(
      points={{-60,-60},{-56,-60},{-52,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sensorVLE_L1_Ex_flow.outlet, sensorVLE_L1_m_flow.inlet) annotation (Line(
      points={{-40,-60},{-36,-60},{-32,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryGas_Txim_flow.gas_a, sensorGas_L1_Ex_flow.inlet) annotation (Line(
      points={{-34,62},{-28,62},{-16,62}},
      color={118,106,98},
      thickness=0.5));
  connect(sensorGas_L1_Ex_flow.outlet, sensorGas_L1_m_flow.inlet) annotation (Line(
      points={{-4,62},{3,62},{10,62}},
      color={118,106,98},
      thickness=0.5));
  connect(sensorGas_L1_m_flow1.outlet, boundaryGas_pTxi1.gas_a) annotation (Line(
      points={{20,8},{50,8}},
      color={118,106,98},
      thickness=0.5));
  connect(sensorGas_L1_V_flow1.outlet, sensorGas_L1_m_flow1.inlet) annotation (Line(
      points={{-4,8},{-4,8},{8,8}},
      color={118,106,98},
      thickness=0.5));
  connect(boundaryGas_Txim_flow1.gas_a, sensorGas_L1_V_flow1.inlet) annotation (Line(
      points={{-34,8},{-16,8}},
      color={118,106,98},
      thickness=0.5));
  connect(sensorGas_L1_m_flow1.outlet, sensorGas_L1_p.port) annotation (Line(
      points={{20,8},{34,8}},
      color={118,106,98},
      thickness=0.5));
  connect(boundaryGas_Txim_flow1.gas_a, sensorGas_L1_T.port) annotation (Line(
      points={{-34,8},{-26,8}},
      color={118,106,98},
      thickness=0.5));
  connect(sensorGas_L1_V_flow.outlet, sensorGas_L1_O2dry.port) annotation (Line(
      points={{0,-30},{24,-30}},
      color={118,106,98},
      thickness=0.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=2));
end TestSensors;
