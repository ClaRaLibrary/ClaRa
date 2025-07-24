within ClaRa.Basics.Icons;
model Pipe
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -50},{100,50}}),
                   graphics={Bitmap(
          extent={{-100,-50},{100,50}},
          imageSource=
              "iVBORw0KGgoAAAANSUhEUgAAAjAAAAEYCAIAAADNhFv+AAAABmJLR0QA/wD/AP+gvaeTAAAJOUlEQVR4nO3bz4+VVx3H8YNh3xlhcMEKHFp++IumCxNrk6ZpQmIaY5gijGVaCjSQ+N9gIhHImAHH6RhxtGpImq6MiYtGhFBoqei6khTI7apuXEw6qdBBnLmX53PO83r9ASff1X3n+d5zNmyd3F1q8+Xx8YW5c7t3PtX1IABxrr//wcGZox/fudP1IP+3L3U9wFp8fOfO/ulXL1+52vUgAFkuX7m6f/rVGmtUKg1SKWUwGEwfeUOTAFZcvnJ1+sgbg8Gg60HWqNYglVIGg8HMsZPv3Xi/60EAunft+o3DR0/UW6NSdZBKKXfu3p360Wu+k4Ceu3zl6suvHLl7717Xg6xL3UEqdndA79W+qVtRfZCKJgE91kyNShtBKpoE9FJLNSrNBKloEtAzjdWotBSkoklAb7RXo9JYkIomAT3QZI1Ke0Eq3icBTWvgvdFqGgxS8T4JaFQb741W02aQit0d0JxWN3Urmg1S0SSgIc3XqLQdpKJJQBP6UKPSfJCKJgGV60mNSh+CVDQJqFZ/alR6EqSiSUCFelWj0p8gFe+TgKo0/N5oNT0KUvE+CahE2++NVtOvIBW7OyBe3zZ1KzZsndy9ziNe+t6+Z/buHco0n3f12nu/Xvrd0I9dNj42tjB3bs+unSM6H2Btrl2/cXDm6Oi+jaZ+8P2v71nvz/6D3r18+a0/XFrnIRvXP8fOyR3PP/fs+s+5z/PPPTuxedPps7NDP7l8trubn/3Z3m9+YxTnA6zBqL+NTh5//dDL+0dx8ieDT94q6w1S9Mpu+sDUiWNHRnS43R0Qpd4aDUt0kIomAf2gRiU/SEWTgNap0bIKglQ0CWiXGq0YwqWGx2P6wFQpZUR3HAaDwUtTh0ZxMkCHKqpRqeULadlIv5MAGlNXjUpdQSqaBPBoqqtRqS5IpZTpA1OHD/2w6ykAcs1MH6yuRqXGIJVSjh+Z8Z0E8IVOHn/92GuHu55iLaoMUrG7A/giNW7qVtQapGJ3B/DfKt3Urag4SMXuDuAz9W7qVtQdpGJ3B1D5pm5F9UEqmgT0Wxs1Km0EqWgS0FfN1Kg0E6TijgPQP7XfYrhPO0Eq7jgAfdLALYb7NBWkYncH9ENLm7oVrQWpaBLQuiZrVJoMUill+sDUvhdf6HoKgOHb9+ILTdaotBqkUsozT3+r6xEAhq/hH7dmgwRAXQQJgAiCBEAEQQIggiABEGFj1wNEm5k++JWJia6nABrx0e3bc/MLXU+RS5Ae5rvf+fZTO3Z0PQXQiA8+/FCQHsLKDoAIggRABEECIIIgARBBkACIIEgARBAkACIIEgARBAmACIIEQARBAiCCIAEQQZAAiCBIAEQQJAAiCBIAEQQJgAiCBEAEQQIggiABEEGQAIggSABEECQAIggSABEECYAIggRABEECIIIgARBBkACIIEgARBAkACIIEgARBAmACIIEQARBAiCCIAEQQZAAiCBIAEQQJAAiCBIAEQQJgAiCBEAEQQIggiABEEGQAIggSABEECQAIggSABEECYAIggRABEECIIIgARBBkACIIEgARBAkACIIEgARBAmACIIEQARBAiCCIAEQQZAAiCBIAEQQJAAiCBIAEQQJgAiCBEAEQQIggiABEEGQAIggSABEECQAIggSABEECYAIggRABEECIIIgARBBkACIIEgARBAkACIIEgARBAmACIIEQARBAiCCIAEQQZAAiCBIAEQQJAAiCBIAEQQJgAiCBEAEQQIggiABEEGQAIggSABEECQAIggSABEECYAIggRABEECIIIgARBBkACIIEgARBAkACIIEgARBAmACIIEQARBAiCCIAEQQZAAiCBIAEQQJAAiCBIAEQQJgAiCBEAEQQIggiABEEGQAIggSABEECQAIggSABEECYAIggRABEECIIIgARBBkACIIEgARBAkACIIEgARBAmACIIEQARBAiCCIAEQQZAAiCBIAEQQJAAiCBIAEQQJgAiCBEAEQQIggiABEEGQAIggSABEECQAIggSABEECYAIggRABEECIIIgARBBkACIIEgARBAkACIIEgARBAmACIIEQARBAiCCIAEQQZAAiCBIAEQQJAAiCBIAEQQJgAiCBEAEQQIggiABEEGQAIggSABEECQAIggSABEECYAIggRABEECIIIgARBBkACIIEgARBAkACIIEgARBAmACBu7HiDan/78l5s3b3U9BdCIj27f7nqEaIL0MHPzC12PANAXVnYARBAkACIIEgARBAmACIIEQIRmg/TuX//W9QgAw9fwj1ubQTp1+sylt9/pegqA4bv09js/OX2m6ylGosEgnTp95lcXl7qeAmBUFi8uNdmk1oJ0ZnZOjYDmLV5cOvvz811PMWRNBenM7Nz5X77Z9RQAj8Pc/EJjTWonSKdOn1EjoFfm5hda2t01EiT/GwH91NL/SS0ESY2APmumSdUHSY0A2mhS3UFypw5gWQP37ioOklsMAJ9X+x2HWoNkUwfwoKp3d1UGyaYOYDX17u7qC5JNHcDDVbq7qyxINnUAj6LG3V1NQVIjgEdXXZM2dj3AoxppjbZMTCxemJ3cvm1E5wOs5u//+OeBV4786/btURy+eHGplPLjE8dHcfjQ1fGFpEZAqya3b1u8MLtlYmJE51f0nVRBkNQIaJsmLUsPkhoBfaBJJTxIagT0hyYN4VLDlWvX1n/Ig27euvXb3/9xFCeXUsbHxs6fO61GQJTJ7dvmzv704MzRu/fujeL8xYtLn3767x1f3T70k4cSgg1bJ3ev/5S6+DYCko303l2y6JXdKKgREG7Uu7tY/QqSTR1QheXd3dgTT3Q9yGPVoyBtmZj4zZsX9uza2fUgAP/b13bvWlr8Ra++k/oSJJs6oDp92931IkhqBFSqV01qP0hqBFStP01qPEhqBDSgJ01qOUhqBDSjD01qNkhqBDSm+Sa1GSTvjYAmtf0+qcEgeW8ENKzh90mtBcmmDmheq7u7poKkRkBPNNmkdoKkRkCvtNekRoKkRkAPNdakFoKkRkBvtdSk6oOkRkDPNdOkuoPkvRFAaeV9UsVBmti8yXsjgGXL75MmNm/qepC1qzVI42Nj87NnfRsBrJjcvm1+9uz42FjXg6xRlUEaHxtbmDu3a+eTXQ8CkGXXzicX5s5V2qT/AGRxMoSmKQ3CAAAAAElFTkSuQmCC",
          fileName="modelica://ClaRa/Resources/Images/Components/Pipe.png")}), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-50},{100,50}})));

end Pipe;
