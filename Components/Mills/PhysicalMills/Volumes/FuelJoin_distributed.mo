within ClaRa.Components.Mills.PhysicalMills.Volumes;
model FuelJoin_distributed "Aerosol component | simple join | PT1-Behavior"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end FuelJoin_distributed;
