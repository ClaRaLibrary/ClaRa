within ClaRa.Components.Utilities.Blocks.Check;
model test_1_LimPID
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
  LimPID PID(
    k=10,
    y_start=4,
    xi_start=3,
    xd_start=2,
    y_max=100,
    Tau_i=0.1,
    y_inactive=10,
    use_activateInput=false,
    t_activation=0,
    Tau_lag_I=0,
    Tau_in=1e-3,
    Tau_out=1e-3,
    initOption=503,
    controllerType=Modelica.Blocks.Types.SimpleController.PID) annotation (Placement(transformation(extent={{-36,-20},{-16,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.2,
    f=0.1,
    offset=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={72,-62})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=1,
    y_start=0.3)
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-6,-56})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={22,-56})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time > 10)
    annotation (Placement(transformation(extent={{-80,-8},{-60,-28}})));
equation
  connect(realExpression.y, PID.u_s) annotation (Line(
      points={{-59,-10},{-38,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, firstOrder.u) annotation (Line(
      points={{11,-56},{6,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, add.u1) annotation (Line(
      points={{61,-62},{34,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, add.u2) annotation (Line(
      points={{-15,-10},{52,-10},{52,-50},{34,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, PID.u_m) annotation (Line(
      points={{-17,-56},{-25.9,-56},{-25.9,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanExpression.y, PID.activateInput) annotation (Line(points={{-59,-18},{-38,-18}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics={            Text(
          extent={{-94,98},{104,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE: 
test initialisation of PID block
test controller activation of PID block

______________________________________________________________________________________________
"),                                               Text(
          extent={{-94,58},{70,44}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="______________________________________________________________________________________________________________
Remarks: 
Play around with controllertype and initType and the controller activation settings
______________________________________________________________________________________________________________
"),                   Text(
          extent={{-94,72},{106,54}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput(equdistant=false));
end test_1_LimPID;
