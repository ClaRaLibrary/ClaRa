within ClaRa.Examples;
model VapourCycle_01 "A closed vapour cycle using discretised plate heat exchanger and discretised flat tube finned heat exhanger."
   extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  inner ClaRa.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_GERGCO2 fluid1)
                                                                                    annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  ClaRa.Components.Sensors.SensorGas_L1_T
                         gasTemperatureSensor_hex_simple annotation (Placement(transformation(extent={{-38,46},{-18,68}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink1(p_const=1e5, T_const=30 + 273.15)
                                                                                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={58,46})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource1(
    variable_m_flow=false,
    variable_T=false,
    T_const(displayUnit="degC") = 303.15,
    m_flow_const=2*0.173)
                      annotation (Placement(transformation(extent={{-70,36},{-50,56}})));
  ClaRa.Components.TurboMachines.Compressors.CompressorVLE_L1_simple pumpVLE_L1_simple(eta_mech=1, eta_hyd=0.75) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,-18})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=2000) annotation (Placement(transformation(extent={{98,-28},{78,-8}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        Delta_p_nom=40e5,
        rho_in_nom=920,
        m_flow_nom=0.044)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={-60,-20})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi
                                      pressureSink_pT2(
    medium=simCenter.fluid2,
    T_const=19.3 + 273.15,
    p_const=1e5,
    Delta_p=10)                                                                     annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-36,-76})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                           massFlowSource_T2(
    medium=simCenter.fluid2,
    m_flow_const=0.166,
    variable_m_flow=false,
    T_const=25 + 273.15)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={36,-76})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple tube(
    frictionAtInlet=false,
    frictionAtOutlet=false,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    p_nom=ones(tube.N_cv)*40e5,
    h_nom=ones(tube.N_cv)*360e3,
    m_flow_nom=0.044,
    h_start=ones(tube.N_cv)*360e3,
    p_start=ones(tube.N_cv)*40.1e5,
    diameter_i=0.01) annotation (Placement(transformation(extent={{-54,-65},{-26,-55}})));
  ClaRa.Visualisation.Quadruple
                          quadruple2(decimalSpaces(m_flow=2), largeFonts=false)
                                                       annotation (Placement(transformation(extent={{-98,-46},{-70,-34}})));
  ClaRa.Visualisation.Quadruple
                          quadruple1(decimalSpaces(m_flow=3), largeFonts=false)
                                                       annotation (Placement(transformation(extent={{70,-6},{98,6}})));
  ClaRa.Visualisation.Quadruple
                          quadruple3(decimalSpaces(m_flow=2), largeFonts=false)
                                                       annotation (Placement(transformation(extent={{-44,14},{-16,26}})));
  ClaRa.Visualisation.Quadruple
                          quadruple4(decimalSpaces(m_flow=2, p=2), largeFonts=false)
                                                       annotation (Placement(transformation(extent={{0,-94},{28,-82}})));
  ClaRa.Components.HeatExchangers.PlateHEXvle2vle_L4 plateHEX(
    medium_b=simCenter.fluid2,
    redeclare model HeatTransferInner_a = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=2000),
    redeclare model HeatTransferInner_b = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=300),
    width=0.1,
    thickness_wall=0.75e-3,
    N_plates=50,
    length=0.3,
    amp=2e-3,
    phi=35*Modelica.Constants.pi/180,
    N_cv=5,
    frictionAtInlet_a=true,
    frictionAtOutlet_a=false,
    m_nom_a=0.044,
    Delta_p_nom_a=0.25e5,
    frictionAtOutlet_b=true,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    h_start_a=linspace(
        360e3,
        460e3,
        plateHEX.N_cv),
    p_start_a=linspace(
        40.1e5,
        40e5,
        plateHEX.N_cv),
    p_start_b=linspace(
        1.01e5,
        1e5,
        plateHEX.N_cv),
    initOptionWall=213,
    T_w_start=linspace(
        280,
        293,
        plateHEX.N_cv)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-68})));
  ClaRa.Visualisation.Quadruple
                          quadruple5(decimalSpaces(m_flow=2, p=2), largeFonts=false)
                                                       annotation (Placement(transformation(extent={{12,-52},{40,-40}})));
  ClaRa.Components.HeatExchangers.FlatTubeFinnedHEXvle2gas_L4 condenser(
    HeatExchangerType=2,
    redeclare model HeatTransferInner_a = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=5000),
    redeclare model HeatTransferInner_b = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=150),
    N_passes=3,
    N_cv_a=9,
    N_cv_b=9,
    width=0.53,
    heigth=0.34,
    thickness_tubeWall=0.1e-3,
    length=0.0175,
    diameter_t=1.51e-3,
    h_f=0.0087,
    s_f=0.1e-3,
    t_f=1.8e-3,
    t_l=1.1e-3,
    N_tubes=11,
    frictionAtOutlet_a=false,
    m_nom_a=0.03,
    Delta_p_nom_a=0.25e5,
    frictionAtOutlet_b=true,
    h_start_a=linspace(
        500e3,
        350e3,
        condenser.N_cv_a),
    p_start_a=linspace(
        100.1e5,
        100.0e5,
        condenser.N_cv_a),
    p_start_b=linspace(
        1.01e5,
        1e5,
        condenser.N_cv_b),
    initOptionTubeWall=213,
    initOptionFinWall=213,
    T_w_tube_start=linspace(
        350,
        350,
        condenser.N_cv_a),
    T_w_fin_start=linspace(
        350,
        350,
        condenser.N_cv_b)) annotation (Placement(transformation(extent={{10,38},{-10,18}})));
  ClaRa.Visualisation.QuadrupleGas
                          quadrupleGas(largeFonts=false)
                                                       annotation (Placement(transformation(extent={{16,30},{44,42}})));
  ClaRa.Components.MechanicalSeparation.SteamSeparatorVLE_L3 steamSeparator(
    length=0.11,
    diameter=0.075,
    yps_start=0.5,
    alpha_ph=0,
    m_flow_nom=0.044,
    p_nom=27e5,
    p_start=40e5,
    levelOutput=true,
    radius_flange=0.01,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3,
    initOption=204) annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
equation
  connect(realExpression.y, pumpVLE_L1_simple.P_drive) annotation (Line(points={{77,-18},{72,-18}},
                                                                                                  color={0,0,127}));
  connect(valve.outlet, tube.inlet) annotation (Line(
      points={{-60,-30},{-60,-60},{-54,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve.eye, quadruple2.eye) annotation (Line(points={{-64,-30},{-64,-40},{-98,-40}},
                                                                                          color={190,190,190}));
  connect(pumpVLE_L1_simple.eye, quadruple1.eye) annotation (Line(points={{54,-7},{54,0},{70,0}},   color={190,190,190}));
  connect(massFlowSource_T2.steam_a, plateHEX.In_b) annotation (Line(
      points={{26,-76},{10,-76}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pressureSink_pT2.steam_a, plateHEX.Out_b) annotation (Line(
      points={{-26,-76},{-10,-76}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(plateHEX.In_a, tube.outlet) annotation (Line(
      points={{-10,-60},{-26,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple4.eye, plateHEX.eye2) annotation (Line(points={{0,-88},{-8,-88},{-8,-78.2}},           color={190,190,190}));
  connect(plateHEX.eye1, quadruple5.eye) annotation (Line(points={{8,-58},{8,-46},{12,-46}}, color={190,190,190}));
  connect(pumpVLE_L1_simple.outlet, condenser.In_a) annotation (Line(
      points={{60,-8},{60,6},{8,6},{8,18}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flueGasFlowSource1.gas_a, gasTemperatureSensor_hex_simple.inlet) annotation (Line(
      points={{-50,46},{-38,46}},
      color={118,106,98},
      thickness=0.5));
  connect(gasTemperatureSensor_hex_simple.outlet, condenser.In_b) annotation (Line(
      points={{-18,46},{-8,46},{-8,38}},
      color={118,106,98},
      thickness=0.5));
  connect(condenser.Out_b, flueGasPressureSink1.gas_a) annotation (Line(
      points={{8,38},{8,46},{48,46}},
      color={118,106,98},
      thickness=0.5));
  connect(quadruple3.eye, condenser.eye1) annotation (Line(points={{-44,20},{-10,20}}, color={190,190,190}));
  connect(condenser.eye2, quadrupleGas.eye) annotation (Line(points={{10.2,36},{16,36}}, color={190,190,190}));
  connect(condenser.Out_a, valve.inlet) annotation (Line(
      points={{-8,18.2},{-8,6},{-60,6},{-60,-10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(plateHEX.Out_a, steamSeparator.inlet) annotation (Line(
      points={{10,-60},{50,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(steamSeparator.outlet2, pumpVLE_L1_simple.inlet) annotation (Line(
      points={{60,-50},{60,-28}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                  Text(
          extent={{-98,102},{100,62}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for the vapour cycle using discretised plate heat exchanger and discretised 
flat tube finned heat exhanger.

______________________________________________________________________________________________
")}),
    experiment(
      StopTime=10000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"));
end VapourCycle_01;
