### SHAREPOINT SECTION ################################

### Copy and Paste This section first if not running script directly ####
Import-Module Microsoft.Online.Sharepoint.PowerShell -DisableNameChecking
$AdminURL = "ADMIN URL"
Connect-SPOService -URL $AdminURL
#########################################################################

################### Remove user from Admin/Owner role ###################

#Get All Site Collections
$Sites = Get-SPOSite -Limit ALL
# $Sites = Get-SPOSite -limit ALL | Select Owner

#Loop through each site and remove site collection admin
Foreach ($Site in $Sites)
{
    Write-host "Scanning site:"$Site.Url -f Yellow
    #Get All Site Collection Administrators
    $Admins = Get-SPOUser -Site $site.Url | Where {$_.IsSiteAdmin -eq $true}
 
    #Iterate through each admin
    Foreach($Admin in $Admins)
    {
        #Check if the Admin Name matches
        If($Admin.LoginName -eq $AdminAccount)
        {
            #Remove Site collection Administrator
            Remove-SPOUser -Site $Site -Login $AdminAccount
            Write-host -f Green "`tAdmin $($AdminAccount) has been removed from $($Admin) Site collection!"
        }
    }
}
#########################################################################

################### Remove user from member role ########################
$UserAccount = Read-Host "Enter the user's email"

#Get all Site Collections
$SitesCollections = Get-SPOSite -Limit ALL
 
#Iterate through each site collection
ForEach($Site in $SitesCollections)
{
    Write-host -f Yellow "Checking Site Collection:"$Site.URL
  
    #Get the user from site collection
    $User = Get-SPOUser -Limit All -Site $Site.URL | Where {$_.LoginName -eq $UserAccount}
  
    #Remove the User from site collection
    If($User)
    {
        #Remove the user from the site collection
        Remove-SPOUser -Site $Site.URL -LoginName $UserAccount
        Write-host -f Green "`tUser $($UserAccount) has been removed from Site collection!"
    }
}

##################################################################################################
