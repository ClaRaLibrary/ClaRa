within ClaRa.Basics.ControlVolumes.Fundamentals.Geometry;
model PipeGeometry_N_cv "Discretized pipe bundle || Tube type "
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.2.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2016, DYNCAP/DYNSTART research team.                     //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.TubeType;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv(
    final volume=Modelica.Constants.pi/4*diameter^2*Delta_x*N_tubes,
    final A_heat=[N_tubes*Modelica.Constants.pi*diameter*Delta_x],
    final A_cross=ones(N_cv)*Modelica.Constants.pi*diameter^2/4*N_tubes,
    final N_heat=1,
    final diameter_hyd=fill(diameter, N_cv),
    Delta_x=ClaRa.Basics.Functions.GenerateGrid({0}, length*N_passes, N_cv),
    final z=cat(1,
               {(z_out - z_in)/(length*N_passes)*Delta_x[1]/2 + z_in},
               {((z_out - z_in)/(length*N_passes)*(sum(Delta_x[k] for k in 1:i - 1) + Delta_x[i]/2) + z_in) for i in 2:N_cv}),
    final Delta_z_in = {sum(Delta_x[1:i]) - Delta_x[i]/2 for i in 1:N_cv});

  parameter Units.Length length=1 "Length of the component (one pass)" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Units.Length diameter=1 "Diameter of the component" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Integer N_tubes=1 "Number of tubes in parallel" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Integer N_passes=1 "Number of passes of the tubes" annotation(Dialog(group="Essential Geometry Definition"));

  annotation (Icon(graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "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"
               +
              "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",
          fileName="modelica://ClaRa/figures/Components/PipeGeometry.png")}));

end PipeGeometry_N_cv;
