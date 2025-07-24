within ClaRa.Basics.Functions;
function A_hor_intCyl "Horizontal area of a cylinder vertically intersecting a horizontal cylinder of large diameter"
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
  input Real z "Vertical position";
  input Real D1 "Diameter of vertical cylinder";
  input Real D2 "Diameter of horizontal cylinder";
  input Real h1 "Length of vertical cylinder";
  input Real L "Length of horizontal cylinder";
  output Real A_intersectingCylinder "Intersecting area";

protected
  Real beta;
  Real x;
  Real h2;
  Real r1;
  Real r2;

algorithm
  r1:=D1/2;
  r2:=D2/2;

  x:=2*r2*sin(acos((r2-z+h1)/r2));
  beta:=2*acos(min(x/r1/2,1-Modelica.Constants.eps));

  h2:=r2*(1-cos(asin(r1/r2)))+h1;

  if z>=0 and z<= h1 then
    A_intersectingCylinder:=Modelica.Constants.pi *r1^2;
  elseif z>h1 and z<h2 then
    A_intersectingCylinder:=x*L+r1^2*(beta-sin(beta));
  else
    A_intersectingCylinder:= x*L;
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
</html>"));
end A_hor_intCyl;
