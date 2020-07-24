within ClaRa.Components.Mills.PhysicalMills.Volumes.Check;
model TestFuelJoin
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;

  inner ClaRa.SimCenter simCenter(redeclare ClaRa.Basics.Media.FuelTypes.Fuel_verbandsformel_v1 fuelModel1) annotation (Placement(transformation(extent={{-198,140},{-158,160}})));
  Adapters.FuelAerosolDistributor fuelAerosolDistributor(classification=Fundamentals.Records.FuelClassification_example_21classes(), classFraction={0.0297,0.1049,0.1155,0.13,0.111,0.0875,0.0728,0.0541,0.0501,0.0484,0.0432,0.0415,0.0399,0.0363,0.0344,0,0,0,0,0}) annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Adapters.FuelAerosolDistributor fuelAerosolDistributor1(classification=Fundamentals.Records.FuelClassification_example_21classes(), classFraction={0.0297,0.1049,0.1155,0.13,0.111,0.0875,0.0728,0.0541,0.0501,0.0484,0.0432,0.0415,0.0399,0.0363,0.0344,0,0,0,0,0}) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Adapters.AerosolFuelConcentrator aerosolFuelConcentrator(classification=Fundamentals.Records.FuelClassification_example_21classes()) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow     fuelBoundary_m_flowTxi(
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                                    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow     fuelBoundary_m_flowTxi1(
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                                     annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi     fuelBoundary_pTxi(
    variable_p=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                          annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant constantCoal(k=0) annotation (Placement(transformation(extent={{-198,36},{-178,56}})));
  Modelica.Blocks.Sources.Constant temperature(k=273.15 + 20)
                                                         annotation (Placement(transformation(extent={{-196,-74},{-176,-54}})));
  Modelica.Blocks.Sources.Constant pressureOut(k=1.013e5) annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Sources.Constant composition[6](k={0.9,0.05,0.05,0,0,0})
                                                                        "{0.9,0,0,0,0,0.00001}" annotation (Placement(transformation(extent={{-196,-38},{-176,-18}})));
  Modelica.Blocks.Sources.Ramp rampCoal(
    height=0,
    duration=0,
    startTime=0,
    offset=30) "0.7*15.72"
                      annotation (Placement(transformation(extent={{-198,2},{-178,22}})));
  FuelJoin_distributed fuelJoint_distributed(xi_fuel_start={0.9,0.05,0.05,0,0,0}) annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
equation
  connect(constantCoal.y, fuelBoundary_m_flowTxi.m_flow) annotation (Line(points={{-177,46},{-100,46}}, color={0,0,127}));
  connect(temperature.y, fuelBoundary_m_flowTxi1.T) annotation (Line(points={{-175,-64},{-142,-64},{-142,0},{-100,0}}, color={0,0,127}));
  connect(temperature.y, fuelBoundary_m_flowTxi.T) annotation (Line(points={{-175,-64},{-142,-64},{-142,40},{-100,40}}, color={0,0,127}));
  connect(temperature.y, fuelBoundary_pTxi.T) annotation (Line(points={{-175,-64},{120,-64},{120,0},{100,0}}, color={0,0,127}));
  connect(pressureOut.y, fuelBoundary_pTxi.p) annotation (Line(points={{101,50},{120,50},{120,6},{100,6}}, color={0,0,127}));
  connect(composition.y, fuelBoundary_pTxi.xi) annotation (Line(points={{-175,-28},{112,-28},{112,-6},{100,-6}}, color={0,0,127}));
  connect(composition.y, fuelBoundary_m_flowTxi1.xi) annotation (Line(points={{-175,-28},{-120,-28},{-120,-6},{-100,-6}}, color={0,0,127}));
  connect(composition.y, fuelBoundary_m_flowTxi.xi) annotation (Line(points={{-175,-28},{-120,-28},{-120,34},{-100,34}}, color={0,0,127}));
  connect(fuelBoundary_m_flowTxi1.m_flow, rampCoal.y) annotation (Line(points={{-100,6},{-142,6},{-142,12},{-177,12}}, color={0,0,127}));
  connect(fuelBoundary_m_flowTxi.fuel_a, fuelAerosolDistributor.inlet) annotation (Line(
      points={{-80,40},{-60,40}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fuelBoundary_m_flowTxi1.fuel_a, fuelAerosolDistributor1.inlet) annotation (Line(
      points={{-80,0},{-60,0}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(aerosolFuelConcentrator.outlet, fuelBoundary_pTxi.fuel_a) annotation (Line(
      points={{60,0},{70,0},{70,0},{80,0}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fuelAerosolDistributor1.outlet, fuelJoint_distributed.fuelInlet1) annotation (Line(
      points={{-40,0},{-10,0}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fuelJoint_distributed.fuelOutlet, aerosolFuelConcentrator.inlet) annotation (Line(
      points={{10,0},{40,0}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fuelAerosolDistributor.outlet, fuelJoint_distributed.fuelInlet2) annotation (Line(
      points={{-40,40},{0,40},{0,10}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{140,160}})),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end TestFuelJoin;
