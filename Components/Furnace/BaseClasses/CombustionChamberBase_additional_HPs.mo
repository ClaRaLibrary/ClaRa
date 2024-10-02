within ClaRa.Components.Furnace.BaseClasses;
partial model CombustionChamberBase_additional_HPs
  import ClaRa;

 //________________________/ Connectors \_______________________________________________________
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat_CarrierTubes
    annotation (Placement(transformation(extent={{190,90},{210,110}})));
  ClaRa.Basics.Interfaces.HeatPort_a
                                   heat_TubeBundle
    annotation (Placement(transformation(extent={{190,-90},{210,-110}})));

 //________________________/ replacable modells for heat transfer, pressure loss and geometry \________________________
  replaceable model HeatTransfer_CarrierTubes =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_carrierTubes_turbulent_L2
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Heat Transfer"), choicesAllMatching=
        true);

  replaceable model HeatTransfer_TubeBundle =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.Convection_tubeBank_L2
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas "1st: choose geometry definition | 2nd: edit corresponding record"
    annotation (Dialog(group="Heat Transfer"), choicesAllMatching=
        true);

    inner HeatTransfer_CarrierTubes  heattransfer_CarrierTubes(heatSurfaceAlloc=3) annotation(Placement(transformation(extent={{10,-10},
            {-10,10}},
        rotation=180,
        origin={162,60})));
    inner HeatTransfer_TubeBundle heattransfer_TubeBundle(heatSurfaceAlloc=2) annotation(Placement(transformation(extent={{10,10},
            {-10,-10}},
        rotation=180,
        origin={162,-60})));

  ClaRa.Basics.Units.HeatFlowRate Q_flow_CarrierTubes "Heat flow from carrier tubes";
  ClaRa.Basics.Units.HeatFlowRate Q_flow_TubeBundle "Heat flow from tube bundle";

equation
  //____________/ Heat port temperatures and Q_flows \____________________________
   Q_flow_CarrierTubes = heat_CarrierTubes.Q_flow;
   Q_flow_TubeBundle =  heat_TubeBundle.Q_flow;

  //_____________/ Connections \______________________________________________
  connect(heattransfer_CarrierTubes.heat, heat_CarrierTubes) annotation (Line(
      points={{172,60},{200,60},{200,100}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heattransfer_TubeBundle.heat, heat_TubeBundle) annotation (Line(
      points={{172,-60},{200,-60},{200,-100}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p><b>Model description: </b>Base class for furnace sections with additional heat ports</p>
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
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-300,-100},
            {300,100}}), graphics));
end CombustionChamberBase_additional_HPs;
