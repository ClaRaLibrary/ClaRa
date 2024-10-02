within ClaRa.StaticCycles.Machines;
model Pump1_real "Real Pump || par.: efficiency || green | blue"
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
  // Blue output: Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
      //---------Summary Definition---------
      model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Basics.Units.Pressure Delta_p "Pressure difference between outlet and inlet" annotation (Dialog);
    parameter Basics.Units.Power P_pump "Pump power" annotation (Dialog);
      end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
        Outline outline;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow,
     h=h_in,
     p=p_in),
  outlet(
     m_flow=m_flow,
     h=h_out,
     p=p_out),
  outline(Delta_p=Delta_p,
     P_pump=P_pump));
  //---------Summary Definition---------
  parameter Real  efficiency= 1 "|Fundamental Definitions|Pump efficiency";
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false, start=1) "Mass flow rate";
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleDensity_pxi(medium, p_in) "Inlet density";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false);
//   final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in=
//       TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_in);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in + (TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_psxi(
      medium,
      p_out,
      TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEntropy_phxi(
        medium,
        p_in,
        h_in)) - h_in)/efficiency "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.Power P_pump=m_flow*(h_out - h_in) "Pump power";
  final parameter ClaRa.Basics.Units.PressureDifference Delta_p=p_in - p_out "Presssure differerence p_in - p_out";

  Fundamentals.SteamSignal_green_a inlet(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-100,10}})));
  Fundamentals.SteamSignal_blue_b outlet(m_flow=m_flow, h=h_out,Medium=medium) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));
initial equation
  inlet.p=p_in;
  inlet.m_flow=m_flow;
  inlet.h=h_in;
  outlet.p=p_out;
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
   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                   graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_p <= 0 then FillPattern.Solid else FillPattern.Backward)),
        Line(
          points={{-98,0},{100,0}},
          color=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          smooth=Smooth.None),
        Line(
          points={{60,40},{100,0},{58,-42}},
          color=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          smooth=Smooth.None)}),
                         Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end Pump1_real;
