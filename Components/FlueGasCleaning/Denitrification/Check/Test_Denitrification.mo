within ClaRa.Components.FlueGasCleaning.Denitrification.Check;
model Test_Denitrification
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
  inner SimCenter simCenter(redeclare TILMedia.Gas.Types.FlueGasTILMedia flueGasModel)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Denitrification_L2 deNOx(
    useHomotopy=simCenter.useHomotopy,
    use_dynamicMassbalance=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Adiabat_L2,
    redeclare model SeparationModel = ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.Denitrification_L2 (separationRate=0.9))
                                                                                                                 annotation (Placement(transformation(extent={{6,0},{26,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow idealGasFlowSource_XRG2(
    m_flow_const=10,
    variable_m_flow=true,
    variable_T=true,
    xi_const={0.01,0.01,0.73,0.01,0.065,0.036,0.01,0.13,0.0})
                                                 annotation (Placement(transformation(extent={{-38,0},{-18,20}})));
  Modelica.Blocks.Sources.Ramp massFlowRate2(
    offset=1e-3,
    startTime=100e3,
    height=1e-3,
    duration=500)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-76,28})));
  Modelica.Blocks.Sources.Ramp Temperature2(
    duration=1,
    height=25,
    offset=273.15 + 200,
    startTime=150000)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-76,-4})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi idealGasPressureSink_XRG1(p_const=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,10})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperatureTop1(T=293.15)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-76,58})));
equation

  connect(massFlowRate2.y, idealGasFlowSource_XRG2.m_flow) annotation (Line(
      points={{-65,28},{-56,28},{-56,16},{-38,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temperature2.y,idealGasFlowSource_XRG2. T)
                                             annotation (Line(
      points={{-65,-4},{-56,-4},{-56,10},{-38,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGasFlowSource_XRG2.gas_a, deNOx.inlet) annotation (Line(
      points={{-18,10},{6,10}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(deNOx.outlet, idealGasPressureSink_XRG1.gas_a) annotation (Line(
      points={{26,10},{72,10}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fixedTemperatureTop1.port, deNOx.heat) annotation (Line(
      points={{-66,58},{16,58},{16,20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-40},{100,100}}),
                      graphics={Text(
          extent={{-98,94},{-24,84}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="________________________________________________________________
PURPOSE:
>>Tester for the Denitrificationl component")}),
    experiment(StopTime=200000),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}})));
end Test_Denitrification;
