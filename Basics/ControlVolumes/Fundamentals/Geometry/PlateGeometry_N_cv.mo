within ClaRa.Basics.ControlVolumes.Fundamentals.Geometry;
model PlateGeometry_N_cv "Discretized plate || Tube type"
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

  //NOTE: this geometry can not be filled as the applying models assume good mixure of phases and no phase separation

  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.TubeType;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv(
    final volume={A_cross[i]*Delta_x[i] for i in 1:N_cv},
    final N_heat = 2,
    final A_heat = [{(N_plates-2)*Phi*width*Delta_x[i] for i in 1:N_cv},ones(N_cv)*(2*(N_plates*(thickness_wall+2*amp)-2*amp)*(width+length)+2*width*length)/N_cv],
    final A_cross=ones(N_cv)*(N_plates-1)/2*width*2*amp,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid({0}, length, N_cv),
    final z=cat(1,
               {(z_out - z_in)/(length)*Delta_x[1]/2 + z_in},
               {((z_out - z_in)/(length)*(sum(Delta_x[k] for k in 1:i - 1) + Delta_x[i]/2) + z_in) for i in 2:N_cv}),
    final Delta_z_in = {sum(Delta_x[1:i]) - Delta_x[i]/2 for i in 1:N_cv},
    final diameter_hyd=fill(4*amp/Phi, N_cv));

  parameter ClaRa.Basics.Units.Length width=1 "Plate width" annotation (Dialog(group="Essential Geometry Definition"));
  parameter ClaRa.Basics.Units.Length length=1 "Plate length" annotation (Dialog(group="Essential Geometry Definition"));
  parameter ClaRa.Basics.Units.Length thickness_wall=0.001 "Wall thickness" annotation (Dialog(group="Essential Geometry Definition"));
  parameter Integer N_plates(min=3)=3 "Number of tubes in parallel"
                                                                   annotation(Dialog(group="Essential Geometry Definition"));

  parameter ClaRa.Basics.Units.Length amp(min=1e-10) = 0.001 "Amplitude of corrugated plate" annotation (Dialog(group="Essential Geometry Definition"));
  parameter ClaRa.Basics.Units.Length length_wave(min=1e-10) = 2*Modelica.Constants.pi*amp "Wave length of corrugated plate" annotation (Dialog(group="Essential Geometry Definition"));
  parameter ClaRa.Basics.Units.Angle phi = 60*Modelica.Constants.pi/180 "Corrugation angle" annotation (Dialog(group="Essential Geometry Definition"));

  final parameter Real X = 2*Modelica.Constants.pi*amp/length_wave "Wave number"
                                                                                annotation (Dialog(group="Adaption to measurement data"));
  final parameter Real Phi = 1/6*(1+sqrt(1+X^2)+4*sqrt(1+0.5*X^2)) "Area enhancement factor"
                                                                                            annotation (Dialog(group="Adaption to measurement data"));

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
 Icon(graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource="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",
          fileName="modelica://ClaRa/Resources/Images/Components/PlateGeometry.png")}));
end PlateGeometry_N_cv;
