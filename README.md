# e1i03i9-data-mgt
Intended for developing the method of automatic submission of grid jobs for decodedd data.

```
renew_proxy.sh
```
Script to use kcron to generate a proxy needed for the job submission following the [Fermilab instruction](https://cdcvs.fnal.gov/redmine/projects/fife/wiki/Authentication#Authentication-with-kcron-for-SL7).

```
run_gridjob.sh
```
Script to use the proxy generated by `renew_proxy.sh` for running the grid job and doing the following steps;
- List out all the decoded runs and save the run numbers
- Find out the newly decoded runs and copy them to `pnfs/e1039/tape_backed/decoded_data area`
- Loop over new decoded data, find out the ones with more than one splitted files and run the grid job

```
gridrun_data.sh
gridsub_data.sh
```
These are the original scripts to run real data in grid with the macro, `RecoE1039Data.C`. Currently the reconstructed outputs are saved in `/pnfs/e1039/persistent/cosmic_recodata/` area. The splitting is handled in decoding level itself (by Kenichi). For now, the splitting is done for every 100 interval of spills.

#### Note:
Some of the variables are set specific to my work area which are needed to change if you want this method to try yourself.



