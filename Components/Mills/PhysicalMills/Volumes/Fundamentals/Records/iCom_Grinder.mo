within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records;
record iCom_Grinder
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

  extends ClaRa.Basics.Icons.IComIcon;

  // Geometry
  parameter Integer n;
  parameter ClaRa.Basics.Units.Length radius_table;
  parameter ClaRa.Basics.Units.Length radius[n];
  parameter ClaRa.Basics.Units.Area A_bottom [n];
  ClaRa.Basics.Units.Length height_sum[n];

  // Fuel Properties
  parameter ClaRa.Basics.Units.DensityMassSpecific rho_bulk;
  parameter Real HGI;
  parameter Real HGI_nom;
  parameter ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_base classification;
  ClaRa.Basics.Units.DensityMassSpecific rho;

  // Operational
  ClaRa.Basics.Units.RPM rpm_table;
  ClaRa.Basics.Units.Pressure p_grinding;

end iCom_Grinder;
