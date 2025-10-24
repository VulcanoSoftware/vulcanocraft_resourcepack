# ============================================
# Prism Launcher RAM auto-toewijzingsscript
# ============================================

# Instance-naam die Prism meegeeft
$instanceName = $env:INST_NAME
if (-not $instanceName) {
    Write-Host "⚠️ Geen instance-naam gevonden via Prism, gebruik standaard 'default'."
    $instanceName = "default"
}

# Pad naar de configuratie van deze instance
$instancePath = Join-Path "$env:APPDATA\PrismLauncher\instances" $instanceName
$configFile   = Join-Path $instancePath "instance.cfg"

if (-not (Test-Path $configFile)) {
    Write-Host "❌ Kon instance.cfg niet vinden op: $configFile"
    exit 1
}

# Vrij geheugen in MB berekenen
$freeRamMB = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024

# 90 % gebruiken, met grenzen
$allocRamMB = [math]::Floor($freeRamMB * 0.9)
if ($allocRamMB -lt 4096) { $allocRamMB = 4096 }    # minimaal 4 GB
if ($allocRamMB -gt 16384) { $allocRamMB = 16384 }  # maximaal 16 GB

# Bestand aanpassen
$content = Get-Content $configFile
$newContent = @()
$found = $false
foreach ($line in $content) {
    if ($line -match "^MaxMemAlloc=") {
        $newContent += "MaxMemAlloc=$allocRamMB"
        $found = $true
    }
    else {
        $newContent += $line
    }
}
if (-not $found) {
    $newContent += "MaxMemAlloc=$allocRamMB"
}

# Schrijf terug
$newContent | Set-Content -Path $configFile -Encoding UTF8

Write-Host "✅ RAM-toewijzing ingesteld op $allocRamMB MB voor $instanceName"
