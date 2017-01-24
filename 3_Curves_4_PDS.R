################################################################################
# Plotting Principal Cuves for Pathifier Results
## Author: Miguel Angel Garcia Campos github: https://github.com/AngelCampos
################################################################################
# Installing and/or loading required packages
if (!require("plotly")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}

################################################################################
# Load Pathifier results and turn into a matrix
load ("PDS.RData")
PDSmatrix <- t(mapply(FUN = c, PDS$scores))

################################################################################
# Plotting Principal Curves
curve.data.PDS <- function(pw){
  x <- PDS$curves[[pw]][which(normals),] # Healthy samples
  y <- PDS$curves[[pw]][which(!normals),] # Tumoral samples
  v <- PDS$z[[pw]][which(normals),]
  z <- PDS$z[[pw]][which(!normals),]
  p <- plot_ly(x = x[,1], y = x[,2],z = x[,3], type = "scatter3d", 
               name = "Healthy", marker = list(size = 4))
  add_trace(p, x = y[,1], y = y[,2], z = y[,3], type = "scatter3d", 
            name = "Tumors",marker = list(size = 4)) %>%
    add_trace(p, x = v[,1], y = v[,2], z = v[,3], type = "scatter3d", 
              name = "Data-Healthy", marker = list(size = 2)) %>%
    add_trace(p, x = z[,1], y = z[,2], z = z[,3], type = "scatter3d", 
              name = "Data-Tumoral", marker = list(size = 2)) %>%
    layout(title = paste("Principal curve of", rownames(PDSmatrix)[pw]))
}

curve.PDS <- function(pw){
  x <- PDS$curves[[pw]][which(normals),] # Healthy samples
  y <- PDS$curves[[pw]][which(!normals),] # Tumoral samples
  p <- plot_ly(x = x[,1], y = x[,2],z = x[,3], type = "scatter3d", 
               name = "Healthy", marker = list(size = 4))
  add_trace(p, x = y[,1], y = y[,2], z = y[,3], type = "scatter3d", 
            name = "Tumors",marker = list(size = 4)) %>%
    layout(title = paste("Principal curve of", rownames(PDSmatrix)[pw]))
}

################################################################################
# Examples:
# Plotting the samples on their principal curves of pathway # 1
curve.data.PDS(1)
# Plotting the data of the samples and their projected points to the principal
# curve of pathway # 2
curve.PDS(2)
