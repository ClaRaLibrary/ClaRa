within ClaRa.Components.Furnace.ChemicalReactions;
model CoalReactionZone
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

extends ClaRa.Components.Furnace.ChemicalReactions.PartialReactionZone;

//Please note that the following calculations are carried out for 1 kg of fuel! Because the factor of 1 would have no influence it is not shown inside these equations.

parameter Real xi_slag = 0.1 "Fraction of Ash that leaves combustion chamber at bottom due to gravity"
                                                                              annotation (Dialog(group="Slag parameters"));

parameter Real xi_NOx=1000e-6 "Fraction of burned fuel N being converted to NOx"
                                                       annotation(Dialog(group="Toxic substance in fluegas"));
parameter Real xi_CO=1000e-6 "Fraction of burned fuel C being converted to CO"
                                                      annotation(Dialog(group="Toxic substance in fluegas"));

equation
   n_C = elementaryComposition_fuel_in[1] /Basics.Constants.M_C;
   n_H = elementaryComposition_fuel_in[2] /Basics.Constants.M_H;
   n_O = elementaryComposition_fuel_in[3]/Basics.Constants.M_O;
   n_N = elementaryComposition_fuel_in[4]/Basics.Constants.M_N;// N not N2!!!!!!
   n_S = elementaryComposition_fuel_in[5] /Basics.Constants.M_S;
   n_Ash = elementaryComposition_fuel_in[6] /Basics.Constants.M_Ash;
   n_H2O = (1-sum(elementaryComposition_fuel_in)) /Basics.Constants.M_H2O;

   0 =elementaryComposition_fuel_in[1]/Basics.Constants.M_C*xi_CO - n_CO;
   0 =elementaryComposition_fuel_in[4]/Basics.Constants.M_N*xi_NOx - n_NO;
   0 = elementaryComposition_fuel_in[1]/Basics.Constants.M_C - n_CO2 -n_CO;
   0 = elementaryComposition_fuel_in[2]/Basics.Constants.M_H / 2 + (1-sum(elementaryComposition_fuel_in))/(Basics.Constants.M_H*2+Basics.Constants.M_O)-n_H2O_prod;
   0 = elementaryComposition_fuel_in[5]/Basics.Constants.M_S -n_SO2;
   0 = elementaryComposition_fuel_in[4]/Basics.Constants.M_N /2-n_N2 -n_NO/2;

 for i in 1:(flueGas.nc-1) loop
     if i==1 then prod_comp[1] =elementaryComposition_fuel_in[6]*(1 - xi_slag);
     else if i==2 then prod_comp[2] =n_CO * (Basics.Constants.M_C + Basics.Constants.M_O);
     else if i==3 then prod_comp[3] =n_CO2 * (Basics.Constants.M_C + 2*Basics.Constants.M_O);
     else if i==4 then prod_comp[4] =n_SO2 * (Basics.Constants.M_S + 2*Basics.Constants.M_O);
     else if i==5 then prod_comp[5] =n_N2*(2*Basics.Constants.M_N);
     else if i==6 then prod_comp[6] = -(n_CO/2 +n_CO2 +n_NO/2 +n_H/4.0 +n_S -n_O/2) * Basics.Constants.M_O * 2.0;
     else if i==7 then prod_comp[7] =n_NO*(Basics.Constants.M_N + Basics.Constants.M_O);
     else if i==8 then prod_comp[8] =n_H2O_prod * (Basics.Constants.M_H * 2+Basics.Constants.M_O);
    else
      prod_comp[i] = 0;
     end if; end if; end if; end if; end if; end if; end if; end if;
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
</html>"));
end CoalReactionZone;
