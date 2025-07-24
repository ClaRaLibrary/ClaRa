within ClaRa.Basics.ControlVolumes.Fundamentals.Geometry;
model HollowBlockWithTubesAndHotwell "Block shape || Shell with tubes || Hotwell"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.BlockShape;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.ShellWithTubes;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry(
    final volume=width*height*length - Modelica.Constants.pi/4*diameter_t^2*length_tubes*N_tubes*N_passes + height_hotwell*width_hotwell*length_hotwell,
    final N_heat=2,
    final A_heat={
              if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then
                if tubeOrientation==2 then 2*(width + length)*height + 2*height_hotwell*(length_hotwell + width_hotwell) + length*width
                else 2*(width + length)*height - 2*N_tubes*Modelica.Constants.pi*diameter_t^2/4 + 2*height_hotwell*(length_hotwell + width_hotwell)  + length*width
              else
                if tubeOrientation==0 then 2*(width + height)*length + 2*height_hotwell*(length_hotwell + width_hotwell)
                else 2*(width + height)*length - 2*N_tubes*Modelica.Constants.pi*diameter_t^2/4 + 2*height_hotwell*(length_hotwell + width_hotwell),
              Modelica.Constants.pi*diameter_t*length_tubes*N_tubes*N_passes},
    final A_cross=if (flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.horizontal and tubeOrientation==0 or flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical and tubeOrientation==2) then A_front - Modelica.Constants.pi/4*diameter_t^2*N_tubes*N_passes else A_front*psi,
    final A_front=if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.horizontal then height*width else width*length,
    final A_hor=width_hotwell*length_hotwell,
    final height_fill=height_hotwell + height,
    final shape = {{(height_fill/20*(i-1))/height_fill,if (height_fill/20*(i-1))<height_hotwell then 1 else (height_hotwell*length_hotwell*width_hotwell + ((height_fill/20*(i-1))-height_hotwell)*length*width*interior)/(height_fill/20*(i-1))/A_hor} for i in 1:20});

  parameter Units.Length height=1 "Height of the component; Fixed flow direction in case of vertical flow orientation" annotation (Dialog(tab="General", group="Essential Geometry Definition"));
  parameter Units.Length width=1 "Width of the component" annotation (Dialog(tab="General", group="Essential Geometry Definition"));
  parameter Units.Length length=1 "|Essential Geometry Definition|Length of the component; Fixed flow direction in case of horizontal flow orientation" annotation (Dialog(
      tab="General",
      group="Essential Geometry Definition",
      showStartAttribute=false,
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HollowBlockWithTubesAndHotwell.png",
      connectorSizing=false));
  parameter ClaRa.Basics.Choices.GeometryOrientation flowOrientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal "Orientation of shell side flow"
                                                                                          annotation (Dialog(groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HollowBlockWithTubes_2.png",tab="General",group="Essential Geometry Definition"));

  final parameter Real interior = (volume-height_hotwell*width_hotwell*length_hotwell)/(width*height*length) "Void fraction in the shell";

  parameter ClaRa.Basics.Units.Length height_hotwell=1 "|Hotwell Definition|Height of the hotwell";
  parameter ClaRa.Basics.Units.Length width_hotwell=1 "|Hotwell Definition|Width of the hotwell";
  parameter ClaRa.Basics.Units.Length length_hotwell=1 "|Hotwell Definition|Length of the hotwell";

  parameter Units.Length diameter_t=0.1 "Outer diameter of internal tubes" annotation (Dialog(
      tab="General",
      group="Interior Equipment",
      showStartAttribute=false,
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX_ParameterDialogTubes.png",
      connectorSizing=false));
  parameter Integer N_tubes=1 "Number of internal tubes for one pass" annotation(Dialog(group="Interior Equipment"));
  parameter Integer N_passes=1 "Number of passes of the internal tubes"
                                                                       annotation(Dialog(group="Interior Equipment"));
  constant Real MIN=1e-5 "Limiter";
  parameter Modelica.Units.SI.Length Delta_z_par=2*diameter_t "Horizontal distance between tubes (center to center)" annotation (Dialog(group="Interior Equipment"));
  parameter Modelica.Units.SI.Length Delta_z_ort=2*diameter_t "Vertical distance between tubes (center to center)" annotation (Dialog(group="Interior Equipment"));
  final parameter Real a=Delta_z_ort/diameter_t "Lateral alignment ratio"
                                                                         annotation(Dialog(group="Interior Equipment"));
  final parameter Real b=Delta_z_par/diameter_t "Vertical alignment ratio"
                                                                          annotation(Dialog(group="Interior Equipment"));
  final parameter Real psi=if b >= 1 or b<=0 then 1 - Modelica.Constants.pi/4/a else 1 - Modelica.Constants.pi/4/a/b "Void ratio" annotation(Dialog(group="Interior Equipment"));
  parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly, false otherwise"
                                                                                                         annotation(Dialog(group="Interior Equipment"));
  final parameter Real fa=if staggeredAlignment then (1 + (if b>0 then 2/3/b else 0)) else (1 + (if b>0 then 0.7/max(MIN,psi)^1.5*(b/a - 0.3)/(b/a + 0.7)^2 else 0)) "Alignment factor";

  parameter Integer N_rows(
    min=N_passes,
    max=N_tubes) = integer(ceil(sqrt(N_tubes))*N_passes) "Number of pipe rows in flow direction" annotation(Dialog(group="Interior Equipment"));
  parameter Integer tubeOrientation=0 "Tube orientation" annotation (Dialog(group="Interior Equipment"), choices(
      choice=0 "Lengthwise",
      choice=1 "Widthwise",
      choice=2 "Heightwise"));
  final parameter Real N_tubes_parallel = N_tubes*N_passes/N_rows "Number of parallel tubes";
  final parameter Real length_tubes = if tubeOrientation==0 then length else if tubeOrientation==1 then width else height "Tube length";
  final parameter Real A_narrowed_ort = if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then
                                            if tubeOrientation==0 then length*width - N_tubes_parallel*diameter_t*length
                                            else if tubeOrientation==1 then length*width - N_tubes_parallel*diameter_t*width
                                            else 0
                                      else  if tubeOrientation==0 then 0
                                            else if tubeOrientation==1 then width*height - N_tubes_parallel*diameter_t*width
                                            else height*width - N_tubes_parallel*diameter_t*height "Narrowed cross section in parallel tube layer";


  final parameter Real A_narrowed_par = if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then
                                            if tubeOrientation==0 then length*height - N_rows*diameter_t*length
                                            else if tubeOrientation==1 then width*height - N_rows*diameter_t*width
                                            else 0
                                      else  if tubeOrientation==0 then 0
                                            else if tubeOrientation==1 then width*length - N_rows*diameter_t*width
                                            else height*length - N_rows*diameter_t*height "Narrowed cross section in tube row layer";

  final parameter Real length_bundle_par = N_rows*Delta_z_par;
  final parameter Real length_bundle_ort = N_tubes_parallel*Delta_z_ort;
  final parameter Real Delta_l_par= if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then
                                 if tubeOrientation==0 then height - length_bundle_par
                                 else if tubeOrientation==1 then height - length_bundle_par
                                 else 0
                              else
                                 if tubeOrientation==0 then 0
                                 else if tubeOrientation==1 then length - length_bundle_par
                                 else length - length_bundle_par;


  final parameter Real Delta_l_ort = if flowOrientation == ClaRa.Basics.Choices.GeometryOrientation.vertical then
                                 if tubeOrientation==0 then width - length_bundle_ort
                                 else if tubeOrientation==1 then length - length_bundle_ort
                                 else 0
                              else
                                 if tubeOrientation==0 then 0
                                 else if tubeOrientation==1 then height - length_bundle_ort
                                 else width - length_bundle_ort;
equation
   for i in 1:N_inlet loop
     assert(if integer(height_fill) <> -1 then z_in[i]<=height_fill else true, "Position of inlet flange no. " +String(i)+ "("+String(z_in[i], significantDigits=3)+" m) must be below max. fill height of "+ String(height_fill, significantDigits=3) + " m in component " +  getInstanceName() + ".");
   end for;
   for i in 1:N_outlet loop
     assert(if integer(height_fill) <> -1 then z_out[i]<=height_fill else true, "Position of outlet flange no. " +String(i)+ "("+String(z_out[i], significantDigits=3)+" m) must be below max. fill height of "+ String(height_fill, significantDigits=3) + " m in component " +  getInstanceName() + ".");
   end for;
  for i in 1:N_inlet loop
    assert(z_in[i]>=0, "Position of inlet flange no. " +String(i)+ "("+String(z_in[i], significantDigits=3)+" m) must be positive in component " +  getInstanceName() + ".");
  end for;
  for i in 1:N_outlet loop
    assert(z_out[i]>=0, "Position of outlet flange no. " +String(i)+ "("+String(z_out[i], significantDigits=3)+" m) must be positive in component " +  getInstanceName() + ".");
  end for;
  assert(psi>0, "Negative or zero psi leads to invalid Reynolds numbers. Check geometry values for pipe arrangement. Delta_z_par*delta_z_ort must be > pi*diameter_o^2/4.");
  assert(volume>0, "The volume of the shell side must be > 0 but is "+String(volume, significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(A_narrowed_ort>=0, "Number of parallel tubes too high. Check geometry values for pipe arrangement. A_narrowed_ort = " +String(A_narrowed_ort, significantDigits=3));
  assert(A_narrowed_par>=0, "Number of tube rows too high. Check geometry values for pipe arrangement. A_narrowed_par = "  +String(A_narrowed_par, significantDigits=3));
  assert(Delta_l_par>=0, "Tube bundle in flow direction larger than volume. Check geometry values for pipe arrangement. Delta_l_par = "  +String(Delta_l_par, significantDigits=3));
  assert(Delta_l_ort>=0, "Tube bundle orthogonal to flow direction larger than volume. Check geometry values for pipe arrangement. Delta_l_ort = "  +String(Delta_l_ort, significantDigits=3));

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
 Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/Resources/Images/Components/HollowBlockWithTubesAndHotwell.png")}));
end HollowBlockWithTubesAndHotwell;
