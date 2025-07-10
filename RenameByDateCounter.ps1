# === CONFIGURATION ===
$excludedExtensions = ('.ps1', '.txt',  '.bat',  '.log',  '.exe')  # Extensions to exclude (lowercase)
$logFile = "rename_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$logPath = Join-Path -Path $PSScriptRoot -ChildPath $logFile
# ======================

$scriptPath = $MyInvocation.MyCommand.Path
$folderPath = Split-Path $scriptPath
$scriptName = Split-Path $scriptPath -Leaf

# Collect files excluding script and excluded extensions
$allFiles = Get-ChildItem -Path $folderPath -File | Where-Object {
    $_.Name -ne $scriptName -and
    -not $excludedExtensions.Contains($_.Extension.ToLower())
}

# Prepare log
"OriginalName -> NewName" | Out-File -FilePath $logPath -Encoding UTF8

# Group files by extension
$groupedFiles = $allFiles | Group-Object Extension

foreach ($group in $groupedFiles) {
    $ext = $group.Name.ToLower()
    $prefix = $ext.TrimStart('.')
    $files = $group.Group | Sort-Object CreationTime

    $nameCounter = @{}

    foreach ($file in $files) {
        $created = $file.CreationTime
        $dateStr = $created.ToString("dd-MM-yyyy_HH-mm_ddd")

        # Create a base key from the timestamp
        $baseKey = "${prefix}_${dateStr}"

        # Initialize or increment counter
        if (-not $nameCounter.ContainsKey($baseKey)) {
            $nameCounter[$baseKey] = 1
        } else {
            $nameCounter[$baseKey]++
        }

        $counter = "{0:D3}" -f $nameCounter[$baseKey]
        $newName = "${baseKey}_${counter}${ext}"
        $newPath = Join-Path $folderPath $newName

        if (-not (Test-Path $newPath)) {
            Rename-Item -Path $file.FullName -NewName $newName
            "$($file.Name) -> $newName" | Out-File -FilePath $logPath -Append -Encoding UTF8
        } else {
            Write-Host "Skipped (exists): $newName"
        }
    }
}

Write-Host "`nRenaming complete. Log saved to: $logPath"