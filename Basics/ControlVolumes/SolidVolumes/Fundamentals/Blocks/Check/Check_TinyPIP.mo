within ClaRa.Basics.ControlVolumes.SolidVolumes.Fundamentals.Blocks.Check;
model Check_TinyPIP "Final test of tiny PI controller with anti wind-up compensation"
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;
  Real control_y = stopablePI.y;

  TinyPIP stopablePI(
    u=step.y,
    initOption=4,
    y_start=0.9,
    K_p=1e-2,
    Tau_i=5*stopablePI.K_p,
    N_i=0.01/stopablePI.K_p)
                 annotation (Placement(transformation(extent={{-6,-46},{26,-12}})));
  Modelica.Blocks.Sources.TimeTable
                               step(table=[0.0,-10; 0.1,1; 0.2,-1; 1,-1; 1.1,2; 1.5,2; 1.6,-1; 1.8,1; 2.2,1; 2.9,2; 3,-4; 3.1,-4; 3.45,-4; 3.5,1; 4.0,1; 4.5,-1; 4.5,-1; 5,0.5; 6,-1]) "[0.0, -1; 0.1, 1; 0.2, -1; 1, -1; 1.1, 2; 1.5, 2; 1.6, -1; 1.8, 1; 2.2, 1; 2.9, 2; 3, -4; 3.1, -4; 3.45, -4; 3.5, -4; 4.0, -4; 4.5, -1; 4.5, -1; 5, 0.5; 6, -1]"
    annotation (Placement(transformation(extent={{-66,-30},{-46,-10}})));

  Components.Utilities.Blocks.LimPID PI_1ph_in(
    y_min=0,
    perUnitConversion=false,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1e-2,
    y_start=1,
    Ni=0.01,
    Tau_i=5,
    sign=-1,
    initOption=796) annotation (Placement(transformation(extent={{-8,22},{12,42}})));
public
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{-56,18},{-36,38}})));
equation
  connect(const.y, PI_1ph_in.u_s) annotation (Line(points={{-35,28},{-24,28},{-24,32},{-10,32}}, color={0,0,127}));
  connect(step.y, PI_1ph_in.u_m) annotation (Line(points={{-45,-20},{-22,-20},{-22,20},{2.1,20}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    experiment(StopTime=8, __Dymola_NumberOfIntervals=50000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-80},{100,80}})));
end Check_TinyPIP;
