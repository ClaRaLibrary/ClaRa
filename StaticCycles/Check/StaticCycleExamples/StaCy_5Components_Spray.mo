within ClaRa.StaticCycles.Check.StaticCycleExamples;
model StaCy_5Components_Spray "A Static Cycle with only five components and a spray attemperator"
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
//   parameter SI.HeatFlowRate Q_nom=boiler.m_flow_LS*(boiler.h_LS_out - boiler.h_LS_in) + boiler.m_flow_RS*(boiler.h_RS_out - boiler.h_RS_in)
//     "Nominal heat flow rate"

  final parameter Basics.Units.MassFlowRate m_flow_FW=m_flow_nom*P_target_ "Feedwater massflow rate at nominal point" annotation (Dialog(group="Global parameter"));

//___________________condenser parameter___________________
  parameter Basics.Units.Pressure p_condenser=4000 annotation (Dialog(group="Condenser"));

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
parameter Real efficiency_Pump_FW=1 "Efficiency of pump" annotation(Dialog(tab="Pumps"));

//________________turbine parameter________________________
parameter Real efficiency_Turb_HP=1 "Efficiency of turbine" annotation(Dialog(tab= "Turbines"));
parameter Real efficiency_Turb_LP=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));
//parameter Real efficiency_Turb_LP2=1 "Efficiency of turbine" annotation(Dialog(tab="Turbines"));

  ClaRa.StaticCycles.Machines.Pump1 pump_fw(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{16,-90},{-4,-70}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-12,44},{-2,64}})));
  ClaRa.StaticCycles.Machines.Turbine turbine_LP(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{76,48},{86,68}})));
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
    m_flow_RS_nom=m_flow_nom) annotation (Placement(transformation(extent={{-80,-12},{-58,10}})));

  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{76,4},{96,24}})));
  Fittings.Mixer2 mixer2_1 annotation (Placement(transformation(
        extent={{-5,3},{5,-3}},
        rotation=90,
        origin={-70,39})));
  ValvesConnects.Valve_cutPressure1 valve_cutPressure annotation (Placement(transformation(
        extent={{-5,-2},{5,2}},
        rotation=90,
        origin={-93,-55})));
  Fittings.Split3 split1_1(splitRatio=0.1) annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=180,
        origin={-69,-78})));
  Triple triple annotation (Placement(transformation(extent={{-84,22},{-72,34}})));
  Triple triple1 annotation (Placement(transformation(extent={{-88,48},{-76,60}})));
  Triple triple2 annotation (Placement(transformation(extent={{-110,40},{-96,52}})));
  Triple triple3 annotation (Placement(transformation(extent={{-64,-66},{-52,-56}})));
  Triple triple4 annotation (Placement(transformation(extent={{-26,-78},{-14,-66}})));
  Triple triple5 annotation (Placement(transformation(extent={{-94,-92},{-82,-82}})));
equation
  connect(condenser.outlet, pump_fw.inlet) annotation (Line(
      points={{86,3.5},{86,-80},{16.5,-80}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(turbine_LP.outlet, condenser.inlet) annotation (Line(
      points={{86.4167,50},{86,50},{86,24.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_cutPressure.outlet, mixer2_1.inlet_2) annotation (Line(
      points={{-93,-49.5},{-93,39},{-73.5,39}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer2_1.inlet_1, boiler.liveSteam) annotation (Line(
      points={{-68,33.5},{-68,10.44},{-69,10.44}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(mixer2_1.outlet, turbine_HP.inlet) annotation (Line(
      points={{-68,44.5},{-68,58},{-12.4167,58}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(pump_fw.outlet, split1_1.inlet) annotation (Line(
      points={{-4.5,-80},{-63.5,-80}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split1_1.outlet_1, valve_cutPressure.inlet) annotation (Line(
      points={{-74.5,-80},{-93,-80},{-93,-60.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple.steamSignal, boiler.liveSteam) annotation (Line(
      points={{-84.375,26.7143},{-84.375,10.44},{-69,10.44}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple1.steamSignal, mixer2_1.outlet) annotation (Line(
      points={{-88.375,52.7143},{-88.375,44.5},{-68,44.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple2.steamSignal, mixer2_1.inlet_2) annotation (Line(
      points={{-110.438,44.7143},{-110.438,39},{-73.5,39}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple3.steamSignal, split1_1.outlet_2) annotation (Line(
      points={{-64.375,-62.0714},{-64.375,-74.5},{-69,-74.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple4.steamSignal, pump_fw.outlet) annotation (Line(
      points={{-26.375,-73.2857},{-26.375,-80},{-4.5,-80}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple5.steamSignal, split1_1.outlet_1) annotation (Line(
      points={{-94.375,-88.0714},{-94.375,-80},{-74.5,-80}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.hotReheat, turbine_LP.inlet) annotation (Line(points={{-62.4,10.44},{-62.4,66},{75.5833,66},{75.5833,62}}, color={0,131,169}));
  connect(turbine_HP.outlet, boiler.coldReheat) annotation (Line(points={{-1.58333,46},{-2,46},{-2,-18},{-2,-20},{-64.6,-20},{-64.6,-12.44}}, color={0,131,169}));
  connect(split1_1.outlet_2, boiler.feedWater) annotation (Line(points={{-69,-74.5},{-69,-43.25},{-69,-12.44}},              color={0,131,169}));
    annotation (Dialog(group="Global parameter"),
              Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                   graphics),      Diagram(graphics,
                                           coordinateSystem(preserveAspectRatio=false,
                 extent={{-100,-100},{100,100}})));
end StaCy_5Components_Spray;
