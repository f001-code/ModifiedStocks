$ErrorActionPreference = "Stop"
$items = Get-ChildItem -Directory
$missing = @()
foreach ($item in $items) {
    $platform = Join-Path $item.FullName ".platform"
    if (Test-Path -LiteralPath $platform) {
        try { $p = Get-Content -Raw -LiteralPath $platform | ConvertFrom-Json } catch { $missing += "$($item.Name): invalid .platform JSON"; continue }
        if (-not $p.metadata.type -or -not $p.metadata.displayName -or -not $p.config.logicalId) { $missing += "$($item.Name): missing type/displayName/logicalId" }
    } elseif ($item.Name -match '\.(Notebook|DataPipeline|Lakehouse|Environment|Eventhouse|KQLDatabase|KQLQueryset|KQLDashboard|Report|SemanticModel)$') {
        $missing += "$($item.Name): .platform missing"
    }
}
if ($missing.Count) { $missing | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host "Platform-file check passed for item folders."
