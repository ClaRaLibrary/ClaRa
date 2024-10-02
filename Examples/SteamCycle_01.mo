within ClaRa.Examples;
model SteamCycle_01 "A closed steam cycle with a simple boiler model including single reheat, feedwater tank, LP and HP preheaters"

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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;

  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_HP1(
    contributeToCycleSummary=false,
    p_nom=NOM.Turbine_HP.p_in,
    m_flow_nom=NOM.Turbine_HP.m_flow,
    Pi=NOM.Turbine_HP.p_out/NOM.Turbine_HP.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_HP.p_in,
        NOM.Turbine_HP.h_in),
    allowFlowReversal=true,
    redeclare model Efficiency =
        ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (
         eta_mflow=([0.0,NOM.efficiency_Turb_HP; 1,NOM.efficiency_Turb_HP])),
    p_in_start=INIT.Turbine_HP.p_in,
    p_out_start=INIT.Turbine_HP.p_out,
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_HP.efficiency)
    annotation (Placement(transformation(extent={{-58,40},{-48,60}})));

  ClaRa.SubSystems.Boiler.SteamGenerator_L3 steamGenerator(
    p_LS_start=INIT.boiler.p_LS_out,
    p_RH_start=INIT.boiler.p_RS_out,
    p_LS_nom=NOM.boiler.p_LS_out,
    p_RH_nom=NOM.boiler.p_RS_out,
    h_LS_nom=NOM.boiler.h_LS_out,
    h_RH_nom=NOM.boiler.h_RS_out,
    h_LS_start=INIT.boiler.h_LS_out,
    h_RH_start=INIT.boiler.h_RS_out,
    Delta_p_nomHP=NOM.Delta_p_LS_nom,
    Delta_p_nomIP=NOM.Delta_p_RS_nom,
    Q_flow_F_nom=NOM.boiler.Q_flow,
    CL_yF_QF_=[0.4207,0.8341; 0.6246,0.8195; 0.8171,0.8049; 1,NOM.boiler.m_flow_feed*(NOM.boiler.h_LS_out - NOM.boiler.h_LS_in)/NOM.boiler.Q_flow],
    m_flow_nomLS=NOM.boiler.m_flow_LS_nom,
    Tau_dead=100,
    Tau_bal=50,
    volume_tot_HP=300,
    volume_tot_IP=100,
    CL_Delta_pHP_mLS_=NOM.CharLine_Delta_p_HP_mLS_,
    CL_Delta_pIP_mLS_=NOM.CharLine_Delta_p_IP_mRS_,
    CL_etaF_QF_=[0,0.9; 1,0.95],
    initOption_IP=0,
    initOption_HP=0,
    heatRelease(initType=Modelica.Blocks.Types.Init.SteadyState))             annotation (Placement(transformation(extent={{-154,46},{-126,84}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP1(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP1.efficiency; 1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    p_nom=NOM.Turbine_IP1.p_in,
    m_flow_nom=NOM.Turbine_IP1.m_flow,
    Pi=NOM.Turbine_IP1.p_out/NOM.Turbine_IP1.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP1.p_in,
        NOM.Turbine_IP1.h_in),
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_IP1.efficiency)
                            annotation (Placement(transformation(extent={{26,40},{36,60}})));

  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP4(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency =
        ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (
         eta_mflow=([0.0,NOM.Turbine_LP4.efficiency; 1,NOM.Turbine_LP4.efficiency])),
    p_in_start=INIT.Turbine_LP4.p_in,
    p_out_start=INIT.Turbine_LP4.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP4.p_in,
    m_flow_nom=NOM.Turbine_LP4.m_flow,
    Pi=NOM.Turbine_LP4.p_out/NOM.Turbine_LP4.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP4.p_in,
        NOM.Turbine_LP4.h_in),
    eta_mech=NOM.Turbine_LP4.efficiency)
    annotation (Placement(transformation(extent={{366,40},{376,60}})));

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_FW(eta_mech=NOM.efficiency_Pump_cond)
                                                                               annotation (Placement(transformation(extent={{30,-170},{10,-190}})));

  ClaRa.Visualisation.Quadruple quadruple(decimalSpaces(p=3))
                                          annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={420,70})));
  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-120,100},{-60,120}})));
  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{-220,100},{-160,120}})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{60,100},{120,120}})));
  ClaRa.Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{-40,100},{20,120}})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_BU_simple
                                             condenser(
    height=5,
    width=5,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    z_in_shell=4.9,
    z_out_shell=0.1,
    level_rel_start=0.5/6,
    m_flow_nom_shell=NOM.condenser.m_flow_in,
    p_nom_shell=NOM.condenser.p_condenser,
    p_start_shell=INIT.condenser.p_condenser,
    initOptionShell=204,
    levelOutput=true,
    z_in_aux1=4.9,
    z_in_aux2=4.9,
    height_hotwell=2,
    width_hotwell=1,
    length_hotwell=10,
    diameter_i=0.008,
    diameter_o=0.01,
    m_flow_nom_tubes=10000,
    p_nom_tubes=2e5,
    h_start_tubes=85e3,
    p_start_tubes=2e5,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2,
    length=12,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={3000,12000}),
    N_tubes=15000)       annotation (Placement(transformation(extent={{530,-60},{550,-40}})));

  ClaRa.Visualisation.Quadruple quadruple5(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{550,-100},{610,-80}})));

  Components.MechanicalSeparation.FeedWaterTank_L3 feedWaterTank(
    level_rel_start=0.5,
    diameter=5,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    p_start(displayUnit="bar") = INIT.feedwatertank.p_FWT,
    z_tapping=4.5,
    z_vent=4.5,
    z_condensate=4.5,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,1000}),
    m_flow_cond_nom=NOM.feedwatertank.m_flow_cond,
    p_nom=NOM.feedwatertank.p_FWT,
    h_nom=NOM.feedwatertank.h_cond_in,
    m_flow_heat_nom=NOM.feedwatertank.m_flow_tap1 + NOM.feedwatertank.m_flow_tap2,
    initOption=204,
    T_wall_start=ones(feedWaterTank.wall.N_rad)*(120 + 273.15),
    showLevel=true,
    length=12,
    z_aux=1, equalPressures = true, absorbInflow = 0.6)                               annotation (Placement(transformation(extent={{44,-138},{104,-118}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_cond(            showExpertSummary=true, eta_mech=0.9,
    m_flow_start=NOM.Pump_cond.summary.inlet.m_flow)                                                   annotation (Placement(transformation(extent={{520,-118},{500,-138}})));
  ClaRa.Components.Utilities.Blocks.LimPID PI_Pump_cond(
    sign=-1,
    y_ref=1e6,
    Tau_d=30,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_max=NOM.Pump_cond.P_pump*10,
    y_min=NOM.Pump_cond.P_pump/200,
    y_start=INIT.Pump_cond.P_pump,
    k=10,
    Tau_i=100,
    initOption=796) annotation (Placement(transformation(extent={{538,-260},{518,-240}})));
  ClaRa.Visualisation.Quadruple quadruple6
    annotation (Placement(transformation(extent={{50,-160},{110,-140}})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_IP1(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                     Delta_p_nom=NOM.valve_IP1.Delta_p, m_flow_nom=NOM.valve_IP1.m_flow)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={90,-30})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP1(
    contributeToCycleSummary=false,
    p_nom=NOM.Turbine_LP1.p_in,
    m_flow_nom=NOM.Turbine_LP1.m_flow,
    Pi=NOM.Turbine_LP1.p_out/NOM.Turbine_LP1.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP1.p_in,
        NOM.Turbine_LP1.h_in),
    allowFlowReversal=true,
    redeclare model Efficiency =
        ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (
         eta_mflow=([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_LP1.efficiency)
    annotation (Placement(transformation(extent={{246,40},{256,60}})));

  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={370,130})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_LP1(
    p_nom=INIT.Turbine_LP1.p_out,
    h_nom=INIT.Turbine_LP1.h_out,
    h_start=INIT.Turbine_LP1.h_out,
    p_start=INIT.Turbine_LP1.p_out,
    volume=0.1,
    initOption=0,
    m_flow_out_nom={NOM.Turbine_LP1.summary.outlet.m_flow,NOM.preheater_LP2.summary.inlet_tap.m_flow})
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={270,40})));

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_preheater_LP1(eta_mech=0.9, inlet(
                                                                                          m_flow(      start=NOM.pump_preheater_LP1.summary.inlet.m_flow)))
                                                                                        annotation (Placement(transformation(extent={{170,-160},{150,-180}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_IP2(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=NOM.valve_IP2.m_flow,
        Delta_p_nom=NOM.valve_IP2.Delta_p,
        rho_in_nom=2.4)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={200,-30})));

  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_HP(
    volume=0.1,
    p_start=INIT.Turbine_HP.p_out,
    p_nom=NOM.Turbine_HP.p_out,
    h_nom=NOM.Turbine_HP.h_out,
    h_start=INIT.Turbine_HP.h_out,
    showExpertSummary=true,
    m_flow_out_nom={NOM.join_HP.m_flow_2,NOM.join_HP.m_flow_3},
    initOption=0) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-88,18})));

  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_HP(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    m_flow_nom_shell=NOM.preheater_HP.m_flow_tap,
    p_nom_shell=NOM.preheater_HP.p_tap,
    h_nom_shell=NOM.preheater_HP.h_tap_out,
    m_flow_nom_tubes=NOM.preheater_HP.m_flow_cond,
    h_nom_tubes=NOM.preheater_HP.h_cond_out,
    h_start_tubes=INIT.preheater_HP.h_cond_out,
    N_passes=1,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    length=15,
    z_in_shell=preheater_HP.length,
    p_start_shell=INIT.preheater_HP.p_tap,
    diameter=2.6,
    showExpertSummary=true,
    Tau_cond=0.3,
    Tau_evap=0.03,
    alpha_ph=50000,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=3500),
    p_nom_tubes=NOM.preheater_HP.p_cond,
    p_start_tubes(displayUnit="bar") = INIT.preheater_HP.p_cond,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,1000}),
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=10),
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    T_w_start=ones(3)*(273.15 + 200),
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1650,10000}),
    diameter_i=0.02,
    diameter_o=0.028,
    N_tubes=2000,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-88,-182})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_HP(
    openingInputIsActive=false,
    showExpertSummary=true,
    redeclare model PressureLoss = Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=NOM.valve_HP.m_flow,
        Delta_p_nom=NOM.valve_HP.Delta_p_nom,
        rho_in_nom=25)) annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=90,
        origin={-88,-30})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_HP(openingInputIsActive=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (
        paraOption=2,
        m_flow_nom=NOM.valve2_HP.m_flow,
        Delta_p_nom=NOM.valve2_HP.Delta_p*0.01,
        rho_in_nom=800)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=0,
        origin={-46,-220})));
  ClaRa.Visualisation.StatePoint_phTs statePoint annotation (Placement(transformation(extent={{-160,-180},{-142,-160}})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_LP1(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    m_flow_nom_shell=NOM.preheater_LP1.m_flow_tap,
    p_nom_shell=NOM.preheater_LP1.p_tap,
    h_nom_shell=NOM.preheater_LP1.h_tap_out,
    m_flow_nom_tubes=NOM.preheater_LP1.m_flow_cond,
    h_nom_tubes=NOM.preheater_LP1.h_cond_out,
    h_start_tubes=INIT.preheater_LP1.h_cond_out,
    p_start_shell=INIT.preheater_LP1.p_tap,
    N_passes=1,
    Q_flow_nom=2e8,
    z_in_shell=preheater_LP1.length,
    z_in_tubes=preheater_LP1.diameter/2,
    z_out_tubes=preheater_LP1.diameter/2,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    p_nom_tubes=NOM.preheater_LP1.p_cond,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP1.p_cond,
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    length=10,
    diameter=3,
    diameter_i=0.05,
    diameter_o=0.052,
    level_rel_start=0.1,
    T_w_start={350,400,440},
    N_tubes=1000,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={200,-124})));

  Modelica.Blocks.Sources.RealExpression setPoint_preheater_HP(y=0.5) annotation (Placement(transformation(extent={{-88,-272},{-76,-260}})));
  Components.Utilities.Blocks.LimPID PI_valveControl_preheater_HP(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_max=1,
    y_min=0.01,
    Tau_i=10,
    y_start=0.2,
    k=2,
    initOption=796) annotation (Placement(transformation(extent={{-72,-260},{-52,-240}})));

  Modelica.Blocks.Continuous.FirstOrder measurement(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.1,
    T=10)
    annotation (Placement(transformation(extent={{570,-272},{562,-264}})));
  StaticCycles.Check.StaticCycleExamples.InitSteamCycle_01                    INIT(
    P_target_=1,
    p_condenser=NOM.p_condenser,
    preheater_HP_p_tap=NOM.preheater_HP_p_tap,
    preheater_HP_m_flow_tap=NOM.preheater_HP_m_flow_tap,
    preheater_LP1_p_tap=NOM.preheater_LP1_p_tap,
    preheater_LP1_m_flow_tap=NOM.preheater_LP1_m_flow_tap,
    p_FWT=NOM.p_FWT,
    valve_LP1_Delta_p_nom=NOM.valve_LP1_Delta_p_nom,
    valve_LP2_Delta_p_nom=NOM.valve_LP2_Delta_p_nom,
    T_LS_nom=NOM.T_LS_nom,
    T_RS_nom=NOM.T_RS_nom,
    p_LS_out_nom=NOM.p_LS_out_nom,
    p_RS_out_nom=NOM.p_RS_out_nom,
    Delta_p_LS_nom=NOM.Delta_p_LS_nom,
    Delta_p_RS_nom=NOM.Delta_p_RS_nom,
    CharLine_Delta_p_HP_mLS_=NOM.CharLine_Delta_p_HP_mLS_,
    CharLine_Delta_p_IP_mRS_=NOM.CharLine_Delta_p_IP_mRS_,
    efficiency_Pump_cond=NOM.efficiency_Pump_cond,
    efficiency_Pump_preheater_LP1=NOM.efficiency_Pump_preheater_LP1,
    efficiency_Pump_FW=NOM.efficiency_Pump_FW,
    efficiency_Turb_HP=NOM.efficiency_Turb_HP,
    efficiency_Turb_LP1=NOM.efficiency_Turb_LP1,
    efficiency_Turb_LP2=NOM.efficiency_Turb_LP2,
    m_flow_nom=NOM.m_flow_nom,
    IP3_pressure(displayUnit="kPa"),
    efficiency_Turb_IP1=NOM.efficiency_Turb_IP1,
    efficiency_Turb_IP2=NOM.efficiency_Turb_IP2,
    efficiency_Turb_IP3=NOM.efficiency_Turb_IP3,
    efficiency_Turb_LP3=NOM.efficiency_Turb_LP3,
    efficiency_Turb_LP4=NOM.efficiency_Turb_LP4,
    valve_HP_Delta_p_nom=NOM.valve_HP_Delta_p_nom)
                               annotation (Placement(transformation(extent={{-312,-198},{-292,-178}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valvePreFeedWaterTank(Tau=1e-3, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                          Delta_p_nom=NOM.valvePreFeedWaterTank.Delta_p_nom, m_flow_nom=NOM.valvePreFeedWaterTank.m_flow)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={160,-122})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_LP_main(
    volume=0.2,
    m_flow_in_nom={NOM.join_LP_main.m_flow_1,NOM.join_LP_main.m_flow_2},
    p_nom=NOM.join_LP_main.p,
    h_nom=NOM.join_LP_main.h3,
    h_start=INIT.join_LP_main.h3,
    p_start=INIT.join_LP_main.p,
    initOption=0,
    redeclare model PressureLossOut = Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=420))
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-122})));

  ClaRa.Components.Utilities.Blocks.LimPID PI_preheater1(
    sign=-1,
    Tau_d=30,
    y_max=NOM.pump_preheater_LP1.P_pump*1.5,
    y_min=NOM.pump_preheater_LP1.P_pump/100,
    y_ref=1e5,
    y_start=INIT.pump_preheater_LP1.P_pump,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=200,
    Tau_i=200,
    initOption=796) annotation (Placement(transformation(extent={{218,-240},{198,-260}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={126,-50})));
  ClaRa.Visualisation.Quadruple quadruple9
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={234,-50})));
  ClaRa.Visualisation.Quadruple quadruple10
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={160,-90})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-52,-50})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-20,-204})));
  ClaRa.Visualisation.Quadruple quadruple13
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={510,-90})));
  ClaRa.Visualisation.Quadruple quadruple14
    annotation (Placement(transformation(extent={{-26,-8},{26,8}},
        rotation=0,
        origin={160,-148})));
  Modelica.Blocks.Math.Gain Nominal_PowerFeedwaterPump1(k=NOM.Pump_FW.P_pump)
    annotation (Placement(transformation(extent={{-16,-276},{-8,-268}})));
  ClaRa.Visualisation.DynDisplay valveControl_preheater_HP_display(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_HP",
    x1=valveControl_preheater_HP.summary.outline.opening_) annotation (Placement(transformation(extent={{-38,-250},{-6,-238}})));
  ClaRa.Visualisation.DynDisplay electricalPower(
    decimalSpaces=2,
    varname="electrical Power",
    x1=simpleGenerator.summary.P_el/1e6,
    unit="MW") annotation (Placement(transformation(extent={{532,64},{572,76}})));
  StaticCycles.Check.StaticCycleExamples.InitSteamCycle_01                    NOM(
    final P_target_=1,
    Delta_p_RS_nom=4.91e5,
    efficiency_Pump_cond=0.9,
    efficiency_Pump_FW=0.9,
    efficiency_Turb_HP=1,
    efficiency_Turb_IP1=1,
    efficiency_Turb_IP2=1,
    efficiency_Turb_IP3=1,
    efficiency_Turb_LP1=1,
    efficiency_Turb_LP2=1,
    efficiency_Turb_LP3=1,
    efficiency_Turb_LP4=1,
    efficiency_Pump_preheater_LP1=0.9,
    efficiency_Pump_preheater_LP3=0.9,
    preheater_HP_p_tap=46e5)  annotation (Placement(transformation(extent={{-312,-236},{-292,-216}})));
  inner SimCenter simCenter(
    contributeToCycleSummary=true,
    redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1,
    showExpertSummary=true) annotation (Placement(transformation(extent={{-280,-220},{-240,-200}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP3(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP1.efficiency; 1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_IP3.p_in,
    m_flow_nom=NOM.Turbine_IP3.m_flow,
    Pi=NOM.Turbine_IP3.p_out/NOM.Turbine_IP3.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP3.p_in,
        NOM.Turbine_IP3.h_in),
    eta_mech=NOM.Turbine_IP3.efficiency)
                            annotation (Placement(transformation(extent={{106,40},{116,60}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP2(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP1.efficiency; 1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_IP2.p_in,
    m_flow_nom=NOM.Turbine_IP2.m_flow,
    Pi=NOM.Turbine_IP2.p_out/NOM.Turbine_IP2.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP2.p_in,
        NOM.Turbine_IP2.h_in),
    eta_mech=NOM.Turbine_IP2.efficiency)
                            annotation (Placement(transformation(extent={{66,40},{76,60}})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_IP2(
    volume=0.1,
    initOption=0,
    p_nom=NOM.Turbine_IP2.p_out,
    h_nom=NOM.Turbine_IP2.h_out,
    m_flow_out_nom={NOM.Turbine_IP2.summary.outlet.m_flow,NOM.feedwatertank.m_flow_tap2},
    h_start=INIT.Turbine_IP2.h_out,
    p_start=INIT.Turbine_IP2.p_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,40})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_IP3(
    volume=0.1,
    initOption=0,
    p_nom=NOM.Turbine_IP3.p_out,
    h_nom=NOM.Turbine_IP3.h_out,
    m_flow_out_nom={NOM.Turbine_IP3.summary.outlet.m_flow,NOM.preheater_LP1.summary.inlet_tap.m_flow},
    h_start=INIT.Turbine_IP3.h_out,
    p_start=INIT.Turbine_IP3.p_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={200,40})));
  Visualisation.Quadruple       quadruple15
    annotation (Placement(transformation(extent={{80,80},{140,100}})));
  Visualisation.Quadruple       quadruple16
    annotation (Placement(transformation(extent={{120,60},{180,80}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_LP3(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP3.p_in,
    m_flow_nom=NOM.Turbine_LP3.m_flow,
    Pi=NOM.Turbine_LP3.p_out/NOM.Turbine_LP3.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP3.p_in,
        NOM.Turbine_LP3.h_in),
    eta_mech=NOM.Turbine_LP3.efficiency)
    annotation (Placement(transformation(extent={{326,40},{336,60}})));
  Components.TurboMachines.Turbines.SteamTurbineVLE_L1       Turbine_LP2(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP2.p_in,
    m_flow_nom=NOM.Turbine_LP2.m_flow,
    Pi=NOM.Turbine_LP2.p_out/NOM.Turbine_LP2.p_in,
    rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP2.p_in,
        NOM.Turbine_LP2.h_in),
    eta_mech=NOM.Turbine_LP2.efficiency)
    annotation (Placement(transformation(extent={{286,40},{296,60}})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y       join_LP2(
    volume=0.1,
    initOption=0,
    p_nom=INIT.Turbine_LP2.p_out,
    h_nom=INIT.Turbine_LP2.h_out,
    m_flow_out_nom={NOM.Turbine_LP2.summary.outlet.m_flow,NOM.preheater_LP3.summary.inlet_tap.m_flow},
    h_start=INIT.Turbine_LP2.h_out,
    p_start=INIT.Turbine_LP2.p_out)
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={310,40})));
  Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_LP3(
    volume=0.1,
    initOption=0,
    p_nom=INIT.Turbine_LP3.p_out,
    h_nom=INIT.Turbine_LP3.h_out,
    h_start=INIT.Turbine_LP3.h_out,
    p_start=INIT.Turbine_LP3.p_out,
    m_flow_out_nom={NOM.Turbine_LP2.summary.outlet.m_flow,NOM.preheater_LP4.summary.inlet_tap.m_flow}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={350,40})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP1(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                               Delta_p_nom=NOM.valve_LP1.Delta_p, m_flow_nom=NOM.valve_LP1.m_flow)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={270,-30})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_LP2(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    N_passes=1,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    length=10,
    diameter=2,
    z_in_shell=preheater_LP2.length,
    m_flow_nom_shell=NOM.preheater_LP2.m_flow_tap,
    p_nom_shell=NOM.preheater_LP2.p_tap,
    h_nom_shell=NOM.preheater_LP2.h_tap_out,
    p_start_shell=INIT.preheater_LP2.p_tap,
    diameter_i=0.05,
    diameter_o=0.052,
    N_tubes=1000,
    z_in_tubes=preheater_LP2.diameter/2,
    z_out_tubes=preheater_LP2.diameter/2,
    m_flow_nom_tubes=NOM.preheater_LP2.m_flow_cond,
    p_nom_tubes=NOM.preheater_LP2.p_cond,
    h_nom_tubes=NOM.preheater_LP2.h_cond_out,
    h_start_tubes=INIT.preheater_LP2.h_cond_out,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP2.p_cond,
    level_rel_start=0.1,
    T_w_start={320,340,360},
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={270,-124})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple preheater_LP3(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    T_w_start={300,320,340},
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    length=10,
    diameter=2,
    z_in_shell=preheater_LP3.length,
    m_flow_nom_shell=NOM.preheater_LP3.m_flow_tap,
    p_nom_shell=NOM.preheater_LP3.p_tap,
    h_nom_shell=NOM.preheater_LP3.h_tap_out,
    p_start_shell=INIT.preheater_LP3.p_tap,
    diameter_i=0.05,
    diameter_o=0.052,
    m_flow_nom_tubes=NOM.preheater_LP3.m_flow_cond,
    p_nom_tubes=NOM.preheater_LP3.p_cond,
    h_nom_tubes=NOM.preheater_LP3.h_cond_out,
    h_start_tubes=INIT.preheater_LP3.h_cond_out,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP3.p_cond,
    level_rel_start=0.2,
    equalPressures=true,
    N_passes=2,
    N_tubes=500,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={340,-124})));
  Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple preheater_LP4(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    T_w_start={300,320,340},
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model HeatTransfer_Shell = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    length=10,
    diameter=2,
    z_in_shell=preheater_LP4.length,
    m_flow_nom_shell=NOM.preheater_LP4.m_flow_tap,
    p_nom_shell=NOM.preheater_LP4.p_tap,
    h_nom_shell=NOM.preheater_LP4.h_tap_out,
    diameter_i=0.05,
    diameter_o=0.052,
    m_flow_nom_tubes=NOM.preheater_LP4.m_flow_cond,
    p_nom_tubes=NOM.preheater_LP4.p_cond,
    h_nom_tubes=NOM.preheater_LP4.h_cond_out,
    h_start_tubes=INIT.preheater_LP4.h_cond_out,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP4.p_cond,
    level_rel_start=0.1,
    N_passes=2,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    N_tubes=600,
    p_start_shell=INIT.preheater_LP4.p_tap,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={410,-124})));
  Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_preheater_LP3(showExpertSummary=true, eta_mech=0.9,
    inlet(m_flow(start=NOM.pump_preheater_LP3.summary.inlet.m_flow)),
    outlet(p(start=NOM.pump_preheater_LP3.summary.outlet.p)))                                               annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={320,-170})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_afterPumpLP3(redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                       m_flow_nom=30, Delta_p_nom=1000)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={304,-150})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP2(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        CL_valve=[0,0; 1,1],
        m_flow_nom=25,
        Delta_p_nom=0.2e5)) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=90,
        origin={270,-150})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_preheater_LP3(
    volume=0.1,
    initOption=0,
    p_nom=NOM.join_preheater_LP3.summary.outlet.p,
    h_nom=NOM.join_preheater_LP3.summary.outlet.h,
    h_start=INIT.join_preheater_LP3.summary.outlet.h,
    p_start=INIT.join_preheater_LP3.summary.outlet.p,
    redeclare model PressureLossIn1 = Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=NOM.m_flow_nom, dp_nom=10))
                                                      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={304,-122})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP4(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        m_flow_nom=8,
        CL_valve=[0,0; 1,1],
        Delta_p_nom=0.06e5)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=0,
        origin={450,-170})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP2(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                               Delta_p_nom=NOM.valve_LP2.Delta_p, m_flow_nom=NOM.valve_LP2.m_flow)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={340,-30})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP3(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                               Delta_p_nom=NOM.valve_LP3.Delta_p, m_flow_nom=NOM.valve_LP3.m_flow)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={410,-30})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(                                                             T_const=273.15 + 15, m_flow_const=25000)
                                                                                                                     annotation (Placement(transformation(extent={{620,-80},{600,-60}})));
  Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=2e5) annotation (Placement(transformation(extent={{620,-40},{600,-20}})));
  Components.Utilities.Blocks.LimPID PID_preheaterLP4(
    sign=-1,
    u_ref=0.1,
    y_ref=1,
    y_max=1,
    y_start=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_in=0.8,
    Tau_out=0.8,
    y_min=0,
    Tau_i=15,
    t_activation=5,
    k=0.2,
    initOption=796) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={418,-250})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP4(y=0.1) annotation (Placement(transformation(extent={{372,-246},{386,-234}})));
  Components.Utilities.Blocks.LimPID PID_preheaterLP3(
    u_ref=0.2,
    Tau_in=0.8,
    Tau_out=0.8,
    sign=-1,
    t_activation=2,
    use_activateInput=false,
    y_ref=150000,
    y_inactive=150000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    y_min=2000,
    y_max=10e6,
    y_start=INIT.pump_preheater_LP3.P_pump,
    Tau_i=30,
    initOption=796) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={348,-250})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP3(y=0.1) annotation (Placement(transformation(extent={{386,-256},{372,-244}})));
  Components.Utilities.Blocks.LimPID PID_NDVW3(
    Tau_in=0.8,
    Tau_out=0.8,
    sign=-1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=0.1,
    y_ref=1,
    y_max=1,
    y_min=0,
    y_start=1,
    k=0.5,
    Tau_i=20,
    initOption=796) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={278,-250})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP2(y=0.1) annotation (Placement(transformation(extent={{314,-256},{300,-244}})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP1(y=0.1) annotation (Placement(transformation(extent={{244,-256},{230,-244}})));
  Modelica.Blocks.Sources.RealExpression setPoint_condenser(y=0.5/6) annotation (Placement(transformation(extent={{586,-256},{572,-244}})));
  Visualisation.Quadruple       quadruple17
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={390,110})));
  Visualisation.Quadruple       quadruple18
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={410,90})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=2000, phi(start=0))
                                                                   annotation (Placement(transformation(extent={{512,40},{532,60}})));
  Components.Electrical.SimpleGenerator simpleGenerator(contributeToCycleSummary=true,
                                                        hasInertia=true) annotation (Placement(transformation(extent={{542,40},{562,60}})));
  Components.BoundaryConditions.BoundaryElectricFrequency boundaryElectricFrequency annotation (Placement(transformation(extent={{602,40},{582,60}})));
  Visualisation.Quadruple       quadruple19
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={304,-50})));
  Visualisation.Quadruple       quadruple20
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={374,-50})));
  Visualisation.Quadruple       quadruple21
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={446,-50})));
  Visualisation.DynamicBar fillingLevel_preheater_LP1(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{208,-134},{218,-114}})));
  Visualisation.DynamicBar fillingLevel_preheater_LP2(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{278,-134},{288,-114}})));
  Visualisation.DynamicBar fillingLevel_preheater_LP3(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{348,-134},{358,-114}})));
  Visualisation.DynamicBar fillingLevel_preheater_LP4(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{418,-134},{428,-114}})));
  Visualisation.DynamicBar fillingLevel_condenser(
    u_set=0.5/6,
    u_high=0.5/3,
    u_low=0.5/12,
    provideInputConnectors=true)
                  annotation (Placement(transformation(extent={{548,-60},{558,-40}})));
  Visualisation.DynamicBar fillingLevel_preheater_HP(
    provideInputConnectors=true,
    u_set=0.5,
    u_high=0.6,
    u_low=0.4)  annotation (Placement(transformation(extent={{-80,-192},{-70,-172}})));
  Visualisation.DynDisplay valveControl_preheater_LP4_display(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_LP4",
    x1=valveControl_preheater_LP4.summary.outline.opening_) annotation (Placement(transformation(extent={{434,-160},{466,-148}})));
  Visualisation.DynDisplay valveControl_preheater_LP2_display2(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_LP2",
    x1=valveControl_preheater_LP2.summary.outline.opening_) annotation (Placement(transformation(extent={{222,-156},{254,-144}})));
  ClaRa.Visualisation.Quadruple quadruple22
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={234,-90})));
  ClaRa.Visualisation.Quadruple quadruple23
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={376,-90})));
  ClaRa.Visualisation.Quadruple quadruple24
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={444,-90})));
  Modelica.Blocks.Sources.TimeTable PTarget(table=[0,1; 500,1; 510,0.7; 1400,0.7; 1410,1; 2300,1; 2310,0.7; 3200,0.7; 3210,1; 5000,1])   annotation (Placement(transformation(extent={{-280,48},{-260,68}})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple downComer_feedWaterTank(
    m_flow_nom=NOM.downComer_feedWaterTank.summary.outlet.m_flow,
    p_nom=ones(downComer_feedWaterTank.geo.N_cv)*NOM.downComer_feedWaterTank.summary.outlet.p,
    h_nom=ones(downComer_feedWaterTank.geo.N_cv)*NOM.downComer_feedWaterTank.summary.outlet.h,
    length=downComer_feedWaterTank.z_in - downComer_feedWaterTank.z_out,
    diameter_i=0.2,
    h_start=ones(downComer_feedWaterTank.geo.N_cv)*INIT.downComer_feedWaterTank.summary.inlet.h,
    z_in=NOM.downComer_z_in,
    z_out=NOM.downComer_z_out,
    p_start=linspace(
        INIT.downComer_feedWaterTank.summary.inlet.p,
        INIT.downComer_feedWaterTank.summary.outlet.p,
        downComer_feedWaterTank.geo.N_cv),
    frictionAtInlet=true) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={40,-159})));
  Visualisation.Quadruple       quadruple25
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-140,-192})));
  Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP1(redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        CL_valve=[0,0; 1,1],
        Delta_p_nom=1000,
        m_flow_nom=25000)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={586,-30})));
equation
  connect(steamGenerator.reheat_out, Turbine_IP1.inlet) annotation (Line(
      points={{-131.6,84},{26,84},{26,56}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(Pump_FW.outlet, preheater_HP.In2) annotation (Line(
      points={{10,-180},{-78,-180}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_HP.Out2, steamGenerator.feedwater) annotation (Line(
      points={{-98,-180},{-140,-180},{-140,46.475}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_HP.outlet, preheater_HP.In1) annotation (Line(
      points={{-88,-40},{-88,-172.2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_HP.Out2, statePoint.port) annotation (Line(
      points={{-98,-180},{-160,-180}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_LP1.In1,valve_IP2. outlet) annotation (Line(
      points={{200,-114.2},{200,-40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_LP1.Out1, Pump_preheater_LP1.inlet) annotation (Line(
      points={{200,-134},{200,-170},{170,-170}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PI_valveControl_preheater_HP.y, valveControl_preheater_HP.opening_in) annotation (Line(
      points={{-51,-250},{-46,-250},{-46,-229}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(measurement.y, PI_Pump_cond.u_m) annotation (Line(
      points={{561.6,-268},{527.9,-268},{527.9,-262}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(join_LP1.inlet, Turbine_LP1.outlet) annotation (Line(
      points={{260,40},{256,40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.inlet,Turbine_HP1. outlet) annotation (Line(
      points={{-78,18},{-48,18},{-48,40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet1, steamGenerator.reheat_in) annotation (Line(
      points={{-98,18},{-131.6,18},{-131.6,46.475}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet2, valve_HP.inlet) annotation (Line(
      points={{-88,8},{-88,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valvePreFeedWaterTank.inlet, preheater_LP1.Out2) annotation (Line(
      points={{170,-122},{190,-122}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valvePreFeedWaterTank.outlet, join_LP_main.inlet1) annotation (Line(
      points={{150,-122},{140,-122}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PI_Pump_cond.y, Pump_cond.P_drive) annotation (Line(
      points={{517,-250},{510,-250},{510,-140}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI_preheater1.y, Pump_preheater_LP1.P_drive) annotation (Line(
      points={{197,-250},{160,-250},{160,-182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(steamGenerator.eye_LS, quadruple2.eye) annotation (Line(
      points={{-145.6,84.7125},{-145.6,110},{-220,110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(steamGenerator.eye_RH, quadruple1.eye) annotation (Line(
      points={{-126,84.7125},{-126,110},{-120,110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_HP1.eye, quadruple4.eye) annotation (Line(
      points={{-47,44},{-40,44},{-40,110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_IP1.eye, quadruple3.eye) annotation (Line(
      points={{37,44},{40,44},{40,110},{60,110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP1.eye, quadruple7.eye) annotation (Line(
      points={{257,44},{270,44},{270,130},{340,130}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP4.eye, quadruple.eye) annotation (Line(
      points={{377,44},{382,44},{382,70},{390,70}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple6.eye, feedWaterTank.eye) annotation (Line(
      points={{50,-150},{50,-139},{52,-139}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple8.eye, valve_IP1.eye) annotation (Line(
      points={{96,-50},{86,-50},{86,-40}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple9.eye,valve_IP2. eye) annotation (Line(
      points={{204,-50},{196,-50},{196,-40}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(valve_HP.eye, quadruple11.eye) annotation (Line(
      points={{-92,-40},{-92,-49.7},{-82,-49.7},{-82,-50}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple12.eye, valveControl_preheater_HP.eye) annotation (Line(
      points={{-50,-204},{-20,-204},{-20,-216},{-36,-216}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple13.eye, Pump_cond.eye) annotation (Line(
      points={{480,-90},{480,-122},{499,-122}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple14.eye, Pump_preheater_LP1.eye) annotation (Line(
      points={{134,-148},{134,-164},{149,-164}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(preheater_HP.Out1, valveControl_preheater_HP.inlet) annotation (Line(
      points={{-88,-192},{-86,-192},{-86,-220},{-56,-220}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(Nominal_PowerFeedwaterPump1.y, Pump_FW.P_drive) annotation (Line(
      points={{-7.6,-272},{20,-272},{20,-192}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.outlet, join_LP_main.inlet2) annotation (Line(
      points={{150,-170},{130,-170},{130,-132}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP_main.outlet, feedWaterTank.condensate) annotation (Line(
      points={{120,-122},{94,-122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(Turbine_IP2.outlet, split_IP2.inlet) annotation (Line(
      points={{76,40},{80,40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(split_IP2.outlet1, Turbine_IP3.inlet) annotation (Line(
      points={{100,40},{100,56},{106,56}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_IP3.outlet, join_IP3.inlet) annotation (Line(
      points={{116,40},{190,40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_IP2.eye, quadruple15.eye) annotation (Line(points={{77,44},{80,44},{80,90}}, color={190,190,190}));
  connect(Turbine_IP3.eye, quadruple16.eye) annotation (Line(points={{117,44},{120,44},{120,70}}, color={190,190,190}));
  connect(split_IP2.outlet2, valve_IP1.inlet) annotation (Line(
      points={{90,30},{90,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_IP3.outlet1, Turbine_LP1.inlet) annotation (Line(
      points={{210,40},{240,40},{240,56},{246,56}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP2.outlet, join_LP2.inlet) annotation (Line(
      points={{296,40},{300,40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP2.outlet1, Turbine_LP3.inlet) annotation (Line(
      points={{320,40},{320,56},{326,56}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(split_LP3.outlet1, Turbine_LP4.inlet) annotation (Line(
      points={{360,40},{360,56},{366,56}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP3.outlet, split_LP3.inlet) annotation (Line(
      points={{336,40},{340,40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.Out2, preheater_LP1.In2) annotation (Line(
      points={{260,-122},{210,-122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.In1,valve_LP1. outlet) annotation (Line(
      points={{270,-114.2},{270,-40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.Out1, valveControl_preheater_LP2.inlet) annotation (Line(
      points={{270,-134},{270,-140}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP2.outlet, preheater_LP3.aux1) annotation (Line(
      points={{270,-160},{270,-170},{292,-170},{292,-116},{330,-116},{330,-116}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_preheater_LP3.outlet, preheater_LP2.In2) annotation (Line(
      points={{294,-122},{280,-122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_preheater_LP3.inlet1, preheater_LP3.Out2) annotation (Line(
      points={{314,-122},{320,-122},{320,-106},{366,-106},{366,-118},{350,-118}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP3.Out1, Pump_preheater_LP3.inlet) annotation (Line(
      points={{340,-134},{340,-170},{330,-170}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_preheater_LP3.outlet, valve_afterPumpLP3.inlet) annotation (Line(
      points={{310,-170},{304,-170},{304,-160}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_afterPumpLP3.outlet, join_preheater_LP3.inlet2) annotation (Line(
      points={{304,-140},{304,-132}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.Out2, preheater_LP3.In2) annotation (Line(
      points={{420,-118},{432,-118},{432,-106},{376,-106},{376,-128},{350,-128}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_IP3.outlet2,valve_IP2. inlet) annotation (Line(
      points={{200,30},{200,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP1.outlet2,valve_LP1. inlet) annotation (Line(
      points={{270,30},{270,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP2.outlet2,valve_LP2. inlet) annotation (Line(
      points={{310,30},{310,-10},{340,-10},{340,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(split_LP3.outlet2, valve_LP3.inlet) annotation (Line(
      points={{350,30},{350,0},{410,0},{410,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_LP2.outlet, preheater_LP3.In1) annotation (Line(
      points={{340,-40},{340,-114}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_LP3.outlet, preheater_LP4.In1) annotation (Line(
      points={{410,-40},{410,-114}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP4.outlet, condenser.In1) annotation (Line(
      points={{376,40},{376,10},{540,10},{540,-40.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(condenser.eye1, quadruple5.eye) annotation (Line(points={{544,-61},{544,-90},{550,-90}}, color={190,190,190}));
  connect(boundaryVLE_Txim_flow.steam_a, condenser.In2) annotation (Line(
      points={{600,-70},{570,-70},{570,-54},{550,-54}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_cond.outlet, preheater_LP4.In2) annotation (Line(
      points={{500,-128},{420,-128}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.Out1, valveControl_preheater_LP4.inlet) annotation (Line(
      points={{410,-134},{410,-170},{440,-170}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP4.outlet, condenser.aux1) annotation (Line(
      points={{460,-170},{476,-170},{476,-42},{530,-42}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(condenser.Out1, Pump_cond.inlet) annotation (Line(
      points={{540,-60},{540,-128},{520,-128}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.level, PID_preheaterLP4.u_m) annotation (Line(points={{418,-135},{418,-166},{418.1,-166},{418.1,-238}}, color={0,0,127}));
  connect(setPoint_preheaterLP4.y, PID_preheaterLP4.u_s) annotation (Line(points={{386.7,-240},{396,-240},{396,-250},{406,-250}}, color={0,0,127}));
  connect(PID_preheaterLP4.y, valveControl_preheater_LP4.opening_in) annotation (Line(points={{429,-250},{450,-250},{450,-179}}, color={0,0,127}));
  connect(preheater_LP3.level, PID_preheaterLP3.u_m) annotation (Line(points={{348,-135},{347.9,-135},{347.9,-238}}, color={0,0,127}));
  connect(PID_preheaterLP3.y, Pump_preheater_LP3.P_drive) annotation (Line(points={{337,-250},{320,-250},{320,-182}}, color={0,0,127}));
  connect(setPoint_preheaterLP3.y, PID_preheaterLP3.u_s) annotation (Line(points={{371.3,-250},{360,-250}}, color={0,0,127}));
  connect(PID_NDVW3.y, valveControl_preheater_LP2.opening_in) annotation (Line(points={{267,-250},{256,-250},{256,-150},{261,-150}}, color={0,0,127}));
  connect(preheater_LP2.level, PID_NDVW3.u_m) annotation (Line(points={{278,-135},{278,-238},{277.9,-238}}, color={0,0,127}));
  connect(setPoint_preheaterLP2.y, PID_NDVW3.u_s) annotation (Line(points={{299.3,-250},{290,-250}}, color={0,0,127}));
  connect(preheater_LP1.level, PI_preheater1.u_m) annotation (Line(points={{208,-135},{208,-180},{207.9,-180},{207.9,-238}}, color={0,0,127}));
  connect(setPoint_preheaterLP1.y, PI_preheater1.u_s) annotation (Line(points={{229.3,-250},{220,-250}}, color={0,0,127}));
  connect(condenser.level, measurement.u) annotation (Line(points={{548,-61},{548,-140},{600,-140},{600,-268},{570.8,-268}},
                                                                                                     color={0,0,127}));
  connect(setPoint_condenser.y, PI_Pump_cond.u_s) annotation (Line(points={{571.3,-250},{540,-250}}, color={0,0,127}));
  connect(Turbine_LP3.eye, quadruple18.eye) annotation (Line(points={{337,44},{340,44},{340,90},{380,90}}, color={190,190,190}));
  connect(Turbine_LP2.eye, quadruple17.eye) annotation (Line(points={{297,44},{300,44},{300,110},{360,110}}, color={190,190,190}));
  connect(Turbine_HP1.shaft_b, Turbine_IP1.shaft_a) annotation (Line(points={{-44,50},{22,50}}, color={0,0,0}));
  connect(Turbine_IP1.shaft_b, Turbine_IP2.shaft_a) annotation (Line(points={{40,50},{62,50}}, color={0,0,0}));
  connect(Turbine_IP2.shaft_b, Turbine_IP3.shaft_a) annotation (Line(points={{80,50},{102,50}}, color={0,0,0}));
  connect(Turbine_IP3.shaft_b, Turbine_LP1.shaft_a) annotation (Line(points={{120,50},{242,50}}, color={0,0,0}));
  connect(Turbine_LP1.shaft_b, Turbine_LP2.shaft_a) annotation (Line(points={{260,50},{282,50}}, color={0,0,0}));
  connect(Turbine_LP2.shaft_b, Turbine_LP3.shaft_a) annotation (Line(points={{300,50},{322,50}}, color={0,0,0}));
  connect(Turbine_LP3.shaft_b, Turbine_LP4.shaft_a) annotation (Line(points={{340,50},{362,50}}, color={0,0,0}));
  connect(Turbine_LP4.shaft_b, inertia.flange_a) annotation (Line(points={{380,50},{512,50}}, color={0,0,0}));
  connect(inertia.flange_b, simpleGenerator.shaft) annotation (Line(points={{532,50},{532,49.9},{542,49.9}},          color={0,0,0}));
  connect(simpleGenerator.powerConnection, boundaryElectricFrequency.electricPortIn) annotation (Line(
      points={{562,50},{582,50}},
      color={115,150,0},
      thickness=0.5));
  connect(valve_LP1.eye, quadruple19.eye) annotation (Line(points={{266,-40},{266,-50},{274,-50}}, color={190,190,190}));
  connect(valve_LP2.eye, quadruple20.eye) annotation (Line(points={{336,-40},{336,-50},{344,-50}}, color={190,190,190}));
  connect(valve_LP3.eye, quadruple21.eye) annotation (Line(points={{406,-40},{406,-50},{416,-50}}, color={190,190,190}));
  connect(preheater_HP.level, PI_valveControl_preheater_HP.u_s) annotation (Line(points={{-80,-193},{-80,-250},{-74,-250}}, color={0,0,127}));
  connect(setPoint_preheater_HP.y, PI_valveControl_preheater_HP.u_m) annotation (Line(points={{-75.4,-266},{-61.9,-266},{-61.9,-262}},
                                                                                                                                   color={0,0,127}));
  connect(preheater_LP1.level, fillingLevel_preheater_LP1.u_in) annotation (Line(points={{208,-135},{206,-135},{206,-134},{207,-134}}, color={0,0,127}));
  connect(preheater_LP2.level, fillingLevel_preheater_LP2.u_in) annotation (Line(points={{278,-135},{276,-135},{276,-134},{277,-134}}, color={0,0,127}));
  connect(preheater_LP3.level, fillingLevel_preheater_LP3.u_in) annotation (Line(points={{348,-135},{348,-134},{347,-134}}, color={0,0,127}));
  connect(preheater_LP4.level, fillingLevel_preheater_LP4.u_in) annotation (Line(points={{418,-135},{418,-134},{417,-134}},            color={0,0,127}));
  connect(condenser.level, fillingLevel_condenser.u_in) annotation (Line(points={{548,-61},{548,-60},{547,-60}}, color={0,0,127}));
  connect(preheater_HP.level, fillingLevel_preheater_HP.u_in) annotation (Line(points={{-80,-193},{-82,-193},{-82,-192},{-81,-192}}, color={0,0,127}));
  connect(Turbine_IP1.outlet, Turbine_IP2.inlet) annotation (Line(
      points={{36,40},{60,40},{60,56},{66,56}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP1.outlet1, Turbine_LP2.inlet) annotation (Line(
      points={{280,40},{280,56},{286,56}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP1.eye2, quadruple10.eye) annotation (Line(points={{189,-124},{188,-124},{188,-110},{160,-110},{160,-90},{130,-90}},
                                                                                                                      color={190,190,190}));
  connect(preheater_LP2.eye2, quadruple22.eye) annotation (Line(points={{259,-124},{234,-124},{234,-90},{204,-90}},   color={190,190,190}));
  connect(preheater_LP3.eye2, quadruple23.eye) annotation (Line(points={{351,-116},{370,-116},{370,-100},{344,-100},{344,-90},{346,-90}},   color={190,190,190}));
  connect(preheater_LP4.eye2, quadruple24.eye) annotation (Line(points={{421,-116},{440,-116},{440,-100},{414,-100},{414,-90}},
                                                                                                                      color={190,190,190}));
  connect(PTarget.y, steamGenerator.QF_setl_) annotation (Line(points={{-259,58},{-158,58},{-158,58},{-158,58},{-158,57.875},{-156.8,57.875}}, color={0,0,127}));
  connect(PTarget.y, Nominal_PowerFeedwaterPump1.u) annotation (Line(points={{-259,58},{-180,58},{-180,-272},{-16.8,-272}},
                                                                                                                          color={0,0,127}));
  connect(steamGenerator.livesteam, Turbine_HP1.inlet) annotation (Line(
      points={{-140,84},{-140,90},{-58,90},{-58,56}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(downComer_feedWaterTank.outlet, Pump_FW.inlet) annotation (Line(
      points={{40,-173},{40,-180},{30,-180}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedWaterTank.feedwater, downComer_feedWaterTank.inlet) annotation (Line(
      points={{48,-138},{48,-140},{40,-140},{40,-145}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_HP.eye2, quadruple25.eye) annotation (Line(points={{-99,-182},{-170,-182},{-170,-192}}, color={190,190,190}));
  connect(valve_IP1.outlet, feedWaterTank.heatingSteam) annotation (Line(
      points={{90,-40},{90,-112},{54,-112},{54,-120}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_HP.outlet, feedWaterTank.aux) annotation (Line(
      points={{-36,-220},{112,-220},{112,-122},{90,-122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP1.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{596,-30},{600,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(condenser.Out2, valveControl_preheater_LP1.inlet) annotation (Line(
      points={{550,-44},{570,-44},{570,-30},{576,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-320,-280},{620,240}}),
                      graphics={
        Rectangle(
          extent={{-280,-160},{-238,-240}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{-320,-160},{-280,-240}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-316,-158},{-288,-178}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleINIT"),
        Text(
          extent={{-322,-198},{-282,-218}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleSettings"),
        Text(
          extent={{-278,-178},{-244,-196}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Model
Properties"),                     Text(
          extent={{-312,228},{-116,164}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="______________________________________________________________________________________________
PURPOSE:
Example of a steam cycle of a 580 MW hard coal power plant. It has a single reheat, one HP preheater and four LP preheaters.
A simple steam generator model is used. Initial and nominal values are computed with help of the static cycle package. 
Levels of preheaters and condenser are controlled by simple PI-controllers, the heating power and feedwater pump power is set by a feed forward block.
Models provide information for automatic efficiency calculation within SimCenter-model.
______________________________________________________________________________________________
"),                   Text(
          extent={{-312,150},{-112,132}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="______________________________________________________________________________________________
Scenario:  
Two successive load reductions to 70 percent load at t=500s and t=2300s with a length of 15 minutes each.
______________________________________________________________________________________________
"),     Rectangle(
          extent={{-320,240},{620,-280}},
          lineColor={115,150,0},
          lineThickness=0.5)}),  Icon(graphics,
                                      coordinateSystem(preserveAspectRatio=true, initialScale=0.1)),
    experiment(
      StopTime=5000,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false));
end SteamCycle_01;
