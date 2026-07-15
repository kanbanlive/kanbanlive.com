# kanbanlive.com

The Kanban Live marketing site, built with [Astro](https://astro.build) (v7).

Static six-page marketing site — Home, Tour, Case Studies, Pricing, About,
Contact — plus a Blog, and Terms / Privacy legal pages. Warm, token-driven
design with a light/dark theme toggle. Deployed as static files to S3 +
CloudFront.

## Develop

```sh
npm install
npm run dev        # http://localhost:4321
```

## Build

```sh
npm run build      # → ./dist
npm run preview    # serve ./dist locally
```

## Deploy

```sh
# Requires AWS credentials with access to the kanbanlive.com bucket.
# Optionally set CLOUDFRONT_DISTRIBUTION_ID to invalidate the CDN after upload.
CLOUDFRONT_DISTRIBUTION_ID=XXXXXXXXXXXXX ./deploy.sh
```

`deploy.sh` runs `npm ci && npm run build`, then syncs `./dist` to
`s3://kanbanlive.com` (fingerprinted assets long-cached, HTML short-cached) and
invalidates CloudFront.

## Structure

```
src/
  layouts/    Site.astro (head/nav/footer/theme), Legal.astro
  components/  Nav, Footer, Logo
  pages/       index, tour, case-studies, pricing, about, contact,
               terms, privacy, 404, blog/, rss.xml
  content/     blog/*.md  (Content Collection)
  styles/      tokens.css (design tokens, light/dark), global.css
  lib/         links.ts, blog.ts
public/        screenshots/, images/, favicon.{svg,png}, robots.txt
```

## Design & theming

Design tokens live in `src/styles/tokens.css` as CSS custom properties on
`:root` (light) and `:root[data-theme="dark"]` (dark). The theme is persisted to
`localStorage['kl-theme']` and applied before paint by a small inline script in
`Site.astro` (no flash). Components are token-driven; static layout uses inline
styles (faithful to the design handoff), while interactive states, responsive
grid collapses and the mobile nav live in `global.css`.

The design source is `design/website/design_handoff_kanban_live_site` in the
main repo.

## Notes

- Blog posts keep their legacy permalinks (`/blog/YYYY/MM/slug/`). Tumblr
  `/post/...` links and the old case-study path are redirected via `redirects`
  in `astro.config.mjs`. Legacy `.html` page URLs can't be emitted as static
  redirects (Astro's directory format nests them); add those as CloudFront/S3
  routing rules if traffic warrants.
- The contact form posts to the existing Formspree endpoint.
- Product screenshots (`public/screenshots/`) stand in for the hero/tour app
  mockups; swap them for updated captures as the app UI evolves.
