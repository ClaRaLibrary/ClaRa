within ClaRa.Components.Sensors;
model TinySensorGas_L1_Ex_flow "Sensor that calculates exergy flow"
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

  import      Modelica.Units.SI;
  extends ClaRa.Basics.Icons.FlowSensor;
  outer ClaRa.SimCenter simCenter;
inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
    final parameter String unit = "kJ/s";
  Modelica.Blocks.Interfaces.RealOutput Ex_flow "Exergy flow" annotation (Placement(transformation(origin={0,100}, extent={{20,-20},{-20,20}},rotation=270), iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,40})));
  Modelica.Blocks.Interfaces.RealOutput entropy "Sepecific entropy" annotation (
     Placement(transformation(
        origin={18,100},
        extent={{20,-20},{-20,20}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,10})));
  Modelica.Blocks.Interfaces.RealOutput H_flow "Enthalpy flow"
                                                              annotation (
     Placement(transformation(
        origin={34,100},
        extent={{20,-20},{-20,20}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={70,-20})));

  ClaRa.Basics.Interfaces.GasPortIn   inlet(Medium=medium) "Inlet port" annotation (
      Placement(transformation(extent={{-70,-70},{-50,-50}}),iconTransformation(
          extent={{-70,-70},{-50,-50}})));
  ClaRa.Basics.Interfaces.GasPortOut   outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}}),
        iconTransformation(extent={{50,-70},{70,-50}})));

protected
  TILMedia.Gas_pT      ambience(p=simCenter.p_amb, T=simCenter.T_amb,
    gasType=medium)                                                   annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  TILMedia.Gas_pT      gas(
    p=inlet.p,
    xi=noEvent(actualStream(inlet.xi_outflow)),
    T=noEvent(actualStream(inlet.T_outflow)),
    gasType=medium)          annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  inlet.p = outlet.p;
  inlet.m_flow=-outlet.m_flow;
  inlet.T_outflow = inStream(outlet.T_outflow);
  outlet.T_outflow = inStream(inlet.T_outflow);
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);

  entropy = gas.s;
  Ex_flow = inlet.m_flow*(gas.h-ambience.h-ambience.T*(gas.s-ambience.s));
  H_flow = inlet.m_flow*gas.h;
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
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}}),
                    graphics={             Text(
            extent={{-50,-24},{50,40}},
            lineColor={118,124,127},
            lineThickness=0.5,
          textString="Ex"),
                  Text(
          extent={{-80,64},{80,94}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if Ex_flow > 0 then {118,106,98} else {167,25,48}),
          textString=DynamicSelect(" Ex_flow ", String(Ex_flow/1000, format="1.1f") + unit)),
        Line(
          points={{-60,-60},{60,-60}},
          color={118,106,98},
          thickness=0.5),
        Line(points={{60,10},{46,10}}, color={27,36,42}),
        Line(points={{60,-20},{38,-20}}, color={27,36,42}),
        Line(points={{60,40},{38,40}}, color={27,36,42})}),
   Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}})));
end TinySensorGas_L1_Ex_flow;
