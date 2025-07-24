within ClaRa.Components.VolumesValvesFittings.Pipes.Check.OnePhaseFlow;
model Test_Pipe_L1_TML_LongDistanceAndGravitationalPressureDrop
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
        rotation=270,
        origin={289,78})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=1000) annotation (Placement(transformation(extent={{260,30},{240,50}})));
  inner SimCenter simCenter(
    redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    useHomotopy=false,
    useClaRaDelay=true,
    p_amb=1000000) annotation (Placement(transformation(extent={{280,180},{320,200}})));
  PipeFlowVLE_L1_TML tube7(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=150,
    z_out=150,
    useConstantMediaData=true) annotation (Placement(transformation(extent={{30,125},{0,135}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=true,
    h_const=100e3,
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=5e4) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,130})));
  Modelica.Blocks.Sources.Step outlet_pressure(
    offset=10e5,
    height=5e5,
    startTime=1000) annotation (Placement(transformation(extent={{-100,40},{-78,60}})));
  Modelica.Blocks.Sources.Ramp mass_flow_1(
    duration=1,
    height=10,
    offset=0,
    startTime=2500)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={270,130})));

  Modelica.Blocks.Sources.Ramp T_wall(
    height=20,
    duration=3600,
    startTime=300000,
    offset=320.378)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,190})));
  Utilities.Blocks.RealInputMultiplyer realInputMultiplyer(N=tube3.N_cv) annotation (Placement(transformation(extent={{-60,180},{-40,200}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube7.length,
    Delta_x=tube7.Delta_x,
    N_ax=tube7.N_cv,
    stateLocation=1,
    T_start=320.378*ones(tube7.N_cv),
    initOption=203) annotation (Placement(transformation(extent={{1,139},{29,150}})));
  Modelica.Blocks.Sources.Ramp mass_flow_2(
    offset=100,
    duration=1,
    height=0,
    startTime=2500) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={310,130})));

  Modelica.Blocks.Sources.Step inlet_pressure1(
    offset=200e3,
    height=20e3,
    startTime=120000)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={310,-30})));

  PipeFlowVLE_L1_TML tube3(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=250,
    z_out=250,
    useConstantMediaData=true,
    alpha=10) annotation (Placement(transformation(
        extent={{15,-6},{-15,6}},
        rotation=0,
        origin={145,158})));
  PipeFlowVLE_L1_TML tube5(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=100,
    z_out=100,
    useConstantMediaData=true) annotation (Placement(transformation(extent={{100,34},{68,46}})));
  PipeFlowVLE_L1_TML tube4(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=250,
    z_out=100,
    useConstantMediaData=true) annotation (Placement(transformation(
        extent={{15,6},{-15,-6}},
        rotation=90,
        origin={122,105})));
  PipeFlowVLE_L1_TML tube6(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=100,
    z_out=150,
    useConstantMediaData=true)
               annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=270,
        origin={47,106})));
  PipeFlowVLE_L1_TML tube2(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=0,
    z_out=250,
    useConstantMediaData=true)
               annotation (Placement(transformation(
        extent={{-16,7},{16,-7}},
        rotation=90,
        origin={169,104})));
  PipeFlowVLE_L1_TML tube1(
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    alpha=1000,
    f_ps=0.01,
    N_cv=10,
    length=10000,
    Delta_p_nom=1/7*1e5,
    z_in=0,
    z_out=0,
    useConstantMediaData=true)
             annotation (Placement(transformation(
        extent={{15,-5},{-15,5}},
        rotation=0,
        origin={205,40})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall1(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube7.length,
    Delta_x=tube7.Delta_x,
    N_ax=tube7.N_cv,
    stateLocation=1,
    T_start=320.378*ones(tube7.N_cv),
    initOption=203) annotation (Placement(transformation(
        extent={{-13.9998,5},{14.0005,-4.99999}},
        rotation=90,
        origin={61,106})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall2(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube7.length,
    Delta_x=tube7.Delta_x,
    N_ax=tube7.N_cv,
    stateLocation=1,
    T_start=320.378*ones(tube7.N_cv),
    initOption=203) annotation (Placement(transformation(
        extent={{-15,-5.50005},{15,5.50008}},
        rotation=270,
        origin={136.5,105})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall3(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube7.length,
    Delta_x=tube7.Delta_x,
    N_ax=tube7.N_cv,
    stateLocation=1,
    T_start=320.378*ones(tube7.N_cv),
    initOption=203) annotation (Placement(transformation(
        extent={{-15.5,-5.50001},{15.5,5.50003}},
        rotation=90,
        origin={186.5,105.5})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall4(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube7.length,
    Delta_x=tube7.Delta_x,
    N_ax=tube7.N_cv,
    stateLocation=1,
    T_start=320.378*ones(tube7.N_cv),
    initOption=203) annotation (Placement(transformation(extent={{70,53},{102,64}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall5(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube7.length,
    Delta_x=tube7.Delta_x,
    N_ax=tube7.N_cv,
    stateLocation=1,
    T_start=linspace(
        320.378,
        320.378,
        tube7.N_cv),
    initOption=203) annotation (Placement(transformation(extent={{130,168},{160,178}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall6(
    diameter_o=0.55,
    diameter_i=0.5,
    length=tube7.length,
    Delta_x=tube7.Delta_x,
    N_ax=tube7.N_cv,
    stateLocation=1,
    T_start=320.378*ones(tube7.N_cv),
    initOption=203) annotation (Placement(transformation(extent={{191,53},{219,64}})));
  PipeFlowVLE_L1_TML tube_merged(
    Delta_V_flow_out(start=0),
    z_in=0,
    showExpertSummary=true,
    kappa=1.25,
    showData=true,
    m_flow_nom=100,
    diameter_i=0.5,
    adiabaticWall=false,
    f_ps=0.01,
    length=70000,
    N_cv=70,
    z_out=150,
    Delta_p_nom=100000,
    alpha=10,
    useConstantMediaData=true) annotation (Placement(transformation(extent={{82,-66},{50,-54}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink1(
    variable_p=true,
    h_const=100e3,
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=5e4) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-26,-60})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource1(
    m_flow_const=0.1,
    variable_m_flow=true,
    h_const=200e3,
    m_flow_nom=0,
    variable_h=true,
    p_nom=1000) annotation (Placement(transformation(extent={{260,-70},{240,-50}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall7(
    diameter_o=0.55,
    diameter_i=0.5,
    stateLocation=1,
    N_ax=tube_merged.N_cv,
    length=tube_merged.length,
    Delta_x=tube_merged.Delta_x,
    T_start=320.378*ones(tube_merged.N_cv),
    initOption=203) annotation (Placement(transformation(extent={{50,-46},{82,-34}})));
  Modelica.Blocks.Math.MultiSum multiSum1(
                                         nu=2) annotation (Placement(
        transformation(
        extent={{4.5,-5},{-4.5,5}},
        rotation=180,
        origin={-58.5,81})));
  Modelica.Blocks.Sources.Step outlet_pressure2(
    height=-5e5,
    offset=0,
    startTime=1002) annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1[tube3.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={126,190})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature2[tube3.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={38,-29})));
equation
  connect(multiSum.y, massFlowSource.m_flow) annotation (Line(
      points={{289,70.98},{289,46},{262,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[1], mass_flow_1.y) annotation (Line(
      points={{291.1,84},{291.1,130},{281,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, tube7.outlet) annotation (Line(
      points={{-20,130},{0,130}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_wall.y, realInputMultiplyer.Signal) annotation (Line(
      points={{-79,190},{-61.8,190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube7.heat) annotation (Line(
      points={{15,139},{15,134}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mass_flow_2.y, multiSum.u[2]) annotation (Line(
      points={{299,130},{299,84},{286.9,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource.h, inlet_pressure1.y) annotation (Line(
      points={{262,40},{280,40},{280,-30},{299,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube7.inlet, tube6.outlet) annotation (Line(
      points={{30,130},{47,130},{47,120}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube6.inlet, tube5.outlet) annotation (Line(
      points={{47,92},{47,40},{68,40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube5.inlet, tube4.outlet) annotation (Line(
      points={{100,40},{122,40},{122,90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube4.inlet, tube3.outlet) annotation (Line(
      points={{122,120},{122,158},{130,158}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube3.inlet, tube2.outlet) annotation (Line(
      points={{160,158},{169,158},{169,120}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube2.inlet,tube1. outlet) annotation (Line(
      points={{169,88},{169,40},{190,40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube1.inlet, massFlowSource.steam_a) annotation (Line(
      points={{220,40},{240,40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall1.innerPhase,tube6. heat) annotation (Line(
      points={{56,106},{54,106},{54,106},{51,106}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall4.innerPhase, tube5.heat) annotation (Line(
      points={{86,53},{86,44.8},{84,44.8}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube2.heat, thinWall3.outerPhase) annotation (Line(
      points={{174.6,104},{178,104},{178,105.5},{181,105.5}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall6.innerPhase,tube1. heat) annotation (Line(
      points={{205,53},{205,44}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink1.steam_a, tube_merged.outlet) annotation (Line(
      points={{-16,-60},{50,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tube_merged.inlet, massFlowSource1.steam_a) annotation (Line(
      points={{82,-60},{240,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inlet_pressure1.y, massFlowSource1.h) annotation (Line(
      points={{299,-30},{294,-30},{294,-60},{262,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, massFlowSource1.m_flow) annotation (Line(
      points={{289,70.98},{289,-54},{262,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thinWall7.innerPhase, tube_merged.heat) annotation (Line(
      points={{66,-46},{66,-55.2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outlet_pressure.y, multiSum1.u[1]) annotation (Line(
      points={{-76.9,50},{-76,50},{-76,50},{-72,50},{-72,79.25},{-68,79.25},{-63,79.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outlet_pressure2.y, multiSum1.u[2]) annotation (Line(
      points={{-79,110},{-73,110},{-73,82.75},{-63,82.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum1.y, massFlowSink.p) annotation (Line(
      points={{-53.235,81},{-44,81},{-44,124},{-40,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum1.y, massFlowSink1.p) annotation (Line(
      points={{-53.235,81},{-44,81},{-44,-66},{-36,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tube4.heat, thinWall2.innerPhase) annotation (Line(
      points={{126.8,105},{131,105}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall5.innerPhase, tube3.heat) annotation (Line(
      points={{145,168},{145,162.8}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, thinWall5.outerPhase) annotation (Line(
      points={{132,190},{145,190},{145,178}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[1].port, thinWall7.outerPhase[21]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[2].port, thinWall7.outerPhase[22]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[3].port, thinWall7.outerPhase[23]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[4].port, thinWall7.outerPhase[24]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[5].port, thinWall7.outerPhase[25]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[6].port, thinWall7.outerPhase[26]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[7].port, thinWall7.outerPhase[27]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[8].port, thinWall7.outerPhase[28]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[9].port, thinWall7.outerPhase[29]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2[10].port, thinWall7.outerPhase[30]) annotation (Line(
      points={{44,-29},{66,-29},{66,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature1.T) annotation (Line(
      points={{-39,189.95},{72,189.95},{72,190},{118.8,190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature2.T) annotation (Line(
      points={{-39,189.95},{-6,189.95},{-6,-29},{30.8,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{320,200}}),
                        graphics={Rectangle(
          extent={{-100,200},{320,-120}},
          lineColor={115,150,0},
          lineThickness=0.5), Text(
          extent={{-98,-62},{246,-126}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          textString="
This tester gives a number of step-like changes to the boundary conditions of a very long (70 km) liquid connection piping.
The upper set of pipes follow a certain height curve of the geographic topology it is related to. The lower, merged piping can only reflect the overall height difference
between inlet and outlet of the system. However, since the overall length is the same, the temperature development at the outlet is very similar.

- Pressure shock at time = 1000 sand time = 1002 s
- Temperature step at pipe inlet at time = 120000 s 
- Mass flow ramp at time 0 2500 s
- Ambient temperature ramp at time = 300000 s")}),
    experiment(
      StopTime=500000,
      __Dymola_NumberOfIntervals=50000,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(
      derivatives=false,
      equidistant=false,
      events=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true)));
end Test_Pipe_L1_TML_LongDistanceAndGravitationalPressureDrop;
