# Run Climpact on CORDEX output

 1. Install [Climpact](https://github.com/ARCCSS-extremes/climpact2) following its instructions
 2. Set the output directory in 'submit_tasks.py', 'list_incomplete.sh' and 'list_complete.sh'
 3. Adjust the search terms in 'submit_tasks.py' to select the desired runs
 4. Run 'submit_tasks.py' to submit jobs
    - The script must be run multiple times, the first run will submit jobs to calculate thresholds, which must be complete before the actual climpact calculation can start

'list_incomplete.sh' will list incomplete runs (both thresholds and climpact runs). Check the log files for more details of what went wrong if the job is no longer running

'list_complete.sh' will list complete runs

## Failed runs

Run `list_incomplete.sh` to get a list of runs that have been submitted but not completed (either because they are still running or because they have failed)

The submit script will skip incomplete runs, as there may be an error in the inputs (e.g. bad metadata, missing times etc.)

To see why a job failed check the log file - `climpact.log` or `thresholds.log` depending on the task - in the output directory

To reset the job and allow the submit script to run it again, delete the
`climpact.waiting` or `thresholds.waiting` file. Note the submit script will
also skip runs that have a `climpact.done`/`thresholds.done` file as those have
already completed successfully.

## Script method

The script searches the CMS intake-esm catalogue to find CORDEX runs to
process. This catalogue is updated once a week to add any new files downloaded
by NCI.

For each found run, if it is a historical experiment first a 'thresholds' job
will be submitted to calculate the threshold information needed by ssp
experiments. Otherwise a 'climpact' job will be submitted to calculate the
climpact metrics using these thresholds.

The jobs themselves run `run_climpact.pbs` which does some minor pre-processing
using the `preprocess.py` script, concatenating the input files along the time
axis and cleaning up some metadata, before running the Climpact R scripts on
the processed data.
