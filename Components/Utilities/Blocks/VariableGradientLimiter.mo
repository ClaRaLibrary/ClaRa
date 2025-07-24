within ClaRa.Components.Utilities.Blocks;
block VariableGradientLimiter "Limit the range of a signal with variable limits"
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
  extends Modelica.Blocks.Interfaces.SISO;
  import ClaRa.Basics.Functions.Stepsmoother;
  parameter Real Nd(min=Modelica.Constants.small) = 10 "|Expert Settings|Input - Output Coupling|The higher Nd, the closer y follows u";

  parameter Boolean useThresh=false "|Expert Settings|Numerical Noise Suppression|Use threshould for suppression of numerical noise";
  parameter Real thres(max=1e-6)=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."                         annotation (Dialog(enable = useThresh,tab="Expert Settings",group="Numerical Noise Suppression"));
  parameter Boolean constantLimits= false "True, if gradient limits are constant";
  parameter Real maxGrad_const = 1 "Constant max gradient" annotation (Dialog(enable = constantLimits));
  parameter Real minGrad_const = -1 "Constant min gradient" annotation (Dialog(enable = constantLimits));

  Modelica.Blocks.Interfaces.RealInput maxGrad=maxGrad_ if not constantLimits "Maximum Gradient allowd"
                              annotation (Placement(transformation(extent={{
            -140,60},{-100,100}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput minGrad=minGrad_ if not constantLimits "Minimum Gradient allowd"
                              annotation (Placement(transformation(extent={{
            -140,-100},{-100,-60}}, rotation=0)));

protected
  Real maxGrad_;
  Real minGrad_;
  Real y_aux;
equation

  if constantLimits then
    maxGrad_ = maxGrad_const;
    minGrad_ = minGrad_const;
  end if;
  der(y_aux) = smooth(1,noEvent(min(maxGrad_,max(minGrad_,(u-y_aux)*Nd))));

  if useThresh then
     y= Stepsmoother(1, 0.1, abs(der(y_aux))/thres)*y_aux + (1-Stepsmoother(1, 0.1, abs(der(y_aux))/thres))*u;
  else
    y=y_aux;
  end if;

initial equation
  y_aux=u;

  annotation (Documentation(info="<html>
<p>
The Limiter block passes its input signal as output signal
as long as the input is within the upper and lower
limits specified by the two additional inputs limit1 and
limit2. If this is not the case, the corresponding limit
is passed as output.
</p>  
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
    Documentation(info="<html>
<p>
The Limiter block passes its input signal as output signal
as long as the input is within the upper and lower
limits specified by the two additional inputs limit1 and
limit2. If this is not the case, the corresponding limit
is passed as output.
</p>
</HTML>
"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,82}},
                                      color={221,222,223}),
        Line(points={{-80,-80},{80,-80}},
                                      color={221,222,223}),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={27,36,42},
          textString="%name"),
        Line(points={{-80,-60},{-18,-4},{80,-60}},
                                                 color={27,36,42}),
        Line(points={{-80,-60},{0,56},{80,-60}}, color={221,222,223})}),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end VariableGradientLimiter;
