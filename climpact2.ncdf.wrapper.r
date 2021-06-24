# ------------------------------------------------
# This wrapper script calls the 'create.indices.from.files' function from the modified climdex.pcic.ncdf package
# to calculate ETCCDI, ET-SCI and other indices, using data and parameters provided by the user.
# Note even when using a threshold file, the base.range parameter must still be specified accurately.
# ------------------------------------------------

library(climdex.pcic.ncdf)

# use like `Rscript climpact2.ncdf.wrapper.r INFILE THRESHOLDS OUTDIR`

args<-commandArgs(TRUE)

# list of one to three input files. e.g. c("a.nc","b.nc","c.nc")
infiles=c()
if (nchar(args[1]) > 0) {
    infiles=c(args[1], args[2])
}
if (nchar(args[3]) > 0) {
    infiles=c(infiles, c(args[3]))
}
print(infiles)

# list of variable names according to above file(s)
vars=c(prec="pr",tmax="tasmax", tmin="tasmin")
#vars=c(prec="precip",tmax="tmax", tmin="tmin")

# output directory. Will be created if it does not exist.
outdir=toString(args[5])

# Output filename format. Must use CMIP5 filename convention. i.e. "var_timeresolution_model_scenario_run_starttime-endtime.nc"
file.template="var_daily_climpact.sample_historical_NA_1991-2010.nc"

# author data
author.data=list(institution="ARC Centre of Excellence for Climate Extremes", institution_id="CLEX")

# reference period
base.range=c(1981,2010)

# number of cores to use, or FALSE for single core.
cores=as.integer(Sys.getenv(c("PBS_NCPUS")))

# list of indices to calculate, or NULL to calculate all.
indices=NULL	#c("hw","tnn")

# input threshold file to use, or NULL for none.
if (nchar(args[4]) > 0) {
    thresholds.files=toString(args[4])
} else {
    thresholds.files = NULL
}



#######################################################
# Esoterics below, do not modify without a good reason.

# definition used for Excess Heat Factor (EHF). "PA13" for Perkins and Alexander (2013), this is the default. "NF13" for Nairn and Fawcett (2013).
EHF_DEF = "PA13"

# axis to split data on. For chunking up of grid, leave this.
axis.name="Y"

# Number of data values to process at once. If you receive "Error: rows.per.slice >= 1 is not TRUE", try increasing this to 20. You might have a large grid.
maxvals=40

# output compatible with FCLIMDEX. Leave this.
fclimdex.compatible=FALSE

# Call the package.
create.indices.from.files(infiles,outdir,file.template,author.data,variable.name.map=vars,base.range=base.range,parallel=cores,axis.to.split.on=axis.name,climdex.vars.subset=indices,thresholds.files=thresholds.files,fclimdex.compatible=fclimdex.compatible,
	cluster.type="SOCK",ehfdef=EHF_DEF,max.vals.millions=maxvals,
	thresholds.name.map=c(tx05thresh="tx05thresh",tx10thresh="tx10thresh", tx50thresh="tx50thresh", tx90thresh="tx90thresh",tx95thresh="tx95thresh", 
			tn05thresh="tn05thresh",tn10thresh="tn10thresh",tn50thresh="tn50thresh",tn90thresh="tn90thresh",tn95thresh="tn95thresh",
			tx90thresh_15days="tx90thresh_15days",tn90thresh_15days="tn90thresh_15days",tavg90thresh_15days="tavg90thresh_15days",
			tavg05thresh="tavg05thresh",tavg95thresh="tavg95thresh",
			txraw="txraw",tnraw="tnraw",precraw="precraw", 
			r95thresh="r95thresh", r99thresh="r99thresh"))
