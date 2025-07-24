within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation;
model Radiation_gas2Wall_advanced_L2 "All Geo || L2 || Radiation Between Gas And Wall (Advanced)"
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

  parameter String suspension_calculationType="Fixed" "Calculation type" annotation (Dialog(group="Emissivity and absorbance factor calculation of the suspension volume"), choices(
      choice="Fixed" "Use fixed value for gas emissivity",
      choice="Calculated" "Calculate suspension emissivity according to VDI Waermeatlas",
      choice="Gas calculated, particles fixed" "Gas emissivity calculated, particle emissivity fixed"));
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

  parameter Real emissivity_suspension_fixed=0.9 "Fixed value for gas emissivity" annotation (Dialog(enable=(suspension_calculationType == "Fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter Real absorbance_suspension_fixed=0.9 "Fixed value for gas absorbance" annotation (Dialog(enable=(suspension_calculationType == "Fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter Real emissivity_particle=0.2 "Value considering dust particles if emissivity and absorbance are calculated"
                                                                                      annotation (Dialog(enable=(suspension_calculationType == "Gas calculated, particles fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter ClaRa.Basics.Units.DensityMassSpecific soot_load_n=163.5e-6 "Amount of soot inside the products at standard temperature and pressure" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Soot particle properties"));

  parameter ClaRa.Basics.Units.MassFraction x_coke=0.1 "Coke fraction of used coal" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Coal particle properties"));

  parameter ClaRa.Basics.Units.DensityMassSpecific d_coke=850 "Coke density" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Coal particle properties"));

  parameter ClaRa.Basics.Units.Length diameter_mean_coke=65e-6 "Mean weighted diameter of coke particles (Rosin-Rammler-Distribution)" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Coal particle properties"));

  parameter Real n_var_coke=1.5 "Variance parameter of coke particle distribution (Rosin-Rammler-Distribution)"
                                                                                      annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Coal particle properties"));

  parameter Real Q_mean_abs_coke=0.85 "Mean relative cross section for absorption of coke particles" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Coal particle properties"));

  parameter ClaRa.Basics.Units.DensityMassSpecific d_ash=2200 "Ash density" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Ash particle properties"));

  parameter ClaRa.Basics.Units.Length diameter_mean_ash=16.8e-6 "Mean weighted diameter of ash particles (Rosin-Rammler-Distribution)" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Ash particle properties"));

  parameter Real n_var_ash=1.5 "Variance parameter of ash particle distribution (Rosin-Rammler-Distribution)"
                                                                                      annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Ash particle properties"));

  parameter Real Q_mean_abs_ash=0.2 "Mean relative cross section for absorption of ash particles" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Ash particle properties"));

  parameter String temperatureDifference="Outlet" "Temperature Difference" annotation (Dialog(group="Heat Transfer"), choices(
      choice="Arithmetic mean",
      choice="Inlet",
      choice="Outlet",
      choice = "Bulk"));

  Units.Temperature Delta_T_mean "Mean temperature";

public
  Real emissivity_suspension "Emissivity";
  Real absorbance_suspension "Absorbance";
  Real view_factor_wall "Radiation view factor";
  Real s_gl "Equivalent thickness";

protected
  Real x "Lenght for view factor calculation";
  Real y "Lenght for view factor calculation";
  Real a1_T_gas "Weighting factor with gas temperature";
  Real a2_T_gas "Weighting factor with gas temperature";
  Real a3_T_gas "Weighting factor with gas temperature";
  Real a1_T_wall "Weighting factor with wall temperature";
  Real a2_T_wall "Weighting factor with wall temperature";
  Real a3_T_wall "Weighting factor with wall temperature";
  Real emissivity_S_1 "Suspension emissivity factor";
  Real emissivity_S_2 "Suspension emissivity factor";
  Real emissivity_S_3 "Suspension emissivity factor";
  Real emissivity_H2O_CO2 "Emissivity of H2O and CO2 inside suspension";
  Real absorbance_H2O_CO2 "Absorbance of H2O and CO2 inside suspension";
  Real k_coke "Absorbance of coke particles";
  Real k_ash "Absorbance of ash particles";
  Real coke_load "Coke load";
  Real ash_load "Ash load";
  Real soot_load "Soot load";
  Real heat_flux_density "Heat flux density";

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock geo;
  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1] "Mean flue gas composition";
  outer ClaRa.Basics.Units.MassFraction xi_fuel "Mean fuel composition";

  TILMedia.Gas.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=Delta_T_mean,
    xi=xi_mean,
    gasType=iCom.mediumModel) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

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

  //T_mean = iCom.T_out;
  //zeros(iCom.mediumModel.nc-1) = - xi_mean * (iCom.m_flow_in - iCom.m_flow_out)
  //                      + (iCom.m_flow_in*iCom.xi_in - iCom.m_flow_out*iCom.xi_out);
  xi_mean = iCom.xi_out;
  s_gl = 3.6*(geo.volume/(geo.width*geo.length*2 + geo.width*geo.height*2 + geo.length*geo.height*2));

  x = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then geo.width/geo.height else geo.width/geo.length;
  y = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then geo.length/geo.height else geo.height/geo.length;

  //________________________/ Calculation of the view factor of the wall surface \_____________________
  view_factor_wall = 1 - (2/(Modelica.Constants.pi*x*y)*(1/2*log((1 + x^2)*(1 + y^2)/(1 + x^2 + y^2)) + x*sqrt(1 + y^2)*atan(x/sqrt(1 + y^2)) + y*sqrt(1 + x^2)*atan(y/sqrt(1 + x^2)) - x*atan(x) - y*atan(y)));
  // Calculated with difference of view-factor-sum (=1) and the view factor for top surface!

  //A_eff = CF_fouling*geo.A_heat_CF[heatSurfaceAlloc]*view_factor_wall;

  //________________________/ Calculation of gas emissivity and absorbance \_____________________
  if suspension_calculationType == "Fixed" then
    emissivity_suspension = emissivity_suspension_fixed;
    emissivity_H2O_CO2 = 0.0;
    absorbance_suspension = absorbance_suspension_fixed;
    absorbance_H2O_CO2 = 0.0;
    emissivity_S_1 = 0;
    emissivity_S_2 = 0;
    emissivity_S_3 = 0;
    a1_T_gas = 0;
    a2_T_gas = 0;
    a3_T_gas = 0;
    a1_T_wall = 0;
    a2_T_wall = 0;
    a3_T_wall = 0;
    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    heat.Q_flow = CF_fouling*geo.A_heat_CF[heatSurfaceAlloc]*view_factor_wall*Modelica.Constants.sigma*emissivity_wall/(absorbance_suspension + emissivity_wall - absorbance_suspension*emissivity_wall)*(absorbance_suspension*heat.T^4 - emissivity_suspension*Delta_T_mean^4);

  elseif suspension_calculationType == "Gas calculated, particles fixed" then

    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    a1_T_gas = 0.13 + 0.265*(Delta_T_mean/1000);
    a2_T_gas = 0.595 - 0.15*(Delta_T_mean/1000);
    a3_T_gas = 0.275 - 0.115*(Delta_T_mean/1000);

    a1_T_wall = 0.13 + 0.265*(heat.T/1000);
    a2_T_wall = 0.595 - 0.15*(heat.T/1000);
    a3_T_wall = 0.275 - 0.115*(heat.T/1000);

    emissivity_S_1 = (1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));
    emissivity_S_2 = (1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));
    emissivity_S_3 = (1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    emissivity_H2O_CO2 = a1_T_gas*emissivity_S_1 + a2_T_gas*emissivity_S_2 + a3_T_gas*emissivity_S_3;

    emissivity_suspension = emissivity_H2O_CO2 + emissivity_particle - emissivity_H2O_CO2*emissivity_particle;

    absorbance_H2O_CO2 = a1_T_wall*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_T_wall*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_T_wall*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    absorbance_suspension = absorbance_H2O_CO2 + emissivity_particle - absorbance_H2O_CO2*emissivity_particle;

    heat.Q_flow = CF_fouling*geo.A_heat_CF[heatSurfaceAlloc]*view_factor_wall*Modelica.Constants.sigma*emissivity_wall/(absorbance_suspension + emissivity_wall - absorbance_suspension*emissivity_wall)*(absorbance_suspension*heat.T^4 - emissivity_suspension*Delta_T_mean^4);

  elseif suspension_calculationType == "Calculated" then

    a1_T_gas = 0.13 + 0.265*(Delta_T_mean/1000);
    a2_T_gas = 0.595 - 0.15*(Delta_T_mean/1000);
    a3_T_gas = 0.275 - 0.115*(Delta_T_mean/1000);

    a1_T_wall = 0.13 + 0.265*(heat.T/1000);
    a2_T_wall = 0.595 - 0.15*(heat.T/1000);
    a3_T_wall = 0.275 - 0.115*(heat.T/1000);

    emissivity_H2O_CO2 = a1_T_gas*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_T_gas*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_T_gas*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    absorbance_H2O_CO2 = a1_T_wall*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_T_wall*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_T_wall*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    soot_load = soot_load_n*(273.15/Delta_T_mean);

    coke_load = x_coke*xi_fuel*properties.d;
    k_coke = Q_mean_abs_coke*3*Modelica.Constants.pi/(2*d_coke*diameter_mean_coke*n_var_coke*sin(Modelica.Constants.pi/n_var_coke));

    ash_load = properties.xi[1]*properties.d;
    k_ash = Q_mean_abs_ash*3*Modelica.Constants.pi/(2*d_ash*diameter_mean_ash*n_var_ash*sin(Modelica.Constants.pi/n_var_ash));

    emissivity_S_1 = (1 - exp(-(0*(properties.p_i[3] + properties.p_i[8])/1e5 + 3460*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));
    emissivity_S_2 = (1 - exp(-(0.824*(properties.p_i[3] + properties.p_i[8])/1e5 + 960*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));
    emissivity_S_3 = (1 - exp(-(25.91*(properties.p_i[3] + properties.p_i[8])/1e5 + 960*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));

    emissivity_suspension = a1_T_gas*emissivity_S_1 + a2_T_gas*emissivity_S_2 + a3_T_gas*emissivity_S_3;
    absorbance_suspension = a1_T_wall*emissivity_S_1 + a2_T_wall*emissivity_S_2 + a3_T_wall*emissivity_S_3;

    heat.Q_flow = CF_fouling*geo.A_heat_CF[heatSurfaceAlloc]*view_factor_wall*Modelica.Constants.sigma*(emissivity_S_1*emissivity_wall/(1 - (1 - emissivity_wall)*(1 - emissivity_S_1))*(a1_T_wall*heat.T^4 - a1_T_gas*Delta_T_mean^4) + emissivity_S_2*emissivity_wall/(1 - (1 - emissivity_wall)*(1 - emissivity_S_2))*(a2_T_wall*heat.T^4 - a2_T_gas*Delta_T_mean^4) + emissivity_S_3*emissivity_wall/(1 - (1 - emissivity_wall)*(1 - emissivity_S_3))*(a3_T_wall*heat.T^4 - a3_T_gas*Delta_T_mean^4));

  else
    emissivity_suspension = emissivity_suspension_fixed;
    emissivity_H2O_CO2 = 0.0;
    absorbance_suspension = absorbance_suspension_fixed;
    absorbance_H2O_CO2 = 0.0;
    emissivity_S_1 = 0;
    emissivity_S_2 = 0;
    emissivity_S_3 = 0;
    a1_T_gas = 0;
    a2_T_gas = 0;
    a3_T_gas = 0;
    a1_T_wall = 0;
    a2_T_wall = 0;
    a3_T_wall = 0;
    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    heat.Q_flow = CF_fouling*geo.A_heat_CF[heatSurfaceAlloc]*view_factor_wall*Modelica.Constants.sigma*emissivity_wall/(absorbance_suspension + emissivity_wall - absorbance_suspension*emissivity_wall)*(absorbance_suspension*heat.T^4 - emissivity_suspension*Delta_T_mean^4);
  end if;

  heat_flux_density = -heat.Q_flow/(1000*geo.A_heat[heatSurfaceAlloc]);

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for radiant heat transfer between gas and wall inside furnaces</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Emissivity and Absorbance of flue gas can be calculated</li>
<li>Emissivity of particles is regarded as constant value</li>
<li>Configuration factors are regarded (radiating gas volume is treated as radiating surface)</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10. bearbeitete und erweiterte Auflage, 2006, chapters Kb, Kc and Kd</li>
<li>Heat transfer equations are chosen as eq. (18) from chapter Kc if property calculations are not considered or eq. (6a) from chapter Ke (better approximation especially for surfaces with higher reflexion) if emissivities and absorbances are calculated</li>
<li>Particle parameters are to be set according to the Rosin-Rammler-Distribution</li>
</ul></p>
</html><html>
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
end Radiation_gas2Wall_advanced_L2;
