-- =========================================================
-- LINGUAI SUPABASE SCHEMA
-- This schema is safe to run on a fresh Supabase project.
-- Existing projects should also apply the migration in
-- supabase/migrations/202611200001_security_hardening.sql.
-- =========================================================

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique not null,
  username text,
  avatar_id text default 'piko_head',
  date_of_birth date,
  target_language text default 'es',
  knowledge_level text default 'beginner',
  role text not null default 'user' check (role in ('user', 'admin')),
  is_premium boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles alter column is_premium set default false;

create table if not exists public.user_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique references public.profiles(id) on delete cascade,
  total_xp int not null default 0,
  level int not null default 1,
  current_streak int not null default 0,
  streak_freezes int not null default 0,
  gems int not null default 100,
  last_practice_date date,
  updated_at timestamptz not null default now()
);

create table if not exists public.support_tickets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  user_email text not null,
  category text not null,
  subject text not null,
  message text not null,
  reply text,
  priority text not null default 'standard',
  status text not null default 'open',
  created_at timestamptz not null default now()
);

create table if not exists public.lessons (
  id serial primary key,
  topic text not null,
  cefr_level text not null,
  order_index int not null,
  is_premium boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.flashcards (
  id serial primary key,
  lesson_id int references public.lessons(id) on delete cascade,
  word text not null,
  translation text not null,
  audio_url text,
  example_sentence text,
  example_translation text,
  created_at timestamptz not null default now()
);

create table if not exists public.user_flashcards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  flashcard_id int not null references public.flashcards(id) on delete cascade,
  status text not null default 'new',
  next_review_date timestamptz,
  repetitions int not null default 0,
  easiness_factor real not null default 2.5,
  interval_days int not null default 0,
  updated_at timestamptz not null default now(),
  unique(user_id, flashcard_id)
);

-- RLS is enabled everywhere exposed to the Supabase API.
alter table public.profiles enable row level security;
alter table public.user_progress enable row level security;
alter table public.support_tickets enable row level security;
alter table public.lessons enable row level security;
alter table public.flashcards enable row level security;
alter table public.user_flashcards enable row level security;

-- Make this file safe to re-run after the previous permissive policies.
drop policy if exists "Allow users to read their own profile" on public.profiles;
drop policy if exists "Allow users to update their own profile" on public.profiles;
drop policy if exists "Allow public insert during registration" on public.profiles;
drop policy if exists "Allow users to read their own progress" on public.user_progress;
drop policy if exists "Allow users to insert/update their own progress" on public.user_progress;
drop policy if exists "Allow users to manage their support tickets" on public.support_tickets;
drop policy if exists "Allow public read access to lessons" on public.lessons;
drop policy if exists "Allow public read access to flashcards" on public.flashcards;
drop policy if exists "Allow users to read their own flashcard progress" on public.user_flashcards;
drop policy if exists "Allow users to insert/update their own flashcard progress" on public.user_flashcards;
drop policy if exists "profile_select_own" on public.profiles;
drop policy if exists "profile_update_own" on public.profiles;
drop policy if exists "progress_select_own" on public.user_progress;
drop policy if exists "support_select_own" on public.support_tickets;
drop policy if exists "support_insert_own" on public.support_tickets;
drop policy if exists "lessons_read_public" on public.lessons;
drop policy if exists "flashcards_read_public" on public.flashcards;
drop policy if exists "user_flashcards_select_own" on public.user_flashcards;
drop policy if exists "user_flashcards_insert_own" on public.user_flashcards;
drop policy if exists "user_flashcards_update_own" on public.user_flashcards;

-- Remove broad client-side access. Elevated server-side operations must use
-- a server secret/service role and must never run in a Flutter client.
revoke all on public.profiles from anon, authenticated;
revoke all on public.user_progress from anon, authenticated;
revoke all on public.support_tickets from anon, authenticated;
revoke all on public.user_flashcards from anon, authenticated;

grant select on public.profiles to authenticated;
grant update (username, avatar_id, date_of_birth, target_language, knowledge_level)
  on public.profiles to authenticated;

-- Progress mutations are intentionally not exposed as direct table writes.
-- XP/levels must be updated by trusted server logic, not client supplied values.
grant select on public.user_progress to authenticated;

grant select, insert on public.support_tickets to authenticated;
-- Ticket replies, moderation status and priority are server/admin controlled.
grant select on public.lessons, public.flashcards to anon, authenticated;

grant select, insert on public.user_flashcards to authenticated;
grant update (status, next_review_date, repetitions, easiness_factor, interval_days, updated_at)
  on public.user_flashcards to authenticated;

-- Users can see and edit only their own profile fields that are granted above.
create policy "profile_select_own"
  on public.profiles for select to authenticated
  using ((select auth.uid()) = id);

create policy "profile_update_own"
  on public.profiles for update to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

create policy "progress_select_own"
  on public.user_progress for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "support_select_own"
  on public.support_tickets for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "support_insert_own"
  on public.support_tickets for insert to authenticated
  with check (
    (select auth.uid()) = user_id
    and user_email = (
      select p.email from public.profiles as p where p.id = (select auth.uid())
    )
    and reply is null
    and priority = 'standard'
    and status = 'open'
  );

create policy "lessons_read_public"
  on public.lessons for select to anon, authenticated
  using (true);

create policy "flashcards_read_public"
  on public.flashcards for select to anon, authenticated
  using (true);

create policy "user_flashcards_select_own"
  on public.user_flashcards for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "user_flashcards_insert_own"
  on public.user_flashcards for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "user_flashcards_update_own"
  on public.user_flashcards for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- Auth signup creates a free profile. Never copy role/premium from user metadata.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, username, role, is_premium)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1)),
    'user',
    false
  )
  on conflict (id) do nothing;

  insert into public.user_progress (user_id, total_xp, level, current_streak)
  values (new.id, 0, 1, 0)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
