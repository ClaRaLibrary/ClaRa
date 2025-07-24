within ClaRa.Components.Adapters.Check;
model TestScalar2VectorHeatPort
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
 Real Q_flow_sum=-sum(scalar2VectorHeatPort.heatVector.Q_flow);
  BoundaryConditions.PrescribedHeatFlowScalar prescribedHeatFlowScalar
    annotation (Placement(transformation(extent={{-64,10},{-44,30}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    diameter_o=0.05,
    diameter_i=0.04,
    length=1,
    N_ax=5,
    Delta_x={0.5,0.25,0.15,0.05,0.05},
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,20})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 thickWall(
    diameter_o=0.5,
    diameter_i=0.4,
    length=thinWall.length,
    initOption=1) annotation (Placement(transformation(extent={{-36,10},{-16,30}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=30,
    duration=1,
    offset=30,
    startTime=1)
    annotation (Placement(transformation(extent={{-92,10},{-72,30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[thinWall.N_ax](
     T={573.15,673.15,773.15,873.15,973.15})
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,20})));
  Scalar2VectorHeatPort scalar2VectorHeatPort(
    length=thinWall.length,
    N=thinWall.N_ax,
    Delta_x=thinWall.Delta_x) annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  BoundaryConditions.PrescribedHeatFlowScalar prescribedHeatFlowScalar1
    annotation (Placement(transformation(extent={{-64,-32},{-44,-12}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall1(
    diameter_o=0.05,
    diameter_i=0.04,
    length=1,
    N_ax=5,
    Delta_x={0.5,0.25,0.15,0.05,0.05},
    initOption=213) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-22})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 thickWall1(
    diameter_o=0.5,
    diameter_i=0.4,
    length=thinWall.length,
    initOption=1) annotation (Placement(transformation(extent={{-36,-30},{-16,-10}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=30,
    duration=1,
    offset=30,
    startTime=1)
    annotation (Placement(transformation(extent={{-92,-32},{-72,-12}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=573.15)
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,-22})));
  Scalar2VectorHeatPort scalar2VectorHeatPort1(
    length=thinWall.length,
    N=thinWall.N_ax,
    Delta_x=thinWall.Delta_x) annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
  Scalar2VectorHeatPort scalar2VectorHeatPort2(
    length=thinWall.length,
    N=thinWall.N_ax,
    Delta_x=thinWall.Delta_x) annotation (Placement(transformation(extent={{70,-32},{50,-12}})));
  BoundaryConditions.PrescribedHeatFlowScalar prescribedHeatFlowScalar2
    annotation (Placement(transformation(extent={{-64,-74},{-44,-54}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall2(
    diameter_o=0.05,
    diameter_i=0.04,
    length=1,
    N_ax=5,
    Delta_x={0.5,0.25,0.15,0.05,0.05},
    initOption=213) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,-64})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 thickWall2(
    diameter_o=0.5,
    diameter_i=0.4,
    length=thinWall.length,
    initOption=1) annotation (Placement(transformation(extent={{-36,-72},{-16,-52}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=30,
    duration=1,
    offset=30,
    startTime=1)
    annotation (Placement(transformation(extent={{-92,-74},{-72,-54}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperature2(Q_flow=-25)
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,-64})));
  Scalar2VectorHeatPort scalar2VectorHeatPort3(
    length=thinWall.length,
    N=thinWall.N_ax,
    Delta_x=thinWall.Delta_x) annotation (Placement(transformation(extent={{-10,-74},{10,-54}})));
  Scalar2VectorHeatPort scalar2VectorHeatPort4(
    length=thinWall.length,
    N=thinWall.N_ax,
    Delta_x=thinWall.Delta_x) annotation (Placement(transformation(extent={{70,-74},{50,-54}})));
equation
  connect(thickWall.outerPhase, prescribedHeatFlowScalar.port) annotation (Line(
      points={{-26,30.1333},{-39.7,30.1333},{-39.7,20},{-44,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ramp.y, prescribedHeatFlowScalar.Q_flow) annotation (Line(
      points={{-71,20},{-64,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thickWall.innerPhase, scalar2VectorHeatPort.heatScalar) annotation (
      Line(
      points={{-26.2,10.4},{-14,10.4},{-14,20},{-10,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatVector, thinWall.outerPhase) annotation (
      Line(
      points={{10,20},{18,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thickWall1.outerPhase, prescribedHeatFlowScalar1.port)
                                                               annotation (Line(
      points={{-26,-9.86667},{-39.7,-9.86667},{-39.7,-22},{-44,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ramp1.y, prescribedHeatFlowScalar1.Q_flow)
                                                   annotation (Line(
      points={{-71,-22},{-64,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thickWall1.innerPhase, scalar2VectorHeatPort1.heatScalar)
                                                                  annotation (
      Line(
      points={{-26.2,-29.6},{-26.2,-30},{-14,-30},{-14,-22},{-10,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort1.heatVector, thinWall1.outerPhase)
                                                                 annotation (
      Line(
      points={{10,-22},{18,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort2.heatVector, thinWall1.innerPhase) annotation (
      Line(
      points={{50,-22},{38,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thickWall2.outerPhase, prescribedHeatFlowScalar2.port)
                                                               annotation (Line(
      points={{-26,-51.8667},{-34,-51.8667},{-34,-52},{-40,-52},{-40,-64},{-44,-64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ramp2.y, prescribedHeatFlowScalar2.Q_flow)
                                                   annotation (Line(
      points={{-71,-64},{-64,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thickWall2.innerPhase, scalar2VectorHeatPort3.heatScalar)
                                                                  annotation (
      Line(
      points={{-26.2,-71.6},{-26.2,-72},{-14,-72},{-14,-64},{-10,-64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort3.heatVector, thinWall2.outerPhase)
                                                                 annotation (
      Line(
      points={{10,-64},{18,-64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort4.heatVector, thinWall2.innerPhase) annotation (
      Line(
      points={{50,-64},{38,-64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort4.heatScalar, fixedTemperature2.port)
    annotation (Line(
      points={{70,-64},{76,-64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature1.port, scalar2VectorHeatPort2.heatScalar)
    annotation (Line(
      points={{76,-22},{70,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, thinWall.innerPhase) annotation (Line(
      points={{76,20},{38,20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics={  Text(
          extent={{-94,98},{104,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:

______________________________________________________________________________________________
"),                                               Text(
          extent={{-94,58},{70,44}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-94,72},{106,54}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}), experiment(StopTime=10));
end TestScalar2VectorHeatPort;
