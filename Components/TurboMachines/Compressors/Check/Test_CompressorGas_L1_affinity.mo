within ClaRa.Components.TurboMachines.Compressors.Check;
model Test_CompressorGas_L1_affinity
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
  inner SimCenter simCenter                                annotation (Placement(transformation(extent={{40,40},{60,60}})));
  CompressorGas_L1_affinity GasFanAdvanced(
    Delta_p_max=1e5,
    eta=0.85,
    J=0.1,
    rpm_fixed=3000,
    rpm_nom=3000,
    exp_hyd=0.5,
    Delta_p_eps=1,
    steadyStateTorque=true,
    useMechanicalPort=true,
    V_flow_max=1)    annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-22,-44})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT2(variable_p=true, p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-44})));
  Modelica.Blocks.Sources.Ramp step1(
    startTime=5,
    duration=5,
    height=1e5,
    offset=1.21e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-50})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT3(variable_p=false, p_const=120000) annotation (Placement(transformation(
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
    duration=5,
    offset=2*Modelica.Constants.pi*3000/60,
    startTime=10,
    height=0.1*2*Modelica.Constants.pi*3000/60)
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-86,12})));
equation
  connect(step1.y, gasSink_pT2.p)
                                annotation (Line(
      points={{31,-50},{24,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speed1.flange, inertia1.flange_a) annotation (Line(
      points={{-48,12},{-44,12}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inertia1.flange_b, GasFanAdvanced.shaft) annotation (Line(
      points={{-24,12},{-22,12},{-22,-36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(step2.y, speed1.w_ref) annotation (Line(
      points={{-75,12},{-70,12}},
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
>> Tester for an affinity law based compressor model with different inputs


")}),
    experiment(StopTime=15),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end Test_CompressorGas_L1_affinity;
