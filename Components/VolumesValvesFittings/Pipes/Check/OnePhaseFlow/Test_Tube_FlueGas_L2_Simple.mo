within ClaRa.Components.VolumesValvesFittings.Pipes.Check.OnePhaseFlow;
model Test_Tube_FlueGas_L2_Simple
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  inner SimCenter simCenter(
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    redeclare ClaRa.Basics.Media.Fuel.Coal_Reference fuelModel1,
    redeclare ClaRa.Basics.Media.Slag.Slag_v2 slagModel,
    redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel)
    annotation (Placement(transformation(extent={{70,76},{90,96}})));

  PipeFlowGas_L4_Simple tube(
    length=10,
    N_cv=10,
    m_flow_nom=10,
    N_tubes=1,
    diameter_i=0.5,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    xi_start={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    T_nom=293.15*ones(10),
    T_start=298.15*ones(10),
    initOption=0)
    annotation (Placement(transformation(extent={{-16,-86},{16,-74}})));

  BoundaryConditions.BoundaryGas_pTxi flueGasFlowSource(
    variable_xi=false,
    T_const(displayUnit="K") = 298.15,
    variable_T=true,
    p_const=1.1e5,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0})
                   annotation (Placement(transformation(extent={{-54,-90},{-34,-70}})));
  BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink_top(T_const=283.15, p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-80})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    length=tube.length,
    Delta_x=tube.Delta_x,
    N_ax=tube.N_cv,
    stateLocation=2,
    T_start=323.15*ones(tube.N_cv),
    diameter_i=tube.diameter_i,
    N_tubes=tube.N_tubes,
    diameter_o=tube.diameter_i + 0.01,
    initOption=213) annotation (Placement(transformation(extent={{-10,-53},{10,-46}})));
  Modelica.Blocks.Sources.Ramp T_wall(
    duration=10,
    offset=298.15,
    startTime=100,
    height=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-86,-80})));
  Modelica.Blocks.Sources.Ramp T_wall1(
    duration=10,
    offset=323.15,
    startTime=150,
    height=1) annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={-85.5,-20.5})));
  Utilities.Blocks.RealInputMultiplyer realInputMultiplyer(N=tube.N_cv) annotation (Placement(transformation(extent={{-66,-30},{-46,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature[tube.N_cv] annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-10,-20})));
equation
  connect(flueGasFlowSource.gas_a, tube.inlet) annotation (Line(
      points={{-34,-80},{-16,-80}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(tube.outlet, flueGasPressureSink_top.gas_a) annotation (Line(
      points={{16,-80},{70,-80}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(thinWall.innerPhase, tube.heat) annotation (Line(
      points={{0,-53},{0,-75.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_wall.y, flueGasFlowSource.T) annotation (Line(
      points={{-75,-80},{-54,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_wall1.y, realInputMultiplyer.Signal) annotation (Line(
      points={{-73.95,-20.5},{-73.975,-20.5},{-73.975,-20},{-67.8,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realInputMultiplyer.y, prescribedTemperature.T) annotation (Line(
      points={{-45,-20.05},{-32,-20.05},{-32,-20},{-17.2,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thinWall.outerPhase) annotation (Line(
      points={{-4,-20},{0,-20},{0,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics={
                                  Text(
          extent={{-98,98},{100,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for the flue gas pipe component

______________________________________________________________________________________________
")}),                                            Icon(graphics,
                                                      coordinateSystem(extent={
            {-100,-100},{100,100}}, preserveAspectRatio=false)),
    experiment(StopTime=300));
end Test_Tube_FlueGas_L2_Simple;
