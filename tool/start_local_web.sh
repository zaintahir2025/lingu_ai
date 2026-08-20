#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

exec flutter run \
  -d web-server \
  --web-hostname=127.0.0.1 \
  --web-port=36537 \
  --dart-define=API_URL=http://127.0.0.1:3000/api/v1
