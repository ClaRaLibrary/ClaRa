within ClaRa;
model SimCenter
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

//extends ClaRa.Basics.Functions.ClaRaDelay.DelayInit;

  replaceable parameter TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid1 constrainedby
    TILMedia.VLEFluid.Types.BaseVLEFluid(final ID=1) "Medium name of working fluid in steam cycle"
    annotation (Dialog(tab="Media and Materials", group="ClaRa-based Models: VLE Components"), choicesAllMatching);
  replaceable parameter TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid2 constrainedby
    TILMedia.VLEFluid.Types.BaseVLEFluid(final ID=2) "Medium name of working fluid in steam cycle"
    annotation (Dialog(tab="Media and Materials", group="ClaRa-based Models: VLE Components"), choicesAllMatching);
  replaceable parameter TILMedia.VLEFluid.Types.TILMedia_SplineWater fluid3 constrainedby
    TILMedia.VLEFluid.Types.BaseVLEFluid(final ID=3) "Medium name of working fluid in steam cycle"
    annotation (Dialog(tab="Media and Materials", group="ClaRa-based Models: VLE Components"), choicesAllMatching);
  replaceable parameter TILMedia.Gas.Types.MoistAirMixture airModel constrainedby TILMedia.Gas.Types.BaseGas
    "Medium name of air model"
    annotation (Dialog(tab="Media and Materials", group="ClaRa-based Models: Gas Components"), choicesAllMatching);
  replaceable parameter TILMedia.Gas.Types.FlueGasTILMedia flueGasModel constrainedby TILMedia.Gas.Types.BaseGas
    "Medium name of flue gas model"
    annotation (Dialog(tab="Media and Materials", group="ClaRa-based Models: Gas Components"), choicesAllMatching);

  replaceable parameter ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel1 constrainedby ClaRa.Basics.Media.FuelTypes.EmptyFuel
                                                                                                                                "Fuel 1" annotation(Dialog(tab="Media and Materials", group="ClaRa-based Models: Fuel, Coal and Slag"),choicesAllMatching);
  replaceable parameter ClaRa.Basics.Media.FuelTypes.Fuel_refvalues_v1 fuelModel2   constrainedby ClaRa.Basics.Media.FuelTypes.EmptyFuel
                                                                                                                                  "Fuel 2" annotation(Dialog(tab="Media and Materials", group="ClaRa-based Models: Fuel, Coal and Slag"),choicesAllMatching);

  replaceable parameter ClaRa.Basics.Media.Slag.Slag_v1 slagModel constrainedby ClaRa.Basics.Media.Slag.PartialSlag "Medium name of slag model" annotation (Dialog(tab="Media and Materials", group="ClaRa-based Models: Fuel, Coal and Slag"), choicesAllMatching);

///////////////////////
  input ClaRa.Basics.Units.AbsolutePressure p_amb=1.013e5 "Ambient pressure" annotation (Dialog(tab="Ambience", group="Variable Input"));
  input ClaRa.Basics.Units.Temperature T_amb=293.15 "Ambient temperature" annotation (Dialog(tab="Ambience", group="Variable Input"));
  input ClaRa.Basics.Units.RelativeHumidity rh_amb=0.2 "Ambient relative humidity (0 < rh < 1)" annotation (Dialog(tab="Ambience", group="Variable Input"));
  parameter ClaRa.Basics.Units.AbsolutePressure p_amb_start(fixed=false) "Initial ambient pressure (automatically calculated)" annotation (Dialog(
      tab="Ambience",
      group="Start Values",
      enable=false));
  parameter ClaRa.Basics.Units.Temperature T_amb_start(fixed=false) "Initial ambient temperature (automatically calculated)" annotation (Dialog(
      tab="Ambience",
      group="Start Values",
      enable=false));

///////////////////////
    parameter Boolean showExpertSummary=false "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean largeFonts= false "|Summary and Visualisation||True if visualisers shall be displayed as large as posible";
  parameter Boolean contributeToCycleSummary = false "True if components shall contribute to automatic efficiency calculation"
                                                                                                  annotation(Dialog(tab="Summary and Visualisation"));

//////////////////////
  parameter Boolean steamCycleAllowFlowReversal = true "Allow flow reversal in steam cycle" annotation(Dialog(tab="Numerics", group="ClaRa-basedModels: VLE Components"));

   parameter Boolean useClaRaDelay=true "True for using ClaRa delay implementation / false for built in Modelica delay"
     annotation(Dialog(tab="Numerics",group="Delay Function"));
   parameter Real MaxSimTime=1e4 "Maximum time for simulation, must be set for Modelica delay blocks with variable delay time"
             annotation(Dialog(enable=useClaRaDelay==false,tab="Numerics", group="Delay Function"));
  parameter Boolean useHomotopy=true "True, if homotopy method is used during initialisation"
                                                             annotation(Dialog(tab="Numerics", group="Misc"),Evaluate=true);
    ClaRa.Basics.Interfaces.CycleSumPort cycleSumPort "Reference to the volume and mass of the VLE fluid in components"
      annotation(HideResult=false);

/////////////////////
  ClaRa.Basics.Units.EnthalpyMassSpecific h_amb_fluid1 "Ambient enthalpy of VLE fluid 1";
  ClaRa.Basics.Units.EntropyMassSpecific s_amb_fluid1 "Ambient entropy of VLE fluid 1";

  ClaRa.Basics.Units.EnthalpyMassSpecific h_amb_fluid2 "Ambient enthalpy of VLE fluid 2";
  ClaRa.Basics.Units.EntropyMassSpecific s_amb_fluid2 "Ambient entropy of VLE fluid 2";

  ClaRa.Basics.Units.EnthalpyMassSpecific h_amb_fluid3 "Ambient enthalpy of VLE fluid 3";
  ClaRa.Basics.Units.EntropyMassSpecific s_amb_fluid3 "Ambient entropy of VLE fluid 3";

protected
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid vleFluid_amb1(vleFluidType=fluid1)
    annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid vleFluid_amb2(vleFluidType=fluid2)
    annotation (Placement(transformation(extent={{-60,-12},{-40,8}})));
  TILMedia.VLEFluid.MixtureCompatible.VLEFluid vleFluid_amb3(vleFluidType=fluid3)
    annotation (Placement(transformation(extent={{-30,-12},{-10,8}})));

public
record summary_clara
  extends ClaRa.Basics.Icons.RecordIcon;
  Real eta_gross  "Gross electrical efficiency";
  Real eta_net    "Net electrical efficiency";
  Real eta_util   "Utilization efficiency";
  Real spec_heat_cons "Specific heat consumption";
end summary_clara;
  summary_clara summary(eta_gross=(cycleSumPort.power_out_elMech)/(cycleSumPort.power_in + 1e-6),
                        eta_net=(cycleSumPort.power_out_elMech - cycleSumPort.power_aux) /(cycleSumPort.power_in + 1e-6),
                        eta_util=(cycleSumPort.power_out_elMech + cycleSumPort.power_out_th - cycleSumPort.power_aux)/(1e-6 + cycleSumPort.power_in),
                        spec_heat_cons = if summary.eta_gross > 0 then 1/summary.eta_gross*3600 else 0);

initial equation
 p_amb_start=p_amb;
 T_amb_start=T_amb;
equation
 h_amb_fluid1 =  vleFluid_amb1.h_pTxi(p_amb,T_amb,fluid1.xi_default);
 s_amb_fluid1 =  vleFluid_amb1.s_pTxi(p_amb,T_amb,fluid1.xi_default);
 h_amb_fluid2 =  vleFluid_amb2.h_pTxi(p_amb,T_amb,fluid2.xi_default);
 s_amb_fluid2 =  vleFluid_amb2.s_pTxi(p_amb,T_amb,fluid2.xi_default);
 h_amb_fluid3 =  vleFluid_amb3.h_pTxi(p_amb,T_amb,fluid3.xi_default);
 s_amb_fluid3 =  vleFluid_amb3.s_pTxi(p_amb,T_amb,fluid3.xi_default);

annotation (   defaultComponentName="simCenter",
    defaultComponentPrefixes="inner",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}}),
         graphics={Bitmap(
          extent={{-200,-100},{200,100}},
          imageSource="iVBORw0KGgoAAAANSUhEUgAABGAAAAIwCAYAAADJUB1kAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7d37t911fefxd5JTQEADgQgKopXriIKoiNqLVq21lnqZOrUoNyM5QG6caC4mQBISMHINObnTKnZMlyFpo5mZTqcYDImENaszIokJhlYSTA6w1gRy0rAIu0n2OfNTWQW553zO+3y/+/H4C14/7HVW8lz7896DTjjlXb0BAAAAQDGDswcAAAAA1J0AAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFBYW/aAiIjTTjk5PviB92fPAAD6wd//r7uje/fu1A1HH3VU/MmnP5W6AQDoH//0f38W//yrR7JnDIwA88EPvD++PWt69gwAoB888OCG9ADzluOP828PAGgR37z2ugERYDxBAgAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAorC17ALweu7q74wtfuih7Rlx60Zfjqxd9OXsGFfPRT52fPSE+d/4fx9fHjc6eAQAALUOAoZKaB5rxyLZt2TOiu7s7ewIVNBA+u/9v55PZEwAAoKV4ggQAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQmAADAAAAUJgAAwAAAFCYAAMAAABQWFv2AAAAqJMTTz0zewLU3uyZ0+KiC76UPQNeE9+AAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAAChMgAEAAAAoTIABAAAAKEyAAQAAACisLXsAAADQOtra2uKv/3JRfPR3P5I9BaBf+QYMAADQbw4cOBDto6+KX2x+KHsKQL8SYAAAgH71zN69cfHIK2N7V1f2FIB+I8AAAAD9bufOJ+OiEVdE9+7d2VMA+oUAAwAApHhk27a4tH10NBqN7CkAxQkwAADQh4YOfVP2hEr52c8fjNHjJ0az2cyeAlCUX0HiVVn1P/5n/Le//4fsGc/5t3/blz0hIiJW/f0/xOZfbsme8Zyhb3pT3HbjDdkzAKClLe68LS4ccbmg8Br84+qfxDXX3RCzZ07LngJQjADDq/LI1m3xj6t/kj1jwHlk67Z4ZOu27BnPGX7sMdkTAKDl/d5HPhzTp06KabNmZ0+plO//4K5461uOj7FXtmdPASjCEyQAAOhjIy6+MC748y9mz6icG2+bGytWrsqeAVCEAAMAAAXMvu7aOO8D78+eUTkTr54Wa3+6PnsGQJ8TYAAAoIC2tra4Y8HtceIJb82eUikHDhyI9jEd8YvND2VPAehTAgwAABRyzLBhcefiBXH4G96QPaVSntm7Ny4eeWVs7+rKngLQZwQYAAAo6D+dcVp03vLtGDRoUPaUStm588m4cMTl0b17d/YUgD4hwAAAQGGf/tQnY0LHmOwZlbN126NxafvoaDQa2VMADpoAAwAA/eCqUVfEn37m09kzKudnP38wRo+fGM1mM3sKwEERYAAAoJ/MufGGeM+Z78qeUTn/uPoncc11N2TPADgoAgwAAPSTww47LL67eH4MH35s9pTK+f4P7orOhUuyZwC8bgIMAAD0o7ccf1x8Z2FnHHLIIdlTKuemOZ2xYuWq7BkAr4sAAwAA/ex97z07brp+RvaMSpo49dpY+9P12TMAXjMBBgAAEnzxC5+LKy77avaMyjnQbEb7mI74xeaHsqcAvCYCDAAAJJk68evx8Y/9fvaMynlm7964+LIrYntXV/YUgFdNgAEAgCSDBw+OBXNujlNPfmf2lMrZ+eRTceGIy6N79+7sKQCvigADAACJ3njkkXHnkgUxdOibsqdUztZtj8al7aOj0WhkTwF4RQIMAAAke8fbT4rFnbdF25Ah2VMq52c/fzBGdUyIZrOZPQXgZQkwAAAwAPzeRz4c06dOzp5RSXffsyauue6G7BkAL0uAAQCAAeKrF38lvvylL2bPqKTv/+Cu6Fy4JHsGwEsSYAAAYAD51oxr47xzP5A9o5JumtMZK1auyp4B8KIEGAAAGEDa2trijvlz4m0nnJA9pZImTr021v50ffYMgN8gwAAAwABzzLBhceeS+XHE4YdnT6mcA81mtI/piF9sfih7CsDzCDAAADAAnXH6aTH3lm/HoEGDsqdUzjN798bFl10R27u6sqcAPEeAAQCAAerTf/iJmNAxJntGJe188qm4cMTl0b17d/YUgIgQYAAAYEC7atQV8dk/+ePsGZW0ddujccnIUdFoNLKnAAgwAAAw0N327evjrHefmT2jkh54cEOM6pgQzWYzewrQ4gQYAAAY4A477LD4zqJ5MXz4sdlTKunue9bENdfdkD0DaHECDAAAVMBbjj8uvrOwMw455JDsKZX0/R/cFZ0Ll2TPAFqYAAMAABXxvveeHTddPyN7RmXdNKczVqxclT0DaFECDAAAVMgXv/C5uPKyEdkzKmvi1Gtj7U/XZ88AWpAAAwAAFTNl4vj4+Md+P3tGJR1oNqN9TEf8YvND2VOAFiPAAABAxQwePDgWzLk5Tj35ndlTKumZvXvj4suuiO1dXdlTgBYiwAAAQAW98cgj484lC+KooUOzp1TSziefigtHXB7du3dnTwFahAADAAAV9Y63nxSLO2+LtiFDsqdU0tZtj8YlI0dFo9HIngK0AAEGAAAq7Hc/8qGYfvU3s2dU1gMPbohRHROi2WxmTwFqToABAICK++pFX46v/MV/yZ5RWXffsyaunnF99gyg5gQYAACogRumXxPnnfuB7BmVtXTZ8uhcuCR7BlBjAgwAANRAW1tb/OWC2+NtJ5yQPaWybprTGctX/ih7BlBTAgwAANTEsKOPjjuXzI8jDj88e0plTZo6Ldb+dH32DKCGBBgAAKiRM04/LTpvvTEGDRqUPaWSDjSb0T6mI36x+aHsKUDNCDAAAFAzf/TJj8fEjrHZMyrrmb174+LLrojtXV3ZU4AaEWAAAKCGxo26PD53/meyZ1TWziefigtHXB67uruzpwA1IcAAAEBN3Tp7Vpz17jOzZ1TW1m2PxqXto6PRaGRPAWpAgAEAgJo67LDD4ruL58Wbhw/PnlJZDzy4IUZ1TIhms5k9Bag4AQYAAGrs+OOOi+8s6oxDDjkke0pl3X3Pmrh6xvXZM4CKE2AAAKDmzjn7rLj5huuyZ1Ta0mXLY+7CxdkzgAoTYAAAoAX82ec/G1deNiJ7RqXdPGdeLF/5o+wZQEUJMAAA0CKmTBwfn/jYR7NnVNqkqdNi7U/XZ88AKkiAAQCAFjF48OCYP+emOPXkd2ZPqawDzWa0j+mIjZs2Z08BKkaAAQCAFvLGI4+M792xMI4aOjR7SmU9s3dvXDLyytje1ZU9BagQAQYAAFrM2096WyyZNyfahgzJnlJZO598Ki4ccXns6u7OngJUhAADAAAt6Hc+fF7MuGZK9oxK27rt0bi0fXQ0Go3sKUAFCDAAANCiLr3wgrjwL/48e0alPfDghhjVMSGazWb2FGCAE2AAAKCFXT/96vjQB8/NnlFpd9+zJq6ecX32DGCAE2AAAKCFtbW1xR3z58RJJ56YPaXSli5bHnMXLs6eAQxgAgwAALS4YUcfHXcumR9HHH549pRKu3nOvFi+8kfZM4ABSoABAADi9NNOjc5bb4xBgwZlT6m0SVOnxb3r7sueAQxAAgwAABAREX/0yY/HpPHjsmdU2oFmMy4fOz42btqcPQUYYAQYAADgOWOvbI/Pn/+Z7BmV9szevXHJyCtj+46u7CnAACLAAAAAz3PL7Flx1nvOzJ5RaTuffCou/Nrlsau7O3sKMEAIMAAAwPMcdthh8d1F8+LNw4dnT6m0rdsejUvbR8ezzzaypwADgAADAAD8huOPOy6+s6gzDj300OwplfbAgxti9PgJ0Ww2s6cAyQQYAADgRZ1z9llx8w3XZc+ovLvvWRNXz7g+ewaQTIABAABe0n/+3J/GqJFfy55ReUuXLY+5CxdnzwASCTAAAMDL+uaEjvjExz6aPaPybp4zL5av/FH2DCCJAAMAALyswYMHx/w5N8Vpp5ycPaXyJk2dFveuuy97BpBAgAEAAF7RG488Mu5csiCOGjo0e0qlHWg24/Kx42Pjps3ZU4B+JsAAAACvyttPelssmTcn2oYMyZ5Sac/s3RuXjLwytu/oyp4C9CMBBgAAeNV+58PnxYxrpmTPqLydTz4VXxnRHru6u7OnAP2kLXsA1TB8+LHxrjNOz57xnAMHmvHPv/pV9owYfuyxMfzYY7JnPGfYsKOzJwAALeDSCy+ILQ//cyxdtjx7SqVte/TXcWn76Ljrv3433vCGw7LnAIUJMLwqF13wpbjogi9lz3jOzp1Pxjkfyb/Ef9EFfx5fHzc6ewYAQL+7fvrV8aut2+J//9P/yZ5SaQ88uCFGdXwj/mphZwzxtAtqzRMkAADgNWtra4s75s+Jk048MXtK5f34J/fG1TOuz54BFCbAAAAAr8uwo4+OO5fMjyMOPzx7SuUtXbY85i5cnD0DKEiAAQAAXrfTTzs15t12UwwaNCh7SuXdPGde3PV3P8yeARQiwAAAAAflU5/4g5j89auyZ9TC5Kunx73r7sueARQgwAAAAAdtzBUj4/PnfyZ7RuUdaDbj8rHjY+OmzdlTgD4mwAAAAH3i1m9fH2e958zsGZX3zN69ccnIK2P7jq7sKUAfEmAAAIA+ceihh8adi+fHm4cPz55SeTuffCq+MqI9dnV3Z08B+ogAAwAA9Jnj3vzm+O7ieXHooYdmT6m8bY/+Oi4ZOSqefbaRPQXoAwIMAADQp9571nvilm/NzJ5RCz/fsDFGdXwjms1m9hTgIAkwAABAn/vCZ8+PUe1fy55RCz/+yb0xdcas7BnAQRJgAACAIr75jY745B98NHtGLfzNshVx+4LF2TOAgyDAAAAARQwePDjmz7k5Tjvl5OwptXDL7fPirr/7YfYM4HUSYAAAgGKOPOKI+N4dC+OooUOzp9TC5Kunx73r7sueAbwOAgwAAFDUSW87Me6Yf3u0DRmSPaXyDjSbcfnY8bFx0+bsKcBrJMAAAADFfeRDH4zrrp2SPaMWntm7Ny4ZeWVs39GVPQV4DQQYAACgX1zylQviogu+lD2jFnY++VR8ZUR77Oruzp4CvEoCDAAA0G9mTZsaHz7v3OwZtbDt0V/HJSNHxbPPNrKnAK+CAAMAAPSbtra2uGP+7XHS207MnlILP9+wMUZ1fCOazWb2FOAVCDAAAEC/Ovqoo+J7SxbEkUcckT2lFn78k3tj6oxZ2TOAVyDAAAAA/e60U0+JebfdFIMH+y9JX/ibZSvi9gWLs2cAL8NfOwAAIMUffvxjMWn8uOwZtXHL7fPirr/7YfYM4CUIMAAAQJoxV4yMz//pn2TPqI3JV0+Pe9fdlz0DeBECDAAAkOrW2bPitFNPyZ5RCweazWgf0xH/8sjW7CnACwgwAABAql9t3Rbbd3Rlz6iNU05+Z5x04gnZM4AXEGAAAIA0e/Y8HSNHXxWNRiN7Si0cM2xY/NXCzjj00EOzpwAvIMAAAAApent7Y9yEyb790kfahgyJJfNui7e+5fjsKcCLEGAAAIAUnYuWxOo1a7Nn1Ma0qZPiQx88N3sG8BIEGAAAoN+tve/+uHXuguwZtfHFL3wuRlx8YfYM4GUIMAAAQL967PEnYsz4idHT05M9pRbOeveZceOs6dkzgFcgwAAAAP1m37590T62I7p3786eUguO7kJ1CDAAAEC/mTZrdmzYuCl7Ri04ugvVIsAAAAD9YsXKVbF02fLsGbXh6C5UiwADAAAUt/mXW2LK9JnZM2rD0V2oHgEGAAAoas+ep2Pk6Kui0WhkT6kFR3ehmgQYAACgmN7e3hg3YXJs39GVPaUWHN2F6hJgAACAYjoXLYnVa9Zmz6gFR3eh2gQYAACgiLX33R+3zl2QPaM2HN2FahNgAACAPvfY40/EmPETo6enJ3tKLTi6C9UnwAAAAH1q37590T62I7p3786eUguO7kI9CDAAAECfmjZrdmzYuCl7Ri04ugv1IcAAAAB9ZsXKVbF02fLsGbXg6C7UiwADAAD0ic2/3BJTps/MnlEbju5CvQgwAADAQduz5+kYOfqqaDQa2VNqwdFdqB8BBgAAOCi9vb0xbsLk2L6jK3tKLTi6C/UkwAAAAAelc9GSWL1mbfaMWnB0F+pLgAEAAF63devvj1vnLsieUQttQ4bE4k5Hd6GuBBgAAOB1eezxJ2J0x8To6enJnlIL06ZOig+f5+gu1JUAAwAAvGb79u2L9rEd0b17d/aUWnB0F+pPgAEAAF6zabNmx4aNm7Jn1IKju9AaBBgAAOA1WbFyVSxdtjx7Ri04ugutQ4ABAABetc2/3BJTps/MnlELju5CaxFgAACAV2XPnqdj5OirotFoZE+pBUd3obUIMAAAwCvq7e2NcRMmx/YdXdlTasHRXWg9AgwAAPCKOhctidVr1mbPqAVHd6E1CTAAAMDLWrf+/rh17oLsGbVwzLBh8ZcL5jq6Cy1IgAEAAF7SY48/EaM7JkZPT0/2lMr796O7J7z1LdlTgAQCDAAA8KL27dsX7WM7onv37uwpteDoLrQ2AQYAAHhR02bNjg0bN2XPqAVHdwEBBgAA+A0rVq6KpcuWZ8+oBUd3gQgBBgAAeIHNv9wSU6bPzJ5RC47uAv9OgAEAAJ6zZ8/TMXL0VdFoNLKnVJ6ju8B/JMAAAAAREdHb2xvjJkyO7Tu6sqfUgqO7wH8kwAAAABER0bloSaxeszZ7Ri04ugu8kAADAADEuvX3x61zF2TPqAVHd4EXI8AAAECLe+zxJ2LM+EnR09OTPaXyHN0FXkpb9gCAkvbv3x/PPuuI4Avt27c/9ux5OnvG87zpTW/MngDQkvbt2xftYztiV3d39pTKc3QXeDkCDFBry/52ZUyZ5mc0X2j5yh/G8pU/zJ7xPF3/sjl7AkBLmjZrdmzYuCl7Ri1cO2Wio7vAS/IECQAAWtSKlati6bLl2TNq4c8+/9n42iUXZc8ABjABBgAAWtDmX26JKdN9S7QvnPXuM+Om62dkzwAGOAEGAABazJ49T8fI0VdFo+FO2sFydBd4tQQYAABoIb29vTFuwuTYvqMre0rlOboLvBYCDAAAtJDORUti9Zq12TNqwdFd4LUQYAAAoEWsW39/3Dp3QfaMWnB0F3itBBgAAGgBjz3+RIwZPyl6enqyp1Seo7vA6yHAAABAze3bty/ax3bEru7u7CmV5+gu8HoJMAAAUHPTZs2ODRs3Zc+oPEd3gYMhwAAAQI2tWLkqli5bnj2jFhzdBQ6GAAMAADX10JaHY8r0mdkzasHRXeBgCTAAAFBDe/Y8HZeNGheNRiN7SuU5ugv0BQEGAABqpre3N8ZNmBzbd3RlT6k8R3eBviLAAABAzcxbdEesXrM2e0blOboL9CUBBgAAamTd+vvjlrnzs2fUgqO7QF8SYAAAoCYee/yJGDN+UvT09GRPqTxHd4G+JsAAAEAN7Nu3L9rHdsSu7u7sKZXn6C5QggADAAA1MG3W7NiwcVP2jMpzdBcoRYABAICKW7FyVSxdtjx7RuU5uguUJMAAAECFPbTl4ZgyfWb2jFpwdBcoSYABAICK2rPn6bhs1LhoNBrZUyrP0V2gNAEGAAAqqLe3N8ZNmBzbd3RlT6k8R3eB/iDAAABABc1bdEesXrM2e0blOboL9BcBBgAAKmbd+vvjlrnzs2dUnqO7QH8SYAAAoEIee/yJGDN+UvT09GRPqTxHd4H+JMAAAEBF7N+/P9rHdsSu7u7sKZXn6C7Q3wQYAACoiGtnfis2bNyUPaPyHN0FMggwAABQAStWroqly5Znz6g8R3eBLAIMAAAMcA9teTimTJ+ZPaPyHN0FMgkwAAAwgO3Z83RcNmpcNBqN7CmV5+gukEmAAQCAAaq3tzfGTZgc23d0ZU+pPEd3gWwCDAAADFDzFt0Rq9eszZ5Ree85812O7gLpBBgAABiA1q2/P26ZOz97RuUdM2xY/NXCTkd3gXQCDAAADDCPPf5EjBk/KXp6erKnVJqju8BAIsAAAMAAsn///mgf2xG7uruzp1Seo7vAQCLAAADAAHLtzG/Fho2bsmdUnqO7wEAjwAAAwACxYuWqWLpsefaMynN0FxiIBBgAABgAHtrycEyZPjN7RuU5ugsMVAIMAAAk27Pn6bhs1LhoNBrZUyrN0V1gIBNgAAAgUW9vb4ybMDm27+jKnlJ5ju4CA5kAAwAAieYtuiNWr1mbPaPyHN0FBjoBBgAAkqxbf3/cMnd+9ozKc3QXqAIBBgAAEjz2+BMxZvyk6OnpyZ5SaY7uAlUhwAAAQD/bv39/tI/tiF3d3dlTKs3RXaBKBBgAAOhn1878VmzYuCl7RuU5ugtUiQADAAD9aMXKVbF02fLsGZXn6C5QNQIMAAD0k4e2PBxTps/MnlF5ju4CVSTAAABAP9iz5+kYOfqqaDQa2VMqzdFdoKoEGAAAKKy3tzfGTZgcv96+I3tKpTm6C1SZAAMAAIXNW3RHrF6zNntG5Tm6C1SZAAMAAAWtW39/3DJ3fvaMynN0F6g6AQYAAAp57PEnYsz4SdHT05M9pdIc3QXqQIABAIAC9u/fH+1jO2JXd3f2lEpzdBeoCwEGAAAKuHbmt2LDxk3ZMyrN0V2gTgQYAADoYytWroqly5Znz6g8R3eBOhFgAACgDz205eGYMn1m9ozKc3QXqBsBBgAA+tDI0VdFo9HInlFpju4CdSTAAABAH/r19h3ZEyrN0V2grgQYAABgQHB0F6gzAQYAABgQHN0F6kyAAQAA0jm6C9SdAAMAAKRydBdoBQIMAACQxtFdoFUIMAAAQApHd4FWIsAAAAApHN0FWokAAwAA9DtHd4FWI8AAAAD96j1nvitunDU9ewZAv2rLHgAAALSOtra2GNX+tXhoy8PZU6ih97337OwJ8JIEGAAAoN8cOHAgrrzqG9kzqKmuf9mcPQFekgAD1Nq57zsnZlw9OXvG88y44cbsCfGBc94b53/mj7JnAABAyxBggFo74/TT4ozTT8ue8TwDIcCccfppcdmlF2fPAACAluEILwAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhbdkDAACgTs45+6zsCQAMQAIMAAD0of/+tz/IngDAAOQJEgAAAEBhAgwAAABAYQIMAAAAQGECDAAAAEBhAgwAAABAYQIMAAAAQGF+hppK+q1Dfis+9MFzs2fEiSeekD2BChoIn913/vY7sicAAEBLEWCopKOGDo2//ZvvZc+A18VnFwAAWo8nSAAAAACFCTAAAAAAhQkwAAAAAIUJWwa2nQAAA0JJREFUMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQkwAAAAAIUJMAAAAACFCTAAAAAAhQ064ZR39WaPeOdvvyPef87Z2TMAgH7w43vujd3/+q+pG44aOjT+8BMfS90AAPSPn/18Q2zd9mj2jIERYAAAAADqzBMkAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDCBBgAAACAwgQYAAAAgMIEGAAAAIDC/j8IUZQw8TThgwAAAABJRU5ErkJggg==",
          fileName="modelica://ClaRa/Resources/Images/Components/SimCenter.png"), Text(
          visible=contributeToCycleSummary,
          extent={{200,80},{800,20}},
          lineColor={0,131,169},
          textStyle={TextStyle.Bold},
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("eta_gross", "eta_gross = " + String(summary.eta_gross*100, format="1.2f") + " %%")),Text(
          visible=contributeToCycleSummary,
          extent={{200,-20},{800,-80}},
          lineColor={0,131,169},
          textStyle={TextStyle.Bold},
          horizontalAlignment=TextAlignment.Left,
          textString=DynamicSelect("eta_net", "eta_net = " + String(summary.eta_net*100, format="1.2f") + " %%"))}),
     Documentation(info="<html>
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
end SimCenter;
