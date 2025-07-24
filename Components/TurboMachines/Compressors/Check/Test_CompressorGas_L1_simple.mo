within ClaRa.Components.TurboMachines.Compressors.Check;
model Test_CompressorGas_L1_simple
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  ClaRa.Components.TurboMachines.Compressors.CompressorGas_L1_simple simpleFan(presetVariableType="P_shaft", use_P_shaftInput=true) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-40,-18})));
  inner SimCenter simCenter                                annotation (Placement(transformation(extent={{40,40},{60,60}})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT(variable_p=true, p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-4,-18})));
  Modelica.Blocks.Sources.Step step(
    startTime=5,
    height=0.5e5,
    offset=1.5e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-24})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT1(variable_p=false, p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-18})));
  Modelica.Blocks.Sources.RealExpression ShaftPower(y=5e3)
    annotation (Placement(transformation(extent={{-68,-6},{-48,14}})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT2(variable_p=true, p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-4,-64})));
  Modelica.Blocks.Sources.Step step1(
    startTime=5,
    height=0.5e5,
    offset=1.5e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-70})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT3(variable_p=false, p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-64})));
  Modelica.Blocks.Sources.RealExpression VolumeFlowRate(y=simpleFan.V_flow) annotation (Placement(transformation(extent={{-68,-52},{-48,-32}})));
  ClaRa.Components.TurboMachines.Compressors.CompressorGas_L1_simple simpleFan1(
    presetVariableType="V_flow",
    V_flowInput=true,
    use_P_shaftInput=false) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-38,-64})));
  Modelica.Blocks.Sources.Step step2(
    startTime=5,
    height=0.5e5,
    offset=1.5e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-120})));
  Modelica.Blocks.Sources.RealExpression dp_input(y=simpleFan.Delta_p) annotation (Placement(transformation(extent={{-68,-102},{-48,-82}})));
  ClaRa.Components.TurboMachines.Compressors.CompressorGas_L1_simple simpleFan2(
    use_P_shaftInput=false,
    presetVariableType="dp",
    use_Delta_p_input=true) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-38,-114})));
  BoundaryConditions.BoundaryGas_Txim_flow
                                     gasFlowSource_T(m_flow_const=1, variable_m_flow=true) annotation (Placement(transformation(extent={{-80,-124},{-60,-104}})));
  Modelica.Blocks.Sources.RealExpression VolumeFlowRate2(y=simpleFan.inlet.m_flow)
    annotation (Placement(transformation(extent={{-108,-118},{-88,-98}})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT4(variable_p=true, p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-4,-114})));
equation
  connect(step.y, gasSink_pT.p) annotation (Line(
      points={{19,-24},{6,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step1.y, gasSink_pT2.p)
                                annotation (Line(
      points={{19,-70},{6,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ShaftPower.y, simpleFan.P_shaft_in) annotation (Line(
      points={{-47,4},{-37.6,4},{-37.6,-9.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VolumeFlowRate.y, simpleFan1.V_flow_in) annotation (Line(
      points={{-47,-42},{-40.4,-42},{-40.4,-55.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VolumeFlowRate2.y, gasFlowSource_T.m_flow) annotation (Line(
      points={{-87,-108},{-80,-108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT4.p, step2.y) annotation (Line(
      points={{6,-120},{19,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp_input.y, simpleFan2.dp_in) annotation (Line(
      points={{-47,-92},{-31.6,-92},{-31.6,-105.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT1.gas_a, simpleFan.inlet) annotation (Line(
      points={{-60,-18},{-48,-18}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(simpleFan.outlet, gasSink_pT.gas_a) annotation (Line(
      points={{-32,-18},{-14,-18}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasSink_pT2.gas_a, simpleFan1.outlet) annotation (Line(
      points={{-14,-64},{-30,-64}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(simpleFan1.inlet, gasSink_pT3.gas_a) annotation (Line(
      points={{-46,-64},{-60,-64}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasFlowSource_T.gas_a, simpleFan2.inlet) annotation (Line(
      points={{-60,-114},{-46,-114}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(simpleFan2.outlet, gasSink_pT4.gas_a) annotation (Line(
      points={{-30,-114},{-14,-114}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-120,-140},{60,60}}, preserveAspectRatio=false),
            graphics={          Text(
          extent={{-118,46},{-14,32}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>> Tester for basic compressor model with different inputs


")}),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end Test_CompressorGas_L1_simple;
