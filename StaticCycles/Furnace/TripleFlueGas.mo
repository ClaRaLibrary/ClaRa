within ClaRa.StaticCycles.Furnace;
model TripleFlueGas "Visualise static cycle results of flue gas connectors"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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
    outer ClaRa.SimCenter simCenter;
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component";

  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
record DecimalSpaces
parameter Integer m_flow=1 "Accuracy to be displayed for mass flow";
parameter Integer p=1 "Accuracy to be displayed for enthalpy";
parameter Integer T=1 "Accuracy to be displayed for pressure";
end DecimalSpaces;

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_base gasSignal(flueGas=flueGas) annotation (Placement(transformation(extent={{-108,-20},{-100,0}}), iconTransformation(extent={{-120,-20},{-100,40}})));

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
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,180}},
        initialScale=0.1),     graphics={
        Text(
          extent={{-90,80},{150,10}},
          lineColor=DynamicSelect({164,167,170}, if gasSignal.T > 273.15 then {118,106,98} else {235,183,0}),
          fillColor={118,106,98},
          horizontalAlignment=TextAlignment.Left,
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("T", String(gasSignal.T-273.15,format="1." + String(decimalSpaces.T) + "f") + " °C")),
        Text(
          extent={{-90,-10},{250,-80}},
          lineColor=DynamicSelect({164,167,170}, if gasSignal.p > 0 then {118,106,98} else {235,183,0}),
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("p", String(gasSignal.p/1e5,format="1." + String(decimalSpaces.p) + "f") + " bar")),
        Text(
          extent={{-90,170},{150,100}},
          lineColor=DynamicSelect({164,167,170}, if gasSignal.m_flow > 0 then {118,106,98} else {235,183,0}),
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("m", String(gasSignal.m_flow,format="1." + String(decimalSpaces.m_flow) + "f") + " kg/s")),
        Line(
          points={{-100,180},{-100,-100}},
          color=DynamicSelect({164,167,170},{118,106,98}),
          smooth=Smooth.None,thickness=0.5)}), Diagram(graphics,
                                                       coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{220,180}},
        initialScale=0.1)));

end TripleFlueGas;
