within ClaRa.Visualisation;
model Sixtuple " Cross-shaped dynamic display of m_flow, p, T, h, s and e"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                           //
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

//  parameter String unit="C" "Variable unit";
  parameter Integer identifier= 0 "Identifier of the quadruple";
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation(Dialog);
  parameter Boolean largeFonts= simCenter.largeFonts "True if visualisers shall be displayed as large as posible";
  parameter Integer vleFluid=1 "Number of VLE fluid in SimCenter, value needs to be between 1 - 3";
  Real p=eye.p "Pressure of state";
  Real h=eye.h "Specific enthalpy of state";
  Real s=eye.s "Specific enthalpy of state";
  Real T=eye.T "Temperature of state";
  Real m_flow=eye.m_flow "Mass flow rate";
  Real e "Exergy flow";

record DecimalSpaces
  extends ClaRa.Basics.Icons.RecordIcon;
parameter Integer T=1 "Accuracy to be displayed for temperature";
parameter Integer m_flow=1 "Accuracy to be displayed for mass flow";
parameter Integer h=1 "Accuracy to be displayed for enthalpy";
parameter Integer p=1 "Accuracy to be displayed for pressure";
parameter Integer s=1 "Accuracy to be displayed for entropy";
parameter Integer e=1 "Accuracy to be displayed for exergy";
end DecimalSpaces;

  outer ClaRa.SimCenter simCenter;
  ClaRa.Basics.Interfaces.EyeIn eye  annotation (Placement(
        transformation(extent={{-210,-110},{-190,-90}}), iconTransformation(
          extent={{-210,-110},{-190,-90}})));
equation
  if vleFluid==1 then
    e=h-simCenter.h_amb_fluid1/1e3-simCenter.T_amb*(s-simCenter.s_amb_fluid1/1e3);
  elseif vleFluid==2 then
    e=h-simCenter.h_amb_fluid2/1e3-simCenter.T_amb*(s-simCenter.s_amb_fluid2/1e3);
  else
    e=h-simCenter.h_amb_fluid3/1e3-simCenter.T_amb*(s-simCenter.s_amb_fluid3/1e3);
  end if;
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
     Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{400,0}},
        initialScale=0.05),    graphics={
        Rectangle(
          extent={{-200,0},{400,-200}},
          fillColor={250,250,250},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent=DynamicSelect({{-200,0},{0,-100}},if largeFonts then {{-200,0},{0,-100}} else {{-200,-20},{0,-80}}),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230}, if time> 0 then if eye.m_flow>0 then {0,131,169} else {167,25,48} else {230,230,230}),
          textString=DynamicSelect(" m ", String(eye.m_flow,format = "1."+String(decimalSpaces.m_flow)+"f") +" kg/s")),
        Text(
          extent=DynamicSelect({{-200,-100},{0,-200}},if largeFonts then {{-200,-100},{0,-200}} else {{-200,-120},{0,-180}}),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {0,131,169} else {230,230,230}),
          textString=DynamicSelect(" h ", String(eye.h,format = "1."+String(decimalSpaces.h)+"f") + " kJ/kg")),
        Text(
          extent=DynamicSelect({{0,0},{200,-100}},if largeFonts then {{0,0},{200,-100}} else {{0,-20},{200,-80}}),
          textString=DynamicSelect(" T ", String(eye.T, format = "1."+String(decimalSpaces.T)+"f") + "°C"),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {0,131,169} else {230,230,230})),
        Text(
          extent=DynamicSelect({{0,-100},{200,-200}}, if largeFonts then {{0,-100},{200,-200}} else {{0,-120},{200,-180}}),
          textString=DynamicSelect(" p ", String(eye.p,format = "1."+String(decimalSpaces.p)+"f") + " bar"),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {0,131,169} else {230,230,230})),
        Text(
          extent=DynamicSelect({{200,0},{400,-100}}, if largeFonts then {{200,0},{400,-100}} else {{200,-20},{400,-80}}),
          textString=DynamicSelect(" s ", String(eye.s,format = "1."+String(decimalSpaces.s)+"f") + " kJ/(kg*K)"),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {0,131,169} else {230,230,230})),
        Text(
          extent=DynamicSelect({{200,-100},{400,-200}}, if largeFonts then {{200,-100},{400,-200}} else {{200,-120},{400,-180}}),
          textString=DynamicSelect(" e ", String(e,format = "1."+String(decimalSpaces.e)+"f") + " kJ/kg"),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230,230,230},if time>0 then {0,131,169} else {230,230,230})),
        Line(
          points={{0,0},{0,-200}},
          pattern=LinePattern.Solid,
          smooth=Smooth.None,
          color=DynamicSelect({190,190,190},if time>0 then {0,131,169} else {190,190,190})),
        Line(
          points={{200,0},{200,-200}},
          pattern=LinePattern.Solid,
          smooth=Smooth.None,
          color=DynamicSelect({190,190,190},if time>0 then {0,131,169} else {190,190,190})),
        Line(
          points={{-200,-100},{400,-100}},
          pattern=LinePattern.Solid,
          smooth=Smooth.None,
          color=DynamicSelect({190,190,190},if time>0 then {0,131,169} else {190,190,190}))}),            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-200,
            -200},{200,0}},
        initialScale=0.05),  graphics));
end Sixtuple;
