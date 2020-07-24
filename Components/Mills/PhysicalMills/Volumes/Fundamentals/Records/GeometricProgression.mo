within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records;
function GeometricProgression
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


  input Real q "Parameter of geometric progression; q = sqrt(2) according to Austin and Luckie (1981) ";
  input ClaRa.Basics.Units.Length diameter_prtcl_init "largest particle diameter in geometric porgression";
  input Integer N_class "number of particle classes, 22 according to Austin and Lucki (1981)";

  output ClaRa.Basics.Units.Length diameter_prtcl[N_class] "diamter of particles";

algorithm

  diameter_prtcl[1] := diameter_prtcl_init;

  for i in 2:N_class loop
    diameter_prtcl[i] := diameter_prtcl[i-1] * q;
  end for;

end GeometricProgression;
