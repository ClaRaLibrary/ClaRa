within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Classifying;
model Classifying_flow "Flow classification | separation by momentum balances of particle size classes"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.6.0                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends Classifying.Classifying_flow_base;
  outer Records.iCom_FlowClassifier iComClassifier;

protected
  parameter Integer n = iComClassifier.n "for convinience";

  //------------------------------------------------------------------------------
  //initial values
public
  parameter ClaRa.Basics.Units.Velocity w_prtcl_rel_start[n,iComClassifier.classification.N_class] = 2*ones(n,iComClassifier.classification.N_class) "initial relative particle velocity for each particle class" annotation(Dialog(tab="General",group="Initialization"));
  parameter ClaRa.Basics.Units.Velocity w_gas_start = 3.77 "initial gas velocity" annotation(Dialog(tab="General",group="Initialization"));

  //------------------------------------------------------------------------------
  //particle motion for each particle class (N_class) and each ring section (n)

  Real c_w[n,iComClassifier.classification.N_class] "coal particle drag coefficient";
  Real c_w_swarm[n,iComClassifier.classification.N_class] "modified VDI for swarms of particle according to VDI-Wärmeatals (L3.1) and Richardso and Zaki";

  Modelica.Units.SI.ReynoldsNumber Re[n,iComClassifier.classification.N_class] "Reynolds number";
  ClaRa.Basics.Units.Volume volume_prtcl[iComClassifier.classification.N_class] "volume of particle, ideal spheres";
  ClaRa.Basics.Units.VolumeFraction K_v[n, iComClassifier.classification.N_class] "volume fraction particle V_prtcl/V_fluid";

  ClaRa.Basics.Units.Velocity w_prtcl_abs[n,iComClassifier.classification.N_class] "absolute velocity of particle";
  ClaRa.Basics.Units.Velocity w_prtcl_rel[n,iComClassifier.classification.N_class](start = w_prtcl_rel_start) "relative velocity of particle (to gas)";
  ClaRa.Basics.Units.Velocity w_gas(start=w_gas_start,fixed=true) "absolute velocity of gas";
  ClaRa.Basics.Units.Velocity w_gas_ps "pseudo state: absolute velocity of gas";
  ClaRa.Basics.Units.Velocity w_prtcl_rel_entry[iComClassifier.classification.N_class] "relative velocity of particles entering transport zone (x=0)";

initial equation
  w_gas=w_gas_ps;

equation
  // BOUNDARY CONDITION FOR DISCETE PARTICLE MOVEMENT
  // absolute velocity of particle entering the transport zone is w_prtcl_abs = w_gas - w_prtcl_rel_entry = 0!
  w_prtcl_rel_entry = w_gas*ones(iComClassifier.classification.N_class);

  //particle volume:
  volume_prtcl = 4/3 .* Modelica.Constants.pi .* (iComClassifier.classification.diameter_prtcl/2).^3;

  //gas velocity
  w_gas = iComClassifier.m_flow_gas_in ./ iComClassifier.A_cross ./ iComClassifier.rho_fluid;  //calculating gas velocity from INLET mass flow
  //pseudo state:
  der(w_gas_ps)=(w_gas - w_gas_ps)./0.1;

  for i in 1:n loop

    //claculating Reynolds and c_w for each particle class
    Re[i,:] = iComClassifier.rho_fluid .* w_prtcl_rel[i,:] .* iComClassifier.classification.diameter_prtcl ./ iComClassifier.eta_gas;

    // c_w according to VDi_wärematlas L3.1
    for j in 1:iComClassifier.classification.N_class loop

       //particle volume density
      K_v[i,j] = max(0,iComClassifier.mass_fuel_discrete[i,j] ./ iComClassifier.rho_prtcl ./ iComClassifier.delta_volume);

      c_w[i,j] = max(24 / Re[i,j] .* (1+0.15 * Re[i,j]^0.687),0.44);

      //modified c_w for particle swarms according to VDI-Wärmeatlas (L3.1) and Richardso and Zaki
      c_w_swarm[i,j] = c_w[i,j] .* (1-K_v[i,j]).^(-3.7);

    end for;

    //equation of motion for each particle class: 0 = Fg - Fw - Fa - Fp + Fu - Ft (where Fu respects inertia due to der(w_gas))
    volume_prtcl .* iComClassifier.rho_prtcl .* (der(w_prtcl_rel[i,:]) + w_prtcl_rel[i,:] .* (w_prtcl_rel[i,:] - (if i>1 then w_prtcl_rel[i-1,:] else w_prtcl_rel_entry)) ./ iComClassifier.delta_height) =  volume_prtcl .* iComClassifier.rho_prtcl .* Modelica.Constants.g_n - c_w_swarm[i,:] .* Modelica.Constants.pi .* (0.5*iComClassifier.classification.diameter_prtcl).^2 .* iComClassifier.rho_fluid .* abs(w_prtcl_rel[i,:]) .* w_prtcl_rel[i,:] .* 0.5 - volume_prtcl .* iComClassifier.rho_fluid * Modelica.Constants.g_n - (iComClassifier.p_gas_in - iComClassifier.p_gas_out)/iComClassifier.height * volume_prtcl + volume_prtcl .* iComClassifier.rho_fluid .* der(w_gas_ps);

    //calculate absolute velocity of particles in gas flow
    w_prtcl_abs[i,:] = w_gas*ones(iComClassifier.classification.N_class) - w_prtcl_rel[i,:];

  end for;
      annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2020.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under Modelica License 2.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/CLA/\">https://claralib.com/CLA/</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under Modelica License 2.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end Classifying_flow;
