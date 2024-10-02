within ClaRa.Components.Sensors;
model TinySensorElectric_L1_P "Ideal TINY one port power sensor"

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

  extends ClaRa.Basics.Icons.PowerSensor;
  parameter Integer unitOption = 2 "Unit of output" annotation(choicesAllMatching,  Dialog(group="Fundamental Definitions"), choices(choice=1 "W", choice=2 "kW", choice=3 "MW", choice=4 "per Unit"));
  parameter ClaRa.Basics.Units.Power P_ref[2]={0,500e6} "Reference power [min,max]" annotation (Dialog(group="Fundamental Definitions", enable=(unitOption == 4)));

  final parameter String unit = if unitOption==1 then " W" elseif unitOption==2 then " kW" elseif unitOption == 3 then " MW" else " p.u.";
  Modelica.Blocks.Interfaces.RealOutput P "active power at port flange" annotation (Placement(
        transformation(extent={{60,-10},{80,10}},rotation=0),
        iconTransformation(extent={{60,-10},{80,10}})));

  ClaRa.Basics.Interfaces.ElectricPortIn inlet annotation (Placement(
        transformation(extent={{-70,-70},{-50,-50}}), iconTransformation(extent={{-70,-70},{-50,-50}})));

  ClaRa.Basics.Interfaces.ElectricPortOut outlet annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
equation
  if unitOption==1 then
    P = inlet.P;
  elseif unitOption==2 then
    P=inlet.P/1e3;
  elseif unitOption==3 then
    P=inlet.P/1e6;
  elseif unitOption==4 then
    P = (inlet.P- P_ref[1])/(P_ref[2]-P_ref[1]);
  else
    P=-1; //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;
  inlet.f = outlet.f;
  inlet.P + outlet.P = 0;
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
</html>"),
Placement(transformation(extent={{42,-2},{62,18}})),
              Diagram(coordinateSystem(extent={{-60,-60},{60,60}})),
                                 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-60},{60,60}}),graphics={
        Text(
          extent={{-54,46},{66,-34}},
          lineColor={118,124,127},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Text(
          extent={{-80,64},{80,94}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if P > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" P ", String(P,format="1.1f") + unit)),
        Line(points={{60,0},{46,0}},     color={27,36,42}),
        Line(
          points={{-60,-60},{60,-60}},
          color={115,150,0},
          thickness=0.5)}));
end TinySensorElectric_L1_P;
