within ClaRa.Components.Mills.HardCoalMills.Check;
model combineMillandFurnace
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
  Modelica.Blocks.Sources.Ramp PTarget1(
    startTime=10000,
    duration=1000,
    offset=1,
    height=-0.2)
    annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
  BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource1(
    m_flow_const=2.2*6.7362,
    variable_m_flow=true,
    T_const=393.15,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                    annotation (Placement(transformation(extent={{-50,-53},{-30,-33}})));
  BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource(m_flow_const=2, variable_m_flow=true)                                                 annotation (Placement(transformation(extent={{-48,-16},{-28,4}})));
  Modelica.Blocks.Math.Gain gain2(k=1200e6/30e6) "INIT.boiler.Q_nom/combustionChamber.LHV_fixed"                 annotation (Placement(transformation(extent={{-66,-5},{-56,5}})));
  Modelica.Blocks.Sources.RealExpression m_Primary2(y=-1.1*coalFlowSource.fuel_a.m_flow
        *15) "combustionChamber.m_flow_air_req*1.1"
    annotation (Placement(transformation(extent={{16,-14},{-16,14}},
        rotation=180,
        origin={-84,-37})));
  ClaRa.Components.Mills.HardCoalMills.VerticalMill_L3 mills1(
    millKoeff=ClaRa.Components.Mills.HardCoalMills.Fundamentals.STV1(),
    N_mills=1,
    initOption=0,
    T_out_start=363.15) annotation (Placement(transformation(extent={{30,-33},{50,-13}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    offset=1.50,
    startTime=1000,
    duration=10,
    height=0)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  ClaRa.Components.Adapters.FuelFlueGas_join coalGas_join_burner4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={8,-23})));

  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1, redeclare
      Basics.Media.FuelTypes.Fuel_verbandsformel_v2 fuelModel1)
    annotation (Placement(transformation(extent={{-100,80},{-60,100}})));
  Furnace.SimpleCombustionChamber combustionChamber(xi_NOx=0) annotation (Placement(transformation(extent={{60,-33},{80,-13}})));
  BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink(                                  p_const=100000, xi_const={0,0,0,0,0.79,0.21,0,0,0})
                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,18})));
  BoundaryConditions.BoundarySlag_pT coalSink annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-58})));
equation
  connect(PTarget1.y, gain2.u)
                              annotation (Line(
      points={{-73,0},{-67,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain2.y, coalFlowSource.m_flow) annotation (Line(
      points={{-55.5,0},{-55.5,0.5},{-48,0.5},{-48,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, mills1.classifierSpeed) annotation (Line(
      points={{1,30},{40,30},{40,-12.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coalGas_join_burner4.fuelFlueGas_outlet, mills1.inlet) annotation (Line(
      points={{18,-23},{30,-23}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(coalFlowSource.fuel_a,coalGas_join_burner4.fuel_inlet)   annotation (
      Line(
      points={{-28,-6},{-20,-6},{-20,-17},{-2,-17}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      smooth=Smooth.None));
  connect(fluelGasFlowSource1.gas_a, coalGas_join_burner4.flueGas_inlet)
    annotation (Line(
      points={{-30,-43},{-20,-43},{-20,-29},{-2,-29}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasPressureSink.gas_a, combustionChamber.flueGas_outlet)
    annotation (Line(
      points={{70,8},{70,-13}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(coalSink.slag_inlet, combustionChamber.slag_outlet) annotation (Line(
      points={{70.2,-48},{70.2,-32.8},{70,-32.8}},
      color={127,127,0},
      smooth=Smooth.None));
  connect(mills1.outlet, combustionChamber.inlet) annotation (Line(
      points={{50,-23},{60,-23}},
      color={175,175,175},
      smooth=Smooth.None));
  connect(m_Primary2.y, fluelGasFlowSource1.m_flow) annotation (Line(
      points={{-66.4,-37},{-50,-37}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={Text(
          extent={{-100,-84},{100,-100}},
          lineColor={0,128,0},
          lineThickness=0.5,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          textString="IDEA:
shows how to combine a mill model to a simple furnace model",
          horizontalAlignment=TextAlignment.Left)}),
    experiment(StopTime=20000),
    __Dymola_experimentSetupOutput);
end combineMillandFurnace;
