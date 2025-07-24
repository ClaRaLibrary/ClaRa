within ClaRa.Components.VolumesValvesFittings.Fittings.Check;
model Test_Junction
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
  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2
    flueGasJunction(
    volume=0.1)                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-16,14})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source2(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=0.1,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0},
    T_const=298.15)   annotation (Placement(transformation(extent={{-74,4},{-54,24}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source1(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=0.1,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0},
    T_const=298.15)   annotation (Placement(transformation(extent={{-74,26},{-54,46}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow sink(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=-0.2,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0})
                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,14})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{78,80},{98,100}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2
    flueGasJunction1(
    volume=0.1)                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-16,-8})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source01(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=0.2,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0})
                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,-8})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow sink01(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=-0.1,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0})
                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,-8})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow sink02(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=-0.1,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0})
                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,-30})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source3(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=10,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0})
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,-38})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi gasSink_pT1(p_const=100000, xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0})
                                                                                   annotation (Placement(transformation(extent={{68,-64},{48,-44}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2
    flueGasJunction2(
    volume=1)                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={28,-54})));
  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2
    flueGasJunction3(
    volume=1)                              annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-34,-54})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 flueGasValve_L1_2(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=3,
        A_cross=0.05,
        zeta=0.0002))
    annotation (Placement(transformation(extent={{-12,-92},{8,-80}})));
  ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2 flueGasCell1(
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry,
    m_flow_nom=0.5,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2)                 annotation (Placement(transformation(extent={{-42,-96},{-22,-76}})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 flueGasValve_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=3,
        A_cross=0.01,
        zeta=0.0005))
    annotation (Placement(transformation(extent={{-12,-60},{8,-48}})));
equation
  connect(source2.gas_a, flueGasJunction.portB) annotation (Line(
      points={{-54,14},{-26,14}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(source1.gas_a, flueGasJunction.portC) annotation (Line(
      points={{-54,36},{-16,36},{-16,24}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasJunction.portA, sink.gas_a) annotation (Line(
      points={{-6,14},{46,14}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(sink01.gas_a, flueGasJunction1.portB) annotation (Line(
      points={{46,-8},{-6,-8}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(sink02.gas_a, flueGasJunction1.portC) annotation (Line(
      points={{46,-30},{-16,-30},{-16,-18}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(source01.gas_a, flueGasJunction1.portA) annotation (Line(
      points={{-54,-8},{-26,-8}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(source3.gas_a, flueGasJunction3.portC) annotation (Line(
      points={{-52,-38},{-34,-38},{-34,-44}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasJunction2.portB, gasSink_pT1.gas_a) annotation (Line(
      points={{38,-54},{48,-54}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasJunction3.portA, flueGasValve_L1_1.inlet) annotation (Line(
      points={{-24,-54},{-12,-54}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasValve_L1_1.outlet, flueGasJunction2.portA) annotation (Line(
      points={{8,-54},{18,-54}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasValve_L1_2.inlet, flueGasCell1.outlet) annotation (Line(
      points={{-12,-86},{-22,-86}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasCell1.inlet, flueGasJunction3.portB) annotation (Line(
      points={{-42,-86},{-52,-86},{-52,-54},{-44,-54}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(flueGasValve_L1_2.outlet, flueGasJunction2.portC) annotation (Line(
      points={{8,-86},{28,-86},{28,-64}},
      color={84,58,36},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={  Text(
          extent={{-98,98},{100,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for gas junctions

______________________________________________________________________________________________
")}), experiment(StopTime=2));
end Test_Junction;
