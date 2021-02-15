within ClaRa.Components.Mills.PhysicalMills.Volumes.Check;
model TestGrinder
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
  Modelica.Blocks.Sources.Constant constantCoal(k=constMassFlow.k*4)
                                                     annotation (Placement(transformation(extent={{-198,36},{-178,56}})));
  Modelica.Blocks.Sources.Constant temperature(k=273.15 + 20)
                                                         annotation (Placement(transformation(extent={{-196,-74},{-176,-54}})));
  Modelica.Blocks.Sources.Constant pressureOut(k=1.013e5) annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Sources.Constant composition[6](k={0.761,0,0,0,0.004,0.125})
                                                                        "{0.9,0,0,0,0,0.00001}" annotation (Placement(transformation(extent={{-196,-38},{-176,-18}})));
  GrinderRingRoller grinder(
    classification=Fundamentals.Records.FuelClassification_example_21classes(),
    xi_fuel_start={0.761,0,0,0,0.004,0.125},
    m_flow_fuel_nom=5*0.97*13.06) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp rampTableSpeed(
    height=0,
    duration=0,
    offset=45) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={28,90})));
  Modelica.Blocks.Sources.Step rampGrindingPressure1(
    offset=0,
    height=8e5,
    startTime=3600 + 742)
                    "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-106,130})));
  Modelica.Blocks.Sources.Step rampGrindingPressure2(
    startTime=3600,
    offset=94e5,
    height=-8e5)  "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-72,130})));
  Modelica.Blocks.Sources.Constant constGrindingPressure(k=94e5) "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-42,130})));
  Modelica.Blocks.Math.Sum sum1(nin=3, k={1,0,0})
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-72,86})));
  Modelica.Blocks.Sources.Step rampMassFlow1(
    offset=0,
    startTime=4800,
    height=-0.2*0.97*13.05)
                    annotation (Placement(transformation(extent={{-300,-36},{-280,-16}})));
  Modelica.Blocks.Sources.Step rampMassFlow(
    startTime=2400,
    offset=0,
    height=0.1*0.97*13.05)
                    annotation (Placement(transformation(extent={{-298,-2},{-278,18}})));
  Modelica.Blocks.Sources.Constant constMassFlow(k=0.97*13.05) annotation (Placement(transformation(extent={{-298,32},{-278,52}})));
  Modelica.Blocks.Math.Sum sum2(nin=3, k={1,1,1}) "{1,0,0} {0,1,1}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-232,8})));
equation
  connect(constantCoal.y, fuelBoundary_m_flowTxi.m_flow) annotation (Line(points={{-177,46},{-100,46}}, color={0,0,127}));
  connect(temperature.y, fuelBoundary_m_flowTxi1.T) annotation (Line(points={{-175,-64},{-142,-64},{-142,0},{-100,0}}, color={0,0,127}));
  connect(temperature.y, fuelBoundary_m_flowTxi.T) annotation (Line(points={{-175,-64},{-142,-64},{-142,40},{-100,40}}, color={0,0,127}));
  connect(temperature.y, fuelBoundary_pTxi.T) annotation (Line(points={{-175,-64},{120,-64},{120,0},{100,0}}, color={0,0,127}));
  connect(pressureOut.y, fuelBoundary_pTxi.p) annotation (Line(points={{101,50},{120,50},{120,6},{100,6}}, color={0,0,127}));
  connect(composition.y, fuelBoundary_pTxi.xi) annotation (Line(points={{-175,-28},{112,-28},{112,-6},{100,-6}}, color={0,0,127}));
  connect(composition.y, fuelBoundary_m_flowTxi1.xi) annotation (Line(points={{-175,-28},{-120,-28},{-120,-6},{-100,-6}}, color={0,0,127}));
  connect(composition.y, fuelBoundary_m_flowTxi.xi) annotation (Line(points={{-175,-28},{-120,-28},{-120,34},{-100,34}}, color={0,0,127}));
  connect(fuelAerosolDistributor.outlet, grinder.fuelInlet2) annotation (Line(
      points={{-40,40},{-20,40},{0,40},{0,10}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fuelAerosolDistributor1.outlet, grinder.fuelInlet1) annotation (Line(
      points={{-40,0},{-10,0}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(grinder.fuelOutlet, aerosolFuelConcentrator.inlet) annotation (Line(
      points={{10,0},{10,0},{40,0}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
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
  connect(rampTableSpeed.y, grinder.inputTableSpeed) annotation (Line(points={{28,79},{28,68},{8,68},{8,12}},   color={0,0,127}));
  connect(rampGrindingPressure2.y, sum1.u[2]) annotation (Line(points={{-72,119},{-72,119},{-72,98}}, color={0,0,127}));
  connect(constGrindingPressure.y, sum1.u[1]) annotation (Line(points={{-42,119},{-58,119},{-58,98},{-73.3333,98}}, color={0,0,127}));
  connect(rampGrindingPressure1.y, sum1.u[3]) annotation (Line(points={{-106,119},{-90,119},{-90,98},{-70.6667,98}}, color={0,0,127}));
  connect(sum1.y, grinder.inputGrindingPressure) annotation (Line(points={{-72,75},{-72,64},{-8,64},{-8,12}}, color={0,0,127}));
  connect(constMassFlow.y, sum2.u[1]) annotation (Line(points={{-277,42},{-260,42},{-260,6.66667},{-244,6.66667}}, color={0,0,127}));
  connect(rampMassFlow.y, sum2.u[2]) annotation (Line(points={{-277,8},{-260,8},{-260,8},{-244,8}}, color={0,0,127}));
  connect(rampMassFlow1.y, sum2.u[3]) annotation (Line(points={{-279,-26},{-260,-26},{-260,9.33333},{-244,9.33333}}, color={0,0,127}));
  connect(sum2.y, fuelBoundary_m_flowTxi1.m_flow) annotation (Line(points={{-221,8},{-162,8},{-162,6},{-100,6}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{140,160}})),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=10000,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestGrinder;
