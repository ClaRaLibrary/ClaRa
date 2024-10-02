within ClaRa.Components.Sensors;
model TinySensorGas_L1_p "Ideal TINY one port pressure sensor"
  //This model douplicates the respective ClaRa sensor changing its icon size //

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

  extends ClaRa.Basics.Icons.PressureSensor;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Integer unitOption = 2 "Unit of output" annotation(choicesAllMatching,  Dialog(group="Fundamental Definitions"), choices(choice=1 "Pa", choice=2 "bar", choice=3 "mbar", choice=4 "MPa", choice = 5 "per Unit"));
  parameter ClaRa.Basics.Units.Pressure p_ref[2]={0,1e5} "Reference pressure [min,max]" annotation (Dialog(group="Fundamental Definitions", enable=(unitOption == 5)));

  final parameter String unit = if unitOption==1 then " Pa" elseif unitOption==2 then " bar" elseif unitOption == 3 then " mbar" elseif unitOption==4 then " MPa" else " p.u.";
  Modelica.Blocks.Interfaces.RealOutput p "pressure in port medium" annotation (Placement(
        transformation(extent={{60,-40},{80,-20}},
                                                 rotation=0),
        iconTransformation(extent={{60,-40},{80,-20}})));

//  constant Real c_bar(unit="bar/Pa") = 1e-5;
  ClaRa.Basics.Interfaces.GasPortIn   port(Medium=medium) annotation (Placement(
        transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));

equation
  if unitOption==1 then
    p = port.p;
  elseif unitOption==2 then
    p=port.p/1e5;
  elseif unitOption==3 then
    p=port.p/100;
  elseif unitOption==4 then
    p=port.p/1e6;
  elseif unitOption==5 then
    p = (port.p- p_ref[1])/(p_ref[2]-p_ref[1]);
  else
    p=-1; //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;
  port.m_flow = 0;
  port.T_outflow = 0;
  port.xi_outflow = zeros(medium.nc - 1);

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
</html>",
        revisions="<html>
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
         Diagram(coordinateSystem(extent={{-60,-100},{60,20}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-100},{60,20}}),
                                      graphics={
        Text(
          extent={{-58,16},{62,-64}},
          lineColor={118,124,127},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="p"),
        Text(
          extent={{-80,24},{80,54}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if p > 0 then {118,106,98} else {167,25,48}),
          textString=DynamicSelect(" p ", String(p,format="1.1f") + unit),
          horizontalAlignment=TextAlignment.Center),
        Line(points={{60,-30},{46,-30}}, color={27,36,42})}));
end TinySensorGas_L1_p;
