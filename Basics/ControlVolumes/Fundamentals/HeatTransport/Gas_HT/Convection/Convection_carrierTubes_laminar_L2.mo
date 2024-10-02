within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model Convection_carrierTubes_laminar_L2 "Carrier Tube Geo || L2 || Convection Longitudinal Tubes"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.8.2                            //
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.HeatTransfer_L2;
  //Equations according to VDI Waermeatlas ch. Ge

  parameter Integer heatSurfaceAlloc=3 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha "Heat transfer coefficient";
  ClaRa.Basics.Units.Velocity w "Flue gas velocity";


   Real Nu_dm "Nusselt number";
   Real K "Curvature parameter";
   Real nu "Kinematic viscosity";
  final parameter ClaRa.Basics.Units.Length length_char = geo.height "Characteristic length";

protected
  ClaRa.Basics.Units.Temperature T_prop_am "Arithmetic mean for calculation of substance properties";

  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubesAndCarrierTubes geo;
  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1] "Mean medium composition";

  TILMedia.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=T_prop_am,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  TILMedia.Gas_pT properties_tw(
    p=(iCom.p_in + iCom.p_out)/2,
    T=heat.T,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true) annotation (Placement(transformation(extent={{72,-12},{92,8}})));

equation

  T_prop_am = (iCom.T_out + iCom.T_in)/2;

   //zeros(iCom.mediumModel.nc - 1) = -xi_mean*(iCom.m_flow_in - iCom.m_flow_out) + (iCom.m_flow_in*iCom.xi_in - iCom.m_flow_out*iCom.xi_out);
   xi_mean = iCom.xi_bulk;

   w = (abs(iCom.V_flow_in) + abs(iCom.V_flow_out))/(2*geo.A_cross);

   nu = properties.transp.eta/properties.d;
   K = nu*length_char/(w*(geo.d_ct/2)^2);
   //Nu_dm = 2* 0.55/(K^0.5)+ 10/9 * 0.95/(K^0.1);
   Nu_dm*(K^0.5)*(K^0.1) = 2*0.55*(K^0.1) + 10/9*(K^0.5)*0.95;

   alpha = Nu_dm*properties_tw.transp.lambda/length_char*CF_fouling;

   heat.Q_flow = geo.A_heat_CF[heatSurfaceAlloc]*alpha*Delta_T_mean;

  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for convective heat transfer at a&nbsp;cylindric&nbsp;tube&nbsp;for&nbsp;longitudinal&nbsp;flow</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Needs geometry model for tube banks</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Ge 1-5</li>
</ul></p>
</html><html>
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end Convection_carrierTubes_laminar_L2;
