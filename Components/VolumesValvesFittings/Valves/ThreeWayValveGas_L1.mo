within ClaRa.Components.VolumesValvesFittings.Valves;
model ThreeWayValveGas_L1 "Three way valve for gaseous media, not suitable for back flows!"
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
  extends ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValve_baseGas;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  replaceable model PressureLoss =
      ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticFrictionFlowAreaSymetric_TWV  constrainedby ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.TWV_L1 "Pressure loss model"
                                                                                            annotation(choicesAllMatching);

//  parameter SI.Area effectiveFlowArea=7.85e-3 "Effective flow area for outlets"
//    annotation(Dialog(group="Valve Parameters"));
//   parameter SI.Area effectiveFlowArea2=effectiveFlowArea1 "Effective flow area for outlet 2"
//     annotation(Dialog(group="Valve Parameters"));

public
  parameter Basics.Units.PressureDifference Delta_p_smooth=100 "Below this value, root function is approximated linearly" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));

parameter Boolean useStabilisedMassFlow=false "|Expert Settings|Numerical Robustness|";
  parameter Basics.Units.Time Tau=0.001 "Time Constant of Stabilisation" annotation (Dialog(
      tab="Expert Settings",
      group="Numerical Robustness",
      enable=useStabilisedMassFlow));

public
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    //     Outline outline;
    ClaRa.Basics.Records.FlangeGas           inlet;
    ClaRa.Basics.Records.FlangeGas           outlet1;
    ClaRa.Basics.Records.FlangeGas           outlet2;
  end Summary;

   Summary summary(inlet(mediumModel=medium, m_flow=inlet.m_flow,  T=gasIn.T, p=inlet.p, h=gasIn.h, xi=gasIn.xi, H_flow= gasIn.h*inlet.m_flow),
                   outlet1(mediumModel=medium, m_flow = -outlet1.m_flow, T=gasOut1.T, p=outlet1.p, h=gasOut1.h, xi=gasOut1.xi, H_flow= -gasOut1.h*outlet1.m_flow),
                   outlet2(mediumModel=medium, m_flow = -outlet2.m_flow, T=gasOut2.T, p=outlet2.p, h=gasOut2.h, xi=gasOut2.xi, H_flow= -gasOut2.h*outlet2.m_flow))
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

inner ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom_TWV iCom(
    p_in=inlet.p,
    p_out1=outlet1.p,
    p_out2=outlet2.p,
    rho_out1=gasOut1.d,
    rho_out2=gasOut2.d,
    opening_=splitRatio,
    m_flow_in=inlet.m_flow,
    rho_in=gasIn.d)      annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

    PressureLoss pressureLoss(useStabilisedMassFlow=useStabilisedMassFlow,
                              Tau=Tau,
                              Delta_p_smooth=Delta_p_smooth) annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  outlet1.m_flow = -pressureLoss.m_flow_1;
  outlet2.m_flow = -pressureLoss.m_flow_2;
  inlet.m_flow + outlet1.m_flow + outlet2.m_flow =0;

  //Isothermal state transformation. Isenthalpic behaviour can not be modeled using ideal gas substance properties.
  inlet.T_outflow *(-inlet.m_flow) = (inStream(outlet1.T_outflow)*outlet1.m_flow + inStream(outlet2.T_outflow)*outlet2.m_flow);// Please note: This valve is not designed for back flows. Please consider this as dummy value!
  outlet1.T_outflow = inStream(inlet.T_outflow);
  outlet2.T_outflow = inStream(inlet.T_outflow);

  // No chemical reaction taking place:
  zeros(medium.nc-1)=inlet.xi_outflow *inlet.m_flow + (inStream(outlet1.xi_outflow)*outlet1.m_flow + inStream(outlet2.xi_outflow)*outlet2.m_flow);
  outlet1.xi_outflow = inStream(inlet.xi_outflow);
  outlet2.xi_outflow = inStream(inlet.xi_outflow);

annotation (    Documentation(info="<html>
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,80}},
        grid={2,2}), graphics));
end ThreeWayValveGas_L1;
