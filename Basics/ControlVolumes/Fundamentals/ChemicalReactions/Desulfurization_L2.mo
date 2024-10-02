within ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions;
model Desulfurization_L2 "Gas || L2 || Desulfurization"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.ChemicalReactions.DesulfurizationBase;
  extends ChemicalReactionsBaseGas(final i=7, final use_signal=false);

  final parameter Modelica.Units.SI.MolarMass M_CaSO4_H2O=0.172141 "Molar mass of gypsum";
  final parameter Modelica.Units.SI.MolarMass M_CaCO3=0.10009 "Molar mass of calcium carbonate";
  final parameter Modelica.Units.SI.MolarMass M_SO2=0.0640638 "Molar mass of sulfur dioxide";
  final parameter Modelica.Units.SI.MolarMass M_O2=0.0319988 "Molar mass of oxygen";
  final parameter Modelica.Units.SI.MolarMass M_H2O=0.0180153 "Molar mass of water";
  final parameter Modelica.Units.SI.MolarMass M_CO2=0.0440098 "Molar mass of carbon dioxide";

  parameter Real SOx_separationRate = 0.95 "Efficiency of SOx separation" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Temperature T_in_H2O = 313.15 "Inlet Temperature of water" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Real specificPowerConsumption(unit="J/m3") = 9000 "Specific power consumption per standard m^3" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  Units.EnthalpyMassSpecific delta_h_evap;
  Units.MassFraction xi_H2O_sat_out "outlet mass fraction of H2O at saturation";

  //required molar flow rates of reaction educts
  Modelica.Units.SI.MolarFlowRate n_flow_CaCO3_req "Required molar flow of calcium carbonate";
  Modelica.Units.SI.MolarFlowRate n_flow_O2_req "Additional required molar flow of oxygen";
  Modelica.Units.SI.MolarFlowRate n_flow_H2O_req "Required molar flow of water";

  //molar flow rates of reaction educts inside flue gas
  Modelica.Units.SI.MolarFlowRate n_flow_SO2_in "Molar flow rate of sulfur dioxide at inlet";
  Modelica.Units.SI.MolarFlowRate n_flow_O2_in "Molar flow rate of oxygen at inlet";
  Modelica.Units.SI.MolarFlowRate n_flow_H2O_in "Molar flow rate of water at inlet";

  //molar flow rates of products
  Modelica.Units.SI.MolarFlowRate n_flow_CaSO4_H2O_out "Molar flow rate of gypsum outlet (no connector)";
  Modelica.Units.SI.MolarFlowRate n_flow_CO2_out "Molar flow rate of carbon dioxide at outlet";
  Modelica.Units.SI.MolarFlowRate n_flow_H2O_out(start=1) "Molar flow rate of water at outlet";
  Modelica.Units.SI.MolarFlowRate n_flow_H2O_sep "Molar flow rate of separated water (no connector)";

  Modelica.Units.SI.MassFlowRate m_flow_SOx_sep "Mass flow of separated sulfur dioxide";
  Modelica.Units.SI.MassFlowRate m_flow_CaSO4_H2O_out "Mass flow of gypsum (no connector)";
  Modelica.Units.SI.MassFlowRate m_flow_H2O_req "Mass flow of required water";
  Modelica.Units.SI.MassFlowRate m_flow_O2_req "Mass flow of required oxygen";
  Modelica.Units.SI.MassFlowRate m_flow_CaCO3_req "Mass flow of required calcium carbonate";
  Modelica.Units.SI.MassFlowRate m_flow_O2_sep "Mass flow of separated oxygen";
  Modelica.Units.SI.MassFlowRate m_flow_H2O_sep "Mass flow of separated water";
  Modelica.Units.SI.MassFlowRate m_flow_CO2_prod "Mass flow of produced carbon dioxide";

  ClaRa.Basics.Units.Power P_el "Electric power consumption";
  ClaRa.Basics.Units.VolumeFlowRate V_flow_std "Standardized volume flow rate";

  //Auxillary variables for upstream reaction before entering the flue gas cell
  Units.EnthalpyMassSpecific h_in;

  Units.MassFraction xi_out[iCom.mediumModel.nc - 1];
  ClaRa.Basics.Units.MassFlowRate m_flow_out;
  Units.EnthalpyMassSpecific h_out;


  TILMedia.Gas gasAux(gasType=iCom.mediumModel) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
initial equation
  m_flow_aux = m_flow_out;
  h_aux = h_out;
  xi_aux = iCom.xi_in;//xi_out;

equation

  //No input here because this replaceable model is treated as if the chemical reaction takes place ahead the volume
  Q_flow_reaction = 0;

  h_reaction=zeros(i);

  m_flow_reaction[1] = 0;
  m_flow_reaction[2] = 0;
  m_flow_reaction[3] = 0;
  m_flow_reaction[4] = 0;
  m_flow_reaction[5] = 0;
  m_flow_reaction[6] = 0;
  m_flow_reaction[7] = 0;

  xi_H2O_sat_out = TILMedia.GasObjectFunctions.saturationMassFraction_phxi(iCom.p_in,h_aux,xi_aux,gasAux.gasPointer);
  delta_h_evap = TILMedia.GasObjectFunctions.specificEnthalpyOfVaporisation_T(iCom.T_in, iCom.fluidPointer_in);
  h_in = TILMedia.GasObjectFunctions.specificEnthalpy_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);

  n_flow_SO2_in =iCom.m_flow_in*iCom.xi_in[4]/M_SO2;
  n_flow_O2_in =iCom.m_flow_in*iCom.xi_in[6]/M_O2;
  n_flow_H2O_in =iCom.m_flow_in*iCom.xi_in[8]/M_H2O;
  n_flow_H2O_out = - iCom.m_flow_out * xi_H2O_sat_out/M_H2O;
  n_flow_H2O_sep = 2 * SOx_separationRate * n_flow_SO2_in;

  n_flow_CaCO3_req = SOx_separationRate * n_flow_SO2_in;

  n_flow_O2_req = if n_flow_O2_in > 0.5 * SOx_separationRate * n_flow_SO2_in then 0 else 0.5 * SOx_separationRate * n_flow_SO2_in - n_flow_O2_in;

  n_flow_H2O_req = if n_flow_H2O_in > 2 * SOx_separationRate * n_flow_SO2_in + n_flow_H2O_out then 0 else n_flow_H2O_sep + n_flow_H2O_out - n_flow_H2O_in;

  n_flow_CaSO4_H2O_out = SOx_separationRate * n_flow_SO2_in;
  n_flow_CO2_out = SOx_separationRate * n_flow_SO2_in;

  m_flow_SOx_sep =SOx_separationRate*iCom.m_flow_in*iCom.xi_in[4];
  m_flow_O2_sep = 0.5 * SOx_separationRate * n_flow_SO2_in * M_O2;
  m_flow_H2O_sep = n_flow_H2O_sep * M_H2O;

  m_flow_CaSO4_H2O_out = n_flow_CaSO4_H2O_out * M_CaSO4_H2O; //Inherits the separated H2O
  m_flow_H2O_req = n_flow_H2O_req * M_H2O;
  m_flow_O2_req = n_flow_O2_req *M_O2;
  m_flow_CaCO3_req = n_flow_CaCO3_req * M_CaCO3;
  m_flow_CO2_prod = 1*SOx_separationRate*n_flow_SO2_in*M_CO2;

  //Stationary auxillary equations for a quasi upstream chemical reaction
  m_flow_out = iCom.m_flow_in - m_flow_SOx_sep + m_flow_O2_req - m_flow_O2_sep + m_flow_H2O_req + m_flow_CO2_prod + m_flow_CaCO3_req - m_flow_CaSO4_H2O_out;

  h_out = (iCom.m_flow_in * h_in + (m_flow_H2O_req-m_flow_H2O_sep) * (-delta_h_evap))/ m_flow_out;

     //   if use_dynamicMassbalance then
      for i in 1:(iCom.mediumModel.nc-1) loop
        if i == 3 then
          xi_out[3]*m_flow_out = iCom.m_flow_in*iCom.xi_in[3] + SOx_separationRate*n_flow_SO2_in*M_CO2*1;
        else if i == 4 then
          xi_out[4]*m_flow_out = iCom.m_flow_in*iCom.xi_in[4] - SOx_separationRate*n_flow_SO2_in*M_SO2*1;
        else if i == 6 then
         if n_flow_O2_in < 0.5 * SOx_separationRate * n_flow_SO2_in then
           xi_out[6] = 0;
         else
           xi_out[6]*m_flow_out =  iCom.m_flow_in*iCom.xi_in[6] - (0.5*SOx_separationRate*n_flow_SO2_in*M_O2);
         end if;
       else if i == 8 then
         xi_out[8] = xi_H2O_sat_out; //Outlet flue gas is fully saturated with water
       else
         xi_out[i]*m_flow_out = iCom.m_flow_in*iCom.xi_in[i];
       end if;
       end if;
       end if;
       end if;
     end for;

  //Auxillary states to decouple equations
  der(m_flow_aux)=1/0.1*(m_flow_out-m_flow_aux);
  der(h_aux)=1/0.1*(h_out-h_aux);
  der(xi_aux)=1/0.1*(xi_out-xi_aux);

      if use_dynamicMassbalance then
         der(xi) =
          1/mass * (m_flow_aux*(xi_aux - xi) + iCom.m_flow_out*(iCom.xi_out - xi));
      else
         zeros(iCom.mediumModel.nc-1) =
           (m_flow_aux*(xi_aux - xi) + iCom.m_flow_out*(iCom.xi_out - xi));
      end if;

  V_flow_std = iCom.m_flow_in / TILMedia.GasObjectFunctions.density_pTxi(iCom.p_in,iCom.T_in,iCom.xi_in,iCom.fluidPointer_in);
  P_el = specificPowerConsumption * V_flow_std;
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
end Desulfurization_L2;
