within ClaRa.StaticCycles.Fittings;
model SplitGas3 "brown | brown | brown"
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
  // Brown input:   Value of xi is known in component and provided FOR neighbor component, values of p, T and m_flow are unknown and provided BY neighbor component.
  // Brown output:  Value of p, T and m_flow are known in component and provided FOR neighbor component, value of xi is unknown and provided BY neighbor component.
  outer ClaRa.SimCenter simCenter;

       //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeGas inlet;
    ClaRa.Basics.Records.StaCyFlangeGas outlet1;
    ClaRa.Basics.Records.StaCyFlangeGas outlet2;
  end Summary;

  Summary summary(
  inlet(mediumModel=gas,
     m_flow=m_flow_in,
     T=T,
     p=p,
     xi=xi),
  outlet1(mediumModel=gas,
     m_flow=m_flow_out1,
     T=T,
     p=p,
     xi=xi),
  outlet2(mediumModel=gas,
     m_flow=m_flow_out2_nom,
     T=T,
     p=p,
     xi=xi));
  //---------Summary Definition---------

  parameter TILMedia.GasTypes.BaseGas gas = simCenter.flueGasModel "Flue gas model used in component" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_out2_nom= 1 "Nominal mass flow through outlet 2";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_out1(fixed = false) "Mass flow at outlet 1";
  final parameter ClaRa.Basics.Units.MassFraction xi[gas.nc - 1](each fixed = false) "Gas composition";
  final parameter ClaRa.Basics.Units.Temperature T(fixed = false);
  final parameter ClaRa.Basics.Units.Pressure p(fixed = false);
  final parameter ClaRa.Basics.Units.Pressure p2(fixed = false);

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_in = m_flow_out1+m_flow_out2_nom;

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_a inlet(flueGas=gas,T=T, p=p, m_flow=m_flow_in) annotation (Placement(transformation(extent={{-68,20},{-60,40}})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_b outlet_1(flueGas=gas,xi=xi)  annotation (Placement(transformation(extent={{40,20},{48,40}})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_b outlet_2(flueGas=gas,xi=xi) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-10,-24})));

initial equation

  xi = inlet.xi;

  m_flow_out1 =outlet_1.m_flow;
  T = outlet_1.T;
  p= outlet_1.p;

  m_flow_out2_nom =outlet_2.m_flow;
  T = outlet_2.T;
  p2= outlet_2.p;

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
         Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-20},{40,40}}), graphics={
                                   Polygon(
          points={{-60,40},{40,40},{40,20},{0,20},{0,-20},{-20,-20},{-20,20},{
              -60,20},{-60,40}},
          lineColor={118,106,98},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                                                  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-20},{40,40}}), graphics={
                                   Polygon(
          points={{-60,40},{40,40},{40,20},{0,20},{0,-20},{-20,-20},{-20,20},{
              -60,20},{-60,40}},
          lineColor={118,106,98},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end SplitGas3;
