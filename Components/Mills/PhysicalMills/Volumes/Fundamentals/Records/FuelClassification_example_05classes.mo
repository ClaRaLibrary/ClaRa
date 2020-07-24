within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records;
record FuelClassification_example_05classes "5 classes | geometric progression | p = 3 | starting at 6.6e-3 m | according to Steinmetz (1991)"
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

  extends FuelClassification_base(final N_class=5, final diameter_prtcl={6.66, 2.22, 0.74, 0.25, 0.08}*1e-3);
end FuelClassification_example_05classes;
