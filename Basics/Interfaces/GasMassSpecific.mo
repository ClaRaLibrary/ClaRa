within ClaRa.Basics.Interfaces;
connector GasMassSpecific "A connector featuring T,p,X,m_dot"

  TILMedia.GasTypes.BaseGas                 Medium "Medium model";

  flow ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate from the connection point into the component";
  ClaRa.Basics.Units.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream ClaRa.Basics.Units.Temperature  T_outflow "Temperature close to the connection point if m_flow < 0";
  stream ClaRa.Basics.Units.MassFraction xi_outflow[Medium.nc-1] "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
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
end GasMassSpecific;
