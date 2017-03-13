within ClaRa.StaticCycles.Machines;
model Turbine_mech "Turbine mith machanical flanges || par.: efficiency || green | blue"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.1.0                            //
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

  parameter Real efficiency= 1 "|Fundamental Definitions|Hydraulic efficiency";
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_in =  TILMedia.VLEFluidFunctions.density_phxi(medium, p_in,h_in) "Inlet density";
  final parameter ClaRa.Basics.Units.Power P_turbine=(-h_out + h_in)*m_flow "Turbine power";

//protected
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false,start=1) "Mass flow rate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific       h_out=h_in +
      efficiency*(TILMedia.VLEFluidFunctions.specificEnthalpy_psxi(
      medium,
      p_out,
      TILMedia.VLEFluidFunctions.specificEntropy_phxi(
        medium,
        p_in,
        h_in)) - h_in) "Outlet enthalpy";

  final parameter ClaRa.Basics.Units.Power P_in(fixed=false) "Power from left attached turbine";
  final parameter ClaRa.Basics.Units.PressureDifference Delta_p = p_in - p_out "Rprt: p_in - p_out";

public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_a inlet annotation (Placement(transformation(extent={{-70,30},{-60,50}}), iconTransformation(extent={{-70,30},{-60,50}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outlet(h=h_out, m_flow=m_flow) annotation (Placement(transformation(extent={{60,-90},{70,-70}}), iconTransformation(extent={{60,-90},{70,-70}})));

  ClaRa_Dev.StaticCycles.Fundamentals.PowerSignal_A power_in annotation (Placement(transformation(extent={{-68,-10},{-60,10}}), iconTransformation(extent={{-68,-10},{-60,10}})));
  ClaRa_Dev.StaticCycles.Fundamentals.PowerSignal_B power_out(power=P_in + P_turbine, s=power_in.s) annotation (Placement(transformation(extent={{60,-10},{68,10}}), iconTransformation(extent={{60,-10},{68,10}})));
initial equation
  inlet.m_flow=m_flow;
  inlet.p=p_in;
  inlet.h=h_in;
  outlet.p=p_out;
  power_in.power = P_in;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-60,
            -100},{60,100}}),  graphics),
              Icon(coordinateSystem(preserveAspectRatio=true,extent={{-60,-100},{60,100}}),
                   graphics={Polygon(
                                    points={{-60,50},{60,90},{60,-90},{-60,-50},{-60,50}},
                                    smooth=Smooth.None,
                                    lineColor=DynamicSelect({0,131,169}, if Delta_p >= 0 then {0,131,169} else {234,171,0}),
                                    fillColor={255,255,255},
                                    fillPattern=DynamicSelect(FillPattern.Solid, if Delta_p >= 0 then FillPattern.Solid else FillPattern.Backward))}));
end Turbine_mech;