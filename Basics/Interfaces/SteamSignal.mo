within ClaRa.Basics.Interfaces;
expandable connector SteamSignal "Signal bus featuring pressure, specific enthalpy and mass flow rate"


   Real p_ "Pressure in p.u." annotation(HideResult=false);
   Real h_ "Specific enthalpy in p.u." annotation(HideResult=false);
   Real m_flow_ "Mass flow rate in p.u." annotation(HideResult=false);

annotation (defaultComponentPrefixes="protected",
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={102,181,203},
          lineThickness=0.5),
          Polygon(
            fillColor={153,205,221},
            fillPattern=FillPattern.Solid,
            points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{-80,-40},{-100,30}},
            smooth=Smooth.Bezier,
          lineColor={102,181,203}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-65.0,15.0},{-55.0,25.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-5.0,15.0},{5.0,25.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{55.0,15.0},{65.0,25.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{25.0,-25.0},{35.0,-15.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
          Ellipse(
            fillPattern=FillPattern.Solid,
            extent={{-35.0,-25.0},{-25.0,-15.0}},
          fillColor={102,181,203},
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
    Documentation(info="<html>
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
</html>"),Diagram(graphics));
end SteamSignal;
