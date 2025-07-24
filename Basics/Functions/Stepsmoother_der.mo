within ClaRa.Basics.Functions;
function Stepsmoother_der "Time derivative of continouus interpolation for x"
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

  extends ClaRa.Basics.Icons.Function;
  input Real func "input for that result = 1";
  input Real nofunc "input for that result = 0";
  input Real x "input for interpolation";
  input Real dfunc "derivative of func";
  input Real dnofunc "derivative of nofunc";
  input Real dx "derivative of x";
  output Real dresult;

protected
  Real m = Modelica.Constants.pi/(func - nofunc);
  Real b = -Modelica.Constants.pi/2 - m*nofunc;
algorithm

  dresult := if x >= 0.999*(func - nofunc) + nofunc and func>nofunc or x
<= 0.999*(func - nofunc) + nofunc and nofunc>func or x <= 0.001*(func -
nofunc) + nofunc and func>nofunc or x >= 0.001*(func - nofunc) + nofunc
 and  nofunc>func then 0
 else
((1-Modelica.Math.tanh(Modelica.Math.tan(m*x+b))^2)*(1 +
Modelica.Math.tan(m*x+b)^2)*m*(dx-dnofunc+m/Modelica.Constants.pi*(dnofunc-dfunc)*(x-nofunc))) /2;
//((1-Modelica.Math.tanh(Modelica.Math.tan(m*x+b))^2)*(1 +
//Modelica.Math.tan(m*x+b)^2)*m*dx)/2;

  annotation (
    Window(
      x=0.01,
      y=0.09,
      width=0.66,
      height=0.6),
Documentation(info="<html>
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
</html>"));
end Stepsmoother_der;
