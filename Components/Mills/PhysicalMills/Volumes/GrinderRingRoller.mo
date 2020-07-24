within ClaRa.Components.Mills.PhysicalMills.Volumes;
model GrinderRingRoller "Aerosol component | grinder component for Ring-Roller-Mills | for replaceable grinding processes | mass transport on discretised table"
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

  extends ClaRa.Basics.Icons.Mill;
  outer ClaRa.SimCenter simCenter;

  //----------------------------------------------------------
  //fundamental definitions
  //parameter TILMedia.GasTypes.BaseGas gas = simCenter.flueGasModel "Medium model"annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Fundamentals.Records.FuelClassification_base classification=Fundamentals.Records.FuelClassification_example_21classes() annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  //----------------------------------------------------------
  //nominal values
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel_nom = 10 "Nominal mass flow rates at inlet" annotation(Dialog(group="Nominal values"));

  //----------------------------------------------------------
  //initial values
  parameter ClaRa.Basics.Units.Temperature T_start = simCenter.T_amb_start "initial fuel" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_fuel_start[fuelModel.N_c-1]=zeros(fuelModel.N_c-1) "initial fuel composition" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction classFraction_in_start[classification.N_class-1] = (1/classification.N_class)*ones(classification.N_class-1) "start value for total class fraction of ALL inlets" annotation(Dialog(tab="Initialisation"));
  parameter Real recirculation_rate_start = 15 "initial m_flow_out/m_flow_in1 kg/kg" annotation(Dialog(tab="Initialisation"));

  //----------------------------------------------------------
  // public Geometry of Table
public
  parameter ClaRa.Basics.Units.Length radius_table = 0.5*(2.44-0.4) "outer radius of the grinding table; center table to center roll!" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length radius_chute = 0.5*0.817 "radius of recirculation tube of classifier" annotation(Dialog(group="Geometry"));
  parameter Integer n = 10 "number of discrete table ring sections" annotation(Dialog(group="Geometry"));

  //----------------------------------------------------------
  // calculating discretized Geometry of Table
protected
  parameter ClaRa.Basics.Units.Length radius[n] = linspace(radius_table/n,radius_table,n) "discrete radius of circular ring elements" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Area A_bottom[n] = Modelica.Constants.pi .* (radius.^2 - (radius-radius_table/n*ones(n)).^2) annotation(Dialog(group="Geometry"));
  parameter Integer m = integer(radius_chute / radius_table * n) "number of ring elemenst within chute radius" annotation(Dialog(group="Geometry"));

  //----------------------------------------------------------
  // influence of coal properties on grinding behavior --------------------
  parameter Real HGI_nom = 60 "Hardgrove-Index of design coal" annotation(Dialog(group="Additional Coal Properties"));
  parameter Real HGI = 50 "Hardgrove-Index of coal in °HG (30 ... 120)" annotation(Dialog(group="Additional Coal Properties"));
  parameter ClaRa.Basics.Units.DensityMassSpecific rho_bulk = 830 "density of coal bulk (not solid!), Effenberger S.40" annotation(Dialog(group="Additional Coal Properties"));

  //-----------------------------------------------------------------------
  //declaration of mass fraction vector: real vector with sum = 1

public
  Real classFraction_out_real[n,classification.N_class](start=ones(n,classification.N_class)) "sum = 1";

  //-----------------------------------------------------------------------
  ClaRa.Basics.Units.Mass mass "accumulated particle/fuel mass in aerosol control volume";
  ClaRa.Basics.Units.Pressure p "pressure in fuel control volume";
  ClaRa.Basics.Units.Temperature T(start=T_start) "temperature in fuel controll volume";
  ClaRa.Basics.Units.MassFraction xi[fuelModel.N_c-1](start=xi_fuel_start) "composition in fuel control volume";
  //ClaRa.Basics.Units.MassFraction classFraction_in[classification.N_class-1](start=classFraction_in_start) "total class fraction of ALL inlets";

  ClaRa.Basics.Units.Area A_coat[n,classification.N_class];
  ClaRa.Basics.Units.Mass mass_discrete[n,classification.N_class];
  ClaRa.Basics.Units.Mass mass_discrete_sum[n];
  ClaRa.Basics.Units.Length height[n,classification.N_class];
  ClaRa.Basics.Units.Length height_sum[n];
  ClaRa.Basics.Units.MassFlowRate m_flow_in[classification.N_class];
  ClaRa.Basics.Units.MassFlowRate m_flow_out[classification.N_class];
  Real coeff_m_flow_in[m] "distribution factor for m_flow_in on ring elements within chute radius";

  Real recirculation_rate "ratio of total inlet mass flow to conveyor inlet mass flow";

  //----------------------------------------------------------
  // Input Operational Variables
  Modelica.Blocks.Interfaces.RealInput inputGrindingPressure annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-80,120})));
  Modelica.Blocks.Interfaces.RealInput inputTableSpeed annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={80,120})));
  ClaRa.Basics.Units.Pressure p_grinding;
  ClaRa.Basics.Units.RPM rpm_table;

  //----------------------------------------------------------
  //ports and media obejcts
  Basics.Interfaces.FuelInletDistr fuelInlet1(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.FuelInletDistr fuelInlet2(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Basics.Interfaces.FuelOutletDistr fuelOutlet(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  ClaRa.Basics.Media.FuelObject fuelIn1(
    p=fuelInlet1.p,
    T=noEvent(actualStream(fuelInlet1.T_outflow)),
    xi_c=noEvent(actualStream(fuelInlet1.xi_outflow))) annotation (Placement(transformation(extent={{-84,-12},{-64,8}})));
  ClaRa.Basics.Media.FuelObject fuelIn2(
    p=fuelInlet2.p,
    T=noEvent(actualStream(fuelInlet2.T_outflow)),
    xi_c=noEvent(actualStream(fuelInlet2.xi_outflow))) annotation (Placement(transformation(extent={{-10,68},{10,88}})));
  ClaRa.Basics.Media.FuelObject fuelOut(
    p=fuelOutlet.p,
    T=noEvent(actualStream(fuelOutlet.T_outflow)),
    xi_c=noEvent(actualStream(fuelOutlet.xi_outflow))) annotation (Placement(transformation(extent={{70,-12},{90,8}})));
  ClaRa.Basics.Media.FuelObject fuelBulk(
    p=p,
    T=T,
    xi_c=xi) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

  //----------------------------------------------------------
  //declaration of replaceable breakage and selection functions
  replaceable model Breakage = Fundamentals.Grinding.Breakage_Function.Breakage_Austin constrainedby Fundamentals.Grinding.Breakage_Function.Breakage_base                                                                         annotation(Dialog(group="Replaceable Models"),choicesAllMatching=true);
  replaceable model Selection = Fundamentals.Grinding.Selection_Function.Selection_Steinmetz constrainedby Fundamentals.Grinding.Selection_Function.Selection_base                                                                         annotation(Dialog(group="Replaceable Models"),choicesAllMatching=true);
  replaceable model Transport = Fundamentals.Grinding.Transport_Velocity.Transport_complex constrainedby Fundamentals.Grinding.Transport_Velocity.Transport_base                                                                         annotation(Dialog(group="Replaceable Models"),choicesAllMatching=true);

  Breakage breakage annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Selection selection annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Transport transport annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  //----------------------------------------------------------
  //declaration of iCom
  inner Fundamentals.Records.iCom_Grinder iCom(
    n=n,
    radius_table=radius_table,
    height_sum=height_sum,
    radius=radius,
    A_bottom=A_bottom,
    classification=classification,
    rho_bulk=rho_bulk,
    rho=fuelBulk.rho,
    rpm_table=rpm_table,
    p_grinding=p_grinding,
    HGI=HGI,
    HGI_nom=HGI_nom) annotation (Placement(transformation(extent={{60,-84},{80,-64}})));

  //-------------------------------------------------------------------------------
  //Summary
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Mass mass "fuel bulk mass in volume";
    input Real HGI "Hardgrove-Index of coal in °HG (30 ... 120)";
    input ClaRa.Basics.Units.DensityMassSpecific rho_bulk "density of coal bulk (not solid!), Effenberger S.40";
    input ClaRa.Basics.Units.Length radius_table "outer radius of the grinding table; center table to center roll!";
    input ClaRa.Basics.Units.Pressure p_grinding;
    input ClaRa.Basics.Units.RPM rpm_table;
    input Real recirculation_rate;
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

  Summary summary(outline(mass=mass, HGI=HGI, rho_bulk=rho_bulk, radius_table=radius_table, p_grinding=p_grinding, rpm_table=rpm_table, recirculation_rate=recirculation_rate)) annotation (Placement(transformation(extent={{-80,-84},{-60,-64}})));

  //----------------------------------------------------------
initial equation

  //Given height of outer ring element
  height_sum[n] = recirculation_rate_start*m_flow_fuel_nom / (2*Modelica.Constants.pi*radius[n]*transport.w_r[n]*rho_bulk);

  //----------------------------------------------------------
equation

  p_grinding = inputGrindingPressure;
  rpm_table = inputTableSpeed;

  //----------------------------------------------------------
  // Discrete Mass-Balance for each Element and Particle Class
  //----------------------------------------------------------

  // INLET MASS FLOW
  //transforming mass fraction vector in real vector with sum = 1
  m_flow_in =fuelInlet1.m_flow*cat(
    1,
    inStream(fuelInlet1.classFraction_outflow),
    {max(0, 1 - sum(inStream(fuelInlet1.classFraction_outflow)))}) + fuelInlet2.m_flow*cat(
    1,
    inStream(fuelInlet2.classFraction_outflow),
    {max(0, 1 - sum(inStream(fuelInlet2.classFraction_outflow)))});

  for i in 1:n loop
    //coat area of circular ring elements
    A_coat[i,:] = 2 * Modelica.Constants.pi * radius[i] * height[i,:];
  end for;

  // calculating distribution factor for m_flow_in on ring elements within chute radius
  for i in 1:m loop
    coeff_m_flow_in[i] = A_bottom[m-i+1]/sum(A_bottom[1:m]);
  end for;

  //DISCRETIZATION IN n CIRCULAR RING ELEMENTS
  der(height[1,:]) = (m_flow_in * coeff_m_flow_in[1]) / (rho_bulk*A_bottom[1]) - A_coat[1,:]/A_bottom[1]*transport.w_r[1];
  //der(mass[1,:]) = rho_s * A_bottom[1] *der(height[1,:]);  //STARTWERTABHÄNGIGKEIT!! Es gilt nicht mehr mass = rho_s*A_bottom*height!
  mass_discrete[1,:] = rho_bulk * A_bottom[1] * height[1,:];

  for i in 2:m loop
    der(height[i,:]) =  (m_flow_in * coeff_m_flow_in[i]) / (rho_bulk*A_bottom[i]) + A_coat[i-1,:]/A_bottom[i]*transport.w_r[i-1] - A_coat[i,:]/A_bottom[i]*transport.w_r[i];  //
    mass_discrete[i,:] = rho_bulk * A_bottom[i] * height[i,:];
  end for;

  for i in m+1:n loop
    der(height[i,:]) = A_coat[i-1,:]/A_bottom[i]*transport.w_r[i-1] - A_coat[i,:]/A_bottom[i]*transport.w_r[i] + (if i >= n then (- selection.S*height[i,:] + breakage.B*selection.S*height[i,:]) else zeros(classification.N_class));
    //der(mass[i,:]) = rho_s * A_bottom[i] * der(height[i,:]);  //STARTWERTABHÄNGIGKEIT!! Es gilt nicht mehr mass = rho_s*A_bottom*height!
    mass_discrete[i,:] = rho_bulk * A_bottom[i] * height[i,:];
  end for;

    //calculating mass outlet flow
  m_flow_out =  rho_bulk * A_bottom[n] * (A_coat[n,:]/A_bottom[n]*transport.w_r[n]);
  fuelOutlet.m_flow = -sum(m_flow_out);

  for i in 1:n loop
    mass_discrete_sum[i] = sum(mass_discrete[i,:]);
    height_sum[i] = sum(height[i,:]);

    for j in 1:classification.N_class loop
      classFraction_out_real[i,j] = max(0,mass_discrete[i,j]) ./ max(Modelica.Constants.small,mass_discrete_sum[i]);
    end for;
  end for;

  fuelOutlet.classFraction_outflow = classFraction_out_real[n, 1:classification.N_class - 1];

  mass = sum(mass_discrete);

  //----------------------------------------------------------
  // Energy-, Composition-Balances, etc.
  //----------------------------------------------------------

  fuelInlet1.p = p;
  fuelInlet2.p = p;
  fuelOutlet.p = p;

  fuelInlet1.T_outflow = 0;
  fuelInlet2.T_outflow = 0;
  fuelOutlet.T_outflow = T;

  fuelInlet1.xi_outflow = zeros(fuelModel.N_c - 1);
  fuelInlet2.xi_outflow = zeros(fuelModel.N_c - 1);
  fuelOutlet.xi_outflow = xi;

  fuelInlet1.classFraction_outflow = zeros(classification.N_class - 1);
  fuelInlet2.classFraction_outflow = zeros(classification.N_class - 1);

  //MIXING raw coal and returning coal form classifier
  //energy balance
  mass*fuelBulk.cp*der(T) = fuelInlet1.m_flow*fuelIn1.cp*(fuelIn1.T - fuelIn1.T_ref) + fuelInlet2.m_flow*fuelIn2.cp*(fuelIn2.T - fuelIn2.T_ref) + fuelOutlet.m_flow*fuelOut.cp*(fuelOut.T - fuelOut.T_ref);

  //composition balance
  for i in 1:fuelModel.N_c-1 loop
    der(xi[i]) =1/mass*(fuelInlet1.m_flow*(fuelIn1.xi_c[i] - xi[i]) + fuelInlet2.m_flow*(fuelIn2.xi_c[i] - xi[i]) + fuelOutlet.m_flow*(fuelOut.xi_c[i] - xi[i]));
  end for;

  //----------------------------------------------------------
  // Additional for Summary and Evaluation
  //----------------------------------------------------------

  recirculation_rate = (-fuelOutlet.m_flow)/fuelInlet1.m_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end GrinderRingRoller;
