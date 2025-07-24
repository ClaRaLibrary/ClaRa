within ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT;
model NusseltPipe_L4 "Pipe || VLE || Nusselt || 1ph"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.VLE_HT.HeatTransfer_L4;
  // TILMedia VLEFluidFunctions
  import fluidFunction_cp = TILMedia.VLEFluid.MixtureCompatible.Functions.specificIsobaricHeatCapacity_phxi;
  import fluidFunction_lambda = TILMedia.VLEFluid.MixtureCompatible.Functions.thermalConductivity_phxi;
  import fluidFunction_eta = TILMedia.VLEFluid.MixtureCompatible.Functions.dynamicViscosity_phxi;
  import fluidFunction_rho = TILMedia.VLEFluid.MixtureCompatible.Functions.density_phxi;

  import fluidObjectFunction_cp = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.specificIsobaricHeatCapacity_phxi;
  import fluidObjectFunction_lambda = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.thermalConductivity_phxi;
  import fluidObjectFunction_eta = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.dynamicViscosity_phxi;
  import fluidObjectFunction_rho = TILMedia.VLEFluid.MixtureCompatible.ObjectFunctions.density_phxi;
  import sm = ClaRa.Basics.Functions.Stepsmoother;

  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha[iCom.N_cv] "Heat transfer coefficient";
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_lam[iCom.N_cv] "Heat transfer coefficient - laminar part";
  ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_turb[iCom.N_cv] "Heat transfer coefficient - turbolent part";
  Real failureStatus[iCom.N_cv] "0== boundary conditions fulfilled | 1== failure >> check if still meaningfull results";

  parameter Integer boundary = 1 "Choice of heat transfer boundary condition, relevant for laminar flow heat transfer" annotation(choices(choice=1 "Uniform wall temperature in developed fluid flow (UWT+DFF)",
                           choice=2 "Uniform heat flux in developed fluid flow (UHF+DFF)",
                           choice=3 "Uniform wall temperature in undeveloped fluid flow (UWT+UFF)",
                           choice=4 "Uniform heat flux in undeveloped fluid flow (UHF+UFF)"));
  parameter Integer correlation = 1 "Correlation type" annotation(choices(choice=1 "Gnielinski | VDI Heat Atlas | roughness considered", choice = 2 "Ditttus and Boelter | Bejan | roughness neglected"));

  ClaRa.Basics.Units.Velocity velocity[geo.N_cv] "Mean velocity";
  ClaRa.Basics.Units.ReynoldsNumber Re[geo.N_cv] "Reynolds number";
  ClaRa.Basics.Units.PrandtlNumber Pr[geo.N_cv] "Prandtl number";

protected
  constant ClaRa.Basics.Units.ReynoldsNumber laminar=2200 "Maximum Reynolds number for laminar regime";
  constant ClaRa.Basics.Units.ReynoldsNumber turbulent=1e4 "Minimum Reynolds number for turbulent regime";
  constant Real MIN=Modelica.Constants.eps "Limiter";

  final parameter ClaRa.Basics.Units.NusseltNumber Nu0=if boundary == 1 or boundary == 3 then 0.7 else if boundary == 2 or boundary == 4 then 1 else 0 "Help variable for local Nusselt number";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu1=if boundary == 1 or boundary == 3 then 3.66 else if boundary == 2 or boundary == 4 then 4.364 else 0 "Help variable for mean Nusselt number";

  ClaRa.Basics.Units.NusseltNumber Nu2[geo.N_cv] "Help variable for mean Nusselt number";
  ClaRa.Basics.Units.NusseltNumber Nu3[geo.N_cv] "Help variable for mean Nusselt number";

  ClaRa.Basics.Units.NusseltNumber Nu_lam[geo.N_cv] "Mean laminar Nusselt number";
  ClaRa.Basics.Units.NusseltNumber Nu[geo.N_cv] "Mean overall Nusselt number";

  ClaRa.Basics.Units.ThermalConductivity lambda[geo.N_cv];
  ClaRa.Basics.Units.DensityMassSpecific rho[geo.N_cv];
  ClaRa.Basics.Units.DynamicViscosity eta[geo.N_cv];
  ClaRa.Basics.Units.HeatCapacityMassSpecific cp[geo.N_cv];
  Real zeta[geo.N_cv] "Pressure loss coefficient";

// Nominal alpha calculation:
  final parameter ClaRa.Basics.Units.HeatCapacityMassSpecific cp_nom=fluidFunction_cp(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DynamicViscosity eta_nom=fluidFunction_eta(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  final parameter ClaRa.Basics.Units.ThermalConductivity lambda_nom=fluidFunction_lambda(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom=fluidFunction_rho(
      iCom.mediumModel,
      iCom.p_nom,
      iCom.h_nom,
      iCom.xi_nom);
  final parameter ClaRa.Basics.Units.Velocity velocity_nom=abs(iCom.m_flow_nom)/max(MIN, rho_nom*geo.A_cross[1]);
  final parameter ClaRa.Basics.Units.ReynoldsNumber Re_nom=(rho_nom*velocity_nom*geo.diameter_hyd[1]/max(MIN, eta_nom)) "Reynolds number";
  final parameter ClaRa.Basics.Units.PrandtlNumber Pr_nom=abs(eta_nom*cp_nom/max(MIN, lambda_nom)) "Prandtl number";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu0_nom=if boundary == 1 or boundary == 3 then 0.7 else if boundary == 2 or boundary == 4 then 0.6 else 0 "Help variable for nominal Nusselt number";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu2_nom=if boundary == 1 or boundary == 3 then 1.615*(Re_nom*Pr_nom*geo.diameter_hyd[1]/geo.length)^(1/3) else if boundary == 2 or boundary == 4 then 1.953*(Re_nom*Pr_nom*geo.diameter_hyd[1]/geo.length)^(1/3) else 0 "Help variable for mean Nusselt number";
  final parameter ClaRa.Basics.Units.NusseltNumber Nu3_nom=if boundary == 3 then (2/(1 + 22*Pr_nom))^(1/6)*(Re_nom*Pr_nom*geo.diameter_hyd[1]/geo.length)^0.5 else if boundary == 4 then (0.924)*(Pr_nom^(1/3))*(Re_nom*geo.diameter_hyd[1]/geo.length)^(1/2) else 0 "Help variable for mean Nusselt number";

  final parameter ClaRa.Basics.Units.NusseltNumber Nu_lam_nom=(Nu1^3 + Nu0_nom^3 + (Nu2_nom - Nu0_nom)^3 + Nu3_nom^3)^(1/3) "Mean Nusselt number";
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_lam_nom=Nu_lam_nom*lambda_nom/max(MIN, geo.diameter_hyd[1]);
   final parameter Real zeta_nom=abs(1/max(MIN, 1.8*Modelica.Math.log10(abs(Re_nom)) - 1.5)^2)
    "Pressure loss coefficient";
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_turb_nom=if correlation == 2 then abs(lambda_nom/geo.diameter_hyd[1])*0.023*Re_nom^0.8*Pr_nom^(1/3) else if correlation == 1 then abs(lambda_nom/geo.diameter_hyd[1])*(abs(zeta_nom)/8)*abs(Re_nom)*abs(Pr_nom)/(1 + 12.7*(abs(zeta_nom)/8)^0.5*(abs(Pr_nom)^(2/3) - 1))*(1 + (geo.diameter_hyd[1]/geo.length)^(2/3)) else 0;
public
  final parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha_nom=(sm(
      laminar,
      turbulent,
      Re_nom)*alpha_lam_nom + sm(
      turbulent,
      laminar,
      Re_nom)*alpha_turb_nom) "Nominal HTC (used for homotopy)";

equation
//   m_flow=abs(iCom.m_flow)./geo.N_tubes;
  T_mean = iCom.T;
  heat.Q_flow = alpha .* A_heat .* (heat.T - T_mean);

  for i in 1:iCom.N_cv loop
//////////////MEDIA DATA CALCULATION ////////////////////////
    lambda[i] = fluidObjectFunction_lambda(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
    rho[i]=fluidObjectFunction_rho(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
    eta[i]=fluidObjectFunction_eta(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
    cp[i]=fluidObjectFunction_cp(
        iCom.p[i],
        iCom.h[i],
        iCom.xi[i, :],
        iCom.fluidPointer[i]);
//////////////////////////LAMINAR ALPHA /////////////////////
    velocity[i]= abs(m_flow[i])./max(MIN, rho[i]*geo.A_cross[i]) "Mean velocity";
    Re[i]=(rho[i]*velocity[i]*geo.diameter_hyd[i]/max(MIN,eta[i])) "Reynolds number";
    Pr[i] = abs(eta[i]*cp[i]/max(MIN, lambda[i])) "Prandtl number";
    Nu2[i] = if boundary == 1 or boundary == 3 then  1.077 *(Re[i]*Pr[i]*geo.diameter_hyd[i]/geo.Delta_z_in[i])^(1/3)
                                                   else if boundary ==  2 or boundary == 4 then 1.302 *(Re[i].*Pr[i]*geo.diameter_hyd[i]/geo.Delta_z_in[i])^(1/3)
                                                        else 0 "Help variable for mean Nusselt number";
    Nu3[i] = if boundary == 3 then 0.5*(2 /(1 + 22 *Pr[i]))^(1/6)*(Re[i]*Pr[i]*geo.diameter_hyd[i]/geo.Delta_z_in[i])^0.5
                                                   else if boundary == 4 then  (0.462) *(Pr[i]^(1/3))*(Re[i]*geo.diameter_hyd[i]/geo.Delta_z_in[i])^(1/2)
                                                        else 0 "Help variable for mean Nusselt number";

    Nu_lam[i]=(Nu1^3 + Nu0^3 + (Nu2[i] - Nu0)^3 + Nu3[i].^3)^(1/3) "Mean Nusselt number";
    alpha_lam[i] =  Nu_lam[i]*lambda[i]/max(MIN, geo.diameter_hyd[i]);

//////////////////////////TURBULENT ALPHA ///////////////////
    zeta[i]=abs(1/max(MIN, 1.8*Modelica.Math.log10(max(abs(Re[i]),MIN)) - 1.5)^2)
    "Pressure loss coefficient";
    alpha_turb[i] = if correlation == 2 then abs(lambda[i]/geo.diameter_hyd[i])*0.023*Re[i]^0.8*Pr[i]^(1/3)
               else if correlation == 1 then abs(lambda[i]/geo.diameter_hyd[i])*(abs(zeta[i])/8)*abs(Re[i])*abs(Pr[i])/(1 + 12.7*(abs(zeta[i])/8)^0.5*(abs(Pr[i])^(2/3) - 1))*(1 + (1/3)*(geo.diameter_hyd[i]/geo.Delta_z_in[i])^(2/3))
               else 0;


/////////////////////////OVERALL ALPHA //////////////////////
    alpha[i] = if useHomotopy then homotopy(sm(laminar, turbulent, Re[i])*alpha_lam[i]
             + sm(turbulent, laminar, Re[i])*alpha_turb[i], alpha_nom)
              else sm(laminar, turbulent, Re[i])*alpha_lam[i]
             + sm(turbulent, laminar, Re[i])*alpha_turb[i];
    Nu[i]=alpha[i]/lambda[i]*geo.diameter_hyd[i];

  //failure status
    if noEvent(Re[i] > 1e6) then
      failureStatus[i] =  1;
    else
       if noEvent(Pr[i] < 0.6 or Pr[i] > 1e3) then
         failureStatus[i] = 1;
       else
         if noEvent(geo.diameter_hyd[i]/max(MIN, geo.length*geo.N_passes) > 1) then
            failureStatus[i] = 1;
         else
            failureStatus[i] = 0;
         end if;
       end if;
    end if;
  end for;
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end NusseltPipe_L4;
