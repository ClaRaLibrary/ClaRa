within ClaRa.Components.BoundaryConditions;
model PrescribedHeatFlowVLE "A heat flow anchor with prescribed heat flow rate"
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
  extends ClaRa.Basics.Icons.Box;
  import SI = ClaRa.Basics.Units;
  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.FlangeVLE           inlet;
    ClaRa.Basics.Records.FlangeVLE           outlet;
  end Summary;
  inner parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));


  parameter Boolean Q_flowInputIsActive=false "True, if  a variable Q_flow is used"
    annotation (Dialog(group="Control Signals"));
  parameter ClaRa.Basics.Units.HeatFlowRate Q_flow_const=100 annotation (Dialog(
        group="Control Signals", enable=not Q_flowInputIsActive));

//   inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  outer ClaRa.SimCenter simCenter;
public
  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),  iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_in = Q_flow if (
    Q_flowInputIsActive) "External Heatflow thats added to the Output" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-108}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  ClaRa.Basics.Units.HeatFlowRate Q_flow "Heat flowrate";
public
  Summary summary(
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=inlet.m_flow,
      T=fluidIn.T,
      p=inlet.p,
      h=fluidIn.h,
      s=fluidIn.s,
      steamQuality=fluidIn.q,
      H_flow=fluidIn.h*inlet.m_flow,
      rho=fluidIn.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOut.T,
      p=outlet.p,
      h=fluidOut.h,
      s=fluidOut.s,
      steamQuality=fluidOut.q,
      H_flow=-fluidOut.h*outlet.m_flow,
      rho=fluidOut.d))
    annotation (Placement(transformation(extent={{-40,-52},{-20,-32}})));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph fluidOut(
    p=outlet.p,
    vleFluidType=medium,
    h=outlet.h_outflow,
    xi=outlet.xi_outflow)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    p=inlet.p,
    h=inStream(inlet.h_outflow),
    xi=inStream(inlet.xi_outflow))
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(extent={{90,-68},{110,-48}}), iconTransformation(extent={{100,-80},{120,-60}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1] annotation (Placement(transformation(extent={{45,-59},{47,-57}})));
equation
  if (not Q_flowInputIsActive) then
    Q_flow = Q_flow_const;
  end if;

//_________________Energy balance___________________________________
    inlet.h_outflow = inStream(outlet.h_outflow) - Q_flow/inlet.m_flow;
    outlet.h_outflow = inStream(inlet.h_outflow) + Q_flow/inlet.m_flow;

//_______________Mass balance (no storage)__________________________
  inlet.m_flow + outlet.m_flow = 0;

  inlet.p = outlet.p;

//______________ No chemical reaction taking place:_________________
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);

//______________Eye port variable definition________________________
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = fluidOut.T-273.15;
  eye_int[1].s = fluidOut.s/1e3;
  eye_int[1].p = outlet.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;
  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-58},{46,-58}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
    annotation (
    Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011 - 2024.</p>
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
</html>"),Dialog(group="Fundamental Definitions"),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-88,88},{88,-88}},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),                                      Text(
          extent={{-52,32},{54,-28}},
          textColor={0,0,0},
          textString="Q_flow")}),                                Diagram(coordinateSystem(preserveAspectRatio=false)));
end PrescribedHeatFlowVLE;
