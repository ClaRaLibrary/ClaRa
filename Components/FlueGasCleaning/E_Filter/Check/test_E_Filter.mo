within ClaRa.Components.FlueGasCleaning.E_Filter.Check;
model test_E_Filter
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  inner SimCenter simCenter(redeclare TILMedia.GasTypes.FlueGasTILMedia flueGasModel) annotation (Placement(transformation(extent={{80,40},{100,60}})));
  BoundaryConditions.BoundaryGas_Txim_flow                  idealGasFlowSource_XRG(
    m_flow_const=10,
    variable_m_flow=true,
    variable_T=true,
    xi_const={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0}) annotation (Placement(transformation(extent={{-40,-28},{-20,-8}})));
  BoundaryConditions.BoundaryGas_pTxi                  idealGasPressureSink(p_const=100000, xi_const={0.0,0,0.73,0,0.065,0.036,0,0.13,0.0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-18})));
  Modelica.Blocks.Sources.Ramp massFlowRate(
    startTime=5,
    height=-2,
    offset=1,
    duration=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,2})));
  Modelica.Blocks.Sources.Ramp Temperature(
    duration=1,
    startTime=1,
    height=50,
    offset=273.15 + 150)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-30})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop1(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,30})));
  BoundaryConditions.BoundaryGas_Txim_flow                  idealGasFlowSource_XRG1(
    m_flow_const=10,
    variable_m_flow=true,
    variable_T=true,
    xi_const={1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9})
                                                 annotation (Placement(transformation(extent={{-40,-126},{-20,-106}})));
  BoundaryConditions.BoundaryGas_pTxi                  idealGasPressureSink1(                                            p_const=100000, xi_const={1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9})
                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-116})));
  Modelica.Blocks.Sources.Ramp massFlowRate1(
    offset=1,
    startTime=5,
    duration=10,
    height=-2)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-96})));
  Modelica.Blocks.Sources.Ramp Temperature1(
    duration=1,
    startTime=1,
    height=50,
    offset=273.15 + 150)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-128})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop2(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-68})));
  BoundaryConditions.BoundaryGas_Txim_flow                  idealGasFlowSource_XRG2(
    variable_m_flow=false,
    m_flow_const=1,
    variable_T=false,
    T_const=473.15,
    xi_const={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0})
                    annotation (Placement(transformation(extent={{-78,-238},{-58,-218}})));
  BoundaryConditions.BoundaryGas_pTxi                  idealGasPressureSink2(                                            p_const=100000, xi_const={0.01,0,0.73,0,0.065,0.036,0,0.13,0.0})
                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={32,-228})));
  Modelica.Blocks.Sources.Ramp U_applied(
    duration=10,
    height=20e3,
    startTime=10,
    offset=1000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,-198})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop3(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-68,-166})));
  E_Filter_L2 e_Filter_L2_detailed(redeclare model SeparationModel =
        Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_Filter_L2_Detailed,                                                              redeclare model HeatTransfer =
        Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2)                                                                                                                                                                        annotation (Placement(transformation(extent={{-32,-238},{-12,-218}})));
  E_Filter_L2 e_Filter_L2_empirical(redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model SeparationModel =
        Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_Filter_L2_Empirical)                                                                                                                                                                      annotation (Placement(transformation(extent={{6,-126},{26,-106}})));
  E_Filter_L2 e_Filter_L2_simple(redeclare model HeatTransfer = Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2, redeclare model SeparationModel =
        Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_Filter_L2_Simple)                                                                                                                                                                   annotation (Placement(transformation(extent={{6,-28},{26,-8}})));
equation

  connect(massFlowRate.y,idealGasFlowSource_XRG. m_flow) annotation (Line(
      points={{-59,2},{-50,2},{-50,-12},{-40,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature.y,idealGasFlowSource_XRG. T)
                                             annotation (Line(
      points={{-59,-30},{-50,-30},{-50,-18},{-40,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowRate1.y, idealGasFlowSource_XRG1.m_flow) annotation (Line(
      points={{-59,-96},{-50,-96},{-50,-110},{-40,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature1.y, idealGasFlowSource_XRG1.T) annotation (Line(
      points={{-59,-128},{-50,-128},{-50,-116},{-40,-116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGasFlowSource_XRG2.gas_a, e_Filter_L2_detailed.inlet) annotation (Line(
      points={{-58,-228},{-45,-228},{-32,-228}},
      color={118,106,98},
      thickness=0.5));
  connect(e_Filter_L2_detailed.outlet, idealGasPressureSink2.gas_a) annotation (Line(
      points={{-12,-228},{22,-228},{22,-228}},
      color={118,106,98},
      thickness=0.5));
  connect(e_Filter_L2_detailed.heat, fixedTemperatureTop3.port) annotation (Line(
      points={{-22,-218},{-22,-218},{-22,-172},{-22,-166},{-58,-166}},
      color={167,25,48},
      thickness=0.5));
  connect(idealGasFlowSource_XRG1.gas_a, e_Filter_L2_empirical.inlet) annotation (Line(
      points={{-20,-116},{-6,-116},{6,-116}},
      color={118,106,98},
      thickness=0.5));
  connect(e_Filter_L2_empirical.outlet, idealGasPressureSink1.gas_a) annotation (Line(
      points={{26,-116},{60,-116}},
      color={118,106,98},
      thickness=0.5));
  connect(idealGasFlowSource_XRG.gas_a, e_Filter_L2_simple.inlet) annotation (Line(
      points={{-20,-18},{-14,-18},{6,-18}},
      color={118,106,98},
      thickness=0.5));
  connect(e_Filter_L2_simple.outlet, idealGasPressureSink.gas_a) annotation (Line(
      points={{26,-18},{26,-18},{60,-18}},
      color={118,106,98},
      thickness=0.5));
  connect(e_Filter_L2_simple.heat, fixedTemperatureTop1.port) annotation (Line(
      points={{16,-8},{16,-8},{16,16},{16,30},{-60,30}},
      color={167,25,48},
      thickness=0.5));
  connect(e_Filter_L2_empirical.heat, fixedTemperatureTop2.port) annotation (Line(
      points={{16,-106},{16,-68},{-60,-68}},
      color={167,25,48},
      thickness=0.5));
  connect(e_Filter_L2_detailed.U_input, U_applied.y) annotation (Line(points={{-29.4,-216.8},{-29.4,-198},{-57,-198}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-260},{120,60}}),
                      graphics={Text(
          extent={{-98,54},{-24,44}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>>Tester for the E_Filter_ideal component")}),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}})));
end test_E_Filter;
