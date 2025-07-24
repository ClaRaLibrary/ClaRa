within ClaRa.Basics.ControlVolumes.Fundamentals.Check;
model Test_SmoothedDeltaTmean_log
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

  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;

  Real DT_wo=T_w - T_o.y;
  Real DT_wi= T_w -  T_i.y;
  Real T_w=200;
  Real T_i1= T_i.y;

  Real DTU=max(DT_wi, DT_wo);
  Real DTL=min(DT_wi, DT_wo);

  Real DT_mean_unsmooth "Logarithmic mean";
  Real DT_mean_smooth "Logarithmic mean - smoothed";
  Modelica.Blocks.Sources.Trapezoid T_o(
    rising=1,
    falling=1,
    startTime=5,
    nperiod=1,
    offset=150,
    amplitude=+100,
    period=20,
    width=5) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.TimeTable
                               T_i(offset=0, table=[0,100; 7,100; 8,300; 14,300; 15,200; 20,200])
                annotation (Placement(transformation(extent={{-2,-18},{18,2}})));
equation

//   DT_mean = ClaRa.Basics.Functions.Stepsmoother(
//     100,
//     -100,
//     DT_wi*DT_wo)*noEvent(if abs(DT_wo) <= 1e-6 or abs(DT_wi) <= 1e-6 then 0 elseif (T_w < T_o.y and T_w > T_i1) or (T_w > T_o.y and T_w < T_i1) then 0 elseif abs(DT_wo - DT_wi) <= eps then DT_wi else (DTU - DTL)/log(DTU/DTL));

//     DT_mean_unsmooth = noEvent(if floor(abs(DT_wo)*1/eps) <= 1 or floor(abs(DT_wi)*1/eps) <= 1 then
//                                  0
//                                elseif (T_w < T_o.y and T_w > T_i.y) or (T_w > T_o.y and T_w < T_i.y) then
//                                  0
//                                elseif floor(abs(DT_wo - DT_wi)*1/eps) < 1 then
//                                  DTL
//                                else
//                                  (DTU - DTL)/log(DTU/(DTL+1e-6)));
    DT_mean_unsmooth = noEvent(
                             if floor(abs(DTU)*1/eps) <= 1 or floor(abs(DTL)*1/eps) <= 1 then
                               0
                             elseif (T_w < T_o.y and T_w > T_i.y) or (T_w > T_o.y and T_w < T_i.y) then
                               0
                             elseif floor(abs(DTU - DTL)*1/eps) < 1 then
                               DTL
                             else
                               (DTU - DTL)/log(DTU/(DTL)));

    DT_mean_smooth = SM(0.1,eps, abs(DTL))*SM(0.01,eps, DTU*DTL) * SZT((DTU - DTL)/log(abs(DTU)/(abs(DTL)+1e-9)), DT_wi, ((DTU)-(DTL))-0.01, 0.001);
                     //SM(0.1,eps, abs(DTL))*SM(0.01,eps, DTU*DTL) * SZT((DTU - DTL)/log(abs(DTU)/(abs(DTL)+1e-9)), DT_wi, (abs(DTU)-abs(DTL))-0.01, 0.001)

     annotation (experiment(StopTime=20), Diagram(graphics={Text(
          extent={{-98,88},{92,56}},
          lineColor={115,150,0},
          textString="IDEA: illustrate the behaviour of the logaritmic mean calculation options available in L2 heat transfer models",
          horizontalAlignment=TextAlignment.Left)}));
end Test_SmoothedDeltaTmean_log;
