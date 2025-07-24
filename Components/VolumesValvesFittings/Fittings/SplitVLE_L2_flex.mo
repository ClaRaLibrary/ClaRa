within ClaRa.Components.VolumesValvesFittings.Fittings;
model SplitVLE_L2_flex "A voluminous split for an arbitrary number of inputs NOT CAPABLE FOR PHASE-CHANGE"
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

 extends ClaRa.Basics.Interfaces.DataInterfaceVector(N_sets=N_ports_out);
  extends ClaRa.Basics.Icons.Adapter5_fw;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");

  outer ClaRa.SimCenter simCenter;

model Outline
  extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Volume volume_tot "Total volume";
end Outline;

model Summary
  parameter Integer N_ports_out;
  extends ClaRa.Basics.Icons.RecordIcon;
  Outline outline;
  ClaRa.Basics.Records.FlangeVLE           inlet;
  ClaRa.Basics.Records.FlangeVLE           outlet[N_ports_out];
  ClaRa.Basics.Records.FluidVLE_L2           fluid;
end Summary;

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (Dialog(group="Fundamental Definitions"));
  parameter Integer N_ports_out(min=1)=1 "Number of outlet  ports"
    annotation(Evaluate=true, Dialog(tab="General",group="Fundamental Definitions"));//connectorSizing=true,
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));
  parameter Modelica.Units.SI.Volume volume(min=1e-6) = 0.1 "System Volume" annotation (Dialog(tab="General", group="Geometry"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_out_nom[N_ports_out]={10} "Nominal mass flow rates at inlet" annotation (Dialog(tab="General", group="Nominal Values"));
  parameter Modelica.Units.SI.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy" annotation (Dialog(group="Nominal Values"));

  parameter Modelica.Units.SI.SpecificEnthalpy h_start=1e5 "Start value of sytsem specific enthalpy" annotation (Dialog(tab="Initialisation"));
  parameter Modelica.Units.SI.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=medium.xi_default annotation (Dialog(tab="Initialisation"));
  parameter Integer initOption=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 208 "Steady pressure and enthalpy", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));

    parameter Boolean showExpertSummary=false "True, if a summary shall be shown, else false"
                                                                                      annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean preciseTwoPhase = true "|Expert Stettings||True, if two-phase transients should be capured precisely";
protected
  parameter Modelica.Units.SI.Density rho_nom=TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi(
      medium,
      p_nom,
      h_nom) "Nominal density";
  Modelica.Units.SI.Power Hdrhodt=if preciseTwoPhase then h*volume*drhodt else 0 "h*V*drhodt";
  Real Xidrhodt[medium.nc-1]= if preciseTwoPhase then xi*volume*drhodt else zeros(medium.nc-1) "h*volume*drhodt";
public
  Modelica.Units.SI.EnthalpyFlowRate H_flow_in;
  Modelica.Units.SI.EnthalpyFlowRate H_flow_out[N_ports_out];
  Modelica.Units.SI.SpecificEnthalpy h(start=h_start);
  Modelica.Units.SI.Mass mass "Total system mass";
  Real drhodt;//(unit="kg/(m3s)");
  Modelica.Units.SI.Pressure p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";
  ClaRa.Basics.Units.MassFlowRate Xi_flow_in[medium.nc - 1] "Mass fraction flows at inlet";
  ClaRa.Basics.Units.MassFlowRate Xi_flow_out[N_ports_out,medium.nc - 1] "Mass fraction flows at outlet";
  ClaRa.Basics.Units.MassFraction xi[medium.nc - 1](start=xi_start) "Mass fraction";

   Summary summary(N_ports_out=N_ports_out,outline(volume_tot = volume),
                   inlet(showExpertSummary = showExpertSummary,m_flow=inlet.m_flow,  T=fluidIn.T, p=inlet.p, h=fluidIn.h,s=fluidIn.s, steamQuality=fluidIn.q, H_flow=fluidIn.h .* inlet.m_flow, rho=fluidIn.d),
                   fluid(showExpertSummary = showExpertSummary, mass=mass, p=p, h=h, T=bulk.T,s=bulk.s, steamQuality=bulk.q, H=h*mass, rho=bulk.d, T_sat=bulk.VLE.T_l, h_dew=bulk.VLE.h_v, h_bub=bulk.VLE.h_l),
                   outlet(each showExpertSummary = showExpertSummary,m_flow = -outlet.m_flow, T=fluidOut.T, p=outlet.p, h=fluidOut.h, s=fluidOut.s, steamQuality=fluidOut.q, H_flow=-fluidOut.h .* outlet.m_flow, rho=fluidOut.d))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet[N_ports_out](each Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph bulk(
    vleFluidType=medium,
    p=p,
    h=h) annotation (Placement(transformation(extent={{70,-10},{90,10}}, rotation=0)));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    p=inlet.p,
    h=noEvent(actualStream(inlet.h_outflow)))
    annotation (Placement(transformation(extent={{20,-32},{40,-12}}, rotation=0)));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid_ph fluidOut[N_ports_out](
    each vleFluidType=medium,
    p=outlet.p,
    h=noEvent(actualStream(outlet.h_outflow)))
    annotation (Placement(transformation(extent={{30,6},{50,26}}, rotation=0)));
equation
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Asserts ~~~~~~~~~~~~~~~~~~~
  assert(volume>0, "The system volume must be greater than zero!");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~
// System definition ~~~~~~~~
   mass= if useHomotopy then volume*homotopy(bulk.d,rho_nom) else volume*bulk.d;

   drhodt*volume=inlet.m_flow + sum(outlet.m_flow) "Mass balance";
   drhodt = der(p)*bulk.drhodp_hxi
          + der(h)*bulk.drhodh_pxi
          + sum(der(xi).*bulk.drhodxi_ph);
                                                   //calculating drhodt from state variables

   der(h) = 1/mass*(H_flow_in + sum(H_flow_out)  + volume*der(p) -Hdrhodt) "Energy balance, decoupled from the mass balance to avoid heavy mass fluctuations during phase change or flow reversal. The term '-h*V*drhodt' is ommited";
   der(xi) = {(sum(Xi_flow_out[:,i])+ Xi_flow_in[i]- Xidrhodt[i])/mass for i in 1:medium.nc-1}; //;

//~~~~~~~~~~~~~~~~~~~~~~~~~
// Boundary conditions ~~~~
  for i in 1:N_ports_out loop
    outlet[i].h_outflow=h;
    outlet[i].xi_outflow=xi;
    H_flow_out[i]=if useHomotopy then homotopy(actualStream(outlet[i].h_outflow)*outlet[i].m_flow, -h*m_flow_out_nom[i]) else actualStream(outlet[i].h_outflow)*outlet[i].m_flow;
    Xi_flow_out[i]=if useHomotopy then homotopy(actualStream(outlet[i].xi_outflow)*outlet[i].m_flow, -xi*m_flow_out_nom[i]) else actualStream(outlet[i].xi_outflow)*outlet[i].m_flow;

    outlet[i].p=p;
  end for;

    H_flow_in= if useHomotopy then homotopy(actualStream(inlet.h_outflow)*inlet.m_flow, inStream(inlet.h_outflow)*sum(m_flow_out_nom)) else actualStream(inlet.h_outflow)*inlet.m_flow;
    Xi_flow_in= if useHomotopy then homotopy(actualStream(inlet.xi_outflow)*inlet.m_flow, inStream(inlet.xi_outflow)*sum(m_flow_out_nom)) else actualStream(inlet.xi_outflow)*inlet.m_flow;

    inlet.p=p;
    inlet.h_outflow=h;
    inlet.xi_outflow=xi;
    for i in 1:N_ports_out loop
    eye[i].m_flow=-outlet[i].m_flow;
    eye[i].T= bulk.T-273.15;
    eye[i].s=bulk.s/1e3;
    eye[i].p=bulk.p/1e5;
    eye[i].h=h/1e3;
  end for;

initial equation
  if initOption == 208 then
    der(h)=0;
    der(p)=0;
  elseif initOption == 201 then
    der(p)=0;
  elseif initOption == 202 then
    der(h)=0;
  elseif initOption ==0 then
    // do nothing
  else
    assert(false, "Unknown initialisation type in " + getInstanceName());
  end if;

equation

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
 Icon(graphics), Diagram(graphics));
end SplitVLE_L2_flex;
