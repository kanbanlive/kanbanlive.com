#!/usr/bin/env bash
set -euo pipefail

# Builds the Astro site and deploys the static output in ./dist to S3 + CloudFront.
# Mirrors the previous caching strategy: fingerprinted assets get a long cache,
# HTML/XML get a short cache. No --delete (stale hashed assets are harmless and
# removing files risks breaking CloudFront error/redirect config).

BUCKET="s3://kanbanlive.com"
CLOUDFRONT_DISTRIBUTION_ID="${CLOUDFRONT_DISTRIBUTION_ID:-}"

echo "Checking prerequisites"
for cmd in npm aws; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command '$cmd' is not installed or not on PATH" >&2
    exit 1
  fi
done

if ! aws sts get-caller-identity >/dev/null 2>&1; then
  echo "Error: AWS credentials are not configured or have expired" >&2
  exit 1
fi

echo "Installing dependencies"
npm ci

echo "Building site"
npm run build

echo "Deploying fingerprinted assets to s3 (immutable, 1 year)"
aws s3 sync ./dist "$BUCKET" \
  --cache-control "public, max-age=31536000, immutable" \
  --exclude "*" --include "_astro/*"

echo "Deploying images to s3 (long cache, ~1 month)"
aws s3 sync ./dist "$BUCKET" \
  --cache-control "public, max-age=2629000" \
  --exclude "*" --include "screenshots/*" --include "images/*" \
  --include "favicon.png" --include "favicon.svg"

echo "Deploying pages, redirects and feeds to s3 (short cache, 5 min)"
aws s3 sync ./dist "$BUCKET" \
  --cache-control "public, max-age=300" \
  --exclude "_astro/*" --exclude "screenshots/*" --exclude "images/*" \
  --exclude "favicon.png" --exclude "favicon.svg"

if [ -n "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
  echo "Invalidating CloudFront distribution $CLOUDFRONT_DISTRIBUTION_ID"
  aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
    --paths "/*"
else
  echo "CLOUDFRONT_DISTRIBUTION_ID not set; skipping CloudFront invalidation"
fi

echo "Done"
