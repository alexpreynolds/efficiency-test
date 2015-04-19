# starch-efficiency

These scripts can be used to test the relative efficiency of BEDOPS v2.4.12 ``starch --bzip2`` and ``--gzip`` options on randomly generated BED3, Bedgraph, and composite (BED3 + Bedgraph) data at scales of 1K to 1M elements, at 10-fold increments. Other element sizes and increments can be tested by the end user with appropriate tweaks of the ``makefile``.

## Requirements

The sampling scripts require installation of BEDOPS ``starch`` and a recent MySQL client. The R script ``starch_eff.R`` requires ``optparse`` and ``lattice`` libraries. Use ``install.packages()`` to install these, as needed. 

## Procedure

Chromosome names and element starting positions are generated randomly using UCSC hg19 records. The makefile ``WINDOW`` parameter creates a 150 nt wide element. This window parameter can be removed to create elements of random length, from 1 to 1000 bases long, past the randomly chosen starting position.

This procedure creates the desired number of elements, and it should be reasonably representative of chromosome name, genomic positions and lengths that would be found in real-world data. 

In the case of a composite BED file (BED3 + Bedgraph), the build process uses ``paste`` to join the results of a sample BED3 file to a separately sampled Bedgraph file. This is called a "trial". This process is repeated for 10 trials (which can be changed in the ``makefile``).

Each trial BED file is compressed with the currently installed version of ``starch`` (v2.4.12 as of writing) with the ``--bzip2`` or ``--gzip`` option. Original and compressed file sizes are measured, and R is used to make a box plot of ratios from all the trials for a given class of compression type (bzip2 or gzip).

## Results

One test of median compression ratios for simulated BED3, 150 nt elements, 10 trials, run with the BEDOPS v2.4.12 toolkit:

| elements | bzip2-starch | gzip-starch |
|----------|--------------|-------------|
| 1000     | 1.30         | 1.23        |
| 10000    | 0.20         | 0.20        |
| 100000   | 0.07         | 0.08        |
| 1000000  | 0.04         | 0.06        |

The same test for simulated Bedgraph (BED3 + float), 150 nt elements, 10 trials:

| elements | bzip2-starch | gzip-starch |
|----------|--------------|-------------|
| 1000     | 1.10         | 1.05        |
| 10000    | 0.25         | 0.27        |
| 100000   | 0.15         | 0.19        |
| 1000000  | 0.12         | 0.17        |

The same test for the composite case (simulated BED3 + Bedgraph, 150 nt elements, 10 trials):

| elements | bzip2-starch | gzip-starch |
|----------|--------------|-------------|
| 1000     | 0.79         | 0.75        |
| 10000    | 0.27         | 0.32        |
| 100000   | 0.21         | 0.29        |
| 1000000  | 0.18         | 0.27        |

For a "composite" BED file containing 1M elements, for instance, the approximate bzip2-backed Starch compression efficiency will be ~18% of the original, uncompressed file size. This compares with ~4% of the original size with a simple 1M BED3 file, and ~12% of a Bedgraph (BED3 + float) file.

Basically, Starch compression works at its best when it is reducing BED data — and only BED data — and doesn't have additional columns to work with.
