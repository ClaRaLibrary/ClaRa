within ClaRa.StaticCycles.Boundaries;
model Source_purple
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
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component";

  parameter ClaRa.Basics.Units.Temperature T_fg_nom;
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_nom;
  parameter ClaRa.Basics.Units.MassFraction xi_fg_nom[flueGas.nc - 1]=flueGas.xi_default;
  final parameter ClaRa.Basics.Units.Pressure p_fg_nom(fixed=false);

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_purple_b outlet(
    flueGas=flueGas,
    T=T_fg_nom,
    m_flow=m_flow_fg_nom,
    xi=xi_fg_nom) annotation (Placement(transformation(extent={{100,-10},{108,10}})));

initial equation
  p_fg_nom=outlet.p;
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
       Text(
          extent={{-60,60},{60,20}},
          lineColor={168,88,171},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow_fg_nom"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={168,88,171},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%T_fg_nom"),
        Text(
          extent={{-60,-20},{60,-60}},
          lineColor={168,88,171},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%xi_fg_nom"),
        Line(points={{60,100},{100,0},{60,-100}}, color={168,88,171})}),
                                                                 Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Source_purple;
