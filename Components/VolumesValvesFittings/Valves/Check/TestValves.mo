within ClaRa.Components.VolumesValvesFittings.Valves.Check;
model TestValves
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
  GenericValveVLE_L1 valve1(showExpertSummary=true, redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_incompressible (paraOption=2, m_flow_nom=1000/3600)) annotation (Placement(transformation(extent={{-4,0},{16,12}})));
  GenericValveVLE_L1 valve2(showExpertSummary=true, redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_incompressible) annotation (Placement(transformation(extent={{-4,-26},{16,-14}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-64,-30},{-44,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG1(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-64,-4},{-44,16}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG2(variable_p=true) annotation (Placement(transformation(extent={{52,-4},{32,16}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG3(variable_p=true) annotation (Placement(transformation(extent={{52,-30},{32,-10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=10,
    height=10e5,
    duration=1,
    offset=2e5) annotation (Placement(transformation(extent={{56,38},{76,58}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-96,-136},{-76,-116}})));

  GenericValveVLE_L1 valve3(showExpertSummary=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                           m_flow_nom=0.2786)) annotation (Placement(transformation(extent={{-4,-54},{16,-42}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG4(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-64,-58},{-44,-38}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG5(variable_p=true) annotation (Placement(transformation(extent={{52,-58},{32,-38}})));
  GenericValveVLE_L1 valve4(showExpertSummary=true, redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_incompressible (paraOption=3, zeta=36000^2*2)) annotation (Placement(transformation(extent={{-4,-80},{16,-68}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG6(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-64,-84},{-44,-64}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG7(variable_p=true) annotation (Placement(transformation(extent={{52,-84},{32,-64}})));
  GenericValveVLE_L1 valve5(showExpertSummary=true, redeclare model PressureLoss = Fundamentals.Quadratic_EN60534_compressible) annotation (Placement(transformation(extent={{-4,-104},{16,-92}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG8(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-66,-108},{-46,-88}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG9(variable_p=true) annotation (Placement(transformation(extent={{50,-108},{30,-88}})));
  GenericValveVLE_L1 valve6(showExpertSummary=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_FlowFunction (                                                                           zeta=36000^2*2)) annotation (Placement(transformation(extent={{-4,-130},{16,-118}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG10(p_const=3e5, h_const=150e3) annotation (Placement(transformation(extent={{-64,-134},{-44,-114}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG11(variable_p=true) annotation (Placement(transformation(extent={{52,-134},{32,-114}})));
equation
  connect(valve2.outlet, pressureSink_XRG3.steam_a) annotation (Line(
      points={{16,-20},{32,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG.steam_a, valve2.inlet) annotation (Line(
      points={{-44,-20},{-4,-20}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve1.outlet, pressureSink_XRG2.steam_a) annotation (Line(
      points={{16,6},{32,6}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG1.steam_a, valve1.inlet) annotation (Line(
      points={{-44,6},{-4,6}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, pressureSink_XRG2.p) annotation (Line(
      points={{77,48},{84,48},{84,12},{52,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, pressureSink_XRG3.p) annotation (Line(
      points={{77,48},{84,48},{84,-14},{52,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve3.outlet,pressureSink_XRG5. steam_a) annotation (Line(
      points={{16,-48},{32,-48}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG4.steam_a, valve3.inlet)
                                                  annotation (Line(
      points={{-44,-48},{-4,-48}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, pressureSink_XRG5.p) annotation (Line(
      points={{77,48},{84,48},{84,-42},{52,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve4.outlet,pressureSink_XRG7. steam_a) annotation (Line(
      points={{16,-74},{32,-74}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG6.steam_a, valve4.inlet)
                                                  annotation (Line(
      points={{-44,-74},{-4,-74}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG7.p, pressureSink_XRG5.p) annotation (Line(
      points={{52,-68},{84,-68},{84,-42},{52,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve5.outlet,pressureSink_XRG9. steam_a) annotation (Line(
      points={{16,-98},{30,-98}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG8.steam_a, valve5.inlet)
                                                  annotation (Line(
      points={{-46,-98},{-4,-98}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG9.p, pressureSink_XRG5.p) annotation (Line(
      points={{50,-92},{84,-92},{84,-42},{52,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valve6.outlet, pressureSink_XRG11.steam_a)
                                                    annotation (Line(
      points={{16,-124},{32,-124}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG10.steam_a, valve6.inlet)
                                                  annotation (Line(
      points={{-44,-124},{-4,-124}},
      points={{-36,-80},{4,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink_XRG11.p, pressureSink_XRG5.p) annotation (Line(
      points={{52,-118},{84,-118},{84,-42},{52,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,100}}),
            graphics={Text(
          extent={{-98,100},{102,2}},
          lineColor={0,128,0},
          textString="_______________________________________________________________________
PURPOSE:
Show different valve models and illustrate the differences. The model compares a
simple linear approach with a simple quadratic approach. The first mentioned one only 
refers to nominal pressure difference and nominal mass flow rate while the latter
mentioned valve takes a constent friction coefficient and the inlet density into account.
_______________________________________________________________________
LOOK AT:
compare both mass flow rates in summary.inlet.m_flow. The quadratic density dependent 
approach shows a considerably higher mass flow rate after flow reversal due differnt 
densities (in fact the flow switches from vapour to liquid water). This effect is not
considered in the linear valve.
_______________________________________________________________________
",        fontSize=10,
          horizontalAlignment=TextAlignment.Left)}),
    experiment(StopTime=20),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end TestValves;
