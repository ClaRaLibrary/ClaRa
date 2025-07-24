within ClaRa.Components.VolumesValvesFittings.Valves;
model ThreeWayValveVLE_L1_simple "Three way valve for vle media | no reverse flow | no pressure dependeny |"
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
  extends ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValve_base;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

// record Outline
//   extends ClaRa.Basics.Icons.RecordIcon;
//     ClaRa.Basics.Units.Volume volume_tot "Total volume";
// end Outline;

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
//   Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet;
  ClaRa.Basics.Records.FlangeVLE           outlet1;
  ClaRa.Basics.Records.FlangeVLE           outlet2;
end Summary;

   Summary summary(inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h*inlet.m_flow, rho=fluidIn.d),
                   outlet1(showExpertSummary = showExpertSummary,m_flow = -outlet1.m_flow, T=fluidOut1.T, p=outlet1.p, h=fluidOut1.h, s=fluidOut1.s, steamQuality=fluidOut1.q, H_flow=-fluidOut1.h*outlet1.m_flow, rho=fluidOut1.d),
                   outlet2(showExpertSummary = showExpertSummary,m_flow = -outlet2.m_flow, T=fluidOut2.T, p=outlet2.p, h=fluidOut2.h, s=fluidOut2.s, steamQuality=fluidOut2.q, H_flow=-fluidOut2.h*outlet2.m_flow, rho=fluidOut2.d))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

equation
  // Pressure drop in design flow direction
  outlet2.p = inlet.p;

  // Isenthalpic state transformation (no storage and no loss of energy)
  inlet.h_outflow = (inStream(outlet1.h_outflow)*outlet1.m_flow + inStream(outlet2.h_outflow)*outlet2.m_flow)/(-inlet.m_flow);
  outlet1.h_outflow = inStream(inlet.h_outflow);
  outlet2.h_outflow = inStream(inlet.h_outflow);

  // mass balance (no storage)
  inlet.m_flow+outlet1.m_flow+outlet2.m_flow=0;
  -outlet1.m_flow=splitRatio*inlet.m_flow;

// No chemical reaction taking place:
  inlet.xi_outflow   = (inStream(outlet1.xi_outflow)*outlet1.m_flow + inStream(outlet2.xi_outflow)*outlet2.m_flow)/(-inlet.m_flow);
  outlet1.xi_outflow   = inStream(inlet.xi_outflow);
  outlet2.xi_outflow   = inStream(inlet.xi_outflow);

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
end ThreeWayValveVLE_L1_simple;
