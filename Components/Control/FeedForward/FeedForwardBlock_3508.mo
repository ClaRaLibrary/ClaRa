within ClaRa.Components.Control.FeedForward;
model FeedForwardBlock_3508 "feed forward for coal mass flow and turbine valve aperture"
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

  parameter Real CL_Valve_[:,:]=[0,0; 1, 1] "Characteristics of the turbine valve"
                                           annotation(Dialog(group="Part Load Definition"));

  parameter Real k_FuelOvershoot=100 "Gain of fuel overshoot";
  parameter Real eta_gen= 0.98 "Efficiency of generator";

  Modelica.Blocks.Interfaces.RealInput derP_max_ "Maximum overall power gradient"
                                     annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,-20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,0})));
  Modelica.Blocks.Interfaces.RealInput derP_StG_ "Maximum  power gradient due to steam generator restrictions"
                                                                  annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,-50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,-40})));
  Modelica.Blocks.Interfaces.RealInput derP_T_ "Maximum  power gradient due to turbine restrictions"
                                                          annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,-80})));
  Modelica.Blocks.Interfaces.RealInput P_G_target_ "Target value generator power"
                                   annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,120})));
protected
  Modelica.Blocks.Math.Min min annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,32})));
public
  Modelica.Blocks.Math.Min min1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,26})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-76,68})));
  Utilities.Blocks.VariableGradientLimiter variableGradientLimiter annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-76,10})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-42,40})));
  Modelica.Blocks.Interfaces.RealInput P_max_ "Maximum generator power"
                                     annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput P_min_ "Minimum generator power"
                                     annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,40})));
  Modelica.Blocks.Math.Gain FuelFeedForward(k=1/eta_gen)
                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-76,-36})));
  Modelica.Blocks.Continuous.Derivative FuelOvershoot(initType=Modelica.Blocks.Types.Init.InitialOutput,
      k=k_FuelOvershoot)                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-38,-32})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-78})));
  Modelica.Blocks.Interfaces.RealOutput QF_FF_ "FiringPower feed forward"
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-110})));
  Modelica.Blocks.Tables.CombiTable1Dv turbineValveOpeneing(table=CL_Valve_, columns={2}) "load dependend turbine valve opening" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-38})));
  Modelica.Blocks.Interfaces.RealOutput y_Turbine_ "Feed forward value for turbine valve openeing"
                                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-110})));
  Modelica.Blocks.Interfaces.RealOutput P_G_set_ "Connector of Real output signal"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-110})));
equation
  connect(derP_max_, min.u2) annotation (Line(
      points={{120,-20},{102,-20},{102,38},{88,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(derP_StG_, min.u1) annotation (Line(
      points={{120,-50},{98,-50},{98,26},{88,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min.y, min1.u2) annotation (Line(
      points={{65,32},{65,31},{52,31},{52,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(derP_T_, min1.u1) annotation (Line(
      points={{120,-80},{94,-80},{94,20},{52,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_G_target_, variableLimiter.u) annotation (Line(
      points={{-40,120},{-40,80},{-76,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(min1.y, variableGradientLimiter.maxGrad) annotation (Line(
      points={{29,26},{-68,26},{-68,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(variableLimiter.y, variableGradientLimiter.u) annotation (Line(
      points={{-76,57},{-76,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, min1.y) annotation (Line(
      points={{-30,40},{22.5,40},{22.5,26},{29,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, variableGradientLimiter.minGrad) annotation (Line(
      points={{-53,40},{-84.5,40},{-84.5,22},{-84,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(variableLimiter.limit1, P_max_) annotation (Line(
      points={{-68,80},{120,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_min_, variableLimiter.limit2) annotation (Line(
      points={{120,50},{68,50},{68,90},{-84,90},{-84,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(variableGradientLimiter.y, FuelFeedForward.u) annotation (Line(
      points={{-76,-1},{-76,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FuelOvershoot.u, variableGradientLimiter.y)
                                                   annotation (Line(
      points={{-38,-20},{-38,-10},{-76,-10},{-76,-1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u2, FuelFeedForward.y) annotation (Line(
      points={{-76,-66},{-76,-47}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u1, FuelOvershoot.y)
                                annotation (Line(
      points={{-64,-66},{-64,-62},{-38,-62},{-38,-43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, QF_FF_)     annotation (Line(
      points={{-70,-89},{-40,-89},{-40,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(variableGradientLimiter.y, turbineValveOpeneing.u[1]) annotation (
      Line(
      points={{-76,-1},{-76,-10},{20,-10},{20,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(turbineValveOpeneing.y[1], y_Turbine_) annotation (Line(
      points={{20,-49},{20,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(variableGradientLimiter.y, P_G_set_) annotation (Line(
      points={{-76,-1},{-96,-1},{-96,-94},{-80,-94},{-80,-110}},
      color={0,0,127},
      smooth=Smooth.None));
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
    revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Diagram(graphics), Icon(graphics={
                                Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid), Rectangle(extent={{-80,80},{80,-80}}, lineColor={221,222,223}),
        Line(points={{-68,60},{-68,-70},{72,-70}}, color={221,222,223}),
        Line(
          points={{-68,-40},{-40,-40},{-40,-40},{-40,40},{-40,40},{-4,8},{72,8}},
          color={186,72,88},
          smooth=Smooth.Bezier),
        Line(
          points={{-60,-60},{-32,-60},{-32,-60},{-26,-30},{-28,-16},{-28,-16},{-6,-16},{-6,-16},{-8,-30},{-2,-60},{-2,-60},{-0.230469,-60},{0,-60},{0,-20.4688},{0,-20},{17.7188,-20},{18,-20},{24,-24},{24,-24},{24,-45.6777},{24,-46},{35.9063,-46},{36,-46},{36,-60},{36,-60},{46,-60},{56,-60},{66,-60}},
          color={221,222,223},
          smooth=Smooth.Bezier)}));
end FeedForwardBlock_3508;
