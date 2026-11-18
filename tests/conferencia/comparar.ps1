# Compara o CSV do VerificadorConferencia com o gabarito tests/gabarito/divergencias.csv (Plano 7, etapa 7.3).
# Uso: powershell -ExecutionPolicy Bypass -File comparar.ps1 -Saida <divergencias_app.csv>
# Saida 0 = igual ao gabarito; 1 = diferente (lista as linhas que so existem num dos lados).
param(
    [Parameter(Mandatory = $true)][string]$Saida,
    [string]$Gabarito = ''
)

$ErrorActionPreference = 'Stop'
# O padrao do gabarito e calculado aqui: no PowerShell 5.1 o $PSScriptRoot pode vir vazio no param()
if (-not $Gabarito) {
    $pastaScript = Split-Path -Parent $MyInvocation.MyCommand.Path
    $Gabarito = Join-Path $pastaScript '..\gabarito\divergencias.csv'
}
# Arquivo ausente e erro (codigo 2), nunca "OK": dois textos vazios seriam iguais
foreach ($arquivo in @($Gabarito, $Saida)) {
    if (-not (Test-Path -LiteralPath $arquivo -PathType Leaf)) {
        Write-Output ("ERRO: arquivo nao encontrado: " + $arquivo)
        exit 2
    }
}

$utf8 = New-Object System.Text.UTF8Encoding($false)
# CRLF vira LF dos dois lados (o git pode trocar a quebra de linha do gabarito no checkout)
$textoGabarito = [System.IO.File]::ReadAllText((Resolve-Path $Gabarito), $utf8) -replace "`r`n", "`n"
$textoSaida    = [System.IO.File]::ReadAllText((Resolve-Path $Saida), $utf8) -replace "`r`n", "`n"

$linhasGabarito = @($textoGabarito.TrimEnd("`n") -split "`n")
$linhasSaida    = @($textoSaida.TrimEnd("`n") -split "`n")

if ($textoGabarito -ceq $textoSaida) {
    Write-Output ("OK: igual ao gabarito ({0} divergencias)." -f ($linhasGabarito.Count - 1))
    exit 0
}

Write-Output ("DIFERENTE: gabarito com {0} linhas, verificador com {1} linhas." -f ($linhasGabarito.Count - 1), ($linhasSaida.Count - 1))
$diferencas = Compare-Object -ReferenceObject $linhasGabarito -DifferenceObject $linhasSaida -CaseSensitive
foreach ($d in $diferencas) {
    if ($d.SideIndicator -eq '<=') {
        Write-Output ("  so no gabarito:     " + $d.InputObject)
    }
    else {
        Write-Output ("  so no verificador:  " + $d.InputObject)
    }
}
if (-not $diferencas) {
    Write-Output "  Mesmas linhas em ordem diferente."
}
exit 1
