within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records;
record FuelClassification_example_11classes "11 classes | geometric progression | p = 2 | starting at 46.08e-3 m | according to Kerstig (1986)"
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

  extends FuelClassification_base(final N_class=11, final diameter_prtcl={46.08, 23.04, 11.52, 5.76, 2.88, 1.44, 0.72, 0.36, 0.18, 0.09, 0.045}*1e-3);
end FuelClassification_example_11classes;
