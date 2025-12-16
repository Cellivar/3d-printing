# Query the current commit information and pass it in
$headers = @{
    Accept = "application/vnd.github.VERSION.sha"
}

# my kingdom for open source repos that use semver tags
if ([string]::IsNullOrWhiteSpace($env:klipper_tag)) {
    $env:klipper_tag   = Invoke-RestMethod -Headers $headers "https://api.github.com/repos/KalicoCrew/kalico/commits/main"
}

if ([string]::IsNullOrWhiteSpace($env:moonraker_tag)) {
    $env:moonraker_tag   = Invoke-RestMethod -Headers $headers "https://api.github.com/repos/Arksine/moonraker/commits/master"
}

docker buildx bake printer

Write-Host "Klipper tag: ${env:klipper_tag}"
Write-Host "Moonraker tag: ${env:moonraker_tag}"
