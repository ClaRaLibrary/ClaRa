within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
partial model HeatTransfer_L3 "L3 || HT-BaseClass"
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L3;
  extends ClaRa.Basics.Icons.Alpha;
  outer ClaRa.Basics.Records.IComVLE_L3 iCom;

  outer parameter Boolean useHomotopy;

  ClaRa.Basics.Interfaces.HeatPort_a heat[iCom.N_cv] annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  parameter String temperatureDifference="Zonal temperatures" "Temperature Difference" annotation (Dialog(group="Heat Transfer"), choices(choice="Zonal tempartures"));

  //   SI.Temperature Delta_T_wi
  //     "Temperature difference between wall and fluid inlet temperature";
  //   SI.Temperature Delta_T_wo
  //     "Temperature difference between wall and fluid outlet temperature";

  Units.Temperature Delta_T_mean[iCom.N_cv] "Mean temperature difference between wall and fluid";

  //   SI.Temperature Delta_T_U;
  //   SI.Temperature Delta_T_L;
  //   //constant Real eps=1e-4;
  //   //SI.Temperature T_mean;

equation
  //   Delta_T_wi = heat[1].T-iCom.T_in;
  //   Delta_T_wo = heat[iCom.N_cv].T-iCom.T_out;
  //   Delta_T_U=  max(Delta_T_wi,Delta_T_wo);
  //   Delta_T_L= min(Delta_T_wi,Delta_T_wo);

  //    DT_mean= noEvent(if floor(abs(DT_wo)*1/eps)<=1 or floor(abs(DT_wi)*1/eps)<=1 then 0
  //     elseif
  //           (DT_wo<-eps and DT_wi>eps) or (DT_wo>eps and DT_wi<-eps) then 0 elseif  floor(abs(DT_wo-DT_wi)*1/eps)<1 then DT_wi
  //                          else (DTU-DTL)/log(DTU/DTL));
  //   DT_mean= (if abs(DT_wo)<=1e-6 or abs(DT_wi)<=1e-6 then 0
  //    elseif
  //          (heat.T<iCom.T_out and heat.T>iCom.T_in) or (heat.T>iCom.T_out and heat.T<iCom.T_in) then 0 elseif  abs(DT_wo-DT_wi)<1e-6 then DT_wi
  //                         else (DTU-DTL)/log(DTU/DTL));
  //

  //    T_mean= if useHomotopy then homotopy(((max(iCom.T_out,iCom.T_in)+2*1e-3)-(min(iCom.T_out,iCom.T_in)))/noEvent(log((max(iCom.T_out,iCom.T_in)+2*1e-3)/(min(iCom.T_out,iCom.T_in)+2*1e-3))), iCom.T)
  //                           else          ((max(iCom.T_out,iCom.T_in)+2*1e-3)-(min(iCom.T_out,iCom.T_in)))/noEvent(log((max(iCom.T_out,iCom.T_in)+2*1e-3)/(min(iCom.T_out,iCom.T_in)+2*1e-3)));

  if temperatureDifference == "Zonal temperatures" then
    for i in 1:iCom.N_cv loop
      Delta_T_mean[i] = heat[i].T - iCom.T[i];
    end for;
  else
    Delta_T_mean = fill(0, iCom.N_cv);
    assert(false, "unknown option for temperature difference");
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
</html>", revisions=
      "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(graphics),
    Diagram(graphics));
end HeatTransfer_L3;
