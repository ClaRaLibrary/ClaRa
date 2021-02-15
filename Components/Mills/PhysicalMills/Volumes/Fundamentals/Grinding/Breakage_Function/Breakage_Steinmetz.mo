within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Breakage_Function;
model Breakage_Steinmetz "Breakage matrix according to Broabent-Calcott (1956) modified by Gardener a. Austin (1962)"
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

  extends Breakage_base;

  // breakage variables --------------------------------------------
  Real b[N_class,N_class](start = zeros(N_class,N_class));
  Real b_diff[N_class,N_class];
  Real B[N_class,N_class] "breakage matrix";
  Real B_sum[N_class];

  // parameters of breakage calculation ----------------------------
  Real sigma "exponent to respect Hg Index according to Gardener/Austin (1962)";

  // Table input: HGI. Table output: (1) sigma
  // According to Gardener and Austin (1962): An Chemical Engineering Treatment of batch Grinding
  // compare to Steinmetz (1991), p. 106
  Modelica.Blocks.Tables.CombiTable1Ds tableHGI(table=[30,2.0274; 51,1.6027; 84,1.2849]) "input Hardgrove Index > output sigma exponent" annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  tableHGI.u = iCom.HGI;//
  sigma = tableHGI.y[1];

  //--------------------------------------------
  for q in 1:N_class loop
    for r in 1:N_class loop
      //if d[r] < d[q] then
      if r > q then
        b[r,q] = (1-exp((-d[r]/d[q])).^sigma) / (1-exp(-1));
      else
        b[r,q] = 0;
      end if;
    end for;
  end for;

  //--------------------------------------------
  for q in 1:N_class loop
    for r in 1:N_class-1 loop
      if b[r,q] > 0 then
        b_diff[r,q] = b[r,q] - b[r+1,q];
      else
        b_diff[r,q] = 0;
      end if;
    end for;
  end for;

  for q in 1:N_class loop
    b_diff[N_class,q] = b[N_class,q];
  end for;

  //--------------------------------------------
  for q in 1:N_class loop
    if sum(b[:,q]) > 0 then
      B[:,q] = b_diff[:,q] ./ sum(b_diff[:,q]);
    else
      B[:,q] = b_diff[:,q];
    end if;
  end for;

  //-------------------------------------------
  for r in 1:N_class loop
    B_sum[r] = sum(B[:,r]);
  end for;

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
end Breakage_Steinmetz;
