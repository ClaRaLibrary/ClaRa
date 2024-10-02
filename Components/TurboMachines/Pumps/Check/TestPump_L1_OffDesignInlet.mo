within ClaRa.Components.TurboMachines.Pumps.Check;
model TestPump_L1_OffDesignInlet "Running the  L1 pump in off design inlet conditions"
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;

  inner ClaRa.SimCenter simCenter(                                                              showExpertSummary=true, redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1)
                                                                                                                            annotation (Placement(transformation(extent={{-160,-200},{-120,-180}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_affinity pump2(
    useHead=true,
    Head_max=1000,
    steadyStateTorque=false,
    showExpertSummary=true,
    J=1,
    rpm_fixed=4600,
    useMechanicalPort=true,
    V_flow_max=1,
    Delta_p_max=100e5,
    redeclare model Hydraulics = ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.MetaStable_Q124 (
        exp_hyd=(0.5),
        drp_exp=(0),
        Delta_p_eps=(100)),
    rpm_nom=5500,
    redeclare model Energetics = ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.EfficiencyCurves_Q1 (
        eta_hyd_nom=(0.82),
        exp_rpm=(0.15),
        V_flow_opt_=(0.6),
        exp_flow=(2.8),
        Delta_p_eps=(100),
        V_flow_leak=(0.00002),
        stabiliseDelta_p=(false),
        Tau_stab=(1e-2))) annotation (Placement(transformation(extent={{-30,-150},{-10,-130}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi source(variable_T=true,p_const=25e5) annotation (Placement(transformation(extent={{-78,-150},{-58,-130}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi sink(
    p_const=12e5,
    h_const=9e4,
    variable_p=true) annotation (Placement(transformation(extent={{60,-150},{40,-130}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=1000)
    annotation (Placement(transformation(extent={{-48,-112},{-28,-92}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1(exact=false)
    annotation (Placement(transformation(extent={{-78,-112},{-58,-92}})));
  ClaRa.Visualisation.DynDisplay dynDisplay(
    varname="Mechanic Power",
    unit="MW",
    decimalSpaces=3,
    x1=pump2.summary.outline.P_shaft/1e6) annotation (Placement(transformation(extent={{-42,-170},{18,-154}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(     initType=Modelica.Blocks.Types.Init.SteadyState,
    k=2*Modelica.Constants.pi/60,
    T=0.0001)
    annotation (Placement(transformation(extent={{-118,-112},{-98,-92}})));

  Modelica.Blocks.Sources.TimeTable
                               rpmRamp(table=[0,5500; 100,5500])
    annotation (Placement(transformation(extent={{-150,-112},{-130,-92}})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{-6,-154},{34,-140}})));
  Modelica.Blocks.Sources.TimeTable Delta_p_out_Ramp(
    startTime=0,
    offset=sink.p_const,
    table=[0,100e5; 100,100e5]) annotation (Placement(transformation(extent={{126,-144},{106,-124}})));
  Modelica.Blocks.Sources.TimeTable Delta_T_in_Ramp(
    startTime=0,
    offset=source.T_const,
    table=[0,0; 100,100; 200,100; 300,0; 500,0]) annotation (Placement(transformation(extent={{-124,-150},{-104,-130}})));
equation
  connect(source.steam_a, pump2.inlet) annotation (Line(
      points={{-58,-140},{-30,-140}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inertia1.flange_a, speed1.flange)
                                           annotation (Line(
      points={{-48,-102},{-58,-102}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(firstOrder.y, speed1.w_ref) annotation (Line(
      points={{-97,-102},{-80,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Delta_p_out_Ramp.y, sink.p) annotation (Line(
      points={{105,-134},{60,-134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inertia1.flange_b, pump2.shaft) annotation (Line(
      points={{-28,-102},{-20,-102},{-20,-130.1}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(rpmRamp.y, firstOrder.u) annotation (Line(
      points={{-129,-102},{-120,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump2.outlet, sink.steam_a) annotation (Line(
      points={{-10,-140},{40,-140}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump2.eye, quadruple.eye) annotation (Line(points={{-9,-146},{-4,-146},{-4,-147},{-6,-147}}, color={190,190,190}));
  connect(Delta_T_in_Ramp.y, source.T) annotation (Line(points={{-103,-140},{-78,-140}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-220},{160,40}}),
                      graphics={
                       Text(
          extent={{-156,38},{158,12}},
          lineColor={0,128,0},
          fontSize=10,
          horizontalAlignment=TextAlignment.Left,
          textString="
______________________________________
Purpose: Illustrate the change of dp vs. V_flow characteristic under non-design inlet conditions, i.e. V_flow and dp is changing due to the change of inlet density, 
______________________________________
Look at: summary: V_flow, P_shaft, P_hyd, m_flow
______________________________________
")}),
    experiment(StopTime=500, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end TestPump_L1_OffDesignInlet;
