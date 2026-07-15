import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  site: 'https://kanbanlive.com',
  integrations: [sitemap()],
  build: {
    // Emit /page/index.html so clean URLs work behind S3/CloudFront.
    format: 'directory',
  },
  // Directory-style redirects only — these emit a static redirect page that S3
  // can serve. Legacy `.html` page URLs (/tour.html etc.) can't be emitted as
  // static redirects here (Astro's directory format would nest them); if
  // analytics show traffic on those, add them as CloudFront/S3 routing rules.
  redirects: {
    // Old case-study collection path → the new Case Studies page.
    '/case-studies/spectech': '/case-studies/',
    // Preserve legacy Tumblr permalinks that the old Jekyll site 301'd from.
    '/post/49845892380/introducing-kanban-live': '/blog/2013/05/introducing-kanban-live/',
    '/post/56271264203/updated-web-site': '/blog/2013/07/updated-web-site/',
    '/post/112880562938/improved-history-view': '/blog/2015/03/improved-history-view/',
    '/post/121744514818/kanban-live-realtime-demo-at-paris-air-show': '/blog/2015/06/kanban-live-realtime-demo-at-paris-air-show/',
  },
});
