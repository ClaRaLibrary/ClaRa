within ClaRa.Components.Mills.PhysicalMills.Check;
model TestMillBox_1
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

  ClaRa.Components.Mills.PhysicalMills.Mill_L4 millBox1(
    m_flow_gas_nom=20.83,
    m_flow_fuel_nom=0.97*13.06,
    classification=Volumes.Fundamentals.Records.FuelClassification_example_21classes(),
    classFraction={0.0297,0.1049,0.1155,0.13,0.111,0.0875,0.0728,0.0541,0.0501,0.0484,0.0432,0.0415,0.0399,0.0363,0.0344,0,0,0,0,0},
    T_grinder_start=273.15 + 20,
    xi_transport_fuel_start={0.761,0,0,0,0.004,0.125},
    xi_classifier_fuel_start={0.761,0,0,0,0.004,0.125},
    xi_grinder_start={0.761,0,0,0,0.004,0.111},
    redeclare model Drying = Volumes.Fundamentals.Drying.Drying_ideal,
    xi_dryer_gas_out_start={0,0,0,0,0.73,0.21,0,0.06,0},
    xi_transport_gas_start={0,0,0,0,0.73,0.21,0,0.06,0},
    xi_classifier_gas_start={0,0,0,0,0.73,0.21,0,0.06,0},
    T_transport_start=273.15 + 100,
    T_classifier_start=273.15 + 100,
    xi_dryer_gas_in_start={0,0,0,0,0.757,0.231,0,0.005,0},
    p_classifier_start=simCenter.p_amb_start + valveGas_L1_1.pressureLoss.Delta_p_nom,
    p_dryer_start=simCenter.p_amb_start + millBox1.flowClassifier.pressureLoss.Delta_p_nom + millBox1.centrifugalClassifier.pressureLoss.Delta_p_nom + valveGas_L1_1.pressureLoss.Delta_p_nom,
    p_transport_start=simCenter.p_amb_start + millBox1.centrifugalClassifier.pressureLoss.Delta_p_nom + valveGas_L1_1.pressureLoss.Delta_p_nom,
    mass_transport_start=1000,
    redeclare model Classifying_centrifugal = Volumes.Fundamentals.Classifying.Classifying_centrifugal (w_prtcl_r_rel_start=cat(
            2,
            10*ones(millBox1.centrifugalClassifier.n, 14),
            0.01*ones(millBox1.centrifugalClassifier.n, 7))),
    redeclare model Classifying_flow = Volumes.Fundamentals.Classifying.Classifying_flow (w_prtcl_rel_start=cat(
            2,
            10*ones(millBox1.flowClassifier.n, 7),
            0.01*ones(millBox1.flowClassifier.n, 14))),
    T_dryer_start=273.15 + 101,
    mass_classifier_start=1000,
    redeclare model Selection = Volumes.Fundamentals.Grinding.Selection_Function.Selection_Steinmetz (s0=425e-10)) "s0 = 325e-10 changed to 425e-10 for FINAL classifier model" annotation (Placement(transformation(extent={{-14,-14},{14,14}})));
  Modelica.Blocks.Sources.Constant pressure(k=simCenter.p_amb_start) annotation (Placement(transformation(extent={{158,16},{138,36}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi(xi_const={0,0,0,0,0.79,0.21,0,0,0}, p_const=simCenter.p_amb_start - 1000)
                                                                                                                                           annotation (Placement(transformation(extent={{100,-70},{80,-50}})));
  inner ClaRa.SimCenter simCenter(redeclare ClaRa.Basics.Media.FuelTypes.Fuel_verbandsformel_v1 fuelModel1) annotation (Placement(transformation(extent={{-738,240},{-698,260}})));
  Modelica.Blocks.Sources.Constant constMassFlow(k=0.97*13.05) annotation (Placement(transformation(extent={{-500,200},{-480,220}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow     fuelBoundary_m_flowTxi(
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                                    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Constant temperature(k=273.15 + 20) annotation (Placement(transformation(extent={{-260,-136},{-240,-116}})));
  Modelica.Blocks.Sources.Constant composition[6](k={0.761,0,0,0,0.004,0.111}) ""
                                                                                 annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi2(
    xi_const={0,0,0,0,0.79,0.21,0,0,0},
    p_const=simCenter.p_amb_start + 3000,
    T_const=273.15 + 302)                                                                                   annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant constGrindingPressure(k=94e5) "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={112,230})));
  Modelica.Blocks.Sources.Constant sourceTableSpeed(k=45)   "rpm" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,90})));
  Modelica.Blocks.Sources.Constant sourceClassifier(k=53) "either guide vane angle (rad) or rotation speed (rpm): 45/180*Modelica.Constants.pi" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,110})));
  Modelica.Blocks.Sources.Ramp rampMassFlow(
    height=10.56 - 0.97*13.05,
    startTime=5000,
    offset=0,
    duration=2)     annotation (Placement(transformation(extent={{-500,160},{-480,180}})));
  Modelica.Blocks.Sources.Step rampGrindingPressure(
    startTime=10000,
    offset=0,
    height=-8.5e5)
                  "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,230})));
  Modelica.Blocks.Sources.Ramp rampMassFlow1(
    offset=0,
    startTime=rampMassFlow.startTime + 583,
    height=-rampMassFlow.height,
    duration=2)                             "583"
                    annotation (Placement(transformation(extent={{-500,120},{-480,140}})));
  Modelica.Blocks.Sources.Step rampGrindingPressure1(
    offset=0,
    startTime=rampGrindingPressure.startTime + 742,
    height=-rampGrindingPressure.height) "pa"
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,230})));
  Modelica.Blocks.Math.Sum sum1(nin=3, k={1,1,1}) "{1,1,1} {1,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,190})));
  Modelica.Blocks.Math.Sum sum2(nin=3, k={1,1,1}) " {1,1,1}{1,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-430,170})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                       boundaryGas_pTxi1(
    T_const=273.15 + 302,
    variable_m_flow=true,
    variable_T=true,
    xi_const={0,0,0,0,0.757,0.231,0,0.005,0})                                                               annotation (Placement(transformation(extent={{-80,-74},{-60,-54}})));
  Modelica.Blocks.Sources.Step rampAirFlow(
    startTime=rampMassFlow.startTime,
    offset=0,
    height=-0.05*constMassFlow.k)     annotation (Placement(transformation(extent={{-460,-58},{-440,-38}})));
  Modelica.Blocks.Sources.Step rampAirFlow1(
    offset=0,
    height=-rampAirFlow.height,
    startTime=rampMassFlow1.startTime)
                          annotation (Placement(transformation(extent={{-460,-98},{-440,-78}})));
  Modelica.Blocks.Math.Sum sum3(nin=5, k={1,1,1,1,1}) "{1,1,1,1,1}{1,0,0,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-390,-88})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=20.83,
    T=50)
         annotation (Placement(transformation(extent={{-360,-18},{-340,2}})));
  Modelica.Blocks.Sources.Constant constAirFlow(k=20.83) annotation (Placement(transformation(extent={{-460,-18},{-440,2}})));

  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi boundaryFuel_pTxi(
    variable_p=true,
    variable_T=true,
    variable_xi=true) annotation (Placement(transformation(extent={{78,10},{58,30}})));
  Modelica.Blocks.Sources.Step rampAirFlow4(
    offset=0,
    height=-rampAirFlow3.height,
    startTime=rampAirFlow3.startTime + 702)
                          annotation (Placement(transformation(extent={{-460,-178},{-440,-158}})));
  Modelica.Blocks.Sources.Step rampAirFlow3(
    startTime=15000,
    offset=0,
    height=-0.9)                      annotation (Placement(transformation(extent={{-460,-138},{-440,-118}})));
  Modelica.Blocks.Sources.Constant constMassFlow1(
                                                 k=0.97*13.05) annotation (Placement(transformation(extent={{-680,220},{-660,240}})));
  Modelica.Blocks.Sources.Ramp rampMassFlow2(
    height=10.56 - 0.97*13.05,
    offset=0,
    startTime=8514,
    duration=2)     annotation (Placement(transformation(extent={{-680,180},{-660,200}})));
  Modelica.Blocks.Sources.Ramp rampMassFlow3(
    offset=0,
    height=-rampMassFlow2.height,
    startTime=9186,
    duration=2)                             "583"
                    annotation (Placement(transformation(extent={{-680,140},{-660,160}})));
  Modelica.Blocks.Math.Sum sum4(nin=5, k={1,1,1,1,1})
                                                  "{1,0,0} {0,1,1}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-610,150})));
  Modelica.Blocks.Sources.Ramp rampMassFlow4(
    height=10.56 - 0.97*13.05,
    offset=0,
    startTime=10130,
    duration=2)     annotation (Placement(transformation(extent={{-680,100},{-660,120}})));
  Modelica.Blocks.Sources.Ramp rampMassFlow5(
    offset=0,
    height=-rampMassFlow4.height,
    startTime=10710,
    duration=2)                             "583"
                    annotation (Placement(transformation(extent={{-680,60},{-660,80}})));
  Modelica.Blocks.Sources.Constant constGrindingPressure1(
                                                         k=94e5) "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-230,230})));
  Modelica.Blocks.Sources.Step rampGrindingPressure2(
    offset=0,
    startTime=8513,
    height=-4.25e5)
                  "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-190,230})));
  Modelica.Blocks.Sources.Step rampGrindingPressure3(
    offset=0,
    height=-rampGrindingPressure2.height,
    startTime=9197) "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-150,230})));
  Modelica.Blocks.Sources.Step rampGrindingPressure4(
    offset=0,
    startTime=11460,
    height=-8.5e5)
                  "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-110,230})));
  Modelica.Blocks.Sources.Step rampGrindingPressure5(
    offset=0,
    height=-rampGrindingPressure4.height,
    startTime=12200)
                    "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,230})));
  Modelica.Blocks.Math.Sum sum5(nin=5, k={1,1,1,1,1})
                                                  "{0,1,1} {1,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-150,190})));
  Modelica.Blocks.Sources.Constant constAirFlow1(
                                                k=20.83) annotation (Placement(transformation(extent={{-680,2},{-660,22}})));
  Modelica.Blocks.Sources.Step rampAirFlow2(
    offset=0,
    startTime=rampMassFlow2.startTime,
    height=-0.05*constMassFlow1.k)    annotation (Placement(transformation(extent={{-680,-38},{-660,-18}})));
  Modelica.Blocks.Sources.Step rampAirFlow5(
    offset=0,
    startTime=rampMassFlow3.startTime,
    height=-rampAirFlow2.height)
                          annotation (Placement(transformation(extent={{-680,-78},{-660,-58}})));
  Modelica.Blocks.Sources.Step rampAirFlow6(
    offset=0,
    height=-0.9,
    startTime=13060)                  annotation (Placement(transformation(extent={{-680,-198},{-660,-178}})));
  Modelica.Blocks.Sources.Step rampAirFlow7(
    offset=0,
    startTime=13790,
    height=-rampAirFlow6.height)
                          annotation (Placement(transformation(extent={{-680,-238},{-660,-218}})));
  Modelica.Blocks.Math.Sum sum6(nin=7, k={1,1,1,1,1,1,1})
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-610,-88})));
  Modelica.Blocks.Sources.Step rampAirFlow8(
    offset=0,
    startTime=rampMassFlow4.startTime,
    height=-0.05*constMassFlow1.k)    annotation (Placement(transformation(extent={{-680,-118},{-660,-98}})));
  Modelica.Blocks.Sources.Step rampAirFlow9(
    offset=0,
    startTime=rampMassFlow5.startTime,
    height=-rampAirFlow8.height)
                          annotation (Placement(transformation(extent={{-680,-158},{-660,-138}})));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.97*13.05,
    T=2) annotation (Placement(transformation(extent={{-360,158},{-340,178}})));
  Modelica.Blocks.Sources.Constant constTempAir(k=273.15 + 300) annotation (Placement(transformation(extent={{-460,-240},{-440,-220}})));
  Modelica.Blocks.Sources.Step stepTempAir(
    offset=0,
    startTime=rampAirFlow.startTime,
    height=-15)                      annotation (Placement(transformation(extent={{-460,-280},{-440,-260}})));
  Modelica.Blocks.Sources.Step stepTempAir1(
    offset=0,
    startTime=rampAirFlow1.startTime,
    height=-stepTempAir.height)       annotation (Placement(transformation(extent={{-460,-320},{-440,-300}})));
  Modelica.Blocks.Sources.Step stepTempAir2(
    offset=0,
    height=-7,
    startTime=rampAirFlow3.startTime) annotation (Placement(transformation(extent={{-460,-360},{-440,-340}})));
  Modelica.Blocks.Sources.Step stepTempAir3(
    offset=0,
    startTime=rampAirFlow4.startTime,
    height=-stepTempAir2.height)      annotation (Placement(transformation(extent={{-460,-400},{-440,-380}})));
  Modelica.Blocks.Math.Sum sum7(nin=5, k={1,1,1,1,1}) "{1,1,1,1,1}{1,0,0,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-390,-310})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=50,
    y_start=273.15 + 300)
         annotation (Placement(transformation(extent={{-360,-240},{-340,-220}})));
  Modelica.Blocks.Sources.Constant constTempAir1(
                                                k=273.15 + 300) annotation (Placement(transformation(extent={{-680,-300},{-660,-280}})));
  Modelica.Blocks.Sources.Step stepTempAir4(
    offset=0,
    height=-15,
    startTime=rampAirFlow2.startTime)
                                     annotation (Placement(transformation(extent={{-680,-340},{-660,-320}})));
  Modelica.Blocks.Sources.Step stepTempAir5(
    offset=0,
    height=15,
    startTime=rampAirFlow5.startTime) annotation (Placement(transformation(extent={{-680,-380},{-660,-360}})));
  Modelica.Blocks.Sources.Step stepTempAir6(
    offset=0,
    height=-7,
    startTime=rampAirFlow6.startTime) annotation (Placement(transformation(extent={{-680,-500},{-660,-480}})));
  Modelica.Blocks.Sources.Step stepTempAir7(
    offset=0,
    height=7,
    startTime=rampAirFlow7.startTime) annotation (Placement(transformation(extent={{-680,-540},{-660,-520}})));
  Modelica.Blocks.Math.Sum sum8(nin=7, k={1,1,1,1,1,1,1})
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-612,-370})));
  Modelica.Blocks.Sources.Step stepTempAir8(
    offset=0,
    height=-15,
    startTime=rampAirFlow8.startTime) annotation (Placement(transformation(extent={{-680,-420},{-660,-400}})));
  Modelica.Blocks.Sources.Step stepTempAir9(
    offset=0,
    height=15,
    startTime=rampAirFlow9.startTime) annotation (Placement(transformation(extent={{-680,-460},{-660,-440}})));
  Modelica.Blocks.Math.Sum sum9(nin=3, k={1,1,1}) "{1,1,1} {1,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,70})));
  Modelica.Blocks.Sources.Ramp rampClassifier(
    offset=0,
    startTime=20000,
    duration=500,
    height=-15)      "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,110})));
  Modelica.Blocks.Sources.Ramp ramprampClassifier1(
    offset=0,
    startTime=21000,
    height=-rampClassifier.height,
    duration=500)                  "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,110})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 valveGas_L1_1(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=millBox1.m_flow_gas_nom, Delta_p_nom=2000)) annotation (Placement(transformation(extent={{46,-66},{66,-54}})));
equation
  connect(temperature.y,fuelBoundary_m_flowTxi. T) annotation (Line(points={{-239,-126},{-222,-126},{-222,20},{-80,20}},color={0,0,127}));
  connect(composition.y,fuelBoundary_m_flowTxi. xi) annotation (Line(points={{-239,-90},{-200,-90},{-200,14},{-80,14}},  color={0,0,127}));
  connect(sourceTableSpeed.y, millBox1.inputTableSpeed) annotation (Line(points={{0,79},{0,14.8}}, color={0,0,127}));
  connect(boundaryGas_pTxi1.gas_a, millBox1.gasInlet) annotation (Line(
      points={{-60,-64},{-40,-64},{-40,-2},{-14,-2}},
      color={118,106,98},
      thickness=0.5));
  connect(millBox1.fuelInlet, fuelBoundary_m_flowTxi.fuel_a) annotation (Line(
      points={{-14,2},{-40,2},{-40,20},{-60,20}},
      color={27,36,42},
      thickness=0.5));
  connect(millBox1.fuelOutlet, boundaryFuel_pTxi.fuel_a) annotation (Line(
      points={{14,2},{36,2},{36,20},{58,20}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pressure.y, boundaryFuel_pTxi.p) annotation (Line(points={{137,26},{78,26}}, color={0,0,127}));
  connect(boundaryFuel_pTxi.T, temperature.y) annotation (Line(points={{78,20},{128,20},{128,-126},{-239,-126}}, color={0,0,127}));
  connect(boundaryFuel_pTxi.xi, composition.y) annotation (Line(points={{78,14},{106,14},{106,-90},{-239,-90}}, color={0,0,127}));
  connect(constGrindingPressure1.y, sum5.u[1]) annotation (Line(points={{-230,219},{-228,219},{-228,212},{-151.6,212},{-151.6,202}}, color={0,0,127}));
  connect(rampGrindingPressure2.y, sum5.u[2]) annotation (Line(points={{-190,219},{-190,212},{-150.8,212},{-150.8,202}}, color={0,0,127}));
  connect(rampGrindingPressure3.y, sum5.u[3]) annotation (Line(points={{-150,219},{-150,202},{-150,202}}, color={0,0,127}));
  connect(rampGrindingPressure4.y, sum5.u[4]) annotation (Line(points={{-110,219},{-110,219},{-110,212},{-149.2,212},{-149.2,202}}, color={0,0,127}));
  connect(rampGrindingPressure5.y, sum5.u[5]) annotation (Line(points={{-70,219},{-70,219},{-70,212},{-150,212},{-150,202},{-148.4,202}}, color={0,0,127}));
  connect(constMassFlow1.y, sum4.u[1]) annotation (Line(points={{-659,230},{-644,230},{-644,148.4},{-622,148.4}},
                                                                                                                color={0,0,127}));
  connect(rampMassFlow2.y, sum4.u[2]) annotation (Line(points={{-659,190},{-644,190},{-644,149.2},{-622,149.2}},
                                                                                                               color={0,0,127}));
  connect(rampMassFlow3.y, sum4.u[3]) annotation (Line(points={{-659,150},{-622,150}}, color={0,0,127}));
  connect(rampMassFlow4.y, sum4.u[4]) annotation (Line(points={{-659,110},{-656,110},{-656,112},{-644,112},{-644,150.8},{-622,150.8}}, color={0,0,127}));
  connect(rampMassFlow5.y, sum4.u[5]) annotation (Line(points={{-659,70},{-644,70},{-644,151.6},{-622,151.6}},     color={0,0,127}));
  connect(constAirFlow1.y, sum6.u[1]) annotation (Line(points={{-659,12},{-642,12},{-642,-89.7143},{-622,-89.7143}},     color={0,0,127}));
  connect(rampAirFlow2.y, sum6.u[2]) annotation (Line(points={{-659,-28},{-642,-28},{-642,-89.1429},{-622,-89.1429}},   color={0,0,127}));
  connect(rampAirFlow5.y, sum6.u[3]) annotation (Line(points={{-659,-68},{-642,-68},{-642,-88.5714},{-622,-88.5714}},   color={0,0,127}));
  connect(rampAirFlow8.y, sum6.u[4]) annotation (Line(points={{-659,-108},{-642,-108},{-642,-88},{-622,-88}},   color={0,0,127}));
  connect(rampAirFlow9.y, sum6.u[5]) annotation (Line(points={{-659,-148},{-642,-148},{-642,-87.4286},{-622,-87.4286}},                         color={0,0,127}));
  connect(rampAirFlow6.y, sum6.u[6]) annotation (Line(points={{-659,-188},{-642,-188},{-642,-86.8571},{-622,-86.8571}}, color={0,0,127}));
  connect(rampAirFlow7.y, sum6.u[7]) annotation (Line(points={{-659,-228},{-642,-228},{-642,-86.2857},{-622,-86.2857}}, color={0,0,127}));
  connect(constGrindingPressure.y, sum1.u[1]) annotation (Line(points={{112,219},{112,220},{112,220},{112,220},{112,202},{68.6667,202}}, color={0,0,127}));
  connect(rampGrindingPressure.y, sum1.u[2]) annotation (Line(points={{70,219},{70,202}}, color={0,0,127}));
  connect(rampGrindingPressure1.y, sum1.u[3]) annotation (Line(points={{30,219},{30,202},{71.3333,202}}, color={0,0,127}));
  connect(constMassFlow.y, sum2.u[1]) annotation (Line(points={{-479,210},{-462,210},{-462,168.667},{-442,168.667}}, color={0,0,127}));
  connect(rampMassFlow.y, sum2.u[2]) annotation (Line(points={{-479,170},{-442,170}}, color={0,0,127}));
  connect(rampMassFlow1.y, sum2.u[3]) annotation (Line(points={{-479,130},{-462,130},{-462,170},{-442,170},{-442,171.333}},                        color={0,0,127}));
  connect(constAirFlow.y, sum3.u[1]) annotation (Line(points={{-439,-8},{-422,-8},{-422,-89.6},{-402,-89.6}},       color={0,0,127}));
  connect(rampAirFlow.y, sum3.u[2]) annotation (Line(points={{-439,-48},{-420,-48},{-420,-88.8},{-402,-88.8}},     color={0,0,127}));
  connect(rampAirFlow1.y, sum3.u[3]) annotation (Line(points={{-439,-88},{-402,-88}},                           color={0,0,127}));
  connect(rampAirFlow3.y, sum3.u[4]) annotation (Line(points={{-439,-128},{-422,-128},{-422,-88},{-402,-88},{-402,-87.2}},                            color={0,0,127}));
  connect(rampAirFlow4.y, sum3.u[5]) annotation (Line(points={{-439,-168},{-422,-168},{-422,-86.4},{-402,-86.4}},   color={0,0,127}));
  connect(firstOrder1.y, fuelBoundary_m_flowTxi.m_flow) annotation (Line(points={{-339,168},{-292,168},{-292,26},{-80,26}}, color={0,0,127}));
  connect(constTempAir.y, sum7.u[1]) annotation (Line(points={{-439,-230},{-420,-230},{-420,-311.6},{-402,-311.6}}, color={0,0,127}));
  connect(stepTempAir.y, sum7.u[2]) annotation (Line(points={{-439,-270},{-420,-270},{-420,-310.8},{-402,-310.8}}, color={0,0,127}));
  connect(stepTempAir1.y, sum7.u[3]) annotation (Line(points={{-439,-310},{-402,-310}},                             color={0,0,127}));
  connect(stepTempAir2.y, sum7.u[4]) annotation (Line(points={{-439,-350},{-420,-350},{-420,-309.2},{-402,-309.2}},                         color={0,0,127}));
  connect(stepTempAir3.y, sum7.u[5]) annotation (Line(points={{-439,-390},{-420,-390},{-420,-308.4},{-402,-308.4}},                         color={0,0,127}));
  connect(firstOrder2.y, boundaryGas_pTxi1.T) annotation (Line(points={{-339,-230},{-326,-230},{-326,-230},{-122,-230},{-122,-64},{-80,-64}}, color={0,0,127}));
  connect(constTempAir1.y, sum8.u[1]) annotation (Line(points={{-659,-290},{-642,-290},{-642,-371.714},{-624,-371.714}}, color={0,0,127}));
  connect(stepTempAir4.y, sum8.u[2]) annotation (Line(points={{-659,-330},{-642,-330},{-642,-371.143},{-624,-371.143}}, color={0,0,127}));
  connect(stepTempAir5.y, sum8.u[3]) annotation (Line(points={{-659,-370},{-642,-370},{-642,-370.571},{-624,-370.571}}, color={0,0,127}));
  connect(stepTempAir8.y, sum8.u[4]) annotation (Line(points={{-659,-410},{-642,-410},{-642,-370},{-624,-370}}, color={0,0,127}));
  connect(stepTempAir9.y, sum8.u[5]) annotation (Line(points={{-659,-450},{-642,-450},{-642,-369.429},{-624,-369.429}}, color={0,0,127}));
  connect(stepTempAir6.y, sum8.u[6]) annotation (Line(points={{-659,-490},{-642,-490},{-642,-368.857},{-624,-368.857}}, color={0,0,127}));
  connect(stepTempAir7.y, sum8.u[7]) annotation (Line(points={{-659,-530},{-642,-530},{-642,-368.286},{-624,-368.286}}, color={0,0,127}));
  connect(sum2.y, firstOrder1.u) annotation (Line(points={{-419,170},{-392,170},{-392,168},{-362,168}}, color={0,0,127}));
  connect(sum3.y, firstOrder.u) annotation (Line(points={{-379,-88},{-368,-88},{-368,-8},{-362,-8}}, color={0,0,127}));
  connect(firstOrder2.u, sum7.y) annotation (Line(points={{-362,-230},{-370,-230},{-370,-310},{-379,-310}}, color={0,0,127}));
  connect(sum1.y, millBox1.inputGrindingPressure) annotation (Line(points={{70,179},{70,146},{-34,146},{-34,40},{-6,40},{-6,14.8}}, color={0,0,127}));
  connect(sum9.y, millBox1.inputClassifier) annotation (Line(points={{50,59},{50,40},{6.2,40},{6.2,14.8}}, color={0,0,127}));
  connect(sourceClassifier.y, sum9.u[1]) annotation (Line(points={{50,99},{50,90},{50,82},{48.6667,82}}, color={0,0,127}));
  connect(rampClassifier.y, sum9.u[2]) annotation (Line(points={{90,99},{90,92},{50,92},{50,82}}, color={0,0,127}));
  connect(ramprampClassifier1.y, sum9.u[3]) annotation (Line(points={{130,99},{130,92},{51.3333,92},{51.3333,82}}, color={0,0,127}));
  connect(millBox1.gasOutlet, valveGas_L1_1.inlet) annotation (Line(
      points={{14,-2},{36,-2},{36,-60},{46,-60}},
      color={118,106,98},
      thickness=0.5));
  connect(valveGas_L1_1.outlet, boundaryGas_pTxi.gas_a) annotation (Line(
      points={{66,-60},{80,-60}},
      color={118,106,98},
      thickness=0.5));
  connect(firstOrder.y, boundaryGas_pTxi1.m_flow) annotation (Line(points={{-339,-8},{-264,-8},{-264,-58},{-80,-58}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-740,-420},{180,260}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-740,-420},{180,260}})),
    experiment(
      StopTime=5000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestMillBox_1;
