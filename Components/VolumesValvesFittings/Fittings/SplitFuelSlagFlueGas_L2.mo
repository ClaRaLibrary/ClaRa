within ClaRa.Components.VolumesValvesFittings.Fittings;
model SplitFuelSlagFlueGas_L2 "A split for fuel flue gas and slag with gas volume"
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

  extends ClaRa.Basics.Interfaces.DataInterfaceVectorGas(N_sets=N_ports_out, eye(each medium=flueGas));
  extends ClaRa.Basics.Icons.Adapter5_fw;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  outer ClaRa.SimCenter simCenter;

  model Gas
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Mass m "Mass flow rate" annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy" annotation (Dialog);
    input ClaRa.Basics.Units.Enthalpy H "Specific enthalpy" annotation (Dialog);
    input ClaRa.Basics.Units.DensityMassSpecific rho "Specific enthalpy" annotation (Dialog);
  end Gas;

  inner model Summary
    parameter Integer N_ports_out;
    extends ClaRa.Basics.Icons.RecordIcon;
    Gas gas;
    ClaRa.Basics.Records.FlangeGas inlet;
    ClaRa.Basics.Records.FlangeGas outlet[N_ports_out];
  end Summary;

  inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));

  // ***************************** defintion of medium used in cell *************************************************
  // inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used in tubes"
  //                                   annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Fuel type" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  inner parameter ClaRa.Basics.Media.Slag.PartialSlag slagType=simCenter.slagModel "Slag properties" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  inner parameter TILMedia.GasTypes.BaseGas flueGas=simCenter.flueGasModel "Medium to be used in tubes" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  ClaRa.Basics.Interfaces.FuelSlagFlueGas_inlet inlet(
    flueGas(Medium=flueGas),
    fuelModel=fuelModel,
    final slagType=slagType) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-100,0}), iconTransformation(extent={{-110,-10},{-90,10}})));

  ClaRa.Basics.Interfaces.FuelSlagFlueGas_outlet outlet[N_ports_out](each
  flueGas(Medium=flueGas),
     each fuelModel=fuelModel,
   each final slagType=slagType) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,0}),                                                                                                                                    iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,0})));

  parameter Integer N_ports_out(min=1) = 1 "Number of inlet  ports" annotation (Evaluate=true, Dialog(tab="General", group="Fundamental Definitions"));
  //connectorSizing=true,

  replaceable model PressureLoss = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp "Pressure loss model at inlet" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter ClaRa.Basics.Units.Volume volume=1 annotation (Dialog(tab="General", group="Geometry"));

protected
  TILMedia.Gas_pT gasInlet(
    gasType=flueGas,
    p=inlet.flueGas.p,
    T=noEvent(actualStream(inlet.flueGas.T_outflow)),
    xi=noEvent(actualStream(inlet.flueGas.xi_outflow))) annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
protected
  TILMedia.Gas_pT gasOutlet[N_ports_out](
    each gasType=flueGas,
    p=outlet.flueGas.p,
    T=noEvent(actualStream(outlet.flueGas.T_outflow)),
    xi=noEvent(actualStream(outlet.flueGas.xi_outflow))) annotation (Placement(transformation(extent={{60,-14},{80,6}})));
protected
  inner TILMedia.Gas_ph bulk(
    computeTransportProperties=false,
    gasType=flueGas,
    p=p,
    h=h,
    xi=xi,
    stateSelectPreferForInputs=true) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  /****************** Nominal values *******************/
public
  parameter Modelica.Units.SI.MassFlowRate m_flow_out_nom[N_ports_out]=fill(10, N_ports_out) "Nominal mass flow rates at outlet" annotation (Dialog(tab="General", group="Nominal Values"));
  parameter Modelica.Units.SI.Pressure p_nom=100000
                                                 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.Temperature T_nom=293.15 "Nominal specific enthalpy" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFraction xi_nom[flueGas.nc - 1]=flueGas.xi_default annotation (Dialog(group="Nominal Values"));

  final parameter Modelica.Units.SI.Density rho_nom=TILMedia.GasFunctions.density_pTxi(
      flueGas,
      p_nom,
      T_nom,
      xi_nom) "Nominal density";
  /****************** Initial values *******************/
public
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start=1.013e5 "Initial value for air pressure" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Temperature T_start=298.15 "Initial value for air temperature" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.MassFraction[flueGas.nc - 1] xi_start=flueGas.xi_default "Initial value for mixing ratio" annotation (Dialog(tab="Initialisation"));

  final parameter Modelica.Units.SI.SpecificEnthalpy h_start=TILMedia.GasFunctions.specificEnthalpy_pTxi(
      flueGas,
      p_start,
      T_start,
      xi_start) "Start value for specific Enthalpy inside volume";

  ClaRa.Basics.Units.MassFraction xi[flueGas.nc - 1](start=xi_start);
  Modelica.Units.SI.SpecificEnthalpy h(start=h_start) "Specific enthalpy";
  ClaRa.Basics.Units.Pressure p(start=p_start) "Pressure";

  ClaRa.Basics.Units.Mass mass "Gas mass in control volume";

  Real drhodt "Density derivative";

   PressureLoss pressureLoss;

public
  inner Summary summary(
    N_ports_out=N_ports_out,
    inlet(
      mediumModel=flueGas,
      m_flow=inlet.flueGas.m_flow,
      T=gasInlet.T,
      p=inlet.flueGas.p,
      h=gasInlet.h,
      xi=gasInlet.xi,
      H_flow=inlet.flueGas.m_flow*gasInlet.h),
    outlet(
      each mediumModel=flueGas,
      m_flow=outlet.flueGas.m_flow,
      T=gasOutlet.T,
      p=outlet.flueGas.p,
      h=gasOutlet.h,
      xi=gasOutlet.xi,
      each H_flow=outlet.flueGas.m_flow*gasOutlet.h),
    gas(
      m=mass,
      T=bulk.T,
      p=p,
      h=h,
      H=h*mass,
      rho=bulk.d)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

initial equation

  if initOption == 1 then
    //steady state
    der(h) = 0;
    der(p) = 0;
    der(xi) = zeros(flueGas.nc - 1);
  elseif initOption == 201 then
    //steady pressure
    der(p) = 0;
  elseif initOption == 202 then
    //steady enthalpy
    der(h) = 0;
  elseif initOption == 208 then
    // steady pressure and enthalpy
    der(h) = 0;
    der(p) = 0;
  elseif initOption == 210 then
    //steady density
    drhodt = 0;
  elseif initOption == 0 then
    //no init
    // do nothing
  else
    assert(initOption == 0, "Invalid init option");
  end if;

equation

  pressureLoss.m_flow = inlet.flueGas.m_flow;

  inlet.flueGas.xi_outflow = xi;
  inlet.flueGas.T_outflow = bulk.T;

  for i in 1:N_ports_out loop
    outlet[i].flueGas.p = p;
    outlet[i].flueGas.T_outflow = bulk.T;
    outlet[i].flueGas.xi_outflow = xi;

    outlet[i].fuel.T_outflow = inStream(inlet.fuel.T_outflow);
    outlet[i].fuel.m_flow = -inlet.fuel.m_flow/N_ports_out;
    outlet[i].fuel.xi_outflow = inStream(inlet.fuel.xi_outflow);

    outlet[i].slag.T_outflow = inStream(inlet.slag.T_outflow);
    outlet[i].slag.p = inlet.slag.p;
  end for;

  inlet.fuel.p = outlet[1].fuel.p;
  inlet.fuel.T_outflow=1000; // dummy, backflow is not supported
  inlet.fuel.xi_outflow = fuelModel.defaultComposition; // dummy, backflow is not supported;

  inlet.slag.T_outflow=1000; // dummy, backflow is not supported
  outlet[1].slag.m_flow = -inlet.slag.m_flow/N_ports_out;

  //der(h) = 1/mass*(inlet.m_flow *(gasInlet.h - h) + sum(outlet.m_flow.*(gasOutlet.h - h*ones(N_ports_out))) + volume*der(p)) "Energy balance";
  der(h) = if useHomotopy then homotopy(1/mass*(inlet.flueGas.m_flow*(gasInlet.h - h) + sum(outlet.flueGas.m_flow .* (gasOutlet.h - h*ones(N_ports_out))) + volume*der(p)), 1/mass*(m_flow_out_nom[1]*(gasInlet.h - h) + sum(m_flow_out_nom .* (gasOutlet.h - h*ones(N_ports_out))) + volume*der(p))) else 1/mass*(inlet.flueGas.m_flow*(gasInlet.h - h) + sum(outlet.flueGas.m_flow .* (gasOutlet.h - h*ones(N_ports_out))) + volume*der(p)) "Energy balance";

  for i in 1:flueGas.nc - 1 loop
    //der(xi[i]) = 1/mass.*(inlet.m_flow.*(gasInlet.xi[i]-xi[i]) + sum(outlet.m_flow.*(gasOutlet.xi[i]-xi[i]*ones(N_ports_out)))) "Mass balance";
    der(xi[i]) = if useHomotopy then homotopy(1/mass .* (inlet.flueGas.m_flow .* (gasInlet.xi[i] - xi[i]) + sum(outlet.flueGas.m_flow .* (gasOutlet[:].xi[i] - xi[i]*ones(N_ports_out)))), 1/mass .* (m_flow_out_nom[1] .* (xi_nom[i] - xi[i]) + sum(m_flow_out_nom .* (xi_nom[i]*ones(N_ports_out) - xi[i]*ones(N_ports_out))))) else 1/mass .* (inlet.flueGas.m_flow .* (gasInlet.xi[i] - xi[i]) + sum(outlet.flueGas.m_flow .* (gasOutlet[:].xi[i] - xi[i]*ones(N_ports_out)))) "Mass balance";
  end for;

  //______________ Balance euqations _______________________

  mass = if useHomotopy then volume*homotopy(bulk.d, rho_nom) else volume*bulk.d "Mass in control volume";

  drhodt = bulk.drhodh_pxi*der(h) + bulk.drhodp_hxi*der(p) + sum({bulk.drhodxi_ph[i]*der(bulk.xi[i]) for i in 1:flueGas.nc - 1});

  drhodt*volume = inlet.flueGas.m_flow + sum(outlet.flueGas.m_flow) "Mass balance";

  inlet.flueGas.p = p + pressureLoss.dp "Momentum balance";

  for i in 1:N_ports_out loop
    eye[i].m_flow = -outlet[i].flueGas.m_flow;
    eye[i].T = bulk.T - 273.15;
    eye[i].s = bulk.s/1e3;
    eye[i].p = bulk.p/1e5;
    eye[i].h = h/1e3;
    eye[i].xi = bulk.xi;
  end for;

  annotation (
    Documentation(info="<html>
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
</html>", revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
    Diagram(graphics, coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics));
end SplitFuelSlagFlueGas_L2;
