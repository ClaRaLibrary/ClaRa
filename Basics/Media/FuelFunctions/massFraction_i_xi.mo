within ClaRa.Basics.Media.FuelFunctions;
function massFraction_i_xi "Elementary composition as function of fuel xi"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.9.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under the 3-clause BSD License.   //
  // Copyright  2013-2021, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  input ClaRa.Basics.Units.MassFraction xi_c[:] "Composition of fuel";
   input Integer compNo "Component number";
   input ClaRa.Basics.Media.FuelTypes.BaseFuel fuelType=ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1() "Fuel type";

  output ClaRa.Basics.Units.MassFraction xi_element "Composition of elements";

protected
  ClaRa.Basics.Units.MassFraction xi_elements[fuelType.N_e - 1];
algorithm
     xi_elements:=zeros(fuelType.N_e - 1);
   if fuelType.N_c==fuelType.N_e then
     xi_elements :=xi_c;
   else

     for i in 1:fuelType.N_e-3 loop
       for j in 1: fuelType.N_c-2 loop
         xi_elements[i] := xi_elements[i] + xi_c[j].* fuelType.xi_e_waf[j,i];
       end for;
     end for;
     for j in 1: fuelType.N_c-2 loop
       xi_elements[fuelType.N_e-2] := xi_elements[fuelType.N_e-2] +  xi_c[j] .* (1 - sum(fuelType.xi_e_waf[j, :]));
     end for;
     xi_elements[fuelType.N_e-1]:=ashMassFraction_xi(xi_c, fuelType);
   end if;
   xi_element :=xi_elements[compNo];
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
end massFraction_i_xi;
