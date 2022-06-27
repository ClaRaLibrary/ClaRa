within ClaRa.Basics.Records;
model FluidVLE_L34 "A record for basic VLE fluid data from L3 and L4-type models"
  extends Icons.RecordIcon;
  parameter Boolean showExpertSummary= false;
  parameter Integer N_cv "Number of zones or nodes";
  input Units.Mass mass[N_cv] "System mass" annotation (Dialog(show));
  input Units.Temperature T[N_cv] "System temperature" annotation (Dialog);
  input Units.Temperature T_sat[N_cv] if showExpertSummary "System saturation temperature" annotation (Dialog);
  input Units.Pressure p[N_cv] "System pressure" annotation (Dialog(show));
  input Units.EnthalpyMassSpecific h[N_cv] "System specific enthalpy" annotation (Dialog(show));
  input Units.EnthalpyMassSpecific h_bub[N_cv] if showExpertSummary "Bubble specific enthalpy" annotation (Dialog(show));
  input Units.EnthalpyMassSpecific h_dew[N_cv] if showExpertSummary "Dew specific enthalpy" annotation (Dialog(show));
  input Units.EntropyMassSpecific s[N_cv] if showExpertSummary "System specific entropy" annotation (Dialog);
  input Units.MassFraction steamQuality[N_cv] if showExpertSummary annotation (Dialog);
  input Modelica.Units.SI.Enthalpy H[N_cv]
                                          if showExpertSummary "System enthalpy" annotation (Dialog(show));
  input Units.DensityMassSpecific rho[N_cv] if showExpertSummary annotation (Dialog);
annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2022.</p>
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
end FluidVLE_L34;
