within ClaRa.Components.FlueGasCleaning.Desulfurization;
model Desulfurization_L2_ideal "Model for an idealised desulfurization with chalk washing"
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

  extends ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2_chem(redeclare model ChemicalReactions=SeparationModel, redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowCylinder (                                                                                                                                        diameter=4,length=10,z_in={0},z_out={10},orientation = ClaRa.Basics.Choices.GeometryOrientation.vertical,flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical));
  extends ClaRa.Basics.Icons.Separator;
parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
   ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut_th=0,
    powerOut_elMech=0,
    powerAux=chemicalReactions.P_el)  if contributeToCycleSummary;

  replaceable model SeparationModel =
       ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.Desulfurization_L2
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.DesulfurizationBase "1st: choose e-filter reaction model | 2nd: edit corresponding record"
     annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  parameter Basics.Units.Length diameter=1 "Diameter of the component";
  parameter Basics.Units.Length height=1 "Height of the component";

  Basics.Interfaces.EyeOutGas
                           eyeOut(medium=medium) annotation (Placement(transformation(extent={{100,-78},{106,-72}}),
                                  iconTransformation(extent={{94,-86},{106,-74}})));
protected
  Basics.Interfaces.EyeInGas
                          eye_int[1](each medium=medium) annotation (Placement(transformation(extent={{76,-76},{74,-74}}),
                                  iconTransformation(extent={{90,-84},{84,-78}})));
equation
  //______________Eye port variable definition________________________
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = flueGasOutlet.T-273.15;
  eye_int[1].s = flueGasOutlet.T/1e3;
  eye_int[1].p = flueGasOutlet.p/1e5;
  eye_int[1].h = flueGasOutlet.h/1e3;
  eye_int[1].xi= flueGasOutlet.xi;

  connect(eye_int[1],eyeOut)  annotation (Line(
      points={{75,-75},{103,-75}},
      color={190,190,190},
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
</html>"));
end Desulfurization_L2_ideal;
