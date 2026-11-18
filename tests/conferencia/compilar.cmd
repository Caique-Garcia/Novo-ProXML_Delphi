@echo off
rem Compila o verificador da conferencia de IBS/CBS (Plano 7, etapa 7.3) numa pasta FORA do repositorio.
rem Uso: compilar.cmd <pasta_de_saida>
rem O exe vai para <pasta_de_saida> e os .dcu para <pasta_de_saida>\dcu.
if "%~1"=="" (
    echo Uso: compilar.cmd ^<pasta_de_saida^>
    exit /b 1
)
call "C:\Program Files (x86)\Embarcadero\Studio\19.0\bin\rsvars.bat"
if not exist "%~1\dcu" mkdir "%~1\dcu"
pushd "%~dp0"
dcc32 -B -Q -CC -E"%~1" -NU"%~1\dcu" -NSSystem;Xml;Data;Winapi;System.Win;Xml.Win VerificadorConferencia.dpr
set RESULTADO=%ERRORLEVEL%
popd
exit /b %RESULTADO%
