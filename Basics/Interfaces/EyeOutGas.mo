within ClaRa.Basics.Interfaces;
connector EyeOutGas
  import SI = ClaRa.Basics.Units;
   parameter TILMedia.GasTypes.BaseGas medium annotation(HideResult=false);
   output Real p "Pressure in bar" annotation(HideResult=false);
   output Real h "Specific enthalpy in kJ/kg" annotation(HideResult=false);
   output Real m_flow "Mass flow rate in kg/s" annotation(HideResult=false);
   output Real T "Temperature in degC" annotation(HideResult=false);
   output Real s "Specific entropy in kJ/kgK" annotation(HideResult=false);
  output Real xi[medium.nc-1] "Mass concentrations" annotation(HideResult=false);

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
</html>"),defaultComponentName="eyeIn",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2), graphics={
                 Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={190,190,190},
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,60},{60,0},{-80,-60},{-80,60}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
  Diagram(coordinateSystem(
        preserveAspectRatio=true, initialScale=0.2,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={Polygon(
          points={{-100,99},{100,0},{-100,-100},{-100,99}},
          lineColor={118,106,98},
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid), Text(
          extent={{-10,85},{-10,60}},
          lineColor={118,106,98},
          textString="%name"),
        Polygon(
          points={{-80,60},{60,0},{-80,-60},{-80,60}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));

end EyeOutGas;
