within ClaRa.StaticCycles.Check.StaticCycleExamples;
model InitSteamCycle_SimplePowerPlant2 "Helps you to find reasonable start values for steam cycles"
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
  extends ClaRa.Basics.Icons.Init;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.*;
  import SI = ClaRa.Basics.Units;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

//__________________global parameter_______________________
  inner parameter Real P_target_= 1 "Value of load in p.u."    annotation(Dialog(group="Global parameter"));
  parameter Basics.Units.MassFlowRate m_flow_nom=417 "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));
  parameter Basics.Units.Temperature T_LS_nom=823 "Live steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter Basics.Units.Temperature T_RS_nom=833 "Reheated steam temperature at nominal point" annotation (Dialog(group="Global parameter"));
  parameter String mediumName = "R718" annotation(Dialog(group="Global parameter"));
//  // parameter SI.HeatFlowRate Q_nom=boiler.m_flow_feed*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_cRH*(boiler.h_RS_out - boiler.h_RS_in)
//     "Nominal heat flow rate"
//     annotation (Dialog(group="Global parameter"));
  final parameter Basics.Units.MassFlowRate m_flow_FW=m_flow_nom*P_target_ "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));

//________________preheater_HP parameter________________________
  parameter ClaRa.Basics.Units.Pressure preheater_HP_p_tap=55.95e5 annotation (Dialog(group="preheater_HP", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate preheater_HP_m_flow_tap=42.812 annotation (Dialog(group="preheater_HP", tab="Preheater"));

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
//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//__________________reheater parameter____________________
  parameter Basics.Units.Pressure p_shell_preheater=20700 "Pressure on preheater shell side" annotation (Dialog(tab="Heat exchangers", group="Preheater"));
//__________________reboiler parameter____________________
  parameter Basics.Units.Pressure p_reboiler=3.5e5 "Reboiler pressure" annotation (Dialog(tab="Heat exchangers", group="Reboiler"));
  parameter Basics.Units.MassFlowRate m_flow_reboiler=150 "Reboiler mass flow rate" annotation (Dialog(tab="Heat exchangers", group="Reboiler"));
// __________________Feewatertank parameter________________
  parameter Basics.Units.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation (Dialog(tab="Heat exchangers", group="Feedwatertank"));
//___________________condenser parameter___________________
  parameter Basics.Units.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers", group="Condenser"));
//________________ valves parameter________________________
  parameter ClaRa.Basics.Units.Pressure valve_IP_dp_nominal=1e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5 annotation (Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Machines.Pump1 pump_fw(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{-140,-68},{-160,-48}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-192,120},{-180,140}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{-140,118},{-128,138}})));
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
    m_flow_RS_nom=m_flow_nom) annotation (Placement(transformation(extent={{-220,60},{-200,80}})));

  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{142,-24},{162,-4}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP(Delta_p_nom=valve_IP_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=270,
        origin={-81,10})));
  ClaRa.StaticCycles.Storage.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_FW) annotation (Placement(transformation(extent={{-62,-68},{-100,-48}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=270,
        origin={95,10})));
  ClaRa.StaticCycles.Machines.Pump1 pump_cond(efficiency=efficiency_Pump_cond) annotation (Placement(transformation(extent={{136,-62},{116,-42}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP1(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{-40,118},{-28,138}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP2(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{52,118},{64,138}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP annotation (Placement(transformation(extent={{-92,112},{-72,122}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP1 annotation (Placement(transformation(extent={{84,112},{104,122}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP1(p_tap_nom=p_shell_preheater, m_flow_tap_nom=42.812) annotation (Placement(transformation(extent={{106,-62},{86,-42}})));
  ClaRa.StaticCycles.Machines.Pump1 pump_preheater(efficiency=efficiency_Pump_preheat) annotation (Placement(transformation(extent={{80,-101},{60,-81}})));
  ClaRa.StaticCycles.Fittings.Mixer1 mixer annotation (Placement(transformation(extent={{58,-61},{40,-51}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP3(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{138,118},{150,138}})));
  ClaRa.StaticCycles.Fittings.Split1 split annotation (Placement(transformation(extent={{-2,128},{16,118}})));
  ClaRa.StaticCycles.HeatExchanger.Reboiler reboiler(p_reb=3.5e5, m_flow_reb=150) annotation (Placement(transformation(extent={{96,168},{116,188}})));
  ClaRa.StaticCycles.Machines.Pump1 pump_preheater1(efficiency=efficiency_Pump_preheat) annotation (Placement(transformation(extent={{154,168},{174,188}})));
  ClaRa.StaticCycles.Fittings.Mixer1 mixer1 annotation (Placement(transformation(extent={{19,-70},{1,-60}})));
equation
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-210,80.4},{-210,134},{-192.5,134}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{-100.95,-61.3333},{-122,-61.3333},{-122,-58},{-139.5,-58}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(pump_cond.inlet, condenser.outlet) annotation (Line(
      points={{136.5,-52},{152,-52},{152,-24.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, pump_cond.outlet) annotation (Line(
      points={{106.5,-52},{115.5,-52}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_in, valve_LP1.outlet) annotation (Line(
      points={{96,-41.5},{96,-1},{95,-1}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{80.5,-91},{96,-91},{96,-62.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.inlet_2, pump_preheater.outlet) annotation (Line(
      points={{49,-61.8333},{49,-91},{59.5,-91}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, mixer.inlet_1) annotation (Line(
      points={{85.5,-52},{58,-52},{58,-52.6667},{58.9,-52.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, valve_LP.outlet) annotation (Line(
      points={{-81,-47.1667},{-81,-1}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP3.outlet, condenser.inlet) annotation (Line(
      points={{150.5,120},{150,120},{150,-3.5},{152,-3.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(reboiler.outlet, pump_preheater1.inlet) annotation (Line(
      points={{116.4,178},{153.5,178}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer1.inlet_2, pump_preheater1.outlet) annotation (Line(
      points={{10,-70.8333},{10,-108},{196,-108},{196,178},{174.5,178}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP.outlet, split_LP.inlet) annotation (Line(
      points={{-127.5,120},{-96,120},{-96,120.333},{-93,120.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_LP.inlet) annotation (Line(
      points={{-82,111.167},{-82,21},{-81,21}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_1, turbine_LP1.inlet) annotation (Line(
      points={{-71,120.333},{-54,120.333},{-54,132},{-40.5,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP1.outlet, split.inlet) annotation (Line(
      points={{-27.5,120},{-6,120},{-6,119.667},{-2.9,119.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split.outlet_2, reboiler.inlet) annotation (Line(
      points={{7,128.833},{7,178},{95.6,178}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split.outlet_1, turbine_LP2.inlet) annotation (Line(
      points={{16.9,119.667},{28,119.667},{28,132},{51.5,132},{51.5,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, split_LP1.inlet) annotation (Line(
      points={{64.5,120},{80,120},{80,120.333},{83,120.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{94,111.167},{94,21},{95,21}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1, turbine_LP3.inlet) annotation (Line(
      points={{105,120.333},{122,120.333},{122,132},{137.5,132}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.outlet, mixer1.inlet_1) annotation (Line(points={{39.1,-52.6667},{28,-52.6667},{28,-61.6667},{19.9,-61.6667}}, color={0,131,169}));
  connect(mixer1.outlet, feedwatertank.cond_in) annotation (Line(points={{0.1,-61.6667},{-29.95,-61.6667},{-29.95,-61.3333},{-61.05,-61.3333}}, color={0,131,169}));
  connect(boiler.hotReheat, turbine_LP.inlet) annotation (Line(points={{-204,80.4},{-204,80.4},{-204,152},{-142,152},{-142,132},{-140.5,132}}, color={0,131,169}));
  connect(turbine_HP.outlet, boiler.coldReheat) annotation (Line(points={{-179.5,122},{-180,122},{-180,50},{-206,50},{-206,59.6}}, color={0,131,169}));
  connect(boiler.feedWater, pump_fw.outlet) annotation (Line(points={{-210,59.6},{-210,59.6},{-210,-60},{-160.5,-60},{-160.5,-58}}, color={0,131,169}));
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
                 extent={{-240,-140},{200,200}},
        initialScale=0.1)));
end InitSteamCycle_SimplePowerPlant2;
