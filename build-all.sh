#!/bin/bash -e
function out() { echo -e "\e[32m${@}\e[39m"; }
function err() { echo -e "\e[31m${@}\e[39m" 1>&2; }

SCRIPT=$(readlink -f "${0}")
SCRIPT_BASENAME=$(basename "${SCRIPT}")
SCRIPT_NAME=$(echo "${SCRIPT_BASENAME}" | sed 's/\\..*//')
SCRIPT_DIR=$(dirname "${SCRIPT}")
BUILD_SCRIPT="${SCRIPT_DIR}/build.sh"

# build dependencies
declare -A DEPS_TREE
declare -A DEPS_SIZE
for DOCKERFILE in $(find "${SCRIPT_DIR}" -name "Dockerfile"); do
    PARENT=$(grep "^FROM " "${DOCKERFILE}" | head -1 | awk '{print $2}')
    if [ "${DEPS_TREE["${PARENT}"]}" != "" ]; then
        DEPS_TREE["${PARENT}"]="${DEPS_TREE["${PARENT}"]};${DOCKERFILE}"
    else
        DEPS_TREE["${PARENT}"]="${DOCKERFILE}"
    fi
    DEPS_SIZE["${PARENT}"]=$(echo "${DEPS_TREE["${PARENT}"]}" | tr -cd ';' | wc -c)
done

# sort dependencies
SORTED_DEPS=$(for PARENT in "${!DEPS_TREE[@]}"; do
    echo "${DEPS_SIZE["${PARENT}"]} ${DEPS_TREE["${PARENT}"]}"
done | sort -n | awk '{print $2}') 

DOCKER_FILES=()
# get sorted Dockerfiles
for DEPS in ${SORTED_DEPS}; do 
    while IFS=';' read -ra SPLITS; do
        for DEP in "${SPLITS[@]}"; do
            # process "$i"
            DOCKER_FILES+=("${DEP}")
        done
    done <<< "${DEPS}"
done 

DOCKER_FILES_COUNT=${#DOCKER_FILES[@]}
if [ ${DOCKER_FILES_COUNT} -gt 0 ]; then
    out "Found ${DOCKER_FILES_COUNT} Dockerfiles:"
    for DOCKER_FILE in "${DOCKER_FILES[@]}"; do 
        out "\t${DOCKER_FILE}"; 
    done
    out
    for DOCKER_FILE in "${DOCKER_FILES[@]}"; do 
        "${BUILD_SCRIPT}" "${@}" "${DOCKER_FILE}"
        out
    done
else 
    err "Nothing to build."
    exit 1
fi
