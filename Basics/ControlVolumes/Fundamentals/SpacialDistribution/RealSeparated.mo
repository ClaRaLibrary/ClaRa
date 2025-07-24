within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model RealSeparated "Separation | Real | outlet states depending on filling Level | All geometries"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealPhases;
  extends ClaRa.Basics.Icons.RealSeparation;
  import ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;

  parameter Units.Length radius_flange=0.05 "Flange radius" annotation (Dialog(group="Flange Geometry and Inlet Behaviour"));
  parameter Real absorbInflow(
    min=0,
    max=1) = 1 "absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"
                                                                                          annotation(Dialog(group="Flange Geometry and Inlet Behaviour"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation" annotation(Dialog(group="Shape interpretation"));

  final parameter Units.Length z_max_in[geo.N_inlet]={min(geo.z_in[i] + radius_flange, geo.height_fill) for i in 1:geo.N_inlet} "Upper edges of inlet flanges";
  final parameter Units.Length z_min_in[geo.N_inlet]={max(1e-3, geo.z_in[i] - radius_flange) for i in 1:geo.N_inlet} "Lower edges of inlet flanges";
  final parameter Units.Length z_max_out[geo.N_outlet]={min(geo.z_out[i] + radius_flange, geo.height_fill) for i in 1:geo.N_outlet} "Upper edges of outlet flanges";
  final parameter Units.Length z_min_out[geo.N_outlet]={max(1e-3, geo.z_out[i] - radius_flange) for i in 1:geo.N_outlet} "Lower edges of outlet flanges";
  Units.DensityMassSpecific rho[iCom.N_cv] "Zonal density";
  Units.MassFraction steamQuality_in[geo.N_inlet] "Inlet steam quality";
  Units.MassFraction steamQuality_out[geo.N_outlet] "Outlet steam quality";
  Units.Area A_hor_act "Actual horizontal surface size";

protected
  constant Units.Length level_abs_min=1e-6 "Min. absolute level";
  Modelica.Blocks.Tables.CombiTable1Dv table(table=geo.shape, columns={2}, smoothness=smoothness) "Shape table for level calculation";
  Units.EnthalpyMassSpecific h_bubin[geo.N_inlet] "Inlet bubble spec. enthalpy";
  Units.EnthalpyMassSpecific h_bubout[geo.N_outlet] "Outlet bubble spec. enthalpy";
  Units.EnthalpyMassSpecific h_dewin[geo.N_inlet] "Inlet dew spec. enthalpy";
  Units.EnthalpyMassSpecific h_dewout[geo.N_outlet] "Outlet dew spec. enthalpy";
equation
  //_________________________Calculation of the Level______________________________
  A_hor_act = geo.A_hor*table.y[1];
  table.u[1] = level_rel;

  level_abs = min(geo.height_fill, max(level_abs_min, iCom.volume[1]/(A_hor_act)));

  level_rel = level_abs/geo.height_fill;

  //_________________________Allocate mass flow rates to the two zones_____________
   m_flow_inliq = {semiLinear(
     iCom.m_flow_in[i],
     absorbInflow*(2 - zoneAlloc_in[i]) + (1 - absorbInflow)*(1 - steamQuality_in[i]),
     2 - zoneAlloc_in[i]) for i in 1:geo.N_inlet};
   m_flow_invap = {semiLinear(
     iCom.m_flow_in[i],
     absorbInflow*(zoneAlloc_in[i] - 1) + (1 - absorbInflow)*(steamQuality_in[i]),
     zoneAlloc_in[i] - 1) for i in 1:geo.N_inlet};
   m_flow_outliq = {semiLinear(
     iCom.m_flow_out[i],
     absorbInflow*(2 - zoneAlloc_out[i]) + (1 - absorbInflow)*(1 - steamQuality_out[i]),
     2 - zoneAlloc_out[i]) for i in 1:geo.N_outlet};
   m_flow_outvap = {semiLinear(
     iCom.m_flow_out[i],
     absorbInflow*(zoneAlloc_out[i] - 1) + (1 - absorbInflow)*(steamQuality_out[i]),
     zoneAlloc_out[i] - 1) for i in 1:geo.N_outlet};

//   H_flow_inliq = {semiLinear(
//     iCom.m_flow_in[i],
//     absorbInflow*(2 - zoneAlloc_in[i])*iCom.h_in[i] + (1 - absorbInflow)*(1-steamQuality_in[i])*min(h_bubin[i], iCom.h_in[i]),
//     (2 - zoneAlloc_in[i])*iCom.h[1])
//       for i in 1:geo.N_inlet};
//   H_flow_invap = {semiLinear(
//     iCom.m_flow_in[i],
//     absorbInflow*(zoneAlloc_in[i] - 1)*iCom.h_in[i] + (1 - absorbInflow)*    steamQuality_in[i]*max(h_dewin[i], iCom.h_in[i]),
//     (zoneAlloc_in[i] - 1)*iCom.h[2])
//       for i in 1:geo.N_inlet};
//
//   H_flow_outliq = {semiLinear(
//     iCom.m_flow_out[i],
//     absorbInflow*(2 - zoneAlloc_out[i])*iCom.h_out[i] + (1 - absorbInflow)*(1-steamQuality_out[i])*min(h_bubout[i], iCom.h_out[i]),
//     (2 - zoneAlloc_out[i])*iCom.h[1])
//       for i in 1:geo.N_outlet};
//
//   H_flow_outvap = {semiLinear(
//     iCom.m_flow_out[i],
//     absorbInflow*(zoneAlloc_out[i] - 1)*iCom.h_out[i] + (1 - absorbInflow)*    steamQuality_out[i]*max(h_dewout[i], iCom.h_out[i]),
//     (zoneAlloc_out[i] - 1)*iCom.h[2])
//       for i in 1:geo.N_outlet};

   H_flow_inliq = {SZT(
     absorbInflow*(2 - zoneAlloc_in[i])*iCom.m_flow_in[i]*iCom.h_in[i] + (1 - absorbInflow)*(1-steamQuality_in[i])*iCom.m_flow_in[i]*min(h_bubin[i], iCom.h_in[i]),
     (2 - zoneAlloc_in[i])*iCom.m_flow_in[i]*iCom.h[1],
     iCom.m_flow_in[i],
     1e-4) for i in 1:geo.N_inlet};
   H_flow_invap = {SZT(
     absorbInflow*(zoneAlloc_in[i] - 1)*iCom.m_flow_in[i]*iCom.h_in[i] + (1 - absorbInflow)*    steamQuality_in[i]*iCom.m_flow_in[i]*max(h_dewin[i], iCom.h_in[i]),
     (zoneAlloc_in[i] - 1)*iCom.m_flow_in[i]*iCom.h[2],
     iCom.m_flow_in[i],
     1e-4) for i in 1:geo.N_inlet};

   H_flow_outliq = {SZT(
     absorbInflow*(2 - zoneAlloc_out[i])*iCom.m_flow_out[i]*iCom.h_out[i] + (1 - absorbInflow)*(1-steamQuality_out[i])*iCom.m_flow_out[i]*min(h_bubout[i], iCom.h_out[i]),
     (2 - zoneAlloc_out[i])*iCom.m_flow_out[i]*iCom.h[1],
     iCom.m_flow_out[i],
     1e-4) for i in 1:geo.N_outlet};

   H_flow_outvap = {SZT(
     absorbInflow*(zoneAlloc_out[i] - 1)*iCom.m_flow_out[i]*iCom.h_out[i] + (1 - absorbInflow)*    steamQuality_out[i]*iCom.m_flow_out[i]*max(h_dewout[i], iCom.h_out[i]),
     (zoneAlloc_out[i] - 1)*iCom.m_flow_out[i]*iCom.h[2],
     iCom.m_flow_out[i],
     1e-4) for i in 1:geo.N_outlet};

  //_________________________Calculation of additional media data_________________
  rho ={TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
    iCom.p[i],
    iCom.h[i],
    iCom.xi[i, :],
    iCom.fluidPointer[i]) for i in 1:iCom.N_cv};
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

  //_________________________Calculation of the outflowing enthalpy _________________
  for i in 1:iCom.N_outlet loop
    //h_outflow_outliq[i] = Stepsmoother(z_min_out[i],z_max_out[i], level_abs)*iCom.h[2]+ (1-Stepsmoother(z_min_out[i],z_max_out[i], level_abs))*iCom.h[1];
    zoneAlloc_out[i] = Stepsmoother(
      z_min_out[i],
      z_max_out[i],
      level_abs) + 1;
  end for;
  for i in 1:iCom.N_inlet loop
    //h_inflow[i]  = Stepsmoother(z_min_in[i], z_max_in[i],  level_abs)*iCom.h[2]+ (1-Stepsmoother(z_min_in[i], z_max_in[i],  level_abs))*iCom.h[1];
    zoneAlloc_in[i] = Stepsmoother(
      z_min_in[i],
      z_max_in[i],
      level_abs) + 1;
  end for;

  //__________________Calculation of the geostatic pressure differences_______________
//   Delta_p_geo_in = {(level_abs - geo.z_in[i])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_in[i] then rho[1] else rho[2]) for i in 1:geo.N_inlet};
//   Delta_p_geo_out = {(level_abs - geo.z_out[i])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_out[i] then rho[1] else rho[2]) for i in 1:geo.N_outlet};
   Delta_p_geo_in = {(level_abs - geo.z_in[i])*Modelica.Constants.g_n*SZT(rho[1], rho[2], level_abs - geo.z_in[i], (z_max_in[i]-z_min_in[i])/2) for i in 1:geo.N_inlet};
   Delta_p_geo_out = {(level_abs - geo.z_out[i])*Modelica.Constants.g_n*SZT(rho[1], rho[2], level_abs - geo.z_out[i], (z_max_out[i]-z_min_out[i])/2) for i in 1:geo.N_outlet};
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
end RealSeparated;
