within ClaRa.Components.VolumesValvesFittings.Pipes;
model Header "A header (distribution pipe) e.g. for superheater."
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

  extends ClaRa.Basics.Icons.Header;
  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  replaceable model WallMaterial = Basics.Media.Solids.Steel16Mo3 constrainedby TILMedia.SolidTypes.BaseSolid  "Wall WallMaterial" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean isAdiabat = false "True if adiabat" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));
  replaceable model InsulationMaterial = Basics.Media.Solids.InsulationOrstechLSP_H_const constrainedby TILMedia.SolidTypes.BaseSolid "Insulation WallMaterial" annotation (choicesAllMatching=true, Dialog(enable = not isAdiabat, group="Fundamental Definitions"));
  parameter Boolean frictionAtInlet = false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet = false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L4  "Pressure Loss Model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4 "Heat Transfer Model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);
  replaceable model MechanicalEquilibrium = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.Homogeneous_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4 "Mechanic Model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching=true);

  parameter ClaRa.Basics.Units.Length length=5 "Length of the pipe (one pass)" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_i=0.3 "Inner diameter of the pipe" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_o=0.33 "Outer diameter" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length thickness_insulation=0.2 "Thickness of inslation" annotation (Dialog(group="Geometry"));
  final parameter ClaRa.Basics.Units.Length insulationDiameter_i=diameter_o "Inner diameter of insulation" annotation (Dialog(group="Geometry"));
  final parameter ClaRa.Basics.Units.Length insulationDiameter_o = insulationDiameter_i+ 2*thickness_insulation "Outer diameter of insulation" annotation(Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Length z_in=0 "Height of inlet above ground" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out=0 "Height of outlet above ground" annotation (Dialog(group="Geometry"));
  parameter Integer N_tubes=1 "Number Of parallel pipes" annotation (Dialog(group="Geometry"));
  final parameter Integer N_passes=1 "Number of passes of the tubes" annotation (Dialog(group="Geometry"));

  parameter ClaRa.Basics.Units.Pressure p_nom=1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom=1e5 "Nominal specific enthalpy for single tube" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=100 "Nominal mass flow w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.PressureDifference Delta_p_nom=1e4 "Nominal pressure loss w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));
  parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start=800e3 "Initial specific enthalpy for single tube" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "Initial pressure" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=zeros(pipeFlow.medium.nc - 1) "Initial composition" annotation (Dialog(tab="Initialisation"));
  final parameter ClaRa.Basics.Units.Temperature T_fluid_start = TILMedia.VLEFluidFunctions.temperature_phxi(medium, p_start, h_start, xi_start);

  parameter Boolean isOutletHeader = false "True if component is outlet header" annotation(Dialog(tab="Summary and Visualisation"));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipeFlow(
    medium=medium,
    frictionAtInlet=frictionAtInlet,
    frictionAtOutlet=frictionAtOutlet,
    redeclare model PressureLoss = PressureLoss,
    redeclare model HeatTransfer = HeatTransfer,
    redeclare model MechanicalEquilibrium = MechanicalEquilibrium,
    p_nom={p_nom},
    h_nom={h_nom},
    m_flow_nom=m_flow_nom,
    Delta_p_nom=Delta_p_nom,
    initOption=initOption,
    h_start={h_start},
    p_start={p_start},
    xi_start=xi_start,
    length=length,
    diameter_i=diameter_i,
    z_in=z_in,
    z_out=z_out,
    N_tubes=N_tubes,
    N_passes=N_passes)
                  annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={0,-20})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 pipeWall(
    redeclare model Material = WallMaterial,
    N_rad=3,
    sizefunc=+1,
    diameter_o=diameter_o,
    diameter_i=diameter_i,
    length=length,
    N_tubes=N_tubes,
    final T_start= if isAdiabat then fill(T_fluid_start, pipeWall.N_rad) else fill(simCenter.T_amb_start, pipeWall.N_rad) + linspace(
        0.99*(T_fluid_start - simCenter.T_amb_start),
        0.94*(T_fluid_start - simCenter.T_amb_start),
        pipeWall.N_rad))
                     annotation (Placement(transformation(
        extent={{-13,-10},{13,10}},
        rotation=0,
        origin={0,0})));

  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{70,-10},{90,10}}), iconTransformation(extent={{70,-10},{90,10}})));
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-90,-10},{-70,10}}), iconTransformation(extent={{-90,-10},{-70,10}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 insulation(
    redeclare model Material = InsulationMaterial,
    N_rad=3,
    sizefunc=+1,
    diameter_o=insulationDiameter_o,
    diameter_i=insulationDiameter_i,
    length=length,
    N_tubes=N_tubes,
    final T_start=fill(simCenter.T_amb_start, insulation.N_rad) + linspace(
        0.94*(T_fluid_start - simCenter.T_amb_start),
        0.1*(T_fluid_start - simCenter.T_amb_start),
        insulation.N_rad)) if isAdiabat
                     annotation (Placement(transformation(
        extent={{-13,-10},{13,10}},
        rotation=0,
        origin={0,30})));
  BoundaryConditions.Ambience ambience(final A_heat=Modelica.Constants.pi*insulationDiameter_o*length) if isAdiabat annotation (Placement(transformation(extent={{-10,50},{10,70}})));

equation
  connect(pipeFlow.outlet, outlet) annotation (Line(
      points={{14,-20},{48,-20},{48,0},{80,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipeFlow.inlet, inlet) annotation (Line(
      points={{-14,-20},{-48,-20},{-48,0},{-80,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipeWall.outerPhase, insulation.innerPhase) annotation (Line(
      points={{0,10.1333},{0,20.4},{-0.26,20.4}},
      color={167,25,48},
      thickness=0.5));
  connect(ambience.heat, insulation.outerPhase) annotation (Line(
      points={{0,50},{0,40.1333}},
      color={167,25,48},
      thickness=0.5));
  connect(pipeFlow.heat[1], pipeWall.innerPhase) annotation (Line(
      points={{0,-16},{0,-9.6},{-0.26,-9.6}},
      color={167,25,48},
      thickness=0.5));
  annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
<p>Friedrich Gottelt, Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH, Copyright &copy; 2019-2020</p>
<p><a href=\"http://www.fvtr.de\">www.fvtr.de</a>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by Forschungszentrum f&uuml;r Verbrennungsmotoren und Thermodynamik Rostock GmbH for industry projects in cooperation with Lausitz Energie Kraftwerke AG, Cottbus.</p>
<b>Acknowledgements:</b>
<p>This model contribution is sponsored by Lausitz Energie Kraftwerke AG.</p>

<p><a href=\"http://www.leag.de\">www.leag.de</a> </p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>", revisions="<html>
<body>
<table>
  <tr>
    <th style=\"text-align: left;\">Date</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Version</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Author</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Affiliation</th>
    <th style=\"text-align: left;\">&nbsp;&nbsp;</th>
    <th style=\"text-align: left;\">Changes</th>
  </tr>
  <tr>
    <td>2020-08-20</td>
    <td> </td>
    <td>ClaRa 1.6.0</td>
    <td> </td>
    <td>Friedrich Gottelt</td>
    <td> </td>
    <td>FVTR GmbH</td>
    <td> </td>
    <td>Initial version of model</td>
  </tr>
</table>
<p>Version means first ClaRa version where the applied change was published.</p>
</body>
</html>"),Icon(coordinateSystem(                           extent={{-80,-80},{80,80}}),
                                                                graphics={
        Polygon(
          points={{-72,28},{-52,28},{-52,-32},{-72,-32}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtInlet),
        Polygon(
          points={{73,30},{53,30},{53,-30},{73,-30}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtOutlet),
        Bitmap(visible= isOutletHeader,
          extent={{-80,-80},{80,80}},
          imageSource="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",
          fileName="modelica://ClaRa/Resources/Images/Components/OutletHeader.png")}),
                                      Diagram(graphics,
                                              coordinateSystem(                           extent={{-80,-80},{80,80}})));
end Header;
