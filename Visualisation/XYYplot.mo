within ClaRa.Visualisation;
model XYYplot "Same as ClaRa's XY plot but with one additional line"
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
  record DecimalSpaces
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Integer x=1 "Accuracy to be displayed for abscissa";
    parameter Integer y=1 "Accuracy to be displayed for ordinate";
  end DecimalSpaces;

  parameter String title="" "Plot title" annotation (Dialog(group="Layout"));
  parameter String x_label="" "Unit for abscissa" annotation (Dialog(group="Layout"));
  parameter String y_label="" "Unit for ordinate" annotation (Dialog(group="Layout"));
  parameter Real x_min=0 "Minimal value of the x-axis" annotation (Dialog(group="Layout"));
  parameter Real x_max=1 "Maximal value of the x-axis" annotation (Dialog(group="Layout"));
  parameter Real y_min=0 "Minimal value of the y-axis" annotation (Dialog(group="Layout"));
  parameter Real y_max=1 "Maximal value of the y-axis" annotation (Dialog(group="Layout"));
  DecimalSpaces decimalSpaces "Accuracy to be displayed" annotation (Dialog(group="Layout"));

  parameter Integer N_nodes1=3 "Number of nodes in set 1" annotation (Hide=false, Dialog(group="Set 1"));
  parameter ClaRa.Basics.Types.Color color1={205,79,70} "Line color in set 1" annotation (Hide=false, Dialog(group="Set 1"));

  parameter Boolean activateSecondSet=false "True, to activate the 2nd set of xy" annotation (Hide=false, Dialog(group="Set 2"));
  parameter Integer N_nodes2=3 "Number of nodes in set 2" annotation (Hide=false, Dialog(enable=activateSecondSet, group="Set 2"));
  parameter ClaRa.Basics.Types.Color color2={147,192,31} "Line color in set 2" annotation (Hide=false, Dialog(enable=activateSecondSet, group="Set 2"));

  parameter Boolean activateThirdSet=false "True, to activate the 3rd set of xy" annotation (Hide=false, Dialog(group="Set 3"));
  parameter Integer N_nodes3=3 "Number of nodes in set 2" annotation (Hide=false, Dialog(enable=activateThirdSet, group="Set 3"));
  parameter ClaRa.Basics.Types.Color color3={79,188,226} "Line color in set 2" annotation (Hide=false, Dialog(enable=activateThirdSet, group="Set 3"));

  final parameter Real h_grid[3]={0.25,0.5,0.75}*200;
  final parameter Real v_grid[3]={0.25,0.5,0.75}*200;

  Modelica.Blocks.Interfaces.RealInput y1[N_nodes1] "First ordinate set" annotation (Placement(transformation(extent={{-100,130},{-60,170}}), iconTransformation(extent={{-80,150},{-60,170}})));
  Modelica.Blocks.Interfaces.RealInput y2[N_nodes2] if activateSecondSet "Second ordinate set" annotation (Placement(transformation(extent={{-100,50},{-60,90}}), iconTransformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Interfaces.RealInput y3[N_nodes3] if activateThirdSet "Third ordinate set" annotation (Placement(transformation(extent={{-100,20},{-60,60}}), iconTransformation(extent={{-80,-10},{-60,10}})));

  Modelica.Blocks.Interfaces.RealInput x1[N_nodes1] "First abscissa set" annotation (Placement(transformation(extent={{74,-42},{114,-2}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-70})));
  Modelica.Blocks.Interfaces.RealInput x2[N_nodes2] if activateSecondSet "Second abscissa set" annotation (Placement(transformation(extent={{74,-84},{114,-44}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-70})));
  Modelica.Blocks.Interfaces.RealInput x3[N_nodes3] if activateThirdSet "Third abscissa set" annotation (Placement(transformation(extent={{74,-84},{114,-44}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-70})));

protected
  Real xy1[:,:]=[(x1 .- x_min) ./ (x_max - x_min)*200,(y1 .- y_min) ./ (y_max - y_min)*200] annotation (Hide=false);
  Real xy2[:,:] = [(x2_.-x_min)./(x_max-x_min)*200, (y2_.-y_min)./(y_max-y_min)*200] if activateSecondSet annotation(Hide=false);
  Real xy3[:,:] = [(x3_.-x_min)./(x_max-x_min)*200, (y3_.-y_min)./(y_max-y_min)*200] if activateThirdSet annotation(Hide=false);


  Modelica.Blocks.Interfaces.RealOutput x2_[N_nodes2];
  Modelica.Blocks.Interfaces.RealOutput x3_[N_nodes3];
  Modelica.Blocks.Interfaces.RealOutput y2_[N_nodes2];
  Modelica.Blocks.Interfaces.RealOutput y3_[N_nodes3];

equation

  if not activateSecondSet then
    x2_=ones(N_nodes2);
    y2_=ones(N_nodes2);
  end if;

  if not activateThirdSet then
    x3_=ones(N_nodes3);
    y3_=ones(N_nodes2);
  end if;

  connect(x2,x2_);
  connect(x3,x3_);
  connect(y2,y2_);
  connect(y3,y3_);


  annotation (
    Documentation(info="<html>
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
</html>", revisions="<html>
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
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,240},{220,-60}}), graphics={
        Rectangle(
          extent={{-60,240},{220,-60}},
          lineColor={27,36,42},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,200},{200,0}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
        Line(points={{0,h_grid[1]},{200,h_grid[1]}}, color={221,222,223}),
        Line(points={{0,h_grid[2]},{200,h_grid[2]}}, color={221,222,223}),
        Line(points={{0,h_grid[3]},{200,h_grid[3]}}, color={221,222,223}),
        Line(points={{v_grid[1],0},{v_grid[1],200}}, color={221,222,223}),
        Line(points={{v_grid[2],0},{v_grid[2],200}}, color={221,222,223}),
        Line(points={{v_grid[3],0},{v_grid[3],200}}, color={221,222,223}),
        Line(points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, xy1), color=color1),
        Line(
          points=DynamicSelect({{0,0},{50,52},{70,40},{100,120}}, xy2),
          color=color2,
          visible=activateSecondSet),
        Line(
          points=DynamicSelect({{0,0},{50,52},{70,40},{100,140}}, xy3),
          color=color3,
          visible=activateThirdSet),
        Text(
          extent={{-20,240},{220,200}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString="%title"),
        Text(
          extent={{-60,210},{0,190}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("y_max", String(y_max, format="1." + String(decimalSpaces.y) + "f"))),
        Text(
          extent={{-60,140},{2,160}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", String((y_max - y_min)*0.75, format="1." + String(decimalSpaces.y) + "f"))),
        Text(
          extent={{-60,90},{2,110}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", String((y_max - y_min)*0.5, format="1." + String(decimalSpaces.y) + "f"))),
        Text(
          extent={{-60,40},{2,60}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("", String((y_max - y_min)*0.25, format="1." + String(decimalSpaces.y) + "f"))),
        Text(
          extent={{-60,14},{2,-6}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("y_min", String(y_min, format="1." + String(decimalSpaces.y) + "f"))),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={0,-30},
          rotation=90,
          textString=DynamicSelect("x_min", String(x_min, format="1." + String(decimalSpaces.x) + "f"))),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={50,-30},
          rotation=90,
          textString=DynamicSelect("", String((x_max - x_min)*0.25, format="1." + String(decimalSpaces.x) + "f"))),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={100,-30},
          rotation=90,
          textString=DynamicSelect("", String((x_max - x_min)*0.5, format="1." + String(decimalSpaces.x) + "f"))),
        Text(
          extent={{-30,10},{30,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={150,-30},
          rotation=90,
          textString=DynamicSelect("", String((x_max - x_min)*0.75, format="1." + String(decimalSpaces.x) + "f"))),
        Text(
          extent={{-31,10},{31,-10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={201,-30},
          rotation=90,
          textString=DynamicSelect("x_max", String(x_max, format="1." + String(decimalSpaces.x) + "f"))),
        Text(
          extent={{0,-60},{206,-40}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          textString="%x_label"),
        Text(
          extent={{-101,-10},{101,10}},
          lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid,
          origin={-50,99},
          rotation=90,
          textString="%y_label")}),
    Diagram(graphics, coordinateSystem(preserveAspectRatio=false, extent={{0,0},{200,200}})));
end XYYplot;
