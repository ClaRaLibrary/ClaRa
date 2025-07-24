within ClaRa.Components.Mills.HardCoalMills.Fundamentals;
model SummaryMill "A summary record for a roller bowl mill"

extends ClaRa.Basics.Icons.RecordIcon;
  input ClaRa.Basics.Units.MassFlowRate m_flow_coal_in "Coal mass flow entering the mill" annotation (Dialog);
  input ClaRa.Basics.Units.MassFlowRate m_flow_coal_out "Coal mass flow leaving the mill" annotation (Dialog);
  input ClaRa.Basics.Units.MassFlowRate m_flow_air_in "Coal mass flow entering the mill" annotation (Dialog);
  input ClaRa.Basics.Units.MassFlowRate m_flow_air_out "Coal mass flow leaving the mill" annotation (Dialog);
  input ClaRa.Basics.Units.MassFlowRate m_flow_tot_in "Total mass flow entering the mill" annotation (Dialog);
  input ClaRa.Basics.Units.MassFlowRate m_flow_tot_out "Total mass flow leaving the mill" annotation (Dialog);

  input ClaRa.Basics.Units.EnthalpyMassSpecific LHV_in "Lower heating value at mill inlet" annotation (Dialog);
  input ClaRa.Basics.Units.EnthalpyMassSpecific LHV_out "Lower heating value at mill outlet" annotation (Dialog);

  input ClaRa.Basics.Units.Temperature T_out "Classifier temperature" annotation (Dialog);
  input ClaRa.Basics.Units.Temperature T_coal_in "Coal inlet temperature" annotation (Dialog);
  input ClaRa.Basics.Units.Temperature T_air_in "Primary air inlet temperature" annotation (Dialog);
  input ClaRa.Basics.Units.RPM rpm_classifier "Classifier speed" annotation (Dialog);
  input ClaRa.Basics.Units.Power P_grind "Power consumed for grinding" annotation (Dialog);
  input ClaRa.Basics.Units.Mass mass_coal "Total coal mass in the mill" annotation (Dialog);

  input ClaRa.Basics.Units.MassFraction xi_coal_h2o_in "Water mass fraction of incoming coal" annotation (Dialog);
  input ClaRa.Basics.Units.MassFraction xi_coal_h2o_out "Water mass fraction of leaving coal" annotation (Dialog);

  input ClaRa.Basics.Units.MassFraction xi_air_h2o_in "Water mass fraction of incoming air" annotation (Dialog);
  input ClaRa.Basics.Units.MassFraction xi_air_h2o_out "Water mass fraction of leaving air" annotation (Dialog);
  input ClaRa.Basics.Units.MassFraction xi_air_h2o_sat "Max. water mass fraction at air path" annotation (Dialog);
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

end SummaryMill;
