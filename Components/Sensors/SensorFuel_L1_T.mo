within ClaRa.Components.Sensors;
model SensorFuel_L1_T "Ideal one port temperature sensor"
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

  extends ClaRa.Basics.Icons.Sensor1;
  outer ClaRa.SimCenter simCenter;

  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1   "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Integer unitOption = 1 "Unit of output" annotation(choicesAllMatching, Dialog( group="Fundamental Definitions"), choices(choice=1 "Kelvin", choice=2 "Degree Celsius",
                                                                                              choice=3 "Degree Fahrenheit", choice = 4 "per Unit"));
  parameter ClaRa.Basics.Units.Temperature T_ref[2]={0,273.15} "Reference temperature [min,max]" annotation (Dialog(group="Fundamental Definitions", enable=(unitOption == 4)));
  ClaRa.Basics.Units.Temperature_DegC T_celsius "Temperatur in Degree Celsius";

  Modelica.Blocks.Interfaces.RealOutput T "Temperature in port medium" annotation (Placement(transformation(extent={{100,-10},{120,10}},
                                                                    rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));
  ClaRa.Basics.Interfaces.Fuel_inlet port(fuelModel=fuelModel) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

protected
  ClaRa.Basics.Units.Temperature T_Kelvin "Temperatur in Kelvin";
equation
  if unitOption == 1 then //Kelvin
    T = T_Kelvin;
  elseif unitOption == 2 then // Degree Celsius
    T =Modelica.Units.Conversions.to_degC(T_Kelvin);
  elseif unitOption == 3 then // Degree Fahrenheit
    T =Modelica.Units.Conversions.to_degF(T_Kelvin);
  elseif unitOption==4 then // per Unit
    T =(T_Kelvin-T_ref[1])/(T_ref[2]-T_ref[1]);
  else
    T=-1;  //dummy
    assert(false, "Unknown unit option in " + getInstanceName());
  end if;

  T_celsius = T_Kelvin - 273.15;
  T_Kelvin = inStream(port.T_outflow);
  port.m_flow = 0;
  port.T_outflow = 0;
  port.xi_outflow = zeros(fuelModel.N_c-1);



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
          textString="TIT"),
        Text(
          extent={{-100,60},{60,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if T_celsius > 0 then {27,36,42} else {167,25,48}),
          textString=DynamicSelect(" T ", String(T, format="1.1f"))),
        Text(
          extent={{50,90},{90,60}},
          lineColor=DynamicSelect({230, 230, 230},  if T_celsius>0 then {27,36,42} else {167,25,48}),
          textString=DynamicSelect("", if unitOption==1 then "K" elseif unitOption==2 then "°C" elseif unitOption==3 then "°F" else "p.u."),
          horizontalAlignment=TextAlignment.Left)}));
end SensorFuel_L1_T;
