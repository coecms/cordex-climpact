# ------------------------------------------------
# This wrapper script calls the 'create.thresholds.from.file' function from the modified climdex.pcic.ncdf package
# to create thresholds, using data and parameters provided by the user.
# ------------------------------------------------

library(climdex.pcic.ncdf)

# use like `Rscript climpact2.ncdf.thresholds.wrapper.r INFILE OUTFILE`
args<-commandArgs(TRUE)

infiles=c()
if (nchar(args[1]) > 0) {
    infiles=c(args[1], args[2])
}
if (nchar(args[3]) > 0) {
    infiles=c(infiles, c(args[3]))
}

# list of variable names according to above file(s)
vars=c(tmax="tasmax", tmin="tasmin", prec="pr")

# output file name
output.file=toString(args[4])

# author data
author.data=list(institution="ARC Centre of Excellence for Climate Extremes", institution_id="CLEX")

# reference period
base.range=c(1981,2010)

# number of cores to use (or FALSE)
parallel=as.integer(Sys.getenv(c("PBS_NCPUS")))

# print messages?
verbose=TRUE



######################################
# Do not modify without a good reason.

fclimdex.compatible=FALSE

create.thresholds.from.file(infiles,output.file,author.data,variable.name.map=vars,base.range=base.range,parallel=parallel,verbose=verbose,fclimdex.compatible=fclimdex.compatible, max.vals.millions=40)
