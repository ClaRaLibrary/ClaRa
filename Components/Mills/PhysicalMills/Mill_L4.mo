within ClaRa.Components.Mills.PhysicalMills;
model Mill_L4 "Aerosol component | box module to capsule mill components"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.Icons.Mill;
  outer ClaRa.SimCenter simCenter;

  // PARAMETER DECLARATION: #########################################################################################

  // Global nominal values: ---------------------------------------------------------------
  parameter TILMedia.GasTypes.BaseGas gas = simCenter.flueGasModel "Medium model" annotation(Dialog(tab="General",group="Fundamental Definitions"), choicesAllMatching);
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(tab="General",group="Fundamental Definitions"));
  parameter Volumes.Fundamentals.Records.FuelClassification_base classification=Volumes.Fundamentals.Records.FuelClassification_example_21classes() "Classification record" annotation (Dialog(tab="General", group="Fundamental Definitions"), choicesAllMatching=true);
  parameter ClaRa.Basics.Units.MassFraction classFraction[classification.N_class-1] = ((1/classification.N_class)*ones(classification.N_class-1)) "Particle class mass fraction" annotation(Dialog(tab="General",group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel_nom = 15.72 "nominal fuel mass flow rate" annotation(Dialog(tab="General",group="Global nominal values"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_gas_nom = 21.68 "nominal gas mass flow rate" annotation(Dialog(tab="General",group="Global nominal values"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_mill_nom = 7500 "Nominal total Pressure Loss of Pulverizer" annotation(Dialog(tab="General",group="Global nominal values"));
  parameter ClaRa.Basics.Units.Power P_grinding_nom = 460e3 "Nominal electrical Power" annotation(Dialog(tab="General",group="Global nominal values"));
  parameter ClaRa.Basics.Units.Mass mass_mill = 116e3 "Total mass of mill construction" annotation(Dialog(tab="General",group="Global nominal values"));

  // Grinder: ---------------------------------------------------------------
  replaceable model Breakage = Volumes.Fundamentals.Grinding.Breakage_Function.Breakage_Austin constrainedby Volumes.Fundamentals.Grinding.Breakage_Function.Breakage_base                                                         annotation(Dialog(tab="Grinder",group="Replaceable Models"),choicesAllMatching=true);
  replaceable model Selection = Volumes.Fundamentals.Grinding.Selection_Function.Selection_Steinmetz constrainedby Volumes.Fundamentals.Grinding.Selection_Function.Selection_base                                                          annotation(Dialog(tab="Grinder",group="Replaceable Models"),choicesAllMatching=true);
  replaceable model Transport = Volumes.Fundamentals.Grinding.Transport_Velocity.Transport_complex constrainedby Volumes.Fundamentals.Grinding.Transport_Velocity.Transport_base                                                         annotation(Dialog(tab="Grinder",group="Replaceable Models"),choicesAllMatching=true);

  parameter ClaRa.Basics.Units.Length radius_table = 0.5*(2.44-0.4) "outer radius of the grinding table; center table to center roll!" annotation(Dialog(tab="Grinder",group="Geometry"));
  parameter ClaRa.Basics.Units.Length radius_chute = 0.5*0.817 "radius of recirculation tube of classifier" annotation(Dialog(tab="Grinder",group="Geometry"));

  parameter ClaRa.Basics.Units.MassFraction xi_grinder_start[fuelModel.N_c - 1]=zeros(fuelModel.N_c - 1) "initial fuel composition" annotation(Dialog(tab="Grinder",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction classFraction_grinder_start[classification.N_class - 1]=(1/classification.N_class)*ones(classification.N_class - 1) "start value for total class fraction of ALL inlets" annotation(Dialog(tab="Grinder",group="Initialization"));
  parameter ClaRa.Basics.Units.Temperature T_grinder_start = simCenter.T_amb_start "initial temperature in fuel controll volume" annotation(Dialog(tab="Grinder",group="Initialization"));
  parameter Real recirculation_rate_grinder_start = 15 "initial m_flow_out/m_flow_in1 kg/kg" annotation(Dialog(tab="Grinder",group="Initialization"));

  // Dryer: ---------------------------------------------------------------
  replaceable model Drying =  Volumes.Fundamentals.Drying.Drying_ideal constrainedby Volumes.Fundamentals.Drying.Drying_base                                                         annotation(Dialog(tab="Dryer",group="Replaceable Models"),choicesAllMatching=true);
  parameter ClaRa.Basics.Units.Mass mass_content_start=100 "Initial mass in drying zone" annotation(Dialog(tab="Dryer",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_H2O_evap_start = 1.5 "initianl mass flow rate of evaporated coal H2O" annotation(Dialog(tab="Dryer",group="Initialization"));
  parameter ClaRa.Basics.Units.Temperature T_dryer_start = simCenter.T_amb_start "initial temperature in fuel controll volume" annotation(Dialog(tab="Dryer",group="Initialization"));
  replaceable model PressureLoss_dryer = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2(Delta_p_nom=0.6*Delta_p_mill_nom) annotation(choicesAllMatching, Dialog(tab="Dryer",group="Replaceable Models"));
  parameter ClaRa.Basics.Units.Pressure p_dryer_start=simCenter.p_amb_start "Initial value for air pressure" annotation(Dialog(tab="Dryer",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction xi_dryer_gas_in_start[gas.nc - 1]=zeros(gas.nc - 1) "initial gas composition" annotation(Dialog(tab="Dryer",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction xi_dryer_gas_out_start[gas.nc - 1]=zeros(gas.nc - 1) "initial gas composition" annotation(Dialog(tab="Dryer",group="Initialization"));

  // Transport: ---------------------------------------------------------------
  replaceable model Classifying_flow =  Volumes.Fundamentals.Classifying.Classifying_flow constrainedby Volumes.Fundamentals.Classifying.Classifying_flow_base                                                          annotation(Dialog(tab="Transport",group="Replaceable Models"),choicesAllMatching=true);
  replaceable model PressureLoss_transport = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2(Delta_p_nom=0.2*Delta_p_mill_nom) annotation(choicesAllMatching, Dialog(tab="Transport",group="Replaceable Models"));

  parameter ClaRa.Basics.Units.Length height_transport = 4.6 "length of transport volume" annotation(Dialog(tab="Transport",group="Geometry"));
  parameter ClaRa.Basics.Units.Area A_cross_transport = 6.43 "cross section of transport volume" annotation(Dialog(tab="Transport",group="Geometry"));

  parameter ClaRa.Basics.Units.Mass mass_transport_start=24 "total initial fuel mass" annotation(Dialog(tab="Transport",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction classFraction_transport_start[classification.N_class - 1]=(1/classification.N_class)*ones(classification.N_class - 1) "start value for total class fraction in control volume" annotation(Dialog(tab="Transport",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction xi_transport_fuel_start[fuelModel.N_c - 1]=zeros(fuelModel.N_c - 1) "initial fuel composition" annotation(Dialog(tab="Transport",group="Initialization"));
  parameter Modelica.SIunits.Pressure p_transport_start=simCenter.p_amb_start "initial value of gas sytsem pressure" annotation(Dialog(tab="Transport",group="Initialization"));
  parameter ClaRa.Basics.Units.Temperature T_transport_start = 273.15+100 "initial temperature" annotation(Dialog(tab="Transport",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction xi_transport_gas_start[gas.nc - 1]=zeros(gas.nc - 1) "initial gas composition" annotation(Dialog(tab="Transport",group="Initialization"));

  // Classifier: ---------------------------------------------------------------
  replaceable model Classifying_centrifugal =  Volumes.Fundamentals.Classifying.Classifying_centrifugal constrainedby Volumes.Fundamentals.Classifying.Classifying_centrifugal_base                                                                  annotation(Dialog(tab="Classifier",group="Replaceable Models"),choicesAllMatching=true);
  replaceable model PressureLoss_classifier = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2(Delta_p_nom=0.2*Delta_p_mill_nom) annotation(choicesAllMatching, Dialog(tab="Classifier",group="Replaceable Models"));

  parameter ClaRa.Basics.Units.Length radius_classifier_outer = 0.5*3.33 "outer radius of classifier (inlet)" annotation(Dialog(tab="Classifier",group="Geometry"));
  parameter ClaRa.Basics.Units.Length radius_classifier_inner = 0.5*0.817 "inner radius of classifier (outlet)" annotation(Dialog(tab="Classifier",group="Geometry"));
  parameter ClaRa.Basics.Units.Length height_classifier = 2 "height of classifier; considered as CONSTANT against radius" annotation(Dialog(tab="Classifier",group="Geometry"));

  parameter ClaRa.Basics.Units.Mass mass_classifier_start=24 "total initial fuel mass" annotation(Dialog(tab="Classifier",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction classFraction_classifier_start[classification.N_class - 1]=(1/classification.N_class)*ones(classification.N_class - 1) "intitial value for total class fraction in control volume" annotation(Dialog(tab="Classifier",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction xi_classifier_fuel_start[fuelModel.N_c - 1]=zeros(fuelModel.N_c - 1) "initial fuel composition" annotation(Dialog(tab="Classifier",group="Initialization"));
  parameter Modelica.SIunits.Pressure p_classifier_start=simCenter.p_amb_start "initial value of gas sytsem pressure" annotation(Dialog(tab="Classifier",group="Initialization"));
  parameter ClaRa.Basics.Units.Temperature T_classifier_start = 273.15+100 "initial temperature" annotation(Dialog(tab="Classifier",group="Initialization"));
  parameter ClaRa.Basics.Units.MassFraction xi_classifier_gas_start[gas.nc - 1]=zeros(gas.nc - 1) "initial gas composition" annotation(Dialog(tab="Classifier",group="Initialization"));

  // COMPONENT INSTANTIATION: #########################################################################################

  Adapters.FuelAerosolDistributor fuelAerosolDistributor(
    fuelModel=fuelModel,
    classification=classification,
    classFraction=classFraction) annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Volumes.Dryer dryer(
    fuelModel=fuelModel,
    m_flow_fuel_nom=m_flow_fuel_nom,
    m_flow_gas_nom=m_flow_gas_nom,
    classification=classification,
    gas=gas,
    T_start=T_dryer_start,
    redeclare model Drying = Drying,
    m_flow_H2O_evap_start=m_flow_H2O_evap_start,
    redeclare model PressureLoss = PressureLoss_dryer,
    p_start=p_dryer_start,
    P_grinding_nom=P_grinding_nom,
    xi_gas_in_start=xi_dryer_gas_in_start,
    xi_gas_out_start=xi_dryer_gas_out_start,
    mass_mill=mass_mill) annotation (Placement(transformation(extent={{-86,-52},{-66,-32}})));

  Volumes.GrinderRingRoller grinderRingRoller(
    fuelModel=fuelModel,
    m_flow_fuel_nom=m_flow_fuel_nom,
    classification=classification,
    xi_fuel_start=xi_grinder_start,
    T_start=T_grinder_start,
    classFraction_in_start=classFraction_grinder_start,
    recirculation_rate_start=recirculation_rate_grinder_start,
    redeclare model Selection = Selection,
    redeclare model Breakage = Breakage,
    redeclare model Transport = Transport,
    radius_table=radius_table,
    radius_chute=radius_chute) annotation (Placement(transformation(extent={{-42,-50},{-22,-30}})));

  Volumes.FlowClassifier flowClassifier(
    fuelModel=fuelModel,
    m_flow_fuel_nom=m_flow_fuel_nom,
    m_flow_gas_nom=m_flow_gas_nom,
    classification=classification,
    gas=gas,
    mass_fuel_start=mass_transport_start,
    p_start=p_transport_start,
    xi_fuel_start=xi_transport_fuel_start,
    xi_gas_start=xi_transport_gas_start,
    T_start=T_transport_start,
    redeclare model Classifying = Classifying_flow,
    classFraction_start=classFraction_transport_start,
    redeclare model PressureLoss = PressureLoss_transport,
    height=height_transport,
    A_cross=A_cross_transport) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={30,-10})));

  Volumes.CentrifugalClassifier centrifugalClassifier(
    fuelModel=fuelModel,
    m_flow_fuel_nom=m_flow_fuel_nom,
    m_flow_gas_nom=m_flow_gas_nom,
    classification=classification,
    gas=gas,
    xi_fuel_start=xi_classifier_fuel_start,
    xi_gas_start=xi_classifier_gas_start,
    mass_fuel_start=mass_classifier_start,
    T_start=T_classifier_start,
    p_start=p_classifier_start,
    redeclare model PressureLoss = PressureLoss_classifier,
    redeclare model Classifying = Classifying_centrifugal,
    classFraction_start=classFraction_classifier_start,
    radius_classifier_outer=radius_classifier_outer,
    radius_classifier_inner=radius_classifier_inner,
    height_classifier=height_classifier) annotation (Placement(transformation(extent={{-22,40},{-42,60}})));

  Volumes.FuelJoin_distributed fuelJoin_distributed(
    fuelModel=fuelModel,
    classification=classification,
    classFraction_start=0.5*(classFraction_transport_start + classFraction_classifier_start),
    xi_fuel_start=0.5*(xi_classifier_fuel_start + xi_transport_fuel_start),
    T_start=0.5*(T_classifier_start + T_transport_start)) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-32,-10})));

  Adapters.AerosolFuelConcentrator aerosolFuelConcentrator(
    fuelModel=fuelModel,
    classification=classification,
    classFraction=classFraction) annotation (Placement(transformation(extent={{80,10},{100,30}})));

  ClaRa.Basics.Interfaces.GasPortIn gasInlet(Medium=gas) annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  ClaRa.Basics.Interfaces.GasPortOut gasOutlet(Medium=gas) annotation (Placement(transformation(extent={{130,-30},{150,-10}})));
  ClaRa.Basics.Interfaces.Fuel_inlet fuelInlet(fuelModel = fuelModel) annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  ClaRa.Basics.Interfaces.Fuel_outlet fuelOutlet(fuelModel = fuelModel) annotation (Placement(transformation(extent={{130,10},{150,30}})));

  inner Modelica.Blocks.Interfaces.RealInput inputGrindingPressure annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,148})));

  inner Modelica.Blocks.Interfaces.RealInput inputTableSpeed annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,148})));

  inner Modelica.Blocks.Interfaces.RealInput inputClassifier "either inlet vane angle or ratation speed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={62,148})));

  //-------------------------------------------------------------------------------
  //Summary
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Mass mass_fuel_table "fuel bulk mass in volume";
    input ClaRa.Basics.Units.Mass mass_fuel_dryer "fuel bulk mass in volume";
    input ClaRa.Basics.Units.Mass mass_fuel_transport "fuel bulk mass in volume";
    input ClaRa.Basics.Units.Mass mass_fuel_classifier "fuel bulk mass in volume";
    input ClaRa.Basics.Units.Mass mass_fuel_total "fuel bulk mass in volume";
    input ClaRa.Basics.Units.Power P_grinding "electrical grinding power demand";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  Summary summary(outline(
      mass_fuel_table=grinderRingRoller.mass,
      mass_fuel_dryer=dryer.mass_fuel,
      mass_fuel_transport=flowClassifier.mass_fuel,
      mass_fuel_classifier=centrifugalClassifier.mass_fuel,
      mass_fuel_total=grinderRingRoller.mass + dryer.mass_fuel + flowClassifier.mass_fuel + centrifugalClassifier.mass_fuel,
      P_grinding = dryer.P_grinding)) annotation (Placement(transformation(extent={{100,-104},{120,-84}})));

equation

  connect(aerosolFuelConcentrator.outlet, fuelOutlet) annotation (Line(
      points={{100,20},{126,20},{140,20}},
      color={27,36,42},
      thickness=0.5));
  connect(fuelInlet, fuelAerosolDistributor.inlet) annotation (Line(
      points={{-140,20},{-120,20}},
      color={27,36,42},
      thickness=0.5));
  connect(gasInlet, dryer.gasInlet) annotation (Line(
      points={{-140,-20},{-118,-20},{-118,-46},{-86,-46}},
      color={118,106,98},
      thickness=0.5));
  connect(fuelAerosolDistributor.outlet, dryer.fuelInlet) annotation (Line(
      points={{-100,20},{-94,20},{-94,-40},{-86,-40}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(dryer.fuelOutlet, grinderRingRoller.fuelInlet1) annotation (Line(
      points={{-66,-40},{-42,-40}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(grinderRingRoller.fuelOutlet, flowClassifier.fuelInlet) annotation (Line(
      points={{-22,-40},{27.8,-40},{27.8,-20}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(dryer.gasOutlet, flowClassifier.gasInlet) annotation (Line(
      points={{-66,-46},{-46,-46},{-46,-60},{-18,-60},{-18,-46},{32,-46},{32,-20}},
      color={118,106,98},
      thickness=0.5));
  connect(centrifugalClassifier.fuelInlet, flowClassifier.fuelOutlet1) annotation (Line(
      points={{-22,47.8},{-18,47.8},{-18,48},{27.8,48},{27.8,0}},
      color={73,80,85},
      thickness=0.5));
  connect(centrifugalClassifier.gasInlet, flowClassifier.gasOutlet) annotation (Line(
      points={{-22,52},{32,52},{32,0}},
      color={118,106,98},
      thickness=0.5));
  connect(centrifugalClassifier.gasOutlet, gasOutlet) annotation (Line(
      points={{-42,52},{-50,52},{-50,70},{50,70},{50,-20},{140,-20}},
      color={118,106,98},
      thickness=0.5));
  connect(centrifugalClassifier.fuelOutlet1, aerosolFuelConcentrator.inlet) annotation (Line(
      points={{-42,47.8},{-44,47.8},{-44,48},{-56,48},{-56,78},{56,78},{56,20},{80,20}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(inputGrindingPressure, grinderRingRoller.inputGrindingPressure) annotation (Line(points={{-60,148},{-60,-22},{-40,-22},{-40,-28}}, color={0,0,127}));
  connect(inputTableSpeed, grinderRingRoller.inputTableSpeed) annotation (Line(points={{0,148},{0,-22},{-24,-22},{-24,-28}}, color={0,0,127}));
  connect(inputClassifier, centrifugalClassifier.inputClassifier) annotation (Line(points={{62,148},{62,98},{-32,98},{-32,62}}, color={0,0,127}));
  connect(flowClassifier.fuelOutlet2, fuelJoin_distributed.fuelInlet2) annotation (Line(
      points={{20,-10},{-22,-10}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fuelJoin_distributed.fuelOutlet, grinderRingRoller.fuelInlet2) annotation (Line(
      points={{-32,-20},{-32,-30}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(centrifugalClassifier.fuelOutlet2, fuelJoin_distributed.fuelInlet1) annotation (Line(
      points={{-32,40},{-32,0},{-32,0}},
      color={73,80,85},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end Mill_L4;
