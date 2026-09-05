#!/usr/bin/env bash
# start_vtuber.sh — launch Open-LLM-VTuber with your configured LLM + TTS.
# Reads API keys from .env (local-only, never committed) so keys never sit in
# conf.yaml.  Copy .env.example / your own .env into place first.
set -euo pipefail
cd "$(dirname "$0")"

ENV_FILE=".env.vtuber"
if [ ! -f "$ENV_FILE" ]; then
  ENV_FILE=".env"
fi

if [ -z "${LLM_API_KEY:-}" ] && [ -f "$ENV_FILE" ]; then
  # Export every KEY=VALUE line from the env file (first one wins).
  while IFS='=' read -r k v; do
    case "$k" in
      ''|\#*) continue ;;
      *) export "$k=$v" ;;
    esac
  done < "$ENV_FILE"
fi

echo "▶ Starting Open-LLM-VTuber"
echo "  Web UI: http://localhost:12393"
exec uv run run_server.py "$@"
