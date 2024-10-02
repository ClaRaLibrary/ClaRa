within ClaRa.Components.HeatExchangers;
model PlateHEXvle2vle_L4 "VLE 2 VLE | L4 | PlateHEX"
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

  import SI = ClaRa.Basics.Units;
  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX01PlateDiscretized;

//  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");

  outer ClaRa.SimCenter simCenter;

  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary=false;
    input ClaRa.Basics.Units.HeatFlowRate Q_flow "Heat flow rate";
    input ClaRa.Basics.Units.TemperatureDifference Delta_T_in "Fluid temperature at inlet T_1_in - T_2_in";
    input ClaRa.Basics.Units.TemperatureDifference Delta_T_out "Fluid temperature at outlet T_1_out - T_2_out";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
  end Summary;

   //*********************************** / General \ ***********************************//
  //________________________________ Fundamentals _______________________________//

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_a=simCenter.fluid1 "Medium to be used  for flow 1"
                                    annotation (Dialog(tab="General", group=
          "Fundamental Definitions"), choicesAllMatching);

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_b=simCenter.fluid1 "Medium to be used for flow 2"
                                   annotation (Dialog(tab="General",group=
          "Fundamental Definitions"), choicesAllMatching);

  parameter Integer HeatExchangerType = 0 "Type of Heat Exchanger"
                                                                  annotation (choices(choice=0 "CounterFlow",choice=1 "ParallelFlow"),Dialog(tab="General",group="Fundamental Definitions"));

  replaceable model HeatTransferInner_a =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBasePlateVLE_L4 "Heat transfer mode of the flow in HX"
                                           annotation (Dialog(tab="Flow_a",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_a =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBasePlateVLE_L4 "Pressure loss model"
      annotation (Dialog(tab="Flow_a",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransferInner_b =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBasePlateVLE_L4 "Heat transfer mode of the flow in HX"
                                           annotation (Dialog(tab="Flow_b",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_b =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBasePlateVLE_L4 "Pressure loss model"
      annotation (Dialog(tab="Flow_b",
        group="Fundamental Definitions"), choicesAllMatching);
//   replaceable model HeatTransferOuter =
//       ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4
//       constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBasePlateVLE_L4 "Heat transfer mode to outside"   annotation (Dialog(tab="General",
//         group="Fundamental Definitions"), choicesAllMatching);

//     model Geometry =
//       ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PlateGeometry_N_cv;
//   inner Geometry geo(
//     N_cv=N_cv,
//     width=width,
//     length=length,
//     thickness_wall=thickness_wall,
//     N_plates=N_plates,
//     amp=amp,
//     length_wave=length_wave,
//     phi=phi)         annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

   //________________________________ Geometry _______________________________//
  parameter ClaRa.Basics.Units.Length width=1 "Plate width"  annotation (Dialog(tab="General", group="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX01PlateGeometry_ParameterDialog.png"));
  parameter ClaRa.Basics.Units.Length length=1 "Plate length" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length thickness_wall=0.01 "Wall thickness of the plate" annotation (Dialog(tab="General", group="Geometry"));
  parameter Integer N_plates(min=3)=4 "Number of tubes in parallel" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length amp(min=1e-10) = 0.001 "Amplitude of corrugated plate" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length length_wave(min=1e-10) = 2*Modelica.Constants.pi*amp "Wave length of corrugated plate" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Angle phi = 60*Modelica.Constants.pi/180 "Corrugation angle" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_a=length/2 "Inlet position from bottom for flow_a" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_a=length/2 "Outlet position from bottom for flow_a" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_b=length/2 "Inlet position from bottom for flow_b" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_b=length/2 "Outlet position from bottom for flow_b" annotation (Dialog(tab="General", group="Geometry"));
  parameter Real CF_geo[2]=ones(2) "Correction factor for heat transfer area dedicated to surfuca of: 1|flow_a 2|flow_b " annotation (Dialog(tab="General", group="Geometry"));
  parameter Integer N_cv=3 "Number of Cells" annotation (Dialog(tab="General",group="Geometry"));

  //________________________________ Flow_A Fundamental Definitions _____________________________________//
  parameter Boolean frictionAtInlet_a=false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_a",group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet_a=false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_a",group="Fundamental Definitions"));

  //________________________________ Flow_A nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_nom_a=1 "Nominal mass flow on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
  parameter SI.Pressure p_nom_a[N_cv]=1e5*ones(N_cv) "Nominal pressure on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
  parameter SI.EnthalpyMassSpecific h_nom_a[N_cv]=85e3*ones(N_cv) "Nominal specific enthalpy on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
 parameter SI.Pressure Delta_p_nom_a=1000 "Nominal pressure loss on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));

  //________________________________ Flow_b nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_nom_b=1 "Nominal mass flow on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
  parameter SI.Pressure p_nom_b[N_cv]=1e5*ones(N_cv) "Nominal pressure on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
  parameter SI.EnthalpyMassSpecific h_nom_b[N_cv]=85e3*ones(N_cv) "Nominal specific enthalpy on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
    parameter SI.Pressure Delta_p_nom_b=1000 "Nominal pressure loss on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));

  //________________________________ Flow_b Fundamental Definitions _____________________________________//
  parameter Boolean frictionAtInlet_b=false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_b",group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet_b=false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_b",group="Fundamental Definitions"));

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Aluminum
    constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Fundamental Definitions"));
  parameter SI.Mass mass_struc=0 "Additional to mass of the plate HX calculated by density*length*width*thicknesswall" annotation (Dialog(tab="Wall", group="Fundamental Definitions"));

  //________________________________ Initialisation general _______________________________________//
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "true, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation"));

  //________________________________ Flow_a initialisation  _______________________________________//
  inner parameter Integer initOption_a=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation", group="Flow_a"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                              choice = 202 "Steady enthalpy"));
  parameter SI.EnthalpyMassSpecific h_start_a[N_cv]=85e3*ones(N_cv) "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation", group="Flow_a"));
  parameter SI.Pressure p_start_a[N_cv]=1e5*ones(N_cv) "Start value of sytsem pressure"
    annotation (Dialog(tab="Initialisation", group="Flow_a"));
  parameter SI.MassFraction xi_start_a[medium_a.nc - 1]=zeros(medium_a.nc - 1) "Initial composition for flow_a" annotation (Dialog(tab="Initialisation", group="Flow_a"));

  //________________________________ Flow_b initialisation _______________________________________//
  parameter Integer initOption_b=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation", group="Flow_b"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                            choice = 202 "Steady enthalpy"));
  parameter SI.EnthalpyMassSpecific h_start_b[N_cv]=85e3*ones(N_cv) "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation", group="Flow_b"));
  parameter SI.Pressure p_start_b[N_cv]=1e5*ones(N_cv) "Start value of sytsem pressure"
    annotation (Dialog(tab="Initialisation", group="Flow_b"));
  parameter SI.MassFraction xi_start_b[medium_b.nc - 1]=zeros(medium_b.nc - 1) "Initial composition for flow_b" annotation (Dialog(tab="Initialisation", group="Flow_b"));

  //________________________________ Wall initialisation _______________________________________//
  parameter Integer initOptionWall=0 "|Initialisation option for wall"    annotation (Dialog(tab="Initialisation", group="Wall"), choices(
      choice=213 "Fixed temperature",
      choice=1 "Steady state",
      choice=203 "Steady temperature",
      choice=0 "No init, use T_start as guess values"));
  parameter SI.Temperature T_w_start[N_cv]=293.15*ones(N_cv) "Initial wall temperature" annotation (Dialog(tab="Initialisation", group="Wall"));

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In_b(Medium=medium_b) annotation (Placement(transformation(extent={{70,-110},{90,-90}}),iconTransformation(extent={{70,-110},{90,-90}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out_b(Medium=medium_b) annotation (Placement(transformation(extent={{70,90},{90,110}}),    iconTransformation(extent={{70,90},{90,110}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out_a(Medium=medium_a) annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In_a(Medium=medium_a) annotation (Placement(transformation(extent={{-90,90},{-70,110}})));

//   HeatTransferOuter heatTransferOuter(A_heat=geo.A_heat_CF[:, 2]) "Outer heat transfer model" annotation (Placement(transformation(extent={{-60,58},{-40,78}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4 flow_a(
    frictionAtInlet=frictionAtInlet_a,
    frictionAtOutlet=frictionAtOutlet_a,
    useHomotopy=useHomotopy,
    h_start=h_start_a,
    p_start=p_start_a,
    redeclare model HeatTransfer = HeatTransferInner_a,
    redeclare model PressureLoss = PressureLoss_a,
    initOption=initOption_a,
    showExpertSummary=true,
    showData=true,
    medium=medium_a,
    p_nom=p_nom_a,
    h_nom=h_nom_a,
    m_flow_nom=m_nom_a,
    Delta_p_nom=Delta_p_nom_a,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PlateGeometry_N_cv (
        z_in=z_in_a,
        z_out=z_out_a,
        N_cv=N_cv,
        width=width,
        length=length,
        thickness_wall=thickness_wall,
        N_plates=N_plates,
        CF_geo={CF_geo[1],1},
        amp=amp,
        length_wave=length_wave,
        phi=phi)) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={-80,0})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4 flow_b(
    frictionAtInlet=frictionAtInlet_b,
    frictionAtOutlet=frictionAtOutlet_b,
    useHomotopy=useHomotopy,
    h_start=h_start_b,
    p_start=p_start_b,
    redeclare model HeatTransfer = HeatTransferInner_b,
    redeclare model PressureLoss = PressureLoss_b,
    initOption=initOption_b,
    showExpertSummary=true,
    showData=true,
    medium=medium_b,
    p_nom=p_nom_b,
    h_nom=h_nom_b,
    m_flow_nom=m_nom_b,
    Delta_p_nom=Delta_p_nom_b,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PlateGeometry_N_cv (
        z_in=z_in_b,
        z_out=z_out_b,
        N_cv=N_cv,
        width=width,
        length=length,
        thickness_wall=thickness_wall,
        N_plates=N_plates,
        CF_geo={CF_geo[2],1},
        amp=amp,
        length_wave=length_wave,
        phi=phi)) annotation (Placement(transformation(
        extent={{14,5},{-14,-5}},
        rotation=270,
        origin={80,0})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 thinWall(
    redeclare model Material = WallMaterial,
    length=length,
    width=width,
    mass_struc=mass_struc,
    N_pathes=N_plates,
    T_start=T_w_start,
    N_ax=N_cv,
    initOption=initOptionWall,
    thickness_wall=thickness_wall) annotation (Placement(transformation(extent={{-10,-8},{10,8}},
        rotation=90,
        origin={0,0})));

  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=sum(flow_a.heat.Q_flow),
      Delta_T_in=flow_a.summary.inlet.T - flow_b.summary.inlet.T,
      Delta_T_out=flow_a.summary.outlet.T - flow_b.summary.outlet.T)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-94})));

protected
   ClaRa.Basics.Interfaces.EyeIn
                           eye_int2
     annotation (Placement(transformation(extent={{-1,-1},{1,1}},
        rotation=270,
        origin={84,80})));
public
   ClaRa.Basics.Interfaces.EyeOut
                            eye2 if showData annotation (Placement(
         transformation(
         extent={{-10,-10},{10,10}},
         rotation=0,
         origin={100,80}),   iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={102,80})));
protected
   ClaRa.Basics.Interfaces.EyeIn
                           eye_int1
     annotation (Placement(transformation(extent={{-85,-81},{-83,-79}})));
public
   ClaRa.Basics.Interfaces.EyeOut
                            eye1 if showData annotation (Placement(transformation(
        extent={{-100,10},{-120,30}},
        rotation=0,
        origin={10,-100}),
                       iconTransformation(
        extent={{-100,10},{-120,30}},
        rotation=0,
        origin={10,-100})));
//   ClaRa.Components.BoundaryConditions.PrescribedHeatFlowScalar prescribedHeatFlowScalar[N_cv] annotation (Placement(transformation(extent={{10,-10},{-10,10}},
//         rotation=90,
//         origin={0,36})));

//   ClaRa.Basics.Interfaces.HeatPort_a heatOuter[N_cv] annotation (Placement(transformation(extent={{-10,88},{10,108}}),iconTransformation(
//         extent={{-10,-10},{10,10}},
//         rotation=90,
//         origin={-4,92})));
//
//       inner ClaRa.Basics.Records.IComVLE_L3_OnePort iCom(
//         N_cv=N_cv,
//         volume=geo.volume,
//         p_in={flow_a.inlet.p},
//         T_in={flow_a.fluidInlet.T},
//         m_flow_in={flow_a.inlet.m_flow},
//         p_out={flow_a.outlet.p},
//         T_out={flow_a.fluidOutlet.T},
//         m_flow_out={flow_a.outlet.m_flow},
//         T=flow_a.fluid.T,
//         p=flow_a.p,
//         p_nom=flow_a.p_nom[1],
//         Delta_p_nom=flow_a.Delta_p_nom,
//         m_flow_nom=flow_a.m_flow_nom,
//         h_nom=flow_a.h_nom[1],
//         mediumModel=flow_a.medium,
//         fluidPointer_in={flow_a.fluidInlet.vleFluidPointer},
//         fluidPointer_out={flow_a.fluidOutlet.vleFluidPointer},
//         h=flow_a.h,
//         fluidPointer=flow_a.fluid.vleFluidPointer,
//         h_in={flow_a.fluidInlet.h},
//         h_out={flow_a.fluidOutlet.h})                    annotation (Placement(transformation(extent={{0,-103},{20,-85}})));

equation
//   // handing over heat flow to inner volume model
//    for i in 1:N_cv loop
//     prescribedHeatFlowScalar[i].Q_flow = heatOuter[i].Q_flow;
//    end for;

    //data exchange with heat transfer model
//   heatTransferOuter.m_flow = ones(N_cv+1)*(flow_a.inlet.m_flow+flow_b.inlet.m_flow)/2;//Dummy

  connect(eye_int2,eye2)  annotation (Line(points={{84,80},{100,80}},                color={190,190,190}));
  connect(eye_int1,eye1)  annotation (Line(points={{-84,-80},{-100,-80}},                color={190,190,190}));

//   for i in 1:N_cv loop
//     connect(flow_a.heat[N_cv+1-i],thinWall[i].outerPhase);
//   end for;

   eye_int1.m_flow=-flow_a.outlet.m_flow;
   eye_int1.T=flow_a.summary.outlet.T-273.15;
   eye_int1.s=flow_a.fluidOutlet.s/1000;
   eye_int1.h=flow_a.summary.outlet.h/1000;
   eye_int1.p=flow_a.summary.outlet.p/100000;

   eye_int2.m_flow=-flow_b.outlet.m_flow;
   eye_int2.T=flow_b.summary.outlet.T-273.15;
   eye_int2.s=flow_b.fluidOutlet.s/1000;
   eye_int2.h=flow_b.summary.outlet.h/1000;
   eye_int2.p=flow_b.summary.outlet.p/100000;

  for i in 1:N_cv loop
    if HeatExchangerType == 0 then
      connect(thinWall.outerPhase[i], flow_a.heat[N_cv+1-i])   annotation (Line(
      points={{-8,4.44089e-16},{-8,0},{-76,0},{-76,-6.66134e-16}},
      color={167,25,48},
      thickness=0.5));
    else
      connect(thinWall.outerPhase, flow_a.heat);
    end if;
  end for;
  connect(flow_b.heat, thinWall.innerPhase) annotation (Line(
      points={{76,6.66134e-16},{76,0},{24,0},{24,-4.44089e-16},{8,-4.44089e-16}},
      color={167,25,48},
      thickness=0.5));
  connect(flow_b.outlet, Out_b) annotation (Line(
      points={{80,14},{80,100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flow_b.inlet, In_b) annotation (Line(
      points={{80,-14},{80,-100}},
      color={0,131,169},
      thickness=0.5));
  connect(flow_a.inlet, In_a) annotation (Line(
      points={{-80,14},{-80,100}},
      color={0,131,169},
      thickness=0.5));
  connect(flow_a.outlet, Out_a) annotation (Line(
      points={{-80,-14},{-80,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
//   connect(prescribedHeatFlowScalar.port, flow_a.heat) annotation (Line(
//       points={{-4.44089e-16,26},{-4.44089e-16,20},{-40,20},{-40,-6.66134e-16},{-76,-6.66134e-16}},
//       color={167,25,48},
//       thickness=0.5));
//   connect(heatTransferOuter.heat, heatOuter) annotation (Line(
//       points={{-41,77},{0,77},{0,98}},
//       color={167,25,48},
//       thickness=0.5));

//   for i in 1:N_cv loop
//   connect(prescribedHeatFlowScalar[i].port, flow_b.heat[N_cv+1-i]) annotation (Line(
//       points={{-6.66134e-16,26},{-6.66134e-16,20},{40,20},{40,6.66134e-16},{76,6.66134e-16}},
//       color={167,25,48},
//       thickness=0.5));
//   end for;
    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
ClaRa development team, Copyright &copy; 2017 - 2022.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p> This component was developed for ClaRa library.</p>
<p><b>Acknowledgements:</b> </p>
<p><b>CLA:</b> </p>

</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics), Diagram(graphics));
end PlateHEXvle2vle_L4;
