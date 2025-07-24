within ClaRa.Basics.Icons;
model Pipe_L4
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.9.0                            //
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -50},{140,50}}),
                   graphics={Bitmap(
          extent={{-140,-40},{140,40}},
          imageSource=
              "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",
          fileName="modelica://ClaRa/Resources/Images/Components/Pipe_L4.png")}),
      Diagram(graphics,
              coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{
            140,50}})));

end Pipe_L4;
