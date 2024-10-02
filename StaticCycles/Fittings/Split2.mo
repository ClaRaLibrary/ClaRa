within ClaRa.StaticCycles.Fittings;
model Split2 "Split || blue | green | yellow"
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
   // Green output: Values of p, m_flow and h are known in component an provided FOR neighbor component.
   // Red output:   Values of p and m_flow are unknown and provided BY neighbor component, value of h is known and provided FOR neighbor component.
  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet1;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet2;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow_1,
     h=h1,
     p=p),
  outlet1(
     m_flow=m_flow_2,
     h=h1,
     p=p),
  outlet2(
     m_flow=m_flow_3,
     h=h1,
     p=p));
  //---------Summary Definition---------
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   vleMedium = simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal split pressure" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real CharLine_p_P_target_[:,:]=[0,1;1,1] "Characteristic line of pressure drop as function of mass flow rate" annotation(Dialog(group="Part Load Definition"));

  final parameter ClaRa.Basics.Units.Pressure p(fixed=false) "Split pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_2=m_flow_1 - m_flow_3 "Mass flow rate of outlet 1";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_3(fixed=false) "Mass flow rate of outlet 2";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h1(fixed=false) "Spec. enthalpy at inlet";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_1(fixed=false) "Mass flow rate of inlet";

  outer parameter Real P_target_;
protected
  Modelica.Blocks.Tables.CombiTable1Dv table(table=CharLine_p_P_target_, u = {P_target_});

public
  Fundamentals.SteamSignal_blue_a inlet(p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{-50,10},{-60,30}}), iconTransformation(extent={{-50,10},{-60,30}})));
  Fundamentals.SteamSignal_green_b outlet_1(
    m_flow=m_flow_2,
    h=h1,
    p=p, Medium=vleMedium) annotation (Placement(transformation(extent={{60,10},{50,30}}), iconTransformation(extent={{60,10},{50,30}})));
  Fundamentals.SteamSignal_yellow_b outlet_2(h=h1, p=p, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-10,-30},{10,-40}},
        rotation=0,
        origin={0,0}), iconTransformation(
        extent={{-10,-30},{10,-40}},
        rotation=0,
        origin={0,0})));
initial equation
  p=table.y[1]*p_nom;
  inlet.m_flow=m_flow_1;
  inlet.h=h1;
  outlet_2.m_flow=m_flow_3;

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
   Icon(coordinateSystem(preserveAspectRatio=false,extent={{-50,-30},{50,30}}),
                   graphics={
          Polygon(
            points={{-50,30},{50,30},{50,10},{10,10},{10,-30},{-10,-30},{-10,10},{-50,10},{-50,30}},
            lineColor={0,131,169},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-20,20},{20,10}},
            lineColor={0,131,169},
            textString=DynamicSelect("p", String(p)))}),        Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-50,-30},{50,30}}),     graphics));
end Split2;
