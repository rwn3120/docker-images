#!/bin/bash -e
function out() { echo -e "\e[32m${@}\e[39m"; }
function err() { echo -e "\e[31m${@}\e[39m" 1>&2; }

SCRIPT=$(readlink -f "${0}")
SCRIPT_BASENAME=$(basename "${SCRIPT}")
SCRIPT_NAME=$(echo "${SCRIPT_BASENAME}" | sed 's/\\..*//')
SCRIPT_DIR=$(dirname "${SCRIPT}")
BUILD_SCRIPT="${SCRIPT_DIR}/build.sh"

# images (sorted)
declare -a IMAGES=("base-image"
                   "debian-base" "debian-dev" 
                   "oraclelinux-java-8" "oraclelinux-mysql-5.7" "oraclelinux-cdh-5.13.1")

## now loop through the above array
for IMAGE in "${IMAGES[@]}"; do
    out "Building ${IMAGE}"
    "${BUILD_SCRIPT}" "${@}" "${SCRIPT_DIR}/${IMAGE}/Dockerfile"
done
