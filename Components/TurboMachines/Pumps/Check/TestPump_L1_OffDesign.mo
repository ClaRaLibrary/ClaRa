within ClaRa.Components.TurboMachines.Pumps.Check;
model TestPump_L1_OffDesign "Running the  L1 pump in off design, including reverse flow and switch off"

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;

  inner ClaRa.SimCenter simCenter(redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1, showExpertSummary=true)
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_affinity pump(
    steadyStateTorque=false,
    Delta_p_max=100e5,
    V_flow_max=2600/3600,
    rpm_nom=4600,
    showExpertSummary=true,
    J=1,
    rpm_fixed=4600,
    useMechanicalPort=true,
    redeclare model Hydraulics = ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.MetaStable_Q124 (
        exp_hyd=(0.5),
        drp_exp=(0),
        Delta_p_eps=(50)),
    redeclare model Energetics = ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.EfficiencyCurves_Q1 (
        eta_hyd_nom=(0.82),
        exp_rpm=(0.15),
        V_flow_opt_=(0.6),
        exp_flow=(2.8),
        Delta_p_eps=(50),
        V_flow_leak=(0.00002),
        stabiliseDelta_p=(false),
        Tau_stab=(1e-2))) annotation (Placement(transformation(extent={{-30,-150},{-10,-130}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi source(T_const=463.15, p_const=12e5) annotation (Placement(transformation(extent={{-78,-150},{-58,-130}})));
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
    x1=pump.summary.outline.P_shaft/1e6)
                     annotation (Placement(transformation(extent={{-42,-170},{18,-154}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(     initType=Modelica.Blocks.Types.Init.SteadyState,
    k=2*Modelica.Constants.pi/60,
    T=0.0001)
    annotation (Placement(transformation(extent={{-118,-112},{-98,-92}})));

  Modelica.Blocks.Sources.TimeTable
                               rpmRamp(
    offset=0,
    startTime=0,
    table=[0,5500; 100,5500; 120,5200; 130,5200; 150,4800; 180,4800; 200,5500; 330,5500; 350,0; 360,0; 380,3000; 400,5000; 450,5000; 451,0; 480,0; 500,5000])
    annotation (Placement(transformation(extent={{-150,-112},{-130,-92}})));
  Modelica.Blocks.Sources.TimeTable Delta_pRamp(
    startTime=0,
    offset=sink.p_const,
    table=[0,-5e5; 30,0; 60,0; 90,40e5; 250,40e5; 280,75e5; 300,75e5; 310,0; 330,0; 360,-5e5; 390,-5e5; 400,75e5; 500,75e5])
    annotation (Placement(transformation(extent={{126,-144},{106,-124}})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{0,-134},{40,-120}})));
equation
  connect(source.steam_a, pump.inlet)                     annotation (Line(
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
  connect(Delta_pRamp.y, sink.p) annotation (Line(
      points={{105,-134},{60,-134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inertia1.flange_b, pump.shaft) annotation (Line(
      points={{-28,-102},{-20,-102},{-20,-130.1}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(rpmRamp.y, firstOrder.u) annotation (Line(
      points={{-129,-102},{-120,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.outlet, sink.steam_a) annotation (Line(
      points={{-10,-140},{40,-140}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump.eye, quadruple.eye) annotation (Line(points={{-9,-146},{-4,-146},{-4,-127},{0,-127}}, color={190,190,190}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-220},{160,40}}),
                      graphics={
                       Text(
          extent={{-160,40},{160,-20}},
          lineColor={0,128,0},
          fontSize=10,
          horizontalAlignment=TextAlignment.Left,
          textString="
______________________________________
Purpose: Illustrate the capacities of the instantiated pump to run under non-design conditions, i.e. shut off, reverse flow due to insufficient shaft power, 
______________________________________
Look at: summary: V_flow, P_shaft, P_hyd, m_flow, Delta_p, rpm
______________________________________
Note: Running the pump in turbine mode is not featured, i.e. the shaft power becomes zero for P_hyd<0
The behaviour of the pump way be affected by the (electric) motor or driving turbine and should be modelled appropriately when tackling simulation of off-design operation
______________________________________")}),
    experiment(
      StopTime=500,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end TestPump_L1_OffDesign;
