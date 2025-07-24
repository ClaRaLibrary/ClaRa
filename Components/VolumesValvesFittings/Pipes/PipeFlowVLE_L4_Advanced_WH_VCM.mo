within ClaRa.Components.VolumesValvesFittings.Pipes;
model PipeFlowVLE_L4_Advanced_WH_VCM "Copy of PipeFlowVLE_L4_Advanced with adaptation of speed of sound according and vapour cavity model"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2025, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//
  extends ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4_Advanced_WH_VCM(suppHighFreqCorr=geo.N_cv/geo.length, redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv (
        z_in=z_in,
        z_out=z_out,
        N_tubes=N_tubes,
        N_cv=N_cv,
        diameter=diameter_i,
        length=length,
        Delta_x=Delta_x,
        N_passes=N_passes,
        orientation=orientation));
  extends ClaRa.Basics.Icons.Pipe_L4_a;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=noEvent(if sum(heat.Q_flow) > 0 then sum(heat.Q_flow) else 0),
    powerOut_th=if not heatFlowIsLoss then -sum(heat.Q_flow) else 0,
    powerOut_elMech=0,
    powerAux=0) if contributeToCycleSummary;
//## P A R A M E T E R S #######################################################################################

//____Geometric data_____________________________________________________________________________________
  parameter ClaRa.Basics.Units.Length length=1 "Length of the pipe (one pass)" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_i=0.1 "Inner diameter of the pipe" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in=0.1 "Height of inlet above ground" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out=0.1 "Height of outlet above ground" annotation (Dialog(group="Geometry"));

  parameter Integer N_tubes= 1 "Number Of parallel pipes"
                                                         annotation(Dialog(group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the tubes" annotation(Dialog(group="Geometry"));
  parameter Integer orientation=0 "Main orientation of tube bundle (N_passes>1)" annotation(Dialog(group="Geometry", enable=(N_passes>1)), choices(choice = 0 "Horizontal", choice = 1 "Vertical"));

//____Discretisation_____________________________________________________________________________________
public
  parameter Integer N_cv(min=3)=3 "Number of finite volumes" annotation(Dialog(group="Discretisation"));

  parameter ClaRa.Basics.Units.Length Delta_x[N_cv]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length*N_passes,
      N_cv) "Discretisation scheme" annotation (Dialog(group="Discretisation"));
//________Summary_________________
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if negative heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));
//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------

public
  ClaRa.Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(extent={{140,-50},{160,-30}}), iconTransformation(extent={{136,-44},{156,-24}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1] annotation (Placement(transformation(extent={{95,-41},{97,-39}})));

equation
//-------------------------------------------
//Summary:
  assert(abs(z_out-z_in) <= length, "Length of pipe less than vertical height", AssertionLevel.error);
  eye_int[1].m_flow=-outlet.m_flow;
  eye_int[1].T= fluidOutlet.T-273.15;
  eye_int[1].s=fluidOutlet.s/1e3;
  eye_int[1].p=outlet.p/1e5;
  eye_int[1].h=noEvent(actualStream(outlet.h_outflow))/1e3;

//-------------------------------------------

  connect(eye,eye_int[1])  annotation (Line(
      points={{150,-40},{96,-40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
//           Line(
//           points={{-106,0},{-100,0},{-98,-30},{-96,-32},{-94,56},{-92,-56},{-90,54},{-88,-50},{-86,44},{-84,-42},{-82,34},{-80,-30},{-78,26},{-76,-24},{-74,14},{-72,-12},{-70,8},{-68,-6},{-66,6},{-64,-4},{-62,4},{-60,-2},{-58,2},{-56,0},{0,0},{4,0},{8,0},{12,0},{16,0},{20,0},{24,0},{28,0},{32,0},{36,0},{42,0},{46,0},{50,0},{54,0},{60,0},{64,0},{70,0},{74,0},{78,0},{82,0},{86,0},{90,0},{96,0},{100,0},{106,0}},
//           color={0,131,169},
//           smooth=Smooth.Bezier)
      annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
ClaRa development team, Copyright &copy; 2017 - 2025.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p> This component was developed for ClaRa library.</p>
<p><b>Acknowledgements:</b> </p>
<p><b>CLA:</b> </p>

</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false,extent={{-140,-50},
            {140,50}}),
                   graphics={
        Polygon(
          points={{-132,42},{-122,42},{-114,34},{-114,-36},{-122,-42},{-132,-42},
              {-132,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtInlet),
        Polygon(
          points={{132,42},{122,42},{114,34},{114,-36},{122,-42},{132,-42},
              {132,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtOutlet),
        Line(
          points={{-106,32},{-106,-32},{-44,-32}},
          color={0,131,169}),
        Line(
          points={{-106,0},{-100,0},{-98,-30},{-96,-32},{-94,56},{-92,-56},{-90,54},{-88,-50},{-86,44},{-84,-42},{-82,34},{-80,-30},{-78,26},{-76,-24},{-74,14},{-72,-12},{-70,8},{-68,-6},{-66,6},{-64,-4},{-62,4},{-60,-2},{-58,2},{-56,0},{-44,0}},
          color={0,131,169},
          smooth=Smooth.Bezier)}),
                              Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}}),
                                      graphics));
end PipeFlowVLE_L4_Advanced_WH_VCM;
