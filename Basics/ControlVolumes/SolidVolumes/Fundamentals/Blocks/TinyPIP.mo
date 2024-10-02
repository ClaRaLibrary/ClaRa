within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Blocks;
block TinyPIP "A minimum implementation of a PI controller with anti windup compensation"


  parameter Real K_p = 1 "Controller gain" annotation (Dialog(group= "Control characteristics"));
  parameter ClaRa.Basics.Units.Time Tau_i "Integrator time constant" annotation (Dialog(group="Control characteristics"));
  parameter Real N_i= 0.9 "Ni is time constant for anti-windup compensation"  annotation (Dialog(group= "Control characteristics"));

  parameter Real y_max = 1 "Maximum output"   annotation (Dialog(group= "Limits"));
  parameter Real y_min = 0 "Minimum output"   annotation (Dialog(group= "Limits"));


  parameter Integer initOption = 1 "Initialisation option" annotation(Dialog(choicesAllMatching, group="Initialisation"), choices(choice = 1 "Integrator state at zero",
                                                                                                    choice=2 "Steady state",
                                                                                                    choice=3 "Apply guess value y_start at output",
                                                                                                    choice=4 "Force y_start at output"));
  parameter Real y_start = 1 "Initial output" annotation(Dialog(group="Initialisation", enable = initOption==3 or initOption == 4));

  input Real u annotation(Dialog);
  output Real y(start=y_start) annotation(Dialog);

protected
  Real outputP;
  Real outputI(start=0);

initial equation
  if initOption == 1 then //no init
    outputI = 0;
  elseif initOption ==2 then //steady integrator state
    der(outputI)=0;
    der(y)=0;
  elseif initOption == 3 then // initial output
    //outputI = min(y_max, max(y_min, y_start)) - outputP;
    //y = min(y_max, max(y_min, y_start));
  elseif initOption==4 then //force auto output
    //outputI = min(y_max, max(y_min, y_start)) - outputP;
    y = min(y_max, max(y_min, y_start));
  else
    assert(false, "Unknown init option in component " + getInstanceName());
  end if;

equation
  //der(outputI) = K_p/Tau_i*(u + 1/(K_p*N_i)*(min(max(y_min, y), y_max) - (outputI+outputP)));
    der(outputI) = K_p/Tau_i*(u + 1/(K_p*N_i)*(min(max(y_min, y), y_max) - (outputI+outputP)));
  outputP = K_p*u;
  y = max(y_min, min(y_max, outputI + outputP));
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
</html>", revisions=
      "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{100,0}},
          lineColor={221,222,223},
          fillColor={118,124,127},
          fillPattern=FillPattern.Solid,
          textString="PIP"),
        Text(
          extent={{-100,-6},{100,-106}},
          lineColor={221,222,223},
          fillColor={73,80,85},
          fillPattern=FillPattern.None,
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end TinyPIP;
