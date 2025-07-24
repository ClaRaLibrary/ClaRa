within ClaRa.Basics;
package Media "Media data (properties of air, water, steam, ...)"
//__________________________________________________________________________//
// Package of the ClaRa library, version: 1.9.0                             //
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


  extends ClaRa.Basics.Icons.PackageIcons.Basics80;






annotation (Documentation(info="<html>
<p><h2><font color=\"#008000\">AP 2.6 Implementierung der bentigten Stoffdaten</font></h2></p>
<p>Ziel dieses Arbeitspaketes ist die Implementierung der f&uuml;r die Simulation aller anderen Kom-ponenten ben&ouml;tigten Stoffdaten in die zu erstellende ClaRa-Modelica-Bibliothek. Dabei geht es insbesondere darum, die relevanten physikalischen Effekte f&uuml;r den jeweiligen Teilbe-reich der Gesamtmodelle mit hinreichender Genauigkeit abzubilden. Gleichzeitig ist es not-wendig, einen transparenten und schnell rechnenden Programmecode zu erzeugen.</p>
<p>Zur Simulation des konventionellen Kraftwerksprozesses wird beispielsweise die genaue Abbildung der Stoffdaten von Wasser ben&ouml;tigt, um eine hinreichende Genauigkeit der Simu-lationsergebnisse f&uuml;r den Wasser-Dampfkreislauf zu gew&auml;hrleisten. Diese Stoffdaten sind zwar grunds&auml;tzlich vorhanden, m&uuml;ssen aber ggf. noch bzgl. Rechengeschwindigkeit optimiert und in die ClaRa-Modelica-Bibliothek eingebunden werden. In anderen Bereichen, wie der CO2-Rauchgasw&auml;sche, der Rauchgasseite des Kraftwerks oder der CO2-Aufreinigung werden neue Stoffdatenmodelle ben&ouml;tigt. Die Vielzahl vorhandener Modellen f&uuml;r die Berechnung von Stoffdaten macht die Auswahl eines ad&auml;quaten Ansatzes schwierig. Hierbei kann die Validierung der Modellergebnisse durch Literaturquellen unterst&uuml;tzt werden.</p>
</html>"));
end Media;
