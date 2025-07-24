within ClaRa.StaticCycles.Check.StaticCycleExamples;
model SteamCycle_4NDV_3HDV_01 "Helps you to find reasonable start values for steam cycles"
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
  extends ClaRa.Basics.Icons.Init;
  import TILMedia.VLEFluid.MixtureCompatible.Functions.*;
  import SI = ClaRa.Basics.Units;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component" annotation (choices(
      choice=simCenter.fluid1 "First fluid defined in global simCenter",
      choice=simCenter.fluid2 "Second fluid defined in global simCenter",
      choice=simCenter.fluid3 "Third fluid defined in global simCenter"), Dialog(group="Fundamental Definitions"));

//__________________global parameter_______________________
  inner parameter Real P_target_= 1 "Value of load in p.u."    annotation(Dialog(group="Global parameter"));
  parameter Basics.Units.MassFlowRate m_flow_nom=417 "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));
  parameter Basics.Units.Temperature T_LS_nom=823 "Live steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter Basics.Units.Temperature T_RS_nom=833 "Reheated steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter String mediumName = "R718" annotation(Dialog(group="Global parameter"));
  final parameter Basics.Units.HeatFlowRate Q_nom=boiler.m_flow_feed*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_cRH*(boiler.h_RS_out - boiler.h_RS_in) "Nominal heat flow rate" annotation (Dialog(group="Global parameter"));
  final parameter Basics.Units.MassFlowRate m_flow_FW=m_flow_nom*P_target_ "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));

//________________preheater_HP parameter________________________
  parameter ClaRa.Basics.Units.Pressure preheater_HP_p_tap=55.95e5 annotation (Dialog(group="preheater_HP", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate preheater_HP_m_flow_tap=42.812 annotation (Dialog(group="preheater_HP", tab="Preheater"));

//________________preheater_IP1 parameter________________________
  parameter ClaRa.Basics.Units.Pressure preheater_IP1_p_tap=26.77e5 annotation (Dialog(group="preheater_IP1", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate preheater_IP1_m_flow_tap=19.337 annotation (Dialog(group="preheater_IP1", tab="Preheater"));

//________________turbine_IP2 parameter________________________
  parameter ClaRa.Basics.Units.Pressure p_out_IP2=13.2e5 annotation (Dialog(group="turbine_IP2", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate IP2_m_flow_tap=17.102 annotation (Dialog(group="turbine_IP2", tab="Preheater"));

//________________preheater_IP3 parameter________________________
  parameter ClaRa.Basics.Units.Pressure preheater_IP3_p_tap=6.488e5 annotation (Dialog(group="preheater_IP3", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate preheater_IP3_m_flow_tap=23.75 annotation (Dialog(group="preheater_IP3", tab="Preheater"));

//________________preheater_LP1 parameter________________________
  parameter ClaRa.Basics.Units.Pressure preheater_LP1_p_tap=2.011e5 annotation (Dialog(group="preheater_LP1", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate preheater_LP1_m_flow_tap=23.072 annotation (Dialog(group="preheater_LP1", tab="Preheater"));

//________________preheater_LP2 parameter________________________
  parameter ClaRa.Basics.Units.Pressure preheater_LP2_p_tap=0.49e5 annotation (Dialog(group="preheater_LP2", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate preheater_LP2_m_flow_tap=7.724 annotation (Dialog(group="preheater_LP2", tab="Preheater"));
//________________preheater_LP3 parameter________________________
  parameter ClaRa.Basics.Units.Pressure preheater_LP3_p_tap=0.207e5 annotation (Dialog(group="preheater_LP3", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate preheater_LP3_m_flow_tap=14.504 annotation (Dialog(group="preheater_LP3", tab="Preheater"));

//____________________boiler parameter_____________________
//  parameter ClaRa.Basics.Units.HeatFlowRate Q_nom = 1150e6 annotation(Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure p_LS_out_nom=250.2e5 "Live steam pressure at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure p_RS_out_nom=51e5 "Reaheated steam pressure at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure dp_LS_nom=89e5 "Live steam pressure loss in boiler at nomninal point" annotation (Dialog(tab="Boiler"));
  parameter Basics.Units.Pressure dp_RS_nom=5e5 "Reheated steam pressure loss in boiler at nomninal point" annotation (Dialog(tab="Boiler"));

  parameter Real CharLine_dpHP_mLS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group = "CharLines", tab="Boiler"));
  parameter Real CharLine_dpIP_mRS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(group = "CharLines",  tab="Boiler"));

//___________________pump parameter________________________
parameter Real efficiency_Pump_FW=1 "Efficiency of freshwater pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_cond=1 "Efficiency of condenser pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheat=1 "Efficiency of preheater pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheater_IP3=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheater_LP1=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheater_LP2=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));
parameter Real efficiency_Pump_preheater_LP3=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));

//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_IP1=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_IP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_IP3=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP1=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP3=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP4=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

// __________________Feewatertank parameter________________
  parameter Basics.Units.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation (Dialog(tab="Heat exchangers", group="Feedwatertank"));

//___________________condenser parameter___________________
  parameter Basics.Units.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers", group="Condenser"));

  //________________ valves parameter________________________
  parameter ClaRa.Basics.Units.Pressure valve_HP_control_dp_nominal=2e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_IP_control_dp_nominal=2e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve1_HP_dp_nominal=2e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_IP1_dp_nominal=1e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_IP2_dp_nominal=0.8e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_IP3_dp_nominal=1e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_LP2_dp_nominal=0.001e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_LP3_dp_nominal=0.001e5 annotation (Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Machines.Pump1 pump_fw(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{78,-190},{38,-150}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{0,90},{30,150}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_IP2(efficiency=efficiency_Turb_IP2) annotation (Placement(transformation(extent={{256,116},{286,176}})));
  Furnace.Boiler_simple boiler(
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_IP_mRS_=CharLine_dpIP_mRS_,
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_dpHP_mLS_,
    Delta_p_LS_nom=dp_LS_nom,
    Delta_p_RS_nom=dp_RS_nom,
    m_flow_LS_nom=m_flow_nom,
    m_flow_RS_nom=m_flow_nom) annotation (Placement(transformation(extent={{-110,54},{-70,94}})));

  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{1010,-16},{1052,24}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_IP2(Delta_p_nom=p_out_IP2 - p_FWT) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={326,31})));
  ClaRa.StaticCycles.Storage.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_nom) annotation (Placement(transformation(extent={{318,-180},{268,-152}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP3(Delta_p_nom=valve_LP3_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={890,33})));
  ClaRa.StaticCycles.Machines.Pump1 pump_cond(efficiency=efficiency_Pump_cond) annotation (Placement(transformation(extent={{1018,-190},{978,-150}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP1(efficiency=efficiency_Turb_LP1) annotation (Placement(transformation(extent={{596,116},{626,176}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP annotation (Placement(transformation(extent={{316,110},{336,130}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP1 annotation (Placement(transformation(extent={{880,110},{900,130}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP3(m_flow_tap_nom=preheater_LP3_m_flow_tap, p_tap_nom=preheater_LP3_p_tap - valve_LP3_dp_nominal) annotation (Placement(transformation(extent={{914,-192},{868,-148}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP4(efficiency=efficiency_Turb_LP4) annotation (Placement(transformation(extent={{952,116},{982,176}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_HP(m_flow_tap_nom=preheater_HP_m_flow_tap, p_tap_nom=preheater_HP_p_tap - valve1_HP_dp_nominal) annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-90,-62})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP_turbine2 annotation (Placement(transformation(extent={{14,28},{-6,48}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_dp_nom(Delta_p_nom=valve1_HP_dp_nominal) annotation (Placement(transformation(extent={{-22,-67},{-42,-57}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve1 annotation (Placement(transformation(extent={{-24,34},{-44,48}})));
  ClaRa.StaticCycles.Fittings.Mixer1 mixer annotation (Placement(transformation(extent={{960,-180},{940,-168}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP2(p_tap_nom=preheater_LP2_p_tap - valve_LP2_dp_nominal, m_flow_tap_nom=preheater_LP1_m_flow_tap + preheater_LP2_m_flow_tap) annotation (Placement(transformation(extent={{808,-192},{762,-148}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP2(Delta_p_nom=valve_LP2_dp_nominal) annotation (Placement(transformation(
        extent={{-9.5,-4.5},{9.5,4.5}},
        rotation=270,
        origin={739.5,-65.5})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP3(efficiency=efficiency_Turb_LP3) annotation (Placement(transformation(extent={{814,116},{844,176}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP2 annotation (Placement(transformation(extent={{768,110},{788,130}})));
  ClaRa.StaticCycles.Machines.Pump1 pump_preheater_LP2(efficiency=efficiency_Pump_preheater_LP2) annotation (Placement(transformation(extent={{772,-248},{732,-208}})));
  ClaRa.StaticCycles.Fittings.Mixer1 mixer1 annotation (Placement(transformation(extent={{723,-180},{706,-168}})));
  ClaRa.StaticCycles.Machines.Pump1 Pump_preheater_LP3(efficiency=efficiency_Pump_preheater_LP3) annotation (Placement(transformation(extent={{898,-248},{938,-208}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP2(efficiency=efficiency_Turb_LP2) annotation (Placement(transformation(extent={{710,116},{740,176}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP3 annotation (Placement(transformation(extent={{650,110},{670,130}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP1(m_flow_tap_nom=preheater_LP1_m_flow_tap, p_tap_nom=preheater_LP1_p_tap - valve_LP1_dp_nominal) annotation (Placement(transformation(extent={{684,-192},{638,-148}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10.5,-5},{10.5,5}},
        rotation=270,
        origin={661,-66.5})));
  ClaRa.StaticCycles.Fittings.Mixer3 mixer3_1 annotation (Placement(transformation(extent={{730,-98},{750,-110}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve2 annotation (Placement(transformation(
        extent={{-12,-6},{12,6}},
        rotation=90,
        origin={696,-130})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP4 annotation (Placement(transformation(extent={{462,108},{482,128}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_IP3(efficiency=efficiency_Turb_IP3) annotation (Placement(transformation(extent={{374,114},{404,174}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_IP3(m_flow_tap_nom=preheater_IP3_m_flow_tap, p_tap_nom=preheater_IP3_p_tap - valve_IP3_dp_nominal) annotation (Placement(transformation(extent={{494,-192},{448,-148}})));
  ClaRa.StaticCycles.Machines.Pump1 pump_preheater_IP3(efficiency=efficiency_Pump_preheater_IP3) annotation (Placement(transformation(extent={{448,-250},{408,-210}})));
  ClaRa.StaticCycles.Fittings.Mixer1 mixer3 annotation (Placement(transformation(extent={{406,-182},{386,-162}})));
  ClaRa.StaticCycles.Fittings.Mixer3 mixer3_2 annotation (Placement(transformation(extent={{210,-112},{230,-132}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_IP1(efficiency=efficiency_Turb_IP1) annotation (Placement(transformation(extent={{144,114},{174,174}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP5 annotation (Placement(transformation(extent={{198,108},{218,128}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_IP1(Delta_p_nom=valve_IP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={208,29})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_IP1(m_flow_tap_nom=preheater_IP1_m_flow_tap, p_tap_nom=preheater_IP1_p_tap - valve_IP1_dp_nominal) annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-90,4})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve4 annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=180,
        origin={-130,-62})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve3 annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=180,
        origin={-130,4})));
  ClaRa.StaticCycles.Fittings.Mixer1 mixer4_1 annotation (Placement(transformation(
        extent={{10,-3.99991},{-10,3.99992}},
        rotation=90,
        origin={-156,-61})));
  ClaRa.StaticCycles.HeatExchanger.Preheater2 preheater_HP_IP1(p_tap_nom=preheater_IP1_p_tap - valve_IP1_dp_nominal) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-90,-124})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve5 annotation (Placement(transformation(
        extent={{10,-5},{-10,5}},
        rotation=180,
        origin={-30,-124})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_IP3(Delta_p_nom=valve_IP3_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={472,29})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom2 valve_dp_nom2_1(Delta_p_nom=valve_HP_control_dp_nominal) annotation (Placement(transformation(extent={{-40,126},{-20,140}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom2 valve_IP_control(Delta_p_nom=valve_IP_control_dp_nominal) annotation (Placement(transformation(extent={{-40,150},{-20,164}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom3 valve_dp_nom3_1(Delta_p_nom=6e5) annotation (Placement(transformation(extent={{364,-176},{344,-162}})));
equation
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{266.75,-170.667},{174,-170.667},{174,-170},{79,-170}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(preheater_LP3.tap_in, valve_LP3.outlet) annotation (Line(
      points={{891,-146.9},{891,-60.6},{890,-60.6},{890,22}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP4.outlet, condenser.inlet) annotation (Line(
      points={{983.25,122},{1032,122},{1032,74},{1031,74},{1031,25}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_IP2.outlet, split_LP.inlet) annotation (Line(
      points={{287.25,122},{300,122},{300,126.667},{315,126.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_IP2.inlet) annotation (Line(
      points={{326,108.333},{326,42}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP3.inlet) annotation (Line(
      points={{890,108.333},{890,44}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1,turbine_LP4. inlet) annotation (Line(
      points={{901,126.667},{928,126.667},{928,158},{950.75,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP_turbine2.inlet, turbine_HP.outlet) annotation (Line(
      points={{15,44.6667},{32,44.6667},{32,96},{31.25,96}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom.inlet, split_LP_turbine2.outlet_2) annotation (Line(
      points={{-21,-62},{4,-62},{4,26.3333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom.outlet, preheater_HP.tap_in) annotation (Line(
      points={{-43,-62},{-69,-62}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1.inlet, split_LP_turbine2.outlet_1) annotation (Line(
      points={{-23,41},{-19.8,41},{-19.8,44.6667},{-7,44.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(condenser.outlet, pump_cond.inlet) annotation (Line(
      points={{1031,-17},{1031,-170},{1019,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.inlet_1, pump_cond.outlet) annotation (Line(
      points={{961,-170},{977,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.outlet,preheater_LP3. cond_in) annotation (Line(
      points={{939,-170},{915.15,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP2.cond_in,preheater_LP3. cond_out) annotation (Line(
      points={{809.15,-170},{866.85,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP3.outlet, split_LP1.inlet) annotation (Line(
      points={{845.25,122},{862,122},{862,126.667},{879,126.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP2.outlet_1, turbine_LP3.inlet) annotation (Line(
      points={{789,126.667},{800,126.667},{800,158},{812.75,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP2.outlet_2, valve_LP2.inlet) annotation (Line(
      points={{778,108.333},{778,40},{739.5,40},{739.5,-55.05}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater_LP2.inlet, preheater_LP2.tap_out) annotation (Line(
      points={{773,-228},{785,-228},{785,-193.1}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer1.inlet_2, pump_preheater_LP2.outlet) annotation (Line(
      points={{714.5,-181},{715.111,-181},{715.111,-228},{731,-228}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer1.inlet_1, preheater_LP2.cond_out) annotation (Line(
      points={{723.85,-170},{760.85,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_preheater_LP3.inlet,preheater_LP3. tap_out) annotation (Line(
      points={{897,-228},{888,-228},{888,-193.1},{891,-193.1}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_preheater_LP3.outlet, mixer.inlet_2) annotation (Line(
      points={{939,-228},{950,-228},{950,-181}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, split_LP2.inlet) annotation (Line(
      points={{741.25,122},{754,122},{754,126.667},{767,126.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP3.outlet_1, turbine_LP2.inlet) annotation (Line(
      points={{671,126.667},{696,126.667},{696,158},{708.75,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP3.inlet, turbine_LP1.outlet) annotation (Line(
      points={{649,126.667},{636,126.667},{636,122},{627.25,122}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, mixer1.outlet) annotation (Line(
      points={{685.15,-170},{705.15,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP1.inlet, split_LP3.outlet_2) annotation (Line(
      points={{661,-54.95},{661,108.333},{660,108.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP1.outlet, preheater_LP1.tap_in) annotation (Line(
      points={{661,-78.05},{661,-146.9}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_out, valve2.inlet) annotation (Line(
      points={{661,-193.1},{662,-193.1},{662,-228},{696,-228},{696,-143.2}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2.outlet, mixer3_1.inlet_1) annotation (Line(
      points={{696,-116.8},{696,-108},{729,-108}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP2.outlet, mixer3_1.inlet_2) annotation (Line(
      points={{739.5,-75.95},{739.5,-76},{740,-76},{740,-97}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer3_1.outlet, preheater_LP2.tap_in) annotation (Line(
      points={{751,-108},{785,-108},{785,-146.9}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_1,turbine_IP3. inlet) annotation (Line(
      points={{337,126.667},{364,126.667},{364,156},{372.75,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_IP3.outlet, split_LP4.inlet) annotation (Line(
      points={{405.25,120},{432,120},{432,124.667},{461,124.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP4.outlet_1, turbine_LP1.inlet) annotation (Line(
      points={{483,124.667},{568,124.667},{568,158},{594.75,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP3.cond_in, preheater_LP1.cond_out) annotation (Line(
      points={{495.15,-170},{636.85,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP3.tap_out, pump_preheater_IP3.inlet) annotation (Line(
      points={{471,-193.1},{471,-230},{449,-230}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer3.inlet_1,preheater_IP3. cond_out) annotation (Line(
      points={{407,-165.333},{432,-165.333},{432,-170},{446.85,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater_IP3.outlet, mixer3.inlet_2) annotation (Line(
      points={{407,-230},{396,-230},{396,-183.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, mixer3_2.outlet) annotation (Line(
      points={{293,-150.833},{293,-128.667},{231,-128.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer3_2.inlet_2, valve_IP2.outlet) annotation (Line(
      points={{220,-110.333},{220,-44},{326,-44},{326,20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP5.outlet_1, turbine_IP2.inlet) annotation (Line(
      points={{219,124.667},{232,124.667},{232,158},{254.75,158}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP5.inlet, turbine_IP1.outlet) annotation (Line(
      points={{197,124.667},{184,124.667},{184,120},{175.25,120}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP1.inlet, split_LP5.outlet_2) annotation (Line(
      points={{208,40},{208,106.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP.cond_out,preheater_IP1. cond_in) annotation (Line(
      points={{-90,-41},{-90,-17}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP1.tap_in,valve_IP1. outlet) annotation (Line(
      points={{-69,4},{208,4},{208,18}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve4.inlet, preheater_HP.tap_out) annotation (Line(
      points={{-119,-62},{-111,-62}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_IP1.tap_out, valve3.inlet) annotation (Line(
      points={{-111,4},{-119,4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP_IP1.cond_out, preheater_HP.cond_in) annotation (Line(
      points={{-90,-103},{-90,-83}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP_IP1.cond_in, pump_fw.outlet) annotation (Line(
      points={{-90,-145},{-90,-170},{37,-170}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer4_1.inlet_1, valve3.outlet) annotation (Line(
      points={{-158.667,-50},{-158.667,4},{-141,4}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer4_1.outlet, preheater_HP_IP1.tap_in) annotation (Line(
      points={{-158.667,-72},{-158.667,-124},{-111,-124}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve5.outlet, mixer3_2.inlet_1) annotation (Line(
      points={{-19,-124},{92,-124},{92,-128.667},{209,-128.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve5.inlet, preheater_HP_IP1.tap_out) annotation (Line(
      points={{-41,-124},{-69,-124}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP4.outlet_2,valve_IP3. inlet) annotation (Line(
      points={{472,106.333},{472,40}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP3.outlet,preheater_IP3. tap_in) annotation (Line(
      points={{472,18},{472,-146.9},{471,-146.9}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer4_1.inlet_2, valve4.outlet) annotation (Line(
      points={{-151.333,-61},{-144,-61},{-144,-62},{-141,-62}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.liveSteam, valve_dp_nom2_1.inlet) annotation (Line(
      points={{-90,94.8},{-86,94.8},{-86,132},{-41,132},{-41,133}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom2_1.outlet, turbine_HP.inlet) annotation (Line(
      points={{-19,133},{-6,133},{-6,132},{-1.25,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP_control.outlet, turbine_IP1.inlet) annotation (Line(
      points={{-19,157},{-8,157},{-8,156},{142.75,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom3_1.inlet, mixer3.outlet) annotation (Line(
      points={{365,-169},{373.2,-169},{373.2,-165.333},{385,-165.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom3_1.outlet, feedwatertank.cond_in) annotation (Line(
      points={{343,-169},{331.8,-169},{331.8,-170.667},{319.25,-170.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.hotReheat, valve_IP_control.inlet) annotation (Line(points={{-78,94.8},{-78,157},{-41,157}}, color={0,131,169}));
  connect(valve1.outlet, boiler.coldReheat) annotation (Line(points={{-45,41},{-82,41},{-82,53.2}}, color={0,131,169}));
  connect(preheater_IP1.cond_out, boiler.feedWater) annotation (Line(points={{-90,25},{-92,25},{-92,53.2},{-90,53.2}}, color={0,131,169}));
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
 Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),      Diagram(graphics,
                                           coordinateSystem(preserveAspectRatio=false,
                 extent={{-180,-280},{1080,240}})));
end SteamCycle_4NDV_3HDV_01;
