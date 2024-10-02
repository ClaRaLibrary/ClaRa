within ClaRa.Components.VolumesValvesFittings.Valves;
model GenericValveVLE_L1 "Valve for VLE fluid flows with replaceable flow models"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.2                           //
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

//  extends ClaRa.Basics.Icons.Valve;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import SI = ClaRa.Basics.Units;
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary;
    input Basics.Units.VolumeFlowRate V_flow "Volume flow rate";
    input Basics.Units.PressureDifference Delta_p "Pressure difference p_out - p_in";
    input Real PR  if showExpertSummary "Pressure ratio, always <1, i.e. dependent on flow direction";
    input Real PR_choked   if showExpertSummary "Critical pressure ratio";
    input Real opening_ "Valve opening in p.u.";
    input Real flowIsChoked "1 if flow is choked, 0 if not";
  end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeVLE           inlet;
    ClaRa.Basics.Records.FlangeVLE           outlet;
  end Summary;
  inner parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium in the component"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model PressureLoss =
   ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV
    constrainedby ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss "Pressure loss model at the tubes side"
                                            annotation (Dialog(group=
          "Fundamental Definitions"), choicesAllMatching);
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"));

  parameter Boolean openingInputIsActive=false "True, if  a variable opening is used"
    annotation (Dialog(group="Control Signals"));
  parameter Real opening_const_=1 "A constant opening: =1: open, =0: closed"
    annotation (Dialog(group="Control Signals", enable=not openingInputIsActive));

  inner parameter Boolean checkValve=false "True, if valve is check valve"
    annotation (Evaluate=true, Dialog(group="Fundamental Definitions"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean useStabilisedMassFlow=false "|Expert Settings|Numerical Robustness|";
  input Basics.Units.Time Tau=0.1 "Time Constant of Stabilisation" annotation (Dialog(
      tab="Expert Settings",
      group="Numerical Robustness",
      enable=useStabilisedMassFlow));

  input Real opening_leak_ = 0 "Leakage valve opening in p.u." annotation(Dialog(tab="Expert Settings", group = "Numerical Robustness"));
  outer ClaRa.SimCenter simCenter;

protected
  Real opening_ "Valve opening in p.u.";

  Basics.Units.MassFlowRate m_flow_ "stabilised mass flow rate";

public
  Modelica.Blocks.Interfaces.RealInput opening_in=opening_ if (openingInputIsActive) "=1: completely open, =0: completely closed"
                                                 annotation (Placement(
        transformation(
        origin={0,80},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,90})));

  ClaRa.Basics.Interfaces.FluidPortIn inlet(Medium=medium) "Inlet port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.FluidPortOut outlet(Medium=medium) "Outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  PressureLoss pressureLoss
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

public
  Summary summary(
    outline(showExpertSummary=showExpertSummary,
            V_flow =  inlet.m_flow/iCom.rho_in,
            Delta_p = pressureLoss.Delta_p,
            PR = noEvent(min(outlet.p,inlet.p)/max(inlet.p,outlet.p)),
            PR_choked = pressureLoss.PR_choked,
            flowIsChoked= pressureLoss.flowIsChoked,
            opening_= iCom.opening_),
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=inlet.m_flow,
      T=fluidIn.T,
      p=inlet.p,
      h=fluidIn.h,
      s=fluidIn.s,
      steamQuality=fluidIn.q,
      H_flow=fluidIn.h*inlet.m_flow,
      rho=fluidIn.d),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-outlet.m_flow,
      T=fluidOut.T,
      p=outlet.p,
      h=fluidOut.h,
      s=fluidOut.s,
      steamQuality=fluidOut.q,
      H_flow=-fluidOut.h*outlet.m_flow,
      rho=fluidOut.d))
    annotation (Placement(transformation(extent={{-40,-52},{-20,-32}})));
public
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph fluidOut(
    p=outlet.p,
    vleFluidType=medium,
    h=if noEvent((checkValve == true and opening_leak_ <= 0) or opening_ <
        opening_leak_) then outlet.h_outflow else ClaRa.Basics.Functions.Stepsmoother(10,-10,pressureLoss.Delta_p)*outlet.h_outflow + ClaRa.Basics.Functions.Stepsmoother(-10,10,pressureLoss.Delta_p)*inStream(outlet.h_outflow),
    xi=if noEvent((checkValve == true and opening_leak_ <= 0) or opening_ < opening_leak_) then outlet.xi_outflow else ClaRa.Basics.Functions.Stepsmoother(10,-10,pressureLoss.Delta_p)*outlet.xi_outflow + ClaRa.Basics.Functions.Stepsmoother(-10,10,pressureLoss.Delta_p)*inStream(outlet.xi_outflow))
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

public
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    p=inlet.p,
    h=if noEvent((checkValve == true and opening_leak_ <= 0) or opening_ <
        opening_leak_) then inStream(inlet.h_outflow) else ClaRa.Basics.Functions.Stepsmoother(10,-10,pressureLoss.Delta_p)*inStream(inlet.h_outflow) + ClaRa.Basics.Functions.Stepsmoother(-10,10,pressureLoss.Delta_p)*inlet.h_outflow,
    xi=if noEvent((checkValve == true and opening_leak_ <= 0) or opening_ < opening_leak_) then inStream(inlet.xi_outflow) else ClaRa.Basics.Functions.Stepsmoother(10,-10,pressureLoss.Delta_p)*inStream(inlet.xi_outflow) + ClaRa.Basics.Functions.Stepsmoother(-10,10,pressureLoss.Delta_p)*inlet.xi_outflow)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

protected
  inner Fundamentals.ICom    iCom(
    p_in=inlet.p,
    p_out=outlet.p,
    opening_leak_=opening_leak_,
    rho_in(start=1)=if noEvent((checkValve == true and opening_leak_ <= 0) or opening_ <
        opening_leak_) then fluidIn.d else (if useHomotopy then homotopy(
        ClaRa.Basics.Functions.Stepsmoother(
        10,
        -10,
        pressureLoss.Delta_p)*fluidIn.d + ClaRa.Basics.Functions.Stepsmoother(
        -10,
        10,
        pressureLoss.Delta_p)*fluidOut.d, fluidIn.d) else
        ClaRa.Basics.Functions.Stepsmoother(
        10,
        -10,
        pressureLoss.Delta_p)*fluidIn.d + ClaRa.Basics.Functions.Stepsmoother(
        -10,
        10,
        pressureLoss.Delta_p)*fluidOut.d),
        gamma_in(start=2)=(SM(fluidIn.VLE.h_v+1000,fluidIn.VLE.h_v,fluidIn.h)*fluidIn.cp+
                          SM(fluidIn.VLE.h_v,fluidIn.VLE.h_v+1000,fluidIn.h)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi(fluidIn.p, fluidIn.VLE.h_v, fluidIn.xi, fluidIn.vleFluidPointer))/
                          (SM(fluidIn.VLE.h_v+1000,fluidIn.VLE.h_v,fluidIn.h)*fluidIn.cv+
                          SM(fluidIn.VLE.h_v,fluidIn.VLE.h_v+1000,fluidIn.h)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsochoricHeatCapacity_phxi(fluidIn.p, fluidIn.VLE.h_v, fluidIn.xi, fluidIn.vleFluidPointer)),
    gamma_out(start=2)=(SM(fluidOut.VLE.h_v+1000,fluidOut.VLE.h_v,fluidOut.h)*fluidOut.cp+
                          SM(fluidOut.VLE.h_v,fluidOut.VLE.h_v+1000,fluidOut.h)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsobaricHeatCapacity_phxi(fluidOut.p, fluidOut.VLE.h_v, fluidOut.xi, fluidOut.vleFluidPointer))/
                          (SM(fluidOut.VLE.h_v+1000,fluidOut.VLE.h_v,fluidOut.h)*fluidOut.cv+
                          SM(fluidOut.VLE.h_v,fluidOut.VLE.h_v+1000,fluidOut.h)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.specificIsochoricHeatCapacity_phxi(fluidOut.p, fluidOut.VLE.h_v, fluidOut.xi, fluidOut.vleFluidPointer)),
    opening_=opening_,
    h_in=fluidIn.h,
    p_crit=fluidIn.crit.p,
    p_vap_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.bubblePressure_Txi(max(fluidIn.T,fluidOut.T),fluidIn.xi, fluidIn.vleFluidPointer)) "mind that: gamma is kept constant at dew line value for h<h_dew, also for supercritical region"
    annotation (Placement(transformation(extent={{-60,-52},{-40,-32}})));

public
  Basics.Interfaces.EyeOut eye if showData
    annotation (Placement(transformation(extent={{90,-68},{110,-48}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
protected
  Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{45,-59},{47,-57}})));

equation
  if (not openingInputIsActive) then
    opening_ = noEvent(min(1,max(opening_leak_,opening_const_)));

  end if;

  if useStabilisedMassFlow then
    der(m_flow_)= (pressureLoss.m_flow - m_flow_)/Tau;
  else
     m_flow_= pressureLoss.m_flow;
  end if;

//_________________Energy balance___________________________________
// Isenthalpic state transformation (no storage and no loss of energy)
  inlet.h_outflow = inStream(outlet.h_outflow);
  outlet.h_outflow = inStream(inlet.h_outflow);

//_______________Mass balance (no storage)__________________________
  inlet.m_flow + outlet.m_flow = 0;
  //inlet.m_flow = pressureLoss.m_flow;
  inlet.m_flow = m_flow_;

//______________ No chemical reaction taking place:_________________
  inlet.xi_outflow = inStream(outlet.xi_outflow);
  outlet.xi_outflow = inStream(inlet.xi_outflow);

//______________Eye port variable definition________________________
  eye_int[1].m_flow = -outlet.m_flow;
  eye_int[1].T = fluidOut.T-273.15;
  eye_int[1].s = fluidOut.s/1e3;
  eye_int[1].p = outlet.p/1e5;
  eye_int[1].h = fluidOut.h/1e3;

  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-58},{46,-58}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

initial equation
  if useStabilisedMassFlow then
    m_flow_=pressureLoss.m_flow;
  end if;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,60}},
        grid={2,2}), graphics={Bitmap(
          extent={{-100,-50},{100,70}},
          imageSource="iVBORw0KGgoAAAANSUhEUgAAAjAAAAFQCAIAAAAuj9P/AAAABmJLR0QA/wD/AP+gvaeTAAAXw0lEQVR4nO3de1RWdb7H8Qe8lHlLZzIrz6TTnay01NKWROKdFEXAK15Ss2w6uWbmuGY8qzrTZWqt1mGtdNS8IAoICIiAko5L8zJr6pSVZWlqmabOeEu8gIKCcP7YLcZBhOfy2/v33b/9fv3Z0H5+/eHzmQd+vA2rqanxASIlz52fPG+B7lMY5bcvzfztf76o+xRA/cJ1HwAAAJ+PQQIACMEgAQBEYJAAACIwSAAAERgkAIAIDBIAQAQGCQAgAoMEABCBQQIAiMAgAQBEYJAAACIwSAAAERgkAIAIDBIAQAQGCQAgAoMEABCBQQIAiMAgAQBEYJAAACIwSAAAEZrqPgBwXS1btmzdqrXuU/gull+8cuVKiA9p0qTJTS1uUnKeULRs2VL3EYDrCqupqdF9BkC0uLFJn372RYgP6dXj0fysdCXnAUzFt+wAACIwSAAAERgkAIAIDBIAQAQGCQAgAoMEABCBQQIAiMAgAQBEYJAAACIwSAAAERgkAIAIDBIAQAQGCQAgAoMEABCBQQIAiMAgAQBEYJAAACIwSAAAERgkAIAIDBIAQAQGCQAgAoMEABCBQQIAiMAgAQBEYJAAACIwSAAAERgkAIAIDBIAQAQGCQAgAoMEABCBQQIAiBCekZ1z6dIl3ccAAHhXRUVFRnZO+B9e+VO3JyJffePt4ydO6D4SAMBbjp848eobb3fv/dQfXvlTU5/PV1pWtiwtIz1r1fCYIS/OmHbv3XfpPiEAwHD7vz8wf9HSouL1lZWV1j9pWvu/VVZWri4oWlO0rt9TfadOTurbp7emQwIATPa3jz5OWZ6+eev2mpqaq/950zpfV11dvWnLtk1btj3c9cFnJ44fOfyZJk2aOHhOAICZrly5sqZo3bK0lbu+2V3vF1z3lt2ub3bPmj0ncmBMyor0iooK204IADBceXlFyor0vgOGzpo953pr5Lv2E1IdPx4+8tqb78xdsHjS+DFTJo5vd/PNqs8JADDWmbNnU9NWrliZfbqkpNEvbmSQLKdLSpLnLViyPD1pbOLUSRNu7dAh5EMCAEx24uTJlBUZ6Vk5paWlfv4rAfxibGlp6YLFKT37Rk9+bubOr3YFdUIAgOF2frVr8nMze/aNXrA4xf818vn5Celqtbceej7WfeZz0/o//VRYWFigDwEAGKampmbTlm0LFi/d8fnO4J4Q8CDV2vH5zikzXnzg/ntnPDt5xLCYpk2DfxQAwL2qqqoK1hYvWrb82737Q3lOqC27b/funzV7Ts/I6OS588+fD+CjGQDA7c6fL02eO79nZPSs2XNCXCNfKJ+Qrnbq1E/J8xYsSU1LiBvxwvRnb+t4q5LHAgBkOnb8xMIly3LzC0rLylQ9U+X32UgQAYDxrk3+qKL+Bz9Wgii/cG10VCQJIgAwxvWSP6rYdRPBum6xacu2hx6MmDppAgkiAHApK/mTsiLj6917bH0h2/+Cvq9375k1e07fAUNTVqSXl5MgAgDXuDr5Y/ca+Rz7G2MPHzn62pvvRA4cuihlucKfgAEA7FBaVrYoZXnkwKGvvfnO4SNHnXlRR3956NjxE2+88+7/vveXkbHPzHh28q+7dHby1QEAjfrh4KFFy5avKVx3sbzc4ZfW8NusF8vLV2bnZuWs7vdU35dffL77Iw87fwYAQB07v9r13vz3P9z2t+rqai0H0JZXIEEEABKEnvxRRX/vhwQRAGihKvmjikOXGhpFgggAHKM2+aOKrI8jJIgAwFZ2JH9UkTVIFhJEAKCcfckfVSQOkoUEEQAoYXfyRxW5g2QhQQQAwXEs+aOKlEsNjbISRINi4/PWFFZVVek+DgDIVVVVlbemcFBsvDPJH1VcM0iWvfv2z5o957Enn06eO//M2bO6jwMAspw5ezZ57vzHnnx61uw5e/dJuT7nJ+nfsqvX6ZKS5HkL3l+aSoIIACwakz+quHKQLCSIAMAnIPmjiosHyUKCCIA3yUn+qOL6QapFggiAR0hL/qjisksNjSJBBMBgMpM/qpj5MYIEEQDDSE7+qKLgE9LggdHdu0m8UGAliJ4aGPPK628dPurQ33gIAGodPnL0ldffihw4dFlahsw1erTbI0MG9g/9OQo+IT30QMSc3w8++o9/ri5cu/aDDZcvXw79mQpdLC9PTc9cnpFFggiAuwhP/jRv3nzY0MGjYod1uuP2tcUb1m/cFOIDlX3LrtMdt788c0bS2NGF64rzCopKS2XNOAkiAG4hP/nTunWr+BHDY5+Jad/uZoWPVfwzpPbtbp6SNH50fNwHGzZm5+WfPPWT2ueHzkoQJc9bMHXShHGJCS1a3Kj7RADws/Lyisyc3JQVGYePCP0pQ4dbfjkmPm7o4IE3tWih/OG2XGq4qUWL+JGxI4bFbN6yLTN39cFDP9rxKqE4fOToa2++M3fB4knjx0yZOL7dzSpHHgACdebs2dS0lStWZp8uKdF9lvp16XznuIRR/ftF2fftJRtv2TVt2nTQgOhBA6J3fbMnc1XOR5/ssO+1gkOCCIB28pM/fR7vOW504sNdI+x+ISeufT/cNeLhrv/z3fcHcvILNn249YqwuAUJIgBaCE/+NAkP798vKjFuxD1O/S2pzv0e0j133/Xfs383ZeL43PzC4g1/rai45NhL+4MEEQBnyE/+3HjjDTGDByXExd7esaOTr+v0L8be3rHjyzNnTJ4wtnj9xtw1hQK/W0qCCIBN5Cd/ftG+fcLI2JghA9u2aeP8q+t5t23bps240fEJcbEfbt2enpUj8LdWrQTRW+8mJ41JnDZ5Yps2rXWfCICLnT9funR5Wnp2zil5d48tv+rUKWlsYr+oyGbNmuk6g87/+9+sWbNBA6IHRD/98aefZWSt2v3tXo2HqRcJIgAhkp/8eTDigQljEnv36hEerrluqv/7UeHh4U8+0evJJ3pZl/E+/vQzab+TbCWI0rNWDY8Z8uKMafc69fM9AK62//sD8xctLSpeX1lZqfss9QgLC+vdq4cz1+f8pH+QalmX8cQmiCorK1cXFOUXriVBBKBhLkr+6D7LvxE0SBYSRABcyrPJH1XEDZKFBBEAF/F48kcVoYNkIUEEQDiSPwqJHiQLCSIAApH8Uc4Fg1SLBBEACUj+2MRNg2QhQQRAC5I/dnPfIFlIEAFwDMkfZ7j7XZIEEQBbkfxxkrsHyUKCCIByJH+cZ8IgWUgQAVCC5I8u5gxSLRJEAIJD8kcvAwfJQoIIgJ9I/ghh7CBZSBABaADJH1EMHyQLCSIAdZD8EcgTg2QhQQTAR/JHMA8NUi0SRIA3kfwRzouDZCFBBHgEyR+38O4gWUgQAQYj+eMuvLv5fCSIAOOQ/HEjBulfSBABBiD5414MUl0kiACXIvnjdgzSdZEgAtyC5I8ZGKRGkCACxCL5YxgGyS8kiABRSP4YiUEKAAkiQDuSPwZjkAJGggjQguSP8Rik4JEgApxB8scjGKRQkSACbELyx2sYJDVIEAEKkfzxJt6VVCJBBISI5I+XMUjqkSACgkDyBwySXUgQAX4i+QMLg2Q7EkTA9ZD8wdUYJIeQIAJqkfxBvRgkR5EggseR/EEDGCQNSBDBg0j+oFEMkjYkiOARJH/gJwZJPxJEMBXJHwSEQZKCBBGMQfIHwWGQZCFBBFcj+YNQ8G4iEQkiuA7JH4SOQZKLBBFcgeQPVGGQpCNBBLFI/kAtBsk1SBBBDpI/sAOD5DIkiKARyR/YikFyJRJEcBjJHziAQXIxEkRwAMkfOIZBcj0SRLAJyR84jEEyBwkiqELyB1owSKYhQYSgkfyBXgySmUgQISAkfyAB7wImI0GERpH8gRwMkvlIEKFeJH8gDYPkFSSIUIvkD2RikDyHBJGXkfyBZAySR5Eg8hSSP3AFBsnTSBAZj+QPXIRBAgkiM5H8geswSPgZCSJjkPyBSzFIqIsEkXuR/IGrMUioHwkiFyH5AzMwSGgICSLhSP7AJN7604vgkCASiOQPzMMgwV8kiIQg+QNTMUgIDAkijUj+wGwMEoJEgshJJH/gBQwSQkKCyFYkf+ApDBIUIEGkHMkfeBCDBGVIEClB8geexSBBMRJEQSP5A49jkGAXEkT+I/kD+Bgk2I0EUQNI/gBXY5DgBBJEdZD8Aa7FIME5JIh8JH+A62OQ4DTXJYhUPZbkD9AwBgl6uChB1FbF56QfDh7q028QyR+gAQwSNJOfIPrptIKfeCl5iHIkfyAKgwQRhCeIzEPyBwIxSBBEfoLIACR/IBaDBHHkJ4hciuQPhGOQIJSVIBoQ/fT2v3+clZP37T6hv6/jChH33zc2cVTfPr25PgfJGCSIFh4eHtX3yai+T4pNEElG8gfuwiDBHYQniKQh+QM3YpDgJvITRNqR/IF7MUhwH/kJIi1I/sDtGCS4lfwEkWNI/sAMDBLcTX6CyD4kf2AYBgmGEJ4gUovkD4zEIMEoxieISP7AYAwSDGRkgojkD4zHIMFYxiSISP7AIxgkGM5KEA0aEG3devjokx26TxSAPo/35M4CvINBgldYtx6++vqbrJw84ZfxrOtzYxPjH3moq+6zAM7htxbgITU1NWUXLpaWXZC8Rj6fr6amprTsQtmFi8LPCajFJyR4wpUrVzZ9uDV7df6BHw7pPotfvt6954+v/umuX3ceMyqOnx7BIxgkGK6s7ELumoLC4vUlJWd0nyVgB3449Na7yQtTUmNjhiSMHNGqVUvdJwJsxCDBWKd+Op2Zk7dh46YLFy/qPktISkrOpKZn5qwuGDyw/7jE+Ft++QvdJwJswSDBQId+PLxyVe7mrdurqqp0n0WZCxcvri4oKlz3QXRU5PjRCZ3v/JXuEwGKMUgwymc7v8zLLxB+iS4UVVVVf9304cbNW3r36hEfN6JH9266TwQowyDBBNadhdyCov3ffa/7LE6oqan56JMdH32y49577k4YMZxbDzADgwR3q6i4tG79htyComPHjus+iwb7v/v+rXeTl2VkJowY/syQwTfeeIPuEwHBY5DgVufPn19duHZNUfHZc+d0n0WzY8eOz124OC1z1cjhMaNih7Xh74qFOzFIcJ8jR/+RvTp/0+at5RUVus8iyNlz51LTM7Nz8/tHR40ZFfcfne7QfSIgMAwS3GTP3n1pK7P+b8fn1dXVus8iVHlFxdriDcXrNz7R87GJ48dG3H+f7hMB/mKQ4ALWz/AzV+V+vXuP7rO4Q3V1tXXr4aEHI8aNTujzeM+wsDDdhwIawSBBtOrq6u1//zgrJ+/bfft1n6V+rVu3Thqb6KvxpWfnlJaW6j5OXVaCKOL++8Ymjurbp3d4OPlKyMUgQSj5yZ+7unR56YXpw2OGNG/e3Ofz/X7Wb4qK189buOTAwYO6j1bXnr37Xnn9z+3btyNBBMkYJIgjP/nzWPduv3l+enRU5NUfOJo3bx4/MjYudtjmrdvnLVz8xZdfaTxhvUgQQTgGCYIIT/6EhYVFR0XOfG5arx6PXu9rwsPDB/SLGtAv6tPPvliweOnmrdulNSNIEEEsBgkiCE/+3HDDDeNHJ0xJGtel851+/iu9ejzaq8eCg4d+TE3PXLkq99KlS7aeMFAkiCAQgwSd5Cd/2rZtM3XihKRxY4L7BleXzne+/sofX3rhufTM7JS0jHPnzis/YShIEEGUsDvujgjxEf/18kvDYgYrOQ28Q37y5/bbOs6YOnl0fFyrlmquAJRduLAqL39RyvJ/Sv1Pvu22jiSIEJy1xRvefW9eiA/hExKcJj/5c9+997wwbcqIYTFNm6r8A9KqZcupk5ImjhtTuO6DhUtT9+3/TuHDlSBBBL0YJDhHfvKn/9NPNXxnIXTNmjWLHxkbPzLWuvWwacs2+14rOCSIoAuDBCcIT/40bdIkdljM9CkTu0Y84NiLWrcevtnz7ZLUtMK1xVVXrjj20v4gQQTnMUiwkfzkT4sWN45NiJ82JelXnTppOUDXiAfee/ft37384tLU9KzcvPJyWZ8dSRDBSVxqgC2s63PZq/MP/HBI91nq1+GWW6ZNThqTENe+XTvdZ/lZyZkz2bn5S5ennzx1SvdZ6nfXrzuPGRXHZTxcS8mlBgYJirku+SPN5cuXxSaILCSIcC1u2UEWlyZ/pCFBBM9ikKCAAckfaUgQwYMYJITEvOSPNCSI4B0MEoJhfPJHGhJE8AIuNSAwHkz+SEOCCAJxqQGO8mzyRxoSRDCVyX9uoQrJH4FIEME8DBIaQvJHPhJEMAaDhHqQ/HEdEkQwAJca8G9I/hiABBGcRzoIKpH8MQwJIjiJW3ZQg+SPkUgQwXUYJE8j+WM8EkRwEQbJo0j+eA0JIsjHIHkLyR+PI0EEybjU4BUkf1AHCSIoxKUG+IXkD+pFggjS8OffZCR/0CgSRJCDQTITyR8EigQRtGOQjELyByEiQQSNuNRgCJI/UI4EEfxHOgg+H8kf2IwEEfzBLTuvI/kDB5AggmMYJFci+QOHkSCCAxgklyH5A71IEME+DJI7kPyBKCSIYAcuNUhH8gfCkSCCj0sNxiP5A1cgQQRVeB+RiOQPXIcEEULHIMlC8gduR4IIQWOQRCD5A8OQIEIQuNSgGckfGI8EkReQDnI3kj/wFBJEZuOWnVuR/IEHkSBCoxgkRx368ceVq/JI/sCzSBChAQySQ0j+AFcjQYRrMUj2IvkDNIAEEa7GpQa7kPwBAkKCyNW41CAUyR8gCCSIwPuRSiR/gBCRIPIyBkkNkj+AWiSIPIhBCgnJH8BWJIg8hUsNQSL5AziMBJFkpIP0IPkDaESCSCZu2TmN5A+gHQkigzFIfiH5A4hCgshIDFIjSP4AkpEgMgmDVD+SP4CLkCAyA5ca6iL5A7gaCSItuNSgGMkfwAAkiNyL9zWfj+QPYBwSRG7k9UEi+QOYjQSRi3h0kEj+AJ5CgsgVPHepgeQP4HEkiOxAOigwJH8A1CJBpBa37PxF8gdAHSSIBDJ8kEj+AGgACSJRjB0kkj8A/EeCSALTBonkD4CgkSDSy5xLDSR/AChEgiggXGr4GckfAMqRIHKeu98fSf4AsBUJIie5dZBI/gBwEgkiB7hskEj+ANCIBJGtXHOpgeQPAFFIEF3NK+kgkj8AxCJBZDH/lh3JHwDCkSBSSOggkfwB4CIkiJQQN0gkfwC4FwmiUEgZJJI/AIxBgig4+i81kPwBYDCPJIhcf6mB5A8A45Eg8p+e91mSPwA8hQSRP5weJJI/ALyMBFEDHBokkj8AUIsEUb1sv9RA8gcAGmBGgkh6OojkDwD4ye0JIrm37Ej+AEBASBD5lA8SyR8ACJrHE0TKBonkDwCo4s0EkYKfIQ0eGH3i5KmdX+5SciDlbmrRYnT8yOnPTuL6HAA3Onzk6JLUFdl5+dIu49V6tNsjt3a4Zf3GTSE+R8EgiUXyB4Ax5CeIQmfmIJH8AWCkyspKsQmi0Jk2SCR/AHiB2ARRKAwZJJI/ADxIbIIoOK4fJJI/ADzu8NGjMhNEgXLxIJH8AYBa8hNEjXLlIJH8AYB6yU8QNcBlg3T/ffc+P3Uy1+cAoAFVVVUFa4vfT1m+d99+3WcJgDsGieQPAARBbIKoXtIHieQPAIRIbIKoDrmD1LZtm6kTJySNG2NHUxYAvObUT6fTM7NT0jLOnTuv+yz1kzhIJH8AwCaSE0SyBonkDwA4QGaCSMogkfwBAOeJShBpHiSSPwCgnZAEkbZBIvkDAKJoTxBpGCSSPwAglsYEkaODdFvHW6dNnjhudHzrVq0ce1EAQKBKy8oyV+UtXZ527PgJx17UoUF6rHu33zw/PToqMjw83IGXAwCErrq6evPW7fMWLv7iy68ceDl7B4nkDwAYwJkEkV2DRPIHAAxjd4JI/SCR/AEAg9mXIFI5SCR/AMAj7EgQqRkkkj8A4EFqE0ShDhLJHwCAkgRRkINE8gcAUEeICaKAB4nkDwCgAUEniAIYpNatWyeNTZw6acKtHToEfkIAgIecOHkyZUVGelZOaWmpn/+KX4N0V5cuL70wfXjMkObNm4d2QgCAh1y+fLmoeP28hUsOHDzY6Bc3MkgkfwAAIbISRH95f8nnO79s4MvqHySSPwAA5RpOENUdJJI/AABbXS9B9K9BIvkDAHDMtQmisDvujiD5AwDQ4uoE0f8DV3Kt4fw6Wq8AAAAASUVORK5CYII=",
          fileName="modelica://ClaRa/Resources/Images/Components/Valve.png", visible = not openingInputIsActive), Bitmap(
          extent={{-100,-50},{100,70}},
          imageSource="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",
          fileName="modelica://ClaRa/Resources/Images/Components/ValveControllable.png",
          visible=openingInputIsActive),
        Line(
          points={{-100,46},{98,-46}},
          color={150,25,48},
          smooth=Smooth.None,
          thickness=0.5, visible=checkValve),
        Ellipse(
          extent={{-104,52},{-92,40}},
          lineColor={150,25,48},
          lineThickness=0.5,
          fillColor={150,25,48},
          fillPattern=FillPattern.Solid, visible=checkValve)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-50},{100,70}},
        grid={2,2}), graphics),
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end GenericValveVLE_L1;
