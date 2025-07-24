within ClaRa.Components.HeatExchangers;
model IdealShell_L2 "A desuperheater having an ideal cooling | block-shaped geometry"
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

  extends ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2(
                                                               redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes (
        height=height,
        width=width,
        length=length,
        diameter_t=
            diameter_t,
        N_tubes=N_tubes,
        N_passes=N_passes,
        tubeOrientation=tubeOrientation,
        flowOrientation=flowOrientation,
        z_in={z_in},
        z_out={z_out}),final heatSurfaceAlloc=2,redeclare model PhaseBorder =
        ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred);
  extends ClaRa.Basics.Icons.HEX02;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_th=if not heatFlowIsLoss then -heat.Q_flow else 0,
    powerOut_elMech=0,
    powerAux=0)                                                                                                     if contributeToCycleSummary;
  outer ClaRa.SimCenter   simCenter;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // parameter dialog~~~~~~~~~~~~~~~~~
  parameter Modelica.Units.SI.Length height=1 "Height of the component" annotation (Dialog(tab="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialog_BUshell1ph2.png"));
  parameter Modelica.Units.SI.Length width=1 "Width of the component" annotation (Dialog(tab="Geometry"));
  parameter Modelica.Units.SI.Length length=1 "Length of the component" annotation (Dialog(tab="Geometry"));
  parameter Modelica.Units.SI.Length diameter_t=0.1 "Outer diameter of internal tubes" annotation (Dialog(tab="Geometry"));
  parameter Integer N_tubes=1 "Number of internal tubes"
    annotation (Dialog(tab="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"
    annotation (Dialog(tab="Geometry"));
  parameter ClaRa.Basics.Choices.GeometryOrientation flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal "Flow orientation at shell side"
                                   annotation (Dialog(tab="Geometry"));

  parameter Integer tubeOrientation=0 "Tube orientation" annotation(Dialog(tab="Geometry"), choices(
      choice=0 "Lengthwise",
      choice=1 "Widthwise",
      choice=2 "Heightwise"));

  parameter Modelica.Units.SI.Length z_in=height/2 "Inlet position from bottom" annotation (Dialog(tab="Geometry", enable=orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical));
  parameter Modelica.Units.SI.Length z_out=height/2 "Outlet position from bottom" annotation (Dialog(tab="Geometry", enable=orientation == ClaRa.Basics.Choices.GeometryOrientation.vertical));

  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
    annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{45,-81},{47,-79}})));

public
  ClaRa.Basics.Interfaces.EyeOut eye if showData
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

equation
  eye_int[1].p = outlet.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = fluidOut.T - 273.15;
  eye_int[1].s = fluidOut.s/1e3;
  connect(eye, eye_int[1]) annotation (Line(
      points={{100,-80},{46,-80}},
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
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics), Diagram(graphics));
end IdealShell_L2;
