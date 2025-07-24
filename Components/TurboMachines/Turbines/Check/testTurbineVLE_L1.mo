within ClaRa.Components.TurboMachines.Turbines.Check;
model testTurbineVLE_L1

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 turbineControlValve(
    showExpertSummary=true,
    checkValve=false,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=100, Delta_p_nom=10e5),
    opening_const_=0.761174,
    useStabilisedMassFlow=false,
    openingInputIsActive=true) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={-140,28})));
  Modelica.Blocks.Sources.CombiTimeTable rampSetPoint(extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table=[0,10]) annotation (Placement(transformation(
        extent={{-8.5,8.5},{8.5,-8.5}},
        rotation=180,
        origin={-52,28})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 turbineHP(
    showExpertSummary=true,
    showData=true,
    m_flow_nom=79.1,
    rho_nom=37.1,
    rpm(start=3000),
    steadyStateTorque=false,
    J=500,
    Pi=32.9e5/turbineHP.p_nom,
    useMechanicalPort=true,
    eta_mech=0.9,
    p_nom=12790000,
    redeclare model Efficiency = Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=[0.0,0.9; 1,0.98]))
                            annotation (Placement(transformation(extent={{-130,-20},{-120,0}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink(
    variable_h=false,
    p_const(displayUnit="Pa") = 32.9e5,
    variable_p=true,
    energyType=1) annotation (Placement(transformation(extent={{48,-48},{28,-28}})));
  ClaRa.Visualisation.Quadruple quadruple(largeFonts=simCenter.largeFonts)
    annotation (Placement(transformation(extent={{-118,-67},{-62,-53}})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={40,-16})));
  Modelica.Mechanics.Rotational.Components.Inertia
          generator_inertia(
    phi(start=0),
    a(start=0),
    J=235,
    w(start=40*2*3.1415))
              annotation (Placement(transformation(extent={{66,-26},{86,-6}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(useSupport=false) annotation (Placement(transformation(extent={{146,-26},{126,-6}})));
  Modelica.Blocks.Continuous.LimPID PI_speed(
    y_start=1,
    yMax=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    k=0.1,
    Td=3.411,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=1,
    yMin=0.01) annotation (Placement(transformation(extent={{-79,21},{-93,35}})));
  ClaRa.Components.Utilities.Blocks.VariableGradientLimiter
    variableGradientLimiter1(
    constantLimits=true,
    maxGrad_const=10,
    minGrad_const=-10)
    annotation (Placement(transformation(extent={{-103,21},{-117,35}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink1(
    variable_h=false,
    h_const=3500e3,
    variable_p=true,
    energyType=1) annotation (Placement(transformation(extent={{-168,34},{-148,54}})));
  inner ClaRa.SimCenter simCenter(
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    contributeToCycleSummary=true,
    showExpertSummary=true) annotation (Placement(transformation(extent={{-200,-80},{-160,-60}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=30e5,
    startTime=5000,
    duration=120,
    offset=150e5)   annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Modelica.Mechanics.Rotational.Components.BearingFriction bearingFriction(tau_pos=[0,1; 100,200]) annotation (Placement(transformation(extent={{94,-26},{114,-6}})));
  Modelica.Blocks.Sources.Ramp speedBoundary(
    duration=5,
    startTime=100000,
    height=0,
    offset=(3000/60*2*Modelica.Constants.pi)) annotation (Placement(transformation(extent={{178,-26},{158,-6}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=4000,
    startTime=6000,
    offset=0.045e5,
    height=0.95e5)  annotation (Placement(transformation(extent={{104,-62},{84,-42}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 turbineIP(
    showExpertSummary=true,
    showData=true,
    m_flow_nom=79.1,
    rpm(start=3000),
    steadyStateTorque=false,
    J=500,
    p_nom(displayUnit="Pa") = 32.9e5,
    rho_nom=10,
    Pi=2e5/turbineIP.p_nom,
    useMechanicalPort=true,
    eta_mech=0.9,
    redeclare model Efficiency = Fundamentals.TurbineEfficiency.TableVolumeFlow (eta_Vflow=[0.0,0.9; 1,0.98]))
                            annotation (Placement(transformation(extent={{-70,-20},{-60,0}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 turbineLP(
    showExpertSummary=true,
    showData=true,
    m_flow_nom=79.1,
    rpm(start=3000),
    steadyStateTorque=false,
    rho_nom=1,
    J=500,
    Pi=0.045e5/turbineLP.p_nom,
    useMechanicalPort=true,
    eta_mech=0.9,
    p_nom=200000,
    redeclare model Efficiency = Fundamentals.TurbineEfficiency.RayCorrelation)
                            annotation (Placement(transformation(extent={{-10,-20},{0,0}})));
  ClaRa.Visualisation.Quadruple quadruple1(
                                          largeFonts=simCenter.largeFonts, decimalSpaces(p=3))
    annotation (Placement(transformation(extent={{8,-67},{64,-53}})));
  ClaRa.Visualisation.Quadruple quadruple2(
                                          largeFonts=simCenter.largeFonts)
    annotation (Placement(transformation(extent={{-56,-67},{0,-53}})));
  Modelica.Blocks.Math.Gain rampSetPoint1(k=1/1e7) annotation (Placement(transformation(
        extent={{-4.25,4.25},{4.25,-4.25}},
        rotation=180,
        origin={-31.75,11.75})));

equation
  connect(turbineHP.eye, quadruple.eye) annotation (Line(
      points={{-119,-16},{-119,-44},{-118,-44},{-118,-60}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(PI_speed.y,variableGradientLimiter1. u) annotation (Line(
      points={{-93.7,28},{-101.6,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink1.steam_a, turbineControlValve.inlet) annotation (Line(
      points={{-148,44},{-140,44},{-140,38}},
      color={0,131,169},
      thickness=0.5));
  connect(bearingFriction.flange_b, speed.flange) annotation (Line(points={{114,-16},{120,-16},{126,-16}}, color={0,0,0}));
  connect(generator_inertia.flange_b, bearingFriction.flange_a) annotation (Line(points={{86,-16},{90,-16},{94,-16}}, color={0,0,0}));
  connect(variableGradientLimiter1.y, turbineControlValve.opening_in) annotation (Line(points={{-117.7,28},{-117.7,28},{-131,28}}, color={0,0,127}));
  connect(turbineControlValve.outlet, turbineHP.inlet) annotation (Line(
      points={{-140,18},{-140,6},{-140,-4},{-130,-4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(ramp.y, pressureSink1.p) annotation (Line(points={{-179,50},{-179,50},{-168,50}}, color={0,0,127}));
  connect(ramp2.y, pressureSink.p) annotation (Line(points={{83,-52},{83,-52},{82,-52},{84,-52},{68,-52},{68,-32},{48,-32}},
                                                                                color={0,0,127}));
  connect(rampSetPoint.y[1], PI_speed.u_s) annotation (Line(points={{-61.35,28},{-61.35,28},{-77.6,28}}, color={0,0,127}));
  connect(turbineHP.outlet, turbineIP.inlet) annotation (Line(
      points={{-120,-20},{-120,-20},{-94,-20},{-94,-4},{-70,-4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(turbineHP.shaft_b, turbineIP.shaft_a) annotation (Line(points={{-116,-10},{-116,-10},{-74,-10}}, color={0,0,0}));
  connect(turbineIP.shaft_b, turbineLP.shaft_a) annotation (Line(points={{-56,-10},{-56,-10},{-14,-10}}, color={0,0,0}));
  connect(turbineIP.outlet, turbineLP.inlet) annotation (Line(
      points={{-60,-20},{-32,-20},{-32,-4},{-10,-4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(turbineLP.outlet, pressureSink.steam_a) annotation (Line(
      points={{0,-20},{0,-38},{28,-38}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(turbineLP.eye, quadruple1.eye) annotation (Line(points={{1,-16},{1,-28},{8,-28},{8,-60}}, color={190,190,190}));
  connect(turbineIP.eye, quadruple2.eye) annotation (Line(points={{-59,-16},{-60,-16},{-60,-60},{-56,-60}}, color={190,190,190}));
  connect(turbineLP.shaft_b, powerSensor.flange_a) annotation (Line(points={{4,-10},{4,-16},{30,-16}},   color={0,0,0}));
  connect(powerSensor.flange_b, generator_inertia.flange_a) annotation (Line(points={{50,-16},{58,-16},{66,-16}}, color={0,0,0}));
  connect(powerSensor.power, rampSetPoint1.u) annotation (Line(points={{32,-5},{32,-5},{32,8},{32,11.75},{-26.65,11.75}}, color={0,0,127}));
  connect(rampSetPoint1.y, PI_speed.u_m) annotation (Line(points={{-36.425,11.75},{-86,11.75},{-86,19.6}}, color={0,0,127}));
  connect(speedBoundary.y, speed.w_ref) annotation (Line(points={{157,-16},{148,-16}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,150}},
        initialScale=0.1),                                                                         graphics={
                                  Text(
          extent={{-150,146},{48,106}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
Test HP, IP and LP turbine part on one mechanical shaft.
______________________________________________________________________________________________
"),                   Text(
          extent={{-150,98},{50,80}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  
Try mechanical port on:
The total power of all turbine stages is controlled, the shaft speed is defined by a boundary, i.e. the grid frequency. 
The controller reacts on a pressure rise at the inlet.
Try mechanical port off: 
No shaft connectors will be present and the fixed speed rpm_fixed will be used. 
The power controller has no effect on the turbine inlet valve opening, the inlet valve stays open.

______________________________________________________________________________________________
"),                                               Text(
          extent={{-150,76},{16,34}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),
        Rectangle(
          extent={{-200,150},{200,-100}},
          lineColor={115,150,0},
          lineThickness=0.5)}),
    experiment(StopTime=10000, Tolerance=1e-005),
    __Dymola_experimentSetupOutput(equidistant=false));
end testTurbineVLE_L1;
