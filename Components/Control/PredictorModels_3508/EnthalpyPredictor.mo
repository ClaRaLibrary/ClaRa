within ClaRa.Components.Control.PredictorModels_3508;
model EnthalpyPredictor "Prediction of evaporator outlet enthalpy using characteristic lines and transfer functions"
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

  extends Modelica.Blocks.Interfaces.SISO;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="01");

  parameter Real CL_hEvap_pD_[:,:] = [0.34, 2806e3; 0.55, 2708e3; 0.75, 2559e3; 1, 2200e3] "Characteristic line evap outlet enthalpy over pressure"
                                                             annotation(Dialog(group="Part Load Definition"));
  parameter Modelica.Units.SI.Time Tau_evap=40 "Time constant for energy storage in evaporator" annotation (Dialog(group="Time Response Definition"));
  Modelica.Blocks.Tables.CombiTable1Dv convert2enthalpy(columns={2}, table=CL_hEvap_pD_) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=Tau_evap,
    initType=initType,
    y_start=h_evap_start)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T=Tau_evap,
    initType=initType,
    y_start=h_evap_start)
    annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T=Tau_evap,
    initType=initType,
    y_start=h_evap_start)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T=Tau_evap,
    initType=initType,
    y_start=h_evap_start)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit "Initialisation option" annotation(Dialog(group="Initialisation"));
  parameter Modelica.Units.SI.SpecificEnthalpy h_evap_start=0 "Initial evaporator outlet enthalpy" annotation (Dialog(group="Initialisation"));
equation
  connect(u, convert2enthalpy.u[1]) annotation (Line(
      points={{-120,0},{-82,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2enthalpy.y[1], firstOrder.u) annotation (Line(
      points={{-59,0},{-42,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, firstOrder1.u) annotation (Line(
      points={{-19,0},{-8,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder1.y, firstOrder2.u) annotation (Line(
      points={{15,0},{24,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder2.y, firstOrder3.u) annotation (Line(
      points={{47,0},{58,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder3.y, y) annotation (Line(
      points={{81,0},{110,0}},
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
 Icon(graphics={   Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid), Rectangle(extent={{-80,80},{80,-80}}, lineColor={221,222,223}),
        Line(
          points={{-80,-40},{-28,-40},{40,40},{80,40}},
          color={221,222,223},
          smooth=Smooth.Bezier)}),Diagram(graphics));
end EnthalpyPredictor;
