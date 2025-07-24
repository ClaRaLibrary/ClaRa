within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model TestThreeWayValves

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
  ThreeWayValveVLE_L1_simple threeWayValve_VLE_L1_1(splitRatio_input=true) annotation (Placement(transformation(extent={{-6,12},{14,-6}})));
  ThreeWayValveVLE_L2 threeWayValveVLE_L2_1(splitRatio_input=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticFrictionNominalPointSymetric_TWV)
    annotation (Placement(transformation(extent={{-10,-9},{10,9}},
        rotation=0,
        origin={4,-59})));
  inner SimCenter simCenter(showExpertSummary=true) annotation (Placement(transformation(extent={{-96,-96},{-76,-76}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph annotation (Placement(transformation(extent={{64,-6},{44,14}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1 annotation (Placement(transformation(extent={{62,20},{42,40}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph2 annotation (Placement(transformation(extent={{64,-68},{44,-48}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph3 annotation (Placement(transformation(extent={{64,-94},{44,-74}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(m_flow_const=10) annotation (Placement(transformation(extent={{-64,-8},{-44,12}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h1(m_flow_const=10) annotation (Placement(transformation(extent={{-62,-68},{-42,-48}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=1,
    offset=0,
    startTime=1)
    annotation (Placement(transformation(extent={{-46,-36},{-26,-16}})));
equation
  connect(pressureSink_ph1.steam_a, threeWayValve_VLE_L1_1.outlet2) annotation (
     Line(
      points={{42,30},{4,30},{4,12}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a, threeWayValve_VLE_L1_1.outlet1) annotation (
      Line(
      points={{44,4},{30,4},{30,2},{14,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(threeWayValveVLE_L2_1.outlet1, pressureSink_ph2.steam_a) annotation (
      Line(
      points={{14,-58},{44,-58}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph3.steam_a, threeWayValveVLE_L2_1.outlet2) annotation (
      Line(
      points={{44,-84},{4,-84},{4,-68}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a, threeWayValve_VLE_L1_1.inlet) annotation (
      Line(
      points={{-44,2},{-6,2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h1.steam_a, threeWayValveVLE_L2_1.inlet) annotation (
      Line(
      points={{-42,-58},{-6,-58}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, threeWayValve_VLE_L1_1.splitRatio_external) annotation (Line(
      points={{-25,-26},{4,-26},{4,-7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, threeWayValveVLE_L2_1.splitRatio_external) annotation (Line(
      points={{-25,-26},{4,-26},{4,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={    Text(
          extent={{-94,98},{104,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for three way VLE valve

______________________________________________________________________________________________
")}),
    experiment(StopTime=3),
    __Dymola_experimentSetupOutput);
end TestThreeWayValves;
