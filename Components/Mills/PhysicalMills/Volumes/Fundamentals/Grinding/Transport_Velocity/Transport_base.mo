within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Grinding.Transport_Velocity;
model Transport_base
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

  //parameter ClaRa.Basics.Units.Velocity w_r_start = 0.25 "initial radial transport velocity of coal on the table" annotation(Dialog(tab="Initialisation"));
public
  parameter ClaRa.Basics.Units.Angle alpha_crit = 10/180*Modelica.Constants.pi "Friction Angle of Hard Coal Pile (=max. slope); 30-35° for stationary conditions" annotation(Dialog(tab="General"));
  parameter ClaRa.Basics.Units.Angle alpha_start = 23/180*Modelica.Constants.pi "Initital Angle of Coal Pile on Table" annotation(Dialog(tab="General"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));

end Transport_base;
