within ClaRa.Components.Electrical;
model AsynchronousMotor_L2_base "Base class of simple asynchronous e-motor"
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
  extends ClaRa.Basics.Icons.Motor;

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_elMech=0,
    powerOut_th=0,
    powerAux=summary.P_term)                                                                                               if contributeToCycleSummary;

  import ClaRa.Basics.Units;
  import Modelica.Constants.pi;

  outer ClaRa.SimCenter simCenter;

/////////////////Parameters/////////////////////////////////////
  parameter Boolean activateHeatPort = false "True if losses are extracted through heat connector" annotation(Dialog(group="Fundamental Definitions"));
  parameter Basics.Units.Power P_nom "Nominal power" annotation (Dialog(group="Fundamental Definitions"));
  parameter Basics.Units.Torque tau_bd_nom "Nominal breakdown torque" annotation (Dialog(group="Fundamental Definitions"));
  parameter Integer N_pp "Number of pole pairs of motor"
                                                        annotation(Dialog(group="Fundamental Definitions"));
  parameter Basics.Units.RPM rpm_nom "nominal speed" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real cosphi(min=0, max=1) "Efficiency factor" annotation(Dialog(group="Fundamental Definitions"));
  parameter Basics.Units.Efficiency eta_stator "Lumped constant stator efficiency" annotation (Dialog(group="Fundamental Definitions"));
  parameter Basics.Units.MomentOfInertia J=1500 "Moment of inertia" annotation (Dialog(group="Fundamental Definitions"));

  inner parameter Basics.Units.Frequency f_term_nom=50 "Nominal excitation frequency" annotation (Dialog(group="Electrics Definitions"));
  parameter Basics.Units.ElectricCurrent I_rotor_nom "Rotor nominal current" annotation (Dialog(group="Electrics Definitions"));
  inner parameter Basics.Units.Voltage U_term_nom "Nominal excitation voltage" annotation (Dialog(group="Electrics Definitions"));

  parameter Boolean useCharLine=true  "True if characteristic line shall be used (else formula of Kloss)" annotation(Dialog(group="Part Load Definitions"));
  parameter Real charLine_tau_rpm_[:,2]=[-3,2.06; -2,2.06; -1,2.05; 0,2; 0.7,1.8; 0.95,2.8; 1,0; 1.05,-2.8; 1.3,-1.8; 2,-2; 3,-2.05; 4,-2.06; 5,-2.06]
                                                                   "Characteristic line: torque = f(rpm/rpm_nom)"  annotation(Dialog(group="Part Load Definitions", enable=useCharLine));

  final parameter Real Pi_windings = sqrt(tau_bd_nom*(8*pi^2*f_term_nom^2/N_pp*L_rotor)/3/U_term_nom^2) "Ratio rotor windings to stator windings";
  final parameter Basics.Units.ElectricResistance R_rotor=P_nom*eta_stator*slip_nom/3/I_rotor_nom^2 "Electric resistante";
  final parameter Basics.Units.Inductance L_rotor=R_rotor/slip_nom*sqrt(1/cosphi^2 - 1)/(2*pi*f_term_nom) "Inductance of rotor";
  final parameter Real slip_nom = (f_term_nom/N_pp - rpm_nom/60)/(f_term_nom/N_pp) "Nominal slip";
  final parameter Basics.Units.Torque tau_nom=P_nom/rpm_nom/2/pi*60 "Nominal torque";

  parameter String initOption = "fixed slip" "Init option" annotation(choices(choice="fixed slip", choice="steady state in speed"), Dialog(tab="Initialisation"));
  parameter Real slip_start = (f_term_nom/N_pp - rpm_nom/60)/(f_term_nom/N_pp) "Initial slip" annotation(Dialog(tab="Initialisation"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean contributeToCycleSummary = false "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation" annotation(Dialog(tab="Expert Settings",enable=useCharLine));

protected
  Basics.Units.RPM rpm(start=rpm_nom) "Shaft rotational speed";
  Basics.Units.RPM rpm_sync "Synchronous rotational speed";
  Basics.Units.Torque tau_bd "Breakdown slip";
  Basics.Units.Torque tau_rotor "Air gap electric torque";

  Basics.Units.Efficiency eta_gap "Electric efficiency";
  Real slip "Asynchronious motor slip";
  Real slip_bd "Breakdown slip";
  Basics.Units.Voltage U_rotor0 "Induced rotor voltage at zero speed";

  Modelica.Blocks.Tables.CombiTable1Dv table(table=charLine_tau_rpm_, columns={2}, smoothness=smoothness);

public
model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter Boolean showExpertSummary "True, if expert summary should be applied";
    input Basics.Units.Power P_term "Excitation power";
    input Basics.Units.Power P_gap "Air gap electric power";
    input Basics.Units.Power P_mech "Mechanic power";
    input Basics.Units.Power P_loss "Heat loss";
    input Basics.Units.RPM rpm "Shaft rotational speed";
    input Basics.Units.RPM rpm_sync "Synchronous rotational speed";
  input Real slip "Slip (rpm_sync-rpm)/rpm_sync";
    input Basics.Units.Torque tau_rotor "Electric rotor torque";
    input Basics.Units.Torque tau_mech "Mechanic shaft torque";
    input Basics.Units.Efficiency eta "Total electric efficiency";
    input Basics.Units.ElectricVoltage U_term "Terminal volage";
    input Basics.Units.ElectricCurrent I_rotor "Rotor current";
end Summary;

/////////////////////////////////////////////////////////
  ClaRa.Basics.Units.Voltage U "Terminal voltage";
  ClaRa.Basics.Units.Frequency f "Excitation frequency";
  ClaRa.Basics.Interfaces.HeatPort_a    heat(Q_flow= -(summary.P_term-summary.P_mech)) if activateHeatPort
     annotation (Placement(transformation(extent={{10,90},{-10,110}}),
          iconTransformation(extent={{10,90},{-10,110}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft "Flange of shaft"
                      annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Summary summary(showExpertSummary=showExpertSummary,
                   P_term = summary.P_gap/eta_stator,
                   P_gap = tau_rotor*der(shaft.phi)/(eta_gap+1e-3),
                   P_mech=-shaft.tau*der(shaft.phi),
                   P_loss=summary.P_term-summary.P_mech,
                   rpm=rpm,
                   rpm_sync=rpm_sync,
                   slip=slip,
                   tau_mech = -shaft.tau,
                   tau_rotor = tau_rotor,
                   eta=eta_stator*eta_gap,
                   U_term=U,
                   I_rotor=if U >1e-3 then U_rotor0/sqrt(R_rotor^2/max(1e-6, slip^2) + 2*pi*f*L_rotor) else 0)  annotation (Placement(transformation(
           extent={{-100,-100},{-80,-80}})));

initial equation
  shaft.phi=0;
  if initOption == "steady state in speed" then
    der(rpm)=0;
  elseif initOption == "fixed slip" then
    slip=slip_start;
  else
    assert(false, "Unknown initOption in e-motor");
  end if;

equation
  //////////////Definitions //////////////////////////
  der(shaft.phi) = (2*pi*rpm/60);
  slip= noEvent(if U >1e-3 then (rpm_sync-rpm)/(rpm_sync) else 0);
  eta_gap = 1 - slip;
  rpm_sync = max(1e-3,f*60/N_pp);

///////////////Electric Characteristics /////////////
  U_rotor0 = U*Pi_windings;
  tau_bd = 3*U_rotor0^2/max(1e-3,8*pi^2*rpm_sync/60*f*L_rotor);
  slip_bd = R_rotor/L_rotor/2/pi/max(1e-3,f);
  if useCharLine then
    table.u[1] = rpm/rpm_sync;
    tau_rotor = table.y[1]*tau_nom*U/U_term_nom;//tau_bd/tau_bd_nom;
  else
    table.u[1] = 1;
    tau_rotor/(tau_bd) = 2/(slip/slip_bd + slip_bd/slip) "Formula of Kloss";
  end if;

///////////////Mechanical Energy Balance ////////////
  J*2*pi/60*der(rpm) = (shaft.tau  +tau_rotor) "Energy balance";

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                        graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
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
</html>"));
end AsynchronousMotor_L2_base;
