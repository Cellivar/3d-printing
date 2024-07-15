# Query the current commit information and pass it in
$headers = @{
    Accept = "application/vnd.github.VERSION.sha"
}
$env:klipper_tag   = Invoke-RestMethod -Headers $headers "https://api.github.com/repos/Klipper3d/klipper/commits/master"
$env:moonraker_tag = Invoke-RestMethod -Headers $headers "https://api.github.com/repos/Arksine/moonraker/commits/master"

docker buildx bake

Write-Host "Klipper tag: ${env:klipper_tag}"
Write-Host "Moonraker tag: ${env:moonraker_tag}"
