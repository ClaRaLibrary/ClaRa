within ClaRa.Components.Furnace.ChemicalReactions;
partial model PartialReactionZone "Model to regard chemical reactions"
  extends ClaRa.Basics.Icons.Box;

  parameter TILMedia.Gas.Types.BaseGas flueGas;
parameter ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel;


  input ClaRa.Basics.Units.MassFraction elementaryComposition_fuel_in[fuelModel.N_e - 1];
  ClaRa.Basics.Units.MassFraction prod_comp[flueGas.nc - 1] "Resulting composition of products";


//_________/Educts\__________________
protected
  Modelica.Units.SI.AmountOfSubstance n_C "Amount of elemental carbon inside 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_H "Amount of elemental hydrogen inside 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_O "Amount of elemental oxygen inside 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_N "Amount of elemental nitrogen inside 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_S "Amount of elemental sulfur inside 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_Ash "Amount of ash inside 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_H2O "Amount of water inside 1 kg of coal";

//_________/Products\__________________
  Modelica.Units.SI.AmountOfSubstance n_CO "Amount of carbon monoxide produced by 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_CO2 "Amount of carbon dioxide produced by 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_H2O_prod "Amount of water produced by 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_SO2 "Amount of sulfur dioxide produced by 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_N2 "Amount of nitrogen produced by 1 kg of coal";
  Modelica.Units.SI.AmountOfSubstance n_NO "Amount of nitric oxides produced by 1 kg of coal";

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
 Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                   graphics={
                       Text(
          extent={{-58,12},{62,-8}},
          lineColor={0,131,169},
          textString="Reaction Zone",
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));

end PartialReactionZone;
