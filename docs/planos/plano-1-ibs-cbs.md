# Plano 1 — Modelos 55 e 65 + IBS/CBS (v1.1.0)

## Objetivo
1. A aplicação passa a processar **NF-e (modelo 55)** e **NFC-e (modelo 65)**. Hoje ela descarta todo XML que não seja 65.
2. Quando o XML tiver o grupo `IBSCBSTot` (Reforma Tributária, NT 2025.002), os valores e somatórios de IBS/CBS aparecem em **cards no topo** e num **novo relatório** só com essas notas.

## Decisões do usuário
| Tema | Decisão |
|------|---------|
| **Modelos** | Aceitar **55 e 65** (outros modelos continuam ignorados e listados no log) |
| Filtro de modelo | Seletor **Todos / NF-e 55 / NFC-e 65**, começando em **Todos**. Cards, grade e **os dois relatórios** respeitam o filtro |
| Grade de notas | Nova coluna **Modelo** (55/65). Os campos de IBS/CBS **não** viram colunas na grade |
| Entrada/saída (55) | **Somar todas**: entradas (`tpNF=0`) e saídas (`tpNF=1`) entram juntas, sem distinção |
| DANFE do 55 | **Seguir o `tpImp` do XML**: retrato (`DANFeRetrato.fr3`) ou paisagem (`DANFePaisagem.fr3`). NFC-e continua com `DANFeNFCeA4.fr3`. O tipo do DANFE é escolhido por nota |
| Textos "NFCe" | Trocar **só os textos visíveis** por "Nota Fiscal" (tela, log, assunto do e-mail). A pasta `NFCe\` e os nomes de arquivos no disco **não mudam** |
| Onde exibir IBS/CBS | Novo relatório IBS/CBS e novos cards de totais |
| Campos IBS/CBS | Base IBS/CBS (`vBCIBSCBS`), IBS UF (`vIBSUF`), IBS Município (`vIBSMun`), IBS total (`vIBS`) e CBS (`vCBS`) |
| Notas sem IBS/CBS | Ficam **fora** do relatório IBS/CBS |
| Acesso ao relatório | Novo item "Relatório IBS/CBS" no menu lateral, abaixo de "Relatório" |
| Leitura do XML | Manter `TXMLDocument` (padrão atual do `uCalculadoraXML.pas`) |
| Conversão numérica | **Corrigir em tudo**: ler os valores com ponto decimal, sem o `/100` dependente do idioma |
| Banco | Gravar os novos campos (incluindo o modelo) na tabela `nf`, com migração automática |
| Thread em `GravarNotasDB` | **Corrigir agora**: gravação segura, sem acessar a `FDMemTable1` fora da thread principal |
| Testes | XMLs **reais** dos modelos **55 e 65** fornecidos pelo usuário |
| Delphi | 10.2 Tokyo (Studio 19.0) |
| Autorização | Nota autorizada = **`cStat` 100 ou 150** (deixa de comparar o texto do `xMotivo`) |
| XML sem `nfeProc` | **Manter como hoje**: não processado e listado no log |
| Mesmo número, chaves diferentes | **Não deduplicar**: todo XML autorizado conta |
| `IBSCBSTot` sem `gIBS`/`gCBS` | **Entra** no relatório IBS/CBS com IBS/CBS = 0,00 e a base preenchida |
| Homologação (`tpAmb=2`) | **Entra** normalmente nos totais |
| Card Valor Total | Continua usando **`vNF`** (`vNFTot` fora do escopo) |
| Nota não autorizada (ex.: denegada 110) | Fica **fora de todos os totais**, inclusive IBS/CBS |
| Sintéticos | Servem só para testar leitura e soma; não precisam ser fiscalmente coerentes. Um caso extra prova a regra do `cStat` |
| Espera do PDF em `GerarDanfe` | **Corrigir na 1.5**: trocar o laço infinito por espera com tempo limite (~15 s) e mensagem de erro clara |
| Grade entre processamentos | **Limpar** a `FDMemTable1` a cada clique em Processar: cards e relatório mostram só a pasta atual |
| Log de nota não autorizada | `Nota Fiscal <nNF> - não autorizada (cStat <código>)`; XML sem protocolo continua como "Arquivo não processado" |
| `IBSCBSTot` sem `vBCIBSCBS` | Base = 0 e a nota é mantida; tag presente com valor inválido → arquivo não processado |
| Gravação no banco | Na **thread principal, com transação** (a mesma conexão FireDAC é usada pela tela; ~0,2 s para 1000 notas) |
| Somatórios dos relatórios | Rodapé usa os **totais calculados em memória** (`FormPrincipal.Totais`, respeitando o filtro); os valores continuam como texto no banco |
| Ordem das notas nos relatórios | **Manter** a ordem de leitura dos arquivos (sem `ORDER BY`) |
| Amostras faltantes | XMLs **sintéticos** gerados pelo `nfe-fiscal` em `exemple\sinteticos\` (fora do git): NF-e 55 com `tpImp=2`, nota de entrada e nota com `vICMS` > 0 |

## Etapas

### 1.1 Mapeamento fiscal e gabarito — `nfe-fiscal`
- Confirmar que os caminhos usados hoje (`ide/nNF`, `ide/dhEmi`, `ide/mod`, `protNFe/infProt/xMotivo`, `total/ICMSTot/vNF|vBC|vICMS`) valem igualmente para os modelos 55 e 65. Mapear também `ide/tpNF` e `ide/tpImp`.
- Confirmar os caminhos de IBS/CBS na NT 2025.002 e no ACBr local (`total/IBSCBSTot`, `gIBS/gIBSUF/vIBSUF`, `gIBS/gIBSMun/vIBSMun`, `gIBS/vIBS`, `gCBS/vCBS`, `vBCIBSCBS`) para os dois modelos.
- Analisar a pasta de XMLs do usuário e informar:
  - quantos XMLs há de cada modelo, com e sem IBS/CBS;
  - quantos são de entrada e quantos de saída;
  - quais `tpImp` aparecem.
- ✅ Concluído em 09/10/2026: mapeamento sem divergência entre NT e ACBr; 7 dúvidas decididas pelo usuário (ver tabela de decisões).
- Gerar o gabarito `tests/gabarito/notas.csv` (por nota: modelo, número, data, vNF, vBC, vICMS e campos de IBS/CBS; mais os totais por filtro Todos/55/65), sem dados sensíveis.
- **Aceite:** tabela de mapeamento aprovada pelo usuário e gabarito gerado.

### 1.2 Leitura e cálculo — `delphi-dev`
- `uCalculadoraXML.pas`:
  - aceitar os modelos `55` e `65`; os outros continuam ignorados e registrados no log;
  - considerar autorizada a nota com `protNFe/infProt/cStat` igual a 100 ou 150;
  - tratar `IBSCBSTot` sem `gIBS`/`gCBS` como IBS/CBS = 0 (`gIBS`, `gCBS` e `gIBSMun` são opcionais);
  - função de conversão independente do idioma (`TFormatSettings` com ponto), substituindo o `/100` em vNF, vBC e vICMS;
  - ler `IBSCBSTot` quando existir e marcar a nota como "tem IBS/CBS".
- `FDMemTable1`: campos novos `modelo`, `tem_ibscbs`, `vbcibscbs`, `vibsuf`, `vibsmun`, `vibs`, `vcbs`. Na grade, só a coluna **Modelo** é visível.
- Os totais deixam de ser acumulados durante a leitura e passam a ser **calculados a partir da `FDMemTable1` filtrada** (ver 1.4), para que o filtro de modelo os recalcule.
- Textos "NFCe" visíveis → "Nota Fiscal" (log, texto da seleção de pasta, assunto do e-mail). Pastas e nomes de arquivos não mudam.
- **Aceite:** build OK; com filtro "Todos", os totais batem com o gabarito; com apenas XMLs 65, o total de ICMS fica igual ao da versão 1.0.0 no Windows pt-BR.

### 1.3 Banco de dados — `delphi-dev`
- `DM.pas`: migração idempotente (`PRAGMA table_info(nf)` + `ALTER TABLE nf ADD COLUMN ...`) para as colunas novas (`MODELO` + 6 de IBS/CBS).
- Reescrever `InserirNotaDB` com **lista explícita de colunas** (hoje é `insert into nf values(...)` posicional).
- `QryNotas` e a nova `QryNotasIBSCBS` (`WHERE TEM_IBSCBS = 1`) passam a receber o filtro de modelo por parâmetro.
- `GravarNotasDB`: deixar de percorrer a `FDMemTable1` dentro da thread anônima (copiar os dados antes ou gravar na thread principal com transação), mantendo a tela de carregamento.
- **Aceite:** o app abre e grava tanto com um `notas.db` antigo quanto com um novo; a gravação de ~1000 notas conclui sem erros e o relatório abre em seguida.

### 1.4 Filtro de modelo e cards — `delphi-dev`
- Seletor **Todos / NF-e 55 / NFC-e 65** perto do botão Processar, começando em Todos. Ao trocar, aplica `Filter` na `FDMemTable1` e recalcula todos os cards.
- Dois cards novos no topo, **Total IBS** e **Total CBS**, no mesmo estilo dos atuais (painel, `TShape`, `TSkSvg`, label de valor).
- **Aceite:** trocar o filtro atualiza grade e cards com os valores do gabarito para cada opção; o layout não quebra na resolução mínima da janela (validação visual pelo usuário).

### 1.5 DANFE por modelo — `delphi-dev`
- `GerarDanfe`: depois de carregar o XML, escolher por nota:
  - modelo 65 → `tiNFCe` + `DANFeNFCeA4.fr3`;
  - modelo 55 com `tpImp=1` → `tiRetrato` + `DANFeRetrato.fr3`;
  - modelo 55 com `tpImp=2` → `tiPaisagem` + `DANFePaisagem.fr3`.
- Se o `tpImp` vier diferente de 1/2 numa nota 55 (ex.: DANFE simplificado), **reportar ao usuário** em vez de escolher um layout.
- Substituir o laço `while not FileExists(...)` (hoje infinito) por uma espera com tempo limite (~15 s) que processa mensagens da tela; se o PDF não aparecer, mostrar mensagem de erro e voltar à aba Notas.
- **Aceite:** gerar o DANFE de uma nota 55 retrato, uma 55 paisagem e uma 65, com PDFs corretos. Um XML cujo nome não é a chave não pode travar o app.

### 1.6 Relatórios — `delphi-dev`
- Relatório de notas atual: nova coluna Modelo, respeitando o filtro.
- Novo form `view/ProXML.FormRelatorioIBSCBS.pas/.dfm` (QuickReport), seguindo o padrão do `FormRelatorios`:
  - colunas: Modelo, Número, Data, Base IBS/CBS, IBS UF, IBS Mun., IBS, CBS;
  - rodapé com os somatórios de cada coluna e a quantidade de notas;
  - respeita o filtro de modelo;
  - se não houver nota com IBS/CBS no filtro atual, mostra a mensagem "Nenhuma nota com IBS/CBS".
- Novo item **"Relatório IBS/CBS"** no menu lateral, abaixo de "Relatório".
- **Aceite:** os dois relatórios mostram os valores do gabarito para os filtros Todos, 55 e 65.

### 1.7 Revisão e testes — `qa-reviewer`
- Revisão do diff (codificação, `.dfm`, conversão, migração, textos).
- Build.
- Comparação com o gabarito nos 3 filtros.
- DANFE nos 3 layouts.
- Teste com banco antigo e banco novo.

### 1.8 Release v1.1.0 — `release-manager`
- README:
  - suporte a NF-e 55 e NFC-e 65, filtro, IBS/CBS e DANFE por modelo;
  - requisito de Delphi corrigido para **10.2 Tokyo** (hoje diz 10.4);
  - descrição do repositório atualizada.
- Empacotar o `ProXML.rar`, publicar a Release v1.1.0 e validar o download.

## Pendências (decidir com o usuário)
- ~~P1. Pasta dos XMLs de teste~~ → `exemple` (16 XMLs: 11 modelo 55, 5 modelo 65), ignorada pelo git.

## Riscos
- O build pela linha de comando com o Delphi 10.2 pode falhar por causa de pacotes do `.dproj` (gerado numa versão mais nova, `ProjectVersion 19.2`). Nesse caso o agente para e reporta.
- O QuickReport precisa estar instalado no Delphi 10.2.
- Somar entradas e saídas da NF-e 55 juntas (decisão do usuário) faz o total misturar compras e vendas. O README e o site devem deixar isso claro.
