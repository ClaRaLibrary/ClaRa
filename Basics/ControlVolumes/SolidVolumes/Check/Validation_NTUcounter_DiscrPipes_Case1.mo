within ClaRa.Basics.ControlVolumes.SolidVolumes.Check;
model Validation_NTUcounter_DiscrPipes_Case1 "Validation: NTU method vs. discretized tube models || counter current || evaporating inner side ||H2O"
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

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  import SI = ClaRa.Basics.Units;
  import fluidObjectFunction_cp = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_h_dew = TILMedia.VLEFluid.ObjectFunctions.vapourSpecificEnthalpy_phxi;

  parameter Units.Temperature T_i_in=100 + 273.15 "Temperature of cold side";
  parameter Units.Temperature T_o_in=300 + 273.15 "Temperature of hot side";
  parameter Units.MassFlowRate m_flow_i=10 "Mass flow of cold side";
  parameter Units.MassFlowRate m_flow_o=100 "Mass flow of hot side";
  parameter Units.Pressure p_i=2e5 "Pressure of cold side";
  parameter Units.Pressure p_o=300e5 "Pressure of hot side";

  parameter Units.CoefficientOfHeatTransfer alpha_i=730 "Heat transfer coefficient of cold side";
  parameter Units.CoefficientOfHeatTransfer alpha_o=7300 "Heat transfer coefficient of hot side";

  parameter Integer N_tubes=200 "Number of parallel tubes";
  parameter Integer N_passes=1 "Number of passes";
  parameter Units.Length diameter_i=0.05*2 "Diameter of cold side tubes";
  parameter Units.Length diameter_o=(0.05 + 1e-6)*2 "Diameter of hot side tubes";
  parameter Units.Length radius_i=diameter_i/2 "Diameter of cold side tubes";
  parameter Units.Length radius_o=diameter_o/2 "Diameter of hot side tubes";
  parameter Units.Length length=4 "Length of tubes";
  parameter Integer N_cv=100;
  //400 "Number of Cells";

  parameter Units.EnthalpyMassSpecific h_i_in=TILMedia.VLEFluid.MixtureCompatible.Functions.specificEnthalpy_pTxi(
      simCenter.fluid1,
      p_i,
      T_i_in);
  parameter Units.EnthalpyMassSpecific h_o_in=TILMedia.VLEFluid.MixtureCompatible.Functions.specificEnthalpy_pTxi(
      simCenter.fluid1,
      p_o,
      T_o_in);

  TILMedia.VLEFluid.MixtureCompatible.VLEFluid ptr_o[N_cv](each vleFluidType=simCenter.fluid1);
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid ptr_i[N_cv](each vleFluidType=simCenter.fluid1);

  Units.HeatFlowRate Q_flow_tot;
  Units.HeatCapacityMassSpecific cp_o_m;
  Units.HeatCapacityMassSpecific cp_i_m;
  Units.HeatCapacityMassSpecific cp_o[N_cv];
  Units.HeatCapacityMassSpecific cp_i[N_cv];
  Units.HeatCapacityMassSpecific cp_o_[N_cv];
  Units.HeatCapacityMassSpecific cp_i_[N_cv];

  Real x[N_cv];
  Real val = TILMedia.VLEFluid.ObjectFunctions.vapourSpecificEnthalpy_phxi(
                                                                          pipe_InnerSide.summary.fluid.p[1],pipe_InnerSide.summary.fluid.h[1],noEvent(actualStream(pipe_InnerSide.inlet.xi_outflow[:])),ptr_i[1].vleFluidPointer);
  //Real val = pipe_InnerSide.summary.fluid.h_dew[1];
  Integer Cell_hv "Zelle bei der Phasenwechsel auftritt";
  Integer Cells_hv_p1=Cell_hv + 1;

  inner SimCenter simCenter(
    steamCycleAllowFlowReversal=true,
    useHomotopy=false,
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1,
    showExpertSummary=true) annotation (Placement(transformation(extent={{116,74},{136,94}})));

  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe_OuterSide(
    Delta_p_nom=100,
    length=length,
    N_tubes=N_tubes,
    N_cv=N_cv,
    Delta_x=ones(N_cv)*length/N_cv,
    h_start=linspace(
        1328.89e3,
        1080.51e3,
        N_cv),
    h_nom=linspace(
        1328.89e3,
        1080.51e3,
        N_cv),
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
    initOption=0,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4)
                    annotation (Placement(transformation(extent={{-84,-14},{-52,-26}})));
  Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe_InnerSide(
    Delta_p_nom=100,
    length=length,
    N_tubes=N_tubes,
    N_cv=N_cv,
    Delta_x=ones(N_cv)*length/N_cv,
    h_nom=linspace(
        419240,
        450e3,
        N_cv),
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
    frictionAtInlet=false,
    h_start=linspace(
        419240,
        2895e3,
        N_cv),
    initOption=0,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4)
                    annotation (Placement(transformation(extent={{-52,-72},{-84,-60}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow OuterSide_in(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=m_flow_o,
    T_const=T_o_in) annotation (Placement(transformation(extent={{-146,-30},{-126,-10}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi OuterSide_out(
    Delta_p(displayUnit="Pa"),
    variable_p=false,
    p_const=p_o) annotation (Placement(transformation(extent={{8,-30},{-12,-10}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow InnerSide_in(
    variable_m_flow=false,
    variable_T=false,
    m_flow_const=m_flow_i,
    T_const=T_i_in) annotation (Placement(transformation(extent={{8,-76},{-12,-56}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi InnerSide_out(
    Delta_p(displayUnit="Pa"),
    variable_p=false,
    p_const=p_i) annotation (Placement(transformation(extent={{-146,-76},{-126,-56}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T OuterSide_outletTemp(unitOption=2)
                                                               annotation (Placement(transformation(extent={{-42,-20},{-22,0}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T InnerSide_outletTemp(unitOption=2)
                                                               annotation (Placement(transformation(extent={{-106,-66},{-86,-46}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
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
    initOption=213) annotation (Placement(transformation(extent={{-78,-46},{-58,-38}})));

  Visualisation.Hexdisplay_3 hexdisplay_3_1(
    Unit="HEX wall",
    y_min=273,
    y_max=900,
    T_o=wall_NTU.summary.T_o,
    T_i=wall_NTU.summary.T_i,
    z_i=wall_NTU.summary.eCom.z_i,
    z_o=wall_NTU.summary.eCom.z_o) annotation (Placement(transformation(extent={{46,-88},{158,16}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone wall_NTU(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    outerPhaseChange=false,
    redeclare model HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.ArithmeticMean,
    radius_i=radius_i,
    radius_o=radius_o,
    gain_eff=2,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_in,
    h_o_inlet=h_o_in,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    T_w_i_start=ones(3)*T_i_in,
    T_w_o_start=ones(3)*T_o_in,
    alpha_i=ones(3)*alpha_i,
    alpha_o=ones(3)*alpha_o,
    yps_start={0.3,0.3},
    initOption=0,
    initOption_yps=3)
                    annotation (Placement(transformation(extent={{4,-50},{24,-30}})));

equation
  for i in 1:pipe_InnerSide.N_cv loop

    connect(pipe_InnerSide.heat[i], thinWall.innerPhase[(pipe_InnerSide.N_cv + 1) - i]);
    x[i] = pipe_InnerSide.summary.fluid.h[i];
  end for;

  for i in 1:N_cv loop
      cp_o_[i]=fluidObjectFunction_cp(pipe_OuterSide.summary.fluid.p[i],pipe_OuterSide.summary.fluid.h[i],noEvent(actualStream(pipe_OuterSide.inlet.xi_outflow[:])),ptr_o[i].vleFluidPointer);
      cp_i_[i]=fluidObjectFunction_cp(pipe_InnerSide.summary.fluid.p[i],pipe_InnerSide.summary.fluid.h[i],noEvent(actualStream(pipe_InnerSide.inlet.xi_outflow[:])),ptr_i[i].vleFluidPointer);
    if i >= Cell_hv then
      cp_o[i] = cp_o_[i];//pipe_OuterSide.fluid[i].cp;
      cp_i[i] = cp_i_[i];//pipe_InnerSide.fluid[i].cp;
    else
      cp_o[i] = 0;
      cp_i[i] = 0;
    end if;
  end for;

  Q_flow_tot = sum(pipe_InnerSide.heat[i].Q_flow for i in 1:N_cv);

  cp_o_m = sum(cp_o)/(max(1, N_cv - Cell_hv));
  cp_i_m = sum(cp_i)/(max(1, N_cv - Cell_hv));

  Cell_hv = integer(Modelica.Math.Vectors.find(
    val,
    x,
    15e3));

  connect(pipe_OuterSide.outlet, OuterSide_outletTemp.port) annotation (Line(
      points={{-52,-20},{-32,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(InnerSide_outletTemp.port, pipe_InnerSide.outlet) annotation (Line(
      points={{-96,-66},{-84,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(OuterSide_in.steam_a, pipe_OuterSide.inlet) annotation (Line(
      points={{-126,-20},{-84,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe_InnerSide.inlet, InnerSide_in.steam_a) annotation (Line(
      points={{-52,-66},{-12,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe_OuterSide.heat, thinWall.outerPhase) annotation (Line(
      points={{-68,-24.8},{-68,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(OuterSide_outletTemp.port, OuterSide_out.steam_a) annotation (Line(
      points={{-32,-20},{-12,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(InnerSide_outletTemp.port, InnerSide_out.steam_a) annotation (Line(
      points={{-96,-66},{-126,-66}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-160,-100},{160,100}}, preserveAspectRatio=false), graphics={
                                                        Text(
          extent={{-158,84},{162,26}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="___________________________________________________________________________________________________
SCENARIO:
* Counterflow
* Comparisson of descritisided model and NTU method
* Evaporation of inner flow, outer flow is cooled, one phase flow
* both media: water
___________________________________________________________________________________________________
LOOK AT:
Outlet temperature of cooled liquid: OuterSide_outletTemp.T  vs. wall_NTU.summary.T_o[6]   = 248.31 C  vs 248.29 C
Outlet temperature of evaporated water: InnerSide_outletTemp.T vs wall_NTU.summary.T_i[6]   = 215.55 C vs 216.11 C
___________________________________________________________________________________________________
NOTE:
* the results from the NTU method is slightly worse when the inlet media data are used instead of taken arethmetic mean
 values. See the Expert Settings in the parameter dialog
___________________________________________________________________________________________________")}),
    experiment(
      StopTime=500,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true)));
end Validation_NTUcounter_DiscrPipes_Case1;
