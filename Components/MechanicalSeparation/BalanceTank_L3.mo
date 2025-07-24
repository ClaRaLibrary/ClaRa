within ClaRa.Components.MechanicalSeparation;
model BalanceTank_L3 "A balance tank with a vent"
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
 extends ClaRa.Basics.Icons.BalanceTank;
  outer ClaRa.SimCenter simCenter;

  parameter TILMedia.VLEFluid.Types.BaseVLEFluid liquidMedium=simCenter.fluid1 "Liquid medium in the component"
    annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  parameter TILMedia.Gas.Types.BaseGas gasMedium=simCenter.flueGasModel "Gas medium in the component"
    annotation (choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  replaceable model Material = TILMedia.Solid.Types.TILMedia_Aluminum
                                                                     constrainedby TILMedia.Solid.Types.BaseSolid
                                                                                                                 "Solid material of the tank"
    annotation (choicesAllMatching=true,Dialog(group="Fundamental Definitions"));
  replaceable model HeatTransfer =
      Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L3 "Heat transfer model"
    annotation (choicesAllMatching=true,Dialog(group="Fundamental Definitions"));
  replaceable model PressureLoss =
      Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L3 "|Fundamental Definitions|Pressure loss model"
    annotation (choicesAllMatching=true,Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length diameter_i=2 "|Geometry|Inner diameter of the tank";
  parameter ClaRa.Basics.Units.Length s_wall=2 "|Geometry|Wall thickness of the tank";
  parameter ClaRa.Basics.Units.Length height=2 "|Geometry|Height of the tank";
  parameter ClaRa.Basics.Units.Temperature T_start[3]=ones(3)*293.15 "|Initialisation|Wall|Start values of wall temperature";
  parameter Integer initOptionWall=213 "|Initialisation|Wall|Wall init option"
    annotation (choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=213 "Fixed temperature",
      choice=203 "Steady temperature"));

  parameter ClaRa.Basics.Units.Length z_in[3]=ones(3)*height "|Geometry|Height of liquid inlet ports";
  parameter ClaRa.Basics.Units.Length z_out[1]={0.1} "|Geometry|Height of liquid outlet ports";

  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_ph=500 "|Expert Settings|Phase Border|HTC of the phase border";
  parameter ClaRa.Basics.Units.Area A_phaseBorder=volume.geo.A_hor*100 "|Expert Settings|Phase Border|Heat transfer area at phase border";

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_liq_start=-10 + TILMedia.VLEFluid.MixtureCompatible.Functions.bubbleSpecificEnthalpy_pxi(                                     liquidMedium, p_start) "|Initialisation|Fluids|Start value ofliquid specific enthalpy";
  parameter ClaRa.Basics.Units.Temperature T_gas_start=293.15 "|Initialisation|Fluids|Start value of gas zone's temperature";
  parameter ClaRa.Basics.Units.Pressure p_start=1e5 "|Initialisation|Fluids|Start value of sytsem pressure";
  parameter ClaRa.Basics.Units.MassFraction xi_start[gasMedium.nc - 1]=zeros(gasMedium.nc - 1) "|Initialisation|Fluids|Initial gas mass fraction";
  parameter Real relLevel_start=0.5 "|Initialisation|Fluids|Initial value for relative level";
  parameter String initFluid="No init, use start values as guess" "|Initialisation|Fluids|Type of initialisation"
                                                    annotation (choices(choice = "No init, use start values as guess", choice="Steady state in p, h_liq, T_gas",
            choice = "Steady state in p", choice="steady State in h_liq and T_gas", choice = "Fixed value for filling level",
             choice = "Fixed values for filling level, p, h_liq, T_gas"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if expert summary should be applied" annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));
  parameter Boolean levelOutput = false "True, if Real level connector shall be addded"  annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean outputAbs = false "True, if absolute level is at output"  annotation(Dialog(enable = levelOutput, tab="Summary and Visualisation"));

  Basics.Interfaces.FluidPortOut outlet(Medium=liquidMedium) "Outlet port"
    annotation (Placement(transformation(extent={{-106,-68},{-86,-48}}),
        iconTransformation(extent={{-106,-68},{-86,-48}})));
  Basics.Interfaces.FluidPortIn inlet3(Medium=liquidMedium) "Inlet port"
    annotation (Placement(transformation(extent={{170,190},{190,210}}),
        iconTransformation(extent={{170,190},{190,210}})));
  Basics.Interfaces.FluidPortIn inlet1(Medium=liquidMedium) "Inlet port"
    annotation (Placement(transformation(extent={{90,190},{110,210}}),
        iconTransformation(extent={{90,190},{110,210}})));
  Basics.Interfaces.FluidPortIn inlet2(Medium=liquidMedium) "Inlet port"
    annotation (Placement(transformation(extent={{132,190},{152,210}}),
        iconTransformation(extent={{132,190},{152,210}})));

  Basics.ControlVolumes.SolidVolumes.CylindricalThickWall_L4 wall(
    N_rad=3,
    sizefunc=+1,
    diameter_i=diameter_i,
    length=height,
    T_start=T_start,
    diameter_o=diameter_i + 2*s_wall,
    redeclare model Material = Material,
    initOption=initOptionWall) annotation (Placement(transformation(extent={{32,-36},{52,-16}})));

  Basics.ControlVolumes.FluidVolumes.VolumeVLEGas_L3 volume(
    medium=liquidMedium,
    gasType=gasMedium,
    redeclare model HeatTransfer = HeatTransfer,
    redeclare model PressureLoss = PressureLoss,
    alpha_ph=alpha_ph,
    A_heat_ph=A_phaseBorder,
    h_liq_start=h_liq_start,
    T_gas_start=T_gas_start,
    p_start=p_start,
    xi_start=xi_start,
    showExpertSummary=showExpertSummary,
    level_rel_start=relLevel_start,
    initType=initFluid,
    redeclare model Geometry =
        Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (
        volume=height*diameter_i^2*Modelica.Constants.pi/4,
        N_heat=1,
        A_heat={Modelica.Constants.pi*diameter_i*height},
        A_cross=diameter_i^2*Modelica.Constants.pi/4,
        A_front=diameter_i^2*Modelica.Constants.pi/4,
        A_hor=diameter_i^2*Modelica.Constants.pi/4,
        N_inlet=3,
        N_outlet=1,
        height_fill=height,
        shape=[0,1; 1,1],
        z_out=z_out,
        z_in=z_in)) annotation (Placement(transformation(extent={{52,-68},{32,-48}})));

  Basics.Interfaces.GasPortIn vent1(Medium=gasMedium)
    annotation (Placement(transformation(extent={{40,190},{60,210}}),
        iconTransformation(extent={{40,190},{60,210}})));

  Modelica.Blocks.Interfaces.RealOutput level = if outputAbs then volume.level_abs else volume.level_rel if levelOutput annotation (Placement(transformation(extent={{204,-126},{224,-106}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={160,-110})));
equation
  connect(volume.outlet[1], outlet) annotation (Line(
      points={{32,-58},{-96,-58}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.inlet[1], inlet1) annotation (Line(
      points={{52,-58},{100,-58},{100,200}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.inlet[2], inlet2) annotation (Line(
      points={{52,-58},{142,-58},{142,200}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.inlet[3], inlet3) annotation (Line(
      points={{52,-58},{180,-58},{180,200}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(volume.vent, vent1) annotation (Line(
      points={{52,-54.2},{52,200},{50,200}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wall.innerPhase, volume.heat) annotation (Line(
      points={{41.8,-35.6},{42,-35.6},{42,-48.2}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
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
</html>"),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{200,200}}), graphics), Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{200,200}})));
end BalanceTank_L3;
