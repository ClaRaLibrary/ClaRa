within ClaRa.Basics.ControlVolumes.SolidVolumes;
model ThinPlateWall_L4 "A thin wall with discretisation in axial direction"
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

  extends ClaRa.Basics.Icons.WallThin;
 replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                                                            annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean useAxialHeatConduction = false "True, if axial heat conduction through a wall shall be considered" annotation (Dialog(group="Fundamental Definitions"));

  input Real CF_lambda=1 "Time-dependent correction factor for thermal conductivity" annotation(Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Length thickness_wall "Wall thickness" annotation (Dialog(group="Geometry"));

public
  parameter ClaRa.Basics.Units.Length length=1 "Length of plate" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length width=1 "Width of plate" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Mass mass_struc=0 "Additional to mass calculated by density*plate volume length*width*thicknesswall" annotation (Dialog(group="Geometry"));
  parameter Real CF_area=1 "Correction factor for additional heat transfer area" annotation(Dialog(group="Geometry"));
  parameter Integer N_pathes=1 "Number of pathes in parallel" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Temperature T_start[N_ax]=293.15*ones(N_ax) "Start values of wall temperature" annotation (Dialog(group="Initialisation"));
  parameter Integer N_ax=1 "Number of axial elements" annotation (Dialog(group="Discretisation"));
  parameter Modelica.Units.SI.Length Delta_x[N_ax]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_ax) "Discretisation scheme" annotation (Dialog(group="Discretisation"));
  inner parameter Integer initOption=213 "Type of initialisation" annotation (Dialog(group="Initialisation"), choices(
      choice=213 "Fixed temperature",
      choice=1 "Steady state",
      choice=203 "Steady temperature",
      choice=0 "No init, use T_start as guess values"));

  parameter Integer stateLocation = 2 "Location of states" annotation(Dialog(group="Numerical Efficiency"), choices(choice=1 "Inner location of states",
                                    choice=2 "Central location of states",  choice=3 "Outer location of states"));

  ClaRa.Basics.Units.Temperature T[N_ax](start=T_start, nominal=500*ones(N_ax));
  ClaRa.Basics.Units.InternalEnergy U[N_ax](nominal=4e6*ones(N_ax));
  ClaRa.Basics.Units.Power Q_flow[N_ax+1] "Axial Heat Conduction in wall";

  ClaRa.Basics.Interfaces.HeatPort_a outerPhase[N_ax] "outer side of the cylinder" annotation (Placement(transformation(extent={{-10,40},{10,60}}), iconTransformation(extent={{-10,40},{10,60}})));
   TILMedia.Solid solid[N_ax](redeclare each replaceable model SolidType = Material, T=T) annotation (Placement(transformation(extent={{48,8},{68,28}})));
  ClaRa.Basics.Interfaces.HeatPort_b innerPhase[N_ax] "Inner side of the cylinder" annotation (Placement(transformation(extent={{-10,-60},{10,-40}}), iconTransformation(extent={{-10,-60},{10,-40}})));

model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  parameter Integer N_ax;
    input ClaRa.Basics.Units.Area A_heat[N_ax] "Mean area of heat transfer (single tube)";
    input ClaRa.Basics.Units.Length thickness_wall "Wall thickness";
    input ClaRa.Basics.Units.Mass mass[N_ax] "Wall mass";
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

Summary summary(N_ax=N_ax,
                A_heat=A_heat,
                thickness_wall=thickness_wall,
                mass=mass,
                U=U,
                T_i=innerPhase.T,
                T_o=outerPhase.T,
                T=T,
                lambda=solid.lambda,
                Q_flow_i=innerPhase.Q_flow,
                Q_flow_o=outerPhase.Q_flow,
                cp=solid.cp,
                d=solid.d)                                                                                                                                                                                                annotation (Placement(transformation(extent={{-60,-40},{-40,-22}})));

protected
  final parameter ClaRa.Basics.Units.Mass mass[N_ax]={Delta_x[i]*width*thickness_wall*solid[i].d*N_pathes + mass_struc*Delta_x[i]/length for i in 1:N_ax} "Fixed mass vector for energy balance";
  final parameter ClaRa.Basics.Units.Area A_heat[N_ax]={Delta_x[i]*width*CF_area*N_pathes for i in 1:N_ax} "Area for heat transfer";
  final parameter SI.Area A_cross = width*thickness_wall "Cross Area of wall";
  final parameter SI.Length Delta_x_FM[N_ax + 1]=cat(
      1,
      {Delta_x[1]/2},
      {(Delta_x[i - 1] + Delta_x[i])/2 for i in 2:N_ax},
      {Delta_x[N_ax]/2}) "Discretisation scheme (Flow model)"
                                                             annotation(Dialog(group="Discretisation"));

equation
  //Axial heat conduction
  for i in 2:N_ax loop
  Q_flow[i] = if useAxialHeatConduction then (T[i-1]-T[i])*A_cross/Delta_x_FM[i]*solid[i].lambda*CF_lambda else 0;
  end for;
  Q_flow[1] = 0;
  Q_flow[N_ax+1] = 0;

  for i in 1:N_ax loop
  U[i]=T[i]*mass[i]*solid[i].cp;
  der(U[i]) = (innerPhase[i].Q_flow+outerPhase[i].Q_flow + Q_flow[i] - Q_flow[i+1]);

    //The following equation is true only for steady state or when changes in boundary conditions are slow compared to the state derivatives
  if stateLocation == 1 then //states are located at inner phase
    outerPhase[i].T = outerPhase[i].Q_flow/(solid[i].lambda*CF_lambda * A_heat[i]) * thickness_wall + T[i];
    innerPhase[i].T = T[i];
  elseif stateLocation == 2 then //states are located in center phase
    innerPhase[i].Q_flow = solid[i].lambda*CF_lambda/(thickness_wall * 0.5) * A_heat[i] * (innerPhase[i].T-T[i]);
    outerPhase[i].Q_flow = solid[i].lambda*CF_lambda/(thickness_wall * 0.5) * A_heat[i] * (outerPhase[i].T-T[i]);
  else // states are located at outer phase
    outerPhase[i].T = T[i];
    innerPhase[i].T = innerPhase[i].Q_flow/(solid[i].lambda*CF_lambda * A_heat[i]) * thickness_wall + T[i];
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

  annotation (Documentation(info="<html><p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
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
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -50},{100,50}})),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-50},{100,50}}),
         graphics));
end ThinPlateWall_L4;
