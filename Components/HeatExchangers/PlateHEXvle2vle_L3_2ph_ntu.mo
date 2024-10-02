within ClaRa.Components.HeatExchangers;
model PlateHEXvle2vle_L3_2ph_ntu "VLE 2 VLE | L2 | PlateHEX NTU"
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
  extends ClaRa.Basics.Icons.HEX01Plate;

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

  replaceable model HeatExchangerType =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CrossFlow_L3
      constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger_L3 "Type of Heat Exchanger"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model HeatTransferInner_a =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBasePlateVLE_L2 "Heat transfer mode of the flow in HX"
                                           annotation (Dialog(tab="Flow_a",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_a =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBasePlateVLE_L2 "Pressure loss model"
      annotation (Dialog(tab="Flow_a",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransferInner_b =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBasePlateVLE_L2 "Heat transfer mode of the flow in HX"
                                           annotation (Dialog(tab="Flow_b",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_b =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBasePlateVLE_L2 "Pressure loss model"
      annotation (Dialog(tab="Flow_b",
        group="Fundamental Definitions"), choicesAllMatching);

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

  //________________________________ Flow_A Fundamental Definitions _____________________________________//
  parameter Boolean frictionAtInlet_a=false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_a",group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet_a=false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_a",group="Fundamental Definitions"));

  //________________________________ Flow_A nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_nom_a=1 "Nominal mass flow on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
  parameter SI.Pressure p_nom_a=1e5 "Nominal pressure on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
  parameter SI.EnthalpyMassSpecific h_nom_a=85e3 "Nominal specific enthalpy on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
 parameter SI.Pressure Delta_p_nom_a=1000 "Nominal pressure loss on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));

  //________________________________ Flow_b nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_nom_b=1 "Nominal mass flow on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
  parameter SI.Pressure p_nom_b=1e5 "Nominal pressure on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
  parameter SI.EnthalpyMassSpecific h_nom_b=85e3 "Nominal specific enthalpy on tube side"
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
  parameter SI.EnthalpyMassSpecific h_start_a=85e3 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation", group="Flow_a"));
  parameter SI.Pressure p_start_a=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Initialisation", group="Flow_a"));
  parameter SI.MassFraction xi_start_a[medium_a.nc - 1]=zeros(medium_a.nc - 1) "Initial composition for flow_a" annotation (Dialog(tab="Initialisation", group="Flow_a"));

  //________________________________ Flow_b initialisation _______________________________________//
  parameter Integer initOption_b=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation", group="Flow_b"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                            choice = 202 "Steady enthalpy"));
  parameter SI.EnthalpyMassSpecific h_start_b=85e3 "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation", group="Flow_b"));
  parameter SI.Pressure p_start_b=1e5 "Start value of sytsem pressure"
    annotation (Dialog(tab="Initialisation", group="Flow_b"));
  parameter SI.MassFraction xi_start_b[medium_b.nc - 1]=zeros(medium_b.nc - 1) "Initial composition for flow_b" annotation (Dialog(tab="Initialisation", group="Flow_b"));

  //________________________________ Wall initialisation _______________________________________//
  parameter Integer initOptionWall=0 "|Initialisation option for wall"    annotation (Dialog(tab="Initialisation", group="Wall"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature",
      choice=204 "Fixed temperatures"));
  parameter SI.Temperature T_w_a_start[3]=ones(3)*293.15 "Initial wall temperature flow_a side" annotation (Dialog(tab="Initialisation", group="Wall"));
  parameter SI.Temperature T_w_b_start[3]=ones(3)*293.15 "Initial wall temperature flow_b side" annotation (Dialog(tab="Initialisation", group="Wall"));
  parameter Integer initOption_yps=3 "Volumetric initialisation" annotation (Dialog(tab="Initialisation", group="Wall"),choices(choice = 1 "Integrator state at zero",
                                                                                                    choice=2 "Steady state",
                                                                                                    choice=3 "Apply guess value y_start at output",
                                                                                                    choice=4 "Force y_start at output"));
  parameter Real yps_start[2]={0.33,0.33} "Initial area fraction 1phase | 2phase " annotation (Dialog(tab="Initialisation", group="Wall"));
  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  replaceable model HeatCapacityAveraging =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.ArithmeticMean
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.GeneralMean
                                                                                              "Method for Averaging of heat capacities"
    annotation (Dialog(tab="Expert Settings", group="NTU model"),choicesAllMatching);
  parameter Real gain_eff=1 "Avoid effectiveness > 1, high gain_eff leads to stricter observation but may cause numeric errors"
                                                                                              annotation (Dialog(tab="Expert Settings", group="NTU model"));
  parameter ClaRa.Basics.Units.Time Tau_stab=0.1 "Time constant for numeric stabilisation w.r.t. heat flow rates" annotation (Dialog(tab="Expert Settings", group="NTU model"));
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.FluidPortIn In_b(Medium=medium_b) annotation (Placement(transformation(extent={{70,-110},{90,-90}}),iconTransformation(extent={{70,-110},{90,-90}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out_b(Medium=medium_b) annotation (Placement(transformation(extent={{70,90},{90,110}}),    iconTransformation(extent={{70,90},{90,110}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out_a(Medium=medium_a) annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  ClaRa.Basics.Interfaces.FluidPortIn In_a(Medium=medium_a) annotation (Placement(transformation(extent={{-90,90},{-70,110}})));

  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 flow_a(
    useHomotopy=useHomotopy,
    h_start=h_start_a,
    p_start=p_start_a,
    redeclare model HeatTransfer = HeatTransferInner_a,
    redeclare model PressureLoss = PressureLoss_a,
    xi_start=xi_start_a,
    initOption=initOption_a,
    showExpertSummary=true,
    medium=medium_a,
    p_nom=p_nom_a,
    h_nom=h_nom_a,
    m_flow_nom=m_nom_a,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PlateGeometry (
        z_in={z_in_a},
        z_out={z_out_a},
        width=width,
        length=length,
        thickness_wall=thickness_wall,
        N_plates=N_plates,
        CF_geo={CF_geo[1],1},
        amp=amp,
        length_wave=length_wave,
        phi=phi)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,0})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L2 flow_b(
    xi_start=xi_start_b,
    useHomotopy=useHomotopy,
    h_start=h_start_b,
    p_start=p_start_b,
    redeclare model HeatTransfer = HeatTransferInner_b,
    redeclare model PressureLoss = PressureLoss_b,
    initOption=initOption_b,
    showExpertSummary=true,
    medium=medium_b,
    p_nom=p_nom_b,
    h_nom=h_nom_b,
    m_flow_nom=m_nom_b,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PlateGeometry (
        z_in={z_in_b},
        z_out={z_out_b},
        width=width,
        length=length,
        thickness_wall=thickness_wall,
        N_plates=N_plates,
        CF_geo={CF_geo[2],1},
        amp=amp,
        length_wave=length_wave,
        phi=phi)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,0})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_plate_L3_standalone thinWall(
    medium_a=medium_a,
    medium_b=medium_b,
    redeclare replaceable model Material = WallMaterial,
    outerPhaseChange=true,
    redeclare model HeatExchangerType = HeatExchangerType,
    length=length,
    width=width,
    N_plates=N_plates,
    mass_struc=mass_struc,
    A_heat=(flow_a.geo.A_heat_CF[flow_a.heatSurfaceAlloc] + flow_b.geo.A_heat_CF[flow_b.heatSurfaceAlloc])/2,
    T_w_i_start=T_w_b_start,
    initOption=initOptionWall,
    thickness_wall=thickness_wall,
    T_w_o_start=T_w_a_start,
    initOption_yps=initOption_yps,
    yps_start=yps_start,
    redeclare model HeatCapacityAveraging = HeatCapacityAveraging,
    gain_eff=gain_eff,
    Tau_stab=Tau_stab,
    showExpertSummary=showExpertSummary,
    p_o=flow_a.inlet.p,
    p_i=flow_b.outlet.p,
    h_i_inlet=inStream(flow_b.inlet.h_outflow),
    h_o_inlet=inStream(flow_a.inlet.h_outflow),
    m_flow_i=flow_b.inlet.m_flow,
    m_flow_o=flow_a.inlet.m_flow,
    xi_i=inStream(flow_b.inlet.xi_outflow),
    xi_o=inStream(flow_a.inlet.xi_outflow),
    alpha_i=ones(3)*flow_b.heattransfer.alpha,
    alpha_o=ones(3)*flow_a.heattransfer.alpha) annotation (Placement(transformation(
        extent={{-10,-8},{10,8}},
        rotation=90,
        origin={0,0})));

  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=flow_a.heat.Q_flow,
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

equation

  connect(eye_int2,eye2)  annotation (Line(points={{84,80},{100,80}},                color={190,190,190}));
  connect(eye_int1,eye1)  annotation (Line(points={{-84,-80},{-100,-80}},                color={190,190,190}));

   eye_int1.m_flow=-flow_a.outlet.m_flow;
   eye_int1.T=flow_a.summary.outlet.T-273.15;
   eye_int1.s=flow_a.fluidOut.s/1000;
   eye_int1.h=flow_a.summary.outlet.h/1000;
   eye_int1.p=flow_a.summary.outlet.p/100000;

   eye_int2.m_flow=-flow_b.outlet.m_flow;
   eye_int2.T=flow_b.summary.outlet.T-273.15;
   eye_int2.s=flow_b.fluidOut.s/1000;
   eye_int2.h=flow_b.summary.outlet.h/1000;
   eye_int2.p=flow_b.summary.outlet.p/100000;

  connect(flow_a.inlet, In_a) annotation (Line(
      points={{-80,10},{-80,100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flow_a.outlet, Out_a) annotation (Line(
      points={{-80,-10},{-80,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flow_b.outlet, Out_b) annotation (Line(
      points={{80,10},{80,100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flow_b.inlet, In_b) annotation (Line(
      points={{80,-10},{80,-100}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(thinWall.outerPhase[1], flow_a.heat) annotation (Line(
      points={{-6.93333,4.44089e-16},{-70,-1.77636e-15}},
      color={167,25,48},
      thickness=0.5));
  connect(thinWall.outerPhase[2], flow_a.heat) annotation (Line(
      points={{-7.2,4.44089e-16},{-70,-1.77636e-15}},
      color={167,25,48},
      thickness=0.5));
  connect(thinWall.outerPhase[3], flow_a.heat) annotation (Line(
      points={{-7.46667,4.44089e-16},{-70,-1.77636e-15}},
      color={167,25,48},
      thickness=0.5));
  connect(thinWall.innerPhase[1], flow_b.heat) annotation (Line(
      points={{7.46667,-4.44089e-16},{70,5.55112e-16}},
      color={167,25,48},
      thickness=0.5));
  connect(thinWall.innerPhase[2], flow_b.heat) annotation (Line(
      points={{7.2,-4.44089e-16},{70,5.55112e-16}},
      color={167,25,48},
      thickness=0.5));
  connect(thinWall.innerPhase[3], flow_b.heat) annotation (Line(
      points={{6.93333,-4.44089e-16},{70,5.55112e-16}},
      color={167,25,48},
      thickness=0.5));
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
                   graphics={Text(
          extent={{-86,78},{86,38}},
          lineColor={27,36,42},
          textString="NTU")}));
end PlateHEXvle2vle_L3_2ph_ntu;
