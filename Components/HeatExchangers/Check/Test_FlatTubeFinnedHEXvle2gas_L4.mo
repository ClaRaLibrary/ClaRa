within ClaRa.Components.HeatExchangers.Check;
model Test_FlatTubeFinnedHEXvle2gas_L4 "Test_FlatTubeFinnedHEXvle2gas_L4"
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  inner ClaRa.SimCenter simCenter(redeclare TILMedia.VLEFluid.Types.TILMedia_GERGCO2 fluid1)
    annotation (Placement(transformation(extent={{-120,-106},{-100,-86}})));

  ClaRa.Components.HeatExchangers.FlatTubeFinnedHEXvle2gas_L4 flatTubeFinnedHX(
    HeatExchangerType=2,
    redeclare model HeatTransferInner_a = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=2000),
    redeclare model HeatTransferInner_b = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4 (alpha_nom=150),
    N_passes=3,
    N_cv_a=9,
    N_cv_b=9,
    width=0.53,
    heigth=0.34,
    thickness_tubeWall=0.1e-3,
    length=0.0175,
    diameter_t=1.51e-3,
    h_f=0.0087,
    s_f=0.1e-3,
    t_f=1.8e-3,
    t_l=1.1e-3,
    N_tubes=11,
    frictionAtOutlet_a=true,
    m_nom_a=0.044,
    Delta_p_nom_a=0.25e5,
    Delta_p_nom_b=10,
    frictionAtOutlet_b=true,
    h_start_a=linspace(
        476e3,
        323e3,
        flatTubeFinnedHX.N_cv_a),
    p_start_a=linspace(
        102.85e5,
        102.8e5,
        flatTubeFinnedHX.N_cv_a),
    p_start_b=linspace(
        1.0001e5,
        1e5,
        flatTubeFinnedHX.N_cv_b),
    initOptionTubeWall=213,
    initOptionFinWall=213,
    T_w_tube_start=linspace(
        350,
        350,
        flatTubeFinnedHX.N_cv_a),
    T_w_fin_start=linspace(
        350,
        350,
        flatTubeFinnedHX.N_cv_b)) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi feedwaterOutlet(
    variable_p=false,
    p_const=1e5)                                                                                        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi feedwaterOutlet1(
    variable_p=false,
    h_const=357e3,
    p_const=102.8e5)                                                                                    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,40})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow feedwaterInlet(m_flow_const=2*0.173, T_const=30 + 273.15)
                                                                                                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow feedwaterInlet1(m_flow_const=0.038, h_const=503.4e3)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,40})));
  ClaRa.Visualisation.Quadruple
                          quadruple2(decimalSpaces(m_flow=2), largeFonts=false)
                                                       annotation (Placement(transformation(extent={{28,2},{56,14}})));
  ClaRa.Visualisation.QuadrupleGas
                          quadrupleGas(                       largeFonts=false)
                                                       annotation (Placement(transformation(extent={{-52,-14},{-24,-2}})));
equation

  connect(feedwaterInlet1.steam_a, flatTubeFinnedHX.In_a) annotation (Line(
      points={{-20,30},{-20,20},{-8,20},{-8,10}},
      color={0,131,169},
      thickness=0.5));
  connect(flatTubeFinnedHX.Out_a, feedwaterOutlet1.steam_a) annotation (Line(
      points={{8,9.8},{8,20},{20,20},{20,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(quadruple2.eye, flatTubeFinnedHX.eye1) annotation (Line(points={{28,8},{10,8}}, color={190,190,190}));
  connect(flatTubeFinnedHX.eye2, quadrupleGas.eye) annotation (Line(points={{-10.2,-8},{-52,-8}}, color={190,190,190}));
  connect(feedwaterInlet.gas_a, flatTubeFinnedHX.In_b) annotation (Line(
      points={{20,-30},{20,-20},{8,-20},{8,-10}},
      color={118,106,98},
      thickness=0.5));
  connect(flatTubeFinnedHX.Out_b, feedwaterOutlet.gas_a) annotation (Line(
      points={{-8,-10},{-8,-20},{-20,-20},{-20,-30}},
      color={118,106,98},
      thickness=0.5));
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
>> Tester for the discretised flat tube finned heat exchanger

______________________________________________________________________________________________
")}),
    experiment(
      StopTime=10000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equdistant=false),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end Test_FlatTubeFinnedHEXvle2gas_L4;
