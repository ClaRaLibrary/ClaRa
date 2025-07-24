within ClaRa.Components.VolumesValvesFittings.Pipes.Check.OnePhaseFlow;
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

  Modelica.Blocks.Math.MultiSum multiSum(nu=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={71,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=1000) annotation (Placement(transformation(extent={{58,-70},{38,-50}})));
  inner SimCenter simCenter(
    redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    useHomotopy=false,
    showExpertSummary=true) annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  PipeFlowVLE_L4_Simple tube(
    length=50,
    m_flow_nom=100,
    diameter_i=0.5,
    N_cv=50,
    h_start=ones(tube.N_cv)*200e3,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    showData=false,
    z_in=50,
    frictionAtInlet=true,
    z_out=0.1,
    frictionAtOutlet=true,
    N_passes=2,
    p_start=linspace(
        1e5,
        6e5,
        tube.N_cv),
    initOption=0) annotation (Placement(transformation(extent={{16,-65},{-11,-55}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    h_const=100e3,
    m_flow_nom=100,
    p_const=1000000)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-46,-60})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Modelica.Blocks.Sources.Step inlet_pressure(
    startTime=100,
    height=1e4,
    offset=6e5)
    annotation (Placement(transformation(extent={{-100,-77},{-80,-57}})));
  Modelica.Blocks.Sources.Ramp mass_flow_1(
    duration=1,
    height=10,
    offset=100,
    startTime=500) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,2})));

  Modelica.Blocks.Sources.Ramp T_wall(
    duration=4,
    startTime=1000,
    offset=293.15,
    height=200) annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-89.5,-22.5})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature[tube.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-10,-23})));
  Utilities.Blocks.RealInputMultiplyer realInputMultiplyer(N=tube.N_cv) annotation (Placement(transformation(extent={{-46,-32},{-32,-13}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(extent={{-10,-46},{16,-36}})));
  Modelica.Blocks.Sources.Ramp mass_flow_2(
    offset=100,
    height=-50,
    startTime=1500,
    duration=1)     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={88,2})));

  Modelica.Blocks.Sources.Step inlet_pressure1(
    height=20e3,
    offset=200e3,
    startTime=2000) annotation (Placement(transformation(
        extent={{9,-9.5},{-9,9.5}},
        rotation=0,
        origin={91,-89.5})));

equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{71,-47.02},{72,-47.02},{72,-54},{60,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSink.p, inlet_pressure.y) annotation (Line(
      points={{-56,-66},{-68,-66},{-68,-67},{-79,-67}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube.inlet, massFlowSource.steam_a) annotation (Line(
      points={{16,-60},{38,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, tube.outlet) annotation (Line(
      points={{-36,-60},{-11,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_wall.y, realInputMultiplyer.Signal) annotation (Line(
      points={{-77.95,-22.5},{-47.26,-22.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature.T) annotation (Line(
      points={{-31.3,-22.5475},{-24,-23},{-17.2,-23}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thinWall.outerPhase) annotation (Line(
      points={{-4,-23},{3,-23},{3,-36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube.heat) annotation (Line(
      points={{3,-46},{3,-56},{2.5,-56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_pressure1.y) annotation (Line(
      points={{60,-60},{66,-60},{66,-89.5},{81.1,-89.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mass_flow_1.y, multiSum.u[1]) annotation (Line(
      points={{61,2},{69.1,2},{69.1,-34},{73.1,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mass_flow_2.y, multiSum.u[2]) annotation (Line(
      points={{77,2},{72,2},{72,-34},{68.9,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{
            100,120}}), graphics={Text(
          extent={{-100,112},{98,72}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________
PURPOSE:
test the simple L4 pipe in a various number of steps concerning mass flow rate heat flow rate 
and inlet enthalpy to evaluate the numerical robustness and to check for physically meaningful behaviour
______________________________________________________________________________________________
",        fontSize=10),                           Text(
          extent={{-100,88},{98,48}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________
Scenario:  1) pressure step at inlet (at t=100s 1e5 Pa --> 1.1e5 Pa 
                2) increase of mass flow (at t = 500s 200kg/s --> 210 kg/s)
                3) increase of outer wall temperature (at t=1000s 293.15K --> 493.15 K)
                4) decrease of mass flow (at t=1500s 210 kg/s --> 160 kg/s)
                5) increase of inlet temperature (at t=2000s 200e3 J/kg.K --> 220e3 J/kg.K
______________________________________________________________________________________________
",        fontSize=10),Text(
          extent={{-100,66},{78,24}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: - tube is initialised steady state in pressure and enthalpy
______________________________________________________________________________________________________________
",        fontSize=8)}),
    experiment(
      StopTime=3000,
      __Dymola_NumberOfIntervals=10000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true)));
end Test_Pipe_L4_Simple;
