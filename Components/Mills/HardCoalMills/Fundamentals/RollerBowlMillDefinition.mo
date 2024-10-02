within ClaRa.Components.Mills.HardCoalMills.Fundamentals;
record RollerBowlMillDefinition "A record for defining the grey-box model by Niemzcek"

extends ClaRa.Basics.Icons.RecordIcon;
  parameter Real K_1=0.0390 "Fraction of coal on table pulverized per second";
  parameter Real K_2=0.0295 "Power consumation per kg pulverized coal on table in %.";
  parameter Real K_3=0.0451 "Power consumation per kg raw coal on table in %";
  parameter Real K_4=0.7664 "Fraction of coal in transport area leaving the mill";
  parameter Real K_5=0.0049 "Fraction of coal picked ip by primary airper second";
  parameter Real K_6=2.7329 "Classifier speed where m_flow_out=0";
  parameter Real K_7=3.6696 "Correction factor for primary air difference pressure";
  parameter Real K_8=0.0285 "Nominal value for 'gz/V' of the mill";
  parameter Real K_9=0.5222 "Fraction of coal in transport area falling down";
  parameter Real K_10=5.46 "Fraction of power dissipated";
  parameter Real K_11=19.8e6 "Heat capacity of the mill content";
  parameter Real K_12=1.7 "Friction loss coefficient for idle load, i.e. zeta/(2A^2)$";
  parameter Real E_e=0.34 "Power consumed for running empy mill in p.u.";
  parameter ClaRa.Basics.Units.Power P_nom=645e3 "Nominal mill power";
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
end RollerBowlMillDefinition;
