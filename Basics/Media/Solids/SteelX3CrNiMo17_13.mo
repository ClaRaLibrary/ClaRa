within ClaRa.Basics.Media.Solids;
model SteelX3CrNiMo17_13 "SteelX3CrNiMo17_13 - 1.4910"
  //source: https://www.tugraz.at/fileadmin/user_upload/Institute/IEP/Thermophysics_Group/Files/Staehle-Richter.pdf

  extends ClaRa.Basics.Media.Solids.BaseSolid(
    final d=7980.0,
    final cp_nominal=450.0,
    final lambda_nominal=16,
    final nu_nominal=0.3,
    final E_nominal=193e9,
    final G_nominal=79e9,
    final beta_nominal=12e-6);
function elasticityModulus
input Real T;
output Real E;
  protected
Integer li;
constant Integer n=4;
final constant Real[4] TBar={293.15, 473.15, 673.15, 773.15};
final constant Real[4] EBar={200e9, 186e9, 172e9, 165e9};
algorithm
if (TBar[1]>=T) then
  E:=EBar[1];
elseif (TBar[n]<=T) then
  E:=EBar[n];
else
  li:=1;
  while (li <= n and TBar[li]<T) loop
    li:=li+1;
  end while;
  li := min(li,n);
  li := li-1;
  E:=(EBar[li+1] - EBar[li])*((T-TBar[li])/(TBar[li+1]-TBar[li]))  + EBar[li];
end if;
annotation (Documentation(info="see Material Data XRG"));
end elasticityModulus;

    function beta_func
    input Real T;
    output Real beta;
  protected
    Integer li;
    constant Integer n=5;
    final constant Real[5] TBar={373.15, 473.15,573.15,673.15,773.15};
    final constant Real[5] betaBar={16.0,16.5,17.0,17.5,18.0}*1e-6;
    algorithm
    if (TBar[1]>=T) then
      beta:=betaBar[1];
    elseif (TBar[n]<=T) then
      beta:=betaBar[n];
    else
      li:=1;
      while (li <= n and TBar[li]<T) loop
        li:=li+1;
      end while;
      li := min(li,n);
      li := li-1;
      beta:=(betaBar[li+1] - betaBar[li])*((T-TBar[li])/(TBar[li+1]-TBar[li]))  + betaBar[li];
    end if;
    annotation (Documentation(info="see Material Data XRG"));
    end beta_func;

equation
  cp = cp_nominal;
  lambda = lambda_nominal;
  nu = nu_nominal;
  E = elasticityModulus(T);
  G= G_nominal;
  beta = beta_func(T);
public
function specificHeatCapacity
input Real T;
output Real cp;
  protected
  Real fi;
  Integer li;
  constant Integer n=7;
  final constant Real[7] TBar={293.15, 373.15, 473.15, 573.15, 673.15, 773.15, 873.15};
  final constant Real[7] cpBar={472, 501, 525, 532, 555, 582, 604};
  Real beta;
algorithm
  if (TBar[1]>=T) then
    cp:=cpBar[1];
  elseif (TBar[n]<=T) then
    cp:=cpBar[n];
  else
    li:=1;
    while (li <= n and TBar[li]<T) loop
      li:=li+1;
    end while;
    li := min(li,n);
    li := li-1;
    fi:=(T-293.15)/100;
    cp:=(cpBar[li+1] - cpBar[li])*((T-TBar[li])/(TBar[li+1]-TBar[li]))  + cpBar[li];
  end if;
  annotation (Documentation(info="<html>see VDI-W&auml;rmeatlas pp. Dea 5</html>"));
end specificHeatCapacity;

function thermalConductivity
input Real T;
output Real lambda;
  protected
  Real fi;
  Integer li;
  constant Integer n=7;
  final constant Real[7] TBar={293.15, 373.15, 473.15, 573.15, 673.15, 773.15, 873.15};
  final constant Real[7] lambdaBar={13.3, 14.8, 16.5, 18.1, 19.6, 21.1, 22.6};
  Real beta;
algorithm
  if (TBar[1]>=T) then
    lambda:=lambdaBar[1];
  elseif (TBar[n]<=T) then
    lambda:=lambdaBar[n];
  else
    li:=1;
    while (li <= n and TBar[li]<T) loop
      li:=li+1;
    end while;
    li := min(li,n);
    li := li-1;
    fi:=(T-293.15)/100;
    lambda:=(lambdaBar[li+1] - lambdaBar[li])*((T-TBar[li])/(TBar[li+1]-TBar[li]))  + lambdaBar[li];
  end if;
  annotation (Documentation(info="<html>
<p>see VDI-W&auml;rmeatlas pp. Dea 5</p>
</html>"));
end thermalConductivity;
end SteelX3CrNiMo17_13;
