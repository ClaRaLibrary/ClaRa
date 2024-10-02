within ClaRa.Components.VolumesValvesFittings.Pipes;
model TubeBundle_L4H1 "Discretised tube bundle with scalar heat port"
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
  extends ClaRa.Basics.Icons.TubeWithWall_L4;
  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  replaceable model Material = Basics.Media.Solids.Steel16Mo3 constrainedby TILMedia.SolidTypes.BaseSolid  "FTW material" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean frictionAtInlet = false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet = false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4  "Pressure Loss Model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4 "Heat Transfer Model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model MechanicalEquilibrium = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.Homogeneous_L4 "Mechanic Model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  parameter Boolean isAdiabat = false "True if adiabat" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length length=47.5 "Length of the pipe (one pass)" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_o=57e-3 "Outer diameter" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_i=49e-3 "Inner diameter of the pipe" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in=104.58 "Height of inlet above ground" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out=98.83 "Height of outlet above ground" annotation (Dialog(group="Geometry"));
  parameter Integer N_tubes=1050 "Number Of parallel pipes" annotation (Dialog(group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the tubes" annotation (Dialog(group="Geometry"));
  parameter Integer N_cv=3 "Number of finite volumes" annotation (Dialog(group="Discretisation"));
  parameter ClaRa.Basics.Units.Length Delta_x[N_cv]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      pipeFlow.length*pipeFlow.N_passes,
      pipeFlow.N_cv) "Discretisation scheme" annotation (Dialog(group="Discretisation"));

  parameter ClaRa.Basics.Units.Pressure p_nom[N_cv]=ones(N_cv)*1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom[N_cv]=ones(N_cv)*1e5 "Nominal specific enthalpy for single tube" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=100 "Nominal mass flow w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.PressureDifference Delta_p_nom=1e4 "Nominal pressure loss w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));
  parameter Integer initOption=0 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 208 "Steady pressure and enthalpy", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start[N_cv]=ones(N_cv)*800e3 "Initial specific enthalpy for single tube" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start[N_cv]=ones(N_cv)*1e5 "Initial pressure" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=zeros(pipeFlow.medium.nc - 1) "Initial composition" annotation (Dialog(tab="Initialisation"));

  parameter Boolean showExpertSummary=pipeFlow.simCenter.showExpertSummary "True, if an extended summary shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=false "True, if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean contributeToCycleSummary=pipeFlow.simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss=true "True if negative heat flow is a loss (not a process product)" annotation (Dialog(tab="Summary and Visualisation"));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipeFlow(
    medium=medium,
    frictionAtInlet=frictionAtInlet,
    frictionAtOutlet=frictionAtOutlet,
    redeclare model PressureLoss = PressureLoss,
    redeclare model HeatTransfer = HeatTransfer,
    redeclare model MechanicalEquilibrium = MechanicalEquilibrium,
    p_nom=p_nom,
    h_nom=h_nom,
    m_flow_nom=m_flow_nom,
    Delta_p_nom=Delta_p_nom,
    initOption=initOption,
    h_start=h_start,
    p_start=p_start,
    xi_start=xi_start,
    showExpertSummary=showExpertSummary,
    showData=showData,
    length=length,
    diameter_i=diameter_i,
    z_in=z_in,
    z_out=z_out,
    N_tubes=N_tubes,
    N_passes=N_passes,
    N_cv=N_cv,
    Delta_x=Delta_x,
    contributeToCycleSummary=contributeToCycleSummary,
    heatFlowIsLoss=heatFlowIsLoss)
                  annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={0,40})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 pipeWall(
    redeclare model Material = Material,
    N_ax=N_cv,
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    length=length,
    N_tubes=N_tubes,
    T_start={TILMedia.VLEFluidFunctions.temperature_phxi(
        medium,
        p_start[i],
        h_start[i],
        xi_start) for i in 1:N_cv},
    stateLocation=if isAdiabat then 1 else 2)
                     annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={0,0})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort adapt(N=N_cv) if not isAdiabat
                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,-28})));

  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})));
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-150,-10},{-130,10}}), iconTransformation(extent={{-150,-10},{-130,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat if not isAdiabat
                                          annotation (Placement(transformation(extent={{-10,-70},{10,-50}}), iconTransformation(extent={{-10,-70},{10,-50}})));

  ClaRa.Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(extent={{140,35},{150,45}})));
equation
  connect(pipeFlow.heat, pipeWall.innerPhase) annotation (Line(
      points={{0,36},{0,5}},
      color={167,25,48},
      thickness=0.5));
  connect(pipeWall.outerPhase, adapt.heatVector) annotation (Line(
      points={{0,-5},{0,-18},{1.77636e-15,-18}},
      color={167,25,48},
      thickness=0.5));
  connect(pipeFlow.outlet, outlet) annotation (Line(
      points={{14,40},{56,40},{56,0},{140,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipeFlow.inlet, inlet) annotation (Line(
      points={{-14,40},{-58,40},{-58,0},{-140,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(adapt.heatScalar, heat) annotation (Line(
      points={{-1.77636e-15,-38},{-1.77636e-15,-50},{0,-50},{0,-60}},
      color={167,25,48},
      thickness=0.5));
  connect(pipeFlow.eye, eye) annotation (Line(points={{14.6,43.4},{66.3,43.4},{66.3,40},{145,40}}, color={190,190,190}));
  annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
<p>Friedrich Gottelt, Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH, Copyright &copy; 2019-2020</p>
<p><a href=\"http://www.fvtr.de\">www.fvtr.de</a>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH for industry projects in cooperation with Lausitz Energie Kraftwerke AG, Cottbus.</p>
<b>Acknowledgements:</b>
<p>This model contribution is sponsored by Lausitz Energie Kraftwerke AG.</p>

<p><a href=\"http://www.leag.de\">www.leag.de</a> </p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>", revisions="<html>
<body>
<table>
  <tr>
    <th style=\"text-align: left;\">Date</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Version</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Author</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Affiliation</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Changes</th>
  </tr>
  <tr>
    <td>2020-08-20</td>
    <td> </td>
    <td>ClaRa 1.6.0</td>
    <td> </td>
    <td>Friedrich Gottelt</td>
    <td> </td>
    <td>FVTR GmbH</td>
    <td> </td>
    <td>Initial version of model</td>
  </tr>
</table>
<p>Version means first ClaRa version where the applied change was published.</p>
</body>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-60},{140,60}}),
                                                            graphics={
        Polygon(
          points={{-133,30},{-113,30},{-113,-30},{-133,-30}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtInlet),
        Polygon(
          points={{133,30},{113,30},{113,-30},{133,-30}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtOutlet)}),Diagram(graphics,
                                              coordinateSystem(preserveAspectRatio=false, extent={{-140,-60},{140,60}})));
end TubeBundle_L4H1;
