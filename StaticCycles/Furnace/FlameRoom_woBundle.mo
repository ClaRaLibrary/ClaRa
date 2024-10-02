within ClaRa.StaticCycles.Furnace;
model FlameRoom_woBundle "Fixed fluid outlet temperature | blue | blue || brown | brown"
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
  // Blue input:   Value of p is known in component and provided FOR neighbor component, values of h and m_flow are unknown and provided BY neighbor component.
  // Blue output:  Value of h and m_flow are known in component and provided FOR neighbor component, values of p is unknown and provided BY neighbor component.
  // Brown input:   Value of xi is known in component and provided FOR neighbor component, values of p, T and m_flow are unknown and provided BY neighbor component.
  // Brown output:  Value of p, T and m_flow are known in component and provided FOR neighbor component, value of xi is unknown and provided BY neighbor component.

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;
  import Modelica.Constants.eps;

  outer ClaRa.SimCenter simCenter;
  outer parameter Real P_target_ "Target power in p.u." annotation(Dialog(group="Part Load Definition"));

  //---------Summary Definition---------
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet_wall;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet_wall;
    ClaRa.Basics.Records.StaCyFlangeGas inlet_fg;
    ClaRa.Basics.Records.StaCyFlangeGas outlet_fg;
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
     m_flow=m_flow_fg,
     T=T_fg_in,
     p=p_fg_in,
     xi=xi_fg_in),
  outlet_fg(
     mediumModel=flueGas,
     m_flow=m_flow_fg,
     T=T_fg_out,
     p=p_fg_out,
     xi=xi_fg_out));

  //---------Summary Definition---------

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid vleMedium = simCenter.fluid1 "vleMedium in the component" annotation(Dialog(group="Fundamental Definitions"));
  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component" annotation(Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_out_nom "Nominal vle wall outlet spec. enthalpy" annotation (Dialog(group="Nominal Operation Point"));

  parameter ClaRa.Basics.Units.Pressure Delta_p_vle_wall_nom "Heated fluid pressure loss at nominal load inside casing walls" annotation (Dialog(group="Nominal Operation Point"));
  parameter ClaRa.Basics.Units.Length z_wall_in=0.0 "Geodetic height at inlet" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length z_wall_out=0.0 "Geodetic height at outlet" annotation (Dialog(group="Fundamental Definitions"));

  parameter Real CharLine_Delta_p_P_target_[:,:]=[0, 0; 0.1, 0.01; 0.3, 0.09; 0.5, 0.25; 0.7, 0.49; 1, 1] "Characteristic line of pressure drop as function of P_target_" annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_h_wall_P_target_[:,2]=[0,1;1,1] "Characteristic line of h_vle_wall_out as function of P_target_" annotation(Dialog(group="Part Load Definition"));

  parameter ClaRa.Basics.Units.Length Delta_x_wall[:]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      10,
      3) "Discretisation scheme - tube bundle side" annotation (Dialog(group="Discretisation (for reporting only)"));
  parameter Boolean frictionAtInlet_wall = false "True if pressure loss between first cell and inlet shall be considered - tube bundle side"
                                                                                              annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));
  parameter Boolean frictionAtOutlet_wall = false "True if pressure loss between last cell and outlet shall be considered - tube bundle side"
                                                                                                                                             annotation(Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false));

// _________GENERAL VALUES ___________
  final parameter Integer N_cv_wall = size(Delta_x_wall,1) "Number of finite volumes in wall";
  final parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_wall=m_flow_vle_wall_in*(h_vle_wall_out - h_vle_wall_in) "Actual heat flow rate to evaporator";

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_bub_wall=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(vleMedium, p_vle_wall_out);
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_dew_wall=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.dewSpecificEnthalpy_pxi(vleMedium, p_vle_wall_out);

  final parameter ClaRa.Basics.Units.Pressure Delta_p_vle_wall(fixed=false) "Pressure losses vle medium";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg(fixed=false) "Mass flow rate flue gas";

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
  final parameter Real kA_wall = Q_flow_wall /(1e-5 + Delta_T_mean_wall) "Rprt: Heat Flow Resistance";

//  final parameter ClaRa.Basics.Units.Pressure p_bundle[N_cv_bundle] = ClaRa.Basics.Functions.pressureInterpolation(p_vle_bundle_in, p_vle_bundle_out, Delta_x_bundle, frictionAtInlet_bundle, frictionAtOutlet_bundle) "Rprt: Discretisised pressure at tube bundle";
  final parameter ClaRa.Basics.Units.Pressure p_wall[N_cv_wall]=ClaRa.Basics.Functions.pressureInterpolation(
      p_vle_wall_in,
      p_vle_wall_out,
      Delta_x_wall,
      frictionAtInlet_wall,
      frictionAtOutlet_wall) "Rprt: Discretisised pressure at tube bundle";

  constant ClaRa.Basics.Units.MassFraction[:] xi=zeros(vleMedium.nc - 1) "VLE composition in component, pure fluids supported only!";
  final parameter ClaRa.Basics.Units.Pressure Delta_p_geo_wall=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      vleMedium,
      p_vle_wall_out,
      h_vle_wall_out,
      xi)*Modelica.Constants.g_n*(z_wall_out - z_wall_in) "Geostatic pressure difference";

  // _________VLE Evaporator Inlet _________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_in(fixed=false) "VLE medium's inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_vle_wall_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_wall_in,
      h_vle_wall_in) "Rprt: VLE medium's inlet temperature";
  final parameter ClaRa.Basics.Units.Pressure p_vle_wall_in=p_vle_wall_out + Delta_p_vle_wall + Delta_p_geo_wall " VLE medium's inlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall_in(fixed=false) "VLE medium's inlet mass flow";

// _________VLE Evaporator Outlet ________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_vle_wall_out(fixed=false) "Outlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_vle_wall_out=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi(
      vleMedium,
      p_vle_wall_out,
      h_vle_wall_out) "VLE  medium's outlet temperature";
  final parameter ClaRa.Basics.Units.Pressure p_vle_wall_out(fixed=false) "VLE  medium's outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_vle_wall_out=m_flow_vle_wall_in "VLE medium's inlet mass flow";

// _________GAS Inlet _________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_in=(m_flow_fg*h_fg_out - m_flow_vle_wall_in*h_vle_wall_in + m_flow_vle_wall_in*h_vle_wall_out)/m_flow_fg "FG medium's inlet specific enthalpy flue gas";
  final parameter ClaRa.Basics.Units.Temperature T_fg_in=TILMedia.GasFunctions.temperature_phxi(
      flueGas,
      p_fg_in,
      h_fg_in,
      xi_fg_in) "FG inlet temperature";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_in[inletGas.flueGas.nc - 1](each fixed=false) "FG medium's inlet composition";
  final parameter ClaRa.Basics.Units.Pressure p_fg_in=p_fg_out "FG medium's inlet pressure";

// _________GAS Outlet ________________
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_fg_out=TILMedia.GasFunctions.specificEnthalpy_pTxi(
      flueGas,
      p_fg_out,
      T_fg_out,
      xi_fg_out) " FG medium's outlet specific enthalpy";
  final parameter ClaRa.Basics.Units.Temperature T_fg_out(fixed=false) "FG medium's outlet temperature";
  final parameter ClaRa.Basics.Units.MassFraction xi_fg_out[outletGas.flueGas.nc - 1]=xi_fg_in "FG medium's outlet composition";
  final parameter ClaRa.Basics.Units.Pressure p_fg_out(fixed=false) "FG medium's outlet pressure";

 // ________WALL Temperature __________________

  final parameter ClaRa.Basics.Units.Temperature T_wall_wall=((T_fg_out + T_fg_in)/2 + (T_vle_wall_in + T_vle_wall_out)/2)/2 "Wall temperature of wall tubes";
 // ___________________________________________
protected
  Modelica.Blocks.Tables.CombiTable1Dv table1(table=CharLine_Delta_p_P_target_, u={P_target_});
  Modelica.Blocks.Tables.CombiTable1Dv table3(table=CharLine_h_wall_P_target_, u={P_target_});

public
  ClaRa.StaticCycles.Fundamentals.FlueGasSignal_brown_b outletGas(flueGas=flueGas, xi=xi_fg_out) annotation (Placement(transformation(
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
        origin={-40,-104})));

public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_a inletWall(p=p_vle_wall_in, Medium=vleMedium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,-70}), iconTransformation(
        extent={{-4,-10},{4,10}},
        rotation=0,
        origin={104,-60})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outletWall(h=h_vle_wall_out, m_flow=m_flow_vle_wall_out, Medium=vleMedium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={100,60}), iconTransformation(
        extent={{4,-10},{-4,10}},
        rotation=0,
        origin={104,60})));
initial equation
  Delta_p_vle_wall = Delta_p_vle_wall_nom*table1.y[1];
  h_vle_wall_out=h_vle_wall_out_nom*table3.y[1];

  h_vle_wall_in=inletWall.h;
  m_flow_vle_wall_in=inletWall.m_flow;
  p_vle_wall_out=outletWall.p;

  m_flow_fg = outletGas.m_flow;
  T_fg_out = outletGas.T;
  p_fg_out = outletGas.p;

  xi_fg_in = inletGas.xi;

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
</html>"),Dialog(group="Nominal Operation Point"),                                                       Dialog(group="Discretisation (for reporting only)"), choices(checkBox=false),
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),                                                                               Icon(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor=DynamicSelect({118,106,98}, if Delta_T_L_wall*Delta_T_U_wall >= 0 or Delta_T_L_bundle*Delta_T_U_bundle >= 0 then {118,106,98} else {234,171,0}),
          fillColor={255,255,255},
          fillPattern=DynamicSelect(FillPattern.Solid, if Delta_T_L_bundle*Delta_T_U_bundle >= 0 or Delta_T_L_bundle*Delta_T_U_bundle >= 0 then FillPattern.Solid else FillPattern.Backward)),
        Line(
          points={{100,60},{80,60},{80,80},{-80,80},{-80,-80},{80,-80},{80,-60},{100,-60}},
          color=DynamicSelect({0,131,169}, if h_vle_wall_out - h_dew_wall > 10 then {167,25,48} elseif h_vle_wall_out - h_bub_wall > -10 then {115,150,0} else {0,131,069}),
          smooth=Smooth.None),
        Text(
          extent={{-80,80},{80,18}},
          lineColor={0,131,169},
          textString="%name")}));
end FlameRoom_woBundle;
