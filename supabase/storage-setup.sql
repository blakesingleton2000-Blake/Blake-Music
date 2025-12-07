-- Supabase Storage Setup
-- Run this in Supabase SQL Editor to set up audio storage bucket

-- Create audio bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('audio', 'audio', true)
ON CONFLICT (id) DO NOTHING;

-- Set up RLS policies for audio bucket
CREATE POLICY "Public audio access"
ON storage.objects FOR SELECT
USING (bucket_id = 'audio');

CREATE POLICY "Authenticated users can upload audio"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'audio' AND
  auth.role() = 'authenticated'
);

CREATE POLICY "Users can update their own audio"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'audio' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can delete their own audio"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'audio' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Grant permissions
GRANT SELECT ON storage.objects TO authenticated;
GRANT INSERT ON storage.objects TO authenticated;
GRANT UPDATE ON storage.objects TO authenticated;
GRANT DELETE ON storage.objects TO authenticated;

