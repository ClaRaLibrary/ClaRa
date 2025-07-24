within ClaRa.Components.MechanicalSeparation;
model FeedWaterTank_L2 "Feedwater tank : mixed volume approach | level-dependent phase separation"
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

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellTypeVLE_L2
                                                                                     "Pressure loss model"
                          annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter Modelica.Units.SI.SpecificEnthalpy h_start=steamQuality_start*(TILMedia.VLEFluid.MixtureCompatible.Functions.dewSpecificEnthalpy_pxi(                                     medium, p_start) - TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(                                     medium, p_start)) + TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(                                     medium, p_start) "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "|Phase Separation|Numerical Robustness|Smoothness of table interpolation for calculation of filling level";

  parameter Modelica.Units.SI.Length z_in=1 "Height of inlet ports" annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length z_out=1 "Height of outlet ports" annotation (Dialog(group="Geometry"));

  parameter Integer initOption = 0 "Type of initialisation"
                             annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed rel.level",  choice=205 "Fixed rel.level and steady pressure"));

protected
 model Outline
   extends ClaRa.Basics.Icons.RecordIcon;
    input Basics.Units.Length level_abs "Absolute filling level";
   input Real level_rel "relative filling level";
 end Outline;

 model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   ClaRa.Basics.Records.FlangeVLE condensate;
   ClaRa.Basics.Records.FlangeVLE tapping;
   ClaRa.Basics.Records.FlangeVLE feedwater;
 end Summary;
public
  Summary summary(
    outline(level_abs=volume.phaseBorder.level_abs, level_rel=volume.phaseBorder.level_rel),
    tapping(
      showExpertSummary=showExpertSummary,
      m_flow=heatingSteam.m_flow,
      p=heatingSteam.p,
      h=actualStream(heatingSteam.h_outflow),
      T=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.temperature_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      s=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEntropy_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=heatingSteam.m_flow*actualStream(heatingSteam.h_outflow),
      rho=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
          heatingSteam.p,
          actualStream(heatingSteam.h_outflow),
          actualStream(heatingSteam.xi_outflow),
          volume.fluidIn.vleFluidPointer)),
    condensate(
      showExpertSummary=showExpertSummary,
      m_flow=condensate.m_flow,
      p=condensate.p,
      h=actualStream(condensate.h_outflow),
      T=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.temperature_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      s=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEntropy_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      steamQuality=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer),
      H_flow=condensate.m_flow*actualStream(condensate.h_outflow),
      rho=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
          condensate.p,
          actualStream(condensate.h_outflow),
          actualStream(condensate.xi_outflow),
          volume.fluidIn.vleFluidPointer)),
    feedwater(
      showExpertSummary=showExpertSummary,
      m_flow=-feedwater.m_flow,
      p=feedwater.p,
      h=actualStream(feedwater.h_outflow),
      T=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.temperature_phxi(
          feedwater.p,
          actualStream(feedwater.h_outflow),
          actualStream(feedwater.xi_outflow),
          volume.fluidOut.vleFluidPointer),
      s=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEntropy_phxi(
          feedwater.p,
          actualStream(feedwater.h_outflow),
          actualStream(feedwater.xi_outflow),
          volume.fluidOut.vleFluidPointer),
      steamQuality=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
          feedwater.p,
          actualStream(feedwater.h_outflow),
          actualStream(feedwater.xi_outflow),
          volume.fluidOut.vleFluidPointer),
      H_flow=-feedwater.m_flow*actualStream(feedwater.h_outflow),
      rho=TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
          feedwater.p,
          actualStream(feedwater.h_outflow),
          actualStream(feedwater.xi_outflow),
          volume.fluidOut.vleFluidPointer))) annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 volume(
    medium=medium,
    redeclare model PressureLoss = PressureLoss,
    useHomotopy=useHomotopy,
    m_flow_nom=m_flow_cond_nom + m_flow_heat_nom,
    p_nom=p_nom,
    h_nom=h_nom,
    p_start=p_start,
    h_start=h_start,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    showExpertSummary=showExpertSummary,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder (
        z_in={z_in},
        z_out={z_out},
        orientation=orientation,
        diameter=diameter,
        length=length),
    final heatSurfaceAlloc=1,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallySeparated (level_rel_start=level_rel_start, smoothness=smoothness),
    initOption=initOption) annotation (Placement(transformation(extent={{0,-30},{-20,-10}})));

  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then summary.outline.level_abs else summary.outline.level_rel if levelOutput annotation (Placement(transformation(extent={{204,-126},{224,-106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={240,-110})));
equation

  eye_int[1].m_flow=-feedwater.m_flow;
  eye_int[1].T=volume.fluidOut.T-273.15;
  eye_int[1].s=volume.fluidOut.s/1000;
  eye_int[1].h=volume.fluidOut.h/1000;
  eye_int[1].p=volume.fluidOut.p/100000;

  connect(volume.inlet, condensate) annotation (Line(
      points={{0,-20},{100,-20},{100,60},{200,60}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatingSteam, volume.inlet) annotation (Line(
      points={{-200,80},{-200,30},{0,30},{0,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.outlet, feedwater) annotation (Line(
      points={{-20,-20},{-140,-20},{-140,-100},{-260,-100}},
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
   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-300,
            -100},{300,100}}),
                   graphics={
                     Rectangle(extent={{220,-8},{260,-92}}, lineColor={27,36,42},
                               fillColor={153,205,221},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel),
                     Rectangle(extent=DynamicSelect({{220,-50},{260,-92}}, {{220,summary.outline.level_rel*84-92},{260,-92}}),
                               lineColor={27,36,42},
                               fillColor={0,131,169},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel)}),
                                       Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-240,-140},{120,100}})));
end FeedWaterTank_L2;
