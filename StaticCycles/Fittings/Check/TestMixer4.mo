within ClaRa.StaticCycles.Fittings.Check;
model TestMixer4
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
  inner parameter   Real P_target_=1;

  ClaRa.StaticCycles.Fittings.Mixer4 mixer4_1(splitRatio=0.7) annotation (Placement(transformation(extent={{-4,4},{6,10}})));
  ClaRa.StaticCycles.Boundaries.Source_yellow source_yellow(h=2000e3, p=1e5) annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  ClaRa.StaticCycles.Boundaries.Sink_yellow sink_yellow(m_flow=10) annotation (Placement(transformation(extent={{24,-4},{44,16}})));
  ClaRa.StaticCycles.Boundaries.Source_yellow source_yellow1(h=3000e3, p=2e5) annotation (Placement(transformation(extent={{-60,-24},{-40,-4}})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{-96,-74},{-56,-54}})));
  ValvesConnects.Valve_dp_nom4 valve_dp_nom4_1(Delta_p_nom=0.5e5) annotation (Placement(transformation(extent={{-30,8},{-20,12}})));
  ValvesConnects.Valve_dp_nom4 valve_dp_nom4_2(Delta_p_nom=0.5e5) annotation (Placement(transformation(extent={{-32,-16},{-22,-12}})));
equation
  connect(mixer4_1.outlet, sink_yellow.inlet) annotation (Line(points={{6.5,9},{15.25,9},{15.25,6},{23.5,6}}, color={0,131,169}));
  connect(valve_dp_nom4_1.inlet, source_yellow.outlet) annotation (Line(points={{-30.5,10},{-39.5,10}},
                                                                                                      color={0,131,169}));
  connect(valve_dp_nom4_1.outlet, mixer4_1.inlet_1) annotation (Line(points={{-19.5,10},{-12,10},{-12,9},{-4.5,9}},
                                                                                                  color={0,131,169}));
  connect(source_yellow1.outlet, valve_dp_nom4_2.inlet) annotation (Line(points={{-39.5,-14},{-32.5,-14}},
                                                                                                         color={0,131,169}));
  connect(valve_dp_nom4_2.outlet, mixer4_1.inlet_2) annotation (Line(points={{-21.5,-14},{1,-14},{1,3.5}},
                                                                                                         color={0,131,169}));
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
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
end TestMixer4;
