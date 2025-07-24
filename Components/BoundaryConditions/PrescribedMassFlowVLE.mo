within ClaRa.Components.BoundaryConditions;
model PrescribedMassFlowVLE "A mass flow anchor with prescribed mass flow rate"
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
  extends ClaRa.Basics.Icons.FlowAnchor;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  //extends BaseClasses.Interfaces.DataInterface(p_int=outlet.p/1e5,h_int=outlet.h_outflow/1e3, m_flow_int=-outlet.m_flow, T_int=refrigerant.T-273.15, s_int=refrigerant.s/1e3);

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  //   parameter Modelica.SIunits.AbsolutePressure dp_nominal
  //     "Nominal pressure drop at full opening" annotation(Dialog(group="Nominal Values"));
  //   parameter Modelica.SIunits.MassFlowRate m_flow_nominal
  //     "Nominal mass flowrate at full opening" annotation(Dialog(group="Nominal Values"));

  parameter Boolean m_flowInputIsActive=false "True, if  a variable m_flow is used"
    annotation (Dialog(group="Control Signals"));

  //Real opening;
  Modelica.Fluid.Types.HydraulicConductance k "Hydraulic conductance at full opening";
  //=m_flow_nominal/dp_nominal
  ClaRa.Basics.Units.Pressure Delta_p "p_inlet-p_outlet";
  ClaRa.Basics.Units.MassFlowRate m_flow "Mass flowrate";
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_const=1 annotation (Dialog(
        group="Control Signals", enable=not m_flowInputIsActive));
  outer ClaRa.SimCenter simCenter;

  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port"
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
    h_in=actualStream(inlet.h_outflow),
    h_out=actualStream(outlet.h_outflow))
    annotation (Placement(transformation(extent={{-75,17},{-55,37}})));

  Modelica.Blocks.Interfaces.RealInput m_flow_in=m_flow if (
    m_flowInputIsActive) annotation (Placement(transformation(
        origin={0,70},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,70})));
  ClaRa.Basics.Interfaces.EyeOut eye
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{90,-50},{110,-30}})));

protected
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    p=outlet.p,
    h=noEvent(actualStream(outlet.h_outflow)),
    xi=noEvent(actualStream(outlet.xi_outflow))) annotation (Placement(transformation(extent={{22,-20},{42,0}})));

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
  inlet.h_outflow = inStream(outlet.h_outflow);
  outlet.h_outflow = inStream(inlet.h_outflow);

  // mass balance (no storage)
  inlet.m_flow + outlet.m_flow = 0;
  inlet.m_flow = m_flow;

  // No chemical reaction taking place:
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);
  //   refrigerant.h=outlet.h_outflow;
  //   refrigerant.p=outlet.p;

  eye.m_flow = -summary.m_flow_out;
  eye.T=fluidOut.T-273.15;
  eye.s=fluidOut.s/1000;
  eye.h=summary.h_out/1000;
  eye.p = summary.p_out/100000;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-50},{100,50}},
        grid={2,2}), graphics),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-50},{100,50}},
        grid={2,2}), graphics),
    Documentation(info="<HTML>
<p>This very simple model provides a pressure drop which is proportional to the flowrate and to the <code>opening</code> input, without computing any fluid property. It can be used for testing purposes, when
a simple model of a variable pressure loss is needed.</p>
<p>A medium model must be nevertheless be specified, so that the fluid ports can be connected to other components using the same medium model.</p>
<p>The model is adiabatic (no heat losses to the ambient) and neglects changes in kinetic energy from the inlet to the outlet.</p>

<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions="<html>
<ul>
<li><i>2 Nov 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Adapted from the ThermoPower library.</li>
</ul>
</html>"));
end PrescribedMassFlowVLE;
