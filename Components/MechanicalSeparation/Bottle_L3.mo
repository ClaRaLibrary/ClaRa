within ClaRa.Components.MechanicalSeparation;
model Bottle_L3 "A bottle"
  extends ClaRa.Basics.Icons.Bottle;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  outer ClaRa.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid
                                      medium=simCenter.fluid1 "Medium in the component"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model material = TILMedia.SolidTypes.TILMedia_Steel constrainedby TILMedia.SolidTypes.BaseSolid "Material of the walls" annotation (Dialog(group="Fundamental Definitions"),choicesAllMatching);
  parameter Boolean includeInsulation=false  "True, if insulation is included" annotation(Dialog(group="Fundamental Definitions"));
  replaceable model insulationMaterial =Basics.Media.Solids.InsulationOrstechLSP_H_const
                                                                             constrainedby TILMedia.SolidTypes.BaseSolid "Insulation material" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions", enable=(includeInsulation==true)));

  parameter Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity of the wall" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length diameter_i=0.5 "Diameter of the component" annotation (Dialog(group="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/Bottle.png"));
  parameter ClaRa.Basics.Units.Length length=30 "Length of the component" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length thickness_wall=diameter_i*0.01/2 "Thickness of the cylinder wall" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length thickness_insulation=0.02 "Thickness of the insulation" annotation (Dialog(group="Geometry", enable=includeInsulation));

  parameter ClaRa.Basics.Units.Length radius_flange=0.05 "Flange radius" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_ins[4]={0.1,0.1,0.1,0.1} "Position of riser flange" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_outs[4]={0.1,0.1,0.1,0.1} "Position of downcomer flange" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Mass of internal structure addtional to bottle wall" annotation (Dialog(group="Geometry"));
  parameter Basics.Units.Time Tau_cond=0.01 "Time constant of condensation" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Basics.Units.Time Tau_evap=Tau_cond*1000 "Time constant of evaporation" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Real absorbInflow=1 "Absorption of incoming mass flow to the zones 1: perfect in the allocated zone, 0: perfect according to steam quality"
                                                                                              annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Basics.Units.Area A_phaseBorder=volume.geo.A_hor*100 "Heat transfer area at phase border" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Basics.Units.CoefficientOfHeatTransfer alpha_ph=500 "HTC of the phase border" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Real expHT_phases=0 "Exponent for volume dependency on inter phase HT" annotation (Dialog(tab="Phase Separation", group="Heat Transfer Between Phases"));
  parameter Boolean equalPressures=true "True if pressure in liquid and vapour phase is equal" annotation (Dialog(tab="Phase Separation", group="Mass Transfer Between Phases"));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation for calculation of filling level" annotation(Dialog(tab="Phase Separation", group="Numerical Robustness"));

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation", group="Volume"));

  parameter Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(medium, volume.p_start) "Start value of liquid specific enthalpy" annotation (Dialog(tab="Initialisation", group="Volume"));
  parameter Basics.Units.EnthalpyMassSpecific h_vap_start=+10 + TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.dewSpecificEnthalpy_pxi(medium, volume.p_start) "Start value of vapour specific enthalpy" annotation (Dialog(tab="Initialisation", group="Volume"));
  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "Start value of sytsem pressure" annotation (Dialog(tab="Initialisation", group="Volume"));
  parameter Real level_rel_start = 0.5 "Initial filling level" annotation(Dialog(tab="Initialisation", group="Volume"));
  inner parameter Integer initOption = 211 "Type of initialisation"
    annotation (Dialog(tab= "Initialisation", group = "Volume"), choices(choice = 0 "Use guess values", choice = 209 "Steady in vapour pressure, enthalpies and vapour volume", choice=201 "Steady vapour pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed volume fraction",  choice=211 "Fixed values in level, enthalpies and vapour pressure"));

  parameter Modelica.Units.SI.Temperature T_wall_start[wall.N_rad]=ones(wall.N_rad)*293.15 "Start values of wall temperature inner --> outer" annotation (Dialog(tab="Initialisation", group="Wall"));
  parameter Integer initOptionWall=213 "Initialisation option for wall" annotation(Dialog(tab="Initialisation", group="Wall"),choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));
  parameter Integer initOptionInsulation=213 "Type of initialisation" annotation (Dialog(tab="Initialisation",group="Insulation", enable=includeInsulation), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));
  parameter ClaRa.Basics.Units.Temperature T_startInsulation=293.15 "Start values of wall temperature" annotation (Dialog(
      tab="Initialisation",
      group="Insulation",
      enable=includeInsulation));

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "Pressure loss model"
                          annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 ( alpha_nom={3000,3000}) constrainedby Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L3 "Heat transfer to the walls" annotation (Dialog(group="Fundamental Definitions"),choicesAllMatching=true);
  parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=10 "Nominal mass flow rate at riser inlet" annotation (Dialog(group="Nominal Values"));

  parameter Boolean enableAmbientLosses=false "Include heat losses to environment" annotation(Dialog(tab="Heat Losses"));
  input ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_prescribed=8 "Prescribed heat transfer coefficient" annotation (Dialog(tab="Heat Losses", enable=(enableAmbientLosses == true)));
  input ClaRa.Basics.Units.Temperature T_amb=simCenter.T_amb "Temperature of surrounding medium" annotation (Dialog(tab="Heat Losses", enable=(enableAmbientLosses == true)));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if expert summary should be applied" annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showLevel = true "True, if level shall be visualised"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean levelOutput = false "True, if Real level connector shall be addded"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean outputAbs = false "True, if absolute level is at output"  annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));


 model Outline
   extends ClaRa.Basics.Icons.RecordIcon;
    input Basics.Units.Length level_abs "Absolute filling level";
   input Real level_rel "relative filling level";
    input ClaRa.Basics.Units.HeatFlowRate Q_loss "Heat flow rate from metal wall to insulation/ambient";
 end Outline;

 model Wall
   extends ClaRa.Basics.Icons.RecordIcon;
    input Basics.Units.Temperature T_wall[3] "Temperatures";
 end Wall;

 model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Outline outline;
   Wall wall;
    //   Wall insulation if includeInsulation;

 end Summary;

  Summary summary(
    outline(
      level_abs=volume.phaseBorder.level_abs,
      level_rel=volume.phaseBorder.level_rel,
      Q_loss=wall.outerPhase.Q_flow),
    wall(T_wall=wall.T))
      annotation (Placement(transformation(extent={{100,-104},{80,-84}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLE_L3_TwoZonesNPort volume(
    medium=medium,
    redeclare model PressureLoss = PressureLoss,
    useHomotopy=useHomotopy,
    p_nom=p_nom,
    p_start=p_start,
    level_rel_start=level_rel_start,
    Tau_cond=Tau_cond,
    showExpertSummary=showExpertSummary,
    Tau_evap=Tau_evap,
    alpha_ph=500,
    h_liq_start=h_liq_start,
    h_vap_start=h_vap_start,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.RealSeparated (
        level_rel_start=level_rel_start,
        radius_flange=radius_flange,
        absorbInflow=absorbInflow,
        smoothness=smoothness),
    A_heat_ph=A_phaseBorder,
    exp_HT_phases=expHT_phases,
    redeclare model HeatTransfer = HeatTransfer,
    initOption=initOption,
    m_flow_nom=m_flow_nom,
    redeclare model Geometry = Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=Modelica.Constants.pi/4*diameter_i^2*length,
        N_heat=1,
        A_heat={Modelica.Constants.pi*diameter_i*length},
        N_outlet=4,
        N_inlet=4,
        A_cross=Modelica.Constants.pi/4*diameter_i^2,
        final A_front=Modelica.Constants.pi/4*diameter_i^2,
        final A_hor=Modelica.Constants.pi/4*diameter_i^2,
        z_in=z_ins,
        z_out=z_outs,
        height_fill=length,
        shape=[0,1; 1,1])) annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    sizefunc=+1,
    N_tubes=1,
    length=length,
    N_rad=3,
    diameter_i=diameter_i,
    redeclare replaceable model Material = material,
    diameter_o=diameter_i + 2*thickness_wall,
    CF_lambda=CF_lambda,
    T_start=T_wall_start,
    initOption=initOptionWall,
    mass_struc=mass_struc + 2*diameter_i^2/4*Modelica.Constants.pi*thickness_wall*wall.solid[1].d) annotation (Placement(transformation(extent={{-10,28},{10,48}})));


  Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(N=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,8})));

  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then summary.outline.level_abs else summary.outline.level_rel if levelOutput annotation (Placement(transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent={{100,-70},{120,-50}})));

  Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 insulation(
    redeclare model Material = insulationMaterial,
    diameter_o=diameter_i + 2*thickness_wall + 2*thickness_insulation,
    diameter_i=diameter_i + 2*thickness_wall,
    length=length,
    N_tubes=1,
    N_ax=1,
    stateLocation=2,
    initOption=initOptionInsulation,
    T_start=T_startInsulation*ones(1)) if includeInsulation annotation (Placement(transformation(extent={{-10,56},{10,64}})));
  Modelica.Blocks.Sources.RealExpression heatFlowRatePrescribedAlpha(y=if includeInsulation then -alpha_prescribed*(length*Modelica.Constants.pi*(diameter_i + 2*thickness_wall + 2*thickness_insulation) + Modelica.Constants.pi*(diameter_i + 2*thickness_wall + 2*thickness_insulation)^2/4*2)*(prescribedHeatFlow.port[1].T - T_amb) else -alpha_prescribed*(length*Modelica.Constants.pi*(diameter_i + 2*thickness_wall) + Modelica.Constants.pi*(diameter_i + 2*thickness_wall)^2/4*2)*(prescribedHeatFlow.port[1].T - T_amb))
                                                 annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,120})));
  BoundaryConditions.PrescribedHeatFlow  prescribedHeatFlow(
    length=length,
    N_axial=1,
    Delta_x=ClaRa.Basics.Functions.GenerateGrid(
        {0},
        length,
        1))                                      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,92})));


  Basics.Interfaces.FluidPortIn inlet_1(Medium=medium) "Inlet 1"     annotation (Placement(transformation(extent={{-110,310},{-90,330}}), iconTransformation(extent={{-110,310},{-90,330}})));
  Basics.Interfaces.FluidPortIn inlet_2(Medium=medium) "Inlet 2"     annotation (Placement(transformation(extent={{-110,230},{-90,250}}), iconTransformation(extent={{-110,230},{-90,250}})));
  Basics.Interfaces.FluidPortIn inlet_3(Medium=medium) "Inlet 3"     annotation (Placement(transformation(extent={{-110,150},{-90,170}}), iconTransformation(extent={{-110,150},{-90,170}})));
  Basics.Interfaces.FluidPortIn inlet_4(Medium=medium) "Inlet 4"     annotation (Placement(transformation(extent={{-110,70},{-90,90}}), iconTransformation(extent={{-110,70},{-90,90}})));
  Basics.Interfaces.FluidPortOut outlet_1(Medium=medium) "Outlet 1" annotation (Placement(transformation(extent={{-10,490},{10,510}}), iconTransformation(extent={{-10,490},{10,510}})));
  Basics.Interfaces.FluidPortOut outlet_2(Medium=medium) "Outlet 2" annotation (Placement(transformation(extent={{90,310},{110,330}}), iconTransformation(extent={{90,310},{110,330}})));
  Basics.Interfaces.FluidPortOut outlet_3(Medium=medium) "Outlet 3" annotation (Placement(transformation(extent={{90,70},{110,90}}), iconTransformation(extent={{90,70},{110,90}})));
  Basics.Interfaces.FluidPortOut outlet_4(Medium=medium) "Outlet 4" annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));
equation
  connect(volume.heat, scalar2VectorHeatPort.heatVector) annotation (Line(
      points={{0,-10},{0,-2}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort.heatScalar, wall.innerPhase) annotation (Line(
      points={{0,18},{0,28.4},{-0.2,28.4}},
      color={167,25,48},
      thickness=0.5));
  connect(inlet_1, volume.inlet[1]) annotation (Line(
      points={{-100,320},{-20,320},{-20,-20},{-10,-20}},
      color={0,131,169},
      thickness=0.5));
  connect(inlet_2, volume.inlet[2]) annotation (Line(
      points={{-100,240},{-20,240},{-20,-20},{-10,-20}},
      color={0,131,169},
      thickness=0.5));
  connect(inlet_3, volume.inlet[3]) annotation (Line(
      points={{-100,160},{-20,160},{-20,-20},{-10,-20}},
      color={0,131,169},
      thickness=0.5));
  connect(inlet_4, volume.inlet[4]) annotation (Line(
      points={{-100,80},{-20,80},{-20,-20},{-10,-20}},
      color={0,131,169},
      thickness=0.5));
  connect(outlet_1, volume.outlet[1]) annotation (Line(
      points={{0,500},{20,500},{20,-20},{10,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(outlet_2, volume.outlet[2]) annotation (Line(
      points={{100,320},{20,320},{20,-20},{10,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(outlet_3, volume.outlet[3]) annotation (Line(
      points={{100,80},{20,80},{20,-20},{10,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(outlet_4, volume.outlet[4]) annotation (Line(
      points={{0,-100},{20,-100},{20,-20},{10,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
    if includeInsulation then
      connect(wall.outerPhase,insulation.innerPhase[1]);
      if enableAmbientLosses then
         connect(insulation.outerPhase[1],prescribedHeatFlow.port[1]);
         //connect(heatFlowRatePrescribedAlpha.y, prescribedHeatFlow.Q_flow);
      end if;
    else
      if enableAmbientLosses then
         connect(wall.outerPhase,prescribedHeatFlow.port[1]);
         //connect(heatFlowRatePrescribedAlpha.y, prescribedHeatFlow.Q_flow);
      end if;
    end if;
  connect(heatFlowRatePrescribedAlpha.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-1.9984e-15,109},{-1.9984e-15,105.5},{1.88738e-15,105.5},{1.88738e-15,102}}, color={0,0,127}));
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
   Icon(graphics={   Rectangle(extent={{20,492},{35,-92}},
                               lineColor={27,36,42},
                               fillColor={153,205,221},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel),
                     Rectangle(extent=DynamicSelect({{20,200},{35,-92}}, {{20,summary.outline.level_rel*584-92},{35,-92}}),
                               lineColor={27,36,42},
                               fillColor={0,131,169},
                               fillPattern=FillPattern.Solid,
                               visible=showLevel)}, coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,500}})),
                                                                Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,500}})));
end Bottle_L3;
