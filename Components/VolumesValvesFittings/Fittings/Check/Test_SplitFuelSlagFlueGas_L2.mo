within ClaRa.Components.VolumesValvesFittings.Fittings.Check;
model Test_SplitFuelSlagFlueGas_L2
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
  import ClaRa;
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{78,80},{98,100}})));

  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource2(
    variable_m_flow=false,
    m_flow_const=40,
    xi_const={0.975,0.025})  annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={30,-90})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT slagSink(T_const=373.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow flueGasFlowSource2(
    variable_m_flow=false,
    m_flow_const=500,
    T_const=773.15,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.8,0.1985,0,0.001,0})
                    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-30,-90})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,-60})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_split coalSlagFlueGas_split1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={18,0})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_Tm_flow slagFlowSource1(m_flow_const=0, T_const=873.15) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,0})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi coalSink1(xi_const={0.975,0.025})                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={72,-30})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitFuelSlagFlueGas_L2 splitFuelSlagFlueGas_L2_1(
    N_ports_out=2,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=500, dp_nom=10),
    T_nom=773.15,
    T_start=773.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,-34})));
  ClaRa.Components.Adapters.FuelSlagFlueGas_split coalSlagFlueGas_split2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-16,0})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi flueGasPressureSink2(p_const=100000, T_const=773.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,52})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_Tm_flow slagFlowSource2(m_flow_const=0, T_const=873.15) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-70,0})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_pTxi coalSink2(xi_const={0.975,0.025})                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,-30})));
  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2 flueGasJunction_L2(
    volume=1,
    redeclare model PressureLossA = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=250, dp_nom=10),
    redeclare model PressureLossB = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=250, dp_nom=10),
    redeclare model PressureLossC = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=500, dp_nom=10),
    p_start(displayUnit="Pa") = 1e5,
    T_start=773.15) annotation (Placement(transformation(extent={{-10,30},{10,10}})));
equation
  connect(coalFlowSource2.fuel_a,coalSlagFlueGas_join.fuel_inlet)  annotation (
      Line(
      points={{30,-80},{30,-74},{6,-74},{6,-70}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasFlowSource2.gas_a,coalSlagFlueGas_join. flueGas_inlet)
    annotation (Line(
      points={{-30,-80},{-30,-74},{-6,-74},{-6,-70}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSink1.fuel_a, coalSlagFlueGas_split1.fuel_outlet) annotation (Line(
      points={{62,-30},{52,-30},{52,-6},{28,-6}},
      color={27,36,42},
      thickness=0.5,
      smooth=Smooth.None));
  connect(coalSlagFlueGas_split1.slag_inlet, slagFlowSource1.slag_outlet) annotation (Line(
      points={{28,-7.21645e-16},{44,-7.21645e-16},{44,7.21645e-16},{60,7.21645e-16}},
      color={234,171,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slagSink.slag_inlet, coalSlagFlueGas_join.slag_outlet) annotation (Line(
      points={{0.2,-80},{0.2,-75},{-1.83187e-15,-75},{-1.83187e-15,-70}},
      color={234,171,0},
      thickness=0.5));
  connect(coalSlagFlueGas_split2.slag_inlet, slagFlowSource2.slag_outlet) annotation (Line(
      points={{-26,7.21645e-16},{-43,7.21645e-16},{-43,0},{-60,0}},
      color={234,171,0},
      thickness=0.5));
  connect(coalSlagFlueGas_split2.fuel_outlet, coalSink2.fuel_a) annotation (Line(
      points={{-26,-6},{-52,-6},{-52,-30},{-58,-30}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitFuelSlagFlueGas_L2_1.outlet[1], coalSlagFlueGas_split1.fuelSlagFlueGas_inlet) annotation (Line(
      points={{-0.25,-24},{-0.25,1.72085e-15},{8,1.72085e-15}},
      color={118,106,98},
      thickness=0.5));
  connect(splitFuelSlagFlueGas_L2_1.outlet[2], coalSlagFlueGas_split2.fuelSlagFlueGas_inlet) annotation (Line(
      points={{0.25,-24},{0.25,-1.72085e-15},{-6,-1.72085e-15}},
      color={118,106,98},
      thickness=0.5));
  connect(coalSlagFlueGas_split2.flueGas_outlet, flueGasJunction_L2.portA) annotation (Line(
      points={{-26,6},{-30,6},{-30,20},{-10,20}},
      color={118,106,98},
      thickness=0.5));
  connect(coalSlagFlueGas_split1.flueGas_outlet, flueGasJunction_L2.portB) annotation (Line(
      points={{28,6},{32,6},{32,20},{10,20}},
      color={118,106,98},
      thickness=0.5));
  connect(flueGasPressureSink2.gas_a, flueGasJunction_L2.portC) annotation (Line(
      points={{-1.77636e-15,42},{0,42},{0,30}},
      color={118,106,98},
      thickness=0.5));
  connect(coalSlagFlueGas_join.fuelSlagFlueGas_outlet, splitFuelSlagFlueGas_L2_1.inlet) annotation (Line(
      points={{1.83187e-15,-50},{1.83187e-15,-43},{-1.83187e-15,-43},{-1.83187e-15,-44}},
      color={118,106,98},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={  Text(
          extent={{-98,98},{100,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> split for fuel flue gas and slag with gas volume

______________________________________________________________________________________________
")}), experiment(StopTime=10, __Dymola_Algorithm="Dassl"));
end Test_SplitFuelSlagFlueGas_L2;
