within ClaRa.Basics.Icons;
record RecordIconGraph
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={29,112,183},
          fillColor={30,54,100},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,60},{-60,-60}}, color={29,112,183}),
        Line(points={{-100,20},{100,20}}, color={29,112,183}),
        Line(points={{-100,-20},{100,-20}}, color={29,112,183}),
        Line(points={{-20,60},{-20,-60}}, color={29,112,183}),
        Line(points={{20,60},{20,-60}}, color={29,112,183}),
        Line(points={{60,60},{60,-60}}, color={29,112,183}),
        Line(points={{-100,0},{-40,26},{-6,-8},{74,-10},{100,-24}}, color={204,79,70})}),
                                                               Diagram(graphics,
                                                                       coordinateSystem(preserveAspectRatio=false)));
end RecordIconGraph;
