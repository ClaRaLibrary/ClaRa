within ClaRa.Components.VolumesValvesFittings.Pipes.Check.MassDefect;
model Test_Pipe_L2_Simple
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  Modelica.Blocks.Sources.Trapezoid MassFlow(
    offset=0.202/3.6,
    width=100,
    period=200,
    rising=40,
    falling=40,
    amplitude=0.202/3.6*2)
    annotation (Placement(transformation(extent={{-94,-26},{-74,-6}})));
  BoundaryConditions.BoundaryVLE_hxim_flow
                                  massFlowSink(variable_m_flow=true) annotation (Placement(transformation(extent={{-22,-54},{-2,-34}})));
  BoundaryConditions.BoundaryVLE_hxim_flow steamInlet1(
    h_const=3252e3,
    m_flow_const=+0.202/3.6,
    variable_m_flow=true) annotation (Placement(transformation(extent={{-24,-10},{-4,10}})));
  inner SimCenter simCenter(redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1, redeclare
      TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid2)
    annotation (Placement(transformation(extent={{-80,-72},{-60,-52}})));
  PipeFlowVLE_L2_Simple tubeBundle_L2_Simple(
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    frictionAtOutlet=false,
    initOption=0,
    frictionAtInlet=true)
                  annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={32,-22})));

  BoundaryConditions.PrescribedHeatFlowScalar prescribedHeatFlowScalar
    annotation (Placement(transformation(extent={{64,-32},{44,-12}})));
  Modelica.Blocks.Sources.Ramp heatFlow(
    duration=10,
    offset=0,
    startTime=500,
    height=-1.5e5*1.2)
    annotation (Placement(transformation(extent={{94,-32},{74,-12}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={-42,-38})));
equation
  connect(MassFlow.y, steamInlet1.m_flow) annotation (Line(
      points={{-73,-16},{-66,-16},{-66,6},{-26,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlowScalar.port, tubeBundle_L2_Simple.heat[1])
    annotation (Line(
      points={{44,-22},{36.8,-22}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatFlow.y, prescribedHeatFlowScalar.Q_flow) annotation (Line(
      points={{73,-22},{64,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tubeBundle_L2_Simple.outlet, massFlowSink.steam_a) annotation (Line(
      points={{32,-32},{32,-44},{-2,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(steamInlet1.steam_a, tubeBundle_L2_Simple.inlet) annotation (Line(
      points={{-4,0},{32,0},{32,-12}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gain.y, massFlowSink.m_flow) annotation (Line(
      points={{-37.6,-38},{-24,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlow.y, gain.u) annotation (Line(
      points={{-73,-16},{-66,-16},{-66,-38},{-46.8,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-80},{100,100}},
          preserveAspectRatio=false),
        graphics={                Text(
          extent={{-98,94},{100,54}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________
PURPOSE:
test the simple L2 pipe in a various number of steps concerning mass flow rate and heat flow rate 
to check for mass defect due to major density variation in the case of condensing steam  
______________________________________________________________________________________________
",        fontSize=10),Text(
          extent={{-98,102},{102,82}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- 2013-08-01 //AR"),Text(
          extent={{-98,68},{100,42}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________
Scenario:  1) trapezoid shaped mass flow inlet and outlet while heat flow rate = 0
                 2) increase of heat flow rate (cooling-down) (at t = 500s 0W --> -1.5e5W)
______________________________________________________________________________________________

",        fontSize=10),Text(
          extent={{-98,52},{80,10}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="___________________________________________________________________________________________________________
Remarks: - tube is initialised using NoInit with default values
___________________________________________________________________________________________________________
",        fontSize=8),                            Text(
          extent={{-98,54},{100,28}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________
Look at:  1) inlet and outlet mass flow rate (are equal)
                 2) system mass (is increasing)
______________________________________________________________________________________________

",        fontSize=10)}),Icon(graphics,
                              coordinateSystem(extent={{-100,-80},{100,100}})),
    experiment(StopTime=10000, Tolerance=1e-006),
    __Dymola_experimentSetupOutput);
end Test_Pipe_L2_Simple;
