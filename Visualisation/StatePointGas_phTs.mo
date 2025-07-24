within ClaRa.Visualisation;
model StatePointGas_phTs "Complete state definition for visualisation in ph, TS, hs-diagrams"
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

  outer SimCenter simCenter;

  parameter TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel "Medium to be used"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Integer stateViewerIndex=0 "Index for StateViewer" annotation(Dialog(group="StateViewer Index"));
  ClaRa.Basics.Units.Pressure p "Pressure of state";
  ClaRa.Basics.Units.EnthalpyMassSpecific h=state.h "Specific enthalpy of state";
  ClaRa.Basics.Units.EntropyMassSpecific s=state.s "Specific enthalpy of state";
  ClaRa.Basics.Units.Temperature T "Temperature of state";
  ClaRa.Basics.Units.VolumeMassSpecific v=1/state.d "Specific volume of state";

  ClaRa.Basics.Interfaces.GasPortIn port(Medium=medium)
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));

protected
  TILMedia.Gas.Gas_pT state(
    p=p,
    T=T,
    xi=inStream(port.xi_outflow),
    gasType=medium) annotation (Placement(transformation(extent={{-20,0},{0,20}})));

equation
  T=inStream(port.T_outflow);
  p=port.p;
  port.m_flow=0;
  port.T_outflow=0;
  port.xi_outflow=zeros(medium.nc-1);

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
     Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{220,260}},
        initialScale=0.04),    graphics={
        Text(
          extent={{-90,80},{150,10}},
          lineColor={118,106,98},
          fillColor={0,131,169},
          horizontalAlignment=TextAlignment.Left,
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("p", String(p/1e5,format="1.1f") + " bar")),
        Text(
          extent={{-92,-10},{248,-80}},
          lineColor={118,106,98},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("h", String(h/1e3,format="1.1f") + " kJ/kg")),
        Text(
          extent={{-90,170},{150,100}},
          lineColor={118,106,98},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("T", String(T-273.15,format="1.1f") + " C")),
        Text(
          extent={{-90,260},{250,190}},
          lineColor={118,106,98},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("s", String(s/1e3,format="1.1f") + " kJ/(kgK)")),
        Line(
          points={{-100,258},{-100,-100}},
          color={118,106,98},
          smooth=Smooth.None,thickness=0.5)}),                                                                           Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{220,260}},
        initialScale=0.08),  graphics));
end StatePointGas_phTs;
