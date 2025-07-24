within ClaRa.Components.VolumesValvesFittings.Pipes.Check.FlowReversal;
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

 extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;

  Modelica.Blocks.Math.MultiSum multiSum(nu=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={77,-38})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=1000) annotation (Placement(transformation(extent={{58,-53},{38,-33}})));
  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1, useHomotopy=true)
    annotation (Placement(transformation(extent={{-100,-120},{-60,-100}})));
  PipeFlowVLE_L4_Simple tube(
    z_in=0,
    z_out=0,
    showExpertSummary=true,
    showData=true,
    diameter_i=0.5,
    h_start=ones(tube.N_cv)*200e3,
    length=50,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    N_cv=50,
    Delta_x=ones(tube.N_cv)*tube.length/tube.N_cv,
    frictionAtOutlet=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=10000),
    initOption=0,
    p_start=linspace(
        14.9e5,
        15e5,
        tube.N_cv),
    frictionAtInlet=true,
    m_flow_nom=100) annotation (Placement(transformation(extent={{19,-50},{-19,-36}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    m_flow_nom=100,
    p_const=1000000,
    h_const=200e3,
    Delta_p=100000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-48,-43})));
  Modelica.Blocks.Sources.Step outlet_pressure(
    startTime=100,
    height=2e5,
    offset=15e5) annotation (Placement(transformation(extent={{-92,-59},{-72,-39}})));
  Modelica.Blocks.Sources.Ramp mass_flow_1(
    duration=1,
    offset=0,
    startTime=1500,
    height=25)     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={48,22})));

  Modelica.Blocks.Sources.Ramp Q_flow(
    startTime=1000,
    duration=100,
    offset=2.5e7,
    height=5e7)
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,10})));

  Modelica.Blocks.Sources.Ramp mass_flow_2(
    duration=200,
    startTime=500,
    height=100,
    offset=-50)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={48,-10})));

  Modelica.Blocks.Sources.Step inlet_pressure1(
    offset=200e3,
    height=-150e3,
    startTime=2000)
                   annotation (Placement(transformation(
        extent={{9,-9.5},{-9,9.5}},
        rotation=0,
        origin={81,-69.5})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    stateLocation=2,
    N_ax=tube.N_cv,
    T_start=320*ones(tube.N_cv),
    initOption=213) annotation (Placement(transformation(extent={{-14,-30},{14,-20}})));

  BoundaryConditions.PrescribedHeatFlow prescribedHeatFlow(length=tube.length, N_axial=tube.N_cv) annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{69.98,-38},{60,-38},{60,-37}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSink.p, outlet_pressure.y) annotation (Line(
      points={{-58,-49},{-71,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube.inlet, massFlowSource.steam_a) annotation (Line(
      points={{19,-43},{38,-43}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, tube.outlet) annotation (Line(
      points={{-38,-43},{-19,-43}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_pressure1.y) annotation (Line(
      points={{60,-43},{66,-43},{66,-69.5},{71.1,-69.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube.heat) annotation (Line(
      points={{0,-30},{0,-37.4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mass_flow_1.y, multiSum.u[1]) annotation (Line(points={{59,22},{94,22},{94,-40.1},{83,-40.1}}, color={0,0,127}));
  connect(mass_flow_2.y, multiSum.u[2]) annotation (Line(points={{59,-10},{88,-10},{88,-35.9},{83,-35.9}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, thinWall.outerPhase) annotation (Line(
      points={{-20,10},{0,10},{0,-20}},
      color={167,25,48},
      thickness=0.5));
  connect(Q_flow.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-59,10},{-40,10}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-120},{100,120}}),
                    graphics={Text(
          extent={{-98,112},{100,72}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
test the heated L4 simple pipe in a flow reversal scenario to evaluate the numerical robustness and to check for
 physically meaningful behaviour
______________________________________________________________________________________________
"),                                               Text(
          extent={{-98,66},{80,24}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
"),                   Text(
          extent={{-98,86},{100,46}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  1) pressure step at inlet (at t=100s 15e5 Pa --> 17e5 Pa 
                2) reversal of flow (at t=500s -50 kg/s --> 50 kg/s)
                3) increase of heat flow rate (at t=1000s 2.5e7 W --> 7.5e7 W)
                4) reversal of mass flow (at t=1500s 50 kg/s --> 75 kg/s)
                5) spec. enthalpy step at inlet (at t=2000s 200 kJ/kgK --> 50 kJ/kgK)
______________________________________________________________________________________________
"),                               Rectangle(
          extent={{-100,120},{100,-120}},
          lineColor={115,150,0},
          lineThickness=0.5)}),
    experiment(
      StopTime=3000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true)));
end Test_Pipe_L4_Simple;
