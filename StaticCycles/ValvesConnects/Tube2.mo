within ClaRa.StaticCycles.ValvesConnects;
model Tube2 " Tube || green | green"
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
  // Green input: Values of p, m_flow and h are unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow,
     h=h_in,
     p=p_in),
  outlet(
     m_flow=m_flow,
     h=h_in,
     p=p_out));
  //---------Summary Definition---------

  outer parameter Real P_target_ "Target power in p.u.";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_nom "Nominal pressure loss" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real CharLine_Delta_p_fric_P_target_[:,2]=[0,0;1,1] "Characteristic line of friction loss as function of mass flow rate" annotation(Dialog(group="Part Load Definition"));

  parameter ClaRa.Basics.Units.Length z_in=0.0 "Geodetic height at inlet" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length z_out=0.0 "Geodetic height at outlet" annotation (Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length Delta_x[:]=fill(abs(z_in - z_out)/3, 3) "Discretisation scheme" annotation (Dialog(group="Discretisation (for reporting only)"));
  parameter Boolean frictionAtInlet = false "True if pressure loss between first cell and inlet shall be considered"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));
  parameter Boolean frictionAtOutlet = false "True if pressure loss between last cell and outlet shall be considered"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow through pipe";
  final parameter ClaRa.Basics.Units.Pressure p_out=p_in - Delta_p_fric - Delta_p_geo "pressure at tube inlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "enthalpy at tube inlet";
  constant ClaRa.Basics.Units.MassFraction[:] xi=zeros(medium.nc - 1);
  final parameter ClaRa.Basics.Units.Pressure Delta_p_geo=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      medium,
      p_in,
      h_in,
      xi)*Modelica.Constants.g_n*(z_out - z_in) "Geostatic pressure difference";
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter Integer N_cv = size(Delta_x,1) "Number of finite volumes";
  final parameter ClaRa.Basics.Units.PressureDifference Delta_p_fric(fixed=false) "Actual friction pressure loss";

  final parameter ClaRa.Basics.Units.Pressure p[N_cv]=Basics.Functions.pressureInterpolation(
      p_in,
      p_out,
      Delta_x,
      frictionAtInlet,
      frictionAtOutlet) "Rprt: Discretisised pressure";
protected
  Modelica.Blocks.Tables.CombiTable1Dv table(table=CharLine_Delta_p_fric_P_target_, u = {P_target_});

public
  Fundamentals.SteamSignal_green_a inlet(Medium=medium) annotation (Placement(transformation(extent={{-100,-10},{-110,10}}), iconTransformation(extent={{-100,-10},{-110,10}})));
  Fundamentals.SteamSignal_green_b outlet(
    m_flow=m_flow,
    h=h_in,
    p=p_out, Medium=medium) annotation (Placement(transformation(extent={{110,-10},{100,10}}), iconTransformation(extent={{110,-10},{100,10}})));
initial equation
  Delta_p_fric = table.y[1] * Delta_p_nom;
  inlet.p=p_in;
  inlet.m_flow=m_flow;
  inlet.h=h_in;
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
   Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-40},{100,40}}),
                   graphics={
         Polygon(
          points={{-100,40},{-80,40},{-60,30},{60,30},{80,40},{100,40},{100,-40},{80,-40},{60,-30},{-60,-30},{-80,-40},{-100,-40},{-100,40}},
          lineColor={0,131,169},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,40},{-72,40},{-60,30},{-60,-30},{-80,-40},{-100,-40},{-100,40}},
          lineColor={0,131,169},
          fillColor= DynamicSelect({255,255,255}, if frictionAtInlet then {0,131,169} else {255,255,255}),
          fillPattern=FillPattern.Solid),
        Polygon(points={{100,40},{80,40},{60,30},{60,-30},{80,-40},{100,-40},{100,40}},
          lineColor={0,131,169},
          fillColor= DynamicSelect({255,255,255}, if frictionAtOutlet then {0,131,169} else {255,255,255}),
          fillPattern=FillPattern.Solid)}),
                                 Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-75},{100,75}}), graphics));
end Tube2;
