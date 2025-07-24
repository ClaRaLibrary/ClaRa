within ClaRa.Visualisation;
model Hexdisplay_3 "Area-temperature diagram for HEX with three zones"
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

  input ClaRa.Basics.Units.Temperature T_o[6]=zeros(6) "Hot side temperatures (if showInterface=false)" annotation (Dialog(group="Input", enable=not showInterface));
  input ClaRa.Basics.Units.Temperature T_i[6]=zeros(6) "Hot side temperatures (if showInterface=false)" annotation (Dialog(group="Input", enable=not showInterface));
  input Real z_o[6] "Position of zone limits at outer side" annotation(Dialog(group="Input", enable=not showInterface));
  input Real z_i[6] "Position of zone limits at inner side" annotation(Dialog(group="Input", enable=not showInterface));
  parameter Real y_min=0 "Choose or guess the minimal value of the y-axis" annotation(Dialog(group="Layout"));
  parameter Real y_max(min=y_min+Modelica.Constants.eps)=1 "Choose or guess the maximal value of the y-axis"
                                                      annotation(Dialog(group="Layout"));
  parameter String Unit="[-]" "Unit for plot variable" annotation(Dialog(group="Layout"));
  parameter Boolean outerPhaseChange= true "True if phase change at outer side";
public
  constant ClaRa.Basics.Types.Color colorh={167,25,48} "Line color"         annotation (Hide=false, Dialog(group="Layout"));
  constant ClaRa.Basics.Types.Color colorc={0,131,169} "Line color"         annotation (Hide=false, Dialog(group="Layout"));

protected
  Real y_o[ size(z_o, 1)];
  Real y_i[ size(z_i, 1)];

public
  Real yps[6] = if outerPhaseChange then z_o else z_i;
  final Real[size(z_o, 1), 2] point_o=transpose({z_o*100,y_o})  annotation(Hide=false);
  final Real[size(z_i, 1), 2] point_i=transpose({z_i*100,y_i})  annotation(Hide=false);

equation
  for i in 1:6 loop
     y_o[i] = if T_o[i] < y_min then (1-(y_max -y_min)/(y_max - y_min))*100 else
           if  T_o[i] > y_max then    (1-(y_max -y_max)/(y_max - y_min))*100 else
               (1-(y_max -T_o[i])/(y_max - y_min))*100;

  end for;
  for i in 1:size(y_i, 1) loop
    y_i[i] = if T_i[i] < y_min then     (1-(y_max -y_min)/(y_max - y_min))*100 else
          if  T_i[i] > y_max then    (1-(y_max -y_max)/(y_max - y_min))*100 else
              (1-(y_max -T_i[i])/(y_max - y_min))*100;

  end for;

annotation (  Documentation(info="<html>
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
</html>"),  Icon(coordinateSystem(preserveAspectRatio=true, extent={{0,0},{
            100,100}}),   graphics={
        Rectangle(
          extent=DynamicSelect({{50,100},{100,0}}, {{yps[5]*100,100},{yps[6]*100,0}}),
          lineColor={27,36,42},
          fillColor={164,167,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent=DynamicSelect({{10,100},{50,0}}, {{yps[3]*100,100},{yps[4]*100,0}}),
          lineColor={27,36,42},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent=DynamicSelect({{0,100},{10,0}}, {{0,100},{yps[2]*100,0}}),
          lineColor={27,36,42},
          fillColor={73,80,85},
          fillPattern=FillPattern.Solid),
        Text(
            extent={{2,94},{-18,100}},
            lineColor={27,36,42},
            textString="%y_max"),
        Text(
          extent={{-16,6},{2,0}},
          lineColor={27,36,42},
          textString="%y_min"),
          Text(
            extent={{66,-4},{36,-12}},
            lineColor={27,36,42},
          textString="Area"),
        Text(
          extent={{-20,114},{120,104}},
          lineColor={27,36,42},
          textString="%Unit"),
        Line(
          points=DynamicSelect({{0,20},{50,57},{70,42},{100,100}}, point_o),
          color=DynamicSelect({167,25,48},colorh),
          pattern=LinePattern.Solid,
          thickness=0.5),
        Line(
          points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, point_i),
          color=DynamicSelect({0,131,169},colorc),
          pattern=LinePattern.Solid,
          thickness=0.5),
        Line(
          points={{50,0},{50,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{0,0},{0,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{10,0},{10,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{20,0},{20,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{30,0},{30,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{40,0},{40,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{100,0},{100,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{90,0},{90,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{80,0},{80,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{70,0},{70,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{60,0},{60,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Text(
          extent={{96,-3},{104,-5}},
          lineColor={27,36,42},
          textString="1"),
        Text(
          extent={{44,-3},{56,-5}},
          lineColor={27,36,42},
          textString="0.5"),
        Text(
          extent={{-4,-3},{4,-6}},
          lineColor={27,36,42},
          textString="0")},
          Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-30,-10},{110,120}},
        grid={2,2},
        initialScale=0.1), graphics)), Diagram(coordinateSystem(extent={{0,0},{
            100,100}})));
end Hexdisplay_3;
