within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Selection_Function;
model Selection_Kersting "Selection matrix according to Kersting (1986), p. 19-23"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.6.0                           //
//                                                                          //
// Licensed by the ClaRa development team under Modelica License 2.         //
// Copyright  2013-2021, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  extends Selection_base;

  //----------------------------------------------------------
  // parameter of selection matrix
  parameter Real mu = 0.7 "parameter mu = 0.7 according to Kersting (1986), Eq. 2.1-30 and to Steinmetz (1991), p. 111";
  parameter Real s0_start = 0.15/0.8 "according to Kersting (1986), p. 27";
  ClaRa.Basics.Units.Frequency s0[N_class] "base values selection matrix";

  //----------------------------------------------------------
  //mill specific
  //parameter ClaRa.Basics.Units.RPM rpm = 10 "RPM of grinding table";
  //parameter Integer n_rolls = 3 "number of grinding rolls";
  parameter ClaRa.Basics.Units.Force F_grinding = 280e3 "grinding force per roll";
  //parameter ClaRa.Basics.Units.Area A_grinding = 1 "effective grinding area";
  parameter ClaRa.Basics.Units.SurfaceTension c_spring = 200e3 "spring constant";
  parameter Integer n_springs = 7 "number of springs per roll";

  //----------------------------------------------------------
  ClaRa.Basics.Units.Frequency s[N_class] "frequency of selection due to rotating grinding table";
  ClaRa.Basics.Units.Frequency S[N_class,N_class] "selection matrix";
  //ClaRa.Basics.Units.Length height_bed = 1 "height of coal on table";    //default value 1 to prevent warnings

equation

  //----------------------------------------------------------
  s0[1] = s0_start "element [1,1] of matrix s0";
  s0[N_class] = 0;

  for i in 2:N_class-1 loop
    s0[i] =  s0[1] * (diameter_prtcl[i+1]/diameter_prtcl[i])^((i-1)*mu);
  end for;

  //----------------------------------------------------------
  s = s0 .* (1 + (F_grinding / (height_bed[n] * n_springs * c_spring)));
  S = diagonal(cat(1,s[1:N_class-1],{0}));  //last element has to be zero!

    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>", revisions=
  "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Selection_Kersting;
