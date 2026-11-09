<#
.SYNOPSIS
  Gera installer\Output\ProXML-Setup.exe com o Inno Setup 6.

.DESCRIPTION
  1. Confere a versão (x.y.z) e a FileVersion do exe Release informado.
  2. Monta uma pasta de staging limpa em installer\Output\staging com:
       - o ProXML.exe informado em -ExePath;
       - sk4d.dll (não versionado; padrão bin\sk4d.dll);
       - Report\, Schemas\ e db\notas.db VAZIO, extraídos do HEAD do git
         (só o versionado; nada de bin\NFCe, ErroLog.txt ou WinRAR.exe);
       - LICENSE-lucide.txt (docs/ui/icones), também do HEAD.
  3. Recusa nomes de arquivo com sequências de 14+ dígitos (CNPJ/chave de acesso).
  4. Chama o ISCC com /DAppVersion e /DSourceDir e mostra tamanho e SHA-256.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File installer\build.ps1 -Version 1.2.0 -ExePath C:\build\ProXML.exe
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $Version,
    [Parameter(Mandatory = $true)] [string] $ExePath,
    [string] $Sk4dPath,
    [string] $IsccPath,
    [string] $GitPath
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2

function Fail([string] $Msg) { Write-Host "ERRO: $Msg" -ForegroundColor Red; exit 1 }

$InstallerDir = $PSScriptRoot
$RepoRoot     = Split-Path $InstallerDir -Parent
$OutputDir    = Join-Path $InstallerDir 'Output'
$Staging      = Join-Path $OutputDir 'staging'
$IssFile      = Join-Path $InstallerDir 'ProXML.iss'
$SetupFile    = Join-Path $OutputDir 'ProXML-Setup.exe'

# --- Versão e exe ---------------------------------------------------------
if ($Version -notmatch '^\d+\.\d+\.\d+$') { Fail "Versão inválida '$Version' (use x.y.z, ex.: 1.2.0)." }
if (-not (Test-Path -LiteralPath $ExePath -PathType Leaf)) { Fail "Exe não encontrado: $ExePath" }
$ExePath = (Resolve-Path -LiteralPath $ExePath).Path
if ($ExePath -ieq (Join-Path $RepoRoot 'bin\ProXML.exe')) { Fail 'Não use bin\ProXML.exe; informe o exe Release compilado para a versão.' }
$FileVersion = (Get-Item -LiteralPath $ExePath).VersionInfo.FileVersion
if ($FileVersion -ne "$Version.0") { Fail "FileVersion do exe é '$FileVersion', esperado '$Version.0'." }

if (-not $Sk4dPath) { $Sk4dPath = Join-Path $RepoRoot 'bin\sk4d.dll' }
if (-not (Test-Path -LiteralPath $Sk4dPath -PathType Leaf)) { Fail "sk4d.dll não encontrada: $Sk4dPath" }

# --- Ferramentas -----------------------------------------------------------
if (-not $GitPath) {
    $cmd = Get-Command git.exe -ErrorAction SilentlyContinue
    if ($cmd) { $GitPath = $cmd.Source }
    else {
        $GitPath = @("$env:ProgramFiles\Git\cmd\git.exe", "${env:ProgramFiles(x86)}\Git\cmd\git.exe", "$env:LOCALAPPDATA\Programs\Git\cmd\git.exe") |
            Where-Object { Test-Path $_ } | Select-Object -First 1
    }
}
if (-not $GitPath) { Fail 'git.exe não encontrado (use -GitPath).' }

if (-not $IsccPath) {
    $IsccPath = @("$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe", "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe", "$env:ProgramFiles\Inno Setup 6\ISCC.exe") |
        Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $IsccPath) { Fail 'ISCC.exe (Inno Setup 6) não encontrado (use -IsccPath).' }

# tar do Windows (bsdtar); evita o tar do Git Bash, que não entende C:\...
$TarPath = Join-Path $env:SystemRoot 'System32\tar.exe'
if (-not (Test-Path $TarPath)) { Fail "tar.exe não encontrado em $TarPath." }

# --- Staging a partir do HEAD ---------------------------------------------
$GitItems = @('bin/Report', 'bin/Schemas', 'bin/db/notas.db', 'docs/ui/icones/LICENSE-lucide.txt')

$dirty = & $GitPath -C $RepoRoot status --porcelain -- $GitItems
if ($LASTEXITCODE -ne 0) { Fail 'git status falhou.' }
if ($dirty) {
    Write-Warning 'Há alterações não commitadas nestes itens; o setup usa a versão do HEAD:'
    $dirty | ForEach-Object { Write-Warning "  $_" }
}
$Head = (& $GitPath -C $RepoRoot rev-parse --short HEAD).Trim()

if (Test-Path $Staging) { Remove-Item -LiteralPath $Staging -Recurse -Force }
New-Item -ItemType Directory -Force -Path $Staging | Out-Null
$GitTree = Join-Path $OutputDir 'git-head'
if (Test-Path $GitTree) { Remove-Item -LiteralPath $GitTree -Recurse -Force }
New-Item -ItemType Directory -Force -Path $GitTree | Out-Null
$TarFile = Join-Path $OutputDir 'git-head.tar'

& $GitPath -C $RepoRoot archive --format=tar -o $TarFile HEAD -- $GitItems
if ($LASTEXITCODE -ne 0) { Fail 'git archive falhou.' }
& $TarPath -xf $TarFile -C $GitTree
if ($LASTEXITCODE -ne 0) { Fail 'Falha ao extrair o git archive.' }
Remove-Item -LiteralPath $TarFile -Force

Move-Item -LiteralPath (Join-Path $GitTree 'bin\Report')  -Destination (Join-Path $Staging 'Report')
Move-Item -LiteralPath (Join-Path $GitTree 'bin\Schemas') -Destination (Join-Path $Staging 'Schemas')
New-Item -ItemType Directory -Force -Path (Join-Path $Staging 'db') | Out-Null
Move-Item -LiteralPath (Join-Path $GitTree 'bin\db\notas.db') -Destination (Join-Path $Staging 'db\notas.db')
Move-Item -LiteralPath (Join-Path $GitTree 'docs\ui\icones\LICENSE-lucide.txt') -Destination (Join-Path $Staging 'LICENSE-lucide.txt')
Remove-Item -LiteralPath $GitTree -Recurse -Force

Copy-Item -LiteralPath $ExePath  -Destination (Join-Path $Staging 'ProXML.exe')
Copy-Item -LiteralPath $Sk4dPath -Destination (Join-Path $Staging 'sk4d.dll')

# --- Verificações do staging ----------------------------------------------
$files = Get-ChildItem -LiteralPath $Staging -Recurse -File
$suspeitos = $files | Where-Object { $_.Name -match '\d{14,}' }
if ($suspeitos) {
    $suspeitos | ForEach-Object { Write-Host "  $($_.FullName)" }
    Fail 'Nome de arquivo com 14+ dígitos (possível CNPJ/chave) no staging.'
}
$proibidos = $files | Where-Object { $_.Name -match '^(ErroLog\.txt|WinRAR\.exe)$' -or $_.FullName -like "$Staging\NFCe\*" }
if ($proibidos) { Fail "Arquivo proibido no staging: $($proibidos[0].FullName)" }

Write-Host "Staging: $Staging (HEAD $Head)"
foreach ($top in Get-ChildItem -LiteralPath $Staging) {
    if ($top.PSIsContainer) {
        $sub = @(Get-ChildItem -LiteralPath $top.FullName -Recurse -File)
        $mb  = ($sub | Measure-Object Length -Sum).Sum / 1MB
        Write-Host ("  {0,-20} {1,5} arquivos  {2,8:N2} MB" -f "$($top.Name)\", $sub.Count, $mb)
    } else {
        Write-Host ("  {0,-20} {1,14:N0} bytes" -f $top.Name, $top.Length)
    }
}

# --- Compilação -------------------------------------------------------------
if (Test-Path $SetupFile) { Remove-Item -LiteralPath $SetupFile -Force }
Write-Host "ISCC: $IsccPath"
& $IsccPath /Qp "/DAppVersion=$Version" "/DSourceDir=$Staging" $IssFile
if ($LASTEXITCODE -ne 0) { Fail "ISCC terminou com código $LASTEXITCODE." }
if (-not (Test-Path $SetupFile)) { Fail "Setup não gerado: $SetupFile" }

$setup = Get-Item -LiteralPath $SetupFile
$hash  = (Get-FileHash -LiteralPath $SetupFile -Algorithm SHA256).Hash
Write-Host ''
Write-Host "Setup:   $SetupFile"
Write-Host ("Tamanho: {0:N0} bytes ({1:N2} MB)" -f $setup.Length, ($setup.Length / 1MB))
Write-Host "SHA-256: $hash"
Write-Host "Versão:  $($setup.VersionInfo.FileVersion)"
