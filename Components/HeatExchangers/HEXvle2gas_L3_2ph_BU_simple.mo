within ClaRa.Components.HeatExchangers;
model HEXvle2gas_L3_2ph_BU_simple "VLE 2 gas | L3 | 1 phase on each side | Block shape | U-type |"
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
    input ClaRa.Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    input ClaRa.Basics.Units.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    input ClaRa.Basics.Units.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA if showExpertSummary "Overall heat transmission";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom if showExpertSummary "Nominal overall heat transmission";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  // Parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter TILMedia.Gas.Types.BaseGas medium1=simCenter.flueGasModel "Medium to be used for gas flow"
    annotation (Dialog(tab="Shell Side", group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransfer_Shell =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_only "Heat transfer model at shell side"  annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model at shell side"  annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter ClaRa.Basics.Units.Length length=10 "Length of the HEX" annotation (Dialog(
      tab="Shell Side",
      group="Geometry",
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialog_BUshellgas2.png"));
  parameter ClaRa.Basics.Units.Length height=3 "Height of HEX" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length width=3 "Width of HEX" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_shell=height "Inlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_shell=0.1 "Outlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Choices.GeometryOrientation flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "Orientation of shell side flow"
                                                                                              annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself" annotation (Dialog(tab="Shell Side", group="Geometry"));

  parameter ClaRa.Basics.Units.MassFlowRate m_nom1=10 "Nominal mass flow on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom1=10 "Nominal pressure on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom1=10 "Nominal specific enthalpy on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Temperature T_start_shell=273.15 + 100 "Start value of system Temperature" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_shell=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_shell_start[medium1.nc - 1]=medium1.xi_default "|Shell Side|Initialisation|Start value of shell mass fraction";
  inner parameter Integer initOptionShell=0 "Type of shell initialisation" annotation (Dialog(tab="Shell Side", group="Initialisation"), choices(
       choice=0 "Use guess values",
       choice=1 "Steady state",
       choice=201 "Steady pressure",
       choice=202 "Steady enthalpy",
       choice=208 "Steady pressure and enthalpy",
       choice=210 "Steady density"));

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium2=simCenter.fluid1 "Medium to be used for water/steam flow"
    annotation (Dialog(tab="Tubes", group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransferTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeTypeVLE_L3
                                                                                      "Heat transfer mode at the tubes side" annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "Pressure loss model at the tubes side" annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);

  parameter ClaRa.Basics.Units.Length diameter_i=0.048 "Inner diameter of horizontal tubes" annotation (Dialog(
      tab="Tubes",
      group="Geometry",
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialogTubes.png"));
  parameter ClaRa.Basics.Units.Length diameter_o=0.05 "Outer diameter of horizontal tubes" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"  annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Boolean parallelTubes=false "True, if tubes are parallel to shell flow orientation" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_tubes=length/2 "Inlet position from bottom" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_tubes=length/2 "Outlet position from bottom" annotation (Dialog(tab="Tubes", group="Geometry"));

  parameter Basics.Units.Length height_hotwell=1 "Height of the hotwell" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length width_hotwell=1 "Width of the hotwell" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length length_hotwell=1 "Length of the hotwell" annotation (Dialog(tab="Tubes", group="Geometry"));

  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length Delta_z_par=1.5*diameter_o
                                                         "Distance between tubes parallel to flow direction" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length Delta_z_ort=1.5*diameter_o
                                                         "Distance between tubes orthogonal to flow direction" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_rows=integer(ceil(sqrt(N_tubes))*N_passes) "Number of pipe rows in shell flow direction (minimum = N_passes)" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Real CF_geo=1 "Correction coefficient of heat transfer area" annotation (Dialog(tab="Tubes", group="Geometry"));

  parameter ClaRa.Basics.Units.MassFlowRate m_nom2=10 "Nominal mass flow on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom2=10 "Nominal pressure on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom2=10 "Nominal specific enthalpy on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Real yps_liq_nom=level_rel_start "Relative volume of liquid phase at nominal point" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  final parameter Real yps_nom[2]={yps_liq_nom, 1-yps_liq_nom} "Relative volume of liquid phase [1] and vapour phase [2] at nominal point";


  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(                                     medium2, p_start_tubes) "Start value of liquid specific enthalpy" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vap_start=+10 + TILMedia.VLEFluid.MixtureCompatible.Functions.dewSpecificEnthalpy_pxi(                                     medium2, p_start_tubes) "Start value of vapour specific enthalpy" annotation (Dialog(tab="Tubes", group="Initialisation"));

  parameter ClaRa.Basics.Units.Pressure p_start_tubes=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Real level_rel_start=0.5 "Start value for relative filling Level" annotation (Dialog(tab="Tubes", group="Initialisation"));
  inner parameter Integer initOptionTubes = 0 "Type of initialisation"
    annotation (Dialog(tab= "Tubes", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume",
                                                                                              choice=201 "Steady vapour pressure",
                                                                                              choice = 202 "Steady enthalpy",
                                                                                              choice=204 "Fixed volume fraction",
                                                                                              choice=211 "Fixed values in level, enthalpies and vapour pressure"));

  replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum
    constrainedby TILMedia.Solid.Types.BaseSolid
                                                "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Tube Wall", group="Fundamental Definitions"));
  parameter Integer initOptionWall=213 "Init Option of Wall"
    annotation (Dialog(tab="Tube Wall", group="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));
  parameter Basics.Units.Temperature T_w_i_start=293.15 "Initial wall temperature at inner phase" annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  parameter Basics.Units.Temperature T_w_a_start=293.15 "Initial wall temperature at outer phase" annotation (Dialog(tab="Tube Wall", group="Initialisation"));

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Basics.Units.Time Tau_cond=0.3 "Time constant of condensation" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Basics.Units.Time Tau_evap=0.03 "Time constant of evaporation" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "HTC of the phase border" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Basics.Units.Area A_phaseBorder=shell.geo.A_hor*100 "Heat transfer area at phase border" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Real expHT_phases=0 "Exponent for volume dependency on inter phase HT" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Real absorbInflow=1 "Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"
                                                                                              annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));
  parameter Boolean equalPressures=true "True if pressure in liquid and vapour phase is equal" annotation (Dialog(tab="Expert Settings", group="Zone Interaction at Shell Side"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True if expert summary should be applied" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                              annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean levelOutput = false "True, if Real level connector shall be addded"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean outputAbs = false "True, if absolute level is at output"  annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium2)
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium2)
    annotation (Placement(transformation(extent={{88,50},{108,70}}),
        iconTransformation(extent={{88,50},{108,70}})));
  ClaRa.Basics.Interfaces.GasPortIn In1(Medium=medium1)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  ClaRa.Basics.Interfaces.GasPortOut Out1(Medium=medium1) "Outlet port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZones tubes(
    medium=medium2,
    p_nom=p_nom2,
    m_flow_nom=m_nom2,
    useHomotopy=useHomotopy,
    p_start=p_start_tubes,
    redeclare model PressureLoss = PressureLossTubes,
    showExpertSummary=showExpertSummary,
    redeclare model HeatTransfer = HeatTransferTubes,
    level_rel_start=level_rel_start,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.PipeWithHotwell (
        z_in={z_in_tubes},
        z_out={z_out_tubes},
        diameter=diameter_i,
        N_tubes=N_tubes,
        N_passes=N_passes,
        length=if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then if parallelTubes then height else width else if parallelTubes then length else height,
        height_hotwell=height_hotwell,
        width_hotwell=width_hotwell,
        length_hotwell=length_hotwell),
    redeclare model PhaseBorder = Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated,
    Tau_cond=Tau_cond,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    expHT_phases=expHT_phases,
    A_heat_ph=A_phaseBorder,
    initOption=initOptionTubes) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={70,0})));

  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 shell(
    medium=medium1,
    p_nom=p_nom1,
    h_nom=h_nom1,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_nom1,
    useHomotopy=useHomotopy,
    T_start=T_start_shell,
    p_start=p_start_shell,
    xi_start=xi_shell_start,
    heatSurfaceAlloc=2,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes (
        z_out={z_out_shell},
        height=height,
        width=width,
        length=length,
        diameter_t=diameter_o,
        N_tubes=N_tubes,
        N_passes=N_passes,
        z_in={z_in_shell},
        CF_geo={1,CF_geo},
        flowOrientation=flowOrientation,
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        staggeredAlignment=staggeredAlignment,
        N_rows=N_rows,
        tubeOrientation=if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical and parallelTubes == false then 0 elseif flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical and parallelTubes == true then 2 elseif flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.horizontal and parallelTubes == false then 1 elseif flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.horizontal and parallelTubes == true then 0 else 0),
    initOption=initOptionShell) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));
  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=shell.heat.Q_flow,
      Delta_T_in=shell.flueGasInlet.T - tubes.summary.inlet.T,
      Delta_T_out=shell.flueGasOutlet.T - tubes.summary.outlet.T,
      kA=1/(sum(tubes.heattransfer.HR.* tubes.summary.outline.yps) + wall.HR + shell.heattransfer.HR),
      kA_nom=1/(sum(tubes.heattransfer.HR_nom .* yps_nom) + wall.HR_nom + shell.heattransfer.HR_nom)))         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));

  Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,80})));
protected
  Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{71,79},{73,81}})));

public
  Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    redeclare model Material = WallMaterial,
    T_start=linspace(T_w_i_start, T_w_a_start, 3),
    initOption=initOptionWall,
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    length=N_passes*length,
    N_tubes=N_tubes,
    N_passes=N_passes,
    mass_struc=mass_struc,
    N_rad=3,
    sizefunc=+1) annotation (Placement(transformation(
        extent={{-10,-7.5},{10,7.5}},
        rotation=90,
        origin={33.5,0})));

//   Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then tubes.summary.outline.level_abs else tubes.summary.outline.level_rel if levelOutput annotation (Placement(transformation(extent={{204,-126},{224,-106}}), iconTransformation(
//         extent={{-10,-10},{10,10}},
//         rotation=270,
//         origin={80,-110})));


  Modelica.Blocks.Interfaces.RealOutput level_abs_ = tubes.summary.outline.level_abs;
  Modelica.Blocks.Interfaces.RealOutput level_rel_ = tubes.phaseBorder.level_rel;

  Modelica.Blocks.Interfaces.RealOutput level if levelOutput annotation (Placement(transformation(extent={{204,-126},{224,-106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-110})));

//   Modelica.Blocks.Sources.RealExpression level_abs_(y=tubes.summary.outline.level_abs);
//   Modelica.Blocks.Sources.RealExpression level_rel_(y=tubes.phaseBorder.level_rel);

equation
  assert(diameter_o > diameter_i,
    "Outer diameter of tubes must be greater than inner diameter");
  if outputAbs then
    connect(level_abs_, level);
  else
      connect(level_rel_, level);
  end if;

  eye_int[1].m_flow = tubes.summary.outlet.m_flow;
  eye_int[1].T = tubes.summary.outlet.T - 273.15;
  eye_int[1].s = tubes.fluidOut.s/1e3;
  eye_int[1].p = tubes.outlet.p/1e5;
  eye_int[1].h = tubes.summary.outlet.h/1e3;
  connect(tubes.inlet, In2) annotation (Line(
      points={{70,-10},{70,-40},{100,-40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{70,10},{70,60},{98,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.outlet, Out1) annotation (Line(
      points={{0,-10},{0,-10},{0,-100}},
      color={118,106,98},
      thickness=0.5));
  connect(shell.inlet, In1) annotation (Line(
      points={{0,10},{0,10},{0,98}},
      color={118,106,98},
      thickness=0.5));
  connect(eye_int[1], eye) annotation (Line(points={{72,80},{100,80},{100,80}}, color={190,190,190}));
  connect(shell.heat, wall.outerPhase) annotation (Line(
      points={{10,0},{25.9,0}},
      color={167,25,48},
      thickness=0.5));
  connect(wall.innerPhase, tubes.heat) annotation (Line(
      points={{40.7,-0.2},{51.35,-0.2},{51.35,0},{60,0}},
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
                   graphics), Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})));
end HEXvle2gas_L3_2ph_BU_simple;
