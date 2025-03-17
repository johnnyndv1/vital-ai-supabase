-- Create auth schema
create schema if not exists auth;

-- Enable RLS
alter table auth.users enable row level security;

-- Create profiles table
create table public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  updated_at timestamp with time zone,
  username text unique,
  full_name text,
  avatar_url text,
  website text,
  
  constraint username_length check (char_length(username) >= 3)
);

-- Create medical tests table
create table public.medical_tests (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  name text not null,
  type text not null,
  data text, -- base64 encoded image
  analysis jsonb not null,
  date timestamp with time zone default now(),
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Enable RLS on profiles
alter table public.profiles enable row level security;

-- Enable RLS on medical_tests
alter table public.medical_tests enable row level security;

-- Create RLS policies
create policy "Public profiles are viewable by everyone."
  on public.profiles for select
  using ( true );

create policy "Users can insert their own profile."
  on public.profiles for insert
  with check ( auth.uid() = id );

create policy "Users can update own profile."
  on public.profiles for update
  using ( auth.uid() = id );

-- Medical tests policies
create policy "Users can view own medical tests"
  on public.medical_tests for select
  using ( auth.uid() = user_id );

create policy "Users can insert own medical tests"
  on public.medical_tests for insert
  with check ( auth.uid() = user_id );

create policy "Users can update own medical tests"
  on public.medical_tests for update
  using ( auth.uid() = user_id );

create policy "Users can delete own medical tests"
  on public.medical_tests for delete
  using ( auth.uid() = user_id );

-- Set up Storage
insert into storage.buckets (id, name)
values ('medical_test_images', 'medical_test_images');

create policy "Medical test images are accessible by test owner"
  on storage.objects for select
  using ( auth.uid() = (
    select user_id from public.medical_tests
    where data like '%' || storage.objects.name || '%'
  ));

create policy "Anyone can upload medical test images"
  on storage.objects for insert
  with check (
    bucket_id = 'medical_test_images'
    and auth.role() = 'authenticated'
  );

-- Create functions
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$;

-- Create triggers
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();