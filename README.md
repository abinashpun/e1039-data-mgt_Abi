# e1039-data-mgt
Intended for developing the method of automatic submission of grid jobs for decoded data.

```
renew_proxy.sh
```
Script to use kcron to generate a proxy needed for the job submission following the [Fermilab instruction](https://cdcvs.fnal.gov/redmine/projects/fife/wiki/Authentication#Authentication-with-kcron-for-SL7).

```
run_gridjob.sh
```
Script to use the proxy generated by `renew_proxy.sh` for running the grid job and doing the following steps;
- List out all the decoded runs and save the run numbers
- Find out the newly decoded runs and copy them to `pnfs/e1039/tape_backed/decoded_data` area
- Loop over new decoded data, find out the ones with more than one splitted files and run the grid job

```
re_run_gridjob.sh
```
This script also uses proxy certificate generated by `renew_proxy.sh` and 
- looks at the log files of the submitted jobs
- Resubmit the failed jobs based on the status (!=0) stored in log files(due to bad job nodes and mysql error)
- To Do: jobs without log files (even after 24 hours)

```
gridrun_data.sh
gridsub_data.sh
```
These are the original scripts to run real data in grid with the macro, `RecoE1039Data.C`. Currently the reconstructed outputs are saved in `/pnfs/e1039/persistent/cosmic_recodata/` area. The splitting is handled in decoding level itself (by Kenichi). For now, the splitting is done for every 100 interval of spills.

#### crontab list:
```
0 0 */5 * * /usr/bin/kcron /path_to_script_area/renew_proxy.sh
0 */3 * * * /usr/bin/kcron /path_to_script_area/run_gridjob.sh
0 */4 * * * /usr/bin/kcron /path_to_script_area/re_run_gridjob.sh
```
First cron job in the list renews the proxy certificate every 5 days and store it in `/var/tmp/${USER}.${ROLE}.proxy` area. The last two jobs uses the certificate from that area. The second cron job is submitting grid jobs every 3 hours and third cron job is re-submitting the failed jobs every four hours.
