#!/bin/sh
set -e

mkdir -p /app/pb_data

if [ ! -d "/app/pb_public" ]; then
  mkdir -p /app/pb_public
fi

echo "🚀 Launching PocketBase (custom start.sh)"
echo "📂 Using /app/pb_public as static directory"

./pocketbase serve \
  --http=0.0.0.0:${PORT:-8080} \
  --dir=/app/pb_data \
  --publicDir=/app/pb_public
