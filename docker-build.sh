#!/usr/bin/env bash
#
# OpenClaw/Moltbot Docker Build Script
# Builds the full OpenClaw image with all dependencies
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="${OPENCLAW_IMAGE:-openclaw:full}"
DOCKERFILE="${SCRIPT_DIR}/Dockerfile.full"

echo "========================================"
echo "OpenClaw/Moltbot Docker Build"
echo "========================================"
echo ""
echo "Image: ${IMAGE_NAME}"
echo "Dockerfile: ${DOCKERFILE}"
echo ""

# Check Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

# Check Docker is running
if ! docker info &> /dev/null; then
    echo "Error: Docker daemon is not running"
    exit 1
fi

# Parse arguments
BUILD_ARGS=""
PUSH=false
CACHE=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --push)
            PUSH=true
            shift
            ;;
        --no-cache)
            CACHE=false
            shift
            ;;
        --image)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --apt-packages)
            BUILD_ARGS="${BUILD_ARGS} --build-arg OPENCLAW_DOCKER_APT_PACKAGES=$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --push              Push image to registry after build"
            echo "  --no-cache          Build without cache"
            echo "  --image NAME        Set image name (default: openclaw:full)"
            echo "  --apt-packages PKGS Install additional APT packages"
            echo "  --help              Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Build cache flags
CACHE_FLAGS=""
if [[ "$CACHE" == "false" ]]; then
    CACHE_FLAGS="--no-cache"
fi

echo "Building OpenClaw Docker image..."
echo ""

# Build the image
docker build \
    -f "${DOCKERFILE}" \
    -t "${IMAGE_NAME}" \
    ${BUILD_ARGS} \
    ${CACHE_FLAGS} \
    "${SCRIPT_DIR}"

echo ""
echo "========================================"
echo "Build Complete!"
echo "========================================"
echo ""
echo "Image: ${IMAGE_NAME}"
echo ""
echo "Run with:"
echo "  docker run -d \\"
echo "    -p 18789:18789 \\"
echo "    -e OPENCLAW_GATEWAY_TOKEN=\$(openssl rand -hex 32) \\"
echo "    ${IMAGE_NAME}"
echo ""

# Push if requested
if [[ "$PUSH" == "true" ]]; then
    echo "Pushing image to registry..."
    docker push "${IMAGE_NAME}"
    echo "Push complete!"
fi
