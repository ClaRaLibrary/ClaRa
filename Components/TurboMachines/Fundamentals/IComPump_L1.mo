within ClaRa.Components.TurboMachines.Fundamentals;
record IComPump_L1

//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2024, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//


  extends ClaRa.Basics.Icons.IComIcon;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium "Used medium model" annotation(Dialog(tab= "General"));
  Basics.Units.Power P_iso "Power for isentropic flow" annotation (Dialog(tab="General"));
  Basics.Units.Pressure Delta_p "Pressure difference between pressure side and suction side" annotation (Dialog(tab="General"));
  Basics.Units.VolumeFlowRate V_flow "Volume flow" annotation (Dialog(tab="General"));
  Basics.Units.RPM rpm "Rotational speed" annotation (Dialog(tab="General"));
  Basics.Units.MassFlowRate m_flow "Mass flow" annotation (Dialog(tab="General"));

  Basics.Units.Pressure Delta_p_max_var "Max. pressure difference at V_flow = 0 and rpm_nom" annotation (Dialog(tab="Nominal"));
  parameter Basics.Units.VolumeFlowRate V_flow_max "Max. flow at Delta_p = 0 and rpm_nom" annotation (Dialog(tab="Nominal"));
  parameter Basics.Units.RPM rpm_nom "nominal rotational speed" annotation (Dialog(tab="Nominal"));

//____Inlet_____________________________________________________________________________
  TILMedia.Internals.TILMediaExternalObject fluidPointer_in "Pointer to inlet gas object" annotation(Dialog(tab="Inlet"));
  Basics.Units.Pressure p_in "Inlet pressure" annotation (Dialog(tab="Inlet"));
  Basics.Units.EnthalpyMassSpecific h_in "Inlet enthalpy" annotation (Dialog(tab="Inlet"));
  Basics.Units.MassFraction xi_in[medium.nc - 1] "Inlet medium composition" annotation (Dialog(tab="Inlet"));
  Basics.Units.EnthalpyMassSpecific h_in_iso "Intlet isentropic enthalpy" annotation (Dialog(tab="Inlet"));

//____Outlet____________________________________________________________________________
  TILMedia.Internals.TILMediaExternalObject fluidPointer_out "Pointer to outlet gas object" annotation(Dialog(tab="Outlet"));
  Basics.Units.Pressure p_out "Outlet pressure" annotation (Dialog(tab="Outlet"));
  Basics.Units.EnthalpyMassSpecific h_out "Outlet enthalpy" annotation (Dialog(tab="Outlet"));
  Basics.Units.MassFraction xi_out[medium.nc - 1] "Outlet medium composition" annotation (Dialog(tab="Outlet"));
  Basics.Units.EnthalpyMassSpecific h_out_iso "Outlet isentropic enthalpy" annotation (Dialog(tab="Outlet"));

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
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=true)), Diagram(coordinateSystem(preserveAspectRatio=true)));
end IComPump_L1;
