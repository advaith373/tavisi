-- ================================================================
-- SUPABASE CLOUD SETUP FOR EVIDENCE PHOTOS (TAVISI WEBSITE)
-- Run this entire script in your Supabase Dashboard:
-- SQL Editor -> New Query -> Paste & Click "Run"
-- ================================================================

-- 1. Create table for evidence photo metadata
create table if not exists public.evidence_photos (
  card_id integer primary key,
  image_url text not null,
  storage_path text,
  caption text default '',
  date text default '',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Enable Row Level Security (RLS) on evidence_photos table
alter table public.evidence_photos enable row level security;

-- 3. Create RLS Policies for public / anonymous client access
drop policy if exists "Allow public read evidence photos" on public.evidence_photos;
create policy "Allow public read evidence photos"
  on public.evidence_photos for select
  using (true);

drop policy if exists "Allow public insert evidence photos" on public.evidence_photos;
create policy "Allow public insert evidence photos"
  on public.evidence_photos for insert
  with check (true);

drop policy if exists "Allow public update evidence photos" on public.evidence_photos;
create policy "Allow public update evidence photos"
  on public.evidence_photos for update
  using (true)
  with check (true);

drop policy if exists "Allow public delete evidence photos" on public.evidence_photos;
create policy "Allow public delete evidence photos"
  on public.evidence_photos for delete
  using (true);

-- 4. Enable Realtime on evidence_photos table
alter publication supabase_realtime add table public.evidence_photos;

-- 5. Create the storage bucket for evidence photos (public: true)
insert into storage.buckets (id, name, public)
values ('evidence-photos', 'evidence-photos', true)
on conflict (id) do update set public = true;

-- 6. Storage policies for the bucket 'evidence-photos'
drop policy if exists "Public access evidence photos bucket" on storage.objects;
create policy "Public access evidence photos bucket"
  on storage.objects for select
  using (bucket_id = 'evidence-photos');

drop policy if exists "Public upload evidence photos bucket" on storage.objects;
create policy "Public upload evidence photos bucket"
  on storage.objects for insert
  with check (bucket_id = 'evidence-photos');

drop policy if exists "Public update evidence photos bucket" on storage.objects;
create policy "Public update evidence photos bucket"
  on storage.objects for update
  using (bucket_id = 'evidence-photos');

drop policy if exists "Public delete evidence photos bucket" on storage.objects;
create policy "Public delete evidence photos bucket"
  on storage.objects for delete
  using (bucket_id = 'evidence-photos');
