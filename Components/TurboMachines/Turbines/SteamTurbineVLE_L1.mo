within ClaRa.Components.TurboMachines.Turbines;
model SteamTurbineVLE_L1 "A steam turbine model based on STODOLA's law"
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

   extends ClaRa.Components.TurboMachines.Turbines.SteamTurbine_base(inlet(
                                                                     m_flow(      start=m_flow_nom)));
//  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_psxi;
//   import SM = ClaRaPlus.Basics.Functions.Stepsmoother;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_elMech=-P_t,
    powerOut_th=0,
    powerAux=0)                                                                                                     if contributeToCycleSummary;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

//_______________________ Mechanics ________________________________________
  parameter Boolean useMechanicalPort=false "True, if a mechenical flange should be used" annotation (Dialog(tab="Mechanical and Efficiency Settings", group = "Mechanics"));
  parameter Boolean steadyStateTorque=true "True, if steady state mechanical momentum shall be used" annotation (Dialog(tab="Mechanical and Efficiency Settings", group = "Mechanics", enable = useMechanicalPort));
  parameter ClaRa.Basics.Units.RPM rpm_fixed=3000 "Constant rotational speed of turbine" annotation (Dialog(
      tab="Mechanical and Efficiency Settings",
      group="Mechanics",
      enable=not useMechanicalPort));
  parameter Modelica.Units.SI.Inertia J=10 "Moment of Inertia" annotation (Dialog(
      tab="Mechanical and Efficiency Settings",
      group="Mechanics",
      enable=not steadyStateTorque and useMechanicalPort));

//_______________________ Visualisation ________________________________________
  parameter Boolean showExpertSummary = simCenter.showExpertSummary "True, if expert summary should be applied"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation(Dialog(tab="Summary and Visualisation"));

//_______________________ Nominal values ___________________________________
  parameter Modelica.Units.SI.Pressure p_nom=300e5 "Nominal inlet perssure" annotation (Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom=419 "Nominal mass flow rate" annotation (Dialog(group="Nominal values"));
  parameter Real Pi=5000/300e5 "Nominal pressure ratio" annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.Density rho_nom=10 "Nominal inlet density" annotation (Dialog(group="Nominal values"));

//_______________________ Initialisation ___________________________________

  inner parameter Integer  initOption=0 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "No Init", choice=802 "Fixed Phi",choice = 804 "Fixed RPM and Phi"));
  parameter ClaRa.Basics.Units.RPM rpm_start=10000 "Start value for RPM (use without electric boundary)" annotation(Dialog(tab="Initialisation",enable=initOption==804));
  parameter Modelica.Units.SI.Pressure p_in_start=p_nom "Start value for inlet pressure" annotation (Dialog(tab="Initialisation"));
  parameter Modelica.Units.SI.Pressure p_out_start=p_nom*Pi "Start value for outlet pressure" annotation (Dialog(tab="Initialisation"));
  parameter Boolean allowFlowReversal = simCenter.steamCycleAllowFlowReversal "True to allow flow reversal during initialisation"
                                                        annotation(Evaluate=true, Dialog(tab="Initialisation"));

//_______________________ Efficiency _____________________________
  parameter Real eta_mech=0.98 "Mechanical efficiency" annotation(Dialog(tab="Mechanical and Efficiency Settings",group="Turbine Efficiency"));

  replaceable model Efficiency=ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow
                                                                                                          constrainedby ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.EfficiencyModelBase
                                                                                                                                                                                                "Calculation of isentropic efficiency"
                                                                                            annotation(Dialog(tab="Mechanical and Efficiency Settings",group="Turbine Efficiency"),choicesAllMatching);

//_______________________ Expert Settings _____________________________
  parameter Boolean chokedFlow=false "With a large number of turbine stages the influence of supercritical flow conditions can be neglected"
                                                                                            annotation(Dialog(group="Expert Settings"));

public
  final parameter Real Kt = (m_flow_nom*sqrt(p_nom))/(sqrt(p_nom^2-p_nom^2*Pi^2)*sqrt(rho_nom)) "Kt coefficient of Stodola's law";

//______________________ Variables _____________________________________
  Modelica.Units.SI.SpecificEnthalpy h_is "Isentropic outlet enthalpy";
  Modelica.Units.SI.Power P_t "Turbine hydraulic power";
  Modelica.Units.SI.Pressure p_in(start=p_in_start);
  Modelica.Units.SI.Pressure p_out(start=p_out_start);
  Real eta_is "Isentropic efficiency";
  Modelica.Units.SI.EntropyFlowRate S_irr "Entropy production rate";
  Modelica.Units.SI.Pressure p_l "Laval pressure";
  ClaRa.Basics.Units.RPM rpm;

  inner Fundamentals.IComTurbine iCom(
    m_flow_in=inlet.m_flow,
    m_flow_nom=m_flow_nom,
    rho_nom=rho_nom,
    rho_in=fluidIn.d,
    rpm=rpm,
    Delta_h_is=fluidIn.h - h_is) annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
    // gamma_out(start=2) = (SM(
    //   fluidOut.VLE.h_v + 1000,
    //   fluidOut.VLE.h_v,
    //   fluidOut.h)*fluidOut.cp + SM(
    //   fluidOut.VLE.h_v,
    //   fluidOut.VLE.h_v + 1000,
    //   fluidOut.h)*TSMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi(
    //   fluidOut.p,
    //   fluidOut.VLE.h_v,
    //   fluidOut.xi,
    //   fluidOut.vleFluidPointer))/(SM(
    //   fluidOut.VLE.h_v + 1000,
    //   fluidOut.VLE.h_v,
    //   fluidOut.h)*fluidOut.cv + SM(
    //   fluidOut.VLE.h_v,
    //   fluidOut.VLE.h_v + 1000,
    //   fluidOut.h)*TSMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsochoricHeatCapacity_phxi(
    //   fluidOut.p,
    //   fluidOut.VLE.h_v,
    //   fluidOut.xi,
    //   fluidOut.vleFluidPointer))

model Outline
  extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.PressureDifference Delta_p;
    input ClaRa.Basics.Units.Power P_mech "Mechanical power of steam turbine" annotation (Dialog);
  input Real eta_isen "Isentropic efficiency" annotation(Dialog);
  input Real eta_mech "Mechanic efficiency" annotation(Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific h_isen "Isentropic steam enthalpy at turbine outlet" annotation (Dialog);
    input ClaRa.Basics.Units.RPM rpm "Pump revolutions per minute";
    input ClaRa.Basics.Units.Pressure p_nom
                                          if showExpertSummary "Nominal inlet perssure" annotation (Dialog);
  input Real Pi if showExpertSummary "Nominal pressure ratio" annotation(Dialog);
    input ClaRa.Basics.Units.MassFlowRate m_flow_nom
                                                   if showExpertSummary "Nominal mass flow rate" annotation (Dialog);
    input ClaRa.Basics.Units.DensityMassSpecific rho_nom
                                                       if showExpertSummary "Nominal inlet density" annotation (Dialog);
  parameter Boolean showExpertSummary;
end Outline;

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet;
  ClaRa.Basics.Records.FlangeVLE           outlet;

end Summary;

protected
  ClaRa.Components.TurboMachines.Fundamentals.GetInputsRotary2 getInputsRotary
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,0})));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    p=outlet.p,
    h=outlet.h_outflow) annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    h=inStream(inlet.h_outflow),
    p=inlet.p,
    d(start=rho_nom)) annotation (Placement(transformation(extent={{-44,48},{-24,68}})));

public
Summary summary(outline(showExpertSummary = showExpertSummary,p_nom= p_nom,m_flow_nom=m_flow_nom,rho_nom=rho_nom,Pi=Pi,Delta_p=p_out-p_in,P_mech=-P_t,eta_isen=eta_is,eta_mech=eta_mech,h_isen=h_is,rpm=rpm),
                inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h*inlet.m_flow, rho=fluidIn.d),
                outlet(showExpertSummary = showExpertSummary,m_flow = -outlet.m_flow, T=fluidOut.T, p=outlet.p, h=fluidOut.h, s=fluidOut.s, steamQuality=fluidOut.q, H_flow=-fluidOut.h*outlet.m_flow, rho=fluidOut.d)) annotation(Placement(
        transformation(extent={{-60,-100},{-40,-80}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft_a if useMechanicalPort
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft_b                                                                if useMechanicalPort
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(extent={{40,-70},{60,-50}}), iconTransformation(extent={{40,-70},{60,-50}})));

    Efficiency efficiency "Efficiency model" annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1] annotation (Placement(transformation(extent={{25,-61},{27,-59}})));

protected
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid ptr_iso(vleFluidType=medium);

initial equation

    if initOption==0 then
      //No Init
    elseif initOption==804 then
      rpm=rpm_start;
      getInputsRotary.shaft_b.phi=0;
    elseif initOption==802 then
      getInputsRotary.shaft_b.phi=0;
    end if;



equation
  rpm = der(getInputsRotary.shaft_a.phi)*60/(2*Modelica.Constants.pi);
//~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~Mechanics~~~~~~~~~~~~~
    if useMechanicalPort then
      //der(shaft_a.phi) = 2*Modelica.Constants.pi*rpm/60;
      if steadyStateTorque then
        0 = getInputsRotary.shaft_a.tau + getInputsRotary.shaft_b.tau -P_t/der(getInputsRotary.shaft_a.phi) "Mechanical momentum balance";
      else
        J*der(rpm)*2*Modelica.Constants.pi/60 =  getInputsRotary.shaft_a.tau + getInputsRotary.shaft_b.tau -P_t/der(getInputsRotary.shaft_a.phi) "Mechanical momentum balance";
      end if;
    else
      rpm = rpm_fixed;
    end if;

  getInputsRotary.shaft_a.phi=getInputsRotary.shaft_b.phi;

//~~~~~~~~~~~~~~~~~~~~~~~~~
// Efficiency ~~~~~~~~~~~~~
  eta_is=efficiency.eta;

//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~
  inlet.h_outflow=inStream(outlet.h_outflow); //This is a dummy - flow reversal is not supported;
  outlet.h_outflow=eta_is*(h_is-inStream(inlet.h_outflow))+inStream(inlet.h_outflow);  //applied the definition of the isentropic efficiency
  p_in=inlet.p;
  p_out=outlet.p;

// Laval pressure
  p_l=p_in*(2/(fluidOut.gamma+1))^(fluidOut.gamma/(fluidOut.gamma-1));
  //p_l=p_in*(2/(iCom.gamma_out+1))^(iCom.gamma_out/(iCom.gamma_out-1));

// Mass balance:
  inlet.m_flow=-outlet.m_flow;

// define isentropic outlet state:
  h_is= ptr_iso.h_psxi(fluidOut.p, fluidIn.s, fluidIn.xi);
  // STODOLA's law:
  if chokedFlow==false then
    outlet.m_flow = homotopy(-Kt*sqrt(max(1e-5, fluidIn.d*inlet.p))* ClaRa.Basics.Functions.ThermoRoot(1 - (p_out^2/inlet.p^2), 0.01), -m_flow_nom*inlet.p/p_nom);
  else
    outlet.m_flow = homotopy(-Kt*sqrt(max(1e-5, fluidIn.d*inlet.p))* ClaRa.Basics.Functions.ThermoRoot(1 - max(p_out^2/inlet.p^2,p_l^2/p_in^2), 0.01), -m_flow_nom*inlet.p/p_nom);
  end if;

  P_t=outlet.m_flow*(fluidIn.h-fluidOut.h)*eta_mech;

  outlet.xi_outflow = inStream(inlet.xi_outflow);
  inlet.xi_outflow = inStream(outlet.xi_outflow);

  S_irr=inlet.m_flow*(fluidOut.s-fluidIn.s);

  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = fluidOut.T-273.15;
  eye_int[1].s = fluidOut.s/1e3;
  eye_int[1].p = outlet.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;

  connect(eye,eye_int[1])  annotation (Line(
      points={{50,-60},{26,-60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(getInputsRotary.shaft_a, shaft_a) annotation (Line(points={{-20,0},{-20,0},{-52,0},{-100,0}},       color={0,0,0}));
  connect(getInputsRotary.shaft_b, shaft_b) annotation (Line(points={{0,0},{10,0},{10,0},{0,0},{80,0},{80,0}},       color={0,0,0}));
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
</html>"),Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false,extent={{-60,-100},{40,100}})),
                                         Icon(coordinateSystem(extent={{-60,-100},{40,100}},
                             preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,10},{-60,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={135,135,135},
          visible=useMechanicalPort), Rectangle(
          extent={{40,10},{80,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={135,135,135},
          visible=useMechanicalPort)}));
end SteamTurbineVLE_L1;
