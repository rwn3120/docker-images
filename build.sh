#!/bin/bash -e
function out() { echo -e "\e[32m${@}\e[39m"; }
function err() { echo -e "\e[31m${@}\e[39m" 1>&2; }

SCRIPT=$(readlink -f "${0}")
SCRIPT_BASENAME=$(basename "${SCRIPT}")
SCRIPT_NAME=$(echo "${SCRIPT_BASENAME}" | sed 's/\\..*//')
SCRIPT_DIR=$(dirname "${SCRIPT}")

REPO="radowan"
USAGE="${SCRIPT_NAME} - builds docker image

Usage:  ${SCRIPT_NAME} [OPTIONS] <directory with docker image>

Options:
            -p ... push/publish image (same as export PUSH=yes)
            -h ... display this help"

# parse args
while getopts ":ph" opt; do
	case $opt in
    	"p")	PUSH="yes"
                ;;
        "h")    out "${USAGE}"
                exit 0
                ;;
        \?)     err "Invalid option: -$OPTARG"
                exit 1
                ;;
    esac
done
shift $(($OPTIND - 1))
DOCKER_DIRECTORY="${1}"

# check args
if [ "${DOCKER_DIRECTORY}" == "" ]; then
    err "Missing an argument. Run with -h for details."
    exit 2
fi

# get real path to Dockerfile
DOCKER_DIRECTORY="$(readlink -f "${DOCKER_DIRECTORY}")"
if [ ! -d "${DOCKER_DIRECTORY}" ]; then
    err "${DOCKER_DIRECTORY} does not exists or is not a directory."
    exit 3
fi

function buildDockerImage() {
  REPO="${1}"
  NAME="${2}"
  TAG=$(basename "${3}")
  DOCKERFILE_PATH="${4}"
  BUILD_ARGS="${5}"
  BUILD_DIR="$(dirname "${DOCKERFILE_PATH}")"

  FINAL_TAG="${REPO}/${NAME}:${TAG}"
  out "Processing ${TAG} with ${DOCKERFILE_PATH}..."

  # build image
  docker build \
      -t "${FINAL_TAG}" \
      -f "${DOCKERFILE_PATH}" \
      ${BUILD_ARGS} \
      "${BUILD_DIR}"

  # distribute image
  if [ "${PUSH}" == "yes" ]; then
      out "... pushing to ${REPO}"
      docker push "${FINAL_TAG}"
  fi
  out "... done. Run with docker run -it --rm ${FINAL_TAG}"
}

function getBuildArgs() {
  BUILD_ARGS_FILE="${1}/build-args"
  if [ -f "${BUILD_ARGS_FILE}" ]; then
    cat "${BUILD_ARGS_FILE}" | sed 's/\(^#\|#\).*//' | xargs
  fi
}

# process images
NAME="$(basename "${DOCKER_DIRECTORY}")"
TAGS="${DOCKER_DIRECTORY}/tags"
if [ -d "${TAGS}" ]; then
  for TAG in "${TAGS}"/*; do
    # if tag has its own dockerfile than use it
    if [ -f "${TAG}/Dockerfile" ]; then
      DOCKERFILE_PATH="${TAG}/Dockerfile"
    # otherwise use shared dockerfile
    elif [ -f "${DOCKER_DIRECTORY}/Dockerfile" ]; then
      DOCKERFILE_PATH="${DOCKER_DIRECTORY}/Dockerfile"
    else
      err "Could not find Dockerfile for ${NAME}"
      exit 4
    fi
    out "Using ${DOCKERFILE_PATH}"
    if [ ! -d "${TAG}" ]; then
      err "${TAG} is not a directory!"
      continue
    fi
    buildDockerImage "${REPO}" ${NAME} "${TAG}" "${DOCKERFILE_PATH}" "$(getBuildArgs "${TAG}")"
  done
else
  if [ -f "${DOCKER_DIRECTORY}/Dockerfile" ]; then
    DOCKERFILE_PATH="${DOCKER_DIRECTORY}/Dockerfile"
  else
    err "Could not find Dockerfile for ${NAME}"
    exit 4
  fi
  buildDockerImage "${REPO}" ${NAME} latest "${DOCKERFILE_PATH}" "$(getBuildArgs "${DOCKER_DIRECTORY}")"
fi
echo done
