within ClaRa.Basics.ControlVolumes.FluidVolumes;
model VolumeVLEGas_L3 "A volume element balancing liquid and gas phase with n inlet and outlet ports"
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
  extends ClaRa.Basics.Icons.Volume2Zones;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");
  outer ClaRa.SimCenter simCenter;

  import Modelica.Constants.eps;
  import ClaRa.Basics.Functions.Stepsmoother;
  import ClaRa;

  //_____________________________________________________
  //____________loal record definition__________________
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    input ClaRa.Basics.Units.Volume volume_tot "Total volume";
    input ClaRa.Basics.Units.Area A_heat_tot "Heat transfer area";
    input ClaRa.Basics.Units.Volume volume[2] if showExpertSummary "Volume of liquid and gas volume";
    input ClaRa.Basics.Units.Area A_heat[2] if showExpertSummary "Heat transfer area";
    input ClaRa.Basics.Units.Length level_abs "Absolue filling level";
    input Real level_rel if showExpertSummary "relative filling level";
    input ClaRa.Basics.Units.Mass fluidMass "Total fluid mass";
    input ClaRa.Basics.Units.Enthalpy H_tot if showExpertSummary "Systems's enthalpy";
    input ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Total heat flow rate";
    input ClaRa.Basics.Units.HeatFlowRate Q_flow[2] if showExpertSummary "Zonal heat flow rate";
    input ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference p_in - p_out";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE inlet;
    ClaRa.Basics.Records.FlangeVLE outlet;
    ClaRa.Basics.Records.FlangeGas vent;
    ClaRa.Basics.Records.FluidVLE_L34 fluid;
  end Summary;

   record ICom
     extends ClaRa.Basics.Records.IComBase_L3;
    ClaRa.Basics.Units.Volume volume[N_cv];
    ClaRa.Basics.Units.EnthalpyMassSpecific h[N_cv];

   end ICom;
  //_____________________________________________________
  //_______________replaceable models____________________
  inner parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
  inner parameter TILMedia.Gas.Types.BaseGas gasType=simCenter.flueGasModel "Gas medium"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.Constant_L3_ypsDependent
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L3 "1st: choose heat transfer model | 2nd: edit corresponding record"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=
        true);

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "1st: choose friction model | 2nd: edit corresponding record"
                                                                  annotation (
      Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);

  //_____________________________________________________
  //______________________parameters_____________________
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_ph=50000 "|Phase Border|HTC of the phase border";
  parameter ClaRa.Basics.Units.Area A_heat_ph=geo.A_hor*100 "|Phase Border|Heat transfer area at phase border";
  //*min(volume_liq/volume_gas, V_gas/volume_liq)

  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(tab="Initialisation"));
  inner parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rates at inlet" annotation (Dialog(tab="General", group="Nominal Values"));

  inner parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));

  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_liq_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleDensity_pxi(                                     medium, p_nom) "Nominal density";
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_gas_nom=1.2 "Nominal density";

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(                                     medium, p_start) "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Temperature T_gas_start=293.15 "Start value of sgas zone's temperature" annotation (Dialog(tab="Initialisation"));

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_gas_start=TILMedia.Gas.Functions.specificEnthalpy_pTxi(
      gasType,
      p_start,
      T_gas_start,
      xi_start) "Start value of gas zone's specific enthalpy" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.MassFraction xi_start[gasType.nc-1]= gasType.xi_default "Initial gas mass fraction"
                                                                                            annotation (Dialog(tab="Initialisation"));
  inner parameter String initType = "No init, use start values as guess" "Type of initialisation"
    annotation (Dialog(tab="Initialisation"), choices(choice = "No init, use start values as guess", choice="Steady state in p, h_liq, T_gas",
            choice = "Steady state in p", choice="steady State in h_liq and T_gas", choice = "Fixed value for filling level",
             choice = "Fixed values for filling level, p, h_liq, T_gas"));

  parameter ClaRa.Basics.Units.Length radius_flange=0.05 "Flange radius" annotation (Dialog(group="Geometry"));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation" annotation(Dialog(group="Shape interpretation"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Integer heatSurfaceAlloc=1 "Heat transfer area to be considered"          annotation(Dialog(group="Geometry"),choices(choice=1 "Lateral surface",
                                                                                   choice=2 "Inner heat transfer surface"));

protected
  constant ClaRa.Basics.Units.Length level_abs_min=1e-6;
  Modelica.Blocks.Tables.CombiTable1Dv table(table=geo.shape, columns={2}, smoothness=smoothness) "Shape table for level calculation";
  final parameter ClaRa.Basics.Units.Length Delta_z_max_in[geo.N_inlet]={min(geo.z_in[i] + radius_flange, geo.height_fill) for i in 1:geo.N_inlet};
  final parameter ClaRa.Basics.Units.Length Delta_z_min_in[geo.N_inlet]={max(1e-3, geo.z_in[i] - radius_flange) for i in 1:geo.N_inlet};
  final parameter ClaRa.Basics.Units.Length Delta_z_max_out[geo.N_outlet]={min(geo.z_out[i] + radius_flange, geo.height_fill) for i in 1:geo.N_outlet};
  final parameter ClaRa.Basics.Units.Length Delta_z_min_out[geo.N_outlet]={max(1e-3, geo.z_out[i] - radius_flange) for i in 1:geo.N_outlet};
  //_____________________________________________________
  //_______Variables and model instances_________________
public
  ClaRa.Basics.Units.EnthalpyMassSpecific h_out[geo.N_outlet];
  ClaRa.Basics.Units.EnthalpyMassSpecific h_in[geo.N_inlet];
  ClaRa.Basics.Units.MassFraction xi_out[geo.N_outlet,medium.nc - 1];
  ClaRa.Basics.Units.MassFraction xi_in[geo.N_inlet,medium.nc - 1];
  inner ClaRa.Basics.Units.EnthalpyMassSpecific h_liq(start=h_liq_start) "Specific enthalpy of liquid phase";
  inner ClaRa.Basics.Units.EnthalpyMassSpecific h_gas(start=h_gas_start) "Specific enthalpy of vapour phase";
  Real drho_liqdt;
  Real drho_gasdt;
  //(unit="kg/(m3s)");
  ClaRa.Basics.Units.Volume volume_liq(start=geo.volume*level_rel_start) "Liquid volume";
  ClaRa.Basics.Units.Volume volume_gas(start=geo.volume*level_rel_start) "Vapour volume";

  ClaRa.Basics.Units.HeatFlowRate Q_flow_phases "Heat flow between phases";

//  ClaRa.Basics.Units.MassFlowRate m_flow_in;
 // ClaRa.Basics.Units.MassFlowRate m_flow_out;

  ClaRa.Basics.Units.Mass mass_liq "Liquid mass";
  ClaRa.Basics.Units.Mass mass_gas "Vapour mass";
  inner ClaRa.Basics.Units.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";
  ClaRa.Basics.Units.MassFraction xi_gas[gasType.nc - 1](start=xi_start) "Gas mass fractions";
  ClaRa.Basics.Units.MassFraction xi_liq[medium.nc - 1] "Liquid mass fractions";
  ClaRa.Basics.Units.Length level_abs;
  ClaRa.Basics.Units.Area A_hor_act "Actual horizontal surface size";
  Real level_rel(start = level_rel_start);
  parameter Real   level_rel_start=0.5 "Initial value for relative level"
    annotation (Dialog(tab="Initialisation"));
  ClaRa.Basics.Units.PressureDifference Delta_p_geo_in[geo.N_inlet];
  ClaRa.Basics.Units.PressureDifference Delta_p_geo_out[geo.N_outlet];

  ClaRa.Basics.Interfaces.FluidPortIn inlet[geo.N_inlet](each Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet[geo.N_outlet](each Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat annotation (
      Placement(transformation(extent={{84,86},{104,106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,98})));

  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidIn[geo.N_inlet](
    each vleFluidType=medium,
    final p=inlet.p,
    final h=h_in) annotation (Placement(transformation(extent={{-90,-10},{-70,10}}, rotation=0)));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOut[geo.N_outlet](
    each vleFluidType=medium,
    final p=outlet.p,
    final h=h_out) annotation (Placement(transformation(extent={{70,-10},{90,10}}, rotation=0)));

  HeatTransfer heattransfer(final heatSurfaceAlloc=heatSurfaceAlloc)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  inner Geometry geo
    annotation (Placement(transformation(extent={{-48,60},{-28,80}})));

  PressureLoss pressureLoss
    annotation (Placement(transformation(extent={{12,60},{32,80}})));

  Summary summary(
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=inlet[1].m_flow,
      T=fluidIn[1].T,
      p=inlet[1].p,
      h=fluidIn[1].h,
      s=fluidIn[1].s,
      steamQuality=fluidIn[1].q,
      H_flow=fluidIn[1].h*inlet[1].m_flow,
      rho=fluidIn[1].d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet[1].m_flow,
      T=fluidOut[1].T,
      p=outlet[1].p,
      h=fluidOut[1].h,
      s=fluidOut[1].s,
      steamQuality=fluidOut[1].q,
      H_flow=-fluidOut[1].h*outlet[1].m_flow,
      rho=fluidOut[1].d),
    vent(
      mediumModel=gasType,
      m_flow=vent.m_flow,
      T=ventIn.T,
      p=vent.p,
      h=ventIn.h,
      H_flow=ventIn.h*vent.m_flow,
      xi=ventIn.xi),
    fluid(
      showExpertSummary=showExpertSummary,
      mass={mass_liq,mass_gas},
      p={p,p},
      h=iCom.h,
      h_bub={liq.VLE.h_l,-1},
      h_dew={liq.VLE.h_v,-1},
      T=iCom.T,
      T_sat={liq.VLE.T_l,-1},
      s={liq.s,gas.s},
      steamQuality={liq.q,if gasType.condensingIndex == 0 then Modelica.Constants.eps else gas.xi_gas/max(gas.xi[gasType.condensingIndex], Modelica.Constants.eps)},
      H=iCom.h .* {mass_liq,mass_gas},
      rho={liq.d,gas.d},
      final N_cv=2),
    outline(
      showExpertSummary=showExpertSummary,
      volume_tot=geo.volume,
      volume={volume_liq,volume_gas},
      A_heat=geo.A_heat[heatSurfaceAlloc]*{volume_liq,volume_gas}/geo.volume,
      A_heat_tot=geo.A_heat[heatSurfaceAlloc],
      level_abs=level_abs,
      level_rel=level_rel,
      Delta_p=inlet[1].p - outlet[1].p,
      fluidMass=mass_gas + mass_liq,
      H_tot=h_liq*mass_liq + h_gas*mass_gas,
      Q_flow_tot=heat.Q_flow,
      Q_flow=heattransfer.heat.Q_flow)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

protected
  inner TILMedia.Gas.Gas_ph gas(
    gasType=gasType,
    p=p,
    h=h_gas,
    computeTransportProperties=true,
    xi=xi_gas) annotation (Placement(transformation(extent={{-10,8},{10,28}}, rotation=0)));
  inner TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph liq(
    vleFluidType=medium,
    h=h_liq,
    computeTransportProperties=true,
    computeVLETransportProperties=true,
    p=p) annotation (Placement(transformation(extent={{-10,-20},{10,0}}, rotation=0)));
  inner ICom     iCom(
    p_in=inlet.p,
    p_out=outlet.p,
    h={h_liq,h_gas},
    T_in=fluidIn.T,
    T_out=fluidOut.T,
    N_cv=2,
    m_flow_nom=m_flow_nom,
    N_inlet=geo.N_inlet,
    N_outlet=geo.N_outlet,
    volume={volume_liq,volume_gas},
    m_flow_in=inlet.m_flow,
    m_flow_out=outlet.m_flow,
    T={liq.T,gas.T},
    p={p,p}) "Internal communication record"
    annotation (Placement(transformation(extent={{-80,-102},{-60,-82}})));
public
  ClaRa.Basics.Interfaces.GasPortIn vent(Medium=gasType)
    annotation (Placement(transformation(extent={{-110,28},{-90,48}})));
public
  TILMedia.Gas.Gas_pT ventIn(
    gasType=gasType,
    p=p,
    computeTransportProperties=true,
    T=noEvent(actualStream(vent.T_outflow)),
    xi=noEvent(actualStream(vent.xi_outflow)))
    annotation (Placement(transformation(extent={{-90,26},{-70,46}}, rotation=0)));
equation

  //_____________________________________________________
  //_______Asserts_______________________________________
  assert(geo.volume > 0, "The system volume must be greater than zero!");
  assert(geo.A_heat[heatSurfaceAlloc] >= 0, "The area of heat transfer must be greater than zero!");
  assert(level_abs < max(max(geo.z_in), max(geo.z_out)), "Air in water flanges");

  //_____________________________________________________
  //_______System definition_____________________________
  mass_liq = if useHomotopy then homotopy(volume_liq*liq.d, volume_liq*
    rho_liq_nom) else volume_liq*liq.d;
  mass_gas = if useHomotopy then homotopy(volume_gas*gas.d, volume_gas*
    rho_gas_nom) else volume_gas*gas.d;
  drho_liqdt = der(p)*liq.drhodp_hxi + der(h_liq)*liq.drhodh_pxi;
  //calculating drhodt from state variables
  drho_gasdt = der(p)*gas.drhodp_hxi + der(h_gas)*gas.drhodh_pxi + sum(der(xi_gas).*gas.drhodxi_ph);
  //calculating drhodt from state variables
  volume_liq = geo.volume - volume_gas;

  //_____________________________________________________
  //_______Mass Balances_________________________________
  drho_liqdt*volume_liq = -liq.d*der(volume_liq) + sum(inlet.m_flow)
     + sum(outlet.m_flow) "Liquid mass balance";
  drho_gasdt*volume_gas = -gas.d*der(volume_gas) + vent.m_flow "Gas mass balance";

  //_____________________________________________________
  //______Species Balance________________________________
  der(xi_gas) = noEvent(if mass_gas >1e-6 then (ventIn.xi*vent.m_flow - xi_gas*gas.d*der(volume_gas) - xi_gas*volume_gas*drho_gasdt)/mass_gas else zeros(gasType.nc-1));
// der(xi_gas) = zeros(gasType.nc-1);//
  for i in 1:medium.nc-1 loop
    der(xi_liq[i]) = noEvent( if mass_liq >1e-6 then (sum(inlet.m_flow.*xi_in[:,i]) + sum(outlet.m_flow.*xi_out[:,i])
        - xi_liq[i]*volume_liq*drho_liqdt
        - liq.d*xi_liq[i]*der(volume_liq))/mass_liq else 0);
  end for;
  //_____________________________________________________
  //______Energy Balances________________________________
  der(h_liq) = noEvent(if mass_liq > 1e-6 then (sum(inlet.m_flow.*h_in) + sum(outlet.m_flow.*h_out)
      + volume_liq*der(p) + p*der(volume_liq) - h_liq*volume_liq*drho_liqdt -
     liq.d*h_liq*der(volume_liq) + Q_flow_phases + heattransfer.heat[1].Q_flow)/
     mass_liq else der(h_gas));

   der(h_gas) = noEvent(if mass_gas > 1e-6 then (vent.m_flow*ventIn.h + volume_gas*der(p) + p*der(volume_gas) - h_gas*volume_gas*drho_gasdt - gas.d*h_gas*der(volume_gas) - Q_flow_phases + heattransfer.heat[2].Q_flow)/mass_gas else der(h_liq));

 // der(h_gas) = (vent.m_flow*ventIn.h + volume_gas*der(p) + p*der(volume_gas) - h_gas*volume_gas*drho_gasdt - gas.d*h_gas*der(volume_gas) - Q_flow_phases + heattransfer.heat[2].Q_flow)/mass_gas;
  //____________________________________________________
  //______Coupling of the Phases________________________
  Q_flow_phases = noEvent(alpha_ph*A_heat_ph*(gas.T - liq.T));

  //____________________________________________________
  //______Boundary Conditions___________________________

  inlet.h_outflow = ones(geo.N_inlet)*h_liq;
  outlet.h_outflow = ones(geo.N_outlet)*h_liq;
  vent.T_outflow=gas.T;

  for i in 1:geo.N_inlet loop
    h_in[i] = if useHomotopy then homotopy(noEvent(actualStream(inlet[i].h_outflow)), noEvent(inStream(inlet[i].h_outflow))) else noEvent(actualStream(inlet[i].h_outflow));
    xi_in[i,:] = if useHomotopy then homotopy(noEvent(actualStream(inlet[i].xi_outflow)), noEvent(inStream(inlet[i].xi_outflow))) else noEvent(actualStream(inlet[i].xi_outflow));
  end for;
  for i in 1:geo.N_outlet loop
    h_out[i] = if useHomotopy then homotopy(noEvent(actualStream(outlet[i].h_outflow)), h_liq) else noEvent(actualStream(outlet[i].h_outflow));
    xi_out[i,:] = if useHomotopy then homotopy(noEvent(actualStream(outlet[i].xi_outflow)), xi_liq) else noEvent(actualStream(outlet[i].xi_outflow));
  end for;

  for i in 1:geo.N_inlet loop
    inlet[i].p = p + pressureLoss.Delta_p[i] + Delta_p_geo_in[i];
  end for;
  for i in 1:geo.N_outlet loop
    outlet[i].p = p + Delta_p_geo_out[i] "The friction term is lumped at the inlet side to avoid direct coupling of two flow models, this avoids aniteration of mass flow rates in some application cases";
  end for;
  vent.p=p;
  vent.xi_outflow = xi_gas;

//_________________________Calculation of the Level______________________________
     A_hor_act = geo.A_hor*table.y[1];
     table.u[1] = level_rel;

     level_abs = min(geo.height_fill, max(level_abs_min, iCom.volume[1]/(A_hor_act)));
     level_rel = level_abs/geo.height_fill;

//__________________Calculation of the geostatic pressure differences_______________
  Delta_p_geo_in ={(level_abs - geo.z_in[i])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_in[i] then liq.d else gas.d) for i in 1:geo.N_inlet};
  Delta_p_geo_out ={(level_abs - geo.z_out[i])*Modelica.Constants.g_n*noEvent(if level_abs > geo.z_out[i] then liq.d else gas.d) for i in 1:geo.N_outlet};

  //___________________________________________________
  //______Initial Equations____________________________
initial equation
   if initType == "Steady state in p, h_liq, T_gas" then
     der(h_liq) = 0;
     der(h_gas) = 0;
     der(p) = 0;
     der(volume_gas) = 0;

   elseif initType == "Steady state in p" then
     der(p) = 0;
   elseif initType == "Steady state in h_liq and T_gas" then
     der(h_liq) = 0;
     der(h_gas) = 0;

   elseif initType == "Fixed value for filling level" then
     level_rel = level_rel_start;
   elseif initType == "Fixed values for filling level, p, h_liq, T_gas" then
    level_rel = level_rel_start;
    h_liq = h_liq_start;
    h_gas = h_gas_start;
    p = p_start;
    xi_gas=xi_start;
   else
     assert(false, "Unknown initialisation option in "+ getInstanceName());
   end if;



equation
  connect(heattransfer.heat[1], heat) annotation (Line(
      points={{-60,70},{-54,70},{-54,96},{94,96}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heattransfer.heat[2], heat) annotation (Line(
      points={{-60,70},{-52,70},{-52,96},{94,96}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics),
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
</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end VolumeVLEGas_L3;
