within ClaRa.Components.Sensors.Check;
model TestSensorVLE_L3_T

//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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

Real Re;
Real Pr;
Real Nu;
Real alpha;

  ClaRa.Components.Sensors.SensorVLE_L1_T temperature annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=100e5, variable_p=true)
                                                                                       annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0.0,10; 100,10; 101,5; 200,5; 201,1; 300,1; 1000,6.3; 10000,6.3])
                                                                                                  annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,3500e3; 50,3500e3; 50.01,3800e3; 150,3800e3; 150.01,3500e3; 250,3500e3; 250.01,3800e3; 300,3800e3; 1000,104e3; 10000,104e3; 10001,148e3; 10002,148e3])
                                                                                                                                                            annotation (Placement(transformation(extent={{-100,-16},{-80,4}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow1(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi1(p_const=100e5, variable_p=true)
                                                                                        annotation (Placement(transformation(extent={{62,-30},{42,-10}})));
  inner ClaRa.SimCenter simCenter(showExpertSummary=true)
                                  annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  SensorVLE_L3_T temperatureSensorVLE_L3(
    p_start=100e5,
    h_start=3500e3,
    thickness_sensor=4e-3,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_StainlessSteel,
    T_sensor_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
        temperatureSensorVLE_L3.FluidMedium,
        temperatureSensorVLE_L3.p_start,
        temperatureSensorVLE_L3.h_start,
        temperatureSensorVLE_L3.xi_start) + 10)                          annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Modelica.Blocks.Sources.TimeTable timeTable2(table=[0.0,100e5; 300,100e5; 1000,1e5; 10000,1e5]) annotation (Placement(transformation(extent={{98,-6},{78,14}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1 annotation (Placement(transformation(extent={{16,-26},{36,-14}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_2 annotation (Placement(transformation(extent={{14,14},{34,26}})));
  BoundaryConditions.BoundaryVLE_hxim_flow                  boundaryVLE_hxim_flow2(variable_m_flow=true, variable_h=true) annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  BoundaryConditions.BoundaryVLE_phxi                  boundaryVLE_phxi2(p_const=100e5, variable_p=true)
                                                                                        annotation (Placement(transformation(extent={{62,-70},{42,-50}})));
  SensorVLE_L3_T temperatureSensorVLE_L3_considerHeatConduction(
    p_start=100e5,
    h_start=3500e3,
    thickness_sensor=4e-3,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_StainlessSteel,
    considerHeatConduction=true,
    T_sensor_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
        temperatureSensorVLE_L3_considerHeatConduction.FluidMedium,
        temperatureSensorVLE_L3_considerHeatConduction.p_start,
        temperatureSensorVLE_L3_considerHeatConduction.h_start,
        temperatureSensorVLE_L3_considerHeatConduction.xi_start) + 10) annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_3 annotation (Placement(transformation(extent={{16,-66},{36,-54}})));
equation
  Re=temperatureSensorVLE_L3.thickness_sensor*Modelica.Constants.pi*temperatureSensorVLE_L3.fluidVolume.summary.inlet.m_flow/temperatureSensorVLE_L3.fluidVolume.fluidIn.transp.eta/temperatureSensorVLE_L3.fluidVolume.geo.A_front;
  Pr=temperatureSensorVLE_L3.fluidVolume.fluidIn.transp.Pr;
  Nu=0.3+sqrt((0.664*sqrt(Re)*Pr^(1/3))^2+(0.037*Re^(0.8)*Pr/(1+2.443*Re^(-0.1)*(Pr^(2/3)-1)))^2);
alpha=Nu*temperatureSensorVLE_L3.fluidVolume.fluidIn.transp.lambda/(temperatureSensorVLE_L3.thickness_sensor*Modelica.Constants.pi);
  connect(timeTable.y, boundaryVLE_hxim_flow.m_flow) annotation (Line(points={{-79,30},{-70,30},{-70,26},{-62,26}}, color={0,0,127}));
  connect(timeTable1.y, boundaryVLE_hxim_flow.h) annotation (Line(points={{-79,-6},{-72,-6},{-72,20},{-62,20}}, color={0,0,127}));
  connect(timeTable.y, boundaryVLE_hxim_flow1.m_flow) annotation (Line(points={{-79,30},{-70,30},{-70,-14},{-62,-14}}, color={0,0,127}));
  connect(timeTable1.y, boundaryVLE_hxim_flow1.h) annotation (Line(points={{-79,-6},{-72,-6},{-72,-20},{-62,-20}}, color={0,0,127}));
  connect(boundaryVLE_hxim_flow1.steam_a, temperatureSensorVLE_L3.inlet) annotation (Line(
      points={{-40,-20},{-10,-20}},
      color={0,131,169},
      thickness=0.5));
  connect(timeTable2.y, boundaryVLE_phxi.p) annotation (Line(points={{77,4},{70,4},{70,26},{60,26}}, color={0,0,127}));
  connect(timeTable2.y, boundaryVLE_phxi1.p) annotation (Line(points={{77,4},{70,4},{70,-16},{70,-14},{62,-14}}, color={0,0,127}));
  connect(valveVLE_L1_1.outlet, boundaryVLE_phxi1.steam_a) annotation (Line(
      points={{36,-20},{39,-20},{42,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveVLE_L1_1.inlet, temperatureSensorVLE_L3.outlet) annotation (Line(
      points={{16,-20},{10,-20}},
      color={0,131,169},
      thickness=0.5));
  connect(temperature.port, valveVLE_L1_2.inlet) annotation (Line(
      points={{0,20},{14,20}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_2.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{34,20},{40,20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_hxim_flow.steam_a, temperature.port) annotation (Line(
      points={{-40,20},{0,20}},
      color={0,131,169},
      thickness=0.5));
  connect(boundaryVLE_hxim_flow2.steam_a, temperatureSensorVLE_L3_considerHeatConduction.inlet) annotation (Line(
      points={{-40,-60},{-10,-60}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_3.outlet,boundaryVLE_phxi2. steam_a) annotation (Line(
      points={{36,-60},{42,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveVLE_L1_3.inlet, temperatureSensorVLE_L3_considerHeatConduction.outlet) annotation (Line(
      points={{16,-60},{10,-60}},
      color={0,131,169},
      thickness=0.5));
  connect(timeTable2.y, boundaryVLE_phxi2.p) annotation (Line(points={{77,4},{70,4},{70,-54},{62,-54}}, color={0,0,127}));
  connect(timeTable1.y, boundaryVLE_hxim_flow2.h) annotation (Line(points={{-79,-6},{-72,-6},{-72,-60},{-62,-60}}, color={0,0,127}));
  connect(timeTable.y, boundaryVLE_hxim_flow2.m_flow) annotation (Line(points={{-79,30},{-70,30},{-70,-54},{-62,-54}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                  Text(
          extent={{-84,94},{114,54}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="______________________________________________________________________________________________
PURPOSE: Compare output of real temperature sensor and ideal temperatur sensor in a number of boundary condition changes.

______________________________________________________________________________________________
")}),
    experiment(StopTime=15000, __Dymola_NumberOfIntervals=15000));
end TestSensorVLE_L3_T;
