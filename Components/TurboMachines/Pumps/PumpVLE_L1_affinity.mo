within ClaRa.Components.TurboMachines.Pumps;
model PumpVLE_L1_affinity "A pump for VLE mixtures based on affinity laws"

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

//   import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
//   import SM = ClaRa.Basics.Functions.Stepsmoother;
//   import Modelica.Constants.pi;
//   import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificEnthalpy_psxi;
  import Modelica.Constants.pi;
  import TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.bubblePressure_Txi;
  import TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificEnthalpy_psxi;
  import TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi;
  import TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi;
  import TILMedia.VLEFluid.MixtureCompatible.Functions.density_pTxi;
  import SM = ClaRa.Basics.Functions.Stepsmoother;

  extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.PumpVLE_affinityBase;

//  final parameter Boolean useDensityAffinity=true "True, if hydraulic characteristic shall be scalled w.r.t. densities according to affinity law" annotation(Dialog(group="Characteristic Field"));
  parameter Boolean useHead=false "True, if a pump head (height) | False, if pump head (pressure) should be used" annotation(Dialog(group="Characteristic Field", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/PumpCharField1.png"));
  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_max = 1 "Volume flow where Delta_p/head = 0 for rpm_nom" annotation(Dialog(group="Characteristic Field"));
  parameter ClaRa.Basics.Units.PressureDifference Delta_p_max = 1e5 "Constant pressure difference at flow = 0 for rpm_nom, rho_nom" annotation(Dialog(group="Characteristic Field", enable=not useHead));
  parameter ClaRa.Basics.Units.Length Head_max = 10 "Constant head at flow = 0 for rpm_nom" annotation(Dialog(group="Characteristic Field", enable=useHead));
//  parameter ClaRa.Basics.Units.Temperature T_nom_char = 293.15 "Nominal temperature related to Delta_p_max" annotation(Dialog(group="Characteristic Field", enable= useHead or (not useHead and useDensityAffinity)));
//  parameter ClaRa.Basics.Units.Pressure p_nom_char = 1e5 "Nominal pressure related to Delta_p_max" annotation(Dialog(group="Characteristic Field", enable= useHead or (not useHead and useDensityAffinity)));
//  parameter ClaRa.Basics.Units.MassFraction xi_nom_char[medium.nc-1] = medium.xi_default "Nominal mass fraction related to Delta_p_max" annotation(Dialog(group="Characteristic Field", enable= useHead or (not useHead and useDensityAffinity)));
  parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom = density_pTxi(iCom.medium,1e5,293.15,medium.xi_default) "Nominal density related to Delta_p_max" annotation(Dialog(group="Characteristic Field", enable= (useHead and not useDensityAffinity) or (not useHead and useDensityAffinity)));
  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_eps = V_flow_max/100 "Minimum volumetric flow rate for which hydraulic characteristic is still scaled with respect to density | For V_flow < abs(V_flow_eps) no density scalling is used." annotation(Dialog(tab="Expert Settings", enable = useDensityAffinity));
  final parameter Basics.Units.Time Tau_rho_CF_ps=1e-4 "Time constant for pseudo state for correction ratio of density.";
  final parameter Basics.Units.Time Tau_rho_upstream_ps=1e-2 "Time constant for pseudo state for upstream density.";

  replaceable model Hydraulics =   ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.MetaStable_Q124 constrainedby ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.BaseHydraulics "Hydraulic characteristic" annotation(choicesAllMatching, Dialog(group= "Characteristic Field", groupImage="modelica://ClaRaPlus/Resources/Images/ParameterDialog/PumpCharacteristicsDialogue.png"));
  replaceable model Energetics =  ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.EfficiencyCurves_Q1  constrainedby ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.BaseEnergetics "Model for losses"         annotation(choicesAllMatching, Dialog(group= "Characteristic Field"));

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");


  Real mult_eta "1/eta if pump mode else eta (turbine mode)";
  ClaRa.Basics.Units.PressureDifference Delta_p_max_var "Pressure difference at flow= 0 for rpm_nom";
  Real rho_CF "Correction ratio of density w.r.t. affinity law";
  Real rho_CF_ps "Pseudo correction ratio of density w.r.t. affinity law";
  ClaRa.Basics.Units.DensityMassSpecific  rho_upstream_ps "Pseudo correction upstream density";

 model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   ClaRa.Basics.Records.FlangeVLE           inlet;
   ClaRa.Basics.Records.FlangeVLE           outlet;
 end Summary;

protected
  replaceable record ICom = ClaRa.Components.TurboMachines.Fundamentals.IComPump_L1 annotation(Dialog(hide=true));

  Basics.Units.EnthalpyMassSpecific h_iso_in(start=bubbleSpecificEnthalpy_pxi(
        iCom.medium,
        max(1e5, Delta_p_max),
        iCom.medium.xi_default)*0.9) "Inlet spec. enthalpy for isentropic state change";
  Basics.Units.EnthalpyMassSpecific h_iso_out "Outlet spec. enthalpy for isentropic state change";

  ClaRa.Basics.Units.DensityMassSpecific rho_upstream(start=density_phxi(
        iCom.medium,
        max(1e5, Delta_p_max),
        bubbleSpecificEnthalpy_pxi(
          iCom.medium,
          max(1e5, Delta_p_max),
          iCom.medium.xi_default)*0.9,
        iCom.medium.xi_default)) "Upstream density";

//   ClaRa.Basics.Units.DensityMassSpecific rho_nom_char = density_pTxi(
//         iCom.medium,
//         p_nom_char,
//         T_nom_char,
//         xi_nom_char) "Nominal density related to Delta_p_max";


public
   Summary summary(
     outline(
       rpm=rpm,
       V_flow=iCom.V_flow,
       P_iso=P_iso,
       P_fluid =  P_fluid,
       P_shaft = getInputsRotary.rotatoryFlange.tau*2*pi*rpm/60,
       Delta_p=Delta_p,
       head= Delta_p/(fluidIn.d*Modelica.Constants.g_n),
       NPSHa = (inlet.p - bubblePressure_Txi(fluidIn.T, fluidIn.xi, fluidIn.vleFluidPointer))/(fluidIn.d*Modelica.Constants.g_n),
       eta_hyd= energetics.eta,
       eta_mech=1),
     inlet(
       showExpertSummary = showExpertSummary,
       m_flow=inlet.m_flow,
       T=fluidIn.T,
       p=inlet.p,
       h=fluidIn.h,
       s=fluidIn.s,
       steamQuality = fluidIn.q,
       H_flow= fluidIn.h*inlet.m_flow,
       rho=fluidIn.d),
     outlet(
       showExpertSummary=showExpertSummary,
       m_flow=-outlet.m_flow,
       T=fluidOut.T,
       p=outlet.p,
       h=fluidOut.h,
       s=fluidOut.s,
       steamQuality=fluidOut.q,
       H_flow=-fluidOut.h*outlet.m_flow,
       rho=fluidOut.d))                                                                              annotation(Placement(transformation(
         extent={{-10,-10},{10,10}},
         origin={-70,-90})));


  inner ICom iCom(
    P_iso=P_iso,
    Delta_p=Delta_p,
    rpm=rpm,
    medium=medium,
    fluidPointer_in=fluidIn.vleFluidPointer,
    fluidPointer_out=fluidOut.vleFluidPointer,
    h_in=fluidIn.h,
    h_out=fluidOut.h,
    p_in=inlet.p,
    p_out=outlet.p,
    xi_in=fluidIn.xi,
    xi_out=fluidOut.xi,
    Delta_p_max_var=Delta_p_max_var,
    V_flow_max=V_flow_max,
    rpm_nom=rpm_nom,
    V_flow=V_flow,
    m_flow=inlet.m_flow,
    h_in_iso=h_iso_in,
    h_out_iso=h_iso_out) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Hydraulics hydraulics annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-30,-30})));
  Energetics energetics annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={10,-30})));

protected
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid ptr_iso_in(vleFluidType=medium);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid ptr_iso_out(vleFluidType=medium);

initial equation
  rho_CF_ps = 1;
  rho_upstream_ps = rho_nom;

equation
  der(rho_CF_ps) = (rho_CF-rho_CF_ps)/Tau_rho_CF_ps;
  der(rho_upstream_ps) = (rho_upstream-rho_upstream_ps)/Tau_rho_upstream_ps;

//____________________ Calculate Power, Volumetric flow and torque _____________________
  //P_iso = Delta_p*V_flow; // Approximate rel. error is approx. 3% due to the assumption of constant density.
  P_iso = energetics.P_iso;
  P_shaft = getInputsRotary.rotatoryFlange.tau*2*pi*rpm/60;
  P_fluid = tau_fluid*2*pi*rpm/60;//P_iso + energetics.tau_loss*2*pi*rpm/60;
  V_flow = hydraulics.V_flow;
  tau_fluid = energetics.tau_fluid;

//_______________Pressure head _______________
//     if useDensityAffinity then
    if useHead then Delta_p_max_var = Head_max*rho_nom*Modelica.Constants.g_n*rho_CF_ps;
      else Delta_p_max_var=Delta_p_max*rho_CF_ps;
    end if;
//     else
//       if useHead then Delta_p_max_var=Head_max*rho_nom*Modelica.Constants.g_n;
//       else Delta_p_max_var=Delta_p_max;
//       end if;
//     end if;

//  Delta_p_max_var = if useHead then Head_max*rho_nom*Modelica.Constants.g_n*rho_CF else Delta_p_max*rho_CF;
  rho_CF = SM(-V_flow_eps/1000, -V_flow_eps, iCom.V_flow) * SM(V_flow_eps/1000, V_flow_eps, iCom.V_flow) * 1
         + SM(-V_flow_eps, -V_flow_eps/1000, iCom.V_flow) * fluidOut.d/rho_nom
         + SM(V_flow_eps, V_flow_eps/1000, iCom.V_flow) * fluidIn.d/rho_nom;

//_______________Additional media properties _______________
  h_iso_out = noEvent(if iCom.V_flow > 0 then ptr_iso_out.h_psxi(fluidOut.p, fluidIn.s, fluidOut.xi) else inStream(outlet.h_outflow));
  h_iso_in = noEvent(if iCom.V_flow < 0 then ptr_iso_in.h_psxi(fluidIn.p, fluidOut.s, fluidIn.xi) else inStream(inlet.h_outflow));
  rho_upstream = noEvent(if iCom.V_flow > 0 then fluidIn.d else fluidOut.d);

//____________________ Balance equations ___________________

  inlet.m_flow + outlet.m_flow = 0.0 "Mass balance";
  Delta_p = outlet.p - inlet.p "Momentum balance";
  //outlet.h_outflow = SM(2*Delta_p_eps,Delta_p_eps, Delta_p)* SM(Delta_p_maxrpm-Delta_p_eps, Delta_p_maxrpm, Delta_p)*(h_iso_out - h_iso_in)/eta_hyd +  h_iso_in "Application of eta_hyd's definition";
  mult_eta = noEvent(if iCom.Delta_p> 0 then 1/energetics.eta else energetics.eta);
  //outlet.h_outflow = (h_iso_out - h_iso_in)*mult_eta +  h_iso_in "Application of eta_hyd's definition";
  //outlet.h_outflow = (h_iso_out - inStream(inlet.h_outflow))*mult_eta + inStream(inlet.h_outflow) "Application of eta_hyd's definition";
  outlet.h_outflow = (ptr_iso_out.h_psxi(fluidOut.p, fluidIn.s, fluidOut.xi) - inStream(inlet.h_outflow))*mult_eta + inStream(inlet.h_outflow) "Application of eta_hyd's definition";


//___________________ Boundary definition __________________
  inlet.h_outflow =  inStream(outlet.h_outflow) "Dummy value, reverse flow i not supported";
  inlet.xi_outflow =  inStream(outlet.xi_outflow) "No chemical reactions";
  outlet.xi_outflow =  inStream(inlet.xi_outflow) "No chemical reactions";

  inlet.m_flow = iCom.V_flow*rho_upstream_ps;
  connect(shaft, getInputsRotary.rotatoryFlange)
    annotation (Line(points={{0,72},{0,72},{0,30}}, color={0,0,0}));
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
 Icon(graphics={Ellipse(
            extent={{-100,100},{100,-100}},
            lineThickness=1,
            lineColor={167,25,48},
            fillPattern=FillPattern.None,
            pattern=DynamicSelect(LinePattern.None, if summary.outline.NPSHa <0 then LinePattern.Solid else LinePattern.None))}), Diagram(graphics));
end PumpVLE_L1_affinity;
