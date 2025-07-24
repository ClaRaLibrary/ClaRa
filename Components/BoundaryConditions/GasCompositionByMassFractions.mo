within ClaRa.Components.BoundaryConditions;
model GasCompositionByMassFractions "set (flue) gas composition graphically"
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

  extends ClaRa.Basics.Icons.MassComposition;
  Modelica.Blocks.Interfaces.RealOutput X[medium.nc - 1] "composition of gas to be set"
    annotation (Placement(transformation(extent={{120,0},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  parameter Real xi_ASH "Mass fraction of ash";
  parameter Real xi_CO "Mass fraction of carbon monoxide (CO)";
  parameter Real xi_CO2 "Mass fraction of carbon dioxide (CO2)";
  parameter Real xi_SO2 "Mass fraction of sulphur dioxide (SO2)";
  parameter Real xi_N2 "Mass fraction of nitrogen (N2)";
  parameter Real xi_O2 "Mass fraction of oxygen (O2)";
  parameter Real xi_NO "Mass fraction of nitrogen oxide (NO)";
  parameter Real xi_H2O "Mass fraction of water (H2O)";
  parameter Real xi_NH3 "Mass fraction of ammonia (NH3)";
  Real sumXi "control sum of set mass fractions";

protected
  outer ClaRa.SimCenter simCenter;
public
  ClaRa.Basics.Units.MassFraction xi_in[medium.nc - 1];
  TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel;
equation
  xi_in[1] = xi_ASH;
  xi_in[2] = xi_CO;
  xi_in[3] = xi_CO2;
  xi_in[4] = xi_SO2;
  xi_in[5] = xi_N2;
  xi_in[6] = xi_O2;
  xi_in[7] = xi_NO;
  xi_in[8] = xi_H2O;
  xi_in[9] = xi_NH3;

  X = xi_in;
algorithm
  for i in 1:  1:  size(xi_in,1) loop
    sumXi :=sumXi + xi_in[i];
  end for;

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
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),Diagram(graphics),Icon(graphics));
end GasCompositionByMassFractions;
