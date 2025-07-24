within ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL;
model LinearPressureLoss_L4 "Medium independent || Linear PL with const. PL coeff"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseFlatTubeFinnedGas_L4;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBasePlateVLE_L4;
  final parameter ClaRa.Basics.Units.Length length=sum(geo.Delta_x);
equation
  if not frictionAtInlet and not frictionAtOutlet then
    for i in 2:iCom.N_cv loop
      m_flow[i] = m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(length - geo.Delta_x_FM[1] - geo.Delta_x_FM[iCom.N_cv + 1]));
    end for;
    Delta_p[1] = 0;
    Delta_p[iCom.N_cv + 1] = 0;

  elseif not frictionAtInlet and frictionAtOutlet then
    for i in 2:iCom.N_cv + 1 loop
      m_flow[i] = m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(length - geo.Delta_x_FM[1]));
    end for;
    Delta_p[1] = 0;

  elseif frictionAtInlet and not frictionAtOutlet then
    for i in 1:iCom.N_cv loop
      m_flow[i] = m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/(length - geo.Delta_x_FM[iCom.N_cv + 1]));
    end for;
    Delta_p[iCom.N_cv + 1] = 0;

  else
    //FlowModel=FlowModelStructure.inlet_dp_innerPipe_dp_outlet
    for i in 1:iCom.N_cv + 1 loop
      m_flow[i] = m_flow_nom*Delta_p[i]/Delta_p_nom ./ ((geo.Delta_x_FM[i])/length);
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
end LinearPressureLoss_L4;
