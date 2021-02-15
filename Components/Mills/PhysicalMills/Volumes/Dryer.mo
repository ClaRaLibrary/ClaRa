within ClaRa.Components.Mills.PhysicalMills.Volumes;
model Dryer "Aerosol component | dryer | for replaceable coal drying processes | respects thermal losses"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.6.0                           //
//                                                                          //
// Licensed by the ClaRa development team under Modelica License 2.         //
// Copyright  2013-2021, ClaRa development team.                            //
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

  //-------------------------------------------------------------------------------
  //fundamental definitions
  parameter TILMedia.GasTypes.BaseGas gas= simCenter.flueGasModel "Medium model" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Fundamentals.Records.FuelClassification_base classification=Fundamentals.Records.FuelClassification_example_21classes() annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  //-------------------------------------------------------------------------------
  //replaceable models
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "1st: pressure loss model | 2nd: edit corresponding record" annotation (Dialog(group="Replaceable Models"), choicesAllMatching=true);
  PressureLoss pressureLoss "Pressure loss model" annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  replaceable model Drying =  Fundamentals.Drying.Drying_ideal constrainedby Fundamentals.Drying.Drying_base                                                                         annotation(Dialog(group="Replaceable Models"),choicesAllMatching=true);
  Drying drying annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  replaceable model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry(volume=volume,A_cross=Modelica.Constants.pi*1^2) constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record" annotation (Dialog(group="Geometry"), choicesAllMatching=true);
  inner Geometry geo annotation(Placement(transformation(extent={{-80,60},{-60,80}})));

  replaceable model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2 "1st: heat transfer model | 2nd: edit corresponding record" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2
               heattransfer annotation (Placement(transformation(extent={{-20,60},{0,80}})));

 ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 cylindricalThickWall_L4_1(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    diameter_o=3.1,
    diameter_i=3,
    length=1.5*15,
    T_start={T_start},
    mass_struc=mass_mill - cylindricalThickWall_L4_1.solid[cylindricalThickWall_L4_1.N_rad].d*Modelica.Constants.pi/4*(cylindricalThickWall_L4_1.diameter_o^2-cylindricalThickWall_L4_1.diameter_i^2)*cylindricalThickWall_L4_1.length*cylindricalThickWall_L4_1.N_tubes)
                   annotation (Placement(transformation(
        extent={{-11,8},{11.0001,-8}},
        rotation=90,
        origin={28,70.9999})));

  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation"));

//iComs: ------------------------------------------------------------------------------------

  inner ClaRa.Basics.Records.IComBase_L2 iCom(
    p_in=gasInlet.p,
    T_in=T_gas_in,
    m_flow_in=gasInlet.m_flow,
    p_out=gasOutlet.p,
    T_out=T,
    m_flow_out=gasOutlet.m_flow,
    T_bulk=gasBulk.T,
    p_bulk=gasBulk.p,
    m_flow_nom=m_flow_gas_nom) annotation (Placement(transformation(extent={{60,-84},{80,-64}})));

  inner Fundamentals.Records.iCom_Dryer iComDryer(
    mediumModel=gas,
    fuelModel=fuelModel,
    xi_gas_in=xi_gas_in,
    xi_gas_out_s=gasBulk.xi_s,
    xi_fuel_in=xi_wf_in,
    m_flow_H2O_evap=m_flow_H2O_evap,
    m_flow_gas_in=gasInlet.m_flow,
    m_flow_fuel_in=fuelInlet.m_flow) annotation (Placement(transformation(extent={{-10,16},{10,36}})));

//_______Nominal Values_______________
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel_nom= 10 "Nominal mass flow rates at inlet" annotation(Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_gas_nom= 10 "Nominal mass flow rates at inlet" annotation(Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.Power P_grinding_nom = 460e3 "Nominal electrical Power for Grinding" annotation(Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.Power Q_steamGenerator_nom = 2200 "Nominal effective thermal Power of Steam Generator in MW" annotation(Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.Mass mass_mill = 116e3 "Total mass of mill construction" annotation(Dialog(group="Nominal Values"));

//_______Geometry_______________
  parameter ClaRa.Basics.Units.Volume volume = 10 "volume of control volume" annotation(Dialog(group="Geometry"));

//_______Initial Conditions_______________
  parameter ClaRa.Basics.Units.Pressure p_start=1.013e5 "Initial value for air pressure" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Temperature T_start = simCenter.T_amb_start "initial temperature in drying zone" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_H2O_evap_start = 1.5 "initianl mass flow rate of evaporated coal H2O" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_gas_in_start[gas.nc-1] = {0,0,0,0,0.79,0.21,0,0,0} "initial composition of incoming air" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_gas_out_start[gas.nc-1] = {0,0,0,0,0.79,0.21,0,0.2,0} "initial composition of outgoing air" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Mass mass_fuel_start = 100 "initial fuel mass" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Mass mass_gas_start = 100 "initial gas mass" annotation(Dialog(tab="Initialisation"));

//_______Powers____________
  ClaRa.Basics.Units.Power P_grinding "Actual electrical Power for Grinding";
  parameter ClaRa.Basics.Units.Power Q_loss = -1 * 0.25 * 0.13 * 0.022 * Q_steamGenerator_nom^0.7 *1e6 "Thermal Loss: Number of Mills, Coefficient for Mills, Coefficient C=0.0220 from DIN EN 12952-15, Nominal effective thermal Power of Steam Generator in MW";

//_______Pressures____________
  ClaRa.Basics.Units.Pressure p(start=p_start) "Gas Pressure";

//_______Masses_______________
  ClaRa.Basics.Units.Mass mass_fuel(start = mass_fuel_start);
  ClaRa.Basics.Units.Mass mass_gas(start = mass_gas_start);
  Real drhodt "Density derivative";

//________Mass Flows___________
  ClaRa.Basics.Units.MassFlowRate m_flow_H2O_evap(start=m_flow_H2O_evap_start) "Mass flow rate of evaporated coal H2O //m_flow_evap";

//________Mass Fractions_______
  ClaRa.Basics.Units.MassFraction xi_wf_in[fuelModel.N_c-1] "Mositure content of incoming wet fuel";
  ClaRa.Basics.Units.MassFraction xi_df_out[fuelModel.N_c-1] "Mositure content of leaving dried fuel";
  ClaRa.Basics.Units.MassFraction xi_gas_in[gas.nc-1](start=xi_gas_in_start) "Composition of incoming air";
  ClaRa.Basics.Units.MassFraction xi_gas_out[gas.nc-1](start=xi_gas_out_start) "Composition of outgoing air";
  ClaRa.Basics.Units.MassFraction xi_bulk[gas.nc-1](start=xi_gas_out_start);

//________Temperatures_________
  ClaRa.Basics.Units.Temperature T( start=T_start) "Classifier Temperature (outlet temperature)";
  ClaRa.Basics.Units.Temperature T_gas_in( start=T_start) "Primary air inlet temperature";
  ClaRa.Basics.Units.Temperature T_wf_in( start=T_start) "Coal inlet temperature";

protected
   final parameter ClaRa.Basics.Units.EnthalpyMassSpecific Delta_h_evap = fuelModel.C_LHV[fuelModel.waterIndex];

  //Ports: ----------------------------------------------------------------------------------------------------------------------
public
  Basics.Interfaces.FuelInletDistr fuelInlet(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Basics.Interfaces.FuelOutletDistr fuelOutlet(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{90,10},{110,30}})));
  ClaRa.Basics.Interfaces.GasPortIn gasInlet(Medium=gas) annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  ClaRa.Basics.Interfaces.GasPortOut gasOutlet(Medium=gas) annotation (Placement(transformation(extent={{90,-50},{110,-30}})));

  //Gas: ------------------------------------------------------------------------------------------------------------------------
  TILMedia.Gas_pT     gasIn(
     gasType=gas,
     p=gasInlet.p,
     T=noEvent(actualStream(gasInlet.T_outflow)),
     xi=noEvent(actualStream(gasInlet.xi_outflow)))
     annotation (Placement(transformation(extent={{-80,-52},{-60,-32}})));

  TILMedia.Gas_pT     gasOut(
     T=noEvent(actualStream(gasOutlet.T_outflow)),
     gasType=gas,
     p=gasOutlet.p,
     xi=noEvent(actualStream(gasOutlet.xi_outflow)))
     annotation (Placement(transformation(extent={{60,-52},{80,-32}})));

  TILMedia.Gas_pT gasBulk(
    T=T,
    gasType=gas,
    p=p,
    xi=xi_bulk) annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));

  //Fuel: -----------------------------------------------------------------------------------------------------------------------
  ClaRa.Basics.Media.FuelObject fuelIn(
    p=fuelInlet.p,
    T=noEvent(actualStream(fuelInlet.T_outflow)),
    xi_c=noEvent(actualStream(fuelInlet.xi_outflow))) annotation (Placement(transformation(extent={{-80,8},{-60,28}})));

  ClaRa.Basics.Media.FuelObject fuelOut(
    p=fuelOutlet.p,
    T=noEvent(actualStream(fuelOutlet.T_outflow)),
    xi_c=noEvent(actualStream(fuelOutlet.xi_outflow))) annotation (Placement(transformation(extent={{60,8},{80,28}})));

  //Summary: --------------------------------------------------------------------------------------------------------------------
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow_H2O_evap "Mass flow rate of evaporated coal H2O //m_flow_evap";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeGas gasInlet;
    ClaRa.Basics.Records.FlangeGas gasOutlet;
  end Summary;

  Summary summary(outline(m_flow_H2O_evap=m_flow_H2O_evap),
                  gasInlet(mediumModel=gas, m_flow=gasInlet.m_flow, T=gasIn.T, p=gasInlet.p, h=gasIn.h, xi=gasIn.xi, H_flow=gasIn.h*gasInlet.m_flow),
                  gasOutlet(mediumModel=gas, m_flow=gasOutlet.m_flow, T=gasOut.T, p=gasOutlet.p, h=gasOut.h, xi=gasOut.xi, H_flow=gasOut.h*gasOutlet.m_flow)) annotation (Placement(transformation(extent={{-80,-84},{-60,-64}})));

  //Thermal loss: ---------------------------------------------------------------------------------------------------------------
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=Q_loss) annotation (Placement(transformation(extent={{80,60},{60,80}})));

equation

  // P_grinding and Q_loss according to F. Brandt, Dampferzeuger (FDBR-Fachbuch Band 3), 1992
  // Actual Grinding Power scaled by coal mass flow; 10 % of P_grinding for idle operation
  P_grinding = P_grinding_nom*0.9 * fuelInlet.m_flow/m_flow_fuel_nom + P_grinding_nom*0.1;

  //Global Energy Balance: -----------------------------------------------------------------------------------------------------------------------------------
  der(T)*(gasBulk.cp*mass_gas + fuelOut.cp*mass_fuel) = gasInlet.m_flow*gasIn.h + fuelInlet.m_flow*fuelIn.h + gasOutlet.m_flow*gasOut.h + fuelOutlet.m_flow*fuelOut.h + m_flow_H2O_evap*Delta_h_evap + P_grinding + heattransfer.heat.Q_flow;

  //Gas Mass Balance: -----------------------------------------------------------------------------------------------------------------------------------
  mass_gas =volume*gasBulk.d;
  drhodt =gasBulk.drhodh_pxi*gasBulk.cp*der(T) + gasBulk.drhodp_hxi*der(gasBulk.p) + sum({gasBulk.drhodxi_ph[i]*der(gasBulk.xi[i]) for i in 1:gas.nc - 1});
  drhodt * volume = gasInlet.m_flow + gasOutlet.m_flow + m_flow_H2O_evap;

  //Fuel Mass Balance: -----------------------------------------------------------------------------------------------------------------------------------
  der(mass_fuel) = fuelInlet.m_flow + fuelOutlet.m_flow - m_flow_H2O_evap;
  der(mass_fuel) = 0;

  //Gas Composition Balance: -----------------------------------------------------------------------------------------------------------------------------------
  //xi_bulk = {0,0,0,0,0.79,0.21,0,0,0};
  der(xi_bulk) = 1/mass_gas * (gasInlet.m_flow*(gasIn.xi-xi_bulk) + gasOutlet.m_flow*(gasOut.xi-xi_bulk) + m_flow_H2O_evap * (cat(1,zeros(gas.condensingIndex - 1), {1}, zeros(gas.nc - gas.condensingIndex - 1)) - xi_bulk));

  //Gas Composition: -----------------------------------------------------------------------------------------------------------------------------------
  xi_gas_in = actualStream(gasInlet.xi_outflow);
  xi_gas_out * abs(gasOutlet.m_flow) = (gasInlet.m_flow * xi_gas_in + m_flow_H2O_evap * cat(1,zeros(gas.condensingIndex - 1), {1}, zeros(gas.nc - gas.condensingIndex - 1)));

  //Fuel Composition: -----------------------------------------------------------------------------------------------------------------------------------
  xi_wf_in = inStream(fuelInlet.xi_outflow);
  xi_df_out * abs(fuelOutlet.m_flow) = (fuelInlet.m_flow * xi_wf_in - m_flow_H2O_evap*cat(1,zeros(fuelModel.waterIndex-1), if fuelModel.waterIndex < fuelModel.N_c then {1} else zeros(0), zeros(max(0,fuelModel.N_c - fuelModel.waterIndex - 1))));

//------------------------------------------------------------------------------------------------------------------------

  //Fuel boundary conditions:
  fuelOutlet.p = fuelInlet.p;

  fuelOutlet.T_outflow = T;
  fuelInlet.T_outflow = T;
  T_wf_in = inStream(fuelInlet.T_outflow);

  fuelOutlet.xi_outflow = xi_df_out;
  fuelInlet.xi_outflow = xi_df_out;

  fuelOutlet.classFraction_outflow = inStream(fuelInlet.classFraction_outflow);
  fuelInlet.classFraction_outflow = inStream(fuelOutlet.classFraction_outflow);

  //Gas boundary conditions:
  gasInlet.p = p + pressureLoss.Delta_p;
  gasOutlet.p = p;

  gasInlet.T_outflow= T;
  gasOutlet.T_outflow = T;

  gasInlet.xi_outflow = xi_bulk;
  gasOutlet.xi_outflow = xi_bulk;

  T_gas_in = inStream(gasInlet.T_outflow);

  connect(heattransfer.heat, cylindricalThickWall_L4_1.innerPhase) annotation (Line(
      points={{0,70},{20.32,70},{20.32,70.7799}},
      color={167,25,48},
      thickness=0.5));
  connect(cylindricalThickWall_L4_1.outerPhase, fixedHeatFlow.port) annotation (Line(
      points={{36.1067,70.9999},{48,70.9999},{48,70},{60,70}},
      color={167,25,48},
      thickness=0.5));
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
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
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,60},{74,60},{100,40},{68,20},{-22,20},{-38,10},{-100,10},{-100,56},{-100,60}},
          fillColor={73,80,85},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-22,20},{2,-4},{68,-4},{82,-14},{-12,-14},{-36,10},{-100,10},{-100,20},{-22,20}},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-100,-14},{82,-14},{100,-26},{66,-46},{-100,-46},{-100,-14}},
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),                           Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(extent={{-24,96},{86,52}},lineColor={28,108,200}), Text(
          extent={{-24,96},{16,90}},
          lineColor={28,108,200},
          textString="Thermal Masses")}));
end Dryer;
