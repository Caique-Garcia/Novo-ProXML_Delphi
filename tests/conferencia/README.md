# Verificador da conferência de IBS/CBS (Plano 7)

`VerificadorConferencia.dpr` é um programa de console, sem VCL, que lê as pastas de XMLs com a **mesma leitura do app** (`lib/uCalculadoraXML.pas`, que chama `lib/uConferenciaIBSCBS.pas`) e grava as divergências no formato de `tests/gabarito/divergencias.csv`. O `comparar.ps1` compara o resultado com o gabarito.

Ele também grava, ao lado do CSV, o arquivo `<saída>-log.txt` com o bloco da conferência que o Resumo mostraria lendo as pastas juntas (linha de resumo 17.23 e uma linha por divergência ou caso sem conferência), para conferir os textos com o glossário (seção 17) e o mockup `docs/ui/mockups/resumo.html#p7-conferencia`.

## Como usar

Compile e grave a saída **fora do repositório** (o `bin\` e o repositório não recebem nada). Na pasta `tests/conferencia/`:

```
compilar.cmd <pasta_fora_do_repo>\verificador
<pasta_fora_do_repo>\verificador\VerificadorConferencia.exe ..\..\exemple ..\..\exemple\sinteticos ..\..\exemple\sinteticos-ibscbs -o <pasta_fora_do_repo>\divergencias_app.csv
powershell -NoProfile -ExecutionPolicy Bypass -File comparar.ps1 -Saida <pasta_fora_do_repo>\divergencias_app.csv
```

- `compilar.cmd` chama o `rsvars.bat` do Delphi 10.2 e o `dcc32` com `-B`; o exe vai para a pasta indicada e os `.dcu` para `<pasta>\dcu`.
- Passe as pastas com barra invertida (`..\..\exemple\sinteticos`), como acima: a marcação `origem=sintetico` depende dela; com `/` todas as linhas saem como `real` e a comparação falha.
- `comparar.ps1` termina com código 2 e `ERRO` se o gabarito ou a saída não existir (antes dava um falso OK).
- Cada pasta é lida sem recursão (só os `*.xml` do próprio nível), como no app e no `gerar_divergencias.py`.
- O console mostra o mesmo resumo do script: notas conferidas por modelo e divergências por nível nos filtros 55, 65 e Todos. Arquivos que o app não processa aparecem como `AVISO:` (o script também os pula).
- `comparar.ps1` termina com código 0 quando o CSV é igual ao gabarito (ignorando CRLF × LF) e 1 quando não é, listando as linhas que só existem num dos lados.

## Resultado esperado (gabarito de 11/11/2026)

- Notas conferidas: 55=49, 65=13, total=62.
- 55: 40 divergências (N1=6, N2=11, N3=12, N4=11), 15 notas com Erro e 16 só com Alerta; 65: 7 (N1=1, N2=4, N3=1, N4=1), 5 com Erro e 2 só com Alerta; Todos: 47, com 20 notas com Erro e 18 só com Alerta (a 910060, com Erro e Alerta, conta só em Erro).
- Linha de resumo do log: "Conferência de IBS/CBS: 62 notas conferidas, 20 com Erro e 18 com Alerta; 9 do Simples Nacional, sem conferir base e alíquota."

## Tempo

A compilação leva poucos segundos (cerca de 3 mil linhas). A leitura das 3 pastas (69 XMLs) leva menos de 2 segundos. Com a comparação, a etapa toda leva menos de 15 segundos.
