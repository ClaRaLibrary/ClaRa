within ClaRa.StaticCycles.Check.StaticCycleExamples;
model InitSteamCycle_SimplePowerPlant3 "Helps you to find reasonable start values for steam cycles"
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
//________________preheater_LP1 parameter________________________
  parameter ClaRa.Basics.Units.Pressure preheater_LP1_p_tap=0.207e5 annotation (Dialog(group="preheater_LP1", tab="Preheater"));
  parameter ClaRa.Basics.Units.MassFlowRate preheater_LP1_m_flow_tap=14 annotation (Dialog(group="preheater_LP1", tab="Preheater"));

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
parameter Real efficiency_Turb_IP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//__________________reboiler parameter____________________
  parameter Basics.Units.Pressure p_reboiler=3.5e5 "Reboiler pressure" annotation (Dialog(tab="Heat exchangers", group="Reboiler"));
  parameter Basics.Units.MassFlowRate m_flow_reboiler=150 "Reboiler mass flow rate" annotation (Dialog(tab="Heat exchangers", group="Reboiler"));
// __________________Feewatertank parameter________________
  parameter Basics.Units.Pressure p_FWT=14e5 "Feedwater tank pressure" annotation (Dialog(tab="Heat exchangers", group="Feedwatertank"));
//___________________condenser parameter___________________
  parameter Basics.Units.Pressure p_condenser=4000 "Condenser Pressure" annotation (Dialog(tab="Heat exchangers", group="Condenser"));
//________________ valves parameter________________________
  parameter ClaRa.Basics.Units.Pressure valve1_HP_dp_nominal=2e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_IP_dp_nominal=1e5 annotation (Dialog(tab="Valves"));
  parameter ClaRa.Basics.Units.Pressure valve_LP1_dp_nominal=0.001e5 annotation (Dialog(tab="Valves"));

//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Machines.Pump1 pump_fw(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{-100,-134},{-140,-94}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-150,112},{-120,172}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_IP(efficiency=efficiency_Turb_IP) annotation (Placement(transformation(extent={{-86,114},{-56,174}})));
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
    m_flow_RS_nom=m_flow_nom) annotation (Placement(transformation(extent={{-224,52},{-184,92}})));

  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{210,-18},{252,22}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP(Delta_p_nom=valve_IP_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={-34,11})));
  ClaRa.StaticCycles.Storage.Feedwatertank3 feedwatertank(p_FWT_nom=p_FWT, m_flow_nom=m_flow_FW) annotation (Placement(transformation(extent={{-8,-124},{-58,-96}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_dp_nominal) annotation (Placement(transformation(
        extent={{-10,-7},{10,7}},
        rotation=270,
        origin={90,11})));
  ClaRa.StaticCycles.Machines.Pump1 pump_cond(efficiency=efficiency_Pump_cond) annotation (Placement(transformation(extent={{174,-134},{134,-94}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP1(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{12,114},{42,174}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP annotation (Placement(transformation(extent={{-44,104},{-24,124}})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP1 annotation (Placement(transformation(extent={{80,104},{100,124}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP1(p_tap_nom=preheater_LP1_p_tap, m_flow_tap_nom=preheater_LP1_m_flow_tap) annotation (Placement(transformation(extent={{114,-136},{68,-92}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP2(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{182,114},{212,174}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_HP(m_flow_tap_nom=preheater_HP_m_flow_tap, p_tap_nom=preheater_HP_p_tap) annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-202,-22})));
  ClaRa.StaticCycles.Fittings.Split1 split_LP_turbine2 annotation (Placement(transformation(extent={{-98,3},{-118,23}})));
  ClaRa.StaticCycles.Fittings.Mixer1 mixer2 annotation (Placement(transformation(extent={{42,-131},{22,-111}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve annotation (Placement(transformation(extent={{-104,-160},{-84,-144}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_dp_nom(Delta_p_nom=valve1_HP_dp_nominal) annotation (Placement(transformation(extent={{-132,-28},{-152,-12}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve1 annotation (Placement(transformation(extent={{-152,12},{-172,26}})));
  ClaRa.StaticCycles.Fittings.Mixer2 mixer2_1 annotation (Placement(transformation(extent={{214,-130},{194,-110}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve2 annotation (Placement(transformation(extent={{148,-166},{168,-150}})));
  Triple triple3 annotation (Placement(transformation(extent={{-96,-94},{-64,-66}})));
  Triple triple annotation (Placement(transformation(extent={{-28,-90},{4,-62}})));
  Triple triple1 annotation (Placement(transformation(extent={{-4,-94},{28,-66}})));
equation
  connect(boiler.liveSteam, turbine_HP.inlet) annotation (Line(
      points={{-204,92.8},{-204,154},{-151.25,154}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.cond_out, pump_fw.inlet) annotation (Line(
      points={{-59.25,-114.667},{-78,-114.667},{-78,-114},{-99,-114}},
      color={0,131,169},
      smooth=Smooth.None));

  connect(preheater_LP1.cond_in, pump_cond.outlet) annotation (Line(
      points={{115.15,-114},{133,-114}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.tap_in, valve_LP1.outlet) annotation (Line(
      points={{91,-90.9},{91,-3.55271e-015},{90,-3.55271e-015}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(feedwatertank.tap_in, valve_LP.outlet) annotation (Line(
      points={{-33,-94.8333},{-33,-44},{-34,-44},{-34,-3.55271e-15}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP2.outlet, condenser.inlet) annotation (Line(
      points={{213.25,120},{218,120},{218,118},{231,118},{231,23}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_IP.outlet, split_LP.inlet) annotation (Line(
      points={{-54.75,120},{-50,120},{-50,120.667},{-45,120.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP.outlet_2, valve_LP.inlet) annotation (Line(
      points={{-34,102.333},{-34,22}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP1.outlet, split_LP1.inlet) annotation (Line(
      points={{43.25,120},{60,120},{60,120.667},{79,120.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{90,102.333},{90,22}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP1.outlet_1,turbine_LP2. inlet) annotation (Line(
      points={{101,120.667},{170,120.667},{170,156},{180.75,156}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP.cond_in, pump_fw.outlet) annotation (Line(
      points={{-202,-43},{-202,-114},{-141,-114}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split_LP_turbine2.inlet, turbine_HP.outlet) annotation (Line(
      points={{-97,19.6667},{-78,19.6667},{-78,118},{-118.75,118}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer2.outlet, feedwatertank.cond_in) annotation (Line(
      points={{21,-114.333},{8,-114.333},{8,-114.667},{-6.75,-114.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve.outlet, mixer2.inlet_2) annotation (Line(
      points={{-83,-152},{32,-152},{32,-132.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve.inlet, preheater_HP.tap_out) annotation (Line(
      points={{-105,-152},{-232,-152},{-232,-22},{-223,-22}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom.inlet, split_LP_turbine2.outlet_2) annotation (Line(
      points={{-131,-20},{-108,-20},{-108,1.33333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_dp_nom.outlet, preheater_HP.tap_in) annotation (Line(
      points={{-153,-20},{-181,-20},{-181,-22}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1.inlet, split_LP_turbine2.outlet_1) annotation (Line(
      points={{-151,19},{-133.8,19},{-133.8,19.6667},{-119,19.6667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP1.inlet, split_LP.outlet_1) annotation (Line(
      points={{10.75,156},{-8,156},{-8,120.667},{-23,120.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, mixer2.inlet_1) annotation (Line(
      points={{66.85,-114},{54,-114},{54,-114.333},{43,-114.333}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer2_1.outlet, pump_cond.inlet) annotation (Line(
      points={{193,-113.333},{184,-113.333},{184,-114},{175,-114}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer2_1.inlet_1, condenser.outlet) annotation (Line(
      points={{215,-113.333},{231,-113.333},{231,-19}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2.outlet, mixer2_1.inlet_2) annotation (Line(
      points={{169,-158},{204,-158},{204,-131.667}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{147,-158},{91,-158},{91,-137.1}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_fw.inlet, triple3.steamSignal) annotation (Line(points={{-99,-114},{-99,-99},{-97,-99},{-97,-83}},     color={0,131,169}));
  connect(feedwatertank.tap_in, triple.steamSignal) annotation (Line(points={{-33,-94.8333},{-33,-87.4667},{-29,-87.4667},{-29,-79}}, color={0,131,169}));
  connect(feedwatertank.cond_in, triple1.steamSignal) annotation (Line(points={{-6.75,-114.667},{-6.75,-98.3335},{-5,-98.3335},{-5,-83}},
                                                                                            color={0,131,169}));
  connect(boiler.hotReheat, turbine_IP.inlet) annotation (Line(points={{-192,92.8},{-192,92.8},{-192,198},{-87.25,198},{-87.25,156}}, color={0,131,169}));
  connect(valve1.outlet, boiler.coldReheat) annotation (Line(points={{-173,19},{-196,19},{-196,51.2}}, color={0,131,169}));
  connect(preheater_HP.cond_out, boiler.feedWater) annotation (Line(points={{-202,-1},{-204,-1},{-204,51.2}}, color={0,131,169}));
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
                 extent={{-240,-200},{280,260}})));
end InitSteamCycle_SimplePowerPlant3;
