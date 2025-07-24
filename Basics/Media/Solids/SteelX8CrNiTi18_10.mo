within ClaRa.Basics.Media.Solids;
model SteelX8CrNiTi18_10 "SteelX8CrNiTi18_10 - 1.4878"
   //Source: http://www.edelstahl-service-center.de/tl_files/ThyssenKrupp/PDF/Datenblaetter/1.4878.pdf;"

  extends ClaRa.Basics.Media.Solids.BaseSolid(
    final d=7900.0,
    final cp_nominal=500.0,
    final lambda_nominal=15,
    final nu_nominal=0.3,
    final E_nominal=193e9,
    final G_nominal=79e9,
    final beta_nominal=12e-6);

    function beta_func
    input Real T;
    output Real beta;
  protected
    Integer li;
    constant Integer n=4;
    final constant Real[4] TBar={473.15, 673.15, 873.15, 1073.15};
    final constant Real[4] betaBar={17e-6, 18.2e-6, 18.5e-6, 19e-6};
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

        function lambda_func
          input Real T;
          output Real lambda;
  protected
          Integer li;
          constant Integer n=2;
          final constant Real[2] TBar={373.15,773.15};
          final constant Real[2] lambdaBar={16.1,22.2};
        algorithm
          if (TBar[1] >= T) then
            lambda := lambdaBar[1];
          elseif (TBar[n] <= T) then
            lambda := lambdaBar[n];
          else
            li := 1;
            while (li <= n and TBar[li] < T) loop
        li:=li+1;
            end while;
            li := min(li, n);
            li := li - 1;
            lambda := (lambdaBar[li + 1] - lambdaBar[li])*
                                                    ((T - TBar[li])/(TBar[li +
        1]
         - TBar[li])) + lambdaBar[li];
          end if;
        end lambda_func;
equation
  cp = cp_nominal;
  lambda = lambda_func(T);
  nu = nu_nominal;
  E = E_nominal;
  G= G_nominal;
  beta = beta_func(T);
end SteelX8CrNiTi18_10;
