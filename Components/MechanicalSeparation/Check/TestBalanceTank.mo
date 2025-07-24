within ClaRa.Components.MechanicalSeparation.Check;
model TestBalanceTank

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
  BalanceTank_L3 balanceTank_L3_1(
    diameter_i=3,
    s_wall=0.02,
    height=10,
    T_gas_start=24 + 273.15,
    p_start=1.016e5,
    T_start=ones(3)*(293.15),
    initFluid="Fixed value for filling level",
    h_liq_start=108e3 - 8e3,
    gasMedium=simCenter.airModel,
    levelOutput=true,
    initOptionWall=213) annotation (Placement(transformation(extent={{-14,-48},{6,-28}})));
  VolumesValvesFittings.Valves.GenericValveGas_L1 valve(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                               m_flow_nom=10), medium=simCenter.airModel) annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=180,
        origin={-26,-8})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT(variable_p=true, medium=simCenter.airModel) annotation (Placement(transformation(extent={{-62,-16},{-42,4}})));
  Modelica.Blocks.Sources.Trapezoid
                               ramp2(
    startTime=10000,
    amplitude=0.5e5,
    rising=100,
    width=2000,
    falling=10,
    period=20000,
    offset=simCenter.p_amb_start - 0.1e5)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={20,-8})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(m_flow_const=-15) annotation (Placement(transformation(extent={{-46,-56},{-26,-36}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={50,-14})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    height=-5,
    offset=0,
    startTime=20000)
    annotation (Placement(transformation(extent={{94,-40},{74,-20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=5,
    duration=10,
    offset=10,
    startTime=18000)
    annotation (Placement(transformation(extent={{94,-8},{74,12}})));
  inner SimCenter simCenter(
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel,
    redeclare TILMedia.Gas.Types.MoistAirMixture airModel)
    annotation (Placement(transformation(extent={{78,-68},{98,-48}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h2(variable_m_flow=false, m_flow_const=2.5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,28})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h3(variable_m_flow=false, m_flow_const=2.5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,10})));
equation
  connect(valve.outlet,gasSink_pT. gas_a)                   annotation (Line(
      points={{-36,-8},{-36,-6},{-42,-6}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp2.y,gasSink_pT. p) annotation (Line(
      points={{-69,0},{-62,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve.inlet, balanceTank_L3_1.vent1) annotation (Line(
      points={{-16,-8},{-16,-8},{-4,-8},{-4,-28}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a, balanceTank_L3_1.outlet) annotation (Line(
      points={{-26,-46},{-26,-45.2},{-13.7333,-45.2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp1.y, multiSum.u[1]) annotation (Line(
      points={{73,-30},{66,-30},{66,-12.95},{56,-12.95}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, multiSum.u[2]) annotation (Line(
      points={{73,2},{66,2},{66,-15.05},{56,-15.05}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, massFlowSource_h1.m_flow) annotation (Line(
      points={{42.98,-14},{32,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a, balanceTank_L3_1.inlet3) annotation (Line(
      points={{10,-8},{4.66667,-8},{4.66667,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(balanceTank_L3_1.inlet2, massFlowSource_h3.steam_a) annotation (Line(
      points={{2.13333,-28},{2.13333,10},{32,10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(balanceTank_L3_1.inlet1, massFlowSource_h2.steam_a) annotation (Line(
      points={{-0.666667,-28},{-0.666667,28},{58,28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
                                  Text(
          extent={{-96,98},{102,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
Show balance tank functionality for charging and discharging situations
______________________________________________________________________________________________
")}),
    experiment(StopTime=30000, Tolerance=1e-006),
    __Dymola_experimentSetupOutput);
end TestBalanceTank;
