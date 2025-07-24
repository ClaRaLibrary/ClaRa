within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
partial model RealPhases "The phases are NOT in ideal thermodynamic equilibrium"

  extends ClaRa.Basics.Icons.RealPhases;
  parameter Real level_rel_start=0.5 "Start value for relative filling level (set by applying control volume)"
                                                                                          annotation(Dialog(enable=false, group="Initialisation"));
  outer parameter Boolean useHomotopy "True, if homotopy method is used during initialisation";

  outer ClaRa.Basics.Records.IComVLE_L3_NPort iCom "Internal communication record";
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo "Geometry record";

  Units.Pressure Delta_p_geo_in[geo.N_inlet] "Geodetic pressure difference to inlets";
  Units.Pressure Delta_p_geo_out[geo.N_outlet] "Geodetic pressure difference to outlets";

  Units.MassFraction zoneAlloc_in[geo.N_inlet] "Allocation of inlet mass flows to zones |1:liq|2:vap|";
  // For two-zonal models only! Other wise a vector of size N_cv-1 must be introduced
  Units.MassFraction zoneAlloc_out[geo.N_outlet] "Allocation of outlet mass flows to zones |1:liq|2:vap|";

  Units.Length level_abs "Absolute filling absLevel";
  Real level_rel(start=level_rel_start) "Relative filling absLevel";

  ClaRa.Basics.Units.MassFlowRate m_flow_inliq[geo.N_inlet] "Mass flow passing from inlet to zone 1 and vice versa";
  ClaRa.Basics.Units.MassFlowRate m_flow_invap[geo.N_inlet] "Mass flow passing from inlet to zone 2 and vice versa";
  ClaRa.Basics.Units.MassFlowRate m_flow_outliq[geo.N_outlet] "Mass flow passing from outlet to zone 1 and vice versa";
  ClaRa.Basics.Units.MassFlowRate m_flow_outvap[geo.N_outlet] "Mass flow passing from outlet to zone 2 and vice versa";

  ClaRa.Basics.Units.EnthalpyMassSpecific H_flow_inliq[geo.N_inlet] "Enthalpy flow passing from inlet to zone 1 and vice versa";
  ClaRa.Basics.Units.EnthalpyMassSpecific H_flow_invap[geo.N_inlet] "Enthalpy flow passing from inlet to zone 2 and vice versa";
  ClaRa.Basics.Units.EnthalpyMassSpecific H_flow_outliq[geo.N_outlet] "Enthalpy flow passing from outlet to zone 1 and vice versa";
  ClaRa.Basics.Units.EnthalpyMassSpecific H_flow_outvap[geo.N_outlet] "Enthalpy flow passing from outlet to zone 2 and vice versa";
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
</html>"));
end RealPhases;
