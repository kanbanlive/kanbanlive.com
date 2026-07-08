#!/usr/bin/env bash
set -euo pipefail

BUCKET="s3://kanbanlive.com"

echo "Building blog"
jekyll build

echo "Deploying static assets to s3 (long cache)"
aws s3 sync ./_site "$BUCKET" \
  --cache-control "public, max-age=2629000" \
  --exclude "*" --include "assets/*" --include "images/*"

echo "Deploying pages to s3 (short cache)"
aws s3 sync ./_site "$BUCKET" \
  --cache-control "public, max-age=300" \
  --exclude "assets/*" --exclude "images/*"
