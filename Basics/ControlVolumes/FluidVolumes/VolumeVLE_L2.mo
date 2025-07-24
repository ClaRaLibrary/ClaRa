within ClaRa.Basics.ControlVolumes.FluidVolumes;
model VolumeVLE_L2 "A lumped control volume for vapour/liquid equilibrium"
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

  extends ClaRa.Basics.Icons.Volume;

  extends ClaRa.Basics.Icons.ComplexityLevel(     complexity="L2");
//  extends BaseClasses.Interfaces.DataInterface(p_int=outlet.p/1e5,h_int=outlet.h_outflow/1e3, m_flow_int=-outlet.m_flow, T_int=fluidOut.T-273.15, s_int=refOutlet.s/1e3);
  outer ClaRa.SimCenter simCenter;

  import Modelica.Constants.eps;
  import ClaRa;

model Outline
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter Boolean showExpertSummary = false;
    input ClaRa.Basics.Units.Volume volume_tot "Total volume";
    input ClaRa.Basics.Units.Area A_heat "Heat transfer area";
    input ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Total heat flow rate";
    input ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";
end Outline;

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE                inlet;
  ClaRa.Basics.Records.FlangeVLE                outlet;
  ClaRa.Basics.Records.FluidVLE_L2                fluid;
end Summary;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// replaceable models~~~~~~~~~~~~~~~~~~~~~~~~
  inner parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2
          constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE "1st: choose heat transfer model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model PhaseBorder =
      ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdealPhases "1st: choose phase border model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

    replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "1st: choose friction model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
  inner parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rates at inlet" annotation (Dialog(tab="General", group="Nominal Values"));

  inner parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  inner parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy" annotation (Dialog(group="Nominal Values"));
  inner parameter ClaRa.Basics.Units.MassFraction xi_nom[medium.nc - 1]=medium.xi_default "Nominal mass fraction" annotation (Dialog(group="Nominal Values"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start=1e5 "Start value of system specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "Start value of system pressure" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=medium.xi_default "Start value for mass fraction" annotation (Dialog(tab="Initialisation"));
  inner parameter Integer  initOption=0 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed rel.level (for phaseBorder = idealSeparated only)",  choice=205 "Fixed rel.level and steady pressure (for phaseBorder = idealSeparated only)"));

  parameter Boolean showExpertSummary = simCenter.showExpertSummary "True, if expert summary should be applied" annotation(Dialog(tab="Summary and Visualisation"));
  parameter Integer heatSurfaceAlloc=1 "Heat transfer area to be considered"          annotation(Dialog(group="Geometry"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface"));

protected
  parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
      medium,
      p_nom,
      h_nom) "Nominal density";

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Variables and model instances ~~~~~~~~~~~~

  ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Outlet spec. enthalpy";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_in "Inlet spec. enthalpy";
  ClaRa.Basics.Units.EnthalpyMassSpecific h(start=h_start) "spec. enthalpy state";

  ClaRa.Basics.Units.MassFraction xi_out[medium.nc - 1] "Outlet composition";
  ClaRa.Basics.Units.MassFraction xi_in[medium.nc - 1] "Inlet composition";
  ClaRa.Basics.Units.MassFraction xi[medium.nc - 1](start=xi_start) "Composition state";

  Real drhodt "Time derivative of density"; //(unit="kg/(m3s)");

public
  ClaRa.Basics.Units.Mass mass "Total system mass";
  inner ClaRa.Basics.Units.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";
public
  ClaRa.Basics.Interfaces.FluidPortIn      inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut      outlet(  Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent={{84,86},
            {104,106}}),        iconTransformation(
         extent={{-10,-10},{10,10}},
         rotation=90,
         origin={0,100})));

   Summary summary(inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h*inlet.m_flow, rho=fluidIn.d),
                   fluid(showExpertSummary = showExpertSummary, mass=mass, p=p, h=h, T=bulk.T,s=bulk.s, steamQuality=bulk.q, H=h*mass, rho=bulk.d, T_sat=bulk.VLE.T_l, h_dew=bulk.VLE.h_v, h_bub=bulk.VLE.h_l),
                   outlet(showExpertSummary = showExpertSummary,m_flow = -outlet.m_flow, T=fluidOut.T, p=outlet.p, h=fluidOut.h, s=fluidOut.s, steamQuality=fluidOut.q, H_flow=-fluidOut.h*outlet.m_flow, rho=fluidOut.d),
    outline(
      volume_tot=geo.volume,
      A_heat=geo.A_heat[heatSurfaceAlloc],
      Delta_p=inlet.p - outlet.p,
      Q_flow_tot=heat.Q_flow))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));
public
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    final p=inlet.p,
    final h=h_in,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true,
    xi=xi_in) annotation (Placement(transformation(extent={{-90,-10},{-70,10}}, rotation=0)));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    p=outlet.p,
    h=h_out,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    computeVLEAdditionalProperties=true,
    xi=xi_out) annotation (Placement(transformation(extent={{70,-10},{90,10}}, rotation=0)));

protected
  inner TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph bulk(
    vleFluidType=medium,
    p=p,
    h=h,
    computeVLEAdditionalProperties=true,
    computeVLETransportProperties=true,
    computeTransportProperties=true,
    xi=xi) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0)));

public
 HeatTransfer heattransfer(
 final heatSurfaceAlloc=heatSurfaceAlloc)
    annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
  inner Geometry geo annotation (Placement(transformation(extent={{-48,60},
            {-28,80}})));
  PhaseBorder phaseBorder annotation (Placement(transformation(extent={{-18,60},{2,80}})));
  PressureLoss pressureLoss annotation (Placement(transformation(extent={{12,60},
            {32,80}})));

protected
  inner ClaRa.Basics.Records.IComVLE_L2 iCom(
    mass=mass,
    h_in=h_in,
    h_out=h_out,
    p_in=inlet.p,
    p_out=outlet.p,
    m_flow_in=inlet.m_flow,
    m_flow_out=outlet.m_flow,
    h_nom=h_nom,
    T_in=fluidIn.T,
    T_out=fluidOut.T,
    p_nom=p_nom,
    m_flow_nom=m_flow_nom,
    xi_in=fluidIn.xi,
    xi_out=fluidOut.xi,
    T_bulk=bulk.T,
    mediumModel=medium,
    p_bulk=bulk.p,
    h_bulk=bulk.h,
    xi_bulk=bulk.xi,
    fluidPointer_bulk=bulk.vleFluidPointer,
    fluidPointer_in=fluidIn.vleFluidPointer,
    fluidPointer_out=fluidOut.vleFluidPointer,
    xi_nom=xi_nom) "Internal communication record"           annotation (Placement(transformation(extent={{-80,-102},{-60,-82}})));

equation
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(geo.volume>0, "The system volume must be greater than zero!");
  assert(geo.A_heat[heatSurfaceAlloc]>=0, "The area of heat transfer must be greater than zero!");

//~~~~~~~~~~~~~~~~~~~~~~~~~~~
// System definition ~~~~~~~~
  mass= if useHomotopy then geo.volume*homotopy(bulk.d,rho_nom) else geo.volume*bulk.d;
 // der(mass)=drhodt*geo.V;
  drhodt*geo.volume=inlet.m_flow + outlet.m_flow "Mass balance";
  drhodt=der(p)*bulk.drhodp_hxi + der(h)*bulk.drhodh_pxi + sum(der(xi).*bulk.drhodxi_ph) "calculating drhodt from state variables";

  der(h) =  if useHomotopy then homotopy((inlet.m_flow*h_in + outlet.m_flow*h_out + geo.volume*der(p) + heat.Q_flow - h*geo.volume*drhodt), (m_flow_nom*h_in - m_flow_nom*h_out  + geo.volume*der(p) + heat.Q_flow - h*geo.volume*drhodt))/mass
  else (inlet.m_flow*h_in + outlet.m_flow*h_out  + geo.volume*der(p) + heat.Q_flow - h*geo.volume*drhodt)/mass "Energy balance";

  der(xi) =  if useHomotopy then homotopy((inlet.m_flow*xi_in + outlet.m_flow*xi_out - xi*geo.volume*drhodt), (m_flow_nom*xi_in - m_flow_nom*xi_out  - xi*geo.volume*drhodt))/mass
  else (inlet.m_flow*xi_in + outlet.m_flow*xi_out  - xi*geo.volume*drhodt)/mass "Species balance without chemical reactions";

  inlet.h_outflow=phaseBorder.h_inflow;
  outlet.h_outflow=phaseBorder.h_outflow;

  h_in= if useHomotopy then homotopy(noEvent(actualStream(inlet.h_outflow)), inStream(inlet.h_outflow)) else noEvent(actualStream(inlet.h_outflow));
  h_out= if useHomotopy then homotopy(noEvent(actualStream(outlet.h_outflow)), outlet.h_outflow) else noEvent(actualStream(outlet.h_outflow));
  xi_in= if useHomotopy then homotopy(noEvent(actualStream(inlet.xi_outflow)), inStream(inlet.xi_outflow)) else noEvent(actualStream(inlet.xi_outflow));
  xi_out= if useHomotopy then homotopy(noEvent(actualStream(outlet.xi_outflow)), outlet.xi_outflow) else noEvent(actualStream(outlet.xi_outflow));

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  In the following equations dividing the friction pressure loss into two parts located at the inlet and outlet side respectively leads
//  to a disadvatageous coupling of flow model cascades and iteration of mass flow rates in some applications.
//    inlet.p  =  p + pressureLoss.Delta_p/2 + phaseBorder.dp_geo_in;
//    outlet.p = p - pressureLoss.Delta_p/2 + phaseBorder.dp_geo_out;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  inlet.p  =p + pressureLoss.Delta_p + phaseBorder.Delta_p_geo_in;
  outlet.p =p + phaseBorder.Delta_p_geo_out "The friction term is lumped at the inlet side to avoid direct coupling of two flow models, this avoids aniteration of mass flow rates in some application cases";

  inlet.xi_outflow   = xi;
  outlet.xi_outflow  = xi;

initial equation
  if initOption == 1 then //steady state
    der(h)=0;
    der(p)=0;
    der(xi)=zeros(medium.nc-1);
  elseif initOption == 201 then //steady pressure
    der(p)=0;
  elseif initOption == 202 then //steady enthalpy
    der(h)=0;
  elseif initOption == 0 then //no init
    // do nothing
  elseif initOption == 204 and phaseBorder.modelType=="IdeallySeparated" then // fixed rel. level
    phaseBorder.level_rel = phaseBorder.level_rel_start;
  elseif initOption == 205 and phaseBorder.modelType=="IdeallySeparated" then // fixed rel. level and steady pressure
    phaseBorder.level_rel = phaseBorder.level_rel_start;
    der(iCom.p_bulk) = 0;
  else
    assert(false, "Unsupported initial condition in " + getInstanceName());
  end if;

equation
  connect(heattransfer.heat, heat) annotation (Line(
      points={{-60,70},{-60,86},{94,86},{94,96}},
      color={191,0,0},
      smooth=Smooth.None));
    annotation (Documentation(info="<html>
<p><b>Model description: </b>A non-adiabatic control volume without friction losses taking the geostatic pressure difference into account</p>
<p><ul>
<li>This model is derived from ThermoPower.Water.Header</li>
<li>Flow reversal is supported</li>
<li>Homotopy initialisation is supported</li>
</ul></p>        
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
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics), Diagram(graphics));
end VolumeVLE_L2;
