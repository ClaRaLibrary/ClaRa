within ClaRa.StaticCycles.Check.StaticCycleExamples;
model InitSteamCycle_SimplePowerPlant1 "Helps you to find reasonable start values for steam cycles"
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
// __________________Feewatertank parameter________________
  parameter Basics.Units.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation (Dialog(tab="Heat exchangers", group="Feedwatertank"));
//___________________condenser parameter___________________
  parameter Basics.Units.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers", group="Condenser"));
//________________ valves parameter________________________
  parameter ClaRa.Basics.Units.Pressure valve_IP_dp_nominal=1e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5 annotation (Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Machines.Pump1_real pump_fw(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{-120,-98},{-140,-78}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-130,122},{-120,142}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{-70,122},{-60,142}})));
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
    m_flow_RS_nom=m_flow_nom) annotation (Placement(transformation(extent={{-160,42},{-140,62}})));

  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{140,6},{160,26}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP(Delta_p_nom=valve_IP_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={-40,17})));
  ClaRa.StaticCycles.Storage.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_FW) annotation (Placement(transformation(extent={{-20,-95},{-60,-75}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={71,8})));
  ClaRa.StaticCycles.Machines.Pump1_real pump_cond(efficiency=efficiency_Pump_cond) annotation (Placement(transformation(extent={{124,-100},{104,-80}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP1(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{22,120},{32,140}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP2(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{108,108},{118,128}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP annotation (Placement(transformation(extent={{-50,116},{-30,126}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP1 annotation (Placement(transformation(extent={{62,112},{82,124}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP1(p_tap_nom=p_shell_preheater, m_flow_tap_nom=14) annotation (Placement(transformation(extent={{81,-100},{61,-80}})));
  ClaRa.StaticCycles.Machines.Pump1_real pump_preheater(efficiency=efficiency_Pump_preheat) annotation (Placement(transformation(extent={{40,-120},{20,-100}})));
  ClaRa.StaticCycles.Fittings.Mixer1 mixer annotation (Placement(transformation(extent={{18,-98},{0,-88}})));
equation
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-150,62.4},{-150,136},{-130.417,136}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{-61,-88.3333},{-96,-88.3333},{-96,-88},{-119.5,-88}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(pump_cond.inlet, condenser.outlet) annotation (Line(
      points={{124.5,-90},{150,-90},{150,5.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, condenser.inlet) annotation (Line(
      points={{118.417,110},{150,110},{150,26.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, pump_cond.outlet) annotation (Line(
      points={{81.5,-90},{103.5,-90}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_in, valve_LP1.outlet) annotation (Line(
      points={{71,-79.5},{71,-3}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_preheater.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{40.5,-110},{71,-110},{71,-100.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.inlet_2, pump_preheater.outlet) annotation (Line(
      points={{9,-98.8333},{9,-110},{19.5,-110}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, mixer.inlet_1) annotation (Line(
      points={{60.5,-90},{56,-90},{56,-89.6667},{18.9,-89.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer.outlet, feedwatertank.cond_in) annotation (Line(
      points={{-0.9,-89.6667},{-19,-89.6667},{-19,-88.3333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, valve_LP.outlet) annotation (Line(
      points={{-40,-74.1667},{-40,6}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP.outlet, split_LP.inlet) annotation (Line(
      points={{-59.5833,124},{-50,124},{-50,124.333},{-51,124.333}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(turbine_LP1.outlet, split_LP1.inlet) annotation (Line(
      points={{32.4167,122},{61,122}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1, turbine_LP2.inlet) annotation (Line(
      points={{83,122},{107.583,122}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{72,111},{71,111},{71,19}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_LP.inlet) annotation (Line(
      points={{-40,115.167},{-40,28}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_1, turbine_LP1.inlet) annotation (Line(points={{-29,124.333},{-3.3,124.333},{-3.3,134},{21.5833,134}},
                                                                                            color={0,131,169}));
  connect(turbine_HP.outlet, boiler.coldReheat) annotation (Line(points={{-119.583,124},{-120,124},{-120,28},{-146,28},{-146,41.6}}, color={0,131,169}));
  connect(boiler.hotReheat, turbine_LP.inlet) annotation (Line(points={{-144,62.4},{-144,62.4},{-144,150},{-144,148},{-70.4167,148},{-70.4167,136}}, color={0,131,169}));
  connect(pump_fw.outlet, boiler.feedWater) annotation (Line(points={{-140.5,-88},{-150,-88},{-150,41.6}}, color={0,131,169}));
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
 Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1),
                   graphics),      Diagram(graphics,
                                           coordinateSystem(preserveAspectRatio=false,
        initialScale=0.1,
        extent={{-160,-120},{180,160}})));
end InitSteamCycle_SimplePowerPlant1;
