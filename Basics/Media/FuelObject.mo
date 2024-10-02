within ClaRa.Basics.Media;
model FuelObject
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

  input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
  input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
  input ClaRa.Basics.Units.MassFraction xi_c[fuelModel.N_c - 1] "Composition" annotation (Dialog);
   parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel = simCenter.fuelModel1 "Fuel type" annotation(choicesAllMatching);

  ClaRa.Basics.Units.DensityMassSpecific rho "Density";
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp(stateSelect=StateSelect.never) "Spec. heat capacity of fuel";
  ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value";
  ClaRa.Basics.Units.EnthalpyMassSpecific h "Spec. enthalpy";

  ClaRa.Basics.Units.MassFraction xi_h2o "Water mass fraction";
  ClaRa.Basics.Units.MassFraction xi_ash "Ash mass fraction";
  ClaRa.Basics.Units.Temperature T_ref=fuelModel.T_ref "Reference temperature";
  ClaRa.Basics.Units.MassFraction xi_e[fuelModel.N_e - 1] "Mass fraction of elements";
   outer ClaRa.SimCenter simCenter;
equation
  //    assert(sum(xi)<=1, "Sum of species fraction must be <=1 but is " + String(sum(xi)) + " in component " + getInstanceName());
   rho = ClaRa.Basics.Media.FuelFunctions.density_pTxi(
     p,
     T,
     xi_c,
     fuelModel) "Density";
   cp = ClaRa.Basics.Media.FuelFunctions.heatCapacity_pTxi(
     p,
     T,
     xi_c,
     fuelModel) "Spec. heat capacity of fuel";
   LHV = ClaRa.Basics.Media.FuelFunctions.LHV_pTxi(
     p,
     T,
     xi_c,
     fuelModel) "Lower heating value";
   h = ClaRa.Basics.Media.FuelFunctions.enthalpy_pTxi(
     p,
     T,
     xi_c,
     fuelModel) "Spec. enthalpy";

   xi_h2o = ClaRa.Basics.Media.FuelFunctions.waterMassFraction_xi(xi_c, fuelModel);
   xi_ash = ClaRa.Basics.Media.FuelFunctions.ashMassFraction_xi(xi_c, fuelModel);
      for i in 1:fuelModel.N_e-1 loop
        xi_e[i] = ClaRa.Basics.Media.FuelFunctions.massFraction_i_xi(xi_c, i, fuelModel);
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
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
          extent={{-80,-60},{80,100}},
          imageSource="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",
          fileName="modelica://ClaRa/Resources/Images/Components/FuelObject.png"), Text(
          extent={{-100,-60},{100,-100}},
          lineColor={27,36,42},
          textString="%name"),
        Ellipse(
          extent={{-80,100},{80,-60}},
          lineColor={118,124,127},
          lineThickness=0.5)}),                                  Diagram(coordinateSystem(preserveAspectRatio=false)));
end FuelObject;
