within ClaRa.Basics.Media.Solids;
model Steel10CrMo9_10 "Steel10CrMo9_10 - 1.7380"
   //source: http://www.thyssenkrupp-stahlkontor.de/tl_files/ThyssenKrupp/pdf/10CrMo9-10.pdf

  extends ClaRa.Basics.Media.Solids.BaseSolid(
    final d=7760.0,
    final cp_nominal=622.0,
    final lambda_nominal=33,
    final nu_nominal=0.3,
    final E_nominal=2e11,
    final G_nominal=79e9,
    final beta_nominal=12e-6);
    function elasticityModulus
    input Real T;
    output Real E;
  protected
    Integer li;
    constant Integer n=4;
    final constant Real[4] TBar={293.15, 573.15, 673.15, 773.15};
    final constant Real[4] EBar={210e9, 185e9, 175e9, 165e9};
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
    end elasticityModulus;

    function beta_func
    input Real T;
    output Real beta;
  protected
    Integer li;
    constant Integer n=4;
    final constant Real[4] TBar={573.15, 673.15, 773.15,873.15};
    final constant Real[4] betaBar={12.9e-6, 13.5e-6, 13.9e-6,14.1e-6};
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
    end beta_func;
equation
  cp = cp_nominal;
  lambda = lambda_nominal;
  nu = nu_nominal;
  E = elasticityModulus(T);
  G= G_nominal;
  beta = beta_func(T);
end Steel10CrMo9_10;
