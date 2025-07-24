within ClaRa.Components.MechanicalSeparation;
model SteamSeparatorVLE_L3
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

  extends ClaRa.Basics.Icons.Cyclone;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  //_____________________________________________________
  //_______________replaceable models____________________
  inner parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  //replaceable model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L3 annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3           constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3
                                                                                              annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
   outer ClaRa.SimCenter simCenter;

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort volume(
    useHomotopy=useHomotopy,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    xi_liq_start=xi_liq_start,
    xi_vap_start=xi_vap_start,
    p_start=p_start,
    level_rel_start=yps_start,
    showExpertSummary=showExpertSummary,
    medium=medium,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3,
    redeclare model PressureLoss = PressureLoss,
    Tau_cond=Tau_cond,
    Tau_evap=Tau_evap,
    alpha_ph=alpha_ph,
    A_heat_ph=volume.geo.A_hor*2,
    exp_HT_phases=exp_HT_phases,
    m_flow_nom=m_flow_nom,
    p_nom=p_nom,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder (
        N_outlet=2,
        z_in={z_in},
        z_out={z_out1,z_out2},
        orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter=diameter,
        length=length),
    redeclare model PhaseBorder = Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=yps_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow,
        smoothness=smoothness),
    equalPressures=equalPressures,
    initOption=initOption)  annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet2(Medium=medium) "Steam outlet" annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet1(Medium=medium) "Liquid outlet" annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  parameter ClaRa.Basics.Units.Length length=20 "Length of separator" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter=0.5 "Diameter of separator" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in=length "Inlet position (from bottom)" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out1=0 "Outlet 1 position (from bottom)" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out2=length "Outlet 2 position (from bottom)" annotation (Dialog(group="Geometry"));

 // parameter ClaRa.Basics.Units.Length s_wall=0.05 "Wall thickness" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length radius_flange=0.05 "Flange radius" annotation (Dialog(group="Geometry"));

  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(                                     medium, p_start) "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vap_start=+10 + TILMedia.VLEFluid.MixtureCompatible.Functions.dewSpecificEnthalpy_pxi(                                     medium, p_start) "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.MassFraction xi_liq_start[medium.nc - 1]=medium.xi_default "|Initialisation||Initial composition of liquid phase";
  parameter ClaRa.Basics.Units.MassFraction xi_vap_start[medium.nc - 1]=medium.xi_default "|Initialisation||Initial composition of vapour phase";

  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation"));
  parameter Real yps_start=0.5 "Start value for volume fraction"
    annotation (Dialog(tab="Initialisation"));

  inner parameter Integer initOption = 211 "Type of initialisation"
    annotation (Dialog(tab= "Initialisation"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume", choice=201 "Steady vapour pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed volume fraction",  choice=211 "Fixed values in level, enthalpies and vapour pressure"));

  final parameter Real absorbInflow=1 "absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"
                                                                                              annotation (Dialog(tab="Expert Settings"));

  parameter ClaRa.Basics.Units.Time Tau_cond=0.03 "Time constant of condensation" annotation (Dialog(tab="Phase Separation"));
  parameter ClaRa.Basics.Units.Time Tau_evap=Tau_cond "Time constant of evaporation" annotation (Dialog(tab="Phase Separation"));
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_ph=10000 "HTC of the phase border" annotation (Dialog(tab="Phase Separation"));
  parameter Real exp_HT_phases=-1 "Exponent for volume dependency on inter phase HT" annotation (Dialog(tab="Phase Separation"));
  parameter Boolean equalPressures=true "True if pressure in liquid and vapour phase is equal" annotation (Dialog(tab="Phase Separation"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rates at inlet" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                              annotation(Dialog(group="Summary and Visualisation"));
  parameter Boolean levelOutput = false "True, if Real level connector shall be addded"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean outputAbs = false "True, if absolute level is at output"  annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation" annotation (Dialog(tab="Expert Settings"));
  ClaRa.Basics.Interfaces.EyeOut eye_out1
                                         if showData annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-110})));
  ClaRa.Basics.Interfaces.EyeOut eye_out2
                                         if showData annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={40,100}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={40,110})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int1[1] annotation (Placement(transformation(extent={{39,-53},{41,-51}})));
  ClaRa.Basics.Interfaces.EyeIn eye_int2[1]
    annotation (Placement(transformation(extent={{39,77},{41,75}})));

public
  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then volume.summary.outline.level_abs else volume.summary.outline.level_rel if levelOutput
  annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
                    iconTransformation(extent={{100,-90},{120,-70}})));
equation
  eye_int2[1].m_flow=-outlet2.m_flow;
  eye_int2[1].T=volume.summary.outlet[2].T-273.15;
  eye_int2[1].s=volume.fluidOut[2].s/1000;
  eye_int2[1].h=volume.summary.outlet[2].h/1000;
  eye_int2[1].p=volume.summary.outlet[2].p/100000;

  eye_int1[1].m_flow=-outlet1.m_flow;
  eye_int1[1].T=volume.summary.outlet[1].T-273.15;
  eye_int1[1].s=volume.fluidOut[1].s/1000;
  eye_int1[1].h=volume.summary.outlet[1].h/1000;
  eye_int1[1].p=volume.summary.outlet[1].p/100000;

  connect(inlet, volume.inlet[1]) annotation (Line(
      points={{-100,0},{-40,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(eye_int1[1], eye_out1) annotation (Line(
      points={{40,-52},{40,-100}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int2[1],eye_out2)  annotation (Line(
      points={{40,76},{40,100}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(volume.outlet[2], outlet2) annotation (Line(
      points={{-20,0},{0,0},{0,100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(volume.outlet[1], outlet1) annotation (Line(
      points={{-20,0},{0,0},{0,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
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
</html>"),Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SteamSeparatorVLE_L3;
