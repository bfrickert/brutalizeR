library(dplyr)
coefs <- read.table('data/brutality.coefficients.tsv', sep='\t', stringsAsFactors = F, header = T)
coefs <- arrange(coefs, coef)
