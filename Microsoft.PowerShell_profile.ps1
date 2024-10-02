# Git管理できないような怪しいものはsecretHook.ps1に書く

$secretHookPath = "$env:USERPROFILE\Documents\PowerShell\secrethook.ps1"
if (Test-Path $secretHookPath) {
    . $secretHookPath
}

# EDITOR
$env:EDITOR = "code"

# 文字コードの設定
$origin = [System.Console]::OutputEncoding
$utf8 = [System.Text.Encoding]::GetEncoding("utf-8")
$OutputEncoding = $utf8
[System.Console]::OutputEncoding = $utf8

# 汎用エイリアス
Set-Alias c code
Set-Alias e explorer.exe
Set-Alias clip Set-Clipboard

# 辞書
function Get-MyConfig {
    # このファイルからFunction, aliasを取得
    bat $PROFILE | rg function
    bat $PROFILE | rg Alias
}
Set-Alias mc Get-MyConfig

# 新しいファイルを作成する
function newfile {
    $file = $args[0]
    if ($null -eq $file) {
        $file = "new.txt"
    }
    New-Item -Path $file -ItemType File
}
Set-Alias nf newfile

# リモートに既に存在しないローカルブランチを削除
function GitDeleteRemoteBranches {
    git fetch -p
    git branch -r | ForEach-Object {
        $branch = $_.Trim()
        $branch = $branch -replace "origin/", ""
        if (-not (git branch -v | Select-String -Pattern $branch)) {
            git branch -D $branch
        }
    }
}
Set-Alias cleanup GitDeleteRemoteBranches

function Generate-Password {
    param(
        [int]$length = 16,
        [switch]$excludeSymbols
    )
    # パスワードの長さを指定
    $passwordLength = $length

    # 使用する文字セットを定義
    $upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    $lowerCase = "abcdefghijklmnopqrstuvwxyz"
    $numbers = "0123456789"
    $specialCharacters = "!@#$%^&*()-_=+[]{}|;:,.<>?/`~"

    # 文字セットを結合
    $allCharacters = $upperCase + $lowerCase + $numbers
    if (-not $excludeSymbols) {
        $allCharacters += $specialCharacters
    }

    # パスワードを格納する変数を初期化
    $password = ""

    # ランダムな文字を選択してパスワードを生成
    for ($i = 0; $i -lt $passwordLength; $i++) {
        $randomIndex = Get-Random -Minimum 0 -Maximum $allCharacters.Length
        $password += $allCharacters[$randomIndex]
    }

    # 生成したパスワードを表示
    Write-Output $password

    # クリップボードにコピー
    $password | Set-Clipboard
}
Set-Alias genpass Generate-Password

# es | fzf
function Everything-FuzzyFind {
    $OutputEncoding = $origin
    [System.Console]::OutputEncoding = $origin
    $esResult = es $args | Out-String

    $OutputEncoding = $utf8
    [System.Console]::OutputEncoding = $utf8

    $esResult | fzf
}
Set-Alias esfz Everything-FuzzyFind

# カレントディレクトリ配下にあるSVNのリポジトリを全て更新
function Update-SvnRepos {
    $svnRepos = Get-ChildItem -Directory | Where-Object { Test-Path "$($_.FullName)\.svn" }
    $svnRepos | ForEach-Object {
        $repo = $_.FullName
        Write-Host "Updating $repo"
        svn update $repo
    }
}
Set-Alias usvn Update-SvnRepos

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Enable-PsFzfAliases
