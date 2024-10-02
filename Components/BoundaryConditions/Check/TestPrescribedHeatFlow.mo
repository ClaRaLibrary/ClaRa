within ClaRa.Components.BoundaryConditions.Check;
model TestPrescribedHeatFlow
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(
    m_flow_const=10,
    h_const=1e5,
    showData=true) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const(displayUnit="bar") = 300000) annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  PrescribedHeatFlowVLE                                     prescribedHeatFlowVLE(Q_flowInputIsActive=true,
                                                                          showData=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=2e6) annotation (Placement(transformation(extent={{-40,-46},{-20,-26}})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{-70,-24},{-50,-14}})));
  ClaRa.Visualisation.Quadruple quadruple1 annotation (Placement(transformation(extent={{10,-26},{30,-16}})));
  ClaRa.Visualisation.Quadruple quadruple2 annotation (Placement(transformation(extent={{50,-26},{70,-16}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-102},{-80,-82}})));
equation
  connect(boundaryVLE_hxim_flow.steam_a, prescribedHeatFlowVLE.inlet) annotation (Line(
      points={{-60,0},{-10,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(prescribedHeatFlowVLE.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{10,0},{60,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple1.eye, prescribedHeatFlowVLE.eye) annotation (Line(points={{10,-21},{10,-11.5},{13,-11.5},{13,-7},{11,-7}}, color={190,190,190}));
  connect(quadruple2.eye, boundaryVLE_phxi.eye) annotation (Line(points={{50,-21},{50,-8},{60,-8}}, color={190,190,190}));
  connect(quadruple.eye, boundaryVLE_hxim_flow.eye) annotation (Line(points={{-70,-19},{-70,-12},{-54,-12},{-54,-8},{-60,-8}}, color={190,190,190}));
  connect(realExpression.y, prescribedHeatFlowVLE.Q_flow_in) annotation (Line(points={{-19,-36},{0,-36},{0,-11}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestPrescribedHeatFlow;
