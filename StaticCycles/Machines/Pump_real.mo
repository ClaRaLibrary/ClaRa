within ClaRa.StaticCycles.Machines;
model Pump_real "Real Pump || par.: efficiency || green | blue"
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
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter Real  efficiency= 1 "|Fundamental Definitions|Pump efficiency";
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false, start=1) "Mass flow rate";
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_in=
      TILMedia.VLEFluidFunctions.bubbleDensity_pxi(medium, p_in) "Inlet density";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false);
//   final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in=
//       TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, p_in);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in + (
      TILMedia.VLEFluidFunctions.specificEnthalpy_psxi(
      medium,
      p_out,
      TILMedia.VLEFluidFunctions.specificEntropy_phxi(
        medium,
        p_in,
        h_in)) - h_in)/efficiency "Outlet spec. enthalpy";
  final parameter ClaRa.Basics.Units.Power P_pump=m_flow*(h_out - h_in) "Pump power";
  final parameter ClaRa.Basics.Units.PressureDifference Delta_p = p_in - p_out "Presssure differerence p_in - p_out";

  Fundamentals.SteamSignal_green_a inlet annotation (Placement(transformation(extent={{-110,-10},{-100,10}}), iconTransformation(extent={{-110,-10},{-100,10}})));
  Fundamentals.SteamSignal_blue_b outlet(m_flow=m_flow, h=h_out) annotation (Placement(transformation(extent={{100,-10},{110,10}}), iconTransformation(extent={{100,-10},{110,10}})));
initial equation
  inlet.p=p_in;
  inlet.m_flow=m_flow;
  inlet.h=h_in;
  outlet.p=p_out;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                   graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_p <= 0 then FillPattern.Solid else FillPattern.Backward)),
        Line(
          points={{-98,0},{100,0}},
          color=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          smooth=Smooth.None),
        Line(
          points={{60,40},{100,0},{58,-42}},
          color=DynamicSelect({0,131,169}, if Delta_p <= 0 then {0,131,169} else {234,171,0}),
          smooth=Smooth.None)}),
                         Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end Pump_real;
