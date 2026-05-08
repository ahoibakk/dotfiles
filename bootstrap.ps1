# Bootstrap %USERPROFILE%\.claude to point at this dotfiles repo.
#
# Idempotent: takes a one-time backup of any existing real files/dirs that
# would be replaced (under .claude\backups\<timestamp>\), then installs:
#   - hardlinks for CLAUDE.md and settings.json
#   - junctions for hooks/, skills/, and the FremraOperations memory dir
#
# Run with the repo on the same NTFS volume as %USERPROFILE% (hardlink limit).
# No admin / no Developer Mode required.

[CmdletBinding()]
param(
  [string] $RepoRoot = (Split-Path -Parent $PSCommandPath),
  [string] $ClaudeRoot = (Join-Path $env:USERPROFILE '.claude')
)

$ErrorActionPreference = 'Stop'

function Write-Info($msg) { Write-Host "[bootstrap] $msg" -ForegroundColor Cyan }

if (-not (Test-Path -LiteralPath $RepoRoot)) {
  throw "RepoRoot not found: $RepoRoot"
}
if (-not (Test-Path -LiteralPath $ClaudeRoot)) {
  Write-Info "Creating $ClaudeRoot"
  New-Item -ItemType Directory -Path $ClaudeRoot -Force | Out-Null
}

$timestamp   = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupRoot  = Join-Path $ClaudeRoot "backups\bootstrap-$timestamp"

# Map: target path under .claude  ->  @{ Source = path in repo; Kind = 'HardLink' | 'Junction' }
$plan = [ordered]@{
  (Join-Path $ClaudeRoot 'CLAUDE.md')                                      = @{ Source = (Join-Path $RepoRoot 'CLAUDE.md');                                      Kind = 'HardLink' }
  (Join-Path $ClaudeRoot 'settings.json')                                  = @{ Source = (Join-Path $RepoRoot 'settings.json');                                  Kind = 'HardLink' }
  (Join-Path $ClaudeRoot 'hooks')                                          = @{ Source = (Join-Path $RepoRoot 'hooks');                                          Kind = 'Junction' }
  (Join-Path $ClaudeRoot 'skills')                                         = @{ Source = (Join-Path $RepoRoot 'skills');                                         Kind = 'Junction' }
  (Join-Path $ClaudeRoot 'projects\c--dev-FremraOperations\memory')        = @{ Source = (Join-Path $RepoRoot 'projects\c--dev-FremraOperations\memory');        Kind = 'Junction' }
}

foreach ($target in $plan.Keys) {
  $src  = $plan[$target].Source
  $kind = $plan[$target].Kind

  if (-not (Test-Path -LiteralPath $src)) {
    throw "Source missing in repo: $src"
  }

  # Make sure parent of target exists
  $parent = Split-Path -Parent $target
  if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }

  $existing = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue

  if ($null -ne $existing) {
    # If it's already a link to the right place, skip
    if ($existing.LinkType -in @('HardLink','Junction','SymbolicLink')) {
      $resolved = $null
      try { $resolved = (Resolve-Path -LiteralPath $target -ErrorAction Stop).ProviderPath } catch {}
      $expected = (Resolve-Path -LiteralPath $src).ProviderPath
      if ($resolved -and ($resolved -ieq $expected)) {
        Write-Info "OK  $target  (already $kind to repo)"
        continue
      }
      # Wrong-target link — remove it (won't touch the source)
      Write-Info "REPLACE  $target  (existing $($existing.LinkType), retargeting)"
      Remove-Item -LiteralPath $target -Force -Recurse:($existing.PSIsContainer)
    }
    else {
      # Real file/dir — back it up before replacing
      $relative   = $target.Substring($ClaudeRoot.Length).TrimStart('\','/')
      $backupDest = Join-Path $backupRoot $relative
      $backupParent = Split-Path -Parent $backupDest
      if (-not (Test-Path -LiteralPath $backupParent)) {
        New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
      }
      Write-Info "BACKUP   $target  ->  $backupDest"
      Move-Item -LiteralPath $target -Destination $backupDest -Force
    }
  }

  switch ($kind) {
    'HardLink' {
      Write-Info "LINK     $target  =hardlink=>  $src"
      New-Item -ItemType HardLink -Path $target -Target $src | Out-Null
    }
    'Junction' {
      Write-Info "LINK     $target  =junction=>  $src"
      # mklink /J is the most reliable way to make a junction without admin
      & cmd.exe /c mklink /J "$target" "$src" | Out-Null
      if ($LASTEXITCODE -ne 0) {
        throw "mklink /J failed for $target -> $src"
      }
    }
  }
}

Write-Info "Done."
if (Test-Path -LiteralPath $backupRoot) {
  Write-Info "Pre-existing files were moved to: $backupRoot"
}
