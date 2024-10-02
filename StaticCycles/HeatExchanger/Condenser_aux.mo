within ClaRa.StaticCycles.HeatExchanger;
model Condenser_aux "Condenser || par.: pressure, level_abs || blue || blue  |green"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2022, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_in,
     h=h_in,
     p=p_in),
  outlet(
     m_flow=m_flow_in,
     h=h_out,
     p=p_out));
  //---------Summary Definition---------
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Pressure p_condenser=4000 "|Fundamental Definitions|Condenser pressure";
  parameter ClaRa.Basics.Units.Length level_abs(min=0) = 0 "|Fundamental Definitions|Filling level in hotwell";

  final parameter ClaRa.Basics.Units.Pressure p_in=p_condenser "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out=p_condenser + Modelica.Constants.g_n*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleDensity_pxi(medium, p_condenser)*level_abs "Outlet pressure";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_condenser) "Outlet enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_aux(fixed=false) "Spec. enthalpy auxilary";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_in(fixed=false) "Inlet mass flow";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_aux(fixed=false) "Mass flow auxilary";
//    final parameter ClaRa.Basics.Units.MassFlowRate    m_flow_out=m_flow_cond;
protected
  final parameter Boolean isFilled = level_abs > 0 "Reprt: True if vessel is filled";
public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inlet(p=p_condenser, Medium=medium) annotation (Placement(transformation(
        extent={{-10,100},{10,110}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,100},{10,110}},
        rotation=0,
        origin={0,0})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b outlet(
    h=h_out,
    p=p_out,
    m_flow=m_flow_in+m_flow_aux,
    Medium=medium) annotation (Placement(transformation(
        extent={{-10,-100},{10,-110}},
        rotation=0,
        origin={0,-0}), iconTransformation(
        extent={{-10,-100},{10,-110}},
        rotation=0,
        origin={0,0})));

  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a aux(p=p_condenser, Medium=medium) annotation (Placement(transformation(extent={{-108,60},{-100,80}})));
initial equation

 inlet.m_flow=m_flow_in;
 inlet.h=h_in;
 aux.m_flow=m_flow_aux;
 aux.h=h_aux;

  annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2022.</p>
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
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                               graphics={
                             Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{100,58},{-36,58},{38,-2},{-30,-62},{100,-62}},
          color={0,131,169},
          smooth=Smooth.None),
        Rectangle(
          extent={{-100,-80},{100,-100}},
          lineColor={0,131,169},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible = DynamicSelect(false, isFilled))}));
end Condenser_aux;
