# PowerShell script to add or remove a registry entry and restart explorer.exe

# Function to check if the OS is Windows 11
function Check-OS {
    $os = (Get-WmiObject -Class Win32_OperatingSystem).Caption
    return $os -like "*Windows 11*"
}

# Elevate if not admin
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

# Function to add the registry entry
function Add-RegistryEntry {
    reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
    Write-Host "Registry entry added successfully."
}

# Function to remove the registry entry
function Remove-RegistryEntry {
    reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f
    Write-Host "Registry entry removed successfully."
}

# Function to restart explorer.exe
function Restart-Explorer {
    Write-Host "Restarting Explorer..."
    Stop-Process -Name explorer -Force
    Start-Sleep -Seconds 1
    Start-Process explorer.exe
}

# Check for Windows 11
if (-not (Check-OS)) {
    # Display the warning and prompt for user input
    Write-Host "Warning: This script is meant to be used in Windows 11 systems only." -ForegroundColor Red
    $response = Read-Host "Type 3310 If you wish to continue despite the warning"

    # Check if the user entered 3310
    if ($response -ne "3310") {
        Write-Host "Operation aborted. You did not enter 3310."
        Exit
    }
}

# Prompt user for action
Write-Host "`nChoose an option`n1. Tweak (Recommended)`n2. Default"

# Display the warning in red
Write-Host "`nWarning: This script is meant to be used in Windows 11 systems only." -ForegroundColor Red

# Get user choice
$choice = Read-Host "Enter your choice (1 or 2)"

# Perform action based on user choice
if ($choice -eq '1') {
    Add-RegistryEntry
    Restart-Explorer
} elseif ($choice -eq '2') {
    Remove-RegistryEntry
    Restart-Explorer
} else {
    Write-Host "Invalid choice, please enter 1 or 2."
}
