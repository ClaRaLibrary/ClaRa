within ClaRa.Components.MechanicalSeparation;
model FeedWaterTank_L3 "Feedwater tank : separated volume approach | level-dependent phase separation"
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

extends ClaRa.Components.MechanicalSeparation.FeedWaterTank_base;
  parameter ClaRa.Basics.Units.Length thickness_wall=0.005*diameter "Thickness of the cylinder wall" annotation (Dialog(group="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/FeedWaterTank_L3_advanced.png"));
  parameter ClaRa.Basics.Units.Length thickness_insulation=0.02 "Thickness of the insulation" annotation (Dialog(group="Geometry", enable=includeInsulation));

  replaceable model material = TILMedia.Solid.Types.TILMedia_Steel
                                                                  constrainedby TILMedia.Solid.Types.BaseSolid
                                                                                                              "Material of the walls"  annotation (Dialog(group="Fundamental Definitions"),choicesAllMatching);
  parameter Boolean includeInsulation=false  "True, if insulation is included" annotation(Dialog(group="Fundamental Definitions"));
  replaceable model insulationMaterial=Basics.Media.Solids.InsulationOrstechLSP_H_const
                                                                            constrainedby TILMedia.Solid.Types.BaseSolid
                                                                                                                        "Insulation material" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions", enable=(includeInsulation==true)));

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");
  parameter Modelica.Units.SI.Length radius_flange=0.05 "Flange radius" annotation (Dialog(group="Geometry"));
  parameter Basics.Units.Length z_tapping=0 "position of tapping flange" annotation (Dialog(group="Geometry"));
  parameter Basics.Units.Length z_condensate=0.1 "position of condensate flange" annotation (Dialog(group="Geometry"));
  parameter Basics.Units.Length z_aux=0.1 "position of auxilliary flange" annotation (Dialog(group="Geometry"));
  parameter Basics.Units.Length z_feedwater=0 "position of feedwater flange" annotation (Dialog(group="Geometry"));
  parameter Basics.Units.Length z_vent=0.1 "position of vent flange" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of internal structure addtional to feedwater tank wall" annotation (Dialog(group="Geometry"));

  parameter Basics.Units.Time Tau_cond=10 "Time constant of condensation" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Basics.Units.Time Tau_evap=Tau_cond*1000 "Time constant of evaporation" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Real absorbInflow=1 "Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"
                                                                                              annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Basics.Units.Area A_phaseBorder=volume.geo.A_hor*100 "Heat transfer area at phase border" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=500 "HTC of the phase border" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Real expHT_phases=0 "Exponent for volume dependency on inter phase HT" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Boolean equalPressures=true "True if pressure in liquid and vapour phase is equal" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation for calculation of filling level" annotation(Dialog(tab="Phase Separation", group="Numerical Robustness"));

  parameter Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(                                     medium, volume.p_start) "Start value of liquid specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter Basics.Units.EnthalpyMassSpecific h_vap_start=+10 + TILMedia.VLEFluid.MixtureCompatible.Functions.dewSpecificEnthalpy_pxi(                                     medium, volume.p_start) "Start value of vapour specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter Modelica.Units.SI.Temperature T_wall_start[wall.N_rad]=ones(wall.N_rad)*293.15 "Start values of wall temperature inner --> outer" annotation (Dialog(tab="Initialisation", group="Wall"));
  parameter Integer initOptionWall=1 "Initialisation option for wall" annotation(Dialog(tab="Initialisation", group="Wall"),choices(
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
  inner parameter Integer initOption = 211 "Type of initialisation"
    annotation (Dialog(tab= "Initialisation"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume", choice=201 "Steady vapour pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed volume fraction",  choice=211 "Fixed values in level, enthalpies and vapour pressure"));
  parameter Boolean enableAmbientLosses=false "Include heat losses to environment "
                                                                                   annotation(Dialog(tab="Heat Losses"));
  input ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_prescribed=8 "Prescribed heat transfer coefficient" annotation (Dialog(tab="Heat Losses", enable=(enableAmbientLosses == true)));
  input ClaRa.Basics.Units.Temperature T_amb=simCenter.T_amb "Temperature of surrounding medium" annotation (Dialog(tab="Heat Losses", enable=(enableAmbientLosses == true)));

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
   ClaRa.Basics.Records.FlangeVLE condensate;
   ClaRa.Basics.Records.FlangeVLE tapping "heatingSteam (= volume.inlet[1]";
   ClaRa.Basics.Records.FlangeVLE feedwater;
   ClaRa.Basics.Records.FlangeVLE aux;
   ClaRa.Basics.Records.FlangeVLE vent "Vent (= volume.outlet[2])";
 end Summary;

  Summary summary(
    outline(
      level_abs=volume.phaseBorder.level_abs,
      level_rel=volume.phaseBorder.level_rel,
      Q_loss=wall.outerPhase.Q_flow),
    wall(T_wall=wall.T),
    tapping(
      showExpertSummary=showExpertSummary,
      m_flow=heatingSteam.m_flow,
      p=heatingSteam.p,
      h=noEvent(actualStream(heatingSteam.h_outflow)),
      T=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.temperature_phxi(
          heatingSteam.p,
          noEvent(actualStream(heatingSteam.h_outflow)),
          noEvent(actualStream(heatingSteam.xi_outflow)),
          volume.fluidIn[1].vleFluidPointer),
      s=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEntropy_phxi(
          heatingSteam.p,
          noEvent(actualStream(heatingSteam.h_outflow)),
          noEvent(actualStream(heatingSteam.xi_outflow)),
          volume.fluidIn[1].vleFluidPointer),
      steamQuality=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
          heatingSteam.p,
          noEvent(actualStream(heatingSteam.h_outflow)),
          noEvent(actualStream(heatingSteam.xi_outflow)),
          volume.fluidIn[1].vleFluidPointer),
      H_flow=heatingSteam.m_flow*noEvent(actualStream(heatingSteam.h_outflow)),
      rho=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
          heatingSteam.p,
          noEvent(actualStream(heatingSteam.h_outflow)),
          noEvent(actualStream(heatingSteam.xi_outflow)),
          volume.fluidIn[1].vleFluidPointer)),
    condensate(
      showExpertSummary=showExpertSummary,
      m_flow=condensate.m_flow,
      p=condensate.p,
      h=noEvent(actualStream(condensate.h_outflow)),
      T=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.temperature_phxi(
          condensate.p,
          noEvent(actualStream(condensate.h_outflow)),
          noEvent(actualStream(condensate.xi_outflow)),
          volume.fluidIn[2].vleFluidPointer),
      s=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEntropy_phxi(
          condensate.p,
          noEvent(actualStream(condensate.h_outflow)),
          noEvent(actualStream(condensate.xi_outflow)),
          volume.fluidIn[2].vleFluidPointer),
      steamQuality=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
          condensate.p,
          noEvent(actualStream(condensate.h_outflow)),
          noEvent(actualStream(condensate.xi_outflow)),
          volume.fluidIn[2].vleFluidPointer),
      H_flow=condensate.m_flow*noEvent(actualStream(condensate.h_outflow)),
      rho=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
          condensate.p,
          noEvent(actualStream(condensate.h_outflow)),
          noEvent(actualStream(condensate.xi_outflow)),
          volume.fluidIn[2].vleFluidPointer)),
    aux(
      showExpertSummary=showExpertSummary,
      m_flow=aux.m_flow,
      p=aux.p,
      h=noEvent(actualStream(aux.h_outflow)),
      T=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.temperature_phxi(
          aux.p,
          noEvent(actualStream(aux.h_outflow)),
          noEvent(actualStream(aux.xi_outflow)),
          volume.fluidIn[3].vleFluidPointer),
      s=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEntropy_phxi(
          aux.p,
          noEvent(actualStream(aux.h_outflow)),
          noEvent(actualStream(aux.xi_outflow)),
          volume.fluidIn[3].vleFluidPointer),
      steamQuality=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
          aux.p,
          noEvent(actualStream(aux.h_outflow)),
          noEvent(actualStream(aux.xi_outflow)),
          volume.fluidIn[3].vleFluidPointer),
      H_flow=aux.m_flow*noEvent(actualStream(aux.h_outflow)),
      rho=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
          aux.p,
          noEvent(actualStream(aux.h_outflow)),
          noEvent(actualStream(aux.xi_outflow)),
          volume.fluidIn[3].vleFluidPointer)),
    feedwater(
      showExpertSummary=showExpertSummary,
      m_flow=-feedwater.m_flow,
      p=feedwater.p,
      h=noEvent(actualStream(feedwater.h_outflow)),
      T=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.temperature_phxi(
          feedwater.p,
          noEvent(actualStream(feedwater.h_outflow)),
          noEvent(actualStream(feedwater.xi_outflow)),
          volume.fluidIn[1].vleFluidPointer),
      s=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEntropy_phxi(
          feedwater.p,
          noEvent(actualStream(feedwater.h_outflow)),
          noEvent(actualStream(feedwater.xi_outflow)),
          volume.fluidIn[1].vleFluidPointer),
      steamQuality=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
          feedwater.p,
          noEvent(actualStream(feedwater.h_outflow)),
          noEvent(actualStream(feedwater.xi_outflow)),
          volume.fluidIn[1].vleFluidPointer),
      H_flow=-feedwater.m_flow*noEvent(actualStream(feedwater.h_outflow)),
      rho=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
          feedwater.p,
          noEvent(actualStream(feedwater.h_outflow)),
          noEvent(actualStream(feedwater.xi_outflow)),
          volume.fluidIn[1].vleFluidPointer)),
    vent(
      showExpertSummary=showExpertSummary,
      m_flow=-vent.m_flow,
      p=vent.p,
      h=volume.fluidOut[2].h,
      T=volume.fluidOut[2].T,
      s=volume.fluidOut[2].s,
      steamQuality=volume.fluidOut[2].q,
      H_flow=-volume.outlet[2].m_flow*volume.fluidOut[2].h,
      rho=volume.fluidOut[2].d)) annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));
  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort volume(
    medium=medium,
    redeclare model PressureLoss = PressureLoss,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_cond_nom + m_flow_heat_nom,
    p_nom=p_nom,
    p_start=p_start,
    level_rel_start=level_rel_start,
    Tau_cond=Tau_cond,
    showExpertSummary=showExpertSummary,
    redeclare model HeatTransfer = HeatTransfer,
    Tau_evap=Tau_evap,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        N_heat=1,
        A_heat={Modelica.Constants.pi*diameter*length},
        final A_hor=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else diameter*length,
        N_outlet=2,
        z_out={z_feedwater,z_vent},
        shape=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then [0,1; 1,1] else [0.0005,0.02981; 0.0245,0.20716; 0.1245,0.45248; 0.2245,0.58733; 0.3245,0.68065; 0.4245,0.74791; 0.5245,0.7954; 0.6245,0.8261; 0.7245,0.84114; 0.8245,0.84015; 0.9245,0.82031; 1,0.7854],
        height_fill=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then length else diameter,
        volume=Modelica.Constants.pi/4*diameter^2*length,
        A_cross=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else length*diameter,
        final A_front=if orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then Modelica.Constants.pi/4*diameter^2 else length*diameter,
        N_inlet=3,
        z_in={z_tapping,z_condensate,z_aux}),
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow,
        smoothness=smoothness),
    A_heat_ph=A_phaseBorder,
    exp_HT_phases=expHT_phases,
    alpha_ph=alpha_ph,
    equalPressures=equalPressures,
    initOption=initOption)  annotation (Placement(transformation(extent={{32,-30},{12,-10}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    sizefunc=+1,
    N_tubes=1,
    length=length,
    N_rad=3,
    diameter_i=diameter,
    redeclare replaceable model Material = material,
    diameter_o=diameter + 2*thickness_wall,
    T_start=T_wall_start,
    initOption=initOptionWall,
    mass_struc=mass_struc + 2*diameter^2/4*Modelica.Constants.pi*thickness_wall*wall.solid[1].d) annotation (Placement(transformation(extent={{12,24},{32,44}})));

  Basics.Interfaces.FluidPortOut vent(Medium=medium)
    annotation (Placement(transformation(extent={{-10,88},{10,108}}),
        iconTransformation(extent={{-10,88},{10,108}})));
public
  Basics.Interfaces.EyeOut eye_sat   if showData
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,110})));
protected
  Basics.Interfaces.EyeIn       eye_int1[1]
    annotation (Placement(transformation(extent={{-41,73},{-39,75}})));
public
  Basics.Interfaces.FluidPortIn aux(Medium=medium) "Auxilliary inlet"
    annotation (Placement(transformation(extent={{150,50},{170,70}}),
        iconTransformation(extent={{150,50},{170,70}})));
  Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={22,8})));
  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then summary.outline.level_abs else summary.outline.level_rel if levelOutput annotation (Placement(transformation(extent={{204,-126},{224,-106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={242,-110})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 insulation(
    redeclare model Material = insulationMaterial,
    diameter_o=diameter + 2*thickness_wall + 2*thickness_insulation,
    diameter_i=diameter + 2*thickness_wall,
    length=length,
    N_tubes=1,
    N_ax=1,
    stateLocation=2,
    initOption=initOptionInsulation,
    T_start=T_startInsulation*ones(1))                             if includeInsulation annotation (Placement(transformation(extent={{12,52},{32,60}})));
  BoundaryConditions.PrescribedHeatFlow                  prescribedHeatFlow(
    length=length,
    N_axial=1,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0},
        length,
        1))         if enableAmbientLosses==true annotation (Placement(transformation(extent={{-38,54},{-18,74}})));
  Modelica.Blocks.Sources.RealExpression heatFlowRatePrescribedAlpha(y=if includeInsulation then -alpha_prescribed*(length*Modelica.Constants.pi*(diameter + 2*thickness_wall + 2*thickness_insulation) + Modelica.Constants.pi*(diameter + 2*thickness_wall + 2*thickness_insulation)^2/4*2)*(prescribedHeatFlow.port[1].T - T_amb) else -alpha_prescribed*(length*Modelica.Constants.pi*(diameter + 2*thickness_wall) + Modelica.Constants.pi*(diameter + 2*thickness_wall)^2/4*2)*(prescribedHeatFlow.port[1].T - T_amb))
                    if enableAmbientLosses==true annotation (Placement(transformation(extent={{-68,54},{-48,74}})));
equation
  eye_int1[1].m_flow=-vent.m_flow;
  eye_int1[1].T=volume.summary.outlet[2].T-273.15;
  eye_int1[1].s=volume.fluidOut[2].s/1000;
  eye_int1[1].h=volume.summary.outlet[2].h/1000;
  eye_int1[1].p=volume.summary.outlet[2].p/100000;

  eye_int[1].m_flow=-feedwater.m_flow;
  eye_int[1].T=volume.summary.outlet[1].T-273.15;
  eye_int[1].s=volume.fluidOut[1].s/1000;
  eye_int[1].h=volume.summary.outlet[1].h/1000;
  eye_int[1].p=volume.summary.outlet[1].p/100000;
  connect(volume.inlet[1], heatingSteam) annotation (Line(
      points={{32,-20},{44,-20},{44,80},{-200,80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.inlet[2], condensate) annotation (Line(
      points={{32,-20},{116,-20},{116,-20},{200,-20},{200,60},{200,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet[1], feedwater) annotation (Line(
      points={{12,-20},{-260,-20},{-260,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet[2], vent) annotation (Line(
      points={{12,-20},{0,-20},{0,98}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_int1[1],eye_sat)
                        annotation (Line(
      points={{-40,74},{-40,110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(aux, volume.inlet[3])           annotation (Line(
      points={{160,60},{44,60},{44,-20},{32,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatVector, volume.heat) annotation (Line(
      points={{22,-2},{22,-10}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatScalar, wall.innerPhase) annotation (Line(
      points={{22,18},{22,24.4},{21.8,24.4}},
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
   Icon(coordinateSystem(preserveAspectRatio=false,extent={{-300,
            -100},{300,100}}),graphics={
                     Rectangle(extent={{220,-8},{260,-92}}, lineColor={27,36,42},
                               fillColor={153,205,221},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel),
                     Rectangle(extent=DynamicSelect({{220,-50},{260,-92}}, {{220,summary.outline.level_rel*84-92},{260,-92}}),
                               lineColor={27,36,42},
                               fillColor={0,131,169},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel),
        Line(
          points={{0,1},{5.81374e-017,-73}},
          color={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          thickness=0.5,
          origin={-150,-13},
          rotation=180),
        Line(
          points={{0,1},{5.81374e-017,-73}},
          color={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          thickness=0.5,
          origin={-120,-13},
          rotation=180),
        Line(
          points={{0,1},{5.81374e-017,-73}},
          color={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          thickness=0.5,
          origin={-90,-13},
          rotation=180),
        Polygon(
          points={{-156,60},{-144,60},{-150,72},{-156,60}},
          lineColor={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          lineThickness=0.5,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-126,60},{-114,60},{-120,72},{-126,60}},
          lineColor={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          lineThickness=0.5,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-96,60},{-84,60},{-90,72},{-96,60}},
          lineColor={162,29,33},
          visible=DynamicSelect(false,if enableAmbientLosses==true then true else false),
          lineThickness=0.5,
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid)}),
                                 Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-300,-100},{300,100}})));
end FeedWaterTank_L3;
