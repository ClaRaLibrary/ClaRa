within ClaRa.Components.Mills.PhysicalMills.Volumes;
model FuelJoin_distributed "Aerosol component | simple join | PT1-Behavior"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.6.0                           //
//                                                                          //
// Licensed by the ClaRa development team under Modelica License 2.         //
// Copyright  2013-2021, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  extends ClaRa.Basics.Icons.Tpipe2;
  outer ClaRa.SimCenter simCenter;

  //----------------------------------------------------------
  //fundamental definitions
    parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Fundamentals.Records.FuelClassification_base classification=Fundamentals.Records.FuelClassification_example_21classes() annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  //----------------------------------------------------------
  //initial values
  parameter ClaRa.Basics.Units.Temperature T_start = simCenter.T_amb_start "initial fuel" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_fuel_start[fuelModel.N_c-1]=zeros(fuelModel.N_c-1) "initial fuel composition" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Mass mass_fuel_start = 240 "total initial mass on grinding table" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction classFraction_start[classification.N_class-1] = (1/classification.N_class)*ones(classification.N_class-1) "start value for total class fraction of ALL inlets" annotation(Dialog(tab="Initialisation"));

  //----------------------------------------------------------
  //variables
  ClaRa.Basics.Units.Mass mass(start=mass_fuel_start) "accumulated particle/fuel mass in aerosol control volume";
  ClaRa.Basics.Units.Pressure p "pressure in fuel control volume";
  ClaRa.Basics.Units.Temperature T(start=T_start) "temperature in fuel controll volume";
  ClaRa.Basics.Units.MassFraction xi[fuelModel.N_c-1](start=xi_fuel_start) "composition in fuel control volume";
  ClaRa.Basics.Units.MassFraction classFraction[classification.N_class-1](start=classFraction_start) "total class fraction of ALL inlets";

  //----------------------------------------------------------
  //ports and media obejcts
  Basics.Interfaces.FuelInletDistr fuelInlet1(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.FuelInletDistr fuelInlet2(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Basics.Interfaces.FuelOutletDistr fuelOutlet(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  ClaRa.Basics.Media.FuelObject fuelIn1(
    p=fuelInlet1.p,
    T=noEvent(actualStream(fuelInlet1.T_outflow)),
    xi_c=noEvent(actualStream(fuelInlet1.xi_outflow)),
    fuelModel=fuelModel) annotation (Placement(transformation(extent={{-84,-12},{-64,8}})));
  ClaRa.Basics.Media.FuelObject fuelIn2(
    p=fuelInlet2.p,
    T=noEvent(actualStream(fuelInlet2.T_outflow)),
    xi_c=noEvent(actualStream(fuelInlet2.xi_outflow)),
    fuelModel=fuelModel) annotation (Placement(transformation(extent={{-10,-88},{10,-68}})));
  ClaRa.Basics.Media.FuelObject fuelOut(
    p=fuelOutlet.p,
    T=noEvent(actualStream(fuelOutlet.T_outflow)),
    xi_c=noEvent(actualStream(fuelOutlet.xi_outflow)),
    fuelModel=fuelModel) annotation (Placement(transformation(extent={{70,-12},{90,8}})));
  ClaRa.Basics.Media.FuelObject fuelBulk(
    p=p,
    T=T,
    xi_c=xi,
    fuelModel=fuelModel) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

  //----------------------------------------------------------

equation

  fuelInlet1.p = p;
  fuelInlet2.p = p;
  fuelOutlet.p = p;

  fuelInlet1.T_outflow = T;

  fuelInlet2.T_outflow = T;
  fuelOutlet.T_outflow = T;

  fuelInlet1.xi_outflow = xi;
  fuelInlet2.xi_outflow = xi;
  fuelOutlet.xi_outflow = xi;

  fuelInlet1.classFraction_outflow = classFraction;
  fuelInlet2.classFraction_outflow = classFraction;
  fuelOutlet.classFraction_outflow = classFraction;

  // ClassFraction Balance
  for i in 1:classification.N_class-1 loop
    der(classFraction[i]) =1/mass*(fuelInlet1.m_flow*(inStream(fuelInlet1.classFraction_outflow[i]) - classFraction[i]) + fuelInlet2.m_flow*(inStream(fuelInlet2.classFraction_outflow[i]) - classFraction[i]) + fuelOutlet.m_flow*(fuelOutlet.classFraction_outflow[i] - classFraction[i]));
  end for;

  // Energy Balance
  mass*fuelBulk.cp*der(T) = fuelInlet1.m_flow*fuelIn1.h + fuelInlet2.m_flow*fuelIn2.h + fuelOutlet.m_flow*fuelOut.h;

  // Composition Balance
  for i in 1:fuelModel.N_c-1 loop
    der(xi[i]) =1/mass*(fuelInlet1.m_flow*(fuelIn1.xi_c[i] - xi[i]) + fuelInlet2.m_flow*(fuelIn2.xi_c[i] - xi[i]) + fuelOutlet.m_flow*(fuelOut.xi_c[i] - xi[i]));
  end for;

  // Mass Balance
  der(mass) = 0;
  der(mass) =fuelInlet1.m_flow + fuelInlet2.m_flow + fuelOutlet.m_flow;

    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end FuelJoin_distributed;
