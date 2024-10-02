within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model SimpleAnalyticalSlip_L4 "Simple slip correlation according to Zivi"
    extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.steamMassFraction_phxi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.vapourDensity_phxi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.liquidDensity_phxi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.bubbleSpecificEnthalpy_pxi;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.dewSpecificEnthalpy_pxi;

  Units.DensityMassSpecific rho[geo.N_cv] "Mixed cup density";
  Units.DensityMassSpecific rho_mix[geo.N_cv] "In-situ density";
  Units.VolumeFraction yps[geo.N_cv] "Void fraction";
  Real S[geo.N_cv] "Slip between phases";
  Units.EnthalpyMassSpecific h[geo.N_cv](start=h_start) "Slip model enthalpy";

//     TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.VLEFluidPointer ptr_slip[iCom.N_cv]={TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.VLEFluidPointer(
//       iCom.mediumModel.concatVLEFluidName,
//       7,
//       iCom.mediumModel.mixingRatio_propertyCalculation[1:end - 1]/sum(iCom.mediumModel.mixingRatio_propertyCalculation),
//       iCom.mediumModel.nc_propertyCalculation,
//       iCom.mediumModel.nc,
//       TILMedia.Internals.redirectModelicaFormatMessage()) for i in 1:iCom.N_cv};

  Units.DensityMassSpecific rho_vap[iCom.N_cv] "Density of vapour";
  Units.DensityMassSpecific rho_liq[iCom.N_cv] "Density of liquid";
  Units.EnthalpyMassSpecific h_liq[geo.N_cv] "Liquid specific enthalpy";
  Units.EnthalpyMassSpecific h_vap[geo.N_cv] "Vapour specific enthalpy";
  Real steamQuality[iCom.N_cv] "Steam quality";
  Units.Velocity w_gu[iCom.N_cv] "Mean drift velocity";

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid ptr_slip[iCom.N_cv](each vleFluidType=iCom.mediumModel) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
equation
    /////// Calculate Media Required Data  ///////////////////
  for i in 1:iCom.N_cv loop
    steamQuality[i] =steamMassFraction_phxi(iCom.p[i], h[i], iCom.xi[i, :], ptr_slip[i].vleFluidPointer);

    rho_vap[i] = vapourDensity_phxi(iCom.p[i], h[i], iCom.xi[i, :], ptr_slip[i].vleFluidPointer);

    rho_liq[i] = liquidDensity_phxi(iCom.p[i], h[i], iCom.xi[i, :], ptr_slip[i].vleFluidPointer);

    h_vap[i] = dewSpecificEnthalpy_pxi(iCom.p[i],iCom.xi[i, :], ptr_slip[i].vleFluidPointer);

    h_liq[i] = bubbleSpecificEnthalpy_pxi(iCom.p[i],iCom.xi[i, :], ptr_slip[i].vleFluidPointer);

    rho[i] = density_phxi(iCom.p[i], h[i], iCom.xi[i, :], ptr_slip[i].vleFluidPointer);

  end for;
  for i in 1:iCom.N_cv loop
      rho_mix[i]=(min(rho_vap[i],rho[i])*yps[i]+max(rho_liq[i],rho[i])*(1-yps[i]));
      yps[i]=(1+rho_vap[i]/rho_liq[i]*(1-steamQuality[i])/max(steamQuality[i],Modelica.Constants.eps)*S[i])^(-1);
      S[i]=(rho_vap[i]/rho_liq[i])^(-1/3);
      iCom.h[i]=(max(rho_liq[i],rho[i])*min(h_liq[i],h[i])*(1-yps[i])+min(rho_vap[i],rho[i])*max(h_vap[i],h[i])*yps[i])/rho_mix[i];
      w_gu[i]=0;
  end for;

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
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end SimpleAnalyticalSlip_L4;
