within ClaRa.Basics.Functions;
function vectorInterpolation "Linear inter-/extrapolation of function values (x_i | f_i) between (x_1 | f_1) and (x_n | f_n)"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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

   input Real[:] x_i "Grid points to calculate function values for";
   input Real x_1 "First grid point";
   input Real f_1 "Function value for first grid point";
   input Real x_n "Last grid point";
   input Real f_n "Function value for last grid point";

   output Real[size(x_i,1)] f_i "Returned function values";

protected
   Integer N_cv = size(x_i,1) "Number of grid points";
   Real dfdx = (f_n-f_1)/max(x_n-x_1,Modelica.Constants.eps) "Function slope";

   Real[N_cv] dx_i = x_i-ones(N_cv)*x_1 "Relative grid points";
   Real[N_cv,N_cv] identity_dfdx = identity(N_cv)*dfdx "Identity matrix of slope";

algorithm
   f_i := identity_dfdx*dx_i+ones(N_cv)*f_1;
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
end vectorInterpolation;
