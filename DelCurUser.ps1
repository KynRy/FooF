# Get the username of the currently logged-on user from the registry
$currentUser = (Get-ItemProperty -Path "HKCU:\Volatile Environment\").UserName

if ($currentUser) {
    # Construct the path to the user's AppData folder
    $folderToDelete = "C:\Users\$currentUser\AppData\Roaming\ScanApp2"

    if (Test-Path -Path $folderToDelete) {
        Remove-Item -Path $folderToDelete -Recurse -Force -Verbose
    } else {
        Write-Host "The folder $folderToDelete does not exist for the current user."
    }
} else {
    Write-Host "Unable to determine the current user."
}
