within ClaRa.StaticCycles.Boundaries;
model Source_black
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

  outer ClaRa.SimCenter simCenter;
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (Dialog(group="Parameters"));

// parameter ClaRa.Basics.Units.Temperature T_FG_nom;
// parameter ClaRa.Basics.Units.MassFlowRate m_flow_FG_nom;
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel "Fuel mass flow from the source";
  parameter ClaRa.Basics.Units.MassFraction xi_fuel[fuelModel.N_c - 1]=fuelModel.defaultComposition "Fuel composition at the source";
//parameter ClaRa.Basics.Units.EnthalpyMassSpecific LHV;
// final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_FG_out=TILMedia.GasFunctions.specificEnthalpy_pTxi(
//       flueGas,
//       1e5,
//       T_FG_nom,
//       xi_nom) "Outlet specific enthalpy";
//final parameter ClaRa.Basics.Units.MassFlowRate m_flow_FG_out=m_flow_FG_nom;

  //  h=h_FG_out,
  ClaRa.StaticCycles.Fundamentals.FuelSignal_black_b fuelSignal_black(
    fuelModel=fuelModel,
    m_flow=m_flow_fuel,
    xi=xi_fuel) annotation (Placement(transformation(extent={{100,-10},{108,10}}), iconTransformation(extent={{100,-10},{108,10}})));
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
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
       Text(
          extent={{-60,60},{60,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%m_flow_fuel"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%xi_fuel"),
        Line(points={{60,100},{100,0},{60,-100}}, color={0,0,0})}),
                                                                 Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));

end Source_black;
