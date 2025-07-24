within ;
package ClaRa "Simulation of Clausius-Rankine Cycles"
  extends ClaRa.Basics.Icons.PackageIcons.ClaRab100;
  import SI = ClaRa.Basics.Units;
























  annotation (preferedView="info",version="1.9.0",
                           uses(
    Modelica(version="4.0.0"), TILMedia(version="1.9.0 ClaRa"),SMArtInt(version="0.5.1")),
                                       Icon(graphics,
                                      coordinateSystem(preserveAspectRatio=
          false, extent={{-100,-100},{100,100}})),
  conversion(from(version="0.0",to="0.1 alpha",  script="modelica://ClaRa/Resources/Scripts/ConvertFrom000.mos"),
    from(version="0.1 alpha",to="0.2 alpha", script="modelica://ClaRa/Resources/Scripts/ConvertFrom010.mos"),
    from(version="0.2 alpha",to="0.2.1 alpha", script="modelica://ClaRa/Resources/Scripts/ConvertFrom020.mos"),
    from(version="0.2.1 alpha",to="0.2.2 alpha", script="modelica://ClaRa/Resources/Scripts/ConvertFrom021.mos"),
    from(version="0.2.2 alpha",to="1.0.1", script="modelica://ClaRa/Resources/Scripts/ConvertFrom022.mos"),
    from(version="1.0.1",to="1.1.2", script="modelica://ClaRa/Resources/Scripts/ConvertFrom101.mos"),
    from(version="1.1.2",to="1.2.1", script="modelica://ClaRa/Resources/Scripts/ConvertFrom112_to_121.mos"),
    from(version="1.2.1",to="1.3.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom12x_to_130.mos"),
    from(version="1.2.2",to="1.3.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom12x_to_130.mos"),
    from(version="1.2.3",to="1.3.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom12x_to_130.mos"),
    from(version="1.3.0",to="1.3.1", script="modelica://ClaRa/Resources/Scripts/ConvertFrom130_to_131.mos"),
    from(version="1.3.1",to="1.4.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom131_to_140.mos"),
    from(version="1.4.0",to="1.4.1", script="modelica://ClaRa/Resources/Scripts/ConvertFrom140_to_141.mos"),
    from(version="1.4.1",to="1.5.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom141_to_150.mos"),
    from(version="1.5.0",to="1.6.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom150_to_160.mos"),
    from(version="1.6.0",to="1.6.1", script="modelica://ClaRa/Resources/Scripts/ConvertFrom160_to_161.mos"),
    from(version="1.6.1",to="1.7.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom161_to_170.mos"),
    from(version="1.7.0",to="1.8.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom170_to_180.mos"),
    from(version="1.8.0",to="1.8.1", script="modelica://ClaRa/Resources/Scripts/ConvertFrom180_to_181.mos"),
    from(version="1.8.1",to="1.8.2", script="modelica://ClaRa/Resources/Scripts/ConvertFrom181_to_182.mos"),
 from(version="1.8.2",to="1.9.0", script="modelica://ClaRa/Resources/Scripts/ConvertFrom182_to_190.mos")),
  Documentation(info="<html>
<p><img src=\"modelica://ClaRa/Resources/Images/ClaRaLibraryInfo.png\"/></p>
<p><h4> Coordinating developers:</h4></p>
<ul>
<li>ClaRa development team (TLK Thermo GmbH, XRG Simulation GmbH)</li>
<li>Lasse Nielsen, Ales Vojacek, Johannes Brunnemann</li>
</ul>
<p><h4>Further developers:</h4></p>
<ul>
<li>Gottelt, Friedrich </li>
<li>Hoppe, Timm </li>
<li>Renz, Ala </li>
<li>Scheffler, Jan </li>
<li>Gulba, Milan </li>
<li>Von der Heyde, Michael </li>
<li>Von Ohlen, Carsten </li>
</ul>
</html>"));
end ClaRa;
