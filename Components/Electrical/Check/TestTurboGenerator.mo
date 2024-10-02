within ClaRa.Components.Electrical.Check;
model TestTurboGenerator

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


  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  SimpleGenerator simpleGenerator(N_pole_pairs=1,
    hasInertia=true,
    contributeToCycleSummary=true,
    eta=0.5)                                                           annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  BoundaryConditions.BoundaryElectricFrequency boundaryElectricFrequency(variable_f=true)
                                                                         annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbineVLE_L1_1(useMechanicalPort=true,
    J=3000,
    steadyStateTorque=true,
    redeclare model Efficiency = TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow,
    contributeToCycleSummary=true,
    eta_mech=1)                                                                                                  annotation (Placement(transformation(extent={{-34,-10},{-24,10}})));
  BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_phxi(
    h_const=3000e3,
    m_flow_const=250,
    energyType=1) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi1(variable_p=true, energyType=1) annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    offset=20e5,
    startTime=20,
    height=-19.99e5)
                  annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    height=10,
    offset=50,
    startTime=100) annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  inner SimCenter simCenter(contributeToCycleSummary=true, showExpertSummary=true)
                            annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
equation
  connect(boundaryElectricFrequency.electricPortIn, simpleGenerator.powerConnection) annotation (Line(
      points={{40,0},{40,0},{20,0}},
      color={115,150,0},
      thickness=0.5));
  connect(steamTurbineVLE_L1_1.shaft_b, simpleGenerator.shaft) annotation (Line(points={{-20,0},{0,0},{0,-0.1}}, color={0,0,0}));
  connect(boundaryVLE_phxi.steam_a, steamTurbineVLE_L1_1.inlet) annotation (Line(
      points={{-40,30},{-34,30},{-34,6}},
      color={0,131,169},
      thickness=0.5));
  connect(boundaryVLE_phxi1.steam_a, steamTurbineVLE_L1_1.outlet) annotation (Line(
      points={{-40,-30},{-24,-30},{-24,-10}},
      color={0,131,169},
      thickness=0.5));
  connect(ramp.y, boundaryVLE_phxi1.p) annotation (Line(points={{-79,-30},{-70,-30},{-70,-24},{-60,-24}}, color={0,0,127}));
  connect(ramp1.y, boundaryElectricFrequency.f) annotation (Line(points={{79,0},{62,0}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=300),
    __Dymola_experimentSetupOutput);
end TestTurboGenerator;
