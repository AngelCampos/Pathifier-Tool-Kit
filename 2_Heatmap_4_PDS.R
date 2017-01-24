###############################################################################
## Heatmap for Pathifier results in R
### Author: Angel Garcia-Campos https://github.com/AngelCampos
#### Base by wonderful: Sebastian Raschka https://github.com/rasbt
###############################################################################

###############################################################################
### Installing and/or loading required packages
###############################################################################

if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}

###############################################################################
## Load Pathifier results and turn into a matrix
###############################################################################

load ("PDS.RData")
PDSmatrix <- t(mapply(FUN = c, PDS$scores))

###############################################################################
## Creating Custom Palette
###############################################################################

# creates a own color palette passing from blue, green yellow to dark red
my_palette <- rev(colorRampPalette(brewer.pal(11, "Spectral"))(n = 1000))

###############################################################################
## Clustering Methods
###############################################################################

# If you want to change the default clustering method (complete linkage method
# with Euclidean distance measure), this can be done as follows: For non-square
# matrix, we can define the distance and cluster based on our matrix data by

row.distance = dist(PDSmatrix, method = "euclidean")
row.cluster = hclust(row.distance, method = "ward.D2")

col.distance = dist(t(PDSmatrix), method = "euclidean")
col.cluster = hclust(col.distance, method = "ward.D2")

# Arguments for the dist() function are: euclidean (default), maximum, canberra,
# binary, minkowski, manhattan
# And arguments for hclust(): complete (default), single, average, mcquitty,
# median, centroid, ward.D2

###############################################################################
## Assign Column labels (Optional)
###############################################################################

colLabels <- as.character(normals)
colLabels[colLabels == "TRUE"] <- "#377EB8"
colLabels[colLabels == "FALSE"] <- "#E41A1C"

###############################################################################
## Plotting the Heatmap!! (where all colorful things happen...)
###############################################################################

png("heatmap.png", # Name of png file
    width = 6 * 500,      # Easier scaling 6*500 = 3000 pixels
    height = 6 * 400,     # 6 x 400 = 2400 px
    units = "px",         # px (Pixels = default), in (inches), cm or mm
    res = 300,            # 300 pixels per inch
    pointsize = 10)        # font size

heatmap.2(PDSmatrix,
          main = "PDS-Heatmap",   # heat map title
          density.info = "none",  # turns off density plot inside color legend
          trace = "none",         # turns off trace lines inside the heat map
          margins = c(10,21),     # widens margins around plot
          col = my_palette,       # use on color palette defined earlier
          Rowv = as.dendrogram(row.cluster), # apply selected clustering method
          Colv = as.dendrogram(col.cluster), # apply selected clustering method
          keysize = 0.8,          # size of color key
          #Additional Options
          ## Color labeled columns
          ColSideColors = colLabels
)
## Legend for ColumnSide color labeling
par(lend = 1)           # square line ends for the color legend
legend("topright",      # location of the legend on the heatmap plot
       legend = c("Normals", "Tumors"), # category labels
       col = c("dodgerblue", "firebrick1"),  # color key
       lty= 1,          # line style
       lwd = 5, unit    # line width
)
dev.off()               # close the PNG device
