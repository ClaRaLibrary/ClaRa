within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals;
record ICom_NTU_L3
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter String media[2] = {"vle", "vle"} "Outer side medium | innner side medium";

   ClaRa.Basics.Units.Temperature T_123_o[6]   annotation(Dialog);
   ClaRa.Basics.Units.Temperature T_123_i[6]   annotation(Dialog);
   ClaRa.Basics.Units.Temperature T_in2out_o[6]   annotation(Dialog);
   ClaRa.Basics.Units.Temperature T_in2out_i[6]   annotation(Dialog);

  ClaRa.Basics.Units.Pressure p_i annotation(Dialog);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_i_inlet   annotation(Dialog);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_o_inlet   annotation(Dialog);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_i_in[3]   annotation(Dialog);
  ClaRa.Basics.Units.Pressure p_o annotation(Dialog);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_o_in[3]   annotation(Dialog);
  TILMedia.Internals.TILMediaExternalObject ptr_i_in[3] annotation(Dialog);
  TILMedia.Internals.TILMediaExternalObject ptr_o_in[3] annotation(Dialog);

   ClaRa.Basics.Units.EnthalpyMassSpecific h_i_out[3];
   ClaRa.Basics.Units.EnthalpyMassSpecific h_o_out[3];
  TILMedia.Internals.TILMediaExternalObject ptr_i_out[3] annotation(Dialog);
  TILMedia.Internals.TILMediaExternalObject ptr_o_out[3] annotation(Dialog);

  ClaRa.Basics.Units.MassFraction xi_i[:] annotation(Dialog);
  ClaRa.Basics.Units.MassFraction xi_o[:] annotation(Dialog);

  ClaRa.Basics.Units.EnthalpyMassSpecific h_o_vap   annotation(Dialog);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_o_bub   annotation(Dialog);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_i_vap   annotation(Dialog);
  ClaRa.Basics.Units.EnthalpyMassSpecific h_i_bub   annotation(Dialog);

  ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_1ph;
  ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_2ph;
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
end ICom_NTU_L3;
