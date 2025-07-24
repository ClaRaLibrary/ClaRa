within ClaRa.Components.Utilities.Blocks;
block Integrator "Output the integral of the input signal - variable Integrator time constant"
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
  import Modelica.Blocks.Types.Init;
  import SI = ClaRa.Basics.Units;
  extends Modelica.Blocks.Interfaces.SISO(y(start=y_start_const));

  parameter Boolean variable_Tau_i=false "True, if integrator time is set by variable input";
  parameter Basics.Units.Time Tau_i_const=1 "Constant integrator time" annotation (Dialog(enable=not variable_Tau_i));

  parameter Integer initOption = 501 "Initialisation option" annotation(Dialog(choicesAllMatching, group="Initialisation"), choices(choice = 501 "No init (y_start and x_start as guess values)",
                                                                                                    choice=502 "Steady state",
                                                                                                    choice=504 "Force y_start at output"));

  parameter Boolean y_startInputIsActive=false "True, if integrator initial output shall be set by variable input"
                                                                                            annotation (Dialog(group="Initialization"));

  parameter Real y_start_const=0 "Initial or guess value of output (= state)"  annotation (Dialog(group="Initialization",enable= not y_startInputIsActive));
  parameter Basics.Units.Time startTime=0 "Start time for integration";

protected
  Basics.Units.Time Tau_i_in;
  Real y_start_in;
public
  Modelica.Blocks.Interfaces.RealInput Tau_i=Tau_i_in if (variable_Tau_i) annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-50,120})));

  Modelica.Blocks.Interfaces.RealInput y_start=y_start_in
                                                        if (y_startInputIsActive) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
initial equation
   if initOption == 502 then
      der(y) = 0;
   elseif initOption == 504 or initOption ==799 then // 799 refers to former buggy initial state initialisation which is still supported but not visible in the drop down any more
     y = y_start_in;
   elseif initOption ==501 then
     //Do nothing, use y_start_const as guess value
   else
    assert(false, "Unknown init option in integrator instance " + getInstanceName());
   end if;



equation
  if not variable_Tau_i then
    Tau_i_in=Tau_i_const;
  end if;
  if not y_startInputIsActive then
    y_start_in=y_start_const;
  end if;

  der(y) =  if time >= startTime then u/Tau_i_in else 0;
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
    Documentation(info="<html></html>"), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={221,222,223}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={221,222,223}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{0,-10},{60,-70}},
          lineColor={221,222,223},
          textString="I"),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={27,36,42},
          textString="Ti=%Ti_in"),
        Line(points={{-80,-80},{80,80}}, color={27,36,42})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-36,60},{32,2}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-32,0},{36,-58}},
          lineColor={0,0,0},
          textString="s"),
        Line(points={{-46,0},{46,0}}, color={0,0,0})}));
end Integrator;
