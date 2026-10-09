-- Run once in Supabase → SQL Editor → New query → Run.
-- Creates the comments table. Anyone can read visible comments and post new ones;
-- nobody but you (in the dashboard) can edit, hide or delete them.

create table if not exists public.comments (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  name        text check (name is null or char_length(name) between 1 and 40),
  anon        boolean not null default false,
  book        text not null default 'all' check (book in ('all', 'leaving', 'return', 'staying')),
  body        text not null check (char_length(btrim(body)) between 1 and 2000),
  hidden      boolean not null default false
);

create index if not exists comments_created_at_idx on public.comments (created_at desc);

alter table public.comments enable row level security;

-- Visitors only ever see comments you haven't hidden.
drop policy if exists "read visible comments" on public.comments;
create policy "read visible comments"
  on public.comments for select
  to anon, authenticated
  using (hidden = false);

-- Visitors can post, but can't set created_at or hide/unhide anything.
drop policy if exists "post comments" on public.comments;
create policy "post comments"
  on public.comments for insert
  to anon, authenticated
  with check (hidden = false);

-- Visitors can't send their own timestamps: always use the server's clock.
revoke insert on public.comments from anon, authenticated;
grant insert (name, anon, book, body) on public.comments to anon, authenticated;
grant select (id, created_at, name, anon, book, body, hidden) on public.comments to anon, authenticated;

-- To moderate: Table Editor → comments → set "hidden" to true on a row (or delete it).
