import { getCollection, type CollectionEntry } from 'astro:content';

export type Post = CollectionEntry<'blog'>;

/** Two-digit month for the URL. */
const pad = (n: number) => String(n).padStart(2, '0');

/** Legacy Jekyll permalink: /blog/YYYY/MM/slug/ (kept for SEO continuity). */
export function postPath(post: Post): string {
  const d = post.data.date;
  return `/blog/${d.getUTCFullYear()}/${pad(d.getUTCMonth() + 1)}/${post.data.slug}/`;
}

export function formatDate(d: Date): string {
  return d.toLocaleDateString('en-GB', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    timeZone: 'UTC',
  });
}

/** All posts, newest first. */
export async function getSortedPosts(): Promise<Post[]> {
  const posts = await getCollection('blog');
  return posts.sort((a, b) => b.data.date.getTime() - a.data.date.getTime());
}
