within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records;
record iCom_FlowClassifier
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

  // Mass and Mass Flow
  ClaRa.Basics.Units.MassFlowRate m_flow_gas_in;
  ClaRa.Basics.Units.Mass mass_fuel_discrete[n,classification.N_class];

  // Fuel and Gas Properties
  parameter ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records.FuelClassification_base classification;
  ClaRa.Basics.Units.DynamicViscosity eta_gas;
  ClaRa.Basics.Units.DensityMassSpecific rho_fluid;
  ClaRa.Basics.Units.DensityMassSpecific rho_prtcl;

  // Geometry
  parameter Integer n( min=1);
  parameter ClaRa.Basics.Units.Area A_cross;
  parameter ClaRa.Basics.Units.Length delta_height;
  parameter ClaRa.Basics.Units.Length height;
  parameter ClaRa.Basics.Units.Volume delta_volume;

  // Gas Pressure
  ClaRa.Basics.Units.Pressure p_gas_in;
  ClaRa.Basics.Units.Pressure p_gas_out;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end iCom_FlowClassifier;
