within ClaRa.Components.Mills.PhysicalMills.Volumes.Check;
model TestAerosolVolume
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

  inner ClaRa.SimCenter simCenter(redeclare ClaRa.Basics.Media.FuelTypes.Fuel_verbandsformel_v1 fuelModel1)
                                  annotation (Placement(transformation(extent={{-200,140},{-160,160}})));
  Adapters.FuelAerosolDistributor fuelAerosolDistributor(classification=Fundamentals.Records.FuelClassification_example_21classes(), classFraction={0,0,0,0,0,0,0,0,0.06675,0.08127,0.09666,0.1158,0.1380,0.1618,0.023858,0.01762,0.01449,0.01163,0.009153,0.006911}) "{0.002846,0.01234,0.01839,0.02730,0.03342,0.03933,0.04732,0.05477,0.06675,0.08127,0.09666,0.1158,0.1380,0.1618,0.023858,0.01762,0.01449,0.01163,0.009153,0.006911}" annotation (Placement(transformation(extent={{-70,28},{-50,48}})));

  Adapters.AerosolFuelConcentrator aerosolFuelConcentrator(classification=Fundamentals.Records.FuelClassification_example_21classes()) annotation (Placement(transformation(extent={{36,28},{56,48}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi     fuelBoundary_pTxi(    variable_p=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                          annotation (Placement(transformation(extent={{96,28},{76,48}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi     fuelBoundary_pTxi1(
    variable_p=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                           annotation (Placement(transformation(extent={{96,-10},{76,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow     boundaryFuel_Txim_flow(
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                                    annotation (Placement(transformation(extent={{-98,28},{-78,48}})));
  Modelica.Blocks.Sources.Constant composition[6](k={0.761,0,0,0,0.004,0.125})
                                                                        "{0.9,0,0,0,0,0.00001}" annotation (Placement(transformation(extent={{-194,-42},{-174,-22}})));
  Adapters.AerosolFuelConcentrator aerosolFuelConcentrator1(classification=Fundamentals.Records.FuelClassification_example_21classes()) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant pressureOut(k=1.013e5) annotation (Placement(transformation(extent={{200,34},{180,54}})));
  Modelica.Blocks.Sources.Constant temperature(k=273.15 + 100)
                                                         annotation (Placement(transformation(extent={{-196,-82},{-176,-62}})));
  CentrifugalClassifier aerosolVolume(
    classification=Fundamentals.Records.FuelClassification_example_21classes(),
    xi_fuel_start={0.8,0.05,0.05,0,0,0},
    m_flow_fuel_nom=0.97*13.06,
    m_flow_gas_nom=20.83,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2) annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi(xi_const={0,0,0,0,0.79,0.21,0,0,0}, variable_p=true)
                                                                                                            annotation (Placement(transformation(extent={{60,60},{40,80}})));
  Modelica.Blocks.Sources.Ramp rampCoal(
    offset=0.97*13.06,
    height=5,
    duration=10,
    startTime=240000)
                annotation (Placement(transformation(extent={{-194,34},{-174,54}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                       boundaryGas_pTxi1(
                                                                        xi_const={0,0,0,0,0.79,0.21,0,0,0},
    variable_m_flow=true,
    T_const=273.15 + 100)                                                                                   annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

        //45/180*Modelica.Constants.pi
  Modelica.Blocks.Sources.Ramp rampClassifier(
    offset=50,
    height=-20,
    duration=1000,
    startTime=1000)
               "75/180*Modelica.Constants.pi; 53"
               annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,144})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi2(
                                                                        xi_const={0,0,0,0,0.79,0.21,0,0,0}, p_const=simCenter.p_amb_start + 1000)
                                                                                                            annotation (Placement(transformation(extent={{-60,86},{-40,106}})));
  Modelica.Blocks.Sources.Ramp rampPrimaryAir(
    offset=0,
    duration=1000,
    height=-0.5*constantPrimaryAir.k,
    startTime=10000)
               annotation (Placement(transformation(extent={{-146,120},{-126,140}})));
  Modelica.Blocks.Sources.Ramp rampClassifier1(
    offset=0,
    height=20,
    duration=1000,
    startTime=3000)
               "75/180*Modelica.Constants.pi; 53"
               annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={34,144})));
  Modelica.Blocks.Math.Sum sum1(nin=2, k={1,1})   "{0,1,1} {1,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,90})));
  Modelica.Blocks.Math.Sum sum2(nin=3, k={1,1,1}) "{0,1,1} {1,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-88,76})));
  Modelica.Blocks.Sources.Ramp rampPrimaryAir1(
    offset=0,
    duration=1000,
    height=0.5*constantPrimaryAir.k,
    startTime=30000)
               annotation (Placement(transformation(extent={{-146,88},{-126,108}})));
  Modelica.Blocks.Sources.Constant constantPrimaryAir(k=20.83) annotation (Placement(transformation(extent={{-146,56},{-126,76}})));
equation
  connect(composition.y, boundaryFuel_Txim_flow.xi) annotation (Line(points={{-173,-32},{-124,-32},{-124,32},{-98,32}},  color={0,0,127}));
  connect(pressureOut.y, fuelBoundary_pTxi.p) annotation (Line(points={{179,44},{96,44}}, color={0,0,127}));
  connect(pressureOut.y, fuelBoundary_pTxi1.p) annotation (Line(points={{179,44},{162,44},{162,6},{96,6}}, color={0,0,127}));
  connect(temperature.y, fuelBoundary_pTxi1.T) annotation (Line(points={{-175,-72},{-175,-72},{132,-72},{132,0},{96,0}}, color={0,0,127}));
  connect(temperature.y, fuelBoundary_pTxi.T) annotation (Line(points={{-175,-72},{132,-72},{132,38},{96,38}}, color={0,0,127}));
  connect(temperature.y, boundaryFuel_Txim_flow.T) annotation (Line(points={{-175,-72},{-136,-72},{-136,38},{-98,38}},             color={0,0,127}));
  connect(composition.y, fuelBoundary_pTxi.xi) annotation (Line(points={{-173,-32},{116,-32},{116,32},{96,32}}, color={0,0,127}));
  connect(fuelBoundary_pTxi1.xi, composition.y) annotation (Line(points={{96,-6},{116,-6},{116,-32},{-173,-32}}, color={0,0,127}));
  connect(fuelAerosolDistributor.outlet, aerosolVolume.fuelInlet) annotation (Line(
      points={{-50,38},{-10,38},{-10,37.8}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(aerosolVolume.fuelOutlet1, aerosolFuelConcentrator.inlet) annotation (Line(
      points={{10,37.8},{20,37.8},{20,38},{28,38},{28,38},{36,38}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(aerosolVolume.fuelOutlet2, aerosolFuelConcentrator1.inlet) annotation (Line(
      points={{0,30},{0,30},{0,0},{40,0}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(aerosolVolume.gasOutlet, boundaryGas_pTxi.gas_a) annotation (Line(
      points={{10,42},{20,42},{20,70},{40,70}},
      color={118,106,98},
      thickness=0.5));
  connect(boundaryFuel_Txim_flow.m_flow, rampCoal.y) annotation (Line(points={{-98,44},{-173,44}},            color={0,0,127}));
  connect(aerosolVolume.gasInlet, boundaryGas_pTxi1.gas_a) annotation (Line(
      points={{-10,42},{-20,42},{-20,70},{-40,70}},
      color={118,106,98},
      thickness=0.5));
  connect(pressureOut.y, boundaryGas_pTxi.p) annotation (Line(points={{179,44},{162,44},{162,76},{60,76}}, color={0,0,127}));
  connect(aerosolFuelConcentrator.outlet, fuelBoundary_pTxi.fuel_a) annotation (Line(
      points={{56,38},{76,38}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryFuel_Txim_flow.fuel_a, fuelAerosolDistributor.inlet) annotation (Line(
      points={{-78,38},{-70,38}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(aerosolFuelConcentrator1.outlet, fuelBoundary_pTxi1.fuel_a) annotation (Line(
      points={{60,0},{68,0},{68,0},{76,0}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rampClassifier.y, sum1.u[1]) annotation (Line(points={{0,133},{0,102},{-1,102}},         color={0,0,127}));
  connect(rampClassifier1.y, sum1.u[2]) annotation (Line(points={{34,133},{34,122},{1,122},{1,102}}, color={0,0,127}));
  connect(sum2.y, boundaryGas_pTxi1.m_flow) annotation (Line(points={{-77,76},{-60,76}}, color={0,0,127}));
  connect(rampPrimaryAir1.y, sum2.u[2]) annotation (Line(points={{-125,98},{-108,98},{-108,76},{-100,76}}, color={0,0,127}));
  connect(rampPrimaryAir.y, sum2.u[3]) annotation (Line(points={{-125,130},{-108,130},{-108,76},{-108,76},{-108,76},{-100,76},{-100,77.3333}}, color={0,0,127}));
  connect(constantPrimaryAir.y, sum2.u[1]) annotation (Line(points={{-125,66},{-122,66},{-122,66},{-116,66},{-116,74.6667},{-100,74.6667}}, color={0,0,127}));
  connect(sum1.y, aerosolVolume.inputClassifier) annotation (Line(points={{-1.9984e-15,79},{-1.9984e-15,67.5},{0,67.5},{0,52}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,160}})),
    experiment(
      StopTime=7200,
      __Dymola_NumberOfIntervals=7200,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end TestAerosolVolume;
