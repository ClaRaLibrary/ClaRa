within ClaRa.Components.HeatExchangers.Check;
model Test_HEXvle2gas_L3_1ph_BU "Example 1 at page Ca 15 in VDI Waermeatlas, 9th edition "
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
  BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource_T(
    m_flow_const=1,
    variable_m_flow=false,
    T_const=120 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-14})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT(T_const=303.15, p_const=11e5) annotation (Placement(transformation(extent={{100,0},{80,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink(                                                         p_const=1e5)
                                                                                            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-30})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource(
    variable_m_flow=false,
    variable_T=false,
    T_const(displayUnit="degC") = 293.15,
    m_flow_const=2*TILMedia.Gas.Functions.density_pTxi(
        flueGasFlowSource.medium,
        1e5,
        273.15 + 20,
        {0,0,0,0,0.76,0.24,0,0,0}),
    variable_xi=true) annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  inner SimCenter simCenter(
    useHomotopy=false,
    redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    showExpertSummary=true) annotation (Placement(transformation(extent={{-100,-180},{-60,-160}})));
  HEXvle2gas_L3_1ph_BU_ntu hex_ntu(
    length=1,
    height=1,
    width=1,
    flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    tubeOrientation=1,
    m_nom1=2,
    h_nom1=24000,
    diameter_i=12e-3,
    diameter_o=16e-3,
    Delta_z_par=0.045,
    Delta_z_ort=0.045,
    N_rows=6,
    m_nom2=1,
    N_passes=6,
    showExpertSummary=true,
    mass_struc=100,
    N_tubes=20,
    p_nom1=100000,
    p_start_shell=1000000,
    p_nom2=1000000,
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    redeclare model HeatTransfer_Shell =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_finnedTubes_L2 (
        CF_fouling=1,
        h_f=0.013,
        s_f=0.0004,
        t_f=1/400,
        redeclare model solidType = TILMedia.Solid.Types.TILMedia_Aluminum),
    redeclare model HeatExchangerType =
        Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossCounterFlow (N_rp=6),
    h_nom2=500e3,
    T_start_shell=20 + 273.15,
    h_start_tubes=375e3,
    p_start_tubes=10e5,
    T_w_i_start=343,
    T_w_a_start=343,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2,
    initOptionTubes=0,
    initOptionShell=0,
    initOptionWall=0)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={8,-8})));

  BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource_T1(
    m_flow_const=1,
    variable_m_flow=false,
    T_const=120 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,-74})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT1(
                                                      T_const=303.15, p_const=10e5) annotation (Placement(transformation(extent={{78,-60},{58,-40}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink1(                                                        p_const=1e5)
                                                                                            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-90})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource1(
    variable_m_flow=false,
    variable_T=false,
    T_const(displayUnit="degC") = 293.15,
    m_flow_const=2*TILMedia.Gas.Functions.density_pTxi(
        flueGasFlowSource1.medium,
        1e5,
        273.15 + 20,
        {0,0,0,0,0.76,0.24,0,0,0}),
    variable_xi=true) annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  HEXvle2gas_L3_1ph_BU_simple hex_simple(
    length=1,
    height=1,
    width=1,
    flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    tubeOrientation=1,
    m_nom1=2,
    h_nom1=24000,
    diameter_i=12e-3,
    diameter_o=16e-3,
    mass_struc=100,
    Delta_z_par=0.045,
    Delta_z_ort=0.045,
    N_rows=6,
    m_nom2=1,
    h_nom2=1200e3,
    N_passes=6,
    T_w_i_start=353,
    T_w_a_start=333,
    showExpertSummary=true,
    N_tubes=20,
    p_nom1=100000,
    p_start_shell=1000000,
    p_nom2=1000000,
    redeclare model HeatTransfer_Shell =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_finnedTubes_L2 (
        CF_fouling=1,
        h_f=0.013,
        s_f=0.0004,
        t_f=1/400,
        redeclare model solidType = TILMedia.Solid.Types.TILMedia_Aluminum),
    p_start_tubes=10e5,
    redeclare model PressureLossShell =
        Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    T_start_shell=273.15 + 20,
    h_start_tubes=400e3,
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.NusseltPipe1ph_L2,
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    initOptionTubes=1,
    initOptionShell=0,
    initOptionWall=213)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={8,-68})));

  Visualisation.Quadruple quadruple1(largeFonts=false) annotation (Placement(transformation(extent={{22,0},{44,12}})));
  Visualisation.Quadruple quadruple2(largeFonts=false) annotation (Placement(transformation(extent={{20,-60},{44,-48}})));
  HEXvle2gas_L3_2ph_BU_simple hex_2ph(
    mass_struc=100,
    parallelTubes=false,
    Delta_z_par=0.045,
    Delta_z_ort=0.045,
    N_rows=6,
    p_start_tubes=11e5,
    flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    T_start_shell=273.15 + 20,
    h_liq_start=400e3,
    h_vap_start=400e3,
    m_nom2=1,
    length=1,
    height=1,
    width=1,
    diameter_i=12e-3,
    diameter_o=16e-3,
    N_tubes=20,
    N_passes=6,
    CF_geo=1,
    redeclare model PressureLossTubes = Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L3,
    redeclare model HeatTransfer_Shell =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_finnedTubes_L2 (
        CF_fouling=1,
        h_f=0.013,
        s_f=0.0004,
        t_f=1/400,
        redeclare model solidType = TILMedia.Solid.Types.TILMedia_Aluminum),
    redeclare model PressureLossShell =
        Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    m_nom1=2,
    p_nom1=1e5,
    h_nom1=24e3,
    redeclare model WallMaterial = TILMedia.Solid.Types.TILMedia_Steel,
    T_w_i_start=273.15 + 50,
    T_w_a_start=273.15 + 50,
    tubes(Tau_cond=0.3, Tau_evap=0.03),
    redeclare model HeatTransferTubes = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (
          alpha_nom={4000,4000}),
    z_out_tubes=0,
    level_rel_start=0.95,
    initOptionTubes=204,
    initOptionShell=0,
    initOptionWall=213) annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink2(                                                        p_const=1e5)
                                                                                            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-150})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource2(
    variable_m_flow=false,
    variable_T=false,
    T_const(displayUnit="degC") = 293.15,
    m_flow_const=2*TILMedia.Gas.Functions.density_pTxi(
        flueGasFlowSource1.medium,
        1e5,
        273.15 + 20,
        {0,0,0,0,0.76,0.24,0,0,0}),
    variable_xi=true) annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT2(
                                                      T_const=303.15, p_const=10e5) annotation (Placement(transformation(extent={{100,-120},{80,-100}})));
  BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource_T2(
    variable_m_flow=false,
    T_const=120 + 273.15,
    m_flow_const=1)       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-134})));
  Visualisation.Quadruple quadruple3(largeFonts=false) annotation (Placement(transformation(extent={{24,-122},{46,-110}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss =
        VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                       m_flow_nom=10, Delta_p_nom=100)) annotation (Placement(transformation(extent={{56,-116},{76,-104}})));
  Sensors.SensorGas_L1_T gasTemperatureSensor_hex_ntu annotation (Placement(transformation(extent={{-10,-30},{-30,-8}})));
  Sensors.SensorGas_L1_T gasTemperatureSensor_hex_2ph annotation (Placement(transformation(extent={{-10,-150},{-30,-128}})));
  Sensors.SensorGas_L1_T gasTemperatureSensor_hex_simple annotation (Placement(transformation(extent={{-10,-90},{-30,-68}})));
  VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_2(redeclare model PressureLoss =
        VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                       m_flow_nom=10)) annotation (Placement(transformation(extent={{56,4},{76,16}})));
  BoundaryConditions.GasCompositionByMassFractions
    gasCompositionByMassFractions(
    xi_ASH=0,
    xi_CO=0,
    xi_CO2=0,
    xi_SO2=0,
    xi_N2=0.76,
    xi_O2=0.24,
    xi_NO=0,
    xi_H2O=0,
    xi_NH3=0) annotation (Placement(transformation(extent={{-96,-6},{-76,14}})));
equation

  connect(hex_ntu.In2, massFlowSource_T.steam_a) annotation (Line(
      points={{18,-14},{58,-14}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource.gas_a, hex_ntu.In1) annotation (Line(
      points={{-40,10},{8,10},{8,1.8}},
      color={118,106,98},
      thickness=0.5));
  connect(hex_simple.In2, massFlowSource_T1.steam_a) annotation (Line(
      points={{18,-74},{58,-74}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_pT1.steam_a, hex_simple.Out2) annotation (Line(
      points={{58,-50},{46,-50},{46,-62},{18,-62}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource1.gas_a, hex_simple.In1) annotation (Line(
      points={{-40,-50},{8,-50},{8,-58.2}},
      color={118,106,98},
      thickness=0.5));
  connect(hex_ntu.eye, quadruple1.eye) annotation (Line(points={{19,-1.77636e-015},{20,-1.77636e-015},{20,6},{22,6}}, color={190,190,190}));
  connect(hex_simple.eye, quadruple2.eye) annotation (Line(points={{18,-60},{18,-60},{20,-60},{20,-56},{20,-54}},          color={190,190,190}));
  connect(flueGasFlowSource2.gas_a, hex_2ph.In1) annotation (Line(
      points={{-40,-110},{-40,-110},{10,-110},{10,-120.2}},
      color={118,106,98},
      thickness=0.5));
  connect(massFlowSource_T2.steam_a, hex_2ph.In2) annotation (Line(
      points={{60,-134},{20,-134}},
      color={0,131,169},
      thickness=0.5));
  connect(hex_2ph.eye, quadruple3.eye) annotation (Line(points={{20,-122},{22,-122},{22,-116},{24,-116}}, color={190,190,190}));
  connect(hex_2ph.Out2, valveVLE_L1_1.inlet) annotation (Line(
      points={{19.8,-124},{32,-124},{52,-124},{52,-110},{56,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveVLE_L1_1.outlet, pressureSink_pT2.steam_a) annotation (Line(
      points={{76,-110},{80,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hex_2ph.Out1, gasTemperatureSensor_hex_2ph.inlet) annotation (Line(
      points={{10,-140},{10,-140},{10,-150},{-10,-150}},
      color={118,106,98},
      thickness=0.5));
  connect(gasTemperatureSensor_hex_2ph.outlet, flueGasPressureSink2.gas_a) annotation (Line(
      points={{-30,-150},{-40,-150}},
      color={118,106,98},
      thickness=0.5));
  connect(hex_simple.Out1, gasTemperatureSensor_hex_simple.inlet) annotation (Line(
      points={{8,-78},{8,-90},{-10,-90}},
      color={118,106,98},
      thickness=0.5));
  connect(gasTemperatureSensor_hex_simple.outlet, flueGasPressureSink1.gas_a) annotation (Line(
      points={{-30,-90},{-35,-90},{-40,-90}},
      color={118,106,98},
      thickness=0.5));
  connect(hex_ntu.Out1, gasTemperatureSensor_hex_ntu.inlet) annotation (Line(
      points={{8,-18},{8,-18},{8,-30},{-10,-30}},
      color={118,106,98},
      thickness=0.5));
  connect(gasTemperatureSensor_hex_ntu.outlet, flueGasPressureSink.gas_a) annotation (Line(
      points={{-30,-30},{-30,-30},{-40,-30}},
      color={118,106,98},
      thickness=0.5));
  connect(valveVLE_L1_2.outlet, pressureSink_pT.steam_a) annotation (Line(
      points={{76,10},{78,10},{80,10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hex_ntu.Out2, valveVLE_L1_2.inlet) annotation (Line(
      points={{18,-2},{30,-2},{52,-2},{52,10},{56,10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(gasCompositionByMassFractions.X, flueGasFlowSource.xi) annotation (Line(points={{-74,4},{-60,4}},         color={0,0,127}));
  connect(gasCompositionByMassFractions.X, flueGasFlowSource1.xi) annotation (Line(points={{-74,4},{-70,4},{-70,2},{-68,2},{-68,-56},{-60,-56}}, color={0,0,127}));
  connect(gasCompositionByMassFractions.X, flueGasFlowSource2.xi) annotation (Line(points={{-74,4},{-68,4},{-68,-116},{-60,-116}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,100}}),
            graphics={                               Text(
          extent={{-100,94},{90,34}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="
_________________________________________________________________________________
PURPOSE:
Compare model with VDI Waermeatlas, Ca15 Example 1 
_________________________________________________________________________________
NOTE: 
> The results of the NTU HEX and the results from VDI WA differ slightly. The VDI WA takes estimated
 values for temperature at which fluid properties are evaluated. ClaRa model takes real temperatures 
for fluid property evaluation.
_________________________________________________________________________________
LOOK AT:
> The outlet temperatures of gas and water flow.
> Outlet temperature of water according to literature: T_h2o_out = 78 C
> Outlet temperature of air according to literature: T_air_out =94 C.
> The differences between NTU and simple HEX.
_________________________________________________________________________________
"),     Rectangle(
          extent={{-100,100},{100,-180}},
          lineColor={115,150,0},
          lineThickness=0.5)}),
    Icon(coordinateSystem(initialScale=0.1),
         graphics),
    experiment(
      StopTime=5000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end Test_HEXvle2gas_L3_1ph_BU;
