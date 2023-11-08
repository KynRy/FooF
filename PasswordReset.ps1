# Prompt the user for the search criteria (Name, SamAccountName, or UserPrincipalName)
$searchCriteria = Read-Host "Enter the Active Directory user's Name, SamAccountName, or UserPrincipalName"

# Try to get the AD user based on the provided criteria
try {
    $adUser = Get-AdUser -Filter {
        (Name -eq $searchCriteria) -or
        (SamAccountName -eq $searchCriteria) -or
        (UserPrincipalName -eq $searchCriteria)
    }
    
    if ($adUser) {
        Write-Host "User found:"
        $adUser

        # Ask for confirmation to reset the user's password
        $resetPassword = Read-Host "Reset the password for this user? (Y/N)"

        if ($resetPassword -eq 'Y') {
            # Reset the user's password to 'password'
            Set-AdAccountPassword -Identity $adUser -NewPassword (ConvertTo-SecureString 'password' -AsPlainText -Force)
            Write-Host "Password reset for user $($adUser.Name)."
        } else {
            Write-Host "Password not reset."
        }
    } else {
        Write-Host "User not found."
    }
} catch {
    Write-Host "Error: $_"
}

