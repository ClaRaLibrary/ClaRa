within ClaRa.StaticCycles.Boundaries;
model Source_yellow "Yellow boundary"
// Yellow output: Values of p, and h are known in component and provided FOR neighbor component, value of m_flow is unknown and provided BY beighbor component.

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow from the source";
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h "Spec. enthalpy of the source flow";
  parameter ClaRa.Basics.Units.Pressure p "Pressure at the source";
  outer ClaRa.SimCenter simCenter;

  ClaRa.StaticCycles.Fundamentals.SteamSignal_yellow_b outlet(h=h, p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));

initial equation
  m_flow= outlet.m_flow;

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
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-60,60},{60,20}},
          lineColor={235,183,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=String(m_flow)),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={235,183,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%h"),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={235,183,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%p"),
        Line(points={{60,100},{100,0},{60,-100}}, color={235,183,0})}),
                                           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Source_yellow;
