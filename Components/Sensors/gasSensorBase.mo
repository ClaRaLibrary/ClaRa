within ClaRa.Components.Sensors;
model gasSensorBase "Base class for gas sensors"
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

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
        iconTransformation(extent={{-110,-110},{-90,-90}})));
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
        iconTransformation(extent={{90,-110},{110,-90}})));
  extends ClaRa.Basics.Icons.Sensor1;
  outer ClaRa.SimCenter simCenter;

inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

equation
  inlet.p = outlet.p;
  inlet.m_flow + outlet.m_flow = 0;
  inlet.T_outflow=inStream(outlet.T_outflow);
  outlet.T_outflow=inStream(inlet.T_outflow);
  inlet.xi_outflow=inStream(outlet.xi_outflow);
  outlet.xi_outflow=inStream(inlet.xi_outflow);

  annotation (                               Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                  graphics),
                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                         graphics));
end gasSensorBase;
