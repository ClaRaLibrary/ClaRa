within ClaRa.Components.Mills.HardCoalMills.Check;
model ValidateRollerBowlMill_3 "A test scenario derived from the paper Niemczyk: 'Derivation and validation of a coal mill model for control'"
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
//   parameter Real K_10 = 1459.98;//1507.9;
//   parameter Real K_11 = 1.75388e7;//8.4736e6;
//   parameter Real K_2 = 0.127694;//0.1283;
//   parameter Real K_3 = 0.0153057;//0.0149602;
  Real Omega;
  Real Dev1;
  Real Dev2;

  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 Mill2(
    millKoeff=Fundamentals.STV4(),
    initOption=801,
    mass_rct_start=3000,
    mass_pct_start=100,
    T_out_start=96.15 + 273.15) annotation (Placement(transformation(extent={{-8,-62},{12,-42}})));
  inner SimCenter simCenter(T_amb=283.15, redeclare Basics.Media.FuelTypes.Fuel_refvalues_v2 fuelModel1(C_cp={1400,1000,4190}))
                                                                                                 annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.CombiTimeTable W_c(
    tableOnFile=true,
    tableName="W_c",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/W_c.mat"))
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable
                               T_air(
    tableOnFile=true,
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/T_air.mat"),
    tableName="T_air")
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable
                               omega(
    tableOnFile=true,
    tableName="omega",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/omega.mat"))
    annotation (Placement(transformation(extent={{-100,-8},{-80,12}})));
  Modelica.Blocks.Sources.CombiTimeTable
                               W_air(
    tableOnFile=true,
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/W_air.mat"),
    tableName="W_air")
    annotation (Placement(transformation(extent={{-100,-72},{-80,-52}})));
  Modelica.Blocks.Sources.CombiTimeTable DeltaP_pa(
    tableOnFile=true,
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/DeltaP_pa.mat"),
    tableName="DeltaP_pa")
    annotation (Placement(transformation(extent={{80,52},{100,72}})));
  Modelica.Blocks.Sources.CombiTimeTable DeltaP_mill_meas(
    tableOnFile=true,
    tableName="DeltaP_mill_meas",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/DeltaP_mill_meas.mat"))
    annotation (Placement(transformation(extent={{80,-52},{100,-32}})));
  Modelica.Blocks.Sources.CombiTimeTable
                               E_meas(
    tableOnFile=true,
    tableName="E_meas",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/E_meas.mat"))
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Modelica.Blocks.Sources.CombiTimeTable T_out_meas(
    tableOnFile=true,
    tableName="T_out_meas",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/T_out_meas.mat"),
    offset={-273.15})
    annotation (Placement(transformation(extent={{80,-84},{100,-64}})));
  Modelica.Blocks.Sources.CombiTimeTable
                               E_model(
    tableOnFile=true,
    tableName="E_model",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/E_model.mat"))
    annotation (Placement(transformation(extent={{52,-20},{72,0}})));
  Modelica.Blocks.Sources.CombiTimeTable DeltaP_mill_model(
    tableOnFile=true,
    tableName="DeltaP_mill_model",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/DeltaP_mill_model.mat"))
    annotation (Placement(transformation(extent={{52,-52},{72,-32}})));
  Modelica.Blocks.Sources.CombiTimeTable T_out_model(
    tableOnFile=true,
    offset={-273.15},
    tableName="T_out_model",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/T_out_model.mat"))
    annotation (Placement(transformation(extent={{52,-84},{72,-64}})));
  Modelica.Blocks.Sources.CombiTimeTable W_pf_meas(
    tableOnFile=true,
    tableName="W_pf_meas",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/W_pf_meas.mat"))
    annotation (Placement(transformation(extent={{80,18},{100,38}})));
  Modelica.Blocks.Sources.CombiTimeTable W_pf_model(
    tableOnFile=true,
    tableName="W_pf_model",
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/W_pf_model.mat"))
    annotation (Placement(transformation(extent={{52,18},{72,38}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_XRG1(m_flow_const=10, variable_m_flow=true) annotation (Placement(transformation(extent={{-66,-48},{-46,-28}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-24,-50})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_burner1(
    m_flow_const=11,
    variable_m_flow=true,
    variable_T=true,
    xi_const={0,0,0,0,0.79,0.21,0,0,0})
                                      annotation (Placement(transformation(extent={{-64,-82},{-44,-62}})));
  BoundaryConditions.BoundaryFuel_pTxi coaSink_XRG1 annotation (Placement(transformation(
        extent={{9.5,-9.5},{-9.5,9.5}},
        rotation=270,
        origin={-10.5,-90.5})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi idealGasPressureSink_XRG1(p_const=100000) annotation (Placement(transformation(
        extent={{9.5,-9.5},{-9.5,9.5}},
        rotation=270,
        origin={26.5,-91.5})));

  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-70})));
equation
  der(Dev1)=(Mill2.summary.T_out-(T_out_meas.y[1]+273.15))^2;
  der(Dev2)=((Mill2.summary.P_grind - E_meas.y[1])^2)*1e4;
  Omega=Dev1+Dev2;

  connect(omega.y[1], Mill2.classifierSpeed) annotation (Line(
      points={{-79,2},{2,2},{2,-41.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource_XRG1.fuel_a,coalGas_join_burner1.fuel_inlet)
    annotation (Line(
      points={{-46,-38},{-40,-38},{-40,-44},{-34,-44}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(fluelGasFlowSource_burner1.gas_a,coalGas_join_burner1. flueGas_inlet)
    annotation (Line(
      points={{-44,-72},{-40,-72},{-40,-56},{-34,-56}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalGas_join_burner1.fuelFlueGas_outlet, Mill2.inlet) annotation (Line(
      points={{-14,-50},{-12,-50},{-12,-52},{-8,-52}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(fluelGasFlowSource_burner1.m_flow, W_air.y[1]) annotation (Line(
      points={{-64,-66},{-72,-66},{-72,-62},{-79,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fluelGasFlowSource_burner1.T, T_air.y[1]) annotation (Line(
      points={{-64,-72},{-72,-72},{-72,-90},{-79,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource_XRG1.m_flow, W_c.y[1]) annotation (Line(
      points={{-66,-32},{-72,-32},{-72,-30},{-79,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGasPressureSink_XRG1.gas_a,coalGas_join_burner2. flueGas_inlet)
    annotation (Line(
      points={{26.5,-82},{28,-82},{28,-80},{26,-80}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coaSink_XRG1.fuel_a,coalGas_join_burner2.fuel_inlet)  annotation (
      Line(
      points={{-10.5,-81},{14,-81},{14,-80}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(coalGas_join_burner2.fuelFlueGas_outlet, Mill2.outlet) annotation (Line(
      points={{20,-60},{20,-52},{12,-52}},
      color={175,175,175},
      smooth=Smooth.None));
  annotation (Diagram(graphics={Text(
          extent={{-96,80},{76,72}},
          lineColor={0,0,255},
          textString=
              "Note, that the Niemczyk model description does not handle coal drying while the model does!"), Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={115,150,0},
          lineThickness=0.5)}),
    experiment(StopTime=5960),
    __Dymola_experimentSetupOutput);
end ValidateRollerBowlMill_3;
