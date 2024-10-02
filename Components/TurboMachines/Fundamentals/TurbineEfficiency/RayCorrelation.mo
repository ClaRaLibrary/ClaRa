within ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency;
model RayCorrelation "Semi-empirical correlation | Shaft speed and isentropic enthalpy drop dependent"
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

//The model is described in Asok Ray: "Dynamic Modelling of Power Plant Turbines for Controller Design" in Appl. Math. Modelling, 1980, Vol.4, pages 109-112.
  extends ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.EfficiencyModelBase;
 parameter Real eta_nom=0.94 "Isentropic efficiency at nominal load";
 parameter Real C_load=2 "Form factor for load dependency";
  parameter Basics.Units.RPM rpm_nom=3000 "Nominal shaft speed";
  parameter Basics.Units.EnthalpyMassSpecific Delta_h_is_nom=250e3 "Nominal isentropic enthalpy drop";
     Real eta "Efficiency";

equation
    eta=eta_nom-C_load*(iCom.rpm/sqrt(abs(iCom.Delta_h_is))/(rpm_nom/sqrt(Delta_h_is_nom))-1)^2;

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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(graphics, coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)));
end RayCorrelation;
