within ClaRa.Components.Control.PowerPlantControl;
model LiveSteamTemperature "A simple controller for the live steam temperature based on Strauss: \"Kraftwerkstechnik\", 5th edition, 2006."
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

  Utilities.Blocks.LimPID PID2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    sign=1,
    u_ref=T_a2_ref,
    y_ref=T_e2_ref,
    k=k_PID2,
    Tau_i=Tau_i_PID2,
    y_max=1000,
    y_start=536,
    perUnitConversion=false,
    initOption=796) annotation (Placement(transformation(
        extent={{10,9},{-10,-9}},
        rotation=90,
        origin={7,68})));
  Utilities.Blocks.LimPID feedback2(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    perUnitConversion=false,
    y_min=0,
    y_max=1,
    k=k_P2,
    sign=-1,
    y_start=0.9,
    initOption=796) annotation (Placement(transformation(
        extent={{10,9.5},{-10,-9.5}},
        rotation=90,
        origin={7.5,36})));
  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={56,36})));
  Modelica.Blocks.Interfaces.RealOutput opening2 "valve opening of injector 2"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,20})));
public
  Basics.Interfaces.Bus MeasurementValues annotation (Placement(transformation(extent={{-20,78},{20,118}}), iconTransformation(extent={{-8,88},{12,110}})));
public
  Basics.Interfaces.Bus SetValues annotation (Placement(transformation(extent={{30,78},{70,118}}), iconTransformation(extent={{40,90},{60,110}})));
  Utilities.Blocks.LimPID PID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=Delta_T_2_ref,
    y_ref=T_e1_ref,
    k=k_PID1,
    Tau_i=Tau_i_PID1,
    y_max=1000,
    y_start=492,
    sign=+1,
    perUnitConversion=false,
    initOption=796) annotation (Placement(transformation(
        extent={{10,9},{-10,-9}},
        rotation=90,
        origin={-2,-28})));
  Utilities.Blocks.LimPID P1(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    sign=-1,
    perUnitConversion=false,
    y_max=1,
    y_min=0,
    k=k_P1,
    y_start=0.5,
    initOption=796) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-2,-68})));
  Modelica.Blocks.Interfaces.RealOutput opening1 "opening of  injector 1"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,-80})));
  parameter Real T_a2_ref=873.15 "Reference value for controlled variable";
  parameter Real k_PID2=1 "Gain of PID2";
  parameter Modelica.Units.SI.Time Tau_i_PID2=0.5 "Integration time constant of PID2";
  parameter Real T_e2_ref=1 "Reference value injector 2 outlet temperature";
  parameter Real k_P2=1 "Gain value multiplied with input signal";
  parameter Real Delta_T_2_ref=20 "Reference value for Temperature difference over injector 2";
  parameter Real T_e1_ref=1 "Reference value for injector 1 outlet temperature";
  parameter Real k_PID1=1 "Gain of controller";
  parameter Modelica.Units.SI.Time Tau_i_PID1=0.5 "Time constant of Integrator block";
  parameter Real k_P1=1 "Gain of controller";
equation
  connect(PID2.y, add2.u1) annotation (Line(
      points={{7,57},{50,57},{50,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MeasurementValues.T_a2, PID2.u_m) annotation (Line(
      points={{0,98},{-72,98},{-72,67.9},{-3.8,67.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(SetValues.T_a2_set, PID2.u_s) annotation (Line(
      points={{50,98},{44.5,98},{44.5,80},{7,80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(SetValues.Delta_T2_set, add2.u2) annotation (Line(
      points={{50,98},{62,98},{62,48}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(MeasurementValues.T_a1, PID1.u_m) annotation (Line(
      points={{0,98},{-72,98},{-72,-28.1},{-12.8,-28.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(PID1.u_s, add2.y) annotation (Line(
      points={{-2,-16},{56,-16},{56,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P1.y, opening1) annotation (Line(
      points={{-2,-79},{-2,-80},{-110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID1.y, P1.u_s) annotation (Line(
      points={{-2,-39},{-2,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback2.y, opening2) annotation (Line(
      points={{7.5,25},{10,25},{10,20},{-110,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID2.y, feedback2.u_s) annotation (Line(
      points={{7,57},{7,52.5},{7.5,52.5},{7.5,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MeasurementValues.T_e2, feedback2.u_m) annotation (Line(
      points={{0,98},{-72,98},{-72,35.9},{-3.9,35.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(MeasurementValues.T_e1, P1.u_m) annotation (Line(
      points={{0,98},{-72,98},{-72,-68.1},{-14,-68.1}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
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
        Rectangle(
          extent={{2,-20},{48,-48}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Line(points={{22,-60},{22,-34},{36,-26}}, color={221,222,223}),
        Line(points={{36,-40},{22,-34},{36,-34}}, color={221,222,223})}));
end LiveSteamTemperature;
