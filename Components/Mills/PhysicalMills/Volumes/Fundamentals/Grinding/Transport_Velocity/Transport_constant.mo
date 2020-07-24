within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Transport_Velocity;
model Transport_constant "Constant radial transport velocity of coal on table"
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

  extends Transport_base;

public
  parameter ClaRa.Basics.Units.Velocity w_transport = 0.06 "radial transport velocity of coal on the table; according to Kersting (1986), p.24" annotation(Dialog(tab="General"));

protected
  parameter ClaRa.Basics.Units.Velocity w_r[n] = w_transport*ones(n) "vector";

end Transport_constant;
