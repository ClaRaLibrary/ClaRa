within ClaRa.StaticCycles.ValvesConnects;
model FlowAnchor_cutPressure1 "Valve || yellow | blue"
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
   // Yellow input: Values of p and h are unknown and provided BY neighbor component, value of m_flow is known and provided FOR neighbor component.
   // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE_a inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE_a outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow,
     h=h_in,
     p=p_in,
     rho = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(vleMedium, p_in, h_in, vleMedium.xi_default)),
  outlet(
     m_flow=m_flow,
     h=h_out,
     p=p_out,
     rho=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(vleMedium, p_out, h_out, vleMedium.xi_default)));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rate" annotation (Dialog(group="Nominal Operation Point"));
  parameter Real CharLine_m_flow_P_target_[:,:]=[0,1;1,1] "Characteristic line of pressure drop as function of mass flow rate" annotation(Dialog(group="Part Load Definition"));

  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.Pressure Delta_p=p_in - p_out "Pressure difference";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Actual mass flow";
  outer parameter Real P_target_ "Target power in p.u.";
protected
  Modelica.Blocks.Tables.CombiTable1Dv table(table=CharLine_m_flow_P_target_, u = {P_target_});

public
  Fundamentals.SteamSignal_yellow_a inlet(m_flow=m_flow, Medium=vleMedium) annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  Fundamentals.SteamSignal_blue_b outlet(m_flow=m_flow, h=h_out, Medium=vleMedium) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  m_flow = table.y[1] * m_flow_nom;
  outlet.p=p_out;
  inlet.p=p_in;
  inlet.h=h_in;

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
   Icon(coordinateSystem(preserveAspectRatio=true,extent={{-50,-25},{50,25}}),
                   graphics={
        Line(points={{-50,0},{50,0}}, color={0,131,169}),
        Polygon(
          points={{-40,-25},{40,0},{-40,25}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern={0,131,169},
          origin={0,0},
          rotation=360,
          lineThickness=0.25),
        Text(
          extent={{-60,40},{60,20}},
          lineColor={0,131,169},
          textString="%m_flow_nom")}),
                                 Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-25},{50,25}}),   graphics));
end FlowAnchor_cutPressure1;
