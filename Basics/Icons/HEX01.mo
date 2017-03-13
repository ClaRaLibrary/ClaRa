within ClaRa.Basics.Icons;
model HEX01
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2016, DYNCAP/DYNSTART research team.                     //
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
          extent={{-100,-100},{100,100}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/figures/Components/HeatExchanger.png")}));

end HEX01;
