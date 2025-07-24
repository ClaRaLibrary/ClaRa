within ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals;
model QuadraticFrictionFlowAreaSymetric_TWV "| Quadratic Pressure Dependency | Flow Area Definition | Opening Characteristics | Symetrical |"

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


  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Basic_TWV;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.TWV_L1;
  extends ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.TWV_L2;
  import SI = ClaRa.Basics.Units;
  parameter Basics.Units.Area effectiveFlowArea1=7.85e-3 "Effective flow area for straight outlet" annotation (Dialog(group="Valve Characteristics"));
  parameter Basics.Units.Area effectiveFlowArea2=effectiveFlowArea1 "Effective flow area for shunt outlet" annotation (Dialog(group="Valve Characteristics"));
  parameter Boolean useStabilisedMassFlow=false "|Expert Settings|Numerical Robustness|";
  parameter Basics.Units.Time Tau=0.001 "Time Constant of Stabilisation" annotation (Dialog(
      tab="Expert Settings",
      group="Numerical Robustness",
      enable=useStabilisedMassFlow));
  parameter Basics.Units.PressureDifference Delta_p_smooth=100 "Below this value, root function is approximated linearly" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));

  Basics.Units.Pressure Delta_p[2](start={10,10}) "Pressure differences";
equation
//////////// Simple hydraulics: ///////////////////////////////
  if useStabilisedMassFlow==false then
    Delta_p[1] = iCom.p_in - iCom.p_out1;
    Delta_p[2] = iCom.p_in - iCom.p_out2;
  else
    der(Delta_p[1]) = (iCom.p_in - iCom.p_out1 - Delta_p[1])/Tau;
    der(Delta_p[2]) = (iCom.p_in - iCom.p_out2 - Delta_p[1])/Tau;
  end if;

  m_flow_1 = sqrt(2*iCom.rho_out1)*ClaRa.Basics.Functions.ThermoRoot(Delta_p[1], Delta_p_smooth)*(aperture_)*effectiveFlowArea1;
  m_flow_2 = sqrt(2*iCom.rho_out2)*ClaRa.Basics.Functions.ThermoRoot(Delta_p[2], Delta_p_smooth)*(1-aperture_)*effectiveFlowArea2;

initial equation
  if useStabilisedMassFlow then
    Delta_p[1] = iCom.p_in - iCom.p_out1;
    Delta_p[2] = iCom.p_in - iCom.p_out2;
  end if;
    annotation (Documentation(info="<html>
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
</html>"));
end QuadraticFrictionFlowAreaSymetric_TWV;
