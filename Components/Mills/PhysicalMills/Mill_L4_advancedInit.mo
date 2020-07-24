within ClaRa.Components.Mills.PhysicalMills;
model Mill_L4_advancedInit "Aerosol component | box module to capsule mill components | with initialisation support"
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

  extends ClaRa.Components.Mills.PhysicalMills.Mill_L4;
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow boundaryFuel_init(
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true)                                                                                                      annotation (Placement(transformation(extent={{80,60},{100,80}})));

  //-------------------------------------------------------------------------------
  // additional mass flows to make m_flow_out = m_flow_in while initializing
  ClaRa.Basics.Units.MassFlowRate m_flow_init;
  ClaRa.Basics.Units.MassFlowRate m_flow_init_ps;

initial equation
  m_flow_init = m_flow_init_ps;

equation

  //-------------------------------------------------------------------------------
  // initialisation support: adding the init mass flow

  der(m_flow_init_ps) = (m_flow_init - m_flow_init_ps)/10;

  if time < 2000 then
    m_flow_init = fuelInlet.m_flow - abs(aerosolFuelConcentrator.outlet.m_flow) - dryer.m_flow_H2O_evap;
    boundaryFuel_init.m_flow = m_flow_init;
  else
    m_flow_init = 0;
    boundaryFuel_init.m_flow = m_flow_init_ps;
  end if;

  // Temperature and composition for init boundary
  boundaryFuel_init.T = aerosolFuelConcentrator.outlet.T_outflow;
  boundaryFuel_init.xi = aerosolFuelConcentrator.outlet.xi_outflow;

  //-------------------------------------------------------------------------------

  connect(boundaryFuel_init.fuel_a, fuelOutlet) annotation (Line(
      points={{100,70},{110,70},{110,20},{140,20}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
end Mill_L4_advancedInit;
