Param (
    [switch]$InstallPkg = $false
)

# カレントディレクトリの取得
$dir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# winget import
if ($InstallPkg = $true) {
    winget import winget_packages.json --no-upgrade --disable-interactivity
}

# シンボリックリンクの設定値リスト
$linkSettings = @(
    @{ src = ".wezterm.lua"; dst = "$env:USERPROFILE\.wezterm.lua" },
    @{ src = "Microsoft.PowerShell_profile.ps1"; dst = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" },
    @{ src = "nu"; dst = "$env:USERPROFILE\AppData\Roaming\nushell" },
    @{ src = "helix"; dst = "$env:USERPROFILE\AppData\Roaming\helix" },
    @{ src = "broot\conf.hjson"; dst = "$env:USERPROFILE\AppData\Roaming\dystroy\broot\config\conf.hjson" },
    @{ src = "broot\verbs.hjson"; dst = "$env:USERPROFILE\AppData\Roaming\dystroy\broot\config\verbs.hjson" },
    @{ src = "LazyVimSettings"; dst = "$env:USERPROFILE\AppData\Local\nvim" }
    # 他の設定値を追加する場合はここに追加
)

# シンボリックリンクの作成
$linkSettings.ForEach({
        $src = Join-Path $dir $_.src
        $dst = $_.dst

        if (Test-Path $src) {
            Write-Host "Create SymbolicLink: $src -> $dst"
        }
        else {
            Write-Host "Not Found: $src"
            return
        }

        if (Test-Path $dst) {
            Remove-Item $dst
        }

        New-Item -ItemType SymbolicLink -Path $dst -Value $src
    })

# .configディレクトリの作成
$configDir = "$env:USERPROFILE\.config"
if (-not (Test-Path "$configDir")) {
    New-Item -ItemType Directory -Path "$configDir"
}

# zoxide
$zoxideConfigDir = "$configDir\zoxide"
$zoxideInitNu = "$zoxideConfigDir\init.nu"
if (-not (Test-Path $zoxideConfigDir)) {
    New-Item -ItemType Directory -Path $zoxideConfigDir
}
if (Test-Path "$zoxideInitNu") {
    Remove-Item "$zoxideInitNu"
}
zoxide init nushell | Out-File "$zoxideInitNu"

# starship
$starshipConfigDir = "$configDir\starship"
$starshipInitNu = "$starshipConfigDir\init.nu"
if (-not (Test-Path "$starshipConfigDir")) {
    New-Item -ItemType Directory -Path "$starshipConfigDir"
}
if (Test-Path "$starshipInitNu") {
    Remove-Item "$starshipInitNu"
}
starship init nu | Out-File "$starshipInitNu"
