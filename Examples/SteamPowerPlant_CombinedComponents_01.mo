within ClaRa.Examples;
model SteamPowerPlant_CombinedComponents_01 "A steam power plant model based on SteamCycle_02 with a detailed boiler model (coal dust fired Benson boiler) without controls"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.8.2                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under the 3-clause BSD License.   //
  // Copyright  2013-2021, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//
    extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;

   import Modelica.Utilities.Files.loadResource;
    parameter TILMedia.VLEFluidTypes.BaseVLEFluid
                                      medium=simCenter.fluid1 "Medium in the component"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter Real alpha_wall= 15;
  parameter Real emissivity_wall = 0.75;
  parameter Real CF_fouling_glob = 0.8;
  parameter Real CF_fouling_rad_glob = 0.78;
  Real P_gen_act = electricalPower.x1/633;

  ClaRa.Basics.Units.HeatFlowRate totalHeat;
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner3(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{46,-106},{26,-86}})));

  ClaRa.Components.Adapters.FuelSlagFlueGas_split             coalSlagFlueGas_split_top
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-98,258})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_Tm_flow slagFlowSource_top(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-198,304})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi coalSink_top(T_const=658.15, xi_const={0.84,0.07})             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-172,292})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink_top(                T_const=658.15,
    xi_const={0.00488,0.00013,0.21147,0.00155,0.70952,0.03784,0,0.00347,0},
    p_const(displayUnit="bar") = 99000)                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-318,-12})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner1(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{46,-158},{26,-138}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2,-154})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner2(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{46,-132},{26,-112}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner2 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2,-128})));

  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2,-102})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature5(T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-16,262})));

  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner4(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{46,-80},{26,-60}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner4 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2,-76})));

  ClaRa.Components.Sensors.SensorVLE_L1_T
                                       sh_4_out_T(unitOption=2)
    annotation (Placement(transformation(extent={{378,184},{398,206}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill1(T_out_start=846,
    initOption=0,
    applyGrindingDelay=true)                                               annotation (Placement(transformation(extent={{-14,-164},{-34,-144}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=10,
    offset=1.50,
    startTime=1500,
    height=-0.0)
    annotation (Placement(transformation(extent={{12,-50},{-8,-30}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 eco_riser_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco_riser.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    diameter_o=eco_riser.diameter_i + 0.03,
    diameter_i=eco_riser.diameter_i,
    length=eco_riser.length,
    N_tubes=eco_riser.N_tubes,
    T_start=ones(eco_riser_wall.N_ax)*(INIT.eco.T_vle_bundle_in),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={311,-124})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple eco_down(
    N_cv=5,
    diameter_i=0.2,
    N_tubes=1,
    z_in=flameRoom_eco.z_out_TB,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_down.length,
        eco_down.N_cv),
    z_out=hopper.z_in_furnace,
    length=eco_down.z_in - eco_down.z_out,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    useHomotopy=true,
    initOption=0,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    p_nom=linspace(
        NOM.eco_down.p_in,
        NOM.eco_down.p_out,
        eco_down.N_cv),
    h_nom=ones(eco_down.N_cv)*NOM.eco_down.h_in,
    h_start=ones(eco_down.N_cv)*INIT.eco_down.h_in,
    p_start=linspace(
        INIT.eco_down.p_in,
        INIT.eco_down.p_out,
        eco_down.N_cv),
    Delta_p_nom=NOM.eco_down.Delta_p_nom,
    frictionAtInlet=false,
    contributeToCycleSummary=false)       annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={-65,-214})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 eco_down_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco_riser.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    diameter_o=eco_riser.diameter_i + 0.03,
    diameter_i=eco_riser.diameter_i,
    length=eco_riser.length,
    N_tubes=eco_riser.N_tubes,
    T_start=ones(eco_riser_wall.N_ax)*(INIT.brnr1.T_vle_wall_in),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(
        extent={{-13.9999,4.99997},{13.9999,-4.99997}},
        rotation=90,
        origin={-53,-214})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 separator(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=0.1e5),
    useHomotopy=true,
    initOption=0,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder (diameter=0.92, length=3),
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    p_nom=NOM.eco.p_vle_wall_out,
    h_nom=NOM.eco.h_vle_wall_out,
    h_start=(INIT.eco.h_vle_wall_out + INIT.ct.h_vle_wall_in)/2,
    p_start=(INIT.eco.p_vle_wall_out + INIT.ct.p_vle_wall_in)/2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,230})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 separator_wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    diameter_o=separator.geo.diameter + 0.064,
    diameter_i=separator.geo.diameter,
    length=separator.geo.length,
    T_start={(INIT.eco.T_vle_wall_out + INIT.ct.T_vle_wall_in)/2})
                                                                  annotation (Placement(transformation(
        extent={{-9.99988,-8.00005},{10.0001,8.00002}},
        rotation=0,
        origin={-130,260})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple rh_pipe(
    N_cv=5,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    diameter_i=0.2,
    z_in=0,
    z_out=flameRoom_eco.z_in_TB,
    N_tubes=1,
    length=rh_pipe.z_out - rh_pipe.z_in,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_pipe.length,
        rh_pipe.N_cv),
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=100000,
    showData=true,
    m_flow_nom=NOM.m_flow_nom - NOM.preheater_HP_m_flow_tap,
    p_nom=ones(rh_pipe.N_cv)*NOM.rh2.p_vle_bundle_out,
    h_nom=ones(rh_pipe.N_cv)*NOM.rh2.h_vle_bundle_out,
    frictionAtOutlet=false,
    h_start=linspace(
        INIT.rh2.h_vle_bundle_out,
        INIT.rh2.h_vle_bundle_out,
        rh_pipe.N_cv),
    p_start=linspace(
        INIT.rh2.p_vle_bundle_out,
        INIT.rh2.p_vle_bundle_out,
        rh_pipe.N_cv),
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={486,198})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 rh_pipe_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco_riser.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    diameter_o=eco_riser.diameter_i + 0.03,
    diameter_i=eco_riser.diameter_i,
    length=eco_riser.length,
    N_tubes=eco_riser.N_tubes,
    T_start=ones(eco_riser_wall.N_ax)*(INIT.rh2.T_vle_bundle_out),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(
        extent={{-13,-5},{13,5}},
        rotation=90,
        origin={465,198})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple sh_pipe(
    N_cv=5,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    N_tubes=1,
    diameter_i=0.2,
    z_in=flameRoom_sh_4.z_out_TB,
    z_out=0,
    length=sh_pipe.z_in - sh_pipe.z_out,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    showData=true,
    p_nom=ones(sh_pipe.N_cv)*(NOM.sh4_down.p_in + NOM.sh4_down.p_out)/2,
    h_nom=ones(sh_pipe.N_cv)*NOM.sh4_down.h_in,
    m_flow_nom=NOM.sh4_down.m_flow,
    Delta_p_nom=NOM.sh4_down.Delta_p_nom,
    h_start=linspace(
        INIT.sh4_down.h_in,
        INIT.sh4_down.h_in,
        sh_pipe.N_cv),
    p_start=linspace(
        INIT.sh4_down.p_in,
        INIT.sh4_down.p_out,
        sh_pipe.N_cv),
    frictionAtOutlet=false,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0},
        sh_pipe.length,
        sh_pipe.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={368,200})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_pipe_wall(
    redeclare replaceable model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=eco_riser.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    diameter_o=eco_riser.diameter_i + 0.03,
    diameter_i=eco_riser.diameter_i,
    length=eco_riser.length,
    N_tubes=eco_riser.N_tubes,
    T_start=ones(eco_riser_wall.N_ax)*(INIT.sh4.T_vle_bundle_out),
    stateLocation=3,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={345,200})));

  StaticCycles.Check.StaticCycleExamples.InitSteamPowerPlant_01 INIT(
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
    efficiency_Turb_LP4=NOM.efficiency_Turb_LP4) annotation (Placement(transformation(extent={{1166,402},{1186,422}})));
  StaticCycles.Check.StaticCycleExamples.InitSteamPowerPlant_01 NOM(
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
    preheater_HP_p_tap=46e5) annotation (Placement(transformation(extent={{1166,364},{1186,384}})));
  inner ClaRa.SimCenter simCenter(
    contributeToCycleSummary=true,
    showExpertSummary=true,
    redeclare ClaRa.Basics.Media.Slag.Slag_v2 slagModel,
    redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1,
    redeclare ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v3 fuelModel1(
      C_cp={989.167,1000,4190},
      xi_e_waf={{0.884524,0.047619,0.0404762,0.0154762}},
      C_LHV={3.30983e7*1.033,0,-2500e3}))                         annotation (Placement(transformation(extent={{1198,380},{1238,400}})));
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
    annotation (Placement(transformation(extent={{598,-30},{608,-10}})));
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
                            annotation (Placement(transformation(extent={{682,-30},{692,-10}})));
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
    annotation (Placement(transformation(extent={{1022,-30},{1032,-10}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_FW(eta_mech=NOM.efficiency_Pump_cond)
                                                                               annotation (Placement(transformation(extent={{686,-240},{666,-260}})));
  ClaRa.Visualisation.Quadruple quadruple(decimalSpaces(p=3))
                                          annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1076,0})));
  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{522,192},{582,212}})));
  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{402,234},{462,254}})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{716,30},{776,50}})));
  ClaRa.Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{616,30},{676,50}})));
  ClaRa.Visualisation.Quadruple quadruple5(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{1206,-170},{1266,-150}})));
  ClaRa.Components.MechanicalSeparation.FeedWaterTank_L3
                                                   feedWaterTank(
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
    z_aux=1,
    level_rel_start=0.51,
    equalPressures=true,
    absorbInflow=0.75,
    Tau_cond=1,
    Tau_evap=10)                                    annotation (Placement(transformation(extent={{700,-208},{760,-188}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_affinity
                                                         Pump_cond(            showExpertSummary=true,
    contributeToCycleSummary=false,
    J=1,
    rpm_nom=3000,
    redeclare model Energetics = ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.EfficiencyCurves_Q1 (eta_hyd_nom=NOM.Pump_cond.efficiency),
    V_flow_max=NOM.Pump_cond.m_flow/NOM.Pump_cond.rho_in*2,
    Delta_p_max=-NOM.Pump_cond.Delta_p*2,
    useMechanicalPort=true)                                                                            annotation (Placement(transformation(extent={{1176,-188},{1156,-208}})));
  ClaRa.Visualisation.Quadruple quadruple6
    annotation (Placement(transformation(extent={{708,-230},{768,-210}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_IP1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                    Delta_p_nom=NOM.valve_IP1.Delta_p, m_flow_nom=NOM.valve_IP1.m_flow), checkValve=true) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={746,-100})));
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
    annotation (Placement(transformation(extent={{902,-30},{912,-10}})));
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
        origin={926,-30})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_preheater_LP1(eta_mech=0.9, inlet(m_flow(start=NOM.pump_preheater_LP1.summary.inlet.m_flow)))
                                                                                        annotation (Placement(transformation(extent={{826,-230},{806,-250}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_IP3(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=NOM.valve_IP2.m_flow,
        Delta_p_nom=NOM.valve_IP2.Delta_p,
        rho_in_nom=2.4)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={856,-100})));
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
        origin={568,-52})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_HP(
    openingInputIsActive=false,
    showExpertSummary=true,
    checkValve=true,
    redeclare model PressureLoss = Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=NOM.valve_HP.m_flow,
        Delta_p_nom=NOM.valve_HP.Delta_p_nom,
        rho_in_nom=25)) annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=90,
        origin={568,-100})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_HP(openingInputIsActive=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (
        paraOption=2,
        m_flow_nom=NOM.valve2_HP.m_flow,
        Delta_p_nom=NOM.valve2_HP.Delta_p*0.01,
        rho_in_nom=800)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=0,
        origin={610,-290})));
  ClaRa.Visualisation.StatePoint_phTs statePoint annotation (Placement(transformation(extent={{496,-250},{514,-230}})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheater_HP(y=0.5) annotation (Placement(transformation(extent={{568,-342},{580,-330}})));
  ClaRa.Components.Utilities.Blocks.LimPID
                                     PI_valveControl_preheater_HP(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_max=1,
    y_min=0.01,
    k=2,
    Tau_i=10,
    y_start=0.2,
    initOption=796) annotation (Placement(transformation(extent={{584,-330},{604,-310}})));
  Modelica.Blocks.Continuous.FirstOrder measurement(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.1,
    T=1)
    annotation (Placement(transformation(extent={{1240,-344},{1232,-336}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valvePreFeedWaterTank(Tau=1e-3, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                          Delta_p_nom=NOM.valvePreFeedWaterTank.Delta_p_nom, m_flow_nom=NOM.valvePreFeedWaterTank.m_flow)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={816,-192})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_LP_main(
    volume=0.2,
    m_flow_in_nom={NOM.join_LP_main.m_flow_1,NOM.join_LP_main.m_flow_2},
    p_nom=NOM.join_LP_main.p,
    h_nom=NOM.join_LP_main.h3,
    h_start=INIT.join_LP_main.h3,
    p_start=INIT.join_LP_main.p,
    initOption=0,
    redeclare model PressureLossOut = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=420))
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={786,-192})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_preheaterLP1(
    sign=-1,
    Tau_d=30,
    y_max=NOM.pump_preheater_LP1.P_pump*1.5,
    y_min=NOM.pump_preheater_LP1.P_pump/100,
    y_ref=1e5,
    y_start=INIT.pump_preheater_LP1.P_pump,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=200,
    Tau_i=200,
    initOption=796) annotation (Placement(transformation(extent={{874,-310},{854,-330}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={782,-120})));
  ClaRa.Visualisation.Quadruple quadruple9
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={890,-120})));
  ClaRa.Visualisation.Quadruple quadruple10
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={816,-160})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={604,-120})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={630,-274})));
  ClaRa.Visualisation.Quadruple quadruple13
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1168,-160})));
  ClaRa.Visualisation.Quadruple quadruple14
    annotation (Placement(transformation(extent={{-26,-8},{26,8}},
        rotation=0,
        origin={816,-218})));
  Modelica.Blocks.Math.Gain Nominal_PowerFeedwaterPump1(k=NOM.m_flow_nom*0.98)
    annotation (Placement(transformation(extent={{622,-400},{630,-392}})));
  ClaRa.Visualisation.DynDisplay valveControl_preheater_HP_display(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_HP",
    x1=valveControl_preheater_HP.summary.outline.opening_) annotation (Placement(transformation(extent={{618,-320},{650,-308}})));
  ClaRa.Visualisation.DynDisplay electricalPower(
    decimalSpaces=2,
    varname="electrical Power",
    x1=simpleGenerator.summary.P_el/1e6,
    unit="MW") annotation (Placement(transformation(extent={{1188,-6},{1228,6}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1
                                                       Turbine_IP3(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP1.efficiency; 1,NOM.Turbine_IP1.efficiency])),
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
                            annotation (Placement(transformation(extent={{762,-30},{772,-10}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1
                                                       Turbine_IP2(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP1.efficiency; 1,NOM.Turbine_IP1.efficiency])),
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
                            annotation (Placement(transformation(extent={{722,-30},{732,-10}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y
                                                          split_IP2(
    volume=0.1,
    initOption=0,
    p_nom=NOM.Turbine_IP2.p_out,
    h_nom=NOM.Turbine_IP2.h_out,
    m_flow_out_nom={NOM.Turbine_IP2.summary.outlet.m_flow,NOM.feedwatertank.m_flow_tap2},
    h_start=INIT.Turbine_IP2.h_out,
    p_start=INIT.Turbine_IP2.p_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={746,-30})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y
                                                          join_IP3(
    volume=0.1,
    initOption=0,
    p_nom=NOM.Turbine_IP3.p_out,
    h_nom=NOM.Turbine_IP3.h_out,
    m_flow_out_nom={NOM.Turbine_IP3.summary.outlet.m_flow,NOM.preheater_LP1.summary.inlet_tap.m_flow},
    h_start=INIT.Turbine_IP3.h_out,
    p_start=INIT.Turbine_IP3.p_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={856,-30})));
  ClaRa.Visualisation.Quadruple quadruple15
    annotation (Placement(transformation(extent={{736,10},{796,30}})));
  ClaRa.Visualisation.Quadruple quadruple16
    annotation (Placement(transformation(extent={{776,-10},{836,10}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP3(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
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
    annotation (Placement(transformation(extent={{982,-30},{992,-10}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP2(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
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
    annotation (Placement(transformation(extent={{942,-30},{952,-10}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_LP2(
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
        origin={966,-30})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_LP3(
    volume=0.1,
    initOption=0,
    p_nom=INIT.Turbine_LP3.p_out,
    h_nom=INIT.Turbine_LP3.h_out,
    h_start=INIT.Turbine_LP3.h_out,
    p_start=INIT.Turbine_LP3.p_out,
    m_flow_out_nom={NOM.Turbine_LP2.summary.outlet.m_flow,NOM.preheater_LP4.summary.inlet_tap.m_flow})
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={1006,-30})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP2(checkValve=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                     Delta_p_nom=NOM.valve_LP1.Delta_p, m_flow_nom=NOM.valve_LP1.m_flow)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={926,-100})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_LP2(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    N_passes=1,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
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
    z_in_tubes=preheater_LP2.diameter/2,
    z_out_tubes=preheater_LP2.diameter/2,
    m_flow_nom_tubes=NOM.preheater_LP2.m_flow_cond,
    p_nom_tubes=NOM.preheater_LP2.p_cond,
    h_nom_tubes=NOM.preheater_LP2.h_cond_out,
    h_start_tubes=INIT.preheater_LP2.h_cond_out,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP2.p_cond,
    level_rel_start=0.2,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1500,10000}),
    T_w_start={320,340,360},
    N_tubes=1000,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={926,-194})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple preheater_LP3(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
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
    N_passes=2,
    N_tubes=500,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1500,10000}),
    T_w_start={300,320,340},
    z_in_aux1=0.1,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={996,-194})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple
                                                   Pump_preheater_LP3(showExpertSummary=true, eta_mech=0.9,
    outlet(p(start=NOM.pump_preheater_LP3.summary.outlet.p)))                                               annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={976,-240})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_afterPumpLP3(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                             m_flow_nom=30, Delta_p_nom=1000)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={960,-220})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP2(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        CL_valve=[0,0; 1,1],
        m_flow_nom=25,
        Delta_p_nom=0.2e5)) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=90,
        origin={926,-220})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y
                                                         join_preheater_LP3(
    volume=0.1,
    initOption=0,
    p_nom=NOM.join_preheater_LP3.summary.outlet.p,
    h_nom=NOM.join_preheater_LP3.summary.outlet.h,
    h_start=INIT.join_preheater_LP3.summary.outlet.h,
    p_start=INIT.join_preheater_LP3.summary.outlet.p,
    redeclare model PressureLossIn1 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=420),
    redeclare model PressureLossOut = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=420))
                                                      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={960,-192})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP4(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        m_flow_nom=8,
        CL_valve=[0,0; 1,1],
        Delta_p_nom=0.06e5)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=0,
        origin={1106,-240})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP3(checkValve=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                     Delta_p_nom=NOM.valve_LP2.Delta_p, m_flow_nom=NOM.valve_LP2.m_flow)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={996,-100})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP4(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                    m_flow_nom=NOM.valve_LP3.m_flow, Delta_p_nom=NOM.valve_LP3.Delta_p), checkValve=true) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={1066,-100})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                      boundaryVLE_Txim_flow(                                                             T_const=273.15 + 15, m_flow_const=25000)
                                                                                                                     annotation (Placement(transformation(extent={{1276,-150},{1256,-130}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi
                                                 boundaryVLE_phxi(p_const=2e5) annotation (Placement(transformation(extent={{1276,-110},{1256,-90}})));
  ClaRa.Components.Utilities.Blocks.LimPID
                                     PID_preheaterLP4(
    sign=-1,
    u_ref=0.1,
    y_ref=1,
    y_max=1,
    y_start=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    Tau_i=15,
    t_activation=5,
    k=0.2,
    initOption=796,
    Tau_in=0,
    Tau_out=0)      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={1074,-320})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP4(y=0.1) annotation (Placement(transformation(extent={{1028,-316},{1042,-304}})));
  ClaRa.Components.Utilities.Blocks.LimPID
                                     PID_preheaterLP3(
    u_ref=0.2,
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
    initOption=796,
    Tau_in=0,
    Tau_out=0)      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={1004,-320})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP3(y=0.1) annotation (Placement(transformation(extent={{1042,-326},{1028,-314}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_preheaterLP2(
    sign=-1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=0.1,
    y_ref=1,
    y_max=1,
    y_min=0,
    k=0.5,
    Tau_i=20,
    y_start=1,
    initOption=796,
    Tau_in=0,
    Tau_out=0)      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={934,-320})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP2(y=0.1) annotation (Placement(transformation(extent={{970,-326},{956,-314}})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP1(y=0.1) annotation (Placement(transformation(extent={{900,-326},{886,-314}})));
  Modelica.Blocks.Sources.RealExpression setPoint_condenser(y=0.5/6) annotation (Placement(transformation(extent={{1242,-326},{1228,-314}})));
  ClaRa.Visualisation.Quadruple quadruple17
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1046,40})));
  ClaRa.Visualisation.Quadruple quadruple18
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1066,20})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=2000, phi(start=0))
                                                                   annotation (Placement(transformation(extent={{1168,-30},{1188,-10}})));
  ClaRa.Components.Electrical.SimpleGenerator
                                        simpleGenerator(contributeToCycleSummary=true,
                                                        hasInertia=true) annotation (Placement(transformation(extent={{1198,-30},{1218,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryElectricFrequency
                                                          boundaryElectricFrequency annotation (Placement(transformation(extent={{1258,-30},{1238,-10}})));
  ClaRa.Visualisation.Quadruple quadruple19
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={960,-120})));
  ClaRa.Visualisation.Quadruple quadruple20
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1030,-120})));
  ClaRa.Visualisation.Quadruple quadruple21(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1102,-120})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_LP1(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{864,-204},{874,-184}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_LP2(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{934,-204},{944,-184}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_LP3(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{1004,-204},{1014,-184}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_LP4(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{1074,-204},{1084,-184}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_condenser(
    u_set=0.5/6,
    u_high=0.5/3,
    u_low=0.5/12,
    provideInputConnectors=true)
                  annotation (Placement(transformation(extent={{1204,-130},{1214,-110}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_HP(
    provideInputConnectors=true,
    u_set=0.5,
    u_high=0.6,
    u_low=0.4)  annotation (Placement(transformation(extent={{576,-262},{586,-242}})));
  ClaRa.Visualisation.DynDisplay
                           valveControl_preheater_LP4_display(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_LP4",
    x1=valveControl_preheater_LP4.summary.outline.opening_) annotation (Placement(transformation(extent={{1090,-230},{1122,-218}})));
  ClaRa.Visualisation.DynDisplay
                           valveControl_preheater_LP2_display2(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_LP2",
    x1=valveControl_preheater_LP2.summary.outline.opening_) annotation (Placement(transformation(extent={{878,-226},{910,-214}})));
  ClaRa.Visualisation.Quadruple quadruple22
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={890,-160})));
  ClaRa.Visualisation.Quadruple quadruple23
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1030,-160})));
  ClaRa.Visualisation.Quadruple quadruple24
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1102,-160})));
  Modelica.Blocks.Sources.TimeTable PTarget(table=[0,1; 2500,1; 2510,0.7; 4300,0.7; 4310,1; 6100,1; 6110,0.7; 7900,0.7; 7910,1; 10000,1])
                                                                                                                                         annotation (Placement(transformation(extent={{-476,-406},{-456,-386}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple
                                                               downComer_feedWaterTank(
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
    frictionAtInlet=true,
    frictionAtOutlet=false)
                          annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={704,-229})));
  ClaRa.Visualisation.Quadruple quadruple25
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={516,-262})));
  ClaRa.Components.Utilities.Blocks.LimPID
                                     PI_Pump_cond(
    Tau_d=500,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=1,
    sign=-1,
    y_max=50,
    y_min=5,
    y_start=50,
    y_ref=1000,
    k=0.5,
    Tau_i=40,
    initOption=796) annotation (Placement(transformation(extent={{1216,-330},{1196,-310}})));
  Modelica.Blocks.Sources.RealExpression fixedVoltage(y=10e3) annotation (Placement(transformation(extent={{1138,-266},{1152,-254}})));
  ClaRa.Components.Electrical.AsynchronousMotor_L2 motor(
    N_pp=1,
    rpm_nom=2950,
    cosphi=0.9,
    eta_stator=0.95,
    tau_bd_nom=50e3,
    activateHeatPort=false,
    initOption="fixed slip",
    J=800,
    useCharLine=true,
    charLine_tau_rpm_=[0,2; 0.7,1.8; 0.95,2.8; 1,0],
    P_nom=NOM.Pump_cond.P_pump,
    I_rotor_nom=50,
    U_term_nom=10e3,
    contributeToCycleSummary=true,
    shaft(phi(start=0)))                annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={1166,-230})));
  ClaRa.Visualisation.DynDisplay
                           electricalPowerPump_Cond(
    decimalSpaces=2,
    varname="electrical Power",
    unit="MW",
    x1=motor.summary.P_term/1e6) annotation (Placement(transformation(extent={{1180,-242},{1220,-230}})));
  ClaRa.Visualisation.DynDisplay
                           rpm_Pump(
    varname="rpm Pump",
    x1=Pump_cond.summary.outline.rpm,
    unit="1/min",
    decimalSpaces=0) annotation (Placement(transformation(extent={{1180,-230},{1220,-218}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        CL_valve=[0,0; 1,1],
        Delta_p_nom=1000,
        m_flow_nom=25000)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={1242,-100})));
  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1104,78})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple eco_riser(
    N_cv=5,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    length=eco_riser.z_out - eco_riser.z_in,
    diameter_i=0.2,
    z_in=0,
    z_out=flameRoom_eco.z_in_TB,
    N_tubes=1,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_riser.length,
        eco_riser.N_cv),
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    p_nom=linspace(
        NOM.eco_riser.p_in,
        NOM.eco_riser.p_out,
        eco_riser.N_cv),
    h_nom=ones(eco_riser.N_cv)*NOM.eco_riser.h_in,
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    p_start=linspace(
        INIT.eco_riser.p_in,
        INIT.eco_riser.p_out,
        eco_riser.N_cv),
    h_start=ones(eco_riser.N_cv)*INIT.eco_riser.h_in,
    Delta_p_nom=NOM.eco_riser.Delta_p_nom,
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={321,-124})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_flex splitVLE_L2_flex(
    p_nom=NOM.eco_riser.p_in,
    h_nom=NOM.eco_riser.h_in,
    N_ports_out=4,
    m_flow_out_nom={NOM.eco.m_flow_vle_wall_in,35,35,35},
    volume=0.5,
    h_start=INIT.preheater_HP.h_cond_out,
    p_start=INIT.preheater_HP.p_cond)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={410,-250})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                        Delta_p_nom=0.1e5, m_flow_nom=420)) annotation (Placement(transformation(extent={{446,-256},{466,-244}})));
  ClaRa.Visualisation.Quadruple quadruple26
    annotation (Placement(transformation(extent={{-266,-4},{-206,16}})));
  ClaRa.Visualisation.Quadruple quadruple27
    annotation (Placement(transformation(extent={{-266,24},{-206,44}})));
  ClaRa.Visualisation.Quadruple quadruple28
    annotation (Placement(transformation(extent={{-260,114},{-200,134}})));
  ClaRa.Visualisation.Quadruple quadruple29
    annotation (Placement(transformation(extent={{-38,-12},{22,8}})));
  ClaRa.Visualisation.Quadruple quadruple30
    annotation (Placement(transformation(extent={{-216,206},{-156,226}})));
  ClaRa.Components.HeatExchangers.RegenerativeAirPreheater_L4 regenerativeAirPreheater(
    s_sp=0.6e-3,
    redeclare model Material = TILMedia.SolidTypes.TILMedia_St35_8,
    A_flueGas=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    A_air=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    diameter_reg=10,
    height_reg=3,
    N_sp=1000,
    Delta_p_flueGas_nom=1000,
    Delta_p_freshAir_nom=1000,
    T_start_wall=linspace(
        385,
        675,
        regenerativeAirPreheater.N_cv),
    T_start_flueGas=linspace(
        677,
        398,
        regenerativeAirPreheater.N_cv),
    T_start_freshAir=linspace(
        376,
        673,
        regenerativeAirPreheater.N_cv),
    frictionAtFlueGasOutlet=false,
    frictionAtFreshAirInlet=false,
    frictionAtFreshAirOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    N_cv=5,
    m_flow_freshAir_nom=475,
    m_flow_flueGas_nom=475 + 42,
    xi_nom_flueGas=NOM.eco.xi_fg_out,
    xi_start_freshAir={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    xi_nom_freshAir={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    xi_start_flueGas=INIT.eco.xi_fg_out,
    p_freshAir_nom=12000,
    p_flueGas_nom=10500,
    p_start_freshAir(each displayUnit="bar") = linspace(
      1.35e5,
      1.34e5,
      regenerativeAirPreheater.N_cv),
    stateLocation=1,
    p_start_flueGas(each displayUnit="bar") = linspace(
      1e5,
      0.99e5,
      regenerativeAirPreheater.N_cv),
    frictionAtFlueGasInlet=true)      annotation (Placement(transformation(extent={{-396,-58},{-376,-38}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitGas_L2_flex splitGas_L2_flex(
    N_ports_out=4,
    volume=2,
    xi_nom={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    m_flow_out_nom={475.6/4,475.6/4,475.6/4,475.6/4},
    T_start=673,
    xi_start={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    T_nom=1119.15,
    p_start(displayUnit="bar") = 133900) annotation (Placement(transformation(extent={{112,-118},{92,-98}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner1(
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    variable_T=false,
    T_const=273.15 + 30,
    m_flow_const=475.6 + 24,
    variable_m_flow=true)
                   annotation (Placement(transformation(extent={{-444,-52},{-424,-32}})));
  Modelica.Blocks.Sources.RealExpression actual_lambda(y=burner1.burner.lambdaComb_primary)
                                                                                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-560,-6})));
  Modelica.Blocks.Sources.Ramp lambda(
    duration=1000,
    startTime=4000,
    height=0,
    offset=1.2)
    annotation (Placement(transformation(extent={{-570,-46},{-550,-26}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_lambda(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ni=0.90,
    y_min=100,
    sign=1,
    k=1,
    t_activation=0,
    Tau_i=1,
    y_ref=475.6 + 24,
    y_max=700,
    y_inactive=475.6 + 24,
    y_start=475.6 + 24,
    u_ref=1.2,
    initOption=501) annotation (Placement(transformation(extent={{-518,-26},{-498,-46}})));
  Modelica.Blocks.Math.Gain gain(k=43/4) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={182,-226})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=475.6 + 24) annotation (Placement(transformation(extent={{-482,-46},{-462,-26}})));
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
    diameter_i=0.02,
    diameter_o=0.028,
    N_tubes=2000,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1650,10000}),
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={568,-252})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple preheater_LP4(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    T_w_start={300,320,340},
    Tau_cond=0.3,
    Tau_evap=0.03,
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
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={1066,-194})));
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
        origin={856,-194})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_BU_simple condenser(
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
    length=12,
    N_tubes=15000,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={3000,12000}),
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2) annotation (Placement(transformation(extent={{1186,-130},{1206,-110}})));
  Visualisation.Quadruple       quadruple31
    annotation (Placement(transformation(extent={{-8,172},{52,192}})));
  Visualisation.Quadruple       quadruple32
    annotation (Placement(transformation(extent={{-260,144},{-200,164}})));
  Visualisation.Quadruple       quadruple33
    annotation (Placement(transformation(extent={{-6,48},{54,68}})));
  Visualisation.Quadruple       quadruple34
    annotation (Placement(transformation(extent={{48,116},{108,136}})));
  Visualisation.QuadrupleGas quadrupleGas(value4=11) annotation (Placement(transformation(extent={{-190,-148},{-170,-138}})));
  Visualisation.QuadrupleGas quadrupleGas1(value4=11) annotation (Placement(transformation(extent={{-190,-123},{-170,-113}})));
  Visualisation.QuadrupleGas quadrupleGas2(value4=11) annotation (Placement(transformation(extent={{-190,-99},{-170,-89}})));
  Visualisation.QuadrupleGas quadrupleGas3(value4=11) annotation (Placement(transformation(extent={{-190,-71},{-170,-61}})));
  Visualisation.QuadrupleGas quadrupleGas4(value4=11) annotation (Placement(transformation(extent={{-190,-41},{-170,-31}})));
  Visualisation.QuadrupleGas quadrupleGas5(value4=11) annotation (Placement(transformation(extent={{-190,-11},{-170,-1}})));
  Visualisation.QuadrupleGas quadrupleGas6(value4=11) annotation (Placement(transformation(extent={{-190,19},{-170,29}})));
  Visualisation.QuadrupleGas quadrupleGas7(value4=11) annotation (Placement(transformation(extent={{-190,51},{-170,61}})));
  Visualisation.QuadrupleGas quadrupleGas8(value4=11) annotation (Placement(transformation(extent={{-190,79},{-170,89}})));
  Visualisation.QuadrupleGas quadrupleGas9(value4=11) annotation (Placement(transformation(extent={{-190,109},{-170,119}})));
  Visualisation.QuadrupleGas quadrupleGas10(value4=11) annotation (Placement(transformation(extent={{-190,137},{-170,147}})));
  Visualisation.QuadrupleGas quadrupleGas11(value4=11) annotation (Placement(transformation(extent={{-190,167},{-170,177}})));
  Visualisation.QuadrupleGas quadrupleGas12(value4=11) annotation (Placement(transformation(extent={{-88,220},{-46,244}})));
  Visualisation.QuadrupleGas quadrupleGas13(value4=11) annotation (Placement(transformation(extent={{-408,-108},{-360,-82}})));
  Visualisation.QuadrupleGas quadrupleGas14(value4=11) annotation (Placement(transformation(extent={{-370,-36},{-332,-16}})));
  Visualisation.XYplot xYplot(
    title="Boiler temperatures",
    x_label="z",
    y_label="°C",
    y_min=100,
    y_max=1800,
    N_nodes1=15,
    color1={167,25,48},
    x_min=0,
    x_max=86,
    decimalSpaces(x=0, y=0),
    activateSecondSet=true,
    N_nodes2=19,
    color2={0,131,169})      annotation (Placement(transformation(
        extent={{-87,-31},{87,31}},
        rotation=90,
        origin={-411,185})));
  Modelica.Blocks.Sources.RealExpression boilergasTemperatures[15](y={hopper.hopper.summary.outline.T_out,hopper.hopper.summary.outline.T_out,burner1.burner.summary.outline.T_out,burner2.burner.summary.outline.T_out,burner4.burner.summary.outline.T_out,burner4.burner.summary.outline.T_out,flameRoom_evap_1.flameRoom.summary.outline.T_out,flameRoom_evap_2.flameRoom.summary.outline.T_out,flameRoom_sh_1.flameRoom.summary.outline.T_out,flameRoom_sh_2.flameRoom.summary.outline.T_out,flameRoom_sh_4.flameRoom.summary.outline.T_out,flameRoom_rh_2.flameRoom.summary.outline.T_out,flameRoom_sh_3.flameRoom.summary.outline.T_out,flameRoom_rh_1.flameRoom.summary.outline.T_out,flameRoom_eco.flameRoom.summary.outline.T_out} - fill(273.15, 15))
                                                                                                                                                                                                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-422,70})));
  Modelica.Blocks.Sources.RealExpression boilerZpositions[15](y={hopper.hopper.geo.z_in[1],hopper.hopper.geo.z_out[1],burner1.burner.geo.z_out[1],burner2.burner.geo.z_out[1],burner4.burner.geo.z_out[1],burner4.burner.geo.z_out[1],flameRoom_evap_1.flameRoom.geo.z_out[1],flameRoom_evap_2.flameRoom.geo.z_out[1],flameRoom_sh_1.flameRoom.geo.z_out[1],flameRoom_sh_2.flameRoom.geo.z_out[1],flameRoom_sh_4.flameRoom.geo.z_out[1],flameRoom_rh_2.flameRoom.geo.z_out[1],flameRoom_sh_3.flameRoom.geo.z_out[1],flameRoom_rh_1.flameRoom.geo.z_out[1],flameRoom_eco.flameRoom.geo.z_out[1]})
                                                                                                                                                                                                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-364,150})));
  Visualisation.Quadruple       quadruple35
    annotation (Placement(transformation(extent={{-266,-24},{-206,-4}})));
  Visualisation.Quadruple       quadruple36
    annotation (Placement(transformation(extent={{-260,94},{-200,114}})));
  Visualisation.Quadruple       quadruple37
    annotation (Placement(transformation(extent={{-266,-44},{-206,-24}})));
  Visualisation.Quadruple       quadruple38
    annotation (Placement(transformation(extent={{-236,-182},{-176,-162}})));
  Visualisation.Quadruple       quadruple39
    annotation (Placement(transformation(extent={{-260,174},{-200,194}})));
  Modelica.Blocks.Sources.RealExpression boilervleTemperatures[19](y={hopper.pipeFlow_FTW.summary.inlet.T,flameRoom_evap_1.pipeFlow_FTW.summary.outlet.T,flameRoom_evap_2.pipeFlow_FTW.summary.outlet.T,flameRoom_rh_2.pipeFlow_FTW.summary.outlet.T,flameRoom_eco.pipeFlow_FTW.summary.outlet.T,flameRoom_sh_1.pipeFlow_CT.summary.outlet.T,flameRoom_sh_1.pipeFlow_TB.summary.outlet.T,flameRoom_sh_2.pipeFlow_TB.summary.outlet.T,flameRoom_sh_2.pipeFlow_TB.summary.inlet.T,flameRoom_sh_4.pipeFlow_TB.summary.outlet.T,flameRoom_sh_2.pipeFlow_TB.summary.inlet.T,flameRoom_rh_2.pipeFlow_TB.summary.outlet.T,flameRoom_rh_2.pipeFlow_TB.summary.inlet.T,flameRoom_sh_3.pipeFlow_TB.summary.outlet.T,flameRoom_sh_3.pipeFlow_TB.summary.inlet.T,flameRoom_rh_1.pipeFlow_TB.summary.outlet.T,flameRoom_rh_1.pipeFlow_TB.summary.inlet.T,flameRoom_eco.pipeFlow_TB.summary.inlet.T,flameRoom_eco.pipeFlow_TB.summary.outlet.T} - fill(273.15, 19))
                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-401,70})));

 Modelica.Blocks.Sources.RealExpression boilerZpositions2[19](y={hopper.hopper.geo.z_in[1],flameRoom_evap_1.flameRoom.geo.z_out[1],flameRoom_evap_2.flameRoom.geo.z_out[1],flameRoom_rh_2.flameRoom.geo.z_out[1],flameRoom_eco.flameRoom.geo.z_out[1],flameRoom_sh_1.flameRoom.geo.z_in[1],flameRoom_sh_1.flameRoom.geo.z_out[1],flameRoom_sh_2.flameRoom.geo.z_in[1],flameRoom_sh_2.flameRoom.geo.z_out[1],flameRoom_sh_4.flameRoom.geo.z_in[1],flameRoom_sh_4.flameRoom.geo.z_out[1],flameRoom_rh_2.flameRoom.geo.z_in[1],flameRoom_rh_2.flameRoom.geo.z_out[1],flameRoom_sh_3.flameRoom.geo.z_in[1],flameRoom_sh_3.flameRoom.geo.z_out[1],flameRoom_rh_1.flameRoom.geo.z_in[1],flameRoom_rh_1.flameRoom.geo.z_out[1],flameRoom_eco.flameRoom.geo.z_out[1],flameRoom_eco.flameRoom.geo.z_in[1]})
                            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-364,190})));

  Components.Control.FeedForward.FeedForwardBlock_3508 feedForwardBlock_3508_1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-432,-392})));
  Modelica.Blocks.Sources.RealExpression P_max_(y=1) annotation (Placement(transformation(extent={{-478,-374},{-458,-354}})));
  Components.Mills.HardCoalMills.RollerBowlMill_L1 rollerBowlMill_L1_1(m_flow_dust_0=1) annotation (Placement(transformation(extent={{-390,-407},{-370,-387}})));
  Modelica.Blocks.Sources.RealExpression P_min_(y=0.5) annotation (Placement(transformation(extent={{-478,-356},{-458,-336}})));
  Modelica.Blocks.Sources.RealExpression P_min_1(y=0.02/60) annotation (Placement(transformation(extent={{-478,-338},{-458,-318}})));
  Components.Utilities.Blocks.LimPID       PI_feedwaterPump(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0.01,
    y_ref=NOM.Pump_FW.P_pump,
    y_max=NOM.Pump_FW.P_pump*2,
    k=1,
    Tau_i=2,
    u_ref=NOM.m_flow_nom,
    initOption=503,
    y_start=INIT.Pump_FW.P_pump)
                          annotation (Placement(transformation(extent={{648,-386},{668,-406}})));
  Components.Sensors.SensorVLE_L1_m_flow sensorFWflow annotation (Placement(transformation(extent={{652,-250},{632,-230}})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_sh2(m_flow_const=28) "Contrlled spray injection mass flow between sh1 and sh2" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={232,-129})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh2(
    volume=0.5,
    p_nom=NOM.sh1.p_vle_bundle_out,
    h_nom=NOM.sh1.h_vle_bundle_out,
    h_start=INIT.sh1.h_vle_bundle_out,
    p_start=INIT.sh1.p_vle_bundle_out,
    m_flow_in_nom={380,28}) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-22,28})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh4(
    volume=0.5,
    m_flow_in_nom={305,15},
    p_nom=NOM.sh3.p_vle_bundle_out,
    h_nom=NOM.sh3.h_vle_bundle_out,
    h_start=INIT.sh3.h_vle_bundle_out,
    p_start=INIT.sh3.p_vle_bundle_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={24,94})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_sh4(m_flow_const=15) "Contrlled spray injection mass flow between sh3 and sh4" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={254,-129})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_rh2(m_flow_const=1) "Contrlled spray injection mass flow between rh1 and rh2" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={278,-129})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh1(
    volume=0.5,
    m_flow_in_nom={200,1.5},
    p_nom=NOM.rh1.p_vle_bundle_out,
    h_nom=NOM.rh1.h_vle_bundle_out,
    h_start=INIT.rh1.h_vle_bundle_out,
    p_start=INIT.rh1.p_vle_bundle_out) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-24,140})));
  SubSystems.Furnace.HopperSlice_L4 hopper(
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (CF_fouling=CF_fouling_rad_glob, suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=4.03,
    z_out_furnace=11.318,
    p_start_flueGas_out(displayUnit="bar") = 100990,
    T_start_flueGas_out=INIT.brnr4.T_fg_out - 500,
    T_top_initial=INIT.brnr1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    T_slag=600 + 273.15,
    frictionAtInlet_FTW=true,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    psi_FTW=0,
    length_FTW=abs(hopper.z_out_furnace - hopper.z_in_furnace),
    diameter_o_FTW=0.038,
    diameter_i_FTW=0.0268,
    N_tubes_FTW=970,
    N_cv_FTW=4,
    Delta_x_FTW=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        hopper.length_FTW,
        hopper.N_cv_FTW),
    h_start_FTW=linspace(
        INIT.eco_down.h_in,
        (INIT.eco_down.h_in + INIT.brnr1.h_vle_wall_out)/2,
        hopper.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.eco_down.p_out,
        INIT.eco_down.p_out - INIT.brnr1.Delta_p_vle/2,
        hopper.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.eco_down.p_out,
        NOM.eco_down.p_out + NOM.brnr1.Delta_p_vle_wall_nom/2,
        hopper.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.eco_down.h_in,
        (NOM.eco_down.h_in + NOM.brnr1.h_vle_wall_out)/2,
        hopper.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.brnr1.Delta_p_vle_wall_nom/2) annotation (Placement(transformation(extent={{-88,-194},{-148,-174}})));
  SubSystems.Furnace.BurnerSlice_L4 burner1(
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        CF_fouling=CF_fouling_rad_glob,
        emissivity_wall=emissivity_wall,
        suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=hopper.z_out_furnace,
    z_out_furnace=18.5,
    p_start_flueGas_out(displayUnit="bar") = 101000,
    T_start_flueGas_out=INIT.brnr1.T_fg_out,
    T_top_initial=INIT.brnr2.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=136,
    slagTemperature_calculationType=2,
    T_slag=600 + 273.15,
    frictionAtInlet_FTW=true,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    psi_FTW=0,
    length_FTW=burner1.z_out_furnace - burner1.z_in_furnace,
    diameter_o_FTW=0.038,
    diameter_i_FTW=0.0268,
    N_tubes_FTW=330,
    h_start_FTW=linspace(
        INIT.brnr1.h_vle_wall_in,
        INIT.brnr1.h_vle_wall_out,
        burner1.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.brnr1.p_vle_wall_in,
        INIT.brnr1.p_vle_wall_out,
        burner1.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.brnr1.p_vle_wall_in,
        NOM.brnr1.p_vle_wall_out,
        burner1.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.brnr1.h_vle_wall_in,
        NOM.brnr1.h_vle_wall_out,
        burner1.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.brnr1.Delta_p_vle_wall_nom) annotation (Placement(transformation(extent={{-88,-164},{-148,-144}})));
  Components.Mills.HardCoalMills.VerticalMill_L3       mill4(T_out_start=846,
    initOption=0,
    applyGrindingDelay=true)                                               annotation (Placement(transformation(extent={{-14,-86},{-34,-66}})));
  Components.Mills.HardCoalMills.VerticalMill_L3       mill3(T_out_start=846,
    initOption=0,
    applyGrindingDelay=true)                                               annotation (Placement(transformation(extent={{-14,-112},{-34,-92}})));
  Components.Mills.HardCoalMills.VerticalMill_L3       mill2(T_out_start=846,
    initOption=0,
    applyGrindingDelay=true)                                               annotation (Placement(transformation(extent={{-14,-138},{-34,-118}})));
  SubSystems.Furnace.BurnerSlice_L4 burner2(
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        CF_fouling=CF_fouling_rad_glob,
        emissivity_wall=emissivity_wall,
        suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=burner1.z_out_furnace,
    z_out_furnace=24,
    p_start_flueGas_out(displayUnit="bar") = 100950,
    T_start_flueGas_out=INIT.brnr2.T_fg_out,
    T_top_initial=INIT.brnr3.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=274,
    slagTemperature_calculationType=2,
    T_slag=600 + 273.15,
    frictionAtInlet_FTW=true,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    psi_FTW=0,
    length_FTW=burner2.z_out_furnace - burner2.z_in_furnace,
    diameter_o_FTW=0.038,
    diameter_i_FTW=0.0268,
    N_tubes_FTW=330,
    h_start_FTW=linspace(
        INIT.brnr2.h_vle_wall_in,
        INIT.brnr2.h_vle_wall_out,
        burner2.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.brnr2.p_vle_wall_in,
        INIT.brnr2.p_vle_wall_out,
        burner2.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.brnr2.p_vle_wall_in,
        NOM.brnr2.p_vle_wall_out,
        burner2.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.brnr2.h_vle_wall_in,
        NOM.brnr2.h_vle_wall_out,
        burner2.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.brnr2.Delta_p_vle_wall_nom) annotation (Placement(transformation(extent={{-88,-138},{-148,-118}})));
  SubSystems.Furnace.BurnerSlice_L4 burner3(
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        CF_fouling=CF_fouling_rad_glob,
        emissivity_wall=emissivity_wall,
        suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=burner2.z_out_furnace,
    z_out_furnace=29.5,
    p_start_flueGas_out(displayUnit="bar") = 100900,
    T_start_flueGas_out=INIT.brnr3.T_fg_out,
    T_top_initial=INIT.brnr4.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=412,
    slagTemperature_calculationType=2,
    T_slag=600 + 273.15,
    frictionAtInlet_FTW=true,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    psi_FTW=0,
    length_FTW=burner3.z_out_furnace - burner3.z_in_furnace,
    diameter_o_FTW=0.038,
    diameter_i_FTW=0.0268,
    N_tubes_FTW=330,
    h_start_FTW=linspace(
        INIT.brnr3.h_vle_wall_in,
        INIT.brnr3.h_vle_wall_out,
        burner3.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.brnr3.p_vle_wall_in,
        INIT.brnr3.p_vle_wall_out,
        burner3.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.brnr3.p_vle_wall_in,
        NOM.brnr3.p_vle_wall_out,
        burner3.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.brnr3.h_vle_wall_in,
        NOM.brnr3.h_vle_wall_out,
        burner3.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.brnr3.Delta_p_vle_wall_nom) annotation (Placement(transformation(extent={{-88,-112},{-148,-92}})));
  SubSystems.Furnace.BurnerSlice_L4 burner4(
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        CF_fouling=CF_fouling_rad_glob,
        emissivity_wall=emissivity_wall,
        suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=burner3.z_out_furnace,
    z_out_furnace=35,
    p_start_flueGas_out(displayUnit="bar") = 100850,
    T_start_flueGas_out=INIT.brnr4.T_fg_out,
    T_top_initial=INIT.evap_rad.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    slagTemperature_calculationType=2,
    T_slag=600 + 273.15,
    frictionAtInlet_FTW=true,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    psi_FTW=0,
    length_FTW=burner4.z_out_furnace - burner4.z_in_furnace,
    diameter_o_FTW=0.038,
    diameter_i_FTW=0.0268,
    N_tubes_FTW=330,
    h_start_FTW=linspace(
        INIT.brnr4.h_vle_wall_in,
        INIT.brnr4.h_vle_wall_out,
        burner4.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.brnr4.p_vle_wall_in,
        INIT.brnr4.p_vle_wall_out,
        burner4.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.brnr4.p_vle_wall_in,
        NOM.brnr4.p_vle_wall_out,
        burner4.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.brnr4.h_vle_wall_in,
        NOM.brnr4.h_vle_wall_out,
        burner4.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.brnr4.Delta_p_vle_wall_nom) annotation (Placement(transformation(extent={{-88,-86},{-148,-66}})));
  SubSystems.Furnace.FreeboardSlice_L4 flameRoom_evap_1(
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        CF_fouling=CF_fouling_rad_glob,
        emissivity_wall=emissivity_wall,
        suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    additionalFuelGasConnector=false,
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.2),
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=burner4.z_out_furnace,
    z_out_furnace=41.334,
    p_start_flueGas_out(displayUnit="bar") = 100800,
    T_start_flueGas_out=INIT.evap_rad.T_fg_out,
    T_top_initial=INIT.evap_rad.T_fg_out - 50,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    psi_FTW=0,
    length_FTW=flameRoom_evap_1.z_out_furnace - flameRoom_evap_1.z_in_furnace,
    diameter_o_FTW=0.038,
    diameter_i_FTW=0.0268,
    N_tubes_FTW=330,
    h_start_FTW=linspace(
        INIT.evap_rad.h_vle_wall_in,
        INIT.evap_rad.h_vle_wall_out,
        flameRoom_evap_1.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.evap_rad.p_vle_wall_in,
        INIT.evap_rad.p_vle_wall_out,
        flameRoom_evap_1.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.evap_rad.h_vle_wall_in,
        NOM.evap_rad.h_vle_wall_out,
        flameRoom_evap_1.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.evap_rad.p_vle_wall_in,
        NOM.evap_rad.p_vle_wall_out,
        flameRoom_evap_1.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.evap_rad.Delta_p_vle_wall_nom) annotation (Placement(transformation(extent={{-88,-56},{-148,-36}})));
  SubSystems.Furnace.FreeboardSlice_L4 flameRoom_evap_2(
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        CF_fouling=CF_fouling_rad_glob,
        emissivity_wall=emissivity_wall,
        suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    additionalFuelGasConnector=false,
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.2),
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=flameRoom_evap_1.z_out_furnace,
    z_out_furnace=56.342,
    p_start_flueGas_out(displayUnit="bar") = 100750,
    T_start_flueGas_out=INIT.evap_rad.T_fg_out - 50,
    T_top_initial=INIT.sh1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    psi_FTW=0,
    length_FTW=46,
    diameter_o_FTW=0.0424,
    diameter_i_FTW=0.0298,
    N_tubes_FTW=330,
    N_cv_FTW=4,
    Delta_x_FTW=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        flameRoom_evap_2.length_FTW,
        flameRoom_evap_2.N_cv_FTW),
    h_start_FTW=linspace(
        (INIT.brnr4.h_vle_wall_out + INIT.evap_rad.h_vle_wall_out)/2,
        INIT.evap_rad.h_vle_wall_out,
        flameRoom_evap_2.N_cv_FTW),
    p_start_FTW=linspace(
        (INIT.brnr4.p_vle_wall_out + INIT.evap_rad.p_vle_wall_out)/2,
        INIT.evap_rad.p_vle_wall_out,
        flameRoom_evap_2.N_cv_FTW),
    h_nom_FTW=linspace(
        (NOM.brnr4.h_vle_wall_out + NOM.evap_rad.h_vle_wall_out)/2,
        NOM.evap_rad.h_vle_wall_out,
        flameRoom_evap_2.N_cv_FTW),
    p_nom_FTW=linspace(
        (NOM.brnr4.p_vle_wall_out + NOM.evap_rad.p_vle_wall_out)/2,
        NOM.evap_rad.p_vle_wall_out,
        flameRoom_evap_2.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.evap_rad.Delta_p_vle_wall_nom/2)
                                                       annotation (Placement(transformation(extent={{-88,-26},{-148,-6}})));
  SubSystems.Furnace.ConvectiveSlice_L4 flameRoom_eco(
    redeclare model GasHeatTransfer_TubeBundle = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_tubeBank_L2,
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        alpha_nom=alpha_wall,
        CF_fouling=CF_fouling_glob,
        temperatureDifference="Inlet"),
    redeclare model GasHeatTransfer_CarrierTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Inlet"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=flameRoom_rh_1.z_out_furnace,
    z_out_furnace=85.6,
    p_start_flueGas_out(displayUnit="bar") = 100100,
    T_start_flueGas_out=INIT.eco.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    frictionAtOutlet_FTW=true,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    psi_FTW=0,
    length_FTW=flameRoom_eco.z_out_furnace - flameRoom_eco.z_in_furnace,
    diameter_o_FTW=0.0424,
    diameter_i_FTW=0.0298,
    N_tubes_FTW=500,
    h_start_FTW=linspace(
        INIT.eco.h_vle_wall_in,
        INIT.eco.h_vle_wall_out,
        flameRoom_eco.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.eco.p_vle_wall_in,
        INIT.eco.p_vle_wall_out,
        flameRoom_eco.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.eco.h_vle_wall_in,
        NOM.eco.h_vle_wall_out,
        flameRoom_eco.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.eco.p_vle_wall_in,
        NOM.eco.p_vle_wall_out,
        flameRoom_eco.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.eco.Delta_p_vle_wall,
    frictionAtInlet_TB=true,
    frictionAtOutlet_TB=true,
    redeclare model PressureLoss_TB = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_TB = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    length_TB=15,
    diameter_o_TB=0.0424,
    diameter_i_TB=0.0334,
    N_tubes_TB=250,
    N_passes_TB=6,
    Delta_z_par=2*flameRoom_eco.diameter_o_TB,
    Delta_z_ort=2*flameRoom_eco.diameter_o_TB,
    N_rows_TB=30,
    N_cv_TB=5,
    Delta_x_TB=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        flameRoom_eco.length_TB*flameRoom_eco.N_passes_TB,
        flameRoom_eco.N_cv_TB),
    h_start_TB=linspace(
        INIT.eco.h_vle_bundle_in,
        INIT.eco.h_vle_bundle_out,
        flameRoom_eco.N_cv_TB),
    p_start_TB=linspace(
        INIT.eco.p_vle_bundle_in,
        INIT.eco.p_vle_bundle_out,
        flameRoom_eco.N_cv_TB),
    h_nom_TB=linspace(
        NOM.eco.h_vle_bundle_in,
        NOM.eco.h_vle_bundle_out,
        flameRoom_eco.N_cv_TB),
    p_nom_TB=linspace(
        NOM.eco.p_vle_bundle_in,
        NOM.eco.p_vle_bundle_out,
        flameRoom_eco.N_cv_TB),
    m_flow_nom_TB=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_TB=NOM.eco.Delta_p_vle_bundle_nom,
    frictionAtInlet_CT=true,
    frictionAtOutlet_CT=false,
    redeclare model PressureLoss_CT = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_CT = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    diameter_o_CT=0.0445,
    diameter_i_CT=0.027,
    N_tubes_CT=310,
    h_start_CT=INIT.ct.h_vle_wall_out,
    p_start_CT=INIT.ct.p_vle_wall_out,
    m_flow_nom_CT=NOM.ct.m_flow_vle_wall_in,
    h_nom=NOM.ct.h_vle_wall_out,
    p_nom_CT=NOM.ct.p_vle_wall_out,
    Delta_p_nom_CT=NOM.ct.Delta_p_vle_wall/7) annotation (Placement(transformation(extent={{-88,182},{-148,202}})));
  SubSystems.Furnace.ConvectiveSlice_L4 flameRoom_rh_1(
    redeclare model GasHeatTransfer_TubeBundle = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_tubeBank_L2,
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        alpha_nom=alpha_wall,
        CF_fouling=CF_fouling_glob,
        temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_CarrierTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=flameRoom_sh_3.z_out_furnace,
    z_out_furnace=82.9,
    p_start_flueGas_out(displayUnit="bar") = 100200,
    T_start_flueGas_out=INIT.rh1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    frictionAtOutlet_FTW=false,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    psi_FTW=0,
    length_FTW=flameRoom_rh_1.z_out_furnace - flameRoom_rh_1.z_in_furnace,
    diameter_o_FTW=0.0424,
    diameter_i_FTW=0.0298,
    N_tubes_FTW=500,
    h_start_FTW=linspace(
        INIT.rh1.h_vle_wall_in,
        INIT.rh1.h_vle_wall_out,
        flameRoom_rh_1.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.rh1.p_vle_wall_in,
        INIT.rh1.p_vle_wall_out,
        flameRoom_rh_1.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.rh1.h_vle_wall_in,
        NOM.rh1.h_vle_wall_out,
        flameRoom_rh_1.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.rh1.p_vle_wall_in,
        NOM.rh1.p_vle_wall_out,
        flameRoom_rh_1.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.rh1.Delta_p_vle_wall,
    frictionAtInlet_TB=true,
    frictionAtOutlet_TB=true,
    redeclare model PressureLoss_TB = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_TB = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    length_TB=15.3,
    diameter_o_TB=0.051,
    diameter_i_TB=0.0413,
    N_tubes_TB=420,
    N_passes_TB=6,
    Delta_z_par=2*flameRoom_rh_1.diameter_o_TB,
    Delta_z_ort=2*flameRoom_rh_1.diameter_o_TB,
    N_rows_TB=50,
    N_cv_TB=5,
    Delta_x_TB=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        flameRoom_rh_1.length_TB*flameRoom_rh_1.N_passes_TB,
        flameRoom_rh_1.N_cv_TB),
    h_start_TB=linspace(
        INIT.rh1.h_vle_bundle_in,
        INIT.rh1.h_vle_bundle_out,
        flameRoom_rh_1.N_cv_TB),
    p_start_TB=linspace(
        INIT.rh1.p_vle_bundle_in,
        INIT.rh1.p_vle_bundle_out,
        flameRoom_rh_1.N_cv_TB),
    h_nom_TB=linspace(
        NOM.rh1.h_vle_bundle_in,
        NOM.rh1.h_vle_bundle_out,
        flameRoom_rh_1.N_cv_TB),
    p_nom_TB=linspace(
        NOM.rh1.p_vle_bundle_in,
        NOM.rh1.p_vle_bundle_out,
        flameRoom_rh_1.N_cv_TB),
    m_flow_nom_TB=NOM.m_flow_nom - NOM.preheater_HP_m_flow_tap,
    Delta_p_nom_TB=NOM.rh1.Delta_p_vle_wall_nom,
    frictionAtInlet_CT=true,
    frictionAtOutlet_CT=false,
    redeclare model PressureLoss_CT = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_CT = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    diameter_o_CT=0.0445,
    diameter_i_CT=0.027,
    N_tubes_CT=310,
    h_start_CT=(INIT.ct.h_vle_wall_out - INIT.ct.h_vle_wall_in)/7*6 + INIT.ct.h_vle_wall_in,
    p_start_CT=(INIT.ct.p_vle_wall_out - INIT.ct.p_vle_wall_in)/7*6 + INIT.ct.p_vle_wall_in,
    m_flow_nom_CT=NOM.ct.m_flow_vle_wall_in,
    h_nom=(NOM.ct.h_vle_wall_out - NOM.ct.h_vle_wall_in)/7*6 + NOM.ct.h_vle_wall_in,
    p_nom_CT=(NOM.ct.p_vle_wall_out - NOM.ct.p_vle_wall_in)/7*6 + NOM.ct.p_vle_wall_in,
    Delta_p_nom_CT=NOM.ct.Delta_p_vle_wall/7) annotation (Placement(transformation(extent={{-88,152},{-148,172}})));
  SubSystems.Furnace.ConvectiveSlice_L4 flameRoom_sh_3(
    redeclare model GasHeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                         CF_fouling=0.65, suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        alpha_nom=alpha_wall,
        CF_fouling=CF_fouling_glob,
        temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_CarrierTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=flameRoom_rh_2.z_out_furnace,
    z_out_furnace=75.18,
    p_start_flueGas_out(displayUnit="bar") = 100300,
    T_start_flueGas_out=INIT.sh3.T_fg_out - 200,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    frictionAtOutlet_FTW=false,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    psi_FTW=0,
    length_FTW=flameRoom_sh_3.z_out_furnace - flameRoom_sh_3.z_in_furnace,
    diameter_o_FTW=0.0424,
    diameter_i_FTW=0.0298,
    N_tubes_FTW=500,
    h_start_FTW=linspace(
        INIT.sh3.h_vle_wall_in,
        INIT.sh3.h_vle_wall_out,
        flameRoom_sh_3.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.sh3.p_vle_wall_in,
        INIT.sh3.p_vle_wall_out,
        flameRoom_sh_3.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.sh3.h_vle_wall_in,
        NOM.sh3.h_vle_wall_out,
        flameRoom_sh_3.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.sh3.p_vle_wall_in,
        NOM.sh3.p_vle_wall_out,
        flameRoom_sh_3.N_cv_FTW),
    m_flow_nom_FTW=NOM.sh3.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.sh3.Delta_p_vle_wall,
    frictionAtInlet_TB=true,
    frictionAtOutlet_TB=true,
    redeclare model PressureLoss_TB = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_TB = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    length_TB=15,
    diameter_o_TB=0.0300,
    diameter_i_TB=0.0268,
    N_tubes_TB=500,
    N_passes_TB=2,
    Delta_z_par=2*flameRoom_sh_3.diameter_o_TB,
    Delta_z_ort=2*flameRoom_sh_3.diameter_o_TB,
    N_rows_TB=integer(ceil(sqrt(flameRoom_sh_3.N_tubes_TB))*flameRoom_sh_3.N_passes_TB),
    N_cv_TB=5,
    Delta_x_TB=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        flameRoom_sh_3.length_TB*flameRoom_sh_3.N_passes_TB,
        flameRoom_sh_3.N_cv_TB),
    h_start_TB=linspace(
        INIT.sh3.h_vle_bundle_in,
        INIT.sh3.h_vle_bundle_out,
        flameRoom_sh_3.N_cv_TB),
    p_start_TB=linspace(
        INIT.sh3.p_vle_bundle_in,
        INIT.sh3.p_vle_bundle_out,
        flameRoom_sh_3.N_cv_TB),
    h_nom_TB=linspace(
        NOM.sh3.h_vle_bundle_in,
        NOM.sh3.h_vle_bundle_out,
        flameRoom_sh_3.N_cv_TB),
    p_nom_TB=linspace(
        NOM.sh3.p_vle_bundle_in,
        NOM.sh3.p_vle_bundle_out,
        flameRoom_sh_3.N_cv_TB),
    m_flow_nom_TB=NOM.sh3.m_flow_vle_bundle,
    Delta_p_nom_TB=NOM.sh3.Delta_p_vle_bundle_nom,
    frictionAtInlet_CT=true,
    frictionAtOutlet_CT=false,
    redeclare model PressureLoss_CT = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_CT = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    diameter_o_CT=0.0445,
    diameter_i_CT=0.027,
    N_tubes_CT=310,
    h_start_CT=(INIT.ct.h_vle_wall_out - INIT.ct.h_vle_wall_in)/7*5 + INIT.ct.h_vle_wall_in,
    p_start_CT=(INIT.ct.p_vle_wall_out - INIT.ct.p_vle_wall_in)/7*5 + INIT.ct.p_vle_wall_in,
    m_flow_nom_CT=NOM.ct.m_flow_vle_wall_in,
    h_nom=(NOM.ct.h_vle_wall_out - NOM.ct.h_vle_wall_in)/7*5 + NOM.ct.h_vle_wall_in,
    p_nom_CT=(NOM.ct.p_vle_wall_out - NOM.ct.p_vle_wall_in)/7*5 + NOM.ct.p_vle_wall_in,
    Delta_p_nom_CT=NOM.ct.Delta_p_vle_wall/7) annotation (Placement(transformation(extent={{-88,122},{-148,142}})));
  SubSystems.Furnace.ConvectiveSlice_L4 flameRoom_rh_2(
    redeclare model GasHeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                         CF_fouling=0.9, suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        alpha_nom=alpha_wall,
        CF_fouling=CF_fouling_glob,
        temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_CarrierTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=flameRoom_sh_4.z_out_furnace,
    z_out_furnace=71.45,
    p_start_flueGas_out(displayUnit="bar") = 100400,
    T_start_flueGas_out=INIT.rh2.T_fg_out - 260,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    frictionAtOutlet_FTW=false,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    psi_FTW=0,
    length_FTW=flameRoom_rh_2.z_out_furnace - flameRoom_rh_2.z_in_furnace,
    diameter_o_FTW=0.0318,
    diameter_i_FTW=0.0206,
    N_tubes_FTW=970,
    h_start_FTW=linspace(
        INIT.rh2.h_vle_wall_in,
        INIT.rh2.h_vle_wall_out,
        flameRoom_rh_2.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.rh2.p_vle_wall_in,
        INIT.rh2.p_vle_wall_out,
        flameRoom_rh_2.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.rh2.h_vle_wall_in,
        NOM.rh2.h_vle_wall_out,
        flameRoom_rh_2.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.rh2.p_vle_wall_in,
        NOM.rh2.p_vle_wall_out,
        flameRoom_rh_2.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.rh2.Delta_p_vle_wall,
    frictionAtInlet_TB=true,
    frictionAtOutlet_TB=false,
    redeclare model PressureLoss_TB = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_TB = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    length_TB=15,
    diameter_o_TB=0.051,
    diameter_i_TB=0.0397,
    N_tubes_TB=800,
    N_passes_TB=2,
    Delta_z_par=2*flameRoom_rh_2.diameter_o_TB,
    Delta_z_ort=2*flameRoom_rh_2.diameter_o_TB,
    N_rows_TB=32,
    N_cv_TB=5,
    Delta_x_TB=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        flameRoom_rh_2.length_TB*flameRoom_rh_2.N_passes_TB,
        flameRoom_rh_2.N_cv_TB),
    h_start_TB=linspace(
        INIT.rh2.h_vle_bundle_in,
        INIT.rh2.h_vle_bundle_out,
        flameRoom_rh_2.N_cv_TB),
    p_start_TB=linspace(
        INIT.rh2.p_vle_bundle_in,
        INIT.rh2.p_vle_bundle_out,
        flameRoom_rh_2.N_cv_TB),
    h_nom_TB=linspace(
        NOM.rh2.h_vle_bundle_in,
        NOM.rh2.h_vle_bundle_out,
        flameRoom_rh_2.N_cv_TB),
    p_nom_TB=linspace(
        NOM.rh2.p_vle_bundle_in,
        NOM.rh2.p_vle_bundle_out,
        flameRoom_rh_2.N_cv_TB),
    m_flow_nom_TB=NOM.m_flow_nom - NOM.preheater_HP_m_flow_tap,
    Delta_p_nom_TB=NOM.rh2.Delta_p_vle_wall_nom,
    frictionAtInlet_CT=true,
    frictionAtOutlet_CT=false,
    redeclare model PressureLoss_CT = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_CT = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    diameter_o_CT=0.0445,
    diameter_i_CT=0.027,
    N_tubes_CT=310,
    h_start_CT=(INIT.ct.h_vle_wall_out - INIT.ct.h_vle_wall_in)/7*4 + INIT.ct.h_vle_wall_in,
    p_start_CT=(INIT.ct.p_vle_wall_out - INIT.ct.p_vle_wall_in)/7*4 + INIT.ct.p_vle_wall_in,
    m_flow_nom_CT=NOM.ct.m_flow_vle_wall_in,
    h_nom=(NOM.ct.h_vle_wall_out - NOM.ct.h_vle_wall_in)/7*4 + NOM.ct.h_vle_wall_in,
    p_nom_CT=(NOM.ct.p_vle_wall_out - NOM.ct.p_vle_wall_in)/7*4 + NOM.ct.p_vle_wall_in,
    Delta_p_nom_CT=NOM.ct.Delta_p_vle_wall/7) annotation (Placement(transformation(extent={{-88,94},{-148,114}})));
  SubSystems.Furnace.ConvectiveSlice_L4 flameRoom_sh_4(
    redeclare model GasHeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                         CF_fouling=0.6, suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        alpha_nom=alpha_wall,
        CF_fouling=CF_fouling_glob,
        temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_CarrierTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=flameRoom_sh_2.z_out_furnace,
    z_out_furnace=67.89,
    p_start_flueGas_out(displayUnit="bar") = 100500,
    T_start_flueGas_out=INIT.sh4.T_fg_out - 250,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    frictionAtOutlet_FTW=false,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    psi_FTW=0,
    length_FTW=flameRoom_sh_4.z_out_furnace - flameRoom_sh_4.z_in_furnace,
    diameter_o_FTW=0.0318,
    diameter_i_FTW=0.0206,
    N_tubes_FTW=970,
    h_start_FTW=linspace(
        INIT.sh4.h_vle_wall_in,
        INIT.sh4.h_vle_wall_out,
        flameRoom_sh_4.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.sh4.p_vle_wall_in,
        INIT.sh4.p_vle_wall_out,
        flameRoom_sh_4.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.sh4.h_vle_wall_in,
        NOM.sh4.h_vle_wall_out,
        flameRoom_sh_4.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.sh4.p_vle_wall_in,
        NOM.sh4.p_vle_wall_out,
        flameRoom_sh_4.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.sh4.Delta_p_vle_wall,
    frictionAtInlet_TB=true,
    frictionAtOutlet_TB=false,
    redeclare model PressureLoss_TB = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_TB = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    length_TB=15,
    diameter_o_TB=0.038,
    diameter_i_TB=0.0238,
    N_tubes_TB=530,
    N_passes_TB=2,
    Delta_z_par=2*flameRoom_sh_4.diameter_o_TB,
    Delta_z_ort=2*flameRoom_sh_4.diameter_o_TB,
    N_rows_TB=integer(ceil(sqrt(flameRoom_sh_4.N_tubes_TB))*flameRoom_sh_4.N_passes_TB),
    N_cv_TB=5,
    Delta_x_TB=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        flameRoom_sh_4.length_TB*flameRoom_sh_4.N_passes_TB,
        flameRoom_sh_4.N_cv_TB),
    h_start_TB=linspace(
        INIT.sh4.h_vle_bundle_in,
        INIT.sh4.h_vle_bundle_out,
        flameRoom_sh_4.N_cv_TB),
    p_start_TB=linspace(
        INIT.sh4.p_vle_bundle_in,
        INIT.sh4.p_vle_bundle_out,
        flameRoom_sh_4.N_cv_TB),
    h_nom_TB=linspace(
        NOM.sh4.h_vle_bundle_in,
        NOM.sh4.h_vle_bundle_out,
        flameRoom_sh_4.N_cv_TB),
    p_nom_TB=linspace(
        NOM.sh4.p_vle_bundle_in,
        NOM.sh4.p_vle_bundle_out,
        flameRoom_sh_4.N_cv_TB),
    m_flow_nom_TB=NOM.sh4.m_flow_vle_bundle,
    Delta_p_nom_TB=NOM.sh4.Delta_p_vle_bundle_nom,
    frictionAtInlet_CT=true,
    frictionAtOutlet_CT=false,
    redeclare model PressureLoss_CT = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_CT = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    diameter_o_CT=0.0445,
    diameter_i_CT=0.027,
    N_tubes_CT=310,
    h_start_CT=(INIT.ct.h_vle_wall_out - INIT.ct.h_vle_wall_in)/7*3 + INIT.ct.h_vle_wall_in,
    p_start_CT=(INIT.ct.p_vle_wall_out - INIT.ct.p_vle_wall_in)/7*3 + INIT.ct.p_vle_wall_in,
    m_flow_nom_CT=NOM.ct.m_flow_vle_wall_in,
    h_nom=(NOM.ct.h_vle_wall_out - NOM.ct.h_vle_wall_in)/7*3 + NOM.ct.h_vle_wall_in,
    p_nom_CT=(NOM.ct.p_vle_wall_out - NOM.ct.p_vle_wall_in)/7*3 + NOM.ct.p_vle_wall_in,
    Delta_p_nom_CT=NOM.ct.Delta_p_vle_wall/7) annotation (Placement(transformation(extent={{-88,64},{-148,84}})));
  SubSystems.Furnace.ConvectiveSlice_L4 flameRoom_sh_2(
    redeclare model GasHeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                         CF_fouling=0.55, suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        alpha_nom=alpha_wall,
        CF_fouling=CF_fouling_glob,
        temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_CarrierTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=flameRoom_sh_1.z_out_furnace,
    z_out_furnace=63.91,
    p_start_flueGas_out(displayUnit="bar") = 100600,
    T_start_flueGas_out=INIT.sh2.T_fg_out - 200,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    frictionAtOutlet_FTW=false,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    psi_FTW=0,
    length_FTW=flameRoom_sh_2.z_out_furnace - flameRoom_sh_2.z_in_furnace,
    diameter_o_FTW=0.0318,
    diameter_i_FTW=0.0206,
    N_tubes_FTW=970,
    h_start_FTW=linspace(
        INIT.sh2.h_vle_wall_in,
        INIT.sh2.h_vle_wall_out,
        flameRoom_sh_2.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.sh2.p_vle_wall_in,
        INIT.sh2.p_vle_wall_out,
        flameRoom_sh_2.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.sh2.h_vle_wall_in,
        NOM.sh2.h_vle_wall_out,
        flameRoom_sh_2.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.sh2.p_vle_wall_in,
        NOM.sh2.p_vle_wall_out,
        flameRoom_sh_2.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.sh2.Delta_p_vle_wall,
    frictionAtInlet_TB=true,
    frictionAtOutlet_TB=false,
    redeclare model PressureLoss_TB = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_TB = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    length_TB=15,
    diameter_o_TB=0.0345,
    diameter_i_TB=0.0269,
    N_tubes_TB=250,
    N_passes_TB=2,
    Delta_z_par=2*flameRoom_sh_2.diameter_o_TB,
    Delta_z_ort=2*flameRoom_sh_2.diameter_o_TB,
    N_rows_TB=integer(ceil(sqrt(flameRoom_sh_2.N_tubes_TB))*flameRoom_sh_2.N_passes_TB),
    N_cv_TB=5,
    Delta_x_TB=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        flameRoom_sh_2.length_TB*flameRoom_sh_2.N_passes_TB,
        flameRoom_sh_2.N_cv_TB),
    h_start_TB=linspace(
        INIT.sh2.h_vle_bundle_in,
        INIT.sh2.h_vle_bundle_out,
        flameRoom_sh_2.N_cv_TB),
    p_start_TB=linspace(
        INIT.sh2.p_vle_bundle_in,
        INIT.sh2.p_vle_bundle_out,
        flameRoom_sh_2.N_cv_TB),
    h_nom_TB=linspace(
        NOM.sh2.h_vle_bundle_in,
        NOM.sh2.h_vle_bundle_out,
        flameRoom_sh_2.N_cv_TB),
    p_nom_TB=linspace(
        NOM.sh2.p_vle_bundle_in,
        NOM.sh2.p_vle_bundle_out,
        flameRoom_sh_2.N_cv_TB),
    m_flow_nom_TB=NOM.sh2.m_flow_vle_bundle,
    Delta_p_nom_TB=NOM.sh2.Delta_p_vle_bundle_nom,
    frictionAtInlet_CT=true,
    frictionAtOutlet_CT=false,
    redeclare model PressureLoss_CT = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_CT = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    diameter_o_CT=0.0445,
    diameter_i_CT=0.027,
    N_tubes_CT=310,
    h_start_CT=(INIT.ct.h_vle_wall_out - INIT.ct.h_vle_wall_in)/7*2 + INIT.ct.h_vle_wall_in,
    p_start_CT=(INIT.ct.p_vle_wall_out - INIT.ct.p_vle_wall_in)/7*2 + INIT.ct.p_vle_wall_in,
    m_flow_nom_CT=NOM.ct.m_flow_vle_wall_in,
    h_nom=(NOM.ct.h_vle_wall_out - NOM.ct.h_vle_wall_in)/7*2 + NOM.ct.h_vle_wall_in,
    p_nom_CT=(NOM.ct.p_vle_wall_out - NOM.ct.p_vle_wall_in)/7*2 + NOM.ct.p_vle_wall_in,
    Delta_p_nom_CT=NOM.ct.Delta_p_vle_wall/7) annotation (Placement(transformation(extent={{-88,34},{-148,54}})));
  SubSystems.Furnace.ConvectiveSlice_L4 flameRoom_sh_1(
    redeclare model GasHeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                         CF_fouling=0.55, suspension_calculationType="Calculated"),
    redeclare model GasHeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        alpha_nom=alpha_wall,
        CF_fouling=CF_fouling_glob,
        temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_CarrierTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Logarithmic mean - smoothed"),
    redeclare model GasHeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model GasPressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    redeclare model Burning_time = Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model ParticleMigration = Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    length_furnace=14.576,
    width_furnace=14.576,
    z_in_furnace=flameRoom_evap_2.z_out_furnace,
    z_out_furnace=59.36,
    p_start_flueGas_out(displayUnit="bar") = 100700,
    T_start_flueGas_out=INIT.sh1.T_fg_out - 100,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom_gas=550,
    frictionAtInlet_FTW=true,
    frictionAtOutlet_FTW=false,
    redeclare model PressureLoss_FTW = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_FTW = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    psi_FTW=0,
    length_FTW=flameRoom_sh_1.z_out_furnace - flameRoom_sh_1.z_in_furnace,
    diameter_o_FTW=0.0318,
    diameter_i_FTW=0.0206,
    N_tubes_FTW=970,
    h_start_FTW=linspace(
        INIT.sh1.h_vle_wall_in,
        INIT.sh1.h_vle_wall_out,
        flameRoom_sh_1.N_cv_FTW),
    p_start_FTW=linspace(
        INIT.sh1.p_vle_wall_in,
        INIT.sh1.p_vle_wall_out,
        flameRoom_sh_1.N_cv_FTW),
    h_nom_FTW=linspace(
        NOM.sh1.h_vle_wall_in,
        NOM.sh1.h_vle_wall_out,
        flameRoom_sh_1.N_cv_FTW),
    p_nom_FTW=linspace(
        NOM.sh1.p_vle_wall_in,
        NOM.sh1.p_vle_wall_out,
        flameRoom_sh_1.N_cv_FTW),
    m_flow_nom_FTW=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom_FTW=NOM.sh1.Delta_p_vle_wall,
    frictionAtInlet_TB=true,
    frictionAtOutlet_TB=true,
    redeclare model PressureLoss_TB = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_TB = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    length_TB=12,
    diameter_o_TB=0.0345,
    diameter_i_TB=0.0269,
    N_tubes_TB=300,
    Delta_z_par=2*flameRoom_sh_1.diameter_o_TB,
    Delta_z_ort=2*flameRoom_sh_1.diameter_o_TB,
    N_rows_TB=integer(ceil(sqrt(flameRoom_sh_1.N_tubes_TB))*flameRoom_sh_1.N_passes_TB),
    N_cv_TB=5,
    Delta_x_TB=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        flameRoom_sh_1.length_TB*flameRoom_sh_1.N_passes_TB,
        flameRoom_sh_1.N_cv_TB),
    initOption_TB=0,
    h_start_TB=linspace(
        INIT.sh1.h_vle_bundle_in,
        INIT.sh1.h_vle_bundle_out,
        flameRoom_sh_1.N_cv_TB),
    p_start_TB=linspace(
        INIT.sh1.p_vle_bundle_in,
        INIT.sh1.p_vle_bundle_out,
        flameRoom_sh_1.N_cv_TB),
    h_nom_TB=linspace(
        NOM.sh1.h_vle_bundle_in,
        NOM.sh1.h_vle_bundle_out,
        flameRoom_sh_1.N_cv_TB),
    p_nom_TB=linspace(
        NOM.sh1.p_vle_bundle_in,
        NOM.sh1.p_vle_bundle_out,
        flameRoom_sh_1.N_cv_TB),
    m_flow_nom_TB=NOM.sh1.m_flow_vle_bundle,
    Delta_p_nom_TB=NOM.sh1.Delta_p_vle_bundle_nom,
    frictionAtInlet_CT=true,
    frictionAtOutlet_CT=false,
    redeclare model PressureLoss_CT = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer_CT = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    diameter_o_CT=0.0445,
    diameter_i_CT=0.027,
    N_tubes_CT=310,
    h_start_CT=(INIT.ct.h_vle_wall_out - INIT.ct.h_vle_wall_in)/7*1 + INIT.ct.h_vle_wall_in,
    p_start_CT=(INIT.ct.p_vle_wall_out - INIT.ct.p_vle_wall_in)/7*1 + INIT.ct.p_vle_wall_in,
    m_flow_nom_CT=NOM.ct.m_flow_vle_wall_in,
    h_nom=(NOM.ct.h_vle_wall_out - NOM.ct.h_vle_wall_in)/7*1 + NOM.ct.h_vle_wall_in,
    p_nom_CT=(NOM.ct.p_vle_wall_out - NOM.ct.p_vle_wall_in)/7*1 + NOM.ct.p_vle_wall_in,
    Delta_p_nom_CT=NOM.ct.Delta_p_vle_wall/7) annotation (Placement(transformation(extent={{-88,4},{-148,24}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=1,
    T=100) annotation (Placement(transformation(extent={{-412,-400},{-404,-392}})));
equation
  totalHeat =burner1.burner.Q_flow_wall + burner2.burner.Q_flow_wall + burner3.burner.Q_flow_wall + burner4.burner.Q_flow_wall + flameRoom_evap_1.flameRoom.Q_flow_wall + flameRoom_evap_2.flameRoom.Q_flow_wall + flameRoom_sh_1.flameRoom.Q_flow_wall + flameRoom_sh_2.flameRoom.Q_flow_wall + flameRoom_sh_4.flameRoom.Q_flow_wall + flameRoom_rh_2.flameRoom.Q_flow_wall;

  connect(coalGas_join_burner1.fuelFlueGas_outlet, mill1.inlet) annotation (Line(
      points={{-8,-154},{-14,-154}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp2.y, mill1.classifierSpeed) annotation (Line(
      points={{-9,-40},{-24,-40},{-24,-143.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eco_down_wall.innerPhase, eco_down.heat) annotation (Line(
      points={{-58,-214},{-61,-214}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(separator_wall.innerPhase, separator.heat) annotation (Line(
      points={{-130.2,252.32},{-130,252.32},{-130,240}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(rh_pipe_wall.innerPhase, rh_pipe.heat) annotation (Line(
      points={{470,198},{474,198},{474,200},{476,200},{476,198},{482,198}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(sh_pipe_wall.innerPhase, sh_pipe.heat) annotation (Line(
      points={{350,200},{364,200}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(coalFlowSource_burner4.fuel_a, coalGas_join_burner4.fuel_inlet) annotation (Line(
      points={{26,-70},{12,-70}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner3.fuel_a, coalGas_join_burner3.fuel_inlet) annotation (Line(
      points={{26,-96},{12,-96}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner2.fuel_a, coalGas_join_burner2.fuel_inlet) annotation (Line(
      points={{26,-122},{12,-122}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner1.fuel_a, coalGas_join_burner1.fuel_inlet) annotation (Line(
      points={{26,-148},{12,-148}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(slagFlowSource_top.slag_outlet, coalSlagFlueGas_split_top.slag_inlet) annotation (Line(
      points={{-188,304},{-98,304},{-98,268}},
      color={234,171,0},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalSink_top.fuel_a, coalSlagFlueGas_split_top.fuel_outlet) annotation (Line(
      points={{-162,292},{-104,292},{-104,268}},
      color={27,36,42},
      thickness=0.5));
  connect(PI_valveControl_preheater_HP.y,valveControl_preheater_HP. opening_in) annotation (Line(
      points={{605,-320},{610,-320},{610,-299}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(join_LP1.inlet,Turbine_LP1. outlet) annotation (Line(
      points={{916,-30},{912,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.inlet,Turbine_HP1. outlet) annotation (Line(
      points={{578,-52},{608,-52},{608,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet2,valve_HP. inlet) annotation (Line(
      points={{568,-62},{568,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valvePreFeedWaterTank.outlet,join_LP_main. inlet1) annotation (Line(
      points={{806,-192},{796,-192}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID_preheaterLP1.y, Pump_preheater_LP1.P_drive) annotation (Line(
      points={{853,-320},{816,-320},{816,-252}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Turbine_HP1.eye,quadruple4. eye) annotation (Line(
      points={{609,-26},{616,-26},{616,40}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_IP1.eye,quadruple3. eye) annotation (Line(
      points={{693,-26},{696,-26},{696,40},{716,40}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP1.eye, quadruple7.eye) annotation (Line(
      points={{913,-26},{926,-26},{926,78},{1074,78}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP4.eye,quadruple. eye) annotation (Line(
      points={{1033,-26},{1038,-26},{1038,0},{1046,0}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple6.eye,feedWaterTank. eye) annotation (Line(
      points={{708,-220},{708,-209}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple8.eye,valve_IP1. eye) annotation (Line(
      points={{752,-120},{742,-120},{742,-110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple9.eye,valve_IP3. eye) annotation (Line(
      points={{860,-120},{852,-120},{852,-110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(valve_HP.eye,quadruple11. eye) annotation (Line(
      points={{564,-110},{564,-119.7},{574,-119.7},{574,-120}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple12.eye,valveControl_preheater_HP. eye) annotation (Line(
      points={{600,-274},{630,-274},{630,-286},{620,-286}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple13.eye,Pump_cond. eye) annotation (Line(
      points={{1138,-160},{1138,-192},{1155,-192}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple14.eye,Pump_preheater_LP1. eye) annotation (Line(
      points={{790,-218},{790,-234},{805,-234}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.outlet,join_LP_main. inlet2) annotation (Line(
      points={{806,-240},{786,-240},{786,-202}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP_main.outlet,feedWaterTank. condensate) annotation (Line(
      points={{776,-192},{750,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(Turbine_IP2.outlet,split_IP2. inlet) annotation (Line(
      points={{732,-30},{736,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(split_IP2.outlet1,Turbine_IP3. inlet) annotation (Line(
      points={{756,-30},{756,-14},{762,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_IP3.outlet,join_IP3. inlet) annotation (Line(
      points={{772,-30},{846,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_IP2.eye,quadruple15. eye) annotation (Line(points={{733,-26},{736,-26},{736,20}},
                                                                                               color={190,190,190}));
  connect(Turbine_IP3.eye,quadruple16. eye) annotation (Line(points={{773,-26},{776,-26},{776,0}},color={190,190,190}));
  connect(split_IP2.outlet2,valve_IP1. inlet) annotation (Line(
      points={{746,-40},{746,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_IP3.outlet1,Turbine_LP1. inlet) annotation (Line(
      points={{866,-30},{896,-30},{896,-14},{902,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP2.outlet,join_LP2. inlet) annotation (Line(
      points={{952,-30},{956,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP2.outlet1,Turbine_LP3. inlet) annotation (Line(
      points={{976,-30},{976,-14},{982,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP3.outlet1,Turbine_LP4. inlet) annotation (Line(
      points={{1016,-30},{1016,-14},{1022,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP3.outlet,join_LP3. inlet) annotation (Line(
      points={{992,-30},{996,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.In1,valve_LP2. outlet) annotation (Line(
      points={{926,-184.2},{926,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.Out1,valveControl_preheater_LP2. inlet) annotation (Line(
      points={{926,-204},{926,-210}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP2.outlet,preheater_LP3. aux1) annotation (Line(
      points={{926,-230},{926,-240},{948,-240},{948,-186},{986,-186}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_preheater_LP3.outlet,preheater_LP2. In2) annotation (Line(
      points={{950,-192},{936,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_preheater_LP3.inlet1,preheater_LP3. Out2) annotation (Line(
      points={{970,-192},{976,-192},{976,-176},{1024,-176},{1024,-188},{1006,-188}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP3.Out1,Pump_preheater_LP3. inlet) annotation (Line(
      points={{996,-204},{996,-240},{986,-240}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_preheater_LP3.outlet,valve_afterPumpLP3. inlet) annotation (Line(
      points={{966,-240},{960,-240},{960,-230}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_afterPumpLP3.outlet,join_preheater_LP3. inlet2) annotation (Line(
      points={{960,-210},{960,-202}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_IP3.outlet2,valve_IP3. inlet) annotation (Line(
      points={{856,-40},{856,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP1.outlet2,valve_LP2. inlet) annotation (Line(
      points={{926,-40},{926,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP2.outlet2,valve_LP3. inlet) annotation (Line(
      points={{966,-40},{966,-80},{996,-80},{996,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP3.outlet2,valve_LP4. inlet) annotation (Line(
      points={{1006,-40},{1006,-70},{1066,-70},{1066,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_LP3.outlet,preheater_LP3. In1) annotation (Line(
      points={{996,-110},{996,-184}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(setPoint_preheaterLP4.y,PID_preheaterLP4. u_s) annotation (Line(points={{1042.7,-310},{1052,-310},{1052,-320},{1062,-320}},
                                                                                                                                  color={0,0,127}));
  connect(PID_preheaterLP4.y,valveControl_preheater_LP4. opening_in) annotation (Line(points={{1085,-320},{1106,-320},{1106,-249}},
                                                                                                                                 color={0,0,127}));
  connect(preheater_LP3.level,PID_preheaterLP3. u_m) annotation (Line(points={{1004,-205},{1003.9,-205},{1003.9,-308}},
                                                                                                                     color={0,0,127}));
  connect(PID_preheaterLP3.y,Pump_preheater_LP3. P_drive) annotation (Line(points={{993,-320},{976,-320},{976,-252}}, color={0,0,127}));
  connect(setPoint_preheaterLP3.y,PID_preheaterLP3. u_s) annotation (Line(points={{1027.3,-320},{1016,-320}},
                                                                                                            color={0,0,127}));
  connect(PID_preheaterLP2.y, valveControl_preheater_LP2.opening_in) annotation (Line(points={{923,-320},{912,-320},{912,-220},{917,-220}},     color={0,0,127}));
  connect(preheater_LP2.level, PID_preheaterLP2.u_m) annotation (Line(points={{934,-205},{934,-308},{933.9,-308}},    color={0,0,127}));
  connect(setPoint_preheaterLP2.y, PID_preheaterLP2.u_s) annotation (Line(points={{955.3,-320},{946,-320}},   color={0,0,127}));
  connect(setPoint_preheaterLP1.y, PID_preheaterLP1.u_s) annotation (Line(points={{885.3,-320},{876,-320}},   color={0,0,127}));
  connect(Turbine_LP3.eye,quadruple18. eye) annotation (Line(points={{993,-26},{996,-26},{996,20},{1036,20}},
                                                                                                           color={190,190,190}));
  connect(Turbine_LP2.eye,quadruple17. eye) annotation (Line(points={{953,-26},{956,-26},{956,40},{1016,40}},color={190,190,190}));
  connect(Turbine_HP1.shaft_b,Turbine_IP1. shaft_a) annotation (Line(points={{612,-20},{678,-20}},
                                                                                                color={0,0,0}));
  connect(Turbine_IP1.shaft_b,Turbine_IP2. shaft_a) annotation (Line(points={{696,-20},{718,-20}},
                                                                                               color={0,0,0}));
  connect(Turbine_IP2.shaft_b,Turbine_IP3. shaft_a) annotation (Line(points={{736,-20},{758,-20}},
                                                                                                color={0,0,0}));
  connect(Turbine_IP3.shaft_b,Turbine_LP1. shaft_a) annotation (Line(points={{776,-20},{898,-20}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP1.shaft_b,Turbine_LP2. shaft_a) annotation (Line(points={{916,-20},{938,-20}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP2.shaft_b,Turbine_LP3. shaft_a) annotation (Line(points={{956,-20},{978,-20}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP3.shaft_b,Turbine_LP4. shaft_a) annotation (Line(points={{996,-20},{1018,-20}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP4.shaft_b,inertia. flange_a) annotation (Line(points={{1036,-20},{1168,-20}},
                                                                                              color={0,0,0}));
  connect(inertia.flange_b,simpleGenerator. shaft) annotation (Line(points={{1188,-20},{1188,-20.1},{1198,-20.1}},    color={0,0,0}));
  connect(simpleGenerator.powerConnection,boundaryElectricFrequency. electricPortIn) annotation (Line(
      points={{1218,-20},{1238,-20}},
      color={115,150,0},
      thickness=0.5));
  connect(valve_LP2.eye,quadruple19. eye) annotation (Line(points={{922,-110},{922,-120},{930,-120}},
                                                                                                   color={190,190,190}));
  connect(valve_LP3.eye,quadruple20. eye) annotation (Line(points={{992,-110},{992,-120},{1000,-120}},
                                                                                                   color={190,190,190}));
  connect(valve_LP4.eye,quadruple21. eye) annotation (Line(points={{1062,-110},{1062,-120},{1072,-120}},
                                                                                                   color={190,190,190}));
  connect(setPoint_preheater_HP.y,PI_valveControl_preheater_HP. u_m) annotation (Line(points={{580.6,-336},{594.1,-336},{594.1,-332}},
                                                                                                                                   color={0,0,127}));
  connect(preheater_LP2.level,fillingLevel_preheater_LP2. u_in) annotation (Line(points={{934,-205},{932,-205},{932,-204},{933,-204}}, color={0,0,127}));
  connect(preheater_LP3.level,fillingLevel_preheater_LP3. u_in) annotation (Line(points={{1004,-205},{1004,-204},{1003,-204}},
                                                                                                                            color={0,0,127}));
  connect(Turbine_IP1.outlet,Turbine_IP2. inlet) annotation (Line(
      points={{692,-30},{716,-30},{716,-14},{722,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP1.outlet1,Turbine_LP2. inlet) annotation (Line(
      points={{936,-30},{936,-14},{942,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.eye2,quadruple22. eye) annotation (Line(points={{915,-194},{890,-194},{890,-160},{860,-160}}, color={190,190,190}));
  connect(preheater_LP3.eye2,quadruple23. eye) annotation (Line(points={{1007,-186},{1026,-186},{1026,-170},{1000,-170},{1000,-160}},       color={190,190,190}));
  connect(downComer_feedWaterTank.outlet,Pump_FW. inlet) annotation (Line(
      points={{704,-243},{704,-250},{686,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedWaterTank.feedwater,downComer_feedWaterTank. inlet) annotation (Line(
      points={{704,-208},{704,-215}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_IP1.outlet,feedWaterTank. heatingSteam) annotation (Line(
      points={{746,-110},{746,-182},{710,-182},{710,-190}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_HP.outlet,feedWaterTank. aux) annotation (Line(
      points={{620,-290},{768,-290},{768,-188},{746,-188},{746,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(setPoint_condenser.y,PI_Pump_cond. u_s) annotation (Line(points={{1227.3,-320},{1218,-320}},
                                                                                                     color={0,0,127}));
  connect(motor.shaft,Pump_cond. shaft) annotation (Line(points={{1166,-220},{1166,-207.9}},
                                                                                           color={0,0,0}));
  connect(measurement.y,PI_Pump_cond. u_m) annotation (Line(points={{1231.6,-340},{1205.9,-340},{1205.9,-332}},
                                                                                                             color={0,0,127}));
  connect(fixedVoltage.y,motor. U_term) annotation (Line(points={{1152.7,-260},{1166,-260},{1166,-242}},
                                                                                                      color={0,0,127}));
  connect(PI_Pump_cond.y,motor. f_term) annotation (Line(points={{1195,-320},{1170,-320},{1170,-242}},
                                                                                                    color={0,0,127}));
  connect(valveControl_preheater_LP1.outlet,boundaryVLE_phxi. steam_a) annotation (Line(
      points={{1252,-100},{1256,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_pipe.outlet, Turbine_HP1.inlet) annotation (Line(
      points={{368,214},{368,264},{598,264},{598,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rh_pipe.outlet, Turbine_IP1.inlet) annotation (Line(
      points={{486,212},{486,218},{682,218},{682,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_pipe.eye, quadruple2.eye) annotation (Line(points={{371.4,214.6},{371.4,244},{402,244}},     color={190,190,190}));
  connect(rh_pipe.eye, quadruple1.eye) annotation (Line(points={{489.4,212.6},{489.4,202},{522,202}},        color={190,190,190}));
  connect(eco_riser_wall.innerPhase, eco_riser.heat) annotation (Line(
      points={{316,-124},{318,-124},{318,-126},{316,-126},{316,-124},{317,-124}},
      color={167,25,48},
      thickness=0.5));
  connect(splitVLE_L2_flex.outlet[1], eco_riser.inlet) annotation (Line(
      points={{400,-249.625},{400,-250},{322,-250},{322,-194},{321,-194},{321,-138}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitVLE_L2_flex.inlet, valveVLE_L1_1.inlet) annotation (Line(
      points={{420,-250},{446,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(regenerativeAirPreheater.freshAirOutlet, splitGas_L2_flex.inlet) annotation (Line(
      points={{-396,-54},{-412,-54},{-412,-292},{136,-292},{136,-108},{112,-108}},
      color={118,106,98},
      thickness=0.5));
  connect(fluelGasFlowSource_burner1.gas_a, regenerativeAirPreheater.freshAirInlet) annotation (Line(
      points={{-424,-42},{-396,-42}},
      color={118,106,98},
      thickness=0.5));
  connect(regenerativeAirPreheater.flueGasOutlet, flueGasPressureSink_top.gas_a) annotation (Line(
      points={{-376,-42},{-318,-42},{-318,-22}},
      color={118,106,98},
      thickness=0.5));
  connect(regenerativeAirPreheater.flueGasInlet, coalSlagFlueGas_split_top.flueGas_outlet) annotation (Line(
      points={{-376,-54},{-278,-54},{-278,316},{-92,316},{-92,268}},
      color={118,106,98},
      thickness=0.5));
  connect(PID_lambda.u_m,actual_lambda. y) annotation (Line(
      points={{-507.9,-24},{-507.9,-6},{-549,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lambda.y,PID_lambda. u_s) annotation (Line(
      points={{-549,-36},{-520,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, coalFlowSource_burner2.m_flow) annotation (Line(points={{182,-215},{182,-116},{46,-116}},                 color={0,0,127}));
  connect(gain.y, coalFlowSource_burner1.m_flow) annotation (Line(points={{182,-215},{182,-142},{46,-142}},                 color={0,0,127}));
  connect(gain.y, coalFlowSource_burner3.m_flow) annotation (Line(points={{182,-215},{182,-90},{46,-90}},                 color={0,0,127}));
  connect(gain.y, coalFlowSource_burner4.m_flow) annotation (Line(points={{182,-215},{182,-64},{46,-64}},                 color={0,0,127}));
  connect(splitGas_L2_flex.outlet[1], coalGas_join_burner4.flueGas_inlet) annotation (Line(
      points={{92,-108.375},{92,-82},{12,-82}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[2], coalGas_join_burner3.flueGas_inlet) annotation (Line(
      points={{92,-108.125},{92,-108},{12,-108}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[3], coalGas_join_burner2.flueGas_inlet) annotation (Line(
      points={{92,-107.875},{92,-134},{12,-134}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[4], coalGas_join_burner1.flueGas_inlet) annotation (Line(
      points={{92,-107.625},{92,-160},{12,-160}},
      color={118,106,98},
      thickness=0.5));
  connect(PID_lambda.y, firstOrder.u) annotation (Line(points={{-497,-36},{-484,-36}},
                                                                                     color={0,0,127}));
  connect(firstOrder.y, fluelGasFlowSource_burner1.m_flow) annotation (Line(points={{-461,-36},{-444,-36}},
                                                                                                          color={0,0,127}));
  connect(preheater_HP.level, fillingLevel_preheater_HP.u_in) annotation (Line(points={{576,-263},{576,-262},{575,-262}},            color={0,0,127}));
  connect(preheater_HP.level, PI_valveControl_preheater_HP.u_s) annotation (Line(points={{576,-263},{576,-320},{582,-320}}, color={0,0,127}));
  connect(valveVLE_L1_1.outlet, preheater_HP.Out2) annotation (Line(
      points={{466,-250},{558,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(statePoint.port, preheater_HP.Out2) annotation (Line(
      points={{496,-250},{558,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_HP.eye2, quadruple25.eye) annotation (Line(points={{557,-252},{484,-252},{484,-262},{486,-262}},                       color={190,190,190}));
  connect(preheater_HP.Out1, valveControl_preheater_HP.inlet) annotation (Line(
      points={{568,-262},{568,-290},{600,-290}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_HP.outlet, preheater_HP.In1) annotation (Line(
      points={{568,-110},{568,-242.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.Out2, preheater_LP3.In2) annotation (Line(
      points={{1076,-188},{1086,-188},{1086,-176},{1040,-176},{1040,-198},{1006,-198}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_cond.outlet, preheater_LP4.In2) annotation (Line(
      points={{1156,-198},{1076,-198}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.Out1, valveControl_preheater_LP4.inlet) annotation (Line(
      points={{1066,-204},{1066,-240},{1096,-240}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.level, fillingLevel_preheater_LP4.u_in) annotation (Line(points={{1074,-205},{1074,-204},{1073,-204}},             color={0,0,127}));
  connect(preheater_LP4.level, PID_preheaterLP4.u_m) annotation (Line(points={{1074,-205},{1074,-308},{1074.1,-308}}, color={0,0,127}));
  connect(quadruple24.eye, preheater_LP4.eye2) annotation (Line(points={{1072,-160},{1070,-160},{1070,-182},{1077,-182},{1077,-186}}, color={190,190,190}));
  connect(preheater_LP1.In1, valve_IP3.outlet) annotation (Line(
      points={{856,-184.2},{856,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP1.Out1, Pump_preheater_LP1.inlet) annotation (Line(
      points={{856,-204},{856,-240},{826,-240}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.Out2, preheater_LP1.In2) annotation (Line(
      points={{916,-192},{866,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valvePreFeedWaterTank.inlet, preheater_LP1.Out2) annotation (Line(
      points={{826,-192},{846,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP1.level, fillingLevel_preheater_LP1.u_in) annotation (Line(points={{864,-205},{864,-204},{863,-204}},                color={0,0,127}));
  connect(preheater_LP1.level, PID_preheaterLP1.u_m) annotation (Line(points={{864,-205},{864,-256},{863.9,-256},{863.9,-308}},     color={0,0,127}));
  connect(preheater_LP4.In1, valve_LP4.outlet) annotation (Line(
      points={{1066,-184},{1066,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP1.inlet, condenser.Out2) annotation (Line(
      points={{1232,-100},{1224,-100},{1224,-114},{1206,-114}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.steam_a, condenser.In2) annotation (Line(
      points={{1256,-140},{1224,-140},{1224,-124},{1206,-124}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP4.outlet, condenser.In1) annotation (Line(
      points={{1032,-30},{1032,-52},{1196,-52},{1196,-110.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(condenser.aux1, valveControl_preheater_LP4.outlet) annotation (Line(
      points={{1186,-112},{1136,-112},{1136,-240},{1116,-240}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_cond.inlet, condenser.Out1) annotation (Line(
      points={{1176,-198},{1196,-198},{1196,-130}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fillingLevel_condenser.u_in, condenser.level) annotation (Line(points={{1203,-130},{1204,-130},{1204,-131}},                                     color={0,0,127}));
  connect(condenser.level, measurement.u) annotation (Line(points={{1204,-131},{1204,-206},{1258,-206},{1258,-340},{1240.8,-340}}, color={0,0,127}));
  connect(condenser.eye1, quadruple5.eye) annotation (Line(points={{1200,-131},{1200,-158},{1206,-158},{1206,-160}}, color={190,190,190}));
  connect(quadruple10.eye, preheater_LP1.eye2) annotation (Line(points={{786,-160},{846,-160},{846,-194},{845,-194}},                             color={190,190,190}));
  connect(quadrupleGas13.eye, regenerativeAirPreheater.eye_freshAir) annotation (Line(points={{-408,-95},{-406,-95},{-406,-56},{-396.2,-56},{-396.2,-56.6}},
                                                                                                                                                      color={190,190,190}));
  connect(regenerativeAirPreheater.eye_flueGas, quadrupleGas14.eye) annotation (Line(points={{-375.8,-39.4},{-375.8,-26},{-370,-26}},            color={190,190,190}));
  connect(boilergasTemperatures.y, xYplot.y1) annotation (Line(points={{-422,81},{-422,91.7857},{-421.333,91.7857}}, color={0,0,127}));
  connect(boilerZpositions.y, xYplot.x1) annotation (Line(points={{-364,161},{-364,160},{-377.933,160},{-377.933,160.143}},          color={0,0,127}));
  connect(boilerZpositions2.y, xYplot.x2) annotation (Line(points={{-364,201},{-364,209.857},{-377.933,209.857}},            color={0,0,127}));
  connect(boilervleTemperatures.y, xYplot.y2) annotation (Line(points={{-401,81},{-401,91.7857},{-400.667,91.7857}},           color={0,0,127}));
  connect(PTarget.y, feedForwardBlock_3508_1.P_G_target_) annotation (Line(points={{-455,-396},{-444,-396}}, color={0,0,127}));
  connect(rollerBowlMill_L1_1.coalDust, Nominal_PowerFeedwaterPump1.u) annotation (Line(points={{-369,-396},{621.2,-396}}, color={0,0,127}));
  connect(feedForwardBlock_3508_1.P_max_, P_max_.y) annotation (Line(points={{-440,-380},{-440,-364},{-457,-364}}, color={0,0,127}));
  connect(feedForwardBlock_3508_1.P_min_, P_min_.y) annotation (Line(points={{-436,-380},{-436,-346},{-457,-346}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_max_) annotation (Line(points={{-457,-328},{-432,-328},{-432,-380}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_StG_) annotation (Line(points={{-457,-328},{-428,-328},{-428,-380}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_T_) annotation (Line(points={{-457,-328},{-424,-328},{-424,-380}}, color={0,0,127}));
  connect(Nominal_PowerFeedwaterPump1.y, PI_feedwaterPump.u_s) annotation (Line(points={{630.4,-396},{646,-396}}, color={0,0,127}));
  connect(sensorFWflow.m_flow, PI_feedwaterPump.u_m) annotation (Line(points={{631,-240},{658.1,-240},{658.1,-384}}, color={0,0,127}));
  connect(PI_feedwaterPump.y, Pump_FW.P_drive) annotation (Line(points={{669,-396},{676,-396},{676,-262}}, color={0,0,127}));
  connect(preheater_HP.In2, sensorFWflow.outlet) annotation (Line(
      points={{578,-250},{632,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sensorFWflow.inlet, Pump_FW.outlet) annotation (Line(
      points={{652,-250},{666,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh2.inlet2, injectionControl_sh2.outlet) annotation (Line(
      points={{-12,28},{232,28},{232,-119}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh2.inlet, splitVLE_L2_flex.outlet[3]) annotation (Line(
      points={{232,-139},{232,-250.125},{400,-250.125}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh4.inlet, splitVLE_L2_flex.outlet[4]) annotation (Line(
      points={{254,-139},{254,-250.375},{400,-250.375}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh4.outlet, sprayInjector_sh4.inlet2) annotation (Line(
      points={{254,-119},{254,94},{34,94}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_rh2.outlet, sprayInjector_sh1.inlet2) annotation (Line(
      points={{278,-119},{278,140},{-14,140}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_rh2.inlet, splitVLE_L2_flex.outlet[2]) annotation (Line(
      points={{278,-139},{278,-249.875},{400,-249.875}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple33.eye, sprayInjector_sh2.eye) annotation (Line(points={{-6,58},{-30,58},{-30,38}},   color={190,190,190}));
  connect(quadruple34.eye, sprayInjector_sh4.eye) annotation (Line(points={{48,126},{16,126},{16,84}},     color={190,190,190}));
  connect(quadruple31.eye, sprayInjector_sh1.eye) annotation (Line(points={{-8,182},{-34,182},{-34,130},{-32,130}},
                                                                                                        color={190,190,190}));
  connect(hopper.inlet_FTW, eco_down.outlet) annotation (Line(
      points={{-126.2,-194},{-128,-194},{-128,-236},{-65,-236},{-65,-228}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hopper.eyeFTW, quadruple38.eye) annotation (Line(points={{-142,-173.6},{-142,-172},{-236,-172}},         color={190,190,190}));
  connect(hopper.outlet_FTW, burner1.inlet_FTW) annotation (Line(
      points={{-146,-174},{-146,-164}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hopper.heat_top, burner1.heat_bottom) annotation (Line(
      points={{-108,-174.2},{-108,-170},{-108.2,-170},{-108.2,-164}},
      color={167,25,48},
      thickness=0.5));
  connect(hopper.outletFG, burner1.inletFG) annotation (Line(
      points={{-98,-174.2},{-98,-164}},
      color={118,106,98},
      thickness=0.5));
  connect(mill1.outlet, burner1.inletFuel) annotation (Line(
      points={{-34,-154},{-88,-154},{-88,-154.2}},
      color={118,106,98},
      thickness=0.5));
  connect(coalGas_join_burner4.fuelFlueGas_outlet, mill4.inlet) annotation (Line(
      points={{-8,-76},{-14,-76}},
      color={118,106,98},
      thickness=0.5));
  connect(coalGas_join_burner3.fuelFlueGas_outlet, mill3.inlet) annotation (Line(
      points={{-8,-102},{-14,-102}},
      color={118,106,98},
      thickness=0.5));
  connect(coalGas_join_burner2.fuelFlueGas_outlet, mill2.inlet) annotation (Line(
      points={{-8,-128},{-14,-128}},
      color={118,106,98},
      thickness=0.5));
  connect(ramp2.y, mill4.classifierSpeed) annotation (Line(points={{-9,-40},{-24,-40},{-24,-65.2}},                  color={0,0,127}));
  connect(ramp2.y, mill3.classifierSpeed) annotation (Line(points={{-9,-40},{-24,-40},{-24,-91.2}},                  color={0,0,127}));
  connect(ramp2.y, mill2.classifierSpeed) annotation (Line(points={{-9,-40},{-24,-40},{-24,-117.2}},                   color={0,0,127}));
  connect(burner1.eyeFG, quadrupleGas.eye) annotation (Line(points={{-94,-143.4},{-94,-143},{-190,-143}},  color={190,190,190}));
  connect(burner1.outletFG, burner2.inletFG) annotation (Line(
      points={{-98,-144.2},{-98,-142},{-98,-142},{-98,-138}},
      color={118,106,98},
      thickness=0.5));
  connect(burner1.heat_top, burner2.heat_bottom) annotation (Line(
      points={{-108,-144.2},{-108.2,-144.2},{-108.2,-138}},
      color={167,25,48},
      thickness=0.5));
  connect(mill2.outlet, burner2.inletFuel) annotation (Line(
      points={{-34,-128},{-88,-128},{-88,-128.2}},
      color={118,106,98},
      thickness=0.5));
  connect(burner1.outlet_FTW, burner2.inlet_FTW) annotation (Line(
      points={{-146,-144},{-146,-138}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadrupleGas1.eye, burner2.eyeFG) annotation (Line(points={{-190,-118},{-94,-118},{-94,-117.4}},                color={190,190,190}));
  connect(mill3.outlet, burner3.inletFuel) annotation (Line(
      points={{-34,-102},{-88,-102},{-88,-102.2}},
      color={118,106,98},
      thickness=0.5));
  connect(burner2.outletFG, burner3.inletFG) annotation (Line(
      points={{-98,-118.2},{-98,-112}},
      color={118,106,98},
      thickness=0.5));
  connect(burner2.heat_top, burner3.heat_bottom) annotation (Line(
      points={{-108,-118.2},{-108,-112},{-108.2,-112}},
      color={167,25,48},
      thickness=0.5));
  connect(burner3.eyeFG, quadrupleGas2.eye) annotation (Line(points={{-94,-91.4},{-94,-90},{-154,-90},{-154,-94},{-190,-94}},
                                                                                                                      color={190,190,190}));
  connect(burner2.outlet_FTW, burner3.inlet_FTW) annotation (Line(
      points={{-146,-118},{-146,-112}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(mill4.outlet, burner4.inletFuel) annotation (Line(
      points={{-34,-76},{-88,-76},{-88,-76.2}},
      color={118,106,98},
      thickness=0.5));
  connect(burner3.outletFG, burner4.inletFG) annotation (Line(
      points={{-98,-92.2},{-98,-86},{-98,-86}},
      color={118,106,98},
      thickness=0.5));
  connect(burner3.heat_top, burner4.heat_bottom) annotation (Line(
      points={{-108,-92.2},{-108,-90},{-108.2,-90},{-108.2,-86}},
      color={167,25,48},
      thickness=0.5));
  connect(burner4.eyeFG, quadrupleGas3.eye) annotation (Line(points={{-94,-65.4},{-94,-66},{-190,-66}},               color={190,190,190}));
  connect(burner3.outlet_FTW, burner4.inlet_FTW) annotation (Line(
      points={{-146,-92},{-146,-86}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(burner4.outletFG, flameRoom_evap_1.inletFG) annotation (Line(
      points={{-98,-66.2},{-98,-56}},
      color={118,106,98},
      thickness=0.5));
  connect(burner4.heat_top, flameRoom_evap_1.heat_bottom) annotation (Line(
      points={{-108,-66.2},{-108,-56},{-108.2,-56}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_evap_1.eyeFG, quadrupleGas4.eye) annotation (Line(points={{-94,-35.4},{-94,-36},{-190,-36}},               color={190,190,190}));
  connect(burner4.outlet_FTW, flameRoom_evap_1.inlet_FTW) annotation (Line(
      points={{-146,-66},{-146,-56}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_evap_1.eyeFTW, quadruple37.eye) annotation (Line(points={{-142,-35.6},{-150,-35.6},{-150,-34},{-266,-34}},
                                                                                                                          color={190,190,190}));
  connect(flameRoom_evap_1.outletFG, flameRoom_evap_2.inletFG) annotation (Line(
      points={{-98,-36.2},{-98,-26}},
      color={118,106,98},
      thickness=0.5));
  connect(quadrupleGas5.eye, flameRoom_evap_2.eyeFG) annotation (Line(points={{-190,-6},{-158,-6},{-158,-5.4},{-94,-5.4}},      color={190,190,190}));
  connect(flameRoom_evap_1.heat_top, flameRoom_evap_2.heat_bottom) annotation (Line(
      points={{-108,-36.2},{-108,-26},{-108.2,-26}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_evap_1.outlet_FTW, flameRoom_evap_2.inlet_FTW) annotation (Line(
      points={{-146,-36},{-146,-26}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_evap_2.eyeFTW, quadruple35.eye) annotation (Line(points={{-142,-5.6},{-206,-5.6},{-206,-14},{-266,-14}},
                                                                                                                          color={190,190,190}));
  connect(flameRoom_rh_1.outlet_FTW, flameRoom_eco.inlet_FTW) annotation (Line(
      points={{-146,172},{-146,182}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_eco.outlet_CT, flameRoom_rh_1.inlet_CT) annotation (Line(
      points={{-118,182},{-118,172}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_eco.heat_bottom, flameRoom_rh_1.heat_top) annotation (Line(
      points={{-108.2,182},{-108,182},{-108,171.8}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_eco.inletFG, flameRoom_rh_1.outletFG) annotation (Line(
      points={{-98,182},{-98,171.8}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_3.outlet_FTW, flameRoom_rh_1.inlet_FTW) annotation (Line(
      points={{-146,142},{-146,152}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_3.inlet_CT, flameRoom_rh_1.outlet_CT) annotation (Line(
      points={{-118,142},{-118,152}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_3.heat_top, flameRoom_rh_1.heat_bottom) annotation (Line(
      points={{-108,141.8},{-108,152},{-108.2,152}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_3.outletFG, flameRoom_rh_1.inletFG) annotation (Line(
      points={{-98,141.8},{-98,152}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_eco.outlet_FTW, separator.inlet) annotation (Line(
      points={{-146,202},{-146,230},{-140,230}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple30.eye, flameRoom_eco.eyeFTW) annotation (Line(points={{-216,216},{-142,216},{-142,202.4}},    color={190,190,190}));
  connect(fixedTemperature5.port, flameRoom_eco.heat_top) annotation (Line(points={{-26,262},{-26,201.8},{-108,201.8}},                              color={191,0,0}));
  connect(quadrupleGas12.eye, flameRoom_eco.eyeFG) annotation (Line(points={{-88,232},{-94,232},{-94,202.6}},                color={190,190,190}));
  connect(quadrupleGas11.eye, flameRoom_rh_1.eyeFG) annotation (Line(points={{-190,172},{-94,172},{-94,172.6}},                                color={190,190,190}));
  connect(quadrupleGas10.eye, flameRoom_sh_3.eyeFG) annotation (Line(points={{-190,142},{-94,142},{-94,142.6}},                       color={190,190,190}));
  connect(eco_riser.outlet, flameRoom_eco.inlet_TB) annotation (Line(
      points={{321,-110},{320,-110},{320,197},{-88.2,197}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_eco.outlet_TB, eco_down.inlet) annotation (Line(
      points={{-88,187},{-78,187},{-78,186},{-66,186},{-66,-200},{-65,-200}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple39.eye, flameRoom_eco.eyeTB) annotation (Line(points={{-260,184},{-87.6,184}},                      color={190,190,190}));
  connect(join_HP.outlet1, flameRoom_rh_1.inlet_TB) annotation (Line(
      points={{558,-52},{526,-52},{526,166},{-86,166},{-86,167},{-88.2,167}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_rh_1.outlet_TB, sprayInjector_sh1.inlet1) annotation (Line(
      points={{-88,157},{-24,157},{-24,150}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple32.eye, flameRoom_rh_1.eyeTB) annotation (Line(points={{-260,154},{-87.6,154}},                   color={190,190,190}));
  connect(flameRoom_sh_3.eyeTB, quadruple28.eye) annotation (Line(points={{-87.6,124},{-260,124}},                   color={190,190,190}));
  connect(flameRoom_sh_3.outlet_TB, sprayInjector_sh4.inlet1) annotation (Line(
      points={{-88,127},{24,127},{24,104}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_eco.outletFG, coalSlagFlueGas_split_top.fuelSlagFlueGas_inlet) annotation (Line(
      points={{-98,201.8},{-98,248}},
      color={118,106,98},
      thickness=0.5));
  connect(separator.outlet, flameRoom_eco.inlet_CT) annotation (Line(
      points={{-120,230},{-118,230},{-118,202}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_4.outlet_FTW, flameRoom_rh_2.inlet_FTW) annotation (Line(
      points={{-146,84},{-146,94}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_2.outlet_FTW, flameRoom_sh_4.inlet_FTW) annotation (Line(
      points={{-146,54},{-146,64}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_1.outlet_FTW, flameRoom_sh_2.inlet_FTW) annotation (Line(
      points={{-146,24},{-146,34}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_1.inlet_CT, flameRoom_sh_2.outlet_CT) annotation (Line(
      points={{-118,24},{-118,34}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_2.inlet_CT, flameRoom_sh_4.outlet_CT) annotation (Line(
      points={{-118,54},{-118,64}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_4.inlet_CT, flameRoom_rh_2.outlet_CT) annotation (Line(
      points={{-118,84},{-118,94}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_4.heat_top, flameRoom_rh_2.heat_bottom) annotation (Line(
      points={{-108,83.8},{-108,94},{-108.2,94}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_2.heat_top, flameRoom_sh_4.heat_bottom) annotation (Line(
      points={{-108,53.8},{-108,64},{-108.2,64}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_1.heat_top, flameRoom_sh_2.heat_bottom) annotation (Line(
      points={{-108,23.8},{-108,34},{-108.2,34}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_1.outletFG, flameRoom_sh_2.inletFG) annotation (Line(
      points={{-98,23.8},{-98,34}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_2.outletFG, flameRoom_sh_4.inletFG) annotation (Line(
      points={{-98,53.8},{-98,64}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_4.outletFG, flameRoom_rh_2.inletFG) annotation (Line(
      points={{-98,83.8},{-98,94}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_1.inletFG, flameRoom_evap_2.outletFG) annotation (Line(
      points={{-98,4},{-98,-6.2}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_1.heat_bottom, flameRoom_evap_2.heat_top) annotation (Line(
      points={{-108.2,4},{-108.2,-9},{-108,-9},{-108,-6.2}},
      color={167,25,48},
      thickness=0.5));
  connect(quadruple36.eye, flameRoom_rh_2.eyeFTW) annotation (Line(points={{-260,104},{-198,104},{-198,114.4},{-142,114.4}},
                                                                                                                       color={190,190,190}));
  connect(flameRoom_evap_2.outlet_FTW, flameRoom_sh_1.inlet_FTW) annotation (Line(
      points={{-146,-6},{-146,4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_rh_2.outlet_FTW, flameRoom_sh_3.inlet_FTW) annotation (Line(
      points={{-146,114},{-146,122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_rh_2.inlet_CT, flameRoom_sh_3.outlet_CT) annotation (Line(
      points={{-118,114},{-118,122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_1.eyeCT, quadruple29.eye) annotation (Line(points={{-124,3.6},{-124,-2},{-38,-2}},            color={190,190,190}));
  connect(flameRoom_rh_2.heat_top, flameRoom_sh_3.heat_bottom) annotation (Line(
      points={{-108,113.8},{-108,122},{-108.2,122}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_rh_2.outletFG, flameRoom_sh_3.inletFG) annotation (Line(
      points={{-98,113.8},{-98,122}},
      color={118,106,98},
      thickness=0.5));
  connect(sprayInjector_sh1.outlet, flameRoom_rh_2.inlet_TB) annotation (Line(
      points={{-24,130},{-24,110},{-88.2,110},{-88.2,109}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_rh_2.outlet_TB, rh_pipe.inlet) annotation (Line(
      points={{-88,99},{-12,99},{-12,112},{486,112},{486,184}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh4.outlet, flameRoom_sh_4.inlet_TB) annotation (Line(
      points={{24,84},{24,79},{-88.2,79}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flameRoom_sh_4.outlet_TB, sh_pipe.inlet) annotation (Line(
      points={{-88,69},{58,69},{58,68},{368,68},{368,186}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_4_out_T.port, sh_pipe.inlet) annotation (Line(
      points={{388,184},{378,184},{378,186},{368,186}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh2.outlet, flameRoom_sh_2.inlet_TB) annotation (Line(
      points={{-22,38},{-22,48},{-88.2,48},{-88.2,49}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple27.eye, flameRoom_sh_2.eyeTB) annotation (Line(points={{-266,34},{-154,34},{-154,36},{-87.6,36}}, color={190,190,190}));
  connect(flameRoom_sh_1.outlet_CT, flameRoom_sh_1.inlet_TB) annotation (Line(
      points={{-118,4},{-120,4},{-120,0},{-74,0},{-74,19},{-88.2,19}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple26.eye, flameRoom_sh_1.eyeTB) annotation (Line(points={{-266,6},{-87.6,6}},                  color={190,190,190}));
  connect(flameRoom_sh_1.outlet_TB, sprayInjector_sh2.inlet1) annotation (Line(
      points={{-88,9},{-22,9},{-22,18}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadrupleGas6.eye, flameRoom_sh_1.eyeFG) annotation (Line(points={{-190,24},{-162,24},{-162,24.6},{-94,24.6}}, color={190,190,190}));
  connect(quadrupleGas7.eye, flameRoom_sh_2.eyeFG) annotation (Line(points={{-190,56},{-160,56},{-160,54.6},{-94,54.6}}, color={190,190,190}));
  connect(quadrupleGas8.eye, flameRoom_sh_4.eyeFG) annotation (Line(points={{-190,84},{-160,84},{-160,84.6},{-94,84.6}}, color={190,190,190}));
  connect(quadrupleGas9.eye, flameRoom_rh_2.eyeFG) annotation (Line(points={{-190,114},{-160,114},{-160,114.6},{-94,114.6}}, color={190,190,190}));
  connect(flameRoom_sh_2.outlet_TB, flameRoom_sh_3.inlet_TB) annotation (Line(
      points={{-88,39},{-84,39},{-84,137},{-88.2,137}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedForwardBlock_3508_1.QF_FF_, firstOrder1.u) annotation (Line(points={{-421,-396},{-412.8,-396}}, color={0,0,127}));
  connect(firstOrder1.y, rollerBowlMill_L1_1.rawCoal) annotation (Line(points={{-403.6,-396},{-390.8,-396}}, color={0,0,127}));
  connect(firstOrder1.y, gain.u) annotation (Line(points={{-403.6,-396},{-398,-396},{-398,-364},{182,-364},{182,-238}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-580,-480},{1300,460}}),
                      graphics={
        Rectangle(
          extent={{1198,440},{1240,360}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{1158,440},{1198,360}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{1162,442},{1190,422}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleINIT"),
        Text(
          extent={{1156,402},{1196,382}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleSettings"),
        Text(
          extent={{1200,422},{1234,404}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Model
Properties"),                     Text(
          extent={{-578,438},{-382,374}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=5,
          textString="______________________________________________________________________________________________
PURPOSE:
Example of a steam cycle of a 580 MW hard coal power plant. It has a single reheat, one HP preheater and four LP preheaters.
This model uses the same steam cycle as in example SteamCycle_01 but a more complex boiler model which features gas and particle radiation.
Initial and nominal values are computed with help of the static cycle package. 
Levels of preheaters and condenser are controlled by simple PI-controllers, the heating power and feedwater pump power is set by a feed forward block.
Models provide information for automatic efficiency calculation within SimCenter-model.
______________________________________________________________________________________________
"),                   Text(
          extent={{-578,348},{-378,330}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=5,
          textString="______________________________________________________________________________________________
Scenario:  
Two successive load reductions to 70 percent load at t=2500s and t=6100s with a length of 30 minutes each.
______________________________________________________________________________________________
")}),
    experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true)),
    __Dymola_experimentFlags(
    Hidden(SmallerDAEIncidence=false)));
end SteamPowerPlant_CombinedComponents_01;
