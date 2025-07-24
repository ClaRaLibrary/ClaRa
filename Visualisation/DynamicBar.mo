within ClaRa.Visualisation;
model DynamicBar

  parameter Real u_max = 1 "Upper boundary for visualised variable" annotation(Dialog(group="Parameters"));
  parameter Real u_min = 0 "Lower boundary for visualised variable" annotation(Dialog(group="Parameters"));
  parameter String unit= "" "The input's unit"  annotation(Dialog(group="Parameters"));
  parameter Integer decimalSpaces=1 "Accuracy to be displayed"  annotation(Dialog(group="Parameters"));
  parameter Boolean provideInputConnectors= false "If true connectors for the inputs are provided"  annotation(Dialog(group="Parameters"));
  parameter Boolean provideLimitsConnectors= false "If true connectors for the limits and set values are provided"  annotation(Dialog(group="Parameters"));
  parameter Boolean provideOutputConnector= false "If true an output connector y is provided"  annotation(Dialog(group="Parameters"));
  input Real u=0 "Variable to be visualised" annotation(Dialog(group= "Inputs", enable = not provideInputConnectors));
  input Real u_set = 0.5 "Set Value of filling level"  annotation(Dialog(group= "Inputs", enable = not provideLimitsConnectors));
  input Real u_high = 0.6 "High input threshold"  annotation(Dialog(group= "Inputs", enable = not provideLimitsConnectors));
  input Real u_low = 0.4 "Low input threshold"  annotation(Dialog(group= "Inputs", enable = not provideLimitsConnectors));



  Modelica.Blocks.Interfaces.RealInput u_in=u_int if provideInputConnectors annotation (Placement(transformation(extent={{-20,-10},{0,10}}),   iconTransformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Interfaces.RealInput u_set_in=u_set_int if provideLimitsConnectors annotation (Placement(transformation(extent={{-20,90},{0,110}}),   iconTransformation(extent={{-20,90},{0,110}})));
  Modelica.Blocks.Interfaces.RealInput u_low_in=u_low_int if provideLimitsConnectors annotation (Placement(transformation(extent={{-20,50},{0,70}}),    iconTransformation(extent={{-20,50},{0,70}})));
  Modelica.Blocks.Interfaces.RealInput u_high_in=u_high_int if provideLimitsConnectors annotation (Placement(transformation(extent={{-20,130},{0,150}}),  iconTransformation(extent={{-20,130},{0,150}})));
  Modelica.Blocks.Interfaces.RealOutput y=u_int if provideOutputConnector annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

protected
  Real u_int annotation(Hide=false);
  Real u_set_int  annotation(Hide=false);
  Real u_low_int  annotation(Hide=false);
  Real u_high_int  annotation(Hide=false);

equation
  assert(u_min < u_low and u_low< u_set and u_set< u_high and u_high < u_max, "The parameters in " + getInstanceName() + " have the following constraints: u_min < u_low < u_set < u_high < u_max.");

  if not provideInputConnectors then
    u_int=u;
  end if;

  if not provideLimitsConnectors then
    u_set_int = u_set;
    u_low_int = u_low;
    u_high_int = u_high;
  end if;

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
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false,extent={{0,0},{100,
            200}}),       graphics={
        Line(points=DynamicSelect({{0,100},{85,100}},{{0,u_set_int/(u_max-u_min)*200},{85,u_set_int/(u_max-u_min)*200}}), color={27,36,42}),
        Line(points=DynamicSelect({{0,140},{85,140}},{{0,u_high_int/(u_max-u_min)*200},{85,u_high_int/(u_max-u_min)*200}}), color={118,124,127}),
        Line(points=DynamicSelect({{0,60},{85,60}},{{0,u_low_int/(u_max-u_min)*200},{85,u_low_int/(u_max-u_min)*200}}), color={118,124,127}),
        Rectangle(
          extent={{20,0},{80,200}},
          lineColor={27,36,42},
          fillColor={164,167,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent=DynamicSelect({{20,0},{80,0}}, {{20,(u_int-u_min)/(u_max-u_min)*200},{80,0}}),
          lineColor=DynamicSelect({115,150,0}, if u_int>u_high_int then {167,25,48} elseif u_int<u_low_int then {0,131,169} else {115,150,0}),
          fillColor=DynamicSelect({115,150,0}, if u_int>u_high_int then {167,25,48} elseif u_int<u_low_int then {0,131,169} else {115,150,0}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,10},{100,-10}},
          lineColor={27,36,42},
          textString="%name",
          origin={50,-10},
          rotation=180),
        Text(
          extent={{-100,110},{100,90}},
          lineColor=DynamicSelect({27,36,42},if u_int>u_max then {27,36,42} elseif u_int>u_high_int then {167,25,48} elseif u_int<u_low_int then {0,131,169} else {115,150,0}),
          origin={50,110},
          textString = DynamicSelect("value", String(u_int,format = "1."+String(decimalSpaces)+"f")+ " %unit"),
          fontSize=0),
        Text(
          extent=DynamicSelect({{85, 90},{200, 110}},{{85,u_set/(u_max-u_min)*200-10},{200,u_set/(u_max-u_min)*200+10}}),
          lineColor={27,36,42},
          textString="%u_set" + "%unit",
          horizontalAlignment=TextAlignment.Left),
        Rectangle(extent={{20,200},{80,0}}, lineColor={27,36,42}),
        Line(points={{20,0},{100,0}}, color={27,36,42}, visible=provideConnector)}),
          Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-30,-10},{110,120}},
        grid={2,2},
        initialScale=0.1), graphics));
end DynamicBar;
