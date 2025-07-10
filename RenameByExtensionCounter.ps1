# === CONFIGURATION ===
$excludedExtensions = @('.ps1', '.txt',  '.bat',  '.log',  '.exe')  # Add extensions to exclude (include dot, lowercase)
$logFile = "rename_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$logPath = Join-Path -Path $PSScriptRoot -ChildPath $logFile
# ======================

$scriptPath = $MyInvocation.MyCommand.Path
$folderPath = Split-Path $scriptPath
$scriptName = Split-Path $scriptPath -Leaf

# Get all files excluding the script and excluded extensions
$allFiles = Get-ChildItem -Path $folderPath -File | Where-Object {
    $_.Name -ne $scriptName -and
    -not $excludedExtensions.Contains($_.Extension.ToLower())
}

# Create log file
"OriginalName -> NewName" | Out-File -FilePath $logPath -Encoding UTF8

# Group files by extension
$groupedFiles = $allFiles | Group-Object Extension

foreach ($group in $groupedFiles) {
    $ext = $group.Name.ToLower()
    $prefix = $ext.TrimStart('.')
    $files = $group.Group | Sort-Object Name

    $i = 1
    foreach ($file in $files) {
        $counter = "{0:D3}" -f $i
        $newName = "{0}_{1}{2}" -f $prefix, $counter, $ext
        $newPath = Join-Path $folderPath $newName

        if (-not (Test-Path $newPath)) {
            Rename-Item -Path $file.FullName -NewName $newName
            "$($file.Name) -> $newName" | Out-File -FilePath $logPath -Append -Encoding UTF8
            $i++
        } else {
            Write-Host "Skipped (already exists): $newName"
        }
    }
}

Write-Host "`nRenaming complete. Log saved to: $logPath"