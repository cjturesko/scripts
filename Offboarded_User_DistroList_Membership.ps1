Import-Module AzureAD
Import-Module ActiveDirectory

# Login to Azure AD
if (!(Get-AzureADSignedInUser)) {
    Connect-AzureAD
}

# Define the username (email or UPN) to check for Azure AD and sAMAccountName for local AD
$userPrincipalName = Read-Host "Enter the User Principal Name (e.g., user@domain.com)"
$samAccountName = Read-Host "Enter the SAM Account Name for local AD (e.g., username)"

# Azure AD Group Membership Retrieval
$userAzureAD = Get-AzureADUser -ObjectId $userPrincipalName

if ($userAzureAD -eq $null) {
    Write-Output "User not found in Azure AD."
} else {
    # Retrieve all Azure AD groups
    $azureGroups = Get-AzureADUserMembership -ObjectId $userAzureAD.ObjectId
}

# Local AD Group Membership Retrieval
$userLocalAD = Get-ADUser -Identity $samAccountName -Properties MemberOf

if ($userLocalAD -eq $null) {
    Write-Output "User not found in local Active Directory."
} else {
    # Retrieve all local AD groups
    $localGroups = $userLocalAD | Get-ADUser -Properties MemberOf | Select-Object -ExpandProperty MemberOf | ForEach-Object {
        (Get-ADGroup -Identity $_).Name
    }
}

# Set the path for the report file
$reportPath = "C:\offboarded_users.txt"

# Generate the report entry
$reportEntry = "User: $($userPrincipalName) - Group Memberships on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$reportEntry += "`r`n" + ('-' * 60) + "`r`n"

# Append Azure AD groups if available
if ($azureGroups) {
    $reportEntry += "Azure AD Groups:`r`n"
    foreach ($group in $azureGroups) {
        $reportEntry += "$($group.DisplayName)`r`n"
    }
}

# Append Local AD groups if available
if ($localGroups) {
    $reportEntry += "`r`nLocal AD Groups:`r`n"
    foreach ($group in $localGroups) {
        $reportEntry += "$group`r`n"
    }
}

$reportEntry += "`r`n" + ('=' * 60) + "`r`n"

# Append the report entry to the file
Add-Content -Path $reportPath -Value $reportEntry

Write-Output "Group membership report for $($userPrincipalName) has been saved to $reportPath."
