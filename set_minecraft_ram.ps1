# Bereken 90% van het vrije RAM en pas de Java-argumenten aan voor Prism Launcher

# Hoeveel RAM is vrij in MB
$freeRamMB = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024

# 90% van het vrije RAM
$allocRamMB = [math]::Floor($freeRamMB * 0.9)

# Bestand waar Prism zijn instellingen opslaat
$settingsFile = "$env:APPDATA\PrismLauncher\instances\$env:INST_ID\instance.cfg"

# Oude waarden verwijderen en nieuwe toevoegen
(Get-Content $settingsFile) |
    Where-Object { $_ -notmatch "^MaxMemAlloc=" } |
    Add-Content -Path $settingsFile -Encoding UTF8

Add-Content -Path $settingsFile -Value "MaxMemAlloc=$allocRamMB" -Encoding UTF8

Write-Host "RAM toewijzing ingesteld op $allocRamMB MB voor $env:INST_NAME"
