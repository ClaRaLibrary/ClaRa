within ClaRa.SubSystems.Boiler;
partial model CoalSupplyBoiler_base "The coal mills and the boiler"

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


  extends ClaRa.Basics.Icons.Boiler;
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

  outer SimCenter simCenter;
  ClaRa.Basics.Interfaces.FluidPortOut livesteam(Medium=medium)
    annotation (Placement(transformation(extent={{-10,184},{10,204}}),
        iconTransformation(extent={{-10,210},{10,230}})));
   ClaRa.Basics.Interfaces.FluidPortOut reheat_out(Medium=medium)
     annotation (Placement(transformation(extent={{48,184},{68,204}}),
         iconTransformation(extent={{50,210},{70,230}})));
  Modelica.Blocks.Interfaces.RealInput QF_setl_ "Set value of thermal output in p.u."
                                          annotation (Placement(transformation(
          extent={{-120,-20},{-80,20}}),iconTransformation(extent={{-140,-20},{
            -100,20}})));
  ClaRa.Basics.Interfaces.FluidPortIn feedwater(Medium=medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-106},{10,-86}})));
   ClaRa.Basics.Interfaces.FluidPortIn reheat_in(Medium=medium)
     annotation (Placement(transformation(extent={{50,-110},{70,-90}}),
         iconTransformation(extent={{50,-106},{70,-86}})));
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
   Icon(coordinateSystem(extent={{-100,-100},{100,200}},
          preserveAspectRatio=false),
                   graphics), Diagram(coordinateSystem(extent={{-100,-100},{100,
            200}}, preserveAspectRatio=true),
                                      graphics));
end CoalSupplyBoiler_base;
