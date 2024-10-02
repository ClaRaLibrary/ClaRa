within ClaRa.Components.VolumesValvesFittings.Fittings.Check;
model TestFuelSplit
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  SplitFuel_L1_flex splitFuel_L1_flex(N_ports_out=3, K_split={0.5,0.2}) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  BoundaryConditions.BoundaryFuel_pTxi                      boundaryFuel_pTxi(p_const=3e5) annotation (Placement(transformation(extent={{92,6},{72,26}})));
  BoundaryConditions.BoundaryFuel_Txim_flow                      boundaryFuel_Txim_flow(m_flow_const=10) annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  BoundaryConditions.BoundaryFuel_pTxi                      boundaryFuel_pTxi1(p_const=2e5) annotation (Placement(transformation(extent={{60,40},{40,60}})));
  inner SimCenter simCenter(redeclare Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel1)
                                                                            annotation (Placement(transformation(extent={{-90,-86},{-50,-66}})));
  BoundaryConditions.BoundaryFuel_pTxi                      boundaryFuel_pTxi2 annotation (Placement(transformation(extent={{72,-92},{52,-72}})));
equation
  connect(boundaryFuel_Txim_flow.fuel_a, splitFuel_L1_flex.inlet) annotation (Line(
      points={{-46,0},{-12,0}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitFuel_L1_flex.outlet[1], boundaryFuel_pTxi1.fuel_a) annotation (Line(
      points={{8,-0.333333},{18,-0.333333},{18,50},{40,50}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitFuel_L1_flex.outlet[2], boundaryFuel_pTxi.fuel_a) annotation (Line(
      points={{8,0},{20,0},{20,16},{72,16}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(splitFuel_L1_flex.outlet[3], boundaryFuel_pTxi2.fuel_a) annotation (Line(
      points={{8,0.333333},{14,0.333333},{14,-2},{18,-2},{18,-82},{52,-82}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, __Dymola_Algorithm="Dassl"));
end TestFuelSplit;
