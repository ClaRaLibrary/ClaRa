within ClaRa.Components.BoundaryConditions.Check;
model TestIAPWSboundaries2
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb60;
  inner SimCenter simCenter(redeclare replaceable TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.CombiTimeTable ramp(table=[0,5; 1,5; 2,-5; 3,-5; 3.1,
        10; 4,10], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-92,14},{-72,34}})));
  Modelica.Blocks.Sources.CombiTimeTable ramp1(extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,
        2e5; 0.5,2e5; 2,5e5; 3,5e5; 3.1,3e5; 4,3e5])
    annotation (Placement(transformation(extent={{18,-66},{38,-46}})));
  BoundaryVLE_hxim_flow massFlowSource_T(variable_m_flow=true, energyType=1) annotation (Placement(transformation(extent={{-52,-20},{-32,0}})));
  BoundaryVLE_phxi pressureSink_pT(
    variable_p=true,
    Delta_p=1000,
    energyType=1) annotation (Placement(transformation(extent={{60,-20},{38,0}})));
equation
  connect(ramp1.y[1], pressureSink_pT.p) annotation (Line(
      points={{39,-56},{78,-56},{78,-4},{60,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_T.m_flow, ramp.y[1]) annotation (Line(
      points={{-54,-4},{-64,-4},{-64,24},{-71,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pressureSink_pT.steam_a, massFlowSource_T.steam_a) annotation (Line(
      points={{38,-10},{-32,-10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(graphics), experiment(StopTime=10));
end TestIAPWSboundaries2;
