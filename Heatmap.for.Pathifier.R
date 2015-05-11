###############################################################################
## Heatmap for Pathifier results in R
### Author: Angel García-Campos
#### Base by wonderful: Sebastian Raschka https://github.com/rasbt
###############################################################################

###############################################################################
## Load Pathifier results and turn into a matrix
###############################################################################

load ("PDS.RData")
PDSmatrix <- mapply(FUN = c, PDS$scores)
PDSmatrix <- t(PDSmatrix)

###############################################################################
## Generating and assigning labels for pathways used in the analysis
###############################################################################

# Read input pathways from .txt
pathways <- read.delim("pathways.txt", header = F)
rownames(pathways) <- pathways[,2] # Naming rownames

# Extract NUMBER of pathways that succesfully used Pathifier
pathwaysInPDS <- rownames(PDSmatrix)  

# Selecting the NAMES of pathways
paths <- as.vector(pathways[,1])      # Extracting pathway names in vector
names(paths) <- pathways[,2]          # Nombrar vector con pathways
labels <- paths[pathwaysInPDS]        # Selects names of pathways as labels

rownames(PDSmatrix) <- labels         # assign labels as row names in PDSmatrix

###############################################################################
### Installing and/or loading required packages "gplots" "RColorBrewer"
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
## Creating Palette
###############################################################################

# creates a own color palette passing from blue, green yellow to red
my_palette <- colorRampPalette(c("blue", "cyan", "chartreuse1", "yellow", 
                                 "red", "firebrick4"))(n = 1000)

# (optional) defines the color breaks manually for a "skewed" color transition
# col_breaks = c(seq(-1,0,length=100),               
#                seq(0,0.8,length=100),              
#                seq(0.8,1,length=100))              

###############################################################################
## Clustering Methods
###############################################################################

# If you want to change the default clustering method (complete linkage method 
# with Euclidean distance measure), this can be done as follows: For non-square 
# matrix, we can define the distance and cluster based on our matrix data by

row.distance = dist(PDSmatrix, method = "euclidean")
row.cluster = hclust(row.distance, method = "average")

col.distance = dist(t(PDSmatrix), method = "euclidean")
col.cluster = hclust(col.distance, method = "average")

# Arguments for the dist() function are: euclidean (default), maximum, canberra, 
# binary, minkowski, manhattan

# And arguments for hclust(): complete (default), # single, average, mcquitty, 
# median, centroid, ward. 

# Note that for non-square matrices you have to define the distance and cluster 
# for both row and column dendrograms separately.
# Otherwise you will get a not so pleasant Error in:

# x[rowInd, colInd] : subscript out of bounds.

###############################################################################
## Assign Columns labels (Optional) Uncomment
###############################################################################

# scores <- read.delim(file = "scores.txt", header = T)
# scores <- scores[,2:ncol(scores)]
# 
# colnames(PDSmatrix) <- colnames(scores)
# # colnames (PDSmatrix) <- NULL # Uncomment for removing labelnames for columns

###############################################################################
## Plotting the Heatmap!! (where all colorful things happen...)
###############################################################################

png("heatmap+labels.png", # Name of png file       
    width = 6 * 500,      # Easier scaling 6*500 = 3000 pixels
    height = 6 * 400,     # 6 x 400 = 2400 px
    units = "px",         # px (Pixels = default), in (inches), cm or mm
    res = 300,            # 300 pixels per inch
    pointsize = 7)        # font size

heatmap.2(PDSmatrix,
          main = "Gene Ontology - Apoptosis",          # heat map title
          density.info= "none",  # turns off density plot inside color legend
          trace= "none",         # turns off trace lines inside the heat map
          margins= c(10,21),     # widens margins around plot
          col=my_palette,        # use on color palette defined earlier 
          Rowv = as.dendrogram(row.cluster), # apply selected clustering method
          Colv = as.dendrogram(col.cluster), # apply selected clustering method
          keysize= 0.8           # size of color key
## Color labeling columns (Opt. RowSideColors for rows)
          ColSideColors= c(           # Grouping col-samples into two different
            rep("dodgerblue", 10),    # categories, Samples 1-10: blue (normals)
            rep("firebrick1", 90)),    # Samples 11-100 (tumors)
#Additional Options
#           breaks= col_breaks,  # enable color transition at specified limits
#           dendrogram= "col",   # only draw a columns dendrogram (opt. "row")
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
