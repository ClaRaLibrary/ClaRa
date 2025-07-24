within ClaRa.Visualisation;
model StatePoint "State Point of fluid without visualisation"
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

//  parameter String unit="C" "Variable unit";
  parameter Integer identifier= -1 "Identifier of the quadruple" annotation(Dialog(group="Indices"));
  parameter Integer stateViewerIndex=-1 "Index for StateViewer" annotation(Dialog(group="Indices"));
  parameter Boolean useEyeIn=true "True if connector shall be used" annotation(Dialog(group="Input"));
  Real p "Pressure in bar";
  Real h "Specific enthalpy in kJ/kg";
  Real s "Specific entropy in kJ/(kg*s)";
  Real T "Temperature in C";
  Real m_flow "Mass flow rate in kg/s";
  input ClaRa.Basics.Units.Pressure p_in=1e5 "Input pressure" annotation (Dialog(group="Input", enable=not useEyeIn));
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_in=200e3 "Specific enthalpy of state" annotation (Dialog(group="Input", enable=not useEyeIn));
  input ClaRa.Basics.Units.EntropyMassSpecific s_in=1e3 "Specific enthalpy of state" annotation (Dialog(group="Input", enable=not useEyeIn));
  input ClaRa.Basics.Units.Temperature T_in=273.15 + 20 "Temperature of state" annotation (Dialog(group="Input", enable=not useEyeIn));
  input ClaRa.Basics.Units.MassFlowRate m_flow_in=1 "Mass flow rate" annotation (Dialog(group="Input", enable=not useEyeIn));
  outer ClaRa.SimCenter simCenter;

  ClaRa.Basics.Interfaces.EyeIn eye(p=p, h=h, s=s, T=T, m_flow=m_flow) if useEyeIn  annotation (Placement(transformation(extent={{-40,-10},{-20,10}}), iconTransformation(extent={{-40,-10},{-20,10}})));

equation
  if useEyeIn==false then
    p=p_in/1e5;
    h=h_in/1e3;
    s=s_in/1e3;
    T=T_in-273.15;
    m_flow=m_flow_in;
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
</html>"),
     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-20,-20},{20,20}},
        initialScale=0.05), graphics={
                             Ellipse(
          extent={{-20,-20},{20,20}},
          lineColor={215,215,215},
          lineThickness=0.5),
                            Text(
          extent={{-20,-20},{20,20}},
          lineColor={215,215,215},
          lineThickness=1,
          textString="S")}),Diagram(graphics,
                                    coordinateSystem(preserveAspectRatio=true,  extent={{-20,-20},{20,20}},
        initialScale=0.05)));
end StatePoint;
