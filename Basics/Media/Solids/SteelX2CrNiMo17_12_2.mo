within ClaRa.Basics.Media.Solids;
model SteelX2CrNiMo17_12_2 "SteelX2CrNiMo17_12_2 - 1.4404"
   //Source: http://www.thyssenkrupp.at/files/rohre/Werkstoffdatenblaetter/1.4404.pdf"

  extends ClaRa.Basics.Media.Solids.BaseSolid(
    final d=8000.0,
    final cp_nominal=500.0,
    final lambda_nominal=15,
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
end SteelX2CrNiMo17_12_2;
