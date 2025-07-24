within ClaRa.Components.VolumesValvesFittings.Pipes.Check.ThickWallScenarios;
model Test_Pipe_L1_TML_insulatedWall
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
        origin={79,-54})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=1000) annotation (Placement(transformation(extent={{60,-69},{40,-49}})));
  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1, useHomotopy=
        false) annotation (Placement(transformation(extent={{-80,-132},{-60,-112}})));
  PipeFlowVLE_L1_TML tube(
    z_in=0,
    z_out=0,
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    length=50,
    m_flow_nom=100,
    diameter_i=0.5,
    alpha=1000,
    N_cv=1,
    f_ps=0.01,
    adiabaticWall=false,
    useHomotopy=true,
    Delta_p_nom=10000) annotation (Placement(transformation(extent={{14,-69},{-6,-49}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    h_const=100e3,
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=100000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-46,-59})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,-132},{80,-112}})));
  Modelica.Blocks.Sources.Step inlet_pressure(
    offset=1e5,
    startTime=100,
    height=1e4)
    annotation (Placement(transformation(extent={{-100,-75},{-80,-55}})));
  Modelica.Blocks.Sources.Ramp mass_flow_1(
    duration=1,
    height=10,
    offset=100,
    startTime=500) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,4})));

  Modelica.Blocks.Sources.Ramp T_wall(
    duration=4,
    startTime=1000,
    offset=293.15,
    height=200) annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-89.5,-22.5})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    T_start=293*ones(tube.N_cv),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(extent={{-2,-49},{10,-35}})));
  Modelica.Blocks.Sources.Ramp mass_flow_2(
    duration=1,
    offset=100,
    height=-50,
    startTime=1500) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-28})));

  Modelica.Blocks.Sources.Step inlet_pressure1(
    height=20e3,
    offset=200e3,
    startTime=2000) annotation (Placement(transformation(
        extent={{-9,-9.5},{9,9.5}},
        rotation=0,
        origin={51,-89.5})));

equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{71.98,-54},{64,-53},{62,-53}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSink.p, inlet_pressure.y) annotation (Line(
      points={{-56,-65},{-79,-65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[1], mass_flow_1.y) annotation (Line(
      points={{85,-56.1},{85,-54},{88,-54},{88,4},{61,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube.inlet, massFlowSource.steam_a) annotation (Line(
      points={{14,-59},{40,-59}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, tube.outlet) annotation (Line(
      points={{-36,-59},{-6,-59}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube.heat) annotation (Line(
      points={{4,-49},{4,-51}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mass_flow_2.y, multiSum.u[2]) annotation (Line(
      points={{61,-28},{88,-28},{88,-54},{85,-54},{85,-51.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_pressure1.y) annotation (Line(
      points={{62,-59},{68,-59},{68,-89.5},{60.9,-89.5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-140},{100,
            120}}), graphics={
        Text(
          extent={{-100,112},{98,72}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________
PURPOSE:
test the transmission line pipe with an attached wall segment 
______________________________________________________________________________________________
",        fontSize=10),
        Text(
          extent={{-100,90},{98,50}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________
Scenario:  1) pressure step at inlet (at t=100s 1e5 Pa --> 1.1e5 Pa 
                2) increase of mass flow (at t = 500s 200kg/s --> 210 kg/s)
                3) increase of wall temperature (at t=1000s 293.15K --> 493.15 K)
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
",        fontSize=8)}),
    experiment(
      StopTime=3000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true)));
end Test_Pipe_L1_TML_insulatedWall;
