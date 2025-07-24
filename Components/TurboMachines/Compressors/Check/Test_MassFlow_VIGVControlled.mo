within ClaRa.Components.TurboMachines.Compressors.Check;
model Test_MassFlow_VIGVControlled
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
  inner SimCenter simCenter(redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel, T_amb=293.15)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  CompressorGas_L1_stageStacked GasFanAdvanced(
    J=0.1,
    rpm_fixed=3000,
    rpm_nom=3000,
    p_in_nom=1.0e5,
    Tau_aux=0.000001,
    useMechanicalPort=true,
    steadyStateTorque=false,
    T_in_nom=293.15,
    m_flow_nom=20,
    eta_mech=0.99,
    eta_isen_stage_nom=0.9,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useExternalVIGVangle=true,
    useFixedEnthalpyCharacteristic=true,
    N_VIGVstages=1,
    Pi_nom=1.125,
    N_stages=1,
    diameter=ones((1))*(1.5),
    psi_nom_fixed=ones((1))*(0.8)) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-46,-54})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT2(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-54})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT3(
    variable_p=false,
    xi_const={0,0,0,0,0.75,0.23,0,0,0},
    p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-94,-54})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1(
                                                    exact=true, useSupport=
        false)
    annotation (Placement(transformation(extent={{-96,-8},{-76,12}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=10)
    annotation (Placement(transformation(extent={{-72,-8},{-52,12}})));
  Modelica.Blocks.Sources.Ramp step2(
    offset=2*Modelica.Constants.pi*3000/60,
    height=0.1*2*Modelica.Constants.pi*3000/60,
    startTime=20,
    duration=5)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-114,2})));
  Modelica.Blocks.Sources.TimeTable timeTable1(
    startTime=0,
    offset=1.125e5,
    table=[0,0; 5,0; 10,0.015e5; 11,0.015e5])
    annotation (Placement(transformation(extent={{52,-70},{32,-50}})));
  Sensors.SensorGas_L1_m_flow gasMassflowSensor annotation (Placement(transformation(extent={{-32,-54},{-12,-34}})));
  Utilities.Blocks.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    perUnitConversion=true,
    u_ref=GasFanAdvanced.m_flow_nom,
    y_ref=1,
    y_max=30,
    y_min=-30,
    y_start=0,
    k=10,
    Tau_i=0.01,
    initOption=796) annotation (Placement(transformation(extent={{-154,-38},{-134,-18}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=GasFanAdvanced.m_flow_nom)
    annotation (Placement(transformation(extent={{-192,-38},{-172,-18}})));
equation
  connect(speed1.flange, inertia1.flange_a) annotation (Line(
      points={{-76,2},{-72,2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(step2.y, speed1.w_ref) annotation (Line(
      points={{-103,2},{-98,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inertia1.flange_b, GasFanAdvanced.shaft) annotation (Line(
      points={{-52,2},{-46,2},{-46,-46}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gasSink_pT2.p, timeTable1.y) annotation (Line(
      points={{20,-60},{31,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasMassflowSensor.outlet, gasSink_pT2.gas_a) annotation (Line(
      points={{-12,-54},{0,-54}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID.y, GasFanAdvanced.Delta_alpha_input) annotation (Line(
      points={{-133,-28},{-70,-28},{-70,-47.6},{-54.64,-47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasMassflowSensor.m_flow, PID.u_m) annotation (Line(
      points={{-11,-44},{-6,-44},{-6,-72},{-143.9,-72},{-143.9,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, PID.u_s) annotation (Line(
      points={{-171,-28},{-156,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT3.gas_a, GasFanAdvanced.inlet) annotation (Line(
      points={{-84,-54},{-54,-54}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GasFanAdvanced.outlet, gasMassflowSensor.inlet) annotation (Line(
      points={{-38,-54},{-32,-54}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-80},{60,60}}, preserveAspectRatio=false),
            graphics={          Text(
          extent={{-198,46},{-124,36}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>> Example for a VIGV mass flow control of a compressor with changing pressure ratio
LOOK AT:
>> Time plots of mass flow and pressure ratio as well as the VIGV position

")}),
    experiment(StopTime=30),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}},     preserveAspectRatio=false)));
end Test_MassFlow_VIGVControlled;
