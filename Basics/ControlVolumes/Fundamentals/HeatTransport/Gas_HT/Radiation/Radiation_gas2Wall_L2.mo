within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation;
model Radiation_gas2Wall_L2 "All Geo || L2 || Radiation Between Gas and Wall"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.HeatTransfer_L2;
  outer ClaRa.Basics.Records.IComGas_L2 iCom;
  extends ClaRa.Basics.Icons.Epsilon;

  input Real CF_fouling=0.8 "Scaling factor accounting for the fouling of the wall"
                                                                                   annotation (Dialog(group="Heat Transfer"));
  parameter Real emissivity_wall=0.8 "Emissivity of the wall";
  parameter Real emissivity_flame=0.9 "Emissivity of the flame";
  parameter Real absorbance_flame=0.9 "Absorbance of the flame";
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock geo;

  parameter String temperatureDifference="Outlet" "Temperature Difference" annotation (Dialog(group="Heat Transfer"), choices(
      choice="Arithmetic mean",
      choice="Inlet",
      choice="Outlet",
      choice = "Bulk"));

  Units.Temperature Delta_T_mean "Mean temperature";

equation

  if temperatureDifference == "Arithmetic mean" then
    Delta_T_mean = (iCom.T_in + iCom.T_out)/2;
  elseif temperatureDifference == "Inlet" then
    Delta_T_mean = iCom.T_in;
  elseif temperatureDifference == "Outlet" then
    Delta_T_mean = iCom.T_out;
  elseif temperatureDifference == "Bulk" then
    Delta_T_mean = iCom.T_bulk;
  else
    Delta_T_mean = -1;
    assert(true, "Unknown temperature difference option in HT model");
  end if;

  //According to VDI Waermeatlas for a wall surrounding a gas volume chapter Kc5.
  heat.Q_flow = geo.A_heat_CF[heatSurfaceAlloc]*CF_fouling*Modelica.Constants.sigma*emissivity_wall/(absorbance_flame + emissivity_wall - absorbance_flame*emissivity_wall)*(absorbance_flame*heat.T^4 - emissivity_flame*Delta_T_mean^4);

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A simple correlation for radiant heat transfer between gas and wall inside furnaces</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>Emissivities of flue gas and wall are constant values</li>
<li>Heat transfer area is calculated from geometry</li>
</ul></p>
</html>
<html>
<p>&nbsp;</p>
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
end Radiation_gas2Wall_L2;
