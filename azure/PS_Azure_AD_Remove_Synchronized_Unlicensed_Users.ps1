<#
This script must be run in the Windows Azure Active Directory Module for Windows PowerShell.
The following content was taken from http://msdn.microsoft.com/en-us/library/azure/jj151815.aspx.

**********************************************************************************************************
The Azure AD Module is supported on the following Windows operating systems with the default version of 
Microsoft .NET Framework and Windows PowerShell: Windows 8.1, Windows 8, Windows 7, Windows Server 
2012 R2, Windows Server 2012, or Windows Server 2008 R2. 

First install the Microsoft Online Services Sign-In Assistant for IT Professionals RTW from the Microsoft Download Center. 
Then install the Azure Active Directory Module for Windows PowerShell (64-bit version), and click Run to run the installer package. 

Important
Effective October 20, 2014, the Azure Active Directory Module for Windows PowerShell (32-bit version) is discontinued. 
Support for the 32-bit version will no longer occur, and future updates to the Azure Active Directory Module will be released 
only for the 64-bit version. We strongly recommend you install the 64-bit version to ensure future support and compatibility. 
**********************************************************************************************************

Eric Skaggs
www.skaggej.com
eskaggs@outlook.com
#>

#Connect to Windows Azure AD (enter global admin credentials when prompted)
Connect-Msolservice

#Get the unlicensed, synced users
$usersToRemove = Get-MsolUser -Synchronized -UnlicensedUsersOnly

#Remove the users from Azure AD (no confirmation prompt will be given)
$usersToRemove | ForEach-Object{Remove-MsolUser -UserPrincipalName $_.UserPrincipalName -force}