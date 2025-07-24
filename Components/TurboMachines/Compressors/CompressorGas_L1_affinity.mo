within ClaRa.Components.TurboMachines.Compressors;
model CompressorGas_L1_affinity "A gas compressor or fan based on affinity laws"

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
import Modelica.Constants.pi;

  outer ClaRa.SimCenter simCenter;
extends ClaRa.Basics.Icons.Compressor;
parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_th=0,
    powerOut_elMech=0,
    powerAux=P_shaft)  if contributeToCycleSummary;

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.VolumeFlowRate V_flow "Volume flow rate";
    input ClaRa.Basics.Units.Power P_hyd "Hydraulic power";
    input ClaRa.Basics.Units.Power P_shaft "Hydraulic power";
    input Real Pi "Pressure ratio";
    input ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference";
    input ClaRa.Basics.Units.RPM rpm "Rotational speed";
    input Real eta "Hydraulic efficiency";
    input Real eta_mech "Mechanic efficiency";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeGas  inlet;
    ClaRa.Basics.Records.FlangeGas  outlet;
  end Summary;

  inner parameter TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel;

  final parameter Boolean allow_reverseFlow = false;

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium, m_flow(min=if
          allow_reverseFlow then -Modelica.Constants.inf else 1e-5)) "inlet flow"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium, m_flow(max=if
          allow_reverseFlow then Modelica.Constants.inf else -1e-5)) "outlet flow"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft if useMechanicalPort
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

protected
  ClaRa.Components.TurboMachines.Fundamentals.GetInputsRotary getInputsRotary
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,20})));

//  ClaRa.Basics.Units.DensityMassSpecific rho_nom_char = TILMedia.GasObjectFunctions.density_pTxi(p_nom_char,T_nom_char,xi_nom_char,InletNom.gasPointer) "Nominal density related to Delta_p_max";

public
  TILMedia.Gas.Gas_pT flueGas_inlet(
    p=inlet.p,
    T=inStream(inlet.T_outflow),
    xi=inStream(inlet.xi_outflow),
    gasType=medium) annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));

  TILMedia.Gas.Gas_ph flueGas_outlet(
    gasType=medium,
    h=h_out,
    p=outlet.p,
    xi=flueGas_inlet.xi) annotation (Placement(transformation(extent={{70,-12},{90,8}})));

  //__________________________/ Parameters \_____________________________
  parameter Modelica.Units.SI.Inertia J "Moment of Inertia" annotation (Dialog(group="Fundamental Definitions", enable=not steadyStateTorque));
  parameter Boolean useMechanicalPort=false "True, if a mechenical flange should be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean steadyStateTorque=false "True, if steady state mechanical momentum shall be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.RPM rpm_fixed=60 "Constant rotational speed of pump" annotation (Dialog(group="Fundamental Definitions", enable=not useMechanicalPort));

  final parameter Boolean useDensityAffinity=true "True, if hydraulic characteristic shall be scalled w.r.t. densities according to affinity law" annotation(Dialog(group="Characteristic field"));
  parameter Boolean useHead=false "True, if a compressor head (height) | False, if compressor head (pressure) should be used" annotation(Dialog(group="Characteristic field"));
  parameter ClaRa.Basics.Units.RPM rpm_nom "|Characteristic field|Nomial rotational speed";
  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_max "|Characteristic field|Maximum volume flow rate at nominal speed";
  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_min=0 "|Characteristic field|V_flow(Delta_p_max, rpm_nom)";
  parameter ClaRa.Basics.Units.Pressure Delta_p_max=1e5 "Constatnt maximum pressure difference at rpm_nom, T_nom_char, p_nom_char, xi_nom_char" annotation(Dialog(group="Characteristic field", enable=not useHead));
  parameter ClaRa.Basics.Units.Length Head_max = 10 "Constant maximum head at flow = 0 for rpm_nom" annotation(Dialog(group="Characteristic field", enable=useHead));
//   parameter ClaRa.Basics.Units.Temperature T_nom_char = 293.15 "Nominal temperature related to Delta_p_max (related to nominal hydraulic characterisic)" annotation(Dialog(group="Characteristic field", enable= (useHead and not useDensityAffinity) or (not useHead and useDensityAffinity)));
//   parameter ClaRa.Basics.Units.Pressure p_nom_char = 1e5 "Nominal pressure related to Delta_p_max (related to nominal hydraulic characterisic)" annotation(Dialog(group="Characteristic field", enable= (useHead and not useDensityAffinity) or (not useHead and useDensityAffinity)));
//   parameter ClaRa.Basics.Units.MassFraction xi_nom_char[medium.nc - 1]={0,0,0,0,0.76,0.23,0,0,0} "Nominal gas composition related to Delta_p_max (related to nominal hydraulic characterisic)" annotation(Dialog(group="Characteristic field", enable= (useHead and not useDensityAffinity) or (not useHead and useDensityAffinity)));
  parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom = TILMedia.Gas.ObjectFunctions.density_pTxi(
                                                                                                      1e5,293.15,{0,0,0,0,0.76,0.23,0,0,0},InletNom.gasPointer) "Nominal density related to Delta_p_max" annotation(Dialog(group="Characteristic field", enable= (useHead and not useDensityAffinity) or (not useHead and useDensityAffinity)));
  parameter Real exp_hyd= 0.5 "|Characteristic field|Exponent for affinity law";

  parameter Real eta = 0.85 "isentropic efficiency";
  parameter Real eta_mech = 0.99 "mechanical efficiency";
  parameter ClaRa.Basics.Units.Pressure Delta_p_eps=100 "Small pressure difference for linearisation around zero mass flow"  annotation(Dialog(tab="Expert Settings", group="Numerical Robustness"));

  parameter ClaRa.Basics.Units.Time Tau_aux=0.1 "Time constant of auxilliary kappa states" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));
  parameter Real kappa_initial = 1.3 "Initial value for kappas" annotation(Dialog(tab="Expert Settings", group="Numerical Robustness"));

  //________________________/ Variables \___________________________________
  ClaRa.Basics.Units.Pressure Delta_p(final start=100) "pressure increase";
  ClaRa.Basics.Units.Power P_hyd "Hydraulic power";
  ClaRa.Basics.Units.VolumeFlowRate V_flow;
  ClaRa.Basics.Units.VolumeFlowRate V_flow_max_aff;
  ClaRa.Basics.Units.Pressure Delta_p_max_aff;
  ClaRa.Basics.Units.Pressure Delta_p_max_var "Pressure difference at flow= 0 for rpm_nom";
  Modelica.Units.SI.AngularAcceleration a "Angular acceleration of the shaft";
  ClaRa.Basics.Units.Power P_shaft "Mechanical power at shaft";
  ClaRa.Basics.Units.RPM rpm "Rotational speed";
  Modelica.Units.SI.Torque tau_fluid "Fluid torque";
  ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h;
  Real kappa;
  Real kappaA;
  Real kappaB;

protected
  ClaRa.Basics.Units.EnthalpyMassSpecific h_out;
  Real kappaB_aux;
  Real kappaA_aux;

  TILMedia.Gas.Gas InletNom(gasType=medium);

public
  ClaRa.Basics.Interfaces.EyeOutGas
                           eyeOut(each medium=medium) annotation (Placement(transformation(extent={{72,-78},
            {112,-42}}),          iconTransformation(extent={{92,-70},{112,-50}})));
protected
  ClaRa.Basics.Interfaces.EyeInGas
                          eye_int[1](each medium=medium) annotation (Placement(transformation(extent={{48,-68},
            {32,-52}}),           iconTransformation(extent={{90,-84},{84,-78}})));

public
  inner Summary summary(outline(
   V_flow = V_flow,
   P_hyd = P_hyd,
   P_shaft = P_shaft,
   Pi = outlet.p/inlet.p,
   Delta_p = outlet.p - inlet.p,
   rpm = rpm,
   eta = eta,
   eta_mech = eta_mech),
    inlet(mediumModel=medium, m_flow = inlet.m_flow,
          T = inStream(inlet.T_outflow),
          p = inlet.p,
          h = flueGas_inlet.h,
          xi = inStream(inlet.xi_outflow),
          H_flow = inlet.m_flow* flueGas_inlet.h),
    outlet(mediumModel=medium, m_flow = -outlet.m_flow,
          T = outlet.T_outflow,
          p = outlet.p,
          h = flueGas_outlet.h,
          xi= outlet.xi_outflow,
          H_flow = -outlet.m_flow* flueGas_outlet.h)) annotation (Placement(transformation(extent={{-100,
            -114},{-80,-94}})));
initial equation
  kappaB = kappa_initial;
  kappaA = kappa_initial;

equation
//_______________Pressure head _______________
   if useDensityAffinity then
     if useHead then Delta_p_max_var = Head_max*flueGas_inlet.d*Modelica.Constants.g_n;
     else Delta_p_max_var = Delta_p_max*(flueGas_inlet.d/rho_nom);
     end if;
   else
     if useHead then Delta_p_max_var = Head_max*rho_nom*Modelica.Constants.g_n;
     else Delta_p_max_var=Delta_p_max;
     end if;
   end if;

//____________________ Mechanics ___________________________
  if useMechanicalPort then
    der(getInputsRotary.rotatoryFlange.phi) = (2*pi*rpm/60);
    J*a*rpm = - tau_fluid*2*pi*rpm/60 + getInputsRotary.rotatoryFlange.tau*2*pi*rpm/60 "Mechanical momentum balance";
  else
    rpm = rpm_fixed;
    getInputsRotary.rotatoryFlange.phi = 0.0;
  end if;

  if (steadyStateTorque) then
    a = 0;
  else
    a = (2*pi/60)^2*der(rpm);
  end if;
  tau_fluid = if noEvent(2*pi*rpm/60<1e-8) then 0 else P_hyd/(2*pi*rpm/60);

  //______________Affinity laws_______________________
  V_flow_max_aff = V_flow_max*rpm/rpm_nom;
  Delta_p_max_aff = Delta_p_max_var*(rpm/rpm_nom)^2;

  //______________Compressor_characteristic___________
  V_flow =  Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower((Delta_p_max_aff - Delta_p)/Delta_p_max_var, Delta_p_eps/Delta_p_max_var, exp_hyd)*(V_flow_max-V_flow_min) + V_flow_min;

  P_hyd = Delta_h*inlet.m_flow;

  P_shaft = P_hyd*1/eta_mech;

  Delta_p = outlet.p - inlet.p;
  h_out = flueGas_inlet.h + Delta_h;

  V_flow = inlet.m_flow / flueGas_inlet.d;
  flueGas_inlet.cv * kappaA_aux = flueGas_inlet.cp;
  flueGas_outlet.cv * kappaB_aux = flueGas_outlet.cp;

  der(kappaB) = 1/Tau_aux*(kappaB_aux-kappaB); // auxilluary state
  der(kappaA) = 1/Tau_aux*(kappaA_aux-kappaA);

  if ( kappaA + kappaB) > 0.3 then
    kappa = ( kappaA + kappaB)/2.0;
  else
    kappa = 0.2;
  end if;

  eta * Delta_h =  kappa/(kappa - 1.0) * flueGas_inlet.p/flueGas_inlet.d * ((flueGas_outlet.p/flueGas_inlet.p)^((kappa -1.0)/kappa) - 1.0);

  inlet.m_flow + outlet.m_flow = 0.0;
  outlet.xi_outflow = inStream(inlet.xi_outflow);
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.T_outflow = flueGas_outlet.T;
  inlet.T_outflow = actualStream(outlet.T_outflow);

  //______________Eye port variable definition________________________
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = flueGas_outlet.T-273.15;
  eye_int[1].s = flueGas_outlet.s/1e3;
  eye_int[1].p = flueGas_outlet.p/1e5;
  eye_int[1].h = flueGas_outlet.h/1e3;
  eye_int[1].xi=flueGas_outlet.xi;

  connect(eye_int[1],eyeOut)  annotation (Line(
      points={{40,-60},{92,-60}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(shaft, getInputsRotary.rotatoryFlange)
    annotation (Line(points={{0,100},{0,30}}, color={0,0,0}));
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
</html>"),Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics));
end CompressorGas_L1_affinity;
