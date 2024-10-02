within ClaRa.Components.Adapters.Check;
model TestGasSensorAdapter

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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  ClaRa.Components.Adapters.GasSensorAdapter gasSensorAdapter annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-4,-20})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_Tm_flow boundarySlag_Tm_flow(m_flow_const=1) annotation (Placement(transformation(extent={{-84,-32},{-64,-12}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow boundaryGas_Txim_flow(m_flow_const=1) annotation (Placement(transformation(extent={{-84,-54},{-64,-34}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow boundaryFuel_Txim_flow(m_flow_const=1) annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_join fuelSlagFlueGas_join annotation (Placement(transformation(extent={{-48,-30},{-28,-10}})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_split fuelSlagFlueGas_split annotation (Placement(transformation(extent={{16,-30},{36,-10}})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT boundarySlag_pT annotation (Placement(transformation(extent={{76,-30},{56,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi boundaryFuel_pTxi annotation (Placement(transformation(extent={{80,-6},{60,14}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi annotation (Placement(transformation(extent={{78,-60},{58,-40}})));
  ClaRa.Components.Sensors.TinySensorGas_L1_p sensorGas_L1_p annotation (Placement(transformation(extent={{4,-58},{16,-46}})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{-62,72},{-22,92}})));
equation
  connect(boundaryGas_Txim_flow.gas_a, fuelSlagFlueGas_join.flueGas_inlet) annotation (Line(
      points={{-64,-44},{-56,-44},{-56,-26},{-48,-26}},
      color={118,106,98},
      thickness=0.5));
  connect(boundarySlag_Tm_flow.slag_outlet, fuelSlagFlueGas_join.slag_outlet) annotation (Line(
      points={{-64,-22},{-56,-22},{-56,-20},{-48,-20}},
      color={234,171,0},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryFuel_Txim_flow.fuel_a, fuelSlagFlueGas_join.fuel_inlet) annotation (Line(
      points={{-68,8},{-58,8},{-58,-14},{-48,-14}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fuelSlagFlueGas_join.fuelSlagFlueGas_outlet, gasSensorAdapter.inlet) annotation (Line(
      points={{-28,-20},{-14,-20}},
      color={118,106,98},
      thickness=0.5));
  connect(gasSensorAdapter.outlet, fuelSlagFlueGas_split.fuelSlagFlueGas_inlet) annotation (Line(
      points={{6,-20},{16,-20}},
      color={118,106,98},
      thickness=0.5));
  connect(boundarySlag_pT.slag_inlet, fuelSlagFlueGas_split.slag_inlet) annotation (Line(
      points={{56,-20.2},{44,-20.2},{44,-20},{36,-20}},
      color={234,171,0},
      thickness=0.5));
  connect(boundaryFuel_pTxi.fuel_a, fuelSlagFlueGas_split.fuel_outlet) annotation (Line(
      points={{60,4},{48,4},{48,-14},{36,-14}},
      color={27,36,42},
      thickness=0.5));
  connect(boundaryGas_pTxi.gas_a, fuelSlagFlueGas_split.flueGas_outlet) annotation (Line(
      points={{58,-50},{48,-50},{48,-26},{36,-26}},
      color={118,106,98},
      thickness=0.5));
  connect(sensorGas_L1_p.port, gasSensorAdapter.gasPort) annotation (Line(
      points={{10,-58},{0,-58},{0,-54},{-4,-54},{-4,-30}},
      color={118,106,98},
      thickness=0.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
end TestGasSensorAdapter;
