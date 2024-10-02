within ClaRa.Components.Sensors;
model SensorGas_L1_xi "Ideal one port gas component sensor"
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

extends ClaRa.Components.Sensors.gasSensorBase;
  outer ClaRa.SimCenter simCenter;

  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"), choices(choice=1 "kg/kg", choice=2 "m^3/m^3"));

  Modelica.Blocks.Interfaces.RealOutput fraction "fraction (volume or mass) in port"
    annotation (Placement(transformation(extent={{44,60},{64,80}},  rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));

  //parameter Integer compositionDefinedBy "output gives mass or volume fraction"  annotation(choices(choice = 1 "mass", choice = 2 "volume"));
  parameter Integer component "component" annotation(choices(choice = 1 "Ash", choice = 2 "CO", choice = 3 "CO2", choice = 4 "SO2", choice = 5 "N2", choice = 6 "O2", choice = 7 "NO", choice = 8 "H2O", choice = 9 "NH3", choice = 10 "Argon"));

Real inFraction "fraction of component";
 Integer N;
  TILMedia.Gas_pT gas(p = inlet.p, T = noEvent(actualStream(inlet.T_outflow)), xi = noEvent(actualStream(inlet.xi_outflow)), gasType= medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  N = 10;
  if component == N then
        if unitOption == 1 then
          inFraction =  1.0 - sum(gas.xi);
        else
          inFraction =  1.0 - sum(gas.x);
        end if;
  elseif
    component > N then
    inFraction =  1.0;
    assert(false, "Wrong component chosen");
  elseif component == 0 then
    inFraction = 1.0;
    assert(false, "Wrong Component chosen");
  else
    if unitOption == 1 then
      inFraction =  gas.xi[component];
    else
      inFraction =  gas.x[component];
    end if;
  end if;

fraction = inFraction;
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
          extent={{-100,40},{100,0}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="QIT"),
        Text(
          extent={{-100,0},{100,-40}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-100,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if gas.p > 0 then {118,106,98} else {167,25,48}),
          textString=DynamicSelect(" xi ", String(inFraction,significantDigits=integer(1)))),
        Line(
          points={{-98,-100},{96,-100}},
          color={118,106,98},
          smooth=Smooth.None,
          thickness=0.5)}));
end SensorGas_L1_xi;
