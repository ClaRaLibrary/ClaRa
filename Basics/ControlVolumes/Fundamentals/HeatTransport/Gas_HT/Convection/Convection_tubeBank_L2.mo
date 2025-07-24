within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection;
model Convection_tubeBank_L2 "Shell Geo || L2 || Convection Tube Bank"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Gas_HT.Convection.HeatTransfer_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_only;
  final parameter Integer HT_type = 0;

  import SM = ClaRa.Basics.Functions.Stepsmoother;

  //Equations according to VDI-Waermeatlas
  parameter Integer heatSurfaceAlloc=2 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

public
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha "Heat transfer coefficient";
  ClaRa.Basics.Units.Velocity w "Flue gas velocity";

  Real Nu_llam "Nusselt number laminar";
  Real Nu_lturb "Nusselt number turbulent";
  Real Nu_l0 "Nusselt number";
  Real Nu_tubeBank "Nusselt number at tube bank";
  ClaRa.Basics.Units.ThermalResistance HR "Convective heat resistance";
  ClaRa.Basics.Units.ThermalResistance HR_nom "Nominal convective heat resistance";
protected
  Real Re_psi1 "Corrected Reynolds number";
  Real f_a "Arrangement factor";
  final parameter ClaRa.Basics.Units.Length length_char=Modelica.Constants.pi/2*geo.diameter_t "Characteristic length";

  ClaRa.Basics.Units.Temperature T_prop_am "Arithmetic mean for calculation of substance properties";
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.HollowBlockWithTubes geo;
  ClaRa.Basics.Units.MassFraction xi_mean[iCom.mediumModel.nc - 1] "Mean medium composition";

  TILMedia.Gas.Gas_pT properties(
    p=(iCom.p_in + iCom.p_out)/2,
    T=T_prop_am,
    xi=xi_mean,
    gasType=iCom.mediumModel,
    computeTransportProperties=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

    Real x1;
    Real x2;
equation
  T_prop_am = (iCom.T_in + iCom.T_out)/2;

  xi_mean = iCom.xi_bulk;

  x1 = SM(0.01,0,iCom.V_flow_in);
  x2 = SM(0,0.01,-iCom.V_flow_out);

  w = (x1*iCom.V_flow_in/geo.A_front + x2*iCom.V_flow_out/geo.A_front)/max((x1)+(x2),1);

  //undisturbed velocity at inlet is needed
  Re_psi1 = max(eps,properties.d*w*length_char/(geo.psi*properties.transp.eta));

  Nu_llam = 0.664*sqrt(Re_psi1)*(properties.transp.Pr)^(1/3);
  Nu_lturb = (0.037*(Re_psi1)^(0.8)*properties.transp.Pr)/(1 + 2.443*(Re_psi1)^(-0.1)*(properties.transp.Pr^(2/3) - 1));
  Nu_l0 = 0.3 + sqrt(Nu_llam^2 + Nu_lturb^2);

  if geo.staggeredAlignment == false then
    f_a = 1 + 0.7/(geo.psi)^(1.5)*(geo.b/geo.a - 0.3)/(geo.b/geo.a + 0.7)^2;
  else
    f_a = 1 + 2/(3*geo.b);
  end if;
  // "Partly staggered"
  //   if c < (a/4) then
  //     f_a = 1 + 0.7/(geo.psi)^(1.5) * (b/a - 0.3)/(b/a + 0.7)^2;
  //   else
  //     f_a = 1 + 2/(3*b);
  //   end if;
  // else
  //   f_a = 0;
  // end if;

  if geo.N_rows < 10 then
    Nu_tubeBank = (1 + (geo.N_rows - 1)*f_a)/(geo.N_rows)*Nu_l0;
  else
    Nu_tubeBank = f_a*Nu_l0;
  end if;

  alpha = Nu_tubeBank*properties.transp.lambda/length_char*CF_fouling;

  //heat.Q_flow = A_eff * alpha*(heat.T - T_mean);
  heat.Q_flow = geo.A_heat_CF[heatSurfaceAlloc]*alpha*Delta_T_mean;

//calculation of NOMINAL heat resistance
  HR_nom = -1;

//calculation of ACTUAL heat resistance
  HR=1/max(Modelica.Constants.eps,alpha*geo.A_heat_CF[heatSurfaceAlloc]);



  annotation (Documentation(info="<html>
<p><b>Model description: </b>A correlation for convective heat transfer inside tube banks</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Aligned, staggered or partly staggered tubes supported</li>
<li>Needs geometry model for tube banks</li>
<li>Equations according to: VDI-W&auml;rmeatlas: 10.bearbeitete und erweiterte Auflage, 2006, chapter Gg1-4</li>
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>
"));
end Convection_tubeBank_L2;
