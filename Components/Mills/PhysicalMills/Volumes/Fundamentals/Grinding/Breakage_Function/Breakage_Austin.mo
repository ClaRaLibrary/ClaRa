within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Breakage_Function;
model Breakage_Austin "Default breakage matrix according to Austin et al. (1981)"
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

end Breakage_Austin;
