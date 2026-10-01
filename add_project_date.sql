-- Run once in Supabase > SQL Editor
-- Adds an admin-controlled project date (month + year; stored as the 1st of that month)

alter table public.projects
  add column if not exists project_date date;

-- Backfill existing projects from their publish/created date so nothing shows blank.
-- You can then change each one from the Edit Project page.
update public.projects
set project_date = date_trunc('month', coalesce(published_at, created_at))::date
where project_date is null;

create index if not exists projects_project_date_idx
  on public.projects(project_date);
