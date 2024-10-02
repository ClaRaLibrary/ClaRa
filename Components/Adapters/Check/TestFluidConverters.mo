within ClaRa.Components.Adapters.Check;
model TestFluidConverters
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  Fluid2ClaRa fluid2ClaRa
    annotation (Placement(transformation(extent={{-20,34},{0,14}})));
  Modelica.Fluid.Sources.Boundary_ph boundary(
    use_p_in=false,
    use_h_in=false,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=1000000,
    h=100e3)
    annotation (Placement(transformation(extent={{-144,14},{-124,34}})));
  BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_T(variable_m_flow=true, variable_h=true,
    showData=true)                                                                                 annotation (Placement(transformation(extent={{60,14},{40,34}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-2,
    duration=0.1,
    offset=1,
    startTime=0.75) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,30})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=0.1,
    offset=1e5,
    startTime=0.25,
    height=3e6)     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,0})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-98,14},{-118,34}})));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium =
        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-30,24},{-50,44}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{80,-204},{100,-184}})));
  Visualisation.DynDisplay dynDisplay2(
    varname="MSL.T",
    unit="C",
    x1=temperature.T - 273.15)
    annotation (Placement(transformation(extent={{-60,8},{-24,20}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue(significantDigits=3)
                                                       annotation (Placement(transformation(extent={{-80,24},{-100,44}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue1(significantDigits=3)
                                                        annotation (Placement(transformation(extent={{-114,34},{-134,54}})));
  Sensors.SensorVLE_L1_m_flow Flow annotation (Placement(transformation(extent={{34,24},{14,44}})));
  Sensors.SensorVLE_L1_T Temperature annotation (Placement(transformation(extent={{24,24},{4,4}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-54,44},{-74,24}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15) annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  inner Modelica.Fluid.System system annotation (Placement(transformation(extent={{-150,-200},{-130,-180}})));
equation
  connect(ramp.y, massFlowSource_T.m_flow) annotation (Line(
      points={{79,30},{62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, massFlowSource_T.h) annotation (Line(
      points={{79,1.33227e-015},{76,1.33227e-015},{76,24},{62,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowRate.port_a, fluid2ClaRa.port_a) annotation (Line(
      points={{-98,24},{-98,24},{-19.8,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(boundary.ports[1], massFlowRate.port_b) annotation (Line(
      points={{-124,24},{-118,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(temperature.port, massFlowRate.port_a) annotation (Line(
      points={{-40,24},{-98,24}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(realValue1.numberPort, massFlowRate.m_flow) annotation (Line(points={{-112.5,44},{-108,44},{-108,35}},    color={0,0,127}));
  connect(Flow.inlet, massFlowSource_T.steam_a) annotation (Line(
      points={{34,24},{40,24}},
      color={0,131,169},
      thickness=0.5));
  connect(Flow.outlet, fluid2ClaRa.steam_a) annotation (Line(
      points={{14,24},{-0.05,24},{-0.05,24.0025}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fluid2ClaRa.steam_a, Temperature.port) annotation (Line(
      points={{-0.05,24.0025},{14,24.0025},{14,24}},
      color={0,131,169},
      thickness=0.5));
  connect(temperature.T, feedback.u1) annotation (Line(points={{-47,34},{-47,34},{-56,34}}, color={0,0,127}));
  connect(feedback.y, realValue.numberPort) annotation (Line(points={{-73,34},{-76,34},{-78.5,34}}, color={0,0,127}));
  connect(realExpression.y, feedback.u2) annotation (Line(points={{-79,50},{-64,50},{-64,42}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-150,-200},{100,100}}, initialScale=0.1), graphics={
        Polygon(
          points={{-150,80},{36,80},{-28,0},{-150,0},{-150,80}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,80},{100,80},{100,0},{-28,0},{36,80}},
          lineColor={215,215,215},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,78},{28,70}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Modelica Standard Library"),
        Text(
          extent={{20,78},{80,70}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="ClaRa Library",
          fontName="Miso")}), Icon(graphics,
                                   coordinateSystem(                                initialScale=0.1)),
    experiment(StopTime=1));
end TestFluidConverters;
