within ClaRa.Basics.Functions;
function shape_intCyl "Horizontal area of a cylinder vertically intersecting a horizontal cylinder of large diameter discretised output"
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
  input Real H_fill "Total filling height";
  input Real D1 "Diameter of vertical cylinder";
  input Real D2 "Diameter of horizontal cylinder";
  input Real h1 "Length of vertical cylinder";
  input Real L "Length of horizontal cylinder";
  input Integer N12 "Number of values between h1 and h2";
  input Integer N2 "Number of values between  h2 and H_fill";
  output Real shape_intCyl[N12+N2+2,2] "Shape table";

protected
  Real h2;
  Real dz12;
  Real dz2;

algorithm
  assert(D2>=D1 and L>=D1,"Diameter and length of horizontal cylinder need to be larger than diameter of hotwell!");

  h2:=D2/2*(1-cos(asin(D1/D2)))+h1;

  dz12:=(h2 - h1)/N12;
  dz2:=(H_fill - h2)/N2;

  shape_intCyl[1,1]:=0;
  shape_intCyl[1,2]:=Modelica.Constants.pi/4*D1^2;
  shape_intCyl[2,1]:=h1/H_fill;
  shape_intCyl[2,2]:=Modelica.Constants.pi/4*D1^2;

  for i in 1:N12 loop
    shape_intCyl[2+i,1]:=(h1 + i*dz12)/H_fill;
    shape_intCyl[2+i,2]:=ClaRa.Basics.Functions.A_hor_intCyl(
      h1 + i*dz12,
      D1,
      D2,
      h1,
      L);
  end for;
  for i in 1:N2 loop
    shape_intCyl[2+N12+i,1]:=(h2 + i*dz2)/H_fill;
    shape_intCyl[2+N12+i,2]:=ClaRa.Basics.Functions.A_hor_intCyl(
      h2 + i*dz2,
      D1,
      D2,
      h1,
      L);
  end for;

  shape_intCyl[:,2]:=shape_intCyl[:, 2]/(Modelica.Constants.pi/4*D1^2);
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
end shape_intCyl;
