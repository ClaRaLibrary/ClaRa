within ClaRa.StaticCycles.ValvesConnects;
model Buffer_setFlow1 "Flow Anchour || par.: m_flow_nom || green | green"
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
// Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
// Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
//outer parameter Real P_target_ "Target power in p.u.";
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
     p=p_in,
     rho = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(vleMedium, p_in, h_in, vleMedium.xi_default)),
  outlet(
     m_flow=m_flow_out,
     h=h_out,
     p=p_out,
     rho=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(vleMedium, p_out, h_out, vleMedium.xi_default)));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_out "Nominal mass flow" annotation (Dialog(group="Fundamental Definitions"));

  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out=p_in "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_in(fixed=false) "Inlet mass flow";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_diff=m_flow_in - m_flow_out "Rprt: Mass flow difference";
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_a inlet(Medium=vleMedium) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b outlet(
    h=h_out,
    m_flow=m_flow_out,
    p=p_out, Medium=vleMedium) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  inlet.p=p_in;
  inlet.h=h_in;
  m_flow_in = inlet.m_flow;

equation

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
   Icon(coordinateSystem(preserveAspectRatio=false,          extent={{-50,-25},{50,25}}),
                   graphics={
        Text(
          extent={{-20,6},{20,-4}},
          lineColor=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169}),
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Line(points={{-50,0},{-25,0}}, color=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169})),
        Line(points={{25,0},{50,0}}, color=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169})),
        Ellipse(
          extent={{-25,25},{25,-25}},
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if abs(m_flow_diff) > 1e-3 then FillPattern.Backward else FillPattern.Solid),
          lineColor=DynamicSelect({0,131,169}, if abs(m_flow_diff) > 1e-3 then {234,171,0} else {0,131,169}))}),
                                 Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-25},{50,25}}),   graphics));
end Buffer_setFlow1;
