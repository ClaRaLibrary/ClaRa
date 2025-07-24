within ClaRa.Components.TurboMachines.Turbines.Check;
model testSingleTurbineStage
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
  TurbineGas_L1_stageStacked GasFanAdvanced(
    rpm_nom=3000,
    useMechanicalPort=true,
    steadyStateTorque=false,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useExternalVIGVangle=true,
    rpm_fixed=2700,
    J=10,
    m_flow_nom=100,
    VIGVInfluence="Medium",
    T_in_nom=600,
    eta_isen_stage_nom=0.9,
    Pi_nom=1/2,
    p_in_nom(displayUnit="bar") = 200000,
    N_VIGVstages=1,
    Tau_aux=0.0001,
    useFixedEnthalpyCharacteristic=false,
    N_stages=1,
    psi_nom_fixed=ones((1))*(-2.5)) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=0,
        origin={-29,-36})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT2(
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000,
    variable_p=true)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-46})));
  Modelica.Blocks.Sources.Ramp PressureOutletRamp(
    duration=5,
    startTime=10,
    offset=1e5,
    height=0.2e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={44,-34})));
  BoundaryConditions.BoundaryGas_pTxi
                                gasSink_pT3(
    xi_const={0,0,0,0,0.75,0.23,0,0,0},
    T_const=600,
    p_const(displayUnit="bar") = 200000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-72,-30})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true, useSupport=
        false)
    annotation (Placement(transformation(extent={{-68,16},{-48,36}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=10)
    annotation (Placement(transformation(extent={{-44,16},{-24,36}})));
  Modelica.Blocks.Sources.Ramp SpeedInputRamp(
    duration=5,
    startTime=15,
    height=0.0*2*Modelica.Constants.pi*3000/60,
    offset=1*2*Modelica.Constants.pi*3000/60)
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-86,26})));
  Modelica.Blocks.Sources.TimeTable VIGVTimeTable(
    offset=0,
    startTime=0,
    table=[0,0; 2.5,0; 5,5; 7.5,0; 10,0])
    annotation (Placement(transformation(extent={{-96,-16},{-76,4}})));
equation
  connect(PressureOutletRamp.y, gasSink_pT2.p)
                                annotation (Line(
      points={{33,-34},{28,-34},{28,-52},{24,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speed.flange, inertia.flange_a)   annotation (Line(
      points={{-48,26},{-44,26}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(SpeedInputRamp.y, speed.w_ref)
                                 annotation (Line(
      points={{-75,26},{-70,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VIGVTimeTable.y, GasFanAdvanced.Delta_alpha_input)
                                                         annotation (Line(
      points={{-75,-6},{-48,-6},{-48,-28},{-34,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT3.gas_a, GasFanAdvanced.inlet) annotation (Line(
      points={{-62,-30},{-34,-30}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GasFanAdvanced.outlet, gasSink_pT2.gas_a) annotation (Line(
      points={{-24,-46},{4,-46}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GasFanAdvanced.shaft_b, inertia.flange_b) annotation (Line(points={{-34,-36},{-40,-36},{-40,-2},{-24,-2},{-24,26}}, color={0,0,0}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-60},{60,60}}, preserveAspectRatio=false),
            graphics={          Text(
          extent={{-98,50},{-18,48}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>> Tester for a single gas turbine stage")}),
    experiment(StopTime=20),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end testSingleTurbineStage;
