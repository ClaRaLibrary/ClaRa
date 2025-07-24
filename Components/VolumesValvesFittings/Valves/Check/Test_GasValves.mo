within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model Test_GasValves
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



  GenericValveGas_L1 valve1(openingInputIsActive=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                              Delta_p_nom=2e5, m_flow_nom=10)) annotation (Placement(transformation(extent={{-80,124},{-60,136}})));

  inner SimCenter simCenter(redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel, showExpertSummary=true)
    annotation (Placement(transformation(extent={{162,232},{182,252}})));

  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT(p_const=800000, xi_const={0,0,0.0,0,0.77,0.23,0,0,0})
                                                                 annotation (Placement(transformation(extent={{80,120},{60,140}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=8,
    offset=1,
    startTime=1,
    height=-0.9)
    annotation (Placement(transformation(extent={{-110,150},{-90,170}})));
  GenericValveGas_L1 valve2(
    openingInputIsActive=true,
    useHomotopy=false,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible (Kvs_in=100, m_flow_nom=10))
                                                                                             annotation (Placement(transformation(extent={{-60,94},{-40,106}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T1(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT1(p_const=800000, xi_const={0,0,0.0,0,0.77,0.23,0,0,0})
                                                                  annotation (Placement(transformation(extent={{80,90},{60,110}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T2(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,66},{-180,86}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT2(p_const=800000, xi_const={0,0,0.0,0,0.77,0.23,0,0,0})
                                                                  annotation (Placement(transformation(extent={{80,66},{60,86}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-150,-160},{-130,-140}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T3(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,-176},{-180,-156}})));
  Adapters.FuelFlueGas_join coalGas_join annotation (Placement(transformation(extent={{-110,-170},{-90,-150}})));
  Adapters.FuelFlueGas_split coalGas_split annotation (Placement(transformation(extent={{60,-170},{80,-150}})));
  BoundaryConditions.BoundaryFuel_pTxi coalSink(p_const=800000) annotation (Placement(transformation(extent={{120,-160},{100,-140}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT3(p_const=800000) annotation (Placement(transformation(extent={{120,-180},{100,-160}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource1(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T4(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,-126},{-180,-106}})));
  Adapters.FuelFlueGas_join coalGas_join1 annotation (Placement(transformation(extent={{-110,-120},{-90,-100}})));
  Adapters.FuelFlueGas_split coalGas_split1 annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  BoundaryConditions.BoundaryFuel_pTxi coalSink1(p_const=800000) annotation (Placement(transformation(extent={{120,-110},{100,-90}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT4(p_const=800000) annotation (Placement(transformation(extent={{120,-130},{100,-110}})));
  ValveFuelFlueGas_L1 coalDustValve2(openingInputIsActive=true, redeclare model PressureLoss =
        Fundamentals.Quadratic_EN60534_compressible (                                                                                       Kvs_in=100, m_flow_nom=10))
                                                                                          annotation (Placement(transformation(extent={{-60,-115},{-40,-103}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource2(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-150,-60},{-130,-40}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T5(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,-76},{-180,-56}})));
  Adapters.FuelFlueGas_join coalGas_join2 annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Adapters.FuelFlueGas_split coalGas_split2 annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  BoundaryConditions.BoundaryFuel_pTxi coalSink2(p_const=800000) annotation (Placement(transformation(extent={{120,-60},{100,-40}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT5(p_const=800000) annotation (Placement(transformation(extent={{120,-80},{100,-60}})));
  ValveFuelFlueGas_L1 coalDustValve1(openingInputIsActive=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      m_flow_nom=10, Delta_p_nom=2e5)) annotation (Placement(transformation(extent={{-80,-65},{-60,-53}})));

  GenericValveGas_L1 valve3(
    openingInputIsActive=true,
    useHomotopy=false,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=10,
        Delta_p_nom=2e5,
        rho_in_nom=1)) annotation (Placement(transformation(extent={{-40,70},{-20,82}})));
  GenericValveGas_L1 valve4(
    openingInputIsActive=true,
    useHomotopy=false,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible (
        paraOption=3,
        m_flow_nom=10,
        A_cross=0.2,
        zeta=0.5)) annotation (Placement(transformation(extent={{-20,44},{0,56}})));
  GenericValveGas_L1 valve5(
    openingInputIsActive=true,
    useHomotopy=true,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible (Kvs_in=100, m_flow_nom=10))
                                                                                             annotation (Placement(transformation(extent={{0,14},{20,26}})));

  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T6(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT6(p_const=800000, xi_const={0,0,0.0,0,0.77,0.23,0,0,0})
                                                                  annotation (Placement(transformation(extent={{80,40},{60,60}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T7(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT7(p_const=800000, xi_const={0,0,0.0,0,0.77,0.23,0,0,0})
                                                                  annotation (Placement(transformation(extent={{80,10},{60,30}})));
  GenericValveGas_L1 valve6(
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_FlowFunction (m_flow_nom=400),
    useHomotopy=true) annotation (Placement(transformation(extent={{20,-16},{40,-4}})));

  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T8(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT8(p_const=800000, xi_const={0,0,0.0,0,0.77,0.23,0,0,0})
                                                                  annotation (Placement(transformation(extent={{80,-20},{60,0}})));
  ValveFuelFlueGas_L1 coalDustValve3(
    openingInputIsActive=true,
    checkValve=false,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=10,
        Delta_p_nom=2e5,
        rho_in_nom=1))
                     annotation (Placement(transformation(extent={{-40,-165},{-20,-153}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource3(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-150,-260},{-130,-240}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T9(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,-286},{-180,-266}})));
  Adapters.FuelFlueGas_join coalGas_join3 annotation (Placement(transformation(extent={{-110,-280},{-90,-260}})));
  Adapters.FuelFlueGas_split coalGas_split3 annotation (Placement(transformation(extent={{60,-280},{80,-260}})));
  BoundaryConditions.BoundaryFuel_pTxi coalSink3(p_const=800000) annotation (Placement(transformation(extent={{110,-260},{90,-240}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT9(p_const=800000) annotation (Placement(transformation(extent={{110,-290},{90,-270}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource4(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T10(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,-226},{-180,-206}})));
  Adapters.FuelFlueGas_join coalGas_join4 annotation (Placement(transformation(extent={{-110,-220},{-90,-200}})));
  Adapters.FuelFlueGas_split coalGas_split4 annotation (Placement(transformation(extent={{60,-220},{80,-200}})));
  BoundaryConditions.BoundaryFuel_pTxi coalSink4(p_const=800000) annotation (Placement(transformation(extent={{120,-210},{100,-190}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT10(p_const=800000) annotation (Placement(transformation(extent={{120,-240},{100,-220}})));
  ValveFuelFlueGas_L1 coalDustValve4(openingInputIsActive=true, redeclare model PressureLoss =
        Fundamentals.Quadratic_EN60534_compressible (
        paraOption=3,
        m_flow_nom=10,
        A_cross=0.2,
        zeta=0.5))                                                                                                                   annotation (Placement(transformation(extent={{-20,-215},{0,-203}})));
  ValveFuelFlueGas_L1 coalDustValve5(
    openingInputIsActive=true,
    useHomotopy=true,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible (Kvs_in=100, m_flow_nom=10))
                      annotation (Placement(transformation(extent={{0,-275},{20,-263}})));

  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource5(m_flow_const=5, T_const=293.15) annotation (Placement(transformation(extent={{-150,-310},{-130,-290}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T11(
    m_flow_const=10,
    T_const=293.15,
    xi_const={0,0,0.0,0,0.77,0.23,0,0,0},
    gas_a(p(start=1000000)))              annotation (Placement(transformation(extent={{-200,-336},{-180,-316}})));
  Adapters.FuelFlueGas_join coalGas_join5 annotation (Placement(transformation(extent={{-110,-330},{-90,-310}})));
  Adapters.FuelFlueGas_split coalGas_split5 annotation (Placement(transformation(extent={{60,-330},{80,-310}})));
  BoundaryConditions.BoundaryFuel_pTxi coalSink5(p_const=800000) annotation (Placement(transformation(extent={{110,-310},{90,-290}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT11(p_const=800000) annotation (Placement(transformation(extent={{110,-340},{90,-320}})));
  ValveFuelFlueGas_L1 coalDustValve6(
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_FlowFunction (m_flow_nom=400),
    useHomotopy=true) annotation (Placement(transformation(extent={{20,-325},{40,-313}})));

  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_1(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-168,120},{-148,140}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_2(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-168,90},{-148,110}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_3(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-168,66},{-148,86}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_4(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-168,40},{-148,60}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_5(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-168,10},{-148,30}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_6(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-168,-20},{-148,0}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_7(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-172,-76},{-152,-56}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_8(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-172,-126},{-152,-106}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_9(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-172,-176},{-152,-156}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_10(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-172,-226},{-152,-206}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_11(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-172,-286},{-152,-266}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 volumeGas_L2_12(T_start=293.15, p_start=10e5) annotation (Placement(transformation(extent={{-170,-336},{-150,-316}})));
equation
  connect(ramp.y, valve1.opening_in) annotation (Line(
      points={{-89,160},{-70,160},{-70,139}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, valve2.opening_in) annotation (Line(
      points={{-89,160},{-50,160},{-50,109}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource.fuel_a,coalGas_join.fuel_inlet)  annotation (Line(
      points={{-130,-150},{-120,-150},{-120,-154},{-110,-154}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split.fuel_outlet, coalSink.fuel_a) annotation (Line(
      points={{80,-154},{89,-154},{89,-150},{100,-150}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split.flueGas_outlet, gasSink_pT3.gas_a) annotation (Line(
      points={{80,-166},{89,-166},{89,-170},{100,-170}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalFlowSource1.fuel_a,coalGas_join1.fuel_inlet)  annotation (Line(
      points={{-130,-100},{-120,-100},{-120,-104},{-110,-104}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split1.fuel_outlet, coalSink1.fuel_a) annotation (Line(
      points={{80,-104},{90,-104},{90,-100},{100,-100}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split1.flueGas_outlet, gasSink_pT4.gas_a) annotation (Line(
      points={{80,-116},{90,-116},{90,-120},{100,-120}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve2.opening_in)
                                            annotation (Line(
      points={{-89,160},{-50,160},{-50,-101}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource2.fuel_a,coalGas_join2.fuel_inlet)  annotation (Line(
      points={{-130,-50},{-120,-50},{-120,-54},{-110,-54}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split2.fuel_outlet, coalSink2.fuel_a) annotation (Line(
      points={{80,-54},{89,-54},{89,-50},{100,-50}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split2.flueGas_outlet, gasSink_pT5.gas_a) annotation (Line(
      points={{80,-66},{89,-66},{89,-70},{100,-70}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve1.opening_in) annotation (Line(
      points={{-89,160},{-70,160},{-70,-51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve3.outlet, gasSink_pT2.gas_a) annotation (Line(
      points={{-20,76},{60,76}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve4.outlet, gasSink_pT6.gas_a) annotation (Line(
      points={{0,50},{60,50}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve1.outlet, gasSink_pT.gas_a) annotation (Line(
      points={{-60,130},{60,130}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasSink_pT1.gas_a, valve2.outlet) annotation (Line(
      points={{60,100},{-40,100}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, valve3.opening_in) annotation (Line(
      points={{-89,160},{-30,160},{-30,85}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, valve4.opening_in) annotation (Line(
      points={{-89,160},{-10,160},{-10,59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, valve5.opening_in) annotation (Line(
      points={{-89,160},{10,160},{10,29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve5.outlet, gasSink_pT7.gas_a) annotation (Line(
      points={{20,20},{60,20}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve6.outlet, gasSink_pT8.gas_a) annotation (Line(
      points={{40,-10},{60,-10}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, valve6.opening_in) annotation (Line(
      points={{-89,160},{30,160},{30,-1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalGas_join.fuelFlueGas_outlet, coalDustValve3.inlet) annotation (Line(
      points={{-90,-160},{-40,-160}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve3.outlet, coalGas_split.fuelFlueGas_inlet) annotation (Line(
      points={{-20,-160},{60,-160}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join2.fuelFlueGas_outlet, coalDustValve1.inlet) annotation (Line(
      points={{-90,-60},{-80,-60}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve1.outlet, coalGas_split2.fuelFlueGas_inlet) annotation (Line(
      points={{-60,-60},{60,-60}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_split1.fuelFlueGas_inlet, coalDustValve2.outlet) annotation (Line(
      points={{60,-110},{-40,-110}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve2.inlet, coalGas_join1.fuelFlueGas_outlet) annotation (Line(
      points={{-60,-110},{-90,-110}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve3.opening_in) annotation (Line(
      points={{-89,160},{-30,160},{-30,-151}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource3.fuel_a,coalGas_join3.fuel_inlet)
                                                          annotation (Line(
      points={{-130,-250},{-120,-250},{-120,-264},{-110,-264}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split3.fuel_outlet, coalSink3.fuel_a) annotation (Line(
      points={{80,-264},{89,-264},{89,-250},{90,-250}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split3.flueGas_outlet, gasSink_pT9.gas_a) annotation (Line(
      points={{80,-276},{89,-276},{89,-280},{90,-280}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalFlowSource4.fuel_a,coalGas_join4.fuel_inlet)  annotation (Line(
      points={{-130,-200},{-120,-200},{-120,-204},{-110,-204}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split4.fuel_outlet, coalSink4.fuel_a) annotation (Line(
      points={{80,-204},{90,-204},{90,-200},{100,-200}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split4.flueGas_outlet, gasSink_pT10.gas_a) annotation (Line(
      points={{80,-216},{90,-216},{90,-230},{100,-230}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve4.opening_in)
                                            annotation (Line(
      points={{-89,160},{-10,160},{-10,-201}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalGas_join3.fuelFlueGas_outlet, coalDustValve5.inlet) annotation (Line(
      points={{-90,-270},{0,-270}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve5.outlet, coalGas_split3.fuelFlueGas_inlet) annotation (Line(
      points={{20,-270},{60,-270}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_split4.fuelFlueGas_inlet, coalDustValve4.outlet) annotation (Line(
      points={{60,-210},{0,-210}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve4.inlet, coalGas_join4.fuelFlueGas_outlet) annotation (Line(
      points={{-20,-210},{-90,-210}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve5.opening_in) annotation (Line(
      points={{-89,160},{10,160},{10,-261}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource5.fuel_a,coalGas_join5.fuel_inlet)
                                                          annotation (Line(
      points={{-130,-300},{-120,-300},{-120,-314},{-110,-314}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split5.fuel_outlet, coalSink5.fuel_a) annotation (Line(
      points={{80,-314},{89,-314},{89,-300},{90,-300}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(coalGas_split5.flueGas_outlet, gasSink_pT11.gas_a) annotation (Line(
      points={{80,-326},{89,-326},{89,-330},{90,-330}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_join5.fuelFlueGas_outlet, coalDustValve6.inlet) annotation (Line(
      points={{-90,-320},{20,-320}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalDustValve6.outlet, coalGas_split5.fuelFlueGas_inlet) annotation (Line(
      points={{40,-320},{60,-320}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, coalDustValve6.opening_in) annotation (Line(
      points={{-89,160},{30,160},{30,-311}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasFlowSource_T.gas_a, volumeGas_L2_1.inlet) annotation (Line(
      points={{-180,130},{-168,130}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_1.outlet, valve1.inlet) annotation (Line(
      points={{-148,130},{-80,130}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T1.gas_a, volumeGas_L2_2.inlet) annotation (Line(
      points={{-180,100},{-168,100}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_2.outlet, valve2.inlet) annotation (Line(
      points={{-148,100},{-60,100}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T2.gas_a, volumeGas_L2_3.inlet) annotation (Line(
      points={{-180,76},{-168,76}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_3.outlet, valve3.inlet) annotation (Line(
      points={{-148,76},{-40,76}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T6.gas_a, volumeGas_L2_4.inlet) annotation (Line(
      points={{-180,50},{-168,50}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_4.outlet, valve4.inlet) annotation (Line(
      points={{-148,50},{-20,50}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T7.gas_a, volumeGas_L2_5.inlet) annotation (Line(
      points={{-180,20},{-168,20}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_5.outlet, valve5.inlet) annotation (Line(
      points={{-148,20},{0,20}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T8.gas_a, volumeGas_L2_6.inlet) annotation (Line(
      points={{-180,-10},{-168,-10}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_6.outlet, valve6.inlet) annotation (Line(
      points={{-148,-10},{20,-10}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T5.gas_a, volumeGas_L2_7.inlet) annotation (Line(
      points={{-180,-66},{-172,-66}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T4.gas_a, volumeGas_L2_8.inlet) annotation (Line(
      points={{-180,-116},{-172,-116}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T3.gas_a, volumeGas_L2_9.inlet) annotation (Line(
      points={{-180,-166},{-172,-166}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T10.gas_a, volumeGas_L2_10.inlet) annotation (Line(
      points={{-180,-216},{-172,-216}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T9.gas_a, volumeGas_L2_11.inlet) annotation (Line(
      points={{-180,-276},{-172,-276}},
      color={118,106,98},
      thickness=0.5));
  connect(gasFlowSource_T11.gas_a, volumeGas_L2_12.inlet) annotation (Line(
      points={{-180,-326},{-170,-326}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_12.outlet, coalGas_join5.flueGas_inlet) annotation (Line(
      points={{-150,-326},{-110,-326}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_11.outlet, coalGas_join3.flueGas_inlet) annotation (Line(
      points={{-152,-276},{-110,-276}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_9.outlet, coalGas_join.flueGas_inlet) annotation (Line(
      points={{-152,-166},{-110,-166}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_10.outlet, coalGas_join4.flueGas_inlet) annotation (Line(
      points={{-152,-216},{-110,-216}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_8.outlet, coalGas_join1.flueGas_inlet) annotation (Line(
      points={{-152,-116},{-110,-116}},
      color={118,106,98},
      thickness=0.5));
  connect(volumeGas_L2_7.outlet, coalGas_join2.flueGas_inlet) annotation (Line(
      points={{-152,-66},{-110,-66}},
      color={118,106,98},
      thickness=0.5));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-420},{200,260}}),
                        graphics={Text(
          extent={{-206,214},{-54,190}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="_______________________________________
PURPOSE:
>> Tester for gas valves
_______________________________________
"),     Rectangle(
          extent={{-220,260},{200,-420}},
          lineColor={115,150,0},
          lineThickness=0.5)}),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)),
    experiment(StopTime=10));
end Test_GasValves;
