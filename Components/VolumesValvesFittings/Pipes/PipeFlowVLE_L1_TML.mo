within ClaRa.Components.VolumesValvesFittings.Pipes;
model PipeFlowVLE_L1_TML "Simple tube model based on transmission line equations. Can choose between Modelica and ClaRa Delay implementation."
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

  ////////////////////////////////////////////////////////////////////
  // simplification of level 1 compared to level 2:
  // transmission line model used instead of balance equations.

  extends ClaRa.Basics.Icons.Pipe_L1;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  import Modelica.Constants.eps;
  import Modelica.Constants.g_n "gravity constant";

  outer ClaRa.SimCenter simCenter;

  //## S U M M w R Y   D E F I N I T I O N ###################################################################
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation (Dialog(hide));

    parameter Basics.Units.Length length "Length of pipe";
    input Basics.Units.Area A_cross if showExpertSummary "Cross sectional area" annotation (Dialog(show));
    input Basics.Units.Area A_wall if showExpertSummary "Total wall area" annotation (Dialog(show));
    input Basics.Units.Length Delta_x[N_wall] if showExpertSummary "Discretisation for energy balance" annotation (Dialog(show));
    input Basics.Units.Volume volume_tot "Total volume of system" annotation (Dialog(show));

    parameter Integer N_cv "|Discretisation|Number of temperature positions computed";
    parameter Integer N_wall "|Discretisation|Number of wall elements";

    input Basics.Units.Pressure dp "Pressure difference between outlet and inlet" annotation (Dialog);
    input Basics.Units.HeatFlowRate Q_flow_tot "Heat flow through entire pipe wall" annotation (Dialog);
    input Basics.Units.Temperature T[N_cv] if showExpertSummary "Temperatures inside pipe" annotation (Dialog);
  end Outline;

  model Wall_L4
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Integer N_wall "|Discretisation|Number of wall elements";
    parameter Boolean showExpertSummary annotation (Dialog(hide));
    input Basics.Units.Temperature T[N_wall] if showExpertSummary "Temperatures of wall segments" annotation (Dialog);
    input Basics.Units.HeatFlowRate Q_flow[N_wall] if showExpertSummary "Heat flows through wall segments" annotation (Dialog);
  end Wall_L4;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE inlet;
    ClaRa.Basics.Records.FlangeVLE outlet;
    Wall_L4 wall;
  end Summary;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=noEvent(if sum(heat.Q_flow) > 0 then sum(heat.Q_flow) else 0),
    powerOut_th=if not heatFlowIsLoss then -sum(heat.Q_flow) else 0,
    powerOut_elMech=0,
    powerAux=0)  if contributeToCycleSummary;
  //## P w R w M E T E R S ###################################################################################

  //____Geometric data________________________________________________________________________________________
  parameter Modelica.Units.SI.Length length=10 "|Geometry|Length of the pipe";
  parameter Modelica.Units.SI.Length diameter_i=0.5 "|Geometry|Inner diameter of the pipe";
  //   parameter Modelica.SIunits.Length d_a= 0.55
  //     "|Geometry|Outer diameter of the pipe"; //include this if cylindric wall shall be included!
  parameter Modelica.Units.SI.Length z_in=0.1 "|Geometry|height of inlet above ground";
  parameter Modelica.Units.SI.Length z_out=0.1 "|Geometry|height of outlet above ground";
  parameter Integer N_tubes=1 "|Geometry|Number Of parallel pipes";

  final parameter Modelica.Units.SI.Area A_cross=Modelica.Constants.pi/4*diameter_i^2*N_tubes "cross area of volume elements";
  final parameter Real S=Modelica.Constants.pi*diameter_i*N_tubes "Shape factor of pipe wall for heat conduction";
  //to include cylindric thick wall, set S=2*Modelica.Constants.pi/log(d_a/diameter_i)

  //____Discretisation________________________________________________________________________________________
  parameter Integer N_cv=1 "|Discretisation|number of subdivisions of tube wall";
  final parameter Integer N_wall=N_cv "number of subdivisions for wall temperature";
  final parameter Modelica.Units.SI.Length Delta_x[N_wall]=ones(N_wall)*length/N_wall "Length of heated wall section";
  final parameter Integer N_temp=2*N_wall + 1 "number of tempratures to be computed";
  //____Media Data____________________________________________________________________________________________
  parameter Boolean useConstantMediaData=false "|Media Data|Use of constant media data";
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(enable=useConstantMediaData == false, group="Media Data"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_const=4200 "Constant heat capacity in pipe" annotation (Dialog(enable=useConstantMediaData == true, group="Media Data"));
  parameter Modelica.Units.SI.Density rho_const=985 "Constant fluid density in pipe" annotation (Dialog(enable=useConstantMediaData == true, group="Media Data"));
  parameter Modelica.Units.SI.Velocity a_const=1500 "Constant speed of sound in pipe" annotation (Dialog(enable=useConstantMediaData == true, group="Media Data"));
  //____Nominal Values________________________________________________________________________________________
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom=10 "|Physical Effects|Linear Pressure Loss|Nominal mass flow w.r.t. all parallel tubes";
  parameter Modelica.Units.SI.Pressure Delta_p_nom=1e3 "|Physical Effects|Linear Pressure Loss|Pressure loss over pipe length length at nominal mass flow w.r.t. all parallel tubes";

  final parameter Modelica.Units.SI.Pressure Delta_p_grav_start=rho_start*g_n*(z_out - z_in) "Pressure loss over pipe length length at nominal operation point";
  //____Physical Effects______________________________________________________________________________________
  parameter Boolean adiabaticWall=true "|Physical Effects|Heat Transfer|set true if pipe is adiabatic";

  parameter Real alpha(unit="W/(m2.K)") = 10 annotation (Dialog(
      enable=adiabaticWall == false,
      tab="Physical Effects",
      group="Heat Transfer"));

  final parameter Modelica.Units.SI.Frequency F=(Delta_p_nom*A_cross)/(m_flow_nom*length) "Friction coefficient";

  //____Initialisation________________________________________________________________________________________
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "|Initialisation|Model Settings|True, if homotopy method is used during initialisation";

  parameter Modelica.Units.SI.SpecificEnthalpy h_start=TILMedia.VLEFluid.MixtureCompatible.Functions.liquidSpecificEnthalpy_pTxi(
      medium,
      p_start,
      simCenter.T_amb_start) "|Initialisation|Initial Medium Properties|Initial averaged fluid specific enthalpy";

  //   final parameter Modelica.SIunits.Temperature T_start= TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.temperature_phxi
  //   (medium,
  //       p_start,
  //       h_start)
  //     "Initial averaged fluid temperature";

  parameter Modelica.Units.SI.Pressure p_start=(p_in_start + p_out_start)/2 "|Initialisation|Initial Medium Properties|Initial averaged fluid pressure";
  parameter Modelica.Units.SI.Pressure p_in_start=simCenter.p_amb_start "|Initialisation|Initial Medium Properties|Initial inlet pressure";
  parameter Modelica.Units.SI.Pressure p_out_start=simCenter.p_amb_start "|Initialisation|Initial Medium Properties|Initial outlet pressure";
  final parameter Modelica.Units.SI.Density rho_start=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
      medium,
      p_start,
      h_start) "Initial fluid density";

  //____Summary and Visualisation_____________________________________________________________________________
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if negative heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if an extended summary shall be shown, else false";
  parameter Boolean showData=false "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  Summary summary(
    outline(
      showExpertSummary=showExpertSummary,
      length=length,
      A_cross=Modelica.Constants.pi/4*diameter_i^2*N_tubes,
      A_wall=Modelica.Constants.pi*diameter_i*length*N_tubes,
      Delta_x=Delta_x,
      volume_tot=A_cross*length,
      N_cv=N_temp,
      N_wall=N_wall,
      dp=outlet.p - inlet.p,
      Q_flow_tot=sum(heat.Q_flow),
      T=T),
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=inlet.m_flow,
      T=fluidInlet.T,
      p=fluidInlet.p,
      h=fluidInlet.h,
      s=fluidInlet.s,
      steamQuality=fluidInlet.q,
      H_flow=fluidInlet.h*inlet.m_flow,
      rho=fluidInlet.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOutlet.T,
      p=fluidOutlet.p,
      h=fluidOutlet.h,
      s=fluidOutlet.s,
      steamQuality=fluidOutlet.q,
      H_flow=fluidOutlet.h*outlet.m_flow,
      rho=fluidOutlet.d),
    wall(
      showExpertSummary=showExpertSummary,
      N_wall=N_wall,
      T=T_wall,
      Q_flow=heat.Q_flow))
    annotation (Placement(transformation(extent={{-60,-50},{-40,-32}})));

  //____Transmission Line Specific Declarations_______________________________________________________________

  parameter Boolean useClaRaDelay=simCenter.useClaRaDelay "|Expert Settings|Delay Function|True for using ClaRa delay implementation / false for built in Modelica delay";

  parameter Real MaxSimTime=simCenter.MaxSimTime "Maximum time for simulation, must be set for Modelica delay blocks with variable delay time if simCenter.useClaRaDelay==true"
    annotation (Dialog(
      enable=useClaRaDelay == false,
      tab="Expert Settings",
      group="Delay Function"));

  parameter Real kappa=1.25 "|Expert Settings|Transmission Line Settings|TML pFrequency approximation";

  parameter Real f_ps(unit="1/s") = 0.01 "|Expert Settings|Transmission Line Settings|Speed factor for pseudo state fluid properties averaging";

  final parameter Integer numDelays=N_wall + N_temp + 13;

  //## V w R I w B length E   P w R T##############################################################################

  //____Energy / Enthalpy_____________________________________________________________________________________
  Real T_0 "Temperature at inlet";

  ClaRa.Basics.Units.Temperature T_L "Temperature at outlet";
  ClaRa.Basics.Units.Temperature T[N_temp] "Temperature at cell borders";

  ClaRa.Basics.Units.Temperature T_L_const "Temperature at outlet";

  ClaRa.Basics.Units.Temperature T_wall[N_wall] "Outer wall temperatures";

  Real dcpdt;
  Modelica.Units.SI.SpecificHeatCapacity cp "Time averaged heat capacity in pipe";
  Modelica.Units.SI.SpecificHeatCapacity cp_ps "Pseudo state for time averaged heat capacity in pipe ";

  //____Pressure______________________________________________________________________________________________
  Modelica.Units.SI.Pressure p_in "Pressure at inlet";
  Modelica.Units.SI.Pressure p_out "Pressure at outlet";

  Modelica.Units.SI.Pressure Delta_p_fric=p_in - p_out "Pressure difference due to friction";
  Modelica.Units.SI.Pressure Delta_p_grav "Pressure drop due to gravity";
  //rho*g_n*(z_out-z_in)

  Modelica.Units.SI.Pressure Delta_p_in(final start=0) "Pressure at inlet:  p_in = p_nom + dp_0";
  Modelica.Units.SI.Pressure Delta_p_out(final start=0) "Pressure at outlet: p_out = p_nom - R*q_nom + dp_L";

  parameter Modelica.Units.SI.Pressure p_L_init(start=p_out_start, fixed=false) "Initial pressure at outlet:  p_out = p_in_init + dp_L";

  parameter Modelica.Units.SI.Pressure p_0_init(start=p_in_start, fixed=false) "Initial pressure at inlet:  p_in = p_out_init + dp_0";

  //____Mass and Density______________________________________________________________________________________
  Modelica.Units.SI.Density rho "Time averaged fluid density in pipe";
  Modelica.Units.SI.Density rho_ps "Pseudo state for time averaged fluid density in pipe";

  Real drhodt;

  //____Flows and Velocities__________________________________________________________________________________
  Modelica.Units.SI.VolumeFlowRate V_flow_in "Volume flow at inlet";
  Modelica.Units.SI.VolumeFlowRate V_flow_out "Volume flow at outlet";

  Modelica.Units.SI.VolumeFlowRate Delta_V_flow_in "Volume flow at inlet:  V_flow_in=q_nom + dq_0";
  Modelica.Units.SI.VolumeFlowRate Delta_V_flow_out(start=0) "Volume flow at outlet: V_flow_out=q_nom + dq_L";

  parameter Modelica.Units.SI.VolumeFlowRate V_flow_start(start=m_flow_nom/rho_start, fixed=false) "Initial volume flow at inlet";

  Modelica.Units.SI.Velocity w "Flow velocity in pipe";
  Modelica.Units.SI.Velocity a "Time averaged speed of sound in pipe";
  Modelica.Units.SI.Velocity a_ps "Pseudo state for time averaged speed of sound in pipe";

  Real B(unit="1/s");
  //____Connectors____________________________________________________________________________________________

  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}}),
        iconTransformation(extent={{-150,-10},{-130,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{130,-10},{150,10}}),
        iconTransformation(extent={{130,-10},{150,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat[N_wall] annotation (Placement(
        transformation(extent={{-10,40},{10,60}}),iconTransformation(extent={{-10,
            30},{10,50}})));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_pT fluidOutlet(
    vleFluidType=medium,
    p=outlet.p,
    T=T_L,
    computeTransportProperties=false,
    computeVLEAdditionalProperties=true) annotation (Placement(transformation(extent={{60,20},{80,40}}, rotation=0)));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidInlet(
    vleFluidType=medium,
    p=inlet.p,
    h=inStream(inlet.h_outflow),
    computeTransportProperties=false,
    computeVLEAdditionalProperties=true) annotation (Placement(transformation(extent={{-80,20},{-60,40}}, rotation=0)));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{71,-31},{73,-29}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye if showData
    annotation (Placement(transformation(extent={{136,-38},{156,-18}}),
        iconTransformation(extent={{136,-38},{156,-18}})));
  //____Transmission Line Specific Declarations_______________________________________________________________
protected
  Real Tau_pass "Residence time of fluid in temperature segements of pipe";
  //Amount of time a fluid volume leaving the pipe has stayed inside the pipe.
  // Real tau_p_seg=Tau_pass/N_wall "Residence time of fluid in a certain wall element";
  Real Tau_sound "Passing time of sound waves through pipe";
  Real Z_c(unit="kg/(m4.s)") = rho*a/A_cross;
  Real R(unit="kg/(m5.s)") = F*rho/A_cross;

  Real Alpha;
  Real Beta;
  Real I_f[N_temp - 1](each stateSelect=StateSelect.avoid);
  //integral part of Temperatures

  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_T_wall[N_wall]={
      SMArtInt.Internal.ClaRaDelay.ExternalTable() for i in 1:N_wall};
  Real hist_T_wall[N_wall, 1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_T[N_temp]={
      SMArtInt.Internal.ClaRaDelay.ExternalTable() for i in 1:N_temp};
  Real hist_T[N_temp, 1](start=ones(N_temp, 1)*simCenter.T_amb_start);
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_d_mean=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_d_mean[1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_cp_mean=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_cp_mean[1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_w_mean=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_w_mean[1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_alpha_d=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_alpha_d[1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_beta_d=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_beta_d[1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_rhocp=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_rhocp[1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_q=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_q[1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_A=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_A[2];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_T_0=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_T_0[2];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_dpL=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_dpL[7](start=zeros(7));
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_dqL=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_dqL[6](start=zeros(6));
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_dp0=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_dp0[7](start=zeros(7));
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_dq0=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_dq0[6](start=zeros(6));

  parameter  Real A_0(fixed=false);
  parameter Real B_0(fixed=false);
  Real Tau_pass_tot "Total residence time fo fluid in pipe from inlet to outlet";
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_beta=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_beta[1];
  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_alpha=
      SMArtInt.Internal.ClaRaDelay.ExternalTable();
  Real hist_alpha[1];

  Real check=Tau_sound*F/2;
  Real conv_0[2];
  Real conv_L[2];
  Real res[2] "Steady state residuum of approximation to convolution integrals";

  Real[1] delayTimes_1={max(0, time - Tau_pass)};
  Real[2] delayTimes_2={max(0, time - Tau_pass),max(0, time - Tau_pass_tot)};
  Real[7] delayTimes_3={max(0, time - (i*kappa + 1)*Tau_sound) for i in 0:6};
  Real[6] delayTimes_4={max(0, time - i*kappa*Tau_sound) for i in 1:6};

protected
  Real Test1;
  Real Test2;

  Real H_flow_in "Enthalpy entering the pipe through the inlet";
  Real H_flow_out "Enthalpy leaving the pipe through the outlet";

  Real Q_flow_wall "Heat exchange with wall";
  Real Delta_H_flow "Sum of ingoing and outgoig enthalpy";

  //### E Q U A T I O N P A R T ##############################################################################
  //-------------------------------------------

initial equation

  Tau_pass = (rho*length/(N_temp - 1)*A_cross)/(inlet.m_flow);
  Tau_pass_tot = (rho*length*A_cross)/(inlet.m_flow);
  Alpha = 0;
  Beta = 0;

  for i in 1:N_temp - 1 loop
    I_f[i] = if adiabaticWall then 0 else alpha*S/(A_cross*rho*cp)*T_wall[div(i + 1,
      2)]/B*(1 - exp(-B*Tau_pass));
  end for;

  if useConstantMediaData==false then
    rho = fluidInlet.d;
    cp = 1/2*(fluidInlet.cp + fluidOutlet.cp);
    //=1400
    a = fluidInlet.w;

    rho_ps = 1/2*(fluidInlet.d + fluidOutlet.d);
    cp_ps = 1/2*(fluidInlet.cp + fluidOutlet.cp);
    a_ps = 1/2*(fluidInlet.w + fluidOutlet.w);
  end if;

  //_____/Initial Settings\______________________________________________________________________________
//  when initial() then
    A_0 = inlet.m_flow/A_cross/rho;
    B_0 = if adiabaticWall then der(cp*rho)/(cp*rho) else alpha*S/(A_cross*rho*cp)
       + der(cp*rho)/(cp*rho);

    //p_0_init = outlet.p + F/A_cross*inlet.m_flow*length;
    //p_L_init = outlet.p;
    //V_flow_start = inlet.m_flow/rho;

//     p_0_init = outlet.p + F/A_cross*(inlet.m_flow- outlet.m_flow)/2*length;
//     p_L_init = outlet.p+Delta_p_grav_start;
    V_flow_start = (inlet.m_flow- outlet.m_flow)/2/rho;

  if abs(z_out - z_in) < Modelica.Constants.eps then
    p_0_init = outlet.p + F/A_cross*(inlet.m_flow- outlet.m_flow)/2*length;
    p_L_init = outlet.p;
  elseif z_out > z_in then
    p_0_init = outlet.p + F/A_cross*(inlet.m_flow- outlet.m_flow)/2*length;
    p_L_init = outlet.p;
  else
    p_0_init = outlet.p + F/A_cross*(inlet.m_flow- outlet.m_flow)/2*length;
    p_L_init = outlet.p;
   end if;


//  end when;
  //__________________________________________________________________________________________________

equation
  assert(abs(z_out-z_in) <= length, "Length of pipe less than vertical height", AssertionLevel.error);

  connect(eye, eye_int[1]) annotation (Line(
      points={{146,-28},{110,-28},{110,-30},{72,-30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));



  //_____/Setup of delayed signals needed in the model Settings\__________________________________________

  if useClaRaDelay then
    //use delay implemented for ClaRa library
    for i in 1:N_wall loop
      hist_T_wall[i, 1] =
        ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_T_wall[i],
        time,
        T_wall[i],
        delayTimes_1[1]);
    end for;
    for i in 1:N_temp loop
      hist_T[i, 1] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_T[i],
        time,
        T[i],
        delayTimes_1[1]);
    end for;
    hist_d_mean[1] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
      pointer_d_mean,
      time,
      fluidInlet.d + fluidOutlet.d,
      delayTimes_1[1]);
    hist_cp_mean[1] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
      pointer_cp_mean,
      time,
      fluidInlet.cp + fluidOutlet.cp,
      delayTimes_1[1]);
    hist_w_mean[1] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
      pointer_w_mean,
      time,
      fluidInlet.w + fluidOutlet.w,
      delayTimes_1[1]);
    hist_alpha_d[1] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
      pointer_alpha_d,
      time,
      Alpha,
      delayTimes_1[1]);
    hist_beta_d[1] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
      pointer_beta_d,
      time,
      Beta,
      delayTimes_1[1]);
    hist_rhocp[1] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
      pointer_rhocp,
      time,
      rho*cp,
      delayTimes_1[1]);
    hist_q[1] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
      pointer_q,
      time,
      inlet.m_flow/rho,
      delayTimes_1[1]);
    for i in 1:2 loop
      hist_A[i] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_A,
        time,
        w,
        delayTimes_2[i]);
      hist_T_0[i] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_T_0,
        time,
        T_0,
        delayTimes_2[i]);
    end for;
    for i in 1:7 loop
      hist_dpL[i] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_dpL,
        time,
        Delta_p_out + Z_c*Delta_V_flow_out,
        delayTimes_3[i]);
      hist_dp0[i] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_dp0,
        time,
        Delta_p_in + Z_c*Delta_V_flow_in,
        delayTimes_3[i]);
    end for;
    for i in 1:6 loop
      hist_dqL[i] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_dqL,
        time,
        Delta_V_flow_out,
        delayTimes_4[i]);
      hist_dq0[i] = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
        pointer_dq0,
        time,
        Delta_V_flow_in,
        delayTimes_4[i]);
    end for;
  else
    //use Modelica delay
    for i in 1:N_wall loop
      hist_T_wall[i, 1] = delay(
        T_wall[i],
        time - delayTimes_1[1],
        MaxSimTime);
    end for;

    for i in 1:N_temp loop
      hist_T[i, 1] = delay(
        T[i],
        time - delayTimes_1[1],
        MaxSimTime);
    end for;

    for i in 1:size(delayTimes_1, 1) loop
      hist_d_mean[i] = delay(
        fluidInlet.d + fluidOutlet.d,
        time - delayTimes_1[i],
        MaxSimTime);
      hist_cp_mean[i] = delay(
        fluidInlet.cp + fluidOutlet.cp,
        time - delayTimes_1[i],
        MaxSimTime);
      hist_w_mean[i] = delay(
        fluidInlet.w + fluidOutlet.w,
        time - delayTimes_1[i],
        MaxSimTime);
      hist_alpha_d[i] = delay(
        Alpha,
        time - delayTimes_1[i],
        MaxSimTime);
      hist_beta_d[i] = delay(
        Beta,
        time - delayTimes_1[i],
        MaxSimTime);
      hist_rhocp[i] = delay(
        rho*cp,
        time - delayTimes_1[i],
        MaxSimTime);
      hist_q[i] = delay(
        inlet.m_flow/rho,
        time - delayTimes_1[i],
        MaxSimTime);
    end for;
    for i in 1:size(delayTimes_2, 1) loop
      hist_A[i] = delay(
        w,
        time - delayTimes_2[i],
        MaxSimTime);
      hist_T_0[i] = delay(
        T_0,
        time - delayTimes_2[i],
        MaxSimTime);
    end for;
    for i in 1:size(delayTimes_3, 1) loop
      hist_dpL[i] = delay(
        Delta_p_out + Z_c*Delta_V_flow_out,
        time - delayTimes_3[i],
        MaxSimTime);
      hist_dp0[i] = delay(
        Delta_p_in + Z_c*Delta_V_flow_in,
        time - delayTimes_3[i],
        MaxSimTime);
    end for;
    for i in 1:size(delayTimes_4, 1) loop
      hist_dqL[i] = delay(
        Delta_V_flow_out,
        time - delayTimes_4[i],
        MaxSimTime);
      hist_dq0[i] = delay(
        Delta_V_flow_in,
        time - delayTimes_4[i],
        MaxSimTime);
    end for;
  end if;

  if time <= Tau_pass then
    hist_alpha = {A_0*(time - Tau_pass)};
    hist_beta = {B_0*(time - Tau_pass)};
  else
    hist_alpha = hist_alpha_d;
    hist_beta = hist_beta_d;
  end if;

  //_____/end of delayed signals needed in the model Settings\__________________________________________

  H_flow_in = T_0*cp*inlet.m_flow;
  H_flow_out = T_L*cp*outlet.m_flow;
  Q_flow_wall = -sum(heat.Q_flow);
  Delta_H_flow = H_flow_in + H_flow_out;

  if useConstantMediaData == false then
    der(rho_ps) = -der(Tau_pass)/Tau_pass*rho_ps + 1/Tau_pass*1/2*(fluidInlet.d +
      fluidOutlet.d - hist_d_mean[1]*(1 - der(Tau_pass)));
    der(cp_ps) = -der(Tau_pass)/Tau_pass*cp_ps + 1/Tau_pass*1/2*(fluidInlet.cp +
      fluidOutlet.cp - hist_cp_mean[1]*(1 - der(Tau_pass)));
    der(a_ps) = -der(Tau_pass)/Tau_pass*a_ps + 1/Tau_pass*1/2*(fluidInlet.w +
      fluidOutlet.w - hist_w_mean[1]*(1 - der(Tau_pass)));

    der(rho) = f_ps*(rho_ps - rho);
    der(cp) = f_ps*(cp_ps - cp);
    der(a) = f_ps*(a_ps - a);
  else
    rho_ps = rho_const;
    cp_ps  = cp_const;
    a_ps   = a_const;
    rho    = rho_const;
    cp     = cp_const;
    a      = a_const;
  end if;

  //_____Energy Balance________________________________________________________________

  drhodt = der(rho);
  dcpdt = der(cp);

  T_0 = fluidInlet.T;

  der(Tau_pass) = 1 - (w/hist_A[1]);
  der(Tau_pass_tot) = 1 - (w/hist_A[2]);

  T_wall = heat.T;

  der(Alpha) = w;
  der(Beta) = B;

  if adiabaticWall then
    der(I_f) = zeros(N_temp - 1);
  else
    for i in 1:N_temp - 1 loop
      //1)    der(I_f[i])=exp(Beta)*alpha*S/(A_cross*rho*cp)*T_wall[div(i+1,2)]-exp(hist_beta[1])*alpha*S/(A_cross*hist_rhocp[1])*hist_T_wall[div(i+1,2),1]*(1-der(Tau_pass));
      der(I_f[i]) = -B*I_f[i] + alpha*S/(A_cross*rho*cp)*T_wall[div(i + 1, 2)] -
        exp(-(Beta - hist_beta[1]))*alpha*S/(A_cross*hist_rhocp[1])*hist_T_wall[div(
        i + 1, 2), 1]*(1 - der(Tau_pass));
      //3)  der(I_f[i])=-Beta*B*I_f[i]+ alpha*S/(A_cross*rho*cp)*T_wall[div(i+1,2)]-(1-(Beta-hist_beta[1])+(Beta-hist_beta[1])^2/2)*alpha*S/(A_cross*hist_rhocp[1])*hist_T_wall[div(i+1,2),1]*(1-der(Tau_pass));

    end for;
  end if;
  Test1 = 1 - (Beta - hist_beta[1]) + (Beta - hist_beta[1])^2/2;
  Test2 = exp(-Beta + hist_beta[1]);

  w = inlet.m_flow/(rho*A_cross);
  B = if adiabaticWall then der(cp*rho)/(cp*rho) else alpha*S/(A_cross*rho*cp) +
    der(cp*rho)/(cp*rho);

  T[1] = T_0;
  T[N_temp] = T_L;

  if adiabaticWall then
    for i in 1:N_temp - 1 loop
      T[i + 1] = hist_rhocp[1]/(rho*cp)*hist_T[i, 1];
    end for;
  else
    for i in 1:N_temp - 1 loop
      //1)  T[i+1]=exp(-(Beta - hist_beta[1]))*hist_T[i,1]+exp(-Beta)*I_f[i];
      T[i + 1] = exp(-(Beta - hist_beta[1]))*hist_T[i, 1] + I_f[i];
      //3) T[i+1]=(1-(Beta - hist_beta[1])+(Beta - hist_beta[1])^2/2)*hist_T[i,1]+I_f[i];
    end for;
  end if;
  T_L_const = T_wall[1] + exp(-Tau_pass_tot*B)*(hist_T_0[2] - T_wall[1]);
  //valid only for constant wall temperature.

  if adiabaticWall then
    //we need to impose a non trivial equation here, otherwise the solver complains about a singular system:  zeros(N_wall) would be sufficient.
    heat.Q_flow = {eps*S*length/N_wall/6*((T_wall[i] - T[2*i - 1]) + 4*(T_wall[i] - T[
      2*i]) + (T_wall[i] - T[2*i + 1])) for i in 1:N_wall};
    //simple Simpson rule approximation of heat flow through wall;
  else
    heat.Q_flow = {alpha*S*length/N_wall/6*((T_wall[i] - T[2*i - 1]) + 4*(T_wall[i] - T[2
      *i]) + (T_wall[i] - T[2*i + 1])) for i in 1:N_wall};
    //simple Simpson rule approximation of heat flow through wall
  end if;
  //_____Momentum Balance______________________________________________________________

  Tau_sound = length/a;

  Delta_p_grav = rho*g_n*abs(z_out - z_in);

  if abs(z_out - z_in) <Modelica.Constants.eps then
    p_out = p_L_init + Delta_p_out;
    p_in = p_0_init + Delta_p_in;
  elseif z_out > z_in then
    p_out = p_L_init + Delta_p_out;
    p_in = homotopy(p_0_init + Delta_p_in + Delta_p_grav, p_0_init + Delta_p_grav_start);
  else
   p_out = homotopy(p_L_init + Delta_p_out + Delta_p_grav, p_L_init + Delta_p_grav_start);
   p_in = p_0_init + Delta_p_in;
  end if;

  p_in = inlet.p;
  p_out = outlet.p;

  V_flow_in = inlet.m_flow/rho;
  //*A_cross
  V_flow_out = -outlet.m_flow/rho;
  //*A_cross

  V_flow_in = V_flow_start + Delta_V_flow_in;
  V_flow_out = V_flow_start - Delta_V_flow_out;

  //very simple momentum balance. Need to approximate at least one of the convolution integrals.
  conv_0[1] = if time < Tau_sound then 0 else (1 - exp(-F/2*Tau_sound))*(1/3*(1*exp(-0)
    *hist_dpL[1] + 4*exp(-1)*hist_dpL[2] + 2*exp(-2)*hist_dpL[3] + 4*exp(-3)*
    hist_dpL[4] + 2*exp(-4)*hist_dpL[5] + 4*exp(-5)*hist_dpL[6] + 1*exp(-6)*
    hist_dpL[7]) + res[1]*hist_dpL[7]);

  conv_0[2] = if time < Tau_sound then 0 else F*rho*length/(A_cross)*(1/3*(1*Delta_V_flow_in + 4*
    exp(-1)*hist_dq0[1] + 2*exp(-2)*hist_dq0[2] + 4*exp(-3)*hist_dq0[3] + 2*exp(
    -4)*hist_dq0[4] + 4*exp(-5)*hist_dq0[5] + 1*exp(-6)*hist_dq0[6]) + res[2]*
    hist_dq0[6]);

  conv_L[1] = if time < Tau_sound then 0 else (1 - exp(-F/2*Tau_sound))*(1/3*(1*exp(-0)
    *hist_dp0[1] + 4*exp(-1)*hist_dp0[2] + 2*exp(-2)*hist_dp0[3] + 4*exp(-3)*
    hist_dp0[4] + 2*exp(-4)*hist_dp0[5] + 4*exp(-5)*hist_dp0[6] + (1*exp(-6))*
    hist_dp0[7]) + res[1]*hist_dp0[7]);

  conv_L[2] = if time < Tau_sound then 0 else F*rho*length/(A_cross)*(1/3*(1*Delta_V_flow_out + 4*
    exp(-1)*hist_dqL[1] + 2*exp(-2)*hist_dqL[2] + 4*exp(-3)*hist_dqL[3] + 2*exp(
    -4)*hist_dqL[4] + 4*exp(-5)*hist_dqL[5] + 1*exp(-6)*hist_dqL[6]) + res[2]*
    hist_dqL[6]);

  res[1] = -1/3*(1 + 4*exp(-1) + 2*exp(-2) + 4*exp(-3) + 2*exp(-4) + 4*exp(-5)
     + 1*exp(-6)) + (1 - exp(-(time - Tau_sound)/(kappa*Tau_sound)));

  res[2] = -1/3*(1 + 4*exp(-1) + 2*exp(-2) + 4*exp(-3) + 2*exp(-4) + 4*exp(-5)
     + 1*exp(-6)) + (1 - exp(-time/(kappa*Tau_sound)));

  Delta_p_in = homotopy(exp(-Tau_sound*F/2)*hist_dpL[1] + Z_c*Delta_V_flow_in + conv_0[1] + conv_0[2],
    Z_c*Delta_V_flow_in);
  Delta_p_out = homotopy(exp(-Tau_sound*F/2)*hist_dp0[1] + Z_c*Delta_V_flow_out + conv_L[1] + conv_L[2],
    Z_c*Delta_V_flow_out);

  inlet.h_outflow = fluidInlet.h;
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.h_outflow = fluidOutlet.h;
  outlet.xi_outflow = inStream(inlet.xi_outflow);

  //-------------------------------------------
  //Summary:
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = fluidOutlet.T - 273.15;
  eye_int[1].s = fluidOutlet.s/1e3;
  eye_int[1].p = fluidOutlet.p/1e5;
  eye_int[1].h = actualStream(outlet.h_outflow)/1e3;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{140,50}}),
         graphics),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}}),
                                      graphics),
    Documentation(info="<html>
<p><b>Model description: </b>w  1D-tube model using a transmission line formulation</p>

<p>
<b>FEATURES</b>
<ul>
<li>This model uses TILMedia</li>
<li>Flow reversal is not  supported</li>

</ul></p>
<b>TODO</b>
<ul>
<li>implememt static head</li>
<li>implememt replaceable pressure loss models</li>
<li>implememt replaceable heat transfer models</li>
</ul>

</html>
<html>
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
</html>"));
end PipeFlowVLE_L1_TML;
