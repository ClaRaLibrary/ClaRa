within ClaRa.Components.Sensors;
model SensorGas_L1_p "Ideal one port pressure sensor"
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
  extends ClaRa.Basics.Icons.Sensor1;
  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"),Placement(transformation(extent={{42,-2},{62,18}})));

  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching,  Dialog(group="Fundamental Definitions"), choices(choice=1 "Pa", choice=2 "bar", choice=3 "mbar", choice=4 "MPa", choice = 5 "per Unit"));

  Modelica.Blocks.Interfaces.RealOutput p(final quantity="Pressure", displayUnit = "bar",final unit="Pa") "pressure in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
                                                                    rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));

  parameter ClaRa.Basics.Units.Pressure p_ref[2]={0,1e5} "Reference pressure [min,max]" annotation (Dialog(group="Fundamental Definitions", enable=(unitOption == 5)));

  Basics.Interfaces.GasPortIn port(Medium = medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));


equation

  if unitOption==1 then
    p = port.p;
  elseif unitOption==2 then
    p=port.p/1e5;
  elseif unitOption==3 then
    p=port.p/100;
  elseif unitOption==4 then
    p=port.p/1e6;
  elseif unitOption==5 then
    p = (port.p- p_ref[1])/(p_ref[2]-p_ref[1]);
  else
    p=-1; //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;

  port.m_flow = 0;
  port.T_outflow = 0;
  port.xi_outflow = zeros(medium.nc - 1);

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
</html>"),Diagram(graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
                Text(
          extent={{-100,60},{60,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if p > 0 then {118,106,98} else {167,25,48}),
          textString=DynamicSelect(" p ", String(p,format="1.1f"))),
        Text(
          extent={{40,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if p > 0 then {118,106,98} else {167,25,48}),
textString=DynamicSelect("", if unitOption==1 then "Pa" elseif unitOption==2 then "bar" elseif unitOption == 3 then "mbar" elseif initOption==4 then "MPa" else "p.u.")),
        Text(
          extent={{-98,36},{102,-4}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="PIT")}));
end SensorGas_L1_p;
