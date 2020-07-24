within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Selection_Function;
model Selection_Kersting "Selection matrix according to Kersting (1986), p. 19-23"
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Selection_Kersting;
