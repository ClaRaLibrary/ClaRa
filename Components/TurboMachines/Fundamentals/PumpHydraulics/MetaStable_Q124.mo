within ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics;
model MetaStable_Q124 "Metastable(d Delta_p/d V_flow) = 0 at V_flow = 0 | normal pumping, rev. turbining, dissipation mode "

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


  extends ClaRa.Components.TurboMachines.Fundamentals.PumpHydraulics.BaseHydraulics;

  import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
  import szt = ClaRa.Basics.Functions.SmoothZeroTransition;

  parameter Real exp_hyd= 0.5 "Exponent for affinity law"
                                                         annotation(Dialog(group = "Characteristic Field",groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/PumpHydraulicsMetaStable124.png"));
  parameter Real drp_exp= 0 "Droop of exp_hyd w.r.t. rpm" annotation(Dialog(group = "Characteristic Field"));

  parameter Real K_rev = 0.75 "Correction term for reverse flow" annotation (Dialog(tab="Expert Settings", group = "Reverse Flow"));
  parameter Basics.Units.Pressure Delta_p_eps=100 "Small pressure difference for linearisation around zero mass flow" annotation (Dialog(tab="Expert Settings", group="Numerical Robustness"));



  Basics.Units.Pressure Delta_p_maxrpm "Maximum pressure difference at current speed";

protected
  Real K_ "=K_rev if revcerse flow, else 1";
//  Basics.Units.VolumeFlowRate V_flow_maxrpm "Max. volume flow at current rpm (deprecated)";
equation
//____________________ Affinity Laws _______________________

//  V_flow_maxrpm = iCom.V_flow_max*iCom.rpm/iCom.rpm_nom;
  Delta_p_maxrpm = iCom.Delta_p_max_var*(iCom.rpm/iCom.rpm_nom)^2;
  K_ = szt(1, K_rev, (Delta_p_maxrpm - iCom.Delta_p), Delta_p_eps);


  V_flow = K_*pow((Delta_p_maxrpm - iCom.Delta_p)/iCom.Delta_p_max_var, Delta_p_eps/iCom.Delta_p_max_var, exp_hyd+drp_exp*(iCom.rpm-iCom.rpm_nom)) *(iCom.V_flow_max);

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
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end MetaStable_Q124;
