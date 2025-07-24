within ClaRa.Components.TurboMachines.Pumps.Fundamentals;
model Outline
 extends ClaRa.Basics.Icons.RecordIcon;
  input Basics.Units.VolumeFlowRate V_flow "Volume flow rate";
  input Basics.Units.PressureDifference Delta_p "Pressure difference";
  input Basics.Units.Length head "Head";
  input Basics.Units.Length NPSHa "Net positive suction head available";
 input Real eta_hyd "Hydraulic efficiency";
 input Real eta_mech "Mechanic efficiency";
  input Basics.Units.Power P_fluid "Hydraulic power";
end Outline;
