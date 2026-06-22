-- ============================================================
-- Baserbinikah.id — skema Supabase
-- Jalankan di: Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================

-- Satu baris per user; seluruh state app disimpan di kolom `data` (jsonb).
create table if not exists public.weddings (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Aktifkan Row Level Security: tiap user HANYA bisa akses barisnya sendiri.
alter table public.weddings enable row level security;

drop policy if exists "own row select" on public.weddings;
drop policy if exists "own row insert" on public.weddings;
drop policy if exists "own row update" on public.weddings;

create policy "own row select" on public.weddings
  for select using (auth.uid() = user_id);

create policy "own row insert" on public.weddings
  for insert with check (auth.uid() = user_id);

create policy "own row update" on public.weddings
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Jaga updated_at selalu terbarui otomatis.
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists trg_weddings_touch on public.weddings;
create trigger trg_weddings_touch
  before update on public.weddings
  for each row execute function public.touch_updated_at();
