#!/usr/bin/env Rscript

suppressPackageStartupMessages(require(optparse))
option_list = list(
    make_option(c("-i", "--inFn"), action="store", default=NA, type='character', help="input filename"),
    make_option(c("-o", "--outFn"), action="store", default=NA, type='character', help="output filename"),
    make_option(c("-e", "--elements"), action="store", default=NA, type='numeric', help="elements")
    )
opt = parse_args(OptionParser(option_list=option_list))

if (is.na(opt$inFn) || is.na(opt$outFn)) {
    cat("Error: Please specify --inFn and --outFn parameters\n")
    q()
}

input <- read.table(opt$inFn, col.names=c("original", "bzip2", "gzip"))
input$elements <- rep(opt$elements, nrow(input))
input$bzip2_ratio <- input$bzip2/input$original
input$gzip_ratio <- input$gzip/input$original
write.table(input, opt$outFn, append=FALSE, quote=FALSE, sep='\t', eol='\n', row.names=FALSE, col.names=TRUE)

type <- c(rep("bzip2", nrow(input)), rep("gzip", nrow(input)))
ratios <- c(input$bzip2_ratio, input$gzip_ratio)
bpdata <- data.frame(type, ratios)
suppressPackageStartupMessages(require(lattice))
pdf(paste(opt$outFn, "pdf", sep="."))
bwplot(ratios ~ type, data=bpdata, main=paste("Starch compression efficiency at ", opt$elements, " elements", sep=""))
dev.off()
