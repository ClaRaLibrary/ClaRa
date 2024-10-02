within ClaRa.Basics.ControlVolumes.GasVolumes;
model VolumeGas_L2_advanced "A 0-d control volume for flue gas with dynamic momentum balance"
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

  extends ClaRa.Basics.Icons.Volume;
  outer ClaRa.SimCenter simCenter;

// ***************************** defintion of medium used in cell *************************************************
inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.flueGasModel "Medium to be used in tubes"
                                  annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

// ************************* replacable models for heat transfer, pressure loss and geometry **********************
  parameter Boolean use2HeatPorts=false "True, if a second heat port should be used" annotation(Dialog(group="Fundamental Definitions"));
  replaceable model HeatTransferOuter =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_only "1st: heat transfer model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model HeatTransferInner =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_only "1st: heat transfer model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
    replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L2 "1st: pressure loss model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);

// ********************************************* Parameters *******************************************

inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
parameter Boolean allow_reverseFlow = true annotation(Evaluate=true, Dialog(tab="Advanced"));
parameter Boolean use_dynamicMassbalance = true annotation(Evaluate=true, Dialog(tab="Advanced"));
final parameter Integer heatSurfaceOuter=1 "Heat transfer area to be considered"          annotation(Dialog(group="Geometry"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface"));
final parameter Integer heatSurfaceInner=2 "Heat transfer area to be considered"          annotation(Dialog(group="Geometry"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface"));
inner parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom= 10 "Nominal mass flow rates at inlet"
                                        annotation(Dialog(tab="General", group="Nominal Values"));

inner parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
inner parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy"      annotation(Dialog(group="Nominal Values"));
  parameter Units.MassFraction xi_nom[medium.nc - 1]=medium.xi_default "Nominal gas composition" annotation (Dialog(group="Nominal Values"));

inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));

  parameter ClaRa.Basics.Units.Temperature T_start= 273.15 + 100.0 "Start value of system temperature"
                                        annotation(Dialog(tab="Initialisation"));
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start=
          TILMedia.GasFunctions.specificEnthalpy_pTxi(medium, p_start, T_start, xi_start) "Start value of system specific enthalpy";
//          TILMedia.GasFunctions.specificEnthalpy_pTxi(medium, p_start, T_start, xi_start[1:end-1]/sum(xi_start))
//    "Start value of system specific enthalpy";
  parameter ClaRa.Basics.Units.Pressure p_start= 1.013e5 "Start value of sytsem pressure"
                                     annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc-1]=medium.xi_default "Start value of sytsem mass fraction"
                                          annotation(Dialog(tab="Initialisation"));
  parameter SI.DensityMassSpecific d_start=TILMedia.GasFunctions.density_pTxi(
      medium,
      p_start,
      T_start,
      xi_start) "Initial density";
   ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Outlet specific enthalpy";
   ClaRa.Basics.Units.EnthalpyMassSpecific h_in "Inlet specific enthalpy";
protected
   inner ClaRa.Basics.Units.EnthalpyMassSpecific h(start=h_start) "Bulk specific enthalpy";
   Real drhodt "Density derivative";
   ClaRa.Basics.Units.Mass mass "Mass inside volume";
   ClaRa.Basics.Units.Pressure p(start=p_start) "Pressure inside volume";
  ClaRa.Basics.Units.MassFraction xi[medium.nc-1]( start=xi_start) "Mass fractions inside volume";

  ClaRa.Basics.Units.Pressure Delta_p_fric "Pressure difference due to friction";
  ClaRa.Basics.Units.Pressure Delta_p_adv "Pressure difference due to advection";
  Modelica.Units.SI.Velocity w_inlet "Flow velocity at inlet";
  Modelica.Units.SI.Velocity w_outlet "Flow velocity at outlet";

  //____Heat flow rates______________________________________________________________________________________
  Modelica.Units.SI.HeatFlowRate Q_flows "Heat flow rates through ports";

public
  HeatTransferOuter heatTransferOuter(heatSurfaceAlloc=heatSurfaceOuter)
    annotation (Placement(transformation(extent={{-32,60},{-12,80}})));
  HeatTransferOuter heatTransferInner(heatSurfaceAlloc=heatSurfaceInner) if use2HeatPorts
    annotation (Placement(transformation(extent={{-74,60},{-54,80}})));
  inner Geometry geo "Cell geometry"   annotation (Placement(transformation(extent={{44,60},{64,80}})));

  PressureLoss pressureLoss "Pressure loss model" annotation (Placement(transformation(extent={{8,60},{28,80}})));

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium, m_flow(min=if
          allow_reverseFlow then -Modelica.Constants.inf else 1e-5)) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium, m_flow(max=if
          allow_reverseFlow then Modelica.Constants.inf else -1e-5)) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TILMedia.Gas_pT     flueGasInlet(gasType = medium, p=inlet.p, T=noEvent(actualStream(inlet.T_outflow)), xi=noEvent(actualStream(inlet.xi_outflow)))
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  TILMedia.Gas_pT     flueGasOutlet(gasType = medium, p=outlet.p, T=noEvent(actualStream(outlet.T_outflow)), xi=noEvent(actualStream(outlet.xi_outflow)))
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  inner TILMedia.Gas_ph     bulk(
    computeTransportProperties=false,
    gasType = medium,p=p,h=h,xi=xi,
    stateSelectPreferForInputs=true)
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

  ClaRa.Basics.Interfaces.HeatPort_a heatOuter "heat port" annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  ClaRa.Basics.Interfaces.HeatPort_b  heatInner if use2HeatPorts "heat port"
    annotation (Placement(transformation(extent={{-54,90},{-34,110}})));
  ClaRa.Basics.Interfaces.HeatPort_b  heatInnerInternal "Internal heat port";

  //Summary

  model Outline
   extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Volume volume_tot "Total volume";
    input ClaRa.Basics.Units.Area A_heatOuter "Outer heat transfer area";
    input ClaRa.Basics.Units.Area A_heatInner "Inner heat transfer area";
    input ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Total heat flow rate";
    input ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";
    input ClaRa.Basics.Units.Mass mass "Mass inside volume" annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature  inside volume" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure inside volume" annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy inside volume" annotation (Dialog);
    input ClaRa.Basics.Units.Enthalpy H "Enthalpy inside volume" annotation (Dialog);
    input ClaRa.Basics.Units.DensityMassSpecific rho "Density inside volume" annotation (Dialog);
  end Outline;

inner model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   ClaRa.Basics.Records.FlangeGas inlet;
   ClaRa.Basics.Records.FlangeGas outlet;
end Summary;

  inner Summary summary(
    outline(
      volume_tot=geo.volume,
      A_heatOuter=geo.A_heat[heatSurfaceOuter],
      A_heatInner=geo.A_heat[heatSurfaceInner],
      Q_flow_tot=heatOuter.Q_flow + heatInnerInternal.Q_flow,
      Delta_p=inlet.p - outlet.p,
      mass=mass,
      T=bulk.T,
      p=p,
      h=h,
      H=h*mass,
      rho=bulk.d),
    inlet(
      mediumModel=medium,
      m_flow=inlet.m_flow,
      T=flueGasInlet.T,
      p=inlet.p,
      h=flueGasInlet.h,
      xi=flueGasInlet.xi,
      H_flow=inlet.m_flow*flueGasInlet.h),
    outlet(
      mediumModel=medium,
      m_flow=-outlet.m_flow,
      T=flueGasOutlet.T,
      p=outlet.p,
      h=flueGasOutlet.h,
      xi=flueGasOutlet.xi,
      H_flow=-outlet.m_flow*flueGasOutlet.h)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

//iCom
protected
  inner ClaRa.Basics.Records.IComGas_L2 iCom(
    mediumModel=medium,
    p_in=inlet.p,
    T_in=flueGasInlet.T,
    m_flow_in=inlet.m_flow,
    p_out=outlet.p,
    T_out=flueGasOutlet.T,
    m_flow_out=outlet.m_flow,
    T_bulk=bulk.T,
    p_bulk=bulk.p,
    p_nom=p_nom,
    m_flow_nom=m_flow_nom,
    h_nom=h_nom,
    xi_nom=xi_nom,
    fluidPointer_in=flueGasInlet.gasPointer,
    fluidPointer_out=flueGasOutlet.gasPointer,
    fluidPointer_bulk=bulk.gasPointer,
    xi_in=flueGasInlet.xi,
    xi_out=flueGasOutlet.xi,
    V_flow_in=abs(inlet.m_flow/flueGasInlet.d),
    V_flow_out=abs(outlet.m_flow/flueGasOutlet.d),
    xi_bulk=bulk.xi,
    h_bulk=bulk.h,
    mass=mass) annotation (Placement(transformation(extent={{-80,-102},{-60,-82}})));

equation
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(geo.volume>0, "The system volume must be greater than zero!");
  assert(geo.A_heat[heatSurfaceOuter]>=0, "The area of heat transfer must be greater than zero!");
  if allow_reverseFlow then
    assert( 0==0, "Dummy");
    else
  assert(  not inlet.m_flow < 0, "Flow reversal at inlet, but allow_reverseFlow is set to FALSE!");
  assert( not outlet.m_flow > 0, "Flow reversal at outlet, but allow_reverseFlow is set to FALSE!");
  end if;

// Port connection
inlet.T_outflow  = bulk.T;
outlet.T_outflow = bulk.T;

inlet.xi_outflow= xi;
outlet.xi_outflow = xi;

 h_in=flueGasInlet.h;
 h_out=flueGasOutlet.h;

  //-------------------------------------------
  //Heat flows through heat ports
  Q_flows = if use2HeatPorts then heatOuter.Q_flow + heatInnerInternal.Q_flow else heatOuter.Q_flow;
  if not use2HeatPorts then
    heatInnerInternal.Q_flow = 0;
  end if;
  //-------------------------------------------
  //-------------------------------------------
  //Fluid mass in cells
  mass = if useHomotopy then homotopy(geo.volume .* bulk.d, geo.volume .* d_start) else geo.volume .* bulk.d;

  w_inlet =inlet.m_flow/(geo.A_cross*flueGasInlet.d);
  w_outlet =-outlet.m_flow/(geo.A_cross*flueGasOutlet.d);

  Delta_p_fric = pressureLoss.Delta_p;
  Delta_p_adv =w_inlet*abs(w_inlet)*flueGasInlet.d - w_outlet*abs(w_outlet)*flueGasOutlet.d;

  // Dynamic momentum balance
//    inlet.p =  p + pressureLoss.Delta_p;
   geo.volume/(geo.A_cross)^2*der(inlet.m_flow) = if useHomotopy then homotopy(inlet.p - outlet.p + geo.volume/geo.A_cross*der(inlet.p)/bulk.w/2 - geo.volume/geo.A_cross*der(outlet.p)/bulk.w/2 + Delta_p_adv - Delta_p_fric, 0) else inlet.p - outlet.p +  geo.volume/geo.A_cross*der(inlet.p)/bulk.w/2 - geo.volume/geo.A_cross*der(outlet.p)/bulk.w/2 + Delta_p_adv - Delta_p_fric;

   outlet.p = p;

// Mass balance
  if use_dynamicMassbalance then
    inlet.m_flow + outlet.m_flow  =  drhodt*geo.volume;
    der(xi) =
     1/mass * (inlet.m_flow*(flueGasInlet.xi - xi) + outlet.m_flow*(flueGasOutlet.xi - xi));
  else
    inlet.m_flow + outlet.m_flow  =  0;
    zeros(medium.nc-1) =
      (inlet.m_flow*(flueGasInlet.xi - xi) + outlet.m_flow*(flueGasOutlet.xi - xi));
  end if;

  if use_dynamicMassbalance then
    drhodt = bulk.drhodh_pxi * der(h)
             + bulk.drhodp_hxi * der(p)
             + sum({bulk.drhodxi_ph[i] * der(bulk.xi[i]) for i in 1:medium.nc-1});
  else
     drhodt = bulk.drhodh_pxi * der(h)
             + bulk.drhodp_hxi * der(p);
  end if;

  //Energy balance
  der(h) =  (inlet.m_flow*(h_in-h) + outlet.m_flow*(h_out-h)  + geo.volume*der(p) + Q_flows)/mass;

initial equation

    if initOption == 1 then //steady state
      der(h)=0;
      der(p)=0;
      der(xi)=zeros(medium.nc-1);
    elseif initOption == 201 then //steady pressure
      der(p)=0;
    elseif initOption == 202 then //steady enthalpy
      der(h)=0;
    elseif initOption == 208 then // steady pressure and enthalpy
      der(h)=0;
      der(p)=0;
    elseif initOption == 210 then //steady density
      drhodt=0;
    elseif initOption == 0 then //no init
    // do nothing
    else
     assert(initOption == 0,"Invalid init option");
    end if;

equation
  connect(heatTransferOuter.heat, heatOuter) annotation (Line(
      points={{-12,70},{0,70},{0,100}},
      color={167,25,48},
      thickness=0.5));
//   connect(heatTransferInner.heat, heatInner) annotation (Line(
//       points={{-54,70},{-44,70},{-44,100}},
//       color={167,25,48},
//       thickness=0.5));
  connect(heatInnerInternal, heatInner);
  connect(heatInnerInternal, heatTransferInner.heat);
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
</html>"),Diagram(    coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                      graphics));
end VolumeGas_L2_advanced;
