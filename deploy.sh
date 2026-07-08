#!/usr/bin/env bash
set -euo pipefail

BUCKET="s3://kanbanlive.com"
CLOUDFRONT_DISTRIBUTION_ID="${CLOUDFRONT_DISTRIBUTION_ID:-}"

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

if [ -n "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
  echo "Invalidating CloudFront distribution $CLOUDFRONT_DISTRIBUTION_ID"
  aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
    --paths "/*"
else
  echo "CLOUDFRONT_DISTRIBUTION_ID not set; skipping CloudFront invalidation"
fi
