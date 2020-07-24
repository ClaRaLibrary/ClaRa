within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Records;
record iCom_Dryer
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

    // Gas
    replaceable parameter TILMedia.GasTypes.FlueGasTILMedia mediumModel "Used medium model" annotation(Dialog(tab="General"));
    ClaRa.Basics.Units.MassFraction xi_gas_in[mediumModel.nc - 1] "|Inlet||Inlet medium composition";
    ClaRa.Basics.Units.MassFraction xi_gas_out_s "Saturation mass fraction of condensing component";

    // Fuel
    parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel;
    ClaRa.Basics.Units.MassFraction xi_fuel_in[fuelModel.N_c - 1] "Inlet medium composition";

    // Mass Flow Rates
    ClaRa.Basics.Units.MassFlowRate m_flow_H2O_evap "Mass flow rate of evaporated coal H2O //m_flow_evap";
    ClaRa.Basics.Units.MassFlowRate m_flow_gas_in;
    ClaRa.Basics.Units.MassFlowRate m_flow_fuel_in;

end iCom_Dryer;
