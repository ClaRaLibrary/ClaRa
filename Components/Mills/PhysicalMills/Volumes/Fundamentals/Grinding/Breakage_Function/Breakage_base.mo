within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Breakage_Function;
model Breakage_base
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

  outer Records.iCom_Grinder iCom;

// given by modifier when instanciated
protected
  parameter Integer N_class = iCom.classification.N_class;
  parameter ClaRa.Basics.Units.Length d[N_class] = iCom.classification.diameter_prtcl "particle diameter, GEOMETRIC DISTRIBUTION!";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Breakage_base;
