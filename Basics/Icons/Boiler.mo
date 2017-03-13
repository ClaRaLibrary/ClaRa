within ClaRa.Basics.Icons;
model Boiler "An icon for a boiler model - phisical units"
//___________________________________________________________________________//
// Component of the ClaRa library, version: 1.2.1                            //
//                                                                           //
// Licensed by the DYNCAP/DYNSTART research team under Modelica License 2.   //
// Copyright  2013-2016, DYNCAP/DYNSTART research team.                     //
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
            -100},{100,220}}),
                   graphics={Bitmap(
          extent={{-100,-100},{100,220}},
          imageSource=
              "iVBORw0KGgoAAAANSUhEUgAAAjAAAAOACAYAAAAkTEmuAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7N15lFTFocfxXw8zMAvKouzDECNbRHZJRBYVJCJBkIiiQSUGgyJGokTFSAImEIlGDSqLRDSoRFEMiIgQBGQTDbKLj1XCzLCJsiizwAzT7w8ZFAVm6+qquv39nPNOeCSpqvdO9fVbt7tvh8LhsACgOFIbNGkhabWh4VtmbtmwxtDYiAHsz9gSZ3sBAAAAJUXAAAAA7xAwAADAOwQMAADwDgEDAAC8Q8AAAADvEDAAAMA7BAwAAPAOAQMAALxDwAAAAO8QMAAAwDsEDAAA8A4BAwAAvEPAAAAA7xAwAADAOwQMAADwDgEDAAC8Q8AAAADvEDAAAMA7BAwAAPAOAQMAALxDwAAAAO8QMAAAwDsEDAAA8A4BAwAAvEPAAAAA7xAwAADAOwQMAADwDgEDAAC8Q8AAAADvEDAAAMA7BAwAAPAOAQMAALxDwAAAAO8QMAAAwDsEDAAA8A4BAwAAvEPAAAAA7xAwAADAOwQMAADwDgEDAAC8Q8AAAADvEDAAAMA7BAwAAPAOAQMAALxDwAAAAO8QMAAAwDsEDAAA8A4BAwAAvEPAAAAA7xAwAADAOwQMAADwDgEDoCTSbC8AOAP2ZwwhYACUxIO2FwCcAfszhhAwAIoltUGTrpIutr0O4FTYn7GHgAFQXMNtLwA4A/ZnjCFgABSJ0y1cxv6MTQQMgOKIxuk2NwpzIJjYnzGIgAFwRlE63b6fuWXDRsNzIIDYn7GLgAFQlGicbv8UhTkQTOzPGEXAADitKJ1uP8jcsmGu4TkQQOzP2EbAADiTaJxuH47CHAgm9mcMI2AAnFIUT7dzDM+BAGJ/goABcDqcbuEy9meMI2AAfA+nW7iM/QmJgAFwapxu4TL2JwgYACfjdAuXsT9RiIAB8F2cbuEy9ickETAAvoXTLVzG/sS3ETAAvo3TLVzG/sQJBAwASZxu4Tb2J76LgAFQiNMtXMb+xEkIGACcbuE09idOhYABIHG6hdvYn/geAgaIcZxu4TL2J06HgAHA6RYuY3/ilAgYIIZxuoXL2J84EwIGiG2cbuEy9idOi4ABYhSnW7iM/YmiEDBA7OJ0C5exP3FGBAwQgzjdwmXsTxQHAQPEJk63cBn7E0UiYIAYw+kWLmN/orgIGCD2cLqFy9ifKBYCBoghnG7hMvYnSoKAAWILp1u4jP2JYiNggBjB6RYuY3+ipAgYIHZwuoXL2J8oEQIGiAGcbuEy9idKg4ABYgOnW7iM/YkSI2CAgON0C5exP1FaBAwQfJxu4TL2J0qFgAECjNMtXMb+RFkQMECwcbqFy9ifKDUCBggoTrdwGfsTZUXAAMHF6RYuY3+iTAgYIIA43cJl7E9EAgEDBBOnW7iM/YkyI2CAgOF0C5exPxEpBAwQPJxu4TL2JyKCgAEChNMtXMb+RCQRMECwcLqFy9ifiBgCBggITrdwGfsTkUbAAMHB6RYuY38ioggYIAA43cJl7E+YQMAAwcDpFi5jfyLiCBjAc5xu4TL2J0whYAD/cbqFy9ifMIKAATzG6RYuY3/CJAIG8BunW7iM/QljCBjAU5xu4TL2J0wjYAB/cbqFy9ifMIqAATzE6RYuY38iGggYwE+cbuEy9ieMI2AAz3C6hcvYn4gWAgbwD6dbuIz9iaggYACPcLqFy9ifiCYCBvALp1u4jP2JqCFgAE9wuoXL2J+INgIG8AenW7iM/YmoImAAD3C6hcvYn7CBgAH8wOkWLmN/IuoIGMBxnG7hMvYnbCFgAPdxuoXL2J+wgoABHMbpFi5jf8ImAgZwG6dbuIz9CWsIGMBRnG7hMvYnbCNgAHdxuoXL2J+wioABHMTpFi5jf8IFBAzgJk63cBn7E9YRMIBjON3CZexPuIKAAdzD6RYuY3/CCQQM4BBOt3AZ+xMuIWAAt3C6hcvYn3AGAQM4gtMtXMb+hGsIGMAdnG7hMvYnnELAAA7gdAuXsT/hIgIGcAOnW7iM/QnnEDCAZZxu4TL2J1xFwAD2cbqFy9ifcBIBA1jE6RYuY3/CZQQMYBenW7iM/QlnETCAJZxu4TL2J1xHwAD2cLqFy9ifcBoBA1jA6RYuY3/CBwQMYAenW7iM/QnnETBAlHG6hcvYn/AFAQNEH6dbuIz9CS8QMEAUcbqFy9if8AkBA0QXp1u4jP0JbxAwQJRwuoXL2J/wDQEDRA+nW7iM/QmvEDBAFHC6hcvYn/ARAQNEB6dbuIz9Ce8QMIBhnG7hMvYnfBVvewFADIjG6faN1AZNWkRhHpixPnPLhmOW5mZ/oig29+dphcLhsO01AIF1/HT7ju11wGkfZG7Z0NbGxOxPFIO1/VkU3kICzIrG6RZ+s/nZEPYniuLsZ5cIGMCQKH22AH6z9tkQ9ieKwenPLhEwgDmcblEU7r7AZc7efZEIGMAITrcoBu6+wGVO332RCBjAFE63KAp3X+Ayp+++SAQMEHGcblEM3H2By5y/+yIRMIAJnG5RFO6+wGXO332RCBggojjdohi4+wKXeXH3RSJggEjjdIuicPcFLvPi7otEwAARw+kWxcDdF7jMm7svEgEDRBKnWxSFuy9wmTd3XyQCBogITrcoBu6+wGVe3X2RCBggUjjdoijcfYHLvLr7IhEwQJlxukUxcPcFLvPu7otEwACRwOkWReHuC1zm3d0XiYAByoTTLYqBuy9wmZd3XyQCBigrTrcoCndf4DIv775IBAxQapxuUQzcfYHLvL37IhEwQFlwukVRuPsCl3l790UiYIBS4XSLYuDuC1zm9d0XiYABSovTLYrC3Re4zOu7L5IUCofDttcAeCW1QZNykpraXgdK7QpJjxme44PMLRvaGp7jlNif3gv0/owkAgZATElt0GS5zL+9cpXvt+dhB/uz+HgLCUDMiNJnQ7z/bAHsYH+WDAEDIJZE47Mh3n+2ANawP0uAgAEQEzjdwmXsz5IjYADECk63cBn7s4QIGACBx+kWLmN/lg4BAyAWcLqFy9ifpUDAAAg0TrdwGfuz9AgYAEHH6RYuY3+WEgEDILA43cJl7M+yIWAABBmnW7iM/VkGBAyAQOJ0C5exP8uOgAEQVJxu4TL2ZxkRMAACh9MtXMb+jAwCBkAQcbqFy9ifEUDAAAgUTrdwGfszcggYAEHD6RYuY39GCAEDIDA43cJl7M/IImAABAmnW7iM/RlBBAyAQOB0C5exPyOPgAEQFJxu4TL2Z4QRMAC8x+kWLmN/mkHAAAgCTrdwGfvTAAIGgNc43cJl7E9zCBgAvuN0C5exPw0hYAB4i9MtXMb+NIuAAeAzTrdwGfvTIAIGgJc43cJl7E/zCBgAvuJ0C5exPw0jYAB4h9MtXMb+jA4CBoCPON3CZezPKCBgAHiF0y1cxv6MHgIGgG843cJl7M8oIWAAeIPTLVzG/owuAgaATzjdwmXszygiYAB4gdMtXMb+jD4CBoAvON3CZezPKCNgADiP0y1cxv60g4AB4ANOt3AZ+9MCAgaA0zjdwmXsT3sIGACu43QLl7E/LSFgADiL0y1cxv60i4AB4DJOt3AZ+9MiAgaAkzjdwmXsT/sIGACu4nQLl7E/LSNgADiH0y1cxv50AwEDwEWcbuEy9qcDCBgATuF0C5exP91BwABwDadbuIz96QgCBoAzON3CZexPtxAwAFzC6RYuY386hIAB4AROt3AZ+9M9BAwAV3C6hcvYn44hYABYx+kWLmN/uomAAeACTrdwGfvTQQQMAKs43cJl7E93ETAAbON0C5exPx1FwACwhtMtXMb+dBsBA8AmTrdwGfvTYQQMACs43cJl7E/3ETAAbOF0C5exPx1HwACIOk63cBn70w8EDAAbON3CZexPDxAwAKKK0y1cxv70BwEDINo43cJl7E9PEDAAoobTLVzG/vQLAQMgmjjdwmXsT48QMACigtMtXMb+9A8BAyBaON3CZexPzxAwAIzjdAuXsT/9RMAAiAZOt3AZ+9NDBAwAozjdwmXsT38RMABM43QLl7E/PUXAADCG0y1cxv70GwEDwCROt3AZ+9NjBAwAIzjdwmXsT/8RMABM4XQLl7E/PUfAAIg4TrdwGfszGAgYACZwuoXL2J8BQMAAiChOt3AZ+zM4CBgAkcbpFi5jfwYEAQMgYjjdwmXsz2AhYABEEqdbuIz9GSAEDICI4HQLl7E/g4eAARApnG7hMvZnwBAwAMqM0y1cxv4MJgIGQCRwuoXL2J8BRMAAKBNOt3AZ+zO4CBgAZcXpFi5jfwYUAQOg1DjdwmXsz2AjYACUBadbuIz9GWAEDIBS4XQLl7E/g4+AAVBanG7hMvZnwBEwAEqM0y1cxv6MDQQMgNLgdAuXsT9jAAEDoERSGzS5Upxu4Sj2Z+wgYACU1B+jMAenW5QW+zNGhMLhsO01APBEaoMmjSX9n+FpPsjcsqGt4TkQQOzP2MIdGAAlkRiFOTjdorTYnzGEgAHgEj5bAJexPx1CwABwCadbuIz96RACBoArON3CZexPxxAwAFzxiO0FAGfA/nQMAQPAFem2FwCcAfvTMQQMAADwDgEDAAC8Q8AAAADvEDAAAMA7BAwAAPAOAQMAALxDwAAAAO8QMAAAwDsEDAAA8A4BAwAAvEPAAAAA7xAwAADAOwQMAADwDgEDAAC8Q8AAAADvEDAAAMA7BAwAAPAOAQMAALxDwAAAAO8QMAAAwDsEDAAA8A4BAwAAvEPAAAAA7xAwAADAOwQMAADwDgEDAAC8Q8AAAADvEDAAAMA7BAwAAPAOAQMAALxDwAAAAO8QMAAAwDsEDAAA8A4BAwAAvEPAAAAA7xAwAADAOwQMAADwDgEDAAC8Q8AAAADvEDAAAMA7BAwAAPAOAQMAALxDwAAAAO8QMAAAwDsEDAAA8A4BAwAAvEPAAAAA7xAwAADAOwQMAADwDgEDAAC8Q8AAAADvEDAAAMA7oTr1LwjbXgQAAEBJcAcGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeCfe1MBXdLpMzS9sYmp4AADguLUfb9C7C94zMraxgGl+YRP17N7N1PAAAMADpgKGt5AAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3iFgAACAdwgYAADgHQIGAAB4h4ABAADeIWAAAIB3CBgAAOAdAgYAAHiHgAEAAN4hYAAAgHcIGAAA4B0CBgAAeIeAAQAA3om3vQAAwZF75IhysnOUnZOj7OxsSVJycrKSk5KUlJykxAoVLK8QQFAQMABOEg6Hte/zz5WesVMZO3fqq6++Uva3ouTrf81RTk7OiT9n53z9vxcUFJxx7Li4OCUlJSk5KUnJyV//a9K3/lwYO8nJSTrrrLNUt04dpdWto2rnnqtQKBSl/w8A8AEBA8SonJwcZezcpfSMTGVkZio94+v/ydi5S7m5uUbmLCgoUFZWlrKyskr030tMTFTdOrWVVjdVaXVTVTf1+L/Wqa2kpCQjawXgNgIGCLg9e/cqPWOn0jMylJ6580Sw7Pv8C9tLK7bc3Fxt2faptmz79Hv/XrVzzzkRNGmpdZRWt67S6tZRzRo1LKwUQLQQMEDAfP7Ffq1eu1arVq/TyjVrtWfvXttLMmrf519o3+dfaNWatSf9fc0aNdS6RXO1atlMLZs317nnVLW0QgAmEDCA5w4eOqTVa9dr9dp1WrV6rdIzM20vyQl79u7V23P/o7fn/keSlJaaqlYtm6tl82Zq2bypKleqZHmFAMqCgAE8c/hwltau/1gr16zVqjVrtf1/OxQOh20vy3npmZlKz8zUjLfeVigU0nk/qKdWLZqrdYvmat70QlWsmGJ7iQBKgIABPLBx02YtWrpMK1ev1eYtW1VAsJRJOBzWp9v/p0+3/0/Tpr+puFBIDRvUV+uWzXVp+3Zq3Kih7SUCKAIBAzhqz97PNG/BQs19d4HSM3hbyKSCcFgbN2/Rxs1bNGXqNKXVTdWVV3RSl06Xq2aN6raXB+AUCBjAIVnZ2Xpv8VLNfXeB1q7/mLeGLEnPyNQ/XnhRz/3zJTVveqGuvKKTLuvYXinJybaXBuA4Agaw7NixY/rvR6s0990FWrr8Ax09etT2knBcOBzWmnXrtWbdej35zHi1b3uxrryik358USuVK1fO9vKAmEbAAJZs2rJVc+fN1/z3FuvAwYO2l4MiHD16VAsWLdaCRYtVpXJldb6so67s0lmNGtS3vTQgJhEwQBR9dfiw3po9R+/8513tSM+wvRyU0oGDBzVtxkxNmzFT9dLq6qqfXqGru3XVWRUr2l4aEDMIGCAKDhw4qKlvTNeMt95Wdk6O7eUggnakZ2jCcy/oxSmv6pqrf6Y+1/ZSlSqVbS8LCDwCBjDos3379Mrrb2jWO3N15AifbQmy7Jwc/eu1aXrjzZnqftWVuvG6a1W9WjXbywICi4ABDNi5a7emTH1dc+fNV15+vu3lIIqOHDmqN2a8pZmz3tGVXTqrb5/rVKd2LdvLAgKHgAEi6H870vXSK69p/nuLVFBQYHs5sCgvP1+z3pmr2XPnqfNll+rmG6/XD+ql2V4WEBgEDBABm7du04v/elVLli3n2S04SUFBgeYtWKh3F76nDu3a6pZf3KCG9c+3vSzAewQMUAbrPt6gl16Zqg9XrLS9FDguHA5r8dL3tXjp+/pJm9a6+cY+anZhE9vLArxFwAClkLlzl558ZrxWrFxleynw0IcrVurDFSvVpnUr3XPXQKXWqW17SYB34mwvAPDJ0aNH9fyLL6vfgDuJF5TZipWr1G/AnXr+xZd5AjNQQgQMUEwfrPhI/QbcqX++/Iry8vJsLwcBkZeXp3++/Ir6DbhTH6z4yPZyAG/wFhJQhM/27dNT4ydq8dL3bS8FAbZz127d/9BwdWx/ie4eOIBnyABFIGCA0zh27Jhe+/cMvfDSv5Sbm2t7OVZVqVxZZ599lpKTkpScnKykpMRv/pyYqOTkJCUnHf/75CQlJyUpKSlJkpSTk6PsnBxlZ+coJydX2TnZX/85N1fZ2dnKzjn+98f//OWXX8X0b0MtXvq+/vvRKt168y90/c+v4UcjgdMgYIBTWPfxBj0+Zqy279hheylRk5CQoNQ6tZVWN1Vpqamqm1pH9dLqKi21jlJSUqK6lqysLKVn7tSO9AxlZO5Uemam0jMylblzV0y8fZebm6vx/3hec/4zX0MGD+LbSsApEDDAtxw8dEjjJk7SnHnzbS/FmJTkZDVsUP+bUKlbR2mpqapZs4biQiHby5MkpaSk6EeNGupHjRqe9PcF4bD27Nmr9MxMZWR8Ezabt2xVVna2pdWas33HDt117/3q2qWz7hzQX5UrVbK9JMAZBAxw3Fuz52jCcy/oq8OHbS8loipUKK+mTS5QqxbN1apFczVu2EBxcX5+fj8uFFLtWjVVu1ZNXdzmohN/X1BQoI2bt2jVmrVatWat1m/4JFC/PTVn3nwtW/6h7rjtVl3dravt5QBOIGAQ87Kys/XoE2O0cPFS20uJiPj4eF3QuJFatWimVi2aq8mPGishIcH2soyKi4vTBY0b6YLGjXTTDdcrLy9PG/5v4/GgWadPNm5Svue/SfXV4cN67O9P66NVq3X/vYOVkpxse0mAVQQMYtrmrds0fOQj2rlrt+2llFpcKKQG9c9XqxbN1bplCzW78AIlJibaXpZVCQkJatGsqVo0a6pf3fL1Z0rWffyJVq5eo1Vr1mrL1m0q8PQnHxYuXqrNW7fp4WEP8pMEiGkEDGLW9Jmz9Myzz3n7odCG9c9X1y6ddUWny/hsRBESExP144ta6ccXtZL09Wed3l3wnubMm6/NW7dZXl3J7dy1WwMHD9Fdt9+mXj26214OYAUBg5iTlZWl0U+M0aIly2wvpcTOPaeqftq5k67s0knn1atnezneqlypknr36qnevXpq+44dmjtvgf4zf4E+/2K/7aUVW15enp58ZrxWrV2nofcOjvo3xQDbCBjElI2bt2jEqNHatXuP7aUUW2KFCurQ7hJ17dJJrVu1dOabQkFxXr16uuO2WzWg/y+1ctVqzZm3QEuWva/cI0dsL61YFi1Zpi1bt2nEQ0PVuGED28sBooaAQcyYNmOmxk+cpDwPPswZCoXUollTde3SWZd2aKfk4w+FgzlxoZDatG6lNq1bKTsnR4uWLNOcefO1Zt16hR3/vMyu3Xs06Le/08AB/dX7mh62lwNEBQGDwDt8OEujH39Si5ctt72UIqUkJ6tXj+7q2b2balTnUfK2JCcl6aqfXqGrfnqF9n62T2/Omq3pM2c5/ayZvPx8PTXuWa1Zu05Dh9yjihV5SwnBRsAg0DZu2qzho0Zr9569tpdyRpUqna3revXUtT2v5rMMjqlRvZoG/Kqf+vbprTfefEuvT39Thw59aXtZp7V42XJt2fapHn5oqBp/50GAQJD4+TQroBjemj1Hd95zn9Pxcu45VTXo9tv0+ksv6JZf3EC8OCwlJUW3/OIGvf7SCxp0+20695yqtpd0Wrv37NWd99ynt2bPsb0UwBjuwCCQJk95RZMmv2x7GadVs0YN9e3TW92u7BL4h8wFTWJiovpc20s/79Fds+fO05Sp07Rnr3uRnJ+fr8f+/rT2Hzigfn1vtL0cIOIIGARKQTisMWMnaPrMWbaXckppdVN10w3Xq0uny/iVYc8lJCSoZ/du6n7VlZq34D29/OprSs/ItL2s75k0+WXtP3BQgwfdwTfYECgEDAIjLz9fI//6Ny1ctMT2Ur7n/B+ep359b1DH9u34h0jAlCtXTl27dNZPr+ikxUuXafKUV7Xt0+22l3WS6TNn6eChQxr2wO+UEM9lH8HATkYgZOfk6KERI7Vy9RrbSzlJSkqKbut3s3r1+Jm3P6CI4okLhXRZh/bq2O4STZ/5tp6b/JKysrJsL+uEhYuW6Msvv9KoEcP4Wj4CgSsqvHfg4EHdPeQB5+KlS6fLNWXSs7r2mquJlxgSFxena6+5WlMmPasunS63vZyTrFy9RncPeUAHDh60vRSgzLiqwmu79+zVnb+9z6nfs6mXVldjHhutPwz9napWrWJ7ObCkatUq+sPQ32nMY6NVL62u7eWcsHnrNt35W7e/nQcUBwEDb239dLsG/naIdu7aZXspkr7+dsrt/W/VCxOeUcvmTW0vB45o2bypXpjwjG7vf6szvxK+c9cuDfztEG117LM6QEkQMPDSmnXr9ZshD2j//gO2lyJJ6tiurV56boL69umteD4kie+Ij49X3z699dJzE9SxXVvby5Ek7d9/QL8Z8oDWrFtveylAqRAw8M6iJcs05ME/OPEBydq1aurRkSM0cvgwHv2PItWoXk0jhw/ToyNHqHatmraXo6ysLA158A9e/jI7QMDAK4uWLNPwkY8oLy/P9lLUs3s3vfiP8br4x21sLwWeufjHbfTiP8arZ/dutpeivLw8DR/5CBED7xAw8Maadev1p9GPqcDyLwOnJCfr4WEPasjdg1S+fHmra4G/ypcvryF3D9LDwx5USnKy1bUUhMP60+jHeDsJXiFg4IWtn27Xg8P/bP3OS6MG9fXcuKd0ecf2VteB4Li8Y3s9N+4pNWpQ3+o68vLy9ODwP/PBXniDgIHzdu/Zq9/93v5nXnpf00PjxjyuOrVrWV0HgqdO7VoaN+Zx9b6mh9V1ZGVl6Xe//wNfsYYXCBg47cDBg7p36DCr3zaqWDFFo0YM09133s5j2GFMQny87r7zdo0aMUwVK9r7VfL9+w/o3qHDeNgdnEfAwFnZOTm67/d/tPqclwsaN9Lz459Rh0vc+Oorgq/DJW31/PhndEHjRtbWsHPXLt33+z8qOyfH2hqAohAwcFJefr4eGjHS2hN2Q6GQ+vT+uZ554lHVrFHdyhoQu2rWqK5nnnhUfXr/XCFLP/65ees2PTRipPLy863MDxSFgIFzCsJhjfzr36z9tlHFiika/afhGjSgPw+lgzXx8fEaNKC/Rv9puLW3lFauXqORf/2b9W/+AadCwMA5Y8ZO0MJFS6zN3/f669T2JzzbBW5o+5M26nv9ddbmX7hoicaMnWBtfuB0CBg4ZfKUVzR95iyra/jHP1/UvAULra4BKDRvwUL9458vWl3D9JmzNHnKK1bXAHwXAQNnvDV7jiZNftn2MlRQUKBRjz5BxMC6eQsWatSjT6igoMD2UjRp8st6a/Yc28sATiBg4ISNmzbrVqERAgAAIABJREFUyWfG217GCUQMbHMpXgo9+cx4bdy02fYyAEkEDBxw+HCWho8arXzHvu1AxMAWF+NFkvLz8zV81GgdPmz/h1QBAgbWjX78SWef/EnEINpcjZdCu/fs1ejHn7S9DICAgV3TZszU4mXLbS/jjIgYRIvr8VJo8bLlmjZjpu1lIMYRMLBm4+YtGj9xku1lFAsRA9N8iZdC4ydO0sbNW2wvAzGMgIEVWVlZGjFqtFdP+SRiYIpv8SJ9/bTsEaNGW/+RVcQuAgZWjH5ijHbt3mN7GSVGxCDSfIyXQrt279HoJ8bYXgZiFAGDqJs+c5YWLVlmexmlRsQgUnyOl0KLliyz/vBJxCYCBlG1ees2PfPsc7aXUWZEDMoqCPFS6Jlnn7P2w6uIXQQMoiYrO1vDRz6ivLw820uJCCIGpRWkeJGkvLw8DR/5iLKys20vBTGEgEHUPPrEGO3ctdv2MiKKiEFJBS1eCu3ctVuP8nkYRBEBg6h4a/YcLVy81PYyjCBiUFxBjZdCCxcv5feSEDUEDIw7eOiQJjz3gu1lGEXEoChBj5dCE557QQcPHbK9DMQAAgbGjZs4SV8dPhyVuSpWTNHtv/ql4uKiv7WJGJyOzXiJi4vT7b/6pSpWTInKfF8dPqxxnjygEn4jYGDUuo83aM68+VGZKxQK6Q8P3Ke+N1ynh+6/l4iBE2zHy0P336u+N1ynPzxwn0KhUFTmnTNvvtZ9vCEqcyF2ETAw5tixY3p8zNiozXf9tb3U9idtJEldOl1OxMA6F+KlS6fLJUltf9JG11/bK2rzPz5mrI4dOxa1+RB7CBgY89q/Z2j7jh1RmeuCxo10+6/6nfR3RAxscileCt3+q366oHGjqKxh+44deu3fM6IyF2ITAQMjPtu3Ty+89K+ozFWxYopGPDRU8fHx3/v3iBjY4GK8SFJ8fLxGPDQ0ap+HeeGlf+mzffuiMhdiDwEDI54aP1G5ublRmevB392jmjWqn/bfJ2IQTa7GS6GaNarrwd/dE5X15Obm6qnxE6MyF2IPAYOI+2DFR1q89P2ozNX7mh7qcEnbIv9zRAyiwfV4KdThkrbqfU2PKKxKWrz0fX2w4qOozIXYQsAgoo4ePaoxYydEZa5GDepr4ID+xf7PEzEwyZd4KTRwQH81alDf4Kq+MWbsBB09ejQqcyF2EDCIqJdffS0qPxeQkpysEQ8NVcIpPvdyJkQMTPAtXiQp4fjnYVKSkw2t7Bs7d+3Wy6++ZnwexBYCBhGTuXOXpkydFpW57r93sOrUrlWq/y4Rg0jyMV4K1aldS/ffOzjCqzq1KVOnKXPnrqjMhdhAwCBinnxmfFR+abpn9266vGP7Mo1BxCASfI6XQpd3bK+e3btFaFWnl5eXpyefGW98HsQOAgYRse7jDVqxcpXxeWrXqqnf3PHriIxFxKAsghAvhX5zx69Vu1bNiIx1JitWruIJvYgYAgYR8dIrU6Myz28H3aHy5ctHbDwiBqURpHiRpPLly+u3g+6I2HhnEq1rBYKPgEGZbd66TR+uWGl8no7t2uriH7eJ+LhEDEoiaPFS6OIft1HHdkU/kqCsPlyxUpu3bjM+D4KPgEGZvfivV43PkZiYqN8MvN3Y+EQMiiOo8VLoNwNvV2JiorHxC0XjmoHgI2BQJv/bka4ly5Ybn6df3xtVo3o1o3MQMTiToMeLJNWoXk39+t5odA5JWrJsuf63I934PAg2AgZl8tIrrykcDhudo15aXfW59hqjcxQiYnAqsRAvhfpce43qpdU1Okc4HNZLr/BcGJQNAYNS27lrt+a/t8j4PPf+ZtApf6jRFCIG3xZL8SJ9/YOP9/5mkPF55r+3KCoPvURwETAotSlTXzd+Ue/S6XK1bN7U6Bynm5eIQazFS6GWzZsan7egoEBTpr5udA4EGwGDUvls3z7NnTff6BwpKSkaVILfOoo0Iia2xWq8FBo0oL9SUlKMzjF33nx9tm+f0TkQXAQMSuWV199QXn6+0Tlu63ezqlatYnSOohAxsSnW40WSqlatotv63Wx0jrz8fL3y+htG50BwETAosQMHDmrWO3ONznH+D89Trx4/MzpHcRExsYV4+UavHj/T+T88z+gcs96ZqwMHDhqdA8FEwKDEpr4xXUeOHDU6R7++N1gJhtMhYmID8XKyuLg49et7g9E5jhw5qqlvTDc6B4LJnX9CwAtfHT6sGW+9bXSOtLqp6ti+ndE5SoOICTbi5dQ6tm+ntLqpRueY8dbb+urwYaNzIHgIGJTIW7PnKDsnx+gcN91wveJCIaNzlBYRE0zEy+nFhUK66Ybrjc6RnZOjt2bPMToHgoeAQYm88593jY5fs0YNdel0mdE5yoqICRbipWhdOl2mmjVqGJ3D9LUFwUPAoNg2bdmqHekZRufo26e3ypUrZ3SOSCBigoF4KZ5y5cqpb5/eRufYkZ6hTVu2Gp0DwULAoNhMP/fl3HOqqtuVXYzOEUlEjN+Il5LpdmUXnXtOVaNzmL7GIFgIGBTLsWPHNP+9xUbn6NP750pISDA6R6QRMX4iXkouISFBfXr/3Ogc899brGPHjhmdA8FBwKBY/vvRKh04aO5ZDZUqna2eP7vK2PgmETF+IV5Kr+fPrlKlSmcbG//AwYP670erjI2PYCFgUCxz311gdPzrevVUYmKi0TlMImL8QLyUTWJioq7r1dPoHKavNQgOAgZFysrO1tLlHxgbPyU5Wdf2vNrY+NFCxLiNeImMa3terZTkZGPjL13+gbKys42Nj+AgYFCk9xYv1dGj5p6826tHd+M/GhctRIybiJfISUlJUa8e3Y2Nf/ToUb23eKmx8REcBAyKZPKWbigUUs/u3YyNbwMR4xbiJfJ6du+mkMGHTfI2EoqDgMEZ7dn7mdau/9jY+C2aNVWN6tWMjW8LEeMG4sWMGtWrqUWzpsbGX7v+Y+3Z+5mx8REMBAzOaN6ChQqHw8bG79qls7GxbSNi7CJezDL52g2HwzG9d1E8BAzOyOSt3MQKFXRpB/d+tDGSiBg7iBfzLu3QTokVKhgbn7eRUBQCBqe1cdNmpWdkGhu/Q7tLlJyUZGx8VxAx0UW8REdyUpI6tLvE2PjpGZnauGmzsfHhPwIGp7Vo6TKj43ft0sno+C4hYqKDeIku069h09cg+I2AwWmtXL3W2NjnnlNVrVu1NDa+i4gYs4iX6GvdqqXR30cyeQ2C/wgYnNLhw1nabPCXYX/auZPiDH4N01VEjBnEix1xoZB+2tncXZjNW7bq8OEsY+PDbwQMTmnt+o9VYPDbR1fG0NtH30XERBbxYpfJ13JBOGz0MQ7wGwGDU1q5xtyt24b1z9d59eoZG98HRExkEC/2nVevnhrWP9/Y+CavRfAbAYNTWmXwohHkZ7+UBBFTNsSLO0y+pk1ei+A3Agbfc/DQIW3/3w4jY8eFQrqi02VGxvYREVM6xItbruh0mbHPtG3/3w4dPHTIyNjwGwGD71m9dr2xp+82qH++KleqZGRsXxExJUO8uKdypUpqYOhtpHA4rNVr1xsZG34jYPA9q9euMzZ2qxbNjY3tMyKmeIgXd5l8bZu8JsFfBAy+Z5XBZy+0btnC2Ni+I2LOjHhxm8nXtslrEvxFwOAkn3+xX+mZZn4+ID4+Xs0uvMDI2EFBxJwa8eK+ZhdeoPj4eCNjp2dm6vMv9hsZG/4iYHCS1WvNnXQuaNxIiYmJxsYPCiLmZMSLHxITE3VB40bGxjd5bYKfCBicZNVqk59/aWZs7KAhYr5GvPjF5Gvc5LUJfiJgcBKTD43iA7wlE+sRQ7z4x+RrnAfa4bsIGJywZ+9e7dm718jYFSqUV5MfNTYydpDFasQQL35q8qPGqlChvJGxTV6f4CcCBiekZ+w0NnbTJhcoISHB2PhBFmsRQ7z4KyEhQU2bmPugvslrFPxDwOCE9IwMY2Pz9lHZxErEEC/+M/laN3mNgn8IGJyQnmnudEPAlF3QI4Z4CQajAWPwGgX/EDA4IT3DzPNfUpKT1bhhAyNjx5qgRgzxEhyNGzZQSnKykbFNXaPgJwIGJ2QYeoBdwwb1rfwDN6iCFjHES7DExcWpYYP6RsY2dY2Cn/inCiRJOTk52vf5F0bGTqubamTcWBaUiCFegsnUa37f518oJyfHyNjwDwEDSVLGzl3Gxk5LJWBM8D1iiJfgMvmaN3mtgl8IGEgy+95y3bp1jI0d63yNGOIl2Ey+5vkcDAoRMJBk9r1l7sCY5VvEEC/BZ/QODJ+DwXEEDCSZO9UkJCSoZs0aRsbGN3yJGOIlNtSsWcPYgyu5A4NCBAwkmbsopNaprbhQyMjYOJnrEUO8xI64UEipdWobGZuAQSECBgqHw8Y+GMc3kKLL1YghXmKPqdd+xs5dCofDRsaGXwgYaN/nnys3N9fI2Hz+JfpcixjiJTaZeu3n5uZq3+efGxkbfom3vQDYZ/IH0uqm8g0kGwr/gW0jHAojphDxEptMvvbTM3aqerVqxsaHHwgYKGOnuYCpl1bX2Ng4M9sRM/Kvj0uSldv9xIt9Jl/7GTt36qJWLYyNDz8QMNBXX31lbOw07sBYZTNibH1OgXhxg8nXvslrFvzBZ2Cg7Gwzj+auUrmyUlJSjIyN4rP5mZhoI17ckZKSoiqVKxsZ29Q1C34J/hUNRco29NsiZ599lpFxUXKxEDHEi3tMXQNMXbPgl+BezVBs2dnZRsZNTkoyMi5KJ8gRQ7y4ydQ1wNQ1C34J3pUMJWbqNJOcnGxkXJReECOGeHGXqWsAd2AgETCQufeTk5ISjYyLsglSxBAvbjN1DeAzMJAIGEjKMXUHhreQnBWEiCFe3GfqGmDqmgW/+Hv1QsTwFlJs8jliiBc/8BYSTPLvyoWIM/YWUiJvIbnOx4ghXvxh6hrAW0iQCBjI5B0Y3kLygU8RQ7z4xdQ1gDswkAgYyORnYHgLyRc+RAzx4h9T1wA+AwOJgIl5uUeOGHvEPN9C8ovLEUO8+MnUNaCgoEC5R44YGRv+cO9KhajKMfheMm8h+cfFiCFe/GXyGmDy2gU/uHOVghUm30vma9R+ciliiBe/mbwG8DkY2L9CwSqTj+ROImC8VRgxoVDI2hpCoRDx4jmT1wB+TgAEDAAA8A4BE+NMPmyObwr4a96ChRr16BMKh8PW1hAOhzXq0Sc0b8FCa2tA2Zi8BvCgTBAwMY73qPFdhfFi6ttpJVFQUEDEeIzP2MEkAibGJRn8lgBPy/SPS/FSiIjxl8lrgMlrF/xAwMS4xAoVjH3bJCcn18i4MMPFeClExPjJ1DUgLi5OiRUqGBkb/iBgYOybAtk5fEvAFy7HSyEixj+mrgF8wxESAQOZey+Zt5D84EO8FCJi/GLqGsDnXyARMJC5p2Xm5PIWkut8ipdCRIw/TF0DeMo3JAIGMnkHhreQXOZjvBQiYvxg6hrAHRhIBAxk8jMwvIXkKp/jpRAR4z5T1wA+AwOJgIEMvoXEt5CcFIR4KUTEuM3UNYC3kCARMBBvIcWSIMVLISLGXbyFBJMIGBh7JDdvIbkliPFSiIhxk6lrAD8jAImAgcydZr788isj46LkghwvhYgY95i6BnAHBhIBA5l7P/nAwYPKysoyMjaKLxbipRAR446srCwdOHjQyNh8BgYSAQNJZ511lrGx0zN3GhsbRbMZL6FQSKFQKOrzEjFuMPnaN3nNgj8IGKhunTrGxt6RnmFsbJyZzXiJi4vTsAeGaNgDQ4z91taZEDH2mXztm7xmwR/xthcA+9LqmrsYZHAHxgrb8fLQ/feqS6fLT/ydjbUURoykk9aC6DD52jd5zYI/uAMDVTv3XCUmJhoZOz0z08i4OD3X4qVLp8v10P33cicmxph67ScmJqrauecaGRt+IWCgUCikunVqGxk7PYOAiSbX4qUQERN7TL3269apbeWzVXAPAQNJUlrdVCPjZu7cpYJw2MjYOJmr8VKIiIkdBeGwMnfuMjK2qWsV/EPAQJK5i0JeXp727NlrZGx8w/V4KUTExIY9e/YqLy/PyNgEDAoRMJAk1U01d1HgczBm+RIvhYiY4DP5mjd5rYJfCBhIMnuqycjgm0im+BYvhYiYYDP5mucODAoRMJAkYx/ilbgDY4qv8VKIiAkuo3dgDF6r4BcCBpKkpKQkVTv3HCNj802kyPM9XgoRMcFk6jVf7dxzlMTvIOE4AgYnmHpvefOWrTHxOzzREpR4KUTEBEtBQYE2b9lqZGw+/4JvI2Bwgqn3lrOys7Vx8xYjY8eaoMVLISImODZu3qKs7GwjY/P5F3wbAYMT0lLNPZ571Zq1xsaOFUGNl0JETDCYfK2bvEbBPwQMTkirW9fY2ARM2QQ9XgoRMf4zGjAGr1HwDwGDE0z+QNr6DZ8Ye7BV0MVKvBQiYvyVl5en9Rs+MTY+P+KIbyNgcELNGjVUs0YNI2MfOXJUG/5vo5GxgyzW4qUQEeOnDf+3UUeOHDUytsnrE/xEwOAkrVs0NzY2byOVTKzGSyEixj8mX+Mmr03wEwGDk7Rq2czY2KvWrDM2dtDEerwUImL8YvI1bvLaBD8RMDhJy+bmTjmfbNyk3NxcY+MHBfFyMiLGD7m5ufpk4yZj45u8NsFPBAxOcu45VZVm6GFR+fn5WvexuQ/4BQHxcmpEjPvWffyJ8vPzjYydlpqqc8+pamRs+IuAwfe0amnupLNy9RpjY/uOeDkzIsZtJl/bJq9J8BcBg+9p2dzk52D4IO+pEC/FQ8S4y+Rr2+Q1Cf4iYPA9LZs3VSgUMjL2lq3bdPDQISNj+4p4KRkixj0HDx3Slq3bjIwdCoXUsnlTI2PDbwQMvqdypUo67wf1jIxdEA7r3QXvGRnbR8RL6RAxbnl3wXsqCIeNjH3eD+qpcqVKRsaG3wgYnFIrg89cmDNvvrGxfUK8lA0R4w6Tr2mT1yL4jYDBKZl8aNTmrdu0fccOY+P7gHiJDCLGvu07dmizobePJB5gh9MjYHBKzZteqDhDn4ORpLnzFhgb23XES2QRMXaZfC3HhUJq3vRCY+PDbwQMTqlixRQ1bFDf2Pj/mb/A2HvmLiNezCBi7CgIh/Wf+eYCpmGD+qpYMcXY+PAbAYPTam3w2Quff7FfK1etNja+i4gXs4iY6Fu5arU+/2K/sfFNXoPgPwIGp3Vp+3ZGx58TQ28jES/RQcREl+nXsOlrEPxGwOC0GjdqqLS6Zn5WQJKWLHtf2Tk5xsZ3BfESXURMdGTn5GjJsveNjZ9WN1WNGzU0Nj78R8DgjK68opOxsXOPHNGiJcuMje8C4sUOIsa8RUuWKffIEWPjm7z2IBgIGJxRl06XG3sqrxTsZ8IQL3YRMWaZfO2GQqGY3rsoHgIGZ1SzRnWjX2Ncs2699n62z9j4thAvbiBizNj72T6tWbfe2PjNm16omjWqGxsfwUDAoEgmb+WGw2G9OWu2sfFtIF7cQsRE3puzZits8DEIvH2E4iBgUKTLOrZX+fLljY0/feYsZWVlGRs/mogXNxExkZOVlaXpM2cZG798+fK6rGN7Y+MjOAgYFCklOVnt215sbPys7Gy98eZbxsaPFuLFbURMZLzx5lvKys42Nn77thcrJTnZ2PgIDgIGxWL6lu7r099Ubm6u0TlMIl78QMSUTW5url6f/qbROXj7CMVFwKBYfnxRK1WpXNnY+IcOfak3337H2PgmES9+IWJK782339GhQ18aG79K5cr68UWtjI2PYCFgUCzlypVT58s6Gp1j6rR/Ky8vz+gckUa8+ImIKbm8vDxNnfZvo3N0vqyjypUrZ3QOBAcBg2K7sktno+N//sV+zZ47z+gckUS8+I2IKZnZc+cZ/d0jyfw1BsFCwKDYGjWor3ppdY3OMWXqNB07dszoHJFAvAQDEVM8x44d05Sp04zOUS+trho1qG90DgQLAYMSueqnVxgdf8/evZq34D2jc5QV8RIsREzR5i14T3v27jU6h+lrC4KHgEGJXN2tq5KTkozO8fKrr6nA4EOyyoJ4CSYi5vQKwmG9/OprRudITkrS1d26Gp0DwUPAoETOqlhR11z9M6NzpGdkavFS937kkXgJNiLm1BYvXab0jEyjc1xz9c90VsWKRudA8BAwKLE+1/ZShQrmnswrSZOnvGolFE6HeIkNRMzJCgoKNHnKq0bnqFChvPpc28voHAgmAgYlVqVKZXW/6kqjc2z7dLumz3zb6BzFRbzEFiLmG9Nnvq1tn243Okf3q65UlSrmnjGF4CJgUCo3XnetEuLjjc7x3OSXtH//AaNzFIV4iU1EjLR//wE9N/klo3MkxMfrxuuuNToHgouAQalUr1bN+DMbsrKyNHbiJKNznAnxEttiPWLGTpxk/EdWr+zSWdWrVTM6B4KLgEGp9e1znfGL+7wFC7V67Xqjc5xuXuIFsRoxq9euNz5vXFyc+va5zugcCDYCBqVWp3Ytdb7sUuPzPPH0WOXn5xufpxDxgm+LtYjJz8/XE0+PNT5P58suVZ3atYzPg+AiYFAmN994vUKhkNE5dqRnaOobM4zOUYh4wanEUsRMfWOGdqRnGJ0jFArp5huvNzoHgo+AQZn8oF6aOrRra3yeyVNe0d7P9hmdg3jBmcRCxOz9bJ8mT3nF6ByS1KFdW/2gXprxeRBsBAzK7JZf3GB8jtzcXD09/llj4xMvKI6gR8zT459Vbm6usfELReOageAjYFBmDeufr5+0aW18nsXLluuD/66I+LjEC0oiqBHzwX9XaPGy5REf97t+0qa1GtY/3/g8CD4CBhFx8419ojLP38dO0NGjRyM2HvGC0ghaxBw9elR/HzshYuOdSbSuFQg+AgYR0ezCJmrTupXxeXbt3qOnJ/wjImMRLyiLIEXM0xP+oV2790RkrDNp07qVml3YxPg8iA0EDCLmnrsGKiEhwfg8b86arYWLl5ZpDOIFkRCEiFm4eKnenDU7Qqs6vYSEBN1z10Dj8yB2EDCImNQ6tdW3T++ozPXoE2O0c9fuUv13iRdEks8Rs3PXbj36xJgIr+rU+vbprdQ6taMyF2IDAYOIuumG66PycKqs7GyNGDVaeSV8wB3xAhN8jJi8/HyNGDVaWdnZhlb2jTq1a+mmG3juCyKLgEFElS9fXoMH3RGVuTZt2arxJfitJOIFJvkWMeMnTtKmLVsNruobgwfdofLly0dlLsQOAgYRd3Gbi9Sx/SVRmWvajJla8n7RX/0kXhANvkTMkveXa9qMmVFYldSx/SW6uM1FUZkLsYWAgRF3DxygxMTEqMz1yN+e1J69n5323ydeEE2uR8yevZ/pkb89GZX1JCYm6u6BA6IyF2IPAQMjqlerpltv/kVU5jp8OEsjRo0+5Q8+Ei+wwdWIyT/+uZfDh7OispZbb/6FqlerFpW5EHsIGBhz/c+v0Xn16kVlrk82btKzz08+6e+IF9jkYsQ8+/xkfbJxU1TWcF69err+59dEZS7EJgIGxpQrV05DBg+K2nyvvTFdyz/8+qcGiBe4wKWIWf7hCr32xvSozT9k8CCVK1cuavMh9pQ7u2q1ESYGvuQnP1bjhg1MDA2P1KheXbv37NXWT7dHZb4PVqyQwl//5ADxAhecf955qlO7lpa+/4HC4XBU5w6Hw1r6/gdKiE/QMxP/EdGf4TiTrl06q3evnlGZC27btHnLiYNlpHEHBsbdOaC/zqpYMSpzHT6cpWef/yfxAqfYvhPz7PP/jNrnXs6qWFF3DugflbkQ2wgYGFe5UiXdcduttpdhFPGCotiMmGi647ZbVblSJdvLQAwI9isJzri6W1dd3rG97WUYQbyguIIeMZd3bK+ru3W1vQzEiGC+iuCk++8dHJWfGYgm4gUlFdSIqVO7lu6/d7DtZSCGBOsVBKelJCfr4WEPRuUXq6OBeEFpBS1iEhIS9PCwB5WSnGx7KYghwXj1wBsN65+vu26/zfYyyox4QVkFKWLuuv02Nax/vu1lIMb4/8qBd3r16K5LO7SzvYxSI14QKUGImEs7tFOvHt1tLwMxyN9XDbw29N7Bql2rpu1llBjxgkjzOWJq16qpoXzuBZb494pBIKSkpGjEQ0OVEB9veynFRrzAFB8jJiE+XiMeGqqUlBTbS0GM8ufVgsBp3LCBBnrywCviBab5FjEDB/Tnaeuwyo9XCgKr9zU91LFdW9vLOCPiBdHiS8R0bNdWva/pYXsZiHFuv0oQE4YOuUe1atawvYxTIl4Qba5HTK2aNTR0yD22lwEQMLCvYsUUPfzQUMU79nkY4gW2uBox8fHxevihoapYkc+9wD63Xh2IWY0bNdQ9dw20vYwTiBfY5mLE3HPXQDVu1ND2MgBJBAwccnW3rurf7ybbyyBe4AyXIqZ/v5v4nSM4xf6rAviWfn1vtP5QrF//8hbiBc7o0uly/fqXt1hdQ68e3dWv741W1wB8FwED5wwedIcuv7SDtfmnvPa6ln+4wtr8wLct/3CFprz2urX5L7+0gwYPusPa/MDpEDBwTlwopGEP/E6tW7awMv/hw1ka+seHNXbiJOXn51tZA5Cfn6+xEydp6B8f1uHDWVbW0LplCw174HeKC4WszA+cCQEDJyXEx2vUiGHWfiAuHA5r6rR/665779eevZ9ZWQNi1569n+mue+/X1Gn/VjgctrKGhvXP16gRw7x6WjZiCwEDZyUnJemxv/xJdWrXtraGTzZu0q8G3qUl7y+3tgbEliXvL9evBt6lTzZusraGOrVr67G//EnJSUnW1gAUhYCB06pUrqwnRo9U1apVrK3h8OEsPTRipJ4a96zyeEsJhuTl5+upcc/qoREjrb1lJElVq1bRE6NHqkrlytbWABQHAQPn1apZQ3/7y5+t/2jctBkzdefgIdq5a7fVdSB4du7arTsHD9G0GTOtriMlJUV/+8ufnX0yNvBtBAy8UP+H5+mRh/+ghIQEq+vYtGWrbrvzbi1cvNTqOhAcCxcv1W133q1NW7ZaXUcPokVtAAAPQklEQVRCQoIeefgPqv/D86yuAyguAgbeaNGsqf449D7r34jIys7W8JGP6PGnxuro0aNW1wJ/HT16VI8/NVbDRz6irOxsq2uJC4X0x6H3qUWzplbXAZQEAQOvXNqhnR4e9qD1OzGS9Oas2brl1wP1wX95ZgxK5oP/rtAtvx6oN2fNtr0UJSQk6OFhD+rSDu1sLwUoEb4fB+9c2qGdHq90th4c/mdlZdn7sKMk7dq9R/cPG6GO7drqNwNvV43q1ayuB27b+9k+PT3+WS1e5sa32lJSUvTIw3/gzgu8xB0YeKlFs6Z6+vG/Wv120rctXrZcN992h6ZMncbD7/A9+fn5mjJ1mm6+7Q5n4qVq1Sp6+vG/Ei/wFgEDb9X/4Xka//fHrT4n5ttyc3P17KQXdOsdd2n12vW2lwNHrF67XrfecZeenfSCcnNzbS9H0tfPeRn/98f5wC68RsDAa7Vq1tC4vz9m7Ym9p7IjPUOD7xuqP4/+m/bvP2B7ObBk//4D+vPov2nwfUO1Iz3D9nJOaFj/fI37+2N8VRreI2DgvSqVK+upx/9q7beTTmfegoXq2/92vTHjLRUUFNheDqKkoKBAb8x4S3373655CxbaXs5JWrdsoace/ysPqUMgEDAIhOSkJD066mGrv2J9KllZWRozboL633m33luyVAWWftcG5hWEw3pvyVL1v/NujRk3wfoHzL/r8ks76NFRD/PzAAgMvoWEwEiIj9fw3z+gypUqafrMWbaXc5Jtn27XH//8iNLqpuqmG65Xl06XqVy5craXhQg4duyY5i14Ty+/+prSMzJtL+eUevXorsGD7rD+DCUgkggYBEpcKKR77hqoqlUqa9Lkl20v53vSMzL1l8ee0PMvTlHfPr3V7couTjzTBiWXl5en2XPnacrUadqzd6/t5ZxW/343qV/fG20vA4g4AgaB1K/vjapapYqefGa8k19r3rN3rx5/aqwmT3lFfXr/XD1/dpUSExNtLwvFkJubqzfffkdTp/1bn3+x3/ZyTis+Pl733DVQV3franspgBEEDALr6m5d1eD8H2r4qNHavcfNE/LnX+zX2Gef08uvvqbrevXUtT2vtv6jlTi1rKwsvfHmW3p9+ps6dOhL28s5o1o1a+jhh4aqcaOGtpcCGMOHeBFojRs11KRxT6tju7a2l3JGhw59qef++ZJ69/2lJj4/WXs/22d7SThu72f7NPH5yerd95d67p8vOR8vHdu11aRxTxMvCDzuwCDwKlZM0cjhwzRtxkyNnzhJeQ6+pVQoKztbL7/6mqZMfV0tmjVV1y6ddWmHdnxzJMqyc3K0aMkyzZk3X2vWrVfYg2+PJcTHa+CA/up9TQ/bSwGigoBBzOh9TQ9deMGPNGLUaO3avcf2cs4oHA5r9dp1Wr12nZ58epw6tLtEXbt0UutWLfkmiSEF4bBWrlqtOfMWaMmy95V75IjtJRVb7Vo1NeKhoWrcsIHtpQBRQ8AgpjRu2ECTxj2l0U+M0aIly2wvp1hyjxzRvAULNW/BQp17TlX9tHMnXdmlk86rV8/20gJh+44dmjtvgf4zf4HTH8o9nUs7tNPQewfz2SnEHAIGMSclJUV//sPvNX3mLD3z7HPKy8uzvaRi+/yL/frXa9P0r9emqWH989W1S2dd0ekyVa5UyfbSvHLw0CG9u+A9zZk3X5u3brO9nFJJSEjQXbffpl49utteCmAFAYOY1atHdzW54EcaPvIR7dy12/ZySmzz1m3avHWbnpnwDzWof75atWiu1i1bqNmFF/CV7O/Izc3Vuo8/0crVa7RqzVpt2brN66ci16ldSw8Pe9Cp3wADoo2AQUxrWP98PTfuKT36xBgtXLzU9nJKpSAc1qYtW7Vpy1a98vobio+P1wWNG6lVi2Zq1aK5mvyoccw9LC8vL08b/m+jVq1Zq1Vr1umTjZucfB5QaVzesb3uv3ewUpKTbS8FsIqAQcxLSU7Ww8Me1EWz52jCcy/oq8OHbS+pTPLz87Xu4w1a9/EG/fPlV1ShQnk1bXKBWrVorlYtmqtxwwaKiwvWExQKCgq0cfOW48GyVus3fKIjR47aXlZEnVWxou647VYeTAccR8AAx13dras6tGurcRMnac68+baXEzFHjhzVR6vW6KNVayR9HWwNG9RXWt1UpaWmqm7dOkpLTVXNmjWc/4ZTQTisPXv2Kj0zUxkZO5Weman0jExt3rJVWdnZtpdnTNcunXXngP581gn4FgIG+JbKlSrp9/fdq+5XXanHx4zV9h07bC8p4rKys098RfvbEhISlFqn9jdhk1pH9dLqKi21TtS/4ZKVlaX0zJ3akZ6hjMxvQiVz5y6vPnRdVufVq6chgwep2YVNbC8FcA4BA5xCswub6PkJT+u1f8/QCy/9S7m5ubaXZFxeXp62/2+Htv/v+9FWpXJlnX32WUpOSlJycrKSkhK/+XNiopKTk5ScdPzvk5OUnJSkpOMP38vJyVF2To6ys3OUk5Or7Jzsr/+cm6vs7Gxl5xz/++N//vLLr3Tg4MFo/5/vlMTERN168y90/c+v4VfLgdMgYIDTKFeunG687lp1vqyjnho/UYuXvm97SdYcOHgw5qMiWjq2v0R3Dxyg6tWq2V4K4DQCBihC9WrVNPKPD+mDFR9pzNgJXn7lGu6rU7uWBg+6Qxe3ucj2UgAvBOurCIBBF7e5SJMnjtMvb7ox5r6WDHMSEhL0y5tu1OSJ44gXoAQIGKAEypcvr1/dcpMmTxynNq1b2V4OPNemdStNnjhOv7rlJpUvX972cgCv8BYSUAqpdWrr8Uf+rHUfb9BLr0zVhytW2l4SPPKTNq118419+HYRUAYEDFAGzS5sosdG/Umbt27Ti/96VUuWLVfY40fUw5xQKKQO7drqll/cwE8AABFAwAAR0LD++f/f3v2/Rn3YcRx/X3Qmd0aM1ZjU5KKjUcuojYm2ThSr8UvsXGGjVZs6yzYKKxtsDMYYjO2n/SdjlK6UDbqty/yytjg2xjRedbB+gdVcUnS1Y8U2ZzuI+8ESKsiGLNeP7/h4QLjLhXzyIr/kST7H5xM/+fEP460LE/HTZ34eJ156OWZmZoqexW2gpaUldu98KI6OHoo1q/uKngPzhoCBObRmdV/86Affi68/eSR+9uxzMXbsRPx7ntyDh1vzmYULY2Tv7jhy+GD0rLq76Dkw7wgYaIKeVXfH97/77fjqV0bjmeeej1+9ODbv7s3DzbW2LoovPjwSowcfdS0XaCIBA020srMzvvPNp+PJ0cfj2ed/Eb984dcx3WgUPYsmqJTL8aVHDsThR78cy5Z1FD0H5j0BA5+CZcs64umnvhZHHj8YL/zmt/Hi747HhYl60bOYA6v7qvHwvj3xyBf2x5L29qLnwB1DwMCnaEl7ezxx6LF44tBj8dobb8bYsRNx4qVXXKY/mWUdHbF7544Y2bs71q/tL3oO3JEEDBRk/dr+WL+2P771jafiz385E2PHT8apP/4pPvrIe2VuR4sWLYrtWz8fI3uG48HNQ26yCAUTMFCwBQsWxNYtD8TWLQ/EB9PT8dIrp2Ls+MmonTvvmjIFK5VKMbDhvhjZMxw7d2yPxZVK0ZOAjwkYuI0srlTiwP59cWD/vrh46R9x7OTvY+z4yZioTxY97Y7SV+2NkT3DsXd4V3R3rSx6DnATAgZuU91dK+Po6OE4Ono4/vba6/HyqT/E6fFavP7GmzHjPzNzqqVUinVr+2PT4EA8tH1b3Lt+XdGTgP9BwEAC965fN/tH9f33P4jaufNx+mwtzpytxd/fuuBU0y0qlUrx2TWrY2jjQGzaOBADG+6L9vbFRc8CboGAgWTa2xfHtq1bYtvWLRER8a/33ovx2rkYr70aZ8ZrMTHpdNPN9PX2xtDgQAwO3B+DAxuiY+nSoicB/wcBA8l1LF0au3Zsj107tkdExOV3/xnjtVqcGX81Tp+txcVLlwpeWIzurq7YtHEghgbvj8GBgVix/K6iJwFzSMDAPLNi+V2xd3hX7B3eFRERFy9dion6VEzU6zExORUT9cmoT07GO5ffLXjp3OhcsTyqvb3RV+2Nvt6e6KtWo6/aE91dXUVPA5pIwMA8193VFd1dXfHg5qEbXm80GlGfens2aCbq1z/qU2/H1atXC1p7c21tbVHtWXU9Uqq9s8FS7VkV5XK56HlAAQQM3KHK5XKs678n1vXfc8Pr165di3cuX46J+lTUp6biypUrMT3diOlGI6anpz9+bESj0Zh9Pt24/vnMzMx//ZktLS1RLpejUi5HpXL9sfyJ55VKZfZrS5YsiWpPT/RVe6JzxYoolUrN/HUAyQgY4AalUilWdnbGys7O2Dy08Za+9+qHH0bjE7ETEbNRUq6Uo621tRmTgTuQgAHmTFtra7S1trobM9B0LUUPAAC4VQIGAEhHwAAA6QgYACAdAQMApCNgAIB0BAwAkI6AAQDSETAAQDoCBgBIR8AAAOkIGAAgHQEDAKQjYACAdAQMAJCOgAEA0hEwAEA6AgYASEfAAADpCBgAIB0BAwCkI2AAgHQEDACQjoABANIRMABAOgIGAEhHwAAA6QgYACAdAQMApCNgAIB0BAwAkI6AAQDSETAAQDoCBgBIR8AAAOkIGAAgHQEDAKQjYACAdAQMAJCOgAEA0hEwAEA6AgYASEfAAADpCBgAIB0BAwCkI2AAgHQEDACQjoABANIRMABAOgIGAEhHwAAA6QgYACAdAQMApCNgAIB0BAwAkI6AAQDSETAAQDoCBgBIR8AAAOkIGAAgHQEDAKQjYACAdAQMAJCOgAEA0hEwAEA6AgYASEfAAADpCBgAIB0BAwCkI2AAgHQEDACQjoABANIRMABAOgIGAEhHwAAA6QgYACAdAQMApCNgAIB0BAwAkI6AAQDSETAAQDoCBgBIR8AAAOkIGAAgHQEDAKQjYACAdAQMAJCOgAEA0hEwAEA6AgYASEfAAADpCBgAIB0BAwCkI2AAgHQEDACQjoABANIRMABAOgIGAEhHwAAA6QgYACAdAQMApCNgAIB0BAwAkI6AAQDSWdisA9fO/7VZhwYAEmhmC5R6+j93rWlHBwBoAqeQAIB0BAwAkI6AAQDSETAAQDoCBgBIR8AAAOkIGAAgHQEDAKQjYACAdAQMAJCOgAEA0hEwAEA6AgYASEfAAADpCBgAIB0BAwCkI2AAgHQEDACQjoABANIRMABAOgIGAEjnP1tLn9VXsOGCAAAAAElFTkSuQmCC",
          fileName="modelica://ClaRa/figures/Components/Boiler.png")}), Diagram(
        coordinateSystem(extent={{-100,-100},{100,220}})));

end Boiler;
