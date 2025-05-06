# Elevate if not admin
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

$Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Administrator)"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.PrivateData.ProgressBackgroundColor = "Black"
$Host.PrivateData.ProgressForegroundColor = "White"
Clear-Host

Write-Host "1. Disable Web Search in Start Menu (Recommended)"
Write-Host "2. Enable Web Search in Start Menu (Default)"

while ($true) {
    $choice = Read-Host "`nChoose an option (1 or 2)"
    if ($choice -match '^[1-2]$') {
        switch ($choice) {
            1 {
                Clear-Host
                Write-Host "Disabling Web Search in Windows..."

                # Disable Bing Web Search + Cortana Suggestions
                reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f | Out-Null
                reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f | Out-Null
                reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f | Out-Null

                Write-Host "Web Search has been disabled..."
                break
            }
            2 {
                Clear-Host
                Write-Host "Enabling Web Search in Windows."

                # Enable Bing Web Search + Cortana Suggestions
                reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "0" /f | Out-Null
                reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "1" /f | Out-Null
                reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "1" /f | Out-Null

                Write-Host "Web Search has been enabled."
                break
            }
        }
    } else {
        Write-Host "Invalid choice. Please enter 1 or 2."
    }
}
