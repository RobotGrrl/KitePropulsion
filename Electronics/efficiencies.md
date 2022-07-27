| Parameter                      | Unit      | 01 Input | Notes                                                                          |
| ------------------------------ | --------- | -------- | ------------------------------------------------------------------------------ |
| V\_in                          | V         | 1        |                                                                                |
| V\_drop                        | V         | 0.7      | Diode and other components                                                     |
| Load current                   | A         | 1        |                                                                                |
|                                |           |          |                                                                                |
| Switching name                 | \-        | XL4005   |                                                                                |
| Switching V\_in                | V         | 0.3      |                                                                                |
| Switching I\_in                | A         | 26.67    | Determined by the efficiency                                                   |
| Switching P\_in                | W         | 8.0      |                                                                                |
| Switching V\_out               | V         | 7.2      |                                                                                |
| Switching I\_out               | A         | 1        |                                                                                |
| Switching P\_out               | W         | 7.2      |                                                                                |
|                                |           |          |                                                                                |
| Switching Effeciency           | %         | 90%      | Given by the webpage...                                                        |
| Switching P\_dissipated        | W         | 0.8      |                                                                                |
|                                |           |          |                                                                                |
| Linear name                    | \-        | 7805     |                                                                                |
| Linear V\_drop                 | V         | 2        |                                                                                |
| Linear V\_in                   | V         | 7.2      | Add +0.2V to be safe                                                           |
| Linear I\_in                   | A         | 1        |                                                                                |
| Linear P\_in                   | W         | 7.2      |                                                                                |
| Linear V\_out                  | V         | 5        |                                                                                |
| Linear I\_out                  | A         | 1        | I\_out = I\_in for linear regulators                                           |
| Linear P\_out                  | W         | 5        |                                                                                |
|                                |           |          |                                                                                |
| Linear Efficiency              | %         | 69%      |                                                                                |
| Linear P\_dissipated           | W         | 2.2      |                                                                                |
|                                |           |          |                                                                                |
| Overall Efficiency             | %         | 63%      |                                                                                |
|                                |           |          |                                                                                |
| θ\_JC                          | deg C / W | 5        | Thermal resistance, junction-to-case, found as R\_thetaJC in the datasheet     |
| θ\_CS                          | deg C / W | 0        | Thermal resistance case to surface                                             |
| θ\_SA                          | deg C / W | 28       | Given in heatsink's datasheet. Thermal resistance from surface to air          |
| Thermal resistance             | deg C / W | 33       | Total thermal resistance from junction to air                                  |
|                                |           |          |                                                                                |
| Temperature rise above ambient | deg C     | 72.6     | Above ambient temperature                                                      |
| Temperature rise incl. ambient | deg C     | 73.3     | Including ambient                                                              |
| Operating junction temperature | deg C     | 150      | The maximum temperature limit of the regulator, found as T\_j in the datasheet |
| Junction temperature remainder | deg C     | 76.7     | This many degrees to go until it is exceeded                                   |