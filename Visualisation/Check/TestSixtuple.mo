within ClaRa.Visualisation.Check;
model TestSixtuple
extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  Sixtuple                         sixtuple(decimalSpaces(s=3, e=2), vleFluid=1) annotation (Placement(transformation(extent={{16,-18},{46,-8}})));
  inner ClaRa.SimCenter simCenter(
    p_amb=1e5,
    T_amb=273.15 + 25,
    redeclare TILMedia.VLEFluid.Types.TILMedia_GERGCO2 fluid2)
    annotation (Placement(transformation(extent={{-100,80},{-60,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_hxim_flow(
    m_flow_const=1,
    T_const=550 + 273.15)    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=200e5)                          annotation (Placement(transformation(extent={{60,0},{40,20}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipeFlowVLE_L2_Simple(
    showData=true,
    showExpertSummary=true,
    medium=simCenter.fluid1) annotation (Placement(transformation(extent={{-26,5},{2,15}})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{16,-8},{36,2}})));
equation
  connect(boundaryVLE_hxim_flow.steam_a, pipeFlowVLE_L2_Simple.inlet) annotation (Line(
      points={{-60,10},{-26,10}},
      color={0,131,169},
      thickness=0.5));
  connect(pipeFlowVLE_L2_Simple.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{2,10},{20,10},{40,10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipeFlowVLE_L2_Simple.eye, sixtuple.eye) annotation (Line(points={{2.6,6.6},{6,6.6},{6,-13},{16,-13}}, color={190,190,190}));
  connect(pipeFlowVLE_L2_Simple.eye, quadruple.eye) annotation (Line(points={{2.6,6.6},{10,6.6},{10,-3},{16,-3}}, color={190,190,190}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000));
end TestSixtuple;
