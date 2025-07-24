within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL;
model QuadraticPlateNominalPoint_L4 "VLE|| Quadratic plate PL with const. PL coeff"
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

  import SI = ClaRa.Basics.Units;
  import TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi;
  import Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.PressureLossPlate_L4;

  parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  parameter Units.Pressure Delta_p_smooth=iCom.Delta_p_nom/iCom.N_cv*0.2 "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";
  final parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta_TOT=geo.A_cross_FM[1]^2*2*iCom.Delta_p_nom*rho_nom/iCom.m_flow_nom^2 "Pressure loss coefficient for total pipe";

  Units.DensityMassSpecific rho[iCom.N_cv + 1] "Density in FlowModel cells";
protected
  Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta[iCom.N_cv + 1] "Pressure loss coefficient for total pipe";

equation
  /////// Calcultae Media Data Required //////////////////

  rho[2:geo.N_cv] = {smooth(1, noEvent(max(1e-6, if Delta_p[i] > 0 then density_phxi(
    iCom.p[i - 1],
    iCom.h[i - 1],
    iCom.xi[i - 1, :],
    iCom.fluidPointer[i - 1]) else density_phxi(
    iCom.p[i],
    iCom.h[i],
    iCom.xi[i, :],
    iCom.fluidPointer[i])))) for i in 2:iCom.N_cv};
  rho[1] = smooth(1, noEvent(max(1e-6, if Delta_p[1] > 0 then density_phxi(
    iCom.p_in[1],
    iCom.h_in[1],
    iCom.xi_in[1, :],
    iCom.fluidPointer_in[1]) else density_phxi(
    iCom.p[1],
    iCom.h[1],
    iCom.xi[1, :],
    iCom.fluidPointer[1]))));
  rho[geo.N_cv + 1] = smooth(1, noEvent(max(1e-6, if Delta_p[geo.N_cv + 1] > 0 then density_phxi(
    iCom.p[geo.N_cv],
    iCom.h[geo.N_cv],
    iCom.xi[geo.N_cv, :],
    iCom.fluidPointer[geo.N_cv]) else density_phxi(
    iCom.p_out[1],
    iCom.h_out[1],
    iCom.xi_out[1, :],
    iCom.fluidPointer_out[1]))));

  ////// Calculate Pressure Losses ////////////////////
  // Note that we want distribute zeta linearly over tha pipe length. Hence use zeta[i]=zeta_TOT*geo.Delta_x_FM[i]/(L -geo.Delta_x_FM[1]-geo.Delta_x_FM[N_cv+1] ) <-- notice that the last two terms depend on the flow model
  // for the homotopy equation we use the dp_pressureLossCoefficient_MFLOW function, linearised about the initial pressure difference.
  // Notice that we have to use the rugularised square root in order to allow for negative initial pressure losses!
  // Simplified homotopy eaution based on linear, density independent corellation, passing the m_flow=0 at Delat_p=0
  if not frictionAtInlet and not frictionAtOutlet then
    for i in 2:iCom.N_cv loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]);
      m_flow[i] = if useHomotopy then homotopy(rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5,
                           m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1])))
                   else rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5;
    end for;
    zeta[1] = 0;
    Delta_p[1] = 0;
    zeta[iCom.N_cv + 1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  elseif not frictionAtInlet and frictionAtOutlet then
    for i in 2:iCom.N_cv + 1 loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1]);
      m_flow[i] = if useHomotopy then homotopy(rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5,
                           m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1])))
                   else rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5;
    end for;
    zeta[1] = 0;
    Delta_p[1] = 0;

  elseif frictionAtInlet and not frictionAtOutlet then
    for i in 1:iCom.N_cv loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv + 1]);
      m_flow[i] = if useHomotopy then homotopy(rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5,
                           m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv + 1])))
                   else rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5;
    end for;
    zeta[iCom.N_cv + 1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  else
    //frictionAtInlet and frictionAtOutlet
    for i in 1:iCom.N_cv + 1 loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM));
      m_flow[i] = if useHomotopy then homotopy(rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5,
                           m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/sum(geo.Delta_x_FM)))
                   else rho[i]*geo.A_cross_FM[i]* SmoothPower( Delta_p[i], Delta_p_smooth, 0.5)/(0.5*zeta[i]*rho[i])^0.5;
    end for;
  end if;
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
end QuadraticPlateNominalPoint_L4;
