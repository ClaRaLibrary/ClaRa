within ClaRa.Basics.ControlVolumes.Fundamentals.Geometry;
model FlatTubeGeometry_N_cv "Discretized flat tube bundle || Tube type"
//__________________________________________________________________________//
// Component of the ClaRa library, version: 1.8.0                           //
//                                                                          //
// Licensed by the ClaRa development team under the 3-clause BSD License.   //
// Copyright  2013-2022, ClaRa development team.                            //
//                                                                          //
// The ClaRa development team consists of the following partners:           //
// TLK-Thermo GmbH (Braunschweig, Germany),                                 //
// XRG Simulation GmbH (Hamburg, Germany).                                  //
//__________________________________________________________________________//
// Contents published in ClaRa have been contributed by different authors   //
// and institutions. Please see model documentation for detailed information//
// on original authorship and copyrights.                                   //
//__________________________________________________________________________//

  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.TubeType;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv(
    final volume=Modelica.Constants.pi/4*diameter^2*Delta_x*N_tubes,
    final A_heat=[N_tubes*2*(diameter+width)*Delta_x],
    final A_cross=ones(N_cv)*diameter*width*N_tubes,
    final N_heat=1,
    final diameter_hyd=4*A_cross/(2*(diameter+width)),
    Delta_x=ClaRa.Basics.Functions.GenerateGrid({0}, length*N_passes, N_cv),
    final z=cat(1,
               {(z_out - z_in)/(length*N_passes)*Delta_x[1]/2 + z_in},
               {((z_out - z_in)/(length*N_passes)*(sum(Delta_x[k] for k in 1:i - 1) + Delta_x[i]/2) + z_in) for i in 2:N_cv}),
    final Delta_z_in = {sum(Delta_x[1:i]) - Delta_x[i]/2 for i in 1:N_cv});

  parameter ClaRa.Basics.Units.Length length=1 "Length of the component (one pass) (Width of HX)" annotation (Dialog(group="Essential Geometry Definition"));
  parameter ClaRa.Basics.Units.Length width=1 "Width of flat tube (Length of HX)" annotation (Dialog(group="Essential Geometry Definition"));
  parameter ClaRa.Basics.Units.Length diameter=1 "Diameter of flat tube (heigth of flat tube)" annotation (Dialog(group="Essential Geometry Definition"));
  parameter ClaRa.Basics.Units.Length thickness_wall=0.001 "Wall thickness" annotation (Dialog(group="Essential Geometry Definition"));
  parameter Integer N_tubes=1 "Number of tubes in parallel" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Integer N_passes=1 "Number of passes of the tubes" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Integer orientation=0 "Main orientation of tube bundle (N_passes>1)" annotation(Dialog(group="Essential Geometry Definition", enable=(N_passes>1)), choices(choice = 0 "Horizontal", choice = 1 "Vertical"));

    annotation (Documentation(info="<html>
<p><b>For detailed model documentation please consult the html-documentation shipped with ClaRa.</b> </p>
<p>&nbsp;</p>
<p><br><b><span style=\"font-size: 10pt;\">Authorship and Copyright Statement for original (initial) Contribution</span></b></p>
<p><b>Author:</b> </p>
DYNCAP/DYNSTART development team, Copyright &copy; 2011-2022.</p>
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
revisions=
        "<html>
<body>
<p>For revisions please consult the html-documentation shipped with ClaRa.</p>
</body>
</html>"),Icon(graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource="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rCbprseRjx49Wo/DAgDAqOrq6qrboatJDtXjyIcPH67HYQEAYFQdOlSXXE6Sw9UknfU48ubNm+txWAAAGFWbNm2q16EP1+3M+Lp16+pxWAAAGFUPP/xwvQ59uJrkiXoc+bbbbqvHYQEAYFTdeuut9Tr0tmqSuqT+bbfd5k2cAAA0tK6urtx+++31Ovwj1SSP1OPIR48ezXXXXVePQwMAwKj4whe+kJ6ennod/uG6nRlPkk9+8pP1OjQAANTdpz71qXoe/uFKktlJdqUOT+OsVCq55557snr16pE+NAAA1NU999yT888/P4ODdXlG5kCSudUke5PcV49XGBwczAc+8IF6HBoAAOrq/e9/f71CPEnWJtn31Nnwr9frVa699tpcf/319To8AACMuBtvvLHe73/8WvLDS1PqFuNJcvXVV2fPnj31fAkAABgRu3fvzi/90i/V+2W+nvwwxr+RpG73Idy6dWve9ra3pa+vr14vAQAAJ6yvry9vectbsm3btnq+TFeSbyU/jPFDSb5Yz1e84YYbcvXVV9fzuhsAABi2wcHBvPOd78zNN99c75e6NklnkjQ97YNHk/yber7q3XffnccffzyXX355qtURv3kLAAAMS39/f66++up84hOfGI2X+60kG5Kk8rQPNifZmmR+vV99zZo1+cxnPpPZs2fX+6UAAOAn2rNnT9761rfmpptuGo2X25Hk5CR9yb++t3hfklH5VuCGG27IeeedlxtvvHE0Xg4AAJ7R9ddfn/POO2+0QjxJPp4nQzz58Qf9fDTHLyivuy1btmTNmjV54xvfmPvuq8ttzgEA4BmtXbs2r3vd63L55Zdn69ato/WyR3K8t/9F5Rl+039L8p5RmfPUiEola9asyVVXXZXLL7887e3to/nyAABMAEePHs0XvvCFfPrTn86NN95Y4sYif57kN5/+gWeK8cVJ1ieZNBqLflRbW1suueSSXHzxxVm1alWWLVuWyZMnZ9q0aSXmAADQgA4dOpQjR45k48aNWbduXW699dbcdttt6e7uLjWpO8nyJE88/YPPFONJ8qEk/7HeiwAAYIL4wyQf+NEPPluMtyd5IMkp9VwEAAATwKYkz8szvDfz2W72fTTJ++q5CAAAJohfy7PcJOUnPXnn2iSfq8scAACYGP4pyZee7Ref7TKVp8xIcldcrgIAAEO1IckFSQ4+2294rmfSH0jyC0mOjeAoAAAY73qTvDU/IcSTpKmGA21PcijJmhEYBQAAE8G7k3z+uX5TLTGeJN9LMjXJJSeyCAAAJoA/efKf51RrjCfJzUmWJjl3OIsAAGAC+N85fveUmjzXGzh/VEuOn26/bIh/DgAAxrsvJnlTkr5a/8BQzownyUCSf87xu6usHuKfBQCA8erTOf6GzZpDPBl6jCfHg/zaHH9K54uG8ecBAGA8+Yskv5Kkf6h/cDgx/pSvJtmf5JUneBwAAGhEPTl+15T/nGRwOAcY6jXjz+T5ST6b5NQROBYAADSCTUl+McntJ3KQ53roTy3uzPEg/9wIHAsAAMa6f8zx90+eUIgnIxPjyfEndf5skp9JsnGEjgkAAGPJY0muyPEz4odG4oAjfa33I0n+55P/+8IkzSN8fAAAGG3dST6U5N8keXAkDzwS14w/m3lJ/kOSX08yrY6vAwAA9XAkySf+Xzt3iBJRGEZh+ME8IIJBXIBGu0V0Hza7+7DZbS7BYhNXIEbtajIIBkEQw52BwaCCzp3yPnDyqYefez+c4GERBYsc4zPrOMYRNkboS5IkSf7iCWc4xfMii8YY4zMr2MWh4Yl/MmJ3kiRJ8p03XOAcl3gfo3TMMT5vgj3s4wA7/u9n0iRJkuQnH7jB1TTXhs9SRrWsMf7VmuE8zNY029jEqmG4z5IkSZL8xutcXvCIO8PBkXvcGi4CLtUnxaR2msd3sDMAAAAASUVORK5CYII=",
          fileName="modelica://ClaRa/Resources/Images/Components/FlatTubeGeometry.png")}));

end FlatTubeGeometry_N_cv;
