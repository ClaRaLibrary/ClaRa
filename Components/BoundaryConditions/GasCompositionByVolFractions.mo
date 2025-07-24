within ClaRa.Components.BoundaryConditions;
model GasCompositionByVolFractions "set (flue) gas composition graphically by volume fractions"
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
extends ClaRa.Basics.Icons.VolumeComposition;
  Modelica.Blocks.Interfaces.RealOutput X[medium.nc - 1] "composition of gas to be set"
    annotation (Placement(transformation(extent={{120,0},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  TILMedia.Gas.Gas_pT gas(
    gasType=medium,
    p=100000,
    T=293.15) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  parameter Real eps_ASH "volume fraction of ash";
  parameter Real eps_CO "volume fraction of carbon monoxide";
  parameter Real eps_CO2 "volume fraction of carbon dioxide";
  parameter Real eps_SO2 "volume fraction of sulphur dioxide";
  parameter Real eps_N2 "volume fraction of nitrogen (N2)";
  parameter Real eps_O2 "volume fraction of oxygen (O2)";
  parameter Real eps_NO "volume fraction of nitrogen oxide";
  parameter Real eps_H2O "volume fraction of water";
  parameter Real YNH3 "volume fraction of ammonia";
  //parameter Real YAr;
  Real sumXi "control sum of set mass fractions";
  Real M_avg "molar mass of mixture";
protected
  outer ClaRa.SimCenter simCenter;
public
  ClaRa.Basics.Units.MassFraction xi_in[medium.nc - 1];
  TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel;

equation
  M_avg = eps_ASH * gas.M_i[1] + eps_CO * gas.M_i[2] + eps_CO2 * gas.M_i[3] + eps_SO2 * gas.M_i[4]
      + eps_N2 * gas.M_i[5] + eps_O2 * gas.M_i[6] + eps_NO * gas.M_i[7] + eps_H2O * gas.M_i[8]
      + YNH3 * gas.M_i[9] + (1.0 - (eps_ASH + eps_CO + eps_CO2 + eps_SO2 + eps_N2 + eps_O2 + eps_H2O + YNH3)) * gas.M_i[10];
  xi_in[1] = eps_ASH * gas.M_i[1]/M_avg;
  xi_in[2] = eps_CO * gas.M_i[2]/M_avg;
  xi_in[3] = eps_CO2 * gas.M_i[3]/M_avg;
  xi_in[4] = eps_SO2 * gas.M_i[4]/M_avg;
  xi_in[5] = eps_N2 * gas.M_i[5]/M_avg;
  xi_in[6] = eps_O2 * gas.M_i[6]/M_avg;
  xi_in[7] = eps_NO * gas.M_i[7]/M_avg;
  xi_in[8] = eps_H2O * gas.M_i[8]/M_avg;
  xi_in[9] = YNH3 * gas.M_i[9]/M_avg;

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
end GasCompositionByVolFractions;
