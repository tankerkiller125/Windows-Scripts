# CSV Meta Data
$DateTime = Get-Date -f "yyyy-MM" 
$CSVFile = $DateTime + "_ADUsers.csv" 
$CSVOutput = @() 

# Get all Users
$AdUsers = Get-ADUser -Filter * -Properties *

$i = 0
$total = $AdUsers.count

foreach ($AdUser in $AdUsers) {
    $i++
    $status = "{0:N0}" -f ($i / $total * 100) 
    Write-Progress -Activity "Exporting AD Users" -status "Processing User $i of $total : $status% Completed" -PercentComplete ($i / $total * 100)

    #// Set up hash table and add values 
    $HashTab = $NULL 
    $HashTab = [ordered]@{ 
        "Name"                  = $AdUser.Name 
        "Path"                  = $AdUser.CanonicalName
        "Succesfull Login Time" = $AdUser.LastLogonDate
        "Failed Login Time"     = $AdUser.LastBadPasswordAttempt
        "Active"                = $AdUser.Enabled
    } 

    $CSVOutput += New-Object PSObject -Property $HashTab 
}

$CSVOutput | Sort-Object Name | Export-Csv $CSVFile -NoTypeInformation 
