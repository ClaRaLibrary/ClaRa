within ClaRa.Components.Utilities.Blocks;
model Noise "Adds a normally distributed noise to a given mean value"
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

  parameter Real Tau_sample = 1 "Sample period" annotation(Dialog(group="Large-Scale Time Definition"));
  parameter Real startTime = 1 "start time moment" annotation(Dialog(group="Large-Scale Time Definition"));
  parameter Boolean varMeanValue=false "True, if mean value is time dependent input"
                                                  annotation(Dialog(group="Noise Definition"));
  parameter Boolean varStandardDeviation=false "True, if standard deviation is time dependent input"
                                                          annotation(Dialog(group="Noise Definition"));
  parameter Real mean_const= 1 "Constant mean value" annotation(Dialog(group="Noise Definition", enable=not varMeanValue));
  parameter Real stdDev_const= 1 "Constant standard deviation" annotation(Dialog(group="Noise Definition", enable=not varStandardDeviation));
  parameter Modelica.Units.SI.Time Tau_smooth=Tau_sample/5 "Time constant for smoothing of the random values" annotation (Dialog(group="Noise Definition"));

protected
  Real seed[3];
  Real y_;
  Real x;
public
  Real m_in;
  Real stdDev_in;

public
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealInput mean=m_in if (varMeanValue) "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput sigma=stdDev_in if (varStandardDeviation) "Variable standard deviation"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}}),
        iconTransformation(extent={{-120,-62},{-80,-22}})));
algorithm

equation
  if (not varMeanValue) then
    m_in=mean_const;
  end if;
  if (not varStandardDeviation) then
    stdDev_in=stdDev_const;
  end if;

   x=smooth(1,div(time,Tau_sample));

  seed =  {noEvent(smooth(1,x)), noEvent(smooth(1,x)^3), noEvent(smooth(1,x^2))};
  if noEvent(time > startTime) then
    der(y_) =(ClaRa.Components.Utilities.Blocks.Fundamentals.normalvariate(
      m_in,
      stdDev_in,
      seed) - y_)/Tau_smooth;
  else
    der(y_)=(m_in-y_)/Tau_smooth;
  end if;
  der(y)=(y_-y)/Tau_smooth;
initial equation
  y=m_in;
  y_=m_in;
  annotation (Documentation(info="<html>
This random generator combines ideas from:
<p>
<b>Peter Fritzson</b>: \"Principles of Object-Oriented Modeling and Simulation with Modelica 2.1\" published by Wiley Interscience, 2004. <br>
<b>Dorel Aiordachioaie et al.</b>: \"On Noise Modelling and Simulation\" In Proceedings of the Modelica Conference 2006.</p>  
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
</html>"),Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,82},{-78,-76},{78,-76}}, color={221,222,223}),
        Line(
          points={{-78,0},{-60,-20},{-42,30},{-32,-14},{-20,-14},{-4,-64},{4,24},{8,-28},{24,76},{36,-16},{38,-54},{69.9688,33.9141},{72,-12}},
          color={27,36,42},
          smooth=Smooth.Bezier)}));
end Noise;
