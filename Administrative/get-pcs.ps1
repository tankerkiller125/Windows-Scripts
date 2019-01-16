$DateTime = Get-Date -f "yyyy-MM"

# Get all computers and their IPv4Addresses and export to CSV
Get-ADComputer -Filter * -Properties IPv4Address | Export-Csv -Path $DateTime + "_GetPCs.csv"