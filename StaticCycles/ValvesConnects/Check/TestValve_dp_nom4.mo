within ClaRa.StaticCycles.ValvesConnects.Check;
model TestValve_dp_nom4
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

inner parameter Real P_target_= 1;
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom4 valve_dp_nom4_1(Delta_p_nom=1e5) annotation (Placement(transformation(extent={{-26,0},{-16,6}})));
  ClaRa.StaticCycles.Boundaries.Source_yellow source_yellow(h=2300e3,p=2e5) annotation (Placement(transformation(extent={{-60,-6},{-40,14}})));
  ClaRa.StaticCycles.Boundaries.Sink_yellow sink_yellow(m_flow=10) annotation (Placement(transformation(extent={{4,-8},{24,12}})));
  inner ClaRa.SimCenter simCenter annotation (Placement(transformation(extent={{-96,-38},{-56,-18}})));
equation
  connect(valve_dp_nom4_1.outlet, sink_yellow.inlet) annotation (Line(points={{-15.5,3},{-5.75,3},{-5.75,2},{3.5,2}}, color={0,131,169}));
  connect(source_yellow.outlet, valve_dp_nom4_1.inlet) annotation (Line(points={{-39.5,4},{-32,4},{-32,3},{-26.5,3}}, color={0,131,169}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
end TestValve_dp_nom4;
