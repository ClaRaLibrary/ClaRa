within ClaRa.Components.Control.PredictorModels_3508.Check;
model TestPredictor
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  ClaRa.Components.Control.PredictorModels_3508.CoalSupplyBoiler_01_XRG Model_boiler(p_LS_nom=24000000, CL_mflowLS_QF_=[0,0.25; 0.34,0.25; 1,1])
                                                                                                        annotation (Placement(transformation(extent={{-2,116},{40,150}})));
  Modelica.Blocks.Sources.Step ramp1(
    offset=1,
    height=-0.5,
    startTime=40000)
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID(
    y_max=1,
    Tau_d=1000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=-1,
    perUnitConversion=true,
    y_ref=1,
    u_ref=1,
    Tau_i=500,
    k=2.5,
    Tau_out=1,
    y_start=1,
    initOption=501) annotation (Placement(transformation(extent={{-54,80},{-34,100}})));
  Modelica.Blocks.Sources.RealExpression MV_Pressure_LS(y=homotopy(realPlantPower_.y, turbinesAndReheat_01.P_gen_)) "Measurement value of live steam pressure" annotation (Placement(transformation(extent={{-112,56},{-92,76}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    offset=1,
    height=-0.5,
    duration=600,
    startTime=6000)
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 HPTurbine(
    rho_nom=74.2585,
    Pi=28e5/240e5,
    p_nom=24000000) annotation (Placement(transformation(extent={{80,-80},{90,-60}})));
  inner ClaRa.SimCenter simCenter(redeclare replaceable TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1) annotation (Placement(transformation(extent={{160,180},{200,200}})));
  ClaRa.Components.Control.PredictorModels_3508.TurbinesAndReheat_01_XRG turbinesAndReheat_01(
    p_nom=2800000,
    P_G_nom=507.7e6,
    CL_Deltah_p=[0.5000e7,0.7*0.1889e7; 0.6000e7,0.7*0.1889e7; 0.8000e7,0.7*0.1910e7; 1.0000e7,0.7*0.1923e7; 1.2000e7,0.7*0.1930e7; 1.4000e7,0.7*0.1933e7; 1.6000e7,0.7*0.1934e7; 1.8000e7,0.7*0.1933e7; 2.0000e7,1.0e6; 2.2000e7,1.1e6; 2.4000e7,1.2117e+006; 2.5000e7,1.2117e+006]) annotation (Placement(transformation(extent={{64,127},{94,161}})));
  Modelica.Blocks.Sources.RealExpression realPlantPower_(y=-(HPTurbine.P_t + IPTurbine.P_t + LPTurbine.P_t)/turbinesAndReheat_01.P_G_nom) annotation (Placement(transformation(extent={{104,-26},{124,-6}})));
  ClaRa.SubSystems.Boiler.SteamGenerator_L3 steamGenerator(
    p_LS_nom=24000000,
    h_LS_nom=3279e3,
    h_LS_start=3400e3,
    p_LS_start=24000000,
    p_RH_start=2800000,
    initOption_HP=0,
    heatRelease(initType=Modelica.Blocks.Types.Init.InitialState)) annotation (Placement(transformation(extent={{6,-64},{32,-28}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSourceFW(
    m_flow_const=419,
    h_const=500e3,
    variable_m_flow=true) annotation (Placement(transformation(extent={{-94,-68},{-74,-48}})));
protected
  ClaRa.Basics.Interfaces.SteamSignal mediumData_b annotation (Placement(transformation(extent={{-134,-61},{-128,-55}})));
public
  Modelica.Blocks.Math.Gain gain(k=Model_boiler.m_flow_LS_nom) annotation (Placement(transformation(extent={{-122,-62},{-110,-50}})));
  ClaRa.Visualisation.Scope scope(
    color={255,255,0},
    t_end=15000,
    hideInterface=false) annotation (Placement(transformation(extent={{144,-44},{188,-4}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSinkCondenser(p_const=5000) annotation (Placement(transformation(extent={{188,-94},{168,-74}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 IPTurbine(
    m_flow_nom=419,
    Pi=4e5/28e5,
    p_nom=2800000) annotation (Placement(transformation(extent={{106,-80},{116,-60}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 LPTurbine(
    Pi=0.0125,
    rho_nom=1.7,
    m_flow_nom=419 - 150,
    p_nom=400000,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,0.9; 1,0.9]))) annotation (Placement(transformation(extent={{140,-80},{150,-60}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split(h_start=2000e3, p_start=4e5) annotation (Placement(transformation(extent={{116,-96},{136,-84}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSourceTap(variable_m_flow=false, m_flow_const=-150) annotation (Placement(transformation(extent={{90,-140},{110,-120}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-86,80},{-66,100}})));
  Modelica.Blocks.Sources.RealExpression MV_Pressure_LS1(y=0) "Measurement value of live steam pressure"
    annotation (Placement(transformation(extent={{-68,58},{-48,78}})));
equation

  connect(ramp1.y, Model_boiler.yT_)         annotation (Line(
      points={{-79,170},{34,170},{34,153.4},{33.5385,153.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, Model_boiler.QF_setl_) annotation (Line(
      points={{-79,130},{-5.23077,130},{-5.23077,133}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(turbinesAndReheat_01.inlet, Model_boiler.steamSignal) annotation (Line(
      points={{64.3,144},{54,144},{54,143.2},{40,143.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HPTurbine.outlet, steamGenerator.reheat_in) annotation (Line(
      points={{90,-80},{26,-80},{26,-63.55},{26.8,-63.55}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HPTurbine.inlet, steamGenerator.livesteam) annotation (Line(
      points={{80,-64},{64,-64},{64,-6},{18,-6},{18,-28},{19,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gain.y, massFlowSourceFW.m_flow) annotation (Line(
      points={{-109.4,-56},{-98,-56},{-98,-52},{-96,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, mediumData_b.p_) annotation (Line(
      points={{-123.2,-56},{-126,-56},{-126,-57.985},{-130.985,-57.985}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(realPlantPower_.y, scope.u) annotation (Line(
      points={{125,-16},{142.114,-16},{142.114,-15.0769}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(Model_boiler.steamSignal, mediumData_b) annotation (Line(
      points={{40,143.2},{40,186},{-140,186},{-140,-58},{-131,-58}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(LPTurbine.outlet, pressureSinkCondenser.steam_a) annotation (Line(
      points={{150,-80},{150,-84},{168,-84}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(IPTurbine.outlet, split.inlet) annotation (Line(
      points={{116,-80},{116,-90}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSourceTap.steam_a, split.outlet2) annotation (Line(
      points={{110,-130},{126,-130},{126,-96}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(steamGenerator.reheat_out, IPTurbine.inlet) annotation (Line(
      points={{26.8,-28},{106,-28},{106,-64}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(split.outlet1, LPTurbine.inlet) annotation (Line(
      points={{136,-90},{136,-64},{140,-64}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(massFlowSourceFW.steam_a, steamGenerator.feedwater) annotation (Line(
      points={{-74,-58},{-60,-58},{-60,-60},{-40,-60},{-40,-92},{19,-92},{19,-63.55}},
      color={0,131,169},
      thickness=0.5));
  connect(PID.y, steamGenerator.QF_setl_) annotation (Line(points={{-33,90},{-22,90},{-22,-52.75},{3.4,-52.75}}, color={0,0,127}));
  connect(feedback.y, PID.u_s) annotation (Line(points={{-67,90},{-56,90}}, color={0,0,127}));
  connect(turbinesAndReheat_01.P_gen_, feedback.u1) annotation (Line(points={{95.5,144},{114,144},{114,108},{-98,108},{-98,90},{-84,90}}, color={0,0,127}));
  connect(MV_Pressure_LS.y, feedback.u2) annotation (Line(points={{-91,66},{-76,66},{-76,82}}, color={0,0,127}));
  connect(MV_Pressure_LS1.y, PID.u_m) annotation (Line(points={{-47,68},{-43.9,68},{-43.9,78}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-200},{200,200}}),
                      graphics={
        Rectangle(extent={{-144,32},{198,-194}},lineColor={0,0,0}),
        Rectangle(
          extent={{-144,200},{122,38}},
          lineColor={0,0,0},
          fillColor={236,236,236},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,50},{136,38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Model-based process control"),
        Text(
          extent={{48,30},{198,18}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Process model")}),
                                 Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=50000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end TestPredictor;
