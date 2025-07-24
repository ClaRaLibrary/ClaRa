within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model QuadraticNominalPoint_L4 "Medium independent || Nominal point, property independent"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseFlatTubeFinnedGas_L4;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBasePlateVLE_L4;

  //  outer ClaRa.Components.ComponentBaseClasses.Fundamentals2.PipeGeometry geo;

  parameter Modelica.Units.SI.Pressure Delta_p_smooth=iCom.Delta_p_nom/iCom.N_cv*0.2 "|Small Mass Flows|For pressure losses below this value the square root of the quadratic pressure loss model is regularised";

  final parameter Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta_TOT=iCom.Delta_p_nom/iCom.m_flow_nom^2 "Pressure loss coefficient for total pipe";
protected
  Modelica.Fluid.Dissipation.Utilities.Types.PressureLossCoefficient zeta[iCom.N_cv + 1] "Pressure loss coefficient for total pipe";

equation
  // Note that we want distribute zeta linearly over tha pipe length. Hence use zeta[i]=zeta_TOT*geo.Delta_x_FM[i]/(L -geo.Delta_x_FM[1]-geo.Delta_x_FM[N_cv+1] ) <-- notice that the last two terms depend on the flow model
  // for the homotopy equation we use a linear function depending on the nominal pressure difference and mass flow and the actual pressure difference.
  // Notice that we have to use the rugularised square root in order to allow for negative initial pressure losses!
  if not frictionAtInlet and not frictionAtOutlet then
    for i in 2:iCom.N_cv loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]);
      m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]))) else sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
    end for;
    zeta[1] = 0;
    Delta_p[1] = 0;
    zeta[iCom.N_cv + 1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  elseif not frictionAtInlet and frictionAtOutlet then
    for i in 2:iCom.N_cv + 1 loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1]);
      m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[1]))) else sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
    end for;
    zeta[1] = 0;
    Delta_p[1] = 0;

  elseif frictionAtInlet and not frictionAtOutlet then
    for i in 1:iCom.N_cv loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv + 1]);
      m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(sum(geo.Delta_x_FM) - geo.Delta_x_FM[iCom.N_cv + 1]))) else sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
    end for;
    zeta[iCom.N_cv + 1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  else
    //frictionAtInlet and frictionAtOutlet
    for i in 1:iCom.N_cv + 1 loop
      zeta[i] = zeta_TOT*geo.Delta_x_FM[i]/(sum(geo.Delta_x_FM));
      m_flow[i] = if useHomotopy then homotopy(sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth), m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/sum(geo.Delta_x_FM))) else sqrt(1/zeta[i])*ClaRa.Basics.Functions.ThermoRoot(Delta_p[i], Delta_p_smooth);
    end for;

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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end QuadraticNominalPoint_L4;
