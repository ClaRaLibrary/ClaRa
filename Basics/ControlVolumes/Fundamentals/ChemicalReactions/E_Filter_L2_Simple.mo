within ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions;
model E_Filter_L2_Simple "Gas || L2 || Simple E-Filter"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.E_FilterBase;
  extends ChemicalReactionsBaseGas(final i=1, final use_signal=false);

  parameter Real separationRate(max = 0.99995) = 0.9995 "Separation rate" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real specific_powerConsumption(unit="W.h/m3") = 0.15 "Specific power consumption" annotation (Dialog(group="Fundamental Definitions"));

  Units.Power powerConsumption "Power consumption";
  Units.DensityMassSpecific d_flueGas_in;
  Units.DensityMassSpecific d_flueGas_out;
  Units.MassFraction xi_dust[iCom.mediumModel.nc - 1];

equation

  Q_flow_reaction = 0;

  //No auxillary step
  xi_aux=iCom.xi_in;
  m_flow_aux=iCom.m_flow_in;
  h_aux=TILMedia.GasObjectFunctions.specificEnthalpy_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);

  xi_dust = {if i==1  then 0.99999 else if i==5 then 0.00001 else 0 for i in 1:iCom.mediumModel.nc-1}; //Dust removed is treated as ash

  h_reaction[1] = TILMedia.GasObjectFunctions.specificEnthalpy_pTxi(iCom.p_bulk,iCom.T_bulk,xi_dust,iCom.fluidPointer_bulk);
  d_flueGas_in = TILMedia.GasObjectFunctions.density_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);
  d_flueGas_out = TILMedia.GasObjectFunctions.density_pTxi(iCom.p_out,iCom.T_out,iCom.xi_out,iCom.fluidPointer_out);

  if iCom.m_flow_in > 0 and iCom.m_flow_out <=0 then
    m_flow_reaction[1] = separationRate *(-iCom.xi_in[1]*iCom.m_flow_in);
    powerConsumption = iCom.m_flow_in/d_flueGas_in*specific_powerConsumption*3600.;
  elseif  iCom.m_flow_in > 0 and iCom.m_flow_in > 0 then
    m_flow_reaction[1] = separationRate * (-iCom.xi_out[1]*iCom.m_flow_out-iCom.xi_in[1]*iCom.m_flow_in);
    powerConsumption = (iCom.m_flow_in/d_flueGas_in +iCom.m_flow_out/d_flueGas_out) *specific_powerConsumption*3600.;
  elseif iCom.m_flow_in <= 0 and iCom.m_flow_out <= 0 then
    m_flow_reaction[1] = 1e-20;
    powerConsumption  = 1e-20;
  else
    m_flow_reaction[1] = separationRate *(-iCom.xi_out[1]*iCom.m_flow_out);
    powerConsumption = iCom.m_flow_out/d_flueGas_out*specific_powerConsumption*3600.;
    end if;

  if use_dynamicMassbalance then
     der(xi) =
      1/mass * (iCom.m_flow_in*(iCom.xi_in - xi) + iCom.m_flow_out*(iCom.xi_out - xi) + m_flow_reaction[1]*(xi_dust-xi));
  else
     zeros(iCom.mediumModel.nc-1) =
       (iCom.m_flow_in*(iCom.xi_in - xi) + iCom.m_flow_out*(iCom.xi_out - xi) + m_flow_reaction[1]*(xi_dust-xi));
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
end E_Filter_L2_Simple;
