within ClaRa.Components.MechanicalSeparation.Check;
model TestSeparator_L1 "Check of normal operation and dry operation (Benson operation) is supported"

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

  //Real diff = steamSeparator.summary.inlet.H_flow - steamSeparator.summary.outlet1.H_flow - steamSeparator.summary.outlet2.H_flow;
  Real diff = steamSeparator.inlet.m_flow*steamSeparator.fluidIn.h - (-steamSeparator.outlet1.m_flow*steamSeparator.fluidOut1.h) - (-steamSeparator.outlet2.m_flow*steamSeparator.fluidOut2.h);

  ClaRa.Components.MechanicalSeparation.SteamSeparatorVLE_L1 steamSeparator(eta_vap=0.96, eta_liq=0.98) annotation (Placement(transformation(extent={{24,0},{44,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(variable_p=true) annotation (Placement(transformation(extent={{-36,60},{-16,80}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                        m_flow_nom=400)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={34,50})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi1(variable_p=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={34,-70})));
  Modelica.Blocks.Sources.TimeTable timeTable_p(table=[0,100e5; 10000,100e5; 12000,300e5; 20000,300e5; 20001,130e5; 30000,130e5; 40000,130e5; 41000,60e5; 45000,60e5; 50000,180e5; 60000,180e5])
                                                                                            annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,100; 5000,100; 5600,300; 10000,300]) annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  Modelica.Blocks.Sources.TimeTable timeTable2(table=[0,2000e3; 7000,2000e3; 7200,3000e3; 10200,3000e3; 25000,3000e3; 25001,1200e3; 25200,1200e3; 30000,1200e3; 41000,2000e3; 45000,2000e3; 50000,2120e3; 60000,2120e3])
                                                                                            annotation (Placement(transformation(extent={{-100,-24},{-80,-4}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    duration=10,
    offset=1,
    startTime=15000) annotation (Placement(transformation(extent={{100,-38},{80,-18}})));
  Modelica.Blocks.Sources.TimeTable timeTable_p1(table=timeTable_p.table, offset=-1e5) annotation (Placement(transformation(extent={{-76,-90},{-56,-70}})));
  inner ClaRa.SimCenter simCenter(showExpertSummary=true) annotation (Placement(transformation(extent={{40,-100},{80,-80}})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 volumeVLE_2_1(
    m_flow_nom=400,
    p_nom=6000000,
    h_start=2000e3,
    p_start=10200000) annotation (Placement(transformation(extent={{-34,0},{-14,20}})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{41,26},{72,36}})));
  ClaRa.Visualisation.Quadruple quadruple1 annotation (Placement(transformation(extent={{40,-14},{71,-4}})));
equation

  connect(valveVLE_L1_1.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{34,60},{34,70},{-16,70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(timeTable_p.y, boundaryVLE_phxi.p) annotation (Line(
      points={{-59,70},{-58,70},{-58,76},{-36,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timeTable_p1.y, boundaryVLE_phxi1.p) annotation (Line(
      points={{-55,-80},{28,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundaryVLE_hxim_flow.m_flow, timeTable1.y) annotation (Line(
      points={{-62,16},{-68,16},{-68,28},{-79,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timeTable2.y, boundaryVLE_hxim_flow.h) annotation (Line(
      points={{-79,-14},{-72,-14},{-72,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(volumeVLE_2_1.outlet, steamSeparator.inlet) annotation (Line(
      points={{-14,10},{24,10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_hxim_flow.steam_a, volumeVLE_2_1.inlet) annotation (Line(
      points={{-40,10},{-34,10}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple.eye, steamSeparator.eye_out2) annotation (Line(points={{41,31},{38,31},{38,21}},         color={190,190,190}));
  connect(steamSeparator.eye_out1, quadruple1.eye) annotation (Line(points={{38,-1},{38,-9},{40,-9}}, color={190,190,190}));
  connect(steamSeparator.outlet1, boundaryVLE_phxi1.steam_a) annotation (Line(
      points={{34,0},{34,0},{34,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(steamSeparator.outlet2, valveVLE_L1_1.inlet) annotation (Line(
      points={{34,20},{34,40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,130}},
        initialScale=0.1), graphics={
                                  Text(
          extent={{-100,120},{100,80}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
Show steam separator functionality for normal and abnormal operation conditions
______________________________________________________________________________________________
")}),
    experiment(
      StopTime=60000,
      __Dymola_NumberOfIntervals=20000,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput);
end TestSeparator_L1;
