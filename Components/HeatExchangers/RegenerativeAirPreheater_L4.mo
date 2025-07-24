within ClaRa.Components.HeatExchangers;
model RegenerativeAirPreheater_L4 "Model for a regenerative air preheater"
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

  extends ClaRa.Basics.Icons.AirPreheater;

  //## S U M M A R Y   D E F I N I T I O N ###################################################################

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.FlangeGas flueGasInlet;
    ClaRa.Basics.Records.FlangeGas freshAirInlet;
    ClaRa.Basics.Records.FlangeGas flueGasOutlet;
    ClaRa.Basics.Records.FlangeGas freshAirOutlet;
  end Summary;

  //## P A R A M E T E R S #######################################################################################

  parameter Boolean calculate_mass=true "True, if mass is calculated with nominal material density"
    annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Mass mass_fixed=100000 "Fixed storage mass" annotation (Dialog(group="Geometry", enable=not calculate_mass));

  parameter ClaRa.Basics.Units.Length diameter_reg=8 "Regenerator diameter" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_hub=0.5 "Hub diameter" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Length height_reg=2 "Regenerator height" annotation (Dialog(group="Geometry"));

  parameter Real N_sp=3500 "Number of storage plates"
    annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Length s_sp=0.6e-3 "Thickness of storage plates" annotation (Dialog(group="Geometry"));

  parameter Real C=440 "Heating surface per volume (mass^2/mass^3)"
    annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_covered=0.1*(A_cross - A_hub) "Covered regenerator cross section" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_flueGas=0.55*(A_cross - A_hub) "Cross section hit by flue gas" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_air=0.35*(A_cross - A_hub) "Cross section hit by fresh air" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_cross=Modelica.Constants.pi/4*diameter_reg^2 "Overall regenerator cross section" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_hub=Modelica.Constants.pi/4*diameter_hub^2 "Hub cross section" annotation (Dialog(
      tab="General",
      group="Geometry",
      showStartAttribute=false,
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/RegAirPreheater.png",
      connectorSizing=false));
  // annotation (Dialog(group="Geometry"));
  parameter Real leakage=0.05 "Ratio of mass leakage from cold fresh air to cold flue gas"
    annotation (Dialog(group="Leakage"));

  inner parameter Integer N_cv(min=2) = 3 "Number of finite control volumes"
    annotation (Dialog(group="Discretisation"));
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(tab="Initialisation"));

  inner parameter Integer initOptionCells=0 "Type of gas cell initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=202 "Steady temperature",
      choice=208 "Steady pressure and enthalpy"));

  parameter Integer initOptionWall=213 "Init Option of Wall"
    annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));

  parameter ClaRa.Basics.Units.Temperature T_start_freshAir[N_cv]=ones(N_cv)*293.15 "Start value of fresh air system Temperature" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_freshAir[N_cv]=ones(N_cv)*1.013e5 "Start value of fresh air system pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_freshAir[medium.nc - 1]=
      medium.xi_default "Start value of fresh air system mass fraction"
    annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Temperature T_start_flueGas[N_cv]=ones(N_cv)*400 "Start value of flue gas system Temperature" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_flueGas[N_cv]=ones(N_cv)*1.013e5 "Start value of flue gas system pressure" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_flueGas[medium.nc - 1]=medium.xi_default "Start value of flue gas system mass fraction" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Temperature T_start_wall[N_cv]=ones(N_cv)*350 "Start value of wall Temperature" annotation (Dialog(tab="Initialisation"));

  parameter Integer stateLocation=2 "Location of wall states" annotation (
      Dialog(group="Numerical Efficiency"), choices(
      choice=1 "Inner location of states",
      choice=2 "Central location of states",
      choice=3 "Outer location of states"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_freshAir_nom=500 "|Physical Effects|Nominal values|Nominal value of fresh air mass flow rate" annotation (Dialog(tab=""));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_flueGas_nom=300 "|Physical Effects|Nominal values|Nominal value of flue gas mass flow rate" annotation (Dialog(tab=""));

  parameter Basics.Units.Pressure p_freshAir_nom=1.0e5 "|Physical Effects|Nominal values|Nominal value of fresh air pressure" annotation (Dialog(tab=""));
  parameter Basics.Units.Pressure p_flueGas_nom=1.0e5 "|Physical Effects|Nominal values|Nominal value of flue gas pressure" annotation (Dialog(tab=""));

  parameter Basics.Units.Pressure Delta_p_freshAir_nom=1.0e4 "|Physical Effects|Nominal values|Nominal value of fresh air pressure loss" annotation (Dialog(tab=""));
  parameter Basics.Units.Pressure Delta_p_flueGas_nom=1.0e4 "|Physical Effects|Nominal values|Nominal value of flue gas pressure loss" annotation (Dialog(tab=""));

  parameter Basics.Units.MassFraction xi_nom_freshAir[medium.nc - 1]= medium.xi_default "|Physical Effects|Nominal values|Nominal composition";

  parameter Basics.Units.MassFraction xi_nom_flueGas[medium.nc - 1]= medium.xi_default "|Physical Effects|Nominal values|Nominal composition";

  inner parameter Boolean frictionAtFreshAirInlet=false "|Physical Effects|Pressure Loss|True if pressure loss between first fresh air cell and inlet shall be considered"
                                                                                              annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtFreshAirOutlet=false "|Physical Effects|Pressure Loss|True if pressure loss between last fresh air cell and outlet shall be considered"
                                                                                              annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtFlueGasInlet=false "|Physical Effects|Pressure Loss|True if pressure loss between first flue gas cell and inlet shall be considered"
                                                                                              annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtFlueGasOutlet=false "|Physical Effects|Pressure Loss|True if pressure loss between last flue gas cell and outlet shall be considered"
                                                                                              annotation (choices(checkBox=true));

  final parameter ClaRa.Basics.Units.Area A_heat=volume_reg_eff*C "Overall heat transfer area";
  final parameter ClaRa.Basics.Units.Length b=(diameter_reg - diameter_hub)/2 "Length of storage material plates";
  final parameter ClaRa.Basics.Units.Area A_plates=N_sp*s_sp*b "Cross sectional area in flow direction blocked by plates";
  final parameter Real f_plates=A_plates/(A_cross - A_hub) "Factor of cross sectional area in flow direction blocked by plates";
  final parameter ClaRa.Basics.Units.Area A_air_free=A_air*(1 - f_plates) "Cross sectional area of air flow";
  final parameter ClaRa.Basics.Units.Area A_flueGas_free=A_flueGas*(1 - f_plates) "Cross sectional area of flue gas flow";
  final parameter ClaRa.Basics.Units.Volume volume_flueGas=A_flueGas_free*height_reg "Flue gas volume";
  final parameter ClaRa.Basics.Units.Volume volume_air=A_air_free*height_reg "Fresh air volume";
  final parameter ClaRa.Basics.Units.Volume volume_reg_eff=(A_cross - A_hub - A_covered)*height_reg "Effective regenerator volume (without hub and covered volume)";
  final parameter ClaRa.Basics.Units.Volume volume_st=(A_cross - A_hub)*(f_plates)*height_reg "Volume of solid regenerator storage material";
  final parameter ClaRa.Basics.Units.Mass mass=if calculate_mass then volume_st*solid.d else mass_fixed "Mass of regenerator storage material";
  final parameter ClaRa.Basics.Units.Length d_gl=4*(A_cross - A_hub - A_plates)/(2*N_sp*b) "Equivalent diameter";

protected
  parameter Basics.Units.Temperature T_start_wall_internal[N_cv]=if size(T_start_wall, 1) == 2 then linspace(
      T_start_wall[1],
      T_start_wall[2],
      N_cv) else T_start_wall "Internal T_start array which allows the user to either state T_inlet, T_outlet if T_start has length 2, otherwise the user can specify an individual Temperature profile for initialisation";

  //_____________defintion of medium used in cells__________________________________________________________
public
  inner parameter TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel "Medium to be used in tube"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  //## V A R I A B L E   P A R T##################################################################################

  outer ClaRa.SimCenter simCenter;

  //____Connectors_______________________________________________________________________________________________
  ClaRa.Basics.Interfaces.GasPortIn flueGasInlet(Medium=medium, m_flow(min=-Modelica.Constants.inf)) "Inlet port"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-100}),iconTransformation(extent={{90,-70},{110,-50}})));

  ClaRa.Basics.Interfaces.GasPortOut flueGasOutlet(Medium=medium, m_flow(max=Modelica.Constants.inf)) "Outlet port"
                  annotation (Placement(transformation(extent={{36,90},{56,110}}),
        iconTransformation(extent={{90,50},{110,70}})));

  ClaRa.Basics.Interfaces.GasPortIn freshAirInlet(Medium=medium, m_flow(min=-Modelica.Constants.inf)) "Inlet port"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-46,100}),iconTransformation(extent={{-110,50},{-90,70}})));

  ClaRa.Basics.Interfaces.GasPortOut freshAirOutlet(Medium=medium, m_flow(max=Modelica.Constants.inf)) "Outlet port"
                  annotation (Placement(transformation(extent={{-56,-110},{-36,
            -90}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));

  //______________________ replaceable models _____________________________
  replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L4 "|Physical Effects|Pressure Loss|Pressure loss model at the tubes side"
    annotation(choicesAllMatching);

  replaceable model HeatTransferFlueGas =
    ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_regenerativeAirPreheater_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4 "|Physical Effects|Heat Transfer|Heat transfer model"
   annotation(choicesAllMatching);

  replaceable model HeatTransferFreshAir =
    ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_regenerativeAirPreheater_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4 "|Physical Effects|Heat Transfer|Heat transfer model"
   annotation(choicesAllMatching);

  replaceable model Material = TILMedia.Solid.Types.TILMedia_Aluminum
    constrainedby TILMedia.Solid.Types.BaseSolid
                                                "Regenerator storage material"
    annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

  TILMedia.Solid.Solid solid(redeclare replaceable model SolidType = Material, T=293.15)
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));

  Basics.ControlVolumes.GasVolumes.VolumeGas_L4 flueGasCell(
    each xi_start=xi_start_flueGas,
    each useHomotopy=useHomotopy,
    each m_flow_nom=m_flow_flueGas_nom,
    each xi_nom=xi_nom_flueGas,
    each T_nom=293.15*ones(N_cv),
    T_start=T_start_flueGas,
    p_start=p_start_flueGas,
    Delta_p_nom=Delta_p_flueGas_nom,
    frictionAtInlet=frictionAtFlueGasInlet,
    frictionAtOutlet=frictionAtFlueGasOutlet,
    redeclare model PressureLoss = PressureLoss,
    redeclare model HeatTransfer = HeatTransferFlueGas (heatSurfaceAlloc=1),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv (
        N_heat=1,
        N_cv=N_cv,
        diameter_hyd=fill(d_gl, N_cv),
        volume=ones(N_cv)*volume_flueGas/N_cv,
        A_cross=ones(N_cv)*A_flueGas_free,
        A_heat=ones(N_cv, 1)*A_heat/N_cv),
    initOption=initOptionCells,
    each p_nom=p_flueGas_nom*ones(N_cv))
                                annotation (Placement(transformation(
        extent={{-14,-6},{14,6}},
        rotation=90,
        origin={46,-22})));

  Basics.ControlVolumes.GasVolumes.VolumeGas_L4 freshAirCell(
    each xi_start=xi_start_freshAir,
    each useHomotopy=useHomotopy,
    each m_flow_nom=m_flow_freshAir_nom,
    each p_nom=p_freshAir_nom*ones(N_cv),
    each xi_nom=xi_nom_freshAir,
    each T_nom=293.15*ones(N_cv),
    T_start=T_start_freshAir,
    p_start=p_start_freshAir,
    Delta_p_nom=Delta_p_freshAir_nom,
    frictionAtInlet=frictionAtFreshAirInlet,
    frictionAtOutlet=frictionAtFreshAirOutlet,
    redeclare model PressureLoss = PressureLoss,
    redeclare model HeatTransfer = HeatTransferFreshAir (heatSurfaceAlloc=1),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv (
        N_heat=1,
        N_cv=N_cv,
        diameter_hyd=fill(d_gl, N_cv),
        volume=ones(N_cv)*volume_air/N_cv,
        A_cross=ones(N_cv)*A_air_free,
        A_heat=ones(N_cv, 1)*A_heat/N_cv),
    initOption=initOptionCells) annotation (Placement(transformation(
        extent={{-14,-6},{14,6}},
        rotation=270,
        origin={-46,-22})));

  Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 wallSecondaryAir(
    redeclare replaceable model Material = Material,
    each thickness_wall=s_sp,
    each initOption=initOptionWall,
    T_start=T_start_wall_internal,
    each stateLocation=stateLocation,
    N_ax=N_cv,
    mass_struc=mass - wallSecondaryAir.length*wallSecondaryAir.width*s_sp*wallSecondaryAir.solid[1].d,
    CF_area=A_heat/(wallSecondaryAir.length*wallSecondaryAir.width)) annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=-90,
        origin={1,-22})));

  VolumesValvesFittings.Fittings.FlueGasJunction_L2 freshAirLeakage_join(
    T_start=if size(T_start_flueGas, 1) == 2 then T_start_flueGas[2]*(1 - leakage) else T_start_flueGas[1]*(1 - leakage),
    p_start=if size(p_start_flueGas, 1) == 2 then p_start_flueGas[2] else p_start_flueGas[1],
    xi_start=(1*xi_start_flueGas + leakage*xi_start_freshAir)/(1 + leakage),
    volume=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={46,40})));

  Summary summary(
    flueGasInlet(
      mediumModel=medium,
      m_flow=flueGasCell.inlet.m_flow,
      T=inStream(flueGasCell.inlet.T_outflow),
      p=flueGasCell.inlet.p,
      h=flueGasCell.fluidInlet.h,
      xi=inStream(flueGasCell.inlet.xi_outflow),
      H_flow=flueGasCell.inlet.m_flow*flueGasCell.fluidInlet.h),
    freshAirInlet(
      mediumModel=medium,
      m_flow=freshAirCell.inlet.m_flow,
      T=inStream(freshAirCell.inlet.T_outflow),
      p=freshAirCell.inlet.p,
      h=freshAirCell.fluidInlet.h,
      xi=inStream(freshAirCell.inlet.xi_outflow),
      H_flow=freshAirCell.inlet.m_flow*freshAirCell.fluidInlet.h),
    flueGasOutlet(
      mediumModel=medium,
      m_flow=-freshAirLeakage_join.portA.m_flow,
      T=flueGasCell.outlet.T_outflow,
      p=flueGasCell.outlet.p,
      h=flueGasCell.fluidOutlet.h,
      xi=flueGasCell.outlet.xi_outflow,
      H_flow=-freshAirLeakage_join.portA.m_flow*freshAirLeakage_join.flueGasIn.h),
    freshAirOutlet(
      mediumModel=medium,
      m_flow=-freshAirCell.outlet.m_flow,
      T=freshAirCell.outlet.T_outflow,
      p=freshAirCell.outlet.p,
      h=freshAirCell.fluidOutlet.h,
      xi=freshAirCell.outlet.xi_outflow,
      H_flow=-freshAirCell.outlet.m_flow*freshAirCell.fluidOutlet.h));

  VolumesValvesFittings.Valves.ThreeWayValveGas_L1_simple freshAirLeakage_split(splitRatio_fixed=leakage) annotation (Placement(transformation(
        extent={{-10,-9},{10,9}},
        rotation=0,
        origin={-32,39})));
public
  Basics.Interfaces.EyeOutGas       eye_flueGas(each medium=medium)
                                            annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,82}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={102,86})));
protected
  Basics.Interfaces.EyeInGas       eye_int_flueGas[1](each medium=medium)
                                               annotation (Placement(transformation(extent={{-1,-1},{1,1}},
        rotation=0,
        origin={86,82})));
protected
  Basics.Interfaces.EyeInGas       eye_int_freshAir
                                                  [1](each medium=medium)
                                               annotation (Placement(transformation(extent={{-1,-1},{1,1}},
        rotation=180,
        origin={-82,-78})));
public
  Basics.Interfaces.EyeOutGas eye_freshAir(each medium=medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-104,-78}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-102,-86})));
equation
  eye_int_flueGas[1].p = summary.flueGasOutlet.p/1e5;
  eye_int_flueGas[1].h = summary.flueGasOutlet.h/1e3;
  eye_int_flueGas[1].m_flow =-freshAirLeakage_join.portA.m_flow;
  eye_int_flueGas[1].T = summary.flueGasOutlet.T - 273.15;
  eye_int_flueGas[1].s =freshAirLeakage_join.flueGasIn.s/1e3;
  eye_int_flueGas[1].xi =freshAirLeakage_join.flueGasIn.xi;

  eye_int_freshAir[1].p = summary.freshAirOutlet.p/1e5;
  eye_int_freshAir[1].h = summary.freshAirOutlet.h/1e3;
  eye_int_freshAir[1].m_flow = summary.freshAirOutlet.m_flow;
  eye_int_freshAir[1].T = summary.freshAirOutlet.T - 273.15;
  eye_int_freshAir[1].s = freshAirCell.fluidOutlet.s/1e3;
  eye_int_freshAir[1].xi = freshAirCell.fluidOutlet.xi;

  connect(freshAirInlet, freshAirLeakage_split.inlet) annotation (Line(
      points={{-46,100},{-46,40},{-42,40}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(freshAirCell.outlet, freshAirOutlet) annotation (Line(
      points={{-46,-36},{-46,-100}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(freshAirLeakage_join.portA, flueGasOutlet) annotation (Line(
      points={{46,50},{46,100}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(freshAirLeakage_join.portB, flueGasCell.outlet) annotation (Line(
      points={{46,30},{46,-8}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasCell.inlet, flueGasInlet) annotation (Line(
      points={{46,-36},{46,-100}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  for i in 1:(N_cv) loop
    connect(wallSecondaryAir.outerPhase[i], flueGasCell.heat[N_cv + 1 - i])
      annotation (Line(
        points={{6,-22},{41.2,-22}},
        color={167,25,48},
        thickness=0.5,
        smooth=Smooth.None));
        end for;

  connect(freshAirLeakage_split.outlet2, freshAirCell.inlet) annotation (Line(
      points={{-32,30},{-46,30},{-46,-8}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(freshAirLeakage_split.outlet, freshAirLeakage_join.portC) annotation (Line(
      points={{-22,40},{36,40}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(freshAirCell.heat, wallSecondaryAir.innerPhase) annotation (Line(
      points={{-41.2,-22},{-4,-22}},
      color={167,25,48},
      thickness=0.5));
  connect(eye_int_flueGas[1],eye_flueGas)  annotation (Line(points={{86,82},{100,82}}, color={190,190,190}));
  connect(eye_int_freshAir[1], eye_freshAir) annotation (Line(points={{-82,-78},{-104,-78}}, color={190,190,190}));
  annotation (
    Dialog(group="Nominal Values"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html>
<p><b>Model description: </b>A model for regenerative air preheaters</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Component is build up as counter current heat exchanger with simplified heat transfer correlations</li>
<li>Heat transfer equations according to: H. Effenberger: Dampferzeugung, chapter 9.34</li>
<li>Air leakage is considered on the cold side of the air preheater with a constant value</li>
</ul></p>
</html>
<html>
<p>&nbsp;</p>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end RegenerativeAirPreheater_L4;
