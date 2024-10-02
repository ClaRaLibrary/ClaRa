within ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions;
model E_Filter_L2_Detailed "Gas || L2 || Detailed E-Filter"
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
  extends ChemicalReactionsBaseGas(final i=1, final use_signal=true);

  //parameter Real separationRate(max = 0.99995) = 0.9995 "Separation rate" annotation (Dialog(group="Fundamental Definitions"));
  parameter Real epsilon_r = 10 "Dielectric number of flueGas";
  parameter Real specific_powerConsumption(unit="W.h/m3") = 0.15 "Specific power consumption" annotation (Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Area A_filter=100 "Collector area of E-Filter" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length d_plate=0.2 "Distance  Plate-to-Plate or Plate-to-Wire, repectivaly" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_particle=50e-6 "Average diameter of ash particles" annotation (Dialog(group="Geometry"));
  final parameter Real A1 = 1.257 "Auxiliary Area"
                                                  annotation(Dialog(group="Geometry"));
  final parameter Real A2 = 0.4 "Auxiliary Area" annotation(Dialog(group="Geometry"));
  final parameter Real A3 = 0.55 "Auxiliary Area"
                                                 annotation(Dialog(group="Geometry"));


  Units.Velocity w_m "Migration speed of dust particles in the E-field";
  Units.Length lambda "Mean free path of particles";
  Modelica.Units.SI.ElectricFieldStrength E_applied "E-Field in Filter estimated as E = U/d with U being the applied potential and d the distance between elektrodes, refer to Riehle 1997";

  ClaRa.Basics.Units.DynamicViscosity mu_flueGas "Dynamic viscosity of flueGas in E-Filter";
  Real Cu "Cunningham slip correction factor Cu = 1 + 2lambda/d *(A1 +A2exp[-A3*diameter_particle/lambda]])";

  Modelica.Units.SI.ElectricCharge Q_sat "Saturation charge of particles";

  Units.Power powerConsumption "Power consumption";
  Units.DensityMassSpecific d_flueGas_in;
  Units.DensityMassSpecific d_flueGas_out;
  Units.MassFraction xi_dust[iCom.mediumModel.nc - 1];

  Real separationRate "Separation rate";
  ClaRa.Basics.Units.VolumeFlowRate V_flow "Volume flow rate of flue Gas entering the E-Filter";

 outer Real U_applied;

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

  E_applied = U_applied/d_plate;

  // calculation of the migration velocity refering to Riehle "Basic and theoretical operation of ESPs" (1997)
  w_m = Q_sat*E_applied*Cu/(3.0*Modelica.Constants.pi*mu_flueGas*diameter_particle);
  // with
  Q_sat = ((1.0+2.0*lambda/diameter_particle)^2 + (2.0/(1.0+2.0*lambda/diameter_particle))*(epsilon_r-1.0)/(epsilon_r+2.0)) * Modelica.Constants.pi*Modelica.Constants.epsilon_0*diameter_particle^2*E_applied;
  //and
  Cu = 1 + 2.0*lambda/diameter_particle*(A1 + A2*Modelica.Math.exp(-A3*diameter_particle/lambda));
  //with lambda the mean free path of molecules/paticles in the flueGas (check, which diameter is physical plausible)
  lambda = 1.0/(4.0*Modelica.Constants.pi*sqrt(2.0)*diameter_particle^2*Modelica.Constants.N_A/(Modelica.Constants.R*iCom.T_in/iCom.p_in));

  mu_flueGas  = TILMedia.GasObjectFunctions.dynamicViscosity_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);

  separationRate =  1- Modelica.Math.exp(-w_m*A_filter/V_flow);
  powerConsumption = V_flow * specific_powerConsumption*3600.;

  if iCom.m_flow_in > 0 and iCom.m_flow_out <=0 then
    V_flow = iCom.V_flow_in;
    m_flow_reaction[1] = separationRate *(-iCom.xi_in[1]*iCom.m_flow_in);
  elseif  iCom.m_flow_in > 0 and iCom.m_flow_in > 0 then
    V_flow = iCom.V_flow_in + iCom.V_flow_out;
    m_flow_reaction[1] = separationRate * (-iCom.xi_out[1]*iCom.m_flow_out-iCom.xi_in[1]*iCom.m_flow_in);
  elseif iCom.m_flow_in <= 0 and iCom.m_flow_out <= 0 then
    V_flow = 1e-20;
    m_flow_reaction[1] = 1e-20;
  else
    V_flow = iCom.V_flow_out;
    m_flow_reaction[1] = separationRate *(-iCom.xi_out[1]*iCom.m_flow_out);
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
end E_Filter_L2_Detailed;
