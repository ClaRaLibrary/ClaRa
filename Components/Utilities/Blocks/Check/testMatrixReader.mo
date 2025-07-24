within ClaRa.Components.Utilities.Blocks.Check;
model testMatrixReader "Two ways how to read a matrix from file"
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

//   import DataFiles;
  parameter Real  A[:,:]=readMATRIX.M;
  extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb50;

  ClaRa.Components.Utilities.Blocks.ReadMatrixFromFile readMATRIX(
    fileName="modelica://ClaRa/Resources/TableBase/exampleTable.mat", matrixName="ABCD")
    annotation (Placement(transformation(extent={{-24,-16},{-4,4}})));
equation

  annotation (experiment(StopTime=1));
end testMatrixReader;
