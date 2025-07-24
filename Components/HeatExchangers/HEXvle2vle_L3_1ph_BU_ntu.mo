within ClaRa.Components.HeatExchangers;
model HEXvle2vle_L3_1ph_BU_ntu "VLE 2 VLE | L3 | 1 phase on each side | Block shape | U-type | NTU Ansatz"
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

  import SI = ClaRa.Basics.Units;
  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX01;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    input Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    input Basics.Units.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    input Basics.Units.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
    input Real effectiveness if showExpertSummary "Effectivenes of HEX";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA if showExpertSummary "Overall heat transmission";
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom if showExpertSummary "Nominal overall heat transmission";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  // General parameters and other user definable settings~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatExchangerType =
      Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow
      constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger "Type of Heat Exchanger"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  //*********************************** / SHELL SIDE \ ***********************************//
  //________________________________ Shell fundamentals _______________________________//
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium_shell=simCenter.fluid1 "Medium to be used  for flow 1"
    annotation (Dialog(tab="Shell Side", group="Fundamental Definitions"), choicesAllMatching);

  replaceable model HeatTransfer_Shell =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellTypeVLE_L2
                                                                                      "Heat transfer model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);

  replaceable model PressureLossShell =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model at shell side"
                                        annotation (Dialog(tab="Shell Side",
        group="Fundamental Definitions"), choicesAllMatching);

  //________________________________ Shell geometry _______________________________//
  parameter Basics.Units.Length length=2 "Length of the HEX" annotation (Dialog(
      tab="Shell Side",
      group="Geometry",
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialog_BUshell1ph.png"));
  parameter Basics.Units.Length height=7 "Height of HEX" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length width=2 "Width of HEX" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_in_shell=height "Inlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Units.Length z_out_shell=0.1 "Outlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Basics.Choices.GeometryOrientation flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "Flow orientation at shell side"
                                       annotation(Dialog(tab="Shell Side", group="Geometry"));
  parameter Integer tubeOrientation=0 "Tube orientation" annotation(Dialog(tab="Shell Side", group="Geometry"), choices(
      choice=0 "Lengthwise",
      choice=1 "Widthwise",
      choice=2 "Heightwise"));

  //________________________________ Shell nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_nom_shell=40 "Nominal mass flow on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_shell=35e5 "Nominal pressure on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_shell=3500e3 "Nominal specific enthalpy on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));

  //________________________________ Shell initialisation  _______________________________________//
  parameter Basics.Units.EnthalpyMassSpecific h_start_shell=100e3 "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter Basics.Units.Pressure p_start_shell=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Shell Side", group="Initialisation"));

  //*********************************** / TUBE SIDE \ ***********************************//
  //________________________________ Tubes fundamentals _______________________________//
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium_tubes=simCenter.fluid1 "Medium to be used for flow 2"
    annotation (Dialog(tab="Tubes", group="Fundamental Definitions"), choicesAllMatching);

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
  parameter Basics.Units.Length diameter_i=0.019 "Inner diameter of horizontal tubes" annotation (Dialog(
      tab="Tubes",
      group="Tubes Geometry",
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialogTubes.png"));
  parameter Basics.Units.Length diameter_o=0.027 "Outer diameter of horizontal tubes" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Integer N_tubes=210 "Number of horizontal tubes"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Integer N_passes=integer(floor(230/(3.14159*diameter_o*width*N_tubes))) "Number of passes of the internal tubes"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Basics.Units.Length z_in_tubes=height "Inlet position from bottom" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Basics.Units.Length z_out_tubes=0.1 "Outlet position from bottom" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly"    annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Basics.Units.Length Delta_z_par=1.5*diameter_o "Distance between tubes parallel to flow direction" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Basics.Units.Length Delta_z_ort=1.5*diameter_o "Distance between tubes orthogonal to flow direction" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  parameter Integer N_rows(min=N_passes,max=N_tubes)=integer(ceil(sqrt(N_tubes))*N_passes)
                                                                "Number of pipe rows in shell flow direction" annotation (Dialog(tab="Tubes", group="Tubes Geometry"));
  //________________________________ Tubes nominal parameter _____________________________________//
  parameter Basics.Units.MassFlowRate m_nom_tubes=400 "Nominal mass flow on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom_tubes=400e5 "Nominal pressure on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom_tubes=10 "Nominal specific enthalpy on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate" annotation (Dialog(tab="Tubes", group="Nominal Values"));

  //________________________________ Tubes initialisation _______________________________________//
  parameter Integer initOptionShell=0 "Type of initialisation"
    annotation (Dialog(tab="Shell Side", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                              choice = 202 "Steady enthalpy"));
  parameter Basics.Units.EnthalpyMassSpecific h_start_tubes=100e3 "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Basics.Units.Pressure p_start_tubes=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Integer initOptionTubes=0 "Type of initialisation"
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
  parameter Basics.Units.Mass mass_struc=25000 "Mass of inner structure elements, additional to the tubes itself" annotation (Dialog(tab="Tube Wall", group="Fundamental Definitions"));
  parameter Integer initOptionWall=0 "|Initialisation option for wall"    annotation (Dialog(tab="Tube Wall", group="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state"));
  parameter Basics.Units.Temperature T_w_i_start=293.15 "Initial wall temperature at inner side" annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  parameter Basics.Units.Temperature T_w_o_start=293.15 "Initial wall temperature at shell side" annotation (Dialog(tab="Tube Wall", group="Initialisation"));

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
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L2 wall(
    length=length,
    redeclare replaceable model Material = WallMaterial,
    N_p=N_passes,
    radius_i=diameter_i/2,
    radius_o=diameter_o/2,
    T_i_in=tubes.fluidIn.T,
    T_a_in=shell.fluidIn.T,
    m_flow_i=tubes.inlet.m_flow,
    m_flow_a=shell.inlet.m_flow,
    alpha_i=tubes.heattransfer.alpha,
    alpha_o=shell.heattransfer.alpha,
    mass_struc=mass_struc,
    N_t=N_tubes,
    cp_mean_i=(tubes.fluidIn.cp + tubes.fluidOut.cp)/2,
    cp_mean_a=(shell.fluidIn.cp + shell.fluidOut.cp)/2,
    T_w_i_start=T_w_i_start,
    T_w_a_start=T_w_o_start,
    redeclare model HeatExchangerType = HeatExchangerType,
    initOption=initOptionWall) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,0})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 tubes(
    medium=medium_tubes,
    useHomotopy=useHomotopy,
    h_start=h_start_tubes,
    p_start=p_start_tubes,
    redeclare model HeatTransfer = HeatTransferTubes,
    redeclare model PressureLoss = PressureLossTubes,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    m_flow_nom=m_nom_tubes,
    p_nom=p_nom_tubes,
    h_nom=h_nom_tubes,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        z_in={z_in_tubes},
        z_out={z_out_tubes},
        diameter=diameter_i,
        N_tubes=N_tubes,
        N_passes=N_passes,
        length=if tubeOrientation == 0 then length elseif tubeOrientation == 1 then width elseif tubeOrientation == 2 then height else length),
    initOption=initOptionTubes) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,0})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 shell(
    medium=medium_shell,
    redeclare model HeatTransfer = HeatTransfer_Shell,
    redeclare model PressureLoss = PressureLossShell,
    useHomotopy=useHomotopy,
    h_start=h_start_shell,
    p_start=p_start_shell,
    m_flow_nom=m_nom_shell,
    p_nom=p_nom_shell,
    h_nom=h_nom_shell,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes (
        z_out={z_out_shell},
        height=height,
        width=width,
        length=length,
        diameter_t=diameter_o,
        N_tubes=N_tubes,
        N_passes=N_passes,
        z_in={z_in_shell},
        flowOrientation=flowOrientation,
        N_rows=N_rows,
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        tubeOrientation=tubeOrientation),
    final heatSurfaceAlloc=2,
    initOption=initOptionShell) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));

  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=shell.heat.Q_flow,
      Delta_T_in=shell.summary.inlet.T - tubes.summary.inlet.T,
      Delta_T_out=shell.summary.outlet.T - tubes.summary.outlet.T,
      effectiveness=wall.effectiveness,
      kA=wall.kA,
      kA_nom=1 /(tubes.heattransfer.HR_nom + wall.HR_nom + shell.heattransfer.HR_nom)))
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));

  Basics.Interfaces.EyeOut eye2 if showData annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-100,-42}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-100,-42})));
protected
  Basics.Interfaces.EyeIn eye_int2[1]
    annotation (Placement(transformation(extent={{-51,-43},{-49,-41}})));
public
  Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,-98}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,-98})));
protected
  Basics.Interfaces.EyeIn eye_int1[1]
    annotation (Placement(transformation(extent={{27,-59},{29,-57}})));

equation
  assert(diameter_o > diameter_i,
    "Outer diameter of tubes must be greater than inner diameter");

  eye_int1[1].m_flow = shell.summary.outlet.m_flow;
  eye_int1[1].T = shell.summary.outlet.T - 273.15;
  eye_int1[1].s = shell.fluidOut.s/1e3;
  eye_int1[1].p = shell.outlet.p/1e5;
  eye_int1[1].h = shell.summary.outlet.h/1e3;
  eye_int2[1].m_flow = tubes.summary.outlet.m_flow;
  eye_int2[1].T = tubes.summary.outlet.T - 273.15;
  eye_int2[1].s = tubes.fluidOut.s/1e3;
  eye_int2[1].p = tubes.outlet.p/1e5;
  eye_int2[1].h = tubes.summary.outlet.h/1e3;
initial equation
  //        wall.T=(Tubes.bulk.T+shell.bulk.T)/2;


equation
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
  connect(tubes.heat, wall.innerPhase) annotation (Line(
      points={{60,6.66134e-016},{42.5,6.66134e-016},{42.5,-4.44089e-016},{39,-4.44089e-016}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(shell.inlet, In1) annotation (Line(
      points={{1.83697e-015,10},{1.83697e-015,74},{0,74},{0,98}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shell.heat, wall.outerPhase) annotation (Line(
      points={{10,-1.77636e-015},{21,-1.77636e-015},{21,4.44089e-016}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(shell.outlet, Out1) annotation (Line(
      points={{-1.83697e-015,-10},{0,-10},{0,-100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_int2[1], eye2) annotation (Line(
      points={{-50,-42},{-100,-42}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int1[1], eye1) annotation (Line(
      points={{28,-58},{28,-98}},
      color={190,190,190},
      smooth=Smooth.None));
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
          extent={{-86,92},{86,52}},
          lineColor={27,36,42},
          textString="NTU")}));
end HEXvle2vle_L3_1ph_BU_ntu;
