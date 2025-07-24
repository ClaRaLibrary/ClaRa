within ClaRa.Basics.ControlVolumes.SolidVolumes;
model NTU_L2_effectiveResistance "NTU  using an effective nominal  value for the product of heat transport coefficient and the heat transfer area"
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

  outer ClaRa.SimCenter simCenter;
  extends ClaRa.Basics.Icons.NTU;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");

replaceable model Material = TILMedia.Solid.Types.TILMedia_Aluminum
                                                                   constrainedby TILMedia.Solid.Types.BaseSolid
                                                                                                               "Material of the cylinder"
                               annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

//_____________fundamental definitions_________________________________________//
  replaceable model HeatExchangerType =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger "Type of HeatExchanger"
                                                                                       annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

//______________geometry definitions___________________________________________//
  parameter Units.Mass mass_struc=0 "Mass of inner components (tubes + structural elements)" annotation (Dialog(group="Geometry"));
  final parameter Units.Mass mass=mass_struc "Total mass of HEX (dry)";

  //parameter Real CF_geo=1 "Correction coefficient due to fins etc.";
  parameter ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom "The product kA - nominal value" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Real CL_kA_mflow[:,2]=[0.4, 0.5; 0.5, 0.75; 0.75, 0.95; 1, 1] "Characteristic line kA = f(m_flow/m_flow_nom)"
                                                    annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean innerSideLimitsHeatFlow = true "True if the inner side heat transfer limits overall performance" annotation(Dialog(tab="General", group="Fundamental Definitions"));
  parameter Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rate at tube side" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
 parameter Integer stateLocation=1 "Location of the states" annotation(Dialog(group="Geometry"),choices(choice = 1 "States on outer surfaces",
                                                                                            choice = 2 "Inner location of states"));
//______________Initialisation______________________________________________//
  parameter Units.Temperature T_w_i_start=293.15 "Initial temperature at inner phase" annotation (Dialog(group="Initialisation"));
  parameter Units.Temperature T_w_a_start=293.15 "Initial temperature at outer phase" annotation (Dialog(group="Initialisation"));
  inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state"));

//______________Visualisation______________________________________________//
 parameter Boolean showExpertSummary = false "|Summary and Visualisation||True, if expert summary should be applied";

//______________Inputs_____________________________________________________//
  input Units.Temperature T_i_in "Inlet temperature of inner flow" annotation (Dialog(group="Input"));
  input Units.Temperature T_a_in "Inlet temperature of outer flow" annotation (Dialog(group="Input"));

  input Units.MassFlowRate m_flow_i "Mass flow rate of inner side" annotation (Dialog(group="Input"));
  input Units.MassFlowRate m_flow_a "Mass flow rate of outer side" annotation (Dialog(group="Input"));

  input Units.HeatCapacityMassSpecific cp_mean_i "Mean cp of inner flow" annotation (Dialog(group="Input"));
  input Units.HeatCapacityMassSpecific cp_mean_a "Mean cp of outer flow" annotation (Dialog(group="Input"));

//______________Variables__________________________________________________//
  Units.Temperature T_i_out "Outlet temperature of steady state inner flow";
  Units.Temperature T_a_out "Outlet temperature of steady state outer flow";
  Units.HeatFlowRate Q_flow_NTU_1 "Steady state heat flow rate outer to inner phase";

  Real effectiveness "Heat exchanger efficiency";

protected
  Units.Temperature T_w_i(start=T_w_i_start) "Wall temperature at inner phase";
  Units.Temperature T_w_a(start=T_w_a_start) "Wall temperature at outer phase";

  Real R_1 "Aspect ratio of heat capacity rates W1/W2<1";
//  Real R_2 "Aspect ratio of heat capacity flow rates W2/W1";

  Real NTU_1 "Number of Transfer Units related to the flow 1";
  Real NTU_2 "Number of Transfer Units related to flow 2";
  Real NTU_ctr "Number of Transfer Units related to the flow 1 for pure counter flow";

  Real C_flow_1(unit="W/K") "Smaller heat capacity rate";
  Real C_flow_2(unit="W/K") "Larger heat capacity rate";
  Real k=(0.5*mass*solid.cp)/100;
public
  ClaRa.Basics.Interfaces.HeatPort_a
                                   outerPhase "outer side of cylinder"
                                         annotation (Placement(transformation(
          extent={{-10,80},{10,100}}, rotation=0)));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   innerPhase "inner side of cylinder"
                                         annotation (Placement(transformation(
          extent={{-10,-100},{10,-80}},
                                      rotation=0)));
  TILMedia.Solid.Solid solid(redeclare replaceable model SolidType = Material, T=(T_w_i + T_w_a)/2)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  HeatExchangerType heatExchangerType(NTU_1=NTU_ctr,
                                                   R_1=R_1) annotation (Placement(transformation(
          extent={{20,20},{40,40}},   rotation=0)));


  Modelica.Blocks.Tables.CombiTable1Dv partLoad_kA(columns={2}, table=CL_kA_mflow) annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

public
model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter Boolean showExpertSummary;
  input Real NTU_1 if showExpertSummary "Number of Transfer Units related to the flow 1";
  input Real NTU_2 if showExpertSummary "Number of Transfer Units related to flow 2";

  input Real C_flow_low(unit="W/K") if showExpertSummary "Smaller heat capacity rate";
  input Real C_flow_high(unit="W/K") if showExpertSummary "Larger heat capacity rate";

  input Units.Temperature T_i_out "Outlet temperature of steady state inner flow";
  input Units.Temperature T_o_out "Outlet temperature of steady state outer flow";
  input ClaRa.Basics.Units.HeatCapacityFlowRate kA_nom "The product of thermal transmission and heat transfer area";
  input Real effectiveness "Heat exchanger efficiency";
  input Units.HeatFlowRate Q_flow "Steady state heat flow rate outer to inner phase";
  input Units.HeatCapacityMassSpecific cp_mean_i "Mean cp of inner flow";
  input Units.HeatCapacityMassSpecific cp_mean_a "Mean cp of outer flow";
  input Units.DensityMassSpecific d "Material density";
end Summary;

Summary summary(showExpertSummary=showExpertSummary,C_flow_low=C_flow_1,C_flow_high=C_flow_2,NTU_1=NTU_1,NTU_2=NTU_2,T_i_out=T_i_out,T_o_out=T_a_out,kA_nom=kA_nom,effectiveness=effectiveness,Q_flow=Q_flow_NTU_1, cp_mean_i=cp_mean_i,cp_mean_a=cp_mean_a, d=solid.d)
annotation(Placement(transformation(extent={{-100,-102},{-80,-82}})));

initial equation
   if initOption == 1 then //steady state
    der(T_w_i)=0;
    der(T_w_a)=0;
   elseif initOption == 0 then //no init
   // do nothing
   else
    assert(initOption == 0,"Invalid init option");
   end if;

equation

  // connect the characteristic line to the inlet mass flow rate at tube side:___
  partLoad_kA.u[1] = if innerSideLimitsHeatFlow then m_flow_i/m_flow_nom else m_flow_a/m_flow_nom;
  //variables of the NTU method:
  C_flow_1=noEvent(min(cp_mean_i*abs(m_flow_i), cp_mean_a*abs(m_flow_a)));
  C_flow_2=noEvent(max(cp_mean_i*abs(m_flow_i), cp_mean_a*abs(m_flow_a)));

  R_1=(C_flow_1+1e-3)/(C_flow_2+1e-3);
//  R_2=C_flow_2/C_flow_1;

//Wall temperatures:
  if stateLocation == 1 then
    innerPhase.T = T_w_i;
    outerPhase.T = T_w_a;
  else
    innerPhase.Q_flow=k*(innerPhase.T-T_w_i);
    outerPhase.Q_flow=k*(outerPhase.T-T_w_a);
  end if;

//Number of Transfer Units:
  NTU_1 = kA_nom*partLoad_kA.y[1]/(C_flow_1+1e-3)*heatExchangerType.CF_NTU;
  NTU_2 = kA_nom*partLoad_kA.y[1]/(C_flow_2+1e-3)*heatExchangerType.CF_NTU;

//Number of Transfer Units for pure counter flow:
  NTU_ctr = kA_nom*partLoad_kA.y[1]/(C_flow_1+1e-3);

  effectiveness = (1 - exp(-NTU_1*(1-R_1)))/max(Modelica.Constants.eps,1 - R_1*exp(-NTU_1*(1-R_1))); //for CounterFlow
//heat flow from flow 1 to flow 2:
  T_i_out = noEvent(if cp_mean_i*abs(m_flow_i) < cp_mean_a*abs(m_flow_a) then T_i_in-effectiveness*(T_i_in - T_a_in) else T_i_in + Q_flow_NTU_1/(C_flow_2+1e-3));
  T_a_out = noEvent(if cp_mean_i*abs(m_flow_i) > cp_mean_a*abs(m_flow_a) then T_a_in+effectiveness*(T_i_in - T_a_in) else T_a_in - Q_flow_NTU_1/(C_flow_2+1e-3));

//Heat flow rate using the effectiveness of the heat exchanger
   Q_flow_NTU_1=effectiveness*C_flow_1*(T_a_in-T_i_in);
//Energy Balance:
    der(T_w_i)=(innerPhase.Q_flow+Q_flow_NTU_1)/(0.5 * mass*solid.cp);
    der(T_w_a)=(outerPhase.Q_flow-Q_flow_NTU_1)/(0.5 * mass*solid.cp);
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
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics), Icon(graphics,
                                         coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end NTU_L2_effectiveResistance;
