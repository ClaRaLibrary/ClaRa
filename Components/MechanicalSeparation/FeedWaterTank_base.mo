within ClaRa.Components.MechanicalSeparation;
partial model FeedWaterTank_base "Base class for feedwater tanks"
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
  extends ClaRa.Basics.Icons.FeedwaterTank;

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter Modelica.Units.SI.Length diameter=1 "Diameter of the component" annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length length=1 "Length of the component" annotation (Dialog(group="Geometry"));
  parameter Basics.Choices.GeometryOrientation      orientation=ClaRa.Basics.Choices.GeometryOrientation.vertical "Orientation of the component"
                                    annotation(Dialog(group="Geometry"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_cond_nom "Nominal condensat flow" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_heat_nom "Nominal heating steam flow" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy" annotation (Dialog(group="Nominal Values"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

  parameter Modelica.Units.SI.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation"));
  parameter Real level_rel_start "Initial filling level" annotation(Dialog(tab="Initialisation"));
  final parameter ClaRa.Basics.Units.MassFraction steamQuality_start=(1 - level_rel_start)*TILMedia.VLEFluid.MixtureCompatible.Functions.dewDensity_pxi(                                     medium, p_start)/((1 - level_rel_start)*TILMedia.VLEFluid.MixtureCompatible.Functions.dewDensity_pxi(                                     medium, p_start) + level_rel_start*TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleDensity_pxi(                                     medium, p_start)) "Initial steam quality";

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if expert summary should be applied" annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown"
                                                                                                 annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showLevel = false "True, if level shall be visualised"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean levelOutput = false "True, if Real level connector shall be addded"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean outputAbs = false "True, if absolute level is at output"  annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));

public
  ClaRa.Basics.Interfaces.FluidPortOut feedwater(Medium=medium) "Feedwater" annotation (Placement(transformation(extent={{-270,-110},{-250,-90}}), iconTransformation(extent={{-270,-110},{-250,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn heatingSteam(Medium=medium) "Heating steam inlet"
    annotation (Placement(transformation(extent={{-210,70},{-190,90}}), iconTransformation(extent={{-210,70},{-190,90}})));
  ClaRa.Basics.Interfaces.FluidPortIn condensate(Medium=medium) "Main condensate inlet"
    annotation (Placement(transformation(extent={{190,50},{210,70}}), iconTransformation(extent={{190,50},{210,70}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye if showData
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-220,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-220,-110})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{-221,-81},{-219,-79}})));
equation
  connect(eye_int[1], eye) annotation (Line(
      points={{-220,-80},{-220,-110}},
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
   Icon(graphics,  coordinateSystem(preserveAspectRatio=false,extent={{-300,-100},{300,100}},
        initialScale=0.1)),
                         Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-300,-100},{300,100}},
        initialScale=0.1)));
end FeedWaterTank_base;
