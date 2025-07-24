within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model ConvectionAndRadiation_tubeBank_L2 "Shell Geo || L2 || Convection And Radiation Inside Tube Banks"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.HeatTransfer_L2;
//  outer ClaRa.Basics.Records.IComGas_L2 iCom;
  extends ClaRa.Basics.Icons.AlphaEpsilon;
  import SM = ClaRa.Basics.Functions.Stepsmoother;

  //Equations according to Effenberger/VDI-Waermeatlas

  parameter String suspension_calculationType="Fixed" "Calculation type" annotation (Dialog(group="Emissivity and absorbance factor calculation of the suspension volume"), choices(
      choice="Fixed" "Use fixed value for gas emissivity",
      choice="Calculated" "Calculate suspension emissivity according to VDI Waermeatlas",
      choice="Gas calculated, particles fixed" "Gas emissivity calculated, particle emissivity fixed"));

  parameter Real emissivity_suspension_fixed=0.9 "Fixed value for gas emissivity" annotation (Dialog(enable=(suspension_calculationType == "Fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter Real absorbance_suspension_fixed=0.9 "Fixed value for gas absorbance" annotation (Dialog(enable=(suspension_calculationType == "Fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

    parameter Real emissivity_particle=0.2 "Value considering dust particles if emissivity and absorbance are calculated"
                                                                                      annotation (Dialog(enable=(suspension_calculationType == "Gas calculated, particles fixed"), group="Emissivity and absorbance factor calculation of the suspension volume"));

  parameter Real emissivity_tubes=0.8 "Emissivity of the tubes" annotation (Dialog(group="Emissivity and absorbance factor calculation of the suspension volume"));

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

  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));


public
  ClaRa.Basics.Units.Velocity w "Flue gas velocity";
  ClaRa.Basics.Units.HeatFlowRate Q_flow_rad "Radiative heat flow";
  ClaRa.Basics.Units.HeatFlowRate Q_flow_conv "Convective heat flow";
  Real emissivity_suspension "Emissivity";
  Real absorbance_suspension "Absorbance";
  Real alpha "Convective heat transfer coefficient";
  Real s_gl "Equivalent thickness";
  Real Nu_llam "Nusselt number laminar";
  Real Nu_lturb "Nusselt number turbulent";
  Real Nu_l0 "Nusselt number";
  Real Nu_tubeBank "Nusselt number at tube bank";

  Units.Temperature T_mean_rad "Mean temperature for radiation";

protected
  Real Re_psi1 "Corrected Reynolds number";
  Real f_a "Arrangement factor";
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

  final parameter ClaRa.Basics.Units.Length length_char=Modelica.Constants.pi/2*geo.diameter_t "Characteristic length";
  ClaRa.Basics.Units.Temperature T_prop_am "Arithmetic mean for calculation of substance properties";

  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1] "Mean flue gas composition";
  outer ClaRa.Basics.Units.MassFraction xi_fuel "Mean fuel composition";
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes geo;

  TILMedia.Gas.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=T_prop_am,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Real x1;
    Real x2;
equation
  //Radiative Heat Transfer
  T_prop_am = (iCom.T_out + iCom.T_in)/2;
  T_mean_rad = (iCom.T_out + iCom.T_in)/2;
  xi_mean = iCom.xi_bulk;

  s_gl = 3.6*geo.volume/geo.A_heat_CF[heatSurfaceAlloc];

     a1_T_gas = 0.13 + 0.265*(T_mean_rad/1000);
     a2_T_gas = 0.595 - 0.15*(T_mean_rad/1000);
     a3_T_gas = 0.275 - 0.115*(T_mean_rad/1000);

     a1_T_wall = 0.13 + 0.265*(heat.T/1000);
     a2_T_wall = 0.595 - 0.15*(heat.T/1000);
     a3_T_wall = 0.275 - 0.115*(heat.T/1000);

  //________________________/ Calculation of gas emissivity and absorbance \_____________________
  if suspension_calculationType == "Fixed" then
    emissivity_suspension = emissivity_suspension_fixed;
    emissivity_H2O_CO2 = 0.0;
    absorbance_suspension = absorbance_suspension_fixed;
    absorbance_H2O_CO2 = 0.0;
    emissivity_S_1 = 0;
    emissivity_S_2 = 0;
    emissivity_S_3 = 0;
    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

  elseif suspension_calculationType == "Gas calculated, particles fixed" then

    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

    emissivity_S_1 = (1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));
    emissivity_S_2 = (1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));
    emissivity_S_3 = (1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    emissivity_H2O_CO2 = a1_T_gas*emissivity_S_1 + a2_T_gas*emissivity_S_2 + a3_T_gas*emissivity_S_3;
    absorbance_H2O_CO2 = a1_T_wall*emissivity_S_1 + a2_T_wall*emissivity_S_2 + a3_T_wall*emissivity_S_3;

    emissivity_suspension = emissivity_H2O_CO2 + emissivity_particle - emissivity_H2O_CO2*emissivity_particle;
    absorbance_suspension = absorbance_H2O_CO2 + emissivity_particle - absorbance_H2O_CO2*emissivity_particle;

  elseif suspension_calculationType == "Calculated" then

    emissivity_H2O_CO2 = a1_T_gas*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_T_gas*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_T_gas*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));
    absorbance_H2O_CO2 = a1_T_wall*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_T_wall*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_T_wall*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

    soot_load = soot_load_n*(273.15/T_mean_rad);

    coke_load = x_coke*xi_fuel*properties.d;
    k_coke = Q_mean_abs_coke*3*Modelica.Constants.pi/(2*d_coke*diameter_mean_coke*n_var_coke*sin(Modelica.Constants.pi/n_var_coke));

    ash_load = properties.xi[1]*properties.d;
    k_ash = Q_mean_abs_ash*3*Modelica.Constants.pi/(2*d_ash*diameter_mean_ash*n_var_ash*sin(Modelica.Constants.pi/n_var_ash));

    emissivity_S_1 = (1 - exp(-(0*(properties.p_i[3] + properties.p_i[8])/1e5 + 3460*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));
    emissivity_S_2 = (1 - exp(-(0.824*(properties.p_i[3] + properties.p_i[8])/1e5 + 960*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));
    emissivity_S_3 = (1 - exp(-(25.91*(properties.p_i[3] + properties.p_i[8])/1e5 + 960*soot_load + k_coke*coke_load + k_ash*ash_load)*s_gl));

    emissivity_suspension = a1_T_gas*emissivity_S_1 + a2_T_gas*emissivity_S_2 + a3_T_gas*emissivity_S_3;
    absorbance_suspension = a1_T_wall*emissivity_S_1 + a2_T_wall*emissivity_S_2 + a3_T_wall*emissivity_S_3;

    //emissivity_suspension = a1_epsilon*(1 - exp(0*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a2_epsilon*(1 - exp(-0.824*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl)) + a3_epsilon*(1 - exp(-25.91*(properties.p_i[3] + properties.p_i[8])/1e5*s_gl));

  else

    emissivity_suspension = emissivity_suspension_fixed;
    emissivity_H2O_CO2 = 0.0;
    absorbance_suspension = absorbance_suspension_fixed;
    absorbance_H2O_CO2 = 0.0;
    emissivity_S_1 = 0;
    emissivity_S_2 = 0;
    emissivity_S_3 = 0;
    k_coke = 0;
    k_ash = 0;
    coke_load = 0;
    ash_load = 0;
    soot_load = 0;

  end if;

    Q_flow_rad = geo.A_heat_CF[heatSurfaceAlloc]*CF_fouling*Modelica.Constants.sigma*emissivity_tubes/(absorbance_suspension + emissivity_tubes - absorbance_suspension*emissivity_tubes)*(absorbance_suspension*heat.T^4 - emissivity_suspension*T_mean_rad^4);

   //Convective Heat Transfer

  x1 = SM(0.01,0,iCom.V_flow_in);
  x2 = SM(0,0.01,-iCom.V_flow_out);
  w = (x1*iCom.V_flow_in/geo.A_front + x2*iCom.V_flow_out/geo.A_front)/max((x1)+(x2),1);

  //A_fr used because undisturbed velocity at inlet is needed
  Re_psi1 = max(eps,properties.d*w*length_char/(geo.psi*properties.transp.eta));

  Nu_llam = 0.664*sqrt(Re_psi1)*(properties.transp.Pr)^(1/3);
  Nu_lturb = (0.037*(Re_psi1)^(0.8)*properties.transp.Pr)/(1 + 2.443*(Re_psi1)^(-0.1)*(properties.transp.Pr^(2/3) - 1));
  Nu_l0 = 0.3 + sqrt(Nu_llam^2 + Nu_lturb^2);

  if geo.staggeredAlignment == false then
    f_a = 1 + 0.7/(geo.psi)^(1.5)*(geo.b/geo.a - 0.3)/(geo.b/geo.a + 0.7)^2;
  else
    f_a = 1 + 2/(3*geo.b);
  end if;

  if geo.N_rows < 10 then
    Nu_tubeBank = (1 + (geo.N_rows - 1)*f_a)/(geo.N_rows)*Nu_l0;
  else
    Nu_tubeBank = f_a*Nu_l0;
  end if;

  alpha = Nu_tubeBank*properties.transp.lambda/length_char*CF_fouling;

  Q_flow_conv = geo.A_heat_CF[heatSurfaceAlloc]*alpha*Delta_T_mean;

  heat.Q_flow = Q_flow_rad + Q_flow_conv;

                                                            annotation (Dialog(group="Heat Transfer"),
              Documentation(info="<html>
<p><b>Model description: </b>A correlation for radiant and convective heat transfer inside tube banks</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Aligned, staggered or partly staggered tubes supported</li>
<li>Emissivity and Absorbance of flue gas can be calculated</li>
<li>Emissivity of particles can is regarded as constant value</li>
<li>Needs geometry model for tube banks</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Kc and Gg</li>
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
end ConvectionAndRadiation_tubeBank_L2;
