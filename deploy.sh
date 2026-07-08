#!/usr/bin/env bash
set -euo pipefail

BUCKET="s3://kanbanlive.com"
CLOUDFRONT_DISTRIBUTION_ID="${CLOUDFRONT_DISTRIBUTION_ID:-}"

echo "Checking prerequisites"

for cmd in bundle aws; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command '$cmd' is not installed or not on PATH" >&2
    exit 1
  fi
done

if ! bundle check >/dev/null 2>&1; then
  echo "Error: bundled gems are not installed; run 'bundle install' first" >&2
  exit 1
fi

if ! aws sts get-caller-identity >/dev/null 2>&1; then
  echo "Error: AWS credentials are not configured or have expired" >&2
  exit 1
fi

echo "Building blog"
bundle exec jekyll build

echo "Deploying static assets to s3 (long cache)"
aws s3 sync ./_site "$BUCKET" \
  --cache-control "public, max-age=2629000" \
  --exclude "*" --include "assets/*" --include "images/*"

echo "Deploying pages to s3 (short cache)"
aws s3 sync ./_site "$BUCKET" \
  --cache-control "public, max-age=300" \
  --exclude "assets/*" --exclude "images/*"

if [ -n "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
  echo "Invalidating CloudFront distribution $CLOUDFRONT_DISTRIBUTION_ID"
  aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
    --paths "/*"
else
  echo "CLOUDFRONT_DISTRIBUTION_ID not set; skipping CloudFront invalidation"
fi
