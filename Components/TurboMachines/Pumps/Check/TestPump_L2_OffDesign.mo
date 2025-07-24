within ClaRa.Components.TurboMachines.Pumps.Check;
model TestPump_L2_OffDesign "Running the  L2 pump in off design, including reverse flow and zero mass flow through valve"
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

  inner ClaRa.SimCenter simCenter(redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1, showExpertSummary=true)
    annotation (Placement(transformation(extent={{-160,-160},{-120,-140}})));
  Modelica.Blocks.Sources.TimeTable
                               ramp1(
    startTime=0,
    table=[0,-1000/60*2*3.14; 50,-1000/60*2*3.14; 51,0; 100,0; 101,500/60*2*
        3.14; 150,500/60*2*3.14],
    offset=2*Modelica.Constants.pi*4600/60)
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Modelica.Blocks.Sources.TimeTable p_out_n1(
    startTime=0,
    offset=10e5,
    table=[0,3e5; 120,3e5; 130,10e5; 150,10e5; 160,-2e5; 180,-2e5; 190,2e5; 200,2e5])
    annotation (Placement(transformation(extent={{104,-124},{84,-104}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L2_affinity pump_3(
    steadyStateTorque=false,
    rpm_nom=4600,
    J=1,
    rpm_fixed=4600,
    V_flow_max=2600/3600,
    Delta_p_max=2e5,
    V_flow_eps=pump_3.V_flow_max/50,
    redeclare model Energetics = ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.EfficiencyCurves_Q1 (
        eta_hyd_nom=(0.82),
        V_flow_opt_=(0.6),
        exp_rpm=(0.15),
        exp_flow=(2.8),
        V_flow_leak=(0.00002),
        Delta_p_eps=(200),
        stabiliseDelta_p=false,
        Tau_stab=0.1),
    m_flow_nom=1,
    volume_fluid=0.02,
    useMechanicalPort=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    h_start=150e3,
    p_start(displayUnit="Pa") = 12e5,
    redeclare model Hydraulics = ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.MetaStable_Q124 (
        exp_hyd=(0.5),
        drp_exp=(0),
        Delta_p_eps=(200)),
    initOption=1) annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG4(p_const(displayUnit="bar") = 1200000)
                                                                                          annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG5(
    p_const=12e5,
    h_const=9e4,
    variable_p=true)
                 annotation (Placement(transformation(extent={{60,-130},{40,-110}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=1000)
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1(exact=false)
    annotation (Placement(transformation(extent={{-88,-90},{-68,-70}})));
  ClaRa.Visualisation.DynDisplay dynDisplay(
    varname="Mechanic Power",
    unit="W",
    x1=pump_3.P_shaft) annotation (Placement(transformation(extent={{-82,-152},{-22,-136}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T= 10, initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(
    checkValve=false,
    openingInputIsActive=true,
    redeclare model PressureLoss = VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (
        paraOption=2,
        m_flow_nom=1000,
        Delta_p_nom=1000)) annotation (Placement(transformation(extent={{0,-126},{20,-114}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    offset=1,
    duration=20,
    startTime=200)
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));

  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{-18,-142},{20,-132}})));

equation
  connect(pressureSink_XRG4.steam_a,pump_3. inlet)        annotation (Line(
      points={{-60,-120},{-40,-120}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inertia1.flange_a, speed1.flange)
                                           annotation (Line(
      points={{-60,-80},{-68,-80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(ramp1.y, firstOrder.u) annotation (Line(
      points={{-129,-80},{-122,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, speed1.w_ref) annotation (Line(
      points={{-99,-80},{-90,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valveVLE_L1_1.outlet, pressureSink_XRG5.steam_a) annotation (Line(
      points={{20,-120},{40,-120}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, valveVLE_L1_1.opening_in) annotation (Line(
      points={{1,-90},{10,-90},{10,-111}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump_3.outlet, valveVLE_L1_1.inlet) annotation (Line(
      points={{-20,-120},{0,-120}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(inertia1.flange_b, pump_3.shaft) annotation (Line(
      points={{-40,-80},{-30,-80},{-30,-110.1}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pump_3.eye, quadruple.eye) annotation (Line(points={{-19,-126},{-18,-126},{-18,-137}}, color={190,190,190}));
  connect(pressureSink_XRG5.p, p_out_n1.y) annotation (Line(points={{60,-114},{78,-114},{83,-114}},           color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{160,40}}),
                      graphics={Text(
          extent={{-160,39},{160,-40}},
          lineColor={115,150,0},
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="
______________________________________
Purpose: Illustrate the capacities of the instantiated pump to run under non-design conditions, i.e. shut off, reverse flow due to insufficient shaft power as well as running against a closed control valve (failure)
______________________________________
Look at: summary: V_flow, P_shaft, P_hyd, m_flow, Delta_p, rpm
______________________________________
Note: 
- Running the pump in turbine mode is not featured, i.e. the shaft power becomes zero for P_hyd<0
- The behaviour of the pump way be affected by the (electric) motor or driving turbine and should be modelled appropriately when tackling simulation of off-design operation
- When running the pump with a closed valve downstream chattering occurs (using dassl as solver). This is currently unsolved problem which improves when using different solvers like radau
______________________________________
    
"), Rectangle(
          extent={{-160,40},{160,-160}},
          lineColor={115,150,0},
          lineThickness=0.5)}),
    experiment(StopTime=250, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false, events=false),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end TestPump_L2_OffDesign;
