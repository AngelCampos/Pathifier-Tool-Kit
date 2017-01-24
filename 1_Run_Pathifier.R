################################################################################
# Running PATHIFIER (Drier et al., 2013)
# Author: Miguel Angel Garcia-Campos - Github: https://github.com/AngelCampos
################################################################################

# Install/load package ##############
source("http://bioconductor.org/biocLite.R")
if (!require("pathifier")){biocLite("pathifier", ask=FALSE); library(pathifier)}

# Load expression data for PATHIFIER
exp.matrix <- read.delim(file =file.choose(), as.is = T, row.names = 1)

# Load Genesets annotation 
gene_sets <- as.matrix(read.delim(file = file.choose(), header = F, sep = "\t",
                                  as.is = T))


#  Generate a list that contains genes in genesets
gs <- list()
for (i in 1:nrow(gene_sets)){
  a <- as.vector(gene_sets[i,3:ncol(gene_sets)])
  a <- na.omit(a)
  a <- a[a != ""]
  a <- matrix(a, ncol = 1)
  gs[[length(gs)+1]] <- a
  rm(a,i)
}

# Generate a list that contains the names of the genesets used
pathwaynames <- as.list(gene_sets[,1])

# Generate a list that contains the previos two lists: genesets and their names
PATHWAYS <- list(); PATHWAYS$gs <- gs; PATHWAYS$pathwaynames <- pathwaynames

# Prepare data and parameters ##################################################
# Extract information from binary phenotypes. 1 = Normal, 0 = Tumor
normals <- as.vector(as.logical(exp.matrix[1,]))
exp.matrix <- as.matrix(exp.matrix[-1, ])

# Calculate MIN_STD
N.exp.matrix <- exp.matrix[,as.logical(normals)]
rsd <- apply(N.exp.matrix, 1, sd)
min_std <- quantile(rsd, 0.25)

# Calculate MIN_EXP 
min_exp <- quantile(as.vector(exp.matrix), 0.1) # Percentile 10 of data

# Filter low value genes. At least 10% of samples with values over min_exp
# Set expression levels < MIN_EXP to MIN_EXP
over <- apply(exp.matrix, 1, function(x) x > min_exp)
G.over <- apply(over, 2, mean)
G.over <- names(G.over)[G.over > 0.1]
exp.matrix <- exp.matrix[G.over,]
exp.matrix[exp.matrix < min_exp] <- min_exp

# Set maximum 5000 genes with more variance
V <- names(sort(apply(exp.matrix, 1, var), decreasing = T))[1:5000]
V <- V[!is.na(V)]
exp.matrix <- exp.matrix[V,]
genes <- rownames(exp.matrix) # Checking genes
allgenes <- as.vector(rownames(exp.matrix))

# Generate a list that contains previous data: gene expression, normal status,
# and name of genes
DATASET <- list(); DATASET$allgenes <- allgenes; DATASET$normals <- normals
DATASET$data <- exp.matrix

# Run Pathifier
PDS <- quantify_pathways_deregulation(DATASET$data, 
                                      DATASET$allgenes,
                                      PATHWAYS$gs,
                                      PATHWAYS$pathwaynames,
                                      DATASET$normals, 
                                      maximize_stability = T,
                                      attempts = 100,
                                      logfile="logfile.txt",
                                      min_std = min_std,
                                      min_exp = min_exp)
# Remove unnecesary data
rm(gene_sets, exp.matrix, allgenes, DATASET, PATHWAYS, rsd, V, over, G.over, 
   N.exp.matrix, gs, genes, min_exp, min_std, pathwaynames)

# Save image into working directory
save.image("PDS.RData")