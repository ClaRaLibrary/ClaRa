within ClaRa.Components.TurboMachines.Compressors;
model CompressorVLE_L1_simple "A compressor for VLE mixtures with a volume flow rate depending on drive power and pressure difference only"
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

  extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.Pump_Base(inlet(m_flow(start=m_flow_start)));
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.bubblePressure_Txi;

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_elMech=0,
    powerOut_th=0,
    powerAux=P_drive)  if contributeToCycleSummary;

  parameter Real eta_mech = 0.98 "Mechanic efficiency of the drive"
   annotation(Dialog(group="Part Load and Efficiency"));
  parameter Real eta_hyd = 0.9 "Hydraulic efficiency"
   annotation(Dialog(group="Part Load and Efficiency"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_start=1 "Initial guess value for mass flow" annotation (Dialog(group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_eps=100 "Small pressure difference for linearisation around zero" annotation (Dialog(tab="Expert Settings", group="Numerical Robustnes"));

  Modelica.Blocks.Interfaces.RealInput P_drive "Power input of the pump's motor"
                                      annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

//  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid ptr_iso_in(vleFluidType=medium);
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid ptr_iso_out(vleFluidType=medium);

  ClaRa.Components.TurboMachines.Pumps.Fundamentals.Summary summary(
    outline(
      V_flow=V_flow,
      P_fluid=P_fluid,
      Delta_p=Delta_p,
      head=Delta_p/((fluidIn.d + fluidOut.d)/2*Modelica.Constants.g_n),
      NPSHa=(inlet.p - bubblePressure_Txi(
          fluidIn.T,
          fluidIn.xi,
          fluidIn.vleFluidPointer))/(fluidIn.d*Modelica.Constants.g_n),
      eta_hyd=eta_hyd,
      eta_mech=eta_mech),
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=inlet.m_flow,
      T=fluidIn.T,
      p=inlet.p,
      h=fluidIn.h,
      s=fluidIn.s,
      steamQuality=fluidIn.q,
      H_flow=fluidIn.h*inlet.m_flow,
      rho=fluidIn.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOut.T,
      p=outlet.p,
      h=fluidOut.h,
      s=fluidOut.s,
      steamQuality=fluidOut.q,
      H_flow=-fluidOut.h*outlet.m_flow,
      rho=fluidOut.d)) annotation (Placement(transformation(extent={{-10,-11},{10,11}}, origin={-70,-91})));
equation
  P_fluid=P_drive*eta_mech;
//  V_flow= P_fluid/(Delta_p+Delta_p_eps);
  inlet.m_flow=V_flow * fluidIn.d;
  inlet.h_outflow=inStream(outlet.h_outflow); // This is a dummy - flow reversal is not supported!
//____________________ Balance equations ___________________
  inlet.m_flow + outlet.m_flow = 0.0 "Mass balance";
  Delta_p=outlet.p-inlet.p "Momentum balance";
//   inStream(inlet.h_outflow) + outlet.h_outflow + P_hyd/inlet.m_flow/eta_hyd = 0.0
//     "Energy balance";
//  P_fluid = (outlet.h_outflow - inStream(inlet.h_outflow))*(inlet.m_flow+1e-6) "Energy balance";
//  outlet.h_outflow = (ptr_iso_out.h_psxi(fluidOut.p, fluidIn.s, fluidOut.xi) - inStream(inlet.h_outflow))/eta_hyd + inStream(inlet.h_outflow) "Application of eta_hyd's definition";
  P_fluid = (ptr_iso_out.h_psxi(fluidOut.p, fluidIn.s, fluidOut.xi) - inStream(inlet.h_outflow))/eta_hyd * inlet.m_flow;
  outlet.h_outflow = P_fluid/(inlet.m_flow+1e-6) + inStream(inlet.h_outflow);
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
ClaRa development team, Copyright &copy; 2017 - 2022.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p> This component was developed for ClaRa library.</p>
<p><b>Acknowledgements:</b> </p>
<p><b>CLA:</b> </p>

</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
 Icon(graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineThickness=1,
            lineColor={167,25,48},
            fillPattern=FillPattern.None,
            pattern=DynamicSelect(LinePattern.None, if summary.outline.NPSHa <0 then LinePattern.Solid else LinePattern.None))}), Diagram(graphics));
end CompressorVLE_L1_simple;
