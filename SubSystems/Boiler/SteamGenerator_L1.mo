within ClaRa.SubSystems.Boiler;
model SteamGenerator_L1 "A steam generation and reaheater model using characteristic lines and transfer functions"
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

  extends ClaRa.SubSystems.Boiler.CoalSupplyBoiler_base;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  parameter Boolean calcOutletPressures= true "True, if the pressures at outlet shall be calculated"  annotation(choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

//___________________________________________________________________________________//
//_____________Nominal Operation Point_______________________________________________//
  parameter Modelica.Units.SI.Pressure p_LS_nom=300e5 "|Nominal Operation|Nominal values - SI units!|Nominal life steam pressure";
  parameter Modelica.Units.SI.Pressure p_RH_nom=60e5 "|Nominal Operation|Nominal values - SI units!|Nominal reheat outlet pressure";
  parameter Modelica.Units.SI.Pressure Delta_p_nomHP=40e5 "|Nominal Operation|Nominal values - SI units!|Nominal main pressure loss";
  parameter Modelica.Units.SI.Pressure Delta_p_nomIP=4e5 "|Nominal Operation|Nominal values - SI units!|Nominal reheat pressure loss";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nomLS=419 "|Nominal Operation|Nominal values - SI units!|Nominal life steam flow rate";
  input Modelica.Units.SI.Temperature T_LS=823.15 "|Nominal Operation|Nominal values - SI units!|Value of life steam temperature" annotation (Dialog);
  parameter Modelica.Units.SI.Temperature T_RH_nom=833 "|Nominal Operation|Nominal values - SI units!|Nominal reheater outlet temperature";

//___________________________________________________________________________________//
//_____________Nominal Operation Point_______________________________________________//
  parameter Real CL_mLS_QF_[:,:]=[0, 0.32; 0.34, 0.32; 1, 1] "|Part Load|Part Load Definition using p.u.!|Characteristic line live steam flow as function of thermal output";
  parameter Real CL_pLS_QF_[:,:]=[0, 0.32; 0.34, 0.32; 1, 1] "|Part Load|Part Load Definition using p.u.!|Characteristic line live steam pressure as function of thermal output";
  parameter Real CL_Valve_[:,:]=[0,0; 1, 1] "|Part Load|Part Load Definition using p.u.!|Characteristics of the turbine valve";
  parameter Real CL_Delta_pHP_mLS_[:,:]=[0,0;0.1, 0.01; 0.2, 0.04; 0.3, 0.09; 0.4, 0.16; 0.5, 0.25; 0.6, 0.36; 0.7, 0.49; 0.8, 0.64; 0.9, 0.81; 1, 1] "|Part Load|Part Load Definition using p.u.!|Characteristic line of HP pressure drop as function of mass flow rate";

  parameter Real CL_Delta_pIP_mLS_[:,:]=[0,0;0.1, 0.01; 0.2, 0.04; 0.3, 0.09; 0.4, 0.16; 0.5, 0.25; 0.6, 0.36; 0.7, 0.49; 0.8, 0.64; 0.9, 0.81; 1, 1] "|Part Load|Part Load Definition using p.u.!|Characteristic line of reheat pressure drop as function of mass flow rate";

   parameter Real CL_Ip_Hp_[:,2]= {{0.2500, 0.0951},
                                        {0.3333, 0.1493},
                                        {0.4167, 0.2141},
                                        {0.5000, 0.2903},
                                        {0.5833, 0.3776},
                                        {0.6667, 0.4770},
                                        {0.7500, 0.5885},
                                        {0.8333, 0.7129},
                                        {0.9167, 0.8500},
                                        {1.0000, 1.0000}} "|Part Load|Part Load Definition using p.u.!|Characteristic line IP pressure over HP pressure (p.u.)";
  parameter Real CL_Trh_Q_[:,:]=[0,    0.9004;    0.4000,    0.9604;    0.5000,    0.9784;    0.7500,    1.0000;    1.0000,    1.0000] "|Part Load|Part Load Definition using p.u.!|Temperature after reheat";

//___________________________________________________________________________________//
//_____________Nominal Operation Point_______________________________________________//
  parameter Modelica.Units.SI.Time Tau_dead=120 "|Transients and Control Definition|Time Response Definition|Equivalent dead time of steam generation";
  parameter Modelica.Units.SI.Time Tau_bal=200 "|Transients and Control Definition|Time Response Definition|Balancing time of steam generation";
  parameter Modelica.Units.SI.Time Tau_stor=200 "|Transients and Control Definition|Time Response Definition|Integration time of steam storage";
  parameter Modelica.Units.SI.Time Tau_IP=(10 + 25)/2 "|Transients and Control Definition|Time Response Definition|Time Constant for Energy Storage in IP/LP turbine";

  parameter Boolean yTInputIsActive= false "|Transients and Control Definition|Time Response Definition| True, if connector is active, else constant valve opening";
  parameter Real y_T_const_ = 1 "|Transients and Control Definition|Time Response Definition|Constant turbine valve aperture"
                                                                                              annotation(Dialog(enable = not yTInputIsActive));

//___________Summary and Visualisation_____________________________________________//
  parameter Boolean showExpertSummary=false "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

//___________Variables____________________________________________________________//
  outer ClaRa.SimCenter simCenter;
  Modelica.Units.SI.Pressure p_LS "Live steam pressure";
  Modelica.Blocks.Continuous.LimIntegrator
                                        SteamStorage(k=1/Tau_stor,
    outMin=0,
    outMax=1.5,
    initType=Modelica.Blocks.Types.Init.NoInit) "A simple way to model the mass storage in the boiler"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Modelica.Blocks.Continuous.TransferFunction heatRelease(a={Tau_bal*Tau_dead,(Tau_bal + Tau_dead),1},
      initType=Modelica.Blocks.Types.Init.NoInit) "comprehends the coal supply, the heat release and the steam generation"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Modelica.Blocks.Math.Product turbineValveModel "Effect of steam flow throtteling"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.Interfaces.RealInput yT_=turbineValveCharacteristics.u[1] if yTInputIsActive "Turbine valve position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,138}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,120})));
  Modelica.Blocks.Tables.CombiTable1Dv turbineValveCharacteristics(table=CL_Valve_, columns={2}) annotation (Placement(transformation(extent={{2,-46},{22,-26}})));
  Modelica.Blocks.Tables.CombiTable1Dv convert2LiveSteamFlow(columns={2}, table=CL_mLS_QF_) annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Tables.CombiTable1Dv convert2LiveSteamPressure(columns={2}, table=CL_pLS_QF_) annotation (Placement(transformation(extent={{40,80},{60,100}})));
public
  Modelica.Blocks.Tables.CombiTable1Dv convert2PressureDrop_HP(columns={2}, table=CL_Delta_pHP_mLS_) annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Modelica.Blocks.Continuous.FirstOrder energyStroage_RH_IPLP_turbine(
               T=Tau_IP, initType=Modelica.Blocks.Types.Init.NoInit)
    annotation (Placement(transformation(extent={{102,40},{122,60}})));
  Modelica.Blocks.Math.Gain to_pRH(k=p_RH_nom)
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Modelica.Blocks.Tables.CombiTable1Dv convert2IntermediatePressure(columns={2}, table=CL_Ip_Hp_) annotation (Placement(transformation(extent={{100,80},{120,100}})));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_pT liveSteam(
    vleFluidType=medium,
    T=T_LS,
    p=p_LS) annotation (Placement(transformation(extent={{10,154},{30,174}})));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_pT reheatedSteam(
    vleFluidType=medium,
    T=convert2reheatTemperature.y[1]*T_RH_nom,
    p=to_pRH.y) annotation (Placement(transformation(extent={{48,154},{68,174}})));
  Modelica.Blocks.Tables.CombiTable1Dv convert2reheatTemperature(columns={2}, table=CL_Trh_Q_) annotation (Placement(transformation(extent={{0,120},{20,140}})));

  Modelica.Blocks.Tables.CombiTable1Dv convert2reheatMassFlow(columns={2}, table=CL_mLS_QF_) annotation (Placement(transformation(extent={{140,40},{160,60}})));
  Modelica.Blocks.Interfaces.RealOutput h_evap "evaporator outlet specific enthalpy"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={98,-106}), iconTransformation(extent={{100,-10},{120,10}},
          rotation=0)));
  Modelica.Blocks.Tables.CombiTable1Dv convert2PressureDrop_IP(columns={2}, table=CL_Delta_pIP_mLS_) annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Fundamentals.BoilerSummary        summaryIdeal(
    p_feed=feedwater.p,
    h_feed=actualStream(feedwater.h_outflow),
    m_flow_feed=feedwater.m_flow,
    p_LS=p_LS,
    m_flow_LS=convert2LiveSteamFlow.y[1]*m_flow_nomLS,
    h_LS=if calcOutletPressures then liveSteam.h else 0,
    p_cRH=reheat_in.p,
    h_cRH=actualStream(reheat_in.h_outflow),
    m_flow_cRH=reheat_in.m_flow,
    p_hRH=reheat_out.p,
    h_hRH=if calcOutletPressures then reheatedSteam.h else 0,
    m_flow_hRH=convert2reheatMassFlow.y[1]*m_flow_nomLS) "Values as defined by transfer functions"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fundamentals.BoilerSummary        summaryReal(
    p_feed=feedwater.p,
    h_feed=actualStream(feedwater.h_outflow),
    m_flow_feed=feedwater.m_flow,
    p_cRH=reheat_in.p,
    h_cRH=actualStream(reheat_in.h_outflow),
    m_flow_cRH=reheat_in.m_flow,
    p_hRH=reheat_out.p,
    p_LS=livesteam.p,
    h_LS=actualStream(livesteam.h_outflow),
    h_hRH=actualStream(reheat_out.h_outflow),
    m_flow_LS=-livesteam.m_flow,
    m_flow_hRH=-reheat_out.m_flow) "Values as seen at connectors"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Basics.Interfaces.EyeOut eye_LS    if showData
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-28,188}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-40,226})));
protected
  Basics.Interfaces.EyeIn eye_intLS[1]
    annotation (Placement(transformation(extent={{-31,159},{-29,161}})));
public
  Basics.Interfaces.EyeOut eye_RH    if showData
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={100,188}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={100,226})));
protected
  Basics.Interfaces.EyeIn eye_intRH[1]
    annotation (Placement(transformation(extent={{97,167},{99,169}})));
equation
  if not yTInputIsActive then
    turbineValveCharacteristics.u[1]=y_T_const_;
  end if;
  p_LS=convert2LiveSteamPressure.y[1]*p_LS_nom;

//___________________feedwater connector definition_______________________________
  feedwater.p = convert2PressureDrop_HP.y[1]*Delta_p_nomHP + convert2LiveSteamPressure.y[1]*p_LS_nom;
  feedwater.h_outflow=1330e3; //This is a generic value (to be refined in the future)
  feedwater.xi_outflow=ones(medium.nc-1);//dummy

//___________________Live steam connector definition______________________________

   if calcOutletPressures then
     livesteam.p=homotopy(convert2LiveSteamPressure.y[1]*p_LS_nom, p_LS_nom);
   else
     livesteam.m_flow=homotopy(-convert2LiveSteamFlow.y[1]*m_flow_nomLS, -m_flow_nomLS);
   end if;
  livesteam.h_outflow=liveSteam.h;
  livesteam.xi_outflow=ones(medium.nc-1); //dummy

//___________________Reheat inlet connector definition____________________________
  reheat_in.p= convert2PressureDrop_IP.y[1]*Delta_p_nomIP + to_pRH.y;
  reheat_in.h_outflow=reheatedSteam.h;
  reheat_in.xi_outflow=ones(medium.nc-1); //dummy

//___________________Reheat outlet connector definition___________________________
   if calcOutletPressures then
     reheat_out.p=to_pRH.y;
   else
     reheat_out.m_flow=-convert2reheatMassFlow.y[1]*m_flow_nomLS;
   end if;
  reheat_out.h_outflow=reheatedSteam.h;
  reheat_out.xi_outflow=ones(medium.nc-1); //dummy
//_________________________________________________________________________________

  h_evap=liveSteam.VLE.h_v+ 50e3;

  eye_intLS[1].p=livesteam.p/1e5;
  eye_intLS[1].h=livesteam.h_outflow/1e3;
  eye_intLS[1].m_flow=-livesteam.m_flow;
  eye_intLS[1].T=liveSteam.T-273.15;
  eye_intLS[1].s=liveSteam.s/1e3;

  eye_intRH[1].p=reheat_out.p/1e5;
  eye_intRH[1].h=reheat_out.h_outflow/1e3;
  eye_intRH[1].m_flow=-reheat_out.m_flow;
  eye_intRH[1].T=reheatedSteam.T-273.15;
  eye_intRH[1].s=reheatedSteam.s/1e3;

initial equation
  heatRelease.y = QF_setl_;
  SteamStorage.y= QF_setl_;
  energyStroage_RH_IPLP_turbine.y= QF_setl_;


equation
  connect(feedback.y, SteamStorage.u) annotation (Line(
      points={{-9,0},{-6,0},{-6,90},{-2,90}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(heatRelease.y, feedback.u1) annotation (Line(
      points={{-37,0},{-26,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QF_setl_, heatRelease.u) annotation (Line(
      points={{-100,0},{-60,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SteamStorage.y, turbineValveModel.u1)
                                           annotation (Line(
      points={{21,90},{34,90},{34,-24},{38,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbineValveModel.y, feedback.u2)
                                       annotation (Line(
      points={{61,-30},{78,-30},{78,-54},{-18,-54},{-18,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbineValveCharacteristics.y[1], turbineValveModel.u2)
                                                            annotation (Line(
      points={{23,-36},{38,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbineValveModel.y, convert2LiveSteamFlow.u[1])
                                                      annotation (Line(
      points={{61,-30},{98,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2LiveSteamPressure.u[1], SteamStorage.y) annotation (Line(
      points={{38,90},{21,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2LiveSteamFlow.y[1], convert2PressureDrop_HP.u[1])
                                                                 annotation (
      Line(
      points={{121,-30},{138,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbineValveModel.y, energyStroage_RH_IPLP_turbine.u)
                                                           annotation (Line(
      points={{61,-30},{72,-30},{72,50},{100,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatRelease.y, convert2reheatTemperature.u[1]) annotation (Line(
      points={{-37,0},{-32,0},{-32,130},{-2,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(energyStroage_RH_IPLP_turbine.y, convert2reheatMassFlow.u[1])
    annotation (Line(
      points={{123,50},{138,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2IntermediatePressure.y[1], to_pRH.u) annotation (Line(
      points={{121,90},{138,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2LiveSteamPressure.y[1], convert2IntermediatePressure.u[1])
    annotation (Line(
      points={{61,90},{98,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eye_LS, eye_intLS[1])
                        annotation (Line(
      points={{-28,188},{-28,160},{-30,160}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_RH, eye_intRH[1])
                        annotation (Line(
      points={{100,188},{100,168},{98,168}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(convert2LiveSteamFlow.y, convert2PressureDrop_IP.u) annotation (Line(
      points={{121,-30},{130,-30},{130,10},{138,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,220}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,220}}), graphics={
        Polygon(
          points={{-10,10},{-10,-10},{10,10},{10,-10},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={13,84,170},
          origin={0,120},
          rotation=90),
        Line(
          points={{2,120},{-112,120}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>
This steam generator model is based on transfer functions and characteristic lines. The aim of this model is to provide reasonable boundary conditions for other parts of the water steam cycle depending on the currend load. <strong>Be careful when combining this model with controllers and other physically motivated models</strong> as the model may behave in a unrealistic manner when used in off-design statesd!<br>
</p>

<p>
<strong>Usage advices:</strong><br>
<ul>
<li>The default parameter set do not refer to any real plant</li>
<li>The inlet pressures (feedwater and cold reheat) are calculated due to the given relative heating power given. Any effects of disturbances in the equlibrium of heating and cooling are neglected. The model provides an ideal feedwater pressure condition (independent from the expansion or the preheating path)</li>
<li>The inlet pressures (feedwater and cold reheat) take pressure losses using a caracteristic line into account. Any effects of local changing phsical states are neglected</li>
<li>The live steam temperature is ideally controlled at a variable temperature. This temperature is used to calculate the live steam specific enthalpy</li>
<li>The hot reheat temperature is ideally following the design profile. This temperature is used to calculate the hot reheat specific enthalpy</li>
<li>At the lifesteam outlet adn the hot reheat outlet either an ideal pressure boundary condition or an ideal mass flow boundary is provided, not both at the same time. This means for instance that a boiler defining an ideal live steam pressure (as defined in the corresponding characteristic line for part load definition) the mass flow depends on the flow model (e.g. a turbine mode) following the boiler. This mass flow rate may differ from the design mass flow rate. However, there is no feedback of the surrounding models to the ideal beahaviour of the boiler.</li>
<li>Be careful with turbine valve throttling the steam storage and mass flow through the valve will not be modelled in a correct way! The turbine valve opeing is included for the sake of completeness (see VDI cuideline 3508). </li>
</ul>
</p>
</html><html>
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
end SteamGenerator_L1;
