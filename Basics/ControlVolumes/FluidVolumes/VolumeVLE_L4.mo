within ClaRa.Basics.ControlVolumes.FluidVolumes;
model VolumeVLE_L4 "A 1D tube-shaped control volume considering one-phase and two-phase heat transfer in a straight pipe with static momentum balance and simple energy balance."
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

  extends ClaRa.Basics.Icons.Volume_L4;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  import SI = ClaRa.Basics.Units;
  import Modelica.Constants.eps;
  import Modelica.Constants.g_n "gravity constant";
  import ClaRa.Basics.Functions.Stepsmoother;

  outer ClaRa.SimCenter simCenter;

  //## S U M M A R Y   D E F I N I T I O N #######################################################################
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation (Dialog(hide));

    input Units.Volume volume_tot "Total volume of system" annotation (Dialog(show));

    parameter Integer N_cv "Number of finite volumes" annotation(Dialog(group="Discretisation"));

    input ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference between outlet and inlet" annotation (Dialog);
    input Units.Mass mass_tot "Total fluid mass in system mass" annotation (Dialog(show));
    input Units.Enthalpy H_tot        if showExpertSummary "Total system enthalpy" annotation (Dialog(show));
    input Units.HeatFlowRate Q_flow_tot "Heat flow through entire pipe wall" annotation (Dialog);

    input Units.Mass mass[N_cv]        if showExpertSummary "Fluid mass in cells" annotation (Dialog(show));
    input Units.Momentum I[N_cv + 1]        if showExpertSummary "Momentum of fluid flow volumes through cell borders" annotation (Dialog(show));
    input Units.Force I_flow[N_cv + 2]        if showExpertSummary "Momentum flow through cell borders" annotation (Dialog(show));
    input Units.MassFlowRate m_flow[N_cv + 1]        if showExpertSummary "Mass flow through cell borders" annotation (Dialog(show));
    input Units.Velocity w[N_cv + 1]        if showExpertSummary "Velocity of flow in cells" annotation (Dialog(show));
  end Outline;

  model Wall_L4
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation (Dialog(hide));
    parameter Integer N_wall "Number of wall segments" annotation (Dialog(hide));
    input Units.Temperature T[N_wall]        if showExpertSummary "Temperatures of wall segments" annotation (Dialog);
    input Units.HeatFlowRate Q_flow[N_wall]        if showExpertSummary "Heat flows through wall segments" annotation (Dialog);
  end Wall_L4;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE inlet;
    ClaRa.Basics.Records.FlangeVLE outlet;
    ClaRa.Basics.Records.FluidVLE_L34 fluid;
    Wall_L4 wall;
  end Summary;

  //____Media Data_____________________________________________________________________________________
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"));

  //____Physical Effects_____________________________________________________________________________________

public
  inner parameter Boolean frictionAtInlet=false "True if pressure loss between first cell and inlet shall be considered"
                                                                                            annotation (choices(checkBox=true),Dialog(group="Fundamental Definitions"));
  inner parameter Boolean frictionAtOutlet=false "True if pressure loss between last cell and outlet shall be considered"
                                                                                            annotation (choices(checkBox=true),Dialog(group="Fundamental Definitions"));

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4            constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model at the tubes side"
                                                                                            annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));

  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4                     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4 "Heat transfer mode at the tubes side"
                                                                                            annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));
  replaceable model Geometry =
      Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv                          constrainedby Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv "Pipe geometry"
                                                                                            annotation(choicesAllMatching,Dialog(group="Geometry"));
  replaceable model MechanicalEquilibrium = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.Homogeneous_L4
                                                                                                  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4
                                                                                                                                                                                         "Mechanical equilibrium model"
                                                                                             annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));
  //____Nominal Values_________________________________________________________________________________
public
  parameter Units.Pressure p_nom[geo.N_cv]=ones(geo.N_cv)*1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter Units.EnthalpyMassSpecific h_nom[geo.N_cv]=ones(geo.N_cv)*1e5 "Nominal specific enthalpy for single tube" annotation (Dialog(group="Nominal Values"));
  inner parameter Units.MassFlowRate m_flow_nom=100 "Nominal mass flow w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));
  inner parameter Units.PressureDifference Delta_p_nom=1e4 "Nominal pressure loss w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));
  final parameter Units.DensityMassSpecific rho_nom[geo.N_cv]=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
      medium,
      p_nom,
      h_nom) "Nominal density";

  //____Initialisation_____________________________________________________________________________________
  inner parameter Integer  initOption=0 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 208 "Steady pressure and enthalpy", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "true, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation",group="Model Settings"));
  parameter Units.EnthalpyMassSpecific h_start[geo.N_cv]=ones(geo.N_cv)*800e3 "Initial specific enthalpy for single tube" annotation (Dialog(tab="Initialisation"));
  parameter Units.Pressure p_start[geo.N_cv]=ones(geo.N_cv)*1e5 "Initial pressure" annotation (Dialog(tab="Initialisation"));
  parameter Units.MassFraction xi_start[medium.nc - 1]=zeros(medium.nc - 1) "Initial composition" annotation (Dialog(tab="Initialisation"));
protected
  parameter Units.Pressure p_start_internal[geo.N_cv]=if size(p_start, 1) == 2 then linspace(
      p_start[1],
      p_start[2],
      geo.N_cv) else p_start "Internal p_start array which allows the user to either state p_inlet, p_outlet if p_start has length 2, otherwise the user can specify an individual pressure profile for initialisation";
  //____Summary and Visualisation_____________________________________________________________________________________
public
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if an extended summary shall be shown, else false"
                                                                                                                           annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=false "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                                              annotation(Dialog(tab="Summary and Visualisation"));

  Summary summary(
    outline(
      showExpertSummary=showExpertSummary,
      N_cv=geo.N_cv,
      volume_tot=sum(geo.volume),
      Delta_p= inlet.p - outlet.p,
      mass_tot=sum(mass),
      H_tot=sum(h .* mass),
      Q_flow_tot=sum(heat.Q_flow),
      mass=mass,
      I=geo.Delta_x_FM .* m_flow,
      I_flow=cat(
          1,
          {w_inlet*abs(w_inlet)*fluidInlet.d*geo.A_cross[1]},
          {w[i]*abs(w[i])*fluid[i].d*geo.A_cross[i] for i in 1:geo.N_cv},
          {w_outlet*abs(w_outlet)*fluidOutlet.d*geo.A_cross[geo.N_cv]}),
      m_flow=m_flow,
      w=w_FM),
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=inlet.m_flow,
      T=fluidInlet.T,
      p=fluidInlet.p,
      h=fluidInlet.h,
      s=fluidInlet.s,
      steamQuality=fluidInlet.q,
      H_flow=H_flow[1],
      rho=fluidInlet.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOutlet.T,
      p=fluidOutlet.p,
      h=fluidOutlet.h,
      s=fluidOutlet.s,
      steamQuality=fluidOutlet.q,
      H_flow=H_flow[geo.N_cv + 1],
      rho=fluidOutlet.d),
    fluid(
      showExpertSummary=showExpertSummary,
      N_cv=geo.N_cv,
      mass=mass,
      T=fluid.T,
      T_sat=fluid.VLE.T_l,
      p=p,
      h=h,
      h_bub=fluid.VLE.h_l,
      h_dew=fluid.VLE.h_v,
      s=fluid.s,
      steamQuality=fluid.q,
      H=mass .* h,
      rho=fluid.d),
    wall(
      showExpertSummary=showExpertSummary,
      N_wall=geo.N_cv,
      T=heat.T,
      Q_flow=heat.Q_flow)) annotation (Placement(transformation(extent={{-60,-52},{-40,-34}})));

  //## V A R I A B L E   P A R T#######################################################################################

  //____Energy / Enthalpy_________________________________________________________________________________________
protected
  Units.EnthalpyMassSpecific h[geo.N_cv](start=h_start, each stateSelect=StateSelect.prefer) "Cell enthalpy";


  //____Pressure__________________________________________________________________________________________________
  Units.Pressure p[geo.N_cv](start=p_start_internal) "Cell pressure";
  Units.PressureDifference Delta_p_fric[geo.N_cv + 1] "Pressure difference due to friction";
  Units.PressureDifference Delta_p_grav[geo.N_cv + 1] "Pressure difference due to gravity";

  //____Mass and Density__________________________________________________________________________________________
  Units.Mass mass[geo.N_cv] "Mass of fluid in cells";
  Units.Mass mass_FM[geo.N_cv + 1]=cat(
      1,
      {mass[1]/2},
      {(mass[i] + mass[i - 1])/2 for i in 2:geo.N_cv},
      {mass[geo.N_cv]/2}) "Mass of fluid in flow cells";
  Real drhodt[geo.N_cv];
  //(unit="kg/(m3s)")

  Units.DensityMassSpecific[geo.N_cv + 1] rho_FM "Density at flow model states";

  Units.MassFraction steamQuality[geo.N_cv] "Steam fraction";
  Units.MassFraction steamQuality_inlet "Steam fraction";
  Units.MassFraction steamQuality_outlet "Steam fraction";


  //____Mass Fractions____________________________________________________________________________________________
  Modelica.Units.SI.MassFraction xi[geo.N_cv,medium.nc - 1] "Mass fraction";
  Real[geo.N_cv + 1, medium.nc - 1] Xi_flow "Mass flow rate of fraction";
  Modelica.Units.SI.MassFraction xi_inlet[medium.nc - 1] "Inlet mass fraction of component";
  Modelica.Units.SI.MassFraction xi_outlet[medium.nc - 1] "Outlet mass fraction of component";

  //____Flows and Velocities______________________________________________________________________________________
  Units.Power H_flow[geo.N_cv + 1] "Enthalpy flow rate at cell borders";
  Units.MassFlowRate m_flow[geo.N_cv + 1](start=ones(geo.N_cv + 1)*m_flow_nom, nominal=ones(geo.N_cv + 1)*m_flow_nom);        //JB: removed this from variable definition: "nominal=ones(geo.N_cv + 1)*m_flow_nom, "
  Units.Velocity w[geo.N_cv] "flow velocities within cells of energy model == flow velocities across cell borders of flow model ";
  Units.Velocity w_inlet "flow velocity at inlet";
  Units.Velocity w_outlet "flow velocity at outlet";
  Units.Velocity w_FM[geo.N_cv + 1] "flow velocities within cells of flow model == flow velocities across cell borders of energy model ";

  //____Connectors________________________________________________________________________________________________
public
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-150,-10},{-130,10}}), iconTransformation(extent={{-150,-10},{-130,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})));

  ClaRa.Basics.Interfaces.HeatPort_a heat[geo.N_cv] annotation (Placement(transformation(extent={{-10,30},{10,50}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));

  //___Instantiation of Replaceable Models___________________________________________________________________________
public
  PressureLoss pressureLoss "Pressure loss model" annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  HeatTransfer heatTransfer(A_heat=geo.A_heat_CF[:, 1]) "heat transfer model" annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  inner Geometry geo annotation (Placement(transformation(extent={{0,0},{20,20}})));
  MechanicalEquilibrium mechanicalEquilibrium(final h_start=h_start) "Mechanical equilibrium model" annotation (Placement(transformation(extent={{40,0},{60,20}})));

protected
  inner TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluid[geo.N_cv](
    each computeSurfaceTension=false,
    p=p,
    h=h,
    each vleFluidType=medium,
    each computeTransportProperties=true,
    xi=xi) annotation (Placement(transformation(extent={{-10,-40},{10,-20}}, rotation=0)));


  inner TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidInlet(
    computeSurfaceTension=false,
    p=inlet.p,
    vleFluidType=medium,
    h=noEvent(actualStream(inlet.h_outflow)),
    computeTransportProperties=true,
    xi=xi_inlet) annotation (Placement(transformation(extent={{-90,-30},{-70,-10}}, rotation=0)));

  inner TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOutlet(
    computeSurfaceTension=false,
    p=outlet.p,
    vleFluidType=medium,
    h=noEvent(actualStream(outlet.h_outflow)),
    computeTransportProperties=true,
    xi=xi_outlet) annotation (Placement(transformation(extent={{70,-30},{90,-10}}, rotation=0)));


  inner Basics.Records.IComVLE_L3_OnePort iCom(
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
    p=p,
    h=h,
    fluidPointer_in={fluidInlet.vleFluidPointer},
    fluidPointer_out={fluidOutlet.vleFluidPointer},
    fluidPointer=fluid.vleFluidPointer) annotation (Placement(transformation(extent={{-80,-52},{-60,-34}})));

  //### E Q U A T I O N P A R T #######################################################################################
  //-------------------------------------------

  //initialisation

initial equation
  if initOption == 208 then
    der(h) = zeros(geo.N_cv);
    der(p) = zeros(geo.N_cv);
  elseif initOption == 201 then
    der(p) = zeros(geo.N_cv);
  elseif initOption == 202 then
    der(h) = zeros(geo.N_cv);
  elseif initOption == 0 then
    // do nothing
  else
    assert(false, "Unknown init option in " + getInstanceName());
  end if;

  for i in 1:geo.N_cv loop
    xi[i, :] = xi_start[1:end];
  end for;
equation

  connect(heat, heatTransfer.heat) annotation (Line(
      points={{0,40},{0,28},{-61,28},{-61,19}},
      color={0,0,0},
      smooth=Smooth.None));

  //-------------------------------------------
  //steam quality at inlet and outlet
  steamQuality_inlet = fluidInlet.q;
  steamQuality_outlet = fluidOutlet.q;

  //flow velocities at inlet and outlet
  w_inlet = inlet.m_flow/(geo.A_cross_FM[1]*fluidInlet.d);
  w_outlet = -outlet.m_flow/(geo.A_cross_FM[geo.N_cv + 1]*fluidOutlet.d);

  for i in 1:geo.N_cv loop
  //flow velocities in energy cells
    w[i] = (m_flow[i] + m_flow[i + 1])/(2*fluid[i].d*geo.A_cross[i]);
  //steam quality in cells
  steamQuality[i] = fluid[i].q;
  end for;

  //flow velocities in flow model
  for i in 1:geo.N_cv+1 loop
     w_FM[i]=m_flow[i]/(geo.A_cross_FM[i]*rho_FM[i]);
  end for;

  //density in flow model
  for i in 2:geo.N_cv loop
    rho_FM[i]=(fluid[i].d+fluid[i-1].d)/2;
  end for;

  //density in first and last momentum cell
  rho_FM[1]=(fluidInlet.d+fluid[1].d)/2;
  rho_FM[geo.N_cv+1]=(fluidOutlet.d+fluid[geo.N_cv].d)/2;

  //-------------------------------------------
  //data exchange with friction model
  m_flow[1] = inlet.m_flow;
  m_flow = pressureLoss.m_flow;
  m_flow[geo.N_cv + 1] = -outlet.m_flow;

  //-------------------------------------------
  //data exchange with replaceable models
  heatTransfer.m_flow = m_flow;
  mechanicalEquilibrium.m_flow = m_flow;

  //pressure drop due to friction, gravity


  Delta_p_fric = pressureLoss.Delta_p;
  if geo.N_cv==1 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = fluid[1].d*g_n*(geo.z_out - geo.z_in);
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = fluid[1].d*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[2] = 0;
      else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] = fluid[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = fluid[1].d*g_n*(geo.z_out - geo.z[1]);
      end if;
  elseif geo.N_cv==2 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = fluid[2].d*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[3] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (fluid[1].d*geo.Delta_x[1] + fluid[2].d*geo.Delta_x[2]/2)/(geo.Delta_x[2]/2+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z_in);
      Delta_p_grav[3] = fluid[2].d*g_n*(geo.z_out - geo.z[2]);
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = fluid[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (fluid[2].d*geo.Delta_x[2] + fluid[1].d*geo.Delta_x[1]/2)/(geo.Delta_x[1]/2+geo.Delta_x[2])*g_n*(geo.z_out - geo.z[1]);
      Delta_p_grav[3] = 0;
      else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] = fluid[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (fluid[1].d*geo.Delta_x[1] + fluid[2].d*geo.Delta_x[2])/(geo.Delta_x[2]+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z[1]);
      Delta_p_grav[3] = fluid[2].d*g_n*(geo.z_out - geo.z[2]);
      end if;
  else
    for i in 3:geo.N_cv-1 loop
      Delta_p_grav[i] = (fluid[i].d*geo.Delta_x[i] + fluid[i - 1].d*geo.Delta_x[i - 1])/(geo.Delta_x[i - 1]+geo.Delta_x[i])*g_n*(geo.z[i] - geo.z[i-1]);
    end for;

    if frictionAtInlet then
      Delta_p_grav[1] = fluid[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] = (fluid[1].d*geo.Delta_x[1] + fluid[2].d*geo.Delta_x[2])/(geo.Delta_x[2]+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z[1]);
      else
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = (fluid[1].d*geo.Delta_x[1] + fluid[2].d*geo.Delta_x[2]/2)/(geo.Delta_x[2]/2+geo.Delta_x[1])*g_n*(geo.z[2] - geo.z_in);
      end if;

    if frictionAtOutlet then
      Delta_p_grav[geo.N_cv+1] = fluid[geo.N_cv].d*g_n*(geo.z_out - geo.z[geo.N_cv]);
      Delta_p_grav[geo.N_cv] = (fluid[geo.N_cv-1].d*geo.Delta_x[geo.N_cv-1] + fluid[geo.N_cv].d*geo.Delta_x[geo.N_cv])/(geo.Delta_x[geo.N_cv-1] + geo.Delta_x[geo.N_cv])*g_n*(geo.z[geo.N_cv] - geo.z[geo.N_cv-1]);
      else
      Delta_p_grav[geo.N_cv+1] = 0;
      Delta_p_grav[geo.N_cv] = (fluid[geo.N_cv-1].d*geo.Delta_x[geo.N_cv-1]/2 + fluid[geo.N_cv].d*geo.Delta_x[geo.N_cv])/(geo.Delta_x[geo.N_cv-1]/2+geo.Delta_x[geo.N_cv])*g_n*(geo.z_out - geo.z[geo.N_cv-1]);
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
    inStream(inlet.h_outflow),
    mechanicalEquilibrium.h[1]), inStream(inlet.h_outflow)*m_flow_nom) else semiLinear(
    m_flow[1],
    inStream(inlet.h_outflow),
    mechanicalEquilibrium.h[1]);
  H_flow[geo.N_cv + 1] = if useHomotopy then homotopy(semiLinear(
    m_flow[geo.N_cv + 1],
    mechanicalEquilibrium.h[geo.N_cv],
    inStream(outlet.h_outflow)), mechanicalEquilibrium.h[geo.N_cv]*m_flow_nom) else semiLinear(
    m_flow[geo.N_cv + 1],
    mechanicalEquilibrium.h[geo.N_cv],
    inStream(outlet.h_outflow));


  //-------------------------------------------
  //Fluid mass in cells
  mass = if useHomotopy then homotopy(geo.volume .* mechanicalEquilibrium.rho_mix, geo.volume .* rho_nom) else geo.volume .* mechanicalEquilibrium.rho_mix;

  //-------------------------------------------
  // definition of the cells' states:
  for i in 1:geo.N_cv loop

    der(h[i]) = (H_flow[i] - H_flow[i + 1] + heat[i].Q_flow + der(p[i])*geo.volume[i] - h[i]*geo.volume[i]*drhodt[i])/mass[i];
    der(xi[i, :]) = 1/mass[i]*((Xi_flow[i, :] -  m_flow[i]*xi[i, :]) - (Xi_flow[i + 1, :] - m_flow[i+1]*xi[i, :])) "Component mass balance";
    drhodt[i]*geo.volume[i] = m_flow[i] - m_flow[i + 1] "Mass balance";
    fluid[i].drhodp_hxi*der(p[i]) = (drhodt[i] - der(h[i])*fluid[i].drhodh_pxi- sum({fluid[i].drhodxi_ph[j]*der(xi[i, j]) for j in 1:medium.nc - 1})) "Calculate pressure from enthalpy and density derivative";
  end for;

  //-------------------------------------------
  // Static momentum balance:
  // notice that for a static momentum balance we need to apply the same balance as homotopy start equation. Otherwise the equations become trivial.
  // For now we leave the homotopy inside for future development
  for i in 2:geo.N_cv loop
    0 = if useHomotopy then homotopy(p[i - 1] - p[i] - Delta_p_fric[i] - Delta_p_grav[i], p[i - 1] - p[i] - Delta_p_fric[i] - Delta_p_grav[i]) else p[i - 1] - p[i] - Delta_p_fric[i] - Delta_p_grav[i];
  end for;
  0 = if useHomotopy then homotopy(inlet.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1], inlet.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1]) else inlet.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1];
  0 = if useHomotopy then homotopy(p[geo.N_cv] - outlet.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1], p[geo.N_cv] - outlet.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1]) else p[geo.N_cv] - outlet.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1];

  inlet.h_outflow = mechanicalEquilibrium.h[1];
  outlet.h_outflow = mechanicalEquilibrium.h[geo.N_cv];


  //-------------------------------------------
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
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{140,50}}), graphics), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{140,50}}), graphics));
end VolumeVLE_L4;
