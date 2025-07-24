within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model RealMixed "Mixing | Real | outlet states depending volume fractions | All geometries"
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
  import ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealPhases;
  extends ClaRa.Basics.Icons.RealMixing;
  parameter Units.VolumeFraction eps_mix[2]={0.2,0.8} "Volume fraction V_1/V_tot of min/max mixed outlet" annotation (Dialog(group="Ouflow Behaviour"));

  Units.MassFraction steamQuality_in[geo.N_inlet] "Inlet steam quality";
  Units.MassFraction steamQuality_out[geo.N_outlet] "Outlet steam quality";

protected
  constant Units.MassFlowRate m_flow_eps=1e-3;
  Units.EnthalpyMassSpecific h_bubin[geo.N_inlet] "Inlet bubble spec. enthalpy";
  Units.EnthalpyMassSpecific h_bubout[geo.N_outlet] "Outlet bubble spec. enthalpy";
  Units.EnthalpyMassSpecific h_dewin[geo.N_inlet] "Inlet dew spec. enthalpy";
  Units.EnthalpyMassSpecific h_dewout[geo.N_outlet] "Outlet dew spec. enthalpy";
equation
  //_________________________Allocate mass flow rates to the two zones_____________
  m_flow_inliq = {(2 - zoneAlloc_in[i])*iCom.m_flow_in[i] for i in 1:geo.N_inlet};
  m_flow_invap = {(zoneAlloc_in[i] - 1)*iCom.m_flow_in[i] for i in 1:geo.N_inlet};
  m_flow_outliq = {(2 - zoneAlloc_out[i])*iCom.m_flow_out[i] for i in 1:geo.N_outlet};
  m_flow_outvap = {(zoneAlloc_out[i] - 1)*iCom.m_flow_out[i] for i in 1:geo.N_outlet};

  H_flow_inliq = {SZT(
    m_flow_inliq[i]*min(h_bubin[i], iCom.h_in[i]),
    (2 - zoneAlloc_in[i])*iCom.m_flow_in[i]*iCom.h[1],
    iCom.m_flow_in[i],
    1e-4) for i in 1:geo.N_inlet};
  H_flow_invap = {SZT(
    m_flow_invap[i]*max(h_dewin[i], iCom.h_in[i]),
    (zoneAlloc_in[i] - 1)*iCom.m_flow_in[i]*iCom.h[2],
     iCom.m_flow_in[i],
     1e-4) for i in 1:geo.N_inlet};

   H_flow_outliq = {SZT(
     m_flow_outliq[i]*min(h_bubout[i], iCom.h_out[i]),
     (2 - zoneAlloc_out[i])*iCom.m_flow_out[i]*iCom.h[1],
     iCom.m_flow_out[i],
     1e-4) for i in 1:geo.N_outlet};

   H_flow_outvap = {SZT(
     m_flow_outvap[i]*max(h_dewout[i], iCom.h_out[i]),
     (zoneAlloc_out[i] - 1)*iCom.m_flow_out[i]*iCom.h[2],
     iCom.m_flow_out[i],
     1e-4) for i in 1:geo.N_outlet};
  //_________________________Calculattion of additional media data_________________
  steamQuality_in ={TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
    iCom.p_in[i],
    iCom.h_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  steamQuality_out ={TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.steamMassFraction_phxi(
    iCom.p_out[i],
    iCom.h_out[i],
    iCom.xi_out[i, :],
    iCom.fluidPointer_out[i]) for i in 1:iCom.N_outlet};
  h_bubin ={TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.bubbleSpecificEnthalpy_pxi(
    iCom.p_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  h_dewin ={TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dewSpecificEnthalpy_pxi(
    iCom.p_in[i],
    iCom.xi_in[i, :],
    iCom.fluidPointer_in[i]) for i in 1:iCom.N_inlet};
  h_bubout ={TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.bubbleSpecificEnthalpy_pxi(
    iCom.p_out[i],
    iCom.xi_out[i, :],
    iCom.fluidPointer_out[i]) for i in 1:iCom.N_outlet};
  h_dewout ={TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dewSpecificEnthalpy_pxi(
    iCom.p_out[i],
    iCom.xi_out[i, :],
    iCom.fluidPointer_out[i]) for i in 1:iCom.N_outlet};

  //_________________________Calculation of the Level______________________________

  level_abs = -1;
  level_rel = iCom.volume[1]/geo.volume;

  //_________________________Calculation of the outflowing enthalpy _________________
  for i in 1:iCom.N_outlet loop
    zoneAlloc_out[i] = Stepsmoother(
      -m_flow_eps*0,
      m_flow_eps,
      iCom.m_flow_out[i])*Stepsmoother(
      eps_mix[1],
      eps_mix[2],
      iCom.volume[1]/geo.volume) + Stepsmoother(
      m_flow_eps,
      -m_flow_eps*0,
      iCom.m_flow_out[i])*steamQuality_out[i] + 1;
  end for;
  for i in 1:iCom.N_inlet loop
    zoneAlloc_in[i] = Stepsmoother(
      -m_flow_eps*0,
      m_flow_eps,
      iCom.m_flow_in[i])*Stepsmoother(
      eps_mix[1],
      eps_mix[2],
      iCom.volume[1]/geo.volume) + Stepsmoother(
      m_flow_eps,
      -m_flow_eps*0,
      iCom.m_flow_in[i])*steamQuality_in[i] + 1;
  end for;

  //__________________Calculation of the geostatic pressure differences_______________
  Delta_p_geo_in = zeros(geo.N_inlet);
  Delta_p_geo_out = zeros(geo.N_outlet);

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
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end RealMixed;
