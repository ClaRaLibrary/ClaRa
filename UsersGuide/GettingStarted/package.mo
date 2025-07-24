within ClaRa.UsersGuide;
package GettingStarted "An introduction to the library"
//__________________________________________________________________________//
// Package of the ClaRa library, version: 1.9.0                             //
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


  extends ClaRa.Basics.Icons.PackageIcons.Info100;


annotation (Documentation(info="<html>


<p><h4> Model Design Principles</h4></p>

<p>For an early introduction to the library concepts see our
<a href=\"http://www.ep.liu.se/ecp/076/062/ecp12076062.pdf\" title=\"Modelica Meeting 2012\">publication</a>.</p>



When setting up the model of a complex physical system such as a power plant, the first question to be answered is what physical fidelity is needed to cope with the given simulation task. The answer to this question
refers to the <strong> level of detail </strong> necessary for each component and sub-process. The next step is to define the
general <strong>physical effects to be considered </strong> for solving
the given task. Finally, the <strong>level of physical insight</strong>
into the considered physical aspects must be chosen.
In what follows it will be explained how these three
stages guide the model design of the ClaRa library.
For illustration the concept will be applied to the well known example of a fluid flow in a pipe.

<p><h5>Levels of Detail</h5></p>
<p>The ClaRa library is intended to contain models at different levels of detail. 
 It is mainly
based on two criteria:</p>
<p>
<ul><li> Purpose of model. In which simulation context
will the model be used? What questions and
physical effects shall be analysed with the model?</li>
<li> Applicability of model. What are the main assumptions the model is based on? Are there some
structural limitations?</li>
</ul>
</p>
<p>
The model design of ClaRa has been inspired by
these ideas. Moreover, it aims to provide a well balanced combination of readability, modelling ?exibil-
ity and avoidance of code duplication. Consequently,
each component in the ClaRa library is represented by a family of <i>freely exchangeable</i> models. 
Every component family is grouped into <strong>four levels of
detail</strong>:</p>

<p>
<ul>
<li><strong>L1:</strong>  Models are based on characteristic lines and / or
transfer functions. This results in an idealised
model, which shows physical behaviour. The
model defnition may be derived either from analytic solutions to the underlying physics or from
phenomenological considerations. Applicability
is limited to the validity of the simplification process. 
Non-physical behaviour may occur otherwise.</li>
<u>Example:</u> <i>transmission line model for fluid flow
in a pipe.</i>
<br>

<li><strong>L2:</strong>  Models are based on balance equations. These
equations are spatially averaged over the component. The models show a correct physical behaviour unless the assumptions for the averaging
process are violated. </li>
<u>Example:</u> <i> single control volume for fuid flow in
a pipe.</i>
<br>

<li><strong>L3:</strong>   Models are by construction subdivided into a
fixed number of spatial zones. The spatial localisation of these zones is not necessarily fixed and
can vary dynamically. For each zone a set of balance equations is used and the model properties
(e.g. media data) are averaged zone-wise. The
models show a correct physical behaviour unless
the assumptions for the zonal subdivision and the
averaging process over zones are violated.</li>
<u>Example:</u> <i> moving boundary approach for fluid
flow in a pipe.</i>
<br>

<li><strong>L4:</strong>  Models can be subdivided into an arbitrary number of spatial zones (control volumes) by the
user. They thus provide a true spatial resolution.
For each zone a set of balance equations is used
which is averaged over that zone. The model
shows a correct physical behaviour unless the assumptions for the choice of grid and the averaging process over the control volumes are violated.</li>
<u>Example:</u> <i> finite volume approach with spatial
discretisation in flow direction for fluid flow in
a pipe.</i>
<br>
</ul>


<p><h5>Physical Effects to be Considered</h5></p>
<p>Once the decision for a specific detail group of models is made, the set of required physical effects to be
covered by a model may still differ according to the
simulation goal. For instance, in a pipe model it might
be necessary to resolve the spatial flow properties but
unnecessary to analyse sound waves in detail. This is
reflected in the complexity of the basic physical equations underlying the model.</p>
<p>
Notice that, although the ClaRa library is designed for dynamic simulations, it is still possible
to include models, where parts of the basic physical
equations correspond to the stationary behaviour of a
component. Such models are often favourable with
respect to computation time and stability. Their use
is appropriate whenever certain aspects of the component dynamics can be neglected compared to the system dynamics under consideration. In the pipe example above this would be manifested by the fact that
if only fluid flow properties (temperature profile, flow
velocities, etc.) are of interest, sound wave propagation can be neglected, as long as the flow velocity is
much less than the speed of sound. Consequently a
stationary momentum balance for the fluid would be
sufficient in this case.</p>
<p>
In order to cope with these different needs, the
ClaRa library provides <i>component models at the
same level of detail but covering different physical effects</i>. They are distinguished by different self explaining names.</p>


<p><h5>Level of Insight</h5></p>
<p>
By now, the fundamental equations of a model are defined by setting its level of detail and the physical effects of consideration. However, these equations declare which physical effects are considered, but not
how they are considered. For instance, the pressure
loss in a pipe may be modelled using constant nominal values or via correlations taking the flow regime
and the fluid states into account. These physical effects are therefore modelled in <i>replaceable</i> models that
complete the fundamental equations using predefined
interfaces, e.g. the friction term in the momentum balance. By separating the governing model definition
from the underlying submodels, the flexibility of the
model is enhanced without loosing readability.
</p>
<p>Further information can be found on the library's homepage  <a href=\"http://claralib.com/\" title=\"www.claralib.com\">www.claralib.com</a>.</p>
<p>



</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics));
end GettingStarted;
