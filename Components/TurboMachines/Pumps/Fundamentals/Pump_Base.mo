within ClaRa.Components.TurboMachines.Pumps.Fundamentals;
partial model Pump_Base "Base class for pumps"
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
  import SI = ClaRa.Basics.Units;
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.bubblePressure_Txi;
  extends ClaRa.Basics.Icons.Pump;
  //extends Modelica.Icons.UnderConstruction;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                                         annotation(choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  parameter Boolean showExpertSummary = simCenter.showExpertSummary "True, if expert summary should be applied"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  Basics.Units.Pressure Delta_p "Pressure difference between pressure side and suction side";
  Basics.Units.VolumeFlowRate V_flow "Volume flow rate";
  Basics.Units.Power P_fluid "Power to the fluid";

  outer ClaRa.SimCenter simCenter;



public
  ClaRa.Basics.Interfaces.FluidPortIn inlet(
                                           Medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut
                                     outlet(Medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph  fluidIn(vleFluidType =    medium, p=inlet.p,
    h=homotopy(noEvent(actualStream(inlet.h_outflow)), inStream(inlet.h_outflow)))
    annotation (Placement(transformation(extent={{-88,-12},{-68,8}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph  fluidOut(
                                vleFluidType =    medium,
    p=outlet.p,
    h=homotopy(noEvent(actualStream(outlet.h_outflow)), outlet.h_outflow))
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
public
  Basics.Interfaces.EyeOut       eye if showData
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
protected
  Basics.Interfaces.EyeIn       eye_int[1]
    annotation (Placement(transformation(extent={{45,-61},{47,-59}})));
equation

  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = fluidOut.T-273.15;
  eye_int[1].s = fluidOut.s/1e3;
  eye_int[1].p = outlet.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;

  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-60},{46,-60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
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
    Icon(graphics),
      Diagram(graphics));
end Pump_Base;
