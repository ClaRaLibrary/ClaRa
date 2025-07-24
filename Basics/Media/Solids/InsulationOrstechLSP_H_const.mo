within ClaRa.Basics.Media.Solids;
model InsulationOrstechLSP_H_const "Orstech Insulation"
  extends ClaRa.Basics.Media.Solids.BaseSolid(
    final d = 100.0,
    final cp_nominal = 800.0,
    final lambda_nominal = 0.1,
    final nu_nominal=-1,
    final E_nominal=-1,
    final G_nominal=-1,
    final beta_nominal=-1);
equation
  cp=cp_nominal;
  lambda=lambda_nominal;
  nu = nu_nominal;
  E = E_nominal;
  G = G_nominal;
  beta = beta_nominal;
end InsulationOrstechLSP_H_const;
