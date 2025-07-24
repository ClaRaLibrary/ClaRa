within ClaRa.Visualisation.Check;
model IllustrateVisualisation
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
extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperature annotation (Placement(transformation(extent={{-4,-8},{16,12}})));
  ClaRa.Visualisation.Quadruple quadruple
    annotation (Placement(transformation(extent={{12,-36},{42,-26}})));
  ClaRa.Visualisation.DynDisplay dynDisplay(
    varname="pipe density",
    x1=pipe.summary.outlet.rho,
    unit="kg/m^3",
    decimalSpaces=2)
    annotation (Placement(transformation(extent={{-62,14},{-42,34}})));
  ClaRa.Visualisation.Scope scope(
    Unit="Temperature at Pipe Outlet Flange",
    y_min=300,
    y_max=700,
    t_end=20,
    hideInterface=false,
    color={122,33,55})
                     annotation (Placement(transformation(extent={{28,16},{72,56}})));
  ClaRa.Visualisation.StatePoint_phTs statePoint_phTs
    annotation (Placement(transformation(extent={{34,-10},{48,4}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(variable_m_flow=true, h_const=3000e3) annotation (Placement(transformation(extent={{-64,-28},{-44,-8}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(p_const=50e5, h_const=2000e3) annotation (Placement(transformation(extent={{84,-28},{64,-8}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe(
    showData=true,
    N_cv=10,
    h_start=ones(10)*3000e3,
    p_start=ones(10)*50e5,
    m_flow_nom=10,
    Delta_p_nom=1e5,
    frictionAtInlet=false,
    frictionAtOutlet=true,
    redeclare model PressureLoss =
        Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4)               annotation (Placement(transformation(extent={{-26,-23},{2,-13}})));

  Modelica.Blocks.Sources.Ramp ramp(
    height=-20,
    offset=10,
    duration=10,
    startTime=5)
    annotation (Placement(transformation(extent={{-96,-22},{-76,-2}})));
  inner ClaRa.SimCenter simCenter(showExpertSummary=true) annotation (Placement(transformation(extent={{-114,-106},{-94,-86}})));
equation
  connect(temperature.T, scope.u) annotation (Line(
      points={{17,2},{22,2},{22,44.9231},{26.1143,44.9231}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe.outlet, pressureSink_ph.steam_a) annotation (Line(
      points={{2,-18},{64,-18}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(pipe.inlet, massFlowSource_h.steam_a) annotation (Line(
      points={{-26,-18},{-44,-18}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(vlePressureSensor.port, pipe.inlet) annotation (Line(
      points={{-30,-10},{-30,-18},{-26,-18}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(quadruple.eye, pipe.eye) annotation (Line(
      points={{12,-31},{6,-31},{6,-21.4},{2.6,-21.4}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(temperature.port, pipe.outlet) annotation (Line(
      points={{6,-8},{6,-18},{2,-18}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(statePoint_phTs.port, pipe.outlet) annotation (Line(
      points={{34,-10},{34,-18},{2,-18}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, massFlowSource_h.m_flow) annotation (Line(
      points={{-75,-12},{-66,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput);
end IllustrateVisualisation;
