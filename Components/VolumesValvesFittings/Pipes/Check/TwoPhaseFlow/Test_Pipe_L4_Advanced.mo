within ClaRa.Components.VolumesValvesFittings.Pipes.Check.TwoPhaseFlow;
model Test_Pipe_L4_Advanced
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

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  Modelica.Blocks.Math.MultiSum multiSum(nu=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={80,6})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=100000) annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  inner SimCenter simCenter(                                                                                useHomotopy=false) annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  PipeFlowVLE_L4_Advanced                                                       tube(
    suppressHighFrequencyOscillations=true,
    z_in=0,
    showExpertSummary=true,
    showData=true,
    Delta_x=ones(tube.N_cv)*tube.length/tube.N_cv,
    length=80,
    diameter_i=0.03,
    z_out=80,
    N_tubes=300,
    N_cv=40,
    p_start=linspace(
        2e7,
        1.9e7,
        tube.N_cv),
    frictionAtInlet=true,
    initOption=0,
    h_start=linspace(
        1.4e6,
        1.4e6,
        tube.N_cv),
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=10000),
    frictionAtOutlet=false,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(extent={{27,-6.5},{-7,6.5}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    h_const=100e3,
    p_const=1000000,
    m_flow_nom=100)
               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-40,0})));
  inner Modelica.Fluid.System system annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Sources.CombiTimeTable
                               outlet_pressure(
    table=[0.0,0.0],
    startTime=100,
    offset={1.9e7})
                  annotation (Placement(transformation(extent={{-100,-16},{-80,4}})));
  Modelica.Blocks.Sources.Ramp mass_flow(
    startTime=500,
    duration=20,
    height=0,
    offset=280) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,40})));

  Modelica.Blocks.Sources.Ramp T_wall(
    startTime=1000,
    duration=200,
    height=300,
    offset=573) annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-90,30})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature[tube.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-10,30})));
  Utilities.Blocks.RealInputMultiplyer realInputMultiplyer(N=tube.N_cv) annotation (Placement(transformation(extent={{-57,20.5},{-43,39.5}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    diameter_i=tube.diameter_i,
    diameter_o=tube.diameter_i + 0.01,
    T_start=573*ones(tube.N_cv),
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    stateLocation=2,
    N_tubes=tube.N_tubes,
    initOption=213) annotation (Placement(transformation(extent={{4,13},{16,27}})));

  Modelica.Blocks.Sources.Step inlet_enthalpy(
    startTime=2000,
    height=0,
    offset=1.4e6) annotation (Placement(transformation(
        extent={{-9,-9.5},{9,9.5}},
        rotation=0,
        origin={50,-30})));

equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{72.98,6},{62,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[1], mass_flow.y) annotation (Line(
      points={{86,6},{94.5,6},{94.5,40},{61,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube.inlet, massFlowSource.steam_a) annotation (Line(
      points={{27,0},{40,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, tube.outlet) annotation (Line(
      points={{-30,-6.66134e-16},{-17,-6.66134e-16},{-17,0},{-7,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_wall.y, realInputMultiplyer.Signal) annotation (Line(
      points={{-78.45,30},{-58.26,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature.T) annotation (Line(
      points={{-42.3,29.9525},{-21.75,30},{-17.2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thinWall.outerPhase) annotation (Line(
      points={{-4,30},{10,30},{10,27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube.heat) annotation (Line(
      points={{10,13},{10,5.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_enthalpy.y) annotation (Line(
      points={{62,0},{65.55,0},{65.55,-30},{59.9,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outlet_pressure.y[1], massFlowSink.p) annotation (Line(points={{-79,-6},{-50,-6}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,120}}), graphics={Text(
          extent={{-98,112},{100,72}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
test the L4 advanced  pipe at evaporation scenario
______________________________________________________________________________________________
"),                                               Text(
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
end Test_Pipe_L4_Advanced;
