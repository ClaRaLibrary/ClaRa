within ClaRa.Components.Furnace.Check;
model Test_CombustionChamber_control
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

  import ClaRa;
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  SimpleCombustionChamber combustionChamber(
    xi_slag=0,
    xi_NOx=0) annotation (Placement(transformation(extent={{16,-26},{36,-6}})));
  inner ClaRa.SimCenter simCenter(redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel)
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource(
    m_flow_const=1,
    variable_m_flow=true,
    fuelModel=simCenter.fuelModel1,
    xi_const=simCenter.fuelModel1.defaultComposition)  annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT slagSink annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={26,-58})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource(
    m_flow_const=2.2*6.7362,
    variable_m_flow=true,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                          annotation (Placement(transformation(extent={{-60,-20},{-40,-40}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink(p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={26,16})));
  Modelica.Blocks.Sources.Ramp setPoint_Q_boiler(
    duration=60,
    startTime=60,
    height=-70e6,
    offset=-30e6)
    annotation (Placement(transformation(extent={{-8,30},{-28,10}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_lambda(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_i=1,
    y_max=1000,
    k=1,
    t_activation=10,
    y_inactive=15,
    Tau_lag_I=5,
    y_ref=100,
    y_min=0.0,
    Tau_out=0.1)
    annotation (Placement(transformation(extent={{-40,-60},{-60,-80}})));
  Modelica.Blocks.Sources.RealExpression setPoint_lambda(y=1.10) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-14,-70})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_Q_boiler(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0.1,
    y_max=10,
    t_activation=30,
    y_inactive=1,
    k=1,
    Tau_lag_I=5,
    y_ref=1/30e6,
    Tau_i=1,
    sign=-1) annotation (Placement(transformation(extent={{-40,30},{-60,10}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join annotation (Placement(transformation(extent={{-24,-26},{-4,-6}})));
equation
  connect(combustionChamber.lambda, PID_lambda.u_m) annotation (Line(
      points={{15,-24},{0,-24},{0,-46},{-50.1,-46},{-50.1,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setPoint_lambda.y, PID_lambda.u_s) annotation (Line(
      points={{-25,-70},{-38,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_lambda.y, flueGasFlowSource.m_flow) annotation (Line(
      points={{-61,-70},{-68,-70},{-68,-36},{-60,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setPoint_Q_boiler.y, PID_Q_boiler.u_s) annotation (Line(
      points={{-29,20},{-38,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combustionChamber.Q_flow_boiler, PID_Q_boiler.u_m) annotation (Line(
      points={{37,-16},{52,-16},{52,42},{-50.1,42},{-50.1,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_Q_boiler.y, coalFlowSource.m_flow) annotation (Line(
      points={{-61,20},{-70,20},{-70,-4},{-60,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalFlowSource.fuel_a,coalGas_join.fuel_inlet)  annotation (Line(
      points={{-40,-10},{-24,-10}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource.gas_a, coalGas_join.flueGas_inlet) annotation (Line(
      points={{-40,-30},{-32,-30},{-32,-22},{-24,-22}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalGas_join.fuelFlueGas_outlet, combustionChamber.inlet) annotation (Line(
      points={{-4,-16},{16,-16}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasPressureSink.gas_a, combustionChamber.flueGas_outlet)
    annotation (Line(
      points={{26,6},{26,-6}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(combustionChamber.slag_outlet, slagSink.slag_inlet) annotation (Line(
      points={{26,-25.8},{26,-48},{26.2,-48}},
      color={234,171,0},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={  Text(
          extent={{-98,100},{46,62}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for simple combustion chamber component

______________________________________________________________________________________________
")}),
    experiment(StopTime=180),
    __Dymola_experimentSetupOutput);
end Test_CombustionChamber_control;
