#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

ROOT_DIR=$(pwd)
CMD_FILE="${ROOT_DIR}/scripts/modelling/conjure_commands.txt"

nb_commands=$(cat ${CMD_FILE} | wc -l)
nb_cores=$1

if (( ${nb_commands} > 0 )) ; then
    echo "Number of commands to run: ${nb_commands}"
    echo "Number of cores to use   : ${nb_cores}"
    find problems -name '*.eprime' -delete
    mkdir -p logs/gnuparallel
    parallel                                                \
        --no-notice                                         \
        -j"${nb_cores}"                                     \
        --eta                                               \
        --results logs/gnuparallel/modelling-results        \
        --joblog  logs/gnuparallel/modelling-joblog         \
        :::: ${CMD_FILE} || true        # allowed to fail due to SR timeouts
    LC_ALL=C sort -n logs/gnuparallel/modelling-joblog -o logs/gnuparallel/modelling-joblog
    # this is to drop the 2nd and the 3rd columns
    # 2nd is the host, which we always expect to be ":"
    # 3rd is the StartTime
    cat logs/gnuparallel/modelling-joblog | cut -f 1,4- > logs/gnuparallel/modelling-joblog.cropped
    mv logs/gnuparallel/modelling-joblog.cropped logs/gnuparallel/modelling-joblog
else
    echo "No commands found in \"${CMD_FILE}\""
    echo "You may want to run \"scripts/modelling/gen_conjure_commands.sh\" first."
fi


# strip the json bits from the eprimes
# parallel "[ -f {} ] && (cat {} | grep -v '\\$' > {}.temp ; mv {}.temp {})" ::: $(find problems -name "*.eprime")

