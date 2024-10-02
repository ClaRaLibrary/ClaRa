within ClaRa.Components.TurboMachines.Pumps.Fundamentals;
partial model PumpVLE_affinityBase "Base class for affinity law based pumps"
  //
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

  import pow = Modelica.Fluid.Dissipation.Utilities.Functions.General.SmoothPower;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import Modelica.Constants.pi;

  extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.Pump_Base; //(inlet( m_flow(      start=V_flow_max*losses.V_flow_opt_*1000)))

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_elMech=0,
    powerOut_th=0,
    powerAux=P_shaft)  if contributeToCycleSummary;

  parameter Boolean useMechanicalPort=false "True, if a mechenical flange should be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean steadyStateTorque=false "True, if steady state mechanical momentum shall be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter Basics.Units.RPM rpm_nom "Nomial rotational speed" annotation (Dialog(group="Fundamental Definitions"));

  parameter Basics.Units.RPM rpm_fixed=60 "Constant rotational speed of pump" annotation (Dialog(group="Fundamental Definitions", enable=not useMechanicalPort));
  parameter Modelica.Units.SI.Inertia J "Moment of Inertia" annotation (Dialog(group="Fundamental Definitions", enable=not steadyStateTorque));


protected
 model Outline
   extends ClaRa.Components.TurboMachines.Pumps.Fundamentals.Outline;
    input Basics.Units.Power P_iso "Power for isentropic flow";
    input Basics.Units.Power P_shaft "Mechanicl power at shaft";
    input ClaRa.Basics.Units.RPM rpm "Pump revolutions per minute";
 end Outline;


public
  Modelica.Units.SI.AngularAcceleration a "Angular acceleration of the shaft";
  Modelica.Units.SI.Torque tau_fluid "Fluid torque";
  Basics.Units.RPM rpm "Rotational speed";
  Basics.Units.Power P_iso "Power for isentropic pressure increase";
  Basics.Units.Power P_shaft "Shaft power";
//  Real eta_hyd(start=eta_hyd_nom) "Hydraulic efficiency";


public
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft  if useMechanicalPort
    annotation (Placement(transformation(extent={{-10,62},{10,82}}),
        iconTransformation(extent={{-10,89},{10,109}})));


protected
  ClaRa.Components.TurboMachines.Fundamentals.GetInputsRotary getInputsRotary
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,20})));


equation


//____________________ Mechanics ___________________________
   if useMechanicalPort then
     der(getInputsRotary.rotatoryFlange.phi) = (2*pi*rpm/60);
     J*a = - tau_fluid + getInputsRotary.rotatoryFlange.tau "Mechanical momentum balance";
   else
     rpm = rpm_fixed;
     getInputsRotary.rotatoryFlange.phi = 0.0;
   end if;

   if (steadyStateTorque) then
     a = 0;
   else
     a = (2*pi/60)*der(rpm);
   end if;



  connect(shaft, getInputsRotary.rotatoryFlange)
    annotation (Line(points={{0,72},{0,72},{0,30}}, color={0,0,0}));
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
</html>"),Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(graphics));
end PumpVLE_affinityBase;
