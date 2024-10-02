within ClaRa.StaticCycles.Storage;
model Separator "Ideal steam separator"

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

   //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_dew;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_bub;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_1,
     h=h1,
     p=p),
  outlet_bub(
     m_flow=m_flow_bub,
     h=h_bub,
     p=p),
  outlet_dew(
     m_flow=m_flow_dew,
     h=h_dew,
     p=p));
  //---------Summary Definition---------

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component";
  //parameter Real steamQuality_out2 = 1 "Steam quality at outlet2";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false) "Specific enthalpy of flow 1";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_dew = TILMedia.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, p, zeros(medium.nc - 1)) "Dew outlet enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_bub = TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p, zeros(medium.nc - 1)) "Bubble outlet enthalpy";
  final parameter ClaRa.Basics.Units.MassFraction steamQuality_1 = TILMedia.VLEFluidFunctions.steamMassFraction_phxi(medium, p, h1, zeros(medium.nc - 1)) "Bubble outlet enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false) "Mass flow rate of flow 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_dew = m_flow_1*steamQuality_1;
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_bub = m_flow_1*(1-steamQuality_1);
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Mixer pressure";
  final parameter ClaRa.Basics.Units.Pressure p_check(fixed=false) "Mixer pressure";
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inlet(Medium=medium,
     p = p) "Wet steam"
    annotation (Placement(transformation(extent={{96,-10},{104,10}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outlet1(
    h=h_bub,
    m_flow=m_flow_bub,
    Medium=medium) "Boiling liquid"
    annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={0,-100})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outlet2(
    h=h_dew,
    m_flow=m_flow_dew,
    Medium=medium) "Saturated steam"
    annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={0,100})));

initial equation
  outlet2.p=p;
  outlet1.p=p_check;
  inlet.h=h1;
  inlet.m_flow=m_flow_1;

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
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-100,100},{100,100},{100,-60},{0,-100},{-100,-60},{-100,100}},
          lineColor=DynamicSelect({0,131,169}, if abs(p_check - p) > 100 then {204,79,70} else {0,131,169}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if abs(p_check - p) > 100 then FillPattern.Forward else FillPattern.Solid)),
        Line(points={{-100,0},{100,0}}, color={0,131,169}),
        Polygon(
          points={{-54,20},{-34,0},{-14,20},{-54,20}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(
          preserveAspectRatio=false)));
end Separator;
