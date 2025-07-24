within ClaRa.Components.Adapters.Check;
model RowOfScalar2VectorHeatPorts
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
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe1(
    length=20,
    h_start=ones(pipe1.geo.N_cv)*1e5,
    m_flow_nom=5,
    Delta_p_nom=5e4,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_start=linspace(
        50,
        49.5,
        pipe1.N_cv)*1e5,
    showExpertSummary=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=10000),
    N_cv=10,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0) annotation (Placement(transformation(extent={{-32,-67},{-4,-57}})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe2(
    length=20,
    N_cv=10,
    m_flow_nom=5,
    Delta_p_nom=5e4,
    p_start=linspace(
        49.5,
        49,
        pipe2.geo.N_cv)*1e5,
    h_start=ones(pipe2.N_cv)*1e5,
    showExpertSummary=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=10000),
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0) annotation (Placement(transformation(extent={{13,-67},{39,-57}})));

  BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT(p_const=4900000) annotation (Placement(transformation(extent={{78,-72},{60,-52}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall_1(
    N_ax=pipe1.N_cv,
    diameter_o=pipe1.diameter_i + 0.005,
    diameter_i=pipe1.diameter_i,
    length=pipe1.length,
    N_tubes=pipe1.N_tubes,
    redeclare model Material = TILMedia.Solid.Types.TILMedia_Steel,
    Delta_x=pipe1.Delta_x,
    stateLocation=2,
    T_start=ones(thinWall_1.N_ax)*(528 + 273.15),
    initOption=213) annotation (Placement(transformation(extent={{-28,-32},{-8,-24}})));
  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall_2(
    N_ax=pipe2.N_cv,
    diameter_o=pipe2.diameter_i + 0.004,
    diameter_i=pipe2.diameter_i,
    length=pipe2.length,
    N_tubes=pipe2.N_tubes,
    redeclare model Material = TILMedia.Solid.Types.TILMedia_Steel,
    Delta_x=pipe2.Delta_x,
    stateLocation=2,
    T_start=ones(thinWall_2.N_ax)*(528 + 273.15),
    initOption=213) annotation (Placement(transformation(extent={{16,-34},{36,-26}})));
  Scalar2VectorHeatPort scalar2VectorHeatPort(
    length=pipe1.length,
    N=pipe1.N_cv,
    Delta_x=pipe1.Delta_x,
    equalityMode="Equal Heat Flow Rates") annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-18,-8})));
  Scalar2VectorHeatPort scalar2VectorHeatPort1(
    length=pipe2.length,
    N=pipe2.N_cv,
    Delta_x=pipe2.Delta_x,
    equalityMode="Equal Heat Flow Rates") annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={26,-8})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(h_const=35e5, m_flow_const=0.3,
    showData=true)                                                                          annotation (Placement(transformation(extent={{-68,-72},{-48,-52}})));
  Visualisation.Quadruple quadruple
    annotation (Placement(transformation(extent={{-70,-96},{-50,-86}})));
  Visualisation.DynDisplay dynDisplay(varname="T outlet pipe1", x1=pipe1.summary.fluid.T[
        pipe1.N_cv] - 273.15)
    annotation (Placement(transformation(extent={{-30,-86},{-4,-78}})));
  Visualisation.DynDisplay dynDisplay1(varname="T inlet pipe2", x1=pipe2.summary.fluid.T[
        1] - 273.15)
    annotation (Placement(transformation(extent={{12,-86},{38,-78}})));
  Visualisation.DynDisplay dynDisplay2(varname="T[N] thinWall 1 ", x1=
        thinWall_1.T[pipe1.N_cv] - 273.15)
    annotation (Placement(transformation(extent={{-18,-52},{2,-44}})));
  Visualisation.DynDisplay dynDisplay3(varname="T[1] thinWall 2", x1=thinWall_2.T[
        1] - 273.15)
    annotation (Placement(transformation(extent={{6,-52},{26,-44}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T=818.15)
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={26,32})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=813.15)
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-18,32})));
  Visualisation.DynDisplay dynDisplay4(x1=scalar2VectorHeatPort.heatScalar.T -
        273.15, varname="T scalar 1 ")
    annotation (Placement(transformation(extent={{-40,0},{-20,8}})));
  Visualisation.DynDisplay dynDisplay5(x1=scalar2VectorHeatPort1.heatScalar.T
         - 273.15, varname="T scalar 2")
    annotation (Placement(transformation(extent={{32,0},{52,8}})));
  Visualisation.DynDisplay dynDisplay6(varname="T[N] thinWall 2", x1=thinWall_2.T[
        pipe2.N_cv] - 273.15)
    annotation (Placement(transformation(extent={{30,-52},{50,-44}})));
  Visualisation.DynDisplay dynDisplay7(varname="T[1] thinWall 1 ", x1=
        thinWall_1.T[1] - 273.15)
    annotation (Placement(transformation(extent={{-40,-52},{-20,-44}})));
equation
  connect(pipe1.outlet, pipe2.inlet) annotation (Line(
      points={{-4,-62},{13,-62}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe2.outlet, pressureSink_pT.steam_a) annotation (Line(
      points={{39,-62},{60,-62}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort.heatVector, thinWall_1.outerPhase) annotation (
      Line(
      points={{-18,-18},{-18,-24}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall_1.innerPhase, pipe1.heat) annotation (Line(
      points={{-18,-32},{-18,-58}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(scalar2VectorHeatPort1.heatVector, thinWall_2.outerPhase) annotation (
     Line(
      points={{26,-18},{26,-26}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(thinWall_2.innerPhase, pipe2.heat) annotation (Line(
      points={{26,-34},{26,-58}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a, pipe1.inlet) annotation (Line(
      points={{-48,-62},{-32,-62}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.eye, quadruple.eye) annotation (Line(
      points={{-48,-70},{-40,-70},{-40,-91},{-70,-91}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(fixedTemperature1.port, scalar2VectorHeatPort.heatScalar) annotation (
     Line(
      points={{-18,22},{-18,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature2.port, scalar2VectorHeatPort1.heatScalar)
    annotation (Line(
      points={{26,22},{26,2}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={  Text(
          extent={{-96,100},{102,60}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:

______________________________________________________________________________________________
"),                                               Text(
          extent={{-96,60},{68,46}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-96,74},{104,56}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}),
    experiment(StopTime=1500),
    __Dymola_experimentSetupOutput);
end RowOfScalar2VectorHeatPorts;
