Connect-AzureAD
Connect-MsolService

$Account = "##user##@#company#.onmicrosoft.com"

Write-Host "---Disabling Account---"
Set-AzureADUser -ObjectID $Account -AccountEnabled $false

Write-Host "---Removing All Groups---"

$userID = (Get-AzureADUser -ObjectId $Account).objectid

$Groups = Get-AzureADUserMembership -ObjectID $userID
foreach($Group in $Groups){
    Remove-AzureADGroupMember -ObjectID $Group.ObjectID -MemberId $userID
}

Write-Host "---Removing Licenses From Account---"

$MsolUser = Get-MsolUser -UserPrincipalName $Account
$AssignedLicenses = $MsolUser.licenses.AccountSkuId
foreach($License in $AssignedLicenses) {
    Set-MsolUserLicense -UserPrincipalName $Account -RemoveLicenses $License
}
