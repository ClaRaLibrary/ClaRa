within ClaRa.SubSystems.Boiler.Fundamentals;
record BoilerSummary "A summary for boilers - takes only the water steam side at the connectors into account"

//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2024, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//


  extends ClaRa.Basics.Icons.RecordIcon;

  Modelica.Units.SI.Pressure p_feed "Feedwater inlet pressure" annotation (Dialog(group="Feedwater"));
  Modelica.Units.SI.SpecificEnthalpy h_feed "Feedwater inlet specific enthalpy" annotation (Dialog(group="Feedwater"));
  Modelica.Units.SI.MassFlowRate m_flow_feed "Feedwater inlet mass flow" annotation (Dialog(group="Feedwater"));

  Modelica.Units.SI.Pressure p_LS "Live steam pressure" annotation (Dialog(group="Live steam"));
  Modelica.Units.SI.SpecificEnthalpy h_LS "Live steam specific enthalpy" annotation (Dialog(group="Live steam"));
  Modelica.Units.SI.MassFlowRate m_flow_LS "Live steam mass flow" annotation (Dialog(group="Live steam"));

  Modelica.Units.SI.Pressure p_cRH "Cold reheat pressure" annotation (Dialog(group="Cold Reheat"));
  Modelica.Units.SI.SpecificEnthalpy h_cRH "Cold reheat specific enthalpy" annotation (Dialog(group="Cold Reheat"));
  Modelica.Units.SI.MassFlowRate m_flow_cRH "Cold reheat mass flow" annotation (Dialog(group="Cold Reheat"));

  Modelica.Units.SI.Pressure p_hRH "Hot reheat pressure" annotation (Dialog(group="Hot Reheat"));
  Modelica.Units.SI.SpecificEnthalpy h_hRH "Hot reheat specific enthalpy" annotation (Dialog(group="Hot Reheat"));
  Modelica.Units.SI.MassFlowRate m_flow_hRH "Hot reheat mass flow" annotation (Dialog(group="Hot Reheat"));

end BoilerSummary;
