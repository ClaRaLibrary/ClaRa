within ClaRa.Components.MechanicalSeparation;
model SteamSeparatorVLE_L1
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

  extends ClaRa.Basics.Icons.Cyclone;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter Real eta_vap(min=0.5, max=0.999) = 0.96 "Efficiency of separating liquid from vapour (at steam outlet)"  annotation (Dialog(group="Fundamental Definitions"));
  parameter Real eta_liq(min=0.5, max=0.999) = 0.98 "Efficiency of separating vapour from liquid (at liquid outlet)"  annotation (Dialog(group="Fundamental Definitions"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if expert summary should be applied" annotation(Dialog(group="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                              annotation(Dialog(group="Summary and Visualisation"));
  constant Real eps=1e-3;
 model Summary
  extends ClaRa.Basics.Icons.RecordIcon;

   ClaRa.Basics.Records.FlangeVLE inlet;
   ClaRa.Basics.Records.FlangeVLE outlet1;
   ClaRa.Basics.Records.FlangeVLE outlet2;
 end Summary;
    outer ClaRa.SimCenter simCenter;

  ClaRa.Basics.Interfaces.FluidPortOut outlet1(Medium=medium) "Liquid outlet"
                                                                             annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet2(Medium=medium) "Steam outlet"  annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    h=inStream(inlet.h_outflow),
    p=inlet.p,
    xi=inStream(inlet.xi_outflow)) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOut1(
    vleFluidType=medium,
    h=actualStream(outlet1.h_outflow),
    p=outlet1.p,
    xi=actualStream(outlet1.xi_outflow)) annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOut2(
    vleFluidType=medium,
    h=actualStream(outlet2.h_outflow),
    p=outlet2.p,
    xi=actualStream(outlet2.xi_outflow)) annotation (Placement(transformation(extent={{-10,60},{10,80}})));

  ClaRa.Basics.Interfaces.EyeOut eye_out2
                                         if showData annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,100}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,110})));

  ClaRa.Basics.Interfaces.EyeOut eye_out1
                                         if showData annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-102}),iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-110})));

  Summary summary(
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=inlet.m_flow,
      p=inlet.p,
      h=fluidIn.h,
      T=fluidIn.T,
      s=fluidIn.s,
      steamQuality=fluidIn.q,
      H_flow=inlet.m_flow*fluidIn.h,
      rho=fluidIn.d),
    outlet1(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet1.m_flow,
      p=outlet1.p,
      h=fluidOut1.h,
      T=fluidOut1.T,
      s=fluidOut1.s,
      steamQuality=fluidOut1.q,
      H_flow=-outlet1.m_flow*fluidOut1.h,
      rho=fluidOut1.d),
    outlet2(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet2.m_flow,
      p=outlet2.p,
      h=fluidOut2.h,
      T=fluidOut2.T,
      s=fluidOut2.s,
      steamQuality=fluidOut2.q,
      H_flow=-outlet2.m_flow*fluidOut2.h,
      rho=fluidOut2.d))
                       annotation (Placement(transformation(extent={{-60,-60},{-80,-40}})));

protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{39,59},{41,61}})));

  ClaRa.Basics.Interfaces.EyeIn eye_int1[1]
    annotation (Placement(transformation(extent={{39,-59},{41,-61}})));

equation
  outlet2.h_outflow= SZT(fluidIn.h,
                         SZT(SZT((eta_liq*inlet.m_flow*fluidIn.q*fluidIn.VLE.h_v + (1-eta_vap)*inlet.m_flow*(1-fluidIn.q)*fluidIn.VLE.h_l)/noEvent(max(1e-3, inlet.m_flow*(eta_liq*fluidIn.q + eta_vap*fluidIn.q  + 1 - eta_vap - fluidIn.q))),
                                 fluidIn.h,
                                 fluidIn.VLE.h_v-fluidIn.h,
                                 eps),
                             fluidIn.h,
                             fluidIn.h-fluidIn.VLE.h_l,
                             eps),
                         inlet.p-fluidIn.crit.p,
                         eps);
  outlet1.h_outflow= SZT(fluidIn.h,
                         SZT(SZT((eta_vap*inlet.m_flow*(1-fluidIn.q)*fluidIn.VLE.h_l + (1-eta_liq)*inlet.m_flow*fluidIn.q*fluidIn.VLE.h_v)/noEvent(max(1e-3, inlet.m_flow*(eta_vap + fluidIn.q - eta_vap*fluidIn.q - eta_liq*fluidIn.q))),
                                 fluidIn.h,
                                 fluidIn.VLE.h_v-fluidIn.h,
                                 eps),
                             fluidIn.h,
                             fluidIn.h-fluidIn.VLE.h_l,
                             eps),
                         inlet.p-fluidIn.crit.p,
                         1e-6);

  inlet.h_outflow= fluidIn.VLE.h_l; //backflow not supported!

  inlet. p = outlet2.p;
  outlet2.m_flow = - inlet.m_flow*(eta_liq*fluidIn.q + eta_vap*fluidIn.q + 1 - eta_vap - fluidIn.q);
  // outlet1.m_flow = - inlet.m_flow*fluidIn.q;
  0 = inlet.m_flow + outlet1.m_flow + outlet2.m_flow;

  eye_int[1].m_flow=-outlet2.m_flow;
  eye_int[1].T=summary.outlet2.T-273.15;
  eye_int[1].s=fluidOut2.s/1000;
  eye_int[1].h=summary.outlet2.h/1000;
  eye_int[1].p=summary.outlet2.p/100000;

  eye_int1[1].m_flow=-outlet1.m_flow;
  eye_int1[1].T=summary.outlet1.T-273.15;
  eye_int1[1].s=fluidOut1.s/1000;
  eye_int1[1].h=summary.outlet1.h/1000;
  eye_int1[1].p=summary.outlet1.p/100000;

  connect(eye_int[1], eye_out2) annotation (Line(
      points={{40,60},{40,100}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int1[1], eye_out1) annotation (Line(
      points={{40,-60},{40,-102}},
      color={190,190,190},
      smooth=Smooth.None));
   annotation (  Documentation(info="<html>
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
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end SteamSeparatorVLE_L1;
