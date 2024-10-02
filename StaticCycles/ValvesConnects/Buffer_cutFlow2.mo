within ClaRa.StaticCycles.ValvesConnects;
model Buffer_cutFlow2 "Buffer || blue | yellow"
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
  // Blue input: Values of p and h are unknown and provided BY neighbor component, value of m_flow is known and provided FOR neighbor component.
  // Yellow output: Values of p and h are known in component and provided FOR neighbor component, m_flow is provided BY neighbor.
    //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE_a inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE_a outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_in,
     h=h_in,
     p=p,
     rho = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(vleMedium, p, h_in, vleMedium.xi_default)),
  outlet(
     m_flow=m_flow_out,
     h=h_out,
     p=p,
     rho=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(vleMedium, p, h_out, vleMedium.xi_default)));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p "System pressure";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_in(fixed=false) "Inlet mass flow rate";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_out(fixed=false) "Inlet mass flow rate";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_diff=m_flow_in - m_flow_out "Rprt: Mass flow difference";

  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inlet(p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_yellow_b outlet(h=h_out,
    p=p,
    Medium=vleMedium) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  //outlet.p=p_out;

  inlet.m_flow = m_flow_in;
  outlet.m_flow=m_flow_out;

  inlet.h=h_in;
equation

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
         Icon(coordinateSystem(preserveAspectRatio=true,extent={{-50,-25},{50,25}}), graphics={
        Line(points={{-50,0},{-25,0}}, color=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169})),
        Line(points={{25,0},{50,0}}, color=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169})),
        Ellipse(
          extent={{-25,25},{25,-25}},
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if abs(m_flow_diff) > 1e-1 then FillPattern.Forward else FillPattern.Solid),
          lineColor=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169}))}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}}),   graphics));
end Buffer_cutFlow2;
