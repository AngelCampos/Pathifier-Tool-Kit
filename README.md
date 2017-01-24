# Pathifier Tool Kit

### 1_Run_Pathifier.R

An R script for running Pathifier on R.

First file required is TAB separated file of the gene expression matrix in the
following format:

|NAME|Sample1|Sample2|Sample3|Sample n...|
|---|---|---|---|---|
|NORMALS|1|1|0|...|
|Gene1|1.25|1.56|2.56|...|
|Gene2|4.56|0.25|1.75|...|
|Gene3|1.56|3.21|1.36|...|
|GeneN|...|...|...|...|

1st row = Sample names
2nd row = Normal status of samples: 1 = Healthy, 0 = Tumor
1st col = Gene names from third row on (Gene symbol format is recommended)

Second file required by the script is a TAB separated file of the pathway
information in GMT format:

||||||
|---|---|---|---|---|
|PATHWAY1|GeneA|GeneB|GeneC|etc...|
|PATHWAY2|GeneD|GeneA|GeneX|etc...|

Notes:
+ NO HEADER ROW!
+ Gene names used must coincide between expression matrix and pathway annotation

*Test-data is provided on TEST-DATA directory*

---
### 2_Heatmap_4_PDS.R

An R script for showing results of Pathifier (Drier et al., 2013)
and generating a heatmap "Drier's et al." style

This script works directly with the results of the "1_Run_Pathifier.R" script 
and the stand-alone version of Pathifier, adding a vector for depicting
normal samples (See additional notes).

THe last update of the heatmap adds sample labeling for normal (healthy) vs 
tumoral samples

Output preview (using EXAMPLE_DATA)
![alt text][heatmap]

---
### 3_Curves_4_PDS.R

An R script with 2 functions for plotting the principal curves derived of the 
pathway deregulation analysis using Pathifier (Drier et al., 2013)

This script works directly with the results of "1_Run_Pathifier.R" script and
the stand-alone version of Pathifier, adding a vector for depicting normal 
samples (See additional notes).

Output examples (using EXAMPLE_DATA)


![alt text][princurve]


![alt text][princurvedata]

---
### Additional notes:
Pathifier Stand-alone version: http://www.weizmann.ac.il/complex/compphys/software/yotam/pathifier/installation.html

R-version of Pathifier is available via Bioconductor:
http://bioconductor.org/packages/pathifier/

[heatmap]: https://raw.githubusercontent.com/AngelCampos/Pathifier-Tool-Kit/master/heatmap.png "PDS Heatmap"
[princurve]: https://raw.githubusercontent.com/AngelCampos/Pathifier-Tool-Kit/master/PathwayCurve.png "Principal Curve of an example pathway"
[princurvedata]: https://raw.githubusercontent.com/AngelCampos/Pathifier-Tool-Kit/master/PathwayCurveData.png "Principal curve and data points of an example pathway"