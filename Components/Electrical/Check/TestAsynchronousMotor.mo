within ClaRa.Components.Electrical.Check;
model TestAsynchronousMotor "A simple test for the simple motor"

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  inner ClaRa.SimCenter simCenter(redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1, showExpertSummary=
        false) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(         w(start=10), J=50)
    annotation (Placement(transformation(extent={{-48,-80},{-28,-60}})));
  AsynchronousMotor_L2 motor(
    rpm_nom=2950,
    I_rotor_nom=10,
    J=50,
    cosphi=0.9,
    tau_bd_nom=550,
    P_nom=154.457e3,
    eta_stator=0.9,
    activateHeatPort=true,
    N_pp=1,
    U_term_nom=3e3)
            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,-68})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-9,-9},{9,9}},
        rotation=270,
        origin={-62,-45})));
  Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio=1)
    annotation (Placement(transformation(extent={{-24,-80},{-4,-60}})));
  Modelica.Mechanics.Rotational.Sources.LinearSpeedDependentTorque
                                               torque(w_nominal=2950/60*2*3.1415, tau_nominal=-600)
    annotation (Placement(transformation(extent={{56,-80},{36,-60}})));
  Modelica.Blocks.Sources.TimeTable      Flow1(table=[0,3e3; 250,3e3; 251,0; 500,0; 501,3e3; 650,3e3; 651,0; 750,0; 751,3e3; 1000,3e3])
                "-(0.6*200e5/(2*3.14*5100/60))*motor.rpm^2/3000"
    annotation (Placement(transformation(extent={{-52,2},{-72,22}})));
  Modelica.Blocks.Sources.TimeTable      Flow3(table=[0,50; 600,50; 601,0; 800,0; 801,30; 1000,30])
               "-(0.6*200e5/(2*3.14*5100/60))*motor.rpm^2/3000"
    annotation (Placement(transformation(extent={{-52,-30},{-72,-10}})));
  Modelica.Mechanics.Rotational.Components.BearingFriction
                                                     bearingFriction(tau_pos=[0,10; 100,100])
    annotation (Placement(transformation(extent={{2,-80},{22,-60}})));
equation
  connect(inertia1.flange_b, idealGear.flange_a) annotation (Line(
      points={{-28,-70},{-24,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inertia1.flange_a, motor.shaft) annotation (Line(
      points={{-48,-70},{-50,-70},{-50,-68},{-52,-68}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(motor.heat, fixedTemperature.port) annotation (Line(
      points={{-62,-58},{-62,-54}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Flow3.y, motor.f_term) annotation (Line(
      points={{-73,-20},{-84,-20},{-84,-64},{-74,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Flow1.y, motor.U_term) annotation (Line(
      points={{-73,12},{-94,12},{-94,-68},{-74,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealGear.flange_b, bearingFriction.flange_a) annotation (Line(points={{-4,-70},{2,-70}}, color={0,0,0}));
  connect(bearingFriction.flange_b, torque.flange) annotation (Line(points={{22,-70},{36,-70}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={
                                  Text(
          extent={{-96,100},{102,60}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:

______________________________________________________________________________________________
"),                                               Text(
          extent={{-96,60},{68,46}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-96,74},{104,56}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}),
    experiment(StopTime=600, __Dymola_NumberOfIntervals=50000),
    __Dymola_experimentSetupOutput);
end TestAsynchronousMotor;
