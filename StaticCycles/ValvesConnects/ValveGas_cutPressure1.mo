within ClaRa.StaticCycles.ValvesConnects;
model ValveGas_cutPressure1 "Valve || green | purple"
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

  import TILMedia.GasFunctions.specificEnthalpy_pTxi;
  import TILMedia.GasFunctions.temperature_phxi;

  //---------Summary Definition---------
   model Summary
     extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeGas_a inlet;
    ClaRa.Basics.Records.StaCyFlangeGas_a outlet;
   end Summary;

   Summary summary(
   inlet(mediumModel=gas,
      m_flow=m_flow,
      T=T_in,
      p=p_in,
      xi=xi_in,
      rho = TILMedia.GasFunctions.density_pTxi(gas, p_in, T_in, xi_in)),
   outlet(mediumModel=gas,
      m_flow=m_flow,
      T=T_out,
      p=p_out,
      xi=xi_out,
      rho=TILMedia.GasFunctions.density_pTxi(gas, p_out, T_out, xi_out)));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.GasTypes.BaseGas gas = simCenter.flueGasModel "Flue gas model used in component" annotation(Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";

  final parameter ClaRa.Basics.Units.MassFraction xi_in[gas.nc-1](each fixed=false);
  final parameter ClaRa.Basics.Units.MassFraction xi_out[gas.nc-1] = xi_in;

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow rate";
  final parameter ClaRa.Basics.Units.Temperature T_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_out= temperature_phxi(gas, p_out, specificEnthalpy_pTxi(gas, p_in, T_in, xi_in), xi_out) "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.Pressure Delta_p=p_in-p_out "Pressure difference";
protected
  final parameter ClaRa.Basics.Units.Pressure Delta_p_nom=p_in-p_out "Nominal pressure drop";

public
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_green_a inlet(flueGas=gas) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_purple_b outlet(
    m_flow=m_flow,
    T=T_out,
    flueGas=gas,
    xi=xi_out) annotation (Placement(transformation(extent={{50,-10},{60,10}}),
                                                                              iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  outlet.p=p_out;
  inlet.p=p_in;
  inlet.T=T_in;
  inlet.m_flow=m_flow;
  inlet.xi = xi_in;

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
        Polygon(
          points={{-50,25},{-20,25},{-20,25},{-20,15},{0,5},{20,15},{20,25},{20,25},{50,25},{50,25},{50,-25},{50,-25},{20,-25},{20,-25},{20,-15},{0,-5},{-20,-15},{-20,-25},{-20,-25},{-50,-25},{-50,-25},{-50,25},{-50,25}},
          smooth=Smooth.Bezier,
          lineColor=DynamicSelect({118, 106, 98}, if Delta_p > 0 then {118, 106, 98} else {235,183,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_p > 0 then FillPattern.Solid else FillPattern.Backward))}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}}),   graphics));
end ValveGas_cutPressure1;
