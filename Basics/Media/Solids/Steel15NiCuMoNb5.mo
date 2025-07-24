within ClaRa.Basics.Media.Solids;
model Steel15NiCuMoNb5 "Steel15NiCuMoNb5 - 1.6368"
  //source: https://www.tugraz.at/fileadmin/user_upload/Institute/IEP/Thermophysics_Group/Files/Staehle-Richter.pdf
  extends ClaRa.Basics.Media.Solids.BaseSolid(
    final d = 7850.0,
    final cp_nominal = 430.0,
    final lambda_nominal = 57.0,
    final nu_nominal=-1,
    final E_nominal=-1,
    final G_nominal=-1,
    final beta_nominal=-1);

  function specificHeatCapacity
  input Real T;
  output Real cp;
  protected
    Real fi;
    Integer li;
    constant Integer n=7;
    final constant Real[7] TBar={293.15, 373.15, 473.15, 573.15, 673.15, 773.15, 873.15};
    final constant Real[7] cpBar={430, 500, 540, 580, 620, 690, 780};
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
    final constant Real[7] lambdaBar={35.9, 38.1, 39.2, 38.5, 37, 34.6, 32.1};
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
equation
  //d=density(T, d_nominal);
  cp=specificHeatCapacity(T);
  lambda=thermalConductivity(T);
  nu = nu_nominal;
  E = E_nominal;
  G=G_nominal;
  beta = beta_nominal;
end Steel15NiCuMoNb5;
