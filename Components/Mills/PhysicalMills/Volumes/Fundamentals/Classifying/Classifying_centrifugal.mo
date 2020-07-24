within ClaRa.Components.Mills.PhysicalMills.Volumes.Fundamentals.Classifying;
model Classifying_centrifugal "Rotating classifier wheel | separation by momentum balances of particle size classes"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
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

  extends Classifying_centrifugal_base;
  outer Records.iCom_CentrifugalClassifier iComClassifier;

protected
  parameter Integer n = iComClassifier.n "for convinience";

public
  parameter Real slip_w_gas_t = 22/55 "ratio of tangetial gas and rotor velocity (to fit measurement data)";

  //-------------------------------------------------------------------------------
  //initial values
  parameter ClaRa.Basics.Units.Velocity w_prtcl_r_rel_start[n,iComClassifier.classification.N_class] = 0.2*ones(n,iComClassifier.classification.N_class) "initial relative radial particle velocity for each particle class" annotation(Dialog(tab="General",group="Initialization"));
  parameter ClaRa.Basics.Units.Velocity w_gas_r_in_start = 1.177 "initial radial gas velocity at classifier inlet" annotation(Dialog(tab="General",group="Initialization"));

  //-------------------------------------------------------------------------------
  //particle motion for each particle class (N_class) and each ring section (n)
  ClaRa.Basics.Units.Volume volume_prtcl[iComClassifier.classification.N_class] "volume of particles, ideal spheres";

  ClaRa.Basics.Units.Velocity w_prtcl_r_abs[n,iComClassifier.classification.N_class] "absolute radial velocity of particle";
  ClaRa.Basics.Units.Velocity w_prtcl_r_rel[n,iComClassifier.classification.N_class](start=w_prtcl_r_rel_start) "relative radial velocity of particle (to gas)";
  ClaRa.Basics.Units.Velocity w_prtcl_r_rel_entry[iComClassifier.classification.N_class] "relative velocity of particles entering transport zone (x=0)";
  ClaRa.Basics.Units.Velocity w_prtcl_t[n,iComClassifier.classification.N_class] "relative radial velocity of particle";

  ClaRa.Basics.Units.Velocity w_gas_r_in(start=w_gas_r_in_start,fixed=true) "radial inlet gas velocity";
  ClaRa.Basics.Units.Velocity w_gas_t_in "tangential inlet gas velocity";
  ClaRa.Basics.Units.Velocity w_gas_r[n] "radial gas velocity against radius";
  ClaRa.Basics.Units.Velocity w_gas_t[n] "tangential gas velocity aganist radius";
  ClaRa.Basics.Units.Velocity w_gas_r_ps[n] "pseudo state: absolute velocity of gas";

  ClaRa.Basics.Units.RPM rpm_classifier "RPM of classifier in 1/min";
  ClaRa.Basics.Units.Frequency omega[n] "angular velocity of fluid";
  Real c1 "tangential constant for archimedan spiral";
  Real c2 "radial constant for archimedian spiral";
  ClaRa.Basics.Units.VolumeFraction K_v[n,iComClassifier.classification.N_class];

  // for radial mass flow through classifier to burner
  Modelica.SIunits.ReynoldsNumber Re[n,iComClassifier.classification.N_class] "Reynolds number";
  Real c_w[n,iComClassifier.classification.N_class] "coal particle drag coefficient";
  Real c_w_swarm[n,iComClassifier.classification.N_class] "modified VDI for swarms of particle according to VDI-Wärmeatals (L3.1) and Richardso and Zaki";

  // for vertical return mass flow to table
  Real c_w_return[n,iComClassifier.classification.N_class] "coal particle drag coefficient";
  Real c_w_swarm_return[n,iComClassifier.classification.N_class] "modified VDI for swarms of particle according to VDI-Wärmeatals (L3.1) and Richardso and Zaki";
  Modelica.SIunits.ReynoldsNumber Re_return[n,iComClassifier.classification.N_class] "Reynolds number";
  ClaRa.Basics.Units.Velocity w_prtcl_return[n,iComClassifier.classification.N_class](start=w_prtcl_r_rel_start) "absolute radial velocity of particle";

initial equation
 w_gas_r_ps=w_gas_r;

equation

  //calculating particle volume as ideal sphere
  volume_prtcl = 4/3 .* Modelica.Constants.pi .* (0.5*iComClassifier.classification.diameter_prtcl).^3;

  // BOUNDARY CONDITION FOR DISCETE PARTICLE MOVEMENT
  // absolute velocity of particle entering the transport zone is u_prtcl = w_gas - 0 = w_gas!
  //w_prtcl_r_rel_entry = zeros(iComClassifier.classification.N_class);
  // absolute velocity of particle entering the transport zone is u_prtcl = w_gas - w_prtcl_entry = 0!
  w_prtcl_r_rel_entry = w_gas_r_in*ones(iComClassifier.classification.N_class);

  // gas velocities at classifier inlet
  rpm_classifier = iComClassifier.inputClassifier;
  w_gas_t_in = slip_w_gas_t * rpm_classifier/60 * 2 * Modelica.Constants.pi * iComClassifier.radius[1];
  w_gas_r_in = iComClassifier.m_flow_gas_in ./ iComClassifier.A_coat_outer[1] ./ iComClassifier.rho_fluid;

  // constants for archimedian spiral
  c1 = w_gas_t_in * iComClassifier.radius[1];
  c2 = w_gas_r_in * iComClassifier.radius[1];

  for i in 1:n loop

    // gas velocities for each discrete radius
    w_gas_t[i] = c1 / iComClassifier.radius[i];
    w_gas_r[i] = c2 / iComClassifier.radius[i];
    omega[i] = w_gas_t[i]/iComClassifier.radius[i];

    //claculating Reynolds and c_w for each particle class
    Re[i,:] = iComClassifier.rho_fluid .* w_prtcl_r_rel[i,:] .* iComClassifier.classification.diameter_prtcl ./ iComClassifier.eta_gas;
    Re_return[i,:] = iComClassifier.rho_fluid .* w_prtcl_return[i,:] .* iComClassifier.classification.diameter_prtcl ./ iComClassifier.eta_gas;

    // c_w according to VDi_wärematlas L3.1
    for j in 1:iComClassifier.classification.N_class loop

      // particle volume density
      K_v[i,j] = max(0,iComClassifier.mass_fuel_discrete[i,j]./ iComClassifier.rho_prtcl ./ iComClassifier.delta_volume[i]);

      c_w[i,j] = max(24 / Re[i,j] .* (1+0.15 * max(0,Re[i,j])^0.687),0.44);
      c_w_return[i,j] = max(24 / Re_return[i,j] .* (1+0.15 * max(0,Re_return[i,j])^0.687),0.44);

      //modified c_w for particle swarms according to VDI-Wärmeatlas (L3.1) and Richardso and Zaki
      c_w_swarm[i,j] = c_w[i,j] .* (1-(K_v[i,j])).^(-3.7);
      c_w_swarm_return[i,j] = c_w_return[i,j] .* (1-(K_v[i,j])).^(-3.7);

    end for;

    //pseudo state: -----------------------------------------------------
    der(w_gas_r_ps[i])=(w_gas_r[i] - w_gas_r_ps[i])/0.1;

   // simplification for tangential relative velocity of particles
   w_prtcl_t[i,:] = zeros(iComClassifier.classification.N_class); // according to Stieß(2009), S.133

    //equation of motion for each particle class (RADIAL):  0 = Fg - Fw - Fa + Fu - Ft (where Fu respects inertia due to der(w_gas_r))
    volume_prtcl .* iComClassifier.rho_prtcl .* (der(w_prtcl_r_rel[i,:]) + w_prtcl_r_rel[i,:] .* (w_prtcl_r_rel[i,:] - (if i>1 then w_prtcl_r_rel[i-1,:] else w_prtcl_r_rel_entry)) ./ iComClassifier.delta_radius - w_prtcl_t[i,:].^2./iComClassifier.radius[i]) = (iComClassifier.rho_prtcl - iComClassifier.rho_fluid) .* volume_prtcl .* iComClassifier.radius[i] .* omega[i].^2  - 0.5 .* c_w_swarm[i,:] .* Modelica.Constants.pi .* (0.5*iComClassifier.classification.diameter_prtcl).^2 .* iComClassifier.rho_fluid .* w_prtcl_r_rel[i,:].^2 + volume_prtcl .* iComClassifier.rho_fluid .* der(w_gas_r_ps[i]);

    //calculate absolute RADIAL velocity of particles in gas flow
    w_prtcl_r_abs[i,:] = w_gas_r[i]*ones(iComClassifier.classification.N_class) - w_prtcl_r_rel[i,:];

    // calculate return velocity of particles to table from stationary, vertical momentum balance
    zeros(iComClassifier.classification.N_class) = volume_prtcl .* iComClassifier.rho_prtcl .* Modelica.Constants.g_n - c_w_swarm_return[i,:] .* Modelica.Constants.pi .* (0.5*iComClassifier.classification.diameter_prtcl).^2 .* iComClassifier.rho_fluid .* w_prtcl_return[i,:].^2 .* 0.5 - volume_prtcl .* iComClassifier.rho_fluid * Modelica.Constants.g_n;

  end for;

end Classifying_centrifugal;
