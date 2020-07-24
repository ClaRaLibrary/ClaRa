within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Breakage_Function;
model Breakage_Steinmetz "Breakage matrix according to Broabent-Calcott (1956) modified by Gardener a. Austin (1962)"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Breakage_Steinmetz;
