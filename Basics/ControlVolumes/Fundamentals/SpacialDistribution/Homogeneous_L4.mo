within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model Homogeneous_L4 "Both phases are in mechanical equilibrium"
    extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4;

  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi;

  Units.DensityMassSpecific rho_mix[geo.N_cv] "Mixture density";
  Real S[geo.N_cv] "Slip between phases";
  Units.EnthalpyMassSpecific h[geo.N_cv](start=h_start) "Slip model enthalpy";
  Units.Velocity w_gu[iCom.N_cv] "Mean drift velocity";

equation
      for i in 1:geo.N_cv loop
    rho_mix[i]=density_phxi(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
      S[i]=1;
      h[i]=iCom.h[i];
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
end Homogeneous_L4;
