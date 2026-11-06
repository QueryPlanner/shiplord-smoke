#!/usr/bin/env bash
set -euo pipefail

docker build -t shiplord-smoke:check .
container=$(docker run --detach --rm --cap-drop ALL \
  --security-opt no-new-privileges --publish 127.0.0.1::8080 shiplord-smoke:check)
trap 'docker stop "$container" >/dev/null 2>&1 || true' EXIT
endpoint=$(docker port "$container" 8080/tcp)
test "$(curl --fail --silent --show-error --retry 8 --retry-delay 1 \
  --retry-all-errors --max-time 3 "http://$endpoint/ready")" = ready
test "$(curl --fail --silent --show-error "http://$endpoint/")" = "$(cat release.txt)"
