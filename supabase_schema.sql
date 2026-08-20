-- =========================================================
-- LINGU AI SUPABASE COMPLETE DATABASE SCHEMA
-- Execute this SQL in your Supabase SQL Editor
-- =========================================================

-- 1. Create Profiles Table (Syncs automatically with Supabase Auth Users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    username TEXT,
    avatar_id TEXT DEFAULT 'piko_head',
    target_language TEXT DEFAULT 'es',
    knowledge_level TEXT DEFAULT 'beginner',
    role TEXT DEFAULT 'user',
    is_premium BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Create User Progress Table
CREATE TABLE IF NOT EXISTS public.user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE REFERENCES public.profiles(id) ON DELETE CASCADE,
    total_xp INT DEFAULT 0,
    level INT DEFAULT 1,
    current_streak INT DEFAULT 0,
    streak_freezes INT DEFAULT 0,
    gems INT DEFAULT 100,
    last_practice_date DATE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Create Support Tickets Table
CREATE TABLE IF NOT EXISTS public.support_tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    user_email TEXT NOT NULL,
    category TEXT NOT NULL,
    subject TEXT NOT NULL,
    message TEXT NOT NULL,
    reply TEXT,
    priority TEXT DEFAULT 'standard',
    status TEXT DEFAULT 'open',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_tickets ENABLE ROW LEVEL SECURITY;

-- 5. RLS Policies for Profiles
CREATE POLICY "Allow users to read their own profile" 
    ON public.profiles FOR SELECT 
    USING (auth.uid() = id);

CREATE POLICY "Allow users to update their own profile" 
    ON public.profiles FOR UPDATE 
    USING (auth.uid() = id);

CREATE POLICY "Allow public insert during registration" 
    ON public.profiles FOR INSERT 
    WITH CHECK (true);

-- 6. RLS Policies for User Progress
CREATE POLICY "Allow users to read their own progress" 
    ON public.user_progress FOR SELECT 
    USING (auth.uid() = user_id);

CREATE POLICY "Allow users to insert/update their own progress" 
    ON public.user_progress FOR ALL 
    USING (auth.uid() = user_id);

-- 7. RLS Policies for Support Tickets
CREATE POLICY "Allow users to manage their support tickets" 
    ON public.support_tickets FOR ALL 
    USING (auth.uid() = user_id);

-- 8. Trigger to Automatically Create Profile & Progress on Signup
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, username, is_premium)
  VALUES (
    new.id, 
    new.email, 
    COALESCE(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    TRUE
  );

  INSERT INTO public.user_progress (user_id, total_xp, level, current_streak)
  VALUES (new.id, 0, 1, 0);

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
