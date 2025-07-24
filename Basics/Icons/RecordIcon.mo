within ClaRa.Basics.Icons;
record RecordIcon

  annotation (Icon(graphics={
        Polygon(
          points={{-100,60},{100,60},{100,-60},{-100,-60},{-100,60}},
          smooth=Smooth.None,
          fillColor={153,205,221},
          fillPattern=FillPattern.Solid,
          lineColor={51,156,186}),
        Line(
          points={{-40,60},{-40,-60}},
          color={51,156,186},
          smooth=Smooth.None),
        Line(
          points={{40,60},{40,-60}},
          color={51,156,186},
          smooth=Smooth.None),
        Line(
          points={{-100,0},{100,0}},
          color={51,156,186},
          smooth=Smooth.None),
        Text(
          extent={{-100,100},{100,60}},
          lineColor={51,156,186},
          textString="%name")}));
end RecordIcon;
