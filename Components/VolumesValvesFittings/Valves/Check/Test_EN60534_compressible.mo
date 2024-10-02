within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model Test_EN60534_compressible

//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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
  inner SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_GERGCO2 fluid1)
                            annotation (Placement(transformation(extent={{-101,-100},{-59,-80}})));
  GenericValveVLE_L1 valveEN_60534_compressible(showExpertSummary=true, redeclare model PressureLoss =
        Fundamentals.Quadratic_EN60534_compressible)                                                                                                annotation (Placement(transformation(extent={{-10,44},{10,56}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG10(p_const=10e5, h_const=3000e3)
                                                                                                      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG11(variable_p=true, h_const=3500e3)
                                                                                           annotation (Placement(transformation(extent={{60,40},{40,60}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0.0,10e5; 10,9e5; 20,2e5; 30,40e5]) annotation (Placement(transformation(extent={{60,70},{80,90}})));
  GenericValveVLE_L1 valveEN_60534_compressible_checkValve(
    showExpertSummary=true,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible,
    checkValve=true) annotation (Placement(transformation(extent={{-10,-16},{10,-4}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG1(p_const=10e5, h_const=3000e3)
                                                                                                      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG2(variable_p=true, h_const=3500e3)
                                                                                           annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0.0,10e5; 10,9e5; 20,2e5; 300,11e5])
                                                                                          annotation (Placement(transformation(extent={{60,10},{80,30}})));
  GenericValveVLE_L1 valveEN_60534_compressibleBackwards(showExpertSummary=true, redeclare model PressureLoss =
        Fundamentals.Quadratic_EN60534_compressible)                                                                                                         annotation (Placement(transformation(extent={{10,104},{-10,116}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG3(p_const=10e5, h_const=3000e3)
                                                                                                      annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG4(variable_p=true, h_const=2700e3)
                                                                                           annotation (Placement(transformation(extent={{58,100},{38,120}})));
  Modelica.Blocks.Sources.TimeTable timeTable2(table=[0.0,10e5; 10,9e5; 20,2e5; 300,11e5])
                                                                                          annotation (Placement(transformation(extent={{60,130},{80,150}})));
  GenericValveVLE_L1 valveEN_60534_compressible_phaseChange(
    showExpertSummary=true,
    redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible,
    checkValve=false) annotation (Placement(transformation(extent={{-10,-76},{10,-64}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG5(
    p_const=10e5,
    h_const=3000e3,
    variable_p=false,
    variable_h=true)                                                                                  annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  BoundaryConditions.BoundaryVLE_phxi                  pressureSink_XRG6(
    h_const=3500e3,
    variable_p=false,
    p_const=8e5)                                                                           annotation (Placement(transformation(extent={{60,-80},{40,-60}})));
  Modelica.Blocks.Sources.TimeTable timeTable3(table=[0.0,3000e3; 100,250e3; 200,3500e3; 300,3500e3; 400,200e3])
                                                                                          annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
equation
  connect(valveEN_60534_compressible.outlet, pressureSink_XRG11.steam_a) annotation (Line(
      points={{10,50},{40,50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG10.steam_a, valveEN_60534_compressible.inlet) annotation (Line(
      points={{-40,50},{-10,50}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(timeTable.y, pressureSink_XRG11.p) annotation (Line(points={{81,80},{92,80},{92,56},{60,56}}, color={0,0,127}));
  connect(valveEN_60534_compressible_checkValve.outlet, pressureSink_XRG2.steam_a) annotation (Line(
      points={{10,-10},{40,-10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG1.steam_a, valveEN_60534_compressible_checkValve.inlet) annotation (Line(
      points={{-40,-10},{-10,-10}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(timeTable1.y, pressureSink_XRG2.p) annotation (Line(points={{81,20},{92,20},{92,-4},{60,-4}}, color={0,0,127}));
  connect(timeTable2.y, pressureSink_XRG4.p) annotation (Line(points={{81,140},{92,140},{92,116},{58,116}}, color={0,0,127}));
  connect(pressureSink_XRG3.steam_a, valveEN_60534_compressibleBackwards.outlet) annotation (Line(
      points={{-40,110},{-10,110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveEN_60534_compressibleBackwards.inlet, pressureSink_XRG4.steam_a) annotation (Line(
      points={{10,110},{38,110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveEN_60534_compressible_phaseChange.outlet, pressureSink_XRG6.steam_a) annotation (Line(
      points={{10,-70},{40,-70}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG5.steam_a, valveEN_60534_compressible_phaseChange.inlet) annotation (Line(
      points={{-40,-70},{-10,-70}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(timeTable3.y, pressureSink_XRG5.h) annotation (Line(points={{-79,-50},{-72,-50},{-72,-70},{-60,-70}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1)),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,160}})),
    experiment(StopTime=40));
end Test_EN60534_compressible;
