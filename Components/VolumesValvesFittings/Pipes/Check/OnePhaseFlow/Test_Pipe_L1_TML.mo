within ClaRa.Components.VolumesValvesFittings.Pipes.Check.OnePhaseFlow;
model Test_Pipe_L1_TML
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
        rotation=180,
        origin={73,-54})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=1000) annotation (Placement(transformation(extent={{60,-69},{40,-49}})));
  inner SimCenter simCenter(
    redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    useHomotopy=false,
    useClaRaDelay=true,
    contributeToCycleSummary=false) annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  PipeFlowVLE_L1_TML tube(
    z_in=0,
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    z_out=0,
    length=10000,
    N_cv=10,
    useConstantMediaData=true,
    Delta_p_nom=100000) annotation (Placement(transformation(extent={{14,-69},{-6,-49}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    h_const=100e3,
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=3e5) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-44,-59})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Modelica.Blocks.Sources.Step inlet_pressure(
    startTime=100,
    offset=10e5,
    height=1e4)
    annotation (Placement(transformation(extent={{-100,-75},{-80,-55}})));
  Modelica.Blocks.Sources.Ramp mass_flow_1(
    duration=1,
    height=10,
    offset=100,
    startTime=500) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-10})));

  Modelica.Blocks.Sources.Ramp T_wall(
    duration=4,
    startTime=1000,
    offset=293.15,
    height=20)  annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-89.5,-22.5})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature[tube.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-10,-23})));
  Utilities.Blocks.RealInputMultiplyer realInputMultiplyer(N=tube.N_cv) annotation (Placement(transformation(extent={{-46,-32},{-32,-13}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    T_start=320*ones(tube.N_cv),
    stateLocation=1,
    N_ax=tube.N_cv,
    initOption=213) annotation (Placement(transformation(extent={{-2,-49},{10,-35}})));
  Modelica.Blocks.Sources.Ramp mass_flow_2(
    offset=100,
    startTime=1500,
    height=-210,
    duration=1)     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-10})));

  Modelica.Blocks.Sources.Step inlet_pressure1(
    offset=200e3,
    startTime=2000,
    height=20e3)    annotation (Placement(transformation(
        extent={{9,-9.5},{-9,9.5}},
        rotation=0,
        origin={91,-89.5})));

equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{65.98,-54},{64,-54},{62,-53}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSink.p, inlet_pressure.y) annotation (Line(
      points={{-54,-65},{-79,-65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[1], mass_flow_1.y) annotation (Line(
      points={{79,-56.1},{79,-32},{69,-32},{69,-10},{61,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube.inlet, massFlowSource.steam_a) annotation (Line(
      points={{14,-59},{40,-59}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, tube.outlet) annotation (Line(
      points={{-34,-59},{-6,-59}},
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
      points={{-4,-23},{4,-23},{4,-35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube.heat) annotation (Line(
      points={{4,-49},{4,-51}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mass_flow_2.y, multiSum.u[2]) annotation (Line(
      points={{79,-10},{79,-51.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_pressure1.y) annotation (Line(
      points={{62,-59},{66,-59},{66,-89.5},{81.1,-89.5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{
            100,120}}), graphics={
        Text(
          extent={{-100,112},{98,72}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________
PURPOSE:
test the transmission line pipe in a various number of steps concerning mass flow rate heat flow rate 
and inlet enthalpy to evaluate the numerical robustness and to check for physically meaningful behaviour
______________________________________________________________________________________________
",        fontSize=10),
        Text(
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
",        fontSize=10),
        Text(
          extent={{-100,58},{100,16}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: - in order to visualise short time beahviour of certain quantities, such as pressure  in  variable step solvers such as DASSL,
                  the number of intervals has to be increased in the simulation setup,  such that the interval length is similar to the
                  time scale to be displayed. This is no longer the case, if other models are involved, causing the solver tgo refine its step size. 
                - notice the slight overshoot of outlet temperature around t=1200 s (compare to finite volume models), this is due to the use
                  of spatially averaged media data. Decrease tube-->Expert Settings -->Transmission Line Settings --> f_ps to suppress this
                  effect. Increase f_ps if the media properties averaging shall be more rapid.
                - notice that the TML model is not capable to show a pressure increase at the time, when the wall is heated up. This is due to the
                  use of averaged media data.
 ______________________________________________________________________________________________________________
",        fontSize=8),
        Text(
          extent={{-100,20},{-84,2}},
          lineColor={255,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="______________________________________________________________________________________
- In order to use the Dymola built in delay function,set 
  simCenter--> Expert Settings --> Delay Function --> useClaRaDelay==false
______________________________________________________________________________________")}),
    experiment(
      StopTime=3000,
      __Dymola_NumberOfIntervals=10000,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(
      derivatives=false,
      equdistant=false,
      events=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true)));
end Test_Pipe_L1_TML;
