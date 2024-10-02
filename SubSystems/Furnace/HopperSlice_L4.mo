within ClaRa.SubSystems.Furnace;
model HopperSlice_L4 "Furnace slice of hopper with cooled walls"
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

  extends ClaRa.Basics.Icons.HopperSlice;
  import rad2deg = Modelica.Units.Conversions.from_deg;
  outer ClaRa.SimCenter simCenter;

  /// Furnace ///

  parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Fuel definition" annotation (choicesAllMatching, Dialog(group="Media Definitions"));
  parameter TILMedia.GasTypes.BaseGas flueGas=simCenter.flueGasModel "Flue gas model" annotation (choicesAllMatching, Dialog(group="Media Definitions", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HopperSketch.png"));
  parameter ClaRa.Basics.Media.Slag.PartialSlag slagType=simCenter.slagModel "Slag properties" annotation (choices(choice=simCenter.slagModel "Slag model 1 as defined in simCenter"),Dialog(group="Media Definitions"));

  replaceable model GasHeatTransfer_Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas "HT from Gas to FTW" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  replaceable model GasHeatTransfer_Top = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Gas_L2 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas "HT from Gas to top" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  replaceable model Burning_time = ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime
    constrainedby ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.PartialBurningTime "Model for the buring time"
                                annotation (Dialog(tab="Combustion Settings",group="Combustion"),choicesAllMatching=true);
  replaceable model ParticleMigration = ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.FixedMigrationSpeed_simple (w_fixed=10)
    constrainedby ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.PartialMigrationSpeed "Model for the particle migration speed"
                                             annotation (Dialog(tab="Combustion Settings",group="Combustion"), choicesAllMatching=true);
  replaceable model ReactionZone = ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone
     constrainedby ClaRa.Components.Furnace.ChemicalReactions.PartialReactionZone "Model to regard chemical reactions"
                                          annotation (Dialog(tab="Combustion Settings",group="Combustion"), choicesAllMatching=true);

  parameter ClaRa.Basics.Units.Length length_furnace=10 "Length of the component" annotation (Dialog(group="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HollowBlock.png"));
  parameter ClaRa.Basics.Units.Length width_furnace=length_furnace "Width of the component" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_furnace=0 "Height of inlet ports" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_furnace=1 "Height of outlet ports" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Choices.GeometryOrientation flowOrientation_furnace=ClaRa.Basics.Choices.GeometryOrientation.vertical "Orientation of shell side flow" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Pressure p_start_flueGas_out=1e5 "Start pressure at outlet" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Temperature T_start_flueGas_out=700 "Start temperature at outlet" annotation (Dialog(tab="Initialisation"));
  parameter Modelica.Units.SI.Temperature T_top_initial=hopper.T_start_flueGas_out "Initial temperature of top volume" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_flueGas_out[flueGas.nc - 1]=flueGas.xi_default "Start composition of flue gas" annotation (Dialog(tab="Initialisation"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nom_gas=1000 "Nominal mass flow rates at inlet" annotation (Dialog(group="Nominal Values"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_falseAir=6.5 "False air mass flow entering hopper" annotation (Dialog(group="False Air"));
  parameter Integer slagTemperature_calculationType=1 "Calculation type of outflowing slag temperature" annotation (Dialog(tab="Combustion Settings", group="Slag Definitions"), choices(
      choice=1 "Fixed slag temperature",
      choice=2 "Outlet flue gas temperature",
      choice=3 "Mean flue gas temperature",
      choice=4 "Inlet flue gas temperature"));
  parameter ClaRa.Basics.Units.Temperature T_slag=900 "Constant slag outlet temperature" annotation (Dialog(tab="Combustion Settings", group="Slag Definitions"));

// Finned Tube Walls (FTW)///
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_FTW = simCenter.fluid1 "FTW medium model" annotation (choicesAllMatching, Dialog(tab="Finned Tube Walls (FTW)", group="Fundamental Definitions", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/FinnedWallSketchHopper.png"));
  replaceable model Material_FTW = Basics.Media.Solids.Steel16Mo3 constrainedby TILMedia.SolidTypes.BaseSolid  "FTW material" annotation (choicesAllMatching, Dialog(tab="Finned Tube Walls (FTW)", group="Fundamental Definitions"));
  parameter Boolean frictionAtInlet_FTW = false "True if pressure loss at inlet" annotation (choices(checkBox=true), Dialog(tab="Finned Tube Walls (FTW)", group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet_FTW = false "True if pressure loss at outlet" annotation (choices(checkBox=true), Dialog(tab="Finned Tube Walls (FTW)", group="Fundamental Definitions"));
  replaceable model PressureLoss_FTW = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model HeatTransfer_FTW = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4 "Heat Transfer Model" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model MechanicalEquilibrium_FTW = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.Homogeneous_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4 "Mechanic flow model" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Fundamental Definitions"), choicesAllMatching=true);
  parameter Modelica.Units.NonSI.Angle_deg psi_FTW=23 "Inclination of pipes" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Geometry"));
  parameter ClaRa.Basics.Units.Length length_FTW=abs(z_out_furnace - z_in_furnace)/sin(rad2deg(psi_FTW)) "Length of the pipe" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_o_FTW=57e-3 "Outer diameter" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_i_FTW=49e-3 "Inner diameter of the pipe" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_FTW = z_in_furnace "Height of inlet above ground" annotation (Dialog(tab="Finned Tube Walls (FTW)", group = "Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_FTW = z_out_furnace "Height of outlet above ground" annotation (Dialog(tab="Finned Tube Walls (FTW)", group = "Geometry"));
  parameter Integer N_tubes_FTW=1050 "Number Of parallel pipes" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Geometry"));
  final parameter Integer N_passes_FTW=1 "Number of passes of the tubes" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Geometry"));
  parameter Integer N_cv_FTW=3 "Number of finite volumes" annotation (Dialog(tab="Finned Tube Walls (FTW)",group="Discretisation"));
  parameter ClaRa.Basics.Units.Length Delta_x_FTW[N_cv_FTW]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length_FTW*N_passes_FTW,
      N_cv_FTW) "Discretisation scheme" annotation (Dialog(tab="Finned Tube Walls (FTW)",group="Discretisation"));
  parameter Integer initOption_FTW=0 "Type of initialisation" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Initialisation"), choices(choice = 0 "Use guess values", choice = 208 "Steady pressure and enthalpy", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start_FTW[N_cv_FTW]=ones(N_cv_FTW)*800e3 "Initial specific enthalpy for single tube" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_FTW[N_cv_FTW]=ones(N_cv_FTW)*1e5 "Initial pressure" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_FTW[medium_FTW.nc - 1]=zeros(medium_FTW.nc - 1) "Initial composition" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Initialisation"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom_FTW[N_cv_FTW]=ones(N_cv_FTW)*1e5 "Nominal specific enthalpy for single tube" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Nominal Values"));
  parameter ClaRa.Basics.Units.Pressure p_nom_FTW[N_cv_FTW]=ones(N_cv_FTW)*1e5 "Nominal pressure" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom_FTW=100 "Nominal mass flow w.r.t. all parallel tubes" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Nominal Values"));
  parameter ClaRa.Basics.Units.PressureDifference Delta_p_nom_FTW=1e4 "Nominal pressure loss w.r.t. all parallel tubes" annotation (Dialog(tab="Finned Tube Walls (FTW)", group="Nominal Values"));

  ///Summary and Visualisation ///
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if an extended summary shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData= true "True if data connectors shall be shown" annotation (Dialog(tab="Summary and Visualisation"));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 wall_FTW(
    redeclare model Material = Material_FTW,
    N_ax=N_cv_FTW,
    Delta_x=Delta_x_FTW,
    diameter_o=diameter_o_FTW,
    diameter_i=diameter_i_FTW,
    length=length_FTW*N_passes_FTW,
    N_tubes=N_tubes_FTW,
    T_start={TILMedia.VLEFluidFunctions.temperature_phxi(
        pipeFlow_FTW.medium,
        p_start_FTW[i],
        h_start_FTW[i]) - 5 for i in 1:wall_FTW.N_ax},
    suppressChattering="False")
                     annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=270,
        origin={240,0})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort adapt_FTW(N=N_cv_FTW)
                                                                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={188,0})));

  ClaRa.Basics.Interfaces.FluidPortOut outlet_FTW(Medium=medium_FTW)
                                                                 "Outlet port"               annotation (Placement(transformation(extent={{270,90},{290,110}}), iconTransformation(extent={{270,90},{290,110}})));
  ClaRa.Basics.Interfaces.FluidPortIn inlet_FTW(Medium=medium_FTW)
                                                               "Inlet port"               annotation (Placement(transformation(extent={{72,-110},{92,-90}}),   iconTransformation(extent={{72,-110},{92,-90}})));
  ClaRa.Components.Furnace.Hopper.Hopper_L2 hopper(
    fuelModel=fuelModel,
    slagType=slagType,
    flueGas=flueGas,
    slagTemperature_calculationType=slagTemperature_calculationType,
    redeclare model HeatTransfer_Wall = GasHeatTransfer_Wall,
    redeclare model HeatTransfer_Top = GasHeatTransfer_Top,
    redeclare model ParticleMigration = ParticleMigration,
    redeclare model Burning_time = Burning_time,
    redeclare model ReactionZone = ReactionZone,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock (
        CF_geo=fill(1, 1),
        N_inlet=1,
        N_outlet=1,
        z_in={z_in_furnace},
        z_out={z_out_furnace},
        height_fill=-1,
        height=abs(z_in_furnace - z_out_furnace),
        width=width_furnace,
        length=length_furnace,
        flowOrientation=flowOrientation_furnace),
    m_flow_nom=m_flow_nom_gas,
    p_start_flueGas_out=p_start_flueGas_out,
    T_start_flueGas_out=T_start_flueGas_out,
    T_top_initial=T_top_initial,
    xi_start_flueGas_out=xi_start_flueGas_out,
    T_slag=T_slag) annotation (Placement(transformation(extent={{-52,-10},{8,10}})));
  ClaRa.Basics.Interfaces.FuelSlagFlueGas_outlet outletFG(
    fuelModel=fuelModel,
    slagType=slagType,
    flueGas(Medium=flueGas))                              annotation (Placement(transformation(extent={{-210,88},{-190,108}})));
  ClaRa.Basics.Interfaces.HeatPort_a heat_top annotation (Placement(transformation(extent={{-110,88},{-90,108}})));
  ClaRa.Basics.Interfaces.EyeOut eyeFTW if showData
                                        annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={240,104})));
  ClaRa.Basics.Interfaces.EyeOutGas eyeFG(medium=flueGas) if showData
                                          annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-240,106})));

  ClaRa.Components.Adapters.FuelSlagFlueGas_join
    coalSlagFlueGas_join
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-38,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow fluelGasFlowSource_bottom(
    m_flow_const=m_flow_falseAir,
    T_const=simCenter.T_amb_start,
    variable_xi=false,
    xi_const={0,0,0.0005,0,0.7681,0.2314,0,0,0},
    variable_m_flow=false)                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,-78})));
  ClaRa.Components.BoundaryConditions.BoundaryFuel_Txim_flow coalFlowSource_bottom(
    T_const=273.15 + 20,
    variable_m_flow=false)
                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-62,-78})));
  ClaRa.Components.BoundaryConditions.BoundarySlag_pT slaglSink_bottom(T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-78})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipeFlow_FTW(
    medium=medium_FTW,
    frictionAtInlet=frictionAtInlet_FTW,
    frictionAtOutlet=frictionAtOutlet_FTW,
    redeclare model PressureLoss = PressureLoss_FTW,
    redeclare model HeatTransfer = HeatTransfer_FTW,
    redeclare model MechanicalEquilibrium = MechanicalEquilibrium_FTW,
    p_nom=p_nom_FTW,
    h_nom=h_nom_FTW,
    m_flow_nom=m_flow_nom_FTW,
    Delta_p_nom=Delta_p_nom_FTW,
    initOption=initOption_FTW,
    h_start=h_start_FTW,
    p_start=p_start_FTW,
    xi_start=xi_start_FTW,
    showExpertSummary=showExpertSummary,
    showData=true,
    length=length_FTW,
    diameter_i=diameter_i_FTW,
    z_in=z_in_FTW,
    z_out=z_out_FTW,
    N_tubes=N_tubes_FTW,
    N_passes=N_passes_FTW,
    N_cv=N_cv_FTW,
    Delta_x=Delta_x_FTW)
                     annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={280,0})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow      boilerLosses(Q_flow(displayUnit="MW") = 0)
                                                                                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-24})));
equation
  connect(wall_FTW.outerPhase, adapt_FTW.heatVector) annotation (Line(
      points={{235,0},{235,-6.66134e-16},{198,-6.66134e-16}},
      color={167,25,48},
      thickness=0.5));
  connect(heat_top, hopper.heat_top) annotation (Line(
      points={{-100,98},{-100,40},{-20,40},{-20,10}},
      color={167,25,48},
      thickness=0.5));
  connect(adapt_FTW.heatScalar, hopper.heat_wall) annotation (Line(
      points={{178,1.77636e-15},{94,1.77636e-15},{94,0},{8,0}},
      color={167,25,48},
      thickness=0.5));
  connect(hopper.eyeOut, eyeFG) annotation (Line(points={{-52,8},{-240,8},{-240,106}},                   color={190,190,190}));
  connect(hopper.outlet, outletFG) annotation (Line(
      points={{-38,10},{-38,22},{-200,22},{-200,98}},
      color={118,106,98},
      thickness=0.5));
  connect(coalFlowSource_bottom.fuel_a,coalSlagFlueGas_join. fuel_inlet) annotation (Line(
      points={{-62,-68},{-62,-56},{-44,-56},{-44,-50}},
      color={27,36,42},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(slaglSink_bottom.slag_inlet,coalSlagFlueGas_join. slag_outlet) annotation (Line(
      points={{-39.8,-68},{-38,-68},{-38,-50}},
      color={234,171,0},
      thickness=0.5));
  connect(fluelGasFlowSource_bottom.gas_a,coalSlagFlueGas_join. flueGas_inlet) annotation (Line(
      points={{-12,-68},{-12,-56},{-32,-56},{-32,-50}},
      color={118,106,98},
      thickness=0.5));
  connect(hopper.inlet, coalSlagFlueGas_join.fuelSlagFlueGas_outlet) annotation (Line(
      points={{-38,-10},{-38,-30}},
      color={118,106,98},
      thickness=0.5));
  connect(pipeFlow_FTW.eye, eyeFTW) annotation (Line(points={{283.4,14.6},{283.4,57.3},{240,57.3},{240,104}}, color={190,190,190}));
  connect(wall_FTW.innerPhase,pipeFlow_FTW. heat) annotation (Line(
      points={{245,-8.88178e-16},{250.5,-8.88178e-16},{250.5,4.44089e-16},{276,4.44089e-16}},
      color={167,25,48},
      thickness=0.5));
  connect(pipeFlow_FTW.outlet, outlet_FTW) annotation (Line(
      points={{280,14},{280,100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipeFlow_FTW.inlet, inlet_FTW) annotation (Line(
      points={{280,-14},{280,-58},{280,-100},{82,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boilerLosses.port, hopper.heat_bottom) annotation (Line(points={{0,-24},{-20,-24},{-20,-10}}, color={191,0,0}));
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
</html>",
        revisions="<html>
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
</html>"),
         Icon(coordinateSystem(preserveAspectRatio=false),
                  graphics={Rectangle(
          extent={{82,-64},{94,-92}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtInlet_FTW), Rectangle(
          extent={{264,92},{292,74}},
          lineColor={28,108,200},
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=frictionAtOutlet_FTW)}),
                                      Diagram(graphics,
                                              coordinateSystem(preserveAspectRatio=false)));
end HopperSlice_L4;
