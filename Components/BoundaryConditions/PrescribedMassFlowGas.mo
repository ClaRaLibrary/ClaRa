within ClaRa.Components.BoundaryConditions;
model PrescribedMassFlowGas "A mass flow anchor with prescribed mass flow rate"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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

  extends ClaRa.Basics.Icons.FlowAnchor;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  //extends BaseClasses.Interfaces.DataInterface(p_int=outlet.p/1e5,h_int=outlet.h_outflow/1e3, m_flow_int=-outlet.m_flow, T_int=refrigerant.T-273.15, s_int=refrigerant.s/1e3);

  parameter TILMedia.GasTypes.BaseGas                 medium = simCenter.flueGasModel "Medium in the component"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean m_flowInputIsActive=false "True, if  a variable m_flow is used"
    annotation (Dialog(group="Control Signals"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_const=1 annotation (Dialog(group="Control Signals", enable=not m_flowInputIsActive));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation(Dialog(group="Summary and Visualisation"));

  Modelica.Fluid.Types.HydraulicConductance k "Hydraulic conductance at full opening";
  Modelica.Units.SI.Pressure Delta_p "p_inlet-p_outlet";
  Modelica.Units.SI.MassFlowRate m_flow "Mass flowrate";

  outer ClaRa.SimCenter simCenter;

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

record Summary
  extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Units.EnthalpyMassSpecific h_in "Inlet specific enthalpy";
    ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Outlet specific enthalpy";
    ClaRa.Basics.Units.MassFlowRate m_flow_in "Inlet mass flow rate";
    ClaRa.Basics.Units.MassFlowRate m_flow_out "Outlet mass flow rate";
    ClaRa.Basics.Units.Pressure p_in "Inlet pressure";
    ClaRa.Basics.Units.Pressure p_out "Outlet pressure";
end Summary;
  Summary summary(
    m_flow_in=m_flow,
    m_flow_out=-m_flow,
    p_in=inlet.p,
    p_out=outlet.p,
    h_in=gasIn.h,
    h_out=gasOut.h)
    annotation (Placement(transformation(extent={{-75,17},{-55,37}})));

  Modelica.Blocks.Interfaces.RealInput m_flow_in=m_flow if (
    m_flowInputIsActive) annotation (Placement(transformation(
        origin={0,70},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,70})));

public
  ClaRa.Basics.Interfaces.EyeOutGas
                           eye(medium=medium) if showData
    annotation (Placement(transformation(extent={{90,-68},{110,-48}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
protected
  ClaRa.Basics.Interfaces.EyeInGas
                          eye_int(medium=medium)
    annotation (Placement(transformation(extent={{45,-59},{47,-57}})));

  TILMedia.Gas_pT gasOut(gasType=medium,
    p=outlet.p,
    T= noEvent(actualStream(outlet.T_outflow)),
    xi= noEvent(actualStream(outlet.xi_outflow)))
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

  TILMedia.Gas_pT      gasIn(gasType=medium,
    p=inlet.p,
    T= noEvent(actualStream(        inlet.T_outflow)),
    xi= noEvent(actualStream(inlet.xi_outflow)))
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

equation
  if (not m_flowInputIsActive) then
    m_flow = m_flow_const;
  end if;

  // Pressure drop in design flow direction
  Delta_p = inlet.p - outlet.p;

  //m_flow = homotopy(opening*k*Delta_p, m_flow_nominal*opening);
  //m_flow = opening*k*Delta_p;
  m_flow = k*Delta_p;
  // Isenthalpic state transformation (no storage and no loss of energy)
  inlet.T_outflow = inStream(outlet.T_outflow);
  outlet.T_outflow = inStream(inlet.T_outflow);

  // mass balance (no storage)
  inlet.m_flow + outlet.m_flow = 0;
  inlet.m_flow = m_flow;

  // No chemical reaction taking place:
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);
  //   refrigerant.h=outlet.h_outflow;
  //   refrigerant.p=outlet.p;

  eye.m_flow = summary.m_flow_in;

  eye_int.T = gasOut.T-273.15;
  eye_int.s = gasOut.s/1e3;
  eye_int.p = outlet.p/1e5;
  eye_int.h = gasOut.h/1e3;
  eye_int.xi=gasOut.xi;

  connect(eye_int, eye) annotation (Line(points={{46,-58},{100,-58}}, color={190,190,190}));
  annotation (
  Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
<p>Friedrich Gottelt, Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH, Copyright &copy; 2019-2020</p>
<p><a href=\"http://www.fvtr.de\">www.fvtr.de</a>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH for industry projects in cooperation with Lausitz Energie Kraftwerke AG, Cottbus.</p>
<b>Acknowledgements:</b>
<p>This model contribution is sponsored by Lausitz Energie Kraftwerke AG.</p>

<p><a href=\"http://www.leag.de\">www.leag.de</a> </p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>", revisions="<html>
<body>
<table>
  <tr>
    <th style=\"text-align: left;\">Date</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Version</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Author</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Affiliation</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Changes</th>
  </tr>
  <tr>
    <td>2020-08-20</td>
    <td> </td>
    <td>ClaRa 1.6.0</td>
    <td> </td>
    <td>Friedrich Gottelt</td>
    <td> </td>
    <td>FVTR GmbH</td>
    <td> </td>
    <td>Initial version of model</td>
  </tr>
</table>
<p>Version means first ClaRa version where the applied change was published.</p>
</body>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-50},{100,50}},
        grid={2,2}), graphics),
    Diagram(graphics,
            coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-50},{100,50}},
        grid={2,2})));
end PrescribedMassFlowGas;
