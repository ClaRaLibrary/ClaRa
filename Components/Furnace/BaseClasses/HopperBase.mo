within ClaRa.Components.Furnace.BaseClasses;
partial model HopperBase

//## P A R A M E T E R S #######################################################################################
   //__________________________/ Media definintions \______________________________________________
  outer ClaRa.SimCenter simCenter;
  inner parameter ClaRa.Basics.Media.FuelTypes.BaseFuel fuelModel=simCenter.fuelModel1 "Fuel elemental composition used for combustion" annotation(choices(choice=simCenter.fuelModel1 "Fuel model 1 as defined in simCenter"),
                                                                                            Dialog(group="Media Definitions"));
  parameter ClaRa.Basics.Media.Slag.PartialSlag slagType=simCenter.slagModel "Slag properties" annotation (choices(choice=simCenter.slagModel "Slag model 1 as defined in simCenter"), Dialog(group="Media Definitions"));
  inner parameter TILMedia.Gas.Types.BaseGas flueGas=simCenter.flueGasModel "Flue gas model used in component"
    annotation (choicesAllMatching, Dialog(group="Media Definitions"));
  parameter Integer slagTemperature_calculationType=1 "Calculation type of outflowing slag temperature" annotation (Dialog(tab="Combustion Settings",group="Slag temperature definitions"), choices(
      choice=1 "Fixed slag temperature",
      choice=2 "Outlet flue gas temperature",
      choice=3 "Mean flue gas temperature",
      choice=4 "Inlet flue gas temperature"));

  inner parameter ClaRa.Basics.Units.Temperature T_slag=900 "Constant slag outlet temperature" annotation (Dialog(enable=(slagTemperature_calculationType == 1),tab="Combustion Settings", group="Slag temperature definitions"));

  //__________________________/ HeatTransfer \______________________________________________
    replaceable model HeatTransfer_Wall =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas "1st: choose geometry definition | 2nd: edit corresponding record"
                                                                       annotation (Dialog(group="Heat Transfer"), choicesAllMatching=true);

  replaceable model HeatTransfer_Top =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Radiation.Radiation_gas2Wall_L2
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas "1st: choose geometry definition | 2nd: edit corresponding record"
                                                                       annotation (Dialog(group="Heat Transfer"), choicesAllMatching=true);

  replaceable model RadiationTimeConstant =
      ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.ThermalLowPass
    constrainedby ClaRa.Components.Furnace.GeneralTransportPhenomena.ThermalCapacities.PartialThermalCapacity
                                                                                            annotation (Dialog(group="Heat transfer correlations"), choicesAllMatching=true);
//________________________/Chemistry \________________________________________________________
  replaceable model ReactionZone =
      ClaRa.Components.Furnace.ChemicalReactions.CoalReactionZone
    constrainedby ClaRa.Components.Furnace.ChemicalReactions.PartialReactionZone "Model to regard chemical reactions"
                                         annotation (Dialog(tab="Combustion Settings",group=
          "Combustion"), choicesAllMatching=true);

  replaceable model Burning_time =
      ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.ConstantBurningTime
    constrainedby ClaRa.Components.Furnace.GeneralTransportPhenomena.BurningTime.PartialBurningTime "Model for the buring time"
                                annotation (Dialog(tab="Combustion Settings",group="Combustion"),
      choicesAllMatching=true);

  replaceable model ParticleMigration =
      ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.MeanMigrationSpeed
    constrainedby ClaRa.Components.Furnace.GeneralTransportPhenomena.ParticleMigration.PartialMigrationSpeed "Model for the particle migration speed"
                                             annotation (Dialog(tab="Combustion Settings",group=
          "Combustion"), choicesAllMatching=true);

  //__________________________/ Geometry \______________________________________________
  replaceable model Geometry =
  ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlock(flowOrientation = ClaRa.Basics.Choices.GeometryOrientation.vertical) constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry(height_fill=-1)   "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Geometry"), choicesAllMatching=true);
  //__________________/ Parameter \_______________________________________________

  inner parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom= 10 "Nominal mass flow rates at inlet" annotation(Dialog(group="Nominal Values"));

  //_______________________/ Start values \_____________________________________________________________
  parameter ClaRa.Basics.Units.Pressure p_start_flueGas_out=1e5 "Start pressure at outlet" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Temperature T_start_flueGas_out=700 "Start temperature at outlet" annotation (Dialog(tab="Initialisation"));
  inner parameter ClaRa.Basics.Units.Temperature T_top_initial= T_start_flueGas_out "Initial temperature of top volume" annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start_flueGas_out[flueGas.nc - 1]={0.01,0,0.1,0,0.74,0.13,0,0.02,0} "Start composition of flue gas" annotation (Dialog(tab="Initialisation"));
  //   parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_flueGas_in_start=1 annotation(Dialog(tab="Initialisation"));
//  parameter ClaRa.Basics.Units.VolumeFlowRate V_flow_flueGas_out_start=-15 "Start volume flow at outlet" annotation(Dialog(tab="Initialisation"));
  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start = TILMedia.Gas.Functions.specificEnthalpy_pTxi(
                                                                                                                flueGas, p_start_flueGas_out, T_start_flueGas_out, xi_start_flueGas_out) "Start flue gas enthalpy"
                                                                                            annotation(Dialog(tab="Initialisation"));

  constant Real T_0=298.15 "Reference temperature";
  inner parameter ClaRa.Basics.Units.Time Tau=0.01 "Time constant for heat transfer temperature delay" annotation (Dialog(tab="Expert Settings"));

//## V A R I A B L E   P A R T##################################################################################

protected
  inner ClaRa.Basics.Units.MassFraction xi_fuel "amount of fuel per flue gas mass";

//________________/ FlueGas Composition \_____________________
public
  inner ClaRa.Basics.Units.MassFraction xi_flueGas[flueGas.nc - 1] "Flue gas composition ";
//________________/ Fuel Composition \_____________________
//  ClaRa.Basics.Units.MassFraction xi_fuel_out[FuelType.N_c - 1] "Fuel outlet composition";

//_____________/ Calculated quantities \_________________________________
  inner ClaRa.Basics.Units.Area A_cross=geo.A_front "Cross section";
  inner ClaRa.Basics.Units.VolumeFlowRate V_flow_flueGas_in "Inlet volume flow";
                                                        //(start=V_flow_flueGas_in_start);
  inner ClaRa.Basics.Units.VolumeFlowRate V_flow_flueGas_out "Outlet volume flow";
                                                         //(start=V_flow_flueGas_out_start);//(start = -20);
  ClaRa.Basics.Units.Mass mass "Gas mass";
  ClaRa.Basics.Units.HeatFlowRate Q_flow_top "Heat flow from top section";
  ClaRa.Basics.Units.HeatFlowRate Q_flow_bottom "Heat flow from bottom section";
  ClaRa.Basics.Units.HeatFlowRate Q_flow_wall "Heat flow from walls";

  //ClaRa.Basics.Units.MassFraction elementaryComposition_fuel_in[FuelType.N_e - 1] "Fuel inlet composition";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_flueGas_out "Gas outlet specific enthalpy";
  ClaRa.Basics.Units.EnthalpyMassSpecific h_flueGas_out_del "Gas outlet specific enthalpy - delayed";

  //ClaRa.Basics.Units.MassFraction xi_flueGas_del[flueGas.nc - 1] "Flue gas outlet composition - dalayed";

    //________________________/ Connectors \_______________________________________________________
  ClaRa.Basics.Interfaces.FuelSlagFlueGas_inlet inlet(
    flueGas(final Medium=flueGas),
    fuelModel=fuelModel,
    final slagType=slagType)
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,-100})));
  ClaRa.Basics.Interfaces.FuelSlagFlueGas_outlet outlet(
    flueGas(final Medium=flueGas, m_flow(start=-1)),
    fuelModel=fuelModel,
    final slagType=slagType)                                                                        annotation (Placement(transformation(extent={{-130,90},
            {-110,110}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,100})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat_wall
    annotation (Placement(transformation(extent={{290,-10},{310,10}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat_top
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat_bottom
     annotation (Placement(transformation(extent={{10,-90},{30,-110}})));

   //_____________________/ Media Objects \_________________________________
protected
  TILMedia.Gas.Gas_pT flueGasInlet(
    p=inlet.flueGas.p,
    T=actualStream(inlet.flueGas.T_outflow),
    xi=actualStream(inlet.flueGas.xi_outflow),
    gasType=flueGas) annotation (Placement(transformation(extent={{-130,-88},{-110,-68}})));

  TILMedia.Gas.Gas_pT flueGasOutlet(
    p=outlet.flueGas.p,
    T=noEvent(actualStream(outlet.flueGas.T_outflow)),
    xi=noEvent(actualStream(outlet.flueGas.xi_outflow)),
    gasType=flueGas) annotation (Placement(transformation(extent={{-130,74},{-110,94}})));
  Basics.Media.FuelObject fuelInlet(
    p=inlet.fuel.p,
    T=noEvent(actualStream(inlet.fuel.T_outflow)),
    xi_c=noEvent(actualStream(inlet.fuel.xi_outflow))) annotation (Placement(transformation(extent={{-152,-88},{-132,-68}})));
  Basics.Media.FuelObject fuelOutlet(
    p=outlet.fuel.p,
    T=noEvent(actualStream(outlet.fuel.T_outflow)),
    xi_c=noEvent(actualStream(outlet.fuel.xi_outflow))) annotation (Placement(transformation(extent={{-156,68},{-136,88}})));

//________________________/ replaceable models for heat transfer, pressure loss and geometry \_________________________

public
  inner Geometry geo annotation(Placement(transformation(extent={{-250,50},{-230,
            70}})));

  inner HeatTransfer_Wall heattransfer_wall(heatSurfaceAlloc=1)  annotation(Placement(transformation(extent={{232,-10},
            {252,10}})));

  inner HeatTransfer_Top heattransfer_top annotation(Placement(transformation(extent={{94,50},
            {74,70}})));

  inner RadiationTimeConstant radiationTimeConstant(T_out_initial=T_top_initial, Tau=Tau)
                                                                                        annotation (Placement(transformation(extent={{32,50},
            {52,70}})));

  Basics.Interfaces.EyeOutGas
                           eyeOut(medium=flueGas) annotation (Placement(transformation(extent={{-286,78},
            {-314,102}}),         iconTransformation(extent={{-290,70},{-310,90}})));
protected  Basics.Interfaces.EyeInGas
                                   eye_int[1](each medium=flueGas)
                                annotation (Placement(transformation(extent={{-254,84},
            {-266,96}}),      iconTransformation(extent={{240,-64},{232,-56}})));
public
  parameter Boolean showData = false "True, if characteristic data shall be visualised in model icon"  annotation(Dialog(tab="Summary and Visualisation"));

initial equation

  h_flueGas_out_del = h_start;
  //xi_flueGas_del = xi_start_flueGas_out;

equation

  der(h_flueGas_out_del) = 1/Tau*(h_flueGas_out-h_flueGas_out_del);
  //der(xi_flueGas_del) = 1/Tau*(xi_flueGas - xi_flueGas_del);

   //____________/ Xi_outflow of Fuel and FlueGas \__________________
  outlet.fuel.xi_outflow = inStream(inlet.fuel.xi_outflow);
  inlet.fuel.xi_outflow = inStream(inlet.fuel.xi_outflow);

  //_____________/ Pressure \______________________________________________
  inlet.flueGas.p = outlet.flueGas.p;
  inlet.fuel.p = outlet.fuel.p;
  inlet.slag.p = outlet.slag.p;

  //____________/ Heat port temperatures and Q_flows \____________________________
   Q_flow_wall = heat_wall.Q_flow;
   Q_flow_top = heat_top.Q_flow;
   Q_flow_bottom = heat_bottom.Q_flow;

 //______________Eye port variable definition________________________
  eye_int[1].m_flow = -outlet.flueGas.m_flow;
  eye_int[1].T = flueGasOutlet.T-273.15;
  eye_int[1].s = flueGasOutlet.s/1e3;
  eye_int[1].p = flueGasOutlet.p/1e5;
  eye_int[1].h = flueGasOutlet.h/1e3;
  eye_int[1].xi = flueGasOutlet.xi;

 //_____________/ Connections \______________________________________________
  connect(heat_top, radiationTimeConstant.heat_in) annotation (Line(
      points={{20,100},{20,60},{32,60}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radiationTimeConstant.heat_out, heattransfer_top.heat) annotation (
      Line(
      points={{52,60},{74,60}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heattransfer_wall.heat, heat_wall) annotation (Line(
      points={{252,0},{300,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(eye_int[1],eyeOut)
                         annotation (Line(
      points={{-260,90},{-300,90}},
      color={190,190,190},
      smooth=Smooth.None));
   annotation (Documentation(info="<html>
<p><b>Model description: </b>Base class for burner and furnace sections</p>
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
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false,extent={{-300,-100},
            {300,100}}),
                   graphics),               Diagram(graphics,
                                                    coordinateSystem(
          preserveAspectRatio=false,extent={{-300,-100},{300,100}})));
end HopperBase;
