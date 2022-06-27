within ClaRa.Components.VolumesValvesFittings.Valves;
model ThreeWayValveVLE_L2 "A voluminous three way valve for VLE media"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2022, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//
  import SI = ClaRa.Basics.Units;
  extends ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValve_base;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");

  outer ClaRa.SimCenter simCenter;
model Outline
  extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Volume volume_tot "Total volume";
end Outline;

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet;
  ClaRa.Basics.Records.FlangeVLE           outlet1;
  ClaRa.Basics.Records.FlangeVLE           outlet2;
  ClaRa.Basics.Records.FluidVLE_L2           fluid;
end Summary;

  replaceable model PressureLoss =
      ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.IdealSymetric_TWV                      constrainedby ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.TWV_L2 "Pressure loss model"
                                                                                            annotation(choicesAllMatching);

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                               annotation(Dialog(group="Fundamental Definitions"));

  parameter Boolean splitRatio_input=false "= true, if split ratio is defined by input"
                                                 annotation(Dialog(group="Fundamental Definitions"));
  parameter Real splitRatio_fixed = 0.5 annotation(Dialog(enable=not splitRatio_input, group= "Fundamental Definitions"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
  parameter Basics.Units.Volume volume(min=1e-6) = 0.1 "System Volume" annotation (Dialog(tab="General", group="Geometry"));
  parameter Basics.Units.MassFlowRate m_flowOut_nom[2]={10,10} "Nominal mass flow rates at outlet" annotation (Dialog(tab="General", group="Nominal Values"));
  parameter Basics.Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter Basics.Units.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy" annotation (Dialog(group="Nominal Values"));

  parameter Basics.Units.EnthalpyMassSpecific h_start=1e5 "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter Basics.Units.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation"));
  inner parameter Integer  initOption=0 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed rel.level (for phaseBorder = idealSeparated only)",  choice=205 "Fixed rel.level and steady pressure (for phaseBorder = idealSeparated only)"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean preciseTwoPhase = true "|Expert Settings||True, if two-phase transients should be capured precisely";

protected
  parameter Basics.Units.DensityMassSpecific rho_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      medium,
      p_nom,
      h_nom) "Nominal density";
  Basics.Units.Power Hdrhodt=if preciseTwoPhase then h*volume*drhodt else 0 "h*V*drhodt";
public
  Real splitRatio;
  Basics.Units.EnthalpyFlowRate H_flow_in;
  Basics.Units.EnthalpyFlowRate H_flow_out[2];
  Basics.Units.EnthalpyMassSpecific h(start=h_start);
  Basics.Units.Mass mass "Total system mass";
  Real drhodt;//(unit="kg/(m3s)");
  Basics.Units.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";

public
   Summary summary(outline(volume_tot = volume),
                   inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h*inlet.m_flow, rho=fluidIn.d),
                   fluid(showExpertSummary = showExpertSummary, mass=mass, p=p, h=h, T=bulk.T,s=bulk.s, steamQuality=bulk.q, H=h*mass, rho=bulk.d, T_sat=bulk.VLE.T_l, h_dew=bulk.VLE.h_v, h_bub=bulk.VLE.h_l),
                   outlet1(showExpertSummary = showExpertSummary,m_flow = -outlet1.m_flow, T=fluidOut1.T, p=outlet1.p, h=fluidOut1.h, s=fluidOut1.s, steamQuality=fluidOut1.q, H_flow=-fluidOut1.h*outlet1.m_flow, rho=fluidOut1.d),
                   outlet2(showExpertSummary = showExpertSummary,m_flow = -outlet2.m_flow, T=fluidOut2.T, p=outlet2.p, h=fluidOut2.h, s=fluidOut2.s, steamQuality=fluidOut2.q, H_flow=-fluidOut2.h*outlet2.m_flow, rho=fluidOut2.d))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph bulk(each vleFluidType = medium, p = p,h=h) annotation (Placement(transformation(extent={{-10,-12},
            {10,8}},rotation=0)));

  inner ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom_TWV iCom(
    p_in=fluidIn.p,
    p_out1=fluidOut1.p,
    p_out2=fluidOut2.p,
    rho_out1=fluidOut1.d,
    rho_out2=fluidOut2.d,
    opening_=splitRatio,
    m_flow_in=inlet.m_flow,
    rho_in=fluidIn.d)      annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
PressureLoss pressureLoss annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(volume>0, "The system volume must be greater than zero!");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~

// System definition ~~~~~~~~
   mass= if useHomotopy then volume*homotopy(bulk.d,rho_nom) else volume*bulk.d;

   drhodt*volume=inlet.m_flow + outlet1.m_flow + outlet2.m_flow "Mass balance";
   drhodt=der(p)*bulk.drhodp_hxi
                             + der(h)*bulk.drhodh_pxi;
                                                   //calculating drhodt from state variables

   der(h) = 1/mass*(sum(H_flow_out) + H_flow_in  + volume*der(p) -Hdrhodt) "Energy balance, decoupled from the mass balance to avoid heavy mass fluctuations during phase change or flow reversal. The term '-h*V*drhodt' is ommited";
//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~

    H_flow_out[1]=if useHomotopy then homotopy(actualStream(outlet1.h_outflow)*outlet1.m_flow, -h*m_flowOut_nom[1]) else actualStream(outlet1.h_outflow)*outlet1.m_flow;
    H_flow_out[2]=if useHomotopy then homotopy(actualStream(outlet2.h_outflow)*outlet2.m_flow, -h*m_flowOut_nom[2]) else actualStream(outlet2.h_outflow)*outlet2.m_flow;
    outlet1.m_flow=-pressureLoss.m_flow_1;
    outlet1.h_outflow=h;
    outlet2.m_flow=-pressureLoss.m_flow_2;
    outlet2.h_outflow=h;

    H_flow_in= if useHomotopy then homotopy(actualStream(inlet.h_outflow)*inlet.m_flow, inStream(inlet.h_outflow)*sum(m_flowOut_nom)) else actualStream(inlet.h_outflow)*inlet.m_flow;
    inlet.p=p;
    inlet.h_outflow=h;

initial equation
  if initOption == 208 then
    der(h)=0;
    der(p)=0;
  elseif initOption == 201 then
    der(p)=0;
  elseif initOption == 202 then
    der(h)=0;
  elseif initOption == 0 then //no init
    // do nothing
  else
    assert(false, "Unknown initialisation option in "+ getInstanceName());
  end if;

equation

  annotation (    Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2022.</p>
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),Diagram(graphics));
end ThreeWayValveVLE_L2;
