within ClaRa.Components.Adapters;
model FuelSlagFlueGas_join
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
  extends ClaRa.Basics.Icons.Adapter3_bw;
 //__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1   "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  inner parameter ClaRa.Basics.Media.Slag.PartialSlag slagType=simCenter.slagModel "Slag properties" annotation (choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));
  inner parameter TILMedia.Gas.Types.BaseGas flueGas=simCenter.flueGasModel "Medium to be used in tubes"
    annotation (choicesAllMatching, Dialog(group="Fundamental Medium Definitions"));

  ClaRa.Basics.Interfaces.Fuel_inlet fuel_inlet(fuelModel=fuelModel)
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  ClaRa.Basics.Interfaces.GasPortIn flueGas_inlet(Medium=flueGas)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Basics.Interfaces.Slag_outlet      slag_outlet(slagType=slagType)
                                               annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}),
                        iconTransformation(extent={{-110,-10},{-90,10}})));

  ClaRa.Basics.Interfaces.FuelSlagFlueGas_outlet      fuelSlagFlueGas_outlet(
    flueGas(Medium=flueGas),
     fuelModel=fuelModel,
    final slagType=slagType)                                                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,0})));

equation
  fuelSlagFlueGas_outlet.flueGas.m_flow = -flueGas_inlet.m_flow;
  fuelSlagFlueGas_outlet.flueGas.T_outflow = inStream(flueGas_inlet.T_outflow);
  flueGas_inlet.T_outflow = inStream(fuelSlagFlueGas_outlet.flueGas.T_outflow);
  fuelSlagFlueGas_outlet.flueGas.xi_outflow = inStream(flueGas_inlet.xi_outflow);
  flueGas_inlet.xi_outflow = inStream(fuelSlagFlueGas_outlet.flueGas.xi_outflow);
  fuelSlagFlueGas_outlet.flueGas.p = flueGas_inlet.p;

  fuelSlagFlueGas_outlet.fuel.m_flow = -fuel_inlet.m_flow;
  fuelSlagFlueGas_outlet.fuel.T_outflow = inStream(fuel_inlet.T_outflow);
  fuel_inlet.T_outflow = inStream(fuelSlagFlueGas_outlet.fuel.T_outflow);
  fuelSlagFlueGas_outlet.fuel.xi_outflow = inStream(fuel_inlet.xi_outflow);
  fuel_inlet.xi_outflow = inStream(fuelSlagFlueGas_outlet.fuel.xi_outflow);
  fuelSlagFlueGas_outlet.fuel.p = fuel_inlet.p;

  fuelSlagFlueGas_outlet.slag.m_flow = -slag_outlet.m_flow;
  fuelSlagFlueGas_outlet.slag.T_outflow = inStream(slag_outlet.T_outflow);
  slag_outlet.T_outflow = inStream(fuelSlagFlueGas_outlet.slag.T_outflow);
  fuelSlagFlueGas_outlet.slag.p = slag_outlet.p;

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
   Icon(graphics),               Diagram(graphics));
end FuelSlagFlueGas_join;
