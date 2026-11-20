-- LinguAI security hardening for existing Supabase projects.
-- Review the effects below before applying. This revokes unverified PRO
-- entitlements; paid users must be restored only after server-side payment
-- verification has been implemented and their subscription is confirmed.

begin;

alter table public.profiles alter column is_premium set default false;
update public.profiles set is_premium = false;
alter table public.profiles alter column is_premium set not null;

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

revoke all on public.profiles from anon, authenticated;
revoke all on public.user_progress from anon, authenticated;
revoke all on public.support_tickets from anon, authenticated;
revoke all on public.user_flashcards from anon, authenticated;

grant select on public.profiles to authenticated;
grant update (username, avatar_id, target_language, knowledge_level)
  on public.profiles to authenticated;
grant select on public.user_progress to authenticated;
grant select, insert on public.support_tickets to authenticated;
grant select on public.lessons, public.flashcards to anon, authenticated;
grant select, insert on public.user_flashcards to authenticated;
grant update (status, next_review_date, repetitions, easiness_factor, interval_days, updated_at)
  on public.user_flashcards to authenticated;

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

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

commit;
