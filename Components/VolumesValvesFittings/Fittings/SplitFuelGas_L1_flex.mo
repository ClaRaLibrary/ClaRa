within ClaRa.Components.VolumesValvesFittings.Fittings;
model SplitFuelGas_L1_flex "A split for fuel dust"
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

//  extends ClaRa.Basics.Interfaces.DataInterfaceVector(N_sets=N_ports_out);
  extends ClaRa.Basics.Icons.Adapter5_fw;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  outer ClaRa.SimCenter simCenter;

  model Coal "Summary for coal flow"
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate"
      annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific LHV annotation (Dialog);
  end Coal;

   inner model Summary
   parameter Integer N_ports_out;
   extends ClaRa.Basics.Icons.RecordIcon;
   Coal inlet;
   Coal outlet[N_ports_out];
   end Summary;

  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1   "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
inner parameter TILMedia.GasTypes.BaseGas gasModel = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Integer N_ports_out(min=1)=1 "Number of outlet  ports" annotation(Evaluate=true, Dialog(tab="General",group="Fundamental Definitions"));//connectorSizing=true,
  parameter Real K_split[N_ports_out-1] = fill(0, N_ports_out-1) "fixed split ratio" annotation(Dialog(tab="General",group="Fundamental Definitions"));

  ClaRa.Basics.Interfaces.FuelFlueGas_inlet inlet(fuelModel=fuelModel, flueGas(Medium=gasModel)) "Inlet port" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FuelFlueGas_outlet outlet[N_ports_out](each fuelModel=fuelModel, each flueGas(Medium=gasModel)) "Outlet port" annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Media.FuelObject coal(
    fuelModel=fuelModel,
    p=inlet.fuel.p,
    T=noEvent(actualStream(inlet.fuel.T_outflow)),
    xi_c=noEvent(actualStream(inlet.fuel.xi_outflow))) annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));

//   inner Summary    summary(N_ports_out=N_ports_out,inlet(m_flow=inlet.fuel.m_flow + inlet.flueGas.m_flow,  T=noEvent(actualStream(inlet.fuel.T_outflow)), p=inlet.p, LHV=coal.LHV),
//                            outlet(m_flow=outlet.fuel.m_flow + outlet.flueGas.m_flow,  T=noEvent(actualStream(outlet.fuel.T_outflow)), p=outlet.flueGas.p, each LHV=coal.LHV))

equation
//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~
  for i in 1:N_ports_out-1 loop
    outlet[i].fuel.T_outflow = inStream(inlet.fuel.T_outflow);
    outlet[i].fuel.m_flow = -K_split[i]*inlet.fuel.m_flow;
    outlet[i].fuel.xi_outflow = inStream(inlet.fuel.xi_outflow);
    outlet[i].flueGas.T_outflow = inStream(inlet.flueGas.T_outflow);
    outlet[i].flueGas.m_flow = -K_split[i]*inlet.flueGas.m_flow;
    outlet[i].flueGas.xi_outflow = inStream(inlet.flueGas.xi_outflow);

  end for;
  outlet[N_ports_out].fuel.T_outflow = inStream(inlet.fuel.T_outflow);
  outlet[N_ports_out].fuel.m_flow = -(1-sum( K_split))*inlet.fuel.m_flow;
  outlet[N_ports_out].fuel.xi_outflow = inStream(inlet.fuel.xi_outflow);
  outlet[N_ports_out].flueGas.T_outflow = inStream(inlet.flueGas.T_outflow);
  outlet[N_ports_out].flueGas.m_flow = -(1-sum( K_split))*inlet.flueGas.m_flow;
  outlet[N_ports_out].flueGas.xi_outflow = inStream(inlet.flueGas.xi_outflow);

  inlet.fuel.p = outlet[1].fuel.p;
  inlet.fuel.T_outflow=1000; // dummy, backflow is not supported
  inlet.fuel.xi_outflow = fuelModel.defaultComposition; // dummy, backflow is not supported;
  inlet.flueGas.p = outlet[1].flueGas.p;
  inlet.flueGas.T_outflow=1000; // dummy, backflow is not supported
  inlet.flueGas.xi_outflow = gasModel.xi_default; // dummy, backflow is not supported;

    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
<p>Friedrich Gottelt, Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH, Copyright &copy; 2019-2020</p>
<p><a href=\"http://www.fvtr.de\">www.fvtr.de</a>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH for industry projects in cooperation with Lausitz Energie Kraftwerke AG, Cottbus.</p>
<b>Acknowledgements:</b>
<p>This model contribution is sponsored by Lausitz Energie Kraftwerke AG.</p>

<p><a href=\"http://www.leag.de\">www.leag.de</a> </p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>", revisions="<html>
<body>
<table>
  <tr>
    <th style=\"text-align: left;\">Date</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Version</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Author</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Affiliation</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Changes</th>
  </tr>
  <tr>
    <td>2020-08-20</td>
    <td> </td>
    <td>ClaRa 1.6.0</td>
    <td> </td>
    <td>Friedrich Gottelt</td>
    <td> </td>
    <td>FVTR GmbH</td>
    <td> </td>
    <td>Initial version of model</td>
  </tr>
</table>
<p>Version means first ClaRa version where the applied change was published.</p>
</body>
</html>"),Placement(transformation(extent={{-60,-102},{-40,-82}})),
              Icon(graphics), Diagram(graphics));
end SplitFuelGas_L1_flex;
