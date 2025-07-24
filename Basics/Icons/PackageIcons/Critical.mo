within ClaRa.Basics.Icons.PackageIcons;
partial package Critical

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,60},{60,-100}},
          lineColor={0,0,0},
          fillColor={255,54,28},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,60},{-100,60},{-32,100},{100,100},{100,-60},{60,-100},{
              60,60},{-100,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,75,21},
          fillPattern=FillPattern.Solid),
        Line(
          points={{60,60},{100,100}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,100},{-32,60}},
          color={0,0,0},
          smooth=Smooth.None)}));
end Critical;
