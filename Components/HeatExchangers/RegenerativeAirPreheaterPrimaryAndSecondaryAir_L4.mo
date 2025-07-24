within ClaRa.Components.HeatExchangers;
model RegenerativeAirPreheaterPrimaryAndSecondaryAir_L4 "Model for a regenerative air preheater with primary and secondary air"
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

  extends ClaRa.Basics.Icons.AirPreheaterQuart;

  //## S U M M A R Y   D E F I N I T I O N ###################################################################

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.FlangeGas flueGasInlet;
    ClaRa.Basics.Records.FlangeGas primaryAirInlet;
    ClaRa.Basics.Records.FlangeGas secondaryAirInlet;
    ClaRa.Basics.Records.FlangeGas flueGasOutlet;
    ClaRa.Basics.Records.FlangeGas primaryAirOutlet;
    ClaRa.Basics.Records.FlangeGas secondaryAirOutlet;
  end Summary;

  //## P A R A M E T E R S #######################################################################################

  parameter Boolean calculate_mass=true "True, if mass is calculated with nominal material density"
    annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Mass mass_fixed=100000 "Fixed overall storage mass" annotation (Dialog(group="Geometry", enable=not calculate_mass));

  parameter ClaRa.Basics.Units.Length diameter_reg=8 "Regenerator diameter" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_hub=0.5 "Hub diameter" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Length height_reg=2 "Regenerator height" annotation (Dialog(group="Geometry"));

  parameter Real N_sp=3500 "Number of storage plates"
    annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Length s_sp=0.6e-3 "Thickness of storage plates" annotation (Dialog(group="Geometry"));

  parameter Real C=440 "Heating surface per volume (m^2/m^3)"
    annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_covered=0.1*(A_cross - A_hub) "Covered regenerator cross section" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_flueGas_primary=0.2*(A_cross - A_hub) "Cross section hit by flue gas (which transfers heat to primary air)" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_flueGas_secondary=0.25*(A_cross - A_hub) "Cross section hit by flue gas (which transfers heat to secondary air)" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_primaryAir=0.2*(A_cross - A_hub) "Cross section hit by primary air" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_secondaryAir=0.25*(A_cross - A_hub) "Cross section hit by secondary air" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_cross=Modelica.Constants.pi/4*diameter_reg^2 "Overall regenerator cross section" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Area A_hub=Modelica.Constants.pi/4*diameter_hub^2 "Hub cross sectionHub cross section" annotation (Dialog(
      tab="General",
      group="Geometry",
      showStartAttribute=false,
      groupImage="modelica://ClaRa/Resources/Images/ParameterDialog/RegAirPreheater_PrimSec.png",
      connectorSizing=false));

  parameter Real leakage_primaryAir=0.1 "Ratio of mass leakage from hot primary air to hot secondary air"
    annotation (Dialog(group="Leakage"));
  parameter Real leakage_secondaryAir=0.05 "Ratio of mass leakage from cold secondary air to cold flue gas"
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

  inner parameter Integer initOptionWall=213 "Init Option of Wall"
    annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));

  parameter ClaRa.Basics.Units.Temperature T_start_primaryAir[N_cv]=ones(N_cv)*293.15 "Start value of primary air system Temperature"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_primaryAir[N_cv]=ones(N_cv)*1.013e5 "Start value of primary air system pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_primaryAir[medium.nc - 1]=
      medium.xi_default "Start value of primary air system mass fraction"
    annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Temperature T_start_secondaryAir[N_cv]=ones(N_cv)*293.15 "Start value of secondary air system Temperature"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_secondaryAir[N_cv]=ones(N_cv)*1.013e5 "Start value of secondary air system pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_secondaryAir[medium.nc - 1]=
      medium.xi_default "Start value of secondary air system mass fraction"
    annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Temperature T_start_flueGas[N_cv]=ones(N_cv)*400 "Start value of flue gas system Temperature"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start_flueGas[N_cv]=ones(N_cv)*1.013e5 "Start value of flue gas system pressure"
    annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_flueGas[medium.nc - 1]=medium.xi_default "Start value of flue gas system mass fraction"
    annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Temperature T_start_primary_wall[N_cv]=ones(N_cv)*350 "Start value of primary wall Temperature" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.Temperature T_start_secondary_wall[N_cv]=ones(N_cv)*350 "Start value of secondary wall Temperature" annotation (Dialog(tab="Initialisation"));

  parameter Integer stateLocation=2 "Location of wall states" annotation (
      Dialog(group="Numerical Efficiency"), choices(
      choice=1 "Inner location of states",
      choice=2 "Central location of states",
      choice=3 "Outer location of states"));

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_primaryAir_nom=250 "|Physical Effects|Nominal values|Nominal value of primary fresh air mass flow rate" annotation (Dialog(tab=""));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_secondaryAir_nom=250 "|Physical Effects|Nominal values|Nominal value of secondary fresh air mass flow rate" annotation (Dialog(tab=""));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_flueGas_nom=300 "|Physical Effects|Nominal values|Nominal value of flue gas mass flow rate" annotation (Dialog(tab=""));

  parameter ClaRa.Basics.Units.Pressure p_primaryAir_nom=1.0e5 "|Physical Effects|Nominal values|Nominal value of primary fresh air pressure loss" annotation (Dialog(tab=""));
  parameter ClaRa.Basics.Units.Pressure p_secondaryAir_nom=1.0e5 "|Physical Effects|Nominal values|Nominal value of secondary fresh air pressure loss" annotation (Dialog(tab=""));
  parameter ClaRa.Basics.Units.Pressure p_flueGas_nom=1.0e5 "|Physical Effects|Nominal values|Nominal value of flue gas pressure loss" annotation (Dialog(tab=""));

  parameter ClaRa.Basics.Units.Pressure Delta_p_primaryAir_nom=1.0e4 "|Physical Effects|Nominal values|Nominal value of primary fresh air pressure loss" annotation (Dialog(tab=""));
  parameter ClaRa.Basics.Units.Pressure Delta_p_secondaryAir_nom=1.0e4 "|Physical Effects|Nominal values|Nominal value of secondary fresh air pressure loss" annotation (Dialog(tab=""));
  parameter ClaRa.Basics.Units.Pressure Delta_p_flueGas_nom=1.0e4 "|Physical Effects|Nominal values|Nominal value of flue gas pressure loss" annotation (Dialog(tab=""));

  parameter Basics.Units.MassFraction xi_nom_primaryAir[medium.nc - 1]=
     medium.xi_default "|Physical Effects|Nominal values|Nominal composition of primary fresh air";

  parameter Basics.Units.MassFraction xi_nom_secondaryAir[medium.nc - 1]=
     medium.xi_default "|Physical Effects|Nominal values|Nominal composition of primary fresh air";

  parameter Basics.Units.MassFraction xi_nom_flueGas[medium.nc - 1]=
     medium.xi_default "|Physical Effects|Nominal values|Nominal composition of flue gas";

  inner parameter Boolean frictionAtPrimaryAirInlet=false "|Physical Effects|Pressure Loss|True if pressure loss between first primary air cell and inlet shall be considered"
                                                                                              annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtPrimaryAirOutlet=false "|Physical Effects|Pressure Loss|True if pressure loss between last primary air cell and outlet shall be considered"
                                                                                              annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtSecondaryAirInlet=false "|Physical Effects|Pressure Loss|True if pressure loss between first secondary air cell and inlet shall be considered"
                                                                                              annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtSecondaryAirOutlet=false "|Physical Effects|Pressure Loss|True if pressure loss between last secondary air cell and outlet shall be considered"
                                                                                              annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtFlueGasInlet=false "|Physical Effects|Pressure Loss|True if pressure loss between first flue gas cell and inlet shall be considered"
                                                                                              annotation (choices(checkBox=true));
  inner parameter Boolean frictionAtFlueGasOutlet=false "|Physical Effects|Pressure Loss|True if pressure loss between last flue gas cell and outlet shall be considered"
                                                                                              annotation (choices(checkBox=true));

  final parameter ClaRa.Basics.Units.Area A_heat_primary=volume_primary_eff*C "Overall primary heat transfer area";
  final parameter ClaRa.Basics.Units.Area A_heat_secondary=volume_secondary_eff*C "Overall secondary heat transfer area";
  final parameter ClaRa.Basics.Units.Length b=(diameter_reg - diameter_hub)/2 "Length of storage material plates";
  final parameter ClaRa.Basics.Units.Area A_plates=N_sp*s_sp*2*b "Cross sectional area in flow direction blocked by plates";
  final parameter Real f_plates = A_plates/(A_cross - A_hub) "Factor of cross sectional area in flow direction blocked by plates";
  final parameter ClaRa.Basics.Units.Area A_primaryAir_free=A_primaryAir*(1 - f_plates) "Cross sectional area of primary air flow";
  final parameter ClaRa.Basics.Units.Area A_secondaryAir_free=A_secondaryAir*(1 - f_plates) "Cross sectional area of secondary air flow";
  final parameter ClaRa.Basics.Units.Area A_flueGas_primary_free=A_flueGas_primary*(1 - f_plates) "Cross sectional area of primary flue gas flow";
  final parameter ClaRa.Basics.Units.Area A_flueGas_secondary_free=A_flueGas_secondary*(1 - f_plates) "Cross sectional area of secondary flue gas flow";
  final parameter ClaRa.Basics.Units.Volume volume_flueGas_primary=A_flueGas_primary_free*height_reg "Flue gas volume (primary heat exchange)";
  final parameter ClaRa.Basics.Units.Volume volume_flueGas_secondary=A_flueGas_primary_free*height_reg "Flue gas volume (secondary heat exchange)";
  final parameter ClaRa.Basics.Units.Volume volume_primaryAir=A_primaryAir_free*height_reg "Primary air volume";
  final parameter ClaRa.Basics.Units.Volume volume_secondaryAir=A_secondaryAir_free*height_reg "Secondary air volume";
  final parameter ClaRa.Basics.Units.Volume volume_primary_eff=(A_primaryAir + A_flueGas_primary)*height_reg "Effective regenerator volume (primary part)";
  final parameter ClaRa.Basics.Units.Volume volume_secondary_eff=(A_secondaryAir + A_flueGas_secondary)*height_reg "Effective regenerator volume (secondary part)";
  final parameter ClaRa.Basics.Units.Volume volume_st_primary=(A_cross - A_hub - A_secondaryAir - A_flueGas_secondary)*(f_plates)*height_reg "Volume of solid regenerator storage material (primary part)";
  final parameter ClaRa.Basics.Units.Volume volume_st_secondary=(A_cross - A_hub - A_primaryAir - A_flueGas_primary)*(f_plates)*height_reg "Volume of solid regenerator storage material (secondary part)";
  final parameter ClaRa.Basics.Units.Mass mass_primary=if calculate_mass then volume_st_primary*solid.d else mass_fixed*volume_st_primary/(volume_st_primary + volume_st_secondary) "Mass of regenerator storage material (primary part)";
  final parameter ClaRa.Basics.Units.Mass mass_secondary=if calculate_mass then volume_st_secondary*solid.d else mass_fixed*volume_st_secondary/(volume_st_primary + volume_st_secondary) "Mass of regenerator storage material (secondary part)";
  final parameter ClaRa.Basics.Units.Length d_gl=4*(A_cross - A_hub - A_plates - A_covered)/(2*N_sp*b) "Equivalent diameter";

protected
  parameter Basics.Units.Temperature T_start_primary_wall_internal[N_cv]=if size(T_start_primary_wall, 1) == 2 then linspace(
      T_start_primary_wall[1],
      T_start_primary_wall[2],
      N_cv) else T_start_primary_wall "Internal T_start array which allows the user to either state T_inlet, T_outlet if T_start has length 2, otherwise the user can specify an individual Temperature profile for initialisation";
  parameter Basics.Units.Temperature T_start_secondary_wall_internal[N_cv]=if size(T_start_secondary_wall, 1) == 2 then linspace(
      T_start_secondary_wall[1],
      T_start_secondary_wall[2],
      N_cv) else T_start_secondary_wall "Internal T_start array which allows the user to either state T_inlet, T_outlet if T_start has length 2, otherwise the user can specify an individual Temperature profile for initialisation";

public
  final parameter Real flueGas_split_ratio=A_flueGas_primary_free/(
      A_flueGas_secondary_free + A_flueGas_primary_free);

  //_____________defintion of medium used in cells__________________________________________________________
  inner parameter TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel "Medium to be used in cells"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  //## V A R I A B L E   P A R T##################################################################################

  outer ClaRa.SimCenter simCenter;

  //____Connectors_______________________________________________________________________________________________

  ClaRa.Basics.Interfaces.GasPortIn flueGasInlet(Medium=medium) "Inlet port"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-100}),iconTransformation(extent={{90,-70},{110,-50}})));

  ClaRa.Basics.Interfaces.GasPortOut flueGasOutlet(Medium=medium) "Outlet port"
                  annotation (Placement(transformation(extent={{70,90},{90,110}}),
        iconTransformation(extent={{90,50},{110,70}})));

  ClaRa.Basics.Interfaces.GasPortIn secondaryAirInlet(Medium=medium) "Inlet port"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-76,100}),iconTransformation(extent={{-110,-50},{-90,-30}})));

  ClaRa.Basics.Interfaces.GasPortOut secondaryAirOutlet(Medium=medium) "Outlet port"
                  annotation (Placement(transformation(extent={{-92,-110},{-72,
            -90}}),
        iconTransformation(extent={{-110,-90},{-90,-70}})));

  ClaRa.Basics.Interfaces.GasPortIn primaryAirInlet(Medium=medium) "Inlet port"
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,100}),iconTransformation(extent={{-110,70},{-90,90}})));

  ClaRa.Basics.Interfaces.GasPortOut primaryAirOutlet(Medium=medium) "Outlet port"
                  annotation (Placement(transformation(extent={{20,-110},{40,
            -90}}),
        iconTransformation(extent={{-110,30},{-90,50}})));

  //______________________ replaceable models _____________________________
  replaceable model PressureLoss =
    ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L4 "|Physical Effects|Pressure Loss|Pressure loss model at the tubes side"
    annotation(choicesAllMatching);

  replaceable model HeatTransferFlueGas =
    ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_regenerativeAirPreheater_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4 "|Physical Effects|Heat Transfer|Heat transfer model"
   annotation(choicesAllMatching);

  replaceable model HeatTransferSecondaryAir =
    ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_regenerativeAirPreheater_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4 "|Physical Effects|Heat Transfer|Heat transfer model"
   annotation(choicesAllMatching);

  replaceable model HeatTransferPrimaryAir =
    ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_regenerativeAirPreheater_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_L4 "|Physical Effects|Heat Transfer|Heat transfer model"
   annotation(choicesAllMatching);

  replaceable model Material = TILMedia.Solid.Types.TILMedia_Aluminum
    constrainedby TILMedia.Solid.Types.BaseSolid
                                                "Regenerator storage material"
    annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

  TILMedia.Solid.Solid solid(redeclare replaceable model SolidType = Material, T=293.15)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

  Basics.ControlVolumes.GasVolumes.VolumeGas_L4 flueGasCellSecondary(
    T_start=T_start_flueGas,
    p_start=p_start_flueGas,
    Delta_p_nom=Delta_p_flueGas_nom,
    each xi_start=xi_start_flueGas,
    each xi_nom=xi_nom_flueGas,
    each useHomotopy=useHomotopy,
    each m_flow_nom=m_flow_flueGas_nom*(1 - flueGas_split_ratio),
    each p_nom=p_flueGas_nom*ones(N_cv),
    each T_nom=293.15*ones(N_cv),
    frictionAtInlet=frictionAtFlueGasInlet,
    frictionAtOutlet=frictionAtFlueGasOutlet,
    redeclare model HeatTransfer = HeatTransferFlueGas (heatSurfaceAlloc=1),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv (
        N_heat=1,
        N_cv=N_cv,
        diameter_hyd=fill(d_gl, N_cv),
        volume=ones(N_cv)*volume_flueGas_secondary/N_cv,
        A_cross=ones(N_cv)*A_flueGas_secondary_free,
        A_heat=ones(N_cv, 1)*A_heat_secondary/N_cv),
    redeclare model PressureLoss = PressureLoss,
    initOption=initOptionCells) annotation (Placement(transformation(
        extent={{-14,-6},{14,6}},
        rotation=90,
        origin={-28,0})));

  Basics.ControlVolumes.GasVolumes.VolumeGas_L4 secondaryAirCell(
    T_start=T_start_secondaryAir,
    p_start=p_start_secondaryAir,
    Delta_p_nom=Delta_p_secondaryAir_nom,
    each xi_start=xi_start_secondaryAir,
    each xi_nom=xi_nom_secondaryAir,
    each useHomotopy=useHomotopy,
    each m_flow_nom=m_flow_secondaryAir_nom,
    each p_nom=p_secondaryAir_nom*ones(N_cv),
    each T_nom=293.15*ones(N_cv),
    frictionAtInlet=frictionAtSecondaryAirInlet,
    frictionAtOutlet=frictionAtSecondaryAirOutlet,
    redeclare model HeatTransfer = HeatTransferSecondaryAir (heatSurfaceAlloc=1),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv (
        N_heat=1,
        N_cv=N_cv,
        diameter_hyd=fill(d_gl, N_cv),
        volume=ones(N_cv)*volume_secondaryAir/N_cv,
        A_cross=ones(N_cv)*A_secondaryAir_free,
        A_heat=ones(N_cv, 1)*A_heat_secondary/N_cv),
    redeclare model PressureLoss = PressureLoss,
    initOption=initOptionCells) annotation (Placement(transformation(
        extent={{-14,-6},{14,6}},
        rotation=270,
        origin={-82,0})));

  Basics.ControlVolumes.GasVolumes.VolumeGas_L4 flueGasCellPrimary(
    T_start=T_start_flueGas,
    p_start=p_start_flueGas,
    Delta_p_nom=Delta_p_flueGas_nom,
    each xi_start=xi_start_flueGas,
    each xi_nom=xi_nom_flueGas,
    each useHomotopy=useHomotopy,
    each m_flow_nom=m_flow_flueGas_nom*flueGas_split_ratio,
    each p_nom=p_flueGas_nom*ones(N_cv),
    each T_nom=293.15*ones(N_cv),
    frictionAtInlet=frictionAtFlueGasInlet,
    frictionAtOutlet=frictionAtFlueGasOutlet,
    redeclare model HeatTransfer = HeatTransferFlueGas (heatSurfaceAlloc=1),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv (
        N_heat=1,
        N_cv=N_cv,
        diameter_hyd=fill(d_gl, N_cv),
        volume=ones(N_cv)*volume_flueGas_primary/N_cv,
        A_cross=ones(N_cv)*A_flueGas_primary_free,
        A_heat=ones(N_cv, 1)*A_heat_primary/N_cv),
    redeclare model PressureLoss = PressureLoss,
    initOption=initOptionCells) annotation (Placement(transformation(
        extent={{-14,-6},{14,6}},
        rotation=90,
        origin={80,0})));

  Basics.ControlVolumes.GasVolumes.VolumeGas_L4 primaryAirCell(
    T_start=T_start_primaryAir,
    p_start=p_start_primaryAir,
    Delta_p_nom=Delta_p_primaryAir_nom,
    each xi_start=xi_start_primaryAir,
    each xi_nom=xi_nom_primaryAir,
    each useHomotopy=useHomotopy,
    each m_flow_nom=m_flow_primaryAir_nom,
    each p_nom=p_primaryAir_nom*ones(N_cv),
    each T_nom=293.15*ones(N_cv),
    frictionAtInlet=frictionAtPrimaryAirInlet,
    frictionAtOutlet=frictionAtPrimaryAirOutlet,
    redeclare model HeatTransfer = HeatTransferPrimaryAir (heatSurfaceAlloc=1),
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv (
        N_heat=1,
        N_cv=N_cv,
        diameter_hyd=fill(d_gl, N_cv),
        volume=ones(N_cv)*volume_primaryAir/N_cv,
        A_cross=ones(N_cv)*A_primaryAir_free,
        A_heat=ones(N_cv, 1)*A_heat_primary/N_cv),
    redeclare model PressureLoss = PressureLoss,
    initOption=initOptionCells) annotation (Placement(transformation(
        extent={{-14,-6},{14,6}},
        rotation=270,
        origin={30,1.77636e-015})));

  Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 wallPrimaryAir(
    redeclare replaceable model Material = Material,
    each thickness_wall=s_sp,
    each initOption=initOptionWall,
    T_start=T_start_primary_wall_internal,
    each stateLocation=stateLocation,
    mass_struc=mass_primary - wallPrimaryAir.length*wallPrimaryAir.width*s_sp*wallPrimaryAir.solid[1].d,
    CF_area=A_heat_primary/(wallPrimaryAir.length*wallPrimaryAir.width),
    N_ax=N_cv) annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=-90,
        origin={55,1.77636e-015})));

  Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 wallSecondaryAir(
    redeclare replaceable model Material = Material,
    each thickness_wall=s_sp,
    each initOption=initOptionWall,
    T_start=T_start_secondary_wall_internal,
    each stateLocation=stateLocation,
    N_ax=N_cv,
    CF_area=A_heat_secondary/(wallSecondaryAir.length*wallSecondaryAir.width),
    mass_struc=mass_secondary - wallSecondaryAir.length*wallSecondaryAir.width*s_sp*wallSecondaryAir.solid[1].d) annotation (Placement(transformation(
        extent={{-10,-5},{10,5}},
        rotation=-90,
        origin={-55,1.77636e-015})));

  VolumesValvesFittings.Valves.ThreeWayValveGas_L1_simple flueGasSplit(splitRatio_fixed=flueGas_split_ratio) annotation (Placement(transformation(
        extent={{-10,9},{10,-9}},
        rotation=180,
        origin={66,-31})));
  VolumesValvesFittings.Fittings.FlueGasJunction_L2
                                                 flueGasJoin(T_start=if size(T_start_flueGas,1)==2 then T_start_flueGas[2] else T_start_flueGas[1],p_start=if size(p_start_flueGas,1)==2 then p_start_flueGas[2] else p_start_flueGas[1],xi_start=xi_start_flueGas,
    volume=2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,28})));
  VolumesValvesFittings.Valves.ThreeWayValveGas_L1_simple primaryLeakage(splitRatio_fixed=leakage_primaryAir) annotation (Placement(transformation(
        extent={{-10,9},{10,-9}},
        rotation=180,
        origin={-10,-59})));
  VolumesValvesFittings.Fittings.FlueGasJunction_L2
                                                 primaryLeakageJoin(T_start=if size(T_start_secondaryAir,1)==2 then T_start_secondaryAir[2] else T_start_secondaryAir[1],p_start=if size(p_start_secondaryAir,1)==2 then p_start_secondaryAir[2] else p_start_secondaryAir[1],xi_start=xi_start_secondaryAir,
    volume=2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-82,-60})));
  VolumesValvesFittings.Valves.ThreeWayValveGas_L1_simple secondaryLeakage(splitRatio_fixed=leakage_secondaryAir) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-63,77})));
  VolumesValvesFittings.Fittings.FlueGasJunction_L2
                                                 secondaryLeakageJoin(                                                                                      p_start=if size(p_start_flueGas,1)==2 then p_start_flueGas[2] else p_start_flueGas[1],xi_start=xi_start_flueGas,
    volume=2,
    T_start=if size(T_start_flueGas, 1) == 2 then T_start_flueGas[2]*(1 - leakage_secondaryAir) else T_start_flueGas[1]*(1 - leakage_secondaryAir))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,78})));

  Summary summary(
    flueGasInlet(
      mediumModel=medium,
      m_flow=flueGasCellPrimary.inlet.m_flow,
      T=inStream(flueGasCellPrimary.inlet.T_outflow),
      p=flueGasCellPrimary.inlet.p,
      h=flueGasCellPrimary.fluidInlet.h,
      xi=inStream(flueGasCellPrimary.inlet.xi_outflow),
      H_flow=flueGasCellPrimary.inlet.m_flow*flueGasCellPrimary.fluidInlet.h),
    primaryAirInlet(
      mediumModel=medium,
      m_flow=primaryAirCell.inlet.m_flow,
      T=inStream(primaryAirCell.inlet.T_outflow),
      p=primaryAirCell.inlet.p,
      h=primaryAirCell.fluidInlet.h,
      xi=inStream(primaryAirCell.inlet.xi_outflow),
      H_flow=primaryAirCell.inlet.m_flow*primaryAirCell.fluidInlet.h),
    secondaryAirInlet(
      mediumModel=medium,
      m_flow=secondaryAirCell.inlet.m_flow,
      T=inStream(secondaryAirCell.inlet.T_outflow),
      p=secondaryAirCell.inlet.p,
      h=secondaryAirCell.fluidInlet.h,
      xi=inStream(secondaryAirCell.inlet.xi_outflow),
      H_flow=secondaryAirCell.inlet.m_flow*secondaryAirCell.fluidInlet.h),
    flueGasOutlet(
      mediumModel=medium,
      m_flow=-secondaryLeakageJoin.portA.m_flow,
      T=secondaryLeakageJoin.portA.T_outflow,
      p=secondaryLeakageJoin.portA.p,
      h=secondaryLeakageJoin.flueGasIn.h,
      xi=secondaryLeakageJoin.portA.xi_outflow,
      H_flow=-secondaryLeakageJoin.portA.m_flow*secondaryLeakageJoin.flueGasIn.h),
    primaryAirOutlet(
      mediumModel=medium,
      m_flow=-primaryAirCell.outlet.m_flow,
      T=primaryAirCell.outlet.T_outflow,
      p=primaryAirCell.outlet.p,
      h=primaryAirCell.fluidOutlet.h,
      xi=primaryAirCell.outlet.xi_outflow,
      H_flow=-primaryAirCell.outlet.m_flow*primaryAirCell.fluidOutlet.h),
    secondaryAirOutlet(
      mediumModel=medium,
      m_flow=-primaryLeakageJoin.portA.m_flow,
      T=primaryLeakageJoin.portA.T_outflow,
      p=primaryLeakageJoin.portA.p,
      h=primaryLeakageJoin.flueGasIn.h,
      xi=primaryLeakageJoin.portA.xi_outflow,
      H_flow=-primaryLeakageJoin.portA.m_flow*primaryLeakageJoin.flueGasIn.h));

  VolumesValvesFittings.Valves.GenericValveGas_L1 valveGas_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                                                                                       Delta_p_nom=5, m_flow_nom=m_flow_flueGas_nom)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={80,54})));
  ClaRa.Basics.Interfaces.EyeOutGas[2] eye_air(each medium=medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-56,-102}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-104})));

protected
  ClaRa.Basics.Interfaces.EyeInGas[2] eye_int_air(each medium=medium) annotation (Placement(transformation(extent={{-1,-1},{1,1}},
        rotation=270,
        origin={-56,-74})));

public
  ClaRa.Basics.Interfaces.EyeOutGas eye_flueGas(each medium=medium)
                                            annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,82}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={102,86})));
protected
  ClaRa.Basics.Interfaces.EyeInGas eye_int_flueGas[1](each medium=medium)
                                               annotation (Placement(transformation(extent={{-1,-1},{1,1}},
        rotation=0,
        origin={86,82})));
equation
  eye_int_air[1].p = summary.primaryAirOutlet.p/1e5;
  eye_int_air[1].h = summary.primaryAirOutlet.h/1e3;
  eye_int_air[1].m_flow = summary.primaryAirOutlet.m_flow;
  eye_int_air[1].T = summary.primaryAirOutlet.T - 273.15;
  eye_int_air[1].s = primaryAirCell.fluidOutlet.s/1e3;
  eye_int_air[1].xi = primaryAirCell.fluidOutlet.xi;

  eye_int_air[2].p = summary.secondaryAirOutlet.p/1e5;
  eye_int_air[2].h = summary.secondaryAirOutlet.h/1e3;
  eye_int_air[2].m_flow = summary.secondaryAirOutlet.m_flow;
  eye_int_air[2].T = summary.secondaryAirOutlet.T - 273.15;
  eye_int_air[2].s = secondaryAirCell.fluidOutlet.s/1e3;
  eye_int_air[2].xi = secondaryAirCell.fluidOutlet.xi;

  eye_int_flueGas[1].p = summary.flueGasOutlet.p/1e5;
  eye_int_flueGas[1].h = summary.flueGasOutlet.h/1e3;
  eye_int_flueGas[1].m_flow = summary.flueGasOutlet.m_flow;
  eye_int_flueGas[1].T = summary.flueGasOutlet.T - 273.15;
  eye_int_flueGas[1].s =secondaryLeakageJoin.flueGasIn.s/1e3;
  eye_int_flueGas[1].xi =secondaryLeakageJoin.flueGasIn.xi;

  for i in 1:(N_cv) loop
  connect(wallSecondaryAir.outerPhase[i], flueGasCellSecondary.heat[N_cv + 1 - i]) annotation (
      Line(
      points={{-50,0},{-44,0},{-44,1.33227e-015},{-32.8,1.33227e-015}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
   connect(flueGasCellPrimary.heat[N_cv + 1 - i], wallPrimaryAir.outerPhase[i]) annotation (Line(
      points={{75.2,4.44089e-016},{66,4.44089e-016},{66,0},{60,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  end for;

  connect(flueGasInlet, flueGasSplit.inlet) annotation (Line(
      points={{80,-100},{80,-30},{76,-30}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasSplit.outlet, flueGasCellPrimary.inlet) annotation (Line(
      points={{56,-30},{52,-30},{52,-18},{80,-18},{80,-14}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasSplit.outlet2, flueGasCellSecondary.inlet) annotation (Line(
      points={{66,-40},{66,-46},{-28,-46},{-28,-14}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasJoin.portB, flueGasCellPrimary.outlet) annotation (Line(
      points={{80,18},{80,14}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flueGasJoin.portC, flueGasCellSecondary.outlet) annotation (Line(
      points={{70,28},{-28,28},{-28,14}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(primaryAirCell.outlet, primaryLeakage.inlet) annotation (Line(
      points={{30,-14},{30,-58},{0,-58}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(secondaryAirCell.outlet, primaryLeakageJoin.portB) annotation (Line(
      points={{-82,-14},{-82,-50}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(primaryLeakageJoin.portA, secondaryAirOutlet) annotation (Line(
      points={{-82,-70},{-82,-100}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(primaryLeakage.outlet, primaryLeakageJoin.portC) annotation (Line(
      points={{-20,-58},{-46,-58},{-46,-60},{-72,-60}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(primaryLeakage.outlet2, primaryAirOutlet) annotation (Line(
      points={{-10,-68},{-10,-78},{30,-78},{30,-100}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(secondaryLeakageJoin.portC, secondaryLeakage.outlet) annotation (Line(
      points={{70,78},{-54,78}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(primaryAirInlet, primaryAirCell.inlet) annotation (Line(
      points={{30,100},{30,14}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(secondaryLeakage.inlet, secondaryAirInlet) annotation (Line(
      points={{-72,78},{-76,78},{-76,100}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(secondaryLeakage.outlet2, secondaryAirCell.inlet) annotation (Line(
      points={{-63,68},{-63,30},{-82,30},{-82,14}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(primaryAirCell.heat, wallPrimaryAir.innerPhase) annotation (Line(
      points={{34.8,-1.11022e-015},{44,-1.11022e-015},{44,0},{50,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(flueGasJoin.portA, valveGas_L1_1.inlet) annotation (Line(
      points={{80,38},{80,42},{80,44},{80,44}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valveGas_L1_1.outlet, secondaryLeakageJoin.portB) annotation (Line(
      points={{80,64},{80,66},{80,66},{80,68}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(secondaryLeakageJoin.portA, flueGasOutlet) annotation (Line(
      points={{80,88},{80,100}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_air[:], eye_int_air[:]) annotation (Line(points={{-56,-102},{-56,-74}}, color={190,190,190}));
  connect(eye_int_flueGas[1], eye_flueGas) annotation (Line(points={{86,82},{100,82}}, color={190,190,190}));
  connect(secondaryAirCell.heat, wallSecondaryAir.innerPhase) annotation (Line(
      points={{-77.2,0},{-60,0}},
      color={167,25,48},
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b>Model description: </b>A model for regenerative air preheaters</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Component is build up as counter current heat exchanger with simplified heat transfer correlations</li>
<li>Heat transfer equations according to: H. Effenberger: Dampferzeugung, chapter 9.34</li>
<li>Two air mass flows (primary and secondary) are considered</li>
<li>Due to the modeling as counter current heat exchanger, the flue gas mass flow is split up by imaginary flue gas areas (normally one single cross sectional area)</li>
<li>Air leakage is considered from primary to secondary air on the hot side and from secondary air to flue gas on the cold side with constant values</li>
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
end RegenerativeAirPreheaterPrimaryAndSecondaryAir_L4;
