within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records;
record FuelClassification_base
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

 constant Integer N_class(min=1) "Number of particle classes";
 constant ClaRa.Basics.Units.Length diameter_prtcl[N_class] "Diameter of particles";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{-40,-100}},
          lineColor={221,222,223},
          fillColor={73,80,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,100},{40,-100}},
          lineColor={221,222,223},
          fillColor={73,80,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,20},{100,-100}},
          lineColor={221,222,223},
          fillColor={73,80,85},
          fillPattern=FillPattern.Solid)}),                      Diagram(coordinateSystem(preserveAspectRatio=false)));
end FuelClassification_base;
