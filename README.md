# mongo-collect-stats
Utility scripts to collect various performance monitoring statistics.

Kudos to devkev for all the scripting magic.

Known Issue:
* It does not prevent you from starting up multiple copies of the script. (It will simply output to multiple files concurrently).
* It does not fail gracefuly if the utility (e.g. `vmstat`, `iostat` etc) are not executable. (It will output the error message to the output files).
