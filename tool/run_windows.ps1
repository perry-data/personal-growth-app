$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $root

if ([string]::IsNullOrWhiteSpace($env:SUPABASE_URL)) {
  $env:SUPABASE_URL = [Environment]::GetEnvironmentVariable('SUPABASE_URL', 'User')
  if ([string]::IsNullOrWhiteSpace($env:SUPABASE_URL)) {
    $env:SUPABASE_URL = [Environment]::GetEnvironmentVariable('SUPABASE_URL', 'Machine')
  }
}

if ([string]::IsNullOrWhiteSpace($env:SUPABASE_ANON_KEY)) {
  $env:SUPABASE_ANON_KEY = [Environment]::GetEnvironmentVariable('SUPABASE_ANON_KEY', 'User')
  if ([string]::IsNullOrWhiteSpace($env:SUPABASE_ANON_KEY)) {
    $env:SUPABASE_ANON_KEY = [Environment]::GetEnvironmentVariable('SUPABASE_ANON_KEY', 'Machine')
  }
}

if ([string]::IsNullOrWhiteSpace($env:SUPABASE_URL)) {
  Write-Host 'Missing SUPABASE_URL.'
  Write-Host 'Temporary: $env:SUPABASE_URL="https://xxxx.supabase.co"'
  Write-Host 'Persist:   setx SUPABASE_URL "https://xxxx.supabase.co"'
  exit 1
}

if ([string]::IsNullOrWhiteSpace($env:SUPABASE_ANON_KEY)) {
  Write-Host 'Missing SUPABASE_ANON_KEY.'
  Write-Host 'Temporary: $env:SUPABASE_ANON_KEY="your_anon_key"'
  Write-Host 'Persist:   setx SUPABASE_ANON_KEY "your_anon_key"'
  exit 1
}

Write-Host 'Running: flutter clean'
& flutter clean

Write-Host 'Running: flutter pub get'
& flutter pub get

Write-Host 'Running: flutter run -d windows'
& flutter run -d windows "--dart-define=SUPABASE_URL=$($env:SUPABASE_URL)" "--dart-define=SUPABASE_ANON_KEY=$($env:SUPABASE_ANON_KEY)"

