#!/bin/bash

###############################################################################
# Example usages:
###############################################################################
# 1. Default build options will create `roboticsmicrofarms/romidb:latest`:
# $ ./build.sh
#
# 2. Build image for a 'scanner' user and specify user & group id value:
# $ ./build.sh -u scanner --uid 1003 --gid 1003
#
# 3. Build image with 'debug' image tag & another 'romidata' branch options:
# $ ./build.sh -t debug -b 'feature/docker'

user=$USER
uid=$(id -u)
gid=$(id -g)
vtag="latest"
git_branch='dev'

usage() {
  echo "USAGE:"
  echo "  ./build.sh [OPTIONS]
    "

  echo "DESCRIPTION:"
  echo "  Build a docker image named 'roboticsmicrofarms/romidb' using Dockerfile in same location.
    "

  echo "OPTIONS:"
  echo "  -t, --tag
    Docker image tag to use, default to '$vtag'.
    "
  echo "  -u, --user
    User name to create inside docker image, default to '$user'.
    "
  echo "  --uid
    User id to use with 'user' inside docker image, default to '$uid'.
    "
  echo "  --gid
    Group id to use with 'user' inside docker image, default to '$gid'.
    "
  echo "  -b, --branch
    Git branch to use for cloning 'romidata' inside docker image, default to '$git_branch'.
    "
  echo "  -h, --help
    Output a usage message and exit.
    "
}

while [ "$1" != "" ]; do
  case $1 in
  -t | --tag)
    shift
    vtag=$1
    ;;
  -u | --user)
    shift
    user=$1
    ;;
  -b | --branch)
    shift
    git_branch=$1
    ;;
  -h | --help)
    usage
    exit
    ;;
  *)
    usage
    exit 1
    ;;
  esac
  shift
done

docker build -t roboticsmicrofarms/romidb:$vtag \
  --build-arg USER_NAME=$user \
  --build-arg USER_ID=$uid \
  --build-arg GROUP_ID=$gid \
  --build-arg ROMIDATA_BRANCH=$git_branch \
  .
