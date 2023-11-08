# Get the current user's username
$currentUser = whoami

# Construct the path to the user's AppData folder
$folderToDelete = "C:\Users\$currentUser\AppData\Roaming\ScanApp2"

if (Test-Path -Path $folderToDelete) {
    Remove-Item -Path $folderToDelete -Recurse -Force -Verbose
} else {
    Write-Host "The folder $folderToDelete does not exist for the current user."
}
