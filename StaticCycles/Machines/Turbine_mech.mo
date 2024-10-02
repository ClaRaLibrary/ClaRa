within ClaRa.StaticCycles.Machines;
model Turbine_mech "Turbine mith machanical flanges || par.: efficiency || green | blue"
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
  // Green input: Values of p, m_flow and h are unknown and provided BY neighbor component.
  // Blue output: Value of p is unknown and provided BY neighbor component, values of m_flow and h are known in component and provided FOR neighbor component.
  outer ClaRa.SimCenter simCenter;
      //---------Summary Definition---------

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Basics.Units.Pressure Delta_p "Pressure difference between outlet and inlet" annotation (Dialog);
    parameter Basics.Units.Power P_turbine "Turbine power" annotation (Dialog);
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.StaCyFlangeVLE inlet;
    ClaRa.Basics.Records.StaCyFlangeVLE outlet;
    Outline outline;
  end Summary;

  Summary summary(
  inlet(
     m_flow=m_flow,
     h=h_in,
     p=p_in),
  outlet(
     m_flow=m_flow,
     h=h_out,
     p=p_out),
  outline(Delta_p=Delta_p,
     P_turbine=P_turbine));
  //---------Summary Definition---------
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));

  parameter Real efficiency= 1 "Hydraulic efficiency" annotation(Dialog(group="Fundamental Definitions"));
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      medium,
      p_in,
      h_in) "Inlet density";
  final parameter ClaRa.Basics.Units.Power P_turbine=(-h_out + h_in)*m_flow "Turbine power";

//protected
  final parameter ClaRa.Basics.Units.Pressure p_in(fixed=false) "Inlet pressure";
  final parameter ClaRa.Basics.Units.Pressure p_out(fixed=false) "Outlet pressure";
  final parameter ClaRa.Basics.Units.MassFlowRate m_flow(fixed=false, start=1) "Mass flow rate";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_in(fixed=false) "Inlet specific enthalpy";
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_out=h_in + efficiency*(TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_psxi(
      medium,
      p_out,
      TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEntropy_phxi(
        medium,
        p_in,
        h_in)) - h_in) "Outlet enthalpy";

  final parameter ClaRa.Basics.Units.Power P_in(fixed=false) "Power from left attached turbine";
  final parameter ClaRa.Basics.Units.PressureDifference Delta_p=p_in - p_out "Rprt: p_in - p_out";

public
  ClaRa.StaticCycles.Fundamentals.SteamSignal_green_a inlet(Medium=medium) annotation (Placement(transformation(extent={{-70,30},{-60,50}}), iconTransformation(extent={{-70,30},{-60,50}})));
  ClaRa.StaticCycles.Fundamentals.SteamSignal_blue_b outlet(h=h_out, m_flow=m_flow, Medium=medium) annotation (Placement(transformation(extent={{60,-90},{70,-70}}), iconTransformation(extent={{60,-90},{70,-70}})));

  ClaRa.StaticCycles.Fundamentals.PowerSignal_A power_in(s=power_out.s)   annotation (Placement(transformation(extent={{-68,-10},{-60,10}}), iconTransformation(extent={{-68,-10},{-60,10}})));
  ClaRa.StaticCycles.Fundamentals.PowerSignal_B power_out(power=P_in + P_turbine) annotation (Placement(transformation(extent={{60,-10},{68,10}}), iconTransformation(extent={{60,-10},{68,10}})));
initial equation
  inlet.m_flow=m_flow;
  inlet.p=p_in;
  inlet.h=h_in;
  outlet.p=p_out;
  power_in.power = P_in;

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
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-60,
            -100},{60,100}}),  graphics),
              Icon(coordinateSystem(preserveAspectRatio=true,extent={{-60,-100},{60,100}}),
                   graphics={Polygon(
                                    points={{-60,50},{60,90},{60,-90},{-60,-50},{-60,50}},
                                    smooth=Smooth.None,
                                    lineColor=DynamicSelect({0,131,169}, if Delta_p >= 0 then {0,131,169} else {234,171,0}),
                                    fillColor={255,255,255},
                                    fillPattern=DynamicSelect(FillPattern.Solid, if Delta_p >= 0 then FillPattern.Solid else FillPattern.Backward))}));
end Turbine_mech;
