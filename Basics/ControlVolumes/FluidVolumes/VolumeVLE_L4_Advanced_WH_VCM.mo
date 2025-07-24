within ClaRa.Basics.ControlVolumes.FluidVolumes;
model VolumeVLE_L4_Advanced_WH_VCM "Copy of VolumeVLE_L4_Advanced with adaptation of speed of sound according and vapour cavity model"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2025, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  extends ClaRa.Basics.Icons.Volume_L4;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  import SI = ClaRa.Basics.Units;
  import Modelica.Constants.eps;
  import Modelica.Constants.g_n "gravity constant";
  import sm=ClaRa.Basics.Functions.Stepsmoother;
  import szt=ClaRa.Basics.Functions.SmoothZeroTransition;
  outer ClaRa.SimCenter simCenter;

//## S U M M A R Y   D E F I N I T I O N ###################################################################
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation(Dialog(hide));

    input SI.Volume volume_tot "Total volume of system" annotation (Dialog(show));

    parameter Integer N_cv  "Number of finite volumes" annotation(Dialog(group="Discretisation"));

    input SI.Pressure Delta_p "Pressure difference between outlet and inlet" annotation (Dialog);
    input SI.Mass mass_tot "Total fluid mass in system mass" annotation (Dialog(show));
    input SI.Enthalpy H_tot if showExpertSummary "Total system enthalpy" annotation (Dialog(show));
    input SI.HeatFlowRate Q_flow_tot "Heat flow through entire pipe wall" annotation (Dialog);

    input SI.Mass mass[N_cv] if showExpertSummary "Fluid mass in cells" annotation (Dialog(show));
    input SI.Momentum I[N_cv + 1] if showExpertSummary "Momentum of fluid flow volumes through cell borders" annotation (Dialog(show));
    input SI.Force I_flow[N_cv + 2] if showExpertSummary "Momentum flow through cell borders" annotation (Dialog(show));
    input SI.MassFlowRate m_flow[N_cv + 1] if showExpertSummary "Mass flow through cell borders" annotation (Dialog(show));
    input SI.Velocity w[N_cv + 1] if showExpertSummary "Velocity of fluid through cell borders" annotation (Dialog(show));
  end Outline;

  model Wall_L4
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation(Dialog(hide));
    parameter Integer N_wall "Number of wall segments"  annotation(Dialog(hide));
    input SI.Temperature T[N_wall] if showExpertSummary "Temperatures of wall segments" annotation (Dialog);
    input SI.HeatFlowRate Q_flow[N_wall] if showExpertSummary "Heat flows through wall segments" annotation (Dialog);
  end Wall_L4;

  model Summary
     extends ClaRa.Basics.Icons.RecordIcon;
     Outline outline;
     ClaRa.Basics.Records.FlangeVLE           inlet;
     ClaRa.Basics.Records.FlangeVLE           outlet;
     ClaRa.Basics.Records.FluidVLE_L34           fluid;
     Wall_L4 wall;
  end Summary;

//## P A R A M E T E R S #######################################################################################

protected
  final inner parameter SI.Length zFM[geo.N_cv + 1]=cat(
      1,
      {0},
      {(geo.z[i] + geo.z[i + 1])/2 for i in 1:geo.N_cv - 1},
      {geo.z_out - geo.z_in}) "height of center of flow model cells == height of energy-grid cell borders (for an equidistant grid)";
   final parameter SI.MassFlowRate m_flow_eps=abs(m_flow_nom)/1e4;
//____Media Data_____________________________________________________________________________________
public
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"));

//____Physical Effects_____________________________________________________________________________________

public
 inner parameter Boolean frictionAtInlet=false "True if pressure loss shall be located between first cell and inlet"
                                                                                            annotation (choices(checkBox=true),Dialog(group="Fundamental Definitions"));
  parameter Real Zeta_in=0 "Inlet losses additional to wall friction";
  inner parameter Boolean frictionAtOutlet=false "True if pressure loss shall be located between last cell and outlet"
                                                                                            annotation (choices(checkBox=true),Dialog(group="Fundamental Definitions"));

  parameter Real Zeta_out=0 "Outlet losses additional to wall friction";
  replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model at the tubes side"
    annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));

  replaceable model HeatTransfer =
     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4 "Heat transfer mode at the tubes side"
   annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv              "Pipe geometry"
   annotation(choicesAllMatching,Dialog(group="Geometry"));

  replaceable model MechanicalEquilibrium = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.Homogeneous_L4
                                                                                                  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4
                                                                                                                                                                                         "Mechanical equilibrium model"
                                                                                             annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));
//____Nominal Values_________________________________________________________________________________
  parameter SI.Pressure p_nom[geo.N_cv]=ones(geo.N_cv)*1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter SI.EnthalpyMassSpecific h_nom[geo.N_cv]=ones(geo.N_cv)*1e5 "Nominal specific enthalpy for single tube" annotation (Dialog(group="Nominal Values"));
  inner parameter SI.MassFlowRate m_flow_nom=100 "Nominal mass flow for single tube" annotation (Dialog(group="Nominal Values"));
  inner parameter SI.Pressure Delta_p_nom=1e4 "Nominal pressure loss w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));

  final parameter SI.DensityMassSpecific rho_nom[geo.N_cv]=TILMedia.VLEFluid.Functions.density_phxi(
      medium,
      p_nom,
      h_nom) "Nominal density";

//____Initialisation_____________________________________________________________________________________
  parameter Integer initOption = 1 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy", choice=208 "steady presure and enthalpy"));
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation",group="Model Settings"));

  parameter SI.EnthalpyMassSpecific h_start[geo.N_cv]=ones(geo.N_cv)*800e3 "Initial specific enthalpy for single tube" annotation (Dialog(tab="Initialisation"));
  parameter SI.Pressure p_start[geo.N_cv]=ones(geo.N_cv)*1e5 "Initial pressure" annotation (Dialog(tab="Initialisation"));
  parameter SI.MassFlowRate m_flow_start[geo.N_cv + 1]=ones(geo.N_cv + 1)*100 "Initial mass flow rate" annotation (Dialog(tab="Initialisation"));
  parameter SI.MassFraction xi_start[medium.nc - 1]=zeros(medium.nc - 1) "Initial composition" annotation (Dialog(tab="Initialisation"));
  final parameter SI.Temperature T_start[geo.N_cv]=TILMedia.VLEFluid.Functions.temperature_phxi(
      medium,
      p_start,
      h_start) "Nominal Temperature";
protected
  parameter SI.Pressure p_start_internal[geo.N_cv]=if size(p_start, 1) == 2 then linspace(
      p_start[1],
      p_start[2],
      geo.N_cv) else p_start "Internal p_start array which allows the user to either state p_inlet, p_outlet if p_start has length 2, otherwise the user can specify an individual pressure profile for initialisation";
//____Summary and Visualisation_____________________________________________________________________________________
public
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if a summary shall be shown, else false"
                                                                                                                 annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=false "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                                              annotation(Dialog(tab="Summary and Visualisation"));

//____Advanced_____________________________________________________________________________________
 parameter Boolean suppressHighFrequencyOscillations=false "Suppress oscillations at frequencies greater than inverse travelling time of sound"
                                                                                                                                               annotation(Dialog(tab="Expert Settings"));
 parameter Real suppHighFreqCorr=1 "Damping factor. Increase it will increase damping "
                                                                                       annotation(Dialog(enable= suppressHighFrequencyOscillations,tab="Expert Settings"));
 final parameter Real suppFreqCorr= if suppressHighFrequencyOscillations then suppHighFreqCorr else 0;
 parameter Boolean useMeanEnthalpyAtInlet=false "Use mean enthalpy at inlet, stabilises zero flows" annotation(Dialog(tab="Expert Settings", group="Mass Flow Stabilization"));
 parameter Boolean useMeanEnthalpyAtOutlet=false "Use mean enthalpy at inlet, stabilises zero flows" annotation(Dialog(tab="Expert Settings", group="Mass Flow Stabilization"));
 parameter Boolean advectivePressureLoss=true annotation(Dialog(tab="Expert Settings", group="Mass Flow Stabilization"));

 parameter Boolean limitMassChange=false "Set to true to limit time derivative of control volume mass. CAUTION: Precise short time dynamics is artificially changed! Can be useful if simulation stops in case of phase change." annotation(Dialog(tab="Expert Settings", group="Mass Flow Stabilization"));
 parameter Real massChangeLimit(unit="1/s")= 10 "Limit abs(drhodt[I]/rho[I])=abs(der(mass[I])/mass[I])<= massChangeLimit" annotation(Dialog(enable= limitMassChange,  tab="Expert Settings", group="Mass Flow Stabilization"));
 parameter Real pressureAdvCalc(min=0, max=1) = 0 "Parameter for a method of calculation advective pressure drop using:|| 0:= upstream velocities | 1:= velocities in energy cells" annotation(Dialog(tab="Expert Settings"));

   Summary summary(
      outline(     showExpertSummary=showExpertSummary,
                   N_cv=geo.N_cv,
                   volume_tot=sum(geo.volume),
                   Delta_p= inlet.p - outlet.p,
                   mass_tot=sum(mass),
                   H_tot=sum(h.*mass),
                   Q_flow_tot=sum(heat.Q_flow),
                   mass=mass,
                   I=geo.Delta_x_FM.*m_flow,
                   I_flow=cat(1,{w_inlet*abs(w_inlet)*fluidInlet.d*geo.A_cross[1]},{w[i]*abs(w[i])*fluid[i].d*geo.A_cross[i] for i in 1:geo.N_cv},{w_outlet*abs(w_outlet)*fluidOutlet.d*geo.A_cross[geo.N_cv]}),
                   m_flow=m_flow,
                   w=w_FM),
       inlet(       showExpertSummary=showExpertSummary,
                   m_flow=inlet.m_flow,
                   T=fluidInlet.T,
                   p=fluidInlet.p,
                   h=fluidInlet.h,
                   s=fluidInlet.s,
                   steamQuality=fluidInlet.q,
                   H_flow=H_flow[1],
                   rho=fluidInlet.d),
      outlet(      showExpertSummary=showExpertSummary,
                   m_flow=-outlet.m_flow,
                   T=fluidOutlet.T,
                   p=fluidOutlet.p,
                   h=fluidOutlet.h,
                   s=fluidOutlet.s,
                   steamQuality=fluidOutlet.q,
                   H_flow=H_flow[geo.N_cv+1],
                   rho=fluidOutlet.d),
      fluid(       showExpertSummary=showExpertSummary,
                   N_cv=geo.N_cv,
                   mass=mass,
                   T=fluid.T,
                   T_sat= fluid.VLE.T_l,
                   p=p,
                   h=h,
                   h_bub = fluid.VLE.h_l,
                   h_dew = fluid.VLE.h_v,
                   s=fluid.s,
                   steamQuality=fluid.q,
                   H=mass.*h,
                   rho=fluid.d),
      wall(        showExpertSummary=showExpertSummary,
                   N_wall=geo.N_cv,
                   T=heat.T,
                   Q_flow=heat.Q_flow))
  annotation (Placement(transformation(extent={{-60,-52},{-40,-34}})));

//## V A R I A B L E   P A R T#######################################################################################

//____Energy / Enthalpy_________________________________________________________________________________________
  SI.EnthalpyMassSpecific h[geo.N_cv](
    nominal=h_nom,
    start=h_start,
    each stateSelect=StateSelect.prefer) "Cell enthalpy";
//   Units.Energy E_kin[geo.N_cv] "Kinetic energy of fluid in cells";
//   Units.Energy E_pot[geo.N_cv] "Potential energy of fluid in cells";
//   Units.Power dE_kin_dt[geo.N_cv] "time derivative of kinetic energy";
//   Units.Power dE_pot_dt[geo.N_cv] "time derivative of potential energy";
//    Basics.Units.EnthalpyMassSpecific[
//                            geo.N_cv + 1] h_FM;

   SI.EnthalpyMassSpecific h_in;
   SI.EnthalpyMassSpecific h_out;
   final parameter ClaRa.Basics.Units.Time Tau_T_ps=1e-4 "Time constant for pseudo state for temperature.";
   SI.Temperature T_ps[geo.N_cv](nominal=293.15,start=T_start) "Temperature pseudo state";
//____Pressure__________________________________________________________________________________________________
protected
  SI.DensityMassSpecific[geo.N_cv + 1] rho_FM "Density at flow model states";
  SI.Pressure p[geo.N_cv](nominal=p_nom, start=p_start_internal) "Cell pressure";

  SI.Pressure Delta_p_adv[geo.N_cv + 1] "Pressure difference due to the momentum of liquid flow";
  SI.Pressure Delta_p_fric[geo.N_cv + 1](start=ones(geo.N_cv + 1)*100) "Pressure difference due to friction";
  SI.Pressure Delta_p_grav[geo.N_cv + 1] "pressure drop due to gravity";
  SI.Pressure Delta_p_inlet "pressure drop due to inlet";
  SI.Pressure Delta_p_outlet "pressure drop due to outlet";
  SI.Pressure Delta_p_suppFreqCorr[geo.N_cv + 1] "Pressure difference due to suppress high frequency oscillations";

//____Mass and Density__________________________________________________________________________________________
public
  SI.Mass mass[geo.N_cv] "Mass of fluid in cells";
  inner Real drhodt[geo.N_cv];//(unit="kg/(m3s)")

//____Mass Fractions____________________________________________________________________________________________
  Modelica.Units.SI.MassFraction xi[geo.N_cv,medium.nc - 1] "Mass fraction";
  Real[geo.N_cv + 1, medium.nc - 1] Xi_flow "Mass flow rate of fraction";
  Modelica.Units.SI.MassFraction xi_inlet[medium.nc - 1] "Inlet mass fraction of component";
  Modelica.Units.SI.MassFraction xi_outlet[medium.nc - 1] "Outlet mass fraction of component";

//____Flows and Velocities______________________________________________________________________________________
  SI.Power H_flow[geo.N_cv + 1] "Enthalpy flow rate at cell borders";
  SI.MassFlowRate m_flow[geo.N_cv + 1](nominal=ones(geo.N_cv + 1)*m_flow_nom, start=m_flow_start);

  SI.Velocity w[geo.N_cv] "flow velocities within cells of energy model == flow velocities across cell borders of flow model ";
  SI.Velocity w_inlet "flow velocity at inlet";
  SI.Velocity w_outlet "flow velocity at outlet";
  SI.Velocity w_FM[geo.N_cv + 1] "flow velocities within cells of flow model == flow velocities across cell borders of energy model ";
  SI.Velocity w_up[geo.N_cv] "upstream flow velocities for calculation of advective pressure losses ";
  SI.Pressure p_sat[geo.N_cv] "Saturation pressure";
  SI.Volume volume[geo.N_cv] "Variable volume of CV";
  SI.Volume volume_cavity[2] "Volume of cavity in first an last CV";
  SI.Volume volume_cavity_help[2] "Volume of cavity in first and last CV";

//____Speed of Sound correction_____________________________________________________________________
public
  Real K[geo.N_cv] "Bulk modulus";
  Real K_inlet "Inlet bulk modulus";
  Real K_outlet "Inlet bulk modulus";
  parameter Boolean exportToFMU=false "True if user defined media data shall not change structure | false else "
                                                                                                                annotation(Dialog(tab="Water Hammer", group = "FMU export"));
  final parameter Real exportToFMUPreFactor = if exportToFMU then 1.0 else 0.0;
  parameter Boolean useStiffWall=true "True for stiff walls | False to account for elasticity of wall material"
                                                                                                               annotation(Dialog(tab="Water Hammer", group = "User Defined Physical Properties"));
  final parameter Real useStiffWallPreFactor = if useStiffWall then 1.0 else 0.0;
  parameter Boolean userDefinedSpeedOfSound=false "True for user definition of speed of sound"
                                                                                              annotation(Dialog(tab="Water Hammer", group = "User Defined Physical Properties"));
  final parameter Real userDefinedSpeedOfSoundPreFactor = if userDefinedSpeedOfSound then 1.0 else 0.0;
  parameter SI.ElasticityModule E=120e9 "Young's modulus"
                                                         annotation(Dialog(tab="Water Hammer", group = "User Defined Physical Properties",enable=(userDefinedSpeedOfSound==false)));
  parameter Real my=0.34 "Possion's ratio"
                                          annotation (Dialog(tab="Water Hammer", group = "User Defined Physical Properties",enable=(userDefinedSpeedOfSound==false)));
  parameter SI.Length e=0.00163 "Wall thickness"
                                                annotation (Dialog(tab="Water Hammer", group = "User Defined Physical Properties",enable=(userDefinedSpeedOfSound==false)));
  parameter SI.Velocity a_def=1319 "User defined speed of sound" annotation(Dialog(tab="Water Hammer", group = "User Defined Physical Properties",enable=(userDefinedSpeedOfSound==true)));
  parameter Boolean userDefinedDynamicViscosity=false "True for user definition of speed of sound"
                                                                                                  annotation(Dialog(tab="Water Hammer", group = "User Defined Physical Properties"));
  parameter SI.DynamicViscosity eta_FM_def[geo.N_cv+1]=ones(geo.N_cv+1)*1e-3 "User defined dynamic viscosity" annotation(Dialog(tab="Water Hammer", group = "User Defined Physical Properties",enable=(userDefinedDynamicViscosity==true)));
  parameter Boolean useUnsteadyFriction=true "True for Unsteady Friction"
                                                                         annotation(Dialog(tab="Water Hammer", group = "User Defined Physical Properties"));

protected
  Real c_1[geo.N_cv] "Dimensionless parameter that describes the effect of pipe constraint condition on the wave speed";
  Real a_corr[geo.N_cv] "Correction term for speed of sound";
  Real a_corr_inlet "Inlet Correction term for speed of sound";
  Real a_corr_outlet "Outlet Correction term for speed of sound";

//____Wall Shear Stress Model_____________________________________________________________________
public
  SI.PressureDifference Delta_p_u[geo.N_cv+1] "Pressure loss due to unsteady friction";
  Real Re[geo.N_cv+1] "Reynolds Number";
  Real k_B[geo.N_cv+1] "Brunone friction factor";
protected
  Real C_ast[geo.N_cv+1] "Shear decay coefficient C* [Vardy]";
  SI.Stress tau_wu[geo.N_cv+1] "Unsteady contribution to wall shear stress";
  parameter Real Re_crit = 10 "Critical Reynolds number for pipe flow" annotation (Dialog(tab="Water Hammer"));
  parameter Real Re_tol = 1 "Tolerance range for critical Reynolds number" annotation (Dialog(tab="Water Hammer"));
  SI.DynamicViscosity eta_FM[geo.N_cv+1] "dynamic viscosity";
//   Real SM[geo.N_cv+1] "Stepsmoother function replacing sign()";
  parameter Real SM_tol = 1e-4 "tolerance Range for SM function" annotation (Dialog(tab="Water Hammer"));
  constant Real MIN=Modelica.Constants.eps "Limiter";

//____Connectors________________________________________________________________________________________________
public
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium, p(start=p_start[1])) "Inlet port" annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium, p(start=p_start[geo.N_cv])) "Outlet port" annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat[geo.N_cv] annotation (Placement(transformation(extent={{-10,40},{10,60}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));

//___Instantiation of Replaceable Models___________________________________________________________________________

  inner TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluid[geo.N_cv](
    each computeSurfaceTension=false,
    each deactivateTwoPhaseRegion=true,
    p={max(p[i], p_sat[i]) for i in 1:geo.N_cv},
    h=h,
    each vleFluidType=medium,
    each computeTransportProperties=true,
    xi=xi) annotation (Placement(transformation(extent={{-10,-50},{10,-30}}, rotation=0)));

  inner TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidInlet(
    computeSurfaceTension=false,
    deactivateTwoPhaseRegion=true,
    p=max(inlet.p, p_sat[1]),
    xi={(inStream(inlet.xi_outflow[i]) + inlet.xi_outflow[i])/2 for i in 1:medium.nc - 1},
    vleFluidType=medium,
    h=if useHomotopy then homotopy(h_in, inStream(inlet.h_outflow)) else h_in)
    "if useHomotopy then homotopy(inStream(inlet.h_outflow), h_in) else h_in"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}}, rotation=0)));

  inner TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOutlet(
    computeSurfaceTension=false,
    deactivateTwoPhaseRegion=true,
    p=max(outlet.p, p_sat[geo.N_cv]),
    xi={(inStream(outlet.xi_outflow[i]) + outlet.xi_outflow[i])/2 for i in 1:medium.nc - 1},
    vleFluidType=medium,
    h=if useHomotopy then homotopy(h_out, outlet.h_outflow) else h_out)
    "(outlet.h_outflow + inStream(outlet.h_outflow))/2"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}}, rotation=0)));

protected
  inner ClaRa.Basics.Records.IComVLE_L3_OnePort iCom(
    mediumModel=medium,
    N_cv=geo.N_cv,
    xi=xi,
    volume=geo.volume,
    p_in={inlet.p},
    T_in={fluidInlet.T},
    m_flow_in={inlet.m_flow},
    h_in={fluidInlet.h},
    xi_in={fluidInlet.xi},
    p_out={outlet.p},
    T_out={fluidOutlet.T},
    m_flow_out={outlet.m_flow},
    h_out={fluidOutlet.h},
    xi_out={fluidOutlet.xi},
    p_nom=p_nom[1],
    Delta_p_nom=Delta_p_nom,
    m_flow_nom=m_flow_nom,
    h_nom=h_nom[1],
    T=fluid.T,
    p={max(p[i], p_sat[i]) for i in 1:geo.N_cv},
    h=h,
    fluidPointer_in={fluidInlet.vleFluidPointer},
    fluidPointer_out={fluidOutlet.vleFluidPointer},
    fluidPointer=fluid.vleFluidPointer) annotation (Placement(transformation(extent={{-80,-52},{-60,-34}})));

public
    PressureLoss pressureLoss "Pressure loss model"
                          annotation(Placement(transformation(extent={{-40,0},
            {-20,20}})));
    HeatTransfer heatTransfer(A_heat=geo.A_heat_CF[:,1]) "heat transfer model"
                            annotation(Placement(transformation(extent={{-80,0},
            {-60,20}})));
    MechanicalEquilibrium
                        mechanicalEquilibrium(final h_start=h_start) "Mechanical equilibrium model" annotation (Placement(transformation(extent={{40,0},{60,20}})));
    inner Geometry geo annotation (Placement(transformation(extent={{0,0},{20,20}})));
//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------
//initialisation

initial equation

  if initOption == 1 then
    der(h)=zeros(geo.N_cv);
    der(p)=zeros(geo.N_cv);

     if not frictionAtInlet and not frictionAtOutlet then
         der(m_flow[2:geo.N_cv])=zeros(geo.N_cv-1);
     elseif frictionAtInlet and not frictionAtOutlet then
         der(m_flow[1:geo.N_cv])=zeros(geo.N_cv);
     elseif  not frictionAtInlet and frictionAtOutlet then
         der(m_flow[2:geo.N_cv+1])=zeros(geo.N_cv);
     else //inlet_dp_innerPipe_dp_outlet
         der(m_flow[2:geo.N_cv])=zeros(geo.N_cv-1);
     end if;
  elseif initOption == 201 then
    der(p)=zeros(geo.N_cv);
  elseif initOption == 202 then
    der(h)=zeros(geo.N_cv);
  elseif initOption == 208 then
    der(h)=zeros(geo.N_cv);
    der(p)=zeros(geo.N_cv);
  elseif initOption ==0 then
    // do nothing
  else
    assert(false, "Unknown initialisation option in " + getInstanceName());
  end if;

  // composition of mass components
  for i in 1:geo.N_cv loop
    xi[i, :] = xi_start[1:end];
  end for;
//--------------------------------------------------------------------------------------

equation
  connect(heat, heatTransfer.heat) annotation (Line(
      points={{0,50},{0,28},{-61,28},{-61,19}},
      color={0,0,0},
      smooth=Smooth.None));

//-------------------------------------------
//flow velocities at inlet and outlet
  w_inlet=inlet.m_flow/(geo.A_cross_FM[1]*rho_FM[1]);
  w_outlet=-outlet.m_flow/(geo.A_cross_FM[geo.N_cv+1]*rho_FM[geo.N_cv+1]);

//flow velocities in cells
  for i in 1:geo.N_cv loop
     w[i]=(m_flow[i]+m_flow[i+1])/(2*fluid[i].d*geo.A_cross[i]);
  end for;

//flow velocities in FlowModel cells
  for i in 2:geo.N_cv loop
     w_FM[i]=m_flow[i]/(geo.A_cross_FM[i]*rho_FM[i]);
  end for;
  w_FM[1]=m_flow[1]/(geo.A_cross_FM[1]*rho_FM[1]);
  w_FM[geo.N_cv+1]=m_flow[geo.N_cv+1]/(geo.A_cross_FM[geo.N_cv+1]*rho_FM[geo.N_cv+1]);

//flow velocities upstream scheme
  for i in 1:geo.N_cv loop
     w_up[i]=noEvent(if w[i]>0 then w_FM[i] else w_FM[i+1]);
  end for;

  //definition of enthalpies at inlet/outlet fluid object: introducing averiging (for small (close to zero) mass flows) or standard way using inStream(inlet.h_outflow) for inlet and outlet.h_outflow for outlet
  if useMeanEnthalpyAtInlet then
    h_in=(inStream(inlet.h_outflow) + inlet.h_outflow)/2;
  else
   h_in=sm(-m_flow_eps,0,m_flow[1])*inlet.h_outflow+sm(0,-m_flow_eps,m_flow[1])*sm(0,m_flow_eps,m_flow[1])*(inStream(inlet.h_outflow) + inlet.h_outflow)/2+sm(m_flow_eps,0,m_flow[1])*inStream(inlet.h_outflow);
  end if;
  if useMeanEnthalpyAtOutlet then
    h_out=  (inStream(outlet.h_outflow) + outlet.h_outflow)/2;
  else
    h_out=sm(-m_flow_eps,0,m_flow[geo.N_cv+1])*inStream(outlet.h_outflow)+sm(0,-m_flow_eps,m_flow[geo.N_cv+1])*sm(0,m_flow_eps,m_flow[geo.N_cv+1])*(inStream(outlet.h_outflow) + outlet.h_outflow)/2+sm(m_flow_eps,0,m_flow[geo.N_cv+1])*outlet.h_outflow;
  end if;

//-------------------------------------------
//definition of the FlowModel density
//compared to a previous version of the volume model, the density in the momentum cells is calculated by averaging the density in the energy cells
//instead of averaging the states p and h and calculate the density in an additional fluidFM model
  for i in 2:geo.N_cv loop
  rho_FM[i]=(fluid[i].d+fluid[i-1].d)/2;
//      p_FM[i]=1/2*(p[i-1]+p[i]);
//      h_FM[i]=(h[i-1]+h[i])/2;
  end for;
  rho_FM[1]=(fluidInlet.d+fluid[1].d)/2;
  rho_FM[geo.N_cv+1]=(fluidOutlet.d+fluid[geo.N_cv].d)/2;
//    p_FM[1]=1/2*(inlet.p+p[1]);
//    h_FM[1]=(actualStream(inlet.h_outflow)+h[1])/2;
//    p_FM[geo.N_cv+1]=1/2*(outlet.p+p[geo.N_cv]);
//    h_FM[geo.N_cv+1]=(h[geo.N_cv]+actualStream(outlet.h_outflow))/2;

//-------------------------------------------
//data exchange with friction model
  m_flow[1]=inlet.m_flow;
  m_flow=pressureLoss.m_flow;
  m_flow[geo.N_cv+1]=-outlet.m_flow;

//-------------------------------------------
//data exchange with replaceable models
  heatTransfer.m_flow=m_flow;
  mechanicalEquilibrium.m_flow = m_flow;

//-------------------------------------------
//additional pressure loss due to unsteady friction

//definition of the eta in FlowModel cells
  if userDefinedDynamicViscosity==false then
    for i in 2:geo.N_cv loop
      eta_FM[i]=(fluid[i].transp.eta+fluid[i-1].transp.eta)/2;
    end for;
    eta_FM[1]=(fluidInlet.transp.eta+fluid[1].transp.eta)/2;
    eta_FM[geo.N_cv+1]=(fluidOutlet.transp.eta+fluid[geo.N_cv].transp.eta)/2;
  else
    eta_FM=eta_FM_def;
  end if;

  if useUnsteadyFriction == true then
    for i in 2:geo.N_cv loop
      Delta_p_u[i] = tau_wu[i]*geo.Delta_x_FM[i]*4/geo.diameter_hyd[i];
      tau_wu[i] = k_B[i]/geo.A_cross_FM[i]*geo.diameter_hyd[i]/4*(der(m_flow[i]) + szt(
        1,
        -1,
        m_flow[i],
        SM_tol)*fluid[i].w*a_corr[i]*abs(0.5*(m_flow[i + 1] - m_flow[i - 1])/geo.Delta_x[i]));
      k_B[i] = sqrt(C_ast[i])/2;
      Re[i] = abs(m_flow[i])*geo.diameter_hyd[i]/(geo.A_cross_FM[i]*max(MIN, eta_FM[i]));
      if noEvent(Re[i] > 0) then
        //       C_ast[i]= sm(Re_crit+Re_tol,Re_crit-Re_tol,Re[i])*12.86/max(Re[i]^Modelica.Math.log10(15.29/max(Re[i]^0.0567,MIN)),MIN)+
        //                 sm(Re_crit-Re_tol,Re_crit+Re_tol,Re[i])*0.00476;
        C_ast[i] = sm(
          Re_crit + Re_tol,
          Re_crit - Re_tol,
          Re[i])*7.41/max(Re[i]^Modelica.Math.log10(14.3/max(Re[i]^0.05, MIN)), MIN) + sm(
          Re_crit - Re_tol,
          Re_crit + Re_tol,
          Re[i])*0.00476;
      else
        C_ast[i] = 0.00476;
      end if;
    end for;

    //i=1,2
    if frictionAtInlet then
      Delta_p_u[1] = tau_wu[1]*geo.Delta_x_FM[1]*4/geo.diameter_hyd[1];
      tau_wu[1] = k_B[1]/geo.A_cross_FM[1]*geo.diameter_hyd[1]/4*(der(m_flow[1]) + szt(
        1,
        -1,
        m_flow[1],
        SM_tol)*fluid[1].w*a_corr[1]*abs((m_flow[2] - m_flow[1])/geo.Delta_x[1]));
      k_B[1] = sqrt(C_ast[1])/2;
      Re[1] = abs(m_flow[1])*geo.diameter_hyd[1]/(geo.A_cross_FM[1]*max(MIN, eta_FM[1]));
      if noEvent(Re[1] > 0) then
        //       C_ast[1]= sm(Re_crit+Re_tol,Re_crit-Re_tol,Re[1])*12.86/max(Re[1]^Modelica.Math.log10(15.29/max(Re[1]^0.0567,MIN)),MIN)+
        //                 sm(Re_crit-Re_tol,Re_crit+Re_tol,Re[1])*0.00476;
        C_ast[1] = sm(
          Re_crit + Re_tol,
          Re_crit - Re_tol,
          Re[1])*7.41/max(Re[1]^Modelica.Math.log10(14.3/max(Re[1]^0.05, MIN)), MIN) + sm(
          Re_crit - Re_tol,
          Re_crit + Re_tol,
          Re[1])*0.00476;
      else
        C_ast[1] = 0.00476;
      end if;

    else
      Delta_p_u[1] = 0;
      tau_wu[1] = 0;
      k_B[1] = 0;
      Re[1] = 0;
      C_ast[1] = 0;
    end if;

    if frictionAtOutlet then
      Delta_p_u[geo.N_cv + 1] = tau_wu[geo.N_cv + 1]*geo.Delta_x_FM[geo.N_cv + 1]*4/geo.diameter_hyd[geo.N_cv];
      tau_wu[geo.N_cv + 1] = k_B[geo.N_cv + 1]/geo.A_cross_FM[geo.N_cv + 1]*geo.diameter_hyd[geo.N_cv]/4*(der(m_flow[geo.N_cv + 1]) + szt(
        1,
        -1,
        m_flow[geo.N_cv + 1],
        SM_tol)*fluidOutlet.w*a_corr[geo.N_cv]*abs((m_flow[geo.N_cv + 1] - m_flow[geo.N_cv])/geo.Delta_x[geo.N_cv]));
      k_B[geo.N_cv + 1] = sqrt(C_ast[geo.N_cv + 1])/2;
      Re[geo.N_cv + 1] = abs(m_flow[geo.N_cv + 1])*geo.diameter_hyd[geo.N_cv]/(geo.A_cross_FM[geo.N_cv + 1]*max(MIN, eta_FM[geo.N_cv + 1]));
      if noEvent(Re[geo.N_cv + 1] > 0) then
        //       C_ast[geo.N_cv+1]= sm(Re_crit+Re_tol,Re_crit-Re_tol,Re[geo.N_cv+1])*12.86/max(Re[geo.N_cv+1]^Modelica.Math.log10(15.29/max(Re[geo.N_cv+1]^0.0567,MIN)),MIN)+
        //                          sm(Re_crit-Re_tol,Re_crit+Re_tol,Re[geo.N_cv+1])*0.00476;
        C_ast[geo.N_cv + 1] = sm(
          Re_crit + Re_tol,
          Re_crit - Re_tol,
          Re[geo.N_cv + 1])*7.41/max(Re[geo.N_cv + 1]^Modelica.Math.log10(14.3/max(Re[geo.N_cv + 1]^0.05, MIN)), MIN) + sm(
          Re_crit - Re_tol,
          Re_crit + Re_tol,
          Re[geo.N_cv + 1])*0.00476;
      else
        C_ast[geo.N_cv + 1] = 0.00476;
      end if;

    else
      Delta_p_u[geo.N_cv + 1] = 0;
      tau_wu[geo.N_cv + 1] = 0;
      k_B[geo.N_cv + 1] = 0;
      Re[geo.N_cv + 1] = 0;
      C_ast[geo.N_cv + 1] = 0;
    end if;

  else
    Delta_p_u = zeros(geo.N_cv + 1);
    tau_wu = zeros(geo.N_cv + 1);
    k_B = zeros(geo.N_cv + 1);
    Re = zeros(geo.N_cv + 1);
    C_ast = zeros(geo.N_cv + 1);
  end if;

//-------------------------------------------
//pressure drop due to momentum current, friction, gravity

  Delta_p_fric= pressureLoss.Delta_p;
  Delta_p_inlet=fluidInlet.d*w_inlet*abs(w_inlet)/2*Zeta_in;
  Delta_p_outlet=fluidOutlet.d*w_outlet*abs(w_outlet)/2*Zeta_out;

  if geo.N_cv==1 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = 0;
      Delta_p_adv[1] = 0;
      Delta_p_adv[2] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = rho_FM[2]*g_n*(geo.z_out - geo.z_in);
      Delta_p_adv[1] = 0;
      Delta_p_adv[2] = w_inlet*abs(w_inlet)*fluidInlet.d -w_outlet*abs(w_outlet)*fluidOutlet.d;
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = rho_FM[1]*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[2] = 0;
      Delta_p_adv[1] = w_inlet*abs(w_inlet)*fluidInlet.d -w_outlet*abs(w_outlet)*fluidOutlet.d;
      Delta_p_adv[2] = 0;
    else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] = rho_FM[1]*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = rho_FM[2]*g_n*(geo.z_out - geo.z[1]);
      Delta_p_adv[1] = w_inlet*abs(w_inlet)*fluidInlet.d - (sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*abs(sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*fluid[1].d;
      Delta_p_adv[2] = (sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*abs(sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*fluid[1].d -w_outlet*abs(w_outlet)*fluidOutlet.d;
    end if;
  elseif geo.N_cv==2 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = rho_FM[2]*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[3] = 0;
      Delta_p_adv[1] = 0;
      Delta_p_adv[2] = w_inlet*abs(w_inlet)*fluidInlet.d -w_outlet*abs(w_outlet)*fluidOutlet.d;
      Delta_p_adv[3] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (rho_FM[2]*geo.Delta_x_FM[2] + rho_FM[1]*geo.Delta_x_FM[1])/(geo.Delta_x_FM[1]+geo.Delta_x_FM[2])*g_n*(geo.z[2] - geo.z_in);
      Delta_p_grav[3] = rho_FM[3]*g_n*(geo.z_out - geo.z[2]);
      Delta_p_adv[1] = 0;
      Delta_p_adv[2] = w_inlet*abs(w_inlet)*fluidInlet.d - (sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*abs(sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*fluid[2].d;
      Delta_p_adv[3] = (sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*abs(sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*fluid[2].d -w_outlet*abs(w_outlet)*fluidOutlet.d;
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = rho_FM[1]*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (rho_FM[2]*geo.Delta_x_FM[2] + rho_FM[3]*geo.Delta_x_FM[3])/(geo.Delta_x_FM[3]+geo.Delta_x_FM[2])*g_n*(geo.z_out - geo.z[1]);
      Delta_p_grav[3] = 0;
      Delta_p_adv[1] = w_inlet*abs(w_inlet)*fluidInlet.d - (sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*abs(sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*fluid[1].d;
      Delta_p_adv[2] = (sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*abs(sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*fluid[1].d -w_outlet*abs(w_outlet)*fluidOutlet.d;
      Delta_p_adv[3] = 0;
    else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] = rho_FM[1]*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = rho_FM[2]*g_n*(geo.z[2] - geo.z[1]);
      Delta_p_grav[3] = rho_FM[3]*g_n*(geo.z_out - geo.z[2]);
      Delta_p_adv[1] = w_inlet*abs(w_inlet)*fluidInlet.d - (sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*abs(sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*fluid[1].d;
      Delta_p_adv[2] = (sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*abs(sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*fluid[1].d - (sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*abs(sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*fluid[2].d;
      Delta_p_adv[3] = (sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*abs(sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*fluid[2].d - w_outlet*abs(w_outlet)*fluidOutlet.d;
    end if;
  else
    if advectivePressureLoss==true then
    for i in 3:geo.N_cv-1 loop
      Delta_p_grav[i] = rho_FM[i]*g_n*(geo.z[i] - geo.z[i-1]);
      Delta_p_adv[i]=(sm(0,1,pressureAdvCalc)*w_up[i-1]+sm(1,0,pressureAdvCalc)*w[i-1])*abs(sm(0,1,pressureAdvCalc)*w_up[i-1]+sm(1,0,pressureAdvCalc)*w[i-1])*fluid[i-1].d - (sm(0,1,pressureAdvCalc)*w_up[i]+sm(1,0,pressureAdvCalc)*w[i])*abs(sm(0,1,pressureAdvCalc)*w_up[i]+sm(1,0,pressureAdvCalc)*w[i])*fluid[i].d;
    end for;

    if frictionAtInlet then
      Delta_p_grav[1] = rho_FM[1]*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = rho_FM[2]*g_n*(geo.z[2] - geo.z[1]);
      Delta_p_adv[1] = w_inlet*abs(w_inlet)*fluidInlet.d - (sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*abs(sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*fluid[1].d;
      Delta_p_adv[2] = (sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*abs(sm(0,1,pressureAdvCalc)*w_up[1]+sm(1,0,pressureAdvCalc)*w[1])*fluid[1].d - (sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*abs(sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*fluid[2].d;
    else
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (rho_FM[2]*geo.Delta_x_FM[2] + rho_FM[1]*geo.Delta_x_FM[1])/(geo.Delta_x_FM[1]+geo.Delta_x_FM[2])*g_n*(geo.z[2] - geo.z_in);
      Delta_p_adv[1] = 0;
      Delta_p_adv[2] = w_inlet*abs(w_inlet)*fluidInlet.d - (sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*abs(sm(0,1,pressureAdvCalc)*w_up[2]+sm(1,0,pressureAdvCalc)*w[2])*fluid[2].d;
    end if;

    if frictionAtOutlet then
      Delta_p_grav[geo.N_cv+1] = rho_FM[geo.N_cv+1]*g_n*(geo.z_out - geo.z[geo.N_cv]);
      Delta_p_grav[geo.N_cv]   = rho_FM[geo.N_cv]*g_n*(geo.z[geo.N_cv] - geo.z[geo.N_cv-1]);
      Delta_p_adv[geo.N_cv] = (sm(0,1,pressureAdvCalc)*w_up[geo.N_cv-1]+sm(1,0,pressureAdvCalc)*w[geo.N_cv-1])*abs(sm(0,1,pressureAdvCalc)*w_up[geo.N_cv-1]+sm(1,0,pressureAdvCalc)*w[geo.N_cv-1])*fluid[geo.N_cv-1].d - (sm(0,1,pressureAdvCalc)*w_up[geo.N_cv]+sm(1,0,pressureAdvCalc)*w[geo.N_cv])*abs(sm(0,1,pressureAdvCalc)*w_up[geo.N_cv]+sm(1,0,pressureAdvCalc)*w[geo.N_cv])*fluid[geo.N_cv].d;
      Delta_p_adv[geo.N_cv+1] = (sm(0,1,pressureAdvCalc)*w_up[geo.N_cv]+sm(1,0,pressureAdvCalc)*w[geo.N_cv])*abs(sm(0,1,pressureAdvCalc)*w_up[geo.N_cv]+sm(1,0,pressureAdvCalc)*w[geo.N_cv])*fluid[geo.N_cv].d -w_outlet*abs(w_outlet)*fluidOutlet.d;
    else
      Delta_p_grav[geo.N_cv+1] = 0;
      Delta_p_grav[geo.N_cv] = (rho_FM[geo.N_cv]*geo.Delta_x_FM[geo.N_cv] + rho_FM[geo.N_cv+1]*geo.Delta_x_FM[geo.N_cv+1])/(geo.Delta_x_FM[geo.N_cv+1]+geo.Delta_x_FM[geo.N_cv])*g_n*(geo.z_out - geo.z[geo.N_cv-1]);
      Delta_p_adv[geo.N_cv] = (sm(0,1,pressureAdvCalc)*w_up[geo.N_cv-1]+sm(1,0,pressureAdvCalc)*w[geo.N_cv-1])*abs(sm(0,1,pressureAdvCalc)*w_up[geo.N_cv-1]+sm(1,0,pressureAdvCalc)*w[geo.N_cv-1])*fluid[geo.N_cv-1].d -w_outlet*abs(w_outlet)*fluidOutlet.d;
      Delta_p_adv[geo.N_cv+1] = 0;
    end if;
    else
    for i in 3:geo.N_cv-1 loop
      Delta_p_grav[i] = rho_FM[i]*g_n*(geo.z[i] - geo.z[i-1]);
      Delta_p_adv[i]=0;
    end for;

    if frictionAtInlet then
      Delta_p_grav[1] = rho_FM[1]*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = rho_FM[2]*g_n*(geo.z[2] - geo.z[1]);
      Delta_p_adv[1] = 0;
      Delta_p_adv[2] = 0;
    else
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (rho_FM[2]*geo.Delta_x_FM[2] + rho_FM[1]*geo.Delta_x_FM[1])/(geo.Delta_x_FM[1]+geo.Delta_x_FM[2])*g_n*(geo.z[2] - geo.z_in);
      Delta_p_adv[1] = 0;
      Delta_p_adv[2] = 0;
    end if;

    if frictionAtOutlet then
      Delta_p_grav[geo.N_cv+1] = rho_FM[geo.N_cv+1]*g_n*(geo.z_out - geo.z[geo.N_cv]);
      Delta_p_grav[geo.N_cv]   = rho_FM[geo.N_cv]*g_n*(geo.z[geo.N_cv] - geo.z[geo.N_cv-1]);
      Delta_p_adv[geo.N_cv] = 0;
      Delta_p_adv[geo.N_cv+1] = 0;
    else
      Delta_p_grav[geo.N_cv+1] = 0;
      Delta_p_grav[geo.N_cv] = (rho_FM[geo.N_cv]*geo.Delta_x_FM[geo.N_cv] + rho_FM[geo.N_cv+1]*geo.Delta_x_FM[geo.N_cv+1])/(geo.Delta_x_FM[geo.N_cv+1]+geo.Delta_x_FM[geo.N_cv])*g_n*(geo.z_out - geo.z[geo.N_cv-1]);
      Delta_p_adv[geo.N_cv] = 0;
      Delta_p_adv[geo.N_cv+1] = 0;
    end if;
    end if;
  end if;

//-------------------------------------------
//Enthalpy flows
  for i in 2:geo.N_cv loop
    H_flow[i] = if useHomotopy then homotopy(semiLinear(
      m_flow[i],
      mechanicalEquilibrium.h[i - 1],
      mechanicalEquilibrium.h[i]), mechanicalEquilibrium.h[i - 1]*m_flow_nom) else semiLinear(
      m_flow[i],
      mechanicalEquilibrium.h[i - 1],
      mechanicalEquilibrium.h[i]);
  end for;
  H_flow[1] = if useHomotopy then homotopy(semiLinear(
    m_flow[1],
    h_in,
    mechanicalEquilibrium.h[1]), inStream(inlet.h_outflow)*m_flow_nom) else semiLinear(
    m_flow[1],
    h_in,
    mechanicalEquilibrium.h[1]);
  H_flow[geo.N_cv + 1] = if useHomotopy then homotopy(semiLinear(
    m_flow[geo.N_cv + 1],
    mechanicalEquilibrium.h[geo.N_cv],
    h_out), mechanicalEquilibrium.h[geo.N_cv]*m_flow_nom) else semiLinear(
    m_flow[geo.N_cv + 1],
    mechanicalEquilibrium.h[geo.N_cv],
    h_out);
//-------------------------------------------
//Fluid mass in cells
 // mass = if useHomotopy then homotopy(volume.*fluid.d, volume.*rho_nom) else volume.*fluid.d;
    mass = if useHomotopy then homotopy(geo.volume .* mechanicalEquilibrium.rho_mix, geo.volume .* rho_nom) else geo.volume .* mechanicalEquilibrium.rho_mix;
   // mass = volume.*rho_sat;
//-------------------------------------------
// definition of the cells' states:
// Energy balance without flow of potential/kinetic energy through cell borders
  for i in 1:2 loop
    volume_cavity_help[i]=if noEvent(volume_cavity[i] < 0) then 0 else volume_cavity[i];
  end for;
  volume = cat(1, {geo.volume[1] - max(0,1*volume_cavity_help[1])},  geo.volume[2:end-1],{ geo.volume[geo.N_cv] - max(0,1*volume_cavity_help[2])});
  for i in 1:geo.N_cv loop
     der(h[i])= (H_flow[i]- H_flow[i+1]
                 + heat[i].Q_flow
                 + der(p[i])*volume[i]
                 - h[i]*volume[i]*drhodt[i]
                 - mechanicalEquilibrium.rho_mix[i]*h[i]* der(volume[i])
                 + max(p[i],p_sat[i])*der(volume[i]))
                  /mass[i];
                 //+ sm(p_sat[i],p_sat[i]-10,p[i])*der(p[i])*volume[i]
//                  -dE_kin_dt_[i]
//                  -dE_pot_dt_[i]
//                 + m_flow[i]*(w_FM[i]^2/2+zFM[i]*g_n)
//                 - m_flow[i+1]*(w_FM[i+1]^2/2+zFM[i+1]*g_n)

    der(xi[i, :]) = 1/mass[i]*((Xi_flow[i, :] -  m_flow[i]*xi[i, :]) - (Xi_flow[i + 1, :] - m_flow[i+1]*xi[i, :])) "Component mass balance";

   // Mass balance with option of limit of mass change
   if limitMassChange then
     drhodt[i] * volume[i]=max(-massChangeLimit*mass[i],min(massChangeLimit*mass[i],m_flow[i]-m_flow[i+1]-mechanicalEquilibrium.rho_mix[i].*der(volume[i])));
   else
    //drhodt[i] *geo.volume[i]=m_flow[i]-m_flow[i+1];
    drhodt[i]*volume[i]=m_flow[i]-m_flow[i+1] - mechanicalEquilibrium.rho_mix[i].*der(volume[i]);
   end if;

    //original without a_corr
    //fluid[i].drhodp_hxi*der(p[i])=(drhodt[i]-der(h[i])*fluid[i].drhodh_pxi- sum({fluid[i].drhodxi_ph[j]*der(xi[i, j]) for j in 1:medium.nc - 1})) "Calculate pressure from enthalpy and density derivative";
    //with a_corr and assumed 1/a_clara^2=fluid[i].drhodp_hxi which is valid for small temperature differnces and away for 2-phase flow
    //fluid[i].drhodp_hxi*a_corr[i]^(-2)*der(p[i])=(drhodt[i]-der(h[i])*fluid[i].drhodh_pxi) "Calculate pressure from enthalpy and density derivative";
    //with a_corr and assumed 1/a_clara^2=fluid[i].drhodp_hxi+1/fluid[i].d*fluid[i].drhodh_pxi
    //(fluid[i].drhodp_hxi+1/fluid[i].d*fluid[i].drhodh_pxi)*a_corr[i]^(-2)*(der(p[i])*1/fluid[i].d+der(h[i]))-(fluid[i].drhodp_hxi*der(h[i])+1/(fluid[i].d^2)*fluid[i].drhodh_pxi*der(p[i]))=1/fluid[i].d*drhodt[i];
    //drhodt[i]=(fluid[i].drhodp_hxi+1/fluid[i].d*fluid[i].drhodh_pxi)*a_corr[i]^(-2)*der(p[i])+fluid[i].drhodh_pxi*(-1/fluid[i].d*der(p[i])+der(h[i]));
    drhodt[i]=(fluid[1].drhodp_hxi+1/mechanicalEquilibrium.rho_mix[i]*fluid[1].drhodh_pxi)*a_corr[i]^(-2)*der(p[i])+fluid[1].drhodh_pxi*(-1/mechanicalEquilibrium.rho_mix[i]*der(p[i])+der(h[i])) + sum({fluid[i].drhodxi_ph[j]*der(xi[i, j]) for j in 1:medium.nc - 1});

//     dE_pot_dt[i]=drhodt[i]*geo.volume[i]*g_n*geo.z[i];//time derivative of potential energy
//     dE_kin_dt[i]=drhodt[i]*geo.volume[i]/2*(m_flow[i]/(fluid[i].d*geo.A_cross[i]))^2
//                  + mass[i]*m_flow[i]/(fluid[i].d*geo.A_cross[i])*(der(m_flow[i])/(fluid[i].d*geo.A_cross[i])-m_flow[i]/geo.A_cross[i]*drhodt[i]/fluid[i].d^2);
//     E_kin[i]=(m_flow[i]/(fluid[i].d*geo.A_cross[i]))^2*mass[i]/2;
//     E_pot[i]=mass[i]*g_n*geo.z[i];

  end for;

//-------------------------------------------
// Dynamic momentum balance:
//
//if useHomotopy then homotopy(p[i-1] - p[i] + Delta_p_adv[i]- Delta_p_fric[i] -Delta_p_grav[i],0)
// notice that in contrast to the simple L4 pipe for the dynamic momentuim balance this homoptopy relation is non  trivial and implies steady state start up.
   for i in 2:geo.N_cv loop
      Delta_p_suppFreqCorr[i]=suppFreqCorr*der(p[i-1])*geo.Delta_x[i-1]/fluid[i-1].w/a_corr[i-1]/2 - suppFreqCorr*der(p[i])*geo.Delta_x[i]/fluid[i].w/a_corr[i]/2;
//    geo.Delta_x_FM[i]/geo.A_cross_FM[i]*der(m_flow[i]) =if useHomotopy then homotopy(p[i-1] - p[i] + Delta_p_adv[i]- Delta_p_fric[i] -Delta_p_grav[i],0) else p[i-1] - p[i] + Delta_p_adv[i]- Delta_p_fric[i] -Delta_p_grav[i];
      geo.Delta_x_FM[i]/geo.A_cross_FM[i]*der(m_flow[i]) =if useHomotopy then
                          homotopy(max(p[i-1],p_sat[i-1])+suppFreqCorr*der(p[i-1])*geo.Delta_x[i-1]/fluid[i-1].w/a_corr[i-1]/2 - max(p[i],p_sat[i])-suppFreqCorr*der(p[i])*geo.Delta_x[i]/fluid[i].w/a_corr[i]/2 + Delta_p_adv[i]- Delta_p_fric[i] - Delta_p_u[i] - Delta_p_grav[i],0)
                        else
                          max(p[i-1],p_sat[i-1])+suppFreqCorr*der(p[i-1])*geo.Delta_x[i-1]/fluid[i-1].w/a_corr[i-1]/2 - max(p[i],p_sat[i])-suppFreqCorr*der(p[i])*geo.Delta_x[i]/fluid[i].w/a_corr[i]/2 + Delta_p_adv[i]- Delta_p_fric[i] - Delta_p_u[i] - Delta_p_grav[i];
   end for;
  inlet.h_outflow = mechanicalEquilibrium.h[1];
  outlet.h_outflow = mechanicalEquilibrium.h[geo.N_cv];

if not frictionAtInlet and not frictionAtOutlet then
  inlet.p = fluid[1].p;
  outlet.p= fluid[geo.N_cv].p;
  Delta_p_suppFreqCorr[1]=0;
  Delta_p_suppFreqCorr[geo.N_cv+1]=0;

elseif frictionAtInlet and not frictionAtOutlet then
  geo.Delta_x_FM[1]/geo.A_cross_FM[1]*der(m_flow[1]) = if useHomotopy then homotopy(inlet.p +suppFreqCorr*der(inlet.p)*geo.Delta_x_FM[1]/fluidInlet.w/a_corr_inlet/2 - max(p[1],p_sat[1]) -suppFreqCorr*der(p[1])*geo.Delta_x_FM[1]/fluid[1].w/a_corr[1]/2 + Delta_p_adv[1]- Delta_p_fric[1] - Delta_p_u[1]- Delta_p_grav[1] - Delta_p_inlet,0)
 else
     inlet.p +suppFreqCorr*der(inlet.p)*geo.Delta_x_FM[1]/fluidInlet.w/a_corr_inlet/2 - max(p[1],p_sat[1]) -suppFreqCorr*der(p[1])*geo.Delta_x[1]/fluid[1].w/a_corr[1]/2 + Delta_p_adv[1]- Delta_p_fric[1] - Delta_p_u[1] - Delta_p_grav[1] - Delta_p_inlet;
  // inlet.p = fluid[1].p;
  outlet.p= fluid[geo.N_cv].p;
  Delta_p_suppFreqCorr[1]=suppFreqCorr*der(inlet.p)*geo.Delta_x_FM[1]/fluidInlet.w/a_corr_inlet/2 -suppFreqCorr*der(p[1])*geo.Delta_x[1]/fluid[1].w/a_corr[1]/2;
  Delta_p_suppFreqCorr[geo.N_cv+1]=0;

elseif  not frictionAtInlet and frictionAtOutlet then
  geo.Delta_x_FM[geo.N_cv+1]/geo.A_cross_FM[geo.N_cv+1]*der(m_flow[geo.N_cv+1]) =
         if useHomotopy then homotopy(max(p[geo.N_cv],p_sat[geo.N_cv]) + suppFreqCorr*der(p[geo.N_cv])*geo.Delta_x[geo.N_cv]/fluid[geo.N_cv].w/a_corr[geo.N_cv]/2 - outlet.p - suppFreqCorr*der(outlet.p)*geo.Delta_x_FM[geo.N_cv+1]/fluidOutlet.w/a_corr_outlet/2 + Delta_p_adv[geo.N_cv+1]- Delta_p_fric[geo.N_cv+1] - Delta_p_u[geo.N_cv+1] -Delta_p_grav[geo.N_cv+1] - Delta_p_outlet,0)
         else max(p[geo.N_cv],p_sat[geo.N_cv]) + suppFreqCorr*der(p[geo.N_cv])*geo.Delta_x[geo.N_cv]/fluid[geo.N_cv].w/a_corr[geo.N_cv]/2 - outlet.p - suppFreqCorr*der(outlet.p)*geo.Delta_x_FM[geo.N_cv+1]/fluidOutlet.w/a_corr_outlet/2 + Delta_p_adv[geo.N_cv+1]- Delta_p_fric[geo.N_cv+1] - Delta_p_u[geo.N_cv+1] -Delta_p_grav[geo.N_cv+1] - Delta_p_outlet;
  inlet.p = fluid[1].p;
  Delta_p_suppFreqCorr[1]=0;
  Delta_p_suppFreqCorr[geo.N_cv+1]=suppFreqCorr*der(p[geo.N_cv])*geo.Delta_x[geo.N_cv]/fluid[geo.N_cv].w/a_corr[geo.N_cv]/2 - suppFreqCorr*der(outlet.p)*geo.Delta_x_FM[geo.N_cv+1]/fluidOutlet.w/a_corr_outlet/2;
  //outlet.p= fluid[geo.N_cv].p;

else //inlet_dp_innerPipe_dp_outlet
  geo.Delta_x_FM[1]/geo.A_cross_FM[1]*der(m_flow[1]) = if useHomotopy then homotopy(inlet.p +suppFreqCorr*der(inlet.p)*geo.Delta_x_FM[1]/fluidInlet.w/a_corr_inlet/2 - max(p[1],p_sat[1]) -suppFreqCorr*der(p[1])*geo.Delta_x_FM[1]/fluid[1].w/a_corr[1]/2+ Delta_p_adv[1]- Delta_p_fric[1] - Delta_p_u[1] -Delta_p_grav[1]  - Delta_p_inlet,0)
         else inlet.p +suppFreqCorr*der(inlet.p)*geo.Delta_x_FM[1]/fluidInlet.w/a_corr_inlet/2 - max(p[1],p_sat[1]) -suppFreqCorr*der(p[1])*geo.Delta_x[1]/fluid[1].w/a_corr[1]/2+ Delta_p_adv[1]- Delta_p_fric[1] - Delta_p_u[1] -Delta_p_grav[1] - Delta_p_inlet;
  geo.Delta_x_FM[geo.N_cv+1]/geo.A_cross_FM[geo.N_cv+1]*der(m_flow[geo.N_cv+1]) =
         if useHomotopy then homotopy(max(p[geo.N_cv],p_sat[geo.N_cv]) + suppFreqCorr*der(p[geo.N_cv])*geo.Delta_x[geo.N_cv]/fluid[geo.N_cv].w/a_corr[geo.N_cv]/2 - outlet.p - suppFreqCorr*der(outlet.p)*geo.Delta_x_FM[geo.N_cv+1]/fluidOutlet.w/a_corr_outlet/2 + Delta_p_adv[geo.N_cv+1]- Delta_p_fric[geo.N_cv+1] - Delta_p_u[geo.N_cv+1] -Delta_p_grav[geo.N_cv+1] - Delta_p_outlet,0)
         else max(p[geo.N_cv],p_sat[geo.N_cv]) + suppFreqCorr*der(p[geo.N_cv])*geo.Delta_x[geo.N_cv]/fluid[geo.N_cv].w/a_corr[geo.N_cv]/2 - outlet.p - suppFreqCorr*der(outlet.p)*geo.Delta_x_FM[geo.N_cv+1]/fluidOutlet.w/a_corr_outlet/2 + Delta_p_adv[geo.N_cv+1]- Delta_p_fric[geo.N_cv+1] - Delta_p_u[geo.N_cv+1] -Delta_p_grav[geo.N_cv+1] - Delta_p_outlet;
  Delta_p_suppFreqCorr[1]=suppFreqCorr*der(inlet.p)*geo.Delta_x_FM[1]/fluidInlet.w/a_corr_inlet/2 -suppFreqCorr*der(p[1])*geo.Delta_x[1]/fluid[1].w/a_corr[1]/2;
  Delta_p_suppFreqCorr[geo.N_cv+1]=suppFreqCorr*der(p[geo.N_cv])*geo.Delta_x[geo.N_cv]/fluid[geo.N_cv].w/a_corr[geo.N_cv]/2 - suppFreqCorr*der(outlet.p)*geo.Delta_x_FM[geo.N_cv+1]/fluidOutlet.w/a_corr_outlet/2 + Delta_p_adv[geo.N_cv+1];
end if;



//-------------------------------------------
//Speed of sound correction term
//
//taking pipe material properties into account

if not exportToFMU then
  for i in 1:geo.N_cv loop
    K[i] = fluid[i].w^2*fluid[i].d;
    a_corr[i] = (1-userDefinedSpeedOfSoundPreFactor) *( useStiffWallPreFactor * 1 + (1-useStiffWallPreFactor)*((1/(1 + K[i]/E*geo.diameter_hyd[i]/e*c_1[i]))^0.5))
                  +userDefinedSpeedOfSoundPreFactor    *a_def/fluid[i].w;
       c_1[i] = 2*e/geo.diameter_hyd[i]*(1 + my) + geo.diameter_hyd[i]*(1 - my^2)/(geo.diameter_hyd[i] + e);
  end for;
    K_inlet = fluidInlet.w^2*fluidInlet.d;
    K_outlet = fluidOutlet.w^2*fluidOutlet.d;
    a_corr_inlet = (1-userDefinedSpeedOfSoundPreFactor)  *( useStiffWallPreFactor * 1 + (1-useStiffWallPreFactor)*((1/(1 + K_inlet/E*geo.diameter_hyd[1]/e*c_1[1]))^0.5))
                    +userDefinedSpeedOfSoundPreFactor    * a_def/fluidInlet.w;
    a_corr_outlet = (1-userDefinedSpeedOfSoundPreFactor) *( useStiffWallPreFactor * 1 + (1-useStiffWallPreFactor)*((1/(1 + K_outlet/E*geo.diameter_hyd[geo.N_cv]/e*c_1[geo.N_cv]))^0.5))
                     +userDefinedSpeedOfSoundPreFactor   * a_def/fluidOutlet.w;
else
  for i in 1:geo.N_cv loop
    K[i] = fluid[i].w^2*fluid[i].d;
    if userDefinedSpeedOfSound == false then
      a_corr[i] = if useStiffWall then 1 else (1/(1 + K[i]/E*geo.diameter_hyd[i]/e*c_1[i]))^0.5;
    else
      a_corr[i] = a_def/fluid[i].w;
    end if;
    c_1[i] = 2*e/geo.diameter_hyd[i]*(1 + my) + geo.diameter_hyd[i]*(1 - my^2)/(geo.diameter_hyd[i] + e);
  end for;
  K_inlet = fluidInlet.w^2*fluidInlet.d;
  K_outlet = fluidOutlet.w^2*fluidOutlet.d;
  if userDefinedSpeedOfSound == false then
    a_corr_inlet = if useStiffWall then 1 else (1/(1 + K_inlet/E*geo.diameter_hyd[1]/e*c_1[1]))^0.5;
    a_corr_outlet = if useStiffWall then 1 else (1/(1 + K_outlet/E*geo.diameter_hyd[geo.N_cv]/e*c_1[geo.N_cv]))^0.5;
  else
    a_corr_inlet = a_def/fluidInlet.w;
    a_corr_outlet = a_def/fluidOutlet.w;
  end if;
end if;

//-------------------------------------------
//VCM
  der(volume_cavity[1])=sm(p_sat[1],p_sat[1]+10,p[1])*(m_flow[2]/rho_FM[2]-m_flow[1]/rho_FM[1]);
  der(volume_cavity[2])=sm(p_sat[geo.N_cv],p_sat[geo.N_cv]+10,p[geo.N_cv])*(m_flow[geo.N_cv+1]/rho_FM[geo.N_cv+1]-m_flow[geo.N_cv]/rho_FM[geo.N_cv]);

// limitation to saturation properties
  der(T_ps) = (iCom.T-T_ps)/Tau_T_ps;
//  p_sat = {TILMedia.VLEFluidFunctions.bubblePressure_Txi(medium,T_ps[i],xi[i]) for i in 1:geo.N_cv};
  p_sat ={TILMedia.VLEFluid.MixtureCompatible.Functions.bubblePressure_Txi(
    medium,
    T_ps[i],
    xi[i]) for i in 1:geo.N_cv};
  //p_sat = {TILMedia.VLEFluid.MixtureCompatible.Functions.bubblePressure_Txi(medium,T_ps[i],xi[i]) for i in 1:geo.N_cv};
  //   p_sat = {TILMedia.VLEFluidObjectFunctions.bubblePressure_Txi(T_ps[i],iCom.xi[i],iCom.fluidPointer[i]) for i in 1:geo.N_cv};

//species balance

   for i in 2:geo.N_cv loop
     Xi_flow[i, :] = if useHomotopy then homotopy(semiLinear(
       m_flow[i],
       (xi[i - 1, :]),
       (xi[i, :])), (xi[i - 1, :])*m_flow_nom) else semiLinear(
       m_flow[i],
       (xi[i - 1, :]),
       (xi[i, :]));
   end for;
   Xi_flow[1, :] = if useHomotopy then homotopy(semiLinear(
     m_flow[1],
     (fluidInlet.xi[:]),
     (xi[1, :])), (fluidInlet.xi[:])*m_flow_nom) else semiLinear(
     m_flow[1],
     (fluidInlet.xi[:]),
     (xi[1, :]));
   Xi_flow[geo.N_cv + 1, :] = if useHomotopy then homotopy(semiLinear(
     m_flow[geo.N_cv + 1],
     (xi[geo.N_cv, :]),
     (fluidOutlet.xi[:])), (xi[geo.N_cv, :])*m_flow_nom) else semiLinear(
     m_flow[geo.N_cv + 1],
     (xi[geo.N_cv, :]),
     (fluidOutlet.xi[:]));
  inlet.xi_outflow[:] = xi[1, :];
  outlet.xi_outflow[:] = xi[geo.N_cv, :];

  xi_inlet = noEvent(actualStream(inlet.xi_outflow));
  xi_outlet = noEvent(actualStream(outlet.xi_outflow));
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
ClaRa development team, Copyright &copy; 2017 - 2025.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p> This component was developed for ClaRa library.</p>
<p><b>Acknowledgements:</b> </p>
<p><b>CLA:</b> </p>

</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{140,50}}), graphics={
        Line(
          points={{-106,32},{-106,-32},{-44,-32}},
          color={0,131,169}),
        Line(
          points={{-106,0},{-100,0},{-98,-30},{-96,-32},{-94,56},{-92,-56},{-90,54},{-88,-50},{-86,44},{-84,-42},{-82,34},{-80,-30},{-78,26},{-76,-24},{-74,14},{-72,-12},{-70,8},{-68,-6},{-66,6},{-64,-4},{-62,4},{-60,-2},{-58,2},{-56,0},{-44,0}},
          color={0,131,169},
          smooth=Smooth.Bezier)}),                                                          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{140,50}}), graphics));
end VolumeVLE_L4_Advanced_WH_VCM;
