# 特定のパッケージがインストールされているかをチェックする関数
function Check-PackageInstalled {
    param (
        [string]$packageId
    )

    $installedPackages = winget list --id $packageId
    return $installedPackages -ne $null
}

# パッケージをインストールする関数
function Install-PackageIfNotInstalled {
    param (
        [string]$packageId
    )

    if (-not (Check-PackageInstalled -packageId $packageId)) {
        Write-Output "Installing $packageId..."
        winget install --id $packageId
    } else {
        Write-Output "$packageId is already installed."
    }
}

Install-PackageIfNotInstalled -packageId "Starship.Starship"
Install-PackageIfNotInstalled -packageId "ajeetdsouza.zoxide"