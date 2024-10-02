within ClaRa.StaticCycles.Fittings;
model HeaterCooler "orange | orange"
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
  // Orange input:   Value of T and xi are known in component and provided FOR neighbor component, values of p and m_flow are unknown and provided BY neighbor component.
  // Orange output:   Value of T and xi are unknown in component and provided BY neighbor component, values of p and m_flow are known and provided FOR neighbor component.
  import TILMedia.GasFunctions.specificEnthalpy_pTxi;
  import TILMedia.GasFunctions.temperature_phxi;
  outer ClaRa.SimCenter simCenter;

  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeGas inlet;
    ClaRa.Basics.Records.StaCyFlangeGas outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_in,
     T=T_in,
     p=p,
     xi=xi_in),
  outlet(
     m_flow=m_flow_out,
     T=T_out,
     p=p,
     xi=xi_out));
  //---------Summary Definition---------

  parameter TILMedia.GasTypes.BaseGas gas = simCenter.flueGasModel "Flue gas model used in component" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.HeatFlowRate Q_flow  "Heat flow rate";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_out(fixed = false) "Mass flow at outlet 1";
  final parameter ClaRa.Basics.Units.MassFraction xi_in[gas.nc - 1](each fixed = false) "Gas composition inlet 1";
  final parameter ClaRa.Basics.Units.MassFraction xi_out[gas.nc - 1] = xi_in;

  final parameter ClaRa.Basics.Units.Temperature T_in(fixed=false);
  final parameter ClaRa.Basics.Units.Temperature T_out = temperature_phxi(gas, p, (specificEnthalpy_pTxi(gas, p, T_in, xi_in)*m_flow_in + Q_flow)/m_flow_out, xi_out);

  final parameter ClaRa.Basics.Units.Pressure p(fixed = false);

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_in = m_flow_out;

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_orange_a inlet(flueGas=gas, p=p, m_flow=m_flow_in) annotation (Placement(transformation(extent={{-68,10},{-60,30}})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_orange_b outlet(flueGas=gas, T=T_out, xi=xi_out)  annotation (Placement(transformation(extent={{40,10},{48,30}})));

initial equation
  xi_in = inlet.xi;
  T_in =inlet.T;

  m_flow_out = outlet.m_flow;
  p= outlet.p;

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
         Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,0},{40,40}}), graphics={
                                   Polygon(
          points={{-60,30},{40,30},{40,10},{0,10},{0,10},{-20,10},{-20,10},{-60,10},{-60,30}},
          lineColor={118,106,98},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(points={{-40,16},{-20,22},{0,16},{20,22}}, color={167,25,48})}),                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,0},{40,40}}),   graphics={
                                   Polygon(
          points={{-60,30},{40,30},{40,10},{0,10},{0,10},{-20,10},{-20,10},{-60,10},{-60,30}},
          lineColor={118,106,98},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(points={{-40,16},{-20,22},{0,16},{20,22}}, color={167,25,48})}));
end HeaterCooler;
