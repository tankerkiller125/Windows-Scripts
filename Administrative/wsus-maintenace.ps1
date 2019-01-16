Param(
    $WsusServer,
    $WsusPort,
    $ToAddress,
    $FromAddress,
    $MailServer,
    $LogPath
)
 
# Mail Subject
$subject = "WSUS Maintenance"
 
##Start Log
Start-Transcript $LogPath
 
Invoke-WsusSpringClean -DeclineSupersededUpdates -DeclinePrereleaseUpdates -DeclineLanguagesExclude @('en-US') -DeclineArchitectures @('ia64') -DeclineSecurityOnlyUpdates
Get-WsusServer -Name $WsusServer -PortNumber $WsusServer | Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates
 
##Stop Log
Stop-Transcript
 
##Send Mail
$body = Get-Content -Path $LogPath | Out-String
Send-MailMessage -To $ToAddress -From $FromAddress -Subject $subject -Body $body -SmtpServer $MailServer
 
##END