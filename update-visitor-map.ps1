param(
  [string]$Source = ".\visitor-map-source.csv",
  [string]$Output = ".\visitor-map.json",
  [string]$Message = "",
  [string]$UpdatedAt = "",
  [switch]$KeepOrder
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Source)) {
  throw "Source file not found: $Source"
}

$rows = Import-Csv -LiteralPath $Source

if (-not $rows -or $rows.Count -eq 0) {
  throw "Source file is empty. Add rows with Country and Count columns."
}

$locations = foreach ($row in $rows) {
  $country = [string]$row.Country
  $count = [string]$row.Count

  if ([string]::IsNullOrWhiteSpace($country)) {
    throw "Every row must include a Country value."
  }

  if (-not ($count -as [int])) {
    if ($count -ne "0") {
      throw "Invalid Count value for country '$country': $count"
    }
  }

  [pscustomobject]@{
    country = $country.Trim()
    count = [int]$count
  }
}

if (-not $KeepOrder) {
  $locations = $locations | Sort-Object -Property @(
    @{ Expression = "count"; Descending = $true },
    @{ Expression = "country"; Descending = $false }
  )
}

$resolvedUpdatedAt = if ([string]::IsNullOrWhiteSpace($UpdatedAt)) {
  (Get-Date).ToString("yyyy-MM-dd")
} else {
  $UpdatedAt
}

$payload = [ordered]@{
  message = $Message
  updatedAt = $resolvedUpdatedAt
  locations = @($locations)
}

$json = $payload | ConvertTo-Json -Depth 4
Set-Content -LiteralPath $Output -Value $json

Write-Host "Updated $Output from $Source"
