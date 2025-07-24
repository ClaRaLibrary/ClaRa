within ClaRa.Components.VolumesValvesFittings.Pipes.Check.WatterHammer;
model Benchmark_KitagawaExperiment
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
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve(openingInputIsActive=true, redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1e4))
                                                                                                                                                                                            annotation (Placement(transformation(extent={{-10,-66},{10,-54}})));
  inner ClaRa.SimCenter simCenter(
    redeclare TILMedia.VLEFluid.Types.TILMedia_Water fluid1,
    useHomotopy=true,
    showExpertSummary=true) annotation (Placement(transformation(extent={{-100,-106},{-80,-86}})));
  PipeFlowVLE_L4_Advanced_WH_VCM pipe(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    m_flow_nom=0.3,
    Delta_p_nom=4.8e5,
    initOption=0,
    h_start=ones(pipe.geo.N_cv)*85e3,
    showExpertSummary=true,
    frictionAtOutlet=true,
    frictionAtInlet=false,
    suppressHighFrequencyOscillations=true,
    userDefinedSpeedOfSound=true,
    a_def=820,
    z_in=0,
    z_out=0,
    diameter_i=15.2e-3,
    m_flow_start=ones(pipe.geo.N_cv + 1)*0.3,
    p_start=linspace(
        5.5e5,
        1.013e5,
        pipe.N_cv),
    length=200,
    N_cv=10) annotation (Placement(transformation(extent={{26,-65},{54,-55}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=10,
    offset=1,
    duration=0.01,
    height=-1)  annotation (Placement(transformation(extent={{-40,-44},{-20,-24}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi1(p_const=5.5e5, h_const=85e3)     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-60})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=1.013e5, h_const=85e3)    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,-60})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=time - 10) annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Tables.CombiTable1Ds resultsKatagawa_p_inlet(
    tableOnFile=true,
    tableName="data_bm04",
    fileName=Modelica.Utilities.Files.loadResource("modelica://ClaRa//Resources//TableBase//") + "BM04_katagawa_p_inlet.txt",
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) "#1 column: p1 [bar] |" annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Tables.CombiTable1Ds resultsKatagawa_w_outlet(
    tableOnFile=true,
    tableName="data_bm04",
    fileName=Modelica.Utilities.Files.loadResource("modelica://ClaRa//Resources//TableBase//") + "BM04_katagawa_w_outlet.txt",
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) "#1 column: w2 [m/s]" annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(ramp.y, valve.opening_in) annotation (Line(points={{-19,-34},{0,-34},{0,-51}},color={0,0,127}));
  connect(boundaryVLE_phxi1.steam_a, valve.inlet) annotation (Line(
      points={{-40,-60},{-10,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valve.outlet,pipe. inlet) annotation (Line(
      points={{10,-60},{26,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipe.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{54,-60},{72,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(realExpression.y, resultsKatagawa_p_inlet.u) annotation (Line(points={{-79,80},{-74,80},{-74,40},{-62,40}}, color={0,0,127}));
  connect(realExpression.y, resultsKatagawa_w_outlet.u) annotation (Line(points={{-79,80},{-74,80},{-74,0},{-62,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=50,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=true, SparseActivate = true, NumberOfCores=4),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end Benchmark_KitagawaExperiment;
