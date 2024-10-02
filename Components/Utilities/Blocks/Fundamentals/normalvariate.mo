within ClaRa.Components.Utilities.Blocks.Fundamentals;
function normalvariate "Normally distributed random variable"
  extends ClaRa.Basics.Icons.Function;
  input Real mu "Mean value";
  input Real sigma "Standard deviation";
  input Real si[3] "Input random seed";
  output Real x "Gaussian random variate";
  output Real so[3] "Output random seed";
protected
  constant Real NV_MAGICCONST=4*exp(-0.5)/sqrt(2.0);
  Real s1[3];
  Real  s2[3];
  Real z;
  Real zz;
  Real u1;
  Real u2;
  Boolean break_=false;
algorithm
  s1 := si;
  u2 := 1;
  while not break_ loop
    (u1,s2) := random(s1);
    (u2,s1) := random(s2);
    z := NV_MAGICCONST*(u1-0.5)/u2;
    zz := z*z/4.0;
    break_ := zz <= (- Math.log(u2));
  end while;
    x := mu + z*sigma;
    so := s1;
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
end normalvariate;
