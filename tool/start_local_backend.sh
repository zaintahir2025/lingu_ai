#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
server_dir="$project_root/linguai_backend/linguai_backend_server"
container_name="linguai-serverpod-postgres-dev"
database_volume="linguai_backend_data"
database_password="BaJy52uJVsjeDsI2CGSckt61L1kdHxw7"

if command -v podman >/dev/null 2>&1; then
  container_engine="podman"
elif command -v docker >/dev/null 2>&1; then
  container_engine="docker"
else
  echo "Install Podman or Docker before starting the local backend." >&2
  exit 1
fi

if ! "$container_engine" container inspect "$container_name" >/dev/null 2>&1; then
  "$container_engine" run -d \
    --name "$container_name" \
    -p 8090:5432 \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_DB=linguai_backend \
    -e "POSTGRES_PASSWORD=$database_password" \
    -v "$database_volume:/var/lib/postgresql/data" \
    docker.io/pgvector/pgvector:pg16
else
  "$container_engine" start "$container_name" >/dev/null
fi

echo "Waiting for the LinguAI PostgreSQL database..."
for attempt in {1..30}; do
  if "$container_engine" exec "$container_name" \
    pg_isready -U postgres -d linguai_backend >/dev/null 2>&1; then
    break
  fi
  if [[ "$attempt" -eq 30 ]]; then
    echo "PostgreSQL did not become ready in time." >&2
    exit 1
  fi
  sleep 1
done

echo "Starting the Dart/Serverpod API at http://localhost:3000/api/v1"
echo "Local verification and password-reset links will appear in this terminal."
cd "$server_dir"
exec dart run bin/main.dart --apply-migrations
