within ClaRa.Components.Control.PredictorModels_3508.Icons;
model TurbineAndReheat
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid), Rectangle(extent={{-80,80},{80,-80}}, lineColor={221,222,223}),
        Polygon(
          points={{-66,10},{-46,20},{-46,-20},{-66,-10},{-66,10}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,40},{-66,40},{-66,10}},
          color={221,222,223}),
        Rectangle(
          extent={{-32,60},{8,20}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,20},{20,32},{20,-32},{40,-20},{40,20}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-46,20},{-46,40},{-26,40},{-12,54},{-12,30},{2,40},{40,40},{40,20}},
          color={221,222,223}),
        Polygon(
          points={{40,20},{60,32},{60,-32},{40,-20},{40,20}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(
          points={{80,-60},{60,-60},{60,-28}},
          color={221,222,223})}),                                                                           Diagram(coordinateSystem(preserveAspectRatio=false)));
end TurbineAndReheat;
