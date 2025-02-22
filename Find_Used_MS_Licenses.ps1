# Connect to M365 if not already connected
Connect-MsolService	

# Get all users and their assigned licenses
$users = Get-MsolUser -All | Select-Object DisplayName, Licenses

# Define license SKUs based on your tenant
$licenseMap = @{
    "BusinessStandard" = "XX:O365_BUSINESS_PREMIUM"  # Business Standard
    "E3" = "XX:ENTERPRISEPACK"  # Office 365 E3
    "E5" = "XX:ENTERPRISEPREMIUM"  # Office 365 E5
    "M365_E3" = "XX:SPE_E3"  # Microsoft 365 E3
    "M365_E5" = "XX:SPE_E5"  # Microsoft 365 E5
    "TeamsAudio" = "XX:Microsoft_Teams_Audio_Conferencing_select_dial_out"  # Teams Dial-out
}

# Prepare output data
$userData = foreach ($user in $users) {
    # Check if the user has any of the Office licenses
    $hasOfficeLicense = ($user.Licenses.AccountSkuId -contains $licenseMap["BusinessStandard"]) -or
                        ($user.Licenses.AccountSkuId -contains $licenseMap["E3"]) -or
                        ($user.Licenses.AccountSkuId -contains $licenseMap["E5"]) -or
                        ($user.Licenses.AccountSkuId -contains $licenseMap["M365_E3"]) -or
                        ($user.Licenses.AccountSkuId -contains $licenseMap["M365_E5"])

    # Check if the user has Teams Audio Conferencing with Dial-out
    $hasTeamsLicense = ($user.Licenses.AccountSkuId -contains $licenseMap["TeamsAudio"])

    # Only include users who have at least one of the licenses
    if ($hasOfficeLicense -or $hasTeamsLicense) {
        [PSCustomObject]@{
            Name   = $user.DisplayName
            Office = if ($hasOfficeLicense) { "X" } else { "-" }
            Teams  = if ($hasTeamsLicense) { "X" } else { "-" }
        }
    }
}

# Save output to CSV
$userData | Export-Csv -Path "$env:USERPROFILE\Desktop\Teams_License_Report.csv" -NoTypeInformation

# Display message
Write-Output "Report saved to Desktop as 'Teams_License_Report.csv'"
