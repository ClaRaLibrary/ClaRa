within ClaRa.Components.Sensors.Check;
model TestGasSensors
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2017, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  SensorGas_L1_xi SensorCO2(component=3) annotation (Placement(transformation(extent={{-38,-90},{-18,-70}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT(                  variable_p=true,
    variable_xi=false,
    xi_const={0,0,0.4,0,0.4,0.2,0,0,0})                                             annotation (Placement(transformation(extent={{-68,-100},{-48,-80}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T(m_flow_const=-10) annotation (Placement(transformation(extent={{98,-100},{78,-80}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=0.5,
    offset=100000,
    amplitude=20000,
    phase=0.017453292519943)
    annotation (Placement(transformation(extent={{-96,-94},{-76,-74}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 flueGasCell annotation (Placement(transformation(extent={{50,-100},{70,-80}})));
  SensorGas_L1_xi SensorN2(component=5) annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  SensorGas_L1_xi SensorO2(component=6) annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  SensorGas_L1_xi_i Sensor1 annotation (Placement(transformation(extent={{-10,-44},{10,-24}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT1(
                                                 variable_p=true, variable_xi=false,
    xi_const={0,0,0,0,0.8,0.2,0,0,0})                                                annotation (Placement(transformation(extent={{-46,-54},{-26,-34}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T1(
                                                           m_flow_const=-10) annotation (Placement(transformation(extent={{80,-54},{60,-34}})));
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=0.5,
    offset=100000,
    amplitude=20000,
    phase=0.017453292519943)
    annotation (Placement(transformation(extent={{-82,-48},{-62,-28}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 flueGasCell1
                                                            annotation (Placement(transformation(extent={{24,-54},{44,-34}})));
  SensorGas_L1_m_flow mass_flow annotation (Placement(transformation(extent={{-38,-2},{-18,18}})));
  BoundaryConditions.BoundaryGas_pTxi gasSink_pT2(
                                                 variable_p=true,
    variable_xi=false,
    xi_const={0,0,0,0,0.8,0.2,0,0,0})                                               annotation (Placement(transformation(extent={{-70,-12},{-50,8}})));
  BoundaryConditions.BoundaryGas_Txim_flow gasFlowSource_T2(
                                                           m_flow_const=-10, variable_xi=false) annotation (Placement(transformation(extent={{98,-12},{78,8}})));
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=0.5,
    offset=100000,
    amplitude=20000,
    phase=0.017453292519943)
    annotation (Placement(transformation(extent={{-96,-6},{-76,14}})));
  Basics.ControlVolumes.GasVolumes.VolumeGas_L2 flueGasCell2
                                                            annotation (Placement(transformation(extent={{50,-12},{70,8}})));
  SensorGas_L1_T temperature annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  SensorGas_L1_p pressure annotation (Placement(transformation(extent={{16,-2},{36,18}})));
equation
  connect(sine.y, gasSink_pT.p) annotation (Line(
      points={{-75,-84},{-68,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flueGasCell.outlet, gasFlowSource_T.gas_a) annotation (Line(
      points={{70,-90},{78,-90}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(SensorO2.inlet, SensorN2.outlet) annotation (Line(
      points={{20,-90},{10,-90}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SensorN2.inlet, SensorCO2.outlet) annotation (Line(
      points={{-10,-90},{-18,-90}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sine1.y, gasSink_pT1.p) annotation (Line(
      points={{-61,-38},{-46,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flueGasCell1.outlet, gasFlowSource_T1.gas_a) annotation (Line(
      points={{44,-44},{60,-44}},
      color={84,58,36},
      smooth=Smooth.None));
  connect(Sensor1.outlet, flueGasCell1.inlet) annotation (Line(
      points={{10,-44},{24,-44}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sine2.y, gasSink_pT2.p) annotation (Line(
      points={{-75,4},{-70,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flueGasCell2.outlet, gasFlowSource_T2.gas_a) annotation (Line(
      points={{70,-2},{78,-2}},
      color={118,106,98},
      thickness=0.5));
  connect(gasSink_pT2.gas_a, mass_flow.inlet) annotation (Line(
      points={{-50,-2},{-50,-2},{-38,-2}},
      color={118,106,98},
      thickness=0.5));
  connect(gasSink_pT1.gas_a, Sensor1.inlet) annotation (Line(
      points={{-26,-44},{-18,-44},{-10,-44}},
      color={118,106,98},
      thickness=0.5));
  connect(gasSink_pT.gas_a, SensorCO2.inlet) annotation (Line(
      points={{-48,-90},{-43,-90},{-38,-90}},
      color={118,106,98},
      thickness=0.5));
  connect(SensorO2.outlet, flueGasCell.inlet) annotation (Line(
      points={{40,-90},{45,-90},{50,-90}},
      color={118,106,98},
      thickness=0.5));
  connect(mass_flow.outlet, temperature.inlet) annotation (Line(
      points={{-18,-2},{-14,-2},{-10,-2}},
      color={118,106,98},
      thickness=0.5));
  connect(temperature.outlet, flueGasCell2.inlet) annotation (Line(
      points={{10,-2},{50,-2}},
      color={118,106,98},
      thickness=0.5));
  connect(pressure.port, flueGasCell2.inlet) annotation (Line(
      points={{26,-2},{26,-2},{50,-2}},
      color={118,106,98},
      thickness=0.5));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-140},{100,100}},
          preserveAspectRatio=false),
            graphics={            Text(
          extent={{-96,94},{102,54}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="______________________________________________________________________________________________
PURPOSE:

______________________________________________________________________________________________
"),                    Text(
          extent={{-112,100},{88,80}},
          lineColor={0,128,0},
          fontSize=31,
          textString="TESTED -- YYYY-MM-DD //XX"),Text(
          extent={{-96,52},{68,38}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
"),                   Text(
          extent={{-96,64},{120,52}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)));
end TestGasSensors;
