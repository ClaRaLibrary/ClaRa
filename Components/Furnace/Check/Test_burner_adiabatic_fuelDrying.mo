within ClaRa.Components.Furnace.Check;
model Test_burner_adiabatic_fuelDrying
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;

  Adapters.FuelSlagFlueGas_split                  coalSlagFlueGas_split_top   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,244})));
  BoundaryConditions.BoundarySlag_Tm_flow                  slagFlowSource_top(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-2,288})));
  BoundaryConditions.BoundaryFuel_pTxi coalSink_top(T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-28,276})));
  BoundaryConditions.BoundaryGas_pTxi                  flueGasPressureSink_top(p_const=100000, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={24,276})));
  inner SimCenter simCenter(
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel,
    redeclare ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v3 fuelModel1)
    annotation (Placement(transformation(extent={{98,62},{118,82}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource(
    m_flow_const=15,
    T_const=293.15)                       annotation (Placement(transformation(extent={{-138,-30},{-118,-10}})));
  BoundaryConditions.BoundaryGas_Txim_flow                  flueGasFlowSource(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=15*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0}) annotation (Placement(transformation(extent={{-106,-42},{-86,-22}})));
  Adapters.FuelFlueGas_join                  coalGas_join_burner   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,-26})));
  Adapters.FuelSlagFlueGas_join                  coalSlagFlueGas_join   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-54})));
  BoundaryConditions.BoundaryGas_Txim_flow                  flueGasFlowSourcee_bottom(m_flow_const=0, T_const=283.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={16,-94})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_bottom(
    m_flow_const=0,
    T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-24,-94})));
  BoundaryConditions.BoundarySlag_pT                  slagSink_bottom(T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-94})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureBottom(Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-50})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureWall(Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={66,-26})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop(T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,16})));
  Burner.Burner_L2_Dynamic                          burner(
    T_slag=873,
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone (xi_NOx=0, xi_CO=0),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        z_in={0},
        z_out={5},
        width=10,
        length=burner.geo.z_out[1] - burner.geo.z_in[1],
        height=10),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    redeclare model HeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2,
    redeclare model HeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2)
                                                                                                                       annotation (Placement(transformation(extent={{-18,-36},{42,-16}})));
  Adapters.FuelSlagFlueGas_split                  coalSlagFlueGas_split_top1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,-164})));
  BoundaryConditions.BoundarySlag_Tm_flow                  slagFlowSource_top1(m_flow_const=0.0, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-2,-120})));
  BoundaryConditions.BoundaryFuel_pTxi coalSink_top1(
                                                    T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-28,-132})));
  BoundaryConditions.BoundaryGas_pTxi                  flueGasPressureSink_top1(p_const=100000, T_const=658.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={24,-132})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource1(
    m_flow_const=15,
    T_const=298.15)                       annotation (Placement(transformation(extent={{-136,-224},{-116,-204}})));
  BoundaryConditions.BoundaryGas_Txim_flow                  flueGasFlowSource1(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=15*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0}) annotation (Placement(transformation(extent={{-104,-236},{-84,-216}})));
  Adapters.FuelFlueGas_join                  coalGas_join_burner1   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-52,-220})));
  Adapters.FuelSlagFlueGas_join                  coalSlagFlueGas_join1   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,-248})));
  BoundaryConditions.BoundaryGas_Txim_flow                  flueGasFlowSourcee_bottom1(m_flow_const=0, T_const=283.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={18,-288})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_bottom1(
    T_const=293.15,
    m_flow_const=0)                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-22,-288})));
  BoundaryConditions.BoundarySlag_pT                  slagSink_bottom1(T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,-288})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureBottom1(
                                                                             Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-244})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperatureWall1(
                                                                           Q_flow=0)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-220})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop1(
                                                                             T=658.15)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={58,-186})));
  Burner.Burner_L2_Dynamic_fuelDrying                          burner_drying(
    T_slag=873,
    redeclare model HeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone (xi_NOx=0, xi_CO=0),
    redeclare model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        z_in={0},
        z_out={5},
        width=10,
        length=burner.geo.z_out[1] - burner.geo.z_in[1],
        height=10),
    redeclare model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime) annotation (Placement(transformation(extent={{-16,-230},{44,-210}})));
  Burner.Burner_L2_Dynamic                          burner1(
    T_slag=873,
    redeclare model ReactionZone = ChemicalReactions.CoalReactionZone (xi_NOx=0, xi_CO=0),
    redeclare model ParticleMigration = GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        z_in={0},
        z_out={5},
        width=10,
        length=burner.geo.z_out[1] - burner.geo.z_in[1],
        height=10),
    redeclare model Burning_time = GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    redeclare model HeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2,
    redeclare model HeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2)
                                                                                                                       annotation (Placement(transformation(extent={{-16,32},{44,52}})));
  Adapters.FuelFlueGas_join                  coalGas_join_burner2  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-52,42})));
  BoundaryConditions.BoundaryGas_Txim_flow                  flueGasFlowSource2(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=15*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0}) annotation (Placement(transformation(extent={{-104,26},{-84,46}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource2(m_flow_const=15, T_const=293.15)
                                          annotation (Placement(transformation(extent={{-136,38},{-116,58}})));
  Burner.Burner_L2_Dynamic                          burner2(
    T_slag=873,
    redeclare model ReactionZone = ChemicalReactions.CoalReactionZone (xi_NOx=0, xi_CO=0),
    redeclare model ParticleMigration = GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        z_in={0},
        z_out={5},
        width=10,
        length=burner.geo.z_out[1] - burner.geo.z_in[1],
        height=10),
    redeclare model Burning_time = GeneralTransportPhenomena.BurningTime.ConstantBurningTime,
    redeclare model PressureLoss = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    redeclare model HeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2,
    redeclare model HeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2)
                                                                                                                       annotation (Placement(transformation(extent={{-24,100},{36,120}})));
  Adapters.FuelFlueGas_join                  coalGas_join_burner3  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,110})));
  BoundaryConditions.BoundaryGas_Txim_flow                  flueGasFlowSource3(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=15*10.396,
    T_const=573.15,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0}) annotation (Placement(transformation(extent={{-112,94},{-92,114}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource3(m_flow_const=15, T_const=293.15)
                                          annotation (Placement(transformation(extent={{-144,106},{-124,126}})));
  FlameRoom.FlameRoomWithTubeBundle_L2_Dynamic flameRoomWithTubeBundle_L2_Dynamic(
    redeclare model HeatTransfer_Wall = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_advanced_L2,
    redeclare model HeatTransfer_Top = Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_advanced_L2,
    redeclare model HeatTransfer_CarrierTubes =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_carrierTubes_turbulent_L2,
    redeclare model HeatTransfer_TubeBundle =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.ConvectionAndRadiation_tubeBank_L2)                                       annotation (Placement(transformation(extent={{-6,176},{54,196}})));
equation
  connect(flueGasFlowSource.gas_a,coalGas_join_burner. flueGas_inlet)
    annotation (Line(
      points={{-86,-32},{-64,-32}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner.fuelFlueGas_outlet,burner. fuelFlueGas_inlet) annotation (Line(
      points={{-44,-26},{-18,-26}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.fuelSlagFlueGas_outlet,burner. inlet)
    annotation (Line(
      points={{-4,-44},{-4,-36}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join.flueGas_inlet,flueGasFlowSourcee_bottom. gas_a)
    annotation (Line(
      points={{2,-64},{2,-74},{16,-74},{16,-84}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slagSink_bottom.slag_inlet,coalSlagFlueGas_join. slag_outlet)
    annotation (Line(
      points={{-3.8,-84},{-3.8,-74},{-4,-74},{-4,-64}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_bottom,fixedTemperatureBottom. port) annotation (Line(
      points={{14,-36},{14,-50},{56,-50}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_wall,fixedTemperatureWall. port) annotation (Line(
      points={{42,-26},{56,-26}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink_top.gas_a,coalSlagFlueGas_split_top. flueGas_outlet) annotation (Line(
      points={{24,266},{24,262},{4,262},{4,254}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top.slag_inlet,slagFlowSource_top. slag_outlet) annotation (Line(
      points={{-2,254},{-2,278}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource1.gas_a,coalGas_join_burner1. flueGas_inlet) annotation (Line(
      points={{-84,-226},{-62,-226}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join_burner1.fuelFlueGas_outlet,burner_drying. fuelFlueGas_inlet) annotation (Line(
      points={{-42,-220},{-16,-220}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top1.fuelSlagFlueGas_inlet,burner_drying. outlet) annotation (Line(
      points={{-2,-174},{-2,-210}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join1.fuelSlagFlueGas_outlet,burner_drying. inlet) annotation (Line(
      points={{-2,-238},{-2,-230}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_join1.flueGas_inlet,flueGasFlowSourcee_bottom1. gas_a) annotation (Line(
      points={{4,-258},{4,-268},{18,-268},{18,-278}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slagSink_bottom1.slag_inlet,coalSlagFlueGas_join1. slag_outlet) annotation (Line(
      points={{-1.8,-278},{-1.8,-268},{-2,-268},{-2,-258}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner_drying.heat_bottom,fixedTemperatureBottom1. port) annotation (Line(
      points={{16,-230},{16,-244},{58,-244}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner_drying.heat_wall,fixedTemperatureWall1. port) annotation (Line(
      points={{44,-220},{58,-220}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner_drying.heat_top,fixedTemperatureTop1. port) annotation (Line(
      points={{16,-210},{16,-186},{48,-186}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink_top1.gas_a,coalSlagFlueGas_split_top1. flueGas_outlet) annotation (Line(
      points={{24,-142},{24,-146},{4,-146},{4,-154}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split_top1.slag_inlet,slagFlowSource_top1. slag_outlet) annotation (Line(
      points={{-2,-154},{-2,-130}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
connect(coalFlowSource.fuel_a,coalGas_join_burner. fuel_inlet) annotation (Line(
    points={{-118,-20},{-64,-20}},
    color={27,36,42},
    pattern=LinePattern.Solid,
    thickness=0.5));
connect(coalFlowSource1.fuel_a,coalGas_join_burner1. fuel_inlet) annotation (Line(
    points={{-116,-214},{-62,-214}},
    color={27,36,42},
    pattern=LinePattern.Solid,
    thickness=0.5));
connect(coalFlowSource_bottom1.fuel_a,coalSlagFlueGas_join1. fuel_inlet) annotation (Line(
    points={{-22,-278},{-16,-278},{-16,-258},{-8,-258}},
    color={27,36,42},
    pattern=LinePattern.Solid,
    thickness=0.5));
connect(coalSink_top1.fuel_a,coalSlagFlueGas_split_top1. fuel_outlet) annotation (Line(
    points={{-28,-142},{-18,-142},{-18,-154},{-8,-154}},
    color={27,36,42},
    thickness=0.5));
connect(coalSink_top.fuel_a,coalSlagFlueGas_split_top. fuel_outlet) annotation (Line(
    points={{-28,266},{-18,266},{-18,254},{-8,254}},
    color={27,36,42},
    thickness=0.5));
connect(coalFlowSource_bottom.fuel_a,coalSlagFlueGas_join. fuel_inlet) annotation (Line(
    points={{-24,-84},{-18,-84},{-18,-64},{-10,-64}},
    color={27,36,42},
    pattern=LinePattern.Solid,
    thickness=0.5));
  connect(coalGas_join_burner2.fuelFlueGas_outlet, burner1.fuelFlueGas_inlet) annotation (Line(
      points={{-42,42},{-16,42}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource2.fuel_a, coalGas_join_burner2.fuel_inlet) annotation (Line(
      points={{-116,48},{-62,48}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flueGasFlowSource2.gas_a, coalGas_join_burner2.flueGas_inlet) annotation (Line(
      points={{-84,36},{-62,36}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner.heat_top, burner1.heat_bottom) annotation (Line(
      points={{14,-16},{16,-16},{16,32},{16,32}},
      color={167,25,48},
      thickness=0.5));
  connect(burner.outlet, burner1.inlet) annotation (Line(
      points={{-4,-16},{-2,-16},{-2,32}},
      color={118,106,98},
      thickness=0.5));
  connect(burner1.heat_wall, fixedTemperatureTop.port) annotation (Line(
      points={{44,42},{44,16},{80,16}},
      color={167,25,48},
      thickness=0.5));
  connect(coalGas_join_burner3.fuelFlueGas_outlet, burner2.fuelFlueGas_inlet) annotation (Line(
      points={{-50,110},{-24,110}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalFlowSource3.fuel_a, coalGas_join_burner3.fuel_inlet) annotation (Line(
      points={{-124,116},{-70,116}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flueGasFlowSource3.gas_a, coalGas_join_burner3.flueGas_inlet) annotation (Line(
      points={{-92,104},{-70,104}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(burner1.outlet, burner2.inlet) annotation (Line(
      points={{-2,52},{-8,52},{-8,100},{-10,100}},
      color={118,106,98},
      thickness=0.5));
  connect(burner1.heat_top, burner2.heat_bottom) annotation (Line(
      points={{16,52},{12,52},{12,100},{8,100}},
      color={167,25,48},
      thickness=0.5));
  connect(burner2.heat_wall, fixedTemperatureTop.port) annotation (Line(
      points={{36,110},{80,110},{80,16}},
      color={167,25,48},
      thickness=0.5));
  connect(burner2.outlet, flameRoomWithTubeBundle_L2_Dynamic.inlet) annotation (Line(
      points={{-10,120},{0,120},{0,176},{8,176}},
      color={118,106,98},
      thickness=0.5));
  connect(flameRoomWithTubeBundle_L2_Dynamic.outlet, coalSlagFlueGas_split_top.fuelSlagFlueGas_inlet) annotation (Line(
      points={{8,196},{4,196},{4,234},{-2,234}},
      color={118,106,98},
      thickness=0.5));
  connect(burner2.heat_top, flameRoomWithTubeBundle_L2_Dynamic.heat_bottom) annotation (Line(
      points={{8,120},{18,120},{18,176},{26,176}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoomWithTubeBundle_L2_Dynamic.heat_TubeBundle, fixedTemperatureTop.port) annotation (Line(
      points={{44,176},{62,176},{62,16},{80,16}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoomWithTubeBundle_L2_Dynamic.heat_wall, fixedTemperatureTop.port) annotation (Line(
      points={{54,186},{70,186},{70,16},{80,16}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoomWithTubeBundle_L2_Dynamic.heat_CarrierTubes, fixedTemperatureTop.port) annotation (Line(
      points={{44,196},{68,196},{68,186},{80,186},{80,16}},
      color={167,25,48},
      thickness=0.5));
  connect(flameRoomWithTubeBundle_L2_Dynamic.heat_top, fixedTemperatureTop.port) annotation (Line(
      points={{26,196},{80,196},{80,16}},
      color={167,25,48},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-140,-300},{120,100}},
          preserveAspectRatio=false), graphics={
                                Text(
          extent={{-136,322},{-52,276}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>>Tester for calculation of the adiabatic outlet temperature of a burner level

")}),                                                                    Icon(graphics,
        coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    experiment(StopTime=10));
end Test_burner_adiabatic_fuelDrying;
