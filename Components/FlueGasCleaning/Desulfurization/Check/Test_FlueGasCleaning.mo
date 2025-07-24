within ClaRa.Components.FlueGasCleaning.Desulfurization.Check;
model Test_FlueGasCleaning
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;

  Desulfurization_L2_ideal deSO_ideal_L1_1(
    m_flow_nom=530,
    xi_start={0,0,0.21,0.00099,0.7,0.0393,0,0.0367,0},
    T_start=395.843,
    p_start=101800,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    initOption=0) annotation (Placement(transformation(extent={{-30,24},{-10,44}})));

  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T(
    m_flow_const=551.153,
    xi_const={0,0,0.21,0.00099,0.7,0.0393,0,0.0367,0},
    T_const=395.843) annotation (Placement(transformation(extent={{-70,24},{-50,44}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT(
    xi_const={0,0,0.21,0.00099,0.7,0.0393,0,0.0367,0},
    p_const=101800,
    T_const=293.15) annotation (Placement(transformation(extent={{52,24},{32,44}})));
  inner SimCenter simCenter(
    contributeToCycleSummary=true,
    redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel,
    showExpertSummary=true) annotation (Placement(transformation(extent={{68,68},{88,88}})));
  Denitrification.Denitrification_L2 deNOx(
    useHomotopy=simCenter.useHomotopy,
    use_dynamicMassbalance=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    length=1,
    height=5,
    width=1,
    redeclare model SeparationModel = ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.Denitrification_L2 (separationRate=0.9))
                                                                                                                                      annotation (Placement(transformation(extent={{14,-96},{34,-76}})));
  BoundaryConditions.BoundaryGas_Txim_flow                  idealGasFlowSource_XRG2(
    m_flow_const=10,
    variable_m_flow=true,
    variable_T=true,
    xi_const={0.01,0.01,0.73,0.01,0.065,0.036,0.01,0.13,0.0})
                                                 annotation (Placement(transformation(extent={{-20,-96},{0,-76}})));
  Modelica.Blocks.Sources.Ramp massFlowRate2(
    offset=1e-3,
    height=1e-3,
    duration=10,
    startTime=100)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-58,-68})));
  Modelica.Blocks.Sources.Ramp Temperature2(
    duration=1,
    height=25,
    offset=273.15 + 200,
    startTime=150)      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-58,-100})));
  BoundaryConditions.BoundaryGas_pTxi                  idealGasPressureSink_XRG1(p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={88,-86})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop1(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-58,-38})));
  BoundaryConditions.BoundaryGas_Txim_flow                  idealGasFlowSource_XRG(
    m_flow_const=10,
    variable_m_flow=true,
    variable_T=true,
    xi_const={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0}) annotation (Placement(transformation(extent={{180,12},{200,32}})));
  BoundaryConditions.BoundaryGas_pTxi                  idealGasPressureSink1(
                                                                            p_const=100000, xi_const={0.0,0,0.73,0,0.065,0.036,0,0.13,0.0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={290,22})));
  Modelica.Blocks.Sources.Ramp massFlowRate(
    startTime=5,
    height=-2,
    offset=1,
    duration=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,42})));
  Modelica.Blocks.Sources.Ramp Temperature(
    duration=1,
    startTime=1,
    height=50,
    offset=273.15 + 150)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,10})));
  E_Filter.E_Filter_L2                                                      e_Filter_dynamic(
    xi_start={0.0,0,0.73,0,0.065,0.036,0,0.13,0.0},

    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2
        (                                                                                                               Delta_p_nom=100),

    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    height=5,
    width=2,
    length=2)                                                                                                                             annotation (Placement(transformation(extent={{216,12},{236,32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop3(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={150,70})));
  BoundaryConditions.BoundaryGas_Txim_flow                  idealGasFlowSource_XRG4(
    m_flow_const=10,
    variable_m_flow=true,
    variable_T=true,
    xi_const={1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9})
                                                 annotation (Placement(transformation(extent={{180,-84},{200,-64}})));
  BoundaryConditions.BoundaryGas_pTxi                  idealGasPressureSink2(                                            p_const=100000, xi_const={1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9})
                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={290,-74})));
  Modelica.Blocks.Sources.Ramp massFlowRate4(
    offset=1,
    startTime=5,
    duration=10,
    height=-2)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-54})));
  Modelica.Blocks.Sources.Ramp Temperature3(
    duration=1,
    startTime=1,
    height=50,
    offset=273.15 + 150)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-86})));
  E_Filter.E_Filter_L2                                                         e_Filter_dynamic1(
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock,
    use_dynamicMassbalance=true,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model SeparationModel = Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_Filter_L2_Empirical (A_el=200))           annotation (Placement(transformation(extent={{216,-84},{236,-64}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop4(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={150,-26})));
  BoundaryConditions.BoundaryGas_Txim_flow                  idealGasFlowSource_XRG5(
    variable_m_flow=false,
    variable_T=false,
    T_const=473.15,
    xi_const={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0},
    m_flow_const=10)
                    annotation (Placement(transformation(extent={{120,-192},{140,-172}})));
  BoundaryConditions.BoundaryGas_pTxi                  idealGasPressureSink3(                                                            xi_const={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0}, p_const=101300)
                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={290,-182})));
  E_Filter.E_Filter_L2                                                        e_Filter_dynamic2(
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock,
    use_dynamicMassbalance=true,
    xi_start={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0},
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    m_flow_nom=10,
    redeclare model SeparationModel = Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_Filter_L2_Detailed,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    T_start=473.15,
    p_start=102300)
                   annotation (Placement(transformation(extent={{216,-192},{236,-172}})));
  Modelica.Blocks.Sources.Ramp U_applied(
    duration=10,
    height=20e3,
    startTime=10,
    offset=1000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={190,-152})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop5(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={190,-120})));
  VolumesValvesFittings.Pipes.PipeFlowGas_L4_Simple pipeFlowGas_L4_Simple(
    redeclare model PressureLoss =
        Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    xi_start={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0},
    xi_nom={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0},
    p_nom=1e5*ones(pipeFlowGas_L4_Simple.N_cv),
    T_nom=473.15*ones(pipeFlowGas_L4_Simple.N_cv),
    T_start=473.15*ones(pipeFlowGas_L4_Simple.N_cv),
    Delta_p_nom=100,
    frictionAtOutlet=true,
    redeclare model HeatTransfer =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (
         alpha_nom=10),
    length=1,
    diameter_i=0.5,
    p_start=1.033e5*ones(pipeFlowGas_L4_Simple.N_cv),
    m_flow_nom=10,
    initOption=0)
    annotation (Placement(transformation(extent={{164,-186},{192,-176}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop6(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-138})));
  Adapters.Scalar2VectorHeatPort            scalar2VectorHeatPort2(
    N=3,
    equalityMode="Equal Temperatures",
    length=10,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        10,
        3))         annotation (Placement(transformation(extent={{146,-148},{166,-128}})));

  VolumesValvesFittings.Valves.GenericValveGas_L1 genericValveGas_L1(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=100, m_flow_nom=1000)) annotation (Placement(transformation(extent={{0,28},{20,40}})));
  VolumesValvesFittings.Valves.GenericValveGas_L1 genericValveGas_L2(redeclare model PressureLoss = VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=100, m_flow_nom=1000)) annotation (Placement(transformation(extent={{42,-92},{62,-80}})));
  VolumesValvesFittings.Valves.GenericValveGas_L1 genericValveGas_L3(redeclare model PressureLoss = VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=100, m_flow_nom=1000)) annotation (Placement(transformation(extent={{246,-188},{266,-176}})));
  VolumesValvesFittings.Valves.GenericValveGas_L1 genericValveGas_L4(redeclare model PressureLoss = VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=100, m_flow_nom=1000)) annotation (Placement(transformation(extent={{246,-80},{266,-68}})));
equation
  connect(gasFlowSource_T.gas_a, deSO_ideal_L1_1.inlet) annotation (Line(
      points={{-50,34},{-30,34}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowRate2.y,idealGasFlowSource_XRG2. m_flow) annotation (Line(
      points={{-47,-68},{-38,-68},{-38,-80},{-20,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature2.y,idealGasFlowSource_XRG2. T)
                                             annotation (Line(
      points={{-47,-100},{-38,-100},{-38,-86},{-20,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGasFlowSource_XRG2.gas_a,deNOx. inlet) annotation (Line(
      points={{0,-86},{14,-86}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fixedTemperatureTop1.port,deNOx. heat) annotation (Line(
      points={{-48,-38},{24,-38},{24,-76}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(massFlowRate.y,idealGasFlowSource_XRG. m_flow) annotation (Line(
      points={{161,42},{170,42},{170,28},{180,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature.y,idealGasFlowSource_XRG. T)
                                             annotation (Line(
      points={{161,10},{170,10},{170,22},{180,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGasFlowSource_XRG.gas_a,e_Filter_dynamic. inlet) annotation (
      Line(
      points={{200,22},{216,22}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(e_Filter_dynamic.outlet, idealGasPressureSink1.gas_a) annotation (Line(
      points={{236,22},{280,22}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fixedTemperatureTop3.port,e_Filter_dynamic. heat) annotation (Line(
      points={{160,70},{226,70},{226,32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(massFlowRate4.y, idealGasFlowSource_XRG4.m_flow) annotation (Line(
      points={{161,-54},{170,-54},{170,-68},{180,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature3.y, idealGasFlowSource_XRG4.T) annotation (Line(
      points={{161,-86},{170,-86},{170,-74},{180,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGasFlowSource_XRG4.gas_a, e_Filter_dynamic1.inlet) annotation (Line(
      points={{200,-74},{216,-74}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fixedTemperatureTop4.port, e_Filter_dynamic1.heat) annotation (Line(
      points={{160,-26},{226,-26},{226,-64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperatureTop5.port, e_Filter_dynamic2.heat) annotation (Line(
      points={{200,-120},{226,-120},{226,-172}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(idealGasFlowSource_XRG5.gas_a, pipeFlowGas_L4_Simple.inlet) annotation (Line(
      points={{140,-182},{164,-182},{164,-181}},
      color={118,106,98},
      thickness=0.5));
  connect(pipeFlowGas_L4_Simple.outlet, e_Filter_dynamic2.inlet) annotation (Line(
      points={{192,-181},{206,-181},{206,-182},{216,-182}},
      color={118,106,98},
      thickness=0.5));
  connect(fixedTemperatureTop6.port, scalar2VectorHeatPort2.heatScalar) annotation (Line(points={{140,-138},{143,-138},{146,-138}}, color={191,0,0}));
  connect(scalar2VectorHeatPort2.heatVector, pipeFlowGas_L4_Simple.heat) annotation (Line(
      points={{166,-138},{178,-138},{178,-177}},
      color={167,25,48},
      thickness=0.5));
  connect(U_applied.y, e_Filter_dynamic2.U_input) annotation (Line(points={{201,-152},{208,-152},{218.6,-152},{218.6,-170.8}}, color={0,0,127}));
  connect(deSO_ideal_L1_1.outlet, genericValveGas_L1.inlet) annotation (Line(
      points={{-10,34},{0,34}},
      color={118,106,98},
      thickness=0.5));
  connect(genericValveGas_L1.outlet, gasSink_pT.gas_a) annotation (Line(
      points={{20,34},{32,34}},
      color={118,106,98},
      thickness=0.5));
  connect(deNOx.outlet, genericValveGas_L2.inlet) annotation (Line(
      points={{34,-86},{42,-86}},
      color={118,106,98},
      thickness=0.5));
  connect(genericValveGas_L2.outlet, idealGasPressureSink_XRG1.gas_a) annotation (Line(
      points={{62,-86},{78,-86}},
      color={118,106,98},
      thickness=0.5));
  connect(e_Filter_dynamic2.outlet, genericValveGas_L3.inlet) annotation (Line(
      points={{236,-182},{246,-182}},
      color={118,106,98},
      thickness=0.5));
  connect(genericValveGas_L3.outlet, idealGasPressureSink3.gas_a) annotation (Line(
      points={{266,-182},{280,-182}},
      color={118,106,98},
      thickness=0.5));
  connect(e_Filter_dynamic1.outlet, genericValveGas_L4.inlet) annotation (Line(
      points={{236,-74},{246,-74}},
      color={118,106,98},
      thickness=0.5));
  connect(genericValveGas_L4.outlet, idealGasPressureSink2.gas_a) annotation (Line(
      points={{266,-74},{280,-74}},
      color={118,106,98},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{320,100}},
        initialScale=0.1),     graphics={
                                Text(
          extent={{-100,86},{-26,76}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="________________________________________________________________
PURPOSE:
>>Regression tester for the flue gas cleaning components"),
        Rectangle(
          extent={{-100,100},{320,-220}},
          lineColor={115,150,0},
          lineThickness=0.5)}

),

    Icon(graphics,
         coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.1)),
    experiment(StopTime=10000));
end Test_FlueGasCleaning;
