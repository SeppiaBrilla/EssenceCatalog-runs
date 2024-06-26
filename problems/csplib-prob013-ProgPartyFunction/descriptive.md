

# Options


- Number of models 4
- Number of solvers 4
- Number of params 64
- Number of params (completed) 29
- Number of params (all timed out) 3
- Number of params (analysed in this file) 26


## Models


 - 01_compact.eprime
 - 03_sparse.eprime
 - 04_nochPrunedLevels_3.eprime
 - 04_nochPrunedLevels_4.eprime


## Solvers


 - chuffed
 - cplex
 - kissat
 - or-tools1


# Total runtime with each option


 | Model | Solver | Total time (seconds) | 
 | -- | -- | -- | 
 | 01_compact.eprime | chuffed | 1384.07 | 
 | 01_compact.eprime | cplex | 252178.32 | 
 | 01_compact.eprime | kissat | 1689.29 | 
 | 01_compact.eprime | or-tools1 | 1963.66 | 
 | 03_sparse.eprime | chuffed | 39472.43 | 
 | 03_sparse.eprime | cplex | 540062.22 | 
 | 03_sparse.eprime | kissat | 5994.10 | 
 | 03_sparse.eprime | or-tools1 | 150460.53 | 
 | 04_nochPrunedLevels_3.eprime | chuffed | 7440.54 | 
 | 04_nochPrunedLevels_3.eprime | cplex | 540058.41 | 
 | 04_nochPrunedLevels_3.eprime | kissat | 40000.80 | 
 | 04_nochPrunedLevels_3.eprime | or-tools1 | 119936.17 | 
 | 04_nochPrunedLevels_4.eprime | chuffed | 40981.40 | 
 | 04_nochPrunedLevels_4.eprime | cplex | 540057.43 | 
 | 04_nochPrunedLevels_4.eprime | kissat | 5391.79 | 
 | 04_nochPrunedLevels_4.eprime | or-tools1 | 55255.30 | 
 | VBS | VBS | 1228.70 | 


## Some total runtime stats


 - Fastest option is ('01_compact.eprime', 'chuffed'), total runtime 1384.07
 - Slowest option is ('03_sparse.eprime', 'cplex'), total runtime 540062.22
 - VBS total runtime 1228.70
 - VBS as a percentage of SBS is 88.77%
