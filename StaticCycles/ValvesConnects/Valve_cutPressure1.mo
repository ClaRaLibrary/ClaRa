within ClaRa.StaticCycles.ValvesConnects;
model Valve_cutPressure1 "Valve || green | blue"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2016, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  // Green input: Values of p, m_flow and h are unknown and provided BY neighbor component.
 // Blue output: Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet perssure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false) "Mass flow rate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_nom=p_out-p_in "Nominal pressure drop";
  final parameter ClaRa.Basics.Units.Pressure Delta_p=p_in-p_out "Pressure difference";

  Fundamentals.SteamSignal_green_a inlet annotation (Placement(transformation(extent={{-60,-10},{-50,10}}), iconTransformation(extent={{-60,-10},{-50,10}})));
  Fundamentals.SteamSignal_blue_b outlet(m_flow=m_flow, h=h_out) annotation (Placement(transformation(extent={{50,-10},{60,10}}), iconTransformation(extent={{50,-10},{60,10}})));
initial equation
  outlet.p=p_out;
  inlet.p=p_in;
  inlet.h=h_in;
  inlet.m_flow=m_flow;

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,extent={{-50,-25},{50,25}}), graphics={
        Polygon(
          points={{-50,25},{-20,25},{-20,25},{-20,15},{0,5},{20,15},{20,25},{20,25},{50,25},{50,25},{50,-25},{50,-25},{20,-25},{20,-25},{20,-15},{0,-5},{-20,-15},{-20,-25},{-20,-25},{-50,-25},{-50,-25},{-50,25},{-50,25}},
          smooth=Smooth.Bezier,
          lineColor=DynamicSelect({0,131,169}, if Delta_p > 0 then {0,131,169} else {235,183,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_p > 0 then FillPattern.Solid else FillPattern.Backward))}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-50,-25},{50,25}}),   graphics));
end Valve_cutPressure1;
