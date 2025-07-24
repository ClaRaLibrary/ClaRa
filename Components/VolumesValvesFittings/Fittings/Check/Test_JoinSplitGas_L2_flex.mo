within ClaRa.Components.VolumesValvesFittings.Fittings.Check;
model Test_JoinSplitGas_L2_flex
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
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source2(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=3,
    T_const=303.15,
    xi_const={0,0,0,0,0,0,0.5,0,0})
                      annotation (Placement(transformation(extent={{-74,4},{-54,24}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source1(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=2,
    T_const=298.15,
    xi_const={0,0,0,0,0,1,0,0,0})
                      annotation (Placement(transformation(extent={{-74,26},{-54,46}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow sink(
    variable_m_flow=false,
    variable_T=false,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0},
    m_flow_const=-6)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,14})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{78,80},{98,100}})));

  ClaRa.Components.VolumesValvesFittings.Fittings.JoinGas_L2_flex joinGas_L2_flex(
    N_ports_in=3,
    m_flow_in_nom={1,2,3},
    xi_start={0,0,0,0,1,0,0,0,0}) annotation (Placement(transformation(extent={{-8,4},{12,24}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source3(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=1,
    xi_const={0,0,0,0,1,0,0,0,0},
    T_const=293.15)   annotation (Placement(transformation(extent={{-74,48},{
            -54,68}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source4(
    variable_m_flow=false,
    variable_T=false,
    T_const=303.15,
    xi_const={0,0,0,0,0,0,0.5,0,0},
    m_flow_const=-3)  annotation (Placement(transformation(extent={{66,-70},{46,
            -50}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source5(
    variable_m_flow=false,
    variable_T=false,
    T_const=298.15,
    xi_const={0,0,0,0,0,1,0,0,0},
    m_flow_const=-2)  annotation (Placement(transformation(extent={{66,-48},{46,
            -28}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow sink1(
    variable_m_flow=false,
    variable_T=false,
    xi_const={0.7,0.1,0.1,0.05,0.01,0.02,0.01,0.01,0},
    m_flow_const=6,
    T_const=298.15)    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-66,-60})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitGas_L2_flex splitGas_L2_flex(
    N_ports_out=3,
    m_flow_out_nom={3,2,1},
    xi_start={0,0,0,0,1,0,0,0,0}) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow source6(
    variable_m_flow=false,
    variable_T=false,
    xi_const={0,0,0,0,1,0,0,0,0},
    T_const=293.15,
    m_flow_const=-1)  annotation (Placement(transformation(extent={{66,-26},{46,
            -6}})));
equation
  connect(joinGas_L2_flex.outlet, sink.gas_a) annotation (Line(
      points={{12,14},{46,14},{46,14}},
      color={118,106,98},
      thickness=0.5));
  connect(source2.gas_a, joinGas_L2_flex.inlet[3]) annotation (Line(
      points={{-54,14},{-8,14},{-8,14.3333}},
      color={118,106,98},
      thickness=0.5));
  connect(source1.gas_a, joinGas_L2_flex.inlet[2]) annotation (Line(
      points={{-54,36},{-34,36},{-34,14},{-8,14}},
      color={118,106,98},
      thickness=0.5));
  connect(source3.gas_a, joinGas_L2_flex.inlet[1]) annotation (Line(
      points={{-54,58},{-34,58},{-34,14},{-8,14},{-8,14},{-8,14},{-8,13.6667},{-8,13.6667}},
      color={118,106,98},
      thickness=0.5));
  connect(sink1.gas_a, splitGas_L2_flex.inlet) annotation (Line(
      points={{-56,-60},{-33,-60},{-10,-60}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[2], source5.gas_a) annotation (Line(
      points={{10,-60},{26,-60},{26,-38},{46,-38}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[3], source6.gas_a) annotation (Line(
      points={{10,-59.6667},{10,-60},{10,-60},{10,-60},{10,-60},{26,-60},{26,-16},{46,-16}},
      color={118,106,98},
      thickness=0.5));
  connect(splitGas_L2_flex.outlet[1], source4.gas_a) annotation (Line(
      points={{10,-60.3333},{28,-60},{46,-60}},
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
>> Tester for gas junctions

______________________________________________________________________________________________
")}), experiment(StopTime=2));
end Test_JoinSplitGas_L2_flex;
