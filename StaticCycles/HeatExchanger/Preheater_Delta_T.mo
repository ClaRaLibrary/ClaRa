within ClaRa.StaticCycles.HeatExchanger;
model Preheater_Delta_T "1ph preheater || par.: shell pressure, shell m_flow, Delta_T"
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
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Red input:    Values of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Blue output:  Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  // Green output: Values of p, m_flow and h are known in component an provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_cond;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_cond;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_tap;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_tap;
  end Summary;
  Summary summary(
  inlet_cond(
     m_flow=m_flow_cond,
     h=h_cond_in,
     p=p_cond),
  outlet_cond(
     m_flow=m_flow_cond,
     h=h_cond_out,
     p=p_cond),
  inlet_tap(
     m_flow=m_flow_tap,
     h=h_tap_in,
     p=p_tap),
  outlet_tap(
     m_flow=m_flow_tap,
     h=h_tap_out,
     p=p_tap));
  //---------Summary Definition---------

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"  annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.TemperatureDifference Delta_T "Lower temperature difference (T_tap_in - T_cond_out)" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_tap=1e5 "Pressure of heating steam" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_tap "Mass flow rate of the heating steam" annotation (Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.Temperature T_tap_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      medium,
      p_tap,
      h_tap_in) "Temperature at tapping inlet";
  final parameter ClaRa.Basics.Units.Temperature T_cond_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      medium,
      p_cond,
      h_cond_in) "Temperature at condensate inlet";
  final parameter ClaRa.Basics.Units.Temperature T_cond_out=T_tap_in - Delta_T "Temperature at condensate outlet";
  final parameter ClaRa.Basics.Units.Temperature T_tap_out=T_tap_in - m_flow_cond*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(
      medium,
      p_cond,
      T_cond_in)*(T_cond_out - T_cond_in)/(m_flow_tap*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(
      medium,
      p_tap,
      T_tap_in)) "Temperature at tapping outlet";

  final parameter ClaRa.Basics.Units.Pressure p_cond(fixed=false) "Pressure at condensate side";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_cond(fixed=false) "Mass flow of the condensate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_in(fixed=false) "Spec. enthalpy at tapping inlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_in(fixed=false) "Spec. enthalpy condensate inlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_tap_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_tap,
      T_tap_out) "Spec. enthalpy at tapping outlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_cond_out=m_flow_tap*(h_tap_in - h_tap_out)/m_flow_cond + h_cond_in "Spec. enthalpy at condensate outlet";

//   ClaRa.Basics.Units.Pressure p_in_cond = p_out_cond;
//   ClaRa.Basics.Units.Pressure p_out_cond = p_in_cond;
  Fundamentals.SteamSignal_blue_a cond_in(p=p_cond, Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-100,10}})));
  Fundamentals.SteamSignal_blue_b cond_out(m_flow=m_flow_cond, h=h_cond_out, Medium=medium) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));
  Fundamentals.SteamSignal_red_a tap_in(p=p_tap, m_flow=m_flow_tap, Medium=medium) annotation (Placement(transformation(
        extent={{-10,100},{10,110}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,100},{10,110}},
        rotation=0,
        origin={0,0})));
  Fundamentals.SteamSignal_green_b tap_out(
    p=p_tap,
    m_flow=m_flow_tap,
    h=h_tap_out, Medium=medium) annotation (Placement(transformation(
        extent={{-10,-100},{10,-110}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,-100},{10,-110}},
        rotation=0,
        origin={0,0})));
initial equation
  tap_in.h=h_tap_in;
  cond_in.h=h_cond_in;
  cond_in.m_flow=m_flow_cond;
  cond_out.p=p_cond;
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
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{0,-40},{0,40},{100,0}},
          color={0,131,169},
          smooth=Smooth.None)}));
end Preheater_Delta_T;
