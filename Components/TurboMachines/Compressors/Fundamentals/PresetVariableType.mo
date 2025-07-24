within ClaRa.Components.TurboMachines.Compressors.Fundamentals;
type PresetVariableType
  extends String;
  annotation(choices(
    choice="dp" "dp",
    choice="m_flow" "m_flow",
    choice="V_flow" "V_flow",
    choice="P_shaft" "P_shaft"));
end PresetVariableType;
