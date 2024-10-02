within ClaRa.StaticCycles.Machines.Check;
model CheckTurbineModels

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExample100;
  Boundaries.Source_green source_green(
    m_flow=30,
    h=3000e3,
    p=80e5)
           annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Boundaries.Sink_blue sink_blue1(p=0.01e5)
                                         annotation (Placement(transformation(extent={{70,-22},{90,-2}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  Turbine_mech turbine_mech annotation (Placement(transformation(extent={{-36,-14},{-24,6}})));
  Turbine_mech turbine_mech1 annotation (Placement(transformation(extent={{-6,-14},{6,6}})));
  Turbine_mech turbine_mech2 annotation (Placement(transformation(extent={{24,-14},{36,6}})));
  Fittings.Split1 split1_1 annotation (Placement(transformation(extent={{-20,-17},{-10,-11}})));
  Fittings.Split1 split1_2 annotation (Placement(transformation(extent={{10,-17},{20,-11}})));
  Boundaries.Sink_red sink_red(m_flow=5, p=20e5) annotation (Placement(transformation(extent={{-6,-50},{14,-30}})));
  Boundaries.Sink_red sink_red1(m_flow=5, p=5e5) annotation (Placement(transformation(extent={{24,-50},{44,-30}})));
  Boundaries.Source_grey source_grey(P=0) annotation (Placement(transformation(extent={{-62,-14},{-42,6}})));
  Boundaries.Sink_grey sink_grey annotation (Placement(transformation(extent={{46,-14},{66,6}})));
equation
  connect(turbine_mech.inlet, source_green.outlet) annotation (Line(points={{-36.5,0},{-59.5,0}}, color={0,131,169}));
  connect(turbine_mech.power_out, turbine_mech1.power_in) annotation (Line(points={{-23.6,-4},{-6.4,-4}}, color={118,124,127}));
  connect(turbine_mech1.power_out, turbine_mech2.power_in) annotation (Line(points={{6.4,-4},{23.6,-4}}, color={118,124,127}));
  connect(turbine_mech2.outlet, sink_blue1.inlet) annotation (Line(points={{36.5,-12},{69.5,-12}}, color={0,131,169}));
  connect(turbine_mech.outlet, split1_1.inlet) annotation (Line(points={{-23.5,-12},{-20.5,-12}}, color={0,131,169}));
  connect(split1_1.outlet_1, turbine_mech1.inlet) annotation (Line(points={{-9.5,-12},{-8,-12},{-8,0},{-6.5,0}}, color={0,131,169}));
  connect(turbine_mech1.outlet, split1_2.inlet) annotation (Line(points={{6.5,-12},{9.5,-12}}, color={0,131,169}));
  connect(split1_2.outlet_1, turbine_mech2.inlet) annotation (Line(points={{20.5,-12},{22,-12},{22,0},{23.5,0}}, color={0,131,169}));
  connect(sink_red.inlet, split1_1.outlet_2) annotation (Line(points={{-6.5,-40},{-15,-40},{-15,-17.5}}, color={0,131,169}));
  connect(split1_2.outlet_2, sink_red1.inlet) annotation (Line(points={{15,-17.5},{15,-40},{23.5,-40}}, color={0,131,169}));
  connect(source_grey.outlet, turbine_mech.power_in) annotation (Line(points={{-42.4,-4},{-36.4,-4}}, color={118,124,127}));
  connect(turbine_mech2.power_out, sink_grey.inlet) annotation (Line(points={{36.4,-4},{46.4,-4}}, color={118,124,127}));
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
 Icon(graphics,    coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                Text(
          extent={{-100,82},{184,35}},
          lineColor={0,128,0},
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="____________________________________________________________________________________________
PURPOSE:
tester of a turbine model with extraction
____________________________________________________________________________________________
LOOK AT:
the calculated turbine power
____________________________________________________________________________________________")}),
    experiment(StopTime=1));
end CheckTurbineModels;
