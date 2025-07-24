within ClaRa.Components.MechanicalSeparation.Check;
model TestDrum "Initialisation of a natural circulation with drum and evaporator"

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
  ClaRa.Components.MechanicalSeparation.Drum_L3 drum(
    diameter=1,
    length=10,
    z_feed=5,
    z_sat=9,
    level_rel_start=0.5,
    h_liq_start=source.h_const,
    h_vap_start=sink.h_const,
    p_start=sink.p_const,
    p_nom=sink.p_const,
    levelOutput=true,
    outputAbs=false,
    showLevel=true,
    showData=true,
    initOption=204,
    z_risers={8,0,0},
    z_downs={1,0,0}) annotation (Placement(transformation(extent={{-30,-40},{30,-20}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow source(h_const=1500e3, m_flow_const=7.1)
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi sink(p_const=150e5, h_const=2500e3) annotation (Placement(transformation(extent={{-78,8},{-58,28}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 evaporator(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    length=2,
    diameter=0.02,
    N_tubes=1,
    N_passes=40,
    m_flow_nom=sink.m_flow_nom,
    p_nom=sink.p_const,
    h_nom=sink.h_const,
    h_start=source.h_const,
    p_start=sink.p_const,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=10000),
    initOption=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={6,-78})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         fixedTemperature
    annotation (Placement(transformation(extent={{42,-88},{22,-68}})));
  inner ClaRa.SimCenter simCenter(redeclare TILMedia.VLEFluid.Types.TILMedia_Water fluid1, useHomotopy=true)
    annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                  Delta_p_nom=10e5, m_flow_nom=10)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={-18,-2})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valve_2(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                                  Delta_p_nom=10e5, m_flow_nom=10)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=180,
        origin={52,-30})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    offset=500 + 273.15,
    height=-100,
    startTime=400) annotation (Placement(transformation(extent={{82,-89},{62,-67}})));
equation
  connect(evaporator.heat, fixedTemperature.port) annotation (Line(
      points={{16,-78},{22,-78}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sink.steam_a, valve_1.outlet) annotation (Line(
      points={{-58,18},{-18,18},{-18,8}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_1.inlet, drum.sat) annotation (Line(
      points={{-18,-12},{-18,-20}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(source.steam_a, valve_2.inlet) annotation (Line(
      points={{80,-30},{62,-30}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_2.outlet, drum.feed) annotation (Line(
      points={{42,-30},{30,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, fixedTemperature.T) annotation (Line(
      points={{61,-78},{44,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaporator.inlet, drum.down_1) annotation (Line(
      points={{6,-68},{6,-40}},
      color={0,131,169},
      thickness=0.5));
  connect(evaporator.outlet, drum.riser_1) annotation (Line(
      points={{6,-88},{6,-96},{-26,-96},{-26,-40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (                          Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                   Text(
          extent={{-100,94},{100,42}},
          lineColor={0,128,0},
          lineThickness=0.5,
          fillColor={102,198,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="_____________________________________________________
PURPOSE:
1. Initialisation of natural circulation with drum and evaporator.
2. Behaviour in case of disturbance (sudden temp. decrease)
_____________________________________________________
HAVE A LOOK AT:
Look at filling level, steam qualities and circulation rate")}),
                                                   Icon(graphics,
                                                        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(StopTime=800),
    __Dymola_experimentSetupOutput);
end TestDrum;
