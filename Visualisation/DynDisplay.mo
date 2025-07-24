within ClaRa.Visualisation;
model DynDisplay "Dynamic Display of one variable"
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

  parameter String varname = "Name of the variable";
  parameter Boolean provideConnector= false "If true a real output connector is provided";
  input Real x1=1 "Variable value" annotation (Dialog(enable= not provideConnector));
  parameter String unit="C" "Variable unit";
  parameter Integer decimalSpaces=1 "Accuracy to be displayed";
  parameter Boolean largeFonts= simCenter.largeFonts "True if visualisers shall be displayed as large as posible";

  outer ClaRa.SimCenter simCenter;


  Modelica.Blocks.Interfaces.RealOutput y=u_aux if provideConnector annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput u=u_aux if provideConnector annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),      iconTransformation(extent={{-120,-10},{-100,10}})));
//protected
  Real u_aux  annotation(Hide=false);
equation

  if not provideConnector then
    u_aux = x1;
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
     Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,0},{100,-100}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={118,124,127}),
        Rectangle(
          extent={{-100,100},{100,0}},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={27,36,42}),
        Text(
          extent=DynamicSelect({{-100,0},{100,-100}}, if largeFonts then {{-100,0},{100,-100}} else {{-94,2},{106,-98}}),
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if u_aux > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" x ", String(u_aux,format = "1."+String(decimalSpaces)+"f") + " %unit")),
        Text(
          extent={{-100,100},{100,0}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, {73,80,85}),
          textString="%varname")}),         Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end DynDisplay;
