within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Selection_Function;
model Selection_Steinmetz "Default selection matrix according to Steinmetz (1991), p. 108-119"
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

  extends Selection_base;

  //----------------------------------------------------------
  // parameter of selection matrix
  //Austin 400e-10, Austin rearranged 360e-10, Steinmetz 210e-10
  parameter Real s0 = 325e-10 "base value selection according to Steinmetz (1991), p. 151" annotation(Dialog(group="Selection Parameters"));
  parameter Real mu = 0.45 "mu = 0.45 according to Sato(1996), mu = 0.7 according to Steinmetz (1991), p. 111" annotation(Dialog(group="Selection Parameters"));

  //----------------------------------------------------------
  //mill specific
  parameter ClaRa.Basics.Units.Area A_hydraulics = 0.035 "diameter of hydraulic cylinders per roll" annotation(Dialog(group="Geometric and operational Parameters"));
  parameter ClaRa.Basics.Units.SurfaceTension c_spring = 7*200e3 "spring constant (1e6 ... 5.6e6 N/m according to Schüler(1975))" annotation(Dialog(group="Geometric and operational Parameters"));
  parameter Integer n_rolls = 3 "number of grinding rolls" annotation(Dialog(group="Geometric and operational Parameters"));
  parameter ClaRa.Basics.Units.Length diameter_roll = 1.18 "diameter of roll" annotation(Dialog(group="Geometric and operational Parameters"));
  parameter ClaRa.Basics.Units.Length width_roll = 0.4 "width of roll annotation" annotation(Dialog(group="Geometric and operational Parameters"));
  parameter Real coeff_lever = 1 "coefficient to respect any lever" annotation(Dialog(group="Geometric and operational Parameters"));

protected
  parameter ClaRa.Basics.Units.Length radius_roll = diameter_roll/2;
  parameter ClaRa.Basics.Units.Mass mass_roll = Modelica.Constants.pi*(0.5*diameter_roll)^2*width_roll*7850 "mass of one grinding roll" annotation(Dialog(group="Geometric and operational Parameters"));

    //----------------------------------------------------------
public
  ClaRa.Basics.Units.Force F_grinding "total grinding force per roll";
  ClaRa.Basics.Units.Frequency s[N_class] "frequency of selection due to rotating grinding table";
  ClaRa.Basics.Units.Frequency S[N_class,N_class] "selection matrix";
  Real coeff_operation;

  // parameters of selection function ----------------------------
  //Coefficients of Selection-function, which is S = a*diameter^alpha. In log-log-plot parameter a becomes the offset und parameter alpha becomes the slope
  // Table input: HGI. Table output: (1) offset, (2) slope

  // (1) According to Austin and Luckie (1981): An Analysis of Ball-and-Race-Milling Part I
  // Derived from experimental work with a Hardgrove Mill, normalized to HGI_nom = 60
  //Modelica.Blocks.Tables.CombiTable1Ds tableHGI(table=[0.5,0.62,1.12; 0.58,0.69,1.12; 0.67,0.76,1.11; 0.75,0.83,1.09; 0.83,0.89,1.07; 0.92,0.95,1.03; 1,1,1; 1.08,1.05,0.95; 1.17,1.1,0.91; 1.25,1.14,0.87; 1.33,1.19,0.82; 1.42,1.23,0.77; 1.5,1.28,0.73; 1.58,1.32,0.68])            annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  // (2) According to Sato (1996): Breakage of Coals in Ring-Roller-Mills Part I
  // Derived from experimental work with a lab-scale ring-roller mill, simple linear function for offset, slope constant, normalized to HGI_nom = 60
  Modelica.Blocks.Tables.CombiTable1Ds tableHGI(table=[0.5,0.5,1; 0.69,0.69,1; 0.89,0.89,1; 1.08,1.08,1; 1.28,1.28,1; 1.47,1.47,1; 1.67,1.67,1])                                                                                                                                       annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Real coeff_HGI_slope;
  Real coeff_HGI_offset;

equation

  //----------------------------------------------------------
  tableHGI.u = iCom.HGI/iCom.HGI_nom;
  tableHGI.y[1] = coeff_HGI_offset;
  tableHGI.y[2] = coeff_HGI_slope;

  //grinding force, where 0.05 m is the preset gap between roll and table
  //respecting ration of bulk density and solid coal density
  F_grinding =  (coeff_lever * iCom.p_grinding * A_hydraulics + c_spring * (iCom.rho_bulk/iCom.rho) * (iCom.height_sum[iCom.n]- 0.05) + mass_roll*Modelica.Constants.g_n);

  //calculating selection matrix S
  coeff_operation =  iCom.rpm_table * n_rolls * F_grinding / max(Modelica.Constants.small,(iCom.rho_bulk/iCom.rho) * iCom.height_sum[iCom.n]);

  s = s0 .* coeff_operation .* coeff_HGI_offset .* diameter_prtcl.^(mu*coeff_HGI_slope);

  S = diagonal(cat(1,s[1:N_class-1],{0}));  //last element has to be zero!

                                                                                                                                                                                                        annotation (Placement(transformation(extent={{-8,40},{12,60}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Selection_Steinmetz;
