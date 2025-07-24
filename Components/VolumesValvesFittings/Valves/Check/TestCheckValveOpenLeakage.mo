within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model TestCheckValveOpenLeakage
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

 import SM = ClaRa.Basics.Functions.Stepsmoother;
Real a;
  inner SimCenter simCenter(useHomotopy=false, redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1)
    annotation (Placement(transformation(extent={{-92,-194},{-72,-174}})));

  Modelica.Blocks.Sources.Ramp pulse(
    height=2e5,
    duration=1,
    offset=2e5,
    startTime=30)
                annotation (Placement(transformation(extent={{40,12},{60,32}})));
  GenericValveVLE_L1 valve4(
    showExpertSummary=true,
    checkValve=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint,
    opening_leak_=0,
    openingInputIsActive=true) annotation (Placement(transformation(extent={{4,-64},{24,-52}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG6(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-54,-68},{-34,-48}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG7(variable_p=true) annotation (Placement(transformation(extent={{62,-68},{42,-48}})));
  Modelica.Blocks.Sources.Ramp pulse1(
    duration=10,
    offset=1,
    startTime=10,
    height=-1.1)
                annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
  GenericValveVLE_L1 valve1(
    showExpertSummary=true,
    checkValve=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint,
    openingInputIsActive=true,
    opening_leak_=0) annotation (Placement(transformation(extent={{4,-6},{24,-18}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG1(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-56,-22},{-36,-2}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG2(variable_p=true) annotation (Placement(transformation(extent={{60,-22},{40,-2}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-20,-46},{0,-26}})));
  Modelica.Blocks.Sources.Ramp pulse2(
    duration=10,
    offset=0,
    startTime=40,
    height=1.2) annotation (Placement(transformation(extent={{-86,-60},{-66,-40}})));
  GenericValveVLE_L1 valve2(
    showExpertSummary=true,
    openingInputIsActive=true,
    opening_leak_=1e-2,
    checkValve=false,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_FlowFunction (Delta_p_eps=1e4)) annotation (Placement(transformation(extent={{4,-156},{24,-144}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG3(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-54,-160},{-34,-140}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG4(variable_p=true) annotation (Placement(transformation(extent={{62,-160},{42,-140}})));
  Modelica.Blocks.Sources.Ramp pulse3(
    duration=10,
    offset=1,
    startTime=10,
    height=-1)  annotation (Placement(transformation(extent={{-86,-120},{-66,-100}})));
  GenericValveVLE_L1 valve3(
    showExpertSummary=true,
    opening_leak_=1e-2,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_FlowFunction (Delta_p_eps=1e4),
    checkValve=false,
    openingInputIsActive=true) annotation (Placement(transformation(extent={{4,-98},{24,-110}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG5(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-56,-114},{-36,-94}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG8(variable_p=true) annotation (Placement(transformation(extent={{60,-114},{40,-94}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{-20,-136},{0,-116}})));
  Modelica.Blocks.Sources.Ramp pulse4(
    duration=10,
    height=1,
    offset=0,
    startTime=40)
                annotation (Placement(transformation(extent={{-86,-152},{-66,-132}})));
equation
  SM(1000,0, valve3.summary.outline.Delta_p)=a;

  connect(pressureSink_XRG6.steam_a, valve4.inlet) annotation (Line(
      points={{-34,-58},{4,-58}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve4.outlet, pressureSink_XRG7.steam_a) annotation (Line(
      points={{24,-58},{42,-58}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pulse.y, pressureSink_XRG7.p) annotation (Line(
      points={{61,22},{90,22},{90,-52},{62,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_XRG1.steam_a,valve1. inlet) annotation (Line(
      points={{-36,-12},{4,-12}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve1.outlet,pressureSink_XRG2. steam_a) annotation (Line(
      points={{24,-12},{40,-12}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pulse.y, pressureSink_XRG2.p) annotation (Line(
      points={{61,22},{90,22},{90,-6},{60,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse1.y, add.u1) annotation (Line(
      points={{-67,-20},{-60,-20},{-60,-30},{-22,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, valve4.opening_in) annotation (Line(
      points={{1,-36},{14,-36},{14,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, valve1.opening_in) annotation (Line(
      points={{1,-36},{14,-36},{14,-21}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse2.y, add.u2) annotation (Line(
      points={{-65,-50},{-60,-50},{-60,-42},{-22,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_XRG3.steam_a,valve2. inlet) annotation (Line(
      points={{-34,-150},{4,-150}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve2.outlet,pressureSink_XRG4. steam_a) annotation (Line(
      points={{24,-150},{42,-150}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG5.steam_a,valve3. inlet) annotation (Line(
      points={{-36,-104},{4,-104}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve3.outlet,pressureSink_XRG8. steam_a) annotation (Line(
      points={{24,-104},{40,-104}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pulse3.y, add1.u1) annotation (Line(
      points={{-65,-110},{-58,-110},{-58,-120},{-22,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, valve2.opening_in) annotation (Line(
      points={{1,-126},{14,-126},{14,-141}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse4.y, add1.u2) annotation (Line(
      points={{-65,-142},{-58,-142},{-58,-132},{-22,-132}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, pressureSink_XRG8.p) annotation (Line(
      points={{61,22},{90,22},{90,-98},{60,-98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, pressureSink_XRG4.p) annotation (Line(
      points={{61,22},{90,22},{90,-144},{62,-144}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, valve3.opening_in) annotation (Line(
      points={{1,-126},{14,-126},{14,-113}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,100}}),
            graphics={Text(
          extent={{-98,90},{100,32}},
          lineColor={0,128,0},
          fontSize=10,
          horizontalAlignment=TextAlignment.Left,
          textString="_______________________________________________________________________
PURPOSE:
Show checkvalve with leakage functionalitiy
_______________________________________________________________________
LOOK AT:

Mass flow rates, Delta_p and Enthalpies 
_______________________________________________________________________
")}),
    experiment(StopTime=60, __Dymola_NumberOfIntervals=20000),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end TestCheckValveOpenLeakage;
