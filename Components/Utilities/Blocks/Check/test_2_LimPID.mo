within ClaRa.Components.Utilities.Blocks.Check;
model test_2_LimPID
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
    y_min=0,
    y_ref=1e5,
    u_ref=10,
    y_max=0.2*1e6,
    k=0.001,
    Tau_i=100,
    Ni=0.001,
    t_activation=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    use_activateInput=true,
    y_start=1,
    initOption=796) annotation (Placement(transformation(extent={{-64,2},{-44,22}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump(eta_mech=1, inlet(m_flow(start=500)))
                                                                          annotation (Placement(transformation(extent={{-20,-48},{0,-28}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG(p_const=100000) annotation (Placement(transformation(extent={{-80,-48},{-60,-28}})));
  BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG1(variable_p=true, p_const=1000000) annotation (Placement(transformation(extent={{34,-48},{14,-28}})));
  Modelica.Blocks.Sources.TimeTable
                               ramp2(
    offset=1.1e5,
    startTime=0,
    table=[0,0; 25,0; 26,2e5; 350,2e5; 380,0; 400,0])
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,-32})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.RealExpression actual_m_flow(y=pump.inlet.m_flow)
    annotation (Placement(transformation(extent={{-96,-24},{-76,-4}})));
  Modelica.Blocks.Sources.RealExpression setPoint_m_flow(y=1000)
    annotation (Placement(transformation(extent={{-96,14},{-76,34}})));
  Modelica.Blocks.Sources.BooleanExpression activate_controller(y=time > 2)
    annotation (Placement(transformation(extent={{-96,-8},{-76,12}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1, initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={56,-32})));
equation
  connect(PID.y, pump.P_drive) annotation (Line(
      points={{-43,12},{-10,12},{-10,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, pressureSink_XRG1.p) annotation (Line(
      points={{45,-32},{34,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_XRG.steam_a, pump.inlet) annotation (Line(
      points={{-60,-38},{-40,-38},{-20,-38}},
      color={0,131,169},
      thickness=0.5));
  connect(pump.outlet, pressureSink_XRG1.steam_a) annotation (Line(
      points={{0,-38},{8,-38},{14,-38}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(activate_controller.y, PID.activateInput) annotation (Line(points={{-75,2},{-72,2},{-72,4},{-66,4}}, color={255,0,255}));
  connect(ramp2.y, firstOrder.u) annotation (Line(points={{75,-32},{68,-32}},                   color={0,0,127}));
  connect(setPoint_m_flow.y, PID.u_s) annotation (Line(points={{-75,24},{-70,24},{-70,12},{-66,12}}, color={0,0,127}));
  connect(actual_m_flow.y, PID.u_m) annotation (Line(points={{-75,-14},{-64,-14},{-64,0},{-53.9,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
                                  Text(
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
")}),                                  Icon(graphics,
                                            coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}})),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end test_2_LimPID;
