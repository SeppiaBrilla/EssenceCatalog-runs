#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob
if [[ -v RUN_TYPE ]]; then
    TYPE="$RUN_TYPE"
else
    TYPE="sbatch"
fi
mkdir -p logs/versions
(scutil --get ComputerName || hostname || echo "unknown host") 2> /dev/null | tee logs/versions/computer_name.txt
conjure --version               | tee logs/versions/conjure_version.txt
savilerow -help | head -n1      | tee logs/versions/savilerow_version.txt
minion | head -n2               | tee logs/versions/minion_version.txt

nb_cores=$1
scripts/solutions/gen_conjure_commands.sh
scripts/solutions/gen_solutions.sh $nb_cores
if [[ "${TYPE}" -eq "sbatch" ]]; then
	script/solutions/run_sbatch.sh
fi
scripts/solutions/collect_info.sh
scripts/solutions/clean_up.sh

