within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Breakage_Function;
model Breakage_Austin "Default breakage matrix according to Austin et al. (1981)"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.6.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends Breakage_base;

  // breakage variables --------------------------------------------
  Real b[N_class,N_class](start = zeros(N_class,N_class));
  Real b_diff[N_class,N_class];
  Real B[N_class,N_class] "breakage matrix";
  Real B_sum[N_class];

  // parameters of breakage calculation ----------------------------

  // Table input: HGI. Table output: (1) gamma, (2) phi, (3) beta
  // According to Austin and Luckie (1981): An Analysis of Ball-and-Race-Milling
  // Derived from experimental work with a Hardgrove Mill Part I
  Modelica.Blocks.Tables.CombiTable1Ds tableHGI(table=[35,1.235,0.22,5; 47,1.089,0.30,5; 54,0.952,0.51,5; 55,1.095,0.50,5; 58,1.080,0.54,5; 66,0.970,0.56,5; 69,0.939,0.56,5; 88,0.868,0.63,5; 101,0.811,0.68,5; 110,0.743,0.74,5])
                                                                                           annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Real gamma;
  Real phi;
  Real beta;

equation

  //--------------------------------------------
  tableHGI.u = iCom.HGI;
  gamma = tableHGI.y[1];
  phi = tableHGI.y[2];
  beta = tableHGI.y[3];

  //--------------------------------------------
  for q in 1:N_class loop
    for r in 1:N_class loop
      if r > q then
        b[r,q] = phi * (d[r-1]/d[q])^gamma + (1-phi)*(d[r-1]/d[q])^beta;
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
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end Breakage_Austin;
