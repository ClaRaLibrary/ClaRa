within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model Constant_L3_ypsDependent "All geo || L3 || HTC || depending on volume fraction || 2ph"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                           //
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L3;

  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransferVLE_L2;
  //extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferGas;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeTypeVLE_L3;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellTypeVLE_L3;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom[iCom.N_cv]=ones(iCom.N_cv)*10 "Constant heat transfer coefficient || [1]:= liq | [2]:= vap " annotation (Dialog(group="Heat Transfer"));
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

  final parameter ClaRa.Basics.Units.ThermalResistance HR_nom[iCom.N_cv]=1 ./ (alpha_nom .* geo.A_heat_CF[heatSurfaceAlloc]) "Nominal convective heat resistance";

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha[iCom.N_cv];
  ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Sum of zonal heat flows";
  ClaRa.Basics.Units.ThermalResistance HR[iCom.N_cv] "Convective heat resistance";


equation
  heat.Q_flow = alpha .* geo.A_heat_CF[heatSurfaceAlloc] .* iCom.volume ./ geo.volume .* (heat.T - iCom.T);
  Q_flow_tot = sum(heat.Q_flow);
  alpha = alpha_nom;
  HR[1] = 1 / max(Modelica.Constants.eps,alpha[1]* geo.A_heat_CF[heatSurfaceAlloc]);
  HR[2] = 1 / max(Modelica.Constants.eps,alpha[2]* geo.A_heat_CF[heatSurfaceAlloc]);
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
end Constant_L3_ypsDependent;
