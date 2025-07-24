within ClaRa.Components.Mills.HardCoalMills;
model VerticalMill_L3 "Vertical roller mill such as ball-and-race mill and roller-bowl mills"
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

  extends ClaRa.Basics.Icons.RollerBowlMill;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_elMech=0,
    powerOut_th=0,
    powerAux=P_mills) if contributeToCycleSummary;

  outer ClaRa.SimCenter simCenter;

////////////////// PARAMETERS /////////////////////////
//________Materials and Media_______
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1  "Fuel type"   annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFraction xi_coal_h2o_res=0 "Residual moisture of coal" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter TILMedia.Gas.Types.BaseGas gas=simCenter.flueGasModel "Medium to be used in tubes"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

//________Mill definition___________
  parameter ClaRa.Components.Mills.HardCoalMills.Fundamentals.RollerBowlMillDefinition  millKoeff=
      ClaRa.Components.Mills.HardCoalMills.Fundamentals.STV1() "Coefficients of the mill"  annotation(choicesAllMatching, Dialog(group="Mill Definition"));
  parameter Integer N_mills= 1 "Number of equal mills in parallel" annotation(Dialog(group="Mill Definition"));

//________Initialisation____________
  parameter Basics.Units.Temperature T_out_start=simCenter.T_amb_start "Initial temperature in mill" annotation (Dialog(tab="Initialisation"));
  parameter Basics.Units.Mass mass_rct_start=1000 "Initial mass of Raw Coal on the Table" annotation (Dialog(tab="Initialisation"));
  parameter Basics.Units.Mass mass_pct_start=100 "Initial mass of Pulverized Coal on the Table" annotation (Dialog(tab="Initialisation"));
  parameter Basics.Units.Mass mass_pca_start=100 "Initial mass of Pulverized Coal in the Air" annotation (Dialog(tab="Initialisation"));
  parameter Basics.Units.MassFraction xi_wc_start[fuelModel.N_c - 1]=fuelModel.defaultComposition "Initial Wet Coal composition" annotation (Dialog(tab="Initialisation"));
  parameter Basics.Units.MassFlowRate m_flow_air_out_start=1 "Initial primary air outlet mass flow rate" annotation (Dialog(tab="Initialisation"));
  inner parameter Integer  initOption=0 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=203 "Steady temperature", choice = 801 "Steady masses"));


//________Summary and Visualisation_
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));

//________Expert Settings___________
  parameter Boolean applyGrindingDelay = false "True if grinding process introduces a dead time" annotation(Dialog(tab="Expert Settings"));
  parameter Basics.Units.Time Tau_delay=120 "Grinding dead time" annotation (Dialog(enable=applyGrindingDelay, tab="Expert Settings"));
  parameter Boolean activateGrindingStatus=false "True, if Status input is activated which makes it possible to stop the grinding process" annotation(Dialog(group="Shutdown",tab="Expert Settings"));

///////////////// VARAIABLE DECLARATION ///////////////
//_________Masses_______________
protected
  Basics.Units.Mass mass_rct(start=mass_rct_start) "Mass of raw coal on the table";
  Basics.Units.Mass mass_pct(start=mass_pct_start) "Mass of pulverized coal on the table";
  Basics.Units.Mass mass_pca(start=mass_pca_start) "Mass of pulverized coal carried by primary air";

//________Mass Flows___________
  Basics.Units.MassFlowRate m_flow_rct "Mass flow rate of raw coal entering the grinding table";
  Basics.Units.MassFlowRate m_flow_pc "Mass flow rate of pulverized coal";
  Basics.Units.MassFlowRate m_flow_rc_in "Mass flow of raw coal to the mill";
  Basics.Units.MassFlowRate m_flow_wc_out "Mass flow rate of wet pulverized coal from the grinding zone";
  Basics.Units.MassFlowRate m_flow_pc_ret "Mass flow rate of coal returnig to the table";
  Basics.Units.MassFlowRate m_flow_air_in "Primary air inlet mass flow rate";
  Basics.Units.MassFlowRate m_flow_evap "Mass flow rate of evaporated coal H2O //m_flow_evap";
  Basics.Units.MassFlowRate m_flow_air_evap_max "Maximum evaporation flow until air saturation";
  Basics.Units.MassFlowRate m_flow_coal_evap_max "Maximum evaporation flow until coal dry out";

  Basics.Units.MassFlowRate m_flow_air_out(start=m_flow_air_out_start) "Primary air outlet mass flow rate";
  Basics.Units.MassFlowRate m_flow_rcg "Mass flow of raw coal entering the grinding zone";
  Basics.Units.MassFlowRate m_flow_dc_out "Mass flow of dried coal leaving the mill";

//________Mass Fractions_______
  Basics.Units.MassFraction xi_rc_in[fuelModel.N_c - 1] "Mositure content of incoming raw coal";
  Basics.Units.MassFraction xi_wc_out[fuelModel.N_c - 1] "Average composition of wet coal after grinding";

  Basics.Units.MassFraction xi_dc_out[fuelModel.N_c - 1] "Coal composition of dried coal at outlet";

  Basics.Units.MassFraction xi_air_in[gas.nc - 1] "Composition of incoming air";
  Basics.Units.MassFraction xi_air_out[gas.nc - 1] "Composition of outgoing air";
  constant Basics.Units.MassFraction xi_evap_coal[fuelModel.N_c - 1]=cat(
      1,
      zeros(fuelModel.waterIndex - 1),
      if fuelModel.waterIndex < fuelModel.N_c then {1} else zeros(0),
      zeros(max(0, fuelModel.N_c - fuelModel.waterIndex - 1))) "Composition of evaporating water (in terms of coal)";
  constant Basics.Units.MassFraction xi_evap_air[gas.nc - 1]=cat(
      1,
      zeros(gas.condensingIndex - 1),
      {1},
      zeros(gas.nc - gas.condensingIndex - 1)) "Composition of evaporating water (in terms of air)";

//________Pressures____________
  Basics.Units.Pressure Delta_p_pa(displayUnit="Pa") "Primary air difference pressure";

//________Temperatures_________
  Basics.Units.Temperature T_out(start=T_out_start) "Classifier Temperature (outlet temperature)";
  Basics.Units.Temperature T_coal_in "Coal inlet temperature";
  Basics.Units.Temperature T_air_in "Primary air inlet temperature";

//________Coal specifics_______
//  Basics.Units.EnthalpyMassSpecific LHV_dry(start=fuelModel.LHV_waf_pTxi(p_start,T_start,xi_start)) "Lower heating value after drying inside mill";
  Basics.Units.EnthalpyMassSpecific Delta_h_evap "Heat of vaporization";
//  Basics.Units.HeatCapacityMassSpecific cp_w "Specific heat capacity of liquid water in the raw coal";
//  Basics.Units.HeatCapacityMassSpecific cp_dc_in "Specific heat capacity of ideally dried coal at inlet condition";

//_______Mechanics_____________
  Real P_grind "Power consumed for grinding in p.u.";
  Basics.Units.Frequency rpm=classifierSpeed "Rotational speed of clasiifier";

  //______Auxilliary Variables_

  SMArtInt.Internal.ClaRaDelay.ExternalTable pointer_W_c= SMArtInt.Internal.ClaRaDelay.ExternalTable() "Pointer for delay memory allocation";

  Real grindingStatus_;

public
  Modelica.Blocks.Interfaces.RealOutput Delta_p_mill(unit="Pa") "Pressure Difference between inlet and outlet connector"
                                                    annotation(Placement(transformation(extent={{100,50},
            {140,90}})));
  Modelica.Blocks.Interfaces.RealInput classifierSpeed "Speed of classifier"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108})));
  TILMedia.Gas.Gas_pT gasIn(
    p=inlet.flueGas.p,
    T=inStream(inlet.flueGas.T_outflow),
    xi=inStream(inlet.flueGas.xi_outflow),
    gasType=gas) annotation (Placement(transformation(extent={{-88,-70},{-68,-50}})));

  ClaRa.Components.Mills.HardCoalMills.Fundamentals.SummaryMill summary(
    T_coal_in=T_coal_in,
    T_air_in=T_air_in,
    rpm_classifier=classifierSpeed*60,
    P_grind=P_grind,
    m_flow_air_out=-outlet.flueGas.m_flow,
    mass_coal=N_mills*(mass_pca + mass_pct + mass_rct),
    m_flow_coal_in=inlet.fuel.m_flow,
    m_flow_air_in=inlet.flueGas.m_flow,
    m_flow_tot_in=inlet.fuel.m_flow + inlet.flueGas.m_flow,
    m_flow_coal_out=-outlet.fuel.m_flow,
    m_flow_tot_out=-outlet.fuel.m_flow - outlet.flueGas.m_flow,
    T_out=T_out,
    xi_coal_h2o_in = coalIn.xi_h2o,
    xi_coal_h2o_out = coalOut.xi_h2o,
    xi_air_h2o_in = xi_air_in[8],
    xi_air_h2o_out=xi_air_out[8],
    xi_air_h2o_sat=gasOut.xi_s,
    LHV_in = coalIn.LHV,
    LHV_out = coalOut.LHV) annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Basics.Interfaces.FuelFlueGas_inlet inlet(flueGas(Medium=gas), fuelModel=fuelModel) "Combined gas-and-coal(raw, wet) inlet" annotation (Placement(transformation(extent={{-110,-8},{-90,12}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.FuelFlueGas_outlet outlet(flueGas(Medium=gas), fuelModel=fuelModel) "Combined gas-and-coal(pulverised, dry) outlet" annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TILMedia.Gas.Gas_pT gasOut(
    p=outlet.flueGas.p,
    T=T_out,
    gasType=gas,
    xi=xi_air_out) annotation (Placement(transformation(extent={{70,-68},{90,-48}})));
  Modelica.Blocks.Interfaces.RealOutput P_mills(unit="W") "Mill power of all parallel mills"
                                                    annotation(Placement(transformation(extent={{100,22},
            {140,62}})));

  Modelica.Blocks.Interfaces.RealInput grindingStatus=grindingStatus_ if (activateGrindingStatus) "Input to stop grinding process, when mill is shutdown" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,108})));
  ClaRa.Basics.Media.FuelObject coalIn(
    p=inlet.fuel.p,
    T=inStream(inlet.fuel.T_outflow),
    xi_c=inStream(inlet.fuel.xi_outflow),
    fuelModel=fuelModel) annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
  ClaRa.Basics.Media.FuelObject coalOut(
    p=outlet.fuel.p,
    T=outlet.fuel.T_outflow,
    xi_c=outlet.fuel.xi_outflow,
    fuelModel=fuelModel) annotation (Placement(transformation(extent={{70,-10},{90,10}})));
protected
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid H2O_props(redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater
      vleFluidType);
initial equation
  xi_wc_out = xi_wc_start;

  if initOption == 0 then
  //do nothing
  elseif initOption == 801 then
    der(mass_rct)=0;
    der(mass_pca)=0;
    der(mass_pct)=0;
  elseif initOption == 203 then
    der(T_out)=0;
  elseif initOption == 1 then
    der(mass_rct)=0;
    der(mass_pca)=0;
    der(mass_pct)=0;
    der(T_out)=0;
  else
    assert(false, "Unknown initialisation option in "+ getInstanceName());
  end if;

equation
////////////////////////////////////////////
/// Additional Media Data                ///
  Delta_h_evap =TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dewSpecificEnthalpy_Txi(
    T_coal_in,
    {1},
    H2O_props.vleFluidPointer) - TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.bubbleSpecificEnthalpy_Txi(
    T_coal_in,
    {1},
    H2O_props.vleFluidPointer);

////////////////////////////////////////////
/// Grinding Process                     ///
  m_flow_pc = millKoeff.K_5*m_flow_air_in*mass_pct;
  m_flow_wc_out = millKoeff.K_4*mass_pca*(1-min(rpm,millKoeff.K_6)/millKoeff.K_6);
  m_flow_pc_ret = millKoeff.K_9*mass_pca;

  // activateGrindingStatus == true the grinding process can be stopped by setting the input grindingStatus to zero

  if not (activateGrindingStatus) then
    grindingStatus_=1;
  end if;
    m_flow_rcg = millKoeff.K_1*mass_rct*grindingStatus_;

  //this is beyond Nimcyks model: a dead time taking particle transport
  //  from the entrance to the grinding table
  if applyGrindingDelay then
    m_flow_rct = ClaRa.Basics.Functions.ClaRaDelay.getDelayValuesAtTime(
       pointer_W_c,
       time,
       m_flow_rc_in,
       time-Tau_delay);
  else
    m_flow_rct = m_flow_rc_in;
  end if;

////////////////////////////////////////////
/// Coal Mass Balance                    ///

//_______Mass balances for the grinding table and the transport area:
  der(mass_rct) = m_flow_rct + m_flow_pc_ret - m_flow_rcg;

  // activateGrindingStatus == true the grinding process can be stopped by setting the input grindingStatus to zero
  der(mass_pct) = millKoeff.K_1*mass_rct*grindingStatus_ - m_flow_pc;

  der(mass_pca) = m_flow_pc - m_flow_wc_out - m_flow_pc_ret;

//_______Species balance in grinding area
  der(xi_wc_out) = (m_flow_rct * xi_rc_in - m_flow_wc_out * xi_wc_out - xi_wc_out*(der(mass_rct) + der(mass_pct) + der(mass_pca))) /(mass_rct + mass_pct + mass_pca);

//_______Drying of coal, after grinding process
  m_flow_dc_out = m_flow_wc_out - m_flow_evap;
  xi_dc_out = (m_flow_wc_out*xi_wc_out - m_flow_evap*xi_evap_coal)/max(1e-6,m_flow_dc_out);

////////////////////////////////////////////
/// Coal Drying                          ///
  m_flow_air_evap_max = m_flow_air_in*(gasOut.xi_s-gasIn.xi[8]);//Maximum H2O evaporation mass flow until air is saturated
  m_flow_coal_evap_max = m_flow_rct*(coalIn.xi_h2o - xi_coal_h2o_res);//Maximum H2O evaporation mass flow until coal is dry

  if noEvent(m_flow_coal_evap_max <= m_flow_air_evap_max) then //Amount of coal H2O evaporation (if < m_flow_air_evap_max then ideal drying)
    m_flow_evap = m_flow_wc_out*(coalIn.xi_h2o - xi_coal_h2o_res);
  else
    m_flow_evap = m_flow_air_evap_max;
  end if;

////////////////////////////////////////////
/// Gas Mass Balance                     ///
  m_flow_air_out = m_flow_air_in + m_flow_evap; //no air mass storage
  xi_air_out = (m_flow_air_in*xi_air_in + m_flow_evap*xi_evap_air)/m_flow_air_out;

////////////////////////////////////////////
/// Gas Moisturing                       ///

////////////////////////////////////////////
/// Global Energy Balance                ///
// the energy balance as in equation (7) of [1] but with the derivative of the coal mass coming from the der(U) term
  der(T_out)=1/millKoeff.K_11*((gasIn.T-273.15)*gasIn.cp*m_flow_air_in
                              + m_flow_rct*coalIn.cp*(T_coal_in-273.15)
                              - m_flow_air_out *gasOut.cp * (gasOut.T-273.15)
                              - m_flow_evap * Delta_h_evap
                              - m_flow_dc_out * coalOut.cp * (T_out-273.15)
                              + millKoeff.K_10*P_grind*100 - (der(mass_rct)+der(mass_pct)+der(mass_pca))*coalOut.cp*(T_out-273.15));

////////////////////////////////////////////
/// Effort for Grinding                  ///

  // activateGrindingStatus == true the grinding process can be stopped by setting the input grindingStatus to zero
  P_grind = (0.01*(millKoeff.K_2*mass_pct+millKoeff.K_3*mass_rct)+millKoeff.E_e)*grindingStatus_;

  P_mills = millKoeff.P_nom*P_grind*N_mills;

////////////////////////////////////////////
/// Hydraulics                           ///
  Delta_p_pa = millKoeff.K_12*abs(m_flow_air_in)*m_flow_air_in/max(gasIn.d,0.0001); //From mill volume flow measurement using an orifice
  Delta_p_mill = millKoeff.K_7 * Delta_p_pa + millKoeff.K_8*mass_pca*100;

////////////////////////////////////////////
/// Connector Couplings                  ///
  T_air_in = inStream(inlet.flueGas.T_outflow);
  m_flow_air_in = inlet.flueGas.m_flow/N_mills;
  xi_air_in = inStream(inlet.flueGas.xi_outflow);
  T_coal_in = inStream(inlet.fuel.T_outflow);
  m_flow_rc_in = inlet.fuel.m_flow/N_mills;
  xi_rc_in = inStream(inlet.fuel.xi_outflow);

  inlet.fuel.p = inlet.flueGas.p;
  inlet.fuel.T_outflow = T_out; //DUMMY value - backflow is not supported!
  inlet.fuel.xi_outflow = inStream(outlet.fuel.xi_outflow); //DUMMY value - backflow is not supported!

  inlet.flueGas.p = outlet.flueGas.p + Delta_p_pa;
  inlet.flueGas.T_outflow = T_out; //DUMMY value - backflow is not supported!
  inlet.flueGas.xi_outflow = inStream(outlet.flueGas.xi_outflow);//DUMMY value - backflow is not supported!

  outlet.fuel.m_flow = -m_flow_dc_out*N_mills;
  outlet.fuel.T_outflow = T_out;
  outlet.fuel.xi_outflow = xi_dc_out;
  outlet.flueGas.T_outflow = T_out;
  outlet.flueGas.xi_outflow = xi_air_out;
  outlet.flueGas.m_flow = -m_flow_air_out*N_mills;

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
</html>"),                   Icon(graphics));
end VerticalMill_L3;
