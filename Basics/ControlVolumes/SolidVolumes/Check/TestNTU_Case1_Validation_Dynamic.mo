within ClaRa.Basics.ControlVolumes.SolidVolumes.Check;
model TestNTU_Case1_Validation_Dynamic "Validation with TestThermalElements.TestNTU_Case2"

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
  parameter Units.Temperature T_i_in=100 + 273.15;
  parameter Units.Temperature T_o_in=300 + 273.15;
//   parameter Units.EnthalpyMassSpecific h_i_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
//       TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),
//       p_i,
//       T_i_in);
//   parameter Units.EnthalpyMassSpecific h_o_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
//       TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater(),
//       p_o,
//       T_o_in);
  parameter Units.MassFlowRate m_flow_i=10;
  parameter Units.MassFlowRate m_flow_o=100;
  parameter Units.Pressure p_i=0.9e5;
  parameter Units.Pressure p_o=300e5;

  parameter Units.CoefficientOfHeatTransfer alpha_i=730;
  parameter Units.CoefficientOfHeatTransfer alpha_o=7300;

  parameter Integer N_tubes=200;
  parameter Integer N_passes=1;
  parameter Units.Length radius_i=0.05;
  parameter Units.Length radius_o=0.05 + 5e-3;
  parameter Units.Length diameter_i=radius_i*2;
  parameter Units.Length diameter_o=radius_o*2;
  parameter Units.Length length=4;
  parameter Integer N_cv=10;

//   Units.HeatFlowRate Q_flow_tot;
  //    SI.HeatCapacityMassSpecific cp_o_m;
  //    SI.HeatCapacityMassSpecific cp_i_m;
  //    SI.HeatCapacityMassSpecific cp_o[N_cv];
  //    SI.HeatCapacityMassSpecific cp_i[N_cv];

  //    Real x[N_cv];
  //    Real val = pipe_ColdSide.fluid[1].VLE.h_v;
  //    Integer Cell_hv "Zelle bei der Phasenwechsel auftritt";
  //    Integer Cells_hv_p1=Cell_hv+1;

  inner SimCenter simCenter(
    steamCycleAllowFlowReversal=true,
    showExpertSummary=true,
    useHomotopy=true,
    redeclare TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1)
    annotation (Placement(transformation(extent={{80,75},{100,95}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_L3_standalone NTU(
    N_t=N_tubes,
    N_p=N_passes,
    length=length,
    radius_i=radius_i,
    radius_o=radius_o,
    m_flow_o=outerVol.inlet.m_flow,
    outerPhaseChange=false,
    T_w_o_start=linspace(
        300 + 273.15,
        280 + 273.15,
        3),
    T_w_i_start=linspace(
        280 + 273.15,
        300 + 273.15,
        3),
    yps_start={0.33,0.33},
    p_o=outerVol.p,
    alpha_o=ones(3)*outerVol.heattransfer.alpha,
    p_i=innerVol.p,
    alpha_i=ones(3)*innerVol.heattransfer.alpha,
    m_flow_i=innerVol.inlet.m_flow,
    redeclare model HeatExchangerType = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow_L3,
    h_i_inlet=actualStream(innerVol.inlet.h_outflow),
    h_o_inlet=actualStream(outerVol.inlet.h_outflow),
    redeclare model HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.ArithmeticMean,
    initOption=0,
    initOption_yps=3,
    xi_i=actualStream(innerVol.inlet.xi_outflow),
    xi_o=actualStream(outerVol.inlet.xi_outflow))
                  annotation (Placement(transformation(extent={{-19,-72},{1,-54}})));

  Modelica.Blocks.Sources.Ramp T_i(
    offset=T_i_in,
    startTime=500,
    duration=10,
    height=20)   annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow OuterSide_in1(
    m_flow_const=m_flow_o,
    T_const=T_o_in,
    variable_m_flow=false,
    variable_T=false) annotation (Placement(transformation(extent={{-78,-48},{-58,-28}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi InnerSide_out1(
    Delta_p(displayUnit="Pa"),
    p_const=p_i,
    variable_p=false) annotation (Placement(transformation(extent={{-78,-98},{-58,-78}})));
  Components.BoundaryConditions.BoundaryVLE_Txim_flow InnerSide_in1(
    variable_m_flow=false,
    m_flow_const=m_flow_i,
    T_const=T_i_in,
    variable_T=true) annotation (Placement(transformation(extent={{60,-98},{40,-78}})));
  Components.BoundaryConditions.BoundaryVLE_pTxi OuterSide_out1(
    Delta_p(displayUnit="Pa"),
    p_const=p_o,
    variable_p=false) annotation (Placement(transformation(extent={{62,-48},{42,-28}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T Cold_out_degC1 annotation (Placement(transformation(extent={{-36,-88},{-16,-68}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T Hot_out_degC1 annotation (Placement(transformation(extent={{12,-38},{32,-18}})));
  FluidVolumes.VolumeVLE_L2 outerVol(
    m_flow_nom=m_flow_o,
    p_nom=p_o,
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred (position_Delta_p_geo="inlet"),
    p_start=p_o,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=alpha_o),
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        diameter=diameter_o,
        length=length,
        N_tubes=N_tubes,
        N_passes=N_passes),
    h_nom=1100e3,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    h_start=1330e3,
    initOption=0)   annotation (Placement(transformation(extent={{-19,-28},{1,-48}})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 innerVol(
    m_flow_nom=m_flow_i,
    p_nom=p_i,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=alpha_i),
    redeclare model PhaseBorder = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.IdeallyStirred,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry (
        diameter=diameter_i,
        length=length,
        N_tubes=N_tubes,
        N_passes=N_passes),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=100),
    initOption=0,
    p_start=p_i + 100,
    h_start=3080e3) annotation (Placement(transformation(extent={{1,-98},{-19,-78}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T Hot_out_degC2 annotation (Placement(transformation(extent={{10,-88},{30,-68}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T Cold_out_degC2 annotation (Placement(transformation(extent={{-42,-38},{-22,-18}})));
   ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple
                                                                pipe_HotSide(
     length=length,
     N_tubes=N_tubes,
     N_cv=N_cv,
     diameter_i=diameter_o,
     Delta_x=ones(N_cv)*length/N_cv,
     m_flow_nom=m_flow_o,
     h_start=linspace(
         1328.89e3,
         1080.51e3,
         N_cv),
     h_nom=linspace(
         1328.89e3,
         1080.51e3,
         N_cv),
     redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
     p_start=linspace(
         p_o + 100,
         p_o,
         N_cv),
     p_nom=linspace(
         p_o + 100,
         p_o,
         N_cv),
     redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=alpha_o),
    initOption=0,
     N_passes=N_passes,
    frictionAtOutlet=true)
                     annotation (Placement(transformation(extent={{-26,28},{6,16}})));
   ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple
                                                                pipe_ColdSide(
     length=length,
     N_tubes=N_tubes,
     N_cv=N_cv,
     diameter_i=diameter_i,
     Delta_x=ones(N_cv)*length/N_cv,
     m_flow_nom=m_flow_i,
     p_nom=linspace(
         p_i + 100,
         p_i,
         N_cv),
     h_nom=linspace(
         419240,
         450e3,
         N_cv),
     redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=alpha_i),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
     h_start=linspace(
         419240,
         2895e3,
         N_cv),
     N_passes=N_passes,
    frictionAtOutlet=true,
    initOption=0,
    Delta_p_nom=100,
    p_start=linspace(
        p_i + 100,
        p_i,
        N_cv))       annotation (Placement(transformation(extent={{6,-16},{-26,-4}})));
   ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       OuterSide_in(
     m_flow_const=m_flow_o,
     T_const=T_o_in,
     variable_m_flow=false,
     variable_T=false) annotation (Placement(transformation(extent={{-78,12},{-58,32}})));
   ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi
                                                  OuterSide_out(
     Delta_p(displayUnit="Pa"),
     p_const=p_o,
     variable_p=false) annotation (Placement(transformation(extent={{60,12},{40,32}})));
   ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       InnerSide_in(
     variable_m_flow=false,
     m_flow_const=m_flow_i,
     T_const=T_i_in,
     variable_T=true) annotation (Placement(transformation(extent={{60,-20},{40,0}})));
   ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi
                                                  InnerSide_out(
     Delta_p(displayUnit="Pa"),
     p_const=p_i,
     variable_p=false) annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
   ClaRa.Components.Sensors.SensorVLE_L1_T Hot_out_degC annotation (Placement(transformation(extent={{16,22},{36,42}})));
   ClaRa.Components.Sensors.SensorVLE_L1_T Cold_out_degC annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                            m_flow_nom=10, Delta_p_nom=1000)) annotation (Placement(transformation(extent={{-34,-94},{-54,-82}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    N_tubes=N_tubes,
    N_ax=N_cv,
    Delta_x=ones(N_cv)*length/N_cv,
    T_start=linspace(
        T_o_in,
        T_i_in,
        N_cv),
    length=length*N_passes,
    initOption=213) annotation (Placement(transformation(extent={{-20,2},{0,10}})));
equation
   for i in 1:pipe_ColdSide.N_cv loop

     connect(pipe_ColdSide.heat[i], thinWall.innerPhase[(pipe_ColdSide.N_cv + 1) - i]);
     // x[i]=pipe_ColdSide.fluid[i].h;
   end for;

  //   for i in 1:N_cv loop
  //      if i>=Cell_hv then
  //         cp_o[i]=pipe_HotSide.fluid[i].cp;
  //         cp_i[i]=pipe_ColdSide.fluid[i].cp;
  //      else
  //         cp_o[i]=0;
  //         cp_i[i]=0;
  //      end if;
  //    end for;
//
//   Q_flow_tot = sum(pipe_ColdSide.heat[i].Q_flow for i in 1:N_cv);

  //   cp_o_m=sum(cp_o)/(max(1,N_cv-Cell_hv));
  //   cp_i_m=sum(cp_i)/(max(1,N_cv-Cell_hv));

  // Cell_hv=integer(ClaRa.Basics.ControlVolumes.SolidVolumes.ValidateThermalElements.findValue_Case2(x,val));

  connect(outerVol.outlet, Hot_out_degC1.port) annotation (Line(
      points={{1,-38},{22,-38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Hot_out_degC1.port, OuterSide_out1.steam_a) annotation (Line(
      points={{22,-38},{42,-38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerVol.inlet, OuterSide_in1.steam_a) annotation (Line(
      points={{-19,-38},{-58,-38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(InnerSide_in1.T, T_i.y) annotation (Line(
      points={{62,-88},{68,-88},{68,-10},{79,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outerVol.heat, NTU.outerPhase[1]) annotation (Line(
      points={{-9,-48},{-9,-55.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerVol.heat, NTU.outerPhase[2]) annotation (Line(
      points={{-9,-48},{-9,-54.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerVol.heat, NTU.outerPhase[3]) annotation (Line(
      points={{-9,-48},{-9,-54.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerVol.inlet, Cold_out_degC2.port) annotation (Line(
      points={{-19,-38},{-32,-38}},
      color={0,131,169},
      thickness=0.5));
  connect(InnerSide_in1.steam_a, Hot_out_degC2.port) annotation (Line(
      points={{40,-88},{20,-88}},
      color={0,131,169},
      thickness=0.5));
  connect(innerVol.inlet, InnerSide_in1.steam_a) annotation (Line(
      points={{1,-88},{40,-88}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(NTU.innerPhase[1], innerVol.heat) annotation (Line(
      points={{-9,-71.4},{-9,-78}},
      color={167,25,48},
      thickness=0.5));
  connect(NTU.innerPhase[2], innerVol.heat) annotation (Line(
      points={{-9,-71.1},{-9,-78}},
      color={167,25,48},
      thickness=0.5));
  connect(NTU.innerPhase[3], innerVol.heat) annotation (Line(
      points={{-9,-70.8},{-9,-78}},
      color={167,25,48},
      thickness=0.5));
  connect(valveVLE_L1_1.inlet, innerVol.outlet) annotation (Line(
      points={{-34,-88},{-19,-88}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Cold_out_degC1.port, innerVol.outlet) annotation (Line(
      points={{-26,-88},{-19,-88}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(InnerSide_out1.steam_a, valveVLE_L1_1.outlet) annotation (Line(
      points={{-58,-88},{-54,-88}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
   connect(pipe_HotSide.outlet,Hot_out_degC. port) annotation (Line(
       points={{6,22},{26,22}},
       color={0,131,169},
       thickness=0.5,
       smooth=Smooth.None));
   connect(OuterSide_in.steam_a,pipe_HotSide. inlet) annotation (Line(
       points={{-58,22},{-26,22}},
       color={0,131,169},
       thickness=0.5,
       smooth=Smooth.None));
   connect(pipe_ColdSide.inlet,InnerSide_in. steam_a) annotation (Line(
       points={{6,-10},{40,-10}},
       color={0,131,169},
       thickness=0.5,
       smooth=Smooth.None));
   connect(pipe_HotSide.heat,thinWall. outerPhase) annotation (Line(
       points={{-10,17.2},{-10,10}},
       color={191,0,0},
       smooth=Smooth.None));
   connect(Hot_out_degC.port,OuterSide_out. steam_a) annotation (Line(
       points={{26,22},{40,22}},
       color={0,131,169},
       thickness=0.5,
       smooth=Smooth.None));
   connect(T_i.y,InnerSide_in. T) annotation (Line(
       points={{79,-10},{62,-10}},
       color={0,0,127},
       smooth=Smooth.None));
  connect(Cold_out_degC.port,pipe_ColdSide. outlet) annotation (Line(
      points={{-32,-10},{-26,-10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipe_ColdSide.outlet, InnerSide_out.steam_a) annotation (Line(
      points={{-26,-10},{-60,-10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(
          extent={{-100,100},{100,48}},
          lineColor={115,150,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
Test steady state and dynamic behaviour of NTU model compared to a highly discretised pipe HEX
______________________________________________________________________________________________
Scenario:  
Increase (20 K) of cold side inlet temperature at 500s 
          
______________________________________________________________________________________________
Look at: Compare pipe_ColdSide.summary.outline.Q_flow_tot and NTU.summary.Q_flow_tot. The difference is less than 3 percent for N_cv = 100.
            Accordingly, the temperatures at the vessels' outlets match very good in steady state case. Be aware that masses and 
            transient behaviour is less comparable.
______________________________________________________________________________________________
Note that accuracy of the discretised HEX model strongly depends on the number of control volumes N_cv. Try changing it to instetigate its impact
 on CPU time and transferred heat.
")}),
    experiment(StopTime=1500, Tolerance=1e-006),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}})));
end TestNTU_Case1_Validation_Dynamic;
