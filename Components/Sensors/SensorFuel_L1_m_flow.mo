within ClaRa.Components.Sensors;
model SensorFuel_L1_m_flow "Ideal two port mass flow sensor"
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

  extends ClaRa.Components.Sensors.FuelSensorBase;

  outer ClaRa.SimCenter simCenter;
  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"), choices(choice=1 "kg/s", choice=2 "t/h", choice=3 "kg/h", choice=4 "t/s", choice=5 "per Unit"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_ref[2]={0,1} "Reference flow rate [min,max]" annotation (Dialog(group="Fundamental Definitions", enable=(unitOption == 5)));

  Modelica.Blocks.Interfaces.RealOutput m_flow(
    final quantity="MassFlowRate",
    displayUnit="kg/s",
    final unit="kg/s") "Mass flow rate"          annotation (Placement(
        transformation(extent={{100,-10},{120,10}},
                                                 rotation=0),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  if unitOption==1 then // kg/s
    m_flow = inlet.m_flow;
  elseif unitOption==2 then // tons per hour
    m_flow = inlet.m_flow*3.6;
  elseif unitOption==3 then // kg/h
    m_flow = inlet.m_flow*3600;
  elseif unitOption==4 then // tons per s
    m_flow = inlet.m_flow/1000;
  elseif unitOption==5 then //p.u.
    m_flow = (inlet.m_flow-m_flow_ref[1])/(m_flow_ref[2]-m_flow_ref[1]);
  else
    m_flow=-1; //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;

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
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="FIT"),
        Text(
          extent={{-100,60},{60,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if m_flow > 0 then {27,36,42} else {167,25,48}),
          textString=DynamicSelect(" m_flow ", String(m_flow, format="1.1f"))),
        Text(
          extent={{50,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if m_flow > 0 then {27,36,42} else {167,25,48}),
          textString=DynamicSelect(" ", if unitOption==1 then "kg/s" elseif unitOption==2 then "t/h" elseif unitOption==3 then "kg/h" else "t/s")),
        Line(
          points={{-98,-100},{96,-100}},
          color={27,36,42},
          smooth=Smooth.None,
          thickness=0.5)}));
end SensorFuel_L1_m_flow;
