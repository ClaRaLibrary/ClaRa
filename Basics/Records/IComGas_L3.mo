within ClaRa.Basics.Records;
record IComGas_L3
  extends IComBase_L3;

  replaceable parameter TILMedia.GasTypes.BaseGas mediumModel "Used medium model" annotation(Dialog(tab="General"));
  TILMedia.Internals.TILMediaExternalObject fluidPointer_in[N_inlet] "|Inlet||Fluid pointer of inlet ports";
  TILMedia.Internals.TILMediaExternalObject fluidPointer_out[N_outlet] "|Outlet||Fluid pointer of outlet ports";
  ClaRa.Basics.Units.EnthalpyMassSpecific h[N_cv] "|System||Specific enthalpy of liquid and vapour zone";
  Units.MassFraction xi[N_cv,mediumModel.nc - 1] "Medium composition" annotation (Dialog(tab="System"));
  TILMedia.Internals.TILMediaExternalObject fluidPointer[N_cv] "|Outlet||Fluid pointer of outlet ports";

//  ClaRa.Basics.Units.Volume volume[N_cv] "|System||Volume of liquid and vapour zone";
  Units.EnthalpyMassSpecific h_in[N_inlet] "|Inlet||Fluid pointer of inlet ports";
  Units.EnthalpyMassSpecific h_out[N_outlet] "|Outlet||Fluid pointer of outlet ports";

  Units.MassFraction xi_in[N_inlet,mediumModel.nc - 1] "|Inlet||Inlet medium composition";
  Units.MassFraction xi_out[N_outlet,mediumModel.nc - 1] "|Outlet||Outlet medium composition";
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
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end IComGas_L3;
