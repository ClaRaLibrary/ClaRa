within ClaRa.Components.VolumesValvesFittings.Fittings;
model SprayInjectorVLE_L3 "A spray injector for i.e. temperature control"
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
  extends ClaRa.Basics.Icons.SprayInjector;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;

  ///___________Summary Definitions________________________________________

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation (Dialog(hide));

    input ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference between outlet and inlet of injector valve" annotation (Dialog);
    input Real opening "Opening of injector valve" annotation (Dialog(show));
  end Outline;

  model Wall_L4
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation (Dialog(hide));
    parameter Integer N_wall "Number of wall segments" annotation (Dialog(hide));
    input Basics.Units.Temperature T[N_wall] if showExpertSummary "Temperatures of wall segments" annotation (Dialog);
    input Basics.Units.HeatFlowRate Q_flow if showExpertSummary "Heat flow through wall segment" annotation (Dialog);
  end Wall_L4;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE inlet1;
    ClaRa.Basics.Records.FlangeVLE inlet2;
    ClaRa.Basics.Records.FlangeVLE outlet;
    Wall_L4 wall;
  end Summary;

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model Material = TILMedia.Solid.Types.TILMedia_Aluminum
                                                                     constrainedby TILMedia.Solid.Types.BaseSolid
                                                                                                                 "Material of the cylinder"
                               annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter Modelica.Units.SI.Length diameter_o=0.5 "Diameter of the component" annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length diameter_i=0.45 "Diameter of the component" annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length length=3 "Length of the component" annotation (Dialog(group="Geometry"));
  parameter Integer N=1 "Number of identical injectors in parallel"  annotation(Dialog(group="Geometry"));

  parameter Modelica.Units.SI.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.SpecificEnthalpy h_nom_Main=3000e3 "Nominal specific enthalpy" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.SpecificEnthalpy h_nom_Spray=1000e3 "Nominal specific enthalpy" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_main=300 "Nominal mass flow rates at inlet" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.Pressure Delta_p_nom=1000 "Nominal pressure loss" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_spray=10 "Nominal injection mass flow rate" annotation (Dialog(group="Nominal Values"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_start_Main=3000e3 "|Initialisation|Fluid|Initial specific enthalpy at main inlet";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start_Spray=1000e3 "|Initialisation|Fluid|Initial specific enthalpy at main inlet";
  parameter Modelica.Units.SI.Pressure p_start=1e5 "|Initialisation|Fluid|Start value of sytsem pressure";

  parameter Integer initOption=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation", group="Fluid"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "|Initialisation||True, if homotopy method is used during initialisation";

  ///__________Expert Settings__________________________________________________________

  parameter Boolean preciseTwoPhase = true "|Expert Settings|Mixing Zone|True, if two-phase transients should be calculated precisely";

  parameter Boolean checkValve = false "|Expert Settings|Injector Valve|True, if spray injector valve is check valve";

  parameter Boolean useStabilisedMassFlow= false "|Expert Settings|Injector Valve|True, if use pseudo state for mass flow in spray injector valve";

  parameter Real Tau=0.001 "|Expert Settings|Injector Valve|Time constant of pseudo state in spray injector valve";

  parameter Real opening_leak_=0 "|Expert Settings|Injector Valve|Leakage valve opening in p.u.";

    parameter Integer N_wall=3 "|Expert Settings|Wall|Number of radial elements of the wall";

///__________Summary and Visualisation________________________________________________
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=false "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));

  Summary summary(
    outline(
      showExpertSummary=showExpertSummary,
      opening=opening,
      Delta_p= valve.summary.outline.Delta_p),
    inlet1(
      showExpertSummary=showExpertSummary,
      m_flow=inlet1.m_flow,
      T=mixingZone.summary.inlet1.T,
      p=mixingZone.summary.inlet1.p,
      h=mixingZone.summary.inlet1.h,
      s=mixingZone.fluidIn1.s,
      steamQuality=mixingZone.fluidIn1.q,
      H_flow=inlet1.m_flow*mixingZone.summary.inlet1.h,
      rho=mixingZone.fluidIn1.d),
    inlet2(
      showExpertSummary=showExpertSummary,
      m_flow=inlet2.m_flow,
      T=valve.summary.inlet.T,
      p=valve.summary.inlet.p,
      h=valve.summary.inlet.h,
      s=valve.fluidIn.s,
      steamQuality=valve.fluidIn.q,
      H_flow=inlet2.m_flow*valve.summary.inlet.h,
      rho=valve.fluidIn.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=outflowZone.fluidOut.T,
      p=outflowZone.fluidOut.p,
      h=outflowZone.fluidOut.h,
      s=outflowZone.fluidOut.s,
      steamQuality=outflowZone.fluidOut.q,
      H_flow=-outlet.m_flow*outflowZone.fluidOut.h,
      rho=outflowZone.fluidOut.d),
    wall(
      showExpertSummary=showExpertSummary,
      N_wall=wall.N_rad,
      T=wall.T,
      Q_flow=outflowZone.heat.Q_flow)) annotation (Placement(transformation(extent={{-80,-39},{-60,-21}})));



protected
  parameter Modelica.Units.SI.SpecificEnthalpy h_nom_mix=(h_nom_Main*m_flow_nom_main + h_nom_Spray*m_flow_nom_spray)/(m_flow_nom_main + m_flow_nom_spray) "Nominal mix enthalpy";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start_mix=(h_start_Main*m_flow_nom_main + h_start_Spray*m_flow_nom_spray)/(m_flow_nom_main + m_flow_nom_spray) "Nominal mix enthalpy";
  parameter Modelica.Units.SI.Temperature T_wall_start[N_wall]=ones(N_wall)*TILMedia.VLEFluid.MixtureCompatible.Functions.temperature_phxi(
      medium,
      p_start - Delta_p_nom,
      h_start_mix) "Start values of wall temperature" annotation (Dialog(group="Initialisation"));

//Pressure loss models
public
  replaceable model PressureLoss =
      ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint
    constrainedby ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss "Pressure loss model of injector valve"
                                                                                   annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);
  replaceable model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2 constrainedby Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2 "Heat transfer to wall" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  replaceable model PressureLoss_outflowZone =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "Pressure loss model of injector outflow Zone"      annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  replaceable model PressureLoss_mixingZoneInlet1 =
      ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction
    constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp "Pressure loss model of mixing zone at inlet1"      annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  replaceable model PressureLoss_mixingZoneInlet2 =
      ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction
    constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp "Pressure loss model of mixing zone at inlet2"      annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  replaceable model PressureLoss_mixingZoneOutlet =
      ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction
    constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp "Pressure loss model of mixing zone at outlet"      annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

public
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 outflowZone(
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (diameter=diameter_i, length=length/2),
    medium=medium,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_nom_main + m_flow_nom_spray,
    h_nom=h_nom_mix,
    h_start=h_start_mix,
    p_nom=p_nom - Delta_p_nom,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model PressureLoss = PressureLoss_outflowZone,
    p_start=p_start,
    showExpertSummary=showExpertSummary,
    initOption=initOption,
    redeclare model HeatTransfer = HeatTransfer) annotation (Placement(transformation(extent={{40,10},{60,30}})));

  ClaRa.Basics.Interfaces.FluidPortIn inlet1(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-110,10},{-90,30}}), iconTransformation(extent={{-110,10},{-90,30}})));
  ClaRa.Basics.Interfaces.FluidPortIn inlet2(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-30,-110},{-10,-90}}), iconTransformation(extent={{-30,-110},{-10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{90,10},{110,30}}), iconTransformation(extent={{90,10},{110,30}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    redeclare replaceable model Material = Material,
    sizefunc=+1,
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    length=length,
    N_tubes=N,
    T_start=T_wall_start,
    N_rad=N_wall,
    initOption=1) annotation (Placement(transformation(extent={{40,40},{60,60}})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve(
    medium=medium,
    openingInputIsActive=true,
    showExpertSummary=showExpertSummary,
    showData=false,
    redeclare model PressureLoss = PressureLoss,
    useStabilisedMassFlow=useStabilisedMassFlow,
    Tau=Tau,
    checkValve=checkValve,
    opening_leak_=opening_leak_) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={-20,-46})));

  Modelica.Blocks.Interfaces.RealInput opening "=1: completely open, =0: completely closed"
                                                 annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-100})));
  ClaRa.Basics.Interfaces.EyeOut eye if showData      annotation(Placement(transformation(extent={{90,-30},
            {110,-10}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{45,-21},{47,-19}})));
public
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y mixingZone(
    volume=Modelica.Constants.pi/4*diameter_i^2*length/2*N,
    medium=medium,
    m_flow_in_nom={m_flow_nom_main,m_flow_nom_spray},
    p_nom=p_nom,
    h_nom=h_nom_mix,
    h_start=h_start_mix,
    p_start=p_start,
    initOption=initOption,
    useHomotopy=useHomotopy,
    preciseTwoPhase=preciseTwoPhase,
    showExpertSummary=showExpertSummary,
    showData=false,
    redeclare model PressureLossIn1 = PressureLoss_mixingZoneInlet1,
    redeclare model PressureLossIn2 = PressureLoss_mixingZoneInlet2,
    redeclare model PressureLossOut = PressureLoss_mixingZoneOutlet) annotation (Placement(transformation(extent={{-30,30},{-10,10}})));


equation
//-------------------------------------------
//Summary:
    eye_int[1].m_flow=-outflowZone.outlet.m_flow;
    eye_int[1].T= outflowZone.summary.outlet.T-273.15;
    eye_int[1].s=outflowZone.fluidOut.s/1e3;
    eye_int[1].p=outflowZone.outlet.p/1e5;
    eye_int[1].h=noEvent(actualStream(outflowZone.outlet.h_outflow))/1e3;

  connect(wall.innerPhase, outflowZone.heat)                  annotation (Line(
      points={{49.8,40.4},{49.8,30},{50,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outflowZone.outlet, outlet) annotation (Line(
      points={{60,20},{100,20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve.inlet, inlet2) annotation (Line(
      points={{-20,-56},{-20,-100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve.opening_in, opening)     annotation (Line(
      points={{-29,-46},{-40,-46},{-40,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-20},{46,-20}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixingZone.outlet, outflowZone.inlet) annotation (Line(
      points={{-10,20},{40,20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixingZone.inlet1, inlet1) annotation (Line(
      points={{-30,20},{-100,20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mixingZone.inlet2, valve.outlet) annotation (Line(
      points={{-20,10},{-20,-36}},
      color={0,131,169},
      thickness=0.5,
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
 Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                   graphics),    Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=true,
                  extent={{-100,-100},{100,100}})));
end SprayInjectorVLE_L3;
