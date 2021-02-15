within ClaRa.Components.Sensors;
model gasSensorBase "Base class for gas sensors"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.6.0                           //
//                                                                          //
// Licensed by the ClaRa development team under Modelica License 2.         //
// Copyright  2013-2021, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}}),
        iconTransformation(extent={{-110,-110},{-90,-90}})));
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
        iconTransformation(extent={{90,-110},{110,-90}})));
  extends ClaRa.Basics.Icons.Sensor1;
  outer ClaRa.SimCenter simCenter;

inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

equation
  inlet.p = outlet.p;
  inlet.m_flow + outlet.m_flow = 0;
  inlet.T_outflow=inStream(outlet.T_outflow);
  outlet.T_outflow=inStream(inlet.T_outflow);
  inlet.xi_outflow=inStream(outlet.xi_outflow);
  outlet.xi_outflow=inStream(inlet.xi_outflow);

  annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),                               Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                  graphics),
                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                         graphics));
end gasSensorBase;
