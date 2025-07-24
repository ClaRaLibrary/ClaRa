within ClaRa.Visualisation.Check;
model TestStatePoint
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
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_XRG(
    variable_h=true,
    m_flow_const=0,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-76,-22})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_XRG(p_const=5100000) annotation (Placement(transformation(extent={{14,-42},{-6,-22}})));
  Modelica.Blocks.Sources.Step MassFlowRate(
    height=-0.02,
    startTime=50,
    offset=300)     annotation (Placement(transformation(extent={{-90,12},{-70,
            32}},     rotation=0)));
  Modelica.Blocks.Sources.Step InSpecEnthalpy(
    startTime=1,
    height=300e3,
    offset=3000e3)
                 annotation (Placement(transformation(extent={{-90,50},{-70,70}},
                  rotation=0)));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{70,76},{90,96}})));
  StatePoint_ph statePoint_ph
    annotation (Placement(transformation(extent={{-44,-12},{-36,-4}})));
  StatePoint_phTs statePoint_phTs
    annotation (Placement(transformation(extent={{-24,-12},{-12,2}})));
equation
  connect(InSpecEnthalpy.y,massFlowSource_XRG. h) annotation (Line(
      points={{-69,60},{-66,60},{-66,0},{-76,0},{-76,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlowRate.y, massFlowSource_XRG.m_flow) annotation (Line(
      points={{-69,22},{-58,22},{-58,-6},{-70,-6},{-70,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(massFlowSource_XRG.steam_a, pressureSink_XRG.steam_a) annotation (Line(
      points={{-76,-32},{-6,-32},{-6,-32}},
      color={0,131,169},
      thickness=0.5));
  connect(massFlowSource_XRG.steam_a, statePoint_ph.port) annotation (Line(
      points={{-76,-32},{-44,-32},{-44,-12}},
      color={0,131,169},
      thickness=0.5));
  connect(massFlowSource_XRG.steam_a, statePoint_phTs.port) annotation (Line(
      points={{-76,-32},{-50,-32},{-24,-32},{-24,-12}},
      color={0,131,169},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), experiment(StopTime=60));
end TestStatePoint;
