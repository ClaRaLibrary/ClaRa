within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_2ph_BU_simple "VLE 2 VLE | L3 | 2 phase at shell side | Block shape |  U-type | simple HT"
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

  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX04;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    input ClaRa.Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    input ClaRa.Basics.Units.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    input ClaRa.Basics.Units.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA if showExpertSummary "Overall heat transmission";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom if showExpertSummary "Nominal overall heat transmission";
    input ClaRa.Basics.Units.Length level_abs "Absolute filling level";
    input Real level_rel "relative filling level";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  // Parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  //*********************************** / SHELL SIDE \ ***********************************//
  //________________________________ Shell fundamentals _______________________________//
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_shell=simCenter.fluid1 "Medium to be used for shell flow"
                                       annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(tab=
          "Shell Side", group="Fundamental Definitions"));
  replaceable model HeatTransfer_Shell =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellTypeVLE_L3
                                                                                      "Heat transfer model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "Pressure loss model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
   annotation (Dialog(tab="General",group="Fundamental Definitions"), choicesAllMatching);
//, groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialog_CHgeneral.png"
  //________________________________ Shell geometry _______________________________//
  parameter ClaRa.Basics.Units.Length length=10 "Length of the HEX" annotation (Dialog(
      tab="Shell Side",
      group="Geometry",
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialog_BUshell2ph.png"));                                                  //
  parameter ClaRa.Basics.Units.Length height=3 "Height of HEX" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length width=3 "Width of HEX" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_shell=height   "Inlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_aux1=height   "Inlet position of auxilliary1 from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_aux2=height   "Inlet position of auxilliary2 from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_shell=0.1      "Outlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length radius_flange=0.05 "Flange radius of all flanges" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself" annotation (Dialog(tab="Shell Side", group="Geometry"));

  //*********************************** / HOTWELL \ ***********************************//
  parameter ClaRa.Basics.Units.Length height_hotwell=1 "Height of the hotwell" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length width_hotwell=1 "Width of the hotwell" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length length_hotwell=1 "Length of the hotwell" annotation (Dialog(tab="Shell Side", group="Geometry"));

  //________________________________ Shell nominal parameter _____________________________________//
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom_shell=10 "Nominal mass flow on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom_shell=10 "Nominal pressure on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom_shell=100e3 "Nominal specific enthalpy on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Real yps_liq_nom=level_rel_start "Relative volume of liquid phase at nominal point" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  final parameter Real yps_nom[2]={yps_liq_nom, 1-yps_liq_nom} "Relative volume of liquid phase [1] and vapour phase [2] at nominal point";

  //________________________________ Shell initialisation  _______________________________________//
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium_shell, p_start_shell) "Start value of liquid specific enthalpy" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vap_start=+10 + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium_shell, p_start_shell) "Start value of vapour specific enthalpy" annotation (Dialog(tab="Shell Side", group="Initialisation"));

  parameter ClaRa.Basics.Units.Pressure p_start_shell=1e5 "Start value of shell fluid pressure" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Real level_rel_start=0.5 "Start value for relative filling Level" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  inner parameter Integer initOptionShell = 211 "Type of initialisation"
    annotation (Dialog(tab= "Shell Side", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume",
                                                                                              choice=201 "Steady vapour pressure",
                                                                                              choice = 202 "Steady enthalpy",
                                                                                              choice=204 "Fixed volume fraction",
                                                                                              choice=211 "Fixed values in level, enthalpies and vapour pressure"));

  //*********************************** / TUBE SIDE \ ***********************************//
  //________________________________ Tubes fundamentals _______________________________//

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_tubes=simCenter.fluid1 "Medium to be used for tubes flow" annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(tab="Tubes",
        group="Fundamental Definitions"));
  replaceable model HeatTransferTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeTypeVLE_L2
                                                                                     "Heat transfer mode at the tubes side" annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeTypeVLE_L2
                                                                                    "Pressure loss model at the tubes side"
                                            annotation (Dialog(tab="Tubes",group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Tubes geometry _______________________________//
  parameter ClaRa.Basics.Units.Length diameter_i=0.048 "Inner diameter of internal tubes" annotation (Dialog(
      tab="Tubes",
      group="Tubes Geometry",
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialogTubes.png"));
  parameter ClaRa.Basics.Units.Length diameter_o=0.05 "Outer diameter of internal tubes" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Integer N_tubes=1000 "Number of tubes"  annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_tubes=length/2 "Inlet position from bottom" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_tubes=length/2 "Outlet position from bottom" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter ClaRa.Basics.Units.Length Delta_z_par=1.5*diameter_o "Distance between tubes parallel to flow direction (center to center)" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter ClaRa.Basics.Units.Length Delta_z_ort=1.5*diameter_o "Distance between tubes orthogonal to flow direction (center to center)" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Integer N_rows=integer(ceil(sqrt(N_tubes))*N_passes) "Number of pipe rows in shell flow direction" annotation(Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Real CF_geo=1 "Correction coefficient due to fins etc." annotation (Dialog(tab="Tubes", group="Tubes Geometry"));

  //________________________________ Tubes nominal parameter _____________________________________//
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom_tubes=10 "Nominal mass flow on tubes side" annotation (Dialog(
      tab="Tubes",
      group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom_tubes=10 "Nominal pressure on side tubes" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom_tubes=10 "Nominal specific enthalpy on tubes side" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate" annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //___________________________Initialisation tubes _______________________________________//
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start_tubes=1e5 "Start value of tube fluid specific enthalpy" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_tubes=1e5 "Start value of tube fluid pressure" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Integer initOptionTubes=0 "Type of initialisation at tube side"
    annotation (Dialog(tab="Tubes", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                              choice = 202 "Steady enthalpy"));

  //***********************************/ WALL \ *****************************************//
  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Tube Wall", group=
          "Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Temperature T_w_start[3]=ones(3)*293.15 "Initial wall temperature inner --> outer" annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  parameter Integer initOptionWall=213 "Init option of Tube wall" annotation (Dialog(tab="Tube Wall", group="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter ClaRa.Basics.Units.Time Tau_cond=0.3 "Time constant of condensation" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter ClaRa.Basics.Units.Time Tau_evap=0.03 "Time constant of evaporation" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "HTC of the phase border" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter ClaRa.Basics.Units.Area A_phaseBorder=shell.geo.A_hor*100 "Heat transfer area at phase border" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Real expHT_phases=0 "Exponent for volume dependency on inter phase HT" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Real absorbInflow=1 "Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"
                                                                                              annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Boolean equalPressures=true "True if pressure in liquid and vapour phase is equal" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
 parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of level calculation (table based)" annotation (Dialog(tab="Expert Settings", group="Mass Accumulation at Shell Side"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if expert summary should be applied" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                              annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean levelOutput = false "True, if Real level connector shall be addded"  annotation(Dialog(tab="Summary and Visualisation"));

  parameter Boolean outputAbs = false "True, if absolute level is at output"  annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 tubes(
    medium=medium_tubes,
    p_nom=p_nom_tubes,
    h_nom=h_nom_tubes,
    m_flow_nom=m_flow_nom_tubes,
    useHomotopy=useHomotopy,
    h_start=h_start_tubes,
    p_start=p_start_tubes,
    redeclare model HeatTransfer = HeatTransferTubes,
    redeclare model PressureLoss = PressureLossTubes,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        final z_in={z_in_tubes},
        final z_out={z_out_tubes},
        final diameter=diameter_i,
        final N_tubes=N_tubes,
        final N_passes=N_passes,
        final length=length),
    initOption=initOptionTubes) annotation (Placement(transformation(extent={{62,10},{42,30}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort shell(
    medium=medium_shell,
    p_nom=p_nom_shell,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_flow_nom_shell,
    useHomotopy=useHomotopy,
    p_start=p_start_shell,
    level_rel_start=level_rel_start,
    Tau_cond=Tau_cond,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    showExpertSummary=showExpertSummary,
    exp_HT_phases=expHT_phases,
    A_heat_ph=A_phaseBorder,
    heatSurfaceAlloc=2,
    redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow,
        smoothness=smoothness),
    equalPressures=equalPressures,
    initOption=initOptionShell,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndHotwell (
        final z_out={z_out_shell},
        final length=length,
        final N_tubes=N_tubes,
        final staggeredAlignment=staggeredAlignment,
        final Delta_z_par=Delta_z_par,
        final Delta_z_ort=Delta_z_ort,
        final N_passes=N_passes,
        final diameter_t=diameter_o,
        final N_inlet=3,
        final z_in={z_in_shell,z_in_aux1,z_in_aux2},
        final flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        final N_rows=N_rows,
        final CF_geo={1,CF_geo},
        final height=height,
        final width=width,
        final height_hotwell=height_hotwell,
        final width_hotwell=width_hotwell,
        final length_hotwell=length_hotwell,
        tubeOrientation=0))           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,46})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    redeclare replaceable model Material = WallMaterial,
    N_rad=3,
    sizefunc=1,
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    N_tubes=N_tubes,
    N_passes=N_passes,
    T_start=T_w_start,
    length=length*N_passes,
    initOption=initOptionWall,
    mass_struc=mass_struc) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={33,45})));

public
  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=sum(shell.heat.Q_flow),
      Delta_T_in=shell.summary.inlet[1].T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet[1].T - tubes.summary.outlet.T,
      level_abs=shell.phaseBorder.level_abs,
      level_rel=shell.phaseBorder.level_rel,
      kA=1/(tubes.heattransfer.HR + wall.HR + sum(shell.heattransfer.HR .* shell.summary.outline.yps)),
      kA_nom=1/(tubes.heattransfer.HR_nom + wall.HR_nom + sum(shell.heattransfer.HR_nom .* yps_nom))))
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));


protected
   ClaRa.Basics.Interfaces.EyeIn eye_int2[1] annotation (Placement(transformation(extent={{67,79},{69,81}})));
public
   ClaRa.Basics.Interfaces.EyeOut eye2 if showData annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={104,80}),   iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={104,80})));
protected
   ClaRa.Basics.Interfaces.EyeIn eye_int1[1] annotation (Placement(transformation(extent={{27,-59},{29,-57}})));
public
   ClaRa.Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(transformation(
        extent={{100,10},{120,30}},
        rotation=270,
        origin={20,0}), iconTransformation(
        extent={{100,10},{120,30}},
        rotation=270,
        origin={20,0})));
  ClaRa.Basics.Interfaces.FluidPortIn aux1(Medium=medium_shell) annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  ClaRa.Basics.Interfaces.FluidPortIn aux2(Medium=medium_shell) annotation (Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then summary.outline.level_abs else summary.outline.level_rel if levelOutput annotation (Placement(transformation(extent={{80,-90},{100,-110}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-110})));
equation
   assert(diameter_o > diameter_i,
     "Outer diameter of tubes must be greater than inner diameter");

  connect(tubes.inlet, In2) annotation (Line(
      points={{62,20},{82,20},{82,-40},{100,-40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{42,20},{72,20},{72,60},{100,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

   eye_int1[1].m_flow=-shell.outlet[1].m_flow;
   eye_int1[1].T=shell.summary.outlet[1].T-273.15;
   eye_int1[1].s=shell.fluidOut[1].s/1000;
   eye_int1[1].h=shell.summary.outlet[1].h/1000;
   eye_int1[1].p=shell.summary.outlet[1].p/100000;

   eye_int2[1].m_flow=-tubes.outlet.m_flow;
   eye_int2[1].T=tubes.summary.outlet.T-273.15;
   eye_int2[1].s=tubes.fluidOut.s/1000;
   eye_int2[1].h=tubes.summary.outlet.h/1000;
   eye_int2[1].p=tubes.summary.outlet.p/100000;

  connect(In1, shell.inlet[1]) annotation (Line(
      points={{0,98},{0,56},{1.77636e-015,56}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.outlet[1], Out1) annotation (Line(
      points={{-1.77636e-015,36},{-1.77636e-015,-26},{0,-26},{0,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(aux1, shell.inlet[2]) annotation (Line(
      points={{-100,80},{1.77636e-015,80},{1.77636e-015,56}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(aux2, shell.inlet[3]) annotation (Line(
      points={{-100,60},{1.77636e-015,60},{1.77636e-015,56}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(shell.heat[1], wall.outerPhase) annotation (Line(
      points={{9.5,46},{22.8667,46},{22.8667,45}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.heat[2], wall.outerPhase) annotation (Line(
      points={{10.5,46},{14,46},{14,45},{22.8667,45}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.heat, wall.innerPhase) annotation (Line(
      points={{52,30},{52,30},{52,44.8},{42.6,44.8}},
      color={167,25,48},
      thickness=0.5));
  connect(eye_int2[1], eye2) annotation (Line(points={{68,80},{104,80}},                color={190,190,190}));
  connect(eye_int1[1], eye1) annotation (Line(points={{28,-58},{40,-58},{40,-110}},         color={190,190,190}));
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
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                              Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end HEXvle2vle_L3_2ph_BU_simple;
