within ClaRa.Components.VolumesValvesFittings.Fittings.Check;
model Test_MixAndSplit
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

  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_flex flxibleJoin(
    h_nom=1900e3,
    p_nom(displayUnit="Pa") = 5000,
    h_start=1800e3,
    N_ports_in=2,
    m_flow_in_nom={25,100},
    volume=0.05,
    preciseTwoPhase=false,
    showExpertSummary=true,
    initOption=208,
    p_start=3000000) annotation (Placement(transformation(extent={{-60,20},{-80,40}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG(h_const=800e3, p_const=3000000) annotation (Placement(transformation(extent={{20,20},{0,40}})));
  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1)
    annotation (Placement(transformation(extent={{80,158},{100,178}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG2(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=1800e3) annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=200,
    height=200,
    offset=-150,
    startTime=200)
    annotation (Placement(transformation(extent={{-192,-94},{-172,-74}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG1(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=3000e3,
    variable_h=true) annotation (Placement(transformation(extent={{20,50},{0,70}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=100,
    height=200,
    startTime=600,
    offset=-100)
    annotation (Placement(transformation(extent={{88,108},{68,128}})));
  Visualisation.Quadruple quadruple
    annotation (Placement(transformation(extent={{-84,2},{-124,12}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    duration=100,
    startTime=1000,
    height=-2500e3,
    offset=3000e3)
    annotation (Placement(transformation(extent={{90,80},{70,100}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveLinear_1_XRG(redeclare model PressureLoss =
        Valves.Fundamentals.LinearNominalPoint (                                                                                                            Delta_p_nom=100000, m_flow_nom=50)) annotation (Placement(transformation(extent={{-40,24},{-20,36}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_Y(
    m_flow_in_nom={25,100},
    p_nom(displayUnit="Pa") = 5000,
    h_nom=1900e3,
    h_start=1800e3,
    volume=0.05,
    preciseTwoPhase=false,
    p_start=3000000,
    showExpertSummary=true,
    initOption=208,
    redeclare model PressureLossIn1 = Fundamentals.Linear,
    redeclare model PressureLossOut = Fundamentals.Linear)
                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-70,-30})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG3(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=1800e3) annotation (Placement(transformation(extent={{-144,-40},{-124,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG4(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=3000e3,
    variable_h=true) annotation (Placement(transformation(extent={{20,-10},{0,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG5(h_const=800e3, p_const=3000000) annotation (Placement(transformation(extent={{20,-40},{0,-20}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveLinear_1_XRG1(redeclare model PressureLoss =
        Valves.Fundamentals.LinearNominalPoint (                                                                                                             Delta_p_nom=100000, m_flow_nom=50)) annotation (Placement(transformation(extent={{-40,-36},{-20,-24}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG6(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=1800e3) annotation (Placement(transformation(extent={{-146,-100},{-126,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG7(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=3000e3,
    variable_h=true) annotation (Placement(transformation(extent={{20,-70},{0,-50}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSource_XRG8(h_const=800e3, p_const=3000000) annotation (Placement(transformation(extent={{20,-100},{0,-80}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveLinear_1_XRG2(redeclare model PressureLoss =
        Valves.Fundamentals.LinearNominalPoint (                                                                                                             Delta_p_nom=100000, m_flow_nom=50)) annotation (Placement(transformation(extent={{-40,-96},{-20,-84}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_Y(
    p_nom(displayUnit="Pa") = 5000,
    h_nom=1900e3,
    h_start=1800e3,
    volume=0.05,
    m_flow_out_nom={25,100},
    preciseTwoPhase=false,
    p_start=3000000,
    showExpertSummary=true,
    initOption=208,
    redeclare model PressureLossIn = Fundamentals.Linear,
    redeclare model PressureLossOut2 = Fundamentals.Linear)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,-90})));
  Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-84,-84},{-124,-74}})));
  Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{-84,-72},{-124,-62}})));
  Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{-82,-43},{-122,-33}})));
  JoinVLE_L3_Y                                                 join_Y1(
    p_nom(displayUnit="Pa") = 5000,
    h_start=1800e3,
    volume=0.05,
    p_start=3000000,
    showExpertSummary=true,
    initOption=211,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3)
                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-62,-148})));
  BoundaryConditions.BoundaryVLE_hxim_flow                  massFlowSource_XRG9(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=1800e3) annotation (Placement(transformation(extent={{-144,-158},{-124,-138}})));
  BoundaryConditions.BoundaryVLE_hxim_flow                  massFlowSource_XRG10(
    m_flow_const=43.551,
    variable_m_flow=true,
    h_const=3000e3,
    variable_h=true) annotation (Placement(transformation(extent={{20,-128},{0,-108}})));
  BoundaryConditions.BoundaryVLE_phxi                  massFlowSource_XRG11(h_const=800e3, p_const=3000000)
                                                                                                           annotation (Placement(transformation(extent={{20,-158},{0,-138}})));
  Valves.GenericValveVLE_L1 valveLinear_1_XRG3(redeclare model PressureLoss = Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=100000, m_flow_nom=50)) annotation (Placement(transformation(extent={{-40,-154},{-20,-142}})));
  Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{-76,-157},{-116,-147}})));
equation
  connect(ramp1.y, massFlowSource_XRG2.m_flow) annotation (Line(
      points={{-171,-84},{-144,-84},{-144,36},{-122,36}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(ramp2.y, massFlowSource_XRG1.m_flow) annotation (Line(
      points={{67,118},{38,118},{38,66},{22,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y, massFlowSource_XRG1.h) annotation (Line(
      points={{69,90},{52,90},{52,60},{22,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valveLinear_1_XRG.outlet, massFlowSource_XRG.steam_a) annotation (
      Line(
      points={{-20,30},{0,30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flxibleJoin.inlet[1], valveLinear_1_XRG.inlet)
                                                  annotation (Line(
      points={{-60,29.75},{-39.95,29.75},{-39.95,30},{-40,30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flxibleJoin.inlet[2], massFlowSource_XRG1.steam_a)
                                                      annotation (Line(
      points={{-60,30.25},{-42,30.25},{-42,60},{0,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flxibleJoin.outlet, massFlowSource_XRG2.steam_a)
                                                    annotation (Line(
      points={{-80,30},{-100,30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_XRG3.m_flow) annotation (Line(
      points={{-171,-84},{-144,-84},{-144,-24},{-146,-24}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(massFlowSource_XRG3.steam_a, join_Y.outlet) annotation (Line(
      points={{-124,-30},{-80,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp2.y, massFlowSource_XRG4.m_flow) annotation (Line(
      points={{67,118},{38,118},{38,6},{22,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y,massFlowSource_XRG4. h) annotation (Line(
      points={{69,90},{52,90},{52,0},{22,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_XRG4.steam_a, join_Y.inlet2) annotation (Line(
      points={{0,0},{-70,0},{-70,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valveLinear_1_XRG1.outlet, massFlowSource_XRG5.steam_a) annotation (
      Line(
      points={{-20,-30},{0,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_XRG6.m_flow) annotation (Line(
      points={{-171,-84},{-148,-84}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(ramp2.y, massFlowSource_XRG7.m_flow) annotation (Line(
      points={{67,118},{38,118},{38,-54},{22,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y,massFlowSource_XRG7. h) annotation (Line(
      points={{69,90},{52,90},{52,-60},{22,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valveLinear_1_XRG2.outlet, massFlowSource_XRG8.steam_a) annotation (
      Line(
      points={{-20,-90},{0,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(split_Y.inlet, valveLinear_1_XRG2.inlet) annotation (Line(
      points={{-60,-90},{-40,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG7.steam_a,split_Y. outlet2) annotation (Line(
      points={{0,-60},{-70,-60},{-70,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(split_Y.outlet1, massFlowSource_XRG6.steam_a) annotation (Line(
      points={{-80,-90},{-126,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_Y.inlet1, valveLinear_1_XRG1.inlet) annotation (Line(
      points={{-60,-30},{-40,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flxibleJoin.eye, quadruple.eye) annotation (Line(
      points={{-80,22},{-82,22},{-82,7},{-84,7}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(split_Y.eye[1], quadruple1.eye) annotation (Line(points={{-80,-84},{-80,-79},{-84,-79}}, color={190,190,190}));
  connect(split_Y.eye[2], quadruple2.eye) annotation (Line(points={{-80,-84},{-80,-67},{-84,-67}}, color={190,190,190}));
  connect(join_Y.eye, quadruple3.eye) annotation (Line(points={{-80,-38},{-82,-38}}, color={190,190,190}));
  connect(ramp1.y,massFlowSource_XRG9. m_flow) annotation (Line(
      points={{-171,-84},{-144,-84},{-144,-142},{-146,-142}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(massFlowSource_XRG9.steam_a, join_Y1.outlet) annotation (Line(
      points={{-124,-148},{-72,-148}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_XRG10.steam_a, join_Y1.inlet2) annotation (Line(
      points={{0,-118},{-62,-118},{-62,-138}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valveLinear_1_XRG3.outlet, massFlowSource_XRG11.steam_a) annotation (Line(
      points={{-20,-148},{0,-148}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp2.y, massFlowSource_XRG7.m_flow) annotation (Line(
      points={{67,118},{38,118},{38,-54},{22,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y,massFlowSource_XRG7. h) annotation (Line(
      points={{69,90},{52,90},{52,-60},{22,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(join_Y1.inlet1, valveLinear_1_XRG3.inlet) annotation (Line(
      points={{-52,-148},{-40,-148}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp3.y, massFlowSource_XRG10.h) annotation (Line(
      points={{69,90},{52,90},{52,-118},{22,-118}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, massFlowSource_XRG10.m_flow) annotation (Line(
      points={{67,118},{38,118},{38,-112},{22,-112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(quadruple4.eye, join_Y1.eye) annotation (Line(points={{-76,-152},{-73,-152}}, color={190,190,190}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-180},{100,180}}), graphics={Text(
          extent={{-198,174},{22,52}},
          lineColor={0,128,0},
          textString="_______________________________________________________________________
PURPOSE:
Show different join or mixing models and illustrate the differences. The model compares a 
flexible join supporting an arbitrary number of inlet mass flows and a Y-type join having
two inlets. Additionally, a Y-type split is applied at the bottom of the diagram. As the
models are capable for reverse flow (as shown by changing the mass flow diraction after 
300 s) the split elements comes to the same results as the join models. However, it is
recommended to consider the design flow direction in the model choice as it eases the
initialisation.
_______________________________________________________________________
LOOK AT:
compare the corresponding outlet connector variables in the summaries. An important 
effect is the phase change at the outlet port after  flow reversal. This is due to 
the fact that the two mass flow sources have different specific enthalpies referring
to vapour and liquid phase, respectively. To calculate this high-gradient transients
rapidly the Boolean parameter preciseTwoPhase in the expert settings dialog is set to 
false. This refers to a cut link between the dynamic energy and mass balance equations,
i.e. the term h*V*der(rho) is ommited. This is okay in most cases since the dynamics of
a power plant do not depend strongly on relative small join elements.
Please note, setting preciseTwoPhase to true may induce strong mass flow oscillations
which can be suppressed by adding additional pressure losses.

_______________________________________________________________________
",        fontSize=10,
          horizontalAlignment=TextAlignment.Left)}),
    experiment(StopTime=3000),
    __Dymola_experimentSetupOutput,
    Icon(graphics, coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)));
end Test_MixAndSplit;
