import rss from '@astrojs/rss';
import type { APIContext } from 'astro';
import { getSortedPosts, postPath } from '../lib/blog';

export async function GET(context: APIContext) {
  const posts = await getSortedPosts();
  return rss({
    title: 'Kanban Live',
    description: 'News and updates from the Kanban Live team.',
    site: context.site ?? 'https://kanbanlive.com',
    items: posts.map((post) => ({
      title: post.data.title,
      pubDate: post.data.date,
      description: post.data.description ?? '',
      link: postPath(post),
    })),
  });
}
