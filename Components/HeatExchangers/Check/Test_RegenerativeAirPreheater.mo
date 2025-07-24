within ClaRa.Components.HeatExchangers.Check;
model Test_RegenerativeAirPreheater
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  import ClaRa;
  inner ClaRa.SimCenter simCenter(redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel)
    annotation (Placement(transformation(extent={{78,22},{98,42}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource1(
    variable_T=true,
    m_flow_const=540,
    T_const=623.15,
    variable_xi=false,
    xi_const={0.01,0.0,0.22,0.0,0.7,0.03,0,0,0})
                    annotation (Placement(transformation(extent={{62,-30},{42,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink1(p_const=100000) annotation (Placement(transformation(extent={{62,-2},{42,18}})));
  Modelica.Blocks.Sources.Step step(
    height=-50,
    startTime=500,
    offset=380 + 273.15)
    annotation (Placement(transformation(extent={{100,-30},{80,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource2(
    variable_m_flow=false,
    variable_T=true,
    m_flow_const=500,
    T_const=313.15,
    variable_xi=false,
    xi_const={0,0,0,0,0.79,0.21,0,0,0})
                    annotation (Placement(transformation(extent={{-42,-2},{-22,18}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink2(p_const=100000) annotation (Placement(transformation(extent={{-42,-30},{-22,-10}})));
  ClaRa.Components.HeatExchangers.RegenerativeAirPreheater_L4 regenerativeAirPreheater(
    s_sp=0.6e-3,
    redeclare model Material = TILMedia.Solid.Types.TILMedia_St35_8,
    A_flueGas=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    A_air=0.45*(regenerativeAirPreheater.A_cross - regenerativeAirPreheater.A_hub),
    diameter_reg=10,
    height_reg=3,
    N_sp=1000,
    T_start_freshAir=linspace(
        340,
        340,
        regenerativeAirPreheater.N_cv),
    T_start_flueGas=linspace(
        450,
        340,
        regenerativeAirPreheater.N_cv),
    m_flow_flueGas_nom=565,
    p_start_flueGas=linspace(
        108600,
        100900,
        regenerativeAirPreheater.N_cv),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    N_cv=10,
    redeclare model HeatTransferFlueGas =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_regenerativeAirPreheater_L4,
    frictionAtFlueGasInlet=false,
    frictionAtFlueGasOutlet=true,
    frictionAtFreshAirInlet=false,
    frictionAtFreshAirOutlet=true,
    p_start_freshAir=linspace(
        110000,
        104700,
        regenerativeAirPreheater.N_cv)) annotation (Placement(transformation(extent={{8,-16},{28,4}})));

  Modelica.Blocks.Sources.Step step1(
    offset=40 + 273.15,
    startTime=800,
    height=20)
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  ClaRa.Components.HeatExchangers.RegenerativeAirPreheaterPrimaryAndSecondaryAir_L4 airPreheater(
    T_start_primaryAir=linspace(
        400,
        400,
        airPreheater.N_cv),
    T_start_secondaryAir=linspace(
        400,
        400,
        airPreheater.N_cv),
    T_start_flueGas=linspace(
        400,
        400,
        airPreheater.N_cv),
    T_start_primary_wall=linspace(
        400,
        400,
        airPreheater.N_cv),
    T_start_secondary_wall=linspace(
        400,
        400,
        airPreheater.N_cv),
    N_cv=10,
    xi_start_primaryAir={0,0,0,0,0.79,0.21,0,0,0},
    xi_start_secondaryAir={0,0,0,0,0.79,0.21,0,0,0},
    xi_start_flueGas={0,0,0.219,0,0.689,0,0.029,0,0}) annotation (Placement(transformation(extent={{6,-100},{26,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource(
    m_flow_const=400,
    variable_m_flow=true,
    T_const=313.15,
    variable_xi=false,
    xi_const={0,0,0,0,0.79,0.21,0,0,0}) annotation (Placement(transformation(extent={{-42,-116},{-22,-96}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource3(
    m_flow_const=400,
    variable_T=true,
    T_const=623.15,
    variable_xi=false,
    xi_const={0.01,0.0,0.22,0.0,0.7,0.03,0,0,0})
                                           annotation (Placement(transformation(extent={{62,-114},{42,-94}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink(p_const=100000) annotation (Placement(transformation(extent={{-42,-138},{-22,-118}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink3(p_const=100000) annotation (Placement(transformation(extent={{62,-86},{42,-66}})));
  Modelica.Blocks.Sources.Step step2(
    offset=350 + 273.15,
    height=-50,
    startTime=500)
    annotation (Placement(transformation(extent={{100,-114},{80,-94}})));
  Modelica.Blocks.Sources.Step step3(
    height=-200,
    offset=400,
    startTime=1500)
    annotation (Placement(transformation(extent={{-74,-110},{-54,-90}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource4(
    variable_m_flow=false,
    m_flow_const=90,
    T_const=313.15,
    variable_xi=false,
    xi_const={0,0,0,0,0.79,0.21,0,0,0}) annotation (Placement(transformation(extent={{-42,-60},{-22,-40}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink4(p_const=100000) annotation (Placement(transformation(extent={{-42,-84},{-22,-64}})));
equation
  connect(step.y, fluelGasFlowSource1.T) annotation (Line(
      points={{79,-20},{62,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step1.y, fluelGasFlowSource2.T) annotation (Line(
      points={{-59,8},{-42,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fluelGasFlowSource2.gas_a, regenerativeAirPreheater.freshAirInlet)
    annotation (Line(
      points={{-22,8},{-2,8},{-2,0},{8,0}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(regenerativeAirPreheater.freshAirOutlet, flueGasPressureSink2.gas_a)
    annotation (Line(
      points={{8,-12},{-2,-12},{-2,-20},{-22,-20}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(regenerativeAirPreheater.flueGasInlet, fluelGasFlowSource1.gas_a)
    annotation (Line(
      points={{28,-12},{38,-12},{38,-20},{42,-20}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(regenerativeAirPreheater.flueGasOutlet, flueGasPressureSink1.gas_a)
    annotation (Line(
      points={{28,0},{38,0},{38,8},{42,8}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step2.y, fluelGasFlowSource3.T) annotation (Line(
      points={{79,-104},{62,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step3.y,fluelGasFlowSource. m_flow) annotation (Line(
      points={{-53,-100},{-42,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fluelGasFlowSource4.gas_a, airPreheater.primaryAirInlet) annotation (
      Line(
      points={{-22,-50},{-2,-50},{-2,-82},{6,-82}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink4.gas_a, airPreheater.primaryAirOutlet)
    annotation (Line(
      points={{-22,-74},{-12,-74},{-12,-86},{6,-86}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(airPreheater.secondaryAirInlet, fluelGasFlowSource.gas_a) annotation (
     Line(
      points={{6,-94},{-12,-94},{-12,-106},{-22,-106}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink.gas_a, airPreheater.secondaryAirOutlet)
    annotation (Line(
      points={{-22,-128},{-2,-128},{-2,-98},{6,-98}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(airPreheater.flueGasOutlet, flueGasPressureSink3.gas_a) annotation (
      Line(
      points={{26,-84},{38,-84},{38,-76},{42,-76}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(airPreheater.flueGasInlet, fluelGasFlowSource3.gas_a) annotation (
      Line(
      points={{26,-96},{38,-96},{38,-104},{42,-104}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -140},{120,100}}),
                      graphics={  Text(
          extent={{-94,98},{104,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for the air preheater component

______________________________________________________________________________________________
")}),                            experiment(StopTime=2000),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)));
end Test_RegenerativeAirPreheater;
