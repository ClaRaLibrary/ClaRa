within ClaRa.StaticCycles.Furnace;
model Burner1
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
  // Red input:   Value of p and m_flow are known in component and provided FOR neighbor component, value of h is unknown and provided BY neighbor component.
  // Red output:   Value of h is known in component and provided FOR neighbor component, value of p and m_flow are unknown and provided BY neighbor component.
  // Brown input:   Value of xi is known in component and provided FOR neighbor component, values of p, T and m_flow are unknown and provided BY neighbor component.
  // Brown output:  Value of p, T and m_flow are known in component and provided FOR neighbor component, value of xi is unknown and provided BY neighbor component.
  // Orange input:   Value of T and xi are known in component and provided FOR neighbor component, values of p and m_flow are unknown and provided BY neighbor component.
  // Black input:   Value of m_flow and xi are known in component and provided FOR neighbor component.

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;
  import ClaRa.Basics.Media.FuelFunctions.massFraction_i_xi;
  import ClaRa.Basics.Media.FuelFunctions.LHV_pTxi;
  import Modelica.Constants.eps;

  outer ClaRa.SimCenter simCenter;

  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_wall;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_wall;
    ClaRa.Basics.Records.StaCyFlangeGas inlet_fg;
    ClaRa.Basics.Records.StaCyFlangeGas outlet_fg;
    ClaRa.Basics.Records.StaCyFlangeGas inlet_pa;
    ClaRa.Basics.Records.StaCyFlangeFuel inlet_fuel;
  end Summary;

  Summary summary(
  inlet_wall(
     m_flow=m_flow_vle_wall_in,
     h=h_vle_wall_in,
     p=p_vle_wall_in),
  outlet_wall(
     m_flow=m_flow_vle_wall_out,
     h=h_vle_wall_out,
     p=p_vle_wall_out),
  inlet_fg(
     mediumModel=flueGas,
     m_flow=m_flow_fg_in,
     T=T_fg_in,
     p=p_fg_out,
     xi=xi_fg_in),
  outlet_fg(
     mediumModel=flueGas,
     m_flow=m_flow_fg_out,
     T=T_fg_out,
     p=p_fg_out,
     xi=xi_fg_out),
  inlet_pa(
     mediumModel=flueGas,
     m_flow=m_flow_pa_in,
     T=T_pa_in,
     p=p_fg_out,
     xi=xi_pa_in),
  inlet_fuel(
     fuelModel=fuelModel,
     m_flow=m_flow_fuel,
     LHV=LHV,
     xi=xi_fuel));

  //---------Summary Definition---------

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid vleMedium = simCenter.fluid1 "Medium in the component" annotation(Dialog(group="Fundamental Definitions"));
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_out_nom "Outlet specific enthalpy of fluid at nominal load" annotation (Dialog(group="Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_vle_wall_nom "Heated fluid pressure loss at nominal load" annotation (Dialog(group="Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Length z_wall_in=0.0 "Geodetic height at inlet" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length z_wall_out=0.0 "Geodetic height at outlet" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length Delta_x_wall[:]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      10,
      3) "Discretisation scheme - tube bundle side" annotation (Dialog(group="Discretisation (for reporting only)"));
  parameter Boolean frictionAtInlet_wall = false "True if pressure loss between first cell and inlet shall be considered - tube bundle side"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));
  parameter Boolean frictionAtOutlet_wall = false "True if pressure loss between last cell and outlet shall be considered - tube bundle side"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));

  outer parameter Real P_target_ "Target power in p.u." annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_Delta_p_P_target_[:,:]=[0, 0; 0.1, 0.01; 0.3, 0.09; 0.5, 0.25; 0.7, 0.49; 1, 1] "Characteristic line of pressure drop as function of P_target_"
                                                                                              annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_h_P_target_[:,2]=[0,1;1,1] "Characteristic line of h_vle_wall_out as function of P_target_" annotation(Dialog(group="Part Load Definition"));
  final parameter ClaRa.Basics.Units.HeatFlowRate Q_flow=m_flow_vle_wall_in*(h_vle_wall_out - h_vle_wall_in);
  final parameter Integer N_cv_wall = size(Delta_x_wall,1) "Number of finite volumes in wall";

  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_U=ClaRa.Basics.Functions.maxAbs(
      T_fg_mix_in - T_vle_wall_out,
      T_fg_out - T_vle_wall_in,
      0.1) "Rprt: Upper temperatre difference";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_L=ClaRa.Basics.Functions.minAbs(
      T_fg_mix_in - T_vle_wall_out,
      T_fg_out - T_vle_wall_in,
      0.1) "Rprt: Lowert temperature difference";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_mean=SM(
      0.1,
      eps,
      abs(Delta_T_L))*SM(
      0.01,
      eps,
      Delta_T_U*Delta_T_L)*SZT(
      (Delta_T_U - Delta_T_L)/log(abs(Delta_T_U)/(abs(Delta_T_L) + 1e-9)),
      Delta_T_L,
      (abs(Delta_T_U) - abs(Delta_T_L)) - 0.01,
      0.001) "Rprt: Logarithmic temperature difference";
  final parameter Real kA = Q_flow /(1e-5+Delta_T_mean) "Rprt: Heat Flow Resistance";
  final parameter ClaRa.Basics.Units.Pressure p_wall[N_cv_wall]=ClaRa.Basics.Functions.pressureInterpolation(
      p_vle_wall_in,
      p_vle_wall_out,
      Delta_x_wall,
      frictionAtInlet_wall,
      frictionAtOutlet_wall) "Rprt: Discretisised pressure at tube bundle";

  final parameter ClaRa.Basics.Units.Temperature T_vle_wall_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_wall_in,
      h_vle_wall_in) "Rprt: VLE medium's inlet temperature";
  final parameter ClaRa.Basics.Units.Temperature T_vle_wall_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_wall_out,
      h_vle_wall_out) "VLE  medium's outlet temperature";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_bub=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(vleMedium, p_vle_wall_out) "Rprt: Bubble enthalpy at vle outlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_dew=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.dewSpecificEnthalpy_pxi(vleMedium, p_vle_wall_out) "Rprt: Dew enthalpy at vle outlet";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_diff=m_flow_vle_wall_in - m_flow_vle_wall_out "Rprt: Mass flow difference";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_in(fixed=false) "Inlet specific enthalpy heated fluid";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall_in(fixed=false) "Inlet mass flow heated fluid";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall_out(fixed=false) "Heated fluid outlet mass flow";
  final parameter ClaRa.Basics.Units.Pressure p_vle_wall_out(fixed=false) "Heated fluid outlet pressure";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_out(fixed=false) "Outlet specific enthalpy";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_out(fixed=false) "Mass flow rate flue gas";
  final parameter ClaRa.Basics.Units.Temperature T_fg_out(fixed=false) "Outlet temperature flue gas";
  final parameter ClaRa.Basics.Units.Pressure p_fg_out(fixed=false) "Outlet pressure flue gas";

  final parameter ClaRa.Basics.Units.Temperature T_fg_in(fixed=false) "Temperature of primary air";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_in(fixed=false) "Mass flow rate primary air";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_in[flueGas.nc - 1](each fixed=false) "Inlet composition flue gas";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel(fixed=false) "Mass flow rate fuel";
  final parameter ClaRa.Basics.Units.MassFraction xi_fuel[fuelModel.N_c - 1](each fixed=false) "Elemental composition of fuel";
  final parameter ClaRa.Basics.Units.MassFraction xi_fuel_e[fuelModel.N_e - 1]={massFraction_i_xi(
      xi_fuel,
      i,
      fuelModel) for i in 1:fuelModel.N_e - 1} "Elemental composition fuel";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific LHV=LHV_pTxi(
      p,
      T,
      xi_fuel,
      fuelModel) "Lower heating value fuel";

  final parameter ClaRa.Basics.Units.Temperature T_pa_in(fixed=false) "Temperature of primary air";
  final parameter ClaRa.Basics.Units.MassFraction xi_pa_in[flueGas.nc - 1](each fixed=false) "Inlet composition primary air";

  final parameter Real n_flow_C_primary= xi_fuel_e[1]*m_flow_fuel/ClaRa.Basics.Constants.M_C "Inlet molar flow rate fuel C";
  final parameter Real n_flow_H_primary= xi_fuel_e[2]*m_flow_fuel/ClaRa.Basics.Constants.M_H "Inlet molar flow rate fuel H";
  final parameter Real n_flow_O_primary= xi_fuel_e[3]*m_flow_fuel/ClaRa.Basics.Constants.M_O "Inlet molar flow rate fuel O";
  final parameter Real n_flow_S_primary= xi_fuel_e[5]*m_flow_fuel/ClaRa.Basics.Constants.M_S "Inlet molar flow rate fuel S";

  final parameter Real m_flow_oxygen_req_primary = (n_flow_C_primary + n_flow_H_primary/4.0 + n_flow_S_primary - n_flow_O_primary/2)*ClaRa.Basics.Constants.M_O *2.0 "Required oxygen for stoichiometric combustion";
  final parameter Real lambda = m_flow_pa_in/m_flow_oxygen_req_primary * max(1e-32,xi_pa_in[6]) "Stoichiometric air ratio";

  final parameter ClaRa.Basics.Units.Pressure Delta_p_vle(fixed=false) "Pressure drop heated fluid";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_mix_in=(h_fg_in*m_flow_fg_in + h_pa_in*m_flow_pa_in)/(m_flow_fg_in + m_flow_pa_in) "Inlet mixed enthalpy flue gas";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_mix_in[flueGas.nc - 1]=(xi_fg_in*m_flow_fg_in + xi_pa_in*m_flow_pa_in)/(m_flow_fg_in + m_flow_pa_in) "Inlet mixed composition flue gas";

  final parameter ClaRa.Basics.Units.Temperature T_fg_mix_in=TILMedia.GasFunctions.temperature_phxi(
      flueGas,
      p_fg_out,
      h_fg_mix_in,
      xi_fg_mix_in) "Inlet mixed temperature flue gas";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_out=TILMedia.GasFunctions.specificEnthalpy_pTxi(
      flueGas,
      p_fg_out,
      T_fg_out,
      xi_fg_in) "Outlet specific enthalpy flue gas";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_in=TILMedia.GasFunctions.specificEnthalpy_pTxi(
      flueGas,
      p_fg_out,
      T_fg_in,
      xi_fg_in) "Inlet specific enthalpy flue gas";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_pa_in=TILMedia.GasFunctions.specificEnthalpy_pTxi(
      flueGas,
      p_fg_out,
      T_pa_in,
      xi_pa_in) "Inlet specific enthalpy primary air";

  constant ClaRa.Basics.Units.MassFraction[:] xi=zeros(vleMedium.nc - 1) "VLE composition in component, pure fluids supported only!";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_geo=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      vleMedium,
      p_vle_wall_out,
      h_vle_wall_out,
      xi)*Modelica.Constants.g_n*(z_wall_out - z_wall_in) "Geostatic pressure difference";

  final parameter ClaRa.Basics.Units.Pressure p_vle_wall_in=p_vle_wall_out + Delta_p_vle + Delta_p_geo "Inlet pressure";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_pa_in=(m_flow_fg_out - m_flow_fuel - m_flow_fg_in) "Inlet mass flow primary air";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_out[flueGas.nc - 1]=ClaRa.Basics.Functions.InitialiseCombustionGas(
      xi_fuel_e,
      m_flow_fuel,
      ((m_flow_fg_in*xi_fg_in) + (m_flow_pa_in*xi_pa_in))/(m_flow_pa_in + m_flow_fg_in),
      (m_flow_pa_in + m_flow_fg_in),
      false) "Outlet composition flue gas";

protected
  Modelica.Blocks.Tables.CombiTable1Dv table1(table=CharLine_Delta_p_P_target_, u={P_target_});
  Modelica.Blocks.Tables.CombiTable1Dv table2(table=CharLine_h_P_target_, u={P_target_});
  constant ClaRa.Basics.Units.Pressure p=1e5;
  constant ClaRa.Basics.Units.Temperature T=273.15;

public
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_b outletGas(flueGas=flueGas, xi=xi_fg_out) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={-40,105}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-40,104})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_purple_a inletGas(flueGas=flueGas, p=p_fg_out) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-40,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-40,-104})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_red_b outletWall(h=h_vle_wall_out, Medium=vleMedium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={100,-70}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=0,
        origin={104,60})));

  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inletWall(p=p_vle_wall_in, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={102,70}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=0,
        origin={104,-60})));

  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_orange_a inletPrimAir(
    flueGas=flueGas,
    p=p_fg_out,
    m_flow=m_flow_pa_in) annotation (Placement(transformation(extent={{-108,-40},{-100,-20}}), iconTransformation(extent={{-108,-40},{-100,-20}})));
  ClaRa.StaticCycles.Fundamentals.FuelSignal_black_a inletFuel(fuelModel=fuelModel) annotation (Placement(transformation(extent={{-108,-10},{-100,10}}), iconTransformation(extent={{-108,-10},{-100,10}})));
initial equation
  Delta_p_vle =  Delta_p_vle_wall_nom*table1.y[1];
  h_vle_wall_out= h_vle_wall_out_nom*table2.y[1];

  outletWall.m_flow=m_flow_vle_wall_out;
  outletWall.p=p_vle_wall_out;

  inletWall.m_flow=m_flow_vle_wall_in;
  inletWall.h=h_vle_wall_in;

  outletGas.m_flow=m_flow_fg_out;
  outletGas.T=T_fg_out;
  outletGas.p=p_fg_out;

  inletGas.m_flow=m_flow_fg_in;
  inletGas.T=T_fg_in;
  inletGas.xi=xi_fg_in;

  inletPrimAir.T=T_pa_in;
  inletPrimAir.xi=xi_pa_in;

  inletFuel.m_flow=m_flow_fuel;
  inletFuel.xi=xi_fuel;

  annotation(Documentation(info="<html>
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
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),Dialog(group="Part Load Definition"),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor=DynamicSelect({118,106,98}, if abs(m_flow_diff) <= 1e-3 then {118,106,98} else {234,171,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if abs(m_flow_diff) <= 1e-3  then FillPattern.Solid else FillPattern.CrossDiag)),
        Line(
          points={{100,60},{80,60},{80,80},{-80,80},{-80,-80},{80,-80},{80,-60},{100,-60}},
          color=DynamicSelect({0,131,169}, if h_vle_wall_out - h_dew > 10 then {167,25,48} elseif h_vle_wall_out - h_bub > -10 then {115,150,0} else {0,131,069}),
          smooth=Smooth.None),
        Line(points={{-60,0},{-100,0}}, color= DynamicSelect({27,36,42}, if m_flow_fuel > 0 then {27,36,42} else {221,222,223})),
        Polygon(
          points={{-10,0},{-10,0},{-50,20},{-70,0},{-50,-20},{-10,0}},
          lineColor=DynamicSelect({118,106,98}, if m_flow_fuel > 0 then {118,106,98} else {221,222,223}),
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-30,0},{-30,0},{-55,10},{-65,0},{-55,-10},{-30,0}},
          lineColor=DynamicSelect({118,106,98}, if m_flow_fuel > 0 then {118,106,98} else {221,222,223}),
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Text(
          extent={{-80,80},{80,18}},
          lineColor={0,131,169},
          textString="%name")}),   Diagram(graphics,
                                           coordinateSystem(preserveAspectRatio=false)));
end Burner1;
