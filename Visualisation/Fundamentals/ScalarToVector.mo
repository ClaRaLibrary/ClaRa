within ClaRa.Visualisation.Fundamentals;
model ScalarToVector
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

  parameter Modelica.Units.SI.Time SampleTime=1 "Time interval| can be choiced as hour or second interval. Altogether you can give in all values.";
  parameter Modelica.Units.SI.Time simulationTime=200 "Set here the simulation time";
 parameter Integer N=integer((simulationTime) /SampleTime+1) "number of components of the z vector";
public
output Real[N] z "The components of this vector contains the values at each sample time of input variable y";

  Modelica.Blocks.Interfaces.RealInput u "Input signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

protected
  parameter Modelica.Units.SI.Time startTime(fixed=false);

initial equation

  startTime = time;

equation
for i in 1:N loop
when  time < (i)*SampleTime+startTime and time >= (i-1)*SampleTime+startTime and sample(startTime,SampleTime) then
  z[i] = u;
end when;
end for;
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
</html>"),version="0.1",uses(Modelica(version="3.1")),
    experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-104,100},{100,-100}},
          lineColor={27,36,42},
          fillColor={250,250,250},
          fillPattern=FillPattern.Solid), Line(
          points={{-98,-100},{-50,-90},{-14,-70},{16,-42},{36,-8},{48,24},{60,
              60},{66,84},{68,100}},
          color={27,36,42},
          smooth=Smooth.Bezier)}));
end ScalarToVector;
