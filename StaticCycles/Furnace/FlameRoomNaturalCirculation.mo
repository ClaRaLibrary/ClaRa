within ClaRa.StaticCycles.Furnace;
model FlameRoomNaturalCirculation " Natural circulation heating surfaces with drum || blue | green"
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
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of m_flow and h are unknown and provided BY neighbor component.
  // Green output: Values of p, m_flow and h are known in component and provided FOR neighbor component.
  // Brown input:   Value of xi is known in component and provided FOR neighbor component, values of p, T and m_flow are unknown and provided BY neighbor component.
  // Brown output:  Value of p, T and m_flow are known in component and provided FOR neighbor component, value of xi is unknown and provided BY neighbor component.
  // Blue output:  Value of h and m_flow are known in component and provided FOR neighbor component, values of p is unknown and provided BY neighbor component.

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;
  import Modelica.Constants.eps;

  outer ClaRa.SimCenter simCenter;
  outer parameter Real P_target_ "Target power in p.u.";

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid vleMedium = simCenter.fluid1 "vleMedium in the component" annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component" annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length z_drum_down=0.0 "Geodetic height at drum downcomer inlet" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_drum_rise=0.0 "Geodetic height at drum riser outlet" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_evap_in=0.0 "Geodetic height at evaporator inlet" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_evap_out=0.0 "Geodetic height at evaporator outlet" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Pressure p_drum_nom "Nominal pressure of drum" annotation (Dialog(group="Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_vle_wall_nom "Heated fluid pressure loss at nominal load inside casing walls" annotation (Dialog(group="Nominal Operation Point"));
  parameter Real N_circ "Circulation number" annotation(Dialog(group="Nominal Operation Point"));

  parameter Real Pi_Q_flow=3 "Heat flow ratio between tube bundle and casing walls"
                                                                                   annotation(Dialog(group="Nominal Operation Point"));
  parameter Real CharLine_Delta_p_wall_P_target_[:,:]=[0, 0; 0.1, 0.01; 0.3, 0.09; 0.5, 0.25; 0.7, 0.49; 1, 1] "Characteristic line of pressure drop as function of P_target_" annotation(Dialog(group="Part Load Definition"));

// _________GENERAL VALUES ___________
  final parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_bundle=m_flow_vle_bundle*(h_vle_bundle_out - h_vle_bundle_in) "Actual heat flow rate of natural circulation";
  final parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_wall=Q_flow_bundle/Pi_Q_flow "Actual heat flow rate to evaporator";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_bub_bundle=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(vleMedium, p_vle_bundle_out) "Rprt: Bubble enthalpy at vle outlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_dew_bundle=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.dewSpecificEnthalpy_pxi(vleMedium, p_vle_bundle_out) "Rprt: Dew enthalpy at vle outlet";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_bub_wall=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(vleMedium, p_vle_wall_out);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_dew_wall=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.dewSpecificEnthalpy_pxi(vleMedium, p_vle_wall_out);

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_bundle(fixed=false) "Mass flow rate at tube bundle";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall(fixed=false) "Mass flow rate at wall HEX";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg(fixed=false) "Mass flow rate flue gas";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_vle_wall(fixed=false) "Pressure loss at wall HEX";

  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_U_bundle=ClaRa.Basics.Functions.maxAbs(
      T_fg_in - T_vle_bundle_out,
      T_fg_out - T_vle_bundle_in,
      0.1) "Rprt: Upper temperatre difference of tube bundle";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_L_bundle=ClaRa.Basics.Functions.minAbs(
      T_fg_in - T_vle_bundle_out,
      T_fg_out - T_vle_bundle_in,
      0.1) "Rprt: Lower temperature difference of tube bundle";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_mean_bundle=SM(
      0.1,
      eps,
      abs(Delta_T_L_bundle))*SM(
      0.01,
      eps,
      Delta_T_U_bundle*Delta_T_L_bundle)*SZT(
      (Delta_T_U_bundle - Delta_T_L_bundle)/log(abs(Delta_T_U_bundle)/(abs(Delta_T_L_bundle) + 1e-9)),
      Delta_T_L_bundle,
      (abs(Delta_T_U_bundle) - abs(Delta_T_L_bundle)) - 0.01,
      0.001) "Rprt: Logarithmic temperature difference of tube bundle";
  final parameter Real kA_bundle = Q_flow_bundle/(1e-5+Delta_T_mean_bundle) "Rprt: Heat Flow Resistance of tube bundle";

  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_U_wall=ClaRa.Basics.Functions.maxAbs(
      T_fg_in - T_vle_wall_out,
      T_fg_out - T_vle_wall_in,
      0.1) "Rprt: Upper temperatre difference";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_L_wall=ClaRa.Basics.Functions.minAbs(
      T_fg_in - T_vle_wall_out,
      T_fg_out - T_vle_wall_in,
      0.1) "Rprt: Lower temperature difference";
  final parameter ClaRa.Basics.Units.TemperatureDifference Delta_T_mean_wall=SM(
      0.1,
      eps,
      abs(Delta_T_L_wall))*SM(
      0.01,
      eps,
      Delta_T_U_wall*Delta_T_L_wall)*SZT(
      (Delta_T_U_wall - Delta_T_L_wall)/log(abs(Delta_T_U_wall)/(abs(Delta_T_L_wall) + 1e-9)),
      Delta_T_L_wall,
      (abs(Delta_T_U_wall) - abs(Delta_T_L_wall)) - 0.01,
      0.001) "Rprt: Logarithmic temperature difference";
  final parameter Real kA_wall = Q_flow_wall/(1e-5+Delta_T_mean_wall) "Rprt: Heat Flow Resistance of wall";
  // _________VLE Tube Bundle Inlet _________________

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_bundle_in(fixed=false) "Spec.enthalpy at tube bundle inlet";
  final parameter ClaRa.Basics.Units.Pressure p_vle_bundle_in=p_drum_nom*P_target_ "Pressure at tube bundle inlet";
  final parameter ClaRa.Basics.Units.Temperature T_vle_bundle_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_vle_bundle_in) "Rprt: tube bundle inlet temperature";

// _________DRUM AND EVAP states ______
  final parameter Real steamQuality_out=1/N_circ "Outlet steam quality evaporator";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_evap_in=h_bub_bundle "Inlet enthalpy evaporator";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_evap_out=steamQuality_out*(h_dew_bundle - h_bub_bundle) + h_bub_bundle "Outlet enthalpy evaporator";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_evap=N_circ*m_flow_vle_bundle "Mass flow rate evaporator";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_geo_down=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_evap_in,
      xi)*Modelica.Constants.g_n*(z_drum_down - z_evap_in) "Geostatic pressure difference downcomer";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_geo_rise=(TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_evap_in,
      xi) + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_evap_out,
      xi))/2*Modelica.Constants.g_n*(z_evap_out - z_evap_in) + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_evap_out,
      xi)*Modelica.Constants.g_n*(z_drum_rise - z_evap_out) "Geostatic pressure difference riser";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_fric=Delta_p_geo_down - Delta_p_geo_rise "Friction losses in evaporator";

  final parameter ClaRa.Basics.Units.Pressure p_evap_in=p_vle_bundle_in + Delta_p_geo_down - Delta_p_fric/3 "Inlet pressure evaporator";
  final parameter ClaRa.Basics.Units.Pressure p_evap_out=p_vle_bundle_in + Delta_p_geo_down - (TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_evap_in,
      xi) + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_evap_out,
      xi))/2*Modelica.Constants.g_n*(z_evap_out - z_evap_in) - Delta_p_fric/2 "Outlet pressure evaporator";

// _________VLE Tube Bundle Outlet ________________
  final parameter ClaRa.Basics.Units.Pressure p_vle_bundle_out=p_vle_bundle_in "Pressure at bundle outlet";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_bundle_out=h_dew_bundle " Spec. enthalpy saturated steam at drum outlet";
  final parameter ClaRa.Basics.Units.Temperature T_vle_bundle_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_bundle_out,
      h_vle_bundle_out) "Rprt: tube bundle outlet temperature";

    // _________VLE Wall Inlet _________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_in(fixed=false) "Wall inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_vle_wall_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_bundle_in,
      h_vle_bundle_in) "Rprt: wall inlet temperature";
  final parameter ClaRa.Basics.Units.Pressure p_vle_wall_in=p_vle_wall_out + Delta_p_vle_wall " Wall inlet pressure";
//   final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall(fixed=false) "Wall HEX mass flow";

// _________VLE Wall Outlet ________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_out=Q_flow_wall/m_flow_vle_wall + h_vle_wall_in "Wall outlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_vle_wall_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_bundle_out,
      h_vle_bundle_out) "Wall outlet temperature";
  final parameter ClaRa.Basics.Units.Pressure p_vle_wall_out(fixed=false) "Wall outlet pressure";
//   final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall_out=m_flow_vle_wall "Wall inlet mass flow";

// _________GAS Inlet _________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_in=(m_flow_fg*h_fg_out - m_flow_vle_bundle*h_vle_bundle_in + m_flow_vle_bundle*h_vle_bundle_out - m_flow_vle_wall*h_vle_wall_in + m_flow_vle_wall*h_vle_wall_out)/m_flow_fg "FG medium's inlet specific enthalpy flue gas";
  final parameter ClaRa.Basics.Units.Temperature T_fg_in=TILMedia.GasFunctions.temperature_phxi(
      flueGas,
      p_fg_in,
      h_fg_in,
      xi_fg_in) "Inlet temperature flue gas";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_in[inletGas.flueGas.nc - 1](each fixed=false) "FG medium's inlet composition";
  final parameter ClaRa.Basics.Units.Pressure p_fg_in=p_fg_out "FG medium's inlet pressure";

// _________GAS Outlet ________________
  final parameter ClaRa.Basics.Units.Temperature T_fg_out(fixed=false) "Outlet specific enthalpy flue gas";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_out=TILMedia.GasFunctions.specificEnthalpy_pTxi(
      flueGas,
      p_fg_out,
      T_fg_out,
      xi_fg_out) " FG medium's outlet specific enthalpy";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_out[outletGas.flueGas.nc - 1]=xi_fg_in "FG medium's outlet composition";
  final parameter ClaRa.Basics.Units.Pressure p_fg_out(fixed=false) "FG medium's outlet pressure";
// ____________________________________
protected
  constant ClaRa.Basics.Units.MassFraction[:] xi=zeros(vleMedium.nc - 1) "VLE composition in component, pure fluids supported only!";
  Modelica.Blocks.Tables.CombiTable1Dv table1(table=CharLine_Delta_p_wall_P_target_, u={P_target_});
public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inletDrum(p=p_vle_bundle_in, Medium=vleMedium) annotation (Placement(transformation(extent={{100,-50},{108,-30}}), iconTransformation(extent={{100,-50},{108,-30}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_b outletDrum(
    m_flow=m_flow_vle_bundle,
    h=h_vle_bundle_out,
    p=p_vle_bundle_out, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={50,104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=180,
        origin={104,40})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_b outletGas(flueGas=flueGas, xi=xi_fg_out) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-70,104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-40,104})));
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_a inletGas(
    flueGas=flueGas,
    m_flow=m_flow_fg,
    p=p_fg_in,
    T=T_fg_in) annotation (Placement(transformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-70,-104}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=90,
        origin={-40,-104})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outletWall(h=h_vle_wall_out, m_flow=m_flow_vle_wall, Medium=vleMedium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={100,60}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=0,
        origin={104,80})));
public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inletWall(p=p_vle_wall_in, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,-70}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=0,
        origin={104,-80})));
initial equation
  Delta_p_vle_wall = Delta_p_vle_wall_nom*table1.y[1];

  m_flow_vle_bundle =inletDrum.m_flow;
  h_vle_bundle_in =inletDrum.h;

  h_vle_wall_in=inletWall.h;
  m_flow_vle_wall=inletWall.m_flow;
  p_vle_wall_out=outletWall.p;

  m_flow_fg = outletGas.m_flow;
  T_fg_out = outletGas.T;
  p_fg_out = outletGas.p;

  xi_fg_in = inletGas.xi;
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
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=true,
        initialScale=0.1),
                   graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor=DynamicSelect({118,106,98}, if Delta_T_L_wall*Delta_T_U_wall >= 0 or Delta_T_L_bundle*Delta_T_U_bundle >= 0 then {118,106,98} else {234,171,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_T_L_wall*Delta_T_U_wall >=0 or Delta_T_L_bundle*Delta_T_U_bundle >=0 then FillPattern.Solid else FillPattern.Backward)),
        Line(points={{100,-40},{60,-40},{0,20},{0,68},{32,68},{60,40},{100,40}},
                                                       color={0,131,169}),
        Line(points={{0,20},{0,-60},{-60,-60},{-60,68},{-48,68},{0,20}},              color={0,131,169}),
        Ellipse(
          extent={{-40,56},{40,-24}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,20},{40,20}},color={0,131,169}),
        Line(points={{-22,32},{-15,20},{-8,32},{-22,32}},
                                                       color={0,131,169}),
        Line(
          points={{100,80},{-80,80},{-80,-80},{100,-80}},
          color=DynamicSelect({0,131,169}, if h_vle_wall_out - h_dew_wall > 10 then {167,25,48} elseif h_vle_wall_out - h_bub_wall > -10 then {115,150,0} else {0,131,069}),
          smooth=Smooth.None)}), Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
        initialScale=0.1)));
end FlameRoomNaturalCirculation;
