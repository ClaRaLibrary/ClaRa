within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model TestThreeWayGasValve

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
  inner SimCenter simCenter(showExpertSummary=true) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=1,
    height=1,
    offset=0)
    annotation (Placement(transformation(extent={{-40,22},{-20,42}})));
  ThreeWayValveGas_L1 threeWayValve_Gas_L1(splitRatio_input=true, pressureLoss(effectiveFlowArea1=0.5)) annotation (Placement(transformation(extent={{-10,-10},{10,8}})));
  BoundaryConditions.BoundaryGas_pTxi pressureSink_ph2(
                                                      p_const=1e5) annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  BoundaryConditions.BoundaryGas_pTxi pressureSink_ph3(p_const=1.005e5)
                                                                    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  BoundaryConditions.BoundaryGas_pTxi      massFlowSource_h1(p_const(displayUnit="bar") = 150000)
                                                                             annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
equation
  connect(massFlowSource_h1.gas_a, threeWayValve_Gas_L1.inlet) annotation (Line(
      points={{-48,0},{-10,0}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(threeWayValve_Gas_L1.outlet1, pressureSink_ph2.gas_a) annotation (Line(
      points={{10,0},{40,0}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(threeWayValve_Gas_L1.outlet2, pressureSink_ph3.gas_a) annotation (Line(
      points={{0,-10},{0,-30},{40,-30}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, threeWayValve_Gas_L1.splitRatio_external) annotation (Line(
      points={{-19,32},{-8,32},{-8,32},{0,32},{0,9}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={    Text(
          extent={{-94,98},{104,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for three way gas valve

______________________________________________________________________________________________
")}),
    experiment(StopTime=3),
    __Dymola_experimentSetupOutput);
end TestThreeWayGasValve;
