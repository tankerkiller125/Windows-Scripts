Param(
    $WsusServer,
    $WsusPort
)

if ($WsusServer -ne $null -and $WsusPort -ne $null) {
    (Get-WsusServer -Name $WsusServer -PortNumber $WsusPort).GetSubscription().GetLastSynchronizationInfo()

    (Get-WsusServer -Name $WsusServer -PortNumber $WsusPort).GetSubscription().GetSynchronizationProgress()
    
    (Get-WsusServer -Name $WsusServer -PortNumber $WsusPort).GetSubscription().GetSynchronizationStatus()
}
else {
    Write-Host "You must specify -WsusServer and -WsusPort" -ForegroundColor red
}
