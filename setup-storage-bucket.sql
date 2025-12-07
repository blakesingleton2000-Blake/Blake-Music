-- Supabase Storage Bucket Setup for Audio Files
-- Run this in Supabase SQL Editor

-- Create audio bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('audio', 'audio', true)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist (for idempotency)
DROP POLICY IF EXISTS "Public audio access" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated uploads" ON storage.objects;
DROP POLICY IF EXISTS "Users can update own files" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete own files" ON storage.objects;

-- Allow public read access (for signed URLs)
CREATE POLICY "Public audio access" ON storage.objects
FOR SELECT USING (bucket_id = 'audio');

-- Allow authenticated uploads
CREATE POLICY "Authenticated uploads" ON storage.objects
FOR INSERT WITH CHECK (bucket_id = 'audio' AND auth.role() = 'authenticated');

-- Allow users to update their own files
CREATE POLICY "Users can update own files" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'audio' 
  AND auth.uid()::text = (string_to_array(name, '/'))[1]
);

-- Allow users to delete their own files
CREATE POLICY "Users can delete own files" ON storage.objects
FOR DELETE USING (
  bucket_id = 'audio' 
  AND auth.uid()::text = (string_to_array(name, '/'))[1]
);

-- Verify bucket was created
SELECT * FROM storage.buckets WHERE id = 'audio';

