within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT;
model Constant_L2 "All Geo || L2 || HTC || Constant"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBasePlateVLE_L2;
  final parameter Integer HT_type = 0;

  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L2;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.HeatTransferGas;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectiveHeatTransfer;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.RadiantHeatTransfer;
  //   extends
  //     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Special.SpecialHeatTransfer;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeTypeVLE_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellTypeVLE_L2;
   import SM = ClaRa.Basics.Functions.Stepsmoother;
   import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;

   outer ClaRa.Basics.Records.IComBase_L2 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=10 "Constant heat transfer coefficient" annotation (Dialog(group="Heat Transfer"));
  final parameter ClaRa.Basics.Units.ThermalResistance HR_nom=1/(alpha_nom*geo.A_heat_CF[heatSurfaceAlloc]) "Nominal convective heat resistance";

  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));
  input Real CF_fouling=1 "Scaling factor accounting for the fouling of the wall" annotation (Dialog(group="Heat Transfer"));

   parameter String temperatureDifference="Logarithmic mean - smoothed" "Temperature Difference" annotation (Dialog(group="Heat Transfer"), choices(
       choice = "Arithmetic mean",
       choice = "Logarithmic mean - smoothed",
       choice = "Inlet",
       choice = "Outlet",
       choice = "Bulk"));

  ClaRa.Basics.Units.TemperatureDifference Delta_T_wi "Temperature difference between wall and fluid inlet temperature";
  ClaRa.Basics.Units.TemperatureDifference Delta_T_wo "Temperature difference between wall and fluid outlet temperature";
  ClaRa.Basics.Units.TemperatureDifference Delta_T_mean "Mean temperature difference used for heat transfer calculation";

  ClaRa.Basics.Units.TemperatureDifference Delta_T_U "Upper temperature difference";
  ClaRa.Basics.Units.TemperatureDifference Delta_T_L "Lower temperature difference";

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha "Heat transfer coefficient used for heat transfer calculation";
  ClaRa.Basics.Units.ThermalResistance HR "Convective heat resistance";

equation
   Delta_T_wi = heat.T - iCom.T_in;
   Delta_T_wo = heat.T - iCom.T_out;
   Delta_T_U = ClaRa.Basics.Functions.maxAbs(Delta_T_wi, Delta_T_wo, 0.1);
   Delta_T_L = ClaRa.Basics.Functions.minAbs(Delta_T_wi, Delta_T_wo, 0.1);

   if temperatureDifference == "Logarithmic mean" then
     //The following equation is only supported due to an backward compatibility issue - avoid its usage
    Delta_T_mean = noEvent(if floor(abs(Delta_T_wo)*1/Modelica.Constants.eps) <= 1 or floor(abs(Delta_T_wi)*1/Modelica.Constants.eps) <= 1 then 0 elseif (heat.T < iCom.T_out and heat.T > iCom.T_in) or (heat.T > iCom.T_out and heat.T < iCom.T_in) then 0 elseif floor(abs(Delta_T_wo - Delta_T_wi)*1/Modelica.Constants.eps) < 1 then Delta_T_wi else (Delta_T_U - Delta_T_L)/log(Delta_T_U/Delta_T_L));
   elseif temperatureDifference == "Logarithmic mean - smoothed" then
    Delta_T_mean = SM(
      0.1,
      Modelica.Constants.eps,
      abs(Delta_T_L))*SM(
      0.01,
      Modelica.Constants.eps,
      Delta_T_U*Delta_T_L)*SZT(
      (Delta_T_U - Delta_T_L)/log(abs(Delta_T_U)/(abs(Delta_T_L) + 1e-9)),
      Delta_T_wi,
      (abs(Delta_T_U) - abs(Delta_T_L)) - 0.01,
      0.001);
   elseif temperatureDifference == "Arithmetic mean" then
     Delta_T_mean = heat.T - (iCom.T_in + iCom.T_out)/2;
   elseif temperatureDifference == "Bulk" then
     Delta_T_mean = heat.T - iCom.T_bulk;
   elseif temperatureDifference == "Inlet" then
     Delta_T_mean = heat.T - iCom.T_in;
   else
     Delta_T_mean = heat.T - iCom.T_out;
   end if;

  alpha = alpha_nom*CF_fouling;

  HR = 1/max(Modelica.Constants.eps,alpha*geo.A_heat_CF[heatSurfaceAlloc]);

  heat.Q_flow = alpha*geo.A_heat_CF[heatSurfaceAlloc]*Delta_T_mean;
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
end Constant_L2;
