within ClaRa.Components.Adapters;
model GasSensorAdapter

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
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1   "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  inner parameter ClaRa.Basics.Media.Slag.PartialSlag slagType=simCenter.slagModel "Slag properties" annotation (choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));
  inner parameter TILMedia.GasTypes.BaseGas               flueGas = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));
  ClaRa.Basics.Interfaces.FuelSlagFlueGas_outlet outlet(
    flueGas(Medium=flueGas),
    fuelModel=fuelModel,
    final slagType=slagType) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,0})));
  ClaRa.Basics.Interfaces.GasPortIn gasPort(Medium=flueGas) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FuelSlagFlueGas_inlet inlet(
    flueGas(Medium=flueGas),
    fuelModel=fuelModel,
    final slagType=slagType) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-100,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,0})));
equation
  connect(inlet, outlet) annotation (Line(
      points={{-100,0},{100,0}},
      color={118,106,98},
      thickness=0.5));
  connect(inlet.flueGas, gasPort) annotation (Line(
      points={{-100,-7},{-52,-7},{-52,-8},{0,-8},{0,-100}},
      color={118,106,98},
      thickness=0.5));
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
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-92,-4},{92,-4},{90,-4}},
          color={118,106,98},
          thickness=0.5),
        Line(
          points={{-92,-4},{0,-4},{0,-96}},
          color={118,106,98},
          thickness=0.5),
        Line(
          points={{-92,0},{92,0},{90,0}},
          color={27,36,42},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-92,4},{92,4}},
          color={234,171,0},
          thickness=0.5)}),                                      Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)));
end GasSensorAdapter;
