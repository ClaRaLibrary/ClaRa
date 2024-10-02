within ClaRa.Basics.Functions;
function pressureInterpolation "Finds pressure values in discretised volumes"
 //___________________________________________________________________________//
 // Component of the ClaRa library, version: 1.8.2                            //
 //                                                                           //
 // Licensed by the DYNCAP/DYNSTART research team under the 3-clause BSD License.   //
 // Copyright  2013-2021, DYNCAP/DYNSTART research team.                      //
 //___________________________________________________________________________//
 // DYNCAP and DYNSTART are research projects supported by the German Federal //
 // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
 // The research team consists of the following project partners:             //
 // Institute of Energy Systems (Hamburg University of Technology),           //
 // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
 // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
 // XRG Simulation GmbH (Hamburg, Germany).                                   //
 //___________________________________________________________________________//
     extends ClaRa.Basics.Icons.Function;

  input ClaRa.Basics.Units.Pressure p_inlet "Pressure at inlet";
  input ClaRa.Basics.Units.Pressure p_outlet "Pressure at outlet";
  input ClaRa.Basics.Units.Length[:] Delta_x "Discretisation scheme";
     input Boolean frictionAtInlet "True if pressure loss between first cell and inlet shall be considered";
     input Boolean frictionAtOutlet "True if pressure loss between last cell and outlet shall be considered";

     output Real[size(Delta_x,1)] p_i "Pressure in discrete Volumes i";

protected
     Integer N_cv = size(Delta_x,1) "Number of discrete volumes in original discretisation scheme";
  ClaRa.Basics.Units.Length[N_cv + 1] Delta_x_internal "Internal discretisation scheme";
  ClaRa.Basics.Units.Pressure[N_cv + 1] p_i_internal "Pressures in internal discrete volumes i";
  ClaRa.Basics.Units.Length[N_cv + 1] x_i_internal "Absolute internal grid points";

algorithm
     // calculate internal discretisation scheme
     Delta_x_internal[1] := Delta_x[1]/2; //half of the first volume is allocated to inlet pressure loss
     for i in 2:N_cv loop
     Delta_x_internal[i] := Delta_x[i-1]/2 + Delta_x[i]/2;
     end for;
     Delta_x_internal[end] :=Delta_x[end]/2; //half of the last volume is allocated to outlet pressure loss)

     // generate absolute grid point from internal discretisation scheme (sum)
     for i in 1:N_cv+1 loop
       x_i_internal[i] :=sum(Delta_x_internal[1:i]);
     end for;

     // calculate pressures of internal discrete volumes using linear interpolation
     if frictionAtInlet and frictionAtOutlet then
     p_i_internal := ClaRa.Basics.Functions.vectorInterpolation(
       x_i_internal,
       0,
       p_inlet,
       x_i_internal[end],
       p_outlet);
     elseif not frictionAtInlet and frictionAtOutlet then
      p_i_internal := ClaRa.Basics.Functions.vectorInterpolation(
       x_i_internal,
       x_i_internal[1],
       p_inlet,
       x_i_internal[end],
       p_outlet);
     elseif frictionAtInlet and not frictionAtOutlet then
      p_i_internal := ClaRa.Basics.Functions.vectorInterpolation(
       x_i_internal,
       0,
       p_inlet,
       x_i_internal[end-1],
       p_outlet);
     else
      p_i_internal := ClaRa.Basics.Functions.vectorInterpolation(
       x_i_internal,
       x_i_internal[1],
       p_inlet,
       x_i_internal[end-1],
       p_outlet);
     end if;

     // pass calculated values back into original discretisation scheme
     p_i := p_i_internal[1:end - 1];
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
</html>"));
end pressureInterpolation;
