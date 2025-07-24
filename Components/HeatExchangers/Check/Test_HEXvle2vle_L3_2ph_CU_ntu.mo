within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_2ph_CU_ntu

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

  HEXvle2vle_L3_2ph_CU_ntu hex(
    redeclare model WallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (
          alpha_nom={2500,7500}),
    z_in_shell=3,
    N_passes=2,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (
          alpha_nom=5000),
    z_in_aux2=1,
    z_in_aux1=1,
    length=5,
    flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
    z_out_shell=0.06,
    m_flow_nom_shell=17,
    p_nom_shell=1e5,
    h_nom_shell=3000e3,
    p_start_shell=1e5,
    m_flow_nom_tubes=300,
    p_nom_tubes=250e5,
    h_nom_tubes=300e3,
    h_start_tubes=300e3,
    p_start_tubes=250e5,
    length_tubes=5,
    N_tubes=750,
    initOptionTubes=1,
    initOptionShell=204) annotation (Placement(transformation(extent={{14,-70},{34,-50}})));

  Sensors.SensorVLE_L1_T Temp_Shell_in annotation (Placement(transformation(extent={{14,16},{34,36}})));
  Sensors.SensorVLE_L1_T Temp_Tubes_in annotation (Placement(transformation(extent={{82,-80},{62,-100}})));
  Sensors.SensorVLE_L1_T Temp_Tubes_out annotation (Placement(transformation(extent={{54,-42},{74,-22}})));
  Modelica.Blocks.Sources.Ramp h_hot(
    height=100e3,
    duration=600,
    offset=2680e3,
    startTime=1800)  annotation (Placement(transformation(extent={{112,-4},{92,16}})));
  Modelica.Blocks.Sources.Ramp m_cold(
    height=-170,
    duration=600,
    offset=300,
    startTime=1800)  annotation (Placement(transformation(extent={{160,-58},{140,-38}})));
  Modelica.Blocks.Sources.Ramp m_hot(
    height=-9.5,
    duration=600,
    offset=17.5,
    startTime=1800)  annotation (Placement(transformation(extent={{112,26},{92,46}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_shell1(
    checkValve=true,
    redeclare model PressureLoss = VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1000, m_flow_nom=20),
    openingInputIsActive=false) annotation (Placement(transformation(extent={{-20,-92},{-40,-80}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=if ((333) > 0) then (333) else 10, Delta_p_nom=if ((1000) <> 0) then (1000) else 1000)) annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=180,
        origin={74,-54})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(h_const=300e3, p_const=2100000,
    variable_p=true)                                                                  annotation (Placement(transformation(extent={{-70,-96},{-50,-76}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=70e5,
    variable_p=true)                                                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-30})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{52,-4},{32,16}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  Modelica.Blocks.Sources.Ramp h_cold(
    height=-25e3,
    duration=600,
    offset=273e3,
    startTime=1800)  annotation (Placement(transformation(extent={{160,-90},{140,-70}})));
  inner SimCenter simCenter(
    useHomotopy=true,
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    showExpertSummary=true) annotation (Placement(transformation(extent={{40,40},{80,60}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hex.shell.summary.inlet[1].T,hex.shell.summary.outlet[1].T,hex.shell.summary.outlet[1].T,hex.shell.summary.outlet[1].T,hex.shell.summary.outlet[1].T,hex.shell.summary.outlet[1].T},
    T_i={hex.tubes.summary.inlet.T,hex.tubes.summary.outlet.T,hex.tubes.summary.outlet.T,hex.tubes.summary.outlet.T,hex.tubes.summary.outlet.T,hex.tubes.summary.outlet.T},
    Unit="HEX Temperature in K",
    z_i={0,1,1,1,1,1},
    z_o={0,1,1,1,1,1},
    y_min=150 + 273.15,
    y_max=230 + 273.15)
                       annotation (Placement(transformation(extent={{-90,-34},{4,54}})));
  Visualisation.Quadruple quadruple1(largeFonts=false) annotation (Placement(transformation(extent={{38,-53},{58,-43}})));
  Visualisation.Quadruple quadruple(largeFonts=false) annotation (Placement(transformation(extent={{30,-82},{50,-72}})));
  Modelica.Blocks.Sources.Ramp p_cold(
    duration=600,
    height=-145e5,
    offset=250e5,
    startTime=1800)
                  annotation (Placement(transformation(extent={{160,-20},{140,0}})));
  Modelica.Blocks.Sources.Ramp p_hot(
    duration=600,
    height=-0.1e5,
    offset=0.85e5,
    startTime=1800)
                annotation (Placement(transformation(extent={{-100,-78},{-80,-58}})));
  Visualisation.DynamicBar level_abs1(
    u=hex.shell.summary.outline.level_abs,
    u_set=0.5,
    u_high=1,
    u_low=0.2,
    u_max=3,
    provideOutputConnector=true) annotation (Placement(transformation(extent={{2,-70},{12,-50}})));
  Utilities.Blocks.LimPID PI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_d=60,
    u_ref=1,
    y_ref=1,
    y_max=1,
    y_min=0,
    y_start=0.5,
    Tau_i=120,
    sign=1,
    k=0.1,
    initOption=796) annotation (Placement(transformation(extent={{-6,-75},{-16,-65}})));
  Modelica.Blocks.Sources.Ramp rampControllerSetpoint(
    duration=100,
    startTime=12000,
    height=0,
    offset=0.5) annotation (Placement(transformation(extent={{10,-82},{4,-76}})));
equation

  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{64,-54},{64,-42}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a,Temp_Shell_in. port) annotation (Line(
      points={{32,6},{24,6},{24,16}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a,Temp_Tubes_in. port) annotation (Line(
      points={{100,-80},{72,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot.y, massFlowSource_h.m_flow) annotation (Line(
      points={{91,36},{84,36},{84,12},{54,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h, h_hot.y) annotation (Line(
      points={{54,6},{91,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-50,-86},{-40,-86}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{100,-30},{86,-30},{86,-54},{84,-54}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.In2, Temp_Tubes_in.port) annotation (Line(
      points={{34,-64},{72,-64},{72,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.Out2, valve_tubes1.inlet) annotation (Line(
      points={{34,-54},{64,-54}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold.y) annotation (Line(
      points={{122,-80},{139,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{139,-48},{134,-48},{134,-74},{122,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{24,-50.2},{24,6},{32,6}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.eye2, quadruple1.eye) annotation (Line(points={{35,-52},{36,-52},{36,-48},{38,-48}}, color={190,190,190}));
  connect(hex.eye1, quadruple.eye) annotation (Line(points={{28,-71},{28,-77},{30,-77}},       color={190,190,190}));
  connect(p_cold.y, pressureSink_ph1.p) annotation (Line(points={{139,-10},{130,-10},{130,-36},{120,-36}}, color={0,0,127}));
  connect(p_hot.y, pressureSink_ph.p) annotation (Line(points={{-79,-68},{-76,-68},{-76,-80},{-70,-80}}, color={0,0,127}));
  connect(rampControllerSetpoint.y, PI.u_m) annotation (Line(points={{3.7,-79},{-11.05,-79},{-11.05,-76}},
                                                                                            color={0,0,127}));
  connect(level_abs1.y, PI.u_s) annotation (Line(points={{13,-70},{-5,-70}}, color={0,0,127}));
  connect(valve_shell1.inlet, hex.Out1) annotation (Line(
      points={{-20,-86},{-4,-86},{24,-86},{24,-70}},
      color={0,131,169},
      thickness=0.5));
  connect(PI.y, valve_shell1.opening_in) annotation (Line(points={{-16.5,-70},{-30,-70},{-30,-77}},  color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{160,100}},
          preserveAspectRatio=false,
        initialScale=0.1),            graphics={  Text(
          extent={{-96,100},{142,54}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_2ph_CU_simple in a load change. Test robustness and 
prove steady-state initialisation capabilities. Check controlled and uncontrolled behaviour.
______________________________________________________________________________________________")}),
                                                 Icon(graphics,
                                                      coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(StopTime=3600, Tolerance=1e-005),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2vle_L3_2ph_CU_ntu;
