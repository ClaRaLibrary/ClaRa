within ClaRa.Components.Mills.PhysicalMills.Volumes;
model CentrifugalClassifier "Aerosol component | centrifugal classifier | for replaceable centrifugal classifying processes | discretised fuel mass balance"
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

  outer ClaRa.SimCenter simCenter;

  //-------------------------------------------------------------------------------
  //replaceable models
  replaceable model Classifying =  Fundamentals.Classifying.Classifying_centrifugal constrainedby Fundamentals.Classifying.Classifying_centrifugal_base                                                                                  annotation(Dialog(group="Replaceable Models"),choicesAllMatching=true);
  Classifying classifying annotation (Placement(transformation(extent={{20,80},{40,100}})));

  replaceable model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry(volume=volume,z_in=z_in,z_out=z_out,A_cross=(A_coat_inner[n]+A_coat_outer[1])/2) constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record" annotation (Dialog(group="Geometry"), choicesAllMatching=true);
  inner Geometry geo annotation(Placement(transformation(extent={{-100,80},{-80,100}})));

  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "1st: pressure loss model | 2nd: edit corresponding record" annotation (Dialog(group="Replaceable Models"), choicesAllMatching=true);
  PressureLoss pressureLoss "Pressure loss model" annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  //-------------------------------------------------------------------------------
  //iCom
  inner Fundamentals.Records.iCom_CentrifugalClassifier iComClassifier(
    n=n,
    classification=classification,
    m_flow_gas_in=gasInlet.m_flow,
    eta_gas=gasBulk.transp.eta,
    rho_fluid=gasBulk.d,
    rho_prtcl=fuelBulk.rho,
    A_coat_outer=A_coat_outer,
    A_coat_inner=A_coat_inner,
    radius_classifier_outer=radius_classifier_outer,
    radius=radius,
    delta_radius=delta_radius,
    inputClassifier=inputClassifier,
    mass_fuel_discrete=mass_fuel_discrete,
    delta_volume=delta_volume,
    volume=volume) annotation (Placement(transformation(extent={{20,56},{40,76}})));

  inner ClaRa.Basics.Records.IComBase_L2 iCom(
    p_in=gasInlet.p,
    T_in=gasIn.T,
    m_flow_in=gasInlet.m_flow,
    p_out=gasOutlet.p,
    T_out=T,
    m_flow_out=gasOutlet.m_flow,
    T_bulk=gasBulk.T,
    p_bulk=gasBulk.p,
    m_flow_nom=m_flow_gas_nom) annotation (Placement(transformation(extent={{-40,56},{-20,76}})));

  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation"));

  //-------------------------------------------------------------------------------
  //Summary
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Mass mass_fuel "fuel bulk mass in volume";
    input ClaRa.Basics.Units.Length radius_classifier_outer "outer radius of classifier (inlet)";
    input ClaRa.Basics.Units.Length diameter_average;
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeGas gasPortIn;
    ClaRa.Basics.Records.FlangeGas gasPortOut;
  end Summary;

  Summary summary(
    outline(mass_fuel=mass_fuel, radius_classifier_outer=radius_classifier_outer,diameter_average=diameter_average),
    gasPortIn(
      mediumModel=gas,
      m_flow=gasInlet.m_flow,
      T=gasIn.T,
      p=gasInlet.p,
      h=gasIn.h,
      xi=gasIn.xi,
      H_flow=gasIn.h*gasInlet.m_flow),
    gasPortOut(
      mediumModel=gas,
      m_flow=gasOutlet.m_flow,
      T=gasOut.T,
      p=gasOut.p,
      h=gasOut.h,
      xi=gasOut.xi,
      H_flow=gasOut.h*gasOutlet.m_flow)) annotation (Placement(transformation(extent={{80,76},{100,96}})));

  //-------------------------------------------------------------------------------

  //fundamental definitions
  parameter TILMedia.GasTypes.BaseGas gas = simCenter.flueGasModel "Medium model" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Coal elemental composition used for combustion" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Fundamentals.Records.FuelClassification_base classification=Fundamentals.Records.FuelClassification_example_21classes() annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  //nominal values
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_fuel_nom= 10 "Nominal fuel mass flow rates at inlet" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_gas_nom=10 "Nominal gas mass flow rates at inlet" annotation (Dialog(group="Nominal Values"));
  //parameter ClaRa.Basics.Units.Pressure p_nom = 1e5 "Nominal pressure for gas volume" annotation (Dialog(group="Nominal Values"));
  //parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom = 1e5 "Nominal enthalpy for gas volume" annotation (Dialog(group="Nominal Values"));

  //start values
  parameter ClaRa.Basics.Units.Pressure p_start = simCenter.p_amb_start "Initial pressure" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Temperature T_start=273.15+100 "Initial temperature" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_gas_start[gas.nc-1]={0,0,0,0,0.79,0.21,0,0,0} "Initial gas composition" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_fuel_start[fuelModel.N_c-1]=zeros(fuelModel.N_c-1) "Initial fuel composition" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Mass mass_fuel_start = 200 "Initial fuel mass" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Mass mass_gas_start = 100 "initial gas mass" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Mass mass_fuel_discrete_start[n,classification.N_class] = (1/n/classification.N_class)*mass_fuel_start*ones(n,classification.N_class) "" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction classFraction_start[classification.N_class-1] = (1/classification.N_class)*ones(classification.N_class-1) "start value for total class fraction in volume" annotation (Dialog(tab="Initialisation"));

  inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state"));

protected
  parameter ClaRa.Basics.Units.DensityMassSpecific rho_fluid_start = 0.970972;

  //basic geometry of classifier
public
  parameter ClaRa.Basics.Units.Length radius_classifier_outer = 0.5*3.33 "outer radius of classifier (inlet)" annotation(Dialog(tab="General",group="Geometry"));
  parameter ClaRa.Basics.Units.Length radius_classifier_inner = 0.5*0.817 "inner radius of classifier (outlet)" annotation(Dialog(tab="General",group="Geometry"));
  parameter ClaRa.Basics.Units.Length height_classifier = 2 "height of classifier; considered as CONSTANT against radius" annotation(Dialog(tab="General",group="Geometry"));
  parameter Integer n = 10 "number of discrete circular ring elements" annotation(Dialog(tab="General",group="Geometry"));

protected
 parameter ClaRa.Basics.Units.Length radius[n] = linspace(radius_classifier_outer-0.5*delta_radius,radius_classifier_inner+0.5*delta_radius,n) "radius of discrete circular ring sections";
 parameter ClaRa.Basics.Units.Length delta_radius = (radius_classifier_outer - radius_classifier_inner)./n "width of circular ring element";
 parameter ClaRa.Basics.Units.Area A_coat_inner[n] = 2 .* Modelica.Constants.pi .* radius .* height_classifier "inner coat area of circular ring elements";
 parameter ClaRa.Basics.Units.Area A_coat_outer[n] =  A_coat_inner;
 parameter ClaRa.Basics.Units.Area A_bottom[n] = Modelica.Constants.pi .* ((radius+0.5*delta_radius*ones(n)).^2 - (radius-0.5*delta_radius*ones(n)).^2);

  parameter ClaRa.Basics.Units.Volume delta_volume[n] = A_bottom .* height_classifier "gas volume of circular ring elements";
  parameter ClaRa.Basics.Units.Volume volume = sum(delta_volume) "total gas volume";
  parameter ClaRa.Basics.Units.Length z_in[1] = {0};
  parameter ClaRa.Basics.Units.Length z_out[1] = {0};

  //variables
public
  ClaRa.Basics.Units.Pressure p(start=p_start) "gas pressure in control volume";
  ClaRa.Basics.Units.Temperature T(start=T_start) "temperature in fuel controll volume";
  ClaRa.Basics.Units.MassFraction xi_fuel[fuelModel.N_c-1](start=xi_fuel_start) "composition in fuel control volume";
  ClaRa.Basics.Units.Mass mass_fuel "fuel bulk mass in volume";
  ClaRa.Basics.Units.MassFraction classFraction[classification.N_class-1](start=classFraction_start) "total class fraction of ALL inlets";
  Real classFraction_in_real[classification.N_class] "declaring class fraction vectors with sum  = 1";
  ClaRa.Basics.Units.Mass mass_fuel_discrete[n,classification.N_class](start = mass_fuel_discrete_start) "mass of each particle class in each ring element";
  ClaRa.Basics.Units.DensityMassSpecific rho_prtcl;

  ClaRa.Basics.Units.MassFraction xi_gas[gas.nc-1](start=xi_gas_start);
  ClaRa.Basics.Units.Mass mass_gas(start = mass_gas_start);
  Real drhodt "Density derivative gas";
  ClaRa.Basics.Units.DensityMassSpecific rho_fluid(start=rho_fluid_start) "density of fluid";

  ClaRa.Basics.Units.MassFlowRate m_flow_in[1,classification.N_class] "mass flow in from iCom";
  ClaRa.Basics.Units.MassFlowRate m_flow_center[n,classification.N_class] "mass flow to center";
  ClaRa.Basics.Units.MassFlowRate m_flow_return[n,classification.N_class] "mass flow to center";
  ClaRa.Basics.Units.MassFlowRate m_flow_return_sum[classification.N_class] "overall return mass flow to table";

  ClaRa.Basics.Units.Velocity w_prtcl_center_eff[n,classification.N_class];
  ClaRa.Basics.Units.Velocity w_prtcl_return_eff[n,classification.N_class];

  ClaRa.Basics.Units.Length diameter_average "averaged prtcl diameter weighted by mass fraction (d50,3)";

  //fuel ports and objects: -------------------------------------------------------------------------------
  Basics.Interfaces.FuelInletDistr fuelInlet(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{-110,-32},{-90,-12}})));
  Basics.Interfaces.FuelOutletDistr fuelOutlet1(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{90,-32},{110,-12}})));
  Basics.Interfaces.FuelOutletDistr fuelOutlet2(fuelModel=fuelModel, classification=classification) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  ClaRa.Basics.Media.FuelObject fuelBulk(
    p=fuelInlet.p,
    T=T,
    xi_c=xi_fuel) annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));

  ClaRa.Basics.Media.FuelObject fuelIn(
    p=fuelInlet.p,
    T=noEvent(actualStream(fuelInlet.T_outflow)),
    xi_c=noEvent(actualStream(fuelInlet.xi_outflow))) annotation (Placement(transformation(extent={{-80,-32},{-60,-12}})));
  ClaRa.Basics.Media.FuelObject fuelOut1(
    p=fuelOutlet1.p,
    T=noEvent(actualStream(fuelOutlet1.T_outflow)),
    xi_c=noEvent(actualStream(fuelOutlet1.xi_outflow))) annotation (Placement(transformation(extent={{60,-32},{80,-12}})));
  ClaRa.Basics.Media.FuelObject fuelOut2(
    p=fuelOutlet2.p,
    T=noEvent(actualStream(fuelOutlet2.T_outflow)),
    xi_c=noEvent(actualStream(fuelOutlet2.xi_outflow))) annotation (Placement(transformation(extent={{-10,-84},{10,-64}})));

  //gas ports and objects: -------------------------------------------------------------------------------
  ClaRa.Basics.Interfaces.GasPortIn gasInlet(Medium=gas) annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  ClaRa.Basics.Interfaces.GasPortOut gasOutlet(Medium=gas) annotation (Placement(transformation(extent={{90,10},{110,30}})));

  TILMedia.Gas_pT     gasIn(
     gasType=gas,
     p=gasInlet.p,
     T=noEvent(actualStream(gasInlet.T_outflow)),
     xi=noEvent(actualStream(gasInlet.xi_outflow)))
     annotation (Placement(transformation(extent={{-80,8},{-60,28}})));

  TILMedia.Gas_pT     gasOut(
     T=noEvent(actualStream(gasOutlet.T_outflow)),
     gasType=gas,
     p=gasOutlet.p,
     xi=noEvent(actualStream(gasOutlet.xi_outflow)))
     annotation (Placement(transformation(extent={{60,8},{80,28}})));

  TILMedia.Gas_pT gasBulk(
    T=T,
    gasType=gas,
    p=p,
    xi=xi_gas,
    computeTransportProperties=true)
                annotation (Placement(transformation(extent={{-10,8},{10,28}})));

  // Classifier Input: -------------------------------------------------------------------------------
  Modelica.Blocks.Interfaces.RealInput inputClassifier annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));

initial equation
  if initOption == 1 then //steady state
    der(xi_gas)=zeros(gas.nc-1);
    der(T) = 0;
  elseif initOption == 0 then //no init
    // do nothing
  else
    assert(initOption == 0,"Invalid init option");
  end if;

equation

  // COMBINED ENERGY BALANCE ###################################
  der(T) * (mass_gas*gasBulk.cp + mass_fuel*fuelBulk.cp) = gasOutlet.m_flow*gasOut.h + gasInlet.m_flow*gasIn.h + fuelInlet.m_flow*fuelIn.cp*(fuelIn.T - fuelIn.T_ref) + fuelOutlet1.m_flow*fuelOut1.cp*(fuelOut1.T - fuelOut1.T_ref) + fuelOutlet2.m_flow*fuelOut2.cp*(fuelOut2.T - fuelOut2.T_ref);

  // GAS SITE ##################################################
  rho_fluid = gasBulk.d;

  //Gas Mass Balance: -----------------------------------------------------------------------------------------------------------------------------------------
  mass_gas =volume*gasBulk.d;
  drhodt = gasBulk.drhodh_pxi*gasBulk.cp*der(T) + gasBulk.drhodp_hxi*der(gasBulk.p) + sum({gasBulk.drhodxi_ph[i]*der(gasBulk.xi[i]) for i in 1:gas.nc - 1});
  drhodt * volume = gasInlet.m_flow + gasOutlet.m_flow;

  //Gas Composition Balance: -----------------------------------------------------------------------------------------------------------------------------------
  der(xi_gas) = 1/mass_gas * (gasInlet.m_flow*(gasIn.xi-xi_gas) + gasOutlet.m_flow*(gasOut.xi-xi_gas));

  //Gas boundary conditions: -----------------------------------------------------------------------------------------------------------------------------------
  gasInlet.p = p + pressureLoss.Delta_p;
  gasOutlet.p = p;

  gasInlet.T_outflow= T;
  gasOutlet.T_outflow = T;

  gasInlet.xi_outflow = xi_gas;
  gasOutlet.xi_outflow = xi_gas;

  // FUEL SITE #################################################
  rho_prtcl =fuelBulk.rho;

  //transforming mass fraction vector in real vector with sum = 1: ------------------------------------------
  for i in 1:classification.N_class-1 loop
    classFraction_in_real[i] = inStream(fuelInlet.classFraction_outflow[i]);
  end for;
  classFraction_in_real[classification.N_class] = max(0,1-sum(inStream(fuelInlet.classFraction_outflow)));

  //inlet mass flow for first element: ----------------------------------------------------------------------
  m_flow_in[1,:] = fuelInlet.m_flow .* classFraction_in_real;

  // Fuel Mass Balance: -------------------------------------------------------------------------------------
  //mass balance for each circular ring element
  der(mass_fuel_discrete[1,:]) = - m_flow_center[1,:] - m_flow_return[1,:] + m_flow_in[1,:];
  for i in 2:n loop
    der(mass_fuel_discrete[i,:]) = - m_flow_center[i,:] - m_flow_return[i,:] + m_flow_center[i-1,:];
  end for;

  // separation condition for each circular ring element: ---------------------------------------------------

  for i in 1:n loop
    for j in 1:classification.N_class loop

      //w_prtcl_center_eff[i,j] = max(classifying.w_prtcl_r_abs[i,j],0);
      //w_prtcl_return_eff[i,j] = max(classifying.w_prtcl_return[i,j]-max(classifying.w_prtcl_r_abs[i,j],0),0);

      //w_prtcl_center_eff[i,j] = max(max(classifying.w_prtcl_r_abs[i,j],0),0.3*classifying.w_prtcl_return[i,j]+0.05*(classifying.w_prtcl_r_abs[i,j]));
      //w_prtcl_return_eff[i,j] = max(0.3*classifying.w_prtcl_return[i,j]-0.05*max(classifying.w_prtcl_r_abs[i,j],0),0);

      //w_prtcl_center_eff[i,j] = max(classifying.w_prtcl_r_abs[i,:])/(1.5*max(classifying.w_prtcl_r_abs[i,:]))*max(0,(classifying.w_prtcl_r_abs[i,j] + 0.5*max(classifying.w_prtcl_r_abs[i,:])));
      //w_prtcl_return_eff[i,j] = 0.4*classifying.w_prtcl_return[i,j];

      w_prtcl_center_eff[i,j] = max(classifying.w_prtcl_r_abs[i,j],0);
      w_prtcl_return_eff[i,j] = classifying.w_prtcl_return[i,j];

      m_flow_center[i,j] = A_coat_inner[i] .* rho_prtcl .* w_prtcl_center_eff[i,j] .* classifying.K_v[i,j];  //particle movement to center, mass flow to next circular ring element
      m_flow_return[i,j] = A_coat_outer[i] .* rho_prtcl .* w_prtcl_return_eff[i,j] .* classifying.K_v[i,j];   //return mass flow to table

    end for;
  end for;

  // total fuel mass  in controll volume: -------------------------------------------------------------------
  mass_fuel = sum(mass_fuel_discrete);

  //outlet fuel mass flow to furnace: -----------------------------------------------------------------------
  fuelOutlet1.m_flow = - sum(m_flow_center[n,:]);  // mass flow to furnace
  fuelOutlet1.classFraction_outflow = m_flow_center[n,1:classification.N_class-1] ./ max(Modelica.Constants.small,sum(m_flow_center[n,:]));

  //return fuel mass flow to table: -------------------------------------------------------------------------
  for j in 1:classification.N_class loop
    m_flow_return_sum[j] = sum(m_flow_return[:,j]);
  end for;

  fuelOutlet2.m_flow = - sum(m_flow_return);
  fuelOutlet2.classFraction_outflow = m_flow_return_sum[1:classification.N_class-1] ./ max(Modelica.Constants.small,sum(m_flow_return));

  // Composition Balance Fuel: -------------------------------------------------------------------------------
  for i in 1:fuelModel.N_c-1 loop
    der(xi_fuel[i]) = 1/mass_fuel*(fuelInlet.m_flow*(fuelIn.xi_c[i]-xi_fuel[i]) + fuelOutlet1.m_flow*(fuelOut1.xi_c[i]-xi_fuel[i]) + fuelOutlet2.m_flow*(fuelOut2.xi_c[i]-xi_fuel[i]));
  end for;

  // ClassFraction Balance Fuel: -----------------------------------------------------------------------------
  for i in 1:classification.N_class-1 loop
    der(classFraction[i]) = 1/mass_fuel*(fuelInlet.m_flow*(inStream(fuelInlet.classFraction_outflow[i])-classFraction[i]) + fuelOutlet1.m_flow*(fuelOutlet1.classFraction_outflow[i]-classFraction[i]) + fuelOutlet2.m_flow*(fuelOutlet2.classFraction_outflow[i]-classFraction[i]));
  end for;

  //Fuel boundary conditions: --------------------------------------------------------------------------------
  fuelInlet.p = fuelOutlet1.p;

  fuelOutlet1.T_outflow = T;
  fuelOutlet1.xi_outflow = xi_fuel;

  fuelOutlet2.T_outflow = T;
  fuelOutlet2.xi_outflow = xi_fuel;

  fuelInlet.T_outflow = T;
  fuelInlet.xi_outflow = xi_fuel;
  fuelInlet.classFraction_outflow = classFraction[1:classification.N_class-1];

  //----------------------------------------------------------
  // Additional for Summary and Evaluation
  //----------------------------------------------------------

  diameter_average = sum(classification.diameter_prtcl .* m_flow_center[n,:]) / sum(m_flow_center[n,:]);

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
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource="iVBORw0KGgoAAAANSUhEUgAAAjAAAAIwCAYAAACY8VFvAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7N1nfFTlugXwNTOppEESQCBAKKGX0EJHmoA0QZpdUREQkA5SpPciVYqACAiIIqJ0pHdCINRACIT0EAjpIXUy94NHr41QMu9+955Z/y/3d736rOccr3Fll3frSlWsZgIRERGRhuhlL0BERET0vFhgiIiISHNYYIiIiEhzWGCIiIhIc1hgiIiISHNYYIiIiEhzWGCIiIhIc1hgiIiISHNYYIiIiEhzWGCIiIhIc1hgiIiISHNYYIiIiEhzWGCIiIhIc1hgiIiISHNYYIiIiEhzWGCIiIhIc1hgiIiISHNYYIiIiEhzWGCIiIhIc1hgiIiISHNYYIiIiEhzbEQNbtemFWrXqCFqPBEREanclevXcfDwUSGzhRWY2jVqoEunDqLGExERkQaIKjC8hURERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNERESawwJDREREmsMCQ0RERJrDAkNE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",
          fileName="modelica://ClaRa/figures/Components/VolumeDistr.png")}),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end CentrifugalClassifier;
