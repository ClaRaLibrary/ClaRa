within ClaRa.Basics.Records;
record IComBase_L3
  extends ClaRa.Basics.Icons.IComIcon;
  import SI = ClaRa.Basics.Units;

  parameter Integer N_cv= 2 "Number of zones";
  parameter Integer N_inlet= 1 "Number of inlet ports";
  parameter Integer N_outlet= 1 "Number of outlet ports";
//____Inlet______________________________________________________________________________
  Units.Pressure p_in[N_inlet] "|Inlet||Inlet pressure";
  Units.Temperature T_in[N_inlet] "|Inlet||Inlet Temperature";
  Units.MassFlowRate m_flow_in[N_inlet] "|Inlet||Inlet mass flow";

//____Outlet_____________________________________________________________________________
  Units.Pressure p_out[N_outlet] "|Outlet||Outlet pressure";
  Units.Temperature T_out[N_outlet] "|Outlet||Outlet Temperature";
  Units.MassFlowRate m_flow_out[N_outlet] "|Outlet||Outlet mass flow";

//_____Bulk______________________________________________________________________________
  Units.Temperature T[N_cv] "|System||Bulk Temperature";
  Units.Pressure p[N_cv] "|System||Outlet pressure";

//_____Nominal___________________________________________________________________________
  parameter Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(tab="Nominal"));
  parameter Units.PressureDifference Delta_p_nom=1e4 "Nominal pressure" annotation (Dialog(tab="Nominal"));
  parameter Units.MassFlowRate m_flow_nom=1 "Nominal mass flow" annotation (Dialog(tab="Nominal"));
  parameter Units.EnthalpyMassSpecific h_nom=1e4 "Nominal enthalpy" annotation (Dialog(tab="Nominal"));
  parameter Units.MassFraction xi_nom[:]={1} "Nominal mass fraction" annotation (Dialog(tab="Nominal"));

//____System_____________________________________________________________________________
  ClaRa.Basics.Units.Volume volume[N_cv] "|System||Volume of liquid and vapour zone" annotation (Dialog(tab="System"));
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
    defaultComponentPrefixes="inner");
end IComBase_L3;
