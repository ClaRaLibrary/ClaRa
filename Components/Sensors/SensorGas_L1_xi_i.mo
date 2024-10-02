within ClaRa.Components.Sensors;
model SensorGas_L1_xi_i "Ideal one port gas composition sensor"
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


  Modelica.Blocks.Interfaces.RealOutput fraction[simCenter.flueGasModel.nc-1] "fraction (volume or mass) in port"
    annotation (Placement(transformation(extent={{44,60},{64,80}},  rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));

//parameter Integer compositionDefinedBy "output gives mass or volume fraction"  annotation(choices(choice = 1 "mass", choice = 2 "volume"));

  TILMedia.Gas_pT gas(p = inlet.p, T = noEvent(actualStream(inlet.T_outflow)), xi = noEvent(actualStream(inlet.xi_outflow)), gasType= medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  if unitOption == 1 then
    fraction = {gas.xi[i] for i in 1:medium.nc-1};
  else
    fraction = {gas.x[i] for i in 1:medium.nc-1};
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
        Line(
          points={{-98,-100},{96,-100}},
          color={118,106,98},
          smooth=Smooth.None,
          thickness=0.5)}));
end SensorGas_L1_xi_i;
