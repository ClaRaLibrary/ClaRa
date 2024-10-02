within ClaRa.Components.Mills.HardCoalMills.Check;
model SimpleMillTester
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                    annotation (Placement(transformation(extent={{-50,-53},{-30,-33}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow
                                            coalFlowSource(m_flow_const=2, variable_m_flow=true)                     annotation (Placement(transformation(extent={{-50,-16},{-30,4}})));
  Modelica.Blocks.Math.Gain gain2(k=1200e6/30e6) "INIT.boiler.Q_nom/combustionChamber.LHV_fixed"                 annotation (Placement(transformation(extent={{-66,-5},{-56,5}})));
  Modelica.Blocks.Sources.RealExpression m_Primary2(y=-1.1*coalFlowSource.fuel_a.m_flow*15)
             "combustionChamber.m_flow_air_req*1.1"
    annotation (Placement(transformation(extent={{16,-14},{-16,14}},
        rotation=180,
        origin={-84,-37})));
  Modelica.Blocks.Sources.Ramp ramp1(
    offset=1.50,
    startTime=1000,
    duration=10,
    height=0)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  ClaRa.Components.Adapters.FuelFlueGas_join join         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-30})));

  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1, redeclare Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel1) annotation (Placement(transformation(extent={{-100,80},{-60,100}})));
  Adapters.FuelFlueGas_split split         annotation (Placement(transformation(extent={{36,-40},{56,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi fuelBoundary_pTxi         annotation (Placement(transformation(extent={{94,-18},{74,2}})));
  VerticalMill_L3 verticalMill_L3_1(
    gasIn(
    d(start=1)),
    gasOut(humRatio(start=0.2)),
    initOption=1,
    N_mills=3,
    xi_coal_h2o_res=0.02)           annotation (Placement(transformation(extent={{8,-40},{28,-20}})));
  BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi annotation (Placement(transformation(extent={{94,-46},{74,-24}})));
equation
  connect(PTarget1.y, gain2.u)
                              annotation (Line(
      points={{-73,0},{-67,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain2.y, coalFlowSource.m_flow) annotation (Line(
      points={{-55.5,0},{-55.5,0.5},{-50,0.5},{-50,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fluelGasFlowSource1.gas_a, join.flueGas_inlet) annotation (Line(
      points={{-30,-43},{-20,-43},{-20,-36}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(m_Primary2.y, fluelGasFlowSource1.m_flow) annotation (Line(
      points={{-66.4,-37},{-50,-37}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundaryGas_pTxi.gas_a, split.flueGas_outlet) annotation (Line(
      points={{74,-35},{62,-35},{62,-36},{56,-36}},
      color={118,106,98},
      thickness=0.5));
  connect(join.fuelFlueGas_outlet, verticalMill_L3_1.inlet) annotation (Line(
      points={{0,-30},{8,-30}},
      color={118,106,98},
      thickness=0.5));
  connect(verticalMill_L3_1.outlet, split.fuelFlueGas_inlet) annotation (Line(
      points={{28,-30},{36,-30}},
      color={118,106,98},
      thickness=0.5));
  connect(ramp1.y, verticalMill_L3_1.classifierSpeed) annotation (Line(points={{1,30},{18,30},{18,-19.2}}, color={0,0,127}));
  connect(coalFlowSource.fuel_a, join.fuel_inlet) annotation (Line(
      points={{-30,-6},{-22,-6},{-22,-24},{-20,-24}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(split.fuel_outlet, fuelBoundary_pTxi.fuel_a) annotation (Line(
      points={{56,-24},{66,-24},{66,-8},{74,-8}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
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
end SimpleMillTester;
