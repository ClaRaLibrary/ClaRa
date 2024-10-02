within ClaRa.StaticCycles.Fittings.Check;
model TestMixSplitGas
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  ClaRa.StaticCycles.Fittings.SplitGas1 splitGas1_1 annotation (Placement(transformation(extent={{-20,25},{-10,31}})));
  ClaRa.StaticCycles.Fittings.MixerGas1 mixerGas1_1 annotation (Placement(transformation(extent={{-20,-57},{-10,-65}})));
  ValvesConnects.ValveGas_cutPressure1 valveGas_cutPressure1_1 annotation (Placement(transformation(
        extent={{-5,-2},{5,2}},
        rotation=270,
        origin={-15,-14})));
  ClaRa.StaticCycles.Boundaries.Source_brown source_brown(xi_fg_nom=source_brown.flueGas.xi_default) annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  ClaRa.StaticCycles.Boundaries.Sink_brown sink_brown(
    T_fg_nom=500,
    m_flow_fg_nom=10,
    p_fg_nom=1e5) annotation (Placement(transformation(extent={{30,20},{50,40}})));
  ClaRa.StaticCycles.Boundaries.Source_orange source_orange(T_fg_nom=300, xi_fg_nom=source_orange.flueGas.xi_default) annotation (Placement(transformation(extent={{-88,-74},{-68,-54}})));
  Boundaries.Sink_orange sink_orange(m_flow_nom=5, p_nom=0.8e5) annotation (Placement(transformation(extent={{86,-74},{106,-54}})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{-68,60},{-28,80}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas annotation (Placement(transformation(extent={{-38,30},{-20,48}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas1 annotation (Placement(transformation(extent={{2,32},{20,52}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas2 annotation (Placement(transformation(extent={{-58,-53},{-38,-35}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas3 annotation (Placement(transformation(extent={{28,-63},{44,-46}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas4 annotation (Placement(transformation(extent={{-12,-40},{14,-26}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas5 annotation (Placement(transformation(extent={{-10,-2},{10,12}})));
  ClaRa.StaticCycles.Fittings.MixerGas2 mixerGas2_1(m_flow_in2=3) annotation (Placement(transformation(extent={{4,-69},{14,-63}})));
  ClaRa.StaticCycles.Fittings.SplitGas2 splitGas2_1 annotation (Placement(transformation(extent={{-48,-66},{-38,-60}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas6 annotation (Placement(transformation(extent={{-30,-63},{-10,-45}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas7 annotation (Placement(transformation(extent={{-42,-91},{-22,-73}})));
  ClaRa.StaticCycles.Furnace.TripleFlueGas tripleFlueGas8 annotation (Placement(transformation(extent={{-4,-63},{16,-45}})));
equation
  connect(splitGas1_1.outlet_2, valveGas_cutPressure1_1.inlet) annotation (Line(points={{-15,24.6},{-15,-8.5}},                       color={118,106,98}));
  connect(valveGas_cutPressure1_1.outlet, mixerGas1_1.inlet_2) annotation (Line(points={{-15,-19.5},{-15,-56.4667}},                color={118,106,98}));
  connect(splitGas1_1.inlet, source_brown.outlet) annotation (Line(points={{-20.4,30},{-49.6,30}},                       color={118,106,98}));
  connect(sink_brown.inlet, splitGas1_1.outlet_1) annotation (Line(points={{29.6,30},{-9.6,30}},                 color={118,106,98}));
  connect(tripleFlueGas.gasSignal, source_brown.outlet) annotation (Line(points={{-38.5625,37.0714},{-38.5625,30},{-49.6,30}},
                                                                                                                color={118,106,98}));
  connect(sink_brown.inlet, tripleFlueGas1.gasSignal) annotation (Line(points={{29.6,30},{2,30},{2,39.8571},{1.4375,39.8571}},
                                                                                                                  color={118,106,98}));
  connect(sink_orange.inlet, tripleFlueGas3.gasSignal) annotation (Line(points={{85.6,-64},{28,-64},{28,-56.3214},{27.5,-56.3214}},
                                                                                                                          color={118,106,98}));
  connect(valveGas_cutPressure1_1.outlet, tripleFlueGas4.gasSignal) annotation (Line(points={{-15,-19.5},{-15,-34.5},{-12.8125,-34.5}},
                                                                                                                     color={118,106,98}));
  connect(splitGas1_1.outlet_2, tripleFlueGas5.gasSignal) annotation (Line(points={{-15,24.6},{-15,3.5},{-10.625,3.5}},
                                                                                                        color={118,106,98}));
  connect(mixerGas1_1.outlet, mixerGas2_1.inlet_1) annotation (Line(points={{-9.6,-63.6667},{-9.6,-64.3333},{3.6,-64.3333},{3.6,-64}}, color={118,106,98}));
  connect(mixerGas2_1.outlet, sink_orange.inlet) annotation (Line(points={{14.4,-64},{85.6,-64}}, color={118,106,98}));
  connect(source_orange.outlet, tripleFlueGas2.gasSignal) annotation (Line(points={{-67.6,-64},{-62,-64},{-62,-45.9286},{-58.625,-45.9286}}, color={118,106,98}));
  connect(source_orange.outlet, splitGas2_1.inlet) annotation (Line(points={{-67.6,-64},{-58,-64},{-58,-61},{-48.4,-61}}, color={118,106,98}));
  connect(splitGas2_1.outlet_1, mixerGas1_1.inlet_1) annotation (Line(points={{-37.6,-61},{-28.8,-61},{-28.8,-63.6667},{-20.4,-63.6667}}, color={118,106,98}));
  connect(splitGas2_1.outlet_2, mixerGas2_1.inlet_2) annotation (Line(points={{-43,-66.4},{-43,-90},{9,-90},{9,-69.4}}, color={118,106,98}));
  connect(splitGas2_1.outlet_1, tripleFlueGas6.gasSignal) annotation (Line(points={{-37.6,-61},{-35.1125,-61},{-35.1125,-55.9286},{-30.625,-55.9286}}, color={118,106,98}));
  connect(splitGas2_1.outlet_2, tripleFlueGas7.gasSignal) annotation (Line(points={{-43,-66.4},{-43,-76.1643},{-42.625,-76.1643},{-42.625,-83.9286}}, color={118,106,98}));
  connect(mixerGas1_1.outlet, tripleFlueGas8.gasSignal) annotation (Line(points={{-9.6,-63.6667},{-9.6,-55.9286},{-4.625,-55.9286}}, color={118,106,98}));
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
         Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
end TestMixSplitGas;
