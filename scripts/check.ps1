Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$ExcludedDirNames = @(".git", "node_modules", "__pycache__")

function Get-RelativePath {
  param([string]$BasePath, [string]$TargetPath)
  $base = [System.IO.Path]::GetFullPath($BasePath)
  if (-not $base.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
    $base += [System.IO.Path]::DirectorySeparatorChar
  }
  $target = [System.IO.Path]::GetFullPath($TargetPath)
  $baseUri = New-Object System.Uri($base)
  $targetUri = New-Object System.Uri($target)
  return [Uri]::UnescapeDataString($baseUri.MakeRelativeUri($targetUri).ToString()).Replace("/", [System.IO.Path]::DirectorySeparatorChar)
}

function Read-AllText {
  param([string]$Path)
  return [System.IO.File]::ReadAllText($Path)
}

function Write-Step {
  param([string]$Message)
  Write-Host ""
  Write-Host "==> $Message"
}

function Get-PublicFiles {
  Get-ChildItem -LiteralPath $Root -Recurse -File | Where-Object {
    $relative = Get-RelativePath -BasePath $Root -TargetPath $_.FullName
    $parts = $relative -split '[\\/]'
    -not ($parts | Where-Object { $ExcludedDirNames -contains $_ })
  }
}

function Test-MarkdownLinks {
  Write-Step "Checking Markdown relative links"
  $markdownFiles = Get-PublicFiles | Where-Object { $_.Extension -eq ".md" }
  $failures = New-Object System.Collections.Generic.List[string]

  foreach ($file in $markdownFiles) {
    $content = Read-AllText $file.FullName
    $matches = [regex]::Matches($content, '(?<!\!)\[[^\]]+\]\(([^)]+)\)|!\[[^\]]*\]\(([^)]+)\)')
    foreach ($match in $matches) {
      $target = if ($match.Groups[1].Success) { $match.Groups[1].Value } else { $match.Groups[2].Value }
      $target = $target.Trim()
      if (-not $target) { continue }
      if ($target.StartsWith("#")) { continue }
      if ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:') { continue }
      $cleanTarget = ($target -split '#')[0]
      $cleanTarget = ($cleanTarget -split '\?')[0]
      if (-not $cleanTarget) { continue }
      $decodedTarget = [Uri]::UnescapeDataString($cleanTarget)
      $baseDir = Split-Path -Parent $file.FullName
      $resolved = Join-Path $baseDir $decodedTarget
      if ($decodedTarget.EndsWith("/") -or $decodedTarget.EndsWith("\")) {
        if (-not (Test-Path -LiteralPath $resolved -PathType Container)) {
          $relativeFile = Get-RelativePath -BasePath $Root -TargetPath $file.FullName
          $failures.Add("${relativeFile}: missing directory link $target")
        }
      } elseif (-not (Test-Path -LiteralPath $resolved -PathType Leaf) -and -not (Test-Path -LiteralPath $resolved -PathType Container)) {
        $relativeFile = Get-RelativePath -BasePath $Root -TargetPath $file.FullName
        $failures.Add("${relativeFile}: missing link $target")
      }
    }
  }

  if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    throw "Markdown link check failed"
  }
}

function Test-NoRunnableExamples {
  Write-Step "Checking coming-soon repo boundaries"
  $forbiddenPaths = @(
    "curl\generate.md",
    "node\index.mjs",
    "webhooks\express-webhook\server.mjs",
    ".env.example"
  )
  foreach ($path in $forbiddenPaths) {
    $resolved = Join-Path $Root $path
    if (Test-Path -LiteralPath $resolved) {
      throw "Coming-soon repo should not include runnable example path: $path"
    }
  }
}

function Test-SecretScan {
  Write-Step "Scanning public files for sensitive values"
  $devHostPattern = "dev" + "-api\.poyo\.ai"
  $testHostPattern = "(test|staging)" + "-api\.poyo\.ai"
  $localHostPattern = "localhost|127\.0\.0\.1|0\.0\.0\.0"
  $privatePattern = "\." + "private"
  $localPathPattern = "(?!Env:)[A-Z]:\\"

  $patterns = @(
    @{ Name = "dev API host"; Pattern = $devHostPattern },
    @{ Name = "test API host"; Pattern = $testHostPattern },
    @{ Name = "localhost reference"; Pattern = $localHostPattern },
    @{ Name = "real bearer token"; Pattern = 'Authorization:\s*Bearer\s+(?!<POYO_API_KEY>|YOUR_API_KEY|YOUR_POYO_API_KEY_HERE|\$POYO_API_KEY)[A-Za-z0-9._~+/=-]{12,}' },
    @{ Name = "real API key assignment"; Pattern = 'POYO_API_KEY\s*=\s*(?!YOUR_POYO_API_KEY_HERE|your-api-key|<POYO_API_KEY>)[A-Za-z0-9._~+/=-]{12,}' },
    @{ Name = "GitHub token"; Pattern = 'gh[pousr]_[A-Za-z0-9_]{20,}' },
    @{ Name = "OpenAI-style secret key"; Pattern = 'sk-[A-Za-z0-9_-]{20,}' },
    @{ Name = "real unified task id"; Pattern = "task-unified-(?!example\b)[A-Za-z0-9-]+" },
    @{ Name = "private notes reference"; Pattern = $privatePattern },
    @{ Name = "local Windows path"; Pattern = $localPathPattern }
  )

  $failures = New-Object System.Collections.Generic.List[string]
  $files = Get-PublicFiles | Where-Object { $_.FullName -notlike "*\scripts\check.ps1" }
  foreach ($file in $files) {
    $content = Read-AllText $file.FullName
    $relative = Get-RelativePath -BasePath $Root -TargetPath $file.FullName
    foreach ($pattern in $patterns) {
      if ($content -match $pattern.Pattern) { $failures.Add("${relative}: matched $($pattern.Name)") }
    }
  }

  if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    throw "Sensitive information scan failed"
  }
}

Test-MarkdownLinks
Test-NoRunnableExamples
Test-SecretScan

Write-Host ""
Write-Host "All checks passed."
