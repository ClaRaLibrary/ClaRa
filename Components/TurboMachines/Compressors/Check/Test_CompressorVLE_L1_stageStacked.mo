within ClaRa.Components.TurboMachines.Compressors.Check;
model Test_CompressorVLE_L1_stageStacked
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
  inner SimCenter simCenter(
    redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel,
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    T_amb=293.15) annotation (Placement(transformation(extent={{40,40},{60,60}})));
  CompressorVLE_L1_stageStacked GasFanAdvanced(
    rpm_nom=3000,
    steadyStateTorque=false,
    Pi_nom=7,
    eta_mech=0.99,
    eta_isen_stage_nom=0.9,
    Delta_alpha_fixed=0,
    useFixedEnthalpyCharacteristic=true,
    rpm_fixed=2700,
    p_in_nom(displayUnit="bar") = 100000,
    J=10,
    m_flow_nom=100,
    VIGVInfluence="Medium",
    useMechanicalPort=true,
    Tau_aux=0.1,
    T_in_nom=500,
    N_VIGVstages=3,
    useExternalVIGVangle=true,
    contributeToCycleSummary=false,
    N_stages=12,
    diameter=ones((12))*(1.5),
    psi_nom_fixed=ones((12))*(0.8)) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-22,-44})));
  BoundaryConditions.BoundaryVLE_pTxi gasSink_pT2(
    variable_p=true,
    p_const=120000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={14,-44})));
  Modelica.Blocks.Sources.Ramp PressureOutletRamp(
    duration=5,
    offset=7e5,
    startTime=10,
    height=1.5e5)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,-50})));
  BoundaryConditions.BoundaryVLE_pTxi gasSink_pT3(
    variable_p=false,
    p_const=100000,
    T_const=500)    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-44})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true, useSupport=
        false)
    annotation (Placement(transformation(extent={{-68,2},{-48,22}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=10)
    annotation (Placement(transformation(extent={{-44,2},{-24,22}})));
  Modelica.Blocks.Sources.Ramp SpeedInputRamp(
    duration=5,
    startTime=15,
    height=0.0*2*Modelica.Constants.pi*3000/60,
    offset=1*2*Modelica.Constants.pi*3000/60)
                 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-86,12})));
  Modelica.Blocks.Sources.TimeTable VIGVTimeTable(
    offset=0,
    startTime=0,
    table=[0,0; 2.5,0; 5,5; 7.5,0; 10,0])
    annotation (Placement(transformation(extent={{-96,-30},{-76,-10}})));
equation
  connect(PressureOutletRamp.y, gasSink_pT2.p)
                                annotation (Line(
      points={{31,-50},{24,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speed.flange, inertia.flange_a)   annotation (Line(
      points={{-48,12},{-44,12}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(SpeedInputRamp.y, speed.w_ref)
                                 annotation (Line(
      points={{-75,12},{-70,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inertia.flange_b, GasFanAdvanced.shaft)  annotation (Line(
      points={{-24,12},{-24,12},{-22,12},{-22,-36},{-22,-36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(VIGVTimeTable.y, GasFanAdvanced.Delta_alpha_input)
                                                         annotation (Line(
      points={{-75,-20},{-48,-20},{-48,-37.6},{-30.64,-37.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSink_pT3.steam_a, GasFanAdvanced.fluid_inlet) annotation (Line(
      points={{-60,-44},{-30,-44}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(GasFanAdvanced.fluid_outlet, gasSink_pT2.steam_a) annotation (Line(
      points={{-14,-44},{4,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-80},{60,60}}, preserveAspectRatio=false),
            graphics={          Text(
          extent={{-98,50},{-24,40}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>> Tester for a physical compressor model according to the stage stacking method")}),
    experiment(StopTime=20),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end Test_CompressorVLE_L1_stageStacked;
