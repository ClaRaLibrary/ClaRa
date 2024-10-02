within ClaRa.Components.MechanicalSeparation;
model Drum_L3 "Drum : separated volume approach | level-dependent phase separation"
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

extends ClaRa.Basics.Icons.Drum;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid
                                      medium=simCenter.fluid1 "Medium in the component"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model material = TILMedia.SolidTypes.TILMedia_Steel constrainedby TILMedia.SolidTypes.BaseSolid "Material of the walls" annotation (Dialog(group="Fundamental Definitions"),choicesAllMatching);
  parameter Boolean includeInsulation=false  "True, if insulation is included" annotation(Dialog(group="Fundamental Definitions"));
  replaceable model insulationMaterial=Basics.Media.Solids.InsulationOrstechLSP_H_const
                                                                            constrainedby TILMedia.SolidTypes.BaseSolid "Insulation material" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions", enable=(includeInsulation==true)));

  parameter ClaRa.Basics.Units.Length diameter=1 "Diameter of the component" annotation (Dialog(group="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/Drum.png"));
  parameter ClaRa.Basics.Units.Length length=1 "Length of the component" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length thickness_wall=diameter*0.01/2 "Thickness of the cylinder wall" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length thickness_insulation=0.02 "Thickness of the insulation" annotation (Dialog(group="Geometry", enable=includeInsulation));

  parameter Basics.Choices.GeometryOrientation      orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "Orientation of the component"
                                                                                              annotation(Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Length radius_flange=0.05 "Flange radius" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_feed=0 "Position of feedwater flange" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_risers[3]={0.1,0.1,0.1} "Position of riser flange" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_sat=0 "Position of saturated steam outlet" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_downs[3]={0.1,0.1,0.1} "Position of downcomer flange" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of internal structure addtional to drum wall" annotation (Dialog(group="Geometry"));
  parameter Basics.Units.Time Tau_cond=0.01 "Time constant of condensation" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Basics.Units.Time Tau_evap=Tau_cond*1000 "Time constant of evaporation" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Real absorbInflow=1 "Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"
                                                                                              annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Basics.Units.Area A_phaseBorder=volume.geo.A_hor*100 "Heat transfer area at phase border" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=500 "HTC of the phase border" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Real expHT_phases=0 "Exponent for volume dependency on inter phase HT" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Boolean equalPressures=true "True if pressure in liquid and vapour phase is equal" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation for calculation of filling level" annotation(Dialog(tab="Phase Separation", group="Numerical Robustness"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation", group="Volume"));

  parameter Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, volume.p_start) "Start value of liquid specific enthalpy" annotation (Dialog(tab="Initialisation", group="Volume"));
  parameter Basics.Units.EnthalpyMassSpecific h_vap_start=+10 + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, volume.p_start) "Start value of vapour specific enthalpy" annotation (Dialog(tab="Initialisation", group="Volume"));
  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation", group="Volume"));
  parameter Real level_rel_start = 0.5 "Initial filling level" annotation(Dialog(tab="Initialisation", group="Volume"));
  inner parameter Integer initOption = 211 "Type of initialisation"
    annotation (Dialog(tab= "Initialisation", group = "Volume"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume", choice=201 "Steady vapour pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed volume fraction",  choice=211 "Fixed values in level, enthalpies and vapour pressure"));

  parameter Modelica.Units.SI.Temperature T_wall_start[wall.N_rad]=ones(wall.N_rad)*293.15 "Start values of wall temperature inner --> outer" annotation (Dialog(tab="Initialisation", group="Wall"));
  parameter Integer initOptionWall=213 "Initialisation option for wall" annotation(Dialog(tab="Initialisation", group="Wall"),choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));
  parameter Integer initOptionInsulation=213 "Type of initialisation" annotation (Dialog(tab="Initialisation",group="Insulation", enable=includeInsulation), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));
  parameter ClaRa.Basics.Units.Temperature T_startInsulation=293.15 "Start values of wall temperature" annotation (Dialog(
      tab="Initialisation",
      group="Insulation",
      enable=includeInsulation));

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "Pressure loss model"
                          annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (                      alpha_nom={3000,3000})                              constrainedby Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L3 "Heat transfer to the walls"
                                                                                              annotation (Dialog(group="Fundamental Definitions"),choicesAllMatching=true);
  parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rate at riser inlet" annotation (Dialog(group="Nominal Values"));

  parameter Boolean enableAmbientLosses=false "Include heat losses to environment "
                                                                                   annotation(Dialog(tab="Heat Losses"));
  input ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_prescribed=8 "Prescribed heat transfer coefficient" annotation (Dialog(tab="Heat Losses", enable=(enableAmbientLosses == true)));
  input ClaRa.Basics.Units.Temperature T_amb=simCenter.T_amb "Temperature of surrounding medium" annotation (Dialog(tab="Heat Losses", enable=(enableAmbientLosses == true)));
  parameter Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity of the wall" annotation (Dialog(tab="Heat Losses"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if expert summary should be applied" annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showLevel = false "True, if level shall be visualised"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean levelOutput = false "True, if Real level connector shall be addded"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean outputAbs = false "True, if absolute level is at output"  annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));

 model Outline
   extends ClaRa.Basics.Icons.RecordIcon;
    input Basics.Units.Length level_abs "Absolute filling level";
   input Real level_rel "relative filling level";
    input ClaRa.Basics.Units.HeatFlowRate Q_loss "Heat flow rate from metal wall to insulation/ambient";
 end Outline;

 model Wall
   extends ClaRa.Basics.Icons.RecordIcon;
    input Basics.Units.Temperature T_wall[3] "Temperatures";
 end Wall;

 model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   Wall wall;
   ClaRa.Basics.Records.FlangeVLE riser[3];
   ClaRa.Basics.Records.FlangeVLE down[3];
   ClaRa.Basics.Records.FlangeVLE feedwater;
   ClaRa.Basics.Records.FlangeVLE sat;

 end Summary;

  Summary summary(
    outline(
      level_abs=volume.phaseBorder.level_abs,
      level_rel=volume.phaseBorder.level_rel,
      Q_loss=wall.outerPhase.Q_flow),
    wall(T_wall=wall.T),
    riser(
      each showExpertSummary=showExpertSummary,
      m_flow={riser_1.m_flow, riser_2.m_flow, riser_3.m_flow},
      p={riser_1.p, riser_2.p, riser_3.p},
      h={volume.fluidIn[2].h, volume.fluidIn[3].h, volume.fluidIn[4].h},
      T={volume.fluidIn[2].T, volume.fluidIn[3].T, volume.fluidIn[4].T},
      s={volume.fluidIn[2].s, volume.fluidIn[3].s, volume.fluidIn[4].s},
      steamQuality={volume.fluidIn[2].q, volume.fluidIn[3].q, volume.fluidIn[4].q},
      H_flow={riser_1.m_flow, riser_2.m_flow, riser_3.m_flow}.*{volume.fluidIn[2].h, volume.fluidIn[3].h, volume.fluidIn[4].h},
      rho={volume.fluidIn[2].d, volume.fluidIn[3].d, volume.fluidIn[4].d}),
    down(
      each showExpertSummary=showExpertSummary,
      m_flow=-{down_1.m_flow, down_2.m_flow, down_3.m_flow},
      p={down_1.p, down_2.p, down_3.p},
      h={volume.fluidOut[2].h, volume.fluidOut[3].h, volume.fluidOut[4].h},
      T={volume.fluidOut[2].T, volume.fluidOut[3].T, volume.fluidOut[4].T},
      s={volume.fluidOut[2].s, volume.fluidOut[3].s, volume.fluidOut[4].s},
      steamQuality={volume.fluidOut[2].q, volume.fluidOut[3].q, volume.fluidOut[4].q},
      H_flow={riser_1.m_flow, riser_2.m_flow, riser_3.m_flow}.*{volume.fluidOut[2].h, volume.fluidOut[3].h, volume.fluidOut[4].h},
      rho={volume.fluidOut[2].d, volume.fluidOut[3].d, volume.fluidOut[4].d}),
    feedwater(
      showExpertSummary=showExpertSummary,
      m_flow=feed.m_flow,
      p=feed.p,
      h=volume.fluidIn[1].h,
      T=volume.fluidIn[1].T,
      s=volume.fluidIn[1].s,
      steamQuality=volume.fluidIn[1].q,
      H_flow = feed.m_flow*volume.fluidIn[1].h,
      rho=volume.fluidIn[1].d),
    sat(
      showExpertSummary=showExpertSummary,
      m_flow=-sat.m_flow,
      p=sat.p,
      h=volume.fluidOut[1].h,
      T=volume.fluidOut[1].T,
      s=volume.fluidOut[1].s,
      steamQuality=volume.fluidOut[1].q,
      H_flow = feed.m_flow*volume.fluidOut[1].h,
      rho=volume.fluidOut[1].d)) annotation (Placement(transformation(extent={{300,-100},{280,-80}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort volume(
    medium=medium,
    redeclare model PressureLoss = PressureLoss,
    equalPressures=equalPressures,
    useHomotopy=useHomotopy,
    p_nom=p_nom,
    p_start=p_start,
    level_rel_start=level_rel_start,
    Tau_cond=Tau_cond,
    showExpertSummary=showExpertSummary,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow,
        smoothness=smoothness),
    A_heat_ph=A_phaseBorder,
    exp_HT_phases=expHT_phases,
    redeclare model HeatTransfer = HeatTransfer,
    initOption=initOption,
    m_flow_nom=m_flow_nom,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=Modelica.Constants.pi/4*diameter^2*length,
        N_heat=1,
        A_heat={Modelica.Constants.pi*diameter*length},
        final A_hor=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else diameter*length,
        shape=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then [0,1; 1,1] else [0.0005,0.02981; 0.0245,0.20716; 0.1245,0.45248; 0.2245,0.58733; 0.3245,0.68065; 0.4245,0.74791; 0.5245,0.7954; 0.6245,0.8261; 0.7245,0.84114; 0.8245,0.84015; 0.9245,0.82031; 1,0.7854],
        height_fill=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then length else diameter,
        A_cross=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else length*diameter,
        final A_front=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else length*diameter,
        z_in=cat(1,{z_feed},z_risers),
        z_out=cat(1,{z_sat},z_downs),
        N_outlet=4,
        N_inlet=4))        annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));

  Basics.Interfaces.FluidPortOut sat(Medium=medium) "Saturated steam outlet"
    annotation (Placement(transformation(extent={{-190,90},{-170,110}}),
        iconTransformation(extent={{-190,90},{-170,110}})));
  Basics.Interfaces.FluidPortOut down_1(Medium=medium) "Downcomer outlet" annotation (Placement(transformation(extent={{50,-110},{70,-90}}), iconTransformation(extent={{50,-110},{70,-90}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    sizefunc=+1,
    N_tubes=1,
    length=length,
    N_rad=3,
    diameter_i=diameter,
    redeclare replaceable model Material = material,
    diameter_o=diameter + 2*thickness_wall,
    CF_lambda=CF_lambda,
    T_start=T_wall_start,
    initOption=initOptionWall,
    mass_struc=mass_struc + 2*diameter^2/4*Modelica.Constants.pi*thickness_wall*wall.solid[1].d) annotation (Placement(transformation(extent={{-10,28},{10,48}})));
  Basics.Interfaces.FluidPortIn feed(Medium=medium) "Feedwater inlet"
    annotation (Placement(transformation(extent={{290,-10},{310,10}}),
        iconTransformation(extent={{290,-10},{310,10}})));
  Basics.Interfaces.FluidPortIn riser_1(Medium=medium) "Riser inlet" annotation (Placement(transformation(extent={{-270,-110},{-250,-90}}), iconTransformation(extent={{-270,-110},{-250,-90}})));
protected
  Basics.Interfaces.EyeIn       eye_int[3]
    annotation (Placement(transformation(extent={{139,-51},{141,-49}})));
public
  Basics.Interfaces.EyeOut eye_down[3]
                                     if showData annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={140,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={140,-110})));
protected
  Basics.Interfaces.EyeIn       eye_int1[1]
    annotation (Placement(transformation(extent={{-9,91},{-7,93}})));
public
  Basics.Interfaces.EyeOut eye_sat   if showData
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,98}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-220,110})));

  Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,8})));

  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then summary.outline.level_abs else summary.outline.level_rel if levelOutput annotation (Placement(transformation(extent={{204,-126},{224,-106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={220,-110})));

  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 insulation(
    redeclare model Material = insulationMaterial,
    diameter_o=diameter + 2*thickness_wall + 2*thickness_insulation,
    diameter_i=diameter + 2*thickness_wall,
    length=length,
    N_tubes=1,
    N_ax=1,
    stateLocation=2,
    initOption=initOptionInsulation,
    T_start=T_startInsulation*ones(1),
    CF_lambda=CF_lambda)                                           if includeInsulation annotation (Placement(transformation(extent={{-10,56},{10,64}})));
  Modelica.Blocks.Sources.RealExpression heatFlowRatePrescribedAlpha(y=if includeInsulation then -alpha_prescribed*(length*Modelica.Constants.pi*(diameter + 2*thickness_wall + 2*thickness_insulation) + Modelica.Constants.pi*(diameter + 2*thickness_wall + 2*thickness_insulation)^2/4*2)*(prescribedHeatFlow.port[1].T - T_amb) else -alpha_prescribed*(length*Modelica.Constants.pi*(diameter + 2*thickness_wall) + Modelica.Constants.pi*(diameter + 2*thickness_wall)^2/4*2)*(prescribedHeatFlow.port[1].T - T_amb))
                    if enableAmbientLosses==true annotation (Placement(transformation(extent={{-90,64},{-70,84}})));
  BoundaryConditions.PrescribedHeatFlow                  prescribedHeatFlow(
    length=length,
    N_axial=1,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0},
        length,
        1))         if enableAmbientLosses==true annotation (Placement(transformation(extent={{-60,64},{-40,84}})));
  Basics.Interfaces.FluidPortOut down_2(Medium=medium) "Downcomer outlet" annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  Basics.Interfaces.FluidPortOut down_3(Medium=medium) "Downcomer outlet" annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}), iconTransformation(extent={{-70,-110},{-50,-90}})));
  Basics.Interfaces.FluidPortIn riser_2(Medium=medium) "Riser inlet" annotation (Placement(transformation(extent={{-210,-110},{-190,-90}}), iconTransformation(extent={{-210,-110},{-190,-90}})));
  Basics.Interfaces.FluidPortIn riser_3(Medium=medium) "Riser inlet" annotation (Placement(transformation(extent={{-150,-110},{-130,-90}}), iconTransformation(extent={{-150,-110},{-130,-90}})));
equation
  eye_int[1].m_flow=-down_1.m_flow;
  eye_int[1].T=volume.summary.outlet[2].T-273.15;
  eye_int[1].s=volume.fluidOut[2].s/1000;
  eye_int[1].h=volume.summary.outlet[2].h/1000;
  eye_int[1].p=volume.summary.outlet[2].p/100000;

  eye_int[2].m_flow=-down_2.m_flow;
  eye_int[2].T=volume.summary.outlet[3].T-273.15;
  eye_int[2].s=volume.fluidOut[3].s/1000;
  eye_int[2].h=volume.summary.outlet[3].h/1000;
  eye_int[2].p=volume.summary.outlet[3].p/100000;

  eye_int[3].m_flow=-down_3.m_flow;
  eye_int[3].T=volume.summary.outlet[4].T-273.15;
  eye_int[3].s=volume.fluidOut[4].s/1000;
  eye_int[3].h=volume.summary.outlet[4].h/1000;
  eye_int[3].p=volume.summary.outlet[4].p/100000;

  eye_int1[1].m_flow=-sat.m_flow;
  eye_int1[1].T=volume.summary.outlet[1].T-273.15;
  eye_int1[1].s=volume.fluidOut[1].s/1000;
  eye_int1[1].h=volume.summary.outlet[1].h/1000;
  eye_int1[1].p=volume.summary.outlet[1].p/100000;

  connect(feed, volume.inlet[1]) annotation (Line(
      points={{300,0},{18,0},{18,-20},{10,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(riser_1, volume.inlet[2]) annotation (Line(
      points={{-260,-100},{-260,-100},{-260,-34},{16,-34},{16,-20},{10,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet[1], sat) annotation (Line(
      points={{-10,-20},{-180,-20},{-180,100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet[2], down_1) annotation (Line(
      points={{-10,-20},{-10,-20},{-28,-20},{-28,-46},{30,-46},{30,-70},{30,-100},{60,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_int1[1], eye_sat)
                        annotation (Line(
      points={{-8,92},{-8,98},{-20,98}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatScalar, wall.innerPhase) annotation (Line(
      points={{1.77636e-015,18},{1.77636e-015,28.4},{-0.2,28.4}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.heat, scalar2VectorHeatPort.heatVector) annotation (Line(
      points={{0,-10},{0,-6},{-1.77636e-015,-6},{-1.77636e-015,-2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
    if includeInsulation then
      connect(wall.outerPhase,insulation.innerPhase[1]);
      if enableAmbientLosses then
         connect(insulation.outerPhase[1],prescribedHeatFlow.port[1]);
         connect(heatFlowRatePrescribedAlpha.y, prescribedHeatFlow.Q_flow);
      end if;
    else
      if enableAmbientLosses then
         connect(wall.outerPhase,prescribedHeatFlow.port[1]);
         connect(heatFlowRatePrescribedAlpha.y, prescribedHeatFlow.Q_flow);
      end if;
    end if;

  connect(volume.outlet[3], down_2) annotation (Line(
      points={{-10,-20},{-28,-20},{-28,-46},{0,-46},{0,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(volume.outlet[4], down_3) annotation (Line(
      points={{-10,-20},{-60,-20},{-60,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(riser_2, volume.inlet[3]) annotation (Line(
      points={{-200,-100},{-200,-34},{16,-34},{16,-20},{10,-20}},
      color={0,131,169},
      thickness=0.5));
  connect(riser_3, volume.inlet[4]) annotation (Line(
      points={{-140,-100},{-140,-34},{16,-34},{16,-20},{10,-20}},
      color={0,131,169},
      thickness=0.5));
  connect(eye_int, eye_down) annotation (Line(points={{140,-50},{140,-110}}, color={190,190,190}));
     annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=false,extent={{-300,-100},{300,100}}),
                   graphics={
                     Rectangle(extent={{120,92},{160,-92}},
                               lineColor={27,36,42},
                               fillColor={153,205,221},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel),
                     Rectangle(extent=DynamicSelect({{120,0},{160,-92}}, {{120,summary.outline.level_rel*184-92},{160,-92}}),
                               lineColor={27,36,42},
                               fillColor={0,131,169},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel)}),
                                       Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-300,-100},{300,100}})));
end Drum_L3;
