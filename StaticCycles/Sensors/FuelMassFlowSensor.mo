within ClaRa.StaticCycles.Sensors;
model FuelMassFlowSensor "Visualise static cycle results of fuel connectors"
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
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (Dialog(group="Fundamental Definitions"));
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
record DecimalSpaces
  parameter Integer m_flow=1 "Accuracy to be displayed for mass flow";
// parameter Integer p=1 "Accuracy to be displayed for enthalpy";
// parameter Integer T=1 "Accuracy to be displayed for pressure";
end DecimalSpaces;

  ClaRa.StaticCycles.Fundamentals.FuelSignal_black_a fuelSignal(fuelModel=fuelModel) annotation (Placement(transformation(extent={{-108,-20},{-100,0}}), iconTransformation(extent={{-120,-20},{-100,40}})));

annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
<p>Friedrich Gottelt, Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH, Copyright &copy; 2019-2020</p>
<p><a href=\"http://www.fvtr.de\">www.fvtr.de</a>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH for industry projects in cooperation with Lausitz Energie Kraftwerke AG, Cottbus.</p>
<b>Acknowledgements:</b>
<p>This model contribution is sponsored by Lausitz Energie Kraftwerke AG.</p>

<p><a href=\"http://www.leag.de\">www.leag.de</a> </p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>", revisions="<html>
<body>
<table>
  <tr>
    <th style=\"text-align: left;\">Date</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Version</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Author</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Affiliation</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Changes</th>
  </tr>
  <tr>
    <td>2020-08-20</td>
    <td> </td>
    <td>ClaRa 1.6.0</td>
    <td> </td>
    <td>Friedrich Gottelt</td>
    <td> </td>
    <td>FVTR GmbH</td>
    <td> </td>
    <td>Initial version of model</td>
  </tr>
</table>
<p>Version means first ClaRa version where the applied change was published.</p>
</body>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{220,60}},
        initialScale=0.1),     graphics={
        Text(
          extent={{-80,40},{160,-30}},
          lineColor=DynamicSelect({164,167,170}, if gasSignal.m_flow > 0 then {118,106,98} else {235,183,0}),
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("m", String(fuelSignal.m_flow,format="1." + String(decimalSpaces.m_flow) + "f") + " kg/s")),
        Line(
          points={{-100,60},{-100,-40}},
          color=DynamicSelect({164,167,170},{118,106,98}),
          smooth=Smooth.None,thickness=0.5)}), Diagram(graphics,
                                                       coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{220,60}},
        initialScale=0.1)));

end FuelMassFlowSensor;
