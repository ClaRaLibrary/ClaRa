within ClaRa.Components.Sensors;
model TinySensorGas_L1_V_flow "Ideal two port volume flow sensor, allowing for normalisation to normal conditions (0°C | 1013.25 mbar)"
  //This model douplicates the respective ClaRa sensor changing its icon size //

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

  extends ClaRa.Basics.Icons.FlowSensor;
  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel "Medium to be used"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean normalise = false "True if value is normalised to DIN norm conditions (0°C | 1013.25 mbar)" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"), choices(choice=1 "m3/s", choice=2 "m3/h", choice=3 "l/h", choice=4 "l/s", choice=5 "per Unit"));
  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_ref[2]={0,1} "Reference flow rate [min,max]" annotation(Dialog(group="Fundamental Definitions", enable = (unitOption==5)));
  final parameter String unit = if normalise then if unitOption==1 then " m3(N)/s" elseif unitOption==2 then " m3(N)/h" elseif unitOption==3 then " l(N)/h" elseif unitOption==4 then " l(N)/s" else (" p.u.(N)") else
                                                          if unitOption==1 then " m3/s" elseif unitOption==2 then " m3/h" elseif unitOption==3 then " l/h" elseif unitOption==4 then " l(N)/s" else (" p.u.");
protected
  Real NC "Normal conversion coefficitient";
public
  Modelica.Blocks.Interfaces.RealOutput V_flow(final quantity="Volume flow",
                                                            displayUnit = "m3/s",
    final unit="m3/s") "Volume flow in port"
    annotation (Placement(transformation(extent={{60,0},{80,20}},   rotation=
            0), iconTransformation(extent={{60,0},{80,20}})));
  ClaRa.Basics.Interfaces.GasPortIn   inlet(Medium=medium) "Inlet port" annotation (
      Placement(transformation(extent={{-70,-70},{-50,-50}}),iconTransformation(
          extent={{-70,-70},{-50,-50}})));
  ClaRa.Basics.Interfaces.GasPortIn    outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}}),
        iconTransformation(extent={{50,-70},{70,-50}})));
  TILMedia.Gas.Gas_pT gas(
    gasType=medium,
    p=inlet.p,
    T=noEvent(actualStream(inlet.T_outflow)),
    xi=noEvent(actualStream(inlet.xi_outflow))) annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  TILMedia.Gas.Gas_pT gasN(
    gasType=medium,
    p(displayUnit="Pa") = 1.01325e5,
    T(displayUnit="K") = 273.15,
    xi=noEvent(actualStream(inlet.xi_outflow))) "normalised conditions (DIN)"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
equation
  if normalise == false then
    NC=1/gas.d;
  else
    NC=1/gasN.d;
  end if;
  if unitOption==1 then // m3/s
    V_flow = NC*inlet.m_flow;
  elseif unitOption==2 then // m3 per hour
    V_flow = NC*inlet.m_flow*3600;
  elseif unitOption==3 then // l/h
    V_flow = NC*inlet.m_flow*3600*1000;
  elseif unitOption==4 then // l per s
    V_flow = NC*inlet.m_flow*1000;
  elseif unitOption==5 then //p.u.
    V_flow = (NC*inlet.m_flow-V_flow_ref[1])/(V_flow_ref[2]-V_flow_ref[1]);
  else
    V_flow=-1; //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;
  inlet.p = outlet.p;
  inlet.m_flow + outlet.m_flow = 0;
  inlet.T_outflow = inStream(outlet.T_outflow);
  outlet.T_outflow = inStream(inlet.T_outflow);
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);

  annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
<p>Friedrich Gottelt, Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH, Copyright &copy; 2019-2020</p>
<p><a href=\"http://www.fvtr.de\">www.fvtr.de</a>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH for industry projects in cooperation with Lausitz Energie Kraftwerke AG, Cottbus.</p>
<b>Acknowledgements:</b>
<p>This model contribution is sponsored by Lausitz Energie Kraftwerke AG.</p>

<p><a href=\"http://www.leag.de\">www.leag.de</a> </p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
        revisions="<html>
<body>
<table>
  <tr>
    <th style=\"text-align: left;\">Date</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Version</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Author</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Affiliation</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Changes</th>
  </tr>
  <tr>
    <td>2020-08-20</td>
    <td> </td>
    <td>ClaRa 1.6.0</td>
    <td> </td>
    <td>Friedrich Gottelt</td>
    <td> </td>
    <td>FVTR GmbH</td>
    <td> </td>
    <td>Initial version of model</td>
  </tr>
</table>
<p>Version means first ClaRa version where the applied change was published.</p>
</body>
</html>"),
         Diagram(coordinateSystem(extent={{-60,-60},{60,60}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}}),
                                      graphics={
        Text(
          extent={{-54,42},{36,-28}},
          lineColor={118,124,127},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="F"),
        Text(
          extent={{-80,62},{80,92}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if V_flow > 0 then if normalise then {115,150,0} else {118,106,98} else {167,25,48}),
          textString=DynamicSelect(" V_flow ", String(V_flow, format="1.1f")+ unit)),
        Line(
          points={{-60,-60},{60,-60}},
          color={118,106,98},
          smooth=Smooth.None,
          thickness=0.5)}));
end TinySensorGas_L1_V_flow;
