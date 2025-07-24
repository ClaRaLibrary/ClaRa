within ClaRa.Basics.Icons;
record IComIcon

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Polygon(
          points={{-100,60},{100,60},{100,-60},{-100,-60},{-100,60}},
          smooth=Smooth.None,
          fillColor={143,170,56},
          fillPattern=FillPattern.Solid,
          lineColor={115,150,0}),
        Line(
          points={{-40,60},{-40,-60}},
          color={115,150,0},
          smooth=Smooth.None),
        Line(
          points={{40,60},{40,-60}},
          color={115,150,0},
          smooth=Smooth.None),
        Line(
          points={{-100,0},{100,0}},
          color={115,150,0},
          smooth=Smooth.None),
        Text(
          extent={{-100,100},{100,60}},
          lineColor={115,150,0},
          textString="%name")}));
end IComIcon;
