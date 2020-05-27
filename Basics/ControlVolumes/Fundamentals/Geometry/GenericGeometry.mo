within ClaRa.Basics.ControlVolumes.Fundamentals.Geometry;
model GenericGeometry "All shapes || Base class"
  //___________________________________________________________________________//
  // Component of the ClaRa library, version: 1.5.1                            //
  //                                                                           //
  // Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
  // Copyright  2013-2020, DYNCAP/DYNSTART research team.                      //
  //___________________________________________________________________________//
  // DYNCAP and DYNSTART are research projects supported by the German Federal //
  // Ministry of Economic Affairs and Energy (FKZ 03ET2009/FKZ 03ET7060).      //
  // The research team consists of the following project partners:             //
  // Institute of Energy Systems (Hamburg University of Technology),           //
  // Institute of Thermo-Fluid Dynamics (Hamburg University of Technology),    //
  // TLK-Thermo GmbH (Braunschweig, Germany),                                  //
  // XRG Simulation GmbH (Hamburg, Germany).                                   //
  //___________________________________________________________________________//

  parameter Units.Volume volume(min=Modelica.Constants.eps) = 1 "Volume of the component" annotation (Dialog(group="Essential Geometry Definition"));
  parameter Integer N_heat=2 "No. of heat transfer areas";
  parameter Units.Area A_heat[N_heat](each min=Modelica.Constants.eps) = ones(N_heat) "Heat transfer area: /1/ dedicated to lateral surface" annotation (Dialog(group="Essential Geometry Definition"));
  final parameter Units.Area A_heat_CF[N_heat](each min=Modelica.Constants.eps) = {A_heat[i]*CF_geo[i] for i in 1:N_heat} "Corrected heat transfer area: /1/ dedicated to lateral surface" annotation (Dialog(group="Essential Geometry Definition"));
  parameter Real CF_geo[N_heat](each min=Modelica.Constants.eps) = ones(N_heat) "Correction factor for heat transfer area: /1/ dedicated to lateral surface" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Units.Area A_cross(min=Modelica.Constants.eps) = 1 "Cross section for mass flow" annotation (Dialog(group="Essential Geometry Definition"));
  parameter Units.Area A_front(min=Modelica.Constants.eps) = 1 "Frontal area" annotation (Dialog(group="Essential Geometry Definition"));

  parameter Units.Area A_hor=1 "Nominal horizonal area" annotation (Dialog(group="Essential Geometry Definition"));

  parameter Integer N_inlet=1 "Number of inlet ports" annotation(Dialog(group="Essential Geometry Definition"));
  parameter Integer N_outlet=1 "Number of outlet ports" annotation(Dialog(group="Essential Geometry Definition"));

  parameter Units.Length z_in[N_inlet]=ones(N_inlet) "Height of inlet ports" annotation (Dialog(group="Essential Geometry Definition"));
  parameter Units.Length z_out[N_outlet]=ones(N_outlet) "Height of outlet ports" annotation (Dialog(group="Essential Geometry Definition"));
  parameter Units.Length height_fill=1 "Fillable height of component" annotation (Dialog(group="Essential Geometry Definition"));
  parameter Real shape[:, 2]=[0, 1; 1, 1] "Shape factor, i.e. A_horitontal=A_hor*interp(shape, relLevel)" annotation(Dialog(group="Essential Geometry Definition"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
            "iVBORw0KGgoAAAANSUhEUgAAAyMAAAMiCAYAAAB9jxxgAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAA+qwAAPqsBAuSEPgAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7N13nNx3fefxz8xs00pa1dVKq16tYhXLHWxjG9tADDYONTljHODuOODII8ldkgtOcmfCnUMI6RfacYSEHASSYEqOiw2Y7iobS66yitW7Vitpd7Vl5v6Qe5G1uzPznfJ8Ph5+WLKNfm8eXusxr/21TKFQiEqSyWTGRcQ5EbEkImZEROdTfzz942kRkUs2EAAAKtNQROyLiF0RsfsFf348Iu4tFArH0s17sUwlxEgmk1kbEddGxJsiYnVEZNMuAgCAmpOPiJ9HxDcj4tZCobAu8Z40MZLJZBoj4tI4GSDXRMTsso8AAID6tj0ivhERt0bEHYVCYaDcA8oaI5lMZnlE/IeIuD4iJpbtwAAAwKl0RcTfRcRfFwqFh8t10LLESCaTWRoR/z0iriv5wQAAgNH454j4nUKh8GipD1TSezMymcyMTCbz6YjYEEIEAACqwXURsSGTyXw6k8nMKOWBSnJmJJPJtEXEb0bEr0VEa9EPAAAAlENPRPxJRHy8UCh0F/sXL3qMZDKZt0fEX0ZEe1F/YQAAIJX9EfGhQqHwD8X8RYsWI0+9H+RzEfGOovyCAABApflKRLyvWO8rKUqMZDKZuXHysWCrRv2LAQAAlezBiLimUCg8OdpfaNQ3sGcymYsi4p4QIgAAUA9WRcQ9T3XAqIwqRjKZzHsj4rvh/hAAAKgn7RHx3ad6YMRGFCOZk/44Tt4j0jSaAQAAQFVqiojPZTKZP85kMpmR/ALDvmfkqQP9VZx8kzoAAMBfR8QHC8OMi5GcGfnDECIAAMCz/kOc7IRhGdaZkUwm8+6I+MJwDwIAANSFGwuFwt+c7j982jGSyWQujIjvR0TzCIcBAAC17UREXFYoFH52Ov/wacVIJpOZHScf39sxum0AAECN2xsR5xYKhe2v9A++4j0jmUymNSJuDSECAAC8so6IuPWpjjil07mB/a8j4qxRTwIAAOrFWXGyI07plJdpZTKZayPi60UcBQAA1I83FwqFW1/ub75sjDx1WmVjRHSWaBgAAFDbdkXE4kKh0PNSf/NUl2n9aggRAABg5DrjZFe8pJc8M5LJZKZExKaImFC6XaOTzWajsbEx9QwAAEiqv78/hvni83I7EhELC4XCwRf+jYaX+R98JCokRNasWRNXXXVVzJkzJ2bOnBmdnZ3R2dkZ06dPj4aGl5sPAAD1YXBwMPbs2RM7d+6MXbt2xa5du2Lbtm1x2223xf333596XsTJrvhIRPz6C//Gi86MZDKZeRHxaCR8ueFrXvOaeOtb3xrXXHNNzJkzJ9UMAACoatu3b49vfvOb8dWvfjXuuOOOlFNORMTSQqGw9bl/8aVi5G8j4vry7XrWOeecE3/4h38Yl19+eYrDAwBAzfre974Xv/mbvxn33Xdfqgl/VygU3vXcv/C8GMlkMvMj4ok4vfePFM2cOXPi4x//eLz97W+PTCZTzkMDAEDdKBQK8ZWvfCV+67d+K7Zt21buw+cjYkGhUHjy6b/wwuj40Ev8tZK6+OKL49577413vOMdQgQAAEook8nEO9/5zrj33nvj4osvLvfhsxHxH174F54elouId5dzzXvf+964/fbbo729vZyHBQCAutbe3h633357vPe97y33oW/IPOcMxHPPgrw6IqaUa8VHP/rR+NznPhdNTU3lOiQAAPCUpqam+NznPhcf/ehHy3nYGRFx/tM/eW6MXFuuBTfeeGPcdNNN5TocAADwMm666aa48cYby3nINz/9g2duYM9kMhsjYlGpj3zhhRfG97///WhuTvbkYAAA4DlOnDgRl112WfzsZz8rx+EeKxQKSyOeipFMJrM8Ih4q9VGnT58eDzzwQHR0dJT6UAAAwDDs3bs31qxZE3v27CnH4ZYVCoVHn75MqyyXaN18881CBAAAKlBHR0fcfPPN5TrcmyOePTPy4zh5A3vJLFu2LNavXx+5XK6UhwEAAEZoaGgoVq5cGY888kipD/WTQqFwUTaTyTRExNpSH+2WW24RIgAAUMFyuVzccsst5TjU2kwm05CJiFUR8fOSHmnt2pSvnQcAAIbh7LPPjnXr1pX6MKuzEbGg1Ed561vfWupDAAAARVKmz+8LshHRWeqjXHPNNaU+BAAAUCRl+vzeWfIYWbhwYaxYsaKUhwAAAIpoxYoVsXDhwlIfpvQx8rrXva6UvzwAAFACZfgc35mNiBmlPMK8efNK+csDAAAlUIbP8TNKfmZkxoyStg4AAFACnZ0lv7W89GdGyvB/AgAAKLIynFSYkY2IiaU8ghgBAIDqU4bP8ROzEdFYyiNMmzatlL88AABQAmX4HN+YLfURstmSHwIAACiycnyOVwoAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEmIEQAAIAkxAgAAJCFGAACAJMQIAACQhBgBAACSECMAAEASYgQAAEhCjAAAAEk0pB4AAFAt8oVCHOsfjGMDgyf//NQfxwcGY2CoEFPGNMWU1qaYOqY5Jo9pimwmk3oyVDQxAgDwlD3H+uKJw8di46GjsfHQsdhzrPfZ6BgYjJ6BodP+tZpy2ThnxqS4aHZ7XDR7anSOH1PC5VCdMhFRKOUBDh8+HBMnTizlIQAAhqVnYCieOHwsnjh09Kn4OPnjo/2DJTvmwknj4vqVc+MNC2dEQ9YZEypfV1dXTJo0qaTHECMAQF3YdPhYfH/rvvj+k/vi8YNHS/sB6BRmjGuJG1bNi2uXzIymnNt3qVxiBABghAoRsWHfkfj+k/vi+1v3xfbuntSTnqdjbEv8/iUr4rzOyamnwEsSIwAAwzCUL8R9ew7H97bujR88uT/295xIPemUMhHx9uWz48PnLYlmZ0moMGIEAOA0HO0fjH96dEd8+aFtFR8gL2XuhLHxscvOjKVT2lJPgWeIEQCAU9h1rDf+z4ZtcevjO4f1pKtK1NKQi1suXxUXzZ6aegpEhBgBAHhJD+/vjr9dvzW+u3Vf5AupbkUvvmwmEx+5aFlcu2Rm6ilQlhjxnhEAoGr8aNv++OL6J+P+PYdTTymJfKEQH/3Rw7H3+In4d2ctSD0HSk6MAAAVb9PhY/GJOx+Le3YdSj2lLD6zblMM5vPxgbMXpZ4CJSVGAICK1X1iID61blN87ZEdNXU51un4/ANbYuqY5nj78tmpp0DJiBEAoOLkC4X4p0d3xl/f90QcOTGQek4yn7jzsZg0pimunN+RegqUhBgBACrKuj2H449+9mhsPHQs9ZTk8oVC/N4dG2Jic2Oc6+WI1CBv1wEAKkL3iYG46Y718e++fa8QeY6BfD5+63sPVuX7U+CViBEAILm7dh6Md/7Tz+I7m/aknlKRuk8MxM0/eqi072OABMQIAJDMiaF8/NHPHo0PfWdd7POd/1P62Y6D8dWHt6eeAUUlRgCAJB4+0B3/5ut3xlce3u47/qfpz+5+PLZ0HU89A4pGjAAAZTWUL8Rn798cv/LNu2OrD9bDcmIoH797x4YYzMs3aoMYAQDKZvexvnjvt+6JT6/bFEM+UI/Iowe74zPrNqWeAUUhRgCAsrh716F41613xob9R1JPqXpfeHBr/HxvV+oZMGpiBAAouS+u3xof+s666Oqr3xcYFlO+UIjf/cGG6BkYTD0FRkWMAAAl0zMwFL/9vQfjz+/eGPmCy7KKadfR3vjEnY+lngGjIkYAgJLY1t0TN37z7rh9y97UU2rWNx7fFT/ctj/1DBgxMQIAFN0Pt+2PG269KzYf9ib1UvvTux73MACqlhgBAIqmEBGfWbcpfuO2B+JYv/sZymFbd098Y+Ou1DNgRMQIAFAUR/sH49f+9f74zP2bvcSwzD67blP0D+VTz4BhEyMAwKhtOnwsbrj1rvjx9gOpp9SlfT0n4h8e3p56BgybGAEARuVfN++JG79xd2zv7kk9pa79759vieMe9UuVESMAwIjkC4X4s7sfj9/5/vroHRxKPafuHTkxEH+7/snUM2BYxAgAMGxdfQPxwe+s8+G3wvz9hifjcF9/6hlw2sQIADAsDx/ojutvvTPu2XUo9RReoGdgKD7/wJbUM+C0iREA4LR94/Fd8b5v3RN7jvWlnsLL+MdHd/j3Q9UQIwDAKxrI5+OWnz4SN//oIY+QrXD9Q/n4zP2bUs+A0yJGAIBT2t9zIv79t++Nrz2yI/UUTtO3Nu6OLV3HU8+AVyRGAICX9cDerrj+63fGg/uOpJ7CMOQLhfjcA5tTz4BXJEYAgJf0Dw9vj/f/y71xsNfTmarRd7fs9e+OiidGAIDn6R/Kx+//YEN8/GePxmC+kHoOIzSYL8TXH3NpHZVNjAAAz9h9rC9+5Zt3x7ef2J16CkXwj4/ujHxBUFK5xAgAEBERd+86FNd//c547ODR1FMokn3H++IH2/anngEvS4wAAPE3D26ND31nXRw5MZB6CkX21Ye3p54AL6sh9QAAIJ2egaH4bz96KL67ZW/qKZTIPbsOxbYjPTFnQmvqKfAizowAQJ3adqQnbvzGXUKkxhUi4muPODtCZRIjAFCH/uWJ3fGuW++KzV6MVxe+uXFX9A0OpZ4BLyJGAKCOdJ8YiP/yvQfj936wIY4PDKaeQ5kc7R+M72zak3oGvIgYAYA6cfeuQ/HOf/pZ3OayrLr0VZdqUYHcwA4ANa5/KB9/cc/G+PJD28IbJ+rXYwePxvp9R2LltAmpp8AzxAgA1LDHDx6Nm36wITYfPpZ6ChXgq49sFyNUFJdpAUANyhcK8TcPbo13f+NuIcIzbt+yN7r6vEuGyiFGAKDGbDx0LN73rXviL+7ZGAP5fOo5VJD+oXzctsWN7FQOl2kBQI3oGRiKT63bFF95eFsM5d0dwku7bfPeeNuy2alnQESIEQCoCd/dsjf++M7HYl/PidRTqHAP7O2Kg739MWVMU+opIEYAoJrt6O6Nj//skfjpjoOpp1Al8oVCfHfL3nj7cmdHSM89IwBQhfqH8vHZ+zfH2//pp0KEYbvdu2aoEM6MAECVuXPnwfj4Tx+Nbd09qadQpVyqRaUQIwBQJR7c2xV/vW5T3LPrUOopVDmXalEpxAgAVLiHD3THp+57wuVYFNXtYoQKIEYAoEI9fuhofOq+TfHDbftTT6EGPbC3Kw70nIiprc2pp1DHxAgAVJjNXcfjM+s2xXe37A1vC6FU8oVCfG/rPmdHSEqMAECF2NbdE59dtzn+3+Y9kS/IEErPpVqkJkYAILF7dx+Krz2yI763dZ8IoaxcqkVqYgQAEjjaPxjf2rgr/vHRHbG163jqOdQpl2qRmhgBgDJ6+EB3fO2RHfGvm/dE3+BQ6jkQt7lUi4TECACUWN/gUPy/zXviHx/ZEQ8f6E49B57n5y7VIiExAgAlsqXrePzjozvi2xt3xdH+wdRz4CXlC4X48fYD8eYzZqaeQh0SIwBQJIWIeHj/kfjBk/vjjif3xWb3glAl7tx5UIyQhBgBgFEYyOfjnl2H4wdP7osfbtsf+3tOpJ4Ew3b3rkORLxQim8mknkKdESMAMEzH+gfjJ9sPxB1P7ouf7DgYPQMuwaK6dZ8YiEcPHI3l7W2pp1BnxAgAnIa9x/ueufxq3Z7DMZj3PhBqy507D4oRyk6MAMAL9A/l45ED3bFh/5HYsO9IrN9/JPYc60s9C0rqzp0H4z1r5qeeQZ0RIwDUtUJEbD/SExv2H4n1+47Ehv1HYuOho858UHce3NcVPQND0dqYSz2FOiJGAKgr3ScGYsP+7tiwr+vkmY/93dF9YiD1LEhuMF+I+3YfiovntKeeQh0RIwDUtH3H++K+PYfj/j1dcd/uw/HkEY/bhZdz586DYoSyEiMA1JRdR3vjvj2HY93uw7Fuz+HYebQ39SSoGnftOpR6AnVGjABQ1Z48cjzW7emKdbsPx317Dse+4240h5Ha2nU89h7vi46xLamnUCfECABVoxARmw8fi/t2H47795yMj0O9/alnQU25c+fBuHaJt7FTHmIEgIrTMzAY27p7YtuRntj+nD9vPdLjZnMosbt2HhIjlI0YASCJ3sGh2N7dE9uP9MS27mejY1t3j7MdkNBdOw9GvlCIbCaTegp1QIwAUBJ9g0NxuG8gDvf1x97jfc9Ex9NnOfb3nEg9EXgJR04MxGMHj8ayqd7GTumJEQBOS8/AUHT19cfhvv443DcQh3r7n/fzw0//uPfkz/sGh1JPBkbozp0HxQhlIUYAalQhIk4MDkXv4FD0Deaj75kfP/1H/pmf9w4MPe/vH+0ffCo0TkbH4b7+6B/Kp/6/BJTJPbsOxa+snp96BnVAjAAVrxARhUIhhgqFyBcihvKFKEQhhvInf54vFJ75Y+gVfp7PRwwVCs//9Z75+bP/bKHw/H/umZ/H84//7M9f/M8/e9x4wZ9f+Ndf/OPn/fqn2JMvFOLEC0Lj6fg4MTgUhaT/5oBqtWF/t/tGKAsxAkRERP/QS3+g7R0Yir6hZ79z/qLvqL/wnx8cisF8/tkPy/mnPmBHRD5feOYD9NMfvl/483zh+R/C80/9GIDy6RkYjC1dx2PhpHGpp1DjxAjUkP6hfHT19UfXiYHo6hs4+eO+gad+3v/sXzsxEMf7B593+U6+4CM/AM9av++IGKHkxAhUsK6+gTjQeyKOPCcino2Kgeg60f+86Oh1wzAARfLgviPx5jO8b4TSEiOQ0EA+H7uP9sWOo72x82hP7DzaGzu7e2Pn0d7YcbQ3egYGU08EoE5t2NeVegJ1QIxAiR3q7T8ZGc8Jjh1PBcf+nhMujwKgIm3pOh7H+gdjXJOPi5SOry4oguMDg/HIge7YfPj4s2c5untj17He6Blw6RQA1acQEQ/tPxLnz5ySego1TIzAMA3mC7Hx0NF4aH93PLT/SDy0/0hsPdLjDAcANefBfWKE0hIj8Aq2dfc8FR0n4+Oxg0e9/A2AurB+35HUE6hxYgSe41Bvf2x4Tng8fKA7uk8MpJ4FAEls2C9GKC0xQt0azBdi/b6u2PCcy612H+tLPQsAKkb3iYHYdqQn5kxoTT2FGiVGqCuHevvjx9sPxE92HIg7dxyM4x6dCwCntH7/ETFCyYgRalohIh7Z3x0/3r4/frz9QDxyoDvcZg4Ap+/BvV1x9aIZqWdQo8QINWcoX4i7dh2K2zbviZ/sOBCHevtTTwKAqrXefSOUkBihZqzfdyT+76bdcfuWvQIEAIrkiUPHondwKMY05FJPoQaJEarak0eOx//dtCe+s2l37OjuTT0HAGpOvlCIRw50x9rpk1JPoQaJEapOz8BgfHPj7vjWxl3xyIHu1HMAoOZt2HdEjFASYoSqsetob3z54e1x62M7PQULAMpo46FjqSdQo8QIFe/+PYfj/zy0Le54cn/kC56FBQDl9sTho6knUKPECBVpIJ+P2zbvjb/fsC0ePehSLABIaWtXTwzlC5HLZlJPocaIESpKvlCIb23cHZ9etyn2Hvc2dACoBAP5fDx55HgsmDQu9RRqjBihYvxw2/74y3ufiM2HXZcKAJXmicPHxAhFJ0ZI7ud7u+LP79kYP9/blXoKAPAynjh8LK5KPYKaI0ZIZnPX8fjLezbGD7ftTz0FAHgFT3iiFiUgRii7E0P5+NR9T8SXNmzzdCwAqBJPuIyaEhAjlNUDe7vi5h89FNuO9KSeAgAMw+6jvdEzMBStjbnUU6ghYoSy6B0cir+694n4h4e3OxsCAFWoEBGbu47Fme0TUk+hhogRSu7e3Yfioz96OHYe7U09BQAYhScOiRGKS4xQMv1D+fjkXY/FPz6yI5wLAYDq574Rik2MUBIHe/vjP93+QKzfdyT1FACgSDaJEYpMjFB0jx08Gr922wOxzxvUAaCmeLwvxZZNPYDa8t0te+O937pHiABADTrc1x+HevtTz6CGiBGKohARn7l/c/z29x6MvsGh1HMAgBJx3wjFJEYYtf6hfPyX7z0Yn1m3yY3qAFDjxAjF5J4RRmUwX4jf/t6D8cNt+1NPAQDKYLMYoYicGWHE8oVCfOSO9UIEAOrIjm7vDaN4xAgjki8U4r/+8KH47pa9qacAAGW082hP6gnUEDHCiNzy00fjX57YnXoGAFBme4+fiMG8u0QpDjHCsP3xnY/FPz26I/UMACCBfKEQu465VIviECMMy2fv3xz/56FtqWcAAAntdN8IRSJGOG137zoUn71/c+oZAEBiO4+KEYpDjHBaDvb2x013rI98wTWiAFDv3MROsYgRXlG+UIjfvWN9HOrtTz0FAKgAzoxQLGKEV/T5B7bE3bsOpZ4BAFQI7xqhWMQIp7Ruz+H4jPtEAIDn2OHMCEUiRnhZXX0D8ZHvu08EAHi+noHB6OobSD2DGiBGeFl/cc/G2N9zIvUMAKACuYmdYhAjvKSH93fHNx7fmXoGAFCh3MROMYgRXqQQER//2aPh4iwA4OW4b4RiECO8yDcf3xUb9h9JPQMAqGCeqEUxiBGe51j/YPzlvRtTzwAAKpx7RigGMcLzfGbdJi83BABekXtGKAYxwjM2Hz4WX3lke+oZAEAV2Hf8RAzm3WHK6IgRnvFHdz4WQ35TAQBOQ75QiIO9XgHA6IgRIiLiu1v2xj27DqWeAQBUkQPeR8YoiRGib3Ao/uTux1PPAACqzIEe95kyOmKE+MKDW2PPsb7UMwCAKnPAZVqMkhipc7uO9sYXH9yaegYAUIVcpsVoiZE698d3PRb9Q/nUMwCAKiRGGC0xUsfu3X0ofvDk/tQzAIAqdcC7yRglMVLH/tcDW1JPAACqmDMjjJYYqVMb9h/xKF8AYFQOihFGSYzUqc87KwIAjNLBvv7IF7wwmZETI3XoicPH4kfb3CsCAIzOUL4QXX0DqWdQxcRIHfrfP98SvocBABSDd40wGmKkzuw62hu3bd6begYAUCO8hZ3RECN15tbHd7m2EwAoGk/UYjTESB3JFwrxrY27Us8AAGqIy7QYDTFSR+7aeSj2Hu9LPQMAqCHOjDAaYqSOfOPxnaknAAA1RowwGmKkTnSfGIgfeJwvAFBkB3rdwM7IiZE68f8274n+oXzqGQBAjTniPSOMghipE15yCACUwvGBwdQTqGJipA6cGMrHvbsPp54BANSgY/1ihJETI3Xgvt2HXKIFAJRE3+BQDOW9w4yRESN14MfbD6SeAADUMJdqMVJipA78dIcYAQBKx6VajJQYqXG7j/XFju7e1DMAgBp2zJkRRkiM1LjHDnanngAA1DhnRhgpMVLjHj94NPUEAKDGiRFGSozUuMcPHUs9AQCocW5gZ6TESI1zZgQAKDVnRhgpMVLDjvUPxq5jbl4HAErreP9Q6glUKTFSw3Yc7Uk9AQCoA8cGBlJPoEqJkRp2qLc/9QQAoA64TIuREiM1TIwAAOXgMi1GSozUMDECAJSDlx4yUmKkhh3qEyMAQOm5TIuREiM1zJkRAKAcjosRRkiM1LB8oZB6AgBQB/oG3TPCyIiRGpbNZFJPAADqwKBvgDJCYqSGiREAoBwG82KEkREjNUyMAADlMJTPp55AlRIjNSynRQCAMnBmhJESIzWsMedfLwBQemKEkfJptYZ1jG1JPQEAqANDbmBnhMRIDZs5fkzqCQBAHRh0zwgjJEZqmBgBAMphyGVajJAYqWFiBAAoh0J42TIjI0ZqWFtzY4xvakg9AwCoA25iZyTESI2bOb419QQAoA6IEUZCjNS4mW0u1QIASs8TtRgJMVLj3DcCAJSDJ2oxEmKkxs0SIwBAGbhMi5EQIzXOmREAoBw83peRECM1zg3sAEA5ODPCSIiRGjd9XEvkspnUMwCAGuc9I4yEGKlxDdlMLJ3SlnoGAFDjGnzzkxEQI3Xg7BmTUk8AAGpcQ87HSobPV00dOEeMAAAl1pT1sZLh81VTB9Z0THTfCABQUk05nzUYPjFSB1obG2KZ+0YAgBJqcGaEEfBVUyfcNwIAlFKje0YYAV81deLsGZNTTwAAalRjNhsu0mIkxEidcN8IAFAqje4XYYTESJ1obczF8qnuGwEAiq/R/SKMkK+cOuK+EQCgFJrcL8II+cqpI+e4bwQAKAFnRhgpXzl1ZHXHxGhw3wgAUGSepMVI+cqpI2Ma3DcCABSfFx4yUmKkzpzbOSX1BACgxjgzwkj5yqkzr5nbnnoCAFBj3DPCSPnKqTPLp7ZFx9iW1DMAgBriaVqMlK+cOuTsCABQTM1ihBHylVOHLps7LfUEAKCGTGxpe87dywAAIABJREFUSj2BKiVG6tDa6ZOirbkx9QwAoEZM8LmCERIjdSiXzcQlc1yqBQAUx8QWMcLIiJE65VItAKBYXKbFSImROnXBrCnR0pBLPQMAqAHOjDBSYqRONeeyceFML0AEAEZvontGGCExUscum+dSLQBg9FymxUiJkTp20eypkctmUs8AAKqcy7QYKTFSx9qaG+Ps6ZNSzwAAqlgmPNqXkRMjde5ST9UCAEZhfHNjZDOutGBkxEidu3TetPDbBwAwUi7RYjTESJ2b1tocy9snpJ4BAFQpN68zGmKEuNxTtQCAEfJYX0ZDjBBXzu9IPQEAqFLOjDAaYoToHD8mlre3pZ4BAFQh94wwGmKEiIi4av701BMAgCo0tbU59QSqmBghIiKuXNDhqVoAwLB1jmtJPYEqJkaIiIiOsS2xsmNi6hkAQJXpHDcm9QSqmBjhGW5kBwCGa8Z4McLIiRGeccX8Dm9QBQBO27imhhjf1JB6BlVMjPCM9tbmWONSLQDgNLlEi9ESIzzPlQtcqgUAnJ7pbl5nlMQIz/PaeS7VAgBOT6f7RRglMcLzTB7TFGfPmJR6BgBQBTzWl9ESI7yIp2oBAKfDk7QYLTHCi1w+ryNyWZdqAQCn5gZ2RkuM8CITWxrj3BmTU88AACrcDJdpMUpihJd0ladqAQCn0NrYEG3NjalnUOXECC/p0rnTosGlWgDAy3DzOsUgRnhJbc2NccHMKalnAAAVymN9KQYxwsu6csH01BMAgArlfhGKQYzwsi6d2x5NOV8iAMCLOTNCMfikycsa29gQF89pTz0DAKhAs8a3pp5ADRAjnNLrF7pUCwB4sXkTxQijJ0Y4pVfPmhrjmhpSzwAAKkgum4mZzoxQBGKEU2rKZePyed45AgA8a9b4Vq8AoCjECK/IpVoAwHO5RItiESO8onNmTIqprc2pZwAAFWLehLGpJ1AjxAivKJvJxFXzXaoFAJw0b6IYoTjECKfl9QtnpJ4AAFQIZ0YoFjHCaVne3haz21wfCgBEzJ3gMwHFIUY4bW5kBwAmj2mKtubG1DOoEWKE0yZGAACXaFFMYoTTNnfC2Fg6pS31DAAgITevU0xihGFxdgQA6ts894tQRGKEYblq4fTIZrxxFQDqlTMjFJMYYVimtTbHWdMnpp4BACQy1z0jFJEYYdi8cwQA6lNTLhszxrWknkENESMM22vnTYvGrC8dAKg3c9paXa5NUflEybC1NTfGhbOmpJ4BAJTZfPeLUGRihBHxVC0AqD+Lp4xPPYEaI0YYkUvmtEdrYy71DACgjJaKEYpMjDAiLQ25uHTutNQzAIAyOsPLjykyMcKIuVQLAOrHlDFNMWVMU+oZ1Bgxwoid3zklJrY0pp4BAJSBsyKUghhhxHLZTFw539kRAKgH7hehFMQIo+JSLQCoD0vECCUgRhiVVR0TvYkVAOrAGWKEEhAjjEomIl7n7AgA1LSxjQ0xq6019QxqkBhh1N6wcEbqCQBACS2ZMj4yqUdQk8QIo7Zw0rhY0T4h9QwAoERcokWpiBGK4rozZqaeAACUiBihVMQIRXHVgunR2phLPQMAKIEzJosRSkOMUBStjbm4aoEb2QGg1jRms7Fg0rjUM6hRYoSicakWANSeBZPGRkPW7euUhhihaFa0T4hFvnMCADXljCltqSdQw8QIRXXd0lmpJwAARbTUzeuUkBihqN6wcHo05XxZAUCtWDrVmRFKx6dGiqqtuTFeO68j9QwAoAiactlYNtWZEUpHjFB01y11IzsA1IJlU9uiMevjIqXjq4uiWzt9Usxpa009AwAYpdUdE1NPoMaJEUrizR7zCwBVb/U0MUJpiRFK4o2LOz2THACq3KqOCaknUOPECCUxeUxTXDKnPfUMAGCE5rS1xqSWptQzqHFihJJ58xneOQIA1cr9IpSDGKFkLpg5OaaPa0k9AwAYgVVihDIQI5RMNpOJa5e4kR0AqpEzI5SDGKGkrlnSGdmMG9kBoJq0NTfG/IljU8+gDogRSqpjbEtcOGtK6hkAwDCc2T4hfCuRchAjlNx13jkCAFVljUu0KBMxQsldPLs9pozxaEAAqBbeL0K5iBFKLpfNxJuWdKaeAQCchlw2E2e2ixHKQ4xQFm9eMsu1pwBQBZZMHh8tDbnUM6gTYoSymNU2Js6eMTn1DADgFXikL+UkRiibX1zqRnYAqHSrprlEi/IRI5TNa+d1xAxvZAeAiuZKBspJjFA2uWwmrl85L/UMAOBlLJo0zhMwKSsxQlldu6QzJjQ3pp4BALyE82d6UTHlJUYoq5aGXLxjxZzUMwCAlyBGKDcxQtm9Y/lsjwwEgArTlMvG2umepEV5iRHKbkJzY1zrJYgAUFFWTZvom4WUnRghietXzotc1msQAaBSnD/TU7QoPzFCEjPGtcRV86enngEAPMX9IqQgRkjmhlXzUk8AAOLkJdRLp4xPPYM6JEZIZvHkcfGqWVNTzwCAunde5+TIZlw+TfmJEZJ6t7MjAJCcS7RIRYyQ1NkzJsWK9gmpZwBAXRMjpCJGSM7ZEQBIZ05ba8wY15J6BnVKjJDcpXPbY86E1tQzAKAuOStCSmKE5LKZTNywcl7qGQBQl7xfhJTECBXhFxbNiKmtzalnAEBdyWYycc4MMUI6YoSK0JTLxi+tmJN6BgDUlTPb22JcU0PqGdQxMULFeMvSWTG20W+IAFAuF7hfhMTECBVjXFNDvGXZrNQzAKBuXDynPfUE6pwYoaL88oo50Zj1ZQkApdYxtiWWTW1LPYM651MfFWVqa3NcvXhG6hkAUPNeM9dZEdITI1Scd62cG9lMJvUMAKhpl86dlnoCiBEqz9wJY+MNC6enngEANautuTHOnj4p9QwQI1Sm95+9KJpyvjwBoBQumj01cllXIZCeT3tUpBnjWuKty2anngEANcklWlQKMULFes/q+d47AgBF1pTLxoWzvF+EyiBGqFgTWxrjhlVzU88AgJpywcwpMaYhl3oGRIQYocL98plzY8qYptQzAKBmXOqRvlQQMUJFG9OQi3971sLUMwCgJmQzGW9dp6KIESredWfMjNltralnAEDVW9MxMSa1uOKAyiFGqHi5bCY+cM6i1DMAoOq5RItKI0aoClfM74hlU9tSzwCAquaRvlQaMUJVyETEr52/JPUMAKhaiyePi87xY1LPgOcRI1SNtdMnxRsWzkg9AwCqkrMiVCIxQlX51fMWR6sXIQLAsIkRKpEYoapMbW2Of3fWgtQzAKCqzBw/Js6YMj71DHgRMULVeeeKOTF/4tjUMwCgavzCIpc5U5nECFWnIZuJ/3zh0tQzAKBqiBEqlRihKp3XOTmumN+RegYAVLxV0yZ4eTAVS4xQtX7t/CUxpiGXegYAVLSrF3emngAvS4xQtTrGtsR71sxPPQMAKlZjNhtXupKACiZGqGrXr5wbc5x6BoCXdNHsqdHW3Jh6BrwsMUJVa8xm46aLl0cm9RAAqEBXL3bjOpVNjFD11k6fFO9YMSf1DACoKG3NjfHq2VNTz4BTEiPUhA+ds8iTQgDgOa5a0BGNWR/1qGy+QqkJLQ25+L2Ll0c244ItAIiIuHqRp2hR+cQINeOs6ZPiHctnp54BAMnNaWuNldMmpJ4Br0iMUFM+dO5iT9cCoO554zrVQoxQU5pz2fj9S1a4XAuAupUJMUL1ECPUnNUdE+Odnq4FQJ1a3TExOsePST0DTosYoSZ98JxFMWeCy7UAqD9XL3bjOtVDjFCTmnPZ+G+XnBm5rMu1AKgfTblsXDG/I/UMOG1ihJq1ctqE+OA5i1LPAICyec2c9hjf1JB6Bpw2MUJNe9fKefGqWd4+C0B9eJtH3FNlxAg1LRMRN7/mzJjW2px6CgCU1KJJ42Lt9EmpZ8CwiBFq3sSWxvjYZSs97heAmvZ2Z0WoQmKEunDW9Enx/rULU88AgJIY39Tg3SJUJTFC3bhx9bw4r3Ny6hkAUHRvWjIzWhpyqWfAsIkR6kY2k4k/uHRlTBnTlHoKABRNJiLevswlWlQnMUJdmTymKf7gUvePAFA7XjV7asxq88Z1qpMYoe6c2zk5/u1ZC1LPAICieIcb16liYoS69L6zFsRrvaEWgCo3u601LvQ+LaqYGKEuZSLiv12yIs6YMj71FAAYsbctmxUuPKaaiRHqVktDLj555Ro3tANQlcY05OJNS2amngGjIkaoax1jW+ITV6yJppz/FACoLm9YNCPGNzWkngGj4hMYdW/ltAlx00XLU88AgGFx4zq1QIxARPzCohnx7lXzUs8AgNOydvqkWDhpXOoZMGpiBJ7ywXMWxSVz2lPPAIBX5KwItUKMwFNOvqH9TN9pAqCiTRvbEpfOnZZ6BhSFGIHnaG1siD+5yhO2AKhc71g+O3JZD/SlNogReIHOcWPiL16/NsZ5QgkAFaatuTHetmxW6hlQNGIEXsKSyePjk1d65C8AleWXV8yJ1kbfLKN2+KQFL2Pt9EnxPy5bFdmMU+EApDeuqSHeuWJO6hlQVGIETuE1c9vjpouWpZ4BAPHOFXNcQkzNESPwCq5ZMjM+fO7i1DMAqGOtjQ3xy86KUIPECJyGG1bNi+tXzk09A4A69fbls6KtuTH1DCg6MQKn6VfPWxJXL5qRegYAdWZMQy6uP3Ne6hlQEmIETlMmIn7v4hVxsbe0A1BGb1k2Kya2OCtCbRIjMAy5bCZuuXxVnNs5OfUUAOpAcy4bN6ycl3oGlIwYgWFqzmXjT686K84TJACU2HVLZ8XkMU2pZ0DJiBEYgeZcNv7kqrPi/JlTUk8BoEY15bJxw6p5qWdASYkRGKHmXDb+5Mo1cYEgAaAErlnSGdNam1PPgJISIzAKTblsfPLKNfGqWYIEgOJpyGbixlXzU8+AkhMjMEpNuWx84oo18apZU1NPAaBGvHFxZ0wf15J6BpScGIEiOBkkq+PVswUJAKOTy2biPaudFaE+iBEokqeDxHtIABiNqxd1Ruf4MalnQFmIESiixmw2Pv7aVXGJIAFgBMY05OIDZy9MPQPKRoxAkZ0MktXx+oXTU08BoMrcuHpeTPUELeqIGIESaMhm4qOXroxfWjEn9RQAqsT0cS1xvbetU2fECJRIJiJ+44Iz4oPnLEo9BYAq8OFzF0dzzkcz6ouveCixX1k9P37v4uWRzWRSTwGgQq3qmBhXLXB5L/VHjEAZXLNkZnziitXR5DteALxAJiJ+4/wlqWdAEj4ZQZlcMqc9/ucbzo7xTQ2ppwBQQd6waEasaJ+QegYkIUagjNZ0TIzPvvHcaPekFAAioqUhFx86d3HqGZCMGIEyWzRpXHz+TefFnAmtqacAkNgNq+bFNN+goo6JEUhgxriW+Pwbz4vl7W2ppwCQyLSxLXHDyrmpZ0BSYgQSmdjSGJ+9+tx4nZcjAtSl/3juomhpyKWeAUmJEUioOZeNj126Mj50zmKP/gWoI2e2T4jXL5yRegYkJ0agAty4el588so1MbbRk7YA6sGvX3BG+BYUiBGoGBfNnhp/c40b2wFq3esWTo9V0zzKFyLECFSUeRPHxt9cc35cOGtK6ikAlEBzLhsf9ihfeIYYgQozvqkh/uyqs+JdnrACUHP+/dkLo2NsS+oZUDHECFSgbCYTv3rekrj5NWdGU85/pgC14Mz2CXH9mb7RBM/lUw5UsF9YNCM+d/W5XogFUOWactn4/UtWeHIivIAYgQq3vL0tvnjt+bHSzY4AVevfr10Y8yeOTT0DKo4YgSowtbU5Pv0L58SbFnemngLAMC1vb3MfILwMMQJV4ulT/L9+wRlO8wNUiaZcNv7rxS7PgpcjRqDK/PKKOfGXr18bbc2NqacA8Ared9aCWDBpXOoZULHECFSh8zonxxevOT8WuP4YoGItm9oW7145L/UMqGhiBKrUrLYx8YVrzotL5rSnngLACzRms/FfL1kRuazLs+BUxAhUsdbGhvjjK9fEe9bMTz0FgOd431nzY6HLs+AViRGocpmI+MDZi+KWy1dFS0Mu9RyAurd0SlvcuMo3ieB0iBGoEVfM74jPv/HcmDGuJfUUgLrVkM3E77s8C06bGIEasmTK+PjitefH2umTUk8BqEvvXbMgFk92eRacLjECNWZSS1P89RvOjvesme+59gBltGTK+PiV1S7PguEQI1CDctlMfODsRfE/37A22lubU88BqHlNuZNPz2pweRYMixiBGnbOjMnx5V+80ON/AUrsNy9cGksmj089A6qOGIEaN6G5MT555Zr4zQuXRlPOf/IAxXbtkpnx5jNmpp4BVcknE6gTb18+O/7mmvNjvre2AxTNsqlt8VuvWpp6BlQtMQJ1ZPHkcfG3154f1/kOHsCoTWhujI+/drWzzjAK/uuBOtPSkIuPXLQ8brl8VYxvakg9B6AqZTOZ+NhlK73bCUZJjECdumJ+R/z9dRfG6o6JqacAVJ33r10YF8ycknoGVD0xAnVsxriW+OzV58T7zlrgnSQAp+mSOe3xK2u8TwSKQYxAnctmMvH+tQvjU79wdkwb63IDgFOZ3dYaN7/mzPDtGygOMQJERMTa6ZPiy9ddEJfOnZZ6CkBFamnIxR9dsTrGud8OikaMAM9oa26MT1yxOj526cqY1NKUeg5ARbnpouWxaNK41DOgpogR4EVet3B6fPUtr4rXL5yeegpARXjH8tl+T4QSECPAS5rY0hh/cOnK+NOrznIvCVDXVndMjF87/4zUM6AmiRHglC6aPTW++pYL4xeXznLDJlB3poxpij+8fFU0ZP0OCKUgRoBXNLaxIX7n1cvi01efE7PbWlPPASiLMQ25+MQVa2Jqa3PqKVCzxAhw2tZOnxRf/sUL44aV87yXBKhpjdls/NEVq2PltAmpp0BNEyPAsDTnsvHh8xbHF645LxZP9lQZoPZkM5n46KVnesM6lIEYAUZk+dS2+NtrL4j3r10YjVm/lQC147dftTSumN+RegbUBZ8ggBFryGbifWctiC9dd0GscikDUAM+dM7i+MWls1LPgLohRoBRWzBxbHzujefGb1xwRoxpyKWeAzAiN6ycFzeunpd6BtQVMQIURTaTiV9aMSf+4S2vcnkDUHWuXTIzPnze4tQzoO6IEaCoZoxriVsuXxWfufqcWDJ5fOo5AK/o8nnT4iMXLUs9A+qSGAFKYu30SfF3bz4/fufVy2JiS2PqOQAv6bzOyfGxy1Z6XDkkIkaAkslmMvGLS2fFP7/tovilFXMi5w3GQAU5s31CfOKKNZ4ICAn5rw8oufFNDfEbF5wRX77uwrhwluf2A+ktmDQu/vx1Z0Vro4duQEpiBCib+RPHxl+8bm188so1MaetNfUcoE51jhsTf/X6tdHW7BJSSE2MAGV3yZz2+MpbLowPn7c4WhsbUs8B6kh7a3P81RvWRntrc+opQIgRIJHGbDZuWDkvvv62V8c1SzrD3SRAqc2bODY+/6bzYrYzs1AxMhFRKOUBDh8+HBMnTizlIYAa8PCB7vjEnY/Fg3u7Uk8BatDqjonxJ1eucWkWDENXV1dMmjSppMcQI0BF+c6mPfHn92yMfcf7Uk8BasSlc6fFf79sZTTlXBACwyFGgLrUP5SPrz26I77w8y1xqLc/9Rygir1t2ez4zxee4T0iMAJiBKhrvYND8ZWHtscX12+N7hMDqecAVeYD5yyK96yen3oGVC0xAhARxwcG40vrn4wvbdgWxwcGU88BKlwum4nfvWh5vHFxZ+opUNXECMBzdJ8YiC+u3xpfeWh79A4OpZ4DVKDWxlz84eWrvWAVikCMALyEQ7398YWfb4mvPboj+ofyqecAFWLymKb4s6vOimVT21JPgZogRgBOYV/Pifhf92+OWx/fGYP5kv5WBlS4OW2t8RevXxszx49JPQVqhhgBOA27jvXGZ9dtjm8/sTvyBVEC9ebM9gnxp1edFRNbvEMEikmMAAzDtiM98en7N8Vtm/eKEqgTF89pj/9x2cpoacilngI1R4wAjMCmw8fiU/dtijue3Ffa3+CAZHLZTLx/7cJ496p53iECJSJGAEZhS9fx+NKGJ+NfntjtRneoIbPaxsTHLl0ZK9onpJ4CNU2MABTBod7++MrD2+Nrj2yPI16eCFXt6kUz4rdetTRaGxtST4GaJ0YAiqhvcCi+uXFXfGnDk7Gjuzf1HGAYxjU1xH951bJ43cLpqadA3RAjACWQLxTijif3x9+t3xoP7juSeg7wClZ1TIw/uPTM6Bznsb1QTmIEoMQe3NsVf7v+yfjBtv2ewAUVJpvJxHvXzI9/e9YCN6lDAmIEoEy2d/fE32/YFt/cuCv6BodSz4G6N31cS/zBpStjTYfPEJCKGAEosyMnBuKrD2+Pf3hkexzq7U89B+rSlfM74ncuWh7jm9ykDimJEYBE+ofy8e0ndseXNjwZW7uOp54DdaG1MRf/6YKlcc2SztRTgBAjAMkVIuKeXYfi64/tjO9v3RcDee8rgVI4s31C3HzpmTGnrTX1FOAp5YgR5z8BTiETEed1To7zOifHkRMD8e2Nu+Lrj+2Mzc6WQFG0tzbHB89ZFFcv7gy3qEP9cWYEYAQe3NsV//zYzrhty143vMMINOeyccOqeXHDqnkxpiGXeg7wElymBVDhjg8Mxnc27Yl/fnRnPHqwO/UcqHiZiHj9whnxoXMXRcfYltRzgFMQIwBV5LGDR+OfH9sR39m0J471D6aeAxVn1bQJ8esXnBFntk9IPQU4DWIEoAr1DQ7F7Vv2xtcf2xkP7O1KPQeSmz6uJf7jOYvjdQunp54CDIMYAahyW7uOxz8/tjO+/cSu6OobSD0Hyqq1MRc3rpof/2bl3GjOZVPPAYZJjADUiIF8Pn607UD86+Y98ePtB9z0Tk3LZjLxxsUz4gNnL4qprc2p5wAjJEYAalDf4FD8ZPuBuH3L3vjx9gPRK0yoIWunT4pfv2BJLJ3SlnoKMEpiBKDGnRjKPxMmP9q2X5hQtc7rnBzvWjkvLpw1JfUUoEjECEAdeW6Y/Hj7/ugZECZUtlw2E1fM74gbVs6LM6aMTz0HKDIxAlCnTgzl46c7nj1jIkyoJK2NuXjzkpnxS2fOjRnjvCsEapUYASD6h/Lxk2fC5ED0DHiHCWlMbW2OdyyfHW9ZOivamhtTzwFKTIwA8Dz9T50x+f7WfXHnzoNxsLc/9SRqXDaTiYtmT41rl8yMi2ZPjVw2k3oSUCZiBIBTeuLwsbhr58G4c+fBWLf7cJwYyqeeRI2Y3dYa1yzpjDf9//buJsaq+77j8PcMLzNgGF4GsMFAUhdsNwtatajYbRwvYktd1NgrR2LXKF2wqNRmU0WpUFSaRRdRSyu7jaq2C3YWkovTQCuz8qI1waqUVsHA2E5qyiDM61w8vHiG+XcxAwYMhJc59w/D80ijO9yZOb8fXlj3wzln7toVfj0vPKTECAC37bNL4/npsTN598jJ7D1yKgdPdtr9HzzTTu+Mnnz9Vx7NK089nt98rN0XIMD9T4wAcNfOXBjNT4ZO5t0jp7L3yMkcG7lQeyXuQ/29s/LsyoE8t2ppvrpqSebNnll7JeA+IUYAmDK/ODOSvUMTYfLe0dNuhH+IfWnBI3lu9ZJ8bfXS/Pqyhe4DAW5IjADQirHxkv/55Ez2Dp3KT4ZO5cCJTj5zv8m0NbOnyW88uihfW70kX129NKv759ZeCXgAiBEAumJsvOTD05/mZ8eHs/9EJ/tPdPLh6U9zadxdJw+qBb2z8rurluS51Uvz7OMDLr8C7pgYAaCai5fGc/Dk2ey/KlD+98yIm+LvY08sfCTPrV6a51YvzbplC9LTuPwKuHvdiBH/TALADfXO6Mm6ZQuybtmCK8+NjI7l/ROd7D8+ESf7j3cy9On5ils+vGbP6MmaxfPy9EB/nh6Yn2ceH8iK+XNqrwVwR5wZAeCenLkwmv0nhvOz4528f6KTn58ZydCn513iNYX6e2flqYH5eWpgfp5cPD9PD8zPlxc+4swH0CqXaQHwQLo0XnL00ws53DmXw51z+b/OuRw+ez6HO+dypHM+o+Nulr+Zx+b1TYTH4vl5aqA/Tw3Mz2Pz+mqvBTyEXKYFwANpRk+Tlf1zsrJ/Tp7NwDVfGy8lx0YuXgmVzz/O50jn3EPxLvJNkoV9s7N0bm/WLJ6XJxfPv3Lmo793Vu31ALpGjADQVT1Nk+Xz+rJ8Xl9+e8Xia75WkhwfuZDDnYmzKJ+MXEjns7F0Lo7m7OXHi6NXnrvffh3xnJkzMjB3dgbm9GbJ3N4MzJmdJXN6r3pu4nFx32zv7QEQMQLAfaRJsuyRvix7pC+/tfyXXxpw8dL4FwLl7GdjGb783FURc2FsPD1N0jRNZjQTUfT5R+7o87kzZ2TgcmxMPg7M6c3cWTPa/48EMI2IEQAeWL0zerJ0bm+Wzu2tvQoAd6Gn9gIAAMDDSYwAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAACWLbgwAAAG5klEQVRViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFWIEAACoQowAAABViBEAAKAKMQIAAFQhRgAAgCrECAAAUIUYAQAAqhAjAABAFa3HyOjoaNsjAACAKdaN1/E9SS62OeDYsWNtHh4AAGhBF17HX+xJcrrNCUNDQ20eHgAAaEEXXsef7knS6hQxAgAAD56jR4+2PWKoJ0mrU7rwlwAAAKZYF04qHG39zMgHH3zQ5uEBAIAWdOF1/FDrMbJ79+6UUtocAQAATKFSSnbv3t32mO5cprVv3742RwAAAFNo37593bjdov3LtJLkrbfeansEAAAwRbr0+n2oJ8mhtqfs2LEj4+PjbY8BAADu0fj4eHbs2NGNUYd6kgwmOdvmlIMHD2b79u1tjgAAAKbA9u3bc/DgwbbHnE0y2JRS0jTNniRfb3PaqlWrcujQofT19bU5BgAAuEsXLlzIk08+mcOHD7c9ak8p5cWeyT/8qO1phw8fzrZt29oeAwAA3KVt27Z1I0SS5K0kuXxm5MtJft72xP7+/rz33ntZu3Zt26MAAIA7MDg4mPXr16fT6XRj3JdKKR/3JEkp5RdJftr2xE6nk40bN2Z4eLjtUQAAwG0aHh7Oxo0buxUi/1VK+ThJeq56cmc3Jh84cCCbNm3y27UAAOA+MD4+nk2bNuXAgQPdGvnm5U+6HiNJsmvXrmzevDljY2PdGgkAAFxnbGwsmzdvzq5du7o59l8uf9KUUq482zTNx0lWdWuLF154IW+88UYWLVrUrZEAAECS06dP59VXX82ePXu6OfaDUsqVG8h7rvviP3Rzkz179mTDhg3dPCUEAAAPvQMHDmTDhg3dDpEk+cer/3B9jPwwyWfd2+Xzu/a3bNmSs2dbfe9FAAB4qJ09ezZbtmzJ+vXrMzg42O3xF3OrGCmlfJLk77u5UZKMjIxk69atWbNmTV5//XX3kgAAwBQaHR3Na6+9ljVr1mTr1q0ZGRmpscYPSynHr37imntGkqRpmiVJPkzS38XFrrFy5cq88sorefnll/P8889n1qxZtVYBAIAH0tjYWN55553s3Lkzb775ZrfezPBmOkl+tZRy4uonvxAjSdI0zXeT/EWXFrulhQsX5sUXX8wTTzyRFStWZMWKFVm+fHkeffTRzJw5s/Z6AABQ1djYWI4dO5ahoaEcPXo0Q0ND+eijj/L222/nzJkztde77M9KKd+//smbxcjcJINJVnRhMQAAYPoaSrK2lHLu+i9cfwN7kmTyG7/X8lIAAMD0970bhUhykzMjSdI0zYwk/53kKy0uBgAATF/7k6wrpVy60RdveGYkSSZ/4FtJxltaDAAAmL7Gk3zrZiGS3CJGkqSU8p9JfjDVWwEAANPeDyZ74qZuepnWlW+YuFzr35K8MIWLAQAA09eeJL93q7MiyW3ESJI0TbMoyd4ka6dmNwAAYJoaTLKhlHL6l33jLS/TumzyQC8lGb7HxQAAgOlrOMlLtxMiyW3GSJKUUg4m+UaSW55qAQAAHkqXknxjshtuy23HSJKUUv49ybfvdCsAAGDa+/ZkL9y2O4qRJCml/E2S79zpzwEAANPWdyY74Y7c1g3sN/zBpvmjJH+VZMZdHQAAAHjQXUryJ6WUv72bH77rGEmSpmleSPJGkkV3fRAAAOBBdDrJq6WUPXd7gHuKkSRpmmZNkreS/No9HQgAAHhQvJ9kYynlg3s5yB3fM3K9yQWeSfLjez0WAABw3/txkmfuNUSSKYiRJCmldJJsTPLn8at/AQBgOrqUidf7Gydf/9+ze75M6wsHbJoNSf4pyVem9MAAAEAt+5N8s5SydyoPOiVnRq42ueC6JH+YZGiqjw8AAHTNUCZe16+b6hBJWjgzcs3Bm2ZOkj9O8qdJFrQ2CAAAmErDSf4yyV+XUs63NaTVGLkypGkGknw3yeYkfa0PBAAA7saFJH+X5PullJNtD+tKjFwZ1jSLk/xBkm/GPSUAAHC/2J+J+77/uZRyqltDuxoj1wxumrVJXp78+J20cP8KAABwQ+NJ/iPJziQ7SymDNZaoFiPXLNE0S5P8fpKXMvGeJcvrbgQAANPO0STvJvlRkn8tpRyvvM/9ESPXa5pmeZK1mYiSFZMfy696XJykt9qCAABwf7mY5FQmgmPoBo+DpZSj9da7sf8H85yxGefe74kAAAAASUVORK5CYII=",
          fileName="modelica://ClaRa/Resources/Images/Components/Genericgeometry2.png")}));
end GenericGeometry;
