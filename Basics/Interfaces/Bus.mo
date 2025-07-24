within ClaRa.Basics.Interfaces;
expandable connector Bus "An expandable connector for the usage in ClaRa control definitions"

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
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}, initialScale=0.2), graphics={
          Rectangle(
            lineColor={118,124,127},
            lineStyle=LineStyle.Dotted,
            lineThickness=0.5,
            extent={{-20.0,-2.0},{20.0,2.0}},
          pattern=LinePattern.Dot),
          Polygon(
            fillColor={221,222,223},
            fillPattern=FillPattern.Solid,
            points={{-80,46},{80,46},{100,26},{80,-44},{60,-54},{-60,-54},{-80,-44},{-100,26}},
            smooth=Smooth.Bezier,
          lineColor={118,124,127}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65.0,15.0},{-55.0,25.0}},
          fillColor={118,124,127},
          pattern=LinePattern.None),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5.0,15.0},{5.0,25.0}},
          fillColor={118,124,127},
          pattern=LinePattern.None),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55.0,15.0},{65.0,25.0}},
          fillColor={118,124,127},
          pattern=LinePattern.None),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35.0,-25.0},{-25.0,-15.0}},
          fillColor={118,124,127},
          pattern=LinePattern.None),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25.0,-25.0},{35.0,-15.0}},
          fillColor={118,124,127},
          pattern=LinePattern.None)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.2), graphics={
        Polygon(
          points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,-20},{-50,15}},
          lineColor={118,124,127},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Ellipse(
          extent={{-32.5,7.5},{-27.5,12.5}},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-2.5,12.5},{2.5,7.5}},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{27.5,12.5},{32.5,7.5}},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-17.5,-7.5},{-12.5,-12.5}},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{12.5,-7.5},{17.5,-12.5}},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-150,70},{150,40}},
          lineColor={118,124,127},
          textString="%name")}));
end Bus;
