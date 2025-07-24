within ClaRa.Components.VolumesValvesFittings.Fittings;
model FlueGasJunction_L2 "Adiabatic junction volume"
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

extends ClaRa.Basics.Icons.Tpipe2;
extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  outer ClaRa.SimCenter simCenter;

 model Gas
  extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Mass m "Mass flow rate" annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific h "Specific enthalpy" annotation (Dialog);
    input ClaRa.Basics.Units.Enthalpy H "Specific enthalpy" annotation (Dialog);
    input ClaRa.Basics.Units.DensityMassSpecific rho "Specific enthalpy" annotation (Dialog);
 end Gas;

 inner model Summary
   extends ClaRa.Basics.Icons.RecordIcon;
   Gas gas;
   ClaRa.Basics.Records.FlangeGas portA;
   ClaRa.Basics.Records.FlangeGas portB;
   ClaRa.Basics.Records.FlangeGas portC;
 end Summary;

inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));

// ***************************** defintion of medium used in cell *************************************************
  inner parameter TILMedia.Gas.Types.BaseGas medium=simCenter.flueGasModel "Medium to be used in tubes"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  Basics.Interfaces.GasPortIn      portA(Medium = medium, m_flow)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.GasPortIn portB(Medium=medium, m_flow) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Basics.Interfaces.GasPortIn portC(Medium=medium, m_flow) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  parameter ClaRa.Basics.Units.Volume volume;

  replaceable model PressureLossA =
    Fundamentals.NoFriction constrainedby Fundamentals.BaseDp "Pressure loss model at inlet" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossB =
      Fundamentals.NoFriction  constrainedby Fundamentals.BaseDp "Pressure loss model at outlet 1" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLossC =
      Fundamentals.NoFriction constrainedby Fundamentals.BaseDp "Pressure loss model at outlet 2" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

  TILMedia.Gas.Gas_pT flueGasIn(
    gasType=medium,
    p=p,
    T=noEvent(actualStream(portA.T_outflow)),
    xi=noEvent(actualStream(portA.xi_outflow))) annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
  TILMedia.Gas.Gas_pT flueGasOut1(
    gasType=medium,
    p=portB.p,
    T=noEvent(actualStream(portB.T_outflow)),
    xi=noEvent(actualStream(portB.xi_outflow))) annotation (Placement(transformation(extent={{60,-14},{80,6}})));
  TILMedia.Gas.Gas_pT flueGasOut2(
    gasType=medium,
    p=portC.p,
    T=noEvent(actualStream(portC.T_outflow)),
    xi=noEvent(actualStream(portC.xi_outflow))) annotation (Placement(transformation(extent={{-10,-82},{10,-62}})));
  inner TILMedia.Gas.Gas_ph bulk(
    computeTransportProperties=false,
    gasType=medium,
    p=p,
    h=h,
    xi=xi,
    stateSelectPreferForInputs=true) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  /****************** Initial values *******************/

public
  parameter ClaRa.Basics.Units.Pressure p_start=1.013e5 "Initial value for air pressure" annotation (Dialog(tab="Initialisation"));
//   parameter Boolean fixedInitialPressure = true
//     "if true, initial pressure is fixed" annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.Temperature T_start=298.15 "Initial value for air temperature" annotation (Dialog(tab="Initialisation"));

  parameter ClaRa.Basics.Units.MassFraction[medium.nc - 1] xi_start=medium.xi_default "Initial value for mixing ratio" annotation(Dialog(tab="Initialisation"));

  final parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start = TILMedia.Gas.Functions.specificEnthalpy_pTxi(
                                                                                                                medium, p_start, T_start, xi_start) "Start value for specific Enthalpy inside volume";

  ClaRa.Basics.Units.MassFraction xi[medium.nc - 1](start=xi_start);
  ClaRa.Basics.Units.EnthalpyMassSpecific h(start=h_start) "Specific enthalpy";
  ClaRa.Basics.Units.Pressure p(start=p_start) "Pressure";

  ClaRa.Basics.Units.Mass mass "Gas mass in control volume";

  Real drhodt "Density derivative";

PressureLossA pressureLossA;
PressureLossB pressureLossB;
PressureLossC pressureLossC;

  inner Summary summary(
    portA(
      mediumModel=medium,
      m_flow=portA.m_flow,
      T=flueGasIn.T,
      p=portA.p,
      h=flueGasIn.h,
      xi=flueGasIn.xi,
      H_flow=portA.m_flow*flueGasIn.h),
    portB(
      mediumModel=medium,
      m_flow=portB.m_flow,
      T=flueGasOut1.T,
      p=portB.p,
      h=flueGasOut1.h,
      xi=flueGasOut1.xi,
      H_flow=portB.m_flow*flueGasOut1.h),
    portC(
      mediumModel=medium,
      m_flow=portC.m_flow,
      T=flueGasOut2.T,
      p=portC.p,
      h=flueGasOut2.h,
      xi=flueGasOut2.xi,
      H_flow=portC.m_flow*flueGasOut2.h),
    gas(
      m=mass,
      T=bulk.T,
      p=p,
      h=h,
      H=h*mass,
      rho=bulk.d)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

public
  Basics.Interfaces.EyeOutGas
                           eye1(each medium=medium)
                               if showData
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-50})));
protected
  Basics.Interfaces.EyeInGas
                          eye_int[2](each medium=medium)
    annotation (Placement(transformation(extent={{55,-51},{57,-49}})));
public
  Basics.Interfaces.EyeOutGas
                           eye2(each medium=medium)
                               if showData
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-110}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-110})));
initial equation

    if initOption == 1 then //steady state
      der(h)=0;
      der(p)=0;
      der(xi)=zeros(medium.nc-1);
    elseif initOption == 201 then //steady pressure
      der(p)=0;
    elseif initOption == 202 then //steady enthalpy
      der(h)=0;
    elseif initOption == 208 then // steady pressure and enthalpy
      der(h)=0;
      der(p)=0;
    elseif initOption == 210 then //steady density
      drhodt=0;
    elseif initOption == 0 then //no init
    // do nothing
    else
     assert(initOption == 0,"Invalid init option");
    end if;

equation

  portA.xi_outflow = xi;
  portB.xi_outflow = xi;
  portC.xi_outflow = xi;

  portA.T_outflow = bulk.T;
  portB.T_outflow = bulk.T;
  portC.T_outflow = bulk.T;

  pressureLossA.m_flow=portA.m_flow;
  pressureLossB.m_flow=-portB.m_flow;
  pressureLossC.m_flow=-portC.m_flow;

//   inlet.p = p; // Volume is located at PortA
//   inlet.p - outlet1.p = 0 "Momentum balance";
//   inlet.p - outlet2.p = 0 "Momentum balance";

  portB.p = p - pressureLossB.dp;
  portC.p = p - pressureLossC.dp;
  portA.p=p+pressureLossA.dp;

  der(h) =1/mass*(portA.m_flow*(flueGasIn.h - h) + portB.m_flow*(flueGasOut1.h - h) + portC.m_flow*(flueGasOut2.h - h) + volume*der(p))
                       "Energy balance";

  der(xi) =1/mass*(portA.m_flow*(flueGasIn.xi - xi) + portB.m_flow*(flueGasOut1.xi - xi) + portC.m_flow*(flueGasOut2.xi - xi))
                                                                             "Mass balance";

      //______________ Balance euqations _______________________

    mass = volume*bulk.d "Mass in cv";

    drhodt = bulk.drhodh_pxi*der(h) + bulk.drhodp_hxi*der(p) + sum({bulk.drhodxi_ph[i] * der(bulk.xi[i]) for i in 1:medium.nc-1});

    drhodt*volume =portA.m_flow + portB.m_flow + portC.m_flow  "Mass balance";



   eye_int[1].T=flueGasOut1.T - 273.15;
    eye_int[1].s=flueGasOut1.s/1e3;
    eye_int[1].p=flueGasOut1.p/1e5;
    eye_int[1].h=flueGasOut1.h/1e3;
    eye_int[2].T=flueGasOut2.T - 273.15;
    eye_int[2].s=flueGasOut2.s/1e3;
    eye_int[2].p=flueGasOut2.p/1e5;
    eye_int[2].h=flueGasOut2.h/1e3;
    eye_int[1].m_flow=-portB.m_flow;
    eye_int[2].m_flow=-portC.m_flow;
    eye_int[1].xi=flueGasOut1.xi;
    eye_int[2].xi=flueGasOut2.xi;

  connect(eye_int[1],eye1)  annotation (Line(
      points={{56,-50.25},{84,-50.25},{84,-50},{110,-50}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int[2],eye2)  annotation (Line(
      points={{56,-49.75},{56,-90},{30,-90},{30,-110}},
      color={190,190,190},
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
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Rectangle(
          extent={{-92,32},{-74,-32}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=pressureLossA.hasPressureLoss), Rectangle(
          extent={{74,32},{92,-32}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=pressureLossB.hasPressureLoss),
        Rectangle(
          extent={{-32,-76},{32,-92}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=pressureLossC.hasPressureLoss)}),
                              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics));
end FlueGasJunction_L2;
