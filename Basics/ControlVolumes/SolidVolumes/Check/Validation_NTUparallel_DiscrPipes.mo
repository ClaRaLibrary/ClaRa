within ClaRa.Basics.ControlVolumes.SolidVolumes.Check;
model Validation_NTUparallel_DiscrPipes "Validation: NTU method vs. discretized tube models || counter current ||"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 0.1 alpha                        //
//                                                                           //
// Licensed by the DYNCAP research team under the 3-clause BSD License.            //
// Copyright © 2013, DYNCAP research team.                                   //
//___________________________________________________________________________//
// DYNCAP is a research project supported by the German Federal Ministry of  //
// Economics and Technology (FKZ 03ET2009).                                  //
// The DYNCAP research team consists of the following project partners:      //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  import SI = ClaRa.Basics.Units;
  import fluidObjectFunction_cp = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi;
  parameter SI.Temperature T_i_in=20 + 273.15 "Temperature of cold side";
  parameter SI.Temperature T_o_in=100 + 273.15 "Temperature of hot side";
  parameter SI.MassFlowRate m_flow_i=1 "Mass flow of cold side";
  parameter SI.MassFlowRate m_flow_o=1 "Mass flow of hot side";
  parameter SI.Pressure p_i=10e5 "Pressure of cold side";
  parameter SI.Pressure p_o=10e5 "Pressure of hot side";

  parameter SI.CoefficientOfHeatTransfer alpha_i=1000 "Heat transfer coefficient of cold side";
  parameter SI.CoefficientOfHeatTransfer alpha_o=1000 "Heat transfer coefficient of hot side";

  parameter Integer N_tubes = 10 "Number of parallel tubes";
  parameter Integer N_passes = 1 "Number of passes";
  parameter SI.Length diameter_i=0.05*2 "Diameter of cold side tubes";
  parameter SI.Length diameter_o=(0.05 + 1e-6)*2 "Diameter of hot side tubes";
  parameter SI.Length radius_i=diameter_i/2 "Diameter of cold side tubes";
  parameter SI.Length radius_o=diameter_o/2 "Diameter of hot side tubes";
  parameter SI.Length length=5 "Length of tubes";
  parameter Integer N_cv = 400 "Number of Cells";

  parameter SI.EnthalpyMassSpecific h_i_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      simCenter.fluid1,
      p_i,
      T_i_in);
  parameter SI.EnthalpyMassSpecific h_o_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      simCenter.fluid1,
      p_o,
      T_o_in);

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid ptr_o_in(vleFluidType=simCenter.fluid1);
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid ptr_i_in(vleFluidType=simCenter.fluid1);


  inner ClaRa.SimCenter simCenter(
    steamCycleAllowFlowReversal=true,
    useHomotopy=false,
    redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1) annotation (Placement(transformation(extent={{40,60},{80,80}})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe_OuterSide(
    frictionAtOutlet=true,
    Delta_p_nom=100,
    length=length,
    N_tubes=N_tubes,
    N_cv=N_cv,
    Delta_x=ones(N_cv)*length/N_cv,
    h_start=linspace(
        630e3,
        500e3,
        N_cv),
    h_nom=linspace(
        1328.89e3,
        1080.51e3,
        N_cv),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    diameter_i=diameter_o,
    p_start=linspace(
        p_o + 100,
        p_o,
        N_cv),
    p_nom=linspace(
        p_o + 100,
        p_o,
        N_cv),
    m_flow_nom=m_flow_o,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=alpha_o),
    initOption=0) annotation (Placement(transformation(extent={{-104,-25},{-76,-35}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe_InnerSide(
    frictionAtOutlet=true,
    Delta_p_nom=100,
    length=length,
    N_tubes=N_tubes,
    N_cv=N_cv,
    Delta_x=ones(N_cv)*length/N_cv,
    h_start=linspace(
        90e3,
        300e3,
        N_cv),
    h_nom=linspace(
        419240,
        450e3,
        N_cv),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    diameter_i=diameter_i,
    p_start=linspace(
        p_i + 100,
        p_i,
        N_cv),
    p_nom=linspace(
        p_i + 100,
        p_i,
        N_cv),
    m_flow_nom=m_flow_i,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=alpha_i),
    initOption=0) annotation (Placement(transformation(extent={{-104,-96},{-76,-84}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow OuterSide_in(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=m_flow_o,
    T_const=T_o_in) annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi OuterSide_out(
    Delta_p(displayUnit="Pa"),
    variable_p=false,
    p_const=p_o) annotation (Placement(transformation(extent={{-4,-40},{-24,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow InnerSide_in(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=m_flow_i,
    T_const=T_i_in) annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi InnerSide_out(
    Delta_p(displayUnit="Pa"),
    variable_p=false,
    p_const=p_i) annotation (Placement(transformation(extent={{-2,-100},{-22,-80}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T OuterSide_outletTemp annotation (Placement(transformation(extent={{-64,-30},{-44,-10}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T InnerSide_outletTemp annotation (Placement(transformation(extent={{-64,-90},{-44,-70}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_St35_8,
    length=length,
    N_tubes=N_tubes,
    N_ax=N_cv,
    Delta_x=ones(N_cv)*length/N_cv,
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    T_start=linspace(
        T_o_in,
        T_i_in,
        N_cv),
    initOption=213) annotation (Placement(transformation(extent={{-104,-64},{-76,-54}})));
  NTU_L2                                                     NTU(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_St35_8,
    redeclare model HeatExchangerType = Fundamentals.HeatExchangerTypes.ParallelFlow,
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    radius_i=radius_i,
    radius_o=radius_o,
    T_w_i_start=T_i_in,
    T_w_a_start=T_o_in,
    T_i_in=T_i_in,
    T_a_in=T_o_in,
    m_flow_i=m_flow_i,
    m_flow_a=m_flow_o,
    alpha_i=alpha_i,
    alpha_o=alpha_o,
    initOption=0,
    cp_mean_i=fluidObjectFunction_cp(pipe_InnerSide.summary.inlet.p,pipe_InnerSide.summary.inlet.h,noEvent(actualStream(pipe_InnerSide.inlet.xi_outflow[:])),ptr_i_in.vleFluidPointer),
    cp_mean_a=fluidObjectFunction_cp(pipe_OuterSide.summary.inlet.p,pipe_OuterSide.summary.inlet.h,noEvent(actualStream(pipe_OuterSide.inlet.xi_outflow[:])),ptr_o_in.vleFluidPointer))
                    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(pipe_OuterSide.outlet, OuterSide_outletTemp.port)
                                                  annotation (Line(
      points={{-76,-30},{-54,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(InnerSide_outletTemp.port, pipe_InnerSide.outlet)
                                                    annotation (Line(
      points={{-54,-90},{-76,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(OuterSide_in.steam_a, pipe_OuterSide.inlet)
                                              annotation (Line(
      points={{-140,-30},{-104,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe_InnerSide.inlet, InnerSide_in.steam_a)
                                                annotation (Line(
      points={{-104,-90},{-140,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(OuterSide_outletTemp.port, OuterSide_out.steam_a)
                                                    annotation (Line(
      points={{-54,-30},{-24,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(InnerSide_outletTemp.port, InnerSide_out.steam_a)
                                                     annotation (Line(
      points={{-54,-90},{-22,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe_OuterSide.heat, thinWall.outerPhase) annotation (Line(
      points={{-90,-34},{-90,-54}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(thinWall.innerPhase, pipe_InnerSide.heat) annotation (Line(
      points={{-90,-64},{-90,-85.2}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation (                                                        Diagram(
        coordinateSystem(extent={{-160,-100},{160,100}}, preserveAspectRatio=true),
        graphics={                                 Text(
          extent={{-160,88},{160,30}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="___________________________________________________________________________________________________
SCENARIO:
* Parallel flow
* Comparisson of descritisided model and NTU method
* both media: water
___________________________________________________________________________________________________
LOOK AT:
Outlet temperature of cooled liquid: OuterSide_outletTemp.T vs. wall_NTU.summary.T_a_out   = 334.19 K  vs 334.20 K
Outlet temperature of evaporated water: InnerSide_outletTemp.T vs wall_NTU.summary.T_i_out     = 332.28 K vs 332.40 K
___________________________________________________________________________________________________
")}),
    experiment(
      StopTime=1500,
      NumberOfIntervals=1500,
      Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true),
        graphics));
end Validation_NTUparallel_DiscrPipes;
