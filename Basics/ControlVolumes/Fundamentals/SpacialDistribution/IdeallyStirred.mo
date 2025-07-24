within ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution;
model IdeallyStirred "Volume is ideally stirred"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdealPhases(final level_rel_start=0, final modelType="IdeallyStirred");
  extends ClaRa.Basics.Icons.IdealMixing;
  parameter String position_Delta_p_geo="inlet" "Position of geostatic pressure difference" annotation (choices(choice="mid", choice="inlet"), Dialog(group="Expert Settings"));
  parameter Boolean provideDensityDerivative=true "True if density derivative shall be provided" annotation (Dialog(group="Expert Settings"));
protected
  ClaRa.Basics.Units.DensityMassSpecific rho "Density used for geostatic pressure loss calculation";
equation
  //_________________________Calculation of the outflowing enthalpy _________________
  h_inflow = iCom.h_bulk;
  h_outflow = iCom.h_bulk;
  //__________________Calculation of the geostatic pressure differences_______________
  if provideDensityDerivative then
    rho =TILMedia.VLEFluid.ObjectFunctions.density_phxi(
      iCom.p_bulk,
      iCom.h_bulk,
      iCom.xi_bulk,
      iCom.fluidPointer_bulk);
  else
    rho =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
      iCom.p_bulk,
      iCom.h_bulk,
      iCom.xi_bulk,
      iCom.fluidPointer_bulk);
  end if;

  if position_Delta_p_geo == "mid" then
    Delta_p_geo_in =(geo.z_out[1] - geo.z_in[1])/2*Modelica.Constants.g_n*
      TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
      iCom.p_bulk,
      iCom.h_bulk,
      iCom.xi_bulk,
      iCom.fluidPointer_bulk);
    Delta_p_geo_out = -Delta_p_geo_in;
  elseif position_Delta_p_geo == "inlet" then
    Delta_p_geo_in =(geo.z_out[1] - geo.z_in[1])*Modelica.Constants.g_n*
      TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi(
      iCom.p_bulk,
      iCom.h_bulk,
      iCom.xi_bulk,
      iCom.fluidPointer_bulk);
    Delta_p_geo_out = 0;
  else
    Delta_p_geo_in = -1;
    Delta_p_geo_out = -1;
    assert(false, "Unknown option for positioning of geostatic pressure difference in phaseBorder model of type 'IdeallySeparated'!");
  end if;
  level_abs = 0;
  level_rel = 0;
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
</html>"),
    Icon(graphics),
    Diagram(graphics));
end IdeallyStirred;
