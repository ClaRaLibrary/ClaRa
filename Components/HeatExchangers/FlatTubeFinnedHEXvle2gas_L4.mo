within ClaRa.Components.HeatExchangers;
model FlatTubeFinnedHEXvle2gas_L4 "VLE 2 Gas | L4 | FlatTubeFinnedHEX"
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

  import SI = ClaRa.Basics.Units;
  // Extends from... ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  extends ClaRa.Basics.Icons.HEX01FlatTubeFinnedDiscretized;

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

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid medium_a=simCenter.fluid1 "Medium to be used  for flow 1"
    annotation (Dialog(tab="General", group="Fundamental Definitions"), choicesAllMatching);

  parameter TILMedia.Gas.Types.BaseGas medium_b=simCenter.flueGasModel "Medium to be used for flow 2"
    annotation (Dialog(tab="General", group="Fundamental Definitions"), choicesAllMatching);

  parameter Integer HeatExchangerType = 0 "Type of Heat Exchanger"
                                                                  annotation (choices(choice=0 "CounterFlow",choice=1 "ParallelFlow", choice=2 "CrossFlow"),Dialog(tab="General",group="Fundamental Definitions"));

  replaceable model HeatTransferInner_a =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4 "Heat transfer mode of the flow in HX"
                                           annotation (Dialog(tab="Flow_a",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_a =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model"
      annotation (Dialog(tab="Flow_a",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model HeatTransferInner_b =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseFlatTubeFinnedGas_L4 "Heat transfer mode of the flow in HX"
                                           annotation (Dialog(tab="Flow_b",
        group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss_b =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
      constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseFlatTubeFinnedGas_L4 "Pressure loss model"
      annotation (Dialog(tab="Flow_b",
        group="Fundamental Definitions"), choicesAllMatching);

   //________________________________ Geometry _______________________________//
  parameter Boolean equalNumberOfPasses=true  "True, if number of pasees for both flows are equal" annotation (Dialog(tab="General", group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of tubes (N_passes_a). If equalNumberOfPasses=true then N_passes_b = N_passes  else N_passes_b=1. "
                                                                                                                                                    annotation (Dialog(tab="General", group="Geometry"));
  final parameter Integer N_passes_a=N_passes "Number of passes for flow_a"
                                                                           annotation (Dialog(tab="General", group="Geometry", enable=not equalNumberOfPasses));
  final parameter Integer N_passes_b=if equalNumberOfPasses then N_passes else 1 "Number of passes for flow_b"
                                                                                                              annotation (Dialog(tab="General", group="Geometry", enable=not equalNumberOfPasses));

//   parameter Integer N_cvPerPass_a=3 "Number of cells for flow_a per pass" annotation (Dialog(tab="General",group="Geometry"));
//   parameter Integer N_cvPerPass_b=3 "Number of cells for flow_b per pass" annotation (Dialog(tab="General",group="Geometry"));
  parameter Integer N_cv_a(min=3)=3 "Number of cells for flow_a" annotation (Dialog(tab="General",group="Geometry"));
  parameter Integer N_cv_b(min=3)=3 "Number of cells for flow_b" annotation (Dialog(tab="General",group="Geometry"));

  parameter Integer N_tubes=1 "Number of tubes in parallel (one pass)"
                                                                      annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length width=1 "Width of HX (length of flat tube)"  annotation (Dialog(tab="General", group="Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX01FlatTubeFinnedGeometry_ParameterDialogHX.png"));
  parameter ClaRa.Basics.Units.Length length=1 "Length of HX (width of flat tube)" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length heigth=1 "Heigth of HX" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_a=heigth/2 "Inlet position from bottom for flow_a" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_a=heigth/2 "Outlet position from bottom for flow_a" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in_b=heigth/2 "Inlet position from bottom for flow_b" annotation (Dialog(tab="General", group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out_b=heigth/2 "Outlet position from bottom for flow_b" annotation (Dialog(tab="General", group="Geometry"));
  parameter Real CF_geo[2]=ones(2) "Correction factor for heat transfer area dedicated to surfuca of: 1|flow_a 2|flow_b " annotation (Dialog(tab="General", group="Geometry"));

  parameter ClaRa.Basics.Units.Length thickness_tubeWall=0.01 "Wall thickness of the plate" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry", groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/HEX01FlatTubeFinnedGeometry_ParameterDialogDetail.png"));
  parameter ClaRa.Basics.Units.Length diameter_t=0.01 "Outer diameter of the flat tube" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry"));
  parameter ClaRa.Basics.Units.Length h_f=0.01 "Fin heigth" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry"));
  parameter ClaRa.Basics.Units.Length s_f=0.002 "Fin thickness" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry"));
  parameter ClaRa.Basics.Units.Length t_f=0.001 "Fin spacing" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry"));
  parameter ClaRa.Basics.Units.Length l_l=0.8*h_f "Length of one louver" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry"));
  parameter ClaRa.Basics.Units.Length t_l=0.001 "Louver spacing" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry"));
  parameter Real Phi(min=0) = 25 "Louver angle" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry"));
  final parameter Integer flowOrientation=if HeatExchangerType==2 then 0 else 1 "Flow orientation of flow_b" annotation (Dialog(tab="General", group="Tube and Fin Side Geometry"), choices(
    choice=0 "Lengthwise",
    choice=1 "Widthwise"));

  //________________________________ Flow_A Fundamental Definitions _____________________________________//
  parameter Boolean frictionAtInlet_a=false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_a",group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet_a=false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_a",group="Fundamental Definitions"));

  //________________________________ Flow_A nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_nom_a=1 "Nominal mass flow on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
  parameter SI.Pressure p_nom_a[N_cv_a]=1e5*ones(N_cv_a) "Nominal pressure on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
  parameter SI.EnthalpyMassSpecific h_nom_a[N_cv_a]=85e3*ones(N_cv_a) "Nominal specific enthalpy on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));
 parameter SI.Pressure Delta_p_nom_a=1000 "Nominal pressure loss on A side"
    annotation (Dialog(tab="Flow_a", group="Nominal Values Flow_a"));

  //________________________________ Flow_b nominal parameter _____________________________________//
  parameter SI.MassFlowRate m_nom_b=1 "Nominal mass flow on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
  parameter SI.Pressure p_nom_b[N_cv_b]=1e5*ones(N_cv_b) "Nominal pressure on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
  parameter SI.Temperature T_nom_b[N_cv_b]=293.15*ones(N_cv_b) "Nominal specific enthalpy on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
  parameter SI.MassFraction xi_nom_b[medium_b.nc - 1]= medium_b.xi_default annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));
    parameter SI.Pressure Delta_p_nom_b=1000 "Nominal pressure loss on tube side"
    annotation (Dialog(tab="Flow_b", group="Nominal Values Flow_b"));

  //________________________________ Flow_b Fundamental Definitions _____________________________________//
  parameter Boolean frictionAtInlet_b=false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_b",group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet_b=false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true),Dialog(tab="Flow_b",group="Fundamental Definitions"));

  //*********************************** / WALL \ ***********************************//
  //________________________________ Wall fundamentals _______________________________//
  replaceable model TubeWallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum
    constrainedby TILMedia.Solid.Types.BaseSolid
                                                "Material of the tube"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Tube wall"));
  parameter SI.Mass mass_struc_tubeWall=0 "Additional mass to tubeWall calculated by density*flow_b.geo.length_plate*flow_b.geo.h_f*flow_b.geo.N_f*s_f*N_passes" annotation (Dialog(tab="Wall", group="Tube wall"));
  inner replaceable model FinWallMaterial = TILMedia.Solid.Types.TILMedia_Aluminum
    constrainedby TILMedia.Solid.Types.BaseSolid
                                                "Material of the fin"
    annotation (choicesAllMatching=true, Dialog(tab="Wall", group=
          "Fin wall"));
  parameter SI.Mass mass_struc_finWall=0 "Additional mass to finWall calculated by density*length*width*thickness_tubeWall*N_passes" annotation (Dialog(tab="Wall", group="Fin wall"));

  //________________________________ Initialisation general _______________________________________//
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "true, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation"));

  //________________________________ Flow_a initialisation  _______________________________________//
  inner parameter Integer initOption_a=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation", group="Flow_a"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                              choice = 202 "Steady enthalpy"));
  parameter SI.EnthalpyMassSpecific h_start_a[N_cv_a]=85e3*ones(N_cv_a) "Start value of sytsem specific enthalpy"
    annotation (Dialog(tab="Initialisation", group="Flow_a"));
  parameter SI.Pressure p_start_a[N_cv_a]=1e5*ones(N_cv_a) "Start value of sytsem pressure"
    annotation (Dialog(tab="Initialisation", group="Flow_a"));
  parameter SI.MassFraction xi_start_a[medium_a.nc - 1]=zeros(medium_a.nc - 1) "Initial composition for flow_a" annotation (Dialog(tab="Initialisation", group="Flow_a"));

  //________________________________ Flow_b initialisation _______________________________________//
  parameter Integer initOption_b=0 "Type of initialisation"
    annotation (Dialog(tab="Initialisation", group="Flow_b"), choices(choice = 0 "Use guess values", choice = 1 "Steady state",
                                                                                              choice=201 "Steady pressure",
                                                                                            choice = 202 "Steady enthalpy"));
  parameter SI.Temperature T_start_b[N_cv_b]=293.15*ones(N_cv_b) "Start value of system temperature"
    annotation (Dialog(tab="Initialisation", group="Flow_b"));
  parameter SI.Pressure p_start_b[N_cv_b]=1e5*ones(N_cv_b) "Start value of sytsem pressure"
    annotation (Dialog(tab="Initialisation", group="Flow_b"));
  parameter SI.MassFraction xi_start_b[medium_b.nc - 1]=medium_b.xi_default "Initial composition for flow_b" annotation (Dialog(tab="Initialisation", group="Flow_b"));

  //________________________________ Wall initialisation _______________________________________//
  parameter Integer initOptionTubeWall=0 "|Initialisation option for tube wall"    annotation (Dialog(tab="Initialisation", group="Wall"), choices(
      choice=213 "Fixed temperature",
      choice=1 "Steady state",
      choice=203 "Steady temperature",
      choice=0 "No init, use T_start as guess values"));
  parameter Integer initOptionFinWall=0 "|Initialisation option for finned wall"    annotation (Dialog(tab="Initialisation", group="Wall"), choices(
      choice=213 "Fixed temperature",
      choice=1 "Steady state",
      choice=203 "Steady temperature",
      choice=0 "No init, use T_start as guess values"));
  parameter SI.Temperature T_w_tube_start[N_cv_a]=293.15*ones(N_cv_a) "Initial tube wall temperature" annotation (Dialog(tab="Initialisation", group="Wall"));
  parameter SI.Temperature T_w_fin_start[N_cv_b]=293.15*ones(N_cv_b) "Initial tube wall temperature" annotation (Dialog(tab="Initialisation", group="Wall"));

  //*********************************** / EXPERT Settings and Visualisation \ ***********************************//
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  ClaRa.Basics.Interfaces.GasPortIn In_b(Medium=medium_b) annotation (Placement(transformation(extent={{70,-110},{90,-90}}),iconTransformation(extent={{70,-110},{90,-90}})));
  ClaRa.Basics.Interfaces.GasPortOut Out_b(Medium=medium_b) annotation (Placement(transformation(extent={{-90,-110},{-70,-90}}),iconTransformation(extent={{-90,-110},{-70,-90}})));
  ClaRa.Basics.Interfaces.FluidPortOut Out_a(Medium=medium_a) annotation (Placement(transformation(extent={{70,88},{90,108}})));
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
    xi_start=xi_start_a,
    showExpertSummary=true,
    showData=true,
    medium=medium_a,
    p_nom=p_nom_a,
    h_nom=h_nom_a,
    m_flow_nom=m_nom_a,
    Delta_p_nom=Delta_p_nom_a,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.FlatTubeGeometry_N_cv (
        z_in=z_in_a,
        z_out=z_out_a,
        N_cv=N_cv_a,
        width=length,
        length=width,
        diameter=diameter_t - 2*thickness_tubeWall,
        thickness_wall=thickness_tubeWall,
        N_tubes=N_tubes,
        CF_geo={CF_geo[1]},
        N_passes=N_passes))
                  annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={0,80})));
  ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L4   flow_b(
    frictionAtInlet=frictionAtInlet_b,
    frictionAtOutlet=frictionAtOutlet_b,
    T_nom=T_nom_b,
    xi_nom=xi_nom_b,
    useHomotopy=useHomotopy,
    T_start=T_start_b,
    p_start=p_start_b,
    redeclare model HeatTransfer = HeatTransferInner_b,
    redeclare model PressureLoss = PressureLoss_b,
    initOption=initOption_b,
    xi_start=xi_start_b,
    showData=true,
    medium=medium_b,
    p_nom=p_nom_b,
    m_flow_nom=m_nom_b,
    Delta_p_nom=Delta_p_nom_b,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.FlatTubeFinnedGeometry_N_cv (
        z_in=z_in_b,
        z_out=z_out_b,
        N_cv=N_cv_b,
        heigth=heigth,
        diameter_t=diameter_t,
        N_passes=N_passes_b,
        flowOrientation=flowOrientation,
        h_f=h_f,
        s_f=s_f,
        t_f=t_f,
        l_l=l_l,
        t_l=t_l,
        width=if flowOrientation == 0 then width else length,
        length=if flowOrientation == 0 then length else width,
        N_tubes=if equalNumberOfPasses then N_tubes else N_tubes*N_passes,
        CF_geo={CF_geo[2]},
        Phi=Phi)) annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=0,
        origin={0,-80})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 tubeWall(
    redeclare model Material = TubeWallMaterial,
    length=width*N_passes,
    width=2*length,
    mass_struc=mass_struc_tubeWall,
    N_pathes=N_tubes,
    T_start=T_w_tube_start,
    N_ax=N_cv_a,
    initOption=initOptionTubeWall,
    thickness_wall=thickness_tubeWall) annotation (Placement(transformation(extent={{-10,-8},{10,8}},
        rotation=0,
        origin={0,60})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 finWall(
    redeclare model Material = FinWallMaterial,
    length=flow_b.geo.length*N_passes_b,
    width=flow_b.geo.l_f*flow_b.geo.N_f,
    mass_struc=mass_struc_tubeWall,
    CF_area=2,
    N_pathes=if equalNumberOfPasses then N_tubes else N_tubes*N_passes,
    T_start=T_w_fin_start,
    N_ax=N_cv_b,
    initOption=initOptionFinWall,
    thickness_wall=s_f)                annotation (Placement(transformation(
        extent={{-10,-8},{10,8}},
        rotation=0,
        origin={0,-60})));

  Summary summary(outline(
      showExpertSummary=showExpertSummary,
      Q_flow=sum(flow_a.heat.Q_flow),
      Delta_T_in=flow_a.summary.inlet.T - flow_b.summary.inlet.T,
      Delta_T_out=flow_a.summary.outlet.T - flow_b.summary.outlet.T)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-94})));

protected
   ClaRa.Basics.Interfaces.EyeInGas
                           eye_int2(medium=medium_b)
     annotation (Placement(transformation(extent={{-1,1},{1,-1}},
        rotation=270,
        origin={-86,-80})));
public
   ClaRa.Basics.Interfaces.EyeOutGas
                            eye2(medium=medium_b) if showData annotation (Placement(
         transformation(
         extent={{10,-10},{-10,10}},
         rotation=0,
         origin={-102,-80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-102,-80})));
protected
   ClaRa.Basics.Interfaces.EyeIn
                           eye_int1
     annotation (Placement(transformation(extent={{-1,-1},{1,1}},
        rotation=180,
        origin={86,80})));
public
   ClaRa.Basics.Interfaces.EyeOut
                            eye1 if showData annotation (Placement(transformation(
        extent={{-100,10},{-120,30}},
        rotation=180,
        origin={-8,100}),
                       iconTransformation(
        extent={{100,10},{120,30}},
        rotation=0,
        origin={-10,60})));

equation
  assert(mod(N_cv_a,N_passes_a)==0, "Number of cells per pass for flow_a must be a whole number but is "+String(N_cv_a/N_passes_a, significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(mod(N_cv_b,N_passes_b)==0, "Number of cells per pass for flow_b must be a whole number but is "+String(N_cv_b/N_passes_b, significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(if ((HeatExchangerType == 0 or HeatExchangerType == 1) and equalNumberOfPasses and N_cv_a>=N_cv_b) then mod(N_cv_a,N_cv_b)==0 else true, "Number of cells for flow_a per number of cells for flow_b must be a whole number but is  "+String(N_cv_a/N_cv_b, significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(if ((HeatExchangerType == 0 or HeatExchangerType == 1) and equalNumberOfPasses and N_cv_b>N_cv_a) then mod(N_cv_b,N_cv_a)==0 else true, "Number of cells for flow_b per number of cells for flow_a must be a whole number but is  "+String(N_cv_b/N_cv_a, significantDigits=3) + " in instance" + getInstanceName() + ".");
//  assert(if ((HeatExchangerType == 0 or HeatExchangerType == 1) and not equalNumberOfPasses and (N_cv_a/N_passes_a)==N_cv_b) then integer(N_cv_a/N_passes_a)==N_cv_b else true, "Number of cells per pass for flow_a must be equal to number of cells for flow_b  "+String(N_cv_a/N_passes_a, significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(if ((HeatExchangerType == 0 or HeatExchangerType == 1) and not equalNumberOfPasses and N_cv_b>integer(N_cv_a/N_passes_a)) then integer(N_cv_b/(N_cv_a/N_passes_a))>=2 and mod(N_cv_b,integer(N_cv_a/N_passes_a))==0 else true, "Number of cells for flow_b per number of cells per pass for flow_a must be whole number and equal or greater than 2"+String(N_cv_b/(N_cv_a/N_passes_a), significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(if ((HeatExchangerType == 0 or HeatExchangerType == 1) and not equalNumberOfPasses and integer(N_cv_a/N_passes_a)>N_cv_b) then integer((N_cv_a/N_passes_a)/N_cv_b)>=2 and mod(integer(N_cv_a/N_passes_a),N_cv_b)==0 else true, "Number of cells per pass for flow_a per number of cells for flow_b must be whole number and equal or greater than 2"+String((N_cv_a/N_passes_a)/N_cv_b, significantDigits=3) + " in instance" + getInstanceName() + ".");
//  assert(if (HeatExchangerType == 2 and not equalNumberOfPasses and N_passes_a==N_cv_b) then N_passes_a==N_cv_b else true, "Number of cells per pass for flow_a is equal to number of cells for flow_b"+String(N_passes_a, significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(if (HeatExchangerType == 2 and not equalNumberOfPasses and N_cv_b>N_passes_a) then integer(N_cv_b/N_passes_a)>=2 and mod(N_cv_b,N_passes_a)==0 else true, "Number of cells for flow_b per number of cells per pass for flow_a must be whole number and equal or greater than 2"+String(N_cv_b/N_passes_a, significantDigits=3) + " in instance" + getInstanceName() + ".");
  assert(if (HeatExchangerType == 2 and not equalNumberOfPasses and N_passes_a>N_cv_b) then integer(N_passes_a/N_cv_b)>=2 and mod(N_passes_a,N_cv_b)==0 else true, "Number of cells per pass for flow_a per number of cells for flow_b must be whole number and equal or greater than 2"+String(N_passes_a/N_cv_b, significantDigits=3) + " in instance" + getInstanceName() + ".");

  connect(eye_int2,eye2)  annotation (Line(points={{-86,-80},{-102,-80}},            color={190,190,190}));
  connect(eye_int1,eye1)  annotation (Line(points={{86,80},{102,80}},                    color={190,190,190}));

   eye_int1.m_flow=-flow_a.outlet.m_flow;
   eye_int1.T=flow_a.summary.outlet.T-273.15;
   eye_int1.s=flow_a.summary.outlet.s/1000;
   eye_int1.h=flow_a.summary.outlet.h/1000;
   eye_int1.p=flow_a.summary.outlet.p/100000;

   eye_int2.m_flow=-flow_b.outlet.m_flow;
   eye_int2.T=flow_b.summary.outlet.T-273.15;
   eye_int2.s=flow_b.fluidOutlet.s/1e3;
   eye_int2.h=flow_b.summary.outlet.h/1000;
   eye_int2.p=flow_b.summary.outlet.p/100000;
   eye_int2.xi=flow_b.summary.outlet.xi;

  for i in 1:N_cv_a loop
    if HeatExchangerType == 0 then
      connect(tubeWall.outerPhase[i], flow_a.heat[N_cv_a+1-i])   annotation (Line(
      points={{0,68},{0,76}},
      color={167,25,48},
      thickness=0.5));
    else
      connect(tubeWall.outerPhase, flow_a.heat);
    end if;
  end for;
  connect(flow_a.inlet, In_a) annotation (Line(
      points={{-14,80},{-80,80},{-80,100}},
      color={0,131,169},
      thickness=0.5));
  connect(flow_a.outlet, Out_a) annotation (Line(
      points={{14,80},{80,80},{80,98}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(flow_b.inlet, In_b) annotation (Line(
      points={{14,-80},{80,-80},{80,-100}},
      color={118,106,98},
      thickness=0.5));
  connect(flow_b.outlet, Out_b) annotation (Line(
      points={{-14,-80},{-80,-80},{-80,-100}},
      color={118,106,98},
      thickness=0.5));
  connect(finWall.innerPhase, flow_b.heat) annotation (Line(
      points={{0,-68},{0,-76}},
      color={167,25,48},
      thickness=0.5));

  if HeatExchangerType == 0 or HeatExchangerType == 1 then
    if equalNumberOfPasses then
      if integer(N_cv_a/N_cv_b) >=1 then
        for i in 1:N_cv_b loop
          for j in 1+integer(N_cv_a/N_cv_b)*(i-1):i*integer(N_cv_a/N_cv_b) loop
            connect(tubeWall.innerPhase[j], finWall.outerPhase[i]) annotation (Line(points={{0,52},{0,-52}},                     color={167,25,48},thickness=0.5));
          end for;
        end for;
      else //integer(N_cv_b/N_cv_a)>=2
        for i in 1:N_cv_a loop
          for j in 1+integer(N_cv_b/N_cv_a)*(i-1):i*integer(N_cv_b/N_cv_a) loop
            connect(tubeWall.innerPhase[i], finWall.outerPhase[j]);
          end for;
        end for;
      end if;
    else // not equalNumberOfPasses
      if integer(N_cv_a/N_passes_a)==N_cv_b then
        for i in 1:N_passes_a loop
          for j in 1+integer(N_cv_a/N_passes_a)*(i-1):i*integer(N_cv_a/N_passes_a) loop
            connect(tubeWall.innerPhase[j], finWall.outerPhase[mod(i,2)*(j+integer(N_cv_a/N_passes_a)-i*integer(N_cv_a/N_passes_a))+mod(i+1,2)*(1-j+i*integer(N_cv_a/N_passes_a))]);
          end for;
        end for;
      elseif integer(N_cv_b/integer(N_cv_a/N_passes_a))>=2 then
        for i in 1:N_passes_a loop
          for j in 1+integer(N_cv_a/N_passes_a)*(i-1):i*integer(N_cv_a/N_passes_a) loop
            for k in 1:integer(N_cv_b/integer(N_cv_a/N_passes_a)) loop
              connect(tubeWall.innerPhase[j], finWall.outerPhase[mod(i,2)*(k+(j+integer(N_cv_a/N_passes_a)-i*integer(N_cv_a/N_passes_a)-1)*integer(N_cv_b/integer(N_cv_a/N_passes_a)))
              +mod(i+1,2)*((1-j+i*integer(N_cv_a/N_passes_a))*integer(N_cv_b/integer(N_cv_a/N_passes_a)-k+1))]);
            end for;
          end for;
        end for;
      else // integer(N_cv_a/N_passes_a)/N_cv_b>=2
        for i in 1:N_passes_a loop
          for k in 1:N_cv_b loop
            for j in 1+integer(N_cv_a/N_passes_a)*(i-1)+(k-1)*integer(integer(N_cv_a/N_passes_a)/N_cv_b):integer(N_cv_a/N_passes_a)*(i-1)+k*integer(integer(N_cv_a/N_passes_a)/N_cv_b) loop
              connect(tubeWall.innerPhase[j], finWall.outerPhase[mod(i,2)*k+mod(i+1,2)*(N_cv_b-k+1)]);
            end for;
          end for;
        end for;
      end if;
    end if;
  else // HeatExchangerType cross flow
    if equalNumberOfPasses then
      for i in 1:N_passes loop
        for j in 1+(i-1)*integer(N_cv_b/N_passes):i*integer(N_cv_b/N_passes) loop
          for k in 1+(i-1)*integer(N_cv_a/N_passes):i*integer(N_cv_a/N_passes) loop
            connect(tubeWall.innerPhase[k], finWall.outerPhase[j]);
          end for;
        end for;
      end for;
    else // not equalNumberOfPasses
      if N_passes_a==N_cv_b then
        for i in 1:N_passes_a loop
          for j in 1+integer(N_cv_a/N_passes_a)*(i-1):i*integer(N_cv_a/N_passes_a) loop
            connect(tubeWall.innerPhase[j], finWall.outerPhase[i]);
          end for;
        end for;
      elseif integer(N_cv_b/N_passes_a)>=2 then
        for i in 1:N_passes_a loop
          for j in 1+integer(N_cv_a/N_passes_a)*(i-1):i*integer(N_cv_a/N_passes_a) loop
            for k in 1:integer(N_cv_b/N_passes_a) loop
              connect(tubeWall.innerPhase[j], finWall.outerPhase[(i-1)*integer(N_cv_b/N_passes_a)+k]);
            end for;
          end for;
        end for;
      else //integer(N_passes_a/N_cv_b)>=2
        for i in 1:N_cv_b loop
          for j in 1+integer(N_cv_a/N_passes_a)*(i-1)*integer(N_passes_a/N_cv_b):i*integer(N_cv_a/N_passes_a)*integer(N_passes_a/N_cv_b) loop
            connect(tubeWall.innerPhase[j], finWall.outerPhase[i]);
          end for;
        end for;
      end if;
    end if;
  end if;
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
                   graphics));
end FlatTubeFinnedHEXvle2gas_L4;
