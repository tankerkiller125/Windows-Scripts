Param(
    $WsusServer,
    $WsusPort
)

(Get-WsusServer -Name $WsusServer -PortNumber $WsusPort).GetSubscription().GetSynchronizationProgress()
(Get-WsusServer -Name $WsusServer -PortNumber $WsusPort).GetSubscription().GetSynchronizationStatus()
