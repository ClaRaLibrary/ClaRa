within ClaRa.Components.Furnace.Hopper;
model Hopper_L2 "Model for a hopper section of a combustion chamber"
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

  import ClaRa;
  extends ClaRa.Basics.Icons.Hopper;
  //inner parameter ClaRa.Basics.Units.Temperature SlagTemperature=900;
extends ClaRa.Components.Furnace.BaseClasses.HopperBase;

inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                              annotation(Dialog(tab="Initialisation"));

  Real sum_xi "Sum of inlet components";
  Real drhodt "Density derivative";

  ClaRa.Basics.Units.MassFraction xi_flueGas_in_del[flueGas.nc - 1] "Flue gas mixture composition";

  ClaRa.Basics.Units.MassFlowRate m_flow_in_del "Pseudo state for inlet mass flow";
  ClaRa.Basics.Units.MassFlowRate m_flow_out_del "Pseudo state for outlet mass flow";
  ClaRa.Basics.Units.Temperature T_bulk_del "Pseudo state for bulk temperature";
  ClaRa.Basics.Units.DensityMassSpecific rho_bulk_del "Pseudo state for bulk density";

  model Outline
  //  parameter Boolean showExpertSummary annotation(Dialog(hide));
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.Volume volume "Volume";
    input ClaRa.Basics.Units.Area A_cross "Cross sectional area";
    input ClaRa.Basics.Units.Area A_wall "Wall area";
    input ClaRa.Basics.Units.Length height "Height of volume";
    input ClaRa.Basics.Units.Mass mass "Mass inside volume";
    input ClaRa.Basics.Units.Temperature T_out "Outlet temperature";
    input ClaRa.Basics.Units.EnthalpyMassSpecific h_out "Flue gas enthalpy at outlet";
  end Outline;

  model Fuel
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate" annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
    input ClaRa.Basics.Units.HeatCapacityMassSpecific cp "Specific heat capacity" annotation (Dialog);
    input ClaRa.Basics.Units.EnthalpyMassSpecific LHV "Lower heating value" annotation (Dialog);

  end Fuel;

  model Slag
    extends ClaRa.Basics.Icons.RecordIcon;
    input ClaRa.Basics.Units.MassFlowRate m_flow "Mass flow rate" annotation (Dialog);
    input ClaRa.Basics.Units.Temperature T "Temperature" annotation (Dialog);
    input ClaRa.Basics.Units.Pressure p "Pressure" annotation (Dialog);
  end Slag;

  model Flow
    extends ClaRa.Basics.Icons.RecordIcon;
    ClaRa.Basics.Records.FlangeGas flueGas;
    Fuel fuel;
    Slag slag;
  end Flow;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    Flow inlet;
    Flow outlet;
  end Summary;

   Summary summary(
   outline(
    volume = geo.volume,
    A_cross = geo.width*geo.height,
    A_wall = geo.width*geo.length*2+geo.length*geo.height*2,
    height=geo.height,
    mass = mass,
    T_out = flueGasOutlet.T,
    h_out = flueGasOutlet.h),
    inlet(
      flueGas(mediumModel=flueGas,
        m_flow=inlet.flueGas.m_flow,
        T=noEvent(actualStream(inlet.flueGas.T_outflow)),
        p=inlet.flueGas.p,
        h=flueGasInlet.h,
        xi=noEvent(actualStream(inlet.flueGas.xi_outflow)),
        H_flow=flueGasInlet.h*inlet.flueGas.m_flow),
      fuel(
        m_flow=inlet.fuel.m_flow,
        T=noEvent(actualStream(inlet.fuel.T_outflow)),
        p=inlet.fuel.p,
        cp=fuelInlet.cp,
        LHV=fuelInlet.LHV),
      slag(
        m_flow=inlet.slag.m_flow,
        T=noEvent(actualStream(inlet.slag.T_outflow)),
        p=inlet.slag.p)),
    outlet(
      flueGas(mediumModel=flueGas,
        m_flow=-outlet.flueGas.m_flow,
        T=noEvent(actualStream(outlet.flueGas.T_outflow)),
        p=outlet.flueGas.p,
        h=h_flueGas_out,
        xi=noEvent(actualStream(outlet.flueGas.xi_outflow)),
        H_flow=-h_flueGas_out*outlet.flueGas.m_flow),
      fuel(
        m_flow=-outlet.fuel.m_flow,
        T=noEvent(actualStream(outlet.fuel.T_outflow)),
        p=outlet.fuel.p,
        cp=fuelOutlet.cp,
        LHV=fuelOutlet.LHV),
      slag(
        m_flow=outlet.slag.m_flow,
        T=noEvent(actualStream(outlet.slag.T_outflow)),
        p=outlet.slag.p))) annotation (Placement(transformation(extent={{274,-102},{300,-76}})));

//___________________/ Media Objects \_________
  TILMedia.Gas.Gas_ph bulk(
    p(start=p_start_flueGas_out) = outlet.flueGas.p,
    xi=xi_flueGas,
    gasType=flueGas,
    h=h_flueGas_out_del) annotation (Placement(transformation(extent={{-130,26},{-110,46}})));

//___________________/ iCom record \__________________
protected
  inner ClaRa.Basics.Records.IComGas_L2 iCom(
    m_flow_nom=m_flow_nom,
    T_bulk=flueGasOutlet.T,
    p_bulk=bulk.p,
    fluidPointer_in=flueGasInlet.gasPointer,
    fluidPointer_bulk=flueGasOutlet.gasPointer,
    fluidPointer_out=flueGasOutlet.gasPointer,
    mediumModel=flueGas,
    p_in=inlet.flueGas.p,
    T_in=T_bulk_del,
    m_flow_in=m_flow_in_del,
    V_flow_in=V_flow_flueGas_in,
    xi_in=xi_flueGas,
    p_out=outlet.flueGas.p,
    T_out=T_bulk_del,
    m_flow_out=m_flow_out_del,
    V_flow_out=V_flow_flueGas_out,
    xi_out=xi_flueGas,
    xi_nom=flueGas.xi_default,
    xi_bulk=bulk.xi,
    h_bulk=bulk.h,
    mass=mass) annotation (Placement(transformation(extent={{244,-102},{268,-76}})));

initial equation

h_flueGas_out = h_start;
xi_flueGas = xi_start_flueGas_out;

equation

   mass = geo.volume * bulk.d;


  //________________/ Mass balance - flue gas \______________________________________
  inlet.flueGas.m_flow + outlet.flueGas.m_flow  =  drhodt*geo.volume;

  der(xi_flueGas) =  1/mass * (inlet.flueGas.m_flow*(flueGasInlet.xi - xi_flueGas) + outlet.flueGas.m_flow*(flueGasOutlet.xi - xi_flueGas));
  drhodt = bulk.drhodh_pxi * der(bulk.h) + sum({bulk.drhodxi_ph[i] * der(bulk.xi[i]) for i in 1:flueGas.nc-1});

  //______________ / Mass balance - Slag \____________________________________________________________________________
  0 = inlet.slag.m_flow  + outlet.slag.m_flow;

  //______________/ Mass balance - Fuel \____________________________
  0 = outlet.fuel.m_flow + inlet.fuel.m_flow;

  //_______________/ Energy Balance for gas \__________________________
  der(h_flueGas_out) = (Q_flow_wall + Q_flow_top + Q_flow_bottom
                + inlet.flueGas.m_flow * (flueGasInlet.h - h_flueGas_out)
                + outlet.flueGas.m_flow * (flueGasOutlet.h - h_flueGas_out)
                + inlet.slag.m_flow * (inlet.slagType.cp * (noEvent(actualStream(inlet.slag.T_outflow)) - 298.15) - h_flueGas_out)
                + outlet.slag.m_flow * (inlet.slagType.cp * (noEvent(actualStream(outlet.slag.T_outflow))  - 298.15) - h_flueGas_out)
                + inlet.fuel.m_flow *(fuelInlet.cp * (inStream(inlet.fuel.T_outflow)  - 298.15) - h_flueGas_out)
                + outlet.fuel.m_flow * (fuelOutlet.cp * (outlet.fuel.T_outflow - 298.15) - h_flueGas_out))/mass;

  V_flow_flueGas_in = 0;
  V_flow_flueGas_out = 0;

  m_flow_in_del = inlet.flueGas.m_flow;
  m_flow_out_del = outlet.flueGas.m_flow;
  xi_flueGas_in_del = flueGasInlet.xi;
  T_bulk_del = bulk.T;
  rho_bulk_del = bulk.d;

  sum_xi = sum(flueGasOutlet.xi);

  xi_fuel = 0; // amount of fuel per flue gas mass

 //___________/ T_outflows \______________
  outlet.fuel.T_outflow = bulk.T;
  outlet.flueGas.T_outflow = bulk.T;
  heat_bottom.T = bulk.T;

  if slagTemperature_calculationType==1 then
    inlet.slag.T_outflow = T_slag;
    outlet.slag.T_outflow = T_slag;
  elseif slagTemperature_calculationType==2 then
    inlet.slag.T_outflow = flueGasOutlet.T;
    outlet.slag.T_outflow = flueGasOutlet.T;
  elseif slagTemperature_calculationType==3 then
    inlet.slag.T_outflow = (flueGasOutlet.T + flueGasInlet.T)/2;
    outlet.slag.T_outflow = (flueGasOutlet.T + flueGasInlet.T)/2;
  elseif slagTemperature_calculationType==4 then
    inlet.slag.T_outflow = flueGasInlet.T;
    outlet.slag.T_outflow = flueGasInlet.T;
  else
    inlet.slag.T_outflow = T_slag;
    outlet.slag.T_outflow = T_slag;
    assert(slagTemperature_calculationType==1 or slagTemperature_calculationType==2 or slagTemperature_calculationType==3 or slagTemperature_calculationType==4, "Invalid slag temperature calculation type");
  end if;

  inlet.flueGas.xi_outflow  = xi_flueGas;
  outlet.flueGas.xi_outflow  = xi_flueGas;


  //___________/ Dummy T_outflows \__________________________________________
  inlet.fuel.T_outflow = bulk.T;
  inlet.flueGas.T_outflow  = bulk.T;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,
            -100},{300,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-100},{300,100}}), graphics={
        Text(
          extent={{32,80},{240,46}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=showData,
          textString=DynamicSelect("", "T_out="+String(bulk.T,format="1.0f") +" K")),
        Text(
          extent={{32,20},{242,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=showData,
          textString=DynamicSelect("", "Q_wall="+String(Q_flow_wall/1e6,format="1.0f")+" MW"))}),
    Documentation(info="<html>
<p><b>Model description: </b>A nonstationary model for the hopper furnace section</p>

<p><b>FEATURES</b> </p>
<p><ul>
<li>This model uses TILMedia</li>
<li>Nonstationary mass and energy balances are used</li>
<li>Different heat transfer correlations can be chosen</li>
</ul></p>
</html><html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2024.</p>
<p><b>References:</b> </p>
<p> For references please consult the html-documentation shipped with ClaRa. </p>
<p><b>Remarks:</b> </p>
<p>This component was developed by ClaRa development team under the 3-clause BSD License.</p>
<b>Acknowledgements:</b>
<p>ClaRa originated from the collaborative research projects DYNCAP and DYNSTART. Both research projects were supported by the German Federal Ministry for Economic Affairs and Energy (FKZ 03ET2009 and FKZ 03ET7060).</p>
<p><b>CLA:</b> </p>
<p>The author(s) have agreed to ClaRa CLA, version 1.0. See <a href=\"https://claralib.com/pdf/CLA.pdf\">https://claralib.com/pdf/CLA.pdf</a></p>
<p>By agreeing to ClaRa CLA, version 1.0 the author has granted the ClaRa development team a permanent right to use and modify his initial contribution as well as to publish it or its modified versions under the 3-clause BSD License.</p>
<p>The ClaRa development team consists of the following partners:</p>
<p>TLK-Thermo GmbH (Braunschweig, Germany)</p>
<p>XRG Simulation GmbH (Hamburg, Germany).</p>
</html>",
revisions="<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"));
end Hopper_L2;
