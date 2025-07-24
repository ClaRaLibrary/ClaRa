within ClaRa.Examples;
model SteamPowerPlant_01 "A steam power plant model based on SteamCycle_02 with a detailed boiler model (coal dust fired Benson boiler) without controls"
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
    extends ClaRa.Basics.Icons.PackageIcons.ExecutableRegressiong100;

   import Modelica.Utilities.Files.loadResource;
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

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
    energyType=1)         annotation (Placement(transformation(extent={{-244,-106},{-224,-86}})));

  ClaRa.Components.Adapters.FuelSlagFlueGas_split             coalSlagFlueGas_split_top
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-134,222})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_Tm_flow slagFlowSource_top(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-192,248})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi coalSink_top(T_const=658.15, xi_const={0.84,0.07})             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-166,236})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink_top(                T_const=658.15,
    xi_const={0.00488,0.00013,0.21147,0.00155,0.70952,0.03784,0,0.00347,0},
    p_const(displayUnit="bar") = 99000)                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-328,58})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner1(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{-244,-158},{-224,-138}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-154})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner2(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{-244,-132},{-224,-112}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-128})));
  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner1(
    T_slag=600 + 273.15,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        height_fill=-1,
        width=14.576,
        z_out={18.5},
        z_in={11.318},
        height=abs(burner1.geo.z_out[1] - burner1.geo.z_in[1]),
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    Tau=0.01,
    T_top_initial=INIT.brnr2.T_fg_out,
    T_start_flueGas_out=INIT.brnr1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=136,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    slagTemperature_calculationType=2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 101000)                                   annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-118,-154})));

  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner2(
    T_slag=burner1.T_slag,
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        height_fill=-1,
        width=14.576,
        z_in={burner1.geo.z_out[1]},
        z_out={24},
        height=burner2.geo.z_out[1] - burner2.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    Tau=0.01,
    T_start_flueGas_out=INIT.brnr2.T_fg_out,
    T_top_initial=INIT.brnr3.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=274,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    slagTemperature_calculationType=2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100950)                                   annotation (Placement(transformation(
        extent={{-30,-10.0001},{30,10}},
        rotation=0,
        origin={-118,-128})));

  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner3(
    T_slag=burner1.T_slag,
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        height_fill=-1,
        width=14.576,
        z_in={burner2.geo.z_out[1]},
        z_out={29.5},
        height=burner3.geo.z_out[1] - burner3.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    Tau=0.01,
    T_start_flueGas_out=INIT.brnr3.T_fg_out,
    T_top_initial=INIT.brnr4.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=412,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    slagTemperature_calculationType=2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100900)                                   annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-118,-102})));

  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-102})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoom_L2_Dynamic flameRoom_evap_1(
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (
        suspension_calculationType="Calculated",
        diameter_mean_coke=40e-6,
        Q_mean_abs_coke=0.65),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        height_fill=-1,
        width=14.576,
        z_in={burner4.geo.z_out[1]},
        z_out={41.334},
        height=flameRoom_evap_1.geo.z_out[1] - flameRoom_evap_1.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.2),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (w_initial=15),
    Tau=0.01,
    T_start_flueGas_out=INIT.evap_rad.T_fg_out,
    T_top_initial=INIT.evap_rad.T_fg_out - 50,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        diameter_mean_coke=40e-6,
        Q_mean_abs_coke=0.65,
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100800) annotation (Placement(transformation(extent={{-148,-60},{-88,-40}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_rh_2(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    Tau=0.01,
    T_start_flueGas_out=INIT.rh2.T_fg_out - 260,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model HeatTransfer_TubeBundle =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        temperatureDifference="Logarithmic mean - smoothed",
        suspension_calculationType="Calculated",
        CF_fouling=0.9),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_sh_4.geo.z_out[1]},
        z_out={71.45},
        height_fill=-1,
        width=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        tubeOrientation=0,
        height=flameRoom_rh_2.geo.z_out[1] - flameRoom_rh_2.geo.z_in[1],
        length=14.576,
        diameter_t=rh_2_wall.diameter_o,
        N_tubes=rh_2.N_tubes,
        N_passes=rh_2.N_passes,
        N_rows=32),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100400)                                                    annotation (Placement(transformation(extent={{-148,76},{-88,96}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature5(T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-84,206})));

  ClaRa.Components.Furnace.Burner.Burner_L2_Dynamic burner4(
    T_slag=burner1.T_slag,
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        height_fill=-1,
        width=14.576,
        z_in={burner3.geo.z_out[1]},
        z_out={35},
        height=burner4.geo.z_out[1] - burner4.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=0.5),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    Tau=0.01,
    T_start_flueGas_out=INIT.brnr4.T_fg_out,
    T_top_initial=INIT.evap_rad.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    slagTemperature_calculationType=2,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100850)                                   annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-118,-76})));

  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_burner4(
    m_flow_const=42/4,
    xi_const={0.84,0.07},
    variable_m_flow=true,
    energyType=1)         annotation (Placement(transformation(extent={{-244,-80},{-224,-60}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,-76})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-134,-206})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_bottom(
    m_flow_const=6.5,
    T_const=283.15,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    variable_m_flow=false)                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-108,-244})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_bottom(
    m_flow_const=0,
    T_const=293.15,
    variable_m_flow=false,
    xi_const={0.84,0.07})
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-158,-244})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT slaglSink_bottom(T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-134,-244})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow      boilerLosses(Q_flow(displayUnit="MW") = 0)
                                                                                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-90,-200})));
  ClaRa.Components.Furnace.FlameRoom.FlameRoom_L2_Dynamic flameRoom_evap_2(
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        height_fill=-1,
        width=14.576,
        z_in={flameRoom_evap_1.geo.z_out[1]},
        z_out={56.342},
        height=flameRoom_evap_2.geo.z_out[1] - flameRoom_evap_2.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime (Tau_burn_const=1.2),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed (w_initial=15),
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    Tau=0.01,
    T_start_flueGas_out=INIT.evap_rad.T_fg_out - 50,
    T_top_initial=INIT.sh1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (
        suspension_calculationType="Calculated",
        diameter_mean_coke=40e-6,
        Q_mean_abs_coke=0.65,
        emissivity_wall=emissivity_wall,
        CF_fouling=CF_fouling_rad_glob),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=50),
    p_start_flueGas_out(displayUnit="bar") = 100750)                                   annotation (Placement(transformation(extent={{-148,-34},{-88,-14}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_1(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    Tau=0.01,
    T_start_flueGas_out=INIT.sh1.T_fg_out - 100,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_evap_2.geo.z_out[1]},
        z_out={59.36},
        height_fill=-1,
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_sh_1.geo.z_out[1] - flameRoom_sh_1.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=sh_1_wall.diameter_o,
        N_tubes=sh_1.N_tubes,
        N_passes=sh_1.N_passes),
    redeclare model HeatTransfer_TubeBundle =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        suspension_calculationType="Calculated",
        temperatureDifference="Logarithmic mean - smoothed",
        CF_fouling=0.55),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100700)                                                    annotation (Placement(transformation(extent={{-148,-8},{-88,12}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_2(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    Tau=0.01,
    T_start_flueGas_out=INIT.sh2.T_fg_out - 200,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_sh_1.geo.z_out[1]},
        z_out={63.91},
        height_fill=-1,
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_sh_2.geo.z_out[1] - flameRoom_sh_2.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=sh_2_wall.diameter_o,
        N_tubes=sh_2.N_tubes,
        N_passes=sh_2.N_passes),
    redeclare model HeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                      suspension_calculationType="Calculated", CF_fouling=0.55),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100600)                                   annotation (Placement(transformation(extent={{-148,20},{-88,40}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_4(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    Tau=0.01,
    T_start_flueGas_out=INIT.sh4.T_fg_out - 250,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_sh_2.geo.z_out[1]},
        z_out={67.89},
        height_fill=-1,
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_sh_4.geo.z_out[1] - flameRoom_sh_4.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=sh_4_wall.diameter_o,
        N_tubes=sh_4.N_tubes,
        N_passes=sh_4.N_passes),
    redeclare model HeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (                                      suspension_calculationType="Calculated", CF_fouling=0.6),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100500)                                                    annotation (Placement(transformation(extent={{-148,48},{-88,68}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_sh_3(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    Tau=0.01,
    T_start_flueGas_out=INIT.sh3.T_fg_out - 200,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_rh_2.geo.z_out[1]},
        z_out={75.18},
        height_fill=-1,
        width=14.576,
        tubeOrientation=0,
        height=flameRoom_sh_3.geo.z_out[1] - flameRoom_sh_3.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        diameter_t=sh_3_wall.diameter_o,
        N_tubes=sh_3.N_tubes,
        N_passes=sh_3.N_passes),
    redeclare model HeatTransfer_TubeBundle =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2 (
        temperatureDifference="Logarithmic mean - smoothed",
        suspension_calculationType="Calculated",
        CF_fouling=0.65),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100300)                                                   annotation (Placement(transformation(extent={{-148,104},{-88,124}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_rh_1(
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    T_start_flueGas_out=INIT.rh1.T_fg_out,
    Tau=0.01,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (CF_fouling=CF_fouling_glob, alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_sh_3.geo.z_out[1]},
        z_out={82.9},
        height_fill=-1,
        width=14.576,
        tubeOrientation=0,
        diameter_t=rh_1_wall.diameter_o,
        height=flameRoom_rh_1.geo.z_out[1] - flameRoom_rh_1.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_tubes=rh_1.N_tubes,
        N_passes=rh_1.N_passes,
        N_rows=50),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100200)                                    annotation (Placement(transformation(extent={{-148,132},{-88,152}})));

  ClaRa.Components.Furnace.FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoom_eco(
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10),
    T_start_flueGas_out=INIT.eco.T_fg_out,
    Tau=0.01,
    redeclare model HeatTransfer_CarrierTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=30, temperatureDifference="Inlet"),
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    m_flow_nom=550,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
        temperatureDifference="Inlet",
        CF_fouling=CF_fouling_glob,
        alpha_nom=alpha_wall),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes (
        z_in={flameRoom_rh_1.geo.z_out[1]},
        z_out={85.6},
        height_fill=-1,
        width=14.576,
        diameter_t=eco_wall.diameter_o,
        height=flameRoom_eco.geo.z_out[1] - flameRoom_eco.geo.z_in[1],
        length=14.576,
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical,
        N_tubes=eco.N_tubes,
        N_passes=eco.N_passes,
        N_rows=30,
        tubeOrientation=0),
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    p_start_flueGas_out(displayUnit="bar") = 100100)                                   annotation (Placement(transformation(extent={{-148,160},{-88,180}})));

  ClaRa.Components.Furnace.Hopper.Hopper_L2 hopper(
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2 (suspension_calculationType="Calculated"),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        height_fill=-1,
        width=14.576,
        length=14.576,
        height=abs(hopper.geo.z_out[1] - hopper.geo.z_in[1]),
        z_out={burner1.geo.z_in[1]},
        z_in={4.03},
        flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.vertical),
    T_slag=600 + 273.15,
    m_flow_nom=1000,
    Tau=0.01,
    T_start_flueGas_out=INIT.brnr4.T_fg_out - 500,
    T_top_initial=INIT.brnr1.T_fg_out,
    xi_start_flueGas_out=INIT.eco.xi_fg_out,
    redeclare model HeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2 (suspension_calculationType="Calculated", CF_fouling=CF_fouling_rad_glob),
    p_start_flueGas_out(displayUnit="bar") = 100980)
                         annotation (Placement(transformation(extent={{-150,-188},{-90,-168}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_1_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=evap_1.N_cv,
    length=evap_1.length,
    diameter_i=evap_1.diameter_i,
    diameter_o=0.038,
    N_tubes=evap_1.N_tubes,
    suppressChattering="False",
    Delta_x={abs(burner1.geo.z_out[1] - burner1.geo.z_in[1]),abs(burner2.geo.z_out[1] - burner2.geo.z_in[1]),abs(
        burner3.geo.z_out[1] - burner3.geo.z_in[1]),abs(burner4.geo.z_out[1] - burner4.geo.z_in[1]),abs(
        flameRoom_evap_1.geo.z_out[1] - flameRoom_evap_1.geo.z_in[1])},
    T_start={INIT.brnr1.T_vle_wall_out,INIT.brnr2.T_vle_wall_out,INIT.brnr3.T_vle_wall_out,INIT.brnr4.T_vle_wall_out,
        INIT.evap_rad.T_vle_wall_out},
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-13.9999,-4.99995},{13.9998,4.99995}},
        rotation=90,
        origin={107,-120})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple evap_1(
    N_cv=5,
    z_in=burner1.geo.z_in[1],
    z_out=flameRoom_evap_1.geo.z_out[1],
    diameter_i=0.0268,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    Delta_x={abs(burner1.geo.z_out[1] - burner1.geo.z_in[1]),abs(burner2.geo.z_out[1] - burner2.geo.z_in[1]),abs(burner3.geo.z_out[1] - burner3.geo.z_in[1]),abs(burner4.geo.z_out[1] - burner4.geo.z_in[1]),abs(flameRoom_evap_1.geo.z_out[1] - flameRoom_evap_1.geo.z_in[1])},
    useHomotopy=true,
    initOption=0,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    frictionAtInlet=true,
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom=(NOM.brnr1.Delta_p_vle_wall_nom/2 + NOM.brnr2.Delta_p_vle_wall_nom + NOM.brnr3.Delta_p_vle_wall_nom + NOM.brnr4.Delta_p_vle_wall_nom + NOM.evap_rad.Delta_p_vle_wall_nom/2),
    p_nom={(NOM.brnr1.p_vle_wall_out + NOM.eco_down.p_out)/2,NOM.brnr2.p_vle_wall_out,NOM.brnr3.p_vle_wall_out,NOM.brnr4.p_vle_wall_out,(NOM.brnr4.p_vle_wall_out + NOM.evap_rad.p_vle_wall_out)/2},
    h_nom={(NOM.brnr1.h_vle_wall_out + NOM.eco_down.h_in)/2,NOM.brnr2.h_vle_wall_out,NOM.brnr3.h_vle_wall_out,NOM.brnr4.h_vle_wall_out,(NOM.brnr4.h_vle_wall_out + NOM.evap_rad.h_vle_wall_out)/2},
    h_start={(INIT.brnr1.h_vle_wall_out + INIT.eco_down.h_in)/2,INIT.brnr2.h_vle_wall_out,INIT.brnr3.h_vle_wall_out,INIT.brnr4.h_vle_wall_out,(INIT.brnr4.h_vle_wall_out + INIT.evap_rad.h_vle_wall_out)/2},
    p_start={(INIT.brnr1.p_vle_wall_out + INIT.eco_down.p_out)/2,INIT.brnr2.p_vle_wall_out,INIT.brnr3.p_vle_wall_out,INIT.brnr4.p_vle_wall_out,(INIT.brnr4.p_vle_wall_out + INIT.evap_rad.p_vle_wall_out)/2},
    N_tubes=330,
    showData=true,
    contributeToCycleSummary=false,
    length=flameRoom_evap_1.geo.z_out[1] - burner1.geo.z_in[1])
                 annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={123,-120})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_2_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=evap_2.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_2.length,
        evap_2.N_cv),
    diameter_i=evap_2.diameter_i,
    length=evap_2.length,
    N_tubes=evap_2.N_tubes,
    diameter_o=0.0424,
    suppressChattering="False",
    T_start=linspace(
        (INIT.brnr4.T_vle_wall_out + INIT.evap_rad.T_vle_wall_out)/2,
        INIT.evap_rad.T_vle_wall_out,
        evap_2.N_cv),
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99996},{14,4.99998}},
        rotation=90,
        origin={105,-24})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple evap_2(
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_2.length,
        evap_2.N_cv),
    diameter_i=0.0298,
    z_in=flameRoom_evap_2.geo.z_in[1],
    z_out=flameRoom_evap_2.geo.z_out[1],
    N_tubes=evap_1.N_tubes,
    N_cv=4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    useHomotopy=true,
    initOption=0,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    frictionAtInlet=true,
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom=NOM.evap_rad.Delta_p_vle_wall_nom/2,
    h_start=linspace(
        (INIT.brnr4.h_vle_wall_out + INIT.evap_rad.h_vle_wall_out)/2,
        INIT.evap_rad.h_vle_wall_out,
        evap_2.N_cv),
    p_start=linspace(
        (INIT.brnr4.p_vle_wall_out + INIT.evap_rad.p_vle_wall_out)/2,
        INIT.evap_rad.p_vle_wall_out,
        evap_2.N_cv),
    p_nom=linspace(
        (NOM.brnr4.p_vle_wall_out + NOM.evap_rad.p_vle_wall_out)/2,
        NOM.evap_rad.p_vle_wall_out,
        evap_2.N_cv),
    h_nom=linspace(
        (NOM.brnr4.h_vle_wall_out + NOM.evap_rad.h_vle_wall_out)/2,
        NOM.evap_rad.h_vle_wall_out,
        evap_2.N_cv),
    length=46,
    showData=true,
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={123,-24})));

  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(
    length=evap_2.length,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_2.length,
        evap_2.N_cv),
    N=4,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{52,-34},{72,-14}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_3_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=evap_3.N_cv,
    diameter_i=evap_3.diameter_i,
    length=evap_3.length,
    N_tubes=evap_3.N_tubes,
    diameter_o=0.0318,
    suppressChattering="False",
    Delta_x={flameRoom_sh_1.geo.height,flameRoom_sh_2.geo.height,flameRoom_sh_4.geo.height,flameRoom_rh_2.geo.height},
    T_start={INIT.sh1.T_vle_wall_out,INIT.sh2.T_vle_wall_out,INIT.sh4.T_vle_wall_out,INIT.rh2.T_vle_wall_out},
    stateLocation=2,
    initOption=213)
    annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={107,40})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple evap_3(
    N_cv=4,
    diameter_i=0.0206,
    z_in=flameRoom_sh_1.geo.z_in[1],
    z_out=flameRoom_rh_2.geo.z_out[1],
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    Delta_x={flameRoom_sh_1.geo.height,flameRoom_sh_2.geo.height,flameRoom_sh_4.geo.height,flameRoom_rh_2.geo.height},
    useHomotopy=true,
    initOption=0,
    length=flameRoom_rh_2.geo.z_out[1] - flameRoom_sh_1.geo.z_in[1],
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    frictionAtInlet=true,
    p_nom={NOM.sh1.p_vle_wall_out,NOM.sh2.p_vle_wall_out,NOM.sh4.p_vle_wall_out,NOM.rh2.p_vle_wall_out},
    h_nom={NOM.sh1.h_vle_wall_out,NOM.sh2.h_vle_wall_out,NOM.sh4.h_vle_wall_out,NOM.rh2.h_vle_wall_out},
    h_start={INIT.sh1.h_vle_wall_out,INIT.sh2.h_vle_wall_out,INIT.sh4.h_vle_wall_out,INIT.rh2.h_vle_wall_out},
    p_start={INIT.sh1.p_vle_wall_out,INIT.sh2.p_vle_wall_out,INIT.sh4.p_vle_wall_out,INIT.rh2.p_vle_wall_out},
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom=(NOM.sh1.Delta_p_vle_wall + NOM.sh2.Delta_p_vle_wall + NOM.sh4.Delta_p_vle_wall + NOM.rh2.Delta_p_vle_wall),
    N_tubes=970,
    showData=true,
    contributeToCycleSummary=false)
                           "former length: 14.618"
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={123,40})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_4_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=evap_4.N_cv,
    diameter_o=0.0424,
    diameter_i=evap_4.diameter_i,
    N_tubes=evap_4.N_tubes,
    suppressChattering="False",
    T_start={INIT.sh3.T_vle_wall_out,INIT.rh1.T_vle_wall_out,INIT.eco.T_vle_wall_out},
    stateLocation=2,
    length=evap_4.length*evap_4.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_4_wall.length,
        evap_4.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99998},{13.9999,4.99998}},
        rotation=90,
        origin={109,142})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple evap_4(
    diameter_i=0.0298,
    z_in=flameRoom_sh_3.geo.z_in[1],
    z_out=flameRoom_eco.geo.z_out[1],
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    N_cv=3,
    Delta_x={flameRoom_sh_3.geo.height,flameRoom_rh_1.geo.height,flameRoom_eco.geo.height},
    useHomotopy=true,
    initOption=0,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtInlet=true,
    h_nom={NOM.sh3.h_vle_wall_out,NOM.rh1.h_vle_wall_out,NOM.eco.h_vle_wall_out},
    p_nom={NOM.sh3.p_vle_wall_out,NOM.rh1.p_vle_wall_out,NOM.eco.p_vle_wall_out},
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    h_start={INIT.sh3.h_vle_wall_out,INIT.rh1.h_vle_wall_out,INIT.eco.h_vle_wall_out},
    p_start={INIT.sh3.p_vle_wall_out,INIT.rh1.p_vle_wall_out,INIT.eco.p_vle_wall_out},
    Delta_p_nom=(NOM.sh3.Delta_p_vle_wall + NOM.rh1.Delta_p_vle_wall + NOM.eco.Delta_p_vle_wall),
    showData=true,
    N_tubes=500,
    contributeToCycleSummary=false,
    length=flameRoom_eco.geo.z_out[1] - flameRoom_sh_3.geo.z_in[1])
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={123,142})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_1_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=sh_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_1.length,
        sh_1.N_cv),
    diameter_i=sh_1.diameter_i,
    N_tubes=sh_1.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh1.T_vle_bundle_in,
        INIT.sh1.T_vle_bundle_out,
        sh_1.N_cv),
    stateLocation=2,
    length=sh_1.length*sh_1.N_passes,
    diameter_o=0.0345,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={349,-82})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple sh_1(
    N_cv=5,
    diameter_i=0.0269,
    z_in=flameRoom_sh_1.geo.z_out[1],
    z_out=flameRoom_sh_1.geo.z_in[1],
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_1.length,
        sh_1.N_cv),
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nom=linspace(
        NOM.sh1.p_vle_bundle_in,
        NOM.sh1.p_vle_bundle_out,
        sh_1.N_cv),
    m_flow_nom=NOM.sh1.m_flow_vle_bundle,
    Delta_p_nom=NOM.sh1.Delta_p_vle_bundle_nom,
    h_start=linspace(
        INIT.sh1.h_vle_bundle_in,
        INIT.sh1.h_vle_bundle_out,
        sh_1.N_cv),
    p_start=linspace(
        INIT.sh1.p_vle_bundle_in,
        INIT.sh1.p_vle_bundle_out,
        sh_1.N_cv),
    h_nom=linspace(
        NOM.sh1.h_vle_bundle_in,
        NOM.sh1.h_vle_bundle_out,
        sh_1.N_cv),
    frictionAtOutlet=true,
    showData=true,
    length=12,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    N_tubes=300,
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={370,-82})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort1(
    length=sh_1.length,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_1.length,
        sh_1.N_cv),
    N=sh_1.N_cv,
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{304,-92},{324,-72}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_2_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=sh_2.N_cv,
    diameter_i=sh_2.diameter_i,
    N_tubes=sh_2.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh2.T_vle_bundle_in,
        INIT.sh2.T_vle_bundle_out,
        sh_2.N_cv),
    stateLocation=2,
    length=sh_2.length*sh_2.N_passes,
    diameter_o=0.0345,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_2_wall.length,
        sh_2.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={353,20})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple sh_2(
    N_cv=5,
    diameter_i=0.0269,
    z_in=flameRoom_sh_2.geo.z_out[1],
    z_out=flameRoom_sh_2.geo.z_in[1],
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    p_nom=linspace(
        NOM.sh2.p_vle_bundle_in,
        NOM.sh2.p_vle_bundle_out,
        sh_2.N_cv),
    m_flow_nom=NOM.sh2.m_flow_vle_bundle,
    Delta_p_nom=NOM.sh2.Delta_p_vle_bundle_nom,
    h_start=linspace(
        INIT.sh2.h_vle_bundle_in,
        INIT.sh2.h_vle_bundle_out,
        sh_2.N_cv),
    p_start=linspace(
        INIT.sh2.p_vle_bundle_in,
        INIT.sh2.p_vle_bundle_out,
        sh_2.N_cv),
    h_nom=linspace(
        NOM.sh2.h_vle_bundle_in,
        NOM.sh2.h_vle_bundle_out,
        sh_2.N_cv),
    showData=true,
    length=15,
    N_passes=2,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    N_tubes=250,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_2.length*sh_2.N_passes,
        sh_2.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={372,20})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort8(
    length=sh_2.length,
    N=sh_2.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_2.length,
        sh_2.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{308,10},{328,30}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_3_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=sh_3.N_cv,
    diameter_i=sh_3.diameter_i,
    N_tubes=sh_3.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh3.T_vle_bundle_in,
        INIT.sh3.T_vle_bundle_out,
        sh_3.N_cv),
    stateLocation=2,
    length=sh_3.length*sh_3.N_passes,
    diameter_o=0.0300,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_3_wall.length,
        sh_1.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={353,104})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple sh_3(
    N_cv=5,
    diameter_i=0.0268,
    z_in=flameRoom_sh_3.geo.z_out[1],
    z_out=flameRoom_sh_3.geo.z_in[1],
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nom=linspace(
        NOM.sh3.p_vle_bundle_in,
        NOM.sh3.p_vle_bundle_out,
        sh_3.N_cv),
    h_nom=linspace(
        NOM.sh3.h_vle_bundle_in,
        NOM.sh3.h_vle_bundle_out,
        sh_3.N_cv),
    m_flow_nom=NOM.sh3.m_flow_vle_bundle,
    Delta_p_nom=NOM.sh3.Delta_p_vle_bundle_nom,
    h_start=linspace(
        INIT.sh3.h_vle_bundle_in,
        INIT.sh3.h_vle_bundle_out,
        sh_3.N_cv),
    p_start=linspace(
        INIT.sh3.p_vle_bundle_in,
        INIT.sh3.p_vle_bundle_out,
        sh_3.N_cv),
    frictionAtOutlet=true,
    showData=true,
    N_tubes=500,
    length=15,
    N_passes=2,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_3.length*sh_3.N_passes,
        sh_3.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={370,104})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort9(
    length=sh_3.length,
    N=sh_3.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_3.length,
        sh_3.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{306,94},{326,114}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_4_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=sh_4.N_cv,
    diameter_i=sh_4.diameter_i,
    N_tubes=sh_4.N_tubes,
    diameter_o=0.038,
    suppressChattering="False",
    T_start=linspace(
        INIT.sh4.T_vle_bundle_in,
        INIT.sh4.T_vle_bundle_out,
        sh_4.N_cv),
    stateLocation=2,
    length=sh_4.length*sh_4.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_4_wall.length,
        sh_4.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99999},{14,5.00002}},
        rotation=90,
        origin={346,216})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple sh_4(
    N_cv=5,
    diameter_i=0.0238,
    z_in=flameRoom_sh_4.geo.z_out[1],
    z_out=flameRoom_sh_4.geo.z_in[1],
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    p_nom=linspace(
        NOM.sh4.p_vle_bundle_in,
        NOM.sh4.p_vle_bundle_out,
        sh_4.N_cv),
    h_nom=linspace(
        NOM.sh4.h_vle_bundle_in,
        NOM.sh4.h_vle_bundle_out,
        sh_4.N_cv),
    h_start=linspace(
        INIT.sh4.h_vle_bundle_in,
        INIT.sh4.h_vle_bundle_out,
        sh_4.N_cv),
    p_start=linspace(
        INIT.sh4.p_vle_bundle_in,
        INIT.sh4.p_vle_bundle_out,
        sh_4.N_cv),
    m_flow_nom=NOM.sh4.m_flow_vle_bundle,
    Delta_p_nom=NOM.sh4.Delta_p_vle_bundle_nom,
    length=15,
    N_passes=2,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    N_tubes=530,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_4.length*sh_4.N_passes,
        sh_4.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={370,216})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort10(
    length=sh_4.length,
    N=sh_4.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        sh_4.length,
        sh_4.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{302,206},{322,226}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 eco_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=eco.N_cv,
    diameter_i=eco.diameter_i,
    N_tubes=eco.N_tubes,
    diameter_o=0.0424,
    suppressChattering="False",
    T_start=linspace(
        INIT.eco.T_vle_bundle_in,
        INIT.eco.T_vle_bundle_out,
        eco.N_cv),
    stateLocation=2,
    length=eco.length*eco.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_wall.length,
        eco.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5.0001},{14,5.0001}},
        rotation=90,
        origin={94.9999,-298})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple eco(
    N_cv=5,
    z_in=flameRoom_eco.geo.z_out[1],
    z_out=flameRoom_eco.geo.z_in[1],
    diameter_i=0.0334,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    h_nom=linspace(
        NOM.eco.h_vle_bundle_in,
        NOM.eco.h_vle_bundle_out,
        eco.N_cv),
    p_nom=linspace(
        NOM.eco.p_vle_bundle_in,
        NOM.eco.p_vle_bundle_out,
        eco.N_cv),
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    Delta_p_nom=NOM.eco.Delta_p_vle_bundle_nom,
    p_start=linspace(
        INIT.eco.p_vle_bundle_in,
        INIT.eco.p_vle_bundle_out,
        eco.N_cv),
    h_start=linspace(
        INIT.eco.h_vle_bundle_in,
        INIT.eco.h_vle_bundle_out,
        eco.N_cv),
    useHomotopy=true,
    N_tubes=250,
    frictionAtOutlet=true,
    showData=true,
    length=15,
    N_passes=6,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco.length*eco.N_passes,
        eco.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={123,-298})));

  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort13(
    length=eco.length,
    N=eco.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco.length,
        eco.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{54,-308},{74,-288}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 rh_1_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=rh_1.N_cv,
    diameter_o=0.051,
    diameter_i=rh_1.diameter_i,
    N_tubes=rh_1.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.rh1.T_vle_bundle_in,
        INIT.rh1.T_vle_bundle_out,
        rh_1.N_cv),
    stateLocation=2,
    length=rh_1.length*rh_1.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_1_wall.length,
        rh_1.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-5.00007},{14,5.00007}},
        rotation=90,
        origin={577,-2})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple rh_1(
    N_cv=5,
    diameter_i=0.0413,
    z_in=flameRoom_rh_1.geo.z_out[1],
    z_out=flameRoom_rh_1.geo.z_in[1],
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    m_flow_nom=NOM.m_flow_nom - NOM.preheater_HP_m_flow_tap,
    Delta_p_nom=NOM.rh1.Delta_p_vle_wall_nom,
    p_nom=linspace(
        NOM.rh1.p_vle_bundle_in,
        NOM.rh1.p_vle_bundle_out,
        rh_1.N_cv),
    h_nom=linspace(
        NOM.rh1.h_vle_bundle_in,
        NOM.rh1.h_vle_bundle_out,
        rh_1.N_cv),
    h_start=linspace(
        INIT.rh1.h_vle_bundle_in,
        INIT.rh1.h_vle_bundle_out,
        rh_1.N_cv),
    p_start=linspace(
        INIT.rh1.p_vle_bundle_in,
        INIT.rh1.p_vle_bundle_out,
        rh_1.N_cv),
    frictionAtOutlet=true,
    showData=true,
    length=15.3,
    N_passes=6,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    N_tubes=420,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_1.length*rh_1.N_passes,
        rh_1.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={596,-2})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort11(
    length=rh_1.length,
    N=rh_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_1.length,
        rh_1.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{534,-12},{554,8}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 rh_2_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=rh_2.N_cv,
    diameter_o=0.051,
    diameter_i=rh_2.diameter_i,
    N_tubes=rh_2.N_tubes,
    suppressChattering="False",
    T_start=linspace(
        INIT.rh2.T_vle_bundle_in,
        INIT.rh2.T_vle_bundle_out,
        rh_1.N_cv),
    stateLocation=2,
    length=rh_2.length*rh_2.N_passes,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_2_wall.length,
        rh_2.N_cv),
    initOption=213) annotation (Placement(transformation(
        extent={{-13.9999,-4.99997},{13.9999,4.99993}},
        rotation=90,
        origin={575,124})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple rh_2(
    N_cv=5,
    diameter_i=0.0397,
    z_in=flameRoom_rh_2.geo.z_in[1],
    z_out=flameRoom_rh_2.geo.z_out[1],
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    m_flow_nom=NOM.m_flow_nom - NOM.preheater_HP_m_flow_tap,
    Delta_p_nom=NOM.rh2.Delta_p_vle_wall_nom,
    p_nom=linspace(
        NOM.rh2.p_vle_bundle_in,
        NOM.rh2.p_vle_bundle_out,
        rh_1.N_cv),
    h_nom=linspace(
        NOM.rh2.h_vle_bundle_in,
        NOM.rh2.h_vle_bundle_out,
        rh_1.N_cv),
    h_start=linspace(
        INIT.rh2.h_vle_bundle_in,
        INIT.rh2.h_vle_bundle_out,
        rh_1.N_cv),
    N_tubes=800,
    p_start=linspace(
        INIT.rh2.p_vle_bundle_in,
        INIT.rh2.p_vle_bundle_out,
        rh_1.N_cv),
    length=15,
    N_passes=2,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    contributeToCycleSummary=false,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_2.length*rh_2.N_passes,
        rh_2.N_cv))
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={596,124})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort12(
    length=rh_2.length,
    N=rh_2.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        rh_2.length,
        rh_2.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{524,114},{544,134}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T
                                       sh_4_out_T(unitOption=2)
    annotation (Placement(transformation(extent={{376,230},{396,252}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 evap_0_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    diameter_o=0.038,
    N_ax=evap_0.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_0.length,
        evap_0.N_cv),
    diameter_i=evap_0.diameter_i,
    length=evap_0.length,
    N_tubes=evap_0.N_tubes,
    suppressChattering="False",
    T_start=ones(evap_0.N_cv)*(INIT.brnr1.T_vle_wall_in),
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(
        extent={{-14,-4.99981},{14,4.99977}},
        rotation=90,
        origin={97.0002,-180})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple evap_0(
    diameter_i=0.0268,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=100000),
    N_cv=4,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_0.length,
        evap_0.N_cv),
    N_tubes=970,
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    length=hopper.geo.z_out[1] - hopper.geo.z_in[1],
    z_in=hopper.geo.z_in[1],
    z_out=hopper.geo.z_out[1],
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    Delta_p_nom=NOM.brnr1.Delta_p_vle_wall_nom/2,
    p_nom=linspace(
        NOM.eco_down.p_out,
        NOM.eco_down.p_out + NOM.brnr1.Delta_p_vle_wall_nom/2,
        evap_0.N_cv),
    h_nom=linspace(
        NOM.eco_down.h_in,
        (NOM.eco_down.h_in + NOM.brnr1.h_vle_wall_out)/2,
        evap_0.N_cv),
    h_start=linspace(
        INIT.eco_down.h_in,
        (INIT.eco_down.h_in + INIT.brnr1.h_vle_wall_out)/2,
        evap_0.N_cv),
    p_start=linspace(
        INIT.eco_down.p_out,
        INIT.eco_down.p_out - INIT.brnr1.Delta_p_vle/2,
        evap_0.N_cv),
    m_flow_nom=NOM.eco.m_flow_vle_wall_in,
    showData=true,
    contributeToCycleSummary=false)
                               "zin/zout changed to hopper from burner1 in/flameroom out"
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={123,-180})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort2(
    length=evap_0.length,
    N=evap_0.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        evap_0.length,
        evap_0.N_cv),
    equalityMode="Equal Temperatures") annotation (Placement(transformation(extent={{48,-190},{68,-170}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 ct_1_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
    N_ax=ct_1.N_cv,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        ct_1.length,
        ct_1.N_cv),
    diameter_i=ct_1.diameter_i,
    N_tubes=ct_1.N_tubes,
    diameter_o=0.0445,
    suppressChattering="False",
    T_start=linspace(
        INIT.ct.T_vle_wall_in,
        INIT.ct.T_vle_wall_out,
        ct_1.N_cv),
    stateLocation=2,
    length=ct_1.length*ct_1.N_passes,
    initOption=213) annotation (Placement(transformation(
        extent={{14,-4.99999},{-14,5}},
        rotation=90,
        origin={209,78})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple ct_1(
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        ct_1.length,
        ct_1.N_cv),
    z_in=flameRoom_eco.geo.z_out[1],
    diameter_i=0.027,
    z_out=flameRoom_sh_2.geo.z_in[1],
    useHomotopy=true,
    initOption=0,
    frictionAtInlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    frictionAtOutlet=false,
    p_nom=linspace(
        NOM.ct.p_vle_wall_in,
        NOM.ct.p_vle_wall_out,
        ct_1.N_cv),
    h_nom=linspace(
        NOM.ct.h_vle_wall_in,
        NOM.ct.h_vle_wall_out,
        ct_1.N_cv),
    Delta_p_nom=NOM.ct.Delta_p_vle_wall,
    h_start=linspace(
        INIT.ct.h_vle_wall_in,
        INIT.ct.h_vle_wall_out,
        ct_1.N_cv),
    p_start=linspace(
        INIT.ct.p_vle_wall_in,
        INIT.ct.p_vle_wall_out,
        ct_1.N_cv),
    m_flow_nom=NOM.ct.m_flow_vle_wall_in,
    showData=true,
    length=32,
    N_tubes=310,
    N_cv=7,
    redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe_L4,
    contributeToCycleSummary=false)
                  annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=90,
        origin={229,78})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill4(
    T_out_start=846,
    mass_pca_start=90,
    initOption=0,
    applyGrindingDelay=true)                                                   annotation (Placement(transformation(extent={{-178,-86},{-158,-66}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill1(
    T_out_start=846,
    mass_pca_start=90,
    initOption=0,
    applyGrindingDelay=true)                                                   annotation (Placement(transformation(extent={{-178,-164},{-158,-144}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill2(
    T_out_start=846,
    mass_pca_start=90,
    initOption=0,
    applyGrindingDelay=true)                                                   annotation (Placement(transformation(extent={{-178,-138},{-158,-118}})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mill3(
    T_out_start=846,
    mass_pca_start=90,
    initOption=0,
    applyGrindingDelay=true)                                                   annotation (Placement(transformation(extent={{-178,-112},{-158,-92}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=10,
    offset=1.50,
    startTime=1500,
    height=-0.0)
    annotation (Placement(transformation(extent={{-218,-60},{-198,-40}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 eco_riser_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
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
    initOption=213)
    annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={103,-336})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple eco_down(
    N_cv=5,
    diameter_i=0.2,
    N_tubes=1,
    z_in=eco.z_out,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0,0},
        eco_down.length,
        eco_down.N_cv),
    z_out=evap_0.z_in,
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
        rotation=90,
        origin={123,-244})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 eco_down_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
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
        extent={{-13.9999,-4.99997},{13.9999,4.99997}},
        rotation=90,
        origin={107,-244})));
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
        origin={174,178})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 separator_wall(
    redeclare model Material = TILMedia.Solid.Types.TILMedia_Steel,
    diameter_o=separator.geo.diameter + 0.064,
    diameter_i=separator.geo.diameter,
    length=separator.geo.length,
    T_start={(INIT.eco.T_vle_wall_out + INIT.ct.T_vle_wall_in)/2}) annotation (Placement(transformation(
        extent={{-9.99988,-8.00005},{10.0001,8.00002}},
        rotation=0,
        origin={174,202})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple rh_pipe(
    N_cv=5,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    diameter_i=0.2,
    z_in=0,
    z_out=eco.z_in,
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
        origin={596,172})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 rh_pipe_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
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
    initOption=213)
    annotation (Placement(transformation(
        extent={{-13,-5},{13,5}},
        rotation=90,
        origin={575,172})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple sh_pipe(
    N_cv=5,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    N_tubes=1,
    diameter_i=0.2,
    z_in=sh_4.z_out,
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
        origin={370,262})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 sh_pipe_wall(
    redeclare replaceable model Material = TILMedia.Solid.Types.TILMedia_Steel,
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
        origin={347,262})));

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
    efficiency_Turb_LP4=NOM.efficiency_Turb_LP4) annotation (Placement(transformation(extent={{1446,402},{1466,422}})));
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
    preheater_HP_p_tap=46e5) annotation (Placement(transformation(extent={{1446,364},{1466,384}})));
  inner ClaRa.SimCenter simCenter(
    contributeToCycleSummary=true,
    showExpertSummary=true,
    redeclare ClaRa.Basics.Media.Slag.Slag_v2 slagModel,
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    redeclare ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v3 fuelModel1(
      C_cp={989.167,1000,4190},
      xi_e_waf={{0.884524,0.047619,0.0404762,0.0154762}},
      C_LHV={3.30983e7*1.033,0,-2500e3})) annotation (Placement(transformation(extent={{1478,380},{1518,400}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_HP1(
    contributeToCycleSummary=false,
    p_nom=NOM.Turbine_HP.p_in,
    m_flow_nom=NOM.Turbine_HP.m_flow,
    Pi=NOM.Turbine_HP.p_out/NOM.Turbine_HP.p_in,
    rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_HP.p_in,
        NOM.Turbine_HP.h_in),
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow
          =([0.0,NOM.efficiency_Turb_HP; 1,NOM.efficiency_Turb_HP])),
    p_in_start=INIT.Turbine_HP.p_in,
    p_out_start=INIT.Turbine_HP.p_out,
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_HP.efficiency) annotation (Placement(transformation(extent={{842,-30},{852,-10}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP1(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow
          =([0.0,NOM.Turbine_IP1.efficiency; 1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    p_nom=NOM.Turbine_IP1.p_in,
    m_flow_nom=NOM.Turbine_IP1.m_flow,
    Pi=NOM.Turbine_IP1.p_out/NOM.Turbine_IP1.p_in,
    rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP1.p_in,
        NOM.Turbine_IP1.h_in),
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_IP1.efficiency) annotation (Placement(transformation(extent={{926,-30},{936,-10}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP4(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow
          =([0.0,NOM.Turbine_LP4.efficiency; 1,NOM.Turbine_LP4.efficiency])),
    p_in_start=INIT.Turbine_LP4.p_in,
    p_out_start=INIT.Turbine_LP4.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP4.p_in,
    m_flow_nom=NOM.Turbine_LP4.m_flow,
    Pi=NOM.Turbine_LP4.p_out/NOM.Turbine_LP4.p_in,
    rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP4.p_in,
        NOM.Turbine_LP4.h_in),
    eta_mech=NOM.Turbine_LP4.efficiency) annotation (Placement(transformation(extent={{1266,-30},{1276,-10}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_FW(eta_mech=NOM.efficiency_Pump_cond)
                                                                               annotation (Placement(transformation(extent={{930,-240},{910,-260}})));
  ClaRa.Visualisation.Quadruple quadruple(decimalSpaces(p=3))
                                          annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1320,0})));
  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{632,192},{692,212}})));
  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{406,278},{466,298}})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{960,30},{1020,50}})));
  ClaRa.Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{860,30},{920,50}})));
  ClaRa.Visualisation.Quadruple quadruple5(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{1450,-170},{1510,-150}})));
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
    Tau_evap=10)                                    annotation (Placement(transformation(extent={{944,-208},{1004,-188}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_affinity
                                                         Pump_cond(            showExpertSummary=true,
    contributeToCycleSummary=false,
    J=1,
    rpm_nom=3000,
    redeclare model Energetics = ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.EfficiencyCurves_Q1 (eta_hyd_nom=NOM.Pump_cond.efficiency),
    V_flow_max=NOM.Pump_cond.m_flow/NOM.Pump_cond.rho_in*2,
    Delta_p_max=-NOM.Pump_cond.Delta_p*2,
    useMechanicalPort=true)                                                                            annotation (Placement(transformation(extent={{1420,-188},{1400,-208}})));
  ClaRa.Visualisation.Quadruple quadruple6
    annotation (Placement(transformation(extent={{952,-230},{1012,-210}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_IP1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                    Delta_p_nom=NOM.valve_IP1.Delta_p, m_flow_nom=NOM.valve_IP1.m_flow), checkValve=true) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={990,-100})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP1(
    contributeToCycleSummary=false,
    p_nom=NOM.Turbine_LP1.p_in,
    m_flow_nom=NOM.Turbine_LP1.m_flow,
    Pi=NOM.Turbine_LP1.p_out/NOM.Turbine_LP1.p_in,
    rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP1.p_in,
        NOM.Turbine_LP1.h_in),
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow
          =([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    eta_mech=NOM.Turbine_LP1.efficiency) annotation (Placement(transformation(extent={{1146,-30},{1156,-10}})));
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
        origin={1170,-30})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_preheater_LP1(eta_mech=0.9, inlet(m_flow(start=NOM.pump_preheater_LP1.summary.inlet.m_flow)))
                                                                                        annotation (Placement(transformation(extent={{1070,-230},{1050,-250}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_IP3(checkValve=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=NOM.valve_IP2.m_flow,
        Delta_p_nom=NOM.valve_IP2.Delta_p,
        rho_in_nom=2.4)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={1100,-100})));
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
        origin={812,-52})));
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
        origin={812,-100})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_HP(openingInputIsActive=true, redeclare model PressureLoss =
        Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (
        paraOption=2,
        m_flow_nom=NOM.valve2_HP.m_flow,
        Delta_p_nom=NOM.valve2_HP.Delta_p*0.01,
        rho_in_nom=800)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=0,
        origin={854,-290})));
  ClaRa.Visualisation.StatePoint_phTs statePoint annotation (Placement(transformation(extent={{740,-250},{758,-230}})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheater_HP(y=0.5) annotation (Placement(transformation(extent={{812,-342},{824,-330}})));
  ClaRa.Components.Utilities.Blocks.LimPID
                                     PI_valveControl_preheater_HP(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_max=1,
    y_min=0.01,
    k=2,
    Tau_i=10,
    y_start=0.2,
    initOption=796) annotation (Placement(transformation(extent={{828,-330},{848,-310}})));
  Modelica.Blocks.Continuous.FirstOrder measurement(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.1,
    T=1)
    annotation (Placement(transformation(extent={{1484,-344},{1476,-336}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valvePreFeedWaterTank(Tau=1e-3, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                          Delta_p_nom=NOM.valvePreFeedWaterTank.Delta_p_nom, m_flow_nom=NOM.valvePreFeedWaterTank.m_flow)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={1060,-192})));
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
        origin={1030,-192})));
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
    initOption=796) annotation (Placement(transformation(extent={{1118,-310},{1098,-330}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1026,-120})));
  ClaRa.Visualisation.Quadruple quadruple9
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1134,-120})));
  ClaRa.Visualisation.Quadruple quadruple10
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1060,-160})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={848,-120})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={874,-274})));
  ClaRa.Visualisation.Quadruple quadruple13
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1412,-160})));
  ClaRa.Visualisation.Quadruple quadruple14
    annotation (Placement(transformation(extent={{-26,-8},{26,8}},
        rotation=0,
        origin={1060,-218})));
  Modelica.Blocks.Math.Gain Nominal_PowerFeedwaterPump1(k=NOM.m_flow_nom*0.98)
    annotation (Placement(transformation(extent={{866,-400},{874,-392}})));
  ClaRa.Visualisation.DynDisplay valveControl_preheater_HP_display(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_HP",
    x1=valveControl_preheater_HP.summary.outline.opening_) annotation (Placement(transformation(extent={{862,-320},{894,-308}})));
  ClaRa.Visualisation.DynDisplay electricalPower(
    decimalSpaces=2,
    varname="electrical Power",
    x1=simpleGenerator.summary.P_el/1e6,
    unit="MW") annotation (Placement(transformation(extent={{1432,-6},{1472,6}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP3(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow
          =([0.0,NOM.Turbine_IP1.efficiency; 1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_IP3.p_in,
    m_flow_nom=NOM.Turbine_IP3.m_flow,
    Pi=NOM.Turbine_IP3.p_out/NOM.Turbine_IP3.p_in,
    rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP3.p_in,
        NOM.Turbine_IP3.h_in),
    eta_mech=NOM.Turbine_IP3.efficiency) annotation (Placement(transformation(extent={{1006,-30},{1016,-10}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP2(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow
          =([0.0,NOM.Turbine_IP1.efficiency; 1,NOM.Turbine_IP1.efficiency])),
    p_in_start=INIT.Turbine_IP1.p_in,
    p_out_start=INIT.Turbine_IP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_IP2.p_in,
    m_flow_nom=NOM.Turbine_IP2.m_flow,
    Pi=NOM.Turbine_IP2.p_out/NOM.Turbine_IP2.p_in,
    rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP2.p_in,
        NOM.Turbine_IP2.h_in),
    eta_mech=NOM.Turbine_IP2.efficiency) annotation (Placement(transformation(extent={{966,-30},{976,-10}})));
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
        origin={990,-30})));
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
        origin={1100,-30})));
  ClaRa.Visualisation.Quadruple quadruple15
    annotation (Placement(transformation(extent={{980,10},{1040,30}})));
  ClaRa.Visualisation.Quadruple quadruple16
    annotation (Placement(transformation(extent={{1020,-10},{1080,10}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP3(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow
          =([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP3.p_in,
    m_flow_nom=NOM.Turbine_LP3.m_flow,
    Pi=NOM.Turbine_LP3.p_out/NOM.Turbine_LP3.p_in,
    rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP3.p_in,
        NOM.Turbine_LP3.h_in),
    eta_mech=NOM.Turbine_LP3.efficiency) annotation (Placement(transformation(extent={{1226,-30},{1236,-10}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP2(
    contributeToCycleSummary=false,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow
          =([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out,
    useMechanicalPort=true,
    p_nom=NOM.Turbine_LP2.p_in,
    m_flow_nom=NOM.Turbine_LP2.m_flow,
    Pi=NOM.Turbine_LP2.p_out/NOM.Turbine_LP2.p_in,
    rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP2.p_in,
        NOM.Turbine_LP2.h_in),
    eta_mech=NOM.Turbine_LP2.efficiency) annotation (Placement(transformation(extent={{1186,-30},{1196,-10}})));
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
        origin={1210,-30})));
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
        origin={1250,-30})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP2(checkValve=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                     Delta_p_nom=NOM.valve_LP1.Delta_p, m_flow_nom=NOM.valve_LP1.m_flow)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={1170,-100})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_LP2(
    redeclare replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Steel,
    N_passes=1,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
          PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,
            100}),
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
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1500,10000}),
    T_w_start={320,340,360},
    N_tubes=1000,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={1170,-194})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple preheater_LP3(
    redeclare replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Steel,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
          PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,
            100}),
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
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1500,10000}),
    T_w_start={300,320,340},
    z_in_aux1=0.1,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={1240,-194})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple
                                                   Pump_preheater_LP3(showExpertSummary=true, eta_mech=0.9,
    outlet(p(start=NOM.pump_preheater_LP3.summary.outlet.p)))                                               annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={1220,-240})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_afterPumpLP3(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                             m_flow_nom=30, Delta_p_nom=1000)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={1204,-220})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP2(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        CL_valve=[0,0; 1,1],
        m_flow_nom=25,
        Delta_p_nom=0.2e5)) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=90,
        origin={1170,-220})));
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
        origin={1204,-192})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP4(
    checkValve=true,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        m_flow_nom=8,
        CL_valve=[0,0; 1,1],
        Delta_p_nom=0.06e5)) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=0,
        origin={1350,-240})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP3(checkValve=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                     Delta_p_nom=NOM.valve_LP2.Delta_p, m_flow_nom=NOM.valve_LP2.m_flow)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={1240,-100})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_LP4(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                    m_flow_nom=NOM.valve_LP3.m_flow, Delta_p_nom=NOM.valve_LP3.Delta_p), checkValve=true) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={1310,-100})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                      boundaryVLE_Txim_flow(                                                             T_const=273.15 + 15, m_flow_const=25000)
                                                                                                                     annotation (Placement(transformation(extent={{1520,-150},{1500,-130}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi
                                                 boundaryVLE_phxi(p_const=2e5) annotation (Placement(transformation(extent={{1520,-110},{1500,-90}})));
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
        origin={1318,-320})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP4(y=0.1) annotation (Placement(transformation(extent={{1272,-316},{1286,-304}})));
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
        origin={1248,-320})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP3(y=0.1) annotation (Placement(transformation(extent={{1286,-326},{1272,-314}})));
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
        origin={1178,-320})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP2(y=0.1) annotation (Placement(transformation(extent={{1214,-326},{1200,-314}})));
  Modelica.Blocks.Sources.RealExpression setPoint_preheaterLP1(y=0.1) annotation (Placement(transformation(extent={{1144,-326},{1130,-314}})));
  Modelica.Blocks.Sources.RealExpression setPoint_condenser(y=0.5/6) annotation (Placement(transformation(extent={{1486,-326},{1472,-314}})));
  ClaRa.Visualisation.Quadruple quadruple17
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1290,40})));
  ClaRa.Visualisation.Quadruple quadruple18
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1310,20})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=2000, phi(start=0))
                                                                   annotation (Placement(transformation(extent={{1412,-30},{1432,-10}})));
  ClaRa.Components.Electrical.SimpleGenerator
                                        simpleGenerator(contributeToCycleSummary=true,
                                                        hasInertia=true) annotation (Placement(transformation(extent={{1442,-30},{1462,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryElectricFrequency
                                                          boundaryElectricFrequency annotation (Placement(transformation(extent={{1502,-30},{1482,-10}})));
  ClaRa.Visualisation.Quadruple quadruple19
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1204,-120})));
  ClaRa.Visualisation.Quadruple quadruple20
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1274,-120})));
  ClaRa.Visualisation.Quadruple quadruple21(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1346,-120})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_LP1(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{1108,-204},{1118,-184}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_LP2(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{1178,-204},{1188,-184}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_LP3(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{1248,-204},{1258,-184}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_LP4(
    u_set=0.1,
    u_high=0.2,
    u_low=0.05,
    provideInputConnectors=true)
                annotation (Placement(transformation(extent={{1318,-204},{1328,-184}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_condenser(
    u_set=0.5/6,
    u_high=0.5/3,
    u_low=0.5/12,
    provideInputConnectors=true)
                  annotation (Placement(transformation(extent={{1448,-130},{1458,-110}})));
  ClaRa.Visualisation.DynamicBar
                           fillingLevel_preheater_HP(
    provideInputConnectors=true,
    u_set=0.5,
    u_high=0.6,
    u_low=0.4)  annotation (Placement(transformation(extent={{820,-262},{830,-242}})));
  ClaRa.Visualisation.DynDisplay
                           valveControl_preheater_LP4_display(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_LP4",
    x1=valveControl_preheater_LP4.summary.outline.opening_) annotation (Placement(transformation(extent={{1334,-230},{1366,-218}})));
  ClaRa.Visualisation.DynDisplay
                           valveControl_preheater_LP2_display2(
    unit="p.u.",
    decimalSpaces=1,
    varname="valveControl_preheater_LP2",
    x1=valveControl_preheater_LP2.summary.outline.opening_) annotation (Placement(transformation(extent={{1122,-226},{1154,-214}})));
  ClaRa.Visualisation.Quadruple quadruple22
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1134,-160})));
  ClaRa.Visualisation.Quadruple quadruple23
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1274,-160})));
  ClaRa.Visualisation.Quadruple quadruple24
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1346,-160})));
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
        origin={948,-229})));
  ClaRa.Visualisation.Quadruple quadruple25
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={760,-262})));
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
    initOption=796) annotation (Placement(transformation(extent={{1460,-330},{1440,-310}})));
  Modelica.Blocks.Sources.RealExpression fixedVoltage(y=10e3) annotation (Placement(transformation(extent={{1382,-266},{1396,-254}})));
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
        origin={1410,-230})));
  ClaRa.Visualisation.DynDisplay
                           electricalPowerPump_Cond(
    decimalSpaces=2,
    varname="electrical Power",
    unit="MW",
    x1=motor.summary.P_term/1e6) annotation (Placement(transformation(extent={{1424,-242},{1464,-230}})));
  ClaRa.Visualisation.DynDisplay
                           rpm_Pump(
    varname="rpm Pump",
    x1=Pump_cond.summary.outline.rpm,
    unit="1/min",
    decimalSpaces=0) annotation (Placement(transformation(extent={{1424,-230},{1464,-218}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveControl_preheater_LP1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        CL_valve=[0,0; 1,1],
        Delta_p_nom=1000,
        m_flow_nom=25000)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={1486,-100})));
  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={1348,78})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple eco_riser(
    N_cv=5,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (alpha_nom=10000),
    length=eco_riser.z_out - eco_riser.z_in,
    diameter_i=0.2,
    z_in=0,
    z_out=eco.z_in,
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
        origin={123,-336})));
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
        origin={654,-250})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                        Delta_p_nom=0.1e5, m_flow_nom=420)) annotation (Placement(transformation(extent={{690,-256},{710,-244}})));
  ClaRa.Visualisation.Quadruple quadruple26
    annotation (Placement(transformation(extent={{380,-70},{440,-50}})));
  ClaRa.Visualisation.Quadruple quadruple27
    annotation (Placement(transformation(extent={{376,28},{436,48}})));
  ClaRa.Visualisation.Quadruple quadruple28
    annotation (Placement(transformation(extent={{378,128},{438,148}})));
  ClaRa.Visualisation.Quadruple quadruple29
    annotation (Placement(transformation(extent={{232,50},{292,70}})));
  ClaRa.Visualisation.Quadruple quadruple30
    annotation (Placement(transformation(extent={{132,148},{192,168}})));
  ClaRa.Components.HeatExchangers.RegenerativeAirPreheater_L4 regenerativeAirPreheater(
    s_sp=0.6e-3,
    redeclare model Material = TILMedia.Solid.Types.TILMedia_St35_8,
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
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
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
    frictionAtFlueGasInlet=true) annotation (Placement(transformation(extent={{-392,14},{-372,34}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitGas_L2_flex splitGas_L2_flex(
    N_ports_out=4,
    volume=2,
    xi_nom={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    m_flow_out_nom={475.6/4,475.6/4,475.6/4,475.6/4},
    T_start=673,
    xi_start={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    T_nom=1119.15,
    p_start(displayUnit="bar") = 133900) annotation (Placement(transformation(extent={{-400,-116},{-380,-96}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner1(
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    variable_T=false,
    T_const=273.15 + 30,
    m_flow_const=475.6 + 24,
    variable_m_flow=true)
                   annotation (Placement(transformation(extent={{-440,20},{-420,40}})));
  Modelica.Blocks.Sources.RealExpression actual_lambda(y=burner1.lambdaComb_primary) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-556,66})));
  Modelica.Blocks.Sources.Ramp lambda(
    duration=1000,
    startTime=4000,
    height=0,
    offset=1.2)
    annotation (Placement(transformation(extent={{-566,26},{-546,46}})));
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
    initOption=501) annotation (Placement(transformation(extent={{-514,46},{-494,26}})));
  Modelica.Blocks.Math.Gain gain(k=43/4) annotation (Placement(transformation(extent={{-400,-152},{-380,-132}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=475.6 + 24) annotation (Placement(transformation(extent={{-478,26},{-458,46}})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_HP(
    redeclare replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Steel,
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
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
          alpha_nom=3500),
    p_nom_tubes=NOM.preheater_HP.p_cond,
    p_start_tubes(displayUnit="bar") = INIT.preheater_HP.p_cond,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,
            1000}),
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=10),
    initOptionTubes=0,
    initOptionShell=204,
    levelOutput=true,
    T_w_start=ones(3)*(273.15 + 200),
    diameter_i=0.02,
    diameter_o=0.028,
    N_tubes=2000,
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent (alpha_nom={1650,10000}),
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={812,-252})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple preheater_LP4(
    redeclare replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Steel,
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
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3
        (alpha_nom={1500,8000}),
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,
            100}),
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
          PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={1310,-194})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_LP1(
    redeclare replaceable model WallMaterial = TILMedia.Solid.Types.TILMedia_Steel,
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
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
          PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3
        (alpha_nom={1500,8000}),
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,
            100}),
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
        origin={1100,-194})));
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
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2) annotation (Placement(transformation(extent={{1430,-130},{1450,-110}})));
  Visualisation.Quadruple       quadruple31
    annotation (Placement(transformation(extent={{532,70},{592,90}})));
  Visualisation.Quadruple       quadruple32
    annotation (Placement(transformation(extent={{534,16},{594,36}})));
  Visualisation.Quadruple       quadruple33
    annotation (Placement(transformation(extent={{300,-34},{360,-14}})));
  Visualisation.Quadruple       quadruple34
    annotation (Placement(transformation(extent={{302,164},{362,184}})));
  Visualisation.QuadrupleGas quadrupleGas(value4=11) annotation (Placement(transformation(extent={{-82,-146},{-62,-136}})));
  Visualisation.QuadrupleGas quadrupleGas1(value4=11) annotation (Placement(transformation(extent={{-80,-125},{-60,-115}})));
  Visualisation.QuadrupleGas quadrupleGas2(value4=11) annotation (Placement(transformation(extent={{-74,-99},{-54,-89}})));
  Visualisation.QuadrupleGas quadrupleGas3(value4=11) annotation (Placement(transformation(extent={{-72,-73},{-52,-63}})));
  Visualisation.QuadrupleGas quadrupleGas4(value4=11) annotation (Placement(transformation(extent={{-72,-47},{-52,-37}})));
  Visualisation.QuadrupleGas quadrupleGas5(value4=11) annotation (Placement(transformation(extent={{-174,-21},{-154,-11}})));
  Visualisation.QuadrupleGas quadrupleGas6(value4=11) annotation (Placement(transformation(extent={{-176,5},{-156,15}})));
  Visualisation.QuadrupleGas quadrupleGas7(value4=11) annotation (Placement(transformation(extent={{-178,33},{-158,43}})));
  Visualisation.QuadrupleGas quadrupleGas8(value4=11) annotation (Placement(transformation(extent={{-178,61},{-158,71}})));
  Visualisation.QuadrupleGas quadrupleGas9(value4=11) annotation (Placement(transformation(extent={{-176,89},{-156,99}})));
  Visualisation.QuadrupleGas quadrupleGas10(value4=11) annotation (Placement(transformation(extent={{-178,117},{-158,127}})));
  Visualisation.QuadrupleGas quadrupleGas11(value4=11) annotation (Placement(transformation(extent={{-178,145},{-158,155}})));
  Visualisation.QuadrupleGas quadrupleGas12(value4=11) annotation (Placement(transformation(extent={{-182,186},{-140,210}})));
  Visualisation.QuadrupleGas quadrupleGas13(value4=11) annotation (Placement(transformation(extent={{-390,-8},{-370,2}})));
  Visualisation.QuadrupleGas quadrupleGas14(value4=11) annotation (Placement(transformation(extent={{-366,36},{-346,46}})));
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
        origin={-229,123})));
  Modelica.Blocks.Sources.RealExpression boilergasTemperatures[15](y={hopper.summary.outline.T_out,
  hopper.summary.outline.T_out,
  burner1.summary.outline.T_out,
  burner2.summary.outline.T_out,
  burner3.summary.outline.T_out,
  burner4.summary.outline.T_out,
  flameRoom_evap_1.summary.outline.T_out,
  flameRoom_evap_2.summary.outline.T_out,
  flameRoom_sh_1.summary.outline.T_out,
  flameRoom_sh_2.summary.outline.T_out,
  flameRoom_sh_4.summary.outline.T_out,
  flameRoom_rh_2.summary.outline.T_out,
  flameRoom_sh_3.summary.outline.T_out,
  flameRoom_rh_1.summary.outline.T_out,
  flameRoom_eco.summary.outline.T_out} - fill(273.15, 15)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-240,8})));
  Modelica.Blocks.Sources.RealExpression boilerZpositions[15](y={hopper.geo.z_in[1],hopper.geo.z_out[1],burner1.geo.z_out[1],burner2.geo.z_out[1],burner3.geo.z_out[1],burner4.geo.z_out[1],flameRoom_evap_1.geo.z_out[1],flameRoom_evap_2.geo.z_out[1],flameRoom_sh_1.geo.z_out[1],flameRoom_sh_2.geo.z_out[1],flameRoom_sh_4.geo.z_out[1],flameRoom_rh_2.geo.z_out[1],flameRoom_sh_3.geo.z_out[1],flameRoom_rh_1.geo.z_out[1],flameRoom_eco.geo.z_out[1]}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-186,86})));
  Visualisation.Quadruple       quadruple35
    annotation (Placement(transformation(extent={{132,-26},{192,-6}})));
  Visualisation.Quadruple       quadruple36
    annotation (Placement(transformation(extent={{132,52},{192,72}})));
  Visualisation.Quadruple       quadruple37
    annotation (Placement(transformation(extent={{146,-106},{206,-86}})));
  Visualisation.Quadruple       quadruple38
    annotation (Placement(transformation(extent={{140,-176},{200,-156}})));
  Visualisation.Quadruple       quadruple39
    annotation (Placement(transformation(extent={{140,-294},{200,-274}})));
  Modelica.Blocks.Sources.RealExpression boilervleTemperatures[19](y= {evap_0.summary.inlet.T,
 evap_1.summary.outlet.T,
 evap_2.summary.outlet.T,
 evap_3.summary.outlet.T,
 evap_4.summary.outlet.T,
 ct_1.summary.outlet.T,
 sh_1.summary.outlet.T,
 sh_2.summary.outlet.T,
 sh_2.summary.inlet.T,
 sh_4.summary.outlet.T,
 sh_4.summary.inlet.T,
 rh_2.summary.outlet.T,
  rh_2.summary.inlet.T,
 sh_3.summary.outlet.T,
 sh_3.summary.inlet.T,
 rh_1.summary.outlet.T,
 rh_1.summary.inlet.T,
 eco.summary.inlet.T,
 eco.summary.outlet.T}
 - fill(273.15, 19)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-219,8})));

 Modelica.Blocks.Sources.RealExpression boilerZpositions2[19](y={hopper.geo.z_in[1],flameRoom_evap_1.geo.z_out[1],flameRoom_evap_2.geo.z_out[1],flameRoom_rh_2.geo.z_out[1],flameRoom_eco.geo.z_out[1],flameRoom_sh_1.geo.z_in[1],flameRoom_sh_1.geo.z_out[1],flameRoom_sh_2.geo.z_in[1],flameRoom_sh_2.geo.z_out[1],flameRoom_sh_4.geo.z_in[1],flameRoom_sh_4.geo.z_out[1],flameRoom_rh_2.geo.z_in[1],flameRoom_rh_2.geo.z_out[1],flameRoom_sh_3.geo.z_in[1],flameRoom_sh_3.geo.z_out[1],flameRoom_rh_1.geo.z_in[1],flameRoom_rh_1.geo.z_out[1],flameRoom_eco.geo.z_out[1],flameRoom_eco.geo.z_in[1]})
                            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-186,126})));

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
                          annotation (Placement(transformation(extent={{892,-386},{912,-406}})));
  Components.Sensors.SensorVLE_L1_m_flow sensorFWflow annotation (Placement(transformation(extent={{896,-250},{876,-230}})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_sh2(m_flow_const=28) "Contrlled spray injection mass flow between sh1 and sh2" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={482,-131})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh2(
    volume=0.5,
    p_nom=NOM.sh1.p_vle_bundle_out,
    h_nom=NOM.sh1.h_vle_bundle_out,
    h_start=INIT.sh1.h_vle_bundle_out,
    p_start=INIT.sh1.p_vle_bundle_out,
    m_flow_in_nom={380,28}) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={370,-38})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh4(
    volume=0.5,
    m_flow_in_nom={305,15},
    p_nom=NOM.sh3.p_vle_bundle_out,
    h_nom=NOM.sh3.h_vle_bundle_out,
    h_start=INIT.sh3.h_vle_bundle_out,
    p_start=INIT.sh3.p_vle_bundle_out) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={370,160})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_sh4(m_flow_const=15) "Contrlled spray injection mass flow between sh3 and sh4" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={518,-131})));
  Components.BoundaryConditions.PrescribedMassFlowVLE injectionControl_rh2(m_flow_const=1) "Contrlled spray injection mass flow between rh1 and rh2" annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=90,
        origin={620,-131})));
  Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y sprayInjector_sh1(
    volume=0.5,
    m_flow_in_nom={200,1.5},
    p_nom=NOM.rh1.p_vle_bundle_out,
    h_nom=NOM.rh1.h_vle_bundle_out,
    h_start=INIT.rh1.h_vle_bundle_out,
    p_start=INIT.rh1.p_vle_bundle_out) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={596,70})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=1,
    T=100) annotation (Placement(transformation(extent={{-416,-400},{-408,-392}})));
equation
  totalHeat =burner1.Q_flow_wall + burner2.Q_flow_wall + burner3.Q_flow_wall + burner4.Q_flow_wall + flameRoom_evap_1.Q_flow_wall + flameRoom_evap_2.Q_flow_wall + flameRoom_sh_1.Q_flow_wall + flameRoom_sh_2.Q_flow_wall + flameRoom_sh_4.Q_flow_wall + flameRoom_rh_2.Q_flow_wall;

  connect(burner1.inlet, hopper.outlet)        annotation (Line(
      points={{-134,-164},{-134,-168},{-136,-168}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_bottom, hopper.heat_top)        annotation (Line(
      points={{-116,-164},{-116,-168},{-118,-168}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.fuelSlagFlueGas_outlet, hopper.inlet)
    annotation (Line(
      points={{-134,-196},{-134,-188},{-136,-188}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.heat_wall, evap_1_wall.outerPhase[1]) annotation (Line(
      points={{-88,-154},{0,-154},{0,-120},{102,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner2.heat_wall, evap_1_wall.outerPhase[2]) annotation (Line(
      points={{-88,-128},{0,-128},{0,-120},{102,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(burner3.heat_wall, evap_1_wall.outerPhase[3]) annotation (Line(
      points={{-88,-102},{0,-102},{0,-120},{102,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_evap_1.heat_wall, evap_1_wall.outerPhase[5]) annotation (Line(
      points={{-88,-50},{0,-50},{0,-120},{102,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_evap_2.heat_wall, scalar2VectorHeatPort.heatScalar)
    annotation (Line(
      points={{-88,-24},{52,-24}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatVector, evap_2_wall.outerPhase) annotation (
     Line(
      points={{72,-24},{100,-24}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_1.outlet, evap_2.inlet) annotation (Line(
      points={{123,-106},{123,-38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(flameRoom_rh_2.heat_wall, evap_3_wall.outerPhase[4]) annotation (Line(
      points={{-88,86},{0,86},{0,40},{102,40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_2.outlet, evap_3.inlet) annotation (Line(
      points={{123,-10},{123,26}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(flameRoom_rh_1.heat_wall, evap_4_wall.outerPhase[2]) annotation (Line(
      points={{-88,142},{8,142},{8,142},{104,142}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_3.outlet, evap_4.inlet) annotation (Line(
      points={{123,54},{123,128}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(eco_wall.innerPhase, eco.heat) annotation (Line(
      points={{100,-298},{119,-298}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort13.heatVector, eco_wall.outerPhase) annotation (
      Line(
      points={{74,-298},{89.9998,-298}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rh_2_wall.innerPhase, rh_2.heat) annotation (Line(
      points={{580,124},{592,124}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort12.heatVector, rh_2_wall.outerPhase) annotation (
     Line(
      points={{544,124},{570,124}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_rh_1.heat_TubeBundle, scalar2VectorHeatPort11.heatScalar)
    annotation (Line(
      points={{-98,132},{84,132},{84,-2},{534,-2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_TubeBundle, scalar2VectorHeatPort13.heatScalar)
    annotation (Line(
      points={{-98,160},{-40,160},{-40,-298},{54,-298}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_wall, evap_4_wall.outerPhase[3]) annotation (Line(
      points={{-88,170},{0,170},{0,142},{104,142}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_rh_2.heat_TubeBundle, scalar2VectorHeatPort12.heatScalar)
    annotation (Line(
      points={{-98,76},{60,76},{60,124},{524,124}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(sh_4_out_T.port, sh_4.outlet) annotation (Line(
      points={{386,230},{370,230}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner4.heat_wall, evap_1_wall.outerPhase[4]) annotation (Line(
      points={{-88,-76},{0,-76},{0,-120},{102,-120}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort2.heatVector, evap_0_wall.outerPhase)
    annotation (Line(
      points={{68,-180},{92.0004,-180}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(evap_0_wall.innerPhase, evap_0.heat) annotation (Line(
      points={{102,-180},{119,-180}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(hopper.heat_wall, scalar2VectorHeatPort2.heatScalar) annotation (Line(
      points={{-90,-178},{-22,-178},{-22,-180},{48,-180}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_1.heat_TubeBundle, scalar2VectorHeatPort1.heatScalar)
    annotation (Line(
      points={{-98,-8},{20,-8},{20,-82},{304,-82}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_1.heat_wall, evap_3_wall.outerPhase[1]) annotation (Line(
      points={{-88,2},{0,2},{0,40},{102,40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_3.heat_TubeBundle, scalar2VectorHeatPort9.heatScalar)
    annotation (Line(
      points={{-98,104},{306,104}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_3.heat_wall, evap_4_wall.outerPhase[1]) annotation (Line(
      points={{-88,114},{0,114},{0,142},{104,142}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_4.heat_TubeBundle, scalar2VectorHeatPort10.heatScalar)
    annotation (Line(
      points={{-98,48},{40,48},{40,216},{302,216}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_4.heat_wall, evap_3_wall.outerPhase[3]) annotation (Line(
      points={{-88,58},{0,58},{0,40},{102,40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_2.heat_TubeBundle, scalar2VectorHeatPort8.heatScalar)
    annotation (Line(
      points={{-98,20},{308,20}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_2.heat_wall, evap_3_wall.outerPhase[2]) annotation (Line(
      points={{-88,30},{0,30},{0,40},{102,40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_eco.heat_CarrierTubes, ct_1_wall.outerPhase[1]) annotation (
     Line(
      points={{-98,180},{20,180},{20,78},{204,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_rh_1.heat_CarrierTubes, ct_1_wall.outerPhase[2])
    annotation (Line(
      points={{-98,152},{20,152},{20,78},{204,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_3.heat_CarrierTubes, ct_1_wall.outerPhase[3])
    annotation (Line(
      points={{-98,124},{20,124},{20,78},{204,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_rh_2.heat_CarrierTubes, ct_1_wall.outerPhase[4])
    annotation (Line(
      points={{-98,96},{20,96},{20,78},{204,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_4.heat_CarrierTubes, ct_1_wall.outerPhase[5])
    annotation (Line(
      points={{-98,68},{20,68},{20,78},{204,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flameRoom_sh_2.heat_CarrierTubes, ct_1_wall.outerPhase[6])
    annotation (Line(
      points={{-98,40},{20,40},{20,78},{204,78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(coalGas_join_burner4.fuelFlueGas_outlet, mill4.inlet) annotation (Line(
      points={{-184,-76},{-178,-76}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill4.outlet, burner4.fuelFlueGas_inlet) annotation (Line(
      points={{-158,-76},{-148,-76}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner3.fuelFlueGas_outlet, mill3.inlet) annotation (Line(
      points={{-184,-102},{-178,-102}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill3.outlet, burner3.fuelFlueGas_inlet) annotation (Line(
      points={{-158,-102},{-148,-102}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner2.fuelFlueGas_outlet, mill2.inlet) annotation (Line(
      points={{-184,-128},{-178,-128}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill2.outlet, burner2.fuelFlueGas_inlet) annotation (Line(
      points={{-158,-128},{-154,-128},{-154,-128},{-148,-128}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner1.fuelFlueGas_outlet, mill1.inlet) annotation (Line(
      points={{-184,-154},{-178,-154}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(mill1.outlet, burner1.fuelFlueGas_inlet) annotation (Line(
      points={{-158,-154},{-148,-154}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp2.y, mill4.classifierSpeed) annotation (Line(
      points={{-197,-50},{-180,-50},{-180,-58},{-168,-58},{-168,-65.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, mill3.classifierSpeed) annotation (Line(
      points={{-197,-50},{-180,-50},{-180,-88},{-168,-88},{-168,-91.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, mill2.classifierSpeed) annotation (Line(
      points={{-197,-50},{-180,-50},{-180,-116},{-168,-116},{-168,-117.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, mill1.classifierSpeed) annotation (Line(
      points={{-197,-50},{-180,-50},{-180,-140},{-168,-140},{-168,-143.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eco_down_wall.innerPhase, eco_down.heat) annotation (Line(
      points={{112,-244},{119,-244}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(separator_wall.innerPhase, separator.heat) annotation (Line(
      points={{173.8,194.32},{174,194.32},{174,188}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(separator.inlet, evap_4.outlet) annotation (Line(
      points={{164,178},{123,178},{123,156}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ct_1.inlet, separator.outlet) annotation (Line(
      points={{229,92},{229,178},{184,178}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(rh_pipe_wall.innerPhase, rh_pipe.heat) annotation (Line(
      points={{580,172},{592,172}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(sh_pipe_wall.innerPhase, sh_pipe.heat) annotation (Line(
      points={{352,262},{366,262}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(ct_1.outlet, sh_1.inlet) annotation (Line(
      points={{229,64},{229,-120},{370,-120},{370,-96}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_2.outlet, sh_3.inlet) annotation (Line(
      points={{372,34},{372,62},{370,62},{370,90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_4.outlet, sh_pipe.inlet) annotation (Line(
      points={{370,230},{370,248}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hopper.heat_bottom, boilerLosses.port) annotation (Line(
      points={{-118,-188},{-118,-200},{-100,-200}},
      color={167,25,48},
      thickness=0.5));
  connect(coalFlowSource_bottom.fuel_a, coalSlagFlueGas_join.fuel_inlet) annotation (Line(
      points={{-158,-234},{-158,-222},{-140,-222},{-140,-216}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(slaglSink_bottom.slag_inlet, coalSlagFlueGas_join.slag_outlet) annotation (Line(
      points={{-133.8,-234},{-134,-234},{-134,-216}},
      color={234,171,0},
      thickness=0.5));
  connect(fluelGasFlowSource_bottom.gas_a, coalSlagFlueGas_join.flueGas_inlet) annotation (Line(
      points={{-108,-234},{-108,-222},{-128,-222},{-128,-216}},
      color={118,106,98},
      thickness=0.5));
  connect(coalFlowSource_burner4.fuel_a, coalGas_join_burner4.fuel_inlet) annotation (Line(
      points={{-224,-70},{-204,-70}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner3.fuel_a, coalGas_join_burner3.fuel_inlet) annotation (Line(
      points={{-224,-96},{-204,-96}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner2.fuel_a, coalGas_join_burner2.fuel_inlet) annotation (Line(
      points={{-224,-122},{-204,-122}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalFlowSource_burner1.fuel_a, coalGas_join_burner1.fuel_inlet) annotation (Line(
      points={{-224,-148},{-204,-148}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalSlagFlueGas_split_top.fuelSlagFlueGas_inlet, flameRoom_eco.outlet) annotation (Line(
      points={{-134,212},{-134,180}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_eco.inlet, flameRoom_rh_1.outlet) annotation (Line(
      points={{-134,160},{-134,152}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_eco.heat_bottom, flameRoom_rh_1.heat_top) annotation (Line(
      points={{-116,160},{-116,152}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_evap_1.outlet, flameRoom_evap_2.inlet) annotation (Line(
      points={{-134,-40},{-134,-34}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_evap_1.heat_top, flameRoom_evap_2.heat_bottom) annotation (Line(
      points={{-116,-40},{-116,-34}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_evap_2.outlet, flameRoom_sh_1.inlet) annotation (Line(
      points={{-134,-14},{-134,-12},{-134,-8},{-134,-8}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_evap_2.heat_top, flameRoom_sh_1.heat_bottom) annotation (Line(
      points={{-116,-14},{-116,-8}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_1.heat_top, flameRoom_sh_2.heat_bottom) annotation (Line(
      points={{-116,12},{-116,20}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_1.outlet, flameRoom_sh_2.inlet) annotation (Line(
      points={{-134,12},{-134,16},{-134,16},{-134,20}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_2.outlet, flameRoom_sh_4.inlet) annotation (Line(
      points={{-134,40},{-134,48}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_2.heat_top, flameRoom_sh_4.heat_bottom) annotation (Line(
      points={{-116,40},{-116,48}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_sh_4.outlet, flameRoom_rh_2.inlet) annotation (Line(
      points={{-134,68},{-134,76}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_4.heat_top, flameRoom_rh_2.heat_bottom) annotation (Line(
      points={{-116,68},{-116,76}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_rh_2.heat_top, flameRoom_sh_3.heat_bottom) annotation (Line(
      points={{-116,96},{-116,104}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_rh_2.outlet, flameRoom_sh_3.inlet) annotation (Line(
      points={{-134,96},{-134,104}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_3.outlet, flameRoom_rh_1.inlet) annotation (Line(
      points={{-134,124},{-134,132}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoom_sh_3.heat_top, flameRoom_rh_1.heat_bottom) annotation (Line(
      points={{-116,124},{-116,132}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoom_eco.heat_top, fixedTemperature5.port) annotation (Line(
      points={{-116,180},{-116,206},{-94,206}},
      color={167,25,48},
      thickness=0.5));
  connect(burner1.outlet, burner2.inlet) annotation (Line(
      points={{-134,-144},{-134,-138}},
      color={118,106,98},
      thickness=0.5));
  connect(burner1.heat_top, burner2.heat_bottom) annotation (Line(
      points={{-116,-144},{-116,-138}},
      color={167,25,48},
      thickness=0.5));
  connect(burner2.outlet, burner3.inlet) annotation (Line(
      points={{-134,-118},{-134,-112}},
      color={118,106,98},
      thickness=0.5));
  connect(burner2.heat_top, burner3.heat_bottom) annotation (Line(
      points={{-116,-118},{-116,-112}},
      color={167,25,48},
      thickness=0.5));
  connect(burner3.outlet, burner4.inlet) annotation (Line(
      points={{-134,-92},{-134,-86}},
      color={118,106,98},
      thickness=0.5));
  connect(burner3.heat_top, burner4.heat_bottom) annotation (Line(
      points={{-116,-92},{-116,-86}},
      color={167,25,48},
      thickness=0.5));
  connect(burner4.outlet, flameRoom_evap_1.inlet) annotation (Line(
      points={{-134,-66},{-134,-60}},
      color={118,106,98},
      thickness=0.5));
  connect(burner4.heat_top, flameRoom_evap_1.heat_bottom) annotation (Line(
      points={{-116,-66},{-116,-60}},
      color={167,25,48},
      thickness=0.5));
  connect(slagFlowSource_top.slag_outlet, coalSlagFlueGas_split_top.slag_inlet) annotation (Line(
      points={{-182,248},{-134,248},{-134,232}},
      color={234,171,0},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(coalSink_top.fuel_a, coalSlagFlueGas_split_top.fuel_outlet) annotation (Line(
      points={{-156,236},{-140,236},{-140,232}},
      color={27,36,42},
      thickness=0.5));
  connect(rh_2.outlet, rh_pipe.inlet) annotation (Line(
      points={{596,138},{596,158}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(PI_valveControl_preheater_HP.y,valveControl_preheater_HP. opening_in) annotation (Line(
      points={{849,-320},{854,-320},{854,-299}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(join_LP1.inlet,Turbine_LP1. outlet) annotation (Line(
      points={{1160,-30},{1156,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.inlet,Turbine_HP1. outlet) annotation (Line(
      points={{822,-52},{852,-52},{852,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet2,valve_HP. inlet) annotation (Line(
      points={{812,-62},{812,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valvePreFeedWaterTank.outlet,join_LP_main. inlet1) annotation (Line(
      points={{1050,-192},{1040,-192}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID_preheaterLP1.y, Pump_preheater_LP1.P_drive) annotation (Line(
      points={{1097,-320},{1060,-320},{1060,-252}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Turbine_HP1.eye,quadruple4. eye) annotation (Line(
      points={{853,-26},{860,-26},{860,40}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_IP1.eye,quadruple3. eye) annotation (Line(
      points={{937,-26},{940,-26},{940,40},{960,40}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP1.eye, quadruple7.eye) annotation (Line(
      points={{1157,-26},{1170,-26},{1170,78},{1318,78}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP4.eye,quadruple. eye) annotation (Line(
      points={{1277,-26},{1282,-26},{1282,0},{1290,0}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple6.eye,feedWaterTank. eye) annotation (Line(
      points={{952,-220},{952,-209}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple8.eye,valve_IP1. eye) annotation (Line(
      points={{996,-120},{986,-120},{986,-110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple9.eye,valve_IP3. eye) annotation (Line(
      points={{1104,-120},{1096,-120},{1096,-110}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(valve_HP.eye,quadruple11. eye) annotation (Line(
      points={{808,-110},{808,-119.7},{818,-119.7},{818,-120}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple12.eye,valveControl_preheater_HP. eye) annotation (Line(
      points={{844,-274},{874,-274},{874,-286},{864,-286}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple13.eye,Pump_cond. eye) annotation (Line(
      points={{1382,-160},{1382,-192},{1399,-192}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple14.eye,Pump_preheater_LP1. eye) annotation (Line(
      points={{1034,-218},{1034,-234},{1049,-234}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.outlet,join_LP_main. inlet2) annotation (Line(
      points={{1050,-240},{1030,-240},{1030,-202}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP_main.outlet,feedWaterTank. condensate) annotation (Line(
      points={{1020,-192},{994,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(Turbine_IP2.outlet,split_IP2. inlet) annotation (Line(
      points={{976,-30},{980,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(split_IP2.outlet1,Turbine_IP3. inlet) annotation (Line(
      points={{1000,-30},{1000,-14},{1006,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_IP3.outlet,join_IP3. inlet) annotation (Line(
      points={{1016,-30},{1090,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_IP2.eye,quadruple15. eye) annotation (Line(points={{977,-26},{980,-26},{980,20}},
                                                                                               color={190,190,190}));
  connect(Turbine_IP3.eye,quadruple16. eye) annotation (Line(points={{1017,-26},{1020,-26},{1020,0}},
                                                                                                  color={190,190,190}));
  connect(split_IP2.outlet2,valve_IP1. inlet) annotation (Line(
      points={{990,-40},{990,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_IP3.outlet1,Turbine_LP1. inlet) annotation (Line(
      points={{1110,-30},{1140,-30},{1140,-14},{1146,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP2.outlet,join_LP2. inlet) annotation (Line(
      points={{1196,-30},{1200,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP2.outlet1,Turbine_LP3. inlet) annotation (Line(
      points={{1220,-30},{1220,-14},{1226,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP3.outlet1,Turbine_LP4. inlet) annotation (Line(
      points={{1260,-30},{1260,-14},{1266,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP3.outlet,join_LP3. inlet) annotation (Line(
      points={{1236,-30},{1240,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.In1,valve_LP2. outlet) annotation (Line(
      points={{1170,-184.2},{1170,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.Out1,valveControl_preheater_LP2. inlet) annotation (Line(
      points={{1170,-204},{1170,-210}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP2.outlet,preheater_LP3. aux1) annotation (Line(
      points={{1170,-230},{1170,-240},{1192,-240},{1192,-186},{1230,-186}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_preheater_LP3.outlet,preheater_LP2. In2) annotation (Line(
      points={{1194,-192},{1180,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_preheater_LP3.inlet1,preheater_LP3. Out2) annotation (Line(
      points={{1214,-192},{1220,-192},{1220,-176},{1268,-176},{1268,-188},{1250,-188}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP3.Out1,Pump_preheater_LP3. inlet) annotation (Line(
      points={{1240,-204},{1240,-240},{1230,-240}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_preheater_LP3.outlet,valve_afterPumpLP3. inlet) annotation (Line(
      points={{1210,-240},{1204,-240},{1204,-230}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_afterPumpLP3.outlet,join_preheater_LP3. inlet2) annotation (Line(
      points={{1204,-210},{1204,-202}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_IP3.outlet2,valve_IP3. inlet) annotation (Line(
      points={{1100,-40},{1100,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP1.outlet2,valve_LP2. inlet) annotation (Line(
      points={{1170,-40},{1170,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP2.outlet2,valve_LP3. inlet) annotation (Line(
      points={{1210,-40},{1210,-80},{1240,-80},{1240,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP3.outlet2,valve_LP4. inlet) annotation (Line(
      points={{1250,-40},{1250,-70},{1310,-70},{1310,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_LP3.outlet,preheater_LP3. In1) annotation (Line(
      points={{1240,-110},{1240,-184}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(setPoint_preheaterLP4.y,PID_preheaterLP4. u_s) annotation (Line(points={{1286.7,-310},{1296,-310},{1296,-320},{1306,-320}},
                                                                                                                                  color={0,0,127}));
  connect(PID_preheaterLP4.y,valveControl_preheater_LP4. opening_in) annotation (Line(points={{1329,-320},{1350,-320},{1350,-249}},
                                                                                                                                 color={0,0,127}));
  connect(preheater_LP3.level,PID_preheaterLP3. u_m) annotation (Line(points={{1248,-205},{1247.9,-205},{1247.9,-308}},
                                                                                                                     color={0,0,127}));
  connect(PID_preheaterLP3.y,Pump_preheater_LP3. P_drive) annotation (Line(points={{1237,-320},{1220,-320},{1220,-252}},
                                                                                                                      color={0,0,127}));
  connect(setPoint_preheaterLP3.y,PID_preheaterLP3. u_s) annotation (Line(points={{1271.3,-320},{1260,-320}},
                                                                                                            color={0,0,127}));
  connect(PID_preheaterLP2.y, valveControl_preheater_LP2.opening_in) annotation (Line(points={{1167,-320},{1156,-320},{1156,-220},{1161,-220}}, color={0,0,127}));
  connect(preheater_LP2.level, PID_preheaterLP2.u_m) annotation (Line(points={{1178,-205},{1178,-308},{1177.9,-308}}, color={0,0,127}));
  connect(setPoint_preheaterLP2.y, PID_preheaterLP2.u_s) annotation (Line(points={{1199.3,-320},{1190,-320}}, color={0,0,127}));
  connect(setPoint_preheaterLP1.y, PID_preheaterLP1.u_s) annotation (Line(points={{1129.3,-320},{1120,-320}}, color={0,0,127}));
  connect(Turbine_LP3.eye,quadruple18. eye) annotation (Line(points={{1237,-26},{1240,-26},{1240,20},{1280,20}},
                                                                                                           color={190,190,190}));
  connect(Turbine_LP2.eye,quadruple17. eye) annotation (Line(points={{1197,-26},{1200,-26},{1200,40},{1260,40}},
                                                                                                             color={190,190,190}));
  connect(Turbine_HP1.shaft_b,Turbine_IP1. shaft_a) annotation (Line(points={{856,-20},{922,-20}},
                                                                                                color={0,0,0}));
  connect(Turbine_IP1.shaft_b,Turbine_IP2. shaft_a) annotation (Line(points={{940,-20},{962,-20}},
                                                                                               color={0,0,0}));
  connect(Turbine_IP2.shaft_b,Turbine_IP3. shaft_a) annotation (Line(points={{980,-20},{1002,-20}},
                                                                                                color={0,0,0}));
  connect(Turbine_IP3.shaft_b,Turbine_LP1. shaft_a) annotation (Line(points={{1020,-20},{1142,-20}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP1.shaft_b,Turbine_LP2. shaft_a) annotation (Line(points={{1160,-20},{1182,-20}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP2.shaft_b,Turbine_LP3. shaft_a) annotation (Line(points={{1200,-20},{1222,-20}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP3.shaft_b,Turbine_LP4. shaft_a) annotation (Line(points={{1240,-20},{1262,-20}},
                                                                                                 color={0,0,0}));
  connect(Turbine_LP4.shaft_b,inertia. flange_a) annotation (Line(points={{1280,-20},{1412,-20}},
                                                                                              color={0,0,0}));
  connect(inertia.flange_b,simpleGenerator. shaft) annotation (Line(points={{1432,-20},{1432,-20.1},{1442,-20.1}},    color={0,0,0}));
  connect(simpleGenerator.powerConnection,boundaryElectricFrequency. electricPortIn) annotation (Line(
      points={{1462,-20},{1482,-20}},
      color={115,150,0},
      thickness=0.5));
  connect(valve_LP2.eye,quadruple19. eye) annotation (Line(points={{1166,-110},{1166,-120},{1174,-120}},
                                                                                                   color={190,190,190}));
  connect(valve_LP3.eye,quadruple20. eye) annotation (Line(points={{1236,-110},{1236,-120},{1244,-120}},
                                                                                                   color={190,190,190}));
  connect(valve_LP4.eye,quadruple21. eye) annotation (Line(points={{1306,-110},{1306,-120},{1316,-120}},
                                                                                                   color={190,190,190}));
  connect(setPoint_preheater_HP.y,PI_valveControl_preheater_HP. u_m) annotation (Line(points={{824.6,-336},{838.1,-336},{838.1,-332}},
                                                                                                                                   color={0,0,127}));
  connect(preheater_LP2.level,fillingLevel_preheater_LP2. u_in) annotation (Line(points={{1178,-205},{1176,-205},{1176,-204},{1177,-204}},
                                                                                                                                       color={0,0,127}));
  connect(preheater_LP3.level,fillingLevel_preheater_LP3. u_in) annotation (Line(points={{1248,-205},{1248,-204},{1247,-204}},
                                                                                                                            color={0,0,127}));
  connect(Turbine_IP1.outlet,Turbine_IP2. inlet) annotation (Line(
      points={{936,-30},{960,-30},{960,-14},{966,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_LP1.outlet1,Turbine_LP2. inlet) annotation (Line(
      points={{1180,-30},{1180,-14},{1186,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.eye2,quadruple22. eye) annotation (Line(points={{1159,-194},{1134,-194},{1134,-160},{1104,-160}},
                                                                                                                      color={190,190,190}));
  connect(preheater_LP3.eye2,quadruple23. eye) annotation (Line(points={{1251,-186},{1270,-186},{1270,-170},{1244,-170},{1244,-160}},       color={190,190,190}));
  connect(downComer_feedWaterTank.outlet,Pump_FW. inlet) annotation (Line(
      points={{948,-243},{948,-250},{930,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedWaterTank.feedwater,downComer_feedWaterTank. inlet) annotation (Line(
      points={{948,-208},{948,-215}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_IP1.outlet,feedWaterTank. heatingSteam) annotation (Line(
      points={{990,-110},{990,-182},{954,-182},{954,-190}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_HP.outlet,feedWaterTank. aux) annotation (Line(
      points={{864,-290},{1012,-290},{1012,-188},{990,-188},{990,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(setPoint_condenser.y,PI_Pump_cond. u_s) annotation (Line(points={{1471.3,-320},{1462,-320}},
                                                                                                     color={0,0,127}));
  connect(motor.shaft,Pump_cond. shaft) annotation (Line(points={{1410,-220},{1410,-207.9}},
                                                                                           color={0,0,0}));
  connect(measurement.y,PI_Pump_cond. u_m) annotation (Line(points={{1475.6,-340},{1449.9,-340},{1449.9,-332}},
                                                                                                             color={0,0,127}));
  connect(fixedVoltage.y,motor. U_term) annotation (Line(points={{1396.7,-260},{1410,-260},{1410,-242}},
                                                                                                      color={0,0,127}));
  connect(PI_Pump_cond.y,motor. f_term) annotation (Line(points={{1439,-320},{1414,-320},{1414,-242}},
                                                                                                    color={0,0,127}));
  connect(valveControl_preheater_LP1.outlet,boundaryVLE_phxi. steam_a) annotation (Line(
      points={{1496,-100},{1500,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_pipe.outlet, Turbine_HP1.inlet) annotation (Line(
      points={{370,276},{370,302},{842,302},{842,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rh_1.inlet, join_HP.outlet1) annotation (Line(
      points={{596,-16},{596,-52},{802,-52}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rh_pipe.outlet, Turbine_IP1.inlet) annotation (Line(
      points={{596,186},{596,218},{926,218},{926,-14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_pipe.eye, quadruple2.eye) annotation (Line(points={{373.4,276.6},{373.4,288},{406,288}},     color={190,190,190}));
  connect(rh_pipe.eye, quadruple1.eye) annotation (Line(points={{599.4,186.6},{599.4,202},{632,202}},        color={190,190,190}));
  connect(eco_riser.outlet, eco.inlet) annotation (Line(
      points={{123,-322},{123,-312}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(eco_riser_wall.innerPhase, eco_riser.heat) annotation (Line(
      points={{108,-336},{119,-336}},
      color={167,25,48},
      thickness=0.5));
  connect(splitVLE_L2_flex.outlet[1], eco_riser.inlet) annotation (Line(
      points={{644,-249.625},{644,-250},{482,-250},{482,-356},{123,-356},{123,-350}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitVLE_L2_flex.inlet, valveVLE_L1_1.inlet) annotation (Line(
      points={{664,-250},{690,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_1.eye, quadruple26.eye) annotation (Line(points={{373.4,-67.4},{373.4,-66},{374,-66},{374,-60},{380,-60}},      color={190,190,190}));
  connect(sh_2.eye, quadruple27.eye) annotation (Line(points={{375.4,34.6},{375.4,38},{376,38}},      color={190,190,190}));
  connect(sh_3.eye, quadruple28.eye) annotation (Line(points={{373.4,118.6},{373.4,138},{378,138}},                         color={190,190,190}));
  connect(quadruple30.eye, evap_4.eye) annotation (Line(points={{132,158},{126.4,158},{126.4,156.6}},                         color={190,190,190}));
  connect(ct_1.eye, quadruple29.eye) annotation (Line(points={{232.4,63.4},{232,63.4},{232,60}},         color={190,190,190}));
  connect(flameRoom_sh_1.heat_CarrierTubes, ct_1_wall.outerPhase[7]) annotation (Line(
      points={{-98,12},{20,12},{20,78},{204,78}},
      color={167,25,48},
      thickness=0.5));
  connect(regenerativeAirPreheater.freshAirOutlet, splitGas_L2_flex.inlet) annotation (Line(
      points={{-392,18},{-406,18},{-406,-106},{-400,-106}},
      color={118,106,98},
      thickness=0.5));
  connect(fluelGasFlowSource_burner1.gas_a, regenerativeAirPreheater.freshAirInlet) annotation (Line(
      points={{-420,30},{-392,30}},
      color={118,106,98},
      thickness=0.5));
  connect(regenerativeAirPreheater.flueGasOutlet, flueGasPressureSink_top.gas_a) annotation (Line(
      points={{-372,30},{-328,30},{-328,48}},
      color={118,106,98},
      thickness=0.5));
  connect(regenerativeAirPreheater.flueGasInlet, coalSlagFlueGas_split_top.flueGas_outlet) annotation (Line(
      points={{-372,18},{-290,18},{-290,276},{-128,276},{-128,232}},
      color={118,106,98},
      thickness=0.5));
  connect(PID_lambda.u_m,actual_lambda. y) annotation (Line(
      points={{-503.9,48},{-503.9,66},{-545,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lambda.y,PID_lambda. u_s) annotation (Line(
      points={{-545,36},{-516,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, coalFlowSource_burner2.m_flow) annotation (Line(points={{-379,-142},{-344,-142},{-344,-116},{-244,-116}}, color={0,0,127}));
  connect(gain.y, coalFlowSource_burner1.m_flow) annotation (Line(points={{-379,-142},{-244,-142}},                         color={0,0,127}));
  connect(gain.y, coalFlowSource_burner3.m_flow) annotation (Line(points={{-379,-142},{-344,-142},{-344,-90},{-244,-90}}, color={0,0,127}));
  connect(gain.y, coalFlowSource_burner4.m_flow) annotation (Line(points={{-379,-142},{-344,-142},{-344,-64},{-244,-64}}, color={0,0,127}));
  connect(splitGas_L2_flex.outlet[1], coalGas_join_burner4.flueGas_inlet) annotation (Line(
      points={{-380,-106.375},{-376,-106.375},{-376,-82},{-204,-82}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[2], coalGas_join_burner3.flueGas_inlet) annotation (Line(
      points={{-380,-106.125},{-376,-106.125},{-376,-108},{-204,-108}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[3], coalGas_join_burner2.flueGas_inlet) annotation (Line(
      points={{-380,-105.875},{-376,-105.875},{-376,-134},{-204,-134}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[4], coalGas_join_burner1.flueGas_inlet) annotation (Line(
      points={{-380,-105.625},{-376,-105.625},{-376,-160},{-204,-160}},
      color={118,106,98},
      thickness=0.5));
  connect(PID_lambda.y, firstOrder.u) annotation (Line(points={{-493,36},{-480,36}}, color={0,0,127}));
  connect(firstOrder.y, fluelGasFlowSource_burner1.m_flow) annotation (Line(points={{-457,36},{-440,36}}, color={0,0,127}));
  connect(preheater_HP.level, fillingLevel_preheater_HP.u_in) annotation (Line(points={{820,-263},{820,-264},{820,-264},{820,-264},{820,-262},{819,-262}},
                                                                                                                                     color={0,0,127}));
  connect(preheater_HP.level, PI_valveControl_preheater_HP.u_s) annotation (Line(points={{820,-263},{820,-320},{826,-320}}, color={0,0,127}));
  connect(valveVLE_L1_1.outlet, preheater_HP.Out2) annotation (Line(
      points={{710,-250},{802,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(statePoint.port, preheater_HP.Out2) annotation (Line(
      points={{740,-250},{802,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_HP.eye2, quadruple25.eye) annotation (Line(points={{801,-252},{728,-252},{728,-256},{728,-256},{728,-262},{730,-262}}, color={190,190,190}));
  connect(preheater_HP.Out1, valveControl_preheater_HP.inlet) annotation (Line(
      points={{812,-262},{812,-290},{844,-290}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve_HP.outlet, preheater_HP.In1) annotation (Line(
      points={{812,-110},{812,-242.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.Out2, preheater_LP3.In2) annotation (Line(
      points={{1320,-188},{1330,-188},{1330,-176},{1284,-176},{1284,-198},{1250,-198}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_cond.outlet, preheater_LP4.In2) annotation (Line(
      points={{1400,-198},{1320,-198}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.Out1, valveControl_preheater_LP4.inlet) annotation (Line(
      points={{1310,-204},{1310,-240},{1340,-240}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP4.level, fillingLevel_preheater_LP4.u_in) annotation (Line(points={{1318,-205},{1318,-206},{1318,-206},{1318,-206},{1318,-204},{1317,-204}},
                                                                                                                                           color={0,0,127}));
  connect(preheater_LP4.level, PID_preheaterLP4.u_m) annotation (Line(points={{1318,-205},{1318,-308},{1318.1,-308}}, color={0,0,127}));
  connect(quadruple24.eye, preheater_LP4.eye2) annotation (Line(points={{1316,-160},{1314,-160},{1314,-182},{1321,-182},{1321,-186}}, color={190,190,190}));
  connect(preheater_LP1.In1, valve_IP3.outlet) annotation (Line(
      points={{1100,-184.2},{1100,-184.2},{1100,-110},{1100,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP1.Out1, Pump_preheater_LP1.inlet) annotation (Line(
      points={{1100,-204},{1100,-204},{1100,-240},{1070,-240}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP2.Out2, preheater_LP1.In2) annotation (Line(
      points={{1160,-192},{1110,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valvePreFeedWaterTank.inlet, preheater_LP1.Out2) annotation (Line(
      points={{1070,-192},{1090,-192}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(preheater_LP1.level, fillingLevel_preheater_LP1.u_in) annotation (Line(points={{1108,-205},{1108,-206},{1108,-206},{1108,-206},{1108,-204},{1107,-204}},
                                                                                                                                           color={0,0,127}));
  connect(preheater_LP1.level, PID_preheaterLP1.u_m) annotation (Line(points={{1108,-205},{1108,-256},{1107.9,-256},{1107.9,-308}}, color={0,0,127}));
  connect(preheater_LP4.In1, valve_LP4.outlet) annotation (Line(
      points={{1310,-184},{1310,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveControl_preheater_LP1.inlet, condenser.Out2) annotation (Line(
      points={{1476,-100},{1476,-100},{1468,-100},{1468,-114},{1450,-114}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.steam_a, condenser.In2) annotation (Line(
      points={{1500,-140},{1468,-140},{1468,-124},{1450,-124},{1450,-124}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Turbine_LP4.outlet, condenser.In1) annotation (Line(
      points={{1276,-30},{1276,-52},{1440,-52},{1440,-110.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(condenser.aux1, valveControl_preheater_LP4.outlet) annotation (Line(
      points={{1430,-112},{1380,-112},{1380,-240},{1360,-240}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Pump_cond.inlet, condenser.Out1) annotation (Line(
      points={{1420,-198},{1440,-198},{1440,-154},{1440,-154},{1440,-130}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fillingLevel_condenser.u_in, condenser.level) annotation (Line(points={{1447,-130},{1448,-130},{1448,-134},{1448,-132},{1448,-132},{1448,-131}}, color={0,0,127}));
  connect(condenser.level, measurement.u) annotation (Line(points={{1448,-131},{1448,-206},{1502,-206},{1502,-340},{1484.8,-340}}, color={0,0,127}));
  connect(condenser.eye1, quadruple5.eye) annotation (Line(points={{1444,-131},{1444,-158},{1450,-158},{1450,-160}}, color={190,190,190}));
  connect(quadruple10.eye, preheater_LP1.eye2) annotation (Line(points={{1030,-160},{1048,-160},{1048,-160},{1090,-160},{1090,-194},{1089,-194}}, color={190,190,190}));
  connect(scalar2VectorHeatPort11.heatVector, rh_1_wall.outerPhase) annotation (Line(
      points={{554,-2},{572,-2}},
      color={167,25,48},
      thickness=0.5));
  connect(rh_1_wall.innerPhase, rh_1.heat) annotation (Line(
      points={{582,-2},{592,-2}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort1.heatVector, sh_1_wall.outerPhase) annotation (Line(
      points={{324,-82},{344,-82}},
      color={167,25,48},
      thickness=0.5));
  connect(sh_1_wall.innerPhase, sh_1.heat) annotation (Line(
      points={{354,-82},{366,-82}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort8.heatVector, sh_2_wall.outerPhase) annotation (Line(
      points={{328,20},{348,20}},
      color={167,25,48},
      thickness=0.5));
  connect(sh_2_wall.innerPhase, sh_2.heat) annotation (Line(
      points={{358,20},{368,20}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort9.heatVector, sh_3_wall.outerPhase) annotation (Line(
      points={{326,104},{348,104}},
      color={167,25,48},
      thickness=0.5));
  connect(sh_3_wall.innerPhase, sh_3.heat) annotation (Line(
      points={{358,104},{366,104}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort10.heatVector, sh_4_wall.outerPhase) annotation (Line(
      points={{322,216},{341,216}},
      color={167,25,48},
      thickness=0.5));
  connect(sh_4_wall.innerPhase, sh_4.heat) annotation (Line(
      points={{351,216},{366,216}},
      color={167,25,48},
      thickness=0.5));
  connect(ct_1_wall.innerPhase, ct_1.heat) annotation (Line(
      points={{214,78},{225,78}},
      color={167,25,48},
      thickness=0.5));
  connect(evap_4_wall.innerPhase, evap_4.heat) annotation (Line(
      points={{114,142},{116,142},{116,142},{119,142}},
      color={167,25,48},
      thickness=0.5));
  connect(evap_3_wall.innerPhase, evap_3.heat) annotation (Line(
      points={{112,40},{119,40}},
      color={167,25,48},
      thickness=0.5));
  connect(evap_2_wall.innerPhase, evap_2.heat) annotation (Line(
      points={{110,-24},{119,-24}},
      color={167,25,48},
      thickness=0.5));
  connect(evap_1_wall.innerPhase, evap_1.heat) annotation (Line(
      points={{112,-120},{116,-120},{116,-120},{119,-120}},
      color={167,25,48},
      thickness=0.5));
  connect(quadruple32.eye, rh_1.eye) annotation (Line(points={{534,26},{599.4,26},{599.4,12.6}},      color={190,190,190}));
  connect(burner1.eyeOut, quadrupleGas.eye) annotation (Line(points={{-148,-146},{-152,-146},{-152,-141},{-82,-141}}, color={190,190,190}));
  connect(quadrupleGas6.eye, flameRoom_sh_1.eyeOut) annotation (Line(points={{-176,10},{-148,10}},                     color={190,190,190}));
  connect(quadrupleGas5.eye, flameRoom_evap_2.eyeOut) annotation (Line(points={{-174,-16},{-148,-16}},                       color={190,190,190}));
  connect(quadrupleGas4.eye, flameRoom_evap_1.eyeOut) annotation (Line(points={{-72,-42},{-148,-42}},                       color={190,190,190}));
  connect(quadrupleGas3.eye, burner4.eyeOut) annotation (Line(points={{-72,-68},{-148,-68}},                       color={190,190,190}));
  connect(quadrupleGas2.eye, burner3.eyeOut) annotation (Line(points={{-74,-94},{-148,-94}},                       color={190,190,190}));
  connect(quadrupleGas1.eye, burner2.eyeOut) annotation (Line(points={{-80,-120},{-148,-120}},                         color={190,190,190}));
  connect(quadrupleGas12.eye, flameRoom_eco.eyeOut) annotation (Line(points={{-182,198},{-182,198},{-182,178},{-166,178},{-166,178},{-148,178}},
                                                                                                                           color={190,190,190}));
  connect(quadrupleGas11.eye, flameRoom_rh_1.eyeOut) annotation (Line(points={{-178,150},{-148,150}},                       color={190,190,190}));
  connect(quadrupleGas10.eye, flameRoom_sh_3.eyeOut) annotation (Line(points={{-178,122},{-148,122}},                       color={190,190,190}));
  connect(quadrupleGas9.eye, flameRoom_rh_2.eyeOut) annotation (Line(points={{-176,94},{-148,94}},                     color={190,190,190}));
  connect(quadrupleGas8.eye, flameRoom_sh_4.eyeOut) annotation (Line(points={{-178,66},{-148,66}},                     color={190,190,190}));
  connect(quadrupleGas7.eye, flameRoom_sh_2.eyeOut) annotation (Line(points={{-178,38},{-148,38}},                     color={190,190,190}));
  connect(quadrupleGas13.eye, regenerativeAirPreheater.eye_freshAir) annotation (Line(points={{-390,-3},{-392,-3},{-392,8},{-392.2,8},{-392.2,15.4}}, color={190,190,190}));
  connect(regenerativeAirPreheater.eye_flueGas, quadrupleGas14.eye) annotation (Line(points={{-371.8,32.6},{-371.8,37.3},{-366,37.3},{-366,41}}, color={190,190,190}));
  connect(boilergasTemperatures.y, xYplot.y1) annotation (Line(points={{-240,19},{-240,29.7857},{-239.333,29.7857}}, color={0,0,127}));
  connect(boilerZpositions.y, xYplot.x1) annotation (Line(points={{-186,97},{-186,98},{-195.933,98},{-195.933,98.1429}},             color={0,0,127}));
  connect(evap_3.eye, quadruple36.eye) annotation (Line(points={{126.4,54.6},{126.4,62},{132,62}},      color={190,190,190}));
  connect(evap_2.eye, quadruple35.eye) annotation (Line(points={{126.4,-9.4},{132,-9.4},{132,-16}},                    color={190,190,190}));
  connect(evap_1.eye, quadruple37.eye) annotation (Line(points={{126.4,-105.4},{126.4,-96},{146,-96}},     color={190,190,190}));
  connect(evap_0.eye, quadruple38.eye) annotation (Line(points={{126.4,-165.4},{126.4,-166},{140,-166}},     color={190,190,190}));
  connect(eco.eye, quadruple39.eye) annotation (Line(points={{126.4,-283.4},{126.4,-284},{140,-284}},     color={190,190,190}));
  connect(boilerZpositions2.y, xYplot.x2) annotation (Line(points={{-186,137},{-186,147.857},{-195.933,147.857}},            color={0,0,127}));
  connect(boilervleTemperatures.y, xYplot.y2) annotation (Line(points={{-219,19},{-219,29.7857},{-218.667,29.7857}},           color={0,0,127}));
  connect(PTarget.y, feedForwardBlock_3508_1.P_G_target_) annotation (Line(points={{-455,-396},{-444,-396}}, color={0,0,127}));
  connect(rollerBowlMill_L1_1.coalDust, Nominal_PowerFeedwaterPump1.u) annotation (Line(points={{-369,-396},{865.2,-396}}, color={0,0,127}));
  connect(feedForwardBlock_3508_1.P_max_, P_max_.y) annotation (Line(points={{-440,-380},{-440,-364},{-457,-364}}, color={0,0,127}));
  connect(feedForwardBlock_3508_1.P_min_, P_min_.y) annotation (Line(points={{-436,-380},{-436,-346},{-457,-346}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_max_) annotation (Line(points={{-457,-328},{-432,-328},{-432,-380}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_StG_) annotation (Line(points={{-457,-328},{-428,-328},{-428,-380}}, color={0,0,127}));
  connect(P_min_1.y, feedForwardBlock_3508_1.derP_T_) annotation (Line(points={{-457,-328},{-424,-328},{-424,-380}}, color={0,0,127}));
  connect(Nominal_PowerFeedwaterPump1.y, PI_feedwaterPump.u_s) annotation (Line(points={{874.4,-396},{890,-396}}, color={0,0,127}));
  connect(sensorFWflow.m_flow, PI_feedwaterPump.u_m) annotation (Line(points={{875,-240},{902.1,-240},{902.1,-384}}, color={0,0,127}));
  connect(PI_feedwaterPump.y, Pump_FW.P_drive) annotation (Line(points={{913,-396},{920,-396},{920,-262}}, color={0,0,127}));
  connect(preheater_HP.In2, sensorFWflow.outlet) annotation (Line(
      points={{822,-250},{876,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sensorFWflow.inlet, Pump_FW.outlet) annotation (Line(
      points={{896,-250},{910,-250}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_1.outlet, sprayInjector_sh2.inlet1) annotation (Line(
      points={{370,-68},{370,-48}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh2.outlet, sh_2.inlet) annotation (Line(
      points={{370,-28},{370,6},{372,6}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh2.inlet2, injectionControl_sh2.outlet) annotation (Line(
      points={{380,-38},{482,-38},{482,-121}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh2.inlet, splitVLE_L2_flex.outlet[3]) annotation (Line(
      points={{482,-141},{482,-250.125},{644,-250.125}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sh_3.outlet, sprayInjector_sh4.inlet1) annotation (Line(
      points={{370,118},{370,150}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh4.outlet, sh_4.inlet) annotation (Line(
      points={{370,170},{370,202}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh4.inlet, splitVLE_L2_flex.outlet[4]) annotation (Line(
      points={{518,-141},{518,-250.375},{644,-250.375}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_sh4.outlet, sprayInjector_sh4.inlet2) annotation (Line(
      points={{518,-121},{518,160},{380,160}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(rh_1.outlet, sprayInjector_sh1.inlet1) annotation (Line(
      points={{596,12},{596,60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(sprayInjector_sh1.outlet, rh_2.inlet) annotation (Line(
      points={{596,80},{596,110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_rh2.outlet, sprayInjector_sh1.inlet2) annotation (Line(
      points={{620,-121},{620,70},{606,70}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(injectionControl_rh2.inlet, splitVLE_L2_flex.outlet[2]) annotation (Line(
      points={{620,-141},{620,-249.875},{644,-249.875}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple33.eye, sprayInjector_sh2.eye) annotation (Line(points={{300,-24},{362,-24},{362,-28}},
                                                                                                         color={190,190,190}));
  connect(quadruple34.eye, sprayInjector_sh4.eye) annotation (Line(points={{302,174},{362,174},{362,170}}, color={190,190,190}));
  connect(quadruple31.eye, sprayInjector_sh1.eye) annotation (Line(points={{532,80},{588,80}},          color={190,190,190}));
  connect(eco.outlet, eco_down.inlet) annotation (Line(
      points={{123,-284},{123,-284},{123,-258}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(eco_down.outlet, evap_0.inlet) annotation (Line(
      points={{123,-230},{123,-213},{123,-213},{123,-194}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(evap_0.outlet, evap_1.inlet) annotation (Line(
      points={{123,-166},{123,-150},{123,-150},{123,-134}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedForwardBlock_3508_1.QF_FF_, firstOrder1.u) annotation (Line(points={{-421,-396},{-416.8,-396}}, color={0,0,127}));
  connect(firstOrder1.y, rollerBowlMill_L1_1.rawCoal) annotation (Line(points={{-407.6,-396},{-390.8,-396}}, color={0,0,127}));
  connect(firstOrder1.y, gain.u) annotation (Line(points={{-407.6,-396},{-406,-396},{-406,-142},{-402,-142}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-580,-480},{1540,460}}),
                      graphics={
        Rectangle(
          extent={{1478,440},{1520,360}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{1438,440},{1478,360}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{1442,442},{1470,422}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleINIT"),
        Text(
          extent={{1436,402},{1476,382}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleSettings"),
        Text(
          extent={{1480,422},{1514,404}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Model
Properties"),                     Text(
          extent={{-578,436},{-382,372}},
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
          extent={{-578,342},{-378,324}},
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
    Icon(coordinateSystem(preserveAspectRatio=true, initialScale=0.1)),
__Dymola_experimentFlags(
    Hidden(SmallerDAEIncidence=false)));
end SteamPowerPlant_01;
