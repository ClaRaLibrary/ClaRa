within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_1ph_kA " VLE 2 VLE | L3 | 1 phase on each side | generic geometry | effective kA"
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

  import      Modelica.Units.SI;
  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX01;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    input ClaRa.Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    input ClaRa.Basics.Units.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    input ClaRa.Basics.Units.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    input Real effectiveness if showExpertSummary "Effectivenes of HEX";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA if showExpertSummary "Overall heat transmission";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom if showExpertSummary "Overall heat transmission at nominal point";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  //*********************************** / SHELL SIDE \ ***********************************//
  //________________________________ Shell fundamentals _______________________________//
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium_shell=simCenter.fluid1 "Medium to be used  for flow 1"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellTypeVLE_L2
                                                                                     "Pressure loss model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Shell geometry _______________________________//
  parameter ClaRa.Basics.Units.Volume volume_shell=1 "Volume of the shell side" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_in_shell=1 "Inlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_out_shell=1 "Outlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));

  //________________________________ Shell nominal parameter _____________________________________//

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom_shell=10 "Nominal mass flow on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom_shell=10 "Nominal pressure on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter SI.SpecificEnthalpy h_nom_shell=10 "Nominal specific enthalpy on shell side"
    annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//
  parameter SI.SpecificEnthalpy h_start_shell=1e5 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_shell=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Integer initOptionShell=0 "Type of initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                              choice = 202 "Steady enthalpy"));

  //*********************************** / TUBE SIDE \ ***********************************//
  //________________________________ Tubes fundamentals _______________________________//

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium_tubes=simCenter.fluid1 "Medium to be used for flow 2"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeTypeVLE_L2
                                                                                    "Pressure loss model at the tubes side"
                                            annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Tubes geometry _______________________________//
  parameter ClaRa.Basics.Units.Volume volume_tubes=1 "Volume of the tubes" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length z_in_tubes=1 "Inlet position from bottom" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length z_out_tubes=1 "Outlet position from bottom" annotation (Dialog(tab="Tubes", group="Geometry"));
  //________________________________ Tubes nominal parameter _____________________________________//
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom_tubes=10 "Nominal mass flow on tube side" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom_tubes=10 "Nominal pressure on tube side" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter SI.SpecificEnthalpy h_nom_tubes=10 "Nominal specific enthalpy on tube side"
    annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate" annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //________________________________ Tubes initialisation _______________________________________//
  parameter SI.SpecificEnthalpy h_start_tubes=1e5 "Start value of sytsem specific enthalpy at tube side"
    annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_tubes=1e5 "Start value of sytsem pressure at tube side" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Integer initOptionTubes=0 "Type of initialisation at tube side"
    annotation (Dialog(tab="Tubes", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                              choice = 202 "Steady enthalpy"));

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum
    constrainedby TILMedia.Solid.Types.BaseSolid
                                                "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Tube Wall", group=
          "Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of inner components (tubes + structural elements)" annotation (Dialog(tab="Tube Wall", group="Fundamental Definitions"));
  //________________________________ Wall initialisation _______________________________________//
  parameter Basics.Units.Temperature T_w_i_start=293.15 "Initial temperature at inner phase" annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  parameter Basics.Units.Temperature T_w_o_start=293.15 "Initial temperature at outer phase" annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  parameter Integer initOptionWall=0 "|Initialisation option for wall"    annotation (Dialog(tab="Tube Wall", group="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state"));

//*******************************General *************************************************//
  parameter Boolean tubesLimitHeatFlow = true "True if the tube side heat transfer limits overall performance" annotation(Dialog(tab="General", group="Heat Exchanger Definition"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom=50000 "The product kA - nominal value" annotation(Dialog(tab="General", group="Heat Exchanger Definition"));
  parameter Real CL_kA_mflow[:, 2]=[0,0;0.4, 0.5; 0.5, 0.75; 0.75, 0.95;
      1, 1] "Characteristic line kA = f(m_flow/m_flow_nom)" annotation(Dialog(tab="General", group="Heat Exchanger Definition"));
  replaceable model HeatExchangerType =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger "Heat exchanger type"
                                                                                              annotation(choicesAllMatching, Dialog(tab="General", group="Heat Exchanger Definition"));
//   parameter Real CF_geo=1
//     "|Heat Exchanger Definition|Correction coefficient due to fins etc.";

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}), iconTransformation(extent={{90,-70},{110,-50}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium_tubes)
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In1(Medium=medium_shell)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 tubes(
    final heatSurfaceAlloc=1,
    medium=medium_tubes,
    p_nom=p_nom_tubes,
    h_nom=h_nom_tubes,
    m_flow_nom=m_flow_nom_tubes,
    useHomotopy=useHomotopy,
    h_start=h_start_tubes,
    p_start=p_start_tubes,
    redeclare model PressureLoss = PressureLossTubes,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=volume_tubes,
        z_in={z_in_tubes},
        z_out={z_out_tubes},
        N_heat=1),
    initOption=initOptionTubes) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,0})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 shell(
    medium=medium_shell,
    p_nom=p_nom_shell,
    h_nom=h_nom_shell,
    redeclare model PressureLoss = PressureLossShell,
    m_flow_nom=m_flow_nom_shell,
    useHomotopy=useHomotopy,
    h_start=h_start_shell,
    p_start=p_start_shell,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    showExpertSummary=showExpertSummary,
    final heatSurfaceAlloc=1,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=volume_shell,
        z_in={z_in_shell},
        z_out={z_out_shell},
        N_heat=1),
    initOption=initOptionShell) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));

  Basics.ControlVolumes.SolidVolumes.NTU_L2_effectiveResistance wall(
    mass_struc=mass_struc,
    stateLocation=2,
    T_i_in=tubes.fluidIn.T,
    T_a_in=shell.fluidIn.T,
    m_flow_i=tubes.inlet.m_flow,
    m_flow_a=shell.inlet.m_flow,
    cp_mean_i=(tubes.fluidIn.cp + tubes.fluidOut.cp)/2,
    cp_mean_a=(shell.fluidIn.cp + shell.fluidOut.cp)/2,
    kA_nom=kA_nom,
    redeclare model Material = WallMaterial,
    CL_kA_mflow=CL_kA_mflow,
    redeclare model HeatExchangerType = HeatExchangerType,
    T_w_i_start=T_w_i_start,
    T_w_a_start=T_w_o_start,
    m_flow_nom=if tubesLimitHeatFlow then m_flow_nom_tubes else
        m_flow_nom_shell,
    innerSideLimitsHeatFlow=tubesLimitHeatFlow,
    initOption=initOptionWall) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,0})));

  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=shell.heat.Q_flow,
      Delta_T_in=shell.summary.inlet.T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet.T - tubes.summary.outlet.T,
      effectiveness=wall.effectiveness,
      kA=wall.kA_nom*wall.partLoad_kA.y[1],
      kA_nom=kA_nom))
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));
  Basics.Interfaces.EyeOut eye2 if showData annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,-86}),  iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,-90})));
protected
  Basics.Interfaces.EyeIn eye_int2[1]
    annotation (Placement(transformation(extent={{63,-87},{65,-85}})));
protected
  Basics.Interfaces.EyeIn eye_int1[1]
    annotation (Placement(transformation(extent={{27,-59},{29,-57}})));
public
  Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-110}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-110})));
initial equation
  //        wall.T=(tubes.bulk.T+shell.bulk.T)/2;

equation
  eye_int1[1].m_flow = shell.summary.outlet.m_flow;
  eye_int1[1].T=shell.summary.outlet.T-273.15;
  eye_int1[1].s=shell.fluidOut.s/1000;
  eye_int1[1].h=shell.summary.outlet.h/1000;
  eye_int1[1].p=shell.summary.outlet.p/100000;

eye_int2[1].m_flow = tubes.summary.outlet.m_flow;
  eye_int2[1].T=tubes.summary.outlet.T-273.15;
  eye_int2[1].s=tubes.fluidOut.s/1000;
  eye_int2[1].h=tubes.summary.outlet.h/1000;
  eye_int2[1].p=tubes.summary.outlet.p/100000;
  connect(tubes.inlet, In2) annotation (Line(
      points={{70,-10},{70,-60},{100,-60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tubes.outlet, Out2) annotation (Line(
      points={{70,10},{70,60},{100,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.inlet, In1) annotation (Line(
      points={{1.77636e-015,10},{1.77636e-015,74},{0,74},{0,98}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.outlet, Out1) annotation (Line(
      points={{-1.77636e-015,-10},{0,-10},{0,-100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.innerPhase, tubes.heat) annotation (Line(
      points={{39,-4.44089e-016},{39,4.44089e-016},{60,4.44089e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wall.outerPhase, shell.heat) annotation (Line(
      points={{21,4.44089e-016},{21,-1.77636e-015},{10,-1.77636e-015}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eye_int1[1], eye1) annotation (Line(points={{28,-58},{30,-58},{30,-110}}, color={190,190,190}));
  connect(eye2, eye_int2[1]) annotation (Line(points={{100,-86},{100,-86},{64,-86}},
                                                                                color={190,190,190}));
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
          extent={{-90,94},{82,54}},
          lineColor={27,36,42},
          textString="NTU")}),Diagram(graphics,
                                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end HEXvle2vle_L3_1ph_kA;
