| N = 1000000 | append | apply | concat | contains | drop | filter | fold | head | init | map | prepend | reverse | tail | take | update |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Built List | 98913.91 | 0.20 | 381984.17 | 43974.02 | 130153.29 | 302685.88 | 91561.96 | 0.20 | 242738.78 | 286208.29 | 139024.75 | 277361.75 | 246613.33 | 122232.65 | 101096.00 |
| Dart List | **0.28** | **0.18** | 356502.86 | 33270.97 | 111860.63 | 275909.75 | 66162.00 | 0.19 |   | 268994.63 | 0.46 | 277517.88 | 219748.00 | 110419.55 | **0.23** |
| Dartz IList | 994381.50 |   | 1313133.00 | 34382.45 |   | 194700.50 | **48492.72** |   |   | 575627.80 | 0.14 | 135687.00 | 0.29 |   |   |
| FIC IList | 0.30 | 0.26 | 0.83 | 43885.65 | 177966.50 | 236876.56 | 91273.22 | 0.21 | 380880.00 | 302381.43 | 136366.75 | 510690.50 | 366809.67 | 199899.73 | 105332.81 |
| Kt List | 140332.56 | 0.22 | 376197.00 | 43890.48 | 199338.73 | 211871.00 | 89098.65 | 0.21 | 431620.17 | 329998.33 |   | 166248.08 | 314403.13 | 219291.55 |   |
| Ribs IChain | 0.53 | 64674.50 | **0.46** |   |   | 2091181.00 | 117565.17 | 0.35 | 912352.00 | 568463.40 | 0.59 | 114288.11 | 33479.92 |   |   |
| Ribs IList | 691927.33 | 15180.51 | 681674.80 | **21542.30** | 15376.38 | **174234.17** | 81651.72 | **0.15** | 962366.50 | 632679.00 | **0.14** | **105738.37** | **0.05** | 83413.08 | 180627.90 |
| Ribs IVector | 7.40 | 0.36 | 368474.00 | 76166.70 | **48.59** | 201857.40 | 135372.07 | 0.71 | **6.03** | **172600.25** | 32.75 | 566647.50 | 6.09 | **31.50** | 351659.17 |