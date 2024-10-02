within ClaRa.Components.HeatExchangers.Check;
model Test_PlateHEXvle2vle_L3_2ph_ntu "Test_PlateHEXvle2vle_L2"
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  inner ClaRa.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_GERGCO2 fluid1)                                                                               annotation (Placement(transformation(extent={{-120,-106},{-100,-86}})));

  ClaRa.Components.HeatExchangers.PlateHEXvle2vle_L3_2ph_ntu plateHEX(
    medium_b=simCenter.fluid2,
    redeclare model HeatTransferInner_a = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=2000),
    redeclare model HeatTransferInner_b = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=300),
    width=0.1,
    thickness_wall=0.75e-3,
    N_plates=50,
    length=0.3,
    amp=2e-3,
    phi=35*Modelica.Constants.pi/180,
    frictionAtOutlet_a=true,
    m_nom_a=0.038,
    p_nom_a=40e5,
    h_nom_a=400e3,
    Delta_p_nom_a=100,
    m_nom_b=0.166,
    frictionAtOutlet_b=true,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    h_start_a=350e3,
    p_start_a=43.5e5,
    redeclare model HeatCapacityAveraging = ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.InputOnly) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi feedwaterOutlet(
    medium=simCenter.fluid2,
    variable_p=false,
    h_const=80e3,
    p_const=1e5)                                                                                        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi feedwaterOutlet1(
    variable_p=false,
    h_const=450e3,
    p_const=43.3e5)                                                                                     annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow feedwaterInlet(
    medium=simCenter.fluid2,
    m_flow_const=0.166,
    T_const=25 + 273.15)                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={52,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow feedwaterInlet1(m_flow_const=0.038, h_const=357e3)    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,40})));
  ClaRa.Visualisation.Quadruple
                          quadruple2(decimalSpaces(m_flow=2), largeFonts=false)
                                                       annotation (Placement(transformation(extent={{-52,-14},{-24,-2}})));
  ClaRa.Visualisation.Quadruple
                          quadruple1(decimalSpaces(m_flow=2), largeFonts=false)
                                                       annotation (Placement(transformation(extent={{18,2},{46,14}})));
equation

  connect(plateHEX.Out_b, feedwaterOutlet.steam_a) annotation (Line(
      points={{8,10},{8,40},{40,40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedwaterInlet.steam_a, plateHEX.In_b) annotation (Line(
      points={{42,-40},{8,-40},{8,-10}},
      color={0,131,169},
      thickness=0.5));
  connect(feedwaterInlet1.steam_a, plateHEX.In_a) annotation (Line(
      points={{-40,40},{-8,40},{-8,10}},
      color={0,131,169},
      thickness=0.5));
  connect(plateHEX.Out_a, feedwaterOutlet1.steam_a) annotation (Line(
      points={{-8,-10},{-8,-40},{-40,-40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple2.eye, plateHEX.eye1) annotation (Line(points={{-52,-8},{-10,-8}}, color={190,190,190}));
  connect(plateHEX.eye2, quadruple1.eye) annotation (Line(points={{10.2,8},{18,8}}, color={190,190,190}));
  annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{140,100}},
          preserveAspectRatio=true), graphics={
                                  Text(
          extent={{-118,106},{80,66}},
          lineColor={0,128,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="______________________________________________________________________________________________
PURPOSE:
>> Tester for the NTU plate heat exchanger

______________________________________________________________________________________________
")}),
    experiment(
      StopTime=10000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end Test_PlateHEXvle2vle_L3_2ph_ntu;
