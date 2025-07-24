within ClaRa.Components.Adapters;
model Scalar2VectorHeatPort "Connect a scalar heat port with a vectorised heat port"
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
  extends ClaRa.Basics.Icons.Adapter5_fw;
  import SI = ClaRa.Basics.Units;

  parameter String equalityMode = "Equal Temperatures" "Spacial equality of state or flow variable?"    annotation(Dialog(group="Fundamental Definitions"),choices(choice="Equal Heat Flow Rates",  choice= "Equal Temperatures"));

  parameter Integer N = 3 "Number of axial elements" annotation(Dialog(group="Fundamental Definitions"));

  parameter Basics.Units.Length length=1 "Length of adapter" annotation (Dialog(group="Discretisation", enable=(equalityMode == "Equal Heat Flow Rates")));
  parameter Basics.Units.Length Delta_x[N]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N) "Discretisation scheme" annotation (Dialog(group="Discretisation", enable=(equalityMode == "Equal Heat Flow Rates")));

  parameter Boolean useStabiliserState= false "True, if a stabiliser state shall be used" annotation(Dialog(tab="Expert Settings",enable = (equalityMode =="Equal Temperatures")));
  parameter ClaRa.Basics.Units.Time Tau=1 "Time Constant of Stabiliser State" annotation (Dialog(tab="Expert Settings", enable=(equalityMode == "Equal Temperatures") and (useStabiliserState)));

  ClaRa.Basics.Interfaces.HeatPort_a
                                   heatScalar
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.HeatPort_b heatVector[N]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation

  if equalityMode ==  "Equal Heat Flow Rates" then
    heatScalar.T = sum(heatVector.T.*Delta_x)/sum(Delta_x);
    heatVector.Q_flow = -heatScalar.Q_flow.*Delta_x/sum(Delta_x);
  elseif equalityMode == "Equal Temperatures" then
    heatScalar.Q_flow = -sum(heatVector.Q_flow);
    if useStabiliserState then
       der(heatVector.T) = (ones(N).*heatScalar.T - heatVector.T)/Tau;
    else
      heatVector.T = ones(N).*heatScalar.T;
    end if;
  else
    assert(false, "Unknown equalityMode option in scalar2VectorHeatPort");
  end if;

initial equation
if equalityMode == "Equal Temperatures" and useStabiliserState ==true then
  heatVector.T= ones( N)*heatScalar.T;
end if;
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
  revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),
   Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                   graphics), Diagram(graphics));
end Scalar2VectorHeatPort;
