within ClaRa.Basics.Icons;
model Tpipe2
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.0                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under the 3-clause BSD License.   //
// Copyright  2013-2021, DYNCAP/DYNSTART research team.                      //
//___________________________________________________________________________//
// DYNCAP and DYNSTART are research projects supported by the German Federal //
// Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
// The research team consists of the following project partners:             //
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
// TLK-Thermo GmbH (Braunschweig, Germany),                                  //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Bitmap(
          extent={{-100,-100},{100,40}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/Resources/Images/Components/Junction2.png")}));

end Tpipe2;
