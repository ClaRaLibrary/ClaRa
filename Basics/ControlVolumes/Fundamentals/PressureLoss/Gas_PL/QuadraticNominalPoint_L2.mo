within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL;
model QuadraticNominalPoint_L2 "Gas || Quadratic PL based on nominal values"
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

  import Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;

  outer ClaRa.Basics.Records.IComGas_L2 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.ShellTypeGas_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.TubeTypeGas_L2;

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.PressureLoss_L2;

  final parameter  ClaRa.Basics.Units.DensityMassSpecific rho_nom=TILMedia.GasFunctions.density_phxi(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);

  parameter ClaRa.Basics.Units.Pressure Delta_p_nom=1000
    "Nominal pressure loss";
  parameter ClaRa.Basics.Units.Pressure Delta_p_smooth=0.2 * Delta_p_nom
    "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";

  final parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta=2*Delta_p_nom*geo.A_cross^2*rho_nom/iCom.m_flow_nom^2 "Pressure loss coefficient for total pipe";
  //density assumed to be equal to nominal density

  ClaRa.Basics.Units.DensityMassSpecific rho "Density";

equation
 rho = TILMedia.GasObjectFunctions.density_pTxi(
   iCom.p_bulk,
   iCom.T_bulk,
   iCom.xi_bulk,
   iCom.fluidPointer_bulk);


  iCom.m_flow_in = if useHomotopy then homotopy(rho*geo.A_cross* SmoothPower( Delta_p, Delta_p_smooth, 0.5)/(0.5*zeta*rho)^0.5,
                           (iCom.m_flow_nom/Delta_p_nom)*Delta_p)
                   else rho*geo.A_cross* SmoothPower( Delta_p, Delta_p_smooth, 0.5)/(0.5*zeta*rho)^0.5;
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
end QuadraticNominalPoint_L2;
