within ClaRa.Components.MechanicalSeparation.Check;
model TestSeparator_L3 "Check of normal operation and dry operation (Benson operation) is supported"

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  ClaRa.Components.MechanicalSeparation.SteamSeparatorVLE_L3 steamSeparator(
    m_flow_nom=100,
    p_nom=100e5,
    p_start=101e5,
    levelOutput=true,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    z_out1=0.1,
    z_out2=19.9,
    radius_flange=0.1,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={20000}),
    z_in=18,
    Tau_evap=0.3,
    Tau_cond=0.03,
    initOption=204) annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(variable_m_flow=true, variable_h=true,
    showData=true)                                                                                                     annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(variable_p=true) annotation (Placement(transformation(extent={{-38,74},{-18,94}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                        m_flow_nom=40, Delta_p_nom=3e5)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={0,70})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_2(openingInputIsActive=true, redeclare model PressureLoss =
        VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                                   Delta_p_nom=3e5, m_flow_nom=40)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={0,-48})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi1(variable_p=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-88})));
  Modelica.Blocks.Sources.TimeTable
                               ramp(table=[0,1; 15000,1; 15010,0; 20000,0; 20010,1; 60000,1])
                     annotation (Placement(transformation(extent={{50,-58},{30,-38}})));
  inner ClaRa.SimCenter simCenter(showExpertSummary=true, redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1)
    annotation (Placement(transformation(extent={{40,-100},{80,-80}})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{-42,-16},{-10,-6}})));
  ClaRa.Visualisation.Quadruple quadruple1 annotation (Placement(transformation(extent={{-52,-52},{-20,-42}})));
  ClaRa.Visualisation.Quadruple quadruple2 annotation (Placement(transformation(extent={{16,78},{48,88}})));
  Modelica.Blocks.Sources.TimeTable timeTable_p(table=[0,100e5; 10000,100e5; 12000,300e5; 20000,300e5; 20001,130e5; 30000,130e5; 40000,130e5; 41000,60e5; 45000,60e5; 50000,180e5; 60000,180e5])
                                                                                            annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,100; 5000,100; 5600,300; 10000,300]) annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.TimeTable timeTable2(table=[0,2000e3; 7000,2000e3; 7200,3000e3; 10200,3000e3; 25000,3000e3; 25199,1200e3; 25200,1200e3; 30000,1200e3; 41000,2000e3; 45000,2000e3; 50000,2120e3; 60000,2120e3])
                                                                                            annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Blocks.Sources.TimeTable timeTable_p1(table=timeTable_p.table, offset=-1e5) annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  ClaRa.Visualisation.Quadruple quadruple3 annotation (Placement(transformation(extent={{26,18},{58,28}})));
  ClaRa.Visualisation.Quadruple quadruple4 annotation (Placement(transformation(extent={{28,-12},{60,-2}})));
  SteamSeparatorVLE_L3 steamSeparator_controlled(
    m_flow_nom=100,
    p_nom=100e5,
    p_start=101e5,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    z_out1=0.1,
    z_out2=19.9,
    radius_flange=0.1,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={20000}),
    z_in=18,
    Tau_evap=0.3,
    initOption=204) annotation (Placement(transformation(extent={{182,0},{202,20}})));
  BoundaryConditions.BoundaryVLE_hxim_flow                  boundaryVLE_hxim_flow1(
                                                                                  variable_m_flow=true, variable_h=true,
    showData=true)                                                                                                     annotation (Placement(transformation(extent={{130,0},{150,20}})));
  BoundaryConditions.BoundaryVLE_phxi                  boundaryVLE_phxi2(
                                                                        variable_p=true) annotation (Placement(transformation(extent={{154,74},{174,94}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_3(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                       m_flow_nom=40, Delta_p_nom=3e5)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={194,70})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_4(openingInputIsActive=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                  Delta_p_nom=3e5, m_flow_nom=100)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={192,-48})));
  BoundaryConditions.BoundaryVLE_phxi                  boundaryVLE_phxi3(variable_p=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={192,-88})));
  Visualisation.Quadruple       quadruple5
                                          annotation (Placement(transformation(extent={{156,-18},{188,-8}})));
  Visualisation.Quadruple       quadruple6 annotation (Placement(transformation(extent={{216,-72},{248,-62}})));
  Visualisation.Quadruple       quadruple7 annotation (Placement(transformation(extent={{208,78},{240,88}})));
  Visualisation.Quadruple       quadruple8 annotation (Placement(transformation(extent={{208,18},{240,28}})));
  Visualisation.Quadruple       quadruple9 annotation (Placement(transformation(extent={{206,-12},{238,-2}})));
  Visualisation.DynamicBar dynamicBar(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    u=steamSeparator_controlled.volume.summary.outline.level_rel,
    provideOutputConnector=true) annotation (Placement(transformation(extent={{204,0},{214,20}})));
  Utilities.Blocks.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    Tau_i=100,
    sign=-1) annotation (Placement(transformation(extent={{262,20},{282,40}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0.1) annotation (Placement(transformation(extent={{226,34},{240,46}})));
  Visualisation.DynamicBar dynamicBar1(
    provideInputConnectors=true,
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    u=steamSeparator_controlled.volume.summary.outline.level_rel,
    provideOutputConnector=false)
                                 annotation (Placement(transformation(extent={{14,2},{24,22}})));
equation
  connect(boundaryVLE_hxim_flow.steam_a, steamSeparator.inlet) annotation (Line(
      points={{-40,10},{-10,10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(valveVLE_L1_1.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{6.66134e-016,80},{6.66134e-016,84},{-18,84}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(boundaryVLE_phxi1.steam_a, valveVLE_L1_2.outlet) annotation (Line(
      points={{0,-78},{0,-58}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, valveVLE_L1_2.opening_in) annotation (Line(
      points={{29,-48},{9,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(quadruple.eye, boundaryVLE_hxim_flow.eye) annotation (Line(
      points={{-42,-11},{-42,-4},{-40,-4},{-40,2}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple1.eye, valveVLE_L1_2.eye) annotation (Line(
      points={{-52,-47},{-4,-47},{-4,-58}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(timeTable_p.y, boundaryVLE_phxi.p) annotation (Line(
      points={{-79,110},{-54,110},{-54,90},{-38,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundaryVLE_hxim_flow.m_flow,timeTable1. y) annotation (Line(
      points={{-62,16},{-66,16},{-66,40},{-79,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timeTable2.y, boundaryVLE_hxim_flow.h) annotation (Line(
      points={{-79,-20},{-70,-20},{-70,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timeTable_p1.y, boundaryVLE_phxi1.p) annotation (Line(points={{-59,-90},{-30,-90},{-30,-98},{-6,-98}}, color={0,0,127}));
  connect(valveVLE_L1_1.eye, quadruple2.eye) annotation (Line(points={{4,80},{12,80},{12,83},{16,83}}, color={190,190,190}));
  connect(steamSeparator.eye_out2, quadruple3.eye) annotation (Line(points={{4,21},{4,23},{26,23}},               color={190,190,190}));
  connect(steamSeparator.eye_out1, quadruple4.eye) annotation (Line(points={{4,-1},{4,-7},{28,-7}},        color={190,190,190}));
  connect(valveVLE_L1_1.inlet, steamSeparator.outlet2) annotation (Line(
      points={{0,60},{0,60},{0,20}},
      color={0,131,169},
      thickness=0.5));
  connect(steamSeparator.outlet1, valveVLE_L1_2.inlet) annotation (Line(
      points={{0,0},{0,-38}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_hxim_flow1.steam_a, steamSeparator_controlled.inlet) annotation (Line(
      points={{150,10},{182,10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valveVLE_L1_3.outlet, boundaryVLE_phxi2.steam_a) annotation (Line(
      points={{194,80},{194,84},{174,84}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(boundaryVLE_phxi3.steam_a,valveVLE_L1_4. outlet) annotation (Line(
      points={{192,-78},{192,-58}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(quadruple5.eye, boundaryVLE_hxim_flow1.eye) annotation (Line(
      points={{156,-13},{156,-12},{150,-12},{150,2}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple6.eye,valveVLE_L1_4. eye) annotation (Line(
      points={{216,-67},{188,-67},{188,-60},{188,-60},{188,-66},{188,-66},{188,-58}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(valveVLE_L1_3.eye,quadruple7. eye) annotation (Line(points={{198,80},{204,80},{204,83},{208,83}},
                                                                                            color={190,190,190}));
  connect(steamSeparator_controlled.outlet2, valveVLE_L1_3.inlet) annotation (Line(
      points={{192,20},{192,60},{194,60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveVLE_L1_4.inlet, steamSeparator_controlled.outlet1) annotation (Line(
      points={{192,-38},{192,-38},{192,0}},
      color={0,131,169},
      thickness=0.5));
  connect(steamSeparator_controlled.eye_out2, quadruple8.eye) annotation (Line(points={{196,21},{196,21},{196,22},{196,23},{208,23}}, color={190,190,190}));
  connect(steamSeparator_controlled.eye_out1, quadruple9.eye) annotation (Line(points={{196,-1},{196,-1},{196,-7},{206,-7}}, color={190,190,190}));
  connect(realExpression.y, PID.u_s) annotation (Line(points={{240.7,40},{252,40},{252,30},{260,30}}, color={0,0,127}));
  connect(dynamicBar.y, PID.u_m) annotation (Line(points={{215,0},{272.1,0},{272.1,18}},
                                                                                     color={0,0,127}));
  connect(PID.y, valveVLE_L1_4.opening_in) annotation (Line(points={{283,30},{292,30},{292,-48},{201,-48}},   color={0,0,127}));
  connect(timeTable_p.y, boundaryVLE_phxi2.p) annotation (Line(points={{-79,110},{22,110},{124,110},{124,90},{154,90}}, color={0,0,127}));
  connect(timeTable1.y, boundaryVLE_hxim_flow1.m_flow) annotation (Line(points={{-79,40},{-79,40},{-44,40},{110,40},{110,16},{128,16}}, color={0,0,127}));
  connect(timeTable2.y, boundaryVLE_hxim_flow1.h) annotation (Line(points={{-79,-20},{110,-20},{110,10},{128,10}}, color={0,0,127}));
  connect(timeTable_p1.y, boundaryVLE_phxi3.p) annotation (Line(points={{-59,-90},{-32,-90},{-32,-100},{186,-100},{186,-100},{186,-100},{186,-98},{186,-98}}, color={0,0,127}));
  connect(steamSeparator.level, dynamicBar1.u_in) annotation (Line(points={{11,2},{13,2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
        initialScale=0.1,
        extent={{-100,-100},{300,160}}), graphics={
                                  Text(
          extent={{-8,144},{192,104}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="______________________________________________________________________________________________
PURPOSE:
Show steam separator functionality for normal and abnormal operation conditions.
Show differences between controlled and uncontrolled separation behaviour
______________________________________________________________________________________________
")}),
    experiment(StopTime=60000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false, initialScale=0.1)));
end TestSeparator_L3;
