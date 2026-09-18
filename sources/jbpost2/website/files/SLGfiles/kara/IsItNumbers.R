#Anders, S., McCarthy, D., et al. (2013) 
# Count-based differential expression analysis
# of RNA sequencing data using R and Bioconductor.
# Nature Protocols,8(9) 1765–1786. doi:10.1038/nprot.2013.099

# This is an example from the above protocol,
# placed in one document for demonstration purposes.
# See original paper for full details.

#-----------------------------------------------------
# Load the edgeR package and use the utility function,
# readDGE, to read in the count files from a transcript 
# quantification software, such as HTSeq-Count

source("https://bioconductor.org/biocLite.R")
biocLite("edgeR")

library("edgeR")

counts <- readDGE(samples$countf)$counts

#----------------------------------------------
# Filter weakly expressed features 
# (less than 1 read per million in a group)

noint <- rownames(counts) %in% 
  c("no_feature", "ambiguous", "too_low_aQual",
    "not_aligned", "alignment_not_unique")

cpms <- cmp(counts)

keep <- rowSums(cpms > 1) >= 3 & !noint

counts <- counts[keep, ]

#----------------------------------------------
#Visualize and inspect the count table

colnames(counts) <- samples$shortname

head(counts[, order(samples$condition)], 5)

#----------------------------------------------
#Create a DGEList object
d <- DGEList(counts = counts, group = samples$condition)

#----------------------------------------------
#Estimate normalization factors

d <- calcNormFactors(d)

#----------------------------------------------
#Create a design matrix
design <- model.matrix( ~ 0 + group, data = samples)

#estimate dispersion values
disperse <- EstimateGLMTrendedDispersion(d, design)

#Fit the model
model <- glmFit(disperse, design)

de <- glmLRT(model, "SYNTAX for DESIRED CONTRAST HERE")

#----------------------------------------------
# Chen, Y., McCarthy, D. et al. (2008) 
# edgeR: differential expression analysis of 
# digital gene expression data user’s guide.

# Below is a brief example from the edgeR user's
# guide to get a feel for the sytax involved.
# See user's guide for more examples and 
# package details. 
#----------------------------------------------

#EXAMPLE 1:     (pg. 30)

#Group B vs. Group A
de <- glmLRT(model, contrast = c(-1, 1, 0))

#Group A vs. average of Group B, Group C
de <- glmLRT(model, contrast = c(1, -0.5, -0.5))


#You can do the same thing with coefficients
design2 <- model.matrix( ~ group, data = samples)

#Group B vs. Group A
de2 <- glmLRT(model, coef=2)

#Similar syntax with added covariates
design3 <- model.matrix( ~ group + time + group:time, data=samples)













