within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes;
model CounterFlow_L3 "Pure counter flow heatexchanger L3"
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

//VDI-Waermeatlas Chapter Ca5, 9th edition, VDI-Verlag,2006

extends ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger_L3(
    final a=0,
    final b=0,
    final c=0,
    final d=0.5);
extends ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Icons.HEX_CounterFlow_Icon;
equation
  h_o_in[1] = iCom.h_o_inlet;
  h_o_in[2] = iCom.h_o_out[1];
  h_o_in[3] = iCom.h_o_out[2];

  h_i_in[1] = iCom.h_i_out[2];
  h_i_in[2] = iCom.h_i_out[3];
  h_i_in[3] = iCom.h_i_inlet;

  T_in2out_o=iCom.T_123_o[{1,2,3,4,5,6}];
  T_in2out_i=iCom.T_123_i[{5,6,3,4,1,2}];

  if outerPhaseChange then
    iCom.Delta_h_1ph = noEvent(if T_in2out_o[1] > T_in2out_i[1] then iCom.h_o_out[1] else -iCom.h_o_out[1])
               - noEvent(if T_in2out_o[1] > T_in2out_i[1] then iCom.h_o_vap else -iCom.h_o_bub);
    iCom.Delta_h_2ph = noEvent(if T_in2out_o[1] > T_in2out_i[1] then iCom.h_o_out[2] else -iCom.h_o_out[2])
                - noEvent(if T_in2out_o[1] > T_in2out_i[1] then iCom.h_o_bub else -iCom.h_o_vap);

  else
    iCom.Delta_h_1ph = noEvent(if T_in2out_o[1] > T_in2out_i[1] then -iCom.h_i_out[3] else -iCom.h_i_out[3])
              - noEvent(if T_in2out_o[1] > T_in2out_i[1] then -iCom.h_i_bub else -iCom.h_i_vap);
    iCom.Delta_h_2ph = noEvent(if T_in2out_o[1] > T_in2out_i[1] then -iCom.h_i_out[2] else iCom.h_i_out[2])
              - noEvent(if T_in2out_o[1] > T_in2out_i[1] then -iCom.h_i_vap else iCom.h_i_bub);

  end if;

  if outerPhaseChange then
    yps[1] = yps_1ph;
    yps[2] = noEvent(max(0,min(1-yps_1ph, yps_2ph)));
    yps[3] = noEvent(max(0,min(1,1-yps[1]-yps[2])));
  else
     yps[3] = yps_1ph;
     yps[2] = noEvent(max(0,min(1-yps_1ph, yps_2ph)));
     yps[1] = noEvent(max(0,min(1,1-yps[3]-yps[2])));
  end if;
  ff_i ={1,1,1};
  ff_o ={1,1,1};
  z_o = {0,yps[1],yps[1],yps[1] + yps[2],yps[1] + yps[2],yps[1] + yps[2] + yps[3]};
  z_i= {yps[1] + yps[2] + yps[3], yps[1] + yps[2],  yps[1] + yps[2], yps[1], yps[1], 0};

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
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics));
end CounterFlow_L3;
