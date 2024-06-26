#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

PROBLEM=$1
ESSENCE=$2
PARAM=$3
CONJURE_MODE=$4
SAVILEROW_MODE=$5
EPRIME=$6
SOLVER=$7
ESSENCE_BASE="${ESSENCE%.*}"
ESSENCE_FULL="EssenceCatalog/problems/${PROBLEM}/${ESSENCE}"
PARAM_FULL="EssenceCatalog/problems/${PROBLEM}/${PARAM}"
EPRIME_SRC="problems/${PROBLEM}/conjure-mode/${CONJURE_MODE}/${EPRIME}"
TARGET_DIR="problems/${PROBLEM}/conjure-mode/${CONJURE_MODE}/savilerow-mode/${SAVILEROW_MODE}/solver/${SOLVER}"
mkdir -p "${TARGET_DIR}"

LIMIT_TIME_PADDED=$(( LIMIT_TIME + 300 ))

SAVILEROW_OPTIONS="-timelimit ${LIMIT_TIME}"
if [ "${SAVILEROW_MODE}" == "O0" ]; then
    SAVILEROW_OPTIONS="${SAVILEROW_OPTIONS} -O0"
elif [ "${SAVILEROW_MODE}" == "O1" ]; then
    SAVILEROW_OPTIONS="${SAVILEROW_OPTIONS} -O1"
elif [ "${SAVILEROW_MODE}" == "O2" ]; then
    SAVILEROW_OPTIONS="${SAVILEROW_OPTIONS} -O2"
elif [ "${SAVILEROW_MODE}" == "O3" ]; then
    SAVILEROW_OPTIONS="${SAVILEROW_OPTIONS} -O3"
else
    echo "SAVILEROW_MODE not recognised: ${SAVILEROW_MODE}"
    exit 1
fi
if [ "${SOLVER}" == "minion" ]; then
    SOLVER_OPTIONS="-cpulimit ${LIMIT_TIME} -varorder domoverwdeg -preprocess GAC"
elif [ "${SOLVER}" == "lingeling" ]; then
    SOLVER_OPTIONS="-t ${LIMIT_TIME} --seed=0"
elif [ "${SOLVER}" == "chuffed" ]; then
    SOLVER_OPTIONS="-t ${LIMIT_TIME}000 --rnd-seed 0"
elif [ "${SOLVER}" == "kissat" ]; then
    SOLVER_OPTIONS="--time=${LIMIT_TIME} --seed=0"
elif [ "${SOLVER}" == "or-tools" ]; then
    SOLVER_OPTIONS="--time_limit=${LIMIT_TIME} --cp_random_seed 0 --fz_seed 0"
elif [ "${SOLVER}" == "or-tools1" ]; then
    SOLVER="or-tools"
    SOLVER_OPTIONS="--time_limit=${LIMIT_TIME} --cp_random_seed 0 --fz_seed 0 --threads=1"
elif [ "${SOLVER}" == "or-tools4" ]; then
    SOLVER="or-tools"
    SOLVER_OPTIONS="--time_limit=${LIMIT_TIME} --cp_random_seed 0 --fz_seed 0 --threads=4"
elif [ "${SOLVER}" == "cplex" ]; then
    SOLVER_OPTIONS="--time-limit ${LIMIT_TIME}"
else
    echo "SOLVER not recognised: ${SOLVER}"
    exit 1
fi

podman run -it --rm \
    --network=none \
    -v "$PWD:/podmandir:z" \
    --cpus=2 \
    --memory=8g \
    --timeout=${LIMIT_TIME_PADDED} \
    "ghcr.io/conjure-cp/conjure@sha256:94a42ff880f38989625a53a03315e44313866a1eda76f268dccb941734d55e29" \
    conjure solve --use-existing-models=/podmandir/${EPRIME_SRC} /podmandir/${ESSENCE_FULL} /podmandir/${PARAM_FULL} -o /podmandir/${TARGET_DIR} \
    --copy-solutions=off \
    --log-level LogNone \
    --savilerow-options "${SAVILEROW_OPTIONS}" \
    --solver "${SOLVER}" \
    --solver-options "${SOLVER_OPTIONS}"

echo ${TARGET_DIR}
rm -f ${TARGET_DIR}/*.eprime-minion         # no need to keep: generated minion file
rm -f ${TARGET_DIR}/*.eprime-dimacs         # no need to keep: generated sat file
rm -f ${TARGET_DIR}/*.eprime-param          # no need to keep
rm -f ${TARGET_DIR}/*.eprime-fzn            # no need to keep
rm -f ${TARGET_DIR}/*.eprime-param.fzn      # no need to keep
rm -f ${TARGET_DIR}/*.eprime.mzn            # no need to keep

# do not rm the eprime file yet, it may be needed by multiple parameter files
# it will be removed by a call to clean_up.sh
