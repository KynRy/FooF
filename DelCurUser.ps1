$currentUserProfile = $env:USERPROFILE
$folderToDelete = Join-Path -Path $currentUserProfile -ChildPath 'AppData\Roaming\ScanApp2'

if (Test-Path -Path $folderToDelete) {
    Remove-Item -Path $folderToDelete -Recurse -Force -Verbose
} else {
    Write-Host "The folder $folderToDelete does not exist for the current user."
}
