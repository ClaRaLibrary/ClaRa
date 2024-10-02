within ClaRa.StaticCycles.Fittings;
model SprayAttemperator2 "Mixer || blue | yellow | blue"
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
  // Blue input: Values of m_flow and h are unknown and provided BY neighbor component, value of p is provided FOR neighbour.
  // Yellow input:    Value of m_flow are known in component and provided FOR neighbor component, values of p and h are unknown and provided BY neighbor component.
  // Blue output: Values of m_flow and h are known in component and provided FOR neighbor component, value of p is provided BY neighbour..
  outer ClaRa.SimCenter simCenter;

   //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet1;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet2;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
  end Summary;

  Summary summary(
  inlet1(
     m_flow=m_flow_1,
     h=h1,
     p=p),
  inlet2(
     m_flow=m_flow_2,
     h=h2,
     p=p),
  outlet(
     m_flow=m_flow_3,
     h=h3,
     p=p));
  //---------Summary Definition---------

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false) "Specific enthalpy of flow 1";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h2(fixed=false) "Specific enthalpy of flow 2";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false) "Mass flow rate of flow 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2 = (h3*m_flow_3 - h1*m_flow_1)/h2 "Mass flow rate of flow 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h3 = TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(medium, p, T, zeros(medium.nc - 1)) "Mixer outlet enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3=m_flow_1 + m_flow_2 "Mixer outlet mass flow rate";
  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Mixer pressure";
  final parameter ClaRa.Basics.Units.Pressure p2(fixed=false) "Coolant pressure";

  parameter ClaRa.Basics.Units.Temperature T "Outlet Temperature";

  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inlet_1(Medium=medium,
     p= p) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_yellow_a inlet_2(
    m_flow=m_flow_2,
    Medium=medium) annotation (Placement(transformation(
        extent={{-10,-30},{10,-40}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,-30},{10,-40}},
        rotation=0,
        origin={0,-0})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outlet(
    h=h3,
    m_flow=m_flow_3,
    Medium=medium) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  outlet.p=p;
  inlet_1.h=h1;
  inlet_1.m_flow=m_flow_1;
  inlet_2.h=h2;
  inlet_2.p=p2
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
         Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-30},{50,30}}),
                         graphics={
        Rectangle(extent={{-50,30},{50,-30}},
          lineColor = DynamicSelect({0,131,169}, if m_flow_2 <= 0 or p2<=p then {235,183,0} else {0,131,169}),
          fillColor={255,255,255},
          fillPattern = DynamicSelect(FillPattern.Solid, if m_flow_2 <= 0 then FillPattern.Backward else if p2<p then FillPattern.CrossDiag else FillPattern.Solid)),
        Line(
          points={{0,-30},{0,0},{20,20}},
          color={0,131,169},
          smooth=Smooth.None),
        Line(
          points={{20,0},{0,0},{20,-20}},
          color={0,131,169},
          smooth=Smooth.None)}),            Diagram(coordinateSystem(
          preserveAspectRatio=true,  extent={{-60,-20},{60,30}}),     graphics));

end SprayAttemperator2;
