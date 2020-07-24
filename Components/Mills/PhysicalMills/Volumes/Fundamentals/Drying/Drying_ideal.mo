within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Drying;
model Drying_ideal "Ideal coal drying process to desired residual water content| driven by H2O concentration difference"
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

  extends Drying_base;
  outer Records.iCom_Dryer iComDryer;

  parameter ClaRa.Basics.Units.MassFraction xi_H2O_res = 0.02 "residual water mass content of coal after drying";

//________Mass Flows___________
  ClaRa.Basics.Units.MassFlowRate m_flow_gas_evap_max "Maximum evaporation flow until gas saturation";
  ClaRa.Basics.Units.MassFlowRate m_flow_fuel_evap_max "Maximum evaporation flow until fuel dry out";

equation

  //Drying of Fuel: -----------------------------------------------------------------------------------------------------------------------------------
  m_flow_gas_evap_max = iComDryer.m_flow_gas_in*(iComDryer.xi_gas_out_s-iComDryer.xi_gas_in[iComDryer.mediumModel.condensingIndex]);  //Maximum H2O evaporation mass flow until gas is saturated
  m_flow_fuel_evap_max = iComDryer.m_flow_fuel_in*(1-sum(iComDryer.xi_fuel_in[:])-xi_H2O_res);  //Maximum H2O evaporation mass flow until fuel is dry

  iComDryer.m_flow_H2O_evap = min(m_flow_gas_evap_max,m_flow_fuel_evap_max);

end Drying_ideal;
