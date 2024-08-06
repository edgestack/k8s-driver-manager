#!/usr/bin/env bash

set -ex
set -o pipefail

TAG=${TAG:-v0.6.8}
REPO=${REPO:-registry.gitlab.com/sonaproject}
CUDA_VERSION="12.5.1"
BASE_DIST="ubi8"
GOLANG_VERSION="1.22.2"

# support other container tools. e.g. podman
CONTAINER_CLI=${CONTAINER_CLI:-docker}
CONTAINER_BUILDER=${CONTAINER_BUILDER:-"buildx build"}

# supported platforms
#PLATFORMS=linux/amd64,linux/arm64
PLATFORMS=linux/amd64

# shellcheck disable=SC2086 # inteneded splitting of CONTAINER_BUILDER
${CONTAINER_CLI} ${CONTAINER_BUILDER} \
  --platform ${PLATFORMS} \
  --push \
  --build-arg CUDA_VERSION="${CUDA_VERSION}" \
  --build-arg BASE_DIST="${BASE_DIST}" \
  --build-arg GOLANG_VERSION="${GOLANG_VERSION}" \
  -f ./deployments/container/Dockerfile.ubi8 \
  -t "${REPO}"/k8s-driver-manager:"${TAG}" .
