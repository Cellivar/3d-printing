# Query the current commit information and pass it in
$headers = @{
    Accept = "application/vnd.github.VERSION.sha"
}

# Klipper tags once in a blue moon, just use latest and pray.
$env:klipper_tag   = Invoke-RestMethod -Headers $headers "https://api.github.com/repos/Klipper3d/klipper/commits/master"

# Moonraker tags more proactively, can use static tags here or uncomment the continuous tag check.
$env:moonraker_tag = "v0.9.2"
# $env:moonraker_tag = Invoke-RestMethod -Headers $headers "https://api.github.com/repos/Arksine/moonraker/commits/master"

docker buildx bake printer

Write-Host "Klipper tag: ${env:klipper_tag}"
Write-Host "Moonraker tag: ${env:moonraker_tag}"
