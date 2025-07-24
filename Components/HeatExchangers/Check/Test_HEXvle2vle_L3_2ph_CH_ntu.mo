within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_2ph_CH_ntu

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

  HEXvle2vle_L3_2ph_CH_ntu hex(
    mass_struc=1,
    redeclare model WallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L3,
    z_in_shell=10,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (
          alpha_nom=5000),
    p_start_tubes=250e5,
    m_flow_nom_shell=42,
    p_nom_shell=53e5,
    h_nom_shell=3000e3,
    p_start_shell=53e5,
    N_passes=3,
    z_in_tubes=0.1,
    z_out_tubes=10,
    p_nom_tubes=250e5,
    h_nom_tubes=1000e3,
    h_start_tubes=1000e3,
    m_flow_nom_tubes=416,
    z_out_shell=0.1,
    level_rel_start=0.2,
    redeclare model HeatCapacityAveraging =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.InputOnly,
    N_tubes=300,
    redeclare model HeatTransfer_Shell =
        Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1000,5000}),
    initOptionTubes=0,
    initOptionShell=204,
    initOptionWall=0) annotation (Placement(transformation(extent={{-6,-72},{14,-52}})));

  Sensors.SensorVLE_L1_T Temp_Shell_in annotation (Placement(transformation(extent={{34,-22},{14,-42}})));
  Sensors.SensorVLE_L1_T Temp_Tubes_in annotation (Placement(transformation(extent={{58,-62},{38,-82}})));
  Modelica.Blocks.Sources.Ramp h_hot(
    offset=2942e3,
    duration=600,
    height=80e3,
    startTime=1800)
                 annotation (Placement(transformation(extent={{100,-32},{80,-12}})));
  Modelica.Blocks.Sources.Ramp m_cold(
    duration=600,
    offset=416,
    height=-166,
    startTime=1800)
                 annotation (Placement(transformation(extent={{100,-64},{80,-44}})));
  Modelica.Blocks.Sources.Ramp m_hot(
    duration=600,
    offset=42.7,
    height=-20,
    startTime=1800)
                annotation (Placement(transformation(extent={{100,0},{80,20}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_shell1(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=50, Delta_p_nom=0.5e5)) annotation (Placement(transformation(extent={{-48,-94},{-68,-82}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(h_const=300e3, p_const=2100000,
    variable_p=true)                                                                  annotation (Placement(transformation(extent={{-92,-98},{-72,-78}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=25000000,
    variable_p=true,
    Delta_p=10)                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-82,-60})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{56,-32},{36,-12}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{68,-70},{48,-50}})));
  Modelica.Blocks.Sources.Ramp h_cold(
    duration=600,
    offset=961e3,
    height=-106e3,
    startTime=1800)
                   annotation (Placement(transformation(extent={{100,-94},{80,-74}})));
  inner SimCenter simCenter(
    useHomotopy=true,
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    showExpertSummary=true) annotation (Placement(transformation(extent={{40,40},{80,60}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o=hex.wall.summary.T_o - fill(273.15, 6),
    T_i=hex.wall.summary.T_i - fill(273.15, 6),
    Unit="HEX Temperature in C",
    z_o=hex.wall.summary.eCom.z_o,
    z_i=hex.wall.summary.eCom.z_i,
    y_min=200,
    y_max=400)         annotation (Placement(transformation(extent={{-120,-32},{-26,56}})));
  Visualisation.Quadruple quadruple(largeFonts=false) annotation (Placement(transformation(extent={{-42,-50},{-10,-34}})));
  Visualisation.Quadruple quadruple1(largeFonts=false) annotation (Placement(transformation(extent={{12,-100},{44,-84}})));
  Modelica.Blocks.Sources.Ramp p_cold(
    duration=600,
    offset=250e5,
    height=-95e5,
    startTime=1800)
                  annotation (Placement(transformation(extent={{-120,-64},{-100,-44}})));
  Modelica.Blocks.Sources.Ramp p_hot(
    duration=600,
    offset=53e5,
    height=-20e5,
    startTime=1800)
                  annotation (Placement(transformation(extent={{-120,-92},{-100,-72}})));
  Visualisation.DynamicBar level_abs1(
    u=hex.shell.summary.outline.level_abs,
    u_set=2,
    u_high=3,
    u_low=1,
    u_max=10,
    provideOutputConnector=true) annotation (Placement(transformation(extent={{-20,-72},{-10,-52}})));
  Utilities.Blocks.LimPID PI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_d=60,
    k=0.1,
    u_ref=1,
    y_ref=1,
    y_max=1,
    y_min=0,
    y_start=0.5,
    Tau_i=120,
    sign=1,
    initOption=796) annotation (Placement(transformation(extent={{-28,-77},{-38,-67}})));
  Modelica.Blocks.Sources.Ramp rampControllerSetpoint(
    duration=100,
    offset=2,
    startTime=12000,
    height=0) annotation (Placement(transformation(extent={{-12,-84},{-18,-78}})));
equation

  connect(m_hot.y, massFlowSource_h.m_flow) annotation (Line(
      points={{79,10},{64,10},{64,-16},{58,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h, h_hot.y) annotation (Line(
      points={{58,-22},{79,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-72,-88},{-68,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold.y) annotation (Line(
      points={{70,-60},{70,-84},{79,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{79,-54},{70,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{4,-52.2},{4,-22},{36,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.In2, massFlowSource_h1.steam_a) annotation (Line(
      points={{14,-60},{48,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.In1, Temp_Shell_in.port) annotation (Line(
      points={{4,-52.2},{4,-22},{24,-22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.In2, Temp_Tubes_in.port) annotation (Line(
      points={{14,-60},{49,-60},{49,-62},{48,-62}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.eye1, quadruple1.eye) annotation (Line(points={{8,-73},{8,-92},{12,-92}},       color={190,190,190}));
  connect(hex.eye2, quadruple.eye) annotation (Line(points={{-7,-62},{-8,-62},{-8,-42},{-42,-42}},   color={190,190,190}));
  connect(p_cold.y, pressureSink_ph1.p) annotation (Line(points={{-99,-54},{-96,-54},{-92,-54}}, color={0,0,127}));
  connect(p_hot.y, pressureSink_ph.p) annotation (Line(points={{-99,-82},{-92,-82}}, color={0,0,127}));
  connect(level_abs1.y, PI.u_s) annotation (Line(points={{-9,-72},{-9,-72},{-27,-72}}, color={0,0,127}));
  connect(rampControllerSetpoint.y, PI.u_m) annotation (Line(points={{-18.3,-81},{-33.05,-81},{-33.05,-78}},
                                                                                            color={0,0,127}));
  connect(hex.Out1, valve_shell1.inlet) annotation (Line(
      points={{4,-72},{4,-88},{-48,-88}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(PI.y, valve_shell1.opening_in) annotation (Line(points={{-38.5,-72},{-58,-72},{-58,-79}},  color={0,0,127}));
  connect(hex.Out2, pressureSink_ph1.steam_a) annotation (Line(
      points={{-6,-60},{-72,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-120,-100},{100,100}},
          preserveAspectRatio=false,
        initialScale=0.1),            graphics={  Text(
          extent={{-96,102},{142,56}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_2ph_CH_ntu as a high pressure preheater in a load change. 
Test robustness and prove steady-state initialisation capabilities. Check controlled and uncontrolled behaviour.
______________________________________________________________________________________________")}),
                                                 Icon(graphics,
                                                      coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(StopTime=3600, Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2vle_L3_2ph_CH_ntu;
