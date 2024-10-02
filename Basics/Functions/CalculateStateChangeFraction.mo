within ClaRa.Basics.Functions;
function CalculateStateChangeFraction "Calculate the fraction of state change in two-phase region to total state change"
  extends ClaRa.Basics.Icons.Function;
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_in "Inlet spec. enthalpy";
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Outlet spec.  enthalpy";
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_dew "Dew spec. enthalpy";
  input ClaRa.Basics.Units.EnthalpyMassSpecific h_bub "Bubble spec. enthalpy";

  output Real yps_2ph "Fraction of state change in two-phase region";
  output Integer case;
algorithm
    if abs(h_in-h_out)<1e-3 then
          yps_2ph:=0;
          case:=0 "in=out";
    else
      if h_in < h_bub then //---------------------------------one point is liquid
        if h_out  < h_bub then //neighbour point is liquid
            yps_2ph:=0;
            case:=1 "liq - liq";
        elseif h_out > h_dew then //neighbour point is superheated
            yps_2ph :=min(1, max(0, abs((h_dew - h_bub)/(h_out - h_in))));
            case:=2 "liq - vap";
        else
            yps_2ph :=min(1, max(0, abs((h_out - h_bub)/(h_out - h_in))));
            case:=3 "liq - 2ph";
        end if;
      elseif  h_in >  h_dew then //----------------------------one point is superheated
        if h_out  < h_bub then //neighbour point is liquid
            yps_2ph:=min(1, max(0, abs((h_dew - h_bub)/(h_out - h_in))));
            case:=4 "vap - liq";
        elseif h_out > h_dew then //neighbour point is superheated
            yps_2ph:=0;
            case:=5 "vap - vap";
        else // neighbour point is two phase
            yps_2ph:=min(1, max(0, abs((h_out - h_dew)/(h_out - h_in))));
            case:=6 "vap - 2ph";
        end if;
      else //--------------------------------------------------------------one point is two phase
        if h_out < h_bub then //neighbour point is liquid
          yps_2ph :=min(1, max(0, abs((h_in - h_bub)/(h_out - h_in))));
          case:=7 "2ph - liq";
        elseif h_out > h_dew then //neighbour point is superheated
          yps_2ph:=min(1, max(0, abs((h_in - h_dew)/(h_out - h_in))));
          case:=8 "2ph - vap";
        else // neighbour point is two phase
          yps_2ph:=1;
          case:=9 "2ph - 2ph";
        end if;
      end if;
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
</html>"));
end CalculateStateChangeFraction;
