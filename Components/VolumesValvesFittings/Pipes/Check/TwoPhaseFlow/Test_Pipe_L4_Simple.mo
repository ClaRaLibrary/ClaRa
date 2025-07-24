within ClaRa.Components.VolumesValvesFittings.Pipes.Check.TwoPhaseFlow;
model Test_Pipe_L4_Simple
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

  Modelica.Blocks.Math.MultiSum multiSum(nu=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={79,-2})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=100000) annotation (Placement(transformation(extent={{60,-17},{40,3}})));
  inner SimCenter simCenter(
    redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    useHomotopy=false,
    showExpertSummary=true) annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=0,
    h_const=1.4e6)
               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-40,-7})));
  inner Modelica.Fluid.System system annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Sources.Step outlet_pressure(
    startTime=100,
    height=0,
    offset=1.9e7) annotation (Placement(transformation(extent={{-94,-23},{-74,-3}})));
  Modelica.Blocks.Sources.Ramp mass_flow(
    startTime=500,
    duration=20,
    height=0,
    offset=280) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,32})));

  Modelica.Blocks.Sources.Ramp T_wall(
    startTime=1000,
    duration=200,
    height=300,
    offset=573) annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-83.5,29.5})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature[tube.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-4,29})));
  Utilities.Blocks.RealInputMultiplyer realInputMultiplyer(N=tube.N_cv) annotation (Placement(transformation(extent={{-40,20},{-26,39}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    diameter_i=tube.diameter_i,
    diameter_o=tube.diameter_i + 0.01,
    T_start=573*ones(tube.N_cv),
    redeclare model Material = TILMedia.Solid.Types.TILMedia_Steel,
    stateLocation=2,
    N_tubes=tube.N_tubes,
    initOption=213) annotation (Placement(transformation(extent={{2,9},{14,23}})));

  Modelica.Blocks.Sources.Step inlet_enthalpy(
    startTime=2000,
    height=0,
    offset=1.4e6) annotation (Placement(transformation(
        extent={{-9,-9.5},{9,9.5}},
        rotation=0,
        origin={49,-35.5})));

  PipeFlowVLE_L4_Simple tube(
    length=80,
    diameter_i=0.03,
    z_in=0,
    z_out=80,
    N_cv=40,
    N_tubes=300,
    h_start=linspace(
        1.4e6,
        1.4e6,
        tube.N_cv),
    m_flow_nom=280,
    Delta_p_nom=1e5,
    p_start=linspace(
        1.97e7,
        1.9e7,
        tube.N_cv),
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=1000),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtInlet=false,
    frictionAtOutlet=true) annotation (Placement(transformation(extent={{22,-12},{-6,-2}})));

equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{71.98,-2},{62,-2},{62,-1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSink.p, outlet_pressure.y) annotation (Line(
      points={{-50,-13},{-73,-13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[1], mass_flow.y) annotation (Line(
      points={{85,-2},{85,-2},{92,-2},{92,32},{61,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_wall.y, realInputMultiplyer.Signal) annotation (Line(
      points={{-71.95,29.5},{-41.26,29.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature.T) annotation (Line(
      points={{-25.3,29.4525},{-18,29},{-11.2,29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thinWall.outerPhase) annotation (Line(
      points={{2,29},{8,29},{8,23}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_enthalpy.y) annotation (Line(
      points={{62,-7},{72,-7},{72,-35.5},{58.9,-35.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube.inlet, massFlowSource.steam_a) annotation (Line(
      points={{22,-7},{40,-7}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube.outlet, massFlowSink.steam_a) annotation (Line(
      points={{-6,-7},{-30,-7}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube.heat, thinWall.innerPhase) annotation (Line(
      points={{8,-3},{8,9}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,120}}), graphics={Text(
          extent={{-98,112},{100,72}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
test the L4 simple  pipe at evaporation scenario
______________________________________________________________________________________________
"),                                              Text(
          extent={{-98,88},{94,46}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-98,98},{100,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="______________________________________________________________________________________________
Scenario:  increase of outer wall temperature (at t=1000s 300°c --> 600 °C) causing evaporation in pipe    
 _______________________________________________________________________________________
")}),
    experiment(
      StopTime=3000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false, events=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)));
end Test_Pipe_L4_Simple;
