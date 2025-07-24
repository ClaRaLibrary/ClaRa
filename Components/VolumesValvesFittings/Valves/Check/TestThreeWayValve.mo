within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model TestThreeWayValve

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
  ThreeWayValveVLE_L1 threeWayValve_VLE_L1_1(splitRatio_input=true) annotation (Placement(transformation(extent={{-10,-14},{10,4}})));
  inner SimCenter simCenter(showExpertSummary=true) annotation (Placement(transformation(extent={{-82,-70},{-62,-50}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(p_const=1e5) annotation (Placement(transformation(extent={{60,-14},{40,6}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_ph1(p_const=1e5) annotation (Placement(transformation(extent={{60,-44},{40,-24}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(m_flow_const=10) annotation (Placement(transformation(extent={{-68,-14},{-48,6}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=1,
    offset=0,
    startTime=1)
    annotation (Placement(transformation(extent={{-38,12},{-18,32}})));
equation
  connect(pressureSink_ph1.steam_a, threeWayValve_VLE_L1_1.outlet2) annotation (
     Line(
      points={{40,-34},{0,-34},{0,-14}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_ph.steam_a, threeWayValve_VLE_L1_1.outlet1) annotation (
      Line(
      points={{40,-4},{10,-4}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSource_h.steam_a, threeWayValve_VLE_L1_1.inlet) annotation (
      Line(
      points={{-48,-4},{-10,-4}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, threeWayValve_VLE_L1_1.splitRatio_external) annotation (Line(
      points={{-17,22},{0,22},{0,5}},
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
end TestThreeWayValve;
