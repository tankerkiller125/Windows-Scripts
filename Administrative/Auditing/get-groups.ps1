#// Start of script 
#// Get year and month for csv export file 
$DateTime = Get-Date -f "yyyy-MM" 
 
#// Set CSV file name 
$CSVFile = "..\data\" + $DateTime + "_ADGroups.csv" 
 
#// Create emy array for CSV data 
$CSVOutput = @() 

#// Get all AD groups in the domain 
$ADGroups = Get-ADGroup -Filter * -Properties * 
 
#// Set progress bar variables 
$i = 0 
$tot = $ADGroups.count 
 
foreach ($ADGroup in $ADGroups) { 
    #// Set up progress bar 
    $i++ 
    $status = "{0:N0}" -f ($i / $tot * 100) 
    Write-Progress -Activity "Exporting AD Groups" -status "Processing Group $i of $tot : $status% Completed" -PercentComplete ($i / $tot * 100) 
 
    #// Ensure Members variable is empty 
    $Members = "" 
 
    #// Get group members which are also groups and add to string 
    $MembersArr = Get-ADGroup -filter {Name -eq $ADGroup.Name} | Get-ADGroupMember | select Name, objectClass, distinguishedName 
    if ($MembersArr) {  
        foreach ($Member in $MembersArr) {  
            if ($Member.objectClass -eq "user") { 
                $MemDN = $Member.distinguishedName 
                $UserObj = Get-ADUser -filter {DistinguishedName -eq $MemDN} 
                if ($UserObj.Enabled -eq $False) { 
                    continue 
                } 
            } 
            $Members = $Members + "," + $Member.Name  
        } 
        #// Check for members to avoid error for empty groups 
        if ($Members) { 
            $Members = $Members.Substring(1, ($Members.Length) - 1) 
        } 
    } 
 
    #// Set up hash table and add values 
    $HashTab = $NULL 
    $HashTab = [ordered]@{ 
        "Name"     = $ADGroup.Name 
        "Category" = $ADGroup.GroupCategory 
        "Scope"    = $ADGroup.GroupScope
        "Path"     = $ADGroup.CanonicalName
        "Members"  = $Members
    } 
 
    #// Add hash table to CSV data array 
    $CSVOutput += New-Object PSObject -Property $HashTab 
} 
 
#// Export to CSV files 
$CSVOutput | Sort-Object Name | Export-Csv $CSVFile -NoTypeInformation 
 
#// End of script