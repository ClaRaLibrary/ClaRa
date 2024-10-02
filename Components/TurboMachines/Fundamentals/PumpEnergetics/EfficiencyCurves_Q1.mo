within ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics;
model EfficiencyCurves_Q1 "Losses by efficiency | normal operation | "

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


  extends ClaRa.Components.TurboMachines.Fundamentals.PumpEnergetics.BaseEnergetics;

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
  import Modelica.Constants.pi;
  import density = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.density_phxi;

  parameter Real eta_hyd_nom=0.8 "Max. hydraulic efficiency at nominal speed" annotation(Dialog(group = "Characteristic Field - refer to documentation for details", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/EfficiencyCurvesParameterDialogue.png"));
  parameter Real V_flow_opt_(min=0.0, max=1) = 0.6 "Relative position of best point at V_flow axis in p.u." annotation(Dialog(group="Characteristic Field - refer to documentation for details"));
  parameter Real exp_rpm=0 "Exponent for rpm dependency of max. efficiency" annotation(Dialog(group="Characteristic Field - refer to documentation for details"));

  parameter Real exp_flow=2 "Exponent for volume flow dependency of efficiency" annotation(Dialog(group="Characteristic Field - refer to documentation for details"));

  parameter Basics.Units.VolumeFlowRate V_flow_leak=0.00002 "Leakage mass flow" annotation (Dialog(tab="Expert Settings", group="Non-Design Operation - refer to documentation for details"));

  parameter Basics.Units.Pressure Delta_p_eps=100 "Small pressure difference for linearisation around zero mass flow" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));

  parameter Boolean stabiliseDelta_p=false "Avoid chattering due to small pressure differences between inlet and outlet at small mass flows"
                                                                                            annotation(Dialog(tab = "Expert Settings", group="Numerical Robustness"));
  parameter Basics.Units.Time Tau_stab=1 "Stabiliser state time constant - refer to documentation for details." annotation (Dialog(
      tab="Expert Settings",
      group="Numerical Robustness",
      enable=stabiliseDelta_p));

  Basics.Units.Pressure Delta_p_maxrpm "Maximum pressure difference at current speed";

protected
  Basics.Units.Pressure Delta_p_ps "Pressure pseudo state prevents chattering";
  constant Basics.Units.RPM rpm_eps=1e-5 "Rotational speed";
  ClaRa.Basics.Units.Power P_diss "Dissipation power";
  ClaRa.Basics.Units.VolumeFlowRate V_flow_maxrpm;

initial equation
 if stabiliseDelta_p then
  Delta_p_ps = iCom.Delta_p;
 end if;

equation
  if stabiliseDelta_p then
   der(Delta_p_ps) = (iCom.Delta_p-Delta_p_ps)/Tau_stab;
  else
    Delta_p_ps = iCom.Delta_p;
  end if;

  P_iso = noEvent(if sign(iCom.rpm/iCom.rpm_nom)* sign(iCom.Delta_p/iCom.Delta_p_max_var)* sign(iCom.V_flow/iCom.V_flow_max) > 0 then (iCom.h_out_iso -  iCom.h_in_iso)*iCom.m_flow else 0);
  Delta_p_maxrpm = iCom.Delta_p_max_var*(iCom.rpm/iCom.rpm_nom)^2;
  V_flow_maxrpm = iCom.V_flow_max*iCom.rpm/iCom.rpm_nom;
  P_diss = (if sign(iCom.rpm/iCom.rpm_nom* iCom.Delta_p/iCom.Delta_p_max_var* iCom.V_flow/iCom.V_flow_max* tau_fluid) <= 0 then (iCom.h_out_iso -  iCom.h_in_iso)*iCom.m_flow else 0);
  P_loss = SM(-Delta_p_eps,Delta_p_eps, Delta_p_ps)  *(-iCom.P_iso*(1-eta))
          + SM(+Delta_p_eps,-Delta_p_eps, Delta_p_ps)  * SM(Delta_p_maxrpm-Delta_p_eps,Delta_p_maxrpm, Delta_p_ps)  * iCom.P_iso*(1-eta)/eta
          + SM(Delta_p_maxrpm,Delta_p_maxrpm-Delta_p_eps, Delta_p_ps)*(-2*P_diss + P_diss*(iCom.rpm_nom-iCom.rpm)/iCom.rpm_nom) "reverse turbine | normal pumping | dissipation";
  P_fluid = tau_fluid*2* pi*iCom.rpm/60;
  tau_loss = P_loss / (1e-3 + 2*pi*iCom.rpm/60);
  tau_fluid = if noEvent(iCom.rpm<rpm_eps) then 0 else (P_iso+P_loss)/(2*pi*iCom.rpm/60);

//____________________ Affinity Laws _______________________
  eta = noEvent(max(0.001,SM(Delta_p_maxrpm-Delta_p_eps,Delta_p_maxrpm, Delta_p_ps)*(eta_hyd_nom*(abs(iCom.rpm)/iCom.rpm_nom)^(-exp_rpm)) *SM(V_flow_opt_, 1, iCom.V_flow/V_flow_maxrpm)*(1-abs(pow( max(V_flow_leak,iCom.V_flow)/(max(V_flow_leak,V_flow_maxrpm)*V_flow_opt_) - 1, 0.01, exp_flow)))));
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
</html>"));
end EfficiencyCurves_Q1;
