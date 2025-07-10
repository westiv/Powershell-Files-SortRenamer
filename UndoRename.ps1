# Get the folder of the script
$folderPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Find all rename logs
$logFiles = Get-ChildItem -Path $folderPath -Filter "rename_log_*.log"

if (-not $logFiles) {
    Write-Host "No log files found. Exiting."
    exit
}

# Show a selection menu
Write-Host "Available log files:`n"
for ($i = 0; $i -lt $logFiles.Count; $i++) {
    Write-Host "$($i + 1). $($logFiles[$i].Name)"
}
Write-Host ""

$selection = Read-Host "Enter the number of the log to use for undo"
if (-not ($selection -as [int]) -or $selection -lt 1 -or $selection -gt $logFiles.Count) {
    Write-Host "Invalid selection. Exiting."
    exit
}

$logPath = $logFiles[$selection - 1].FullName

# Prepare backup folder
#$backupFolder = Join-Path $folderPath "undo_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
#New-Item -ItemType Directory -Path $backupFolder | Out-Null

# Read and parse the log
$logLines = Get-Content -Path $logPath | Select-Object -Skip 1  # Skip header

Write-Host "`nUndoing renames using log file: '$($logFiles[$selection - 1].Name)'"
$reverted = 0

foreach ($line in $logLines) {
    if ($line -match "^(.*)\s+->\s+(.*)$") {
        $originalName = $matches[1].Trim()
        $newName = $matches[2].Trim()

        $originalPath = Join-Path $folderPath $originalName
        $newPath = Join-Path $folderPath $newName

      if ((Test-Path $newPath) -and (-not (Test-Path $originalPath))) {
            # Backup the renamed file first
            #Copy-Item -Path $newPath -Destination (Join-Path $backupFolder $newName)

            # Perform the undo
            Rename-Item -Path $newPath -NewName $originalName
            Write-Host "Reverted: $newName -> $originalName"
            $reverted++
        } elseif (-not (Test-Path $newPath)) {
            Write-Host "Missing file: $newName (skipped)"
        } else {
            Write-Host "Conflict: $originalName already exists (skipped)"
        }
    }
}

Write-Host "`nUndo complete. Total files reverted: $reverted"
#Write-Host "Backup of renamed files saved to: $backupFolder"
