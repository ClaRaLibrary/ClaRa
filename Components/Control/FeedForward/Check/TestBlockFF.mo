within ClaRa.Components.Control.FeedForward.Check;
model TestBlockFF
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
  Modelica.Blocks.Sources.Ramp PTarget(
    offset=1,
    duration=600,
    height=-0.1,
    startTime=600)
    annotation (Placement(transformation(extent={{-92,-58},{-72,-38}})));
  FeedForwardBlock_3508 feedForwardBlock_3508_1(CL_Valve_=[0,1; 1,1]) annotation (Placement(transformation(extent={{-50,-82},{-30,-62}})));
  Modelica.Blocks.Sources.Constant const2(k=1)
    annotation (Placement(transformation(extent={{60,-54},{40,-34}})));
  Modelica.Blocks.Sources.Constant const3(k=0.5)
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=0.1,
    offset=0.02/60,
    height=0,
    startTime=300)
              annotation (Placement(transformation(extent={{62,-88},{40,-66}})));
equation
  connect(PTarget.y, feedForwardBlock_3508_1.P_G_target_) annotation (Line(
      points={{-71,-48},{-44,-48},{-44,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const2.y, feedForwardBlock_3508_1.P_max_) annotation (Line(
      points={{39,-44},{7.5,-44},{7.5,-64},{-28,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedForwardBlock_3508_1.P_min_, const3.y) annotation (Line(
      points={{-28,-68},{16,-68},{16,-60},{69,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, feedForwardBlock_3508_1.derP_max_) annotation (Line(
      points={{38.9,-77},{6.45,-77},{6.45,-72},{-28,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, feedForwardBlock_3508_1.derP_StG_) annotation (Line(
      points={{38.9,-77},{6,-77},{6,-76},{-28,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, feedForwardBlock_3508_1.derP_T_) annotation (Line(
      points={{38.9,-77},{6.45,-77},{6.45,-80},{-28,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                      graphics={  Text(
          extent={{-94,98},{104,58}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:

______________________________________________________________________________________________
"),                                               Text(
          extent={{-94,58},{70,44}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          textString="______________________________________________________________________________________________________________
Remarks: 
______________________________________________________________________________________________________________
",        fontSize=8),Text(
          extent={{-94,72},{106,54}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
Scenario:  

______________________________________________________________________________________________
")}), experiment(StopTime=2000));
end TestBlockFF;
