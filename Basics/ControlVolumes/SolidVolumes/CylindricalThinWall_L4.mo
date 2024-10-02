within ClaRa.Basics.ControlVolumes.SolidVolumes;
model CylindricalThinWall_L4 "A thin cylindric wall with axial discretisation"
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

  extends ClaRa.Basics.Icons.WallThinLarge;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean useAxialHeatConduction = false "True, if axial heat conduction through a wall shall be considered" annotation (Dialog(group="Fundamental Definitions"));
  input Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity" annotation (Dialog(group="Fundamental Definitions"));

  import SI = ClaRa.Basics.Units;
public
  parameter Integer N_ax=3 "Number of axial elements" annotation (Dialog(group="Discretisation"));
  parameter ClaRa.Basics.Units.Length Delta_x[N_ax]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_ax) "Discretisation scheme" annotation (Dialog(group="Discretisation"));
  parameter Units.Length diameter_o "Outer diameter" annotation (Dialog(group="Geometry"));
  parameter Units.Length diameter_i "Inner diameter" annotation (Dialog(group="Geometry"));
  parameter Units.Length length "Length of cylinder" annotation (Dialog(group="Geometry"));
  parameter Integer N_tubes=1 "Number of tubes in parallel" annotation (Dialog(group="Geometry"));
  parameter Units.Temperature T_start[N_ax]=ones(N_ax)*293.15 "Start values of wall temperature" annotation (Dialog(group="Initialisation"));
  inner parameter Integer initOption=213 "Type of initialisation" annotation (Dialog(group="Initialisation"), choices(
      choice=213 "Fixed temperature",
      choice=1 "Steady state",
      choice=203 "Steady temperature",
      choice=0 "No init, use T_start as guess values"));
  parameter Integer stateLocation=2 "Location of states" annotation (Dialog(group="Numerical Efficiency"), choices(
      choice=1 "Inner location of states",
      choice=2 "Central location of states",
      choice=3 "Outer location of states",
      choice=0 "No init, use T_start as guess values"));
  parameter String suppressChattering="True" "Enable to suppress possible chattering" annotation (Dialog(group="Numerical Efficiency"), choices(choice="False" "False (faster if no chattering occurs)",
                                                                                            choice="True" "True (faster if chattering occurs)"));
  final parameter Units.Mass mass=sum(solid.d .* (Modelica.Constants.pi/4*(diameter_o^2 - diameter_i^2)*Delta_x*N_tubes)) "Wall mass";
protected
  final parameter Units.HeatFlowRate Q_flow_nom=1;
  constant Real Q_flow_eps=1e-9;

public
  Units.Temperature T[N_ax](start=T_start, each nominal=500) "Axial temperatures";

protected
  Units.HeatFlowRate Delta_Q_flow[N_ax](each nominal=1e5);
  Units.InternalEnergy U[N_ax](each nominal=4e6);
  ClaRa.Basics.Units.Power Q_flow[N_ax+1] "Axial Heat Conduction in wall";
  final parameter SI.Area A_cross = Modelica.Constants.pi/4*(diameter_o^2 - diameter_i^2) "Cross section area of wall";
  final parameter SI.Length Delta_x_FM[N_ax + 1]=cat(
      1,
      {Delta_x[1]/2},
      {(Delta_x[i - 1] + Delta_x[i])/2 for i in 2:N_ax},
      {Delta_x[N_ax]/2}) "Discretisation scheme (Flow model)"
                                                             annotation(Dialog(group="Discretisation"));

public
  ClaRa.Basics.Interfaces.HeatPort_a outerPhase[N_ax](T(start=T_start)) "outer side of the cylinder" annotation (Placement(transformation(extent={{-10,40},{10,60}}), iconTransformation(extent={{-10,40},{10,60}})));
  TILMedia.Solid solid[N_ax](T(start=T_start) = T, redeclare each replaceable model SolidType = Material) annotation (Placement(transformation(extent={{48,8},{68,28}})));
  ClaRa.Basics.Interfaces.HeatPort_b innerPhase[N_ax](T(start=T_start)) "Inner sider of the cylinder" annotation (Placement(transformation(extent={{-10,-60},{10,-40}}), iconTransformation(extent={{-10,-60},{10,-40}})));

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Length diameter_o "Outer diameter";
    input ClaRa.Basics.Units.Length diameter_i "Inner diameter";
    input Units.Length length "Length of cylinder";
    input Integer N_tubes "Number of tubes in parallel";
    input ClaRa.Basics.Units.Mass mass "Wall mass";
    parameter Integer N_ax "Number of axial elements";
    input ClaRa.Basics.Units.InternalEnergy U[N_ax] "Inner energy of wall";
    input Units.Temperature T_i[N_ax] "Inner phase temperature";
    input Units.Temperature T_o[N_ax] "Outer phase temperature";
    input ClaRa.Basics.Units.Temperature T[N_ax] "Wall temperature";
    input Real lambda[N_ax] "Heat conductivity";
    input Units.HeatFlowRate Q_flow_i[N_ax] "Heat flow rate to inner phase";
    input Units.HeatFlowRate Q_flow_o[N_ax] "Heat flow rate to outer phase";
    input Units.HeatCapacityMassSpecific cp[N_ax] "Specific heat capacity";
    input Units.DensityMassSpecific d[N_ax] "Material density";
  end Summary;

Summary summary(diameter_o=diameter_o,
                diameter_i=diameter_i,
                length=length,
                N_tubes=N_tubes,
                mass=mass,
                N_ax=N_ax,
                U=U,
                T_i=innerPhase.T,
                T_o=outerPhase.T,
                T=T,
                lambda=solid.lambda,
                Q_flow_i=innerPhase.Q_flow,
                Q_flow_o=outerPhase.Q_flow,
                cp=solid.cp,
                d=solid.d);

equation
  assert(diameter_o > diameter_i, "The outer diameter has to be greater then the inner diameter!");
  //Axial heat conduction
  for i in 2:N_ax loop
    Q_flow[i] = if useAxialHeatConduction then (T[i-1]-T[i])*A_cross/Delta_x_FM[i]*solid[i].lambda*CF_lambda else 0;
  end for;
  Q_flow[1] = 0;
  Q_flow[N_ax+1] = 0;

  for i in 1:N_ax loop
    U[i] = T[i]*solid[i].d*(Modelica.Constants.pi/4*(diameter_o^2 - diameter_i^2)*Delta_x[i]*N_tubes)*solid[i].cp;
    if suppressChattering == "True" then
      der(U[i]) = Delta_Q_flow[i]*Q_flow_nom;
      Delta_Q_flow[i] = noEvent(if abs(innerPhase[i].Q_flow + outerPhase[i].Q_flow + Q_flow[i] - Q_flow[i+1]) > Q_flow_eps then (innerPhase[i].Q_flow + outerPhase[i].Q_flow + Q_flow[i] - Q_flow[i+1]) else 0)/Q_flow_nom;
    else
      der(U[i]) = Delta_Q_flow[i];
      Delta_Q_flow[i] = innerPhase[i].Q_flow + outerPhase[i].Q_flow + Q_flow[i] - Q_flow[i+1];
    end if;

    //The following equation is true only for steady state or when changes in boundary conditions are slow compared to the state derivatives
    if stateLocation == 1 then
      //states are located at inner phase
      outerPhase[i].T = outerPhase[i].Q_flow .* log(diameter_o/diameter_i)/(2*Delta_x[i]*N_tubes*solid[i].lambda*CF_lambda*Modelica.Constants.pi) + T[i];
      innerPhase[i].T = T[i];
    elseif stateLocation == 2 then
      //states are located in center phase
      innerPhase[i].Q_flow = solid[i].lambda*CF_lambda*(2*Modelica.Constants.pi*Delta_x[i]*N_tubes)/log((diameter_o + diameter_i)/(2*diameter_i))*(innerPhase[i].T - T[i]);
      outerPhase[i].Q_flow = solid[i].lambda*CF_lambda*(2*Modelica.Constants.pi*Delta_x[i]*N_tubes)/log((2*diameter_o)/(diameter_o + diameter_i))*(outerPhase[i].T - T[i]);
    else
      // states are located at outer phase
      outerPhase[i].T = T[i];
      innerPhase[i].T = innerPhase[i].Q_flow .* log(diameter_o/diameter_i)/(2*Delta_x[i]*N_tubes*solid[i].lambda*CF_lambda*Modelica.Constants.pi) + T[i];
    end if;

  end for;

initial equation

   if initOption == 1 then //steady state
     der(U)=zeros(N_ax);
   elseif initOption == 203 then //steady temperature
     der(T)=zeros(N_ax);
   elseif initOption == 0 then //no init
     //do nothing
   elseif initOption == 213 then // fixed temperature
     T=T_start;
   else
    assert(initOption == 0,"Invalid init option");
   end if;

  annotation (
    Documentation(info="<html>
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
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-50},{140,50}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-140,-50},{140,50}}), graphics));
end CylindricalThinWall_L4;
