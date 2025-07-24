within ClaRa.Visualisation;
model Scope "Dynamic graphical display of one variable"
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

  parameter Boolean hideInterface=true "Select for input interface" annotation(Dialog(group="Input"));
  input Real inputVar=0 "Input variable (if showInterface=false)" annotation(Dialog(group="Input", enable=not showInterface));

  parameter Real y_min=0 "Choose or guess the minimal value of the y-axis" annotation(Dialog(group="Layout"));
  parameter Real y_max(min=y_min+Modelica.Constants.eps)=1 "Choose or guess the maximal value of the y-axis"
                                                      annotation(Dialog(group="Layout"));
  parameter String Unit="[-]" "Unit for plot variable" annotation(Dialog(group="Layout"));

public
  parameter Modelica.Units.SI.Time t_start=0 "Start time of display" annotation (Dialog(group="Layout"));
  parameter Modelica.Units.SI.Time t_end=1 "Start time of display" annotation (Dialog(group="Layout"));
  parameter Modelica.Units.SI.Time t_sample(min=Modelica.Constants.eps) = (t_end - t_start)/100 "Output intervall for plot, use carefully since this creates scalars!" annotation (Dialog(group="Layout"));

  parameter ClaRa.Basics.Types.Color color={0,131,169} "Line color"         annotation (Hide=false, Dialog(group="Layout"));
  parameter Modelica.Units.SI.Time Tau_stab=0.01 "Stabilizing time constant, 0 means no stabilisation " annotation (Dialog(group="Numerics"));

//  final parameter Real y_start=(y_min+y_max)/2 "Initial display value";


protected
  final parameter Real x[N_points] = linspace(1,100,N_points) "x-positions of line points" annotation(Hide=false);
  Real y[N_points] "y-positions of line points" annotation(Hide=false);
  final parameter Integer N_points = integer((t_end-t_start)/t_sample+1) "Number of points";
  Real f "Horizontal position of the cover-rectangle" annotation(Hide=false);
  Real u_in "Value to be displayed";
  Real u_aux "Auxilliary variable";
  Real xy[:,:] = [x,y] annotation(Hide=false);
public
  Modelica.Blocks.Interfaces.RealInput u = u_aux if not hideInterface "Input signal"
    annotation (Placement(transformation(extent={{-40,50},{0,90}}),
        iconTransformation(extent={{-42,78},{-30,90}})));

initial equation
   if Tau_stab>0 then
    u_in=u_aux;
   end if;

equation
  if Tau_stab>0 then
    der(u_in) =  (u_aux-u_in)/Tau_stab;
  else
    u_in= u_aux;
  end if;
   if hideInterface then
     u_aux = inputVar;
   end if;

  for i in 1:N_points loop
    when  time < (i)*t_sample+t_start and time >= (i-1)*t_sample+t_start and sample(t_start,t_sample) then
      y[i] = if u_in < y_min then     (1-(y_max -y_min)/(y_max - y_min))*100 else
                     if u_in > y_max then    (1-(y_max -y_max)/(y_max - y_min))*100 else
                        (1-(y_max -u_in)/(y_max - y_min))*100;
    end when;
  end for;
  f=if time  <= t_start then 0 else if time  >= (t_end-t_start)+t_start then 100 else  (time-t_sample-t_start)*100/(t_end-t_start);

  assert(y_max>=y_min, "Parameter failure: y_max shall be larger than y_min.");
  assert(t_end>t_start, "Parameter failure: t_end shall be larger than t_start");

annotation ( Documentation(info="<html>
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
</html>"),   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-30,-10},
            {110,120}}),  graphics={
        Rectangle(
          extent={{-30,120},{110,-10}},
          lineColor={27,36,42},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Text(
            extent={{0,94},{-30,100}},
            lineColor={27,36,42},
          horizontalAlignment=TextAlignment.Right,
          textString=String(y_max, format="1.0f")),
        Text(
            extent={{-30,6},{0,0}},
            lineColor={27,36,42},
          horizontalAlignment=TextAlignment.Right,
          textString=String(y_min, format="1.0f")),
          Text(
            extent={{64,-2},{34,-10}},
            lineColor={27,36,42},
          textString="Time"),
        Text(
          extent={{-30,120},{110,110}},
          lineColor={27,36,42},
          textString="%Unit"),
                    Rectangle(
            extent={{0,100},{100,0}},
            lineColor={27,36,42},
          fillColor={27,36,42},
          fillPattern=FillPattern.Solid),
          Line(
            points=DynamicSelect({{0,0},{50,52},{70,40},{100,100}}, xy),
            color=DynamicSelect({0,131,169},color),
            pattern=LinePattern.Solid, thickness=0.5),
          Rectangle(
            extent=DynamicSelect({{0,100},{100,0}}, {{f,100},{100,0}}),
            pattern=LinePattern.Solid,
            lineColor={27,36,42},
            fillColor=DynamicSelect({27,36,42}, {27,36,42}),
            fillPattern=FillPattern.Solid),
        Text(
            extent={{-8,-2},{10,-8}},
            lineColor={27,36,42},
          textString=String(t_start, format="1.0f")),
        Text(
            extent={{90,-2},{108,-8}},
            lineColor={27,36,42},
          textString=String(t_end, format="1.0f"))}),
          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-30,-10},{110,120}},
        grid={2,2},
        initialScale=0.1),                 graphics));
end Scope;
