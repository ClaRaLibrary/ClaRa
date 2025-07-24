within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2vle_L3_1ph_BU_ntu

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

  HEXvle2vle_L3_1ph_BU_ntu hex(
    length=6,
    height=2,
    width=2,
    Delta_z_par=1.5*hex.diameter_o,
    Delta_z_ort=1.5*hex.diameter_o,
    redeclare model WallMaterial = TILMedia.Solid.Types.TILMedia_Steel,
    mass_struc=5000,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltShell1ph_L2,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    h_start_shell=2975e3,
    p_start_shell=21.05e5,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    p_nom_tubes=250e5,
    h_nom_tubes=1130e3,
    h_start_tubes=1130e3,
    p_start_tubes=250e5,
    flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
    N_tubes=200,
    N_passes=5,
    N_rows=30,
    redeclare model HeatExchangerType = Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow,
    initOptionShell=0,
    initOptionTubes=1,
    initOptionWall=0) annotation (Placement(transformation(extent={{0,-76},{20,-56}})));

  Sensors.SensorVLE_L1_T Temp_Shell_in annotation (Placement(transformation(extent={{16,2},{36,22}})));
  Sensors.SensorVLE_L1_T Temp_Shell_out annotation (Placement(transformation(extent={{-46,-82},{-26,-62}})));
  Sensors.SensorVLE_L1_T Temp_Tubes_in annotation (Placement(transformation(extent={{16,-42},{36,-22}})));
  Sensors.SensorVLE_L1_T Temp_Tubes_out annotation (Placement(transformation(extent={{44,-70},{64,-90}})));
  Modelica.Blocks.Sources.Ramp h_hot1(
    duration=1500,
    startTime=5000,
    offset=3375e3,
    height=200e3)
    annotation (Placement(transformation(extent={{140,-14},{120,6}})));
  Modelica.Blocks.Sources.Ramp m_cold1(
    duration=600,
    startTime=10000,
    height=-250.1,
    offset=416.1)
    annotation (Placement(transformation(extent={{140,-46},{120,-26}})));
  Modelica.Blocks.Sources.Ramp m_hot1(
    startTime=10000,
    height=-14.5,
    duration=600,
    offset=21.6)
    annotation (Placement(transformation(extent={{142,18},{122,38}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_shell1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=if ((15) > 0) then (15) else 10, Delta_p_nom=if ((1000) <> 0) then (1000) else 1000)) annotation (Placement(transformation(extent={{-40,-88},{-60,-76}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_tubes1(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=if ((333) > 0) then (333) else 10, Delta_p_nom=if ((1000) <> 0) then (1000) else 1000)) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=180,
        origin={64,-60})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(                 h_const=300e3,
    p_const=2500000,
    variable_p=true)                                                                  annotation (Placement(transformation(extent={{-84,-92},{-64,-72}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(h_const=2000e3, p_const=25000000,
    variable_p=true)                                                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-90})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{100,-14},{80,6}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{100,-52},{80,-32}})));
  Modelica.Blocks.Sources.Ramp h_cold4(
    duration=600,
    offset=1161e3,
    startTime=10000,
    height=-200e3)
    annotation (Placement(transformation(extent={{140,-72},{120,-52}})));
  inner SimCenter simCenter(
    showExpertSummary=true,
    useHomotopy=true,
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    T_o={hex.shell.summary.inlet.T,hex.shell.summary.outlet.T,hex.shell.summary.outlet.T,hex.shell.summary.outlet.T,hex.shell.summary.outlet.T,hex.shell.summary.outlet.T},
    T_i={hex.tubes.summary.inlet.T,hex.tubes.summary.outlet.T,hex.tubes.summary.outlet.T,hex.tubes.summary.outlet.T,hex.tubes.summary.outlet.T,hex.tubes.summary.outlet.T},
    Unit="HEX Temperature in K",
    y_min=500,
    y_max=800,
    z_i={0,1,1,1,1,1},
    z_o={0,1,1,1,1,1}) annotation (Placement(transformation(extent={{-92,-48},{2,40}})));
  Visualisation.Quadruple quadruple(largeFonts=false) annotation (Placement(transformation(extent={{14,-88},{34,-78}})));
  Visualisation.Quadruple quadruple1(largeFonts=false) annotation (Placement(transformation(extent={{-26,-70},{-6,-60}})));
  Modelica.Blocks.Sources.Ramp p_cold1(
    duration=600,
    startTime=10000,
    height=-150e5,
    offset=250e5)
    annotation (Placement(transformation(extent={{140,-106},{120,-86}})));
  Modelica.Blocks.Sources.Ramp p_hot1(
    duration=600,
    startTime=10000,
    height=-15e5,
    offset=25e5) annotation (Placement(transformation(extent={{-120,-86},{-100,-66}})));
equation

  connect(valve_shell1.inlet,Temp_Shell_out. port) annotation (Line(
      points={{-40,-82},{-36,-82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_tubes1.inlet,Temp_Tubes_out. port) annotation (Line(
      points={{54,-60},{54,-70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a,Temp_Shell_in. port) annotation (Line(
      points={{80,-4},{26,-4},{26,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a,Temp_Tubes_in. port) annotation (Line(
      points={{80,-42},{26,-42}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(m_hot1.y, massFlowSource_h.m_flow) annotation (Line(
      points={{121,28},{112,28},{112,2},{102,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h.h,h_hot1. y) annotation (Line(
      points={{102,-4},{119,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a,valve_shell1. outlet) annotation (Line(
      points={{-64,-82},{-60,-82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph1.steam_a,valve_tubes1. outlet) annotation (Line(
      points={{80,-90},{78,-90},{78,-60},{74,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.In2, Temp_Tubes_in.port) annotation (Line(
      points={{20,-72},{26,-72},{26,-42}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.Out2, valve_tubes1.inlet) annotation (Line(
      points={{20,-60},{54,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.h, h_cold4.y) annotation (Line(
      points={{102,-42},{110,-42},{110,-62},{119,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_cold1.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{119,-36},{102,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temp_Shell_out.port, hex.Out1) annotation (Line(
      points={{-36,-82},{10,-82},{10,-76}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.In1, massFlowSource_h.steam_a) annotation (Line(
      points={{10,-56.2},{10,-4},{80,-4}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hex.eye2, quadruple1.eye) annotation (Line(points={{0,-70.2},{-6,-70.2},{-6,-65},{-26,-65}}, color={190,190,190}));
  connect(hex.eye1, quadruple.eye) annotation (Line(points={{12.8,-75.8},{12.8,-83},{14,-83}}, color={190,190,190}));
  connect(p_cold1.y, pressureSink_ph1.p) annotation (Line(points={{119,-96},{100,-96}}, color={0,0,127}));
  connect(p_hot1.y, pressureSink_ph.p) annotation (Line(points={{-99,-76},{-92,-76},{-84,-76}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{140,100}},
          preserveAspectRatio=false), graphics={  Text(
          extent={{-96,96},{142,50}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="______________________________________________________________________________________________
PURPOSE:
>>check HEXvle2vle_L3_1ph_BU_ntu as a desuperheater in a load change at t=10000s. 
______________________________________________________________________________________________
NOTE: A number of visualisers can be displayed in the simulation window :-)
______________________________________________________________________________________________
")}),                                            Icon(graphics,
                                                      coordinateSystem(initialScale=0.1)),
    experiment(
      StopTime=12000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2vle_L3_1ph_BU_ntu;
