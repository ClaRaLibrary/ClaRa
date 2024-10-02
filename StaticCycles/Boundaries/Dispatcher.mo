within ClaRa.StaticCycles.Boundaries;
model Dispatcher "Ideal fuel dispatcher"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under the 3-clause BSD License.   //
// Copyright © 2013-2016, DYNCAP/DYNSTART research team.                     //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  import ClaRa.Basics.Constants.*;
  import ClaRa.Basics.Media.FuelFunctions.massFraction_i_xi;
  import ClaRa.Basics.Media.FuelFunctions.LHV_pTxi;
  outer ClaRa.SimCenter simCenter;
  outer parameter Real P_target_ "Target power in p.u." annotation(Dialog(group="Part Load Definition"));



  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific LHV=LHV_pTxi(
      p,
      T,
      xi_c,
      fuelModel) "Nominal lower heating value" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.MassFraction xi_c[fuelModel.N_c - 1]=fuelModel.defaultComposition "Fuel composition" annotation (Dialog(group="Fundamental Definitions"));
  parameter Integer N_burner_levels = 1  "Number of burner levels" annotation(Dialog(group="Fundamental Definitions"));

  parameter TILMedia.GasTypes.BaseGas flueGas = simCenter.flueGasModel "Flue gas model used in component" annotation(Dialog(group="Combustion Air"));
  parameter ClaRa.Basics.Units.MassFraction xi_pa_in[flueGas.nc - 1]={0,0,0,0,0.77,0.23,0,0,0} "Primary air inlet composition" annotation (Dialog(group="Combustion Air"));
  parameter Real lambda = 1.15 "Excess air" annotation(Dialog(group="Combustion Air"));

  parameter ClaRa.Basics.Units.Power P_el_nom "Nominal electric power" annotation (Dialog(group="Nominal Operation Point"));
  parameter Real eta_el_nom "Nominal plant efficiency" annotation(Dialog(group="Nominal Operation Point"));

  parameter Real CharLine_P_el_[:,2]=[0,1;1,1] "Characteristic line of P_el as function of P_target_" annotation(Dialog(group="Part Load Definition"));
  parameter Real CharLine_eta_el_[:,2]=[0,1;1,1] "Characteristic line of eta_el as function of P_target_" annotation(Dialog(group="Part Load Definition"));

  final parameter ClaRa.Basics.Units.Power P_el(fixed=false) "Electric power";
  final parameter Real eta_el(fixed=false) "Plant efficiency";

  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel=P_el/(eta_el*LHV)/N_burner_levels "Fuel mass flow (per burner level)";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_pa=Pi_m_flows*m_flow_fuel "Rprt: Primary air mass flow (per burner level)";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow_fg_total=(m_flow_fuel + m_flow_pa)*N_burner_levels "Total flue gass implied by all mills";

  final parameter Real Pi_m_flows = lambda*(n_flow_C_primary + n_flow_H_primary/4.0 + n_flow_S_primary - n_flow_O_primary/2)*ClaRa.Basics.Constants.M_O *2.0/max(1e-32,xi_pa_in[6])/m_flow_fuel;

  ClaRa.StaticCycles.Fundamentals.FuelSignal_black_b fuelSignal_black[N_burner_levels]( each
    fuelModel=fuelModel,
    each m_flow=m_flow_fuel,
    each xi=xi_c) annotation (Placement(transformation(extent={{100,-10},{108,10}}), iconTransformation(extent={{100,-10},{108,10}})));

protected
  final parameter Real n_flow_C_primary= massFraction_i_xi(xi_c, 1, fuelModel).*m_flow_fuel/M_C;
  final parameter Real n_flow_H_primary= massFraction_i_xi(xi_c, 2, fuelModel).*m_flow_fuel/M_H;
  final parameter Real n_flow_O_primary= massFraction_i_xi(xi_c, 3, fuelModel).*m_flow_fuel/M_O;
  final parameter Real n_flow_S_primary= massFraction_i_xi(xi_c, 5, fuelModel).*m_flow_fuel/M_S;
  Modelica.Blocks.Tables.CombiTable1Dv table1(table=CharLine_P_el_, u={P_target_});
  Modelica.Blocks.Tables.CombiTable1Dv table2(table=CharLine_eta_el_, u={P_target_});
  constant ClaRa.Basics.Units.Pressure p=1e5;
  constant ClaRa.Basics.Units.Temperature T=273.15;

initial equation
  P_el= P_el_nom*table1.y[1];
  eta_el= eta_el_nom*table2.y[1];

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
   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-300,-100},{100,100}}),
                   graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,131,169},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(points={{-80,60},{80,60},{-80,-60},{80,-60}}, color={0,131,169}),
        Text(
          extent={{-300,100},{-128,0}},
          lineColor={28,108,200},
          textString=DynamicSelect("",String(m_flow_fuel,format="1.2f") +" kg/s")),
        Text(
          extent={{-300,0},{-100,-100}},
          lineColor={28,108,200},
          textString=DynamicSelect("",String(LHV/1e6,format="1.2f") +" MJ/kg"))}),
                         Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics));
end Dispatcher;
