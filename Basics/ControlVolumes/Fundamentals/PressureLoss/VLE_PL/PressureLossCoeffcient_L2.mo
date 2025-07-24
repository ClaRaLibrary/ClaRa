within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL;
model PressureLossCoeffcient_L2 "All geo || Quadratic pressure loss || constant pressure loss coefficient || density dependent "
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLoss_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeTypeVLE_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellTypeVLE_L2;
  import TILMedia.VLEFluid.ObjectFunctions.density_phxi;
  import ClaRa.Basics.Functions.Stepsmoother;
protected
  ClaRa.Basics.Units.DensityMassSpecific rho_in "Density at inlet";
  ClaRa.Basics.Units.DensityMassSpecific rho_out "Density at outlet";

public
  ClaRa.Basics.Units.DensityMassSpecific rho=if useHomotopy then homotopy(Stepsmoother(
      10,
      -10,
      Delta_p)*rho_in + Stepsmoother(
      -10,
      10,
      Delta_p)*rho_out, rho_in) else Stepsmoother(
      10,
      -10,
      Delta_p)*rho_in + Stepsmoother(
      -10,
      10,
      Delta_p)*rho_out;

  parameter Units.Pressure Delta_p_smooth=100 "Start linearisation for decreasing pressure loss";
  parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta_TOT "Pressure loss coefficient";
equation
  rho_in = density_phxi(
    iCom.p_in,
    iCom.h_in,
    iCom.xi_in,
    iCom.fluidPointer_in);
  rho_out = density_phxi(
    iCom.p_out,
    iCom.h_out,
    iCom.xi_out,
    iCom.fluidPointer_out);

  iCom.m_flow_in =  rho*geo.A_cross*
    Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower(
    Delta_p,
    Delta_p_smooth,
    0.5)/(0.5*zeta_TOT*rho)^0.5;

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
end PressureLossCoeffcient_L2;
