within ClaRa.Components.TurboMachines.Compressors.Check;
model Test_CompressorGas_L1_stageStacked_singleStage
//___________________________________________________________________________//
// Component of the ClaRa library, version: 0.1 alpha                        //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under the 3-clause BSD License.   //
// Copyright  2013, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
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
    Pi_nom=1.18,
    N_stages=1,
    diameter=ones((1))*(1.5),
    psi_nom_fixed=ones((1))*(0.8)) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-22,-44})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT2(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-44})));
  Modelica.Blocks.Sources.Ramp step1(
    duration=5,
    startTime=10,
    height=0.0e5,
    offset=1.2e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-50})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT3(
    variable_p=false,
    xi_const={0,0,0,0,0.75,0.23,0,0,0},
    p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-44})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1(
                                                    exact=true, useSupport=
        false)
    annotation (Placement(transformation(extent={{-68,2},{-48,22}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=10)
    annotation (Placement(transformation(extent={{-44,2},{-24,22}})));
  Modelica.Blocks.Sources.Ramp step2(
    offset=2*Modelica.Constants.pi*3000/60,
    startTime=10,
    duration=2.5,
    height=0.2*2*Modelica.Constants.pi*3000/60)
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-86,12})));
  Modelica.Blocks.Sources.TimeTable timeTable(
    offset=0,
    startTime=0,
    table=[0,0; 2.5,0; 5,10; 7.5,0; 10,0])
    annotation (Placement(transformation(extent={{-96,-28},{-76,-8}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(
    startTime=0,
    offset=1.125e5,
    table=[0,0; 10,0; 11,0; 12.5,0; 20,0e5; 22.5,0.06608e5; 23,0.06608e5])
    annotation (Placement(transformation(extent={{52,-28},{32,-8}})));
equation
  connect(speed1.flange, inertia1.flange_a) annotation (Line(
      points={{-48,12},{-44,12}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(step2.y, speed1.w_ref) annotation (Line(
      points={{-75,12},{-70,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inertia1.flange_b, GasFanAdvanced.shaft) annotation (Line(
      points={{-24,12},{-24,-36},{-22,-36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(timeTable.y, GasFanAdvanced.Delta_alpha_input) annotation (Line(
      points={{-75,-18},{-48,-18},{-48,-37.6},{-30.64,-37.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT2.p, timeTable1.y) annotation (Line(
      points={{24,-50},{24,-18},{31,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT3.gas_a, GasFanAdvanced.inlet) annotation (Line(
      points={{-60,-44},{-30,-44}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GasFanAdvanced.outlet, gasSink_pT2.gas_a) annotation (Line(
      points={{-14,-44},{4,-44}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-80},{60,60}}, preserveAspectRatio=false),
            graphics={          Text(
          extent={{-98,46},{-24,36}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>> Tester for a single compressor stage


")}),
    experiment(StopTime=20),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end Test_CompressorGas_L1_stageStacked_singleStage;
