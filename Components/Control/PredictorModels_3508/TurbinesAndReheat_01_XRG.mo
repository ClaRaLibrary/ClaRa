within ClaRa.Components.Control.PredictorModels_3508;
model TurbinesAndReheat_01_XRG "A predictor for the generator power including the HP and IP/LP turbines aswell as the energy storage in the reheater"
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

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="01");
  extends ClaRa.Components.Control.PredictorModels_3508.Icons.TurbineAndReheat;

  parameter Modelica.Units.SI.Pressure p_nom=240e5 "Nominal pressure at inlet of HP turbine" annotation (Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom=419 "Nominal mass flow rate at inlet of HP turbine" annotation (Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.Power P_G_nom=804.89e6 "Nominal generator power of the block" annotation (Dialog(group="Nominal values"));
  parameter Real turbineRatio= 0.33 "Aspect ratio of HP turbine output to total power output"
                                                                annotation(Dialog(group="Nominal values"));
parameter Real CL_Deltah_p[:,2]={{0.5000e7,    0.1889e7},
    {0.6000e7,    0.1889e7},
    {0.8000e7,    0.1910e7},
     {1.0000e7,    0.1923e7},
     {1.2000e7,    0.1930e7},
     {1.4000e7,    0.1933e7},
     {1.6000e7,    0.1934e7},
     {1.8000e7,    0.1933e7},
     {2.0000e7,    0.1930e7},
     {2.2000e7,    0.1926e7},
     {2.4000e7,    0.1921e7},
     {2.5000e7,    0.1921e7}} "Characteristic line enthalpy difference over HP inlet pressure "
                                                                                            annotation(Dialog(group="Part Load Definition"));

  parameter Modelica.Units.SI.Time Tau_HP=(0.2 + 0.5)/2 "Time Constant for Energy Storage in HP turbine" annotation (Dialog(group="Time Response Definition"));
  parameter Modelica.Units.SI.Time Tau_IP=(10 + 25)/2 "Time Constant for Energy Storage in IP/LP turbine" annotation (Dialog(group="Time Response Definition"));

  parameter Real m_flow_start_=1 "Initial mass flow rate in p.u." annotation(Dialog(group="Initialisation"));
  Modelica.Blocks.Continuous.FirstOrder energyStorage_HP_turbine(        T=Tau_HP,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=m_flow_start_)
    annotation (Placement(transformation(extent={{-62,24},{-42,44}})));
  Modelica.Blocks.Continuous.FirstOrder energyStroage_RH_IPLP_turbine(
               T=Tau_IP,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=m_flow_start_)
    annotation (Placement(transformation(extent={{-62,-36},{-42,-16}})));
  Modelica.Blocks.Math.Add add(k1=turbineRatio, k2=1 - turbineRatio)
    annotation (Placement(transformation(extent={{-24,-6},{-4,14}})));
  input Basics.Interfaces.SteamSignal      inlet       annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-98,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-98,0})));
  Modelica.Blocks.Interfaces.RealOutput P_gen_ "Generator power in p.u."
    annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Tables.CombiTable1Dv convert2SpecificpowerOutput(columns={2}, table=CL_Deltah_p) annotation (Placement(transformation(extent={{6,60},{26,80}})));
  Modelica.Blocks.Math.Gain gain(k=p_nom)
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  Modelica.Blocks.Math.Gain gain1(k=m_flow_nom)
    annotation (Placement(transformation(extent={{4,-6},{24,14}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{34,0},{54,20}})));
  Modelica.Blocks.Math.Gain gain2(k=1/P_G_nom)
    annotation (Placement(transformation(extent={{64,0},{84,20}})));
equation

assert(Tau_HP>0 and Tau_IP>0, "Time constants must be greater than zero!");
  connect(energyStorage_HP_turbine.y, add.u1) annotation (Line(
      points={{-41,34},{-36,34},{-36,10},{-26,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(energyStroage_RH_IPLP_turbine.y, add.u2) annotation (Line(
      points={{-41,-26},{-35.5,-26},{-35.5,-2},{-26,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, convert2SpecificpowerOutput.u[1])
                                                  annotation (Line(
      points={{-9,70},{4,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, gain1.u) annotation (Line(
      points={{-3,4},{2,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convert2SpecificpowerOutput.y[1], product.u1)
                                                      annotation (Line(
      points={{27,70},{28,70},{28,16},{32,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain1.y, product.u2) annotation (Line(
      points={{25,4},{32,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain2.y, P_gen_) annotation (Line(
      points={{85,10},{90,10},{90,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, gain2.u) annotation (Line(
      points={{55,10},{62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inlet.p_, gain.u) annotation (Line(
      points={{-98.1,0.1},{-84,0.1},{-84,70},{-32,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(inlet.m_flow_, energyStroage_RH_IPLP_turbine.u) annotation (Line(
      points={{-98.1,0.1},{-78,0.1},{-78,-26},{-64,-26}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(inlet.m_flow_, energyStorage_HP_turbine.u) annotation (Line(
      points={{-98.1,0.1},{-78,0.1},{-78,34},{-64,34}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
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
</html>"));
end TurbinesAndReheat_01_XRG;
