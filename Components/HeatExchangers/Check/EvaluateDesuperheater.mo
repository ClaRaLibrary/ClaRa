within ClaRa.Components.HeatExchangers.Check;
model EvaluateDesuperheater "An evaluation scenario for the ShellAndTube_HEX_1 featuring part load. Comparing against an EBSILON model"
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
  import Modelica.Utilities.Files.loadResource;

  Real Q_flow1=-desuperheater_1.summary.outline.Q_flow;
  Real Q_flow2=-desuperheater_2.summary.outline.Q_flow;
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveCompressible(openingInputIsActive=false, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                                        m_flow_nom=if ((416) > 0) then (416) else 10, Delta_p_nom=if ((2000) <> 0) then (2000) else 1000)) annotation (Placement(transformation(extent={{10,-30},{-10,-18}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    variable_m_flow=true,
    h_const=1161.8e3,
    variable_h=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={32,30})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink(
    h_const=3000e3,
    variable_p=true,
    p_const=32310000) annotation (Placement(transformation(extent={{-42,-34},{-22,-14}})));
  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable MeasurementData(
    tableOnFile=true,
    tableName="S",
    columns={2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,
        27,28,29,30,31,32,33,34,35},
    fileName=loadResource("modelica://ClaRa/Resources/TableBase/Desuperheater.mat"))
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Discrete.Sampler sampler[34](each samplePeriod=300)
    annotation (Placement(transformation(extent={{-72,40},{-52,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=-(sampler[24].y -
        sampler[18].y))
    annotation (Placement(transformation(extent={{-98,-40},{-78,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource1(
    h_const=2800e3,
    variable_m_flow=true,
    variable_h=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={64,12})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveCompressible1(openingInputIsActive=false, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                                         m_flow_nom=if ((416) > 0) then (416) else 10, Delta_p_nom=if ((1000) <> 0) then (1000) else 1000)) annotation (Placement(transformation(extent={{10,-4},{-10,8}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink1(
    h_const=2800e3,
    variable_p=true,
    p_const=3000000) annotation (Placement(transformation(extent={{-42,-8},{-22,12}})));
  HEXvle2vle_L3_1ph_BU_ntu desuperheater_1(
    length=15.2,
    height=3,
    width=3,
    tubeOrientation=0,
    diameter_i=0.017,
    diameter_o=0.019,
    N_tubes=217,
    Q_flow_nom=1e6,
    redeclare model WallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum,
    p_start_tubes=3200000,
    showExpertSummary=true,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100000),
    m_nom_tubes=416,
    h_start_tubes=1000e3,
    h_nom_tubes=1000e3,
    p_nom_shell=3e5,
    h_start_shell=3300e3,
    p_start_shell=2.5e5,
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (
          PL_alpha=[0.01,0.5025; 0.4,0.6; 0.6,0.8; 1,1], alpha_nom=62.5),
    redeclare model HeatExchangerType = Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow,
    initOptionShell=0,
    initOptionTubes=0,
    wall(stateLocation=2))
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={32,2})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveCompressible2(
    openingInputIsActive=false,
    checkValve=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (m_flow_nom=if ((416) > 0) then (416) else 10, Delta_p_nom=if ((2000) <> 0) then (2000) else 1000)) annotation (Placement(transformation(extent={{10,-94},{-10,-82}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource2(
    variable_m_flow=true,
    h_const=1161.8e3,
    variable_h=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={64,-34})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink2(
    h_const=3000e3,
    variable_p=true,
    p_const=32310000) annotation (Placement(transformation(extent={{-42,-98},{-22,-78}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource3(
    h_const=2800e3,
    variable_m_flow=true,
    variable_h=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={68,-62})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveCompressible3(openingInputIsActive=false, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                                                         m_flow_nom=if ((416) > 0) then (416) else 10, Delta_p_nom=if ((1000) <> 0) then (1000) else 1000)) annotation (Placement(transformation(extent={{10,-68},{-10,-56}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink3(
    h_const=2800e3,
    variable_p=true,
    p_const=3000000) annotation (Placement(transformation(extent={{-42,-72},{-22,-52}})));
  HEXvle2vle_L3_1ph_kA desuperheater_2(
    h_start_tubes=3e6,
    h_start_shell=2990e3,
    Q_flow_nom=1e6,
    redeclare model WallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum,
    kA_nom=98365.519,
    CL_kA_mflow=[0.01,0.5025; 0.4,0.6; 0.6,0.8; 1,1],
    mass_struc=1,
    showExpertSummary=true,
    h_nom_shell=3500e3,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100000),
    m_flow_nom_tubes=416,
    m_flow_nom_shell=21.627,
    redeclare model HeatExchangerType =
        ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow,
    p_nom_shell=3500000,
    p_start_shell=250000,
    p_nom_tubes=40000000,
    p_start_tubes=32000000,
    initOptionShell=0,
    initOptionWall=0,
    initOptionTubes=0) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={32,-62})));

equation
  connect(valveCompressible.outlet, pressureSink.steam_a) annotation (Line(
      points={{-10,-24},{-10,-24},{-22,-24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(MeasurementData.y, sampler.u) annotation (Line(
      points={{-79,50},{-74,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[3].y, massFlowSource.m_flow) annotation (Line(
      points={{-51,50},{26,50},{26,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[4].y, massFlowSource.h) annotation (Line(
      points={{-51,50},{32,50},{32,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[7].y, pressureSink.p) annotation (Line(
      points={{-51,50},{-48,50},{-48,-18},{-42,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink1.steam_a, valveCompressible1.outlet) annotation (Line(
      points={{-22,2},{-10,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource1.m_flow, sampler[15].y) annotation (Line(
      points={{58,24},{58,50},{-51,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[16].y, massFlowSource1.h) annotation (Line(
      points={{-51,50},{64,50},{64,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[19].y, pressureSink1.p) annotation (Line(
      points={{-51,50},{-42,50},{-42,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource1.steam_a, desuperheater_1.In1) annotation (Line(
      points={{64,2},{41.8,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource.steam_a, desuperheater_1.In2) annotation (Line(
      points={{32,20},{32,12},{26,12}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valveCompressible.inlet, desuperheater_1.Out2) annotation (Line(
      points={{10,-24},{38,-24},{38,12}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(desuperheater_1.Out1, valveCompressible1.inlet) annotation (Line(
      points={{22,2},{10,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valveCompressible2.outlet, pressureSink2.steam_a) annotation (Line(
      points={{-10,-88},{-10,-88},{-22,-88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(sampler[3].y, massFlowSource2.m_flow) annotation (Line(
      points={{-51,50},{76,50},{76,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[4].y, massFlowSource2.h) annotation (Line(
      points={{-51,50},{76,50},{76,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[7].y, pressureSink2.p) annotation (Line(
      points={{-51,50},{-48,50},{-48,-82},{-42,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink3.steam_a, valveCompressible3.outlet) annotation (Line(
      points={{-22,-62},{-10,-62}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource3.m_flow, sampler[15].y) annotation (Line(
      points={{80,-56},{80,50},{-51,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[16].y, massFlowSource3.h) annotation (Line(
      points={{-51,50},{80,50},{80,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler[19].y, pressureSink3.p) annotation (Line(
      points={{-51,50},{-42,50},{-42,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource3.steam_a, desuperheater_2.In1) annotation (Line(
      points={{58,-62},{41.8,-62}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource2.steam_a, desuperheater_2.In2) annotation (Line(
      points={{54,-34},{26,-34},{26,-52}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valveCompressible2.inlet, desuperheater_2.Out2) annotation (Line(
      points={{10,-88},{38,-88},{38,-52}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(desuperheater_2.Out1, valveCompressible3.inlet) annotation (Line(
      points={{22,-62},{10,-62}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,180}},
          preserveAspectRatio=false),                         graphics={
                                                     Text(
          extent={{-100,176},{88,70}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="
___________________________________________________________________________________________         
PURPOSE:
>  Compare two different HEX model approaches with an Corresponding EBSILON model
___________________________________________________________________________________________
NOTE: 
> The model of desuperheater_2 assumes that the product of heat transfer area and heat transfer coefficient US
   depends solely on the mass flow rate via a characteristic line. The model of desuperheater_1 is capable to
   take  variaous influence variables into account, depending on the heat transfer model on both shell and tube
   side. However, in this example the shell side heat transfer model is set to be ideal while the tube side HT
   is based on a simple characteristic line. With these settings both models behave similar.
___________________________________________________________________________________________  
LOOK AT: 
> compare the outlet enthalpy and temperature  of the tube side (sampler[10].y and sampler[8].y, respectively)
   with the corresponding values from the HEX model summaries.
> compare the outlet enthalpy and temperature  of the shell side (sampler[22].y and sampler[20].y, respectively)
   with the corresponding values from the HEX model summaries. 
> compare the transferred heat flow rate (sampler[25].y vs. Q_flow1 vs Q_flow2)  
___________________________________________________________________________________________  
")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            true), graphics),
    experiment(StopTime=30000),
    __Dymola_experimentSetupOutput);
end EvaluateDesuperheater;
