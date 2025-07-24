within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation;
model Radiation_gas2Gas_advanced_L2 "All Geo || L2 || Radiation Between Gas Volumes (Advanced)"
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

  import ClaRa.Basics.Functions.Stepsmoother;

  parameter String suspension_calculationType="Fixed" "Calculation type" annotation (Dialog(group="Emissivity and absorbance factor calculation of the suspension volume"), choices(
      choice="Fixed" "Use fixed value for gas emissivity",
      choice="Calculated" "Calculate suspension emissivity according to VDI Waermeatlas",
      choice="Gas calculated, particles fixed" "Gas emissivity calculated, particle emissivity fixed"));

  parameter Real emissivity_source_fixed=0.9 "Fixed value for source emissivity" annotation (Dialog(enable=(suspension_calculationType == "Fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter Real emissivity_sink_fixed=0.9 "Fixed value for sink emissivity" annotation (Dialog(enable=(suspension_calculationType == "Fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter Real absorbance_source_fixed=0.9 "Fixed value for source absorbance" annotation (Dialog(enable=(suspension_calculationType == "Fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter Real emissivity_particle_source=0.2 "Value considering dust particles if emissivity and absorbance are calculated"
                                                                                      annotation (Dialog(enable=(suspension_calculationType == "Gas calculated, particles fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));
  parameter Real emissivity_particle_sink=0.2 "Value considering dust particles if emissivity and absorbance are calculated"
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

  parameter Real Q_m_abs_ash=0.2 "Mean relative cross section for absorption of ash particles" annotation (Dialog(enable=(suspension_calculationType == "Calculated"), group="Ash particle properties"));

public
  Units.Temperature T_mean "Mean temperature";
  Real emissivity_source "Emissivity of radiation source";
  Real emissivity_sink "Emissivity of radiation sink";
  Real absorbance_source "Absorbance of radiation source";
  Real s_gl "Equivalent thickness";

protected
  ClaRa.Basics.Units.Temperature T_source "Temperature of radiation source";
  ClaRa.Basics.Units.Temperature T_sink "Temperature of radiation source";
  Real view_factor "Radiation view factor";
  Real x "Lenght for view factor calculation";
  Real y "Lenght for view factor calculation";
  Real a1_source "Weighting factor with radiation source temperature";
  Real a2_source "Weighting factor with radiation source temperature";
  Real a3_source "Weighting factor with radiation source temperature";
  Real a1_sink "Weighting factor with radiation sink temperature";
  Real a2_sink "Weighting factor with radiation sink temperature";
  Real a3_sink "Weighting factor with radiation sink temperature";
  Real emissivity_H2O_CO2_source "Emissivity of H2O and CO2 of radiation source";
  Real emissivity_H2O_CO2_sink "Emissivity of H2O and CO2 of radiation sink";
  Real absorbance_H2O_CO2_source "Asorbance of H2O and CO2 of radiation source";
  Real emissivity_S_1 "Suspension emissivity factor";
  Real emissivity_S_2 "Suspension emissivity factor";
  Real emissivity_S_3 "Suspension emissivity factor";
  Real k_coke "Absorbance of coke particles";
  Real k_ash "Absorbance of ash particles";
  Real coke_load "Coke load";
  Real ash_load "Ash load";
  Real soot_load "Soot load";
  Real smooth "Smoothing factor";

  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1] "Mean flue gas composition";
  outer ClaRa.Basics.Units.MassFraction xi_fuel "Mean fuel composition";

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock geo;
  TILMedia.Gas.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=T_mean,
    xi=xi_mean,
    gasType=iCom.mediumModel) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

equation
  //T_mean = (iCom.T_out + iCom.T_in)/2;
  T_mean = iCom.T_out;
  // zeros(iCom.mediumModel.nc-1) = - xi_mean * (iCom.m_flow_in - iCom.m_flow_out)
  //                       + (iCom.m_flow_in*iCom.xi_in - iCom.m_flow_out*iCom.xi_out);
  xi_mean = iCom.xi_out;

  smooth = Stepsmoother(
    5,
    -5,
    (heat.T - T_mean));
  T_source = smooth*heat.T + (1 - smooth)*T_mean;
  T_sink = smooth*T_mean + (1 - smooth)*heat.T;

  x = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then geo.width/geo.height else geo.width/geo.length;
  y = if geo.flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then geo.length/geo.height else geo.height/geo.length;

  view_factor = (2/(Modelica.Constants.pi*x*y)*(1/2*log((1 + x^2)*(1 + y^2)/(1 + x^2 + y^2)) + x*sqrt(1 + y^2)*atan(x/sqrt(1 + y^2)) + y*sqrt(1 + x^2)*atan(y/sqrt(1 + x^2)) - x*atan(x) - y*atan(y)));

  s_gl = 3.6*(geo.volume/(geo.width*geo.length*2 + geo.width*geo.height*2 + geo.length*geo.height*2));

  //________________________/ Calculation of source emissivity and absorbance \_____________________
  if suspension_calculationType == "Fixed" then
    emissivity_source = emissivity_source_fixed;
    emissivity_H2O_CO2_source = 0.0;
    absorbance_source = absorbance_source_fixed;
    absorbance_H2O_CO2_source = 0.0;
    emissivity_sink = emissivity_sink_fixed;
    emissivity_H2O_CO2_sink = 0.0;

    a1_source = 0;
    a2_source = 0;
    a3_source = 0;
    emissivity_S_1 = 0;
    emissivity_S_2 = 0;
    emissivity_S_3 = 0;
    a1_sink = 0;
    a2_sink = 0;
    a3_sink = 0;
    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    heat.Q_flow = smooth*(geo.A_front*view_factor*Modelica.Constants.sigma*emissivity_sink/(absorbance_source + emissivity_sink - absorbance_source*emissivity_sink)*(emissivity_source*T_source^4 - absorbance_source*T_sink^4)) + (1 - smooth)*(-geo.A_front*view_factor*Modelica.Constants.sigma*emissivity_sink/(absorbance_source + emissivity_sink - absorbance_source*emissivity_sink)*(emissivity_source*T_source^4 - absorbance_source*T_sink^4));

  elseif suspension_calculationType == "Gas calculated, particles fixed" then

    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    a1_source = 0.13 + 0.265*(T_source/1000);
    a2_source = 0.595 - 0.15*(T_source/1000);
    a3_source = 0.275 - 0.115*(T_source/1000);

    a1_sink = 0.13 + 0.265*(T_sink/1000);
    a2_sink = 0.595 - 0.15*(T_sink/1000);
    a3_sink = 0.275 - 0.115*(T_sink/1000);

    emissivity_S_1 = (1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));
    emissivity_S_2 = (1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));
    emissivity_S_3 = (1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    emissivity_H2O_CO2_source = a1_source*emissivity_S_1 + a2_source*emissivity_S_2 + a3_source*emissivity_S_3;

    emissivity_source = emissivity_H2O_CO2_source + emissivity_particle_source - emissivity_H2O_CO2_source*emissivity_particle_source;

    //___________/ Absorbance of source volume is calculated with sink temperature (see VDI Waermeatlas)\___________________
    absorbance_H2O_CO2_source = a1_sink*emissivity_S_1 + a2_sink*emissivity_S_2 + a3_sink*emissivity_S_3;

    absorbance_source = absorbance_H2O_CO2_source + emissivity_particle_source - absorbance_H2O_CO2_source*emissivity_particle_source;

    //________________________/ Calculation of sink emissivity \_____________________
    emissivity_H2O_CO2_sink = a1_sink*emissivity_S_1 + a2_sink*emissivity_S_2 + a3_sink*emissivity_S_3;

    emissivity_sink = emissivity_H2O_CO2_sink + emissivity_particle_sink - emissivity_H2O_CO2_sink*emissivity_particle_sink;

    heat.Q_flow = smooth*(geo.A_front*view_factor*Modelica.Constants.sigma*emissivity_sink/(absorbance_source + emissivity_sink - absorbance_source*emissivity_sink)*(emissivity_source*T_source^4 - absorbance_source*T_sink^4)) + (1 - smooth)*(-geo.A_front*view_factor*Modelica.Constants.sigma*emissivity_sink/(absorbance_source + emissivity_sink - absorbance_source*emissivity_sink)*(emissivity_source*T_source^4 - absorbance_source*T_sink^4));

  elseif suspension_calculationType == "Calculated" then

    a1_source = 0.13 + 0.265*(T_source/1000);
    a2_source = 0.595 - 0.15*(T_source/1000);
    a3_source = 0.275 - 0.115*(T_source/1000);

    a1_sink = 0.13 + 0.265*(T_sink/1000);
    a2_sink = 0.595 - 0.15*(T_sink/1000);
    a3_sink = 0.275 - 0.115*(T_sink/1000);

    emissivity_H2O_CO2_source = a1_source*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_source*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_source*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    //___________/ Absorbance of source volume is calculated with sink temperature (see VDI Waermeatlas)\___________________
    absorbance_H2O_CO2_source = a1_sink*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_sink*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_sink*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    //________________________/ Calculation of sink emissivity \_____________________
    emissivity_H2O_CO2_sink = a1_sink*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_sink*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_sink*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    soot_load = soot_load_n*(273.15/T_mean);

    coke_load = x_coke*xi_fuel*properties.d;
    k_coke = Q_mean_abs_coke*3*Modelica.Constants.pi/(2*d_coke*diameter_mean_coke*n_var_coke*sin(Modelica.Constants.pi/n_var_coke));

    ash_load = properties.xi[1]*properties.d;
    k_ash = Q_m_abs_ash*3*Modelica.Constants.pi/(2*d_ash*diameter_mean_ash*n_var_ash*sin(Modelica.Constants.pi/n_var_ash));

    emissivity_S_1 = (1 - exp(-(0*(properties.p_i[3] + properties.p_i[8])/1e5 + 3460*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));
    emissivity_S_2 = (1 - exp(-(0.824*(properties.p_i[3] + properties.p_i[8])/1e5 + 960*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));
    emissivity_S_3 = (1 - exp(-(25.91*(properties.p_i[3] + properties.p_i[8])/1e5 + 960*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));

    emissivity_source = a1_source*emissivity_S_1 + a2_source*emissivity_S_2 + a3_source*emissivity_S_3;

    absorbance_source = a1_sink*emissivity_S_1 + a2_sink*emissivity_S_2 + a3_sink*emissivity_S_3;

    emissivity_sink = a1_sink*emissivity_S_1 + a2_sink*emissivity_S_2 + a3_sink*emissivity_S_3;

    heat.Q_flow = smooth*(geo.A_front*view_factor*Modelica.Constants.sigma*(emissivity_S_1*emissivity_source/(1 - (1 - emissivity_source)*(1 - emissivity_S_1))*(a1_source*T_source^4 - a1_sink*T_sink^4) + emissivity_S_2*emissivity_source/(1 - (1 - emissivity_source)*(1 - emissivity_S_2))*(a2_source*T_source^4 - a2_sink*T_sink^4) + emissivity_S_3*emissivity_source/(1 - (1 - emissivity_source)*(1 - emissivity_S_3))*(a3_source*T_source^4 - a3_sink*T_sink^4))) + (1 - smooth)*(-geo.A_front*view_factor*Modelica.Constants.sigma*(emissivity_S_1*emissivity_source/(1 - (1 - emissivity_source)*(1 - emissivity_S_1))*(a1_source*T_source^4 - a1_sink*T_sink^4) + emissivity_S_2*emissivity_source/(1 - (1 - emissivity_source)*(1 - emissivity_S_2))*(a2_source*T_source^4 - a2_sink*T_sink^4) + emissivity_S_3*emissivity_source/(1 - (1 - emissivity_source)*(1 - emissivity_S_3))*(a3_source*T_source^4 - a3_sink*T_sink^4)));

  else
    emissivity_source = emissivity_source_fixed;
    emissivity_H2O_CO2_source = 0.0;
    absorbance_source = absorbance_source_fixed;
    absorbance_H2O_CO2_source = 0.0;
    emissivity_sink = emissivity_sink_fixed;
    emissivity_H2O_CO2_sink = 0.0;

    a1_source = 0;
    a2_source = 0;
    a3_source = 0;
    emissivity_S_1 = 0;
    emissivity_S_2 = 0;
    emissivity_S_3 = 0;
    a1_sink = 0;
    a2_sink = 0;
    a3_sink = 0;
    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    heat.Q_flow = smooth*(geo.A_front*view_factor*Modelica.Constants.sigma*emissivity_sink/(absorbance_source + emissivity_sink - absorbance_source*emissivity_sink)*(emissivity_source*T_source^4 - absorbance_source*T_sink^4)) + (1 - smooth)*(geo.A_front*view_factor*Modelica.Constants.sigma*emissivity_sink/(absorbance_source + emissivity_sink - absorbance_source*emissivity_sink)*(emissivity_source*T_source^4 - absorbance_source*T_sink^4));
  end if;

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for radiant heat transfer between gas volume surfaces inside furnaces</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Emissivity and Absorbance of flue gas can be calculated</li>
<li>Emissivity of particles is regarded as constant value</li>
<li>Configuration factors are regarded (radiating gas volumes are treated as radiating surfaces)</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10. bearbeitete und erweiterte Auflage, 2006, chapters Kb and Kc</li>
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
end Radiation_gas2Gas_advanced_L2;
