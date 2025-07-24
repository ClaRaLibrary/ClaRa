within ClaRa.Components.BoundaryConditions;
model BoundaryVLE_phxi "A boundary defining pressure, enthalpy and composition"
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
  import SI = ClaRa.Basics.Units;
extends ClaRa.Basics.Icons.FlowSink;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=if energyType == 1 then -steam_a.m_flow*actualStream(steam_a.h_outflow) else 0,
    powerOut_th=if energyType == 2 then steam_a.m_flow*actualStream(steam_a.h_outflow) else 0,
    powerOut_elMech=0,
    powerAux=0)  if contributeToCycleSummary;
  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

 parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                              annotation(Dialog(tab="Summary and Visualisation"));
  parameter Integer  energyType=0 "Type of energy" annotation(Dialog(tab="Summary and Visualisation"), choices(choice = 0 "Energy is loss", choice = 1 "Energy is effort", choice=2 "Energy is profit"));

  parameter Boolean variable_p=false "True, if pressure defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_h=false "True, if spc. enthalpy defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));

  parameter Basics.Units.Pressure p_const=0 "Constant pressure" annotation (Dialog(group="Constant Boundaries", enable=not variable_p));
  parameter Basics.Units.EnthalpyMassSpecific h_const=1e5 "Constant specific enthalpy of source" annotation (Dialog(group="Constant Boundaries", enable=not variable_h));
  parameter Basics.Units.MassFraction xi_const[medium.nc - 1]=zeros(medium.nc - 1) "Constant composition" annotation (Dialog(group="Constant Boundaries", enable=not variable_xi));
  parameter Basics.Units.Pressure Delta_p=0 "Flange pressure drop at nominal mass flow (zero refers to ideal boundary)" annotation (Dialog(group="Nominal Values"));
  parameter Basics.Units.MassFlowRate m_flow_nom=1 "Nominal flange mass flow " annotation (Dialog(group="Nominal Values"));
  outer ClaRa.SimCenter simCenter;
protected
  Basics.Units.Pressure p_in;
  Basics.Units.EnthalpyMassSpecific h_in;
  Basics.Units.MassFraction xi_in[medium.nc - 1];

protected
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    p=steam_a.p,
    h=noEvent(actualStream(steam_a.h_outflow)),
    xi=xi_in) annotation (Placement(transformation(extent={{22,-20},{42,0}})));

public
  ClaRa.Basics.Interfaces.FluidPortIn steam_a(Medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput p=p_in if (variable_p) "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput h=h_in if (variable_h) "Variable specific enthalpy"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput xi[medium.nc-1]=xi_in
    if (variable_xi) "Variable composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));

public
  Basics.Interfaces.EyeOut       eye if showData
    annotation (Placement(transformation(extent={{94,-86},{106,-74}}),
        iconTransformation(extent={{94,-86},{106,-74}})));
protected
  Basics.Interfaces.EyeIn       eye_int[1]
    annotation (Placement(transformation(extent={{55,-81},{57,-79}}),
        iconTransformation(extent={{55,-55},{57,-53}})));
equation

  if (not variable_p) then
    p_in=p_const;
  end if;
  if (not variable_h) then
    h_in=h_const;
  end if;
  if (not variable_xi) then
    xi_in=xi_const;
  end if;

  steam_a.h_outflow=h_in;
  if Delta_p>0 then
    steam_a.p=p_in + Delta_p/m_flow_nom*steam_a.m_flow;
  else
    steam_a.p=p_in;
  end if;
  steam_a.xi_outflow=xi_in;

  eye_int[1].m_flow = -steam_a.m_flow;
  eye_int[1].T = fluidOut.T-273.15;
  eye_int[1].s = fluidOut.s/1e3;
  eye_int[1].p = steam_a.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;
  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-80},{56,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
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
   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Text(
          extent={{-100,30},{10,-30}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="h
xi")}),                       Diagram(graphics,
                                      coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}})));
end BoundaryVLE_phxi;
