-- BookSoul Dashboard: migration for administrator access.
-- Apply this file AFTER supabase/schema.sql in the same Supabase project.

alter table public.profiles add column if not exists role text not null default 'reader'
  check (role in ('reader', 'editor', 'admin'));
alter table public.profiles add column if not exists is_suspended boolean not null default false;
alter table public.books add column if not exists status text not null default 'published'
  check (status in ('draft', 'published', 'archived'));
alter table public.books add column if not exists updated_at timestamptz not null default now();

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin' and is_suspended = false
  );
$$;

grant execute on function public.is_admin() to authenticated;

alter table public.collections enable row level security;
alter table public.collection_books enable row level security;
alter table public.notifications enable row level security;

create policy "admins manage books" on public.books for all
  to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins manage profiles" on public.profiles for all
  to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins manage user books" on public.user_books for all
  to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins manage reviews" on public.reviews for all
  to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins manage highlights" on public.highlights for all
  to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins manage collections" on public.collections for all
  to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins manage collection books" on public.collection_books for all
  to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admins manage notifications" on public.notifications for all
  to authenticated using (public.is_admin()) with check (public.is_admin());

-- Run once after registering the intended administrator account.
-- update public.profiles set role = 'admin' where id = '<AUTH_USER_UUID>';
