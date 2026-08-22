-- BookSoul Dashboard: application analytics metrics.
-- Apply after schema.sql and admin_migration.sql.

create table if not exists public.app_metrics_daily (
  metric_date date primary key,
  android_downloads integer not null default 0 check (android_downloads >= 0),
  windows_downloads integer not null default 0 check (windows_downloads >= 0),
  active_users integer not null default 0 check (active_users >= 0),
  crash_free_rate numeric(5,2) not null default 0 check (crash_free_rate between 0 and 100),
  api_latency_ms integer not null default 0 check (api_latency_ms >= 0),
  app_version text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.app_metrics_daily enable row level security;
create policy "admins manage application metrics" on public.app_metrics_daily
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

create index if not exists app_metrics_daily_date_idx on public.app_metrics_daily(metric_date desc);

-- Example upsert for a trusted server-side analytics job only:
-- insert into public.app_metrics_daily(metric_date, android_downloads, windows_downloads, active_users, crash_free_rate, api_latency_ms, app_version)
-- values (current_date, 0, 0, 0, 0, 0, '1.4.0')
-- on conflict (metric_date) do update set updated_at = now();
