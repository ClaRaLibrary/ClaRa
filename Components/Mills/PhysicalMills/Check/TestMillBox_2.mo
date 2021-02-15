within ClaRa.Components.Mills.PhysicalMills.Check;
model TestMillBox_2
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

  Modelica.Blocks.Sources.Constant pressure(k=simCenter.p_amb_start) annotation (Placement(transformation(extent={{158,16},{138,36}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi(xi_const={0,0,0,0,0.79,0.21,0,0,0}, p_const=simCenter.p_amb_start - 1000)
                                                                                                                                           annotation (Placement(transformation(extent={{100,-50},{80,-30}})));
  inner ClaRa.SimCenter simCenter(redeclare ClaRa.Basics.Media.Fuel.CoalOilMixture fuelModel1)
                                                                                             annotation (Placement(transformation(extent={{-738,240},{-698,260}})));
  Modelica.Blocks.Sources.Constant constMassFlow(k=20)         annotation (Placement(transformation(extent={{-440,20},{-420,40}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow     fuelBoundary_m_flowTxi(
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true)                                                                                                                                                                    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Constant temperature(k=273.15 + 20) annotation (Placement(transformation(extent={{-260,-136},{-240,-116}})));
  Modelica.Blocks.Sources.Constant composition[simCenter.fuelModel1.N_c - 1](k=simCenter.fuelModel1.defaultComposition) annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi2(
    xi_const={0,0,0,0,0.79,0.21,0,0,0},
    p_const=simCenter.p_amb_start + 3000,
    T_const=273.15 + 302)                                                                                   annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant constGrindingPressure(k=113e5)
                                                                 "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={112,230})));
  Modelica.Blocks.Sources.Constant sourceTableSpeed(k=22.6) "rpm" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,90})));
  Modelica.Blocks.Sources.Constant sourceClassifier(k=65) "either guide vane angle (rad) or rotation speed (rpm): 45/180*Modelica.Constants.pi" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,110})));
  Modelica.Blocks.Sources.Ramp rampMassFlow(
    startTime=5000,
    offset=0,
    duration=2,
    height=-constMassFlow.k*0.16578)
                    annotation (Placement(transformation(extent={{-440,-20},{-420,0}})));
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
                    annotation (Placement(transformation(extent={{-440,-60},{-420,-40}})));
  Modelica.Blocks.Sources.Step rampGrindingPressure1(
    offset=0,
    startTime=rampGrindingPressure.startTime + 742,
    height=-rampGrindingPressure.height)
                    "pa" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,230})));
  Modelica.Blocks.Math.Sum sum1(nin=3, k={1,1,1}) "{0,1,1} {1,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,190})));
  Modelica.Blocks.Math.Sum sum2(nin=3, k={1,1,1}) "{1,0,0} {0,1,1}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-370,-10})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                       boundaryGas_pTxi1(
    variable_m_flow=true,
    T_const=273.15 + 238,
    xi_const={0,0,0,0,0.757,0.231,0,0.005,0},
    variable_T=false)                                                                                       annotation (Placement(transformation(extent={{-80,-74},{-60,-54}})));
  Modelica.Blocks.Sources.Step rampAirFlow(
    startTime=rampMassFlow.startTime,
    offset=0,
    height=-constAirFlow.k*0.03)      annotation (Placement(transformation(extent={{-500,-200},{-480,-180}})));
  Modelica.Blocks.Sources.Step rampAirFlow1(
    offset=0,
    startTime=rampMassFlow1.startTime,
    height=-rampAirFlow.height)
                          annotation (Placement(transformation(extent={{-500,-240},{-480,-220}})));
  Modelica.Blocks.Math.Sum sum3(nin=5, k={1,1,1,1,1})
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-430,-230})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=50,
    y_start=8.5 + 17.8)
         annotation (Placement(transformation(extent={{-400,-160},{-380,-140}})));
  Modelica.Blocks.Sources.Constant constAirFlow(k=8.5 + 17.8)
                                                         annotation (Placement(transformation(extent={{-500,-160},{-480,-140}})));

  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi boundaryFuel_pTxi(
    variable_p=true,
    variable_T=true,
    variable_xi=true) annotation (Placement(transformation(extent={{78,10},{58,30}})));
  Modelica.Blocks.Sources.Step rampAirFlow4(
    offset=0,
    height=-rampAirFlow3.height,
    startTime=rampAirFlow3.startTime + 702)
                          annotation (Placement(transformation(extent={{-500,-320},{-480,-300}})));
  Modelica.Blocks.Sources.Step rampAirFlow3(
    startTime=15000,
    offset=0,
    height=-0.9)                      annotation (Placement(transformation(extent={{-500,-280},{-480,-260}})));

  ClaRa.Components.Mills.PhysicalMills.Mill_L4 millBox1(
    xi_grinder_start={0.9,0,0.08},
    xi_transport_fuel_start={0.9,0,0.08},
    xi_classifier_fuel_start={0.9,0,0.08},
    classification=Volumes.Fundamentals.Records.FuelClassification_example_21classes(),
    classFraction={0.0297,0.1049,0.1155,0.13,0.111,0.0875,0.0728,0.0541,0.0501,0.0484,0.0432,0.0415,0.0399,0.0363,0.0344,0,0,0,0,0},
    radius_table=0.5*2.55,
    Delta_p_mill_nom=9000,
    P_grinding_nom=705e3,
    m_flow_fuel_nom=26.38,
    m_flow_gas_nom=33.64,
    radius_classifier_outer=0.5*4.14,
    height_classifier=2.22,
    radius_chute=0.5*1,
    height_transport=5.68,
    A_cross_transport=7.98,
    radius_classifier_inner=0.5*1,
    p_classifier_start=simCenter.p_amb_start + valveGas_L1_1.pressureLoss.Delta_p_nom,
    p_dryer_start=simCenter.p_amb_start + millBox1.flowClassifier.pressureLoss.Delta_p_nom + millBox1.centrifugalClassifier.pressureLoss.Delta_p_nom + valveGas_L1_1.pressureLoss.Delta_p_nom,
    p_transport_start=simCenter.p_amb_start + millBox1.flowClassifier.pressureLoss.Delta_p_nom + valveGas_L1_1.pressureLoss.Delta_p_nom,
    mass_transport_start=550,
    mass_classifier_start=165,
    redeclare model Classifying_centrifugal = Volumes.Fundamentals.Classifying.Classifying_centrifugal (
        slip_w_gas_t=16/65,
        w_prtcl_r_rel_start=cat(
            2,
            10*ones(millBox1.centrifugalClassifier.n, 14),
            0.01*ones(millBox1.centrifugalClassifier.n, 7)),
        w_gas_r_in_start=1.00756),
    redeclare model Classifying_flow = Volumes.Fundamentals.Classifying.Classifying_flow (w_prtcl_rel_start=cat(
            2,
            10*ones(millBox1.flowClassifier.n, 7),
            0.01*ones(millBox1.flowClassifier.n, 14)), w_gas_start=3.457),
    T_transport_start=273.15 + 72,
    T_classifier_start=273.15 + 72,
    m_flow_H2O_evap_start=1.432,
    T_dryer_start=273.15 + 72,
    xi_dryer_gas_in_start={0,0,0,0,0.757,0.231,0,0.005,0},
    xi_dryer_gas_out_start={0,0,0,0,0.757,0.231,0,0.02,0},
    xi_transport_gas_start={0,0,0,0,0.757,0.231,0,0.02,0},
    xi_classifier_gas_start={0,0,0,0,0.757,0.231,0,0.02,0},
    T_grinder_start=273.15 + 72,
    redeclare model Transport = Volumes.Fundamentals.Grinding.Transport_Velocity.Transport_complex (alpha_start=30/180*Modelica.Constants.pi),
    recirculation_rate_grinder_start=11.45,
    mass_mill=1.5*116e3,
    redeclare model Selection = Volumes.Fundamentals.Grinding.Selection_Function.Selection_Steinmetz (
        diameter_roll=1.98,
        width_roll=0.68,
        s0=665e-10)) "" annotation (Placement(transformation(extent={{-14,-14},{14,14}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=1,
    y_start=20)
         annotation (Placement(transformation(extent={{-340,-20},{-320,0}})));
  Modelica.Blocks.Math.Sum sum9(nin=3, k={1,1,1}) "{1,1,1} {1,0,0}"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,70})));
  Modelica.Blocks.Sources.Ramp rampClassifier(
    offset=0,
    startTime=20000,
    duration=500,
    height=-20)      "pa" annotation (Placement(transformation(
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
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 valveGas_L1_1(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=millBox1.m_flow_gas_nom, Delta_p_nom=2000)) annotation (Placement(transformation(extent={{46,-46},{66,-34}})));
  Modelica.Blocks.Continuous.SecondOrder secondOrder(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    D=1,
    y_start=0.442702,
    w=1/100)              annotation (Placement(transformation(extent={{-216,128},{-196,148}})));
equation
  connect(temperature.y,fuelBoundary_m_flowTxi. T) annotation (Line(points={{-239,-126},{-222,-126},{-222,20},{-80,20}},color={0,0,127}));
  connect(composition.y,fuelBoundary_m_flowTxi. xi) annotation (Line(points={{-239,-90},{-200,-90},{-200,14},{-80,14}},  color={0,0,127}));
  connect(pressure.y, boundaryFuel_pTxi.p) annotation (Line(points={{137,26},{78,26}}, color={0,0,127}));
  connect(boundaryFuel_pTxi.T, temperature.y) annotation (Line(points={{78,20},{128,20},{128,-126},{-239,-126}}, color={0,0,127}));
  connect(boundaryFuel_pTxi.xi, composition.y) annotation (Line(points={{78,14},{106,14},{106,-90},{-239,-90}}, color={0,0,127}));
  connect(constGrindingPressure.y, sum1.u[1]) annotation (Line(points={{112,219},{112,220},{112,220},{112,220},{112,202},{68.6667,202}}, color={0,0,127}));
  connect(rampGrindingPressure.y, sum1.u[2]) annotation (Line(points={{70,219},{70,202}}, color={0,0,127}));
  connect(rampGrindingPressure1.y, sum1.u[3]) annotation (Line(points={{30,219},{30,202},{71.3333,202}}, color={0,0,127}));
  connect(constMassFlow.y, sum2.u[1]) annotation (Line(points={{-419,30},{-402,30},{-402,-11.3333},{-382,-11.3333}}, color={0,0,127}));
  connect(rampMassFlow.y, sum2.u[2]) annotation (Line(points={{-419,-10},{-382,-10}}, color={0,0,127}));
  connect(rampMassFlow1.y, sum2.u[3]) annotation (Line(points={{-419,-50},{-414,-50},{-414,-50},{-402,-50},{-402,-10},{-382,-10},{-382,-8.66667}}, color={0,0,127}));
  connect(constAirFlow.y, sum3.u[1]) annotation (Line(points={{-479,-150},{-460,-150},{-460,-231.6},{-442,-231.6}}, color={0,0,127}));
  connect(rampAirFlow.y, sum3.u[2]) annotation (Line(points={{-479,-190},{-460,-190},{-460,-230.8},{-442,-230.8}}, color={0,0,127}));
  connect(rampAirFlow1.y, sum3.u[3]) annotation (Line(points={{-479,-230},{-442,-230}},                         color={0,0,127}));
  connect(rampAirFlow3.y, sum3.u[4]) annotation (Line(points={{-479,-270},{-462,-270},{-462,-230},{-442,-230},{-442,-229.2}},                         color={0,0,127}));
  connect(rampAirFlow4.y, sum3.u[5]) annotation (Line(points={{-479,-310},{-462,-310},{-462,-228.4},{-442,-228.4}}, color={0,0,127}));
  connect(sum3.y, firstOrder.u) annotation (Line(points={{-419,-230},{-406,-230},{-406,-150},{-402,-150}}, color={0,0,127}));
  connect(firstOrder.y, boundaryGas_pTxi1.m_flow) annotation (Line(points={{-379,-150},{-290,-150},{-290,-58},{-80,-58}}, color={0,0,127}));
  connect(fuelBoundary_m_flowTxi.fuel_a, millBox1.fuelInlet) annotation (Line(
      points={{-60,20},{-38,20},{-38,2},{-14,2}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryGas_pTxi1.gas_a, millBox1.gasInlet) annotation (Line(
      points={{-60,-64},{-48,-64},{-48,-64},{-38,-64},{-38,-2},{-14,-2}},
      color={118,106,98},
      thickness=0.5));
  connect(millBox1.fuelOutlet, boundaryFuel_pTxi.fuel_a) annotation (Line(
      points={{14,2},{40,2},{40,20},{58,20}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sourceTableSpeed.y, millBox1.inputTableSpeed) annotation (Line(points={{0,79},{0,14.8}}, color={0,0,127}));
  connect(sum1.y, millBox1.inputGrindingPressure) annotation (Line(points={{70,179},{70,152},{-28,152},{-28,28},{-6,28},{-6,14.8}}, color={0,0,127}));
  connect(sum2.y, firstOrder1.u) annotation (Line(points={{-359,-10},{-342,-10}}, color={0,0,127}));
  connect(firstOrder1.y, fuelBoundary_m_flowTxi.m_flow) annotation (Line(points={{-319,-10},{-260,-10},{-260,26},{-80,26}}, color={0,0,127}));
  connect(sourceClassifier.y, sum9.u[1]) annotation (Line(points={{50,99},{50,90},{50,82},{48.6667,82}}, color={0,0,127}));
  connect(rampClassifier.y, sum9.u[2]) annotation (Line(points={{90,99},{90,90},{50,90},{50,82}}, color={0,0,127}));
  connect(ramprampClassifier1.y, sum9.u[3]) annotation (Line(points={{130,99},{130,90},{51.3333,90},{51.3333,82}}, color={0,0,127}));
  connect(sum9.y, millBox1.inputClassifier) annotation (Line(points={{50,59},{50,36},{6,36},{6,14.8},{6.2,14.8}}, color={0,0,127}));
  connect(millBox1.gasOutlet, valveGas_L1_1.inlet) annotation (Line(
      points={{14,-2},{40,-2},{40,-40},{46,-40}},
      color={118,106,98},
      thickness=0.5));
  connect(valveGas_L1_1.outlet, boundaryGas_pTxi.gas_a) annotation (Line(
      points={{66,-40},{80,-40}},
      color={118,106,98},
      thickness=0.5));
  connect(firstOrder1.y, secondOrder.u) annotation (Line(points={{-319,-10},{-298,-10},{-298,76},{-278,76},{-278,138},{-218,138}}, color={0,0,127}));
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
      StopTime=25000,
      __Dymola_NumberOfIntervals=25000,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestMillBox_2;
