# Prompt the user for the AD user's name
$adUserName = Read-Host "Enter the Active Directory user's name"

# Try to get the AD user based on the provided name
try {
    $adUser = Get-AdUser -Filter "Name -eq '$adUserName'"
    
    if ($adUser) {
        Write-Host "User found:"
        $adUser
    } else {
        Write-Host "User not found."
    }
} catch {
    Write-Host "Error: $_"
}
