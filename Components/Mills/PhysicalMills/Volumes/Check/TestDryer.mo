within ClaRa.Components.Mills.PhysicalMills.Volumes.Check;
model TestDryer
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.6.0                           //
//                                                                          //
// Licensed by the ClaRa development team under Modelica License 2.         //
// Copyright  2013-2021, ClaRa development team.                            //
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

  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi     boundaryFuel_pTxi(
    variable_p=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                          annotation (Placement(transformation(extent={{62,-10},{42,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow     boundaryFuel_Txim_flow(
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                                    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  inner ClaRa.SimCenter simCenter(redeclare ClaRa.Basics.Media.FuelTypes.Fuel_verbandsformel_v1 fuelModel1) annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi                                     annotation (Placement(transformation(extent={{42,-40},{22,-20}})));
  Adapters.FuelAerosolDistributor fuelAerosolDistributor(classification=Fundamentals.Records.FuelClassification_example_21classes(), classFraction=ones(20) .* 1/21) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Adapters.AerosolFuelConcentrator aerosolFuelConcentrator(classification=Fundamentals.Records.FuelClassification_example_21classes()) annotation (Placement(transformation(extent={{16,-10},{36,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    offset=10,
    height=0,
    duration=0,
    startTime=0) annotation (Placement(transformation(extent={{-98,20},{-78,40}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=0,
    duration=0,
    offset=400,
    startTime=0)   annotation (Placement(transformation(extent={{-98,-10},{-78,10}})));
  Modelica.Blocks.Sources.Constant ramp4[6](k={0.761,0,0,0,0.004,0.111})
                                                                     annotation (Placement(transformation(extent={{-96,-50},{-76,-30}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    offset=300, duration=1)
                 annotation (Placement(transformation(extent={{100,-26},{80,-6}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    offset=1e5, duration=1)
                 annotation (Placement(transformation(extent={{98,6},{78,26}})));
  Modelica.Blocks.Sources.Constant ramp5[6](k={0.9,0.05,0,0,0,0}) "{0.9,0.05,0,0,0,0}" annotation (Placement(transformation(extent={{100,-60},{80,-40}})));
  Dryer dryer(redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2, classification=Fundamentals.Records.FuelClassification_example_21classes()) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi1(
                                                                        xi_const={0,0,0,0,0.79,0.21,0,0,0},
    T_const=simCenter.T_amb_start + 20,
    p_const=simCenter.p_amb_start + 1000)                                                                   annotation (Placement(transformation(extent={{-50,-38},{-30,-18}})));
equation
  connect(ramp.y, boundaryFuel_Txim_flow.m_flow) annotation (Line(points={{-77,30},{-74,30},{-74,6},{-66,6}}, color={0,0,127}));
  connect(ramp1.y, boundaryFuel_Txim_flow.T) annotation (Line(points={{-77,0},{-77,0},{-66,0}},           color={0,0,127}));
  connect(ramp4.y, boundaryFuel_Txim_flow.xi) annotation (Line(points={{-75,-40},{-70,-40},{-70,-6},{-66,-6}}, color={0,0,127}));
  connect(ramp3.y, boundaryFuel_pTxi.p) annotation (Line(points={{77,16},{70,16},{70,6},{62,6}}, color={0,0,127}));
  connect(ramp2.y, boundaryFuel_pTxi.T) annotation (Line(points={{79,-16},{78,-16},{78,0},{62,0},{62,0}}, color={0,0,127}));
  connect(ramp5.y, boundaryFuel_pTxi.xi) annotation (Line(points={{79,-50},{72,-50},{72,-6},{62,-6}}, color={0,0,127}));
  connect(fuelAerosolDistributor.outlet, dryer.fuelInlet) annotation (Line(
      points={{-20,0},{-16,0},{-10,0}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(aerosolFuelConcentrator.inlet, dryer.fuelOutlet) annotation (Line(
      points={{16,0},{14,0},{10,0}},
      color={73,80,85},
      thickness=0.5));
  connect(dryer.gasInlet, boundaryGas_pTxi1.gas_a) annotation (Line(
      points={{-10,-6},{-14,-6},{-14,-28},{-30,-28}},
      color={118,106,98},
      thickness=0.5));
  connect(dryer.gasOutlet, boundaryGas_pTxi.gas_a) annotation (Line(
      points={{10,-6},{14,-6},{14,-30},{22,-30}},
      color={118,106,98},
      thickness=0.5));
  connect(boundaryFuel_Txim_flow.fuel_a, fuelAerosolDistributor.inlet) annotation (Line(
      points={{-46,0},{-40,0}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(aerosolFuelConcentrator.outlet, boundaryFuel_pTxi.fuel_a) annotation (Line(
      points={{36,0},{42,0}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1200));
end TestDryer;
