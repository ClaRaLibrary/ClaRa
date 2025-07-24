within ClaRa.Basics.Records;
record IComBase_L2 "Basic internal communication record"
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

//____Inlet______________________________________________________________________________
  Units.Pressure p_in "Inlet pressure" annotation (Dialog(tab="Inlet"));
  Units.Temperature T_in "Inlet Temperature" annotation (Dialog(tab="Inlet"));
  Units.MassFlowRate m_flow_in "Inlet mass flow" annotation (Dialog(tab="Inlet"));

//____Outlet_____________________________________________________________________________
  Units.Pressure p_out "Outlet pressure" annotation (Dialog(tab="Outlet"));
  Units.Temperature T_out "Outlet Temperature" annotation (Dialog(tab="Outlet"));
  Units.MassFlowRate m_flow_out "Outlet mass flow" annotation (Dialog(tab="Outlet"));

//_____Bulk______________________________________________________________________________
  Units.Temperature T_bulk "Bulk Temperature" annotation (Dialog(tab="Bulk"));
  Units.Pressure p_bulk "Outlet pressure" annotation (Dialog(tab="Bulk"));

//_____Nominal___________________________________________________________________________
  parameter Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(tab="Nominal"));
  parameter Units.MassFlowRate m_flow_nom=10 "Nominal mass flow" annotation (Dialog(tab="Nominal"));
  parameter Units.EnthalpyMassSpecific h_nom=1e4 "Nominal enthalpy" annotation (Dialog(tab="Nominal"));
  parameter Units.MassFraction xi_nom[:]={1} "Nominal mass fraction" annotation (Dialog(tab="Nominal"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_nom=100 "Nominal pressure loss" annotation (Dialog(tab="Nominal"), HideResult=true);
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
</html>"),   defaultComponentName="iCom",
    defaultComponentPrefixes="inner",
    Icon(graphics));
end IComBase_L2;
