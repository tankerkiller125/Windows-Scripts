Param(
    $WsusServer,
    $WsusPort,
    $ToAddress,
    $FromAddress,
    $MailServer,
    $LogPath
)
 
# Mail Subject
$subject = "WSUS Cleanup"

try {
    Start-Transcript $LogPath

    Get-WsusServer -Name $WsusServer -PortNumber $WsusPort | Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates

    Invoke-WsusSpringClean -DeclineSupersededUpdates -DeclinePrereleaseUpdates -DeclineLanguagesExclude @('en-US') -DeclineArchitectures @('ia64') -DeclineSecurityOnlyUpdates

    Stop-Transcript

    # Send Mail with log content
    $body = Get-Content -Path $LogPath | Out-String
    Send-MailMessage -To $ToAddress -From $FromAddress -Subject $subject -Body $body -SmtpServer $MailServer
}
catch {
    Send-MailMessage -To $ToAddress -From $FromAddress -Subject "WSUS Cleanup - Failed!" -Body "The WSUS Cleanup task failed, check the server logs located at $LogPath for more information." -SmtpServer $MailServer
}