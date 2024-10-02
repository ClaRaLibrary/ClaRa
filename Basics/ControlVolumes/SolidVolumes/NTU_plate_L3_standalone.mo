within ClaRa.Basics.ControlVolumes.SolidVolumes;
model NTU_plate_L3_standalone "A three-zonal NTU cell model with internally calculated zone size for plate geometry"
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

  //import SI = ClaRa.Basics.Units;
  outer ClaRa.SimCenter simCenter;
  extends ClaRa.Basics.Icons.NTU;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L3");

  import smooth = ClaRa.Basics.Functions.Stepsmoother;

//_____________material definitions_________________________________________//

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium_a=simCenter.fluid1 "Medium at outer side"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium_b=simCenter.fluid1 "Medium at inner side"
                              annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                                                       annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean outerPhaseChange=true "True, if phase change may occur at outer side"
                                                    annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

//______________geometry definitions________________________________________//
  replaceable model HeatExchangerType =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.CounterFlow_L3
                                                        constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.HeatExchangerTypes.GeneralHeatExchanger_L3 "Type of heat exchanger"
                             annotation(choicesAllMatching,Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length width=1 "Plate width" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length length=1 "Plate length" annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length thickness_wall=0.001 "Wall thickness" annotation(Dialog(group="Geometry"));
  parameter Integer N_plates(min=3)=3 "Number of tubes in parallel" annotation(Dialog(group="Geometry"));
  parameter Real mass_struc = 0 "Mass of inner structure elements, additional to the tubes itself"                   annotation(Dialog(group="Geometry"));
  //discrete SI.Mass  mass "Total mass of HEX";
//Area of Heat Transfer
  parameter ClaRa.Basics.Units.Area A_heat=(N_plates-2)*width*length "Mean area of heat transfer"  annotation(Dialog(group="Geometry"));
  parameter Real CF_geo=1 "Correction coefficient due to fins etc." annotation(Dialog(group="Geometry"));

//______________Initialisation______________________________________________//
  inner parameter Integer initOption=0 "Thermal initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=203 "Steady temperature",
      choice=204 "Fixed temperatures"));
  parameter ClaRa.Basics.Units.Temperature T_w_i_start[3]=ones(3)*293.15 "Initial temperature at inner phase" annotation (Dialog(choicesAllMatching, tab="Initialisation"));
  parameter ClaRa.Basics.Units.Temperature T_w_o_start[3]=ones(3)*293.15 "Initial temperature at outer phase" annotation (Dialog(choicesAllMatching, tab="Initialisation"));

  parameter Integer initOption_yps = 3 "Volumetric initialisation" annotation(Dialog(choicesAllMatching, tab="Initialisation"), choices(choice = 1 "Integrator state at zero",
                                                                                                    choice=2 "Steady state",
                                                                                                    choice=3 "Apply guess value y_start at output",
                                                                                                    choice=4 "Force y_start at output"));
  parameter Real yps_start[2]={0,0} "Initial area fraction 1phase | 2phase " annotation(Dialog(tab="Initialisation"));

//______________Expert Settings____________________________________________//
  replaceable model HeatCapacityAveraging =
      ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.ArithmeticMean
    constrainedby ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Averaging_Cp.GeneralMean
                                                                                "Method for Averaging of heat capacities" annotation(Dialog(choicesAllMatching, tab="Expert Settings"));

  parameter Real gain_eff= 1 "Avoid effectiveness > 1, high gain_eff leads to stricter observation but may cause numeric errors"  annotation(Dialog(choicesAllMatching, tab="Expert Settings"));
  parameter ClaRa.Basics.Units.Time Tau_stab=0.1 "Time constant for numeric stabilisation w.r.t. heat flow rates" annotation (Dialog(choicesAllMatching, tab="Expert Settings"));
  parameter Boolean showExpertSummary = false "True,if expert summaries shall be shown"  annotation(Dialog(choicesAllMatching, tab="Expert Settings"));

  final parameter Modelica.Units.SI.ThermalResistance HR_nom=nTU.HR_nom "Nominal conductive heat resistance";

//______________Inputs_____________________________________________________//
public
  input ClaRa.Basics.Units.Pressure p_o "Pressure at outer side" annotation (Dialog(group="Input"));
  input ClaRa.Basics.Units.Pressure p_i "Pressure at inner side" annotation (Dialog(group="Input"));
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_i_inlet "Inlet enthalpy of inner flow" annotation (Dialog(group="Input"));
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_o_inlet "Inlet enthalpy of outer flow" annotation (Dialog(group="Input"));

  input ClaRa.Basics.Units.MassFlowRate m_flow_i "Mass flow rate of inner side" annotation (Dialog(group="Input"));
  input ClaRa.Basics.Units.MassFlowRate m_flow_o "Mass flow rate of outer side" annotation (Dialog(group="Input"));

  input ClaRa.Basics.Units.MassFraction xi_i[medium_b.nc-1] "Mass fraction at outer side" annotation (Dialog(group="Input"));
  input ClaRa.Basics.Units.MassFraction xi_o[medium_a.nc-1] "Mass fraction at outer side" annotation (Dialog(group="Input"));

  input ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_i[3] "Coefficient of heatTransfer for inner side for regions |A|B|C|" annotation (Dialog(group="Input"));
  input ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_o[3] "Coefficient of heatTransfer for outer side for regions |A|B|C|" annotation (Dialog(group="Input"));

//   SI.AreaFraction yps_A "Area fraction of zone A";
//   SI.AreaFraction yps_B "Area fraction of zone B";
//   SI.AreaFraction yps_C "Area fraction of zone C";
//   SI.Temperature T_i[4] "Inner side temperatures A-->C";
//   SI.Temperature T_o[4] "Outer side temperatures A-->C";

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  ECom eCom;
  parameter Boolean showExpertSummary;
  input ClaRa.Basics.Units.HeatFlowRate Q_flow[3] "Heat flow rate of zones |1|2|3|";
  input ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Total heat flow rate";
  input Real C_flow_low[3] if showExpertSummary "Lower heat capacity flow in zones |1|2|3|";
  input Real C_flow_high[3] if showExpertSummary "Higher heat capacity flow in zones |1|2|3|";
  input Real C_flow_i[3] if showExpertSummary "Inner side heat capacity flow in zones |1|2|3|";
  input Real C_flow_o[3] if showExpertSummary "Outer side heat capacity flow in zones |1|2|3|";

  input ClaRa.Basics.Units.Temperature T_i[6] "Temperatures (i/o) of outer flow zones |1|2|3|";
  input ClaRa.Basics.Units.Temperature T_o[6] "Temperatures (i/o) of outer flow zones |1|2|3|";

  input ClaRa.Basics.Units.Temperature T_i_sat "Inner side saturation temperature";
  input ClaRa.Basics.Units.Temperature T_o_sat "Outer side saturation temperature";
  input Real yps[3] "Area fractions";
  input Real effectiveness[3] "effectiveness in zones |1|2|3|";
  input Real cp_error_[3] if showExpertSummary "Check: Deviation from constant cp in zones |1|2|3|";
  input ClaRa.Basics.Units.HeatCapacityFlowRate kA[3] "The product U*A for regions |1|2|3|";
end Summary;

model ECom
  extends ClaRa.Basics.Icons.RecordIcon;
  input Real z_i[6] "Zone positions at the inner side of the heat exchanger";
  input Real z_o[6] "Zone positions at the outer side of the heat exchanger";
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_i[6] "Specific enthalpies (i/o) of inner flow zones |1|2|3|";
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_o[6] "Specific enthalpies (i/o) of outer flow zones |1|2|3|";
end ECom;

public
  Summary summary(eCom( z_o = nTU.HEXtype.z_o,
    z_i = nTU.HEXtype.z_i,
    h_i={nTU.iCom.h_i_in[1], nTU.iCom.h_i_out[1],nTU.iCom.h_i_in[2], nTU.iCom.h_i_out[2],nTU.iCom.h_i_in[3], nTU.iCom.h_i_out[3]},
    h_o={nTU.iCom.h_o_in[1], nTU.iCom.h_o_out[1],nTU.iCom.h_o_in[2], nTU.iCom.h_o_out[2],nTU.iCom.h_o_in[3], nTU.iCom.h_o_out[3]}),
    showExpertSummary = showExpertSummary,
    Q_flow=nTU.Q_flow,
    T_i_sat=nTU.I3_in.VLE.T_v,
    T_o_sat=nTU.O1_in.VLE.T_v,
    C_flow_low=nTU.C_flow_low,
    C_flow_high=nTU.C_flow_high,
    C_flow_i=nTU.cp_i*m_flow_i.*nTU.HEXtype.ff_i,
    C_flow_o=nTU.cp_o*m_flow_o.*nTU.HEXtype.ff_o,
    T_i= nTU.iCom.T_in2out_i,
    T_o= nTU.iCom.T_in2out_o,
    yps=nTU.HEXtype.yps,
    Q_flow_tot = sum(nTU.Q_flow),
    effectiveness=nTU.effectiveness,
    cp_error_=nTU.cp_error_,
    kA=nTU.kA) annotation (Placement(transformation(extent={{80,-102},{100,-82}})));

protected
  ClaRa.Basics.ControlVolumes.SolidVolumes.NTU_plate_L3 nTU(
    medium_shell=medium_a,
    medium_tubes=medium_b,
    redeclare model Material = Material,
    outerPhaseChange=outerPhaseChange,
    width=width,
    length=length,
    thickness_wall=thickness_wall,
    N_plates=N_plates,
    mass_struc=mass_struc,
    CF_geo=CF_geo,
    A_heat=A_heat,
    T_w_i_start=T_w_i_start,
    T_w_o_start=T_w_o_start,
    redeclare model HeatCapacityAveraging = HeatCapacityAveraging,
    p_o=p_o,
    p_i=p_i,
    h_i_inlet=h_i_inlet,
    h_o_inlet=h_o_inlet,
    m_flow_i=m_flow_i,
    m_flow_o=m_flow_o,
    alpha_i=alpha_i,
    alpha_o=alpha_o,
    redeclare final model HeatExchangerType = HeatExchangerType,
    yps_1ph=PI_1ph_in.y,
    yps_2ph=PI_2ph.y,
    gain_eff=gain_eff,
    showExpertSummary=showExpertSummary,
    Tau_stab=Tau_stab,
    initOption=initOption,
    xi_i=xi_i,
    xi_o=xi_o) annotation (Placement(transformation(extent={{-14,-10},{14,12}})));
public
  ClaRa.Basics.Interfaces.HeatPort_a
                                   outerPhase[3] "outer side of cylinder"
    annotation (Placement(transformation(extent={{-10,80},{10,100}}), iconTransformation(extent={{-10,80},{10,100}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   innerPhase[3] "inner side of cylinder"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}), iconTransformation(extent={{-10,-100},{10,-80}})));
protected
  ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Blocks.TinyPIP PI_2ph(
    y_min=0,
    y_start=yps_start[2],
    K_p=0.01,
    y_max=1,
    initOption=initOption_yps,
    Tau_i=1000*PI_2ph.K_p,
    N_i=0.01/PI_2ph.K_p,
    u=controller2phInput) annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Blocks.TinyPIP PI_1ph_in(
    y_min=0,
    y_start=yps_start[1],
    K_p=0.01,
    y_max=1,
    initOption=initOption_yps,
    Tau_i=1000*PI_1ph_in.K_p,
    N_i=0.01/PI_1ph_in.K_p,
    u=controller1phInput) annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

protected
  ClaRa.Basics.Units.EnthalpyMassSpecific controller2phInput "Controller input for 2ph yps controller";
  ClaRa.Basics.Units.EnthalpyMassSpecific controller1phInput "Controller input for 1ph yps controller";

equation

   if outerPhaseChange then
     controller2phInput = (smooth(1e-3,1e-4,m_flow_o)+smooth(-1e-3,-1e-4,m_flow_o))*nTU.iCom.Delta_h_2ph/1000;
     controller1phInput = (smooth(1e-3,1e-4,m_flow_o)+smooth(-1e-3,-1e-4,m_flow_o))*nTU.iCom.Delta_h_1ph/1000;
  else
     controller2phInput = (smooth(1e-3,1e-4,m_flow_i)+smooth(-1e-3,-1e-4,m_flow_i))*nTU.iCom.Delta_h_2ph/1000;
     controller1phInput = (smooth(1e-3,1e-4,m_flow_i)+smooth(-1e-3,-1e-4,m_flow_i))*nTU.iCom.Delta_h_1ph/1000;

   end if;

//_____________connection of PI controllers for the area fraction:____________________//

//    PI_1ph_in.u_s= 0;
//    PI_2ph.u_s = 0;
//

  connect(nTU.outerPhase, outerPhase)     annotation (Line(
      points={{0,10.9},{0,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nTU.innerPhase, innerPhase)     annotation (Line(
      points={{0,-8.9},{0,-90}},
      color={191,0,0},
      smooth=Smooth.None));
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
</html>"),Diagram(graphics), Icon(graphics,
                                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end NTU_plate_L3_standalone;
