#!/usr/bin/env Rscript

suppressPackageStartupMessages(require(optparse))
option_list = list(
    make_option(c("-i", "--inFnPrefix"), action="store", default=NA, type='character', help="input filename prefix"),
    make_option(c("-o", "--outFn"), action="store", default=NA, type='character', help="output filename"),
    make_option(c("-e", "--elementsStr"), action="store", default=NA, type='character', help="elements string (comma-delimited)")
    )
opt = parse_args(OptionParser(option_list=option_list))

if (is.na(opt$inFnPrefix) || is.na(opt$outFn)) {
    cat("Error: Please specify --inFnPrefix and --outFn parameters\n")
    q()
}

elements <- strsplit(opt$elementsStr, ",")

elements_length <- length(as.vector(elements[[1]]))

categories <- c("bzip2", "bzip2_starch", "gzip", "gzip_starch")

categories_length <- length(categories)

df <- data.frame("elements" = numeric(), "ratio" = numeric(), "category" = character(), stringsAsFactors=FALSE)

for (element in as.vector(elements[[1]])) {
    inFn <- paste(opt$inFnPrefix, element, "txt", sep=".")
    input <- read.table(inFn, col.names=c("original","bzip2","bzip2_starch","gzip","gzip_starch","elements","bzip2_ratio","bzip2_starch_ratio","gzip_ratio","gzip_starch_ratio"), skip=1)
    df[nrow(df) + 1, ] <- c(element, signif(mean(input$bzip2_ratio), digits=4), "bzip2")
    df[nrow(df) + 1, ] <- c(element, signif(mean(input$bzip2_starch_ratio), digits=4), "bzip2_starch")
    df[nrow(df) + 1, ] <- c(element, signif(mean(input$gzip_ratio), digits=4), "gzip")
    df[nrow(df) + 1, ] <- c(element, signif(mean(input$gzip_starch_ratio), digits=4), "gzip_starch")
}

df$category <- as.factor(df$category)
print(df)

fmt <- function(){
    f <- function(x) as.character(round(as.numeric(x),2))
    f
}

suppressPackageStartupMessages(require(ggplot2))
pdf(paste(opt$outFn, "pdf", sep="."))

ggplot(df, aes(x=elements, y=ratio, group=category, colour=category)) + geom_line(aes(linetype=category)) + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) + ggtitle("Compression efficiency for\nsimulated hg19 bedgraph elements\n") + scale_color_brewer(palette="Set1") + scale_x_discrete(limits=elements[[1]]) + scale_y_discrete(labels=fmt())

dev.off()
