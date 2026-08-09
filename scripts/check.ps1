Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")

Write-Host "Checking Node.js syntax"
Get-ChildItem -LiteralPath $Root -Recurse -Filter *.mjs -File | Where-Object { $_.FullName -notmatch "[\\/](node_modules|\.git)[\\/]" } | ForEach-Object {
  & node --check $_.FullName
  if ($LASTEXITCODE -ne 0) { throw "Node syntax failed: $($_.FullName)" }
}

Write-Host "Checking missing-key behavior"
$oldKey = $env:POYO_API_KEY
Remove-Item Env:\POYO_API_KEY -ErrorAction SilentlyContinue
try {
  $previousErrorAction = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  $output = (& node (Join-Path $Root "node/index.mjs") 2>&1 | Out-String)
  $nodeExitCode = $LASTEXITCODE
  $ErrorActionPreference = $previousErrorAction
  if ($nodeExitCode -eq 0 -or $output -notmatch "POYO_API_KEY") { throw "Node example must fail safely without POYO_API_KEY" }
} finally {
  $ErrorActionPreference = "Stop"
  if ($null -ne $oldKey) { $env:POYO_API_KEY = $oldKey }
}

Write-Host "Scanning for committed secrets"
$files = Get-ChildItem -LiteralPath $Root -Recurse -File | Where-Object { $_.FullName -notmatch "[\\/](node_modules|\.git)[\\/]" }
foreach ($file in $files) {
  $text = [IO.File]::ReadAllText($file.FullName)
  if ($text -match "poyo_[A-Za-z0-9_-]{20,}") { throw "Possible API key in $($file.FullName)" }
}
Write-Host "All checks passed."
exit 0
