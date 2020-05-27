within ClaRa.Basics.Icons;
model HEX03
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Bitmap(
          extent={{-100,-100},{100,100}},
          imageSource=
              "iVBORw0KGgoAAAANSUhEUgAAAjAAAAIwCAYAAACY8VFvAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7d1ndJTV/rfxve8UQm8BBJEOAoKIiIKggCKCAmJBCTUhCaGFFiD0Lr1DSG9ACIoce+8FERUVuwiiiCCKID2QZO/nheb8PT6W3JCwZ89cn7V86eSrYnKtycz85OUNmuYLAAAAizimBwAAALhFwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACs419cD9z5lo6iRbOriuvhAQCAh9v16WfipVdeK5bHLraAadHsKnFX9zuK6+EBAIAFiitg+BUSAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDwJWszVvkqVOnTc8A4OMIGACubNqyVfYJDXeyNm+ROTk5pucA8FEEDADXTp06LZIz1suQsEjnP48/KXPz8kxPAuBjCBgAF+zYsV/F6vgk2X/wEOeZ51+USinTkwD4CAIGwEU7/NPPYvGK1XLQkOHOq2+8KbXWpicB8HIEDIAi8/2BH8Ts+Ytl5Mgxzjvvvi9N7wHgvQgYAEVuz95vxKQZs+XIcROdjz7+1PQcAF6IgAFQbD79/AsxZuJkZ8KUGfKr3V+bngPAi/ibHgDA+733wYfyvQ8+lDe3a6sHD+qv69SqZXoSAMsRMAAumTe2bZdvbd8hO3fqoMMG9NPVL6tmehIAS/ErJACXlFJKvPDyq3JAxFBnxdp18sgvR01PAmAhAgaAEXl5eeLxp56V/QZHOvHJafLEiZOmJwGwCAEDwKhz586Lh7Y+KvsMCnfSN2ySp8+cMT0JgAUIGAAe4czZsyIzK1uGhEY4m7f8R547d970JAAejIAB4FFOnDgpElLTZd+wSOexJ5+WedxZAvAXCBgAHumXo0fFyrgEOSBiqPP8S69IxXkCAH9AwADwaId+PCwWLF0hw6JGOK+/tY07SwCEEAQMAEt8t/97MXPeQhkVPdZ59/2d3FkCfBwBA8Aqu/fsFROnzZKjxk9yPv70M9NzABhCwACw0seffiZGjZ/kTJw2U3719R7TcwBcYpwSAGC1d9//QL6380N5U7u2Onxgf1271hWmJwG4BAgYANbTWos33npbvvX2O/K2Wzrq0P59ubMEeDl+hQTAayilxPMvvcKdJcAHEDAAvA53lgDvR8AA8FoFd5ZCQiOcjI3Z8szZs6YnASgiBAwAr3f6zBmRsXGT7DMo3Nn8CHeWAG9AwADwGSdOnBQJKemy3+BI5/GnnuHOEmAxAgaAzznyy1GxYm08d5YAixEwAHxWwZ2lwdxZAqxDwADwed8W3FkaNY47S4AlCBgA+N3ur/f8987SJ59+bnoOgH9AwADAn3z86WcienysM3HaTLl7z17TcwD8BU4JAMDf4M4S4LkIGAD4BwV3lra9/Y7szJ0lwGPwKyQAKIT8P9xZWrk2Xv5ylDtLgEkEDAC4kJeXJx576hnZNyzSSUhJ584SYAgBAwAX4Ny582LzI//hzhJgCAEDwCN07tRRt762pXWfJMedJcAMAgaAR6hbp5ZYMn+OXrl4gWrWtInpOa79z52lp5/lzhJQzAgYAB7lmqubibXLF6uFc2bqhvXrmZ7j2pFfjooVa9bJgZHDnBde5s4SUFwIGAAeqc311+mktSvVrCmx+oqal5ue49rBQz+K+Ut+u7P0xra3OU8AFDECBoDHklKKjje315lJ61TsuNG6WtWqpie59u3+78WMuQvkkOixzrs7PyBkgCJCwADweI7jiG5dOuuNaYlq1PAoXaliRdOTXNv99R4xcepMOXrCJMmdJeDiETAArBHg7y/u6dldb8pIVkMGD9LlypY1Pcm1XZ98JqPHxzqx02dxZwm4CAQMAOsElSgh+t5/n87OSFYD+z6gS5YMMj3JtR3v7ZRR0WOdmfMWyv3fHzA9B7AOAQPAWqVLlxaDB/bX2Rkpqvfdd+nAwEDTk1zRWovX39omw6JGOAuWrpA/Hj5sehJgDQIGgPUqlC8vRkRF6Ky0RNWj2+3az8/P9CRX/ntnKZw7S0BhETAAvEaV4GARM3qk3pASrzp36qgdx65vcbl/uLOUmJohT5zkzhLwd+z6vxsACqFG9epiWmyMTl23WrW/sY11nyR37tx5kb1lqwwZFOFkZnFnCfgrBAwAr1W3Tm0xb8ZUHb9qmWrV8hrrQub0mTMifcMmGTIownlo66Py/HnuLAEFCBgAXq/JlY3EsgVz9crF89VVTRqbnuPa8RMnRHxymuwbxp0loAABA8BnXHN1cxG3YolaMGeGrl+vruk5rnFnCfg/BAwAn9P2+tY6JW6VmjF5or7icovvLA0d6by5bTvnCeCTCBgAPklKKW7pcJPOTF6nJo4dpatVrWJ6kmvffrdfTJ87X0ZFj3Xe2/khIQOfQsAA8GmO44g7br9Nb0xLUqOGDdEVK1YwPcm1r77eIyZMnfHbnaXPuLME30DAAID4/c7SXT10dkaKigwbqMuWKWN6kmu7PvlMRsf8dmfpa+4swcsRMADwB0ElSoh+D/TWmzNTVP8+91t7Z2lI9Fhn1oPcWYL3ImAA4C+ULl1aRIQO0NkZKeq+u3vqgIAA05Nc0VqL19787c7SwmUrubMEr0PAAMA/qFC+vBgZFak3pSep7pbeWXruxZd/u7MUlyCPHjtmehJQJAgYACiEKsHBYvzokXp9crzq3KmDnXeWnnxa9g3lzhK8g13/BwKAYZfXqC6mxY7XKXGrVLs2N1j3SXI5585xZwlegYABgAtQr24d8eCsaXrdyqXq2mtaWBcyf7yz9PDWx7izBOsQMABwEZo2vlIsXzhPL184TzdtfKXpOa4dP3FCrEtOlX0HD3Ge4M4SLELAAEARuPaaFnrdyqVq/qzpun7dOqbnuHbkyC9i+X/vLL3KnSV4PAIGAIrQjW2u1ynrVqvpkybompfXMD3Htd/uLC3nzhI8HgEDAEVMSilu7XizzkxapyaMidZVqwSbnuQad5bg6QgYACgmfn5+4s6uXXRWWpKKHhqpK1Yob3qSa/93Z2kyd5bgUQgYAChmAQEB4t5ePXV2RoqKCB2gy5QpbXqSa7s++VRGx8Q6k6bP5s4SPAIBAwCXSFBQkOjf5369OSNV9e/TWwcF2Xdn6Z333ufOEjwCAQMAl1iZMqVFROhAnZ2RrO7tZf+dpcOHfzI9CT6IgAEAQypWqCCih0bqrLQkdWfXLtbeWeofHuWsWpfInSVcUgQMABhWtUqwmDAmWmcmrVO3dLhZS2nXm35y8/LEo0889dudpTTuLOHSIGAAwEPUvLyGmDF5gk5Zt1rdeMP11n2SXM65cyL74a0yJDTSWb9pszx7Nsf0JHgxAgYAPEz9unXE/NnT9boVS9S1La62LmROnz4t0tZnyT6DwrmzhGJDwACAh2rapLFYvuhBvWzBPN2kcSPTc1z7852l/Px805PgRQgYAPBwrVq20PErl6kHZ07T9erUNj3HtYI7SwMihjkvvvIad5ZQJAgYALBEu7Y36NT4NWr6pPH68hrVTc9x7eChQ+LBxcvk4KEjnbfefseuVyrD4xAwAGCR3+4sddDrk+PV+NEjrb2zNG3Og3LoqHHO+x9wZwkXhoABAAv5+fmJ7t1u11lpSWpEVISVd5a+3P21GD9lhhwzcYr89PMvTM+BZQgYALBYQECA6H33XXpTeooKH9TfyjtLH338iRw5bqIzacZsuWfvN6bnwBIEDAB4gZIlg8SAkAd0dkaK6veApXeW3n1fRo4c48yev0juP8CdJfwzAgYAvEjZMmVEZNhAnZ2erO7p2V0H+PubnuSK1lq8+sZbMmzICGfR8lXcWcLfImAAwAtVrFhBjBoepTemJak7utym/Ry7vt3nKyWefeEl7izhb9n1JxoA4Eq1qlXExHGjdEbSOtWpw03W31k6eeqU6UnwEAQMAPiAK2peLmZOnqiT41aptje0tu6T5AruLPUZFOGs3/QQd5ZAwACAL2lQr65YMHuGjluxRLVs0dy6kPntztJGGRIa4Wz5D3eWfBkBAwA+6KomjcWKRfP1sgVzdZMr7buz9Ovx4yIuKVX2GxzlPPnMc9xZ8kEEDAD4sFYtr9Hxq5apeTOn6roW3ln6+cgRsWx1HHeWfBABAwAQ7du20anxa9TUiTG6RnV77yyFD4vmzpKPIGAAAEIIIRwpxW23dNQbUuJVzKgRukqwfXeW9n37nZg250E5bHQMd5a8HAEDAPgffn5+oscdXXVWWqIaMSRcVyhv352lL77azZ0lL0fAAAD+UmBgoOh9Ty+dnZGiBg/sr0uX5s4SPAcBAwD4RyVLBomBfR/QmzNTVMj99+qgEiVMT3KNO0veh4ABABRK2TJlRNTgUL0pI1ndbfmdpcXLV3NnyXIEDADAlUoVK4rRw6P0xtRE1a1LZyvvLD3zwouyf3iUs3pdojx27FfTk3AB7PpTBwDwGNWqVRWx40br9KQ41enm9lbeWfrPE0/JkNAIJyktkztLliFgAAAXpVbNmmLmlFidvHalatP6Ous+SS7n3Dmx6eFHuLNkGQIGAFAkGtSvJxbOnanXLl+sWjRvZl3IcGfJLgQMAKBINWvaRKxaskAvnT9HN27U0PQc1/54Z+mpZ5/nzpKHImAAAMXiumtb6oTVy9Xc6VN0ndq1TM9x7ecjR8TSVWvlwMhhzkuvvs6dJQ9DwAAAitVN7drqtIS1asqEcVbeWfrh4CExb9HS3+4sbefOkqcgYAAAxc6RUnS5tZNen7xOjYseroODK5ue5Nq+b78T02b/dmdp54cfETKGETAAgEvG399f9Lyzm96UlqSGR4br8uXKmZ7k2hdf7RYxk6fLsbFT5GdffGl6js8iYAAAl1xgYKC4/95eOjszRYUN6KtLlyplepJrH+76RI4YO8GZPHOO3PPNPtNzfA4BAwAwplTJkmJQvxCdnZmiQnrbeWdp+473ZOSI0c7sBYvl9wd+MD3HZxAwAADjypUtK6LCQ3VWepLq1eNOO+8svf6mDB0y/Lc7Sz/9bHqS1yNgAAAeo3KlSmLMiKF6Q2qC6nrbrfbeWRo8hDtLxcyuPxkAAJ9wWbVqYlLMGJ2eGKc6tG9n752lsEgnOX09d5aKAQEDAPBYta6oKWZPm6ST1qxQN7RuZd0nyeXk5Iish7bIkNAIZ0M2d5aKEgEDAPB4DRvUF4vmztJrli5SLZpfZV3InDp1WqRm/n5n6dHHZW5urulJ1iNgAADWaN6sqVi1ZKFe/OBsfWXDBqbnuPbr8eMiLjFF9g0bwp2li0TAAACsc32ra3XimhVqzvTJuk6tK0zPcY07SxePgAEAWOvmdjfqtMQ4NWXCWF2j+mWm57hWcGcpgjtLrhEwAACr/XZn6Ra9PjlejY0eroMrVzI9ybVvCu4sjYlxdn64i5ApBAIGAOAV/P39xV13dtNZaclqaESYLleurOlJrn3x5W4RM3kad5YKgYABAHiVEiUCRZ/77tGbM1NVaH/uLHkrAgYA4JVKlSwpQvuH6OyMFNXnvnt0iRKBpie5VnBnac6CJdxZ+hMCBgDg1cqVKyuGRoTpTenJqlf3O7S/hXeWXnn9jd/uLK3gzlIBAgYA4BMqV6okxowcpjekJKjbO9+iHRvvLD3/ouwfHuWsiU/y+TtLdv3XAwDgIlW/rJqYPH6sTk9Yq25uf6N9d5Zyc8XWx5/0+TtLBAwAwCfVrnWFmDNtsk5YvVxdf9211n2S3J/vLOXk+NadJQIGAODTrmzYQCyeN1uvXrpQXd3sKtNzXPvjnaVHHnvCZ+4sETAAAAghrm52lVi9dKFaPG+WbtSgvuk5rh379bhYm5As+w0e4jz13Atef2eJgAEA4A+uv66VTlyzQs2eNknXtvDO0k8/HxFLV66Rg4YMd15+7XWpvfTOEgEDAMCfSClFh/btdHpinJoUM0ZXv6ya6UmuHfjhoJi7cKkMHxbtbNu+w65XKhcCAQMAwN9wpBRdb7tVb0hJUGNGDNWVK9l5Z2nq7Hled2eJgAEA4F/4+/uLXj3u1JvSk9XQcLvvLI2LnSo/94I7SwQMAACFVKJEoOjT+x6dnZGiBvUL0aVKljQ9ybUPdn0sh4+d4EyZOVfu3fet6TkXjIABAMCl0qVKibABfXV2Rop64N67rbyz9PaOd2XE8FHOnAVL5IEfDpqe4xoBAwDABSpfvpwYFjlYZ6Ulq553drP2ztKg3+8s/fTzEdOTCo2AAQDgIgVXriTGRQ/X65PjVZdbO9l3Zyk/Xzzz/Iuy3+AhzpqEZHnsV8+/s2TXv2EAADxYjeqXiSkTxum0hDXq5nZtrfsAltzcXLH1sSdkSGikk5KxXp46ddr0pL9FwAAAUMTq1Kol5kyfohNXL1etW9l5Z2nj5i2yT2i4s3Hzwx55Z4mAAQCgmFzZqKFY8uBsvWrJAtWsaRPTc1w7deq0SMnY4JF3lggYAACKWYvmzcTa5YvVormzdMP69UzPcc0T7ywRMAAAXCI3tG6lk9auVLOmxOpaV9Q0Pcc1T7qzRMAAAHAJSSlFx5vb64zEOBU7brS+rFpV05NcK7izFDF8lPP2O+8aOU9AwAAAYIDjOKJbl856Q2qiGj1iqK5UsaLpSa7t3fetmDJrrhw+ZrzzwUeX9s4SAQMAgEEB/v7i7h536k0ZySoqPFSXK2vfnaXPv/xKjJv0+52lL7+6JF+TgAEAwAMElSghQnrfq7MzU9TAvg/Ye2dpzHhn6qx5xX5nya7PPAYAwMuVLlVKDB7YX997V0+d9dAW+dhTz8jz58+bnuXKtnd2yLd3vCsbNaivhRDF8kpfnoEBAMADlS9fTgwfEq43pSWpHnd0tfLO0pe7v5bit9Yo8tfHEDAAAHiw4ODKImbUCL0+eZ267ZaO1t1Z+l2Rh4yV/xYAAPA1NapXF1MnxujU+DWq/Y1trDtP8LsiCxkCBgAAi9StXUvMmzFVJ6xerq679hqfDRkCBgAACzVu1FAsnT9Xr1xs552l311wyBAwAABY7Jqrf7uztGDODN3AwjtLv3MdMna9pBkAAPyltte31m1aX6dfe/MtmbY+S35/4AfTky6E/P2vf337Nc/AAADgJaSUotPNN+nMpHUqdtxoXa2qfXeWfvevz8gURcAU1BIAAPAABXeWNqYlqlHDo6y8s/RvijJgiuWDagAAwIUJ8PcX9/TsrjdlJKvIsIG6bJkypie59be/RrrYgPlzsPw3ZI4eO3aRDw0AAIpCUIkSot8DvfXmzBQ1IOQBXbJkkOlJhVFsr4H5p18dyfWbNjsLl62UPx4+fBFfAgAAFJXSpUuL8EH9dXZGiup99106MDDQ9KR/UqwB87eU0uK5F1+WA8KHOivjEuQvR49exJcCAABFpUL58mJEVITOSktUPbrdrv38/ExP+rN//YC+Cw2YQr/WJTcvTzz25NOyb1ikk5CSLk+cOHmBXxIAABSlKsHBImb0SL0+OV517tTBU+4sFeqCtV+5SlVmXsCD/+s/oZRSSPl/nZOfny8+/fwL+cTTz8rc3DzRqGEDERAQcAFfGoBJmx5+RObm5hb547Zq2UJc3eyqIn9cAP+uXNmy4ub2N4qb292oj/zyi/j+wA8m35RTqPMIFxIwhXrb9J8DpkBubq746ONP5JPPPiellKJh/frC39/jnroC8DcIGMB7VaxQQdza8WZxQ+vr9I+HfxKHfvzxUodMoW87XUjAFOr5pb8LmALnzp0X73/wkXzuxZdkYGCgaFC/nvCQp64A/AMCBvB+VYIri9s73yJaNG8mDvxwUP585Mil+tLFFjCF/tC6fwuYAmfOnhXvvPe+fPGV12SZ0qVFvbp1CvX3ATCDgAF8R/XLqok7u3bRVzZsIL7d/708duzX4vxyri5ruw2YQj9FUtiAKXDq1Gnx1vZ35GtvbpOVKlQQtWtdQcgAHoiAAXzPFTUvFz3v6Kpr17pCfLPvW3niZLG8IafYAsbVyQC3AVPg+PET4rU335Jvv7NDVq1SRdS8vIbrxwBQfAgYwDdJKUXdOrVFrx536GpVq4o933wjT58+U1QP7ypehHAXMK5eoHKhAVPg6LFj4qVXX5fvf/CRrFG9ur6smrUHqQCvQsAAvk1KKRo2qC96db9DVyhfTny99xuZk5NzsQ9bbAHj+mDjxQZMgZ9+PiKee/Fl+dnnX4paV9QUwZUrX/RjArhwBAwAIYTw8/MTTRtfKXp1v0OXDCopvt6zV54/f/5CHsp1vAhR+IBx/fagogqYAgcP/SifevZ5ueebfaJu7dqiYoUKRfbYAAqPgAHwR/7+/uLqZleJnnd0047jiN179sq8vDw3D1FsAeP62Rchij5gCuz//oB88pnn5PcHDooG9euKsmXLFvnXAPD3CBgAfyUwMFBce00LcWfXLjo/P198vfcbmZ+f/29/2wXFixCFe2bF494KpJQSL736mhwQMcxZtmrtpXx/OgAA+AcVK1QQI6MidVZakmp+VdN/C5RiCxiPi5c/ys/PF08++7zsGzbEWZuYLH89ftz0JAAAIISoWiVY3HZLRy2EUOKvQ+WC40UIywOmQG5urnjk0SdkSGiEk5KxQZ46ddr0JAAA8H/+KmSKLWCsiJc/Ons2R2zc/LAMCY1wsjZvKYq3dQEAgKLzT8/IuPJPAVOoc9ae6OSpUyI5Y70MCY1wHnnsiWJ5wSEAALhgxRowBV+gSErJhGO/HhdrE5Jlv8FDnKeee6Ewr4YGAAAWKOznu1gdMj/9fEQsXblGDhoy3Hn5tdel0lb+YwAAgN+5/YA6q0PmwA8HxdyFS2XEsGjnre3vWPcaHwAA8BvXn7D7O6tD5ptvvxPTZj8oh42OcXZ++BEhAwCAZS40YApYHTJffLVbxEyeLsdMnCI//fwL03MAAEAhXWzAFLA6ZD76+BM5ctxEZ9KM2XLP3m9MzwEAAP/Cv4gfr+Ct19LPz08qpYr44YvXO+++L3e8t1N2vKmdDhvYT9eqWdP0JAAA8BeK6hmYP9Nh/fuqrrfdqv2c4voSxUNrLV594y0ZNmSEs3DZSvnj4cOmJwEAgD8ptrooV66smBQzRqcnxqmON7XTxXGZujjlKyWee/FlOSB8qLMyLkH+cvSo6UkAAOB3xf70SK0raopZUyfppDUrVJvW11n3GpncvDzx2JNPy75hkU5iaoY8cfKk6UkAAPi8S/b7nYYN6ouFc2fqtcsXq2uubm5dyJw7d15kb9kqQwZFOBkbs+WZs2dNTwIAwGdd8heoNGvaRKxcPF8vnT9HN7my0aX+8hft9JkzImPjJtlnULiz+ZH/yHPnzpueBACAzzH2Ctvrrm2p41ctU/NmTtX16tQ2NeOCnThxUiSkpMt+gyOdx596Rubl5ZmeBACAzzD+FqH2bdvolPg1alrseH15jeqm57h25JejYsXaeDkgYqjz3IsvW/fWcQAAbGQ8YIQQwpFSdO7UQa9Pjlfjx0TrqlWCTU9y7dCPh8XCZStl2NCRzutvbpOag5EAABQbjwiYAn5+fqJ71y46Ky1JjRwaqStWKG96kmvf7f9ezHxwoYyKHuvseG+nXe8dBwDAEh4VMAUCAgLEfb166uyMFBUROkCXKVPa9CTXdu/ZK2Knz5Ijx010Pvr4U9NzAADwKh4ZMAWCgoJE/z73680Zqap/n/t1UFCQ6Umuffr5F2LMxMnOhCkz5Je7vzY9BwAAr+DRAVOgTJnSIiJ0gM7OSFb33d1TBwQEmJ7k2nsffCiHjhrnTJ8zX+77br/pOQAAWM2KgClQsUIFMTIqUm9KT1Ldu92u/fz8TE9y7c23t8vwYdHOvEXL5MFDh0zPAQDASlYFTIEqwcFi/OiRen1yvOrcqaN2LDsYqZQSL736mhwQMcxZtmqt/PnIEdOTAACwil0/+f/k8hrVxbTYGJ26brVqf2Mb6963nJ+fL5589nnZb3CUE5eYIn89ftz0JAAArGB1wBSoW6e2mDdjqk5YvVxdd+011oXM+fPnxZZHH5choRFOSsYGeerUadOTAADwaF4RMAUaN2ools6fq1cuXqCaNW1ieo5rZ8/miI2bH5YhoRFO1uYtMicnx/QkAAA8klcFTIFrrm4m1i5frBbOmakb1q9neo5rJ0+dEskZ62VIWKSz9bEnZG5urulJAAB4FK8MmAJtrr9OJ61dqWZPnaRrXVHT9BzXjh37VaxJ/VwoVwAAFntJREFUSJb9Bg9xnnruBZmfn296EgAAHsGrA0YIIaSUosNN7XRGYpyaFDNGV7+smulJrv308xGxdOUaOWjIcOfl117nzhIAwOd5fcAUcBxHdL3tVr0hJUGNGTFUV65UyfQk1w78cFDMXbhUhg+LdrZt38GdJQCAz/KZgCng7+8vevW4U29KT1ZDI8J0uXJlTU9y7ZtvvxNTZ8+Tw8bEODs//IiQAQD4HJ8LmAIlSgSKPvfdozdnpqrQ/n116VKlTE9y7Ysvd4uYydPl2Ngp8rMvvjQ9BwCAS8ZnA6ZAqZIlRWj/EJ2dkaL63HePLlEi0PQk1z7c9YkcMXaCM2nGbLln7zem5wAAUOx8PmAKlCtXVgyNCNOb0pNVrx536gB/f9OTXHvn3fdl5Mgxzuz5i+T+AwdMzwEAoNgQMH9SuVIlMWbEUL0hNUF1ve1W7WfZnSWttXj1jbdk2JARzqLlq+Thwz+ZngQAQJGz66fzJXRZtWpiUswYnZ4Ypzre1E5LaddrZfOVEs++8JLsHx7lrIxLkEePHTM9CQCAIkPA/ItaV9QUs6ZO0slrV6o2119n3Qew5ObliceefFr2DY10ElMz5ImTJ01PAgDgohEwhdSgfj2xcM5MvXb5YnXN1c2tC5mcc+dE9patMmRQhJOZlS3PnD1rehIAABeMgHGpWdMmYuXi+XrZgrm6yZWNTM9x7fSZMyJ9wyYZMijC2fzIf+S5c+dNTwIAwDUC5gK1anmNjl+1TM2bOVXXq1Pb9BzXjp84IRJS0mW/wZHO4089I/Py8kxPAgCg0AiYi9S+bRudEr9GTYsdry+vUd30HNeO/HJUrFgbLwdEDHWef+kVqbizBACwAAFTBBwpRedOHfT65Hg1fky0rlol2PQk1w79eFgsWLpChkWNcF5/axsHIwEAHo2AKUJ+fn6ie9cuOistSY0cGqkrVihvepJr3+3/Xsyct1BGRY91dry30673jgMAfAYBUwwCAgLEfb166uyMFBUZOlCXLVPG9CTXdu/ZK2Knz5LRMbHOrk8+NT0HAID/QcAUo6CgINGvT2+dnZGi+ve5X5csGWR6kmuffPa5GD1hsjNhygz51e6vTc8BAEAIQcBcEmXKlBYRoQP0pvRkdd/dPXVAQIDpSa6998GHMmrUOGf6nPly33f7Tc8BAPg4AuYSqlihghgZFak3pSepHt1u135+fqYnufbm29tl+LBo58HFy+TBQ4dMzwEA+CgCxoAqwcEiZvRIvSElXnXu1FE7lh2MVEqJF195TQ6IGOYsW7VW/nzkiOlJAAAfY9dPTi9To3p1MS02RqeuW63a39jGuvct5+fniyeffV72GxzlxCWmyF+PHzc9CQDgIwgYD1C3Tm0xb8ZUnbB6uWp9bUvrQub8+fNiy6OPy5DQCCc1c6M8ffq06UkAAC9HwHiQxo0aiiXz5+iVixeoZk2bmJ7j2tmzOWJD9kOyz6AIJ2vzFpmTk2N6EgDASxEwHuiaq5uJtcsXq0VzZ+mG9euZnuPayVOnRHLGehkSFulsfewJmZuba3oSAMDLEDAe7IbWrXTS2pVq9tRJunatK0zPce3YsV/FmoRk2T88ynn6uRdkfn6+6UkAAC9BwHg4KaXocFM7nZ6wVk2KGaOrX1bN9CTXDv/0s1iyco0cNGS48/Jrr3NnCQBw0QgYSziOI7redqvekJKgxo4cpoMrVzI9ybUDPxwUcxculRHDRznbtu/gzhIA4IIRMJbx9/cXd3W/Q2elJauhEWG6XLmypie5tnfft2Lq7Hly2JgYZ+eHuwgZAIBrBIylSpQIFH3uu0dvzkxVof376tKlSpme5NoXX+4WMZOnybGxU+RnX3xpeg4AwCIEjOVKlSwpQvuH6OzMFBXS+15dokSg6UmufbjrEzli7ARn8sw5cs83+0zPAQBYgIDxEuXKlhVR4aF6U3qy6tXjTh3g7296kmvbd7wnI0eMdmbPXyT3Hzhgeg4AwIMRMF6mcqVKYsyIoXpDaoLqetut2s+yO0taa/HqG2/JsCEjnEXLV8nDh38yPQkA4IHs+umGQrusWjUxKWaMTk+KU51ubq+ltOu1svlKiWdfeEn2D49yVq1LlEePHTM9CQDgQQgYL1erZk0xc0qsTl67UrW5/jrrPoAlNy9PPPrEU7JvaKSTmJohT5w8aXoSAMADEDA+okH9emLhnJl67fLF6pqrm1sXMjnnzonsLVtlyKAIJzMrW545e9b0JACAQQSMj2nWtIlYuXi+XrZgrm5yZSPTc1w7feaMSN+wSYYMinAe2vqoPHfuvOlJAAADCBgf1arlNTp+1TI1b+ZUXa9ObdNzXDt+4oSIT06T/QZHOo8//azMy8szPQkAcAkRMD6ufds2OjV+jZo+abyueXkN03NcO/LLUbFizTo5IGKo8/xLr0jFnSUA8AkEDISUUtzasYPOTFqnxo+J1lWrBJue5NqhHw+LBUtXyLCoEc7rb23jYCQAeDkCBv/l5+cnunftorPSktTIoZG6YoXypie59t3+78XMeQtlVPRY5933d9r13nEAQKERMPj/BAQEiPt69dTZGSkqMnSgLlumjOlJru3es1dMnDZLRsfEOrs++dT0HABAESNg8LeCgoJEvz69dXZGiurf535dsmSQ6UmuffLZ52L0hMnOhKkz5Ve7vzY9BwBQRAgY/KsyZUqLiNABOjsjRd13d08dGGjfwcj3dn4go0aNc6bPmS/3fbff9BwAwEUiYFBoFcqXFyOjInVWWqLq0e127efnZ3qSa2++vV2GD4t2Hly8TB48dMj0HADABSJg4FqV4GARM3qk3pASrzp36qgdyw5GKqXEi6+8JgdEDHOWrY6TR478YnoSAMAlu37ywKPUqF5dTIuN0anxa9RNN7a17n3L+fn54slnnpN9Bw9x4hJT5K/Hj5ueBAAoJAIGF61u7Vpi7owpOmH1ctX62pbWhcz58+fFlkcflyGhEU5q5kZ5+vRp05MAAP+CgEGRadyooVgyf45etWSBata0iek5rp09myM2ZD8k+wyKcLIe2iJzcnJMTwIA/A0CBkWuRfNmYu3yxWrR3Fm6UYP6pue4dvLUKZGcvl6GhEU6Wx97Qubm5pqeBAD4EwIGxeaG1q104poVavbUSbp2rStMz3Ht2LFfxZqEZNk/PMp5+rkXZH5+vulJAIDfETAoVlJK0eGmdjo9MU5NHj9WV7+smulJrh3+6WexZOUaOWjIcOfl197gzhIAeAACBpeEI6W4vfMtekNKgho7cpgOrlzJ9CTXDvxwUMxduERGDB/lbNu+gztLAGAQAYNLyt/fX9zV/Q6dlZashkaE6fLlypme5Nrefd+KqbPnyWFjYpydH+4iZADAAAIGRpQoESj63HePzs5MUWED+urSpUqZnuTaF1/uFjGTp8mxsVPkZ198aXoOAPgUAgZGlSpZUgzqF6KzM1NUSO97dVCJEqYnufbhrk/kiLETnMkz58g93+wzPQcAfAIBA49QrmxZERUeqjdlJKtePe7UAf7+pie5tn3HezJyxGhn9oLFcv+BA6bnAIBXI2DgUSpVrCjGjBiqN6Ymqm5dOms/y+4saa3Fq6+/KcOGjHAWLV8lDx/+yfQkAPBKdv10gM+oVq2qiB03WqcnxalON7fXUtr1Wtl8pcSzL7wk+4dHOavWJcqjx46ZngQAXoWAgUerVbOmmDklVievXanaXH+ddR/AkpuXJx594inZNzTSSUzLkCdOnjQ9CQC8AgEDKzSoX08snDNTx61Yolq2aG5dyOScOyeyH94qQ0IjncysbHnm7FnTkwDAagQMrHJVk8ZixaL5etmCubpJ40am57h2+vRpkb5hkwwZFOE8tPVRef78edOTAMBKBAys1KrlNTp+5TL14Mxpul6d2qbnuHb8xAkRn5wm+4ZFOo8//azMy8szPQkArELAwGrt2t6gU+PXqOmTxuual9cwPce1I78cFSvWrJMDI4c5L7z8ilTcWQKAQiFgYD0ppbi1YwedmbROjR8TratWCTY9ybWDh34U85eskIOjRjivv7WNg5EA8C8IGHgNPz8/0b1rF52VlqSih0bqihUrmJ7k2rf7vxcz5y2UUaPGOe++v9Ou944DwCVEwMDrBAQEiHt79dTZ6ckqMnSgLlumjOlJru3+eo+YOG2WjI6JdXZ98qnpOQDgcQgYeK2goCDRr09vnZ2Rovr3uV+XLBlkepJrn3z2uRg9YbIzYepM+dXur03PAQCPQcDA65UpU1pEhA7Q2Rkpqvfdd+nAwEDTk1x7b+cHMmrUOGfG3Ply33f7Tc8BAOMIGPiMCuXLixFRETorLVH16Ha79vPzMz3JtTe2bZfhw6KdBxcvkwcP/Wh6DgAYQ8DA51QJDhYxo0fqDSnxqnOnjtqx7GCkUkq8+MprcmDkMGfZ6jh55MgvpicBwCVn13duoAjVqF5dTIuN0anxa9RNN7a17n3LeXl54slnnpN9Bw9x1iWlyl+PHzc9CQAuGQIGPq9u7Vpi7owpOnH1ctX62pbWhcz58+fFw/95TIaERjipmRvl6dOnTU8CgGJHwAC/u7JRQ7Fk/hy9askC1fyqpqbnuHb2bI7YkP2Q7DMowsl6aIvMOXfO9CQAKDYEDPAnLZo3E2uWLVKL5s7SjRrUNz3HtZOnTonk9PUyJDTC+c/jT8pc7iwB8EIEDPA3bmjdSieuWaFmT5uka9e6wvQc144d+1Wsjk+S/QcPcZ5+7gWplDI9CQCKDAED/AMppejQvp1OT4xTk8eP1dUvq2Z6kmuHf/pZLFm5Rg6KHO68/Nob3FkC4BUIGKAQHCnF7Z1v0RtSEtTYkcN0cOVKpie59v0PP4i5C5fIiOGjnLffeZc7SwCsRsAALvj7+4u7ut+hs9KS1bDIwbp8uXKmJ7m2d9+3YsqsuXL4mPHOzg93ETIArETAABegRIlA8cC9d+vszBQVNqCvLl2qlOlJrn3+5VciZvI0OS52qvz8iy9NzwEAVwgY4CKUKllSDOoXorMzU1RI73t1UIkSpie59sGuj+XwsROcyTPnyD3f7DM9BwAKhYABikC5smVFVHio3pSRrO7u2V0H+PubnuTa9h3vycgRo53ZCxbL7w/8YHoOAPwjAgYoQpUqVhSjh0fpjamJqluXztrPsjtLWmvx6utvytAhw53Fy1fLw4d/Mj0JAP6SXd9dAUtUq1ZVxI4brdOT4lSnm9trKe16rWy+UuKZF16U/cOjnFXrEuXRY8dMTwKA/0HAAMWoVs2aYuaUWJ28dqVqe0Nr6z6AJTcvTzz6xFOyb2ikk5iWIU+cPGl6EgAIIQgY4JJoUL+eWDB7ho5bsUS1bNHcupDJOXdOZD+8VYaERjo5OTmm5wAAAQNcSlc1aSxWLJqvly2Yp5s0bmR6jmunT58W+fn5pmcAgLDvrRKAF2jVsoVu1XKZ3rZ9h0xbv1Hu3fet6UkAYBUCBjCoXdsb9I1trtevvP6GTN+wSR744aDpSQBgBX6FBBgmpRS3duygM5PWqQljonW1qlVMTwIAj0fAAB7Cz89P3Nm1i96Ymqiih0bqihUrmJ4EAB6LgAE8TEBAgLi3V0+dnZ6sIkMH6rJlypieBAAeh4ABPFRQUJDo16e33pyZogaEPKBLlgwyPQkAPAYBA3i40qVLi/BB/XV2RorqffddOjAw0PQkADCOgAEsUaF8eTEiKkJvSktSPbrdrv38/ExPAgBjCBjAMsHBlUXM6JF6Q0q8uu2Wjtqx7GAkABQFvvMBlqpRvbqYOjFGp8avUTfd2Na68wQAcDEIGMBydWvXEnNnTNGJq5er1te2JGQA+AQCBvASVzZqKJbMn6NXLVmgml/V1PQcAChWBAzgZVo0bybWLFukFs2dpRs1qG96DgAUC24hAV7qhtat9PXXXavf2Pa2TFufJb/b/73pSQBQZHgGBvBiUkrRoX07nZ4YpyaPH6urX1bN9CQAKBIEDOADHCnF7Z1v0RtSEtTY6OE6uHIl05MA4KIQMIAP8ff3F3fd2U1vSk9WwyIH6/LlypmeBAAXhIABfFBgYKB44N67dXZmigob0FeXLlXK9CQAcIWAAXxYqZIlxaB+ITo7M0WF3H+vDipRwvQkACgUAgaAKFe2rIgaHKo3ZSSru3t21wH+vEERgGcjYAD8V6WKFcXo4VF6Y2qi6tals/bjzhIAD8V3JwD/n2rVqorYcaN1elKc6tThJi2lND0JAP4HAQPgb9WqWVPMnDxRJ8etUm1vaM2dJQAeg4AB8K8a1KsrFsyeoeNWLFEtWzQnZAAYR8AAKLSrmjQWKxbN18sWzNNNGjcyPQeAD+OtBgBca9WyhW7Vcpnetn2HTFu/Ue7d963pSQB8DAED4IK1a3uDvrHN9fqV19+U6Ruy5IEfDpqeBMBH8CskABdFSilu7XizzkxapyaMidbVqlYxPQmADyBgABQJPz8/cWfXLnpjaqKKHhqpK1asYHoSAC9GwAAoUgEBAeLeXj11dnqyigwdqMuWKWN6EgAvRMAAKBZBQUGiX5/eenNmihoQ8oAuWTLI9CQAXoSAAVCsSpcuLcIH9dfZGSmq99136cDAQNOTAHgBAgbAJVGhfHkxIipCZ6Ulqh7dbtd+fn6mJwGwGAED4JKqEhwsYkaP1BtS4lXnTh21w8FIABeA7xwAjKhRvbqYFhujU+PXqJtubMvBSACu8EF2AIyqW7uWmDtjij5//rzpKQAswjMwADwCL+4F4AYBAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArONfXA+869PPiuuhAQCABYqzBeTlDZrmF9ujAwAAFAN+hQQAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACsQ8AAAADrEDAAAMA6BAwAALAOAQMAAKxDwAAAAOsQMAAAwDoEDAAAsA4BAwAArEPAAAAA6xAwAADAOgQMAACwDgEDAACs8/8AUmVBp4y/2h0AAAAASUVORK5CYII=",
          fileName="modelica://ClaRa/Resources/Images/Components/HEX03.png")}));

end HEX03;
