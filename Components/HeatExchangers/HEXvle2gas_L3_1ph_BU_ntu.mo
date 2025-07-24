within ClaRa.Components.HeatExchangers;
model HEXvle2gas_L3_1ph_BU_ntu "VLE 2 gas | L3 | 1 phase on each side | Block shape | U-type | NTU ansatz"
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
    input ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom if showExpertSummary "Nominal overall heat transmission";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;



  model CF_geo_fin
    Modelica.Blocks.Interfaces.RealInput u;
    Modelica.Blocks.Interfaces.RealOutput y=u;
  end CF_geo_fin;

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
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialog_BUshellgas.png"));
  parameter ClaRa.Basics.Units.Length height=3 "Height of HEX" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length width=3 "Width of HEX" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_shell=height "Inlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_shell=0.1 "Outlet position from bottom" annotation (Dialog(tab="Shell Side", group="Geometry"));

  parameter Basics.Choices.GeometryOrientation flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "Orientation of shell side flow"
                                                                                              annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of inner structure elements, additional to the tubes itself" annotation (Dialog(tab="Shell Side", group="Geometry"));
  parameter Integer tubeOrientation=0 "Tube orientation" annotation(Dialog(tab="Shell Side", group="Geometry"), choices(
      choice=0 "Lengthwise",
      choice=1 "Widthwise",
      choice=2 "Heightwise"));
  parameter ClaRa.Basics.Units.MassFlowRate m_nom1=10 "Nominal mass flow on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom1=10 "Nominal pressure on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom1=10 "Nominal specific enthalpy on shell side" annotation (Dialog(tab="Shell Side", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Temperature T_start_shell=273.15 + 100 "Start value of system Temperature" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_shell=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Shell Side", group="Initialisation"));
  inner parameter Integer initOptionShell=0 "Type of shell initialisation" annotation (Dialog(tab="Shell Side", group="Initialisation"), choices(
       choice=0 "Use guess values",
       choice=1 "Steady state",
       choice=201 "Steady pressure",
       choice=202 "Steady enthalpy",
       choice=208 "Steady pressure and enthalpy",
       choice=210 "Steady density"));
  parameter ClaRa.Basics.Units.MassFraction xi_shell_start[medium1.nc - 1]=medium1.xi_default "|Shell Side|Initialisation|Start value of shell mass fraction";

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium2=simCenter.fluid1 "Medium to be used for water/steam flow"
    annotation (Dialog(tab="Tubes", group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransferTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeTypeVLE_L2
                                                                                      "Heat transfer mode at the tubes side" annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model at the tubes side" annotation (Dialog(tab="Tubes",
        group="Fundamental Definitions"), choicesAllMatching);

  replaceable model HeatExchangerType =
      Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow
      constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger "Type of Heat Exchanger"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length diameter_i=0.048 "Inner diameter of horizontal tubes" annotation (Dialog(
      tab="Tubes",
      group="Geometry",
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialogTubes.png"));
  parameter ClaRa.Basics.Units.Length diameter_o=0.05 "Outer diameter of horizontal tubes" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_tubes=1000 "Number of horizontal tubes" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"  annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_tubes=length/2 "Inlet position from bottom" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_tubes=length/2 "Outlet position from bottom" annotation (Dialog(tab="Tubes", group="Geometry"));

  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length Delta_z_par=1.5*diameter_o "Distance between tubes parallel to flow direction" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Basics.Units.Length Delta_z_ort=1.5*diameter_o "Distance between tubes orthogonal to flow direction" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Integer N_rows=integer(ceil(sqrt(N_tubes))*N_passes) "Number of pipe rows in shell flow direction (minimum = N_passes)" annotation (Dialog(tab="Tubes", group="Geometry"));
  parameter Real CF_geo=1 "Correction coefficient of heat transfer area" annotation (Dialog(tab="Tubes", group="Geometry"));

  parameter ClaRa.Basics.Units.MassFlowRate m_nom2=10 "Nominal mass flow on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom2=10 "Nominal pressure on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom2=10 "Nominal specific enthalpy on side 2" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_nom=1e6 "Nominal heat flow rate" annotation (Dialog(tab="Tubes", group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start_tubes=1e5 "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_tubes=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Tubes", group="Initialisation"));
  parameter Integer initOptionTubes=0 "Type of initialisation at tube side"
    annotation (Dialog(tab="Tubes", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                              choice = 202 "Steady enthalpy"));

  replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum
    constrainedby TILMedia.Solid.Types.BaseSolid
                                                "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Tube Wall", group="Fundamental Definitions"));
  parameter Integer initOptionWall=0 "Init Option of Wall"
    annotation (Dialog(tab="Tube Wall", group="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature"));
  parameter Basics.Units.Temperature T_w_i_start=293.15 "Initial wall temperature at inner phase" annotation (Dialog(tab="Tube Wall", group="Initialisation"));
  parameter Basics.Units.Temperature T_w_a_start=293.15 "Initial wall temperature at outer phase" annotation (Dialog(tab="Tube Wall", group="Initialisation"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True if expert summary should be applied" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                              annotation (Dialog(tab="Summary and Visualisation"));

  ClaRa.Basics.Interfaces.FluidPortIn In2(Medium=medium2)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out2(Medium=medium2)
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  ClaRa.Basics.Interfaces.GasPortIn In1(Medium=medium1)
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  ClaRa.Basics.Interfaces.GasPortOut Out1(Medium=medium1) "Outlet port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L2 wall(
    length=length,
    redeclare replaceable model Material = WallMaterial,
    N_p=N_passes,
    radius_i=diameter_i/2,
    radius_o=diameter_o/2,
    T_i_in=tubes.fluidIn.T,
    m_flow_i=tubes.inlet.m_flow,
    m_flow_a=shell.inlet.m_flow,
    alpha_i=tubes.heattransfer.alpha,
    alpha_o=shell.heattransfer.alpha,
    cp_mean_i=(tubes.fluidIn.cp + tubes.fluidOut.cp)/2,
    mass_struc=mass_struc,
    N_t=N_tubes,
    T_a_in=shell.flueGasInlet.T,
    cp_mean_a=(shell.flueGasInlet.cp + shell.flueGasOutlet.cp)/2,
    T_w_i_start=T_w_i_start,
    T_w_a_start=T_w_a_start,
    initOption=initOptionWall,
    showExpertSummary=showExpertSummary,
    CF_geo=cF_geo_fin.u,
    redeclare model HeatExchangerType = HeatExchangerType) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,0})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 tubes(
    medium=medium2,
    p_nom=p_nom2,
    h_nom=h_nom2,
    m_flow_nom=m_nom2,
    useHomotopy=useHomotopy,
    h_start=h_start_tubes,
    p_start=p_start_tubes,
    redeclare model HeatTransfer = HeatTransferTubes,
    redeclare model PressureLoss = PressureLossTubes,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        z_in={z_in_tubes},
        z_out={z_out_tubes},
        diameter=diameter_i,
        N_tubes=N_tubes,
        N_passes=N_passes,
        length=if tubeOrientation == 0 then length elseif tubeOrientation == 1 then width elseif tubeOrientation == 2 then height else length),
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
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes (
        z_out={z_out_shell},
        height=height,
        width=width,
        length=length,
        diameter_t=diameter_o,
        N_tubes=N_tubes,
        N_passes=N_passes,
        z_in={z_in_shell},
        flowOrientation=flowOrientation,
        CF_geo={1,CF_geo},
        Delta_z_par=Delta_z_par,
        Delta_z_ort=Delta_z_ort,
        staggeredAlignment=staggeredAlignment,
        N_rows=N_rows,
        tubeOrientation=tubeOrientation),
    heatSurfaceAlloc=2,
    initOption=initOptionShell) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));
  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=shell.heat.Q_flow,
      Delta_T_in=shell.flueGasInlet.T - tubes.summary.inlet.T,
      Delta_T_out=shell.flueGasOutlet.T - tubes.summary.outlet.T,
      effectiveness=wall.effectiveness,
      kA=wall.kA,
      kA_nom=1/(tubes.heattransfer.HR_nom + wall.HR_nom + shell.heattransfer.HR_nom)))
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-92})));

  Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={100,80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,80})));
  CF_geo_fin cF_geo_fin;
protected
  Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{71,79},{73,81}})));
  Modelica.Blocks.Sources.RealExpression CFgeo_fin_in(y=shell.heattransfer.A_finned/shell.heattransfer.A_tubes) if fin_geo;
  Modelica.Blocks.Sources.RealExpression CFgeo_in(y=CF_geo) if not fin_geo;
  final parameter Boolean fin_geo = if shell.heattransfer.HT_type == 1 then true else false;
equation
  assert(diameter_o > diameter_i,
    "Outer diameter of tubes must be greater than inner diameter");

initial equation
  //        wall.T=(Tubes.bulk.T+shell.bulk.T)/2;

equation
  eye_int[1].m_flow = tubes.summary.outlet.m_flow;
  eye_int[1].T = tubes.summary.outlet.T - 273.15;
  eye_int[1].s = tubes.fluidOut.s/1e3;
  eye_int[1].p = tubes.outlet.p/1e5;
  eye_int[1].h = tubes.summary.outlet.h/1e3;
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
  connect(shell.heat, wall.outerPhase) annotation (Line(
      points={{10,-1.77636e-015},{21,-1.77636e-015},{21,4.44089e-016}},
      color={167,25,48},
      thickness=0.5));
  connect(tubes.heat, wall.innerPhase) annotation (Line(
      points={{60,1.77636e-015},{39,1.77636e-015},{39,-5.55112e-016}},
      color={167,25,48},
      thickness=0.5));
  connect(Out1, shell.outlet) annotation (Line(
      points={{0,-100},{0,-100},{0,-10}},
      color={118,106,98},
      thickness=0.5));
  connect(shell.inlet, In1) annotation (Line(
      points={{0,10},{0,10},{0,98}},
      color={118,106,98},
      thickness=0.5));
  connect(eye_int[1], eye) annotation (Line(points={{72,80},{90,80},{90,80},{100,80}}, color={190,190,190}));
  connect(CFgeo_fin_in.y, cF_geo_fin.u);
  connect(CFgeo_in.y, cF_geo_fin.u);
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
          textString="NTU")}),Diagram(graphics,
                                      coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})));
end HEXvle2gas_L3_1ph_BU_ntu;
