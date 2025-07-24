within ClaRa.Components.TurboMachines.Turbines.Check;
model testStackedTurbineStages
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
  inner SimCenter simCenter(
    contributeToCycleSummary=true,
    redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel,
    T_amb=293.15) annotation (Placement(transformation(extent={{40,40},{60,60}})));
  TurbineGas_L1_stageStacked GasFanAdvanced(
    rpm_nom=3000,
    Tau_aux=0.000001,
    useMechanicalPort=true,
    steadyStateTorque=false,
    eta_mech=0.99,
    Delta_alpha_fixed=0,
    xi_nom={0,0,0,0,0.75,0.23,0,0,0},
    useExternalVIGVangle=true,
    useFixedEnthalpyCharacteristic=true,
    rpm_fixed=2700,
    J=10,
    m_flow_nom=100,
    VIGVInfluence="Medium",
    T_in_nom=600,
    p_in_nom(displayUnit="bar") = 700000,
    N_VIGVstages=3,
    Pi_nom=1/7,
    eta_isen_stage_nom=0.9,
    N_stages=5,
    diameter=ones((5))*(1.5),
    psi_nom_fixed=ones((5))*(-2.5)) annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=0,
        origin={-29,-32})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT2(
    variable_p=true,
    xi_const={0,0,0.0005,0,0.7581,0.2314,0,0,0.01},
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-42})));
  Modelica.Blocks.Sources.Ramp PressureOutletRamp(
    duration=5,
    startTime=10,
    height=1.5e5,
    offset=1e5)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={48,-48})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT3(
    variable_p=false,
    xi_const={0,0,0,0,0.75,0.23,0,0,0},
    p_const(displayUnit="bar") = 700000,
    T_const=600) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,-26})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true, useSupport=
        false)
    annotation (Placement(transformation(extent={{24,-8},{4,12}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=10)
    annotation (Placement(transformation(extent={{-8,-8},{-28,12}})));
  Modelica.Blocks.Sources.Ramp SpeedInputRamp(
    duration=5,
    startTime=15,
    height=0.0*2*Modelica.Constants.pi*3000/60,
    offset=1*2*Modelica.Constants.pi*3000/60)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={48,2})));
  Modelica.Blocks.Sources.TimeTable VIGVTimeTable(
    offset=0,
    startTime=0,
    table=[0,0; 2.5,0; 5,5; 7.5,0; 10,0])
    annotation (Placement(transformation(extent={{-96,-6},{-76,14}})));
equation
  connect(PressureOutletRamp.y, gasSink_pT2.p)
                                annotation (Line(
      points={{37,-48},{24,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speed.flange, inertia.flange_a)   annotation (Line(
      points={{4,2},{-8,2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(SpeedInputRamp.y, speed.w_ref)
                                 annotation (Line(
      points={{37,2},{26,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VIGVTimeTable.y, GasFanAdvanced.Delta_alpha_input)
                                                         annotation (Line(
      points={{-75,4},{-48,4},{-48,-24},{-34,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT3.gas_a, GasFanAdvanced.inlet) annotation (Line(
      points={{-64,-26},{-34,-26}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GasFanAdvanced.outlet, gasSink_pT2.gas_a) annotation (Line(
      points={{-24,-42},{4,-42}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inertia.flange_b, GasFanAdvanced.shaft_b) annotation (Line(points={{-28,2},{-40,2},{-40,-32},{-34,-32}}, color={0,0,0}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-60},{60,60}}, preserveAspectRatio=false),
            graphics={            Text(
          extent={{-98,66},{100,26}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for the gas turbine component

______________________________________________________________________________________________
")}),
    experiment(StopTime=20),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end testStackedTurbineStages;
