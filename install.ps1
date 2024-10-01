# カレントディレクトリの取得
$dir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# シンボリックリンクの設定値リスト
$linkSettings = @(
    @{ src = ".wezterm.lua"; dst = "$env:USERPROFILE\.wezterm.lua" }
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