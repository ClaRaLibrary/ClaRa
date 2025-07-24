within ClaRa.Basics.Icons;
model ComplexityLevel "Displays the complexity level inside model icon "
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

String complexity="??";

annotation (Icon(graphics={Text(
          extent={{-100,-58},{100,-100}},
          lineColor={27,36,42},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%complexity",
          visible=false)}),
              Documentation(info="<html>
<p><h4>Complexity Levels of a Model</h4></p>
<p>The ClaRa library is intended to contain models at different levels of complexity. Ideally, different complexity levels should be replaceable and hence extended from one base class. We suggest to use a scale containing <b>at most 6 complexity states</b>: </p>
<p><ul>
<li><b>Complexity 0:</b> base class for model</li>
<li><b>Complexity 1:</b> simple model, e.g. based on transfer functions</li>
<li><b>Complexity 2:</b> medium detailed model</li>
</ul></p>
<p>&nbsp;&nbsp; ....up to....</p>
<p><ul>
<li><b>Complexity 5:</b> very detailed model </li>
</ul></p>
<p>The idea of a model should be clearly described in the model information. Additionally, the complexity of a model should be visible already from its icon. For this the <b>complexity level</b> (0..5) <b>is displayed as a number in the lower center of the icon</b> as follows: </p>
<p><br/><code><font style=\"color: #0000ff; \">        model</font>&nbsp;MyNewModel&nbsp;<font style=\"color: #006400; \">&QUOT;A&nbsp;new way to solve this problem&QUOT;</font></code></p>
<p><br/><code><font style=\"color: #0000ff; \">        extends&nbsp;</font><font style=\"color: #ff0000; \">ClaRa.Basics.Icons.MyModel</font>;</code></p>
<p><code><font style=\"color: #0000ff; \">        extends&nbsp;</font><font style=\"color: #ff0000; \">ClaRa.Basics.Icons.ComplexityLevel</font>(complexity=&QUOT;x&QUOT;);        </code></p>
<pre>
        ....
<p><br/><code><font style=\"color: #0000ff; \">        end&nbsp;</font>MyNewModel;</code></p>
<pre> </pre>
<p>Here &QUOT;x&QUOT; runs from 0..5. </p>
</html>"));

end ComplexityLevel;
