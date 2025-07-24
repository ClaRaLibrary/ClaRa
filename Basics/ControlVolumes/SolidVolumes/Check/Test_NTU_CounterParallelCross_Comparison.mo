within ClaRa.Basics.ControlVolumes.SolidVolumes.Check;
model Test_NTU_CounterParallelCross_Comparison "Comparison of NTU counter cross and parallel flow models"

//extends ClaRa.Basics.Icons.PackageIcons.ExecutableExampleb80;

  extends ClaRa.Visualisation.Check.TestHEXdisplay;
  annotation (experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-007,
      __Dymola_Algorithm="Dassl"));
end Test_NTU_CounterParallelCross_Comparison;
