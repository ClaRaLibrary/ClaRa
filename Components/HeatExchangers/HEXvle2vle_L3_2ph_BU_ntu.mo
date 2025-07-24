within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_2ph_BU_ntu "VLE 2 VLE | L3 | two phase at shell side | Block shape | U-type | NTU ansatz"
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

  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX04;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    input SI.HeatFlowRate Q_flow "Heat flow rate";
    input SI.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    input SI.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    input Real effectiveness[3] if showExpertSummary "Effectivenes of HEX";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA[3] if showExpertSummary "Overall heat transmission";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom if showExpertSummary "Nominal overall heat transmission";
    input SI.Length level_abs "Absolute filling level";
    input Real level_rel "relative filling level";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;
  // Parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  //*********************************** / SHELL SIDE \ ***********************************//
  //________________________________ Shell fundamentals _______________________________//
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium_shell=simCenter.fluid1 "Medium to be used for shell flow"
    annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"), Dialog(tab="Shell Side", group=
          "Fundamental Definitions"));

  replaceable model HeatTransfer_Shell =
     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellTypeVLE_L3
                                                                                      "Heat transfer model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "Pressure loss model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Shell geometry _______________________________//
  parameter SI.Length length=10 "Length of the HEX" annotation (Dialog(
      tab="Shell Side",
      group="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialog_BUshell2ph.png"));
  parameter SI.Length height=3 "Height of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length width=3 "Width of HEX"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_in_shell=height   "Inlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
    parameter SI.Length z_in_aux1=height   "Inlet position of auxilliary1 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_in_aux2=height   "Inlet position of auxilliary2 from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter SI.Length z_out_shell=0.1      "Outlet position from bottom"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length radius_flange=0.05 "Flange radius of all flanges" annotation (Dialog(tab="Shell Side", group="Geometry"));

  //________________________________ Shell nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_flow_nom_shell=10 "Nominal mass flow on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter SI.Pressure p_nom_shell=10 "Nominal pressure on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Real yps_liq_nom=level_rel_start "Relative volume of liquid phase at nominal point" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  final parameter Real yps_nom[2]={yps_liq_nom, 1-yps_liq_nom} "Relative volume of liquid phase [1] and vapour phase [2] at nominal point";

//   parameter SI.SpecificEnthalpy h_nom_shell=10
//     "Nominal specific enthalpy on shell side"
//     annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//
   parameter SI.EnthalpyMassSpecific h_liq_start=-10 +
       TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(                                     medium_shell, p_start_shell) "Start specific enthalpy of liquid phase" annotation (Dialog(tab="Shell Side", group="Initialisation"));
   parameter SI.EnthalpyMassSpecific h_vap_start=+10 +
       TILMedia.VLEFluid.MixtureCompatible.Functions.dewSpecificEnthalpy_pxi(                                     medium_shell, p_start_shell) "Start specific enthalpy of steam phase" annotation (Dialog(tab="Shell Side", group="Initialisation"));

//   parameter SI.SpecificEnthalpy h_start_shell=1e5
//     "Start value of sytsem specific enthalpy"
//     annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter SI.Pressure p_start_shell=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Real level_rel_start=0.5 "Start value for relative filling Level" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  inner parameter Integer initOptionShell = 211 "Type of initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume", choice=201 "Steady vapour pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed volume fraction",  choice=211 "Fixed values in level, enthalpies and vapour pressure"));

  //*********************************** / TUBE SIDE \ ***********************************//
  //________________________________ Tubes fundamentals _______________________________//
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium_tubes=simCenter.fluid1 "Medium to be used for tubes flow"
    annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"), Dialog(tab="Tubes", group=
          "Fundamental Definitions"));

  replaceable model HeatTransferTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeTypeVLE_L2
                                                                                     "Heat transfer mode at the tubes side"
                                           annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model at the tubes side"
                                            annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Tubes geometry _______________________________//
  parameter SI.Length diameter_i=0.048 "Inner diameter of horizontal tubes"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter SI.Length diameter_o=0.05 "Outer diameter of horizontal tubes"    annotation (Dialog(tab="Tubes", group="Tubes Geometry",groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialogTubes.png"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter SI.Length z_in_tubes=length/2 "Inlet position from bottom"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter SI.Length z_out_tubes=length/2 "Outlet position from bottom"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter SI.Length Delta_z_par=1.5*diameter_o "Distance between tubes parallel to flow direction (center to center)"
                                                                                              annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter SI.Length Delta_z_ort=1.5*diameter_o "Distance between tubes orthogonal to flow direction (center to center)"
                                                                                              annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Integer N_rows=integer(ceil(sqrt(N_tubes))*N_passes) "Number of pipe rows in shell flow direction" annotation(Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Real CF_geo=1 "Correction coefficient due to fins etc."    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));

  //________________________________ Tubes nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_flow_nom_tubes=10 "Nominal mass flow on tubes side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.Pressure p_nom_tubes=10 "Nominal pressure on tubes side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.EnthalpyMassSpecific h_nom_tubes=10 "Nominal specific enthalpy on tubes side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //________________________________ Tubes initialisation _______________________________________//
  parameter SI.EnthalpyMassSpecific h_start_tubes=1e5 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter SI.Pressure p_start_tubes=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Integer initOptionTubes=0 "Type of initialisation at tube side"
    annotation (Dialog(tab="Tubes", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));

  //*********************************** / HOTWELL \ ***********************************//
  parameter Basics.Units.Length height_hotwell=1 "Height of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length width_hotwell=1 "Width of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length length_hotwell=1 "Length of the hotwell"
    annotation (Dialog(tab="Shell Side", group="Geometry"));

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum
    constrainedby TILMedia.Solid.Types.BaseSolid
                                                "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Tube Wall", group=
          "Fundamental Definitions"));
  parameter SI.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself"
    annotation (Dialog(tab="Tube Wall", group="Fundamental Definitions"));

  //________________________________ Wall initialisation _______________________________________//
  parameter Basics.Units.Temperature T_w_tube_start[3]=ones(3)*293.15 "Initial temperature at inner phase"
    annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  parameter Basics.Units.Temperature T_w_shell_start[3]=ones(3)*293.15 "Initial temperature at outer phase"
    annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  parameter Integer initOptionWall=0 "Init Option of Wall"
    annotation (Dialog(tab="Tube Wall", group="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature"));
  parameter Integer initOption_yps=3 "Volumetric initialisation" annotation (Dialog(tab="Tube Wall", group="Initialisation"),choices(choice = 1 "Integrator state at zero",
                                                                                                    choice=2 "Steady state",
                                                                                                    choice=3 "Apply guess value y_start at output",
                                                                                                    choice=4 "Force y_start at output"));
  parameter Real yps_start[2]={0.33,0.33} "Initial area fraction 1phase | 2phase " annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Basics.Units.Time Tau_cond=0.3 "Time constant of condensation" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Basics.Units.Time Tau_evap=0.03 "Time constant of evaporation" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "HTC of the phase border" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Basics.Units.Area A_phaseBorder=shell.geo.A_hor*100 "Heat transfer area at phase border" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Real expHT_phases=0 "Exponent for volume dependency on inter phase HT" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Real absorbInflow=1 "Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"
                                                                                              annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Boolean equalPressures=true "True if pressure in liquid and vapour phase is equal" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of level calculation (table based)" annotation (Dialog(tab="Expert Settings", group="Mass Accumulation at Shell Side"));

  replaceable model HeatCapacityAveraging =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.ArithmeticMean
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.GeneralMean
                                                                                              "Method for Averaging of heat capacities"
    annotation (Dialog(tab="Expert Settings", group="NTU model"),choicesAllMatching);
  parameter Real gain_eff=1 "Avoid effectiveness > 1, high gain_eff leads to stricter observation but may cause numeric errors"
                                                                                              annotation (Dialog(tab="Expert Settings", group="NTU model"));
  parameter Basics.Units.Time Tau_stab=0.1 "Time constant for numeric stabilisation w.r.t. heat flow rates" annotation (Dialog(tab="Expert Settings", group="NTU model"));

  //________________________________ Shell expert settings  _______________________________________//

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if expert summary should be applied" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                              annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean levelOutput = false "True, if Real level connector shall be addded"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean outputAbs = false "True, if absolute level is at output"  annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone wall(
    length=length,
    redeclare replaceable model Material = WallMaterial,
    N_p=N_passes,
    radius_i=diameter_i/2,
    m_flow_i=tubes.inlet.m_flow,
    alpha_i=ones(3)*tubes.heattransfer.alpha,
    mass_struc=mass_struc,
    N_t=N_tubes,
    radius_o=diameter_o/2,
    h_i_inlet=inStream(tubes.inlet.h_outflow),
    h_o_inlet=inStream(shell.inlet[1].h_outflow),
    m_flow_o=sum(shell.inlet.m_flow),
    alpha_o={shell.heattransfer.alpha[1],shell.heattransfer.alpha[2],shell.heattransfer.alpha[2]},
    redeclare model HeatCapacityAveraging = HeatCapacityAveraging,
    medium_shell=medium_shell,
    medium_tubes=medium_tubes,
    redeclare model HeatExchangerType =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow_L3,
    T_w_i_start=T_w_tube_start,
    T_w_o_start=T_w_shell_start,
    initOption=initOptionWall,
    outerPhaseChange=true,
    p_i=tubes.outlet.p,
    showExpertSummary=showExpertSummary,
    gain_eff=gain_eff,
    Tau_stab=Tau_stab,
    CF_geo=CF_geo,
    p_o=shell.inlet[1].p,
    initOption_yps=initOption_yps,
    yps_start=yps_start,
    xi_i=inStream(tubes.inlet.xi_outflow),
    xi_o=inStream(shell.inlet[1].xi_outflow))
                       annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={56,0})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 tubes(
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
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        z_in={z_in_tubes},
        z_out={z_out_tubes},
        diameter=diameter_i,
        N_tubes=N_tubes,
        N_passes=N_passes,
        length=length),
    showExpertSummary=showExpertSummary,
    initOption=initOptionTubes) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,0})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort shell(
    medium=medium_shell,
    p_nom=p_nom_shell,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_flow_nom_shell,
    useHomotopy=useHomotopy,
    p_start=p_start_shell,
    showExpertSummary=showExpertSummary,
    Tau_cond=Tau_cond,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    A_heat_ph=A_phaseBorder,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    level_rel_start=level_rel_start,
    exp_HT_phases=expHT_phases,
    heatSurfaceAlloc=2,
    redeclare model PhaseBorder = Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow,
        smoothness=smoothness),
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndHotwell (
        CF_geo={1,CF_geo},
        height=height,
        width=width,
        length=length,
        diameter_t=diameter_o,
        N_tubes=N_tubes,
        staggeredAlignment=staggeredAlignment,
        height_hotwell=height_hotwell,
        width_hotwell=width_hotwell,
        length_hotwell=length_hotwell,
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        N_inlet=3,
        z_out={z_out_shell},
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        z_in={z_in_shell,z_in_aux1,z_in_aux2},
        N_passes=N_passes,
        N_rows=N_rows,
        tubeOrientation=0),
    equalPressures=equalPressures,
    initOption=initOptionShell) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));

  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=sum(shell.heat.Q_flow),
      Delta_T_in=shell.summary.inlet[1].T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet[1].T - tubes.summary.outlet.T,
      effectiveness=wall.summary.effectiveness,
      kA=wall.summary.kA,
      kA_nom=1 /(tubes.heattransfer.HR_nom + wall.HR_nom + sum(shell.heattransfer.HR_nom .* yps_nom)),
      level_abs=shell.phaseBorder.level_abs,
      level_rel= shell.phaseBorder.level_rel)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));


   Basics.Interfaces.EyeOut eye2 if showData annotation (Placement(
         transformation(
         extent={{10,-10},{-10,10}},
         rotation=180,
         origin={104,80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,80})));
protected
   Basics.Interfaces.EyeIn eye_int2[1]
     annotation (Placement(transformation(extent={{89,79},{91,81}})));
public
   Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(
         transformation(
         extent={{-10,-10},{10,10}},
         rotation=270,
         origin={28,-98}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-110})));
protected
   Basics.Interfaces.EyeIn eye_int1[1]
     annotation (Placement(transformation(extent={{27,-59},{29,-57}})));

public
  Basics.Interfaces.FluidPortIn       aux1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Basics.Interfaces.FluidPortIn       aux2(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));

  Adapters.Scalar2VectorHeatPort reallocateHeatFlows(     final equalityMode="Equal Temperatures", N=3)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then shell.summary.outline.level_abs else shell.summary.outline.level_rel if levelOutput annotation (Placement(transformation(extent={{204,-126},{224,-106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-110})));

equation


  connect(tubes.inlet, In2) annotation (Line(
      points={{80,-10},{80,-40},{100,-40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{80,10},{80,60},{100,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  assert(diameter_o > diameter_i,
    "Outer diameter of tubes must be greater than inner diameter");

   eye_int1[1].m_flow = shell.summary.outlet[1].m_flow;
   eye_int1[1].T = shell.summary.outlet[1].T - 273.15;
   eye_int1[1].s = shell.fluidOut[1].s/1e3;
   eye_int1[1].p = shell.outlet[1].p/1e5;
   eye_int1[1].h = shell.summary.outlet[1].h/1e3;
   eye_int2[1].m_flow = tubes.summary.outlet.m_flow;
   eye_int2[1].T = tubes.summary.outlet.T - 273.15;
   eye_int2[1].s = tubes.fluidOut.s/1e3;
   eye_int2[1].p = tubes.outlet.p/1e5;
   eye_int2[1].h = tubes.summary.outlet.h/1e3;

  connect(In1, shell.inlet[1]) annotation (Line(
      points={{0,98},{0,10},{1.77636e-015,10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.outlet[1], Out1) annotation (Line(
      points={{-1.77636e-015,-10},{-1.77636e-015,-34},{0,-34},{0,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(aux1, shell.inlet[2]) annotation (Line(
      points={{-100,80},{1.77636e-015,80},{1.77636e-015,10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(aux2, shell.inlet[3]) annotation (Line(
      points={{-100,60},{0,60},{0,40},{1.77636e-015,40},{1.77636e-015,10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.outerPhase[1], reallocateHeatFlows.heatVector[1]) annotation (
      Line(
      points={{47.6667,4.44089e-16},{47.6667,0},{40,0},{40,-0.666667}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.outerPhase[2], reallocateHeatFlows.heatVector[2]) annotation (
      Line(
      points={{47,4.44089e-16},{47,5.55112e-17},{40,5.55112e-17}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.heat, wall.innerPhase[1]) annotation (Line(
      points={{70,0},{65.6667,0}},
      color={167,25,48},
      thickness=0.5));
  connect(tubes.heat, wall.innerPhase[2]) annotation (Line(
      points={{70,0},{65,0}},
      color={167,25,48},
      thickness=0.5));
  connect(tubes.heat, wall.innerPhase[3]) annotation (Line(
      points={{70,0},{64.3333,0}},
      color={167,25,48},
      thickness=0.5));
  connect(eye_int1[1], eye1) annotation (Line(points={{28,-58},{28,-58},{28,-98}}, color={190,190,190}));
  connect(eye_int2[1], eye2) annotation (Line(points={{90,80},{104,80},{104,80}}, color={190,190,190}));
  connect(wall.outerPhase[3], reallocateHeatFlows.heatVector[3]) annotation (Line(
      points={{46.3333,0},{44,0},{44,0.666667},{40,0.666667}},
      color={167,25,48},
      thickness=0.5));
  connect(reallocateHeatFlows.heatScalar, shell.heat[1]) annotation (Line(
      points={{20,0},{9.5,0}},
      color={167,25,48},
      thickness=0.5));
  connect(reallocateHeatFlows.heatScalar, shell.heat[2]) annotation (Line(
      points={{20,0},{10.5,0}},
      color={167,25,48},
      thickness=0.5));
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
            -100},{100,100}}),
                   graphics={Text(
          extent={{-86,98},{86,58}},
          lineColor={27,36,42},
          textString="NTU")}),Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end HEXvle2vle_L3_2ph_BU_ntu;
