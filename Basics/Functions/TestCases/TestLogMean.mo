within ClaRa.Basics.Functions.TestCases;
model TestLogMean
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
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;
  import Modelica.Constants.eps;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
//\\___________________Case1: |T_out=T_w| or |T_in=T_w| -> DT_wo=0 or DT_wi=0 -> devision by zero ----> solved!___________________//\\

//    Real T_w = 300+rampT_w.y;
//    Real T_in = 100;
//    Real T_out= 200+rampT_out.y;

//\\___________________Case2: |T_out=T_in=T_w|  -->  DT_wo=0 and DT_wi=0 -> devision by zero ----> solved!___________________//\\

//   Real T_w = 300+rampT_w.y;
//   Real T_in = 100+rampT_in.y;
//   Real T_out= 200+rampT_out.y;

//\\___________________Case3: |T_in>T_w and T_out<T_w| or |T_in<T_w and T_out>T_w|    --> negative argument of log()   ---->  solved!___________________//\\

//      Real T_w = 200;
//      Real T_in = 100+rampT_in.y;
//      Real T_out= 150+rampT_out2.y;

//\\___________________Case4: |T_w-T_in = T_w-T_out| --> DT_wi=DT_wo --> log(1)=0 --> 0/0   ---->    solved!!!!!___________________//\\

    Real T_w = 200;
    Real T_in = 100+rampT_in.y;
    Real T_out= 150+rampT_out2.y;

  Real DT_wi = T_w-T_in;
  Real DT_wo = T_w-T_out;
   Real DT_mean1, DT_mean2, DT_mean3, DT_mean4, DT_mean5;
//   Real  DT_mean3;
  Real DTU=max(DT_wi,DT_wo);
  Real DTL=min(DT_wi,DT_wo);
//  Real DTU=max(abs(DT_wi),abs(DT_wo));
//  Real DTL=min(abs(DT_wi),abs(DT_wo));
  constant Real ep=1e-6;
//   Real A1 = SM(ep,0,abs(DTL));
//   Real A2 = SM(ep,0,abs(DTU));

  Real A12 = SM(ep,0,abs(DTL))*SM(ep,0,abs(DTU));
  Real A3 =  SM(ep,0, DTU*DTL);
  Real A41 = SM(0,ep/2, DTU*DTL)*SM(ep,-ep,abs(abs(DT_wi)-abs(DT_wo)));

  Modelica.Blocks.Sources.Ramp rampT_w(
    startTime=1,
    duration=1,
    offset=0,
    height=0)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Ramp rampT_out(
    offset=0,
    duration=2,
    height=100,
    startTime=2)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.TimeTable
                               rampT_in(
    offset=0, table=[0,0; 5,0; 6,200; 25,200; 26,-100; 30,-100])
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.TimeTable
                               rampT_out2(table=[0,0; 10,0; 11,100; 20,100; 21,
        0; 22,0])
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation

//Case 1 --> solved!
//DT_mean=  noEvent(if floor(abs(DT_wo)*1/eps)<=1 or floor(abs(DT_wi)*1/eps)<=1 then 0 else (DTU-DTL)/log(DTU/DTL));

//DT_mean=  noEvent(if abs(DT_wo)<=1e-6 or abs(DT_wi)<=1e-6 then 0 else (DTU-DTL)/log(DTU/DTL));

//Case 2 --> solved with solution of Case 1
//DT_mean = noEvent(if floor(abs(DT_wo)*1/eps)<=1 or floor(abs(DT_wi)*1/eps)<=1 then 0 else (DTU-DTL)/log(DTU/DTL));

//Case 3 --> check it!
//DT_mean = noEvent(if floor(abs(DT_wo)*1/eps)<=1 or floor(abs(DT_wi)*1/eps)<=1 then 0 elseif (T_w<T_out and T_w>T_in) or (T_w>T_out and T_w<T_in) then 0  else (DTU-DTL)/log(DTU/DTL));

//Case 4 --> check it!
//DT_mean = noEvent(if floor(abs(DT_wo)*1/eps)<=1 or floor(abs(DT_wi)*1/eps)<=1 then 0 elseif (T_w<T_out and T_w>T_in) or (T_w>T_out and T_w<T_in) then 0 elseif abs(DT_wo-DT_wi)<=eps  then DT_wi  else (DTU-DTL)/log(DTU/DTL));
 DT_mean1 = noEvent(if abs(DT_wo)<=1e-6 or abs(DT_wi)<=1e-6 then 0
         elseif
               (T_w<T_out and T_w>T_in) or (T_w>T_out and T_w<T_in) then 0 elseif abs(DT_wo-DT_wi)<=eps  then DT_wi
         else  (DTU-DTL)/log(DTU/DTL));
 DT_mean2 = noEvent(if floor(abs(DT_wo)*1/eps)<=1 or floor(abs(DT_wi)*1/eps)<=1 then 0
                      elseif (T_w<T_out and T_w>T_in) or (T_w>T_out and T_w<T_in) then 0
                      elseif  floor(abs(DT_wo-DT_wi)*1/eps)<1 then DT_wi
                      else (DTU-DTL)/log(DTU/DTL));
// DT_mean3=sign(DT_wi)*A3*(abs(DTU)-abs(DTL))/log((A41*Modelica.Constants.e + (1-A41)*abs(DTU))/((1-A1)*1 + (A1)*abs(DTL)));
  DT_mean3=sign(DT_wi)*A3*(abs(DTU)-abs(DTL))/log((A41*Modelica.Constants.e + (1-A41)*abs(DTU))/((1-A12)*1 + (A12)*abs(DTL)));

  DT_mean4=SM(100,-100,(DT_wi)*(DT_wo))*(DT_wi+DT_wo)/2;
  //DT_mean4=A3*(DT_wi+DT_wo)/2;
  DT_mean5=T_w-(T_in+T_out)/2;

  annotation (
    experiment(
      StopTime=20,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput,
    Diagram(graphics));
end TestLogMean;
