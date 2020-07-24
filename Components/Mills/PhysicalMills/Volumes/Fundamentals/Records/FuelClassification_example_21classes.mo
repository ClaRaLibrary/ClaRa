within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records;
record FuelClassification_example_21classes "Default | 21 classes | geometric progression | p = sqrt(2)"
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

  extends FuelClassification_base(final N_class=21, final diameter_prtcl={10.24,7.2408,5.12,3.6204,2.56,1.8102,1.28,0.9051,0.64,0.4525,0.32,0.2263,0.16,0.1131,0.08,0.0566,0.04,0.0283,0.02,0.0141,0.01}*1e-3);
end FuelClassification_example_21classes;
