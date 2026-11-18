# ProXML · Glossário de textos da interface (v1.1.0)

> **Etapa:** 4.1 do Plano 4 · **Status:** aprovado pelo usuário em 19/10/2026, com os acréscimos registrados em cada item. **Revisão do Plano 2 (v1.2.0, 06/11/2026):** textos do ZIP nativo, sem WinRAR (11.3, 11.20, 11.20a, 14.4a e 14.4b). **Plano 7 (v1.3.0, 11/11/2026):** textos da conferência de IBS/CBS nas seções 16 a 19, **aguardando aprovação do usuário** (etapa 7.2)
> **Levantamento:** `view/*.pas`, `view/*.dfm`, `lib/uCalculadoraXML.pas`, `datamodule/DM.pas` no commit `6be6cd8` (`.pas` lidos como Windows-1252; `#nnn` dos `.dfm` decodificados).
> Depois de aprovado, o `delphi-dev` aplica estes textos na 4.7 e o `qa-reviewer` confere com `grep` (4.10): **nenhum texto visível fora desta lista**.

## Regras de tom

1. Frases curtas, voz ativa, sem "!!" e sem exclamação.
2. **Pasta** (nunca "repositório" ou "diretório"), **e-mail** (com hífen), **Nota Fiscal** (maiúsculas), **NF-e (55)** e **NFC-e (65)**, **ProXML** (junto).
3. Botões com verbo no infinitivo ("Gerar relatório", "Copiar chave"); em andamento, gerúndio com reticências ("Enviando…").
4. Erro = o que aconteceu + o que fazer. Motivo técnico (mensagem do ACBr, do servidor ou do banco) vai numa linha "Motivo:" separada.
5. Sucesso discreto: confirmação na própria tela, sem caixa de diálogo, sempre que der.
6. Números e datas no padrão brasileiro: `R$ 1.234,56`, `19/10/2026 14:32`, `4,2 s`. Contagem com singular/plural ("1 nota", "128 notas").
7. Reticências com o caractere "…" (U+2026) em botões que abrem diálogo ("Selecionar…") e em textos de andamento.
8. `{x}` = valor preenchido em tempo de execução.

Legenda de tipo: **R** rótulo · **B** botão · **H** hint/dica · **M** mensagem (caixa de diálogo) · **F** faixa de status ou texto na tela · **L** linha do log do Resumo · **P** relatório impresso · **I** interno (não aparece direto para o usuário).

---

## 1. Janela e cabeçalho

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 1.1 | `FormPrincipal.Caption` | R | Pro XML | ProXML | Título da janela e da barra de tarefas |
| 1.2 | `Application.Title` (`.dpr`) | R | *(não definido; o Windows usa o nome do executável)* | ProXML | `Application.Title := 'ProXML';` no `.dpr`. Título das caixas de mensagem |
| 1.3 | cabeçalho (novo) | B | — | Sobre | Link no canto direito do cabeçalho |
| 1.4 | cabeçalho (novo) | H | — | Sobre o ProXML | |

## 2. Barra de pasta

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 2.1 | `EditCaminho.Text` (`.dfm`) | R | Selecione uma pasta contendo XMLs de Nota Fiscal | *(vazio)* | O texto de instrução sai do `Text` (P3) |
| 2.2 | `EditCaminho.TextHint` | H | Selecione uma pasta contendo XMLs de Nota Fiscal | Selecione ou arraste uma pasta com XMLs de Nota Fiscal | |
| 2.3 | `EditCaminho` (novo hint) | H | — | Clique para escolher a pasta (Ctrl+O) | Hint do campo com caminho: caminho completo + este texto (decisão da 4.3) |
| 2.4 | `SkSvg1` (ícone de pasta) | B | *(só ícone, sem texto)* | Selecionar… | Vira `TProBotao` secundário |
| 2.5 | botão Selecionar (novo) | H | — | Escolher a pasta dos XMLs (Ctrl+O) | |
| 2.6 | `FileOpenDialog1.Title` | R | Selecione uma pasta | Selecione a pasta com os XMLs | |
| 2.7 | `LabelFiltroModelo` | R | Modelo | Modelo | Sem mudança |
| 2.8 | `ComboFiltroModelo.Items` | R | Todos · NF-e 55 · NFC-e 65 | Todos · NF-e 55 · NFC-e 65 | Sem mudança (combo ou segmentos, decisão D6) |
| 2.9 | seletor de modelo (novo) | H | — | Todos: NF-e (55) e NFC-e (65) · Só NF-e (modelo 55) · Só NFC-e (modelo 65) | Um hint por opção |
| 2.10 | `SpeedButton1` | B | Processar | Processar | `TProBotao` primário |
| 2.11 | Processar (novo) | H | — | Ler os XMLs da pasta (F5) | |
| 2.12 | Processar desabilitado (novo) | H | — | Selecione uma pasta primeiro. | Sem pasta, Processar fica desabilitado |
| 2.13 | `SpeedButton1Click` | M | Por favor selecione um repositório !! | Selecione uma pasta com XMLs. | Só por segurança: com o botão desabilitado ela não deve aparecer |
| 2.14 | pasta salva que sumiu (novo) | M | — | A pasta não foi encontrada:<br>{pasta}<br><br>Selecione outra pasta. | Última pasta restaurada (4.2) que não existe mais. Na faixa, "A pasta não foi encontrada:" em Semibold e o mesmo alinhamento das outras faixas (28/10/2026, 4.9) |
| 2.15 | `ProcessarXMLs` | F | Não encontrado arquivos XMLs no diretótio selecionado! | Nenhum XML encontrado na pasta selecionada. | Faixa de aviso no Resumo |

## 3. Menu lateral

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 3.1 | `Panel8.Caption` | R | Opções | *(removido)* | N3 |
| 3.2 | `CategoryButtons1` item 0 | R | Resumo | Resumo | |
| 3.3 | item 1 | R | `Notas ` (com espaço) | Notas | N3 |
| 3.4 | item 2 | R | Relatório | Relatórios | Um item só, abre a tela nova |
| 3.5 | item `RelatorioIBSCBS` | R | Relatório IBS/CBS | *(removido)* | Vira botão na tela Relatórios (N6) |
| 3.6 | item 3 | R | Enviar | Enviar | |
| 3.7 | item 4 | R | Configurações | Configurações | |

## 4. Cards de totais

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 4.1 | `Label3` | R | Valor Total | Valor Total | |
| 4.2 | `Label5` | R | Base ICMS | Base ICMS | |
| 4.3 | `Label6` | R | Valor ICMS | ICMS | |
| 4.4 | `LabelTituloIBS` | R | Total IBS | IBS | |
| 4.5 | `LabelTituloCBS` | R | Total CBS | CBS | |
| 4.6 | `FormatarValor` (cards, totais) | R | R$ 11201,15 | R$ 11.201,15 | `FormatFloat('"R$ "#,##0.00', v, FmtPtBR)` com `TFormatSettings` pt-BR explícito (P7) |

## 5. Resumo (processamento e log)

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 5.1 | estado vazio (novo) | F | — | Nenhuma pasta processada | Título |
| 5.2 | estado vazio (novo) | F | — | Selecione uma pasta com XMLs de NF-e (55) ou NFC-e (65), ou arraste a pasta para esta janela, e clique em Processar. | |
| 5.3 | estado vazio (novo) | B | — | Selecionar pasta… | |
| 5.4 | estado vazio (novo) | F | — | Atalhos: Ctrl+O seleciona a pasta · F5 processa | Legenda |
| 5.5 | processando (novo) | F | — | Lendo os XMLs… | |
| 5.6 | `Gauge1` (sem texto) | F | — | {x} de {n} arquivos | P5. Singular: "{x} de 1 arquivo" (03/11/2026, 4.10) |
| 5.7 | processando (novo) | B | — | Cancelar | |
| 5.8 | Cancelar (novo) | H | — | Parar a leitura (Esc) | |
| 5.9 | processando (novo) | F | — | Esc também cancela. As notas só aparecem quando a leitura termina. | Legenda |
| 5.10 | cancelado (novo) | F | — | **Processamento cancelado.** Nenhuma nota foi alterada. | Faixa de aviso (PD-3) |
| 5.11 | cancelado (novo) | F | — | {x} de {n} arquivos tinham sido lidos. Clique em Processar para começar de novo. | Singular: "{x} de 1 arquivo tinha sido lido." (03/11/2026, 4.10) |
| 5.12 | contadores (novo) | R | — | Autorizadas · Ignoradas · Com erro | Ignoradas = não autorizadas + outro modelo; Com erro = não foi possível ler |
| 5.13 | contadores (novo) | R | — | {t} s · {n} arquivos lidos | Singular: "1 arquivo lido" (registrado em 03/11/2026, 4.10). Menos de 0,1 s: "< 0,1 s · {n} arquivos lidos" (aprovado em 28/10/2026, 4.9). Ex.: "4,2 s · 132 arquivos lidos" |
| 5.14 | log (novo) | R | — | Detalhes da leitura | Título do quadro do log |
| 5.15 | log (novo) | R | — | Processado em {dd/mm/aaaa hh:mm} | |
| 5.16 | `uCalculadoraXML` (FalhaModelo) | L | XML {arquivo} - Falha ao recuperar modelo | {arquivo}: não foi possível identificar o modelo. | Conta como Com erro |
| 5.17 | `uCalculadoraXML` (ModeloValido) | L | XML {arquivo} - modelo diferente de 55/65 | {arquivo}: modelo {mod} ignorado (o ProXML lê só os modelos 55 e 65). | Conta como Ignorada |
| 5.18 | `uCalculadoraXML` (cStat vazio) | L | Nota Fiscal {n} - não autorizada (sem protocolo) | Nota Fiscal {n}: não autorizada (sem protocolo de autorização). | Ignorada |
| 5.19 | `uCalculadoraXML` (cStat) | L | Nota Fiscal {n} - não autorizada (cStat {c}) | Nota Fiscal {n}: não autorizada (cStat {c}). | Ignorada |
| 5.20 | `ProcessarXMLs` (except) | L | Arquivo não processado: {arquivo} | {arquivo}: não foi possível ler o arquivo ({motivo}). | Com erro; `{motivo}` = itens 5.24–5.27 |
| 5.21 | `ProcessarXMLs` (fim) | L | Foram processasdos {n} Arquivos XMLs | {n} notas autorizadas carregadas. | X1. Também vai para o contador "Autorizadas". Singular: "1 nota autorizada carregada." |
| 5.22 | `ProcessarXMLs` (fim) | L | {n} Arquivos com problemas para serem processados. | *(removida)* | Vira o contador "Com erro" |
| 5.23 | nenhuma ocorrência (novo) | L | — | Todos os {n} arquivos foram lidos sem ocorrências. | Quando não há ignoradas nem erros |
| 5.24 | `NoFilhoObrigatorio` | I/L | Tag {tag} não encontrada no XML | falta a tag {tag} | Vira o `{motivo}` de 5.20 |
| 5.25 | `LerNotaXML` (nfeProc) | I/L | Tag nfeProc não encontrada no XML | o arquivo não é uma Nota Fiscal com protocolo de autorização (falta a tag nfeProc) | Texto aprovado pelo usuário em 19/10/2026 (proposta do `nfe-fiscal`: sem `nfeProc` também cai aqui um XML que não é NF-e/NFC-e, ex.: evento de cancelamento ou CT-e) |
| 5.26 | `LerNotaXML` (nNF) | I/L | Tag nNF vazia no XML | tag nNF vazia | |
| 5.27 | exceção não prevista (novo) | I/L | — | {mensagem da exceção} | Texto original do Delphi/MSXML |
| 5.28 | fechar durante a leitura (novo) | M | — | A leitura dos XMLs ainda está em andamento.<br>Deseja cancelar e fechar o ProXML? | Botões Sim / Não |
| 5.29 | aviso no Resumo: só homologação (novo) | F | — | **Os totais incluem {h} notas de homologação** (ambiente de testes, sem valor fiscal). Confira se a pasta é a certa. | **Aprovado pelo usuário em 20/10/2026.** Faixa de aviso (`CorAvisoSuave` + `CorAviso`) entre os contadores e o log. Singular: "**Os totais incluem 1 nota de homologação** (…)" |
| 5.30 | aviso no Resumo: só entrada (novo) | F | — | **Os totais incluem {e} NF-e de entrada**, somadas às de saída. Confira se a pasta é a certa. | **Aprovado pelo usuário em 20/10/2026.** Entrada = NF-e 55 com tpNF 0. Singular: "**Os totais incluem 1 NF-e de entrada**, somada às de saída." |
| 5.31 | aviso no Resumo: os dois (novo) | F | — | **Os totais incluem {h} notas de homologação** (ambiente de testes, sem valor fiscal) **e {e} NF-e de entrada.** Confira se a pasta é a certa. | **Aprovado pelo usuário em 20/10/2026.** Exemplo no mockup `resumo.html`, estado "Concluído". Singular: "**Os totais incluem 1 nota de homologação** (ambiente de testes, sem valor fiscal) **e 1 NF-e de entrada.** Confira se a pasta é a certa." (registrado em 03/11/2026, 4.10) |
| 5.32 | log: nota de homologação (novo) | L | — | Nota Fiscal {n}: homologação (tpAmb 2), somada aos totais. | **Aprovado pelo usuário em 20/10/2026.** Uma linha por nota, ícone de aviso; não muda os contadores |
| 5.33 | log: NF-e de entrada (novo) | L | — | Nota Fiscal {n}: NF-e de entrada (tpNF 0), somada aos totais. | **Aprovado pelo usuário em 20/10/2026.** Idem |
| 5.34 | `LerNotaXML` (Id) (novo) | I/L | — | a chave de acesso da nota (atributo Id de infNFe) não tem 44 dígitos | Vira o `{motivo}` de 5.20 (decisão D4). Aprovado pelo usuário em 21/10/2026 |
| 5.35 | `LerNotaXML` (chNFe) (novo) | I/L | — | a chave do protocolo de autorização (chNFe) é diferente da chave da nota | Vira o `{motivo}` de 5.20 (decisão D4). Aprovado pelo usuário em 21/10/2026 |
| 5.36 | fechar durante o envio do e-mail (novo) | M | — | O e-mail ainda está sendo enviado. Aguarde terminar para fechar o ProXML. | Aviso com OK; o app não fecha. Aprovado pelo usuário em 21/10/2026 (4.6) |
| 5.37 | cancelado no primeiro uso (novo) | F | — | As notas e os totais continuam como estavam antes de Processar. | Abaixo da faixa 5.10/5.11, sem botão. Texto do mockup, aprovado pelo usuário em 21/10/2026 (4.6) |
| 5.38 | erro fora da leitura de um arquivo (novo) | M | {mensagem da exceção} | Não foi possível ler a pasta selecionada.<br>{pasta}<br><br>Motivo: {motivo}<br><br>As notas carregadas antes continuam na tela. | Erro (caixa) + LOG. Pasta apagada ou sem acesso durante o Processar. Aprovado pelo usuário em 26/10/2026 (4.7) |

## 6. Notas (grade, ações, busca, CSV)

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 6.1 | título da tela (novo) | R | — | Notas | |
| 6.2 | contador (novo) | R | — | {n} notas · {x} de {n} notas (com busca) · 1 nota | |
| 6.3 | `DBGrid1` coluna `numero` | R | Número | Nº | |
| 6.4 | coluna `modelo` | R | Modelo | Modelo | Valores "55" / "65" |
| 6.5 | coluna `data` | R | Data | Data | |
| 6.6 | coluna `chave` | R | Chave | Chave | 44 dígitos, sem "-nfe" (decisão D4) |
| 6.7 | coluna `vtotal` | R | Valor R$ | Valor | Células "R$ 1.234,56" |
| 6.8 | colunas novas | R | *(ocultas, sem título: `vlicms`, `bcicms`)* | Base ICMS · ICMS · IBS · CBS | Visíveis com largura suficiente (D3) |
| 6.9 | valores na grade | R | 10.804,15 (sem R$) | R$ 10.804,15 | `DisplayFormat '"R$ "#,##0.00'` |
| 6.10 | ordenação (novo) | R | — | ▲ / ▼ no fim do título | |
| 6.11 | `GerarPDF1.Caption` (popup) | R | Copiar Chave | Copiar chave | Renomear componente para `mnuCopiarChave`; atalho Ctrl+C |
| 6.12 | `GerarDANFe1.Caption` (popup) | R | Gerar DANFe | Gerar DANFE | Atalho Ctrl+D (grafia: decisão D12) |
| 6.13 | botão Copiar chave (novo) | B/H | — | Copiar chave · *hint:* Copiar a chave de acesso da nota selecionada (Ctrl+C) | |
| 6.14 | botão Gerar DANFE (novo) | B/H | — | Gerar DANFE · *hint:* Gerar o PDF do DANFE da nota selecionada (Ctrl+D ou duplo clique) | |
| 6.15 | botões desabilitados (novo) | H | — | Selecione uma nota na lista. | |
| 6.16 | botão Exportar CSV (novo) | B/H | — | Exportar CSV · *hint:* Salvar as notas da lista num arquivo CSV (abre no Excel) | |
| 6.17 | busca (novo) | H | — | Buscar por número ou chave | `TextHint` |
| 6.18 | busca (novo) | H | — | Ctrl+F para buscar. Esc limpa. | Hint do campo |
| 6.19 | após copiar (novo) | F | — | Chave copiada | Aviso flutuante, 2 s |
| 6.20 | grade vazia (novo) | F | — | Nenhuma nota carregada | T6 |
| 6.21 | grade vazia (novo) | F | — | Selecione uma pasta com XMLs e clique em Processar. | |
| 6.22 | grade vazia (novo) | B | — | Selecionar pasta… | |
| 6.23 | busca sem resultado (novo) | F | — | Nenhuma nota encontrada para "{busca}" | Aspas curvas “ ” |
| 6.24 | busca sem resultado (novo) | F | — | Confira o número ou a chave. A busca considera só o modelo selecionado ({modelo}). | `{modelo}` = Todos / NF-e 55 / NFC-e 65 |
| 6.25 | busca sem resultado (novo) | B | — | Limpar busca | |
| 6.26 | CSV: diálogo (novo) | R | — | Exportar notas para CSV | Título do `TSaveDialog` |
| 6.27 | CSV: filtro (novo) | R | — | Arquivo CSV (separado por ;) (*.csv) | |
| 6.28 | CSV: nome sugerido (novo) | R | — | ProXML-notas-{aaaa-mm-dd}.csv | |
| 6.29 | CSV: cabeçalho (novo) | R | — | Nº;Modelo;Data;Chave;Valor;Base ICMS;ICMS;Base IBS/CBS;IBS UF;IBS Mun.;IBS;CBS | PD-2; valores sem "R$", vírgula decimal |
| 6.30 | CSV: sucesso (novo) | M | — | Arquivo CSV salvo:<br>{caminho} | Informação |
| 6.31 | CSV: erro (novo) | M | — | Não foi possível salvar o arquivo CSV.<br><br>Motivo: {motivo} | Erro |
| 6.32 | Copiar chave: área de transferência ocupada (novo) | M | — | Não foi possível copiar a chave: outro programa está usando a área de transferência. Tente de novo em alguns segundos. | Aviso (caixa com OK), depois de tentar de novo por cerca de 1 s. Aprovado pelo usuário em 21/10/2026 |

## 7. DANFE

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 7.1 | `GerarDanfe` (LoadFromFile) | M | Não foi possível carregar o XML da nota:<br>{caminho}<br><br>{erro} | Não foi possível abrir o XML da nota.<br><br>Arquivo: {caminho}<br>Motivo: {motivo} | Erro |
| 7.2 | `GerarDanfe` (exceção) | I | O arquivo não contém uma Nota Fiscal válida. | O arquivo não contém uma Nota Fiscal válida. | Sem mudança; aparece como `{motivo}` de 7.1 |
| 7.3 | `ConfigurarLayoutDanfe` (tpImp) | M | Layout de DANFE não suportado (tpImp {x}).<br>O ProXML gera o DANFE da NF-e (modelo 55) apenas nos layouts retrato (tpImp 1) e paisagem (tpImp 2). | Esta NF-e usa um layout de DANFE que o ProXML não gera (tpImp {x}).<br><br>O ProXML gera o DANFE da NF-e (55) só nos layouts retrato (tpImp 1) e paisagem (tpImp 2). | Aviso |
| 7.4 | `ConfigurarLayoutDanfe` (modelo) | M | Modelo de documento não suportado para gerar o DANFE (modelo {x}). | O ProXML não gera DANFE para o modelo {x}. Só NF-e (55) e NFC-e (65). | Aviso |
| 7.5 | `GerarDanfe` (ImprimirPDF) | M | Erro ao gerar o DANFE:<br><br>{erro} | Não foi possível gerar o DANFE.<br><br>Motivo: {motivo} | Erro |
| 7.6 | `GerarDanfe` (tempo limite) | M | O PDF do DANFE não foi gerado em 15 segundos.<br><br>Pasta esperada: {pasta} | O PDF do DANFE não ficou pronto em 15 segundos.<br><br>Confira a pasta: {pasta} | Erro. "15" vem de `TEMPO_LIMITE_PDF_MS` |
| 7.7 | `DMConfig.CreateLog` | I | PDF do DANFE não gerado: {caminho} | PDF do DANFE não ficou pronto em 15 s: {caminho} | Só no LOG |
| 7.8 | Carregando (novo) | F | *(aba vazia)* | Gerando o DANFE da nota {n}… | N4 |
| 7.9 | Carregando (novo) | F | — | O PDF abre sozinho quando ficar pronto (até 15 segundos). | |

## 8. Tela Relatórios e geração

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 8.1 | título (novo) | R | — | Relatórios | |
| 8.2 | indicador do filtro (novo) | R | — | Modelo: {Todos / NF-e 55 / NFC-e 65} · {n} notas | Sem notas: "Nenhuma nota carregada" |
| 8.3 | opção 1 (novo) | R | — | Relatório de Notas | |
| 8.4 | opção 1 (novo) | F | — | Nº, modelo, data, chave, valor da nota, base de cálculo do ICMS e ICMS de cada nota, com os totais no fim. | |
| 8.5 | opção 2 (novo) | R | — | Relatório IBS/CBS | |
| 8.6 | opção 2 (novo) | F | — | Base IBS/CBS, IBS UF, IBS municipal, IBS e CBS das notas que têm o grupo IBS/CBS. {x} de {n} notas têm IBS/CBS. | Singular: "{x} de 1 nota tem IBS/CBS." (registrado em 28/10/2026, 4.9). {x} conta só as notas com o grupo de totais `IBSCBSTot`; por isso pode ser menor que as "notas conferidas" da 18.2a, que incluem notas com IBS/CBS só nos itens (decisão do usuário na B3, 11/11/2026) |
| 8.7 | botões (novo) | B/H | — | Gerar relatório · *hint:* Gravar as notas e abrir a visualização do relatório | |
| 8.8 | sem notas (novo) | F | — | Processe uma pasta para gerar relatórios. | Dica visível ao lado dos botões desabilitados |
| 8.8a | sem notas no modelo (novo) | F | — | Nenhuma nota do modelo selecionado. Escolha outro modelo na barra de cima. | Há notas carregadas, mas nenhuma no filtro de modelo. Aprovado em 20/10/2026 (4.4). Também no painel da tela Notas (sem busca), aprovado em 21/10/2026 (4.5), e no quadro do anexo da tela Enviar (decisão da 4.7) |
| 8.9 | `GerarRelatorio` | M | Sem dados para gerar relatório !! | *(substituída pela 8.8)* | Botões desabilitados; se ainda for preciso: "Nenhuma nota para o relatório. Processe uma pasta primeiro." |
| 8.10 | `AbrirRelatorioIBSCBS` | M | Nenhuma nota com IBS/CBS | Nenhuma nota do modelo selecionado tem IBS/CBS. | Vira dica visível com o botão IBS/CBS desabilitado; a caixa só se o botão for acionado mesmo assim |
| 8.11 | rodapé da tela (novo) | F | — | Os relatórios usam as notas do modelo selecionado na barra de cima. A busca da tela Notas não é aplicada. | Depende da decisão D5 |
| 8.12 | `GravarNotasDB` | M | Erro ao gravar as notas no banco de dados. O relatório não foi gerado.<br>{erro} | Não foi possível gravar as notas no banco de dados. O relatório não foi gerado.<br><br>Motivo: {motivo} | Erro + LOG (decisão de 03/11/2026, 4.10) |
| 8.13 | `GravarNotasDB` (FinalizaRelatorio) | M | Erro ao gerar o relatório:<br><br>{erro} | Não foi possível gerar o relatório.<br><br>Motivo: {motivo} | Erro |
| 8.14 | `TFormRelatorios` (exceção) | I | Sem registros no banco de dados! | Nenhuma nota para o relatório. | Aparece como `{motivo}` de 8.13 |
| 8.15 | Carregando (novo) | F | *(aba vazia)* | Gerando o Relatório de Notas… · Gerando o Relatório IBS/CBS… | |
| 8.16 | Carregando (novo) | F | — | Gravando {n} notas e montando a visualização. | `{n}` = total de notas gravadas (todas as carregadas, sem o filtro de modelo; 03/11/2026, 4.10). Singular: "Gravando 1 nota e montando a visualização." |

## 9. Relatório de Notas (QuickReport, `FormRelatorios`)

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 9.1 | `QRLabel601` | P | Pro XML | Relatório de Notas | Título (16 pt) |
| 9.2 | marca (novo) | P | — | ProXML | À direita do cabeçalho (decisão D7) |
| 9.3 | `QRLabel602` (Todos) | P | XMLs de Nota Fiscal processados pelo programa | Período: {dd/mm/aaaa} a {dd/mm/aaaa} · Modelo: Todos (NF-e 55 e NFC-e 65) · {n} notas | R5 |
| 9.4 | `QRLabel602` (filtro) | P | XMLs de Nota Fiscal ({filtro}) processados pelo programa | Período: {…} · Modelo: NF-e 55 · {n} notas | Idem para NFC-e 65 |
| 9.5 | `QRLabelQt` | P | {n} *(número solto)* | *(entra na linha 9.3)* | R6 |
| 9.6 | linha da pasta (novo) | P | — | Pasta: {caminho} | |
| 9.7 | `QRLabel606` | P | Número | Nº | |
| 9.8 | `QRLabelModelo` | P | Modelo | Mod. | Falta largura para "Modelo" |
| 9.9 | coluna nova | P | — | Data | R3 |
| 9.10 | `QRLabel607` | P | Chave | Chave | |
| 9.11 | `QRLabel611` | P | Valor | Valor (R$) | Decisão D11 |
| 9.12 | `QRLabel608` | P | Base de Cálculo␠ | Base ICMS (R$) | Tira o espaço do fim |
| 9.13 | `QRLabel612` | P | ICMS | ICMS (R$) | |
| 9.14 | `QRLabel610` / `QRLabelValorTotal` | P | TOTAL · R$ 11201,15 | Total · {n} notas · 1.234.567,89 (na coluna Valor) | Linha de total (D8) |
| 9.15 | `QRLabel621` / `QRLabelTotalBC` | P | BASE DE CÁLCULO · R$ … | *(valor na coluna Base ICMS)* | |
| 9.16 | `QRLabel613` / `QRLabelTotalICMS` | P | ICMS · R$ … | *(valor na coluna ICMS)* | |
| 9.17 | legenda do total (novo) | P | — | NF-e 55: {a} notas · NFC-e 65: {b} notas · notas não autorizadas não entram no relatório | Só no filtro Todos mostra os dois modelos. Singular: "NF-e 55: 1 nota" (aprovado em 26/10/2026, 4.8) |
| 9.18 | continuação (novo) | P | — | Relatório de Notas · Modelo: {m} · continuação | Topo das páginas 2+ |
| 9.19 | `QRSysData74` + `QRLabel609` + `QRSysData75` | P | 19/10/2026 13:24:10 · Desenvolvido por Caique Garcia \| Email caique.garciatst@gmail.com · 1 | Gerado pelo ProXML v{versão} · {dd/mm/aaaa hh:mm} · Página {x} de {y} | R8; sem e-mail |
| 9.20 | `Label186` (no formulário) | R | 41 | *(remover)* | Rótulo de teste esquecido |

## 10. Relatório IBS/CBS (QuickReport, `FormRelatorioIBSCBS`)

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 10.1 | `QRLabelTitulo` | P | Pro XML | Relatório IBS/CBS | |
| 10.2 | `QRLabelSubtitulo` (Todos) | P | XMLs de Nota Fiscal com IBS/CBS processados pelo programa | Período: {…} · Modelo: Todos (NF-e 55 e NFC-e 65) · {n} notas com IBS/CBS | |
| 10.3 | `QRLabelSubtitulo` (filtro) | P | XMLs de Nota Fiscal ({filtro}) com IBS/CBS processados pelo programa | Período: {…} · Modelo: {filtro} · {n} notas com IBS/CBS | |
| 10.4 | linha da pasta (novo) | P | — | Pasta: {caminho} | |
| 10.5 | `QRLabelModelo` | P | Modelo | Modelo | Ordem das colunas: decisão D9 |
| 10.6 | `QRLabelNumero` | P | Número | Nº | |
| 10.7 | `QRLabelData` | P | Data | Data | |
| 10.8 | `QRLabelBaseIBSCBS` | P | Base IBS/CBS | Base IBS/CBS (R$) | |
| 10.9 | `QRLabelIBSUF` | P | IBS UF | IBS UF (R$) | |
| 10.10 | `QRLabelIBSMun` | P | IBS Mun. | IBS Mun. (R$) | |
| 10.11 | `QRLabelIBS` | P | IBS | IBS (R$) | |
| 10.12 | `QRLabelCBS` | P | CBS | CBS (R$) | |
| 10.13 | `QRLabelQt` | P | 0 *(número solto)* | *(entra na linha 10.2)* | |
| 10.14 | totais (`QRLabelTitulo…` + `QRLabelTotal…`) | P | BASE IBS/CBS · IBS UF · IBS MUNICÍPIO · IBS · CBS · QUANTIDADE DE NOTAS | Total · {n} notas (valores embaixo de cada coluna) | D8 |
| 10.15 | legenda do total (novo) | P | — | {n} de {m} notas do filtro têm o grupo IBS/CBS | Singular: "1 de {m} notas do filtro tem o grupo IBS/CBS"; no 10.2/10.3, "1 nota com IBS/CBS" (aprovado em 26/10/2026, 4.8) |
| 10.16 | continuação (novo) | P | — | Relatório IBS/CBS · Modelo: {m} · continuação | |
| 10.17 | `QRSysDataData` + `QRLabelDesenvolvido` + `QRSysDataPagina` | P | {data hora} · Desenvolvido por Caique Garcia \| Email caique.garciatst@gmail.com · {página} | Gerado pelo ProXML v{versão} · {dd/mm/aaaa hh:mm} · Página {x} de {y} | |

## 11. Enviar

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 11.1 | `Label11` | R | `Enviar ` (com espaço) | Enviar por e-mail | Título da tela |
| 11.2 | `Label12` | R | Enviar arquivos por email | *(removido)* | O quadro do anexo explica o envio |
| 11.3 | anexo (novo) | F | — | Anexo: {n} XMLs (.zip) | E3. Singular: "Anexo: 1 XML (.zip)". Era "(.rar)" até a v1.1.0; aprovado pelo usuário em 06/11/2026 (Plano 2) |
| 11.4 | anexo (novo) | F | — | Modelo: {m} · os XMLs somam {tamanho} · compactado só ao clicar em Enviar | Tamanho em KB/MB com vírgula ("3,4 MB") |
| 11.5 | anexo sem notas (novo) | F | — | Nenhuma nota para enviar | |
| 11.6 | anexo sem notas (novo) | F | — | Processe uma pasta para gerar o anexo. | |
| 11.7 | `Label15` | R | Email | Para | |
| 11.8 | `EditEmailEnviar` (novo) | H | — | nome@empresa.com.br | `TextHint` |
| 11.9 | `Label17` | R | Mensagem | Mensagem | Preenchida com a mensagem padrão das Configurações |
| 11.10 | remetente (novo) | F | — | Enviado de {e-mail} · alterar em Configurações | "alterar em Configurações" é link para a tela |
| 11.11 | `btnEnviarEmail` | B | Enviar | Enviar | `TProBotao` primário |
| 11.12 | Enviar (novo) | H | — | Compactar os XMLs e enviar por e-mail | |
| 11.13 | enviando (novo) | B | — | Enviando… | |
| 11.14 | enviando (novo) | F | — | Compactando e enviando {n} XMLs. Isso pode levar alguns segundos. | Singular: "Compactando e enviando 1 XML. Isso pode levar alguns segundos." (registrado em 03/11/2026, 4.10) |
| 11.15 | `btnEnviarEmailClick` / `EnviaArquivo` | M | Sem arquivos para enviar! | Nenhuma nota para enviar. Processe uma pasta primeiro. | Duas ocorrências. Com o botão desabilitado, vira o texto 11.5/11.6 |
| 11.16 | `EnviaArquivo` | M→F | Email enviado com sucesso!! | **E-mail enviado** para {destino} às {hh:mm}. | X2. Faixa de sucesso, sem caixa |
| 11.17 | erro no envio (novo; hoje a exceção sobe sem tratamento) | F | — | **Não foi possível enviar o e-mail.**<br>O servidor respondeu: {motivo}. Confira os dados em Configurações e use Testar conexão. | Faixa de erro + LOG. `{motivo}` = resposta do servidor a partir do código de 3 dígitos (sem o prefixo do ACBr, ex.: "SMTP Error: …"); sem código, a mensagem original; sem repetir o ponto final. O LOG guarda a mensagem completa (28/10/2026, 4.9) |
| 11.18 | validação (novo) | F | — | Informe um e-mail válido. Exemplo: nome@empresa.com.br | E5. Um só destinatário (decisão de 26/10/2026) |
| 11.19 | SMTP não configurado (novo) | F | — | Configure o e-mail de envio em Configurações antes de enviar. | Faixa informativa; Enviar desabilitado |
| 11.20 | WinRAR ausente | F | ~~**Não foi possível compactar os XMLs.** WinRAR não encontrado em {pasta do ProXML}.~~ | *(removida)* | Sem WinRAR, o erro não existe (ZIP nativo). Valeu até a v1.1.0; remoção aprovada pelo usuário em 06/11/2026 (Plano 2) |
| 11.20a | .zip não criado | F | **Não foi possível compactar os XMLs.** O arquivo .rar não foi gerado. Tente de novo; se continuar, confira o espaço em disco e a pasta do ProXML. | **Não foi possível compactar os XMLs.** O arquivo .zip não foi criado. Feche programas que estejam usando a pasta NFCe do ProXML, confira o espaço em disco e tente de novo. | Faixa de erro + LOG (14.4b); o e-mail não é enviado. Genérica para toda falha ao criar o `.zip` (arquivo em uso, disco cheio, sem permissão, `.zip` ausente ou vazio) **e** para a falha ao criar a pasta `NFCe\ProXML` (que não mostra a 11.20b). O motivo técnico vai só para o LOG. Texto do .rar aprovado em 26/10/2026 (4.7); texto do .zip aprovado pelo usuário em 06/11/2026 (Plano 2) |
| 11.20b | XML ausente ao preparar o anexo (novo) | F | — | **Não foi possível preparar o anexo.** {n} XML não foi encontrado: {arquivo}. Processe a pasta de novo. | Faixa de erro + LOG; o e-mail não é enviado. Plural: "{n} XMLs não foram encontrados: {primeiro arquivo}." Aprovado pelo usuário em 03/11/2026 (4.10) |
| 11.21 | assunto do e-mail | R | Projeto Pro XML - XMLs de Nota Fiscal | XMLs de Nota Fiscal · {período} · {n} notas | Ex.: "XMLs de Nota Fiscal · 01/10/2026 a 31/10/2026 · 128 notas". Todas as notas com a mesma data: "XMLs de Nota Fiscal · 15/10/2026 · 1 nota" (decisão de 26/10/2026) |
| 11.22 | `ACBrMail1.FromName` | R | Projeto Pro XML | ProXML | Nome do remetente visto pelo destinatário |

## 12. Configurações

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 12.1 | `Label1` | R | Configurações | Configurações | |
| 12.2 | `Label2` | R | Dados para envio por email | E-mail de envio (SMTP) | |
| 12.3 | `Label4` | R | SMTP | Servidor SMTP | |
| 12.4 | `EditSMTP.Text` (`.dfm`) | R | smtp.gmail.com | *(vazio)* · *TextHint:* Ex.: smtp.gmail.com | Valor real vem do banco |
| 12.5 | `Label7` | R | Porta | Porta | *TextHint:* 587 |
| 12.6 | rótulo novo | R | — | Segurança | Acima de SSL/TLS |
| 12.7 | `CheckBoxSSL` | R | SSL | SSL | |
| 12.8 | `CheckBoxTSL` | R | TSL | TLS | E6. Nome interno `TSL` não muda |
| 12.9 | legenda (novo) | F | — | Porta 587 usa TLS; porta 465 usa SSL. | |
| 12.10 | `Label8` | R | Email | E-mail (usuário) | |
| 12.11 | `Label9` | R | Senha | Senha | |
| 12.12 | `SkSvg5` (olho) | H | — | Mostrar senha · Ocultar senha | Alterna com o estado |
| 12.13 | legenda (novo) | F | — | No Gmail, use uma senha de app. | |
| 12.14 | `Label10` | R | Mensagem | Mensagem padrão do e-mail | |
| 12.15 | `btnSalvarConfig` | B/H | Salvar | Salvar · *hint:* Salvar as configurações de e-mail | |
| 12.16 | `btnSalvarConfigClick` | M→F | Configuração salva com sucesso !! | Configurações salvas | X2. Confirmação inline 3 s; não troca de tela (N5) |
| 12.17 | erro ao salvar (novo; hoje `except end` vazio) | M | — | Não foi possível salvar as configurações.<br><br>Motivo: {motivo} | E1 + LOG |
| 12.18 | erro ao ler (novo; `FormCreate` engole) | M | — | Não foi possível ler as configurações de e-mail.<br><br>Motivo: {motivo} | E1 + LOG |
| 12.19 | Testar conexão (novo) | B/H | — | Testar conexão · *hint:* Conectar e autenticar no servidor, sem enviar e-mail | PD-4 |
| 12.20 | testando (novo) | B/F | — | Testando… · Conectando a {servidor}:{porta}… | |
| 12.21 | conexão OK (novo) | F | — | **Conexão OK.** O servidor {servidor}:{porta} aceitou o usuário e a senha. Nenhum e-mail foi enviado. | |
| 12.22 | conexão falhou (novo) | F | — | **Não foi possível conectar.**<br>O servidor respondeu: {motivo} | Sem resposta do servidor: "O servidor {servidor}:{porta} não respondeu. Confira o endereço, a porta e a conexão com a internet." |
| 12.22a | servidor sem autenticação (novo) | F | — | **Não foi possível autenticar.** O servidor {servidor}:{porta} não pediu usuário e senha nesta conexão. Confira a porta e as opções SSL e TLS. | Faixa de erro. Ex.: Gmail com TLS desmarcado. Aprovado pelo usuário em 26/10/2026 (4.7) |
| 12.23 | validação porta (novo) | F | — | Informe uma porta entre 1 e 65535. | |
| 12.24 | validação e-mail (novo) | F | — | Informe um e-mail válido. | |
| 12.25 | validação servidor (novo) | F | — | Informe o servidor SMTP. | |

## 13. Sobre

> **Etapa 3.5 do [Plano 3](../planos/plano-3-site-vercel.md) (v1.2.1, 11/11/2026):** itens 13.7 a 13.8c (link do site e "Apoie o projeto"), **aguardando aprovação do usuário**. Mockup: `mockups/sobre.html` (sugestão A). Ordem na tela: 13.1, 13.2, 13.3, 13.7, 13.4, divisor, 13.8, 13.8a, 13.8b, 13.6.

| # | Onde | Tipo | Antes | Depois | Observação |
|---|------|------|-------|--------|------------|
| 13.1 | tela nova | R | — | ProXML v{versão} | Versão do VersionInfo (ex.: 1.1.0). Sem VersionInfo: "ProXML" (registrado em 03/11/2026, 4.10) |
| 13.2 | tela nova | F | — | Totalizador de XMLs de NF-e (55) e NFC-e (65) com IBS/CBS, DANFE e relatórios. | Mesma frase da descrição do repositório (aprovada) |
| 13.3 | tela nova (e saindo do relatório) | F | Desenvolvido por Caique Garcia \| Email … (no relatório) | Desenvolvido por Caique Garcia | Sem e-mail |
| 13.4 | tela nova | B | — | github.com/Caique-Garcia/Novo-ProXML_Delphi | Link; abre `https://github.com/Caique-Garcia/Novo-ProXML_Delphi` |
| 13.5 | link (novo) | H | — | Abrir no navegador | |
| 13.6 | tela nova | F | — | Ícones: Lucide (licença ISC) · Componentes: ACBr, Skia4Delphi | Atende à licença dos ícones |
| 13.7 | link do site (novo, v1.2.1) | B | — | proxml.vercel.app | Link no mesmo estilo do 13.4 (ícone `external-link`), logo acima dele. Clique: abre `https://proxml.vercel.app` no navegador padrão, sem confirmação; o ProXML continua na tela Sobre |
| 13.7a | link do site (novo, v1.2.1) | H | — | Abrir no navegador | Igual ao 13.5 |
| 13.8 | bloco "Apoie o projeto" (novo, v1.2.1) | R | — | Apoie o projeto | Título do bloco, 10 pt Semibold. Mesmo título da seção do site |
| 13.8a | bloco "Apoie o projeto" (novo, v1.2.1) | F | — | O ProXML é gratuito e sem anúncios. Se ele ajuda no seu trabalho, apoie o desenvolvimento no Apoia.se. | Texto de apoio, 10 pt `CorTextoSecundario`. Versão curta da frase do site |
| 13.8b | bloco "Apoie o projeto" (novo, v1.2.1) | B | — | Apoiar no Apoia.se | Botão secundário com o ícone `heart` (sugestão A; ver opções no mockup). Clique: abre `https://apoia.se/proxmlferramenta` no navegador padrão, sem confirmação |
| 13.8c | bloco "Apoie o projeto" (novo, v1.2.1) | H | — | Abrir apoia.se/proxmlferramenta no navegador | A dica mostra o endereço, porque o texto do botão não mostra |

## 14. Banco de dados e mensagens internas

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 14.1 | `DM.pas` (`GravarNotas`, `CreateLog`, `GravarConfig`, `UpdateConfig`) | I | Erro na gravação de dados: {erro} | Erro ao gravar no banco de dados: {erro} | Aparece como `{motivo}` em 8.12 / 12.17 |
| 14.2 | `DM.pas` (leituras: `GetConfig`, consulta de config) | I | Erro na gravação de dados: {erro} | Erro ao ler o banco de dados: {erro} | Hoje a leitura diz "gravação" |
| 14.3 | `DM.pas` (`SetFiltroModelo`) | I | Filtro de modelo inválido: {n} | Filtro de modelo inválido: {n}. | Erro de programação |
| 14.4 | `ErroLog.txt` | I | {data}: {mensagem} | sem mudança | Arquivo de log |
| 14.4a | prefixos só do LOG | I | — | Salvar configurações: · Ler configurações de e-mail: · Configurar o ACBr: · Preferências da tela: · Processar: · Enviar e-mail: · Testar conexão: · Exportar CSV: · Não foi possível criar o arquivo · Não foi possível preparar o anexo. {n} XML(s) não encontrado(s) | Não aparecem na tela (registrado em 03/11/2026, 4.10). Saem "O WinRAR não gerou o arquivo" e "WinRAR não encontrado em {pasta}"; entra "Não foi possível criar o arquivo" (14.4b). Aprovado pelo usuário em 06/11/2026 (Plano 2) |
| 14.4b | falha ao criar o `.zip` (novo) | I | — | Enviar e-mail: Não foi possível criar o arquivo {pasta do ProXML}NFCe\NFCe_ProXML.zip. Motivo: {mensagem da exceção} ({classe da exceção}) | Acompanha a 11.20a. Sem exceção, mas com o `.zip` ausente ou de 0 byte: "Motivo: o arquivo não existe depois da compactação" / "Motivo: o arquivo ficou vazio". Aprovado pelo usuário em 06/11/2026 (Plano 2) |
| 14.5 | `TabSheet1`, `TabSheet2`, `Loading`, `Enviar`, `Config` (`Caption` das abas) | I | TabSheet1 · TabSheet2 · Loading · Enviar · Config | sem mudança (abas ocultas) | Opcional renomear os componentes |

## 15. Caixas de mensagem

| # | Item | Antes | Depois | Observação |
|---|------|-------|--------|------------|
| 15.1 | Título das caixas | definido pela VCL (`MessageDlg`) | ProXML | Conferir no app compilado: no Delphi 10.2 o `MessageDlg` pode mostrar títulos e botões em inglês ("Information", "Yes"). Se aparecer, usar um helper único (`TaskDialog` ou `Application.MessageBox`) com título "ProXML" e botões do Windows em português |
| 15.2 | Tipos | `mtInformation`, `mtWarning`, `mtError` | Informação, Aviso, Erro | Mesmo ícone do Windows |
| 15.3 | Botões | OK | OK · Sim / Não (só em 5.28) | |

---

## Plano 7 · Conferência de IBS/CBS (v1.3.0): convenções

> **Etapa:** 7.2 do [Plano 7](../planos/plano-7-conferencia-ibs-cbs.md) · **Status:** dúvidas P7-1 a P7-14 decididas em 11/11/2026 com a sugestão; textos e mockups **aguardando aprovação visual do usuário**.
> **Base:** regras e decisões D1 a D24 em [plano-7-regras-ibs-cbs.md](../planos/plano-7-regras-ibs-cbs.md) (seções 5.1, 7.5, 7.6 e 10). Exemplos tirados de `tests/gabarito/divergencias.csv` (47 divergências em 62 notas conferidas, com a NF-e 910060 incluída em 11/11/2026).
> **Simples Nacional (NT 2026.005, D17, D22 e D23), incluído em 11/11/2026:** 16.5a, 17.7a, 17.7b, 17.8a, 17.9a, 17.23b, 18.C, 18.24, 18.25, 19.2 e 19.4.
> **Mockups:** `mockups/notas.html#p7-conferencia`, `mockups/resumo.html#p7-conferencia`, `mockups/relatorios.html#p7-divergencias` e `mockups/relatorio-divergencias-a4.html`.
> As citações **P7-1 a P7-14** são decisões (11/11/2026). **P7-15 a P7-17** são dúvidas novas do Simples Nacional, em aberto, com a sugestão aplicada aqui.

1. **Erro** (níveis 1 e 2) diz o que não fecha: termina com `(erro).` e usa "esperado".
2. **Alerta** (níveis 3 e 4) **não afirma que a nota está errada**: mostra o valor do XML e a referência do ProXML ("pela composição do item", "para 2026", "pela tabela do cClassTrib") e termina com `; confira (alerta).`
3. Valores em reais no formato do app (4.6): `R$ 1.234,56`. Alíquotas (`pIBSUF`, `pIBSMun`, `pCBS`, `pAliqEfet`, `pAliqEfetReg…`) com 4 casas e `%`: `0,1000%`. Percentuais de redução, diferimento e devolução sem casas quando inteiros (`60%`); se não, até 4 casas, sem zeros no fim (`12,5%`).
4. Esferas: `{esf}` = **IBS UF**, **IBS municipal** ou **CBS**; `{do esf}` = "do IBS UF", "do IBS municipal", "da CBS". No relatório (coluna Campo, espaço curto): IBS UF, IBS Mun., CBS.
5. Placeholders: `{n}` número da nota (nNF), `{i}` número do item (nItem), `{xml}` valor no XML, `{esp}` valor esperado, `{cst}` CST, `{c}` cClassTrib, `{ano}` ano da emissão; `{d}` divergências, `{e}` notas (ou contas) com Erro, `{a}` notas (ou indicações) com Alerta, `{k}` notas conferidas, `{m}` notas com divergência, `{s}` notas sem divergência.
6. Uma linha por esfera (D7). Singular e plural como no resto do app ("1 nota", "2 notas").

## 16. Conferência de IBS/CBS: tela Notas e CSV

| # | Onde | Tipo | Antes | Depois | Observação |
|---|------|------|-------|--------|------------|
| 16.1 | `DBGrid1`, coluna nova `conf_ibscbs` | R | — | IBS/CBS | Título da coluna. Posição e largura: tokens 5.15 (decisões P7-3 e P7-4). Título mantido na decisão P7-14 |
| 16.2 | células da coluna | R | — | OK · Alerta · Erro · *(vazia)* | Vazia = nota sem IBS/CBS (fora da conferência). Nota com Erro e Alerta mostra **Erro**. Itens sem conferência não mudam a célula (D9) |
| 16.3 | título da coluna (dica) | H | — | Conferência dos cálculos de IBS/CBS.<br>Erro: conta que não fecha com os valores do XML. Alerta: indicação para conferir. | Duas linhas (`#13#10`). Dica por célula via `OnMouseMove` (tokens 5.15) |
| 16.4 | célula OK (dica) | H | — | Cálculos de IBS/CBS conferidos, sem divergência. | |
| 16.5 | célula OK com itens sem conferência (dica) | H | — | Cálculos de IBS/CBS conferidos, sem divergência.<br>Alguns itens ou totais não foram conferidos; veja o Resumo. | Ex.: 910020 (item monofásico e total gMono). Decisão P7-12; "itens ou totais" aprovado em 11/11/2026 |
| 16.5a | célula OK de nota do Simples Nacional (dica) (**proposta**) | H | — | Totais de IBS/CBS conferidos, sem divergência.<br>Nota do Simples Nacional (gTribSN): base e alíquota dos itens não são conferidas. | Nota com item com `gTribSN` e sem `gIBSCBS` (D22). Ex.: 910040, 910050. Célula continua **OK**. Com Erro ou Alerta, vale a 16.6 ou a 16.7. Dúvida P7-17 |
| 16.6 | célula Alerta (dica) | H | — | Alerta: {a} indicações para conferir (base, alíquota ou CST). Não quer dizer que a nota está errada.<br>Detalhes no Resumo e no relatório Divergências IBS/CBS. | Singular: "Alerta: 1 indicação para conferir (…)" |
| 16.7 | célula Erro (dica) | H | — | Erro: {e} contas de IBS/CBS não fecham com os valores do XML.<br>Detalhes no Resumo e no relatório Divergências IBS/CBS. | Singular: "Erro: 1 conta de IBS/CBS não fecha com os valores do XML." Com alertas na mesma nota, a 1ª linha ganha: "…, e há {a} indicações para conferir." |
| 16.8 | célula vazia (dica) | H | — | Nota sem IBS/CBS: fora da conferência. | |
| 16.9 | ordenação pela coluna | R | — | IBS/CBS ▲ · IBS/CBS ▼ | Ordem por gravidade (vazia < OK < Alerta < Erro), empate por Nº. 1º clique em ▼, Erro no topo (decisão P7-5) |
| 16.10 | CSV: cabeçalho | R | Nº;Modelo;Data;Chave;Valor;Base ICMS;ICMS;Base IBS/CBS;IBS UF;IBS Mun.;IBS;CBS (6.29) | Nº;Modelo;Data;Chave;Valor;Base ICMS;ICMS;Base IBS/CBS;IBS UF;IBS Mun.;IBS;CBS;Conferência IBS/CBS | Coluna nova **no fim**, para não mudar a posição das outras (planilhas de quem já usa o CSV). Substitui 6.29 a partir da v1.3.0 |
| 16.11 | CSV: valores da coluna nova | R | — | OK · Alerta · Erro · *(vazio)* | Mesmo texto da grade, sem ícone |
| 16.12 | botão Exportar CSV (dica) | H | Salvar as notas da lista num arquivo CSV (abre no Excel) (6.16) | sem mudança | |

## 17. Conferência de IBS/CBS: log do Resumo

Erro → `llErro` (ícone `circle-x`); Alerta e linhas informativas → `llAviso` (`triangle-alert`). As linhas **não mudam** os contadores Autorizadas, Ignoradas e Com erro. Posição das linhas no log (decisão P7-7): juntas no fim, depois da 5.21, abertas pela 17.23 e em ordem de Nº, item e nível.

### 17.A Nível 1: conta do item (Erro)

| # | Regra | Tipo | Texto | Exemplo (gabarito) |
|---|-------|------|-------|--------------------|
| 17.1 | N1-vIBSUF · N1-vIBSMun · N1-vCBS | L | Nota Fiscal {n}, item {i}: {esf} {xml}, esperado {esp} ({conta}) (erro). | Nota Fiscal 910003, item 1: IBS UF R$ 0,50, esperado R$ 0,24 (R$ 238,13 × 0,1000%) (erro). |
| 17.1a | `{conta}` sem redução | I | {vBC} × {alíquota} | R$ 238,13 × 0,1000% |
| 17.1b | `{conta}` com redução (`gRed`) | I | {vBC} × {pAliqEfet}, alíquota efetiva | Nota Fiscal 910006, item 1: CBS R$ 3,35, esperado R$ 1,34 (R$ 372,07 × 0,3600%, alíquota efetiva) (erro). |
| 17.1c | `{conta}` com diferimento ou devolução de tributo | I | {vBC} × {alíquota} − {vDif} de diferimento − {vDevTrib} de devolução de tributo | Só os termos que existem no item. Ex.: "R$ 100,00 × 0,9000% − R$ 0,90 de diferimento" |
| 17.2 | N1-vIBS | L | Nota Fiscal {n}, item {i}: IBS {xml}, esperado {esp} (IBS UF + IBS municipal) (erro). | Nota Fiscal 910005, item 1: IBS R$ 0,20, esperado R$ 0,09 (IBS UF + IBS municipal) (erro). |
| 17.2a | N1-vIBS com crédito presumido (D10) | L | Nota Fiscal {n}, item {i}: IBS {xml}, esperado {esp} (IBS UF + IBS municipal, com ou sem o crédito presumido de {vCredPres}) (erro). | Só quando nenhuma das duas formas bate. `{esp}` = a soma sem o crédito |
| 17.3 | N1-pAliqEfet | L | Nota Fiscal {n}, item {i}: alíquota efetiva {do esf} {xml}, esperado {esp} ({alíquota} com redução de {pRedAliq}) (erro). | Nota Fiscal 910007, item 1: alíquota efetiva da CBS 0,5000%, esperado 0,3600% (0,9000% com redução de 60%) (erro). |
| 17.3a | N1-pAliqEfet com compra governamental | L | … ({alíquota} com redução de {pRedAliq} e redutor de compra governamental de {pRedutor}) (erro). | |
| 17.4 | N1-vDif | L | Nota Fiscal {n}, item {i}: diferimento {do esf} {xml}, esperado {esp} ({pDif} do imposto) (erro). | |
| 17.5 | N1-vDevTrib | L | Nota Fiscal {n}, item {i}: devolução de tributo {do esf} {xml}, esperado {esp} ({pDevTrib} do imposto) (erro). | |
| 17.6 | N1-vTribReg | L | Nota Fiscal {n}, item {i}: tributação regular {do esf} {xml}, esperado {esp} ({vBC} × {pAliqEfetReg}) (erro). | |

### 17.B Nível 2: itens × totais (Erro)

| # | Regra | Tipo | Texto | Exemplo (gabarito) |
|---|-------|------|-------|--------------------|
| 17.7 | N2-{campo} | L | Nota Fiscal {n}: total {do campo} {xml}, soma dos itens {esp} (erro). | Nota Fiscal 910009: total da CBS R$ 12,00, soma dos itens R$ 10,05 (erro). |
| 17.7a | `{do campo}` | I | da base de IBS/CBS · do IBS UF · do IBS municipal · do IBS · da CBS · do diferimento do IBS UF (do IBS municipal, da CBS) · da devolução de tributo do IBS UF (…) · do crédito presumido do IBS · do crédito presumido da CBS · do crédito presumido do IBS em condição suspensiva · do crédito presumido da CBS em condição suspensiva · do IBS do Simples Nacional · da CBS do Simples Nacional | Nota Fiscal 910008: total da base de IBS/CBS R$ 150,00, soma dos itens R$ 111,62 (erro). Os dois últimos (`vIBSSN`, `vCBSSN`) são da NT 2026.005 e só são comparados quando o total tem `gTribSN` |
| 17.7b | N2-vIBSSN · N2-vCBSSN (Simples Nacional, D17) | L | Nota Fiscal {n}: total {do IBS do Simples Nacional / da CBS do Simples Nacional} {xml}, soma dos itens {esp} (erro). | Nota Fiscal 910041: total do IBS do Simples Nacional R$ 1,50, soma dos itens R$ 1,20 (erro).<br>Nota Fiscal 910042: total da CBS do Simples Nacional R$ 5,34, soma dos itens R$ 5,33 (erro). (diferença de 1 centavo: tolerância zero no nível 2)<br>Nota Fiscal 910051: total do IBS do Simples Nacional R$ 0,40, soma dos itens R$ 0,42 (erro). |
| 17.8 | N2-IBSCBSTot (total ausente) | L | Nota Fiscal {n}: itens com IBS/CBS e nota sem o total de IBS/CBS (IBSCBSTot) (erro). | Nota Fiscal 910010. Vale também para itens com `gTribSN` (910047): sai só esta linha, sem a 17.8a |
| 17.8a | N2-gTribSN (total do Simples ausente, W59h-10) | L | Nota Fiscal {n}: itens com IBS/CBS do Simples Nacional e nota sem o total do Simples Nacional (gTribSN) (erro). | Nota Fiscal 910043: itens com IBS/CBS do Simples Nacional e nota sem o total do Simples Nacional (gTribSN) (erro). Também 910053 |
| 17.9 | N2-IBSCBSTot (sem itens, D6) | L | Nota Fiscal {n}: total de IBS/CBS (IBSCBSTot) informado e nenhum item com IBS/CBS (erro). | |
| 17.9a | N2-gTribSN (total do Simples sem itens, W59h-20) | L | Nota Fiscal {n}: total do Simples Nacional (gTribSN) informado e nenhum item com IBS/CBS do Simples Nacional (erro). | Nota Fiscal 910044: total do Simples Nacional (gTribSN) informado e nenhum item com IBS/CBS do Simples Nacional (erro). |

### 17.C Nível 3: base de cálculo (Alerta)

| # | Regra | Tipo | Texto | Exemplo (gabarito) |
|---|-------|------|-------|--------------------|
| 17.10 | N3-vBC | L | Nota Fiscal {n}, item {i}: base de IBS/CBS {xml} no XML e {esp} pela composição do item; confira (alerta). | Nota Fiscal 10435, item 1: base de IBS/CBS R$ 30,00 no XML e R$ 38,50 pela composição do item; confira (alerta). |

A composição (vProd + frete + seguro + outras − desconto − tributos, D1) **não** vai para a linha, para ela caber no log. Ela fica no README e no site (19.3).

### 17.D Nível 4: alíquota, redução e CST (Alerta)

| # | Regra | Tipo | Texto | Exemplo (gabarito) |
|---|-------|------|-------|--------------------|
| 17.11 | N4-cClassTrib | L | Nota Fiscal {n}, item {i}: o cClassTrib {c} não está na tabela oficial (v{versão}); confira (alerta). | `{versão}` = versão da tabela embutida (hoje 1.71) |
| 17.12 | N4-CSTxcClassTrib | L | Nota Fiscal {n}, item {i}: pela tabela oficial, o cClassTrib {c} não pertence ao CST {cst}; confira (alerta). | Nota Fiscal 910019, item 1: pela tabela oficial, o cClassTrib 200034 não pertence ao CST 000; confira (alerta). |
| 17.13 | N4-cClassTribModelo | L | Nota Fiscal {n}, item {i}: pela tabela oficial, o cClassTrib {c} não é usado na {NF-e (55) / NFC-e (65)}; confira (alerta). | |
| 17.14 | N4-cClassTribVigencia | L | Nota Fiscal {n}, item {i}: pela tabela oficial, o cClassTrib {c} não estava vigente em {dd/mm/aaaa}; confira (alerta). | Data = emissão |
| 17.15 | N4-gIBSCBS (ausente) | L | Nota Fiscal {n}, item {i}: sem o grupo de cálculo do IBS/CBS (gIBSCBS) no XML, e o CST {cst} prevê esse grupo; confira (alerta). | |
| 17.15a | N4-gIBSCBS (presente) | L | Nota Fiscal {n}, item {i}: grupo de cálculo do IBS/CBS (gIBSCBS) no XML, e o CST {cst} não prevê esse grupo; confira (alerta). | |
| 17.16 | N4-pIBSUF · N4-pIBSMun · N4-pCBS | L | Nota Fiscal {n}, item {i}: alíquota {do esf} {xml} no XML e {esp} para {ano}; confira (alerta). | Nota Fiscal 910014, item 1: alíquota do IBS UF 0,0500% no XML e 0,1000% para 2026; confira (alerta). |
| 17.16a | idem, tributação regular | L | Nota Fiscal {n}, item {i}: alíquota {do esf} {xml} no XML e 0,0000% para o cClassTrib {c} (tributação regular); confira (alerta). | |
| 17.16b | idem, ZFM/ALC (`gALCZFMCBS`) | L | Nota Fiscal {n}, item {i}: alíquota da CBS {xml} no XML e 0,0000% com o grupo da ZFM/ALC (gALCZFMCBS); confira (alerta). | |
| 17.17 | N4-pRedAliq | L | Nota Fiscal {n}, item {i}: redução {do esf} de {xml} no XML e {esp} pela tabela do cClassTrib {c}; confira (alerta). | Nota Fiscal 910016, item 1: redução da CBS de 40% no XML e 60% pela tabela do cClassTrib 200034; confira (alerta). |
| 17.18 | N4-gRed (ausente) | L | Nota Fiscal {n}, item {i}: sem redução {do esf} no XML, e a tabela prevê {esp} para o cClassTrib {c}; confira (alerta). | Nota Fiscal 910018, item 1: sem redução do IBS UF no XML, e a tabela prevê 60% para o cClassTrib 200034; confira (alerta). |
| 17.18a | N4-gRed (presente) | L | Nota Fiscal {n}, item {i}: redução {do esf} de {xml} no XML, e o CST {cst} não prevê redução; confira (alerta). | Nota Fiscal 910017, item 1: redução do IBS UF de 60% no XML, e o CST 000 não prevê redução; confira (alerta). |
| 17.19 | N4-gDif (ausente) | L | Nota Fiscal {n}, item {i}: sem diferimento {do esf} no XML, e o CST {cst} prevê diferimento; confira (alerta). | |
| 17.19a | N4-gDif (presente) | L | Nota Fiscal {n}, item {i}: diferimento {do esf} no XML, e o CST {cst} não prevê diferimento; confira (alerta). | |
| 17.20 | N4-gTribRegular (ausente) | L | Nota Fiscal {n}, item {i}: sem tributação regular (gTribRegular) no XML, e o cClassTrib {c} prevê esse grupo; confira (alerta). | |
| 17.20a | N4-gTribRegular (presente) | L | Nota Fiscal {n}, item {i}: tributação regular (gTribRegular) no XML, e o cClassTrib {c} não prevê esse grupo; confira (alerta). | |

### 17.E Casos sem conferência (D9 e D14) e resumo

| # | Onde | Tipo | Texto | Observação |
|---|------|------|-------|------------|
| 17.21 | uma linha por nota | L | Nota Fiscal {n}, sem conferência de IBS/CBS: {motivo}; {motivo}. | `llAviso`, sem contar como divergência e sem mudar a coluna da grade. Os motivos da mesma nota vão na mesma linha, separados por "; ", e a linha sai depois das divergências da mesma nota (11/11/2026, revisão da 7.3). Nível do log: `llAviso` (decisão P7-6) |
| 17.22a | motivo: monofásico | I | item {i} (tributação monofásica, CST 620) | Vários itens: "itens 1, 3 e 4 (tributação monofásica, CST 620)". Ex.: Nota Fiscal 910020, sem conferência de IBS/CBS: item 1 (tributação monofásica, CST 620); totais de IBS/CBS monofásico (gMono). (a 910020 também tem `gMono` no total: os dois motivos na mesma linha, 17.21 e 17.22i; decisão de 11/11/2026, revisão da 7.3) |
| 17.22b | motivo: CST 800 / 810 / 811 | I | item {i} (transferência de crédito, CST 800) · item {i} (ajuste de IBS na ZFM, CST 810) · item {i} (ajuste de competência, CST 811) | |
| 17.22c | motivo: compra governamental | I | item {i} (compra governamental, valores sem o redutor) | `gTribCompraGov` |
| 17.22d | motivo: crédito presumido da ZFM | I | item {i} (crédito presumido da ZFM) | `gCredPresIBSZFM` |
| 17.22e | motivo: devolução | I | base e alíquotas (devolução, finNFe 4) | Ex.: Nota Fiscal 910022, sem conferência de IBS/CBS: base e alíquotas (devolução, finNFe 4). |
| 17.22f | motivo: outras finalidades (D3) | I | base (nota complementar, finNFe 2) · base (nota de ajuste, finNFe 3) · base (nota de crédito, finNFe 5) · base (nota de débito, finNFe 6) | ✅ 11/11/2026, `nfe-fiscal`: nomes do finNFe 5 e 6 conferidos na NT 2025.002 v1.53, campo B25 ("5=Nota de crédito; 6=Nota de débito"). O texto já estava certo e não mudou |
| 17.22g | motivo: nota de crédito | I | alíquotas (nota de crédito, tpNFCredito {x}) | `tpNFCredito` 03, 04 ou 06 |
| 17.22h | motivo: ano sem alíquota em lei (D8) | I | alíquota da CBS de {ano} (depende da alíquota de referência) · alíquotas do IBS de {ano} (dependem da lei de cada ente) | |
| 17.22i | motivo: totais não conferidos | I | totais de IBS/CBS monofásico (gMono) · totais de estorno de crédito (gEstornoCred) | |
| 17.23 | resumo da conferência | L | Conferência de IBS/CBS: {k} notas conferidas, {e} com Erro e {a} com Alerta{simples}. | Depois da 5.21. `llErro` se houver Erro; senão `llAviso`. Só Erro: "…, {e} com Erro"; só Alerta: "…, {a} com Alerta". Singular: "1 nota conferida". Decisão P7-11. Sem nota conferida, a linha não sai. O log descreve a leitura da pasta inteira e **não muda com o filtro de modelo**; grade e relatório respeitam o filtro (decisões de 11/11/2026, revisão da 7.3; o exemplo "Filtro NFC-e 65" da 17.23b foi retirado). `{simples}` = 17.23b, vazio quando não há nota do Simples |
| 17.23a | resumo sem divergência | L | Conferência de IBS/CBS: {k} notas conferidas, sem divergência{simples}. | `llSucesso` |
| 17.23b | `{simples}`: menção do Simples Nacional (D22) (**proposta**) | I | ; {x} do Simples Nacional, sem conferir base e alíquota | Uma menção só, na linha de resumo; **nenhuma linha por nota**. `{x}` = notas conferidas com algum item com `gTribSN` e sem `gIBSCBS` (já contadas em `{k}`). `{x}` = `{k}`: "; todas do Simples Nacional, sem conferir base e alíquota"; `{k}` = 1: "; do Simples Nacional, sem conferir base e alíquota". Ex. (gabarito): Conferência de IBS/CBS: 62 notas conferidas, 20 com Erro e 18 com Alerta; 9 do Simples Nacional, sem conferir base e alíquota. Não conta como divergência. Dúvida P7-15 |
| 17.24 | 5.23 "Todos os {n} arquivos foram lidos sem ocorrências." | L | sem mudança | Continua valendo só para a leitura (sem ignoradas nem erros). A divergência não é ocorrência de leitura; quem informa a conferência é a 17.23 |

## 18. Relatório Divergências IBS/CBS

### 18.A Tela Relatórios, menu e carregamento

| # | Onde | Tipo | Antes | Depois | Observação |
|---|------|------|-------|--------|------------|
| 18.1 | quadro novo (tela Relatórios) | R | — | Divergências IBS/CBS | 3º quadro, depois do Relatório IBS/CBS (decisão P7-1). Ícone `list-checks` |
| 18.2 | quadro (descrição) | F | — | Erros e alertas da conferência de IBS/CBS, um por linha: nota, item, nível, campo, valor no XML e valor esperado. {e} notas com Erro e {a} com Alerta. | Só Erro: "{e} notas com Erro."; só Alerta: "{a} notas com Alerta." Singular: "1 nota com Erro" |
| 18.2a | quadro, sem divergência | F | — | Erros e alertas da conferência de IBS/CBS, um por linha: nota, item, nível, campo, valor no XML e valor esperado. Nenhuma divergência nas {k} notas conferidas. | Singular: "Nenhuma divergência na nota conferida." Botão habilitado (decisão P7-9) |
| 18.3 | botão | B/H | — | Gerar relatório · *dica:* Gravar as notas e abrir a visualização do relatório | Igual a 8.7 |
| 18.4 | sem nota com IBS/CBS no filtro | F | — | Nenhuma nota do modelo selecionado tem IBS/CBS. | Igual a 8.10: botão desabilitado com a dica visível |
| 18.5 | ~~item de menu~~ | — | — | *(não entra)* | Descartado na decisão P7-1: o relatório é o 3º quadro (18.1) e o menu continua com 5 itens |
| 18.6 | Carregando | F | — | Gerando o relatório Divergências IBS/CBS… | Mesmo padrão de 8.15 |
| 18.7 | Carregando (legenda) | F | — | Gravando {n} notas e montando a visualização. | Igual a 8.16 |
| 18.8 | erros ao gravar e gerar | M | — | *(8.12 e 8.13 sem mudança)* | O `{motivo}` da 8.14 ("Nenhuma nota para o relatório.") vale também aqui |

### 18.B Relatório impresso (QuickReport, form novo `FormRelatorioDivergencias`)

| # | Onde | Tipo | Antes | Depois | Observação |
|---|------|------|-------|--------|------------|
| 18.10 | título | P | — | Divergências IBS/CBS | 16 pt Semibold |
| 18.11 | marca | P | — | ProXML | Como 9.2 |
| 18.12 | subtítulo (Todos) | P | — | Período: {dd/mm/aaaa} a {dd/mm/aaaa} · Modelo: Todos (NF-e 55 e NFC-e 65) · {k} notas conferidas · {d} divergências | Singular: "1 nota conferida", "1 divergência". Período = notas conferidas do filtro |
| 18.13 | subtítulo (filtro) | P | — | Período: {…} · Modelo: {NF-e 55 / NFC-e 65} · {k} notas conferidas · {d} divergências | |
| 18.14 | pasta | P | — | Pasta: {caminho} | Como 9.6 |
| 18.15 | títulos das colunas | P | — | Nº · Mod. · Data · Item · Nível · Tipo · Campo · Valor no XML · Esperado | Nº antes de Mod. (decisão P7-10). Larguras em tokens 6 |
| 18.16 | Item | P | — | {nItem} · Total | "Total" = divergência de nível 2 |
| 18.17 | Nível | P | — | 1 · 2 · 3 · 4 | Explicado na legenda 18.22 |
| 18.18 | Tipo | P | — | Erro · Alerta | Erro em Semibold (impressão monocromática) |
| 18.19 | Campo | P | — | *(tabela 18.C)* | Nome curto + tag do XML entre parênteses (decisão P7-13) |
| 18.20 | Valor no XML / Esperado | P | — | R$ 1.234,56 · 0,1000% · 60% · ausente · presente · {cClassTrib} · do CST {cst} | A unidade vai na célula, porque a coluna mistura tipos |
| 18.21 | linha de total | P | — | Total · {d} divergências em {m} notas | Singular: "1 divergência em 1 nota" |
| 18.21a | contagem | P | — | Notas com Erro: {e} · Notas com Alerta: {a} · Notas sem divergência: {s} · a nota com Erro e Alerta conta só em Erro | Mesma regra da coluna da grade |
| 18.22 | legenda dos níveis | P | — | Nível 1: conta do item · Nível 2: itens × totais · Nível 3: base de cálculo · Nível 4: alíquota, redução e CST. Níveis 1 e 2 são Erro; 3 e 4, Alerta. | 8 pt |
| 18.23 | legenda Erro × Alerta | P | — | Erro: conta que não fecha com os valores do próprio XML. Alerta: indicação para conferir; depende da operação e da regra legal e não afirma que a nota está errada. | 8 pt |
| 18.24 | legenda do que não entra | P | — | Não entram: notas sem IBS/CBS e itens sem conferência (monofásico, transferência de crédito, ajustes, compra governamental; veja o Resumo). Nos itens do Simples Nacional (gTribSN), só os totais e o cClassTrib são conferidos. | 8 pt. 2ª frase nova (D17/D22); sai sempre, mesmo sem nota do Simples no filtro |
| 18.25 | legenda das regras | P | — | Regras da NT 2025.002 v{versão}, da NT 2026.005 v{versão} (Simples Nacional) e da tabela de cClassTrib v{versão}. A conferência não muda os totais do ProXML. | Versões vindas da unit `uConferenciaIBSCBS` (hoje 1.53, 1.00 e 1.71). Também na 18.27 (sem divergência) |
| 18.26 | sem divergência (título) | P | — | Nenhuma divergência de IBS/CBS | 12 pt Semibold, no corpo da 1ª página |
| 18.27 | sem divergência (texto) | P | — | As {k} notas com IBS/CBS do filtro foram conferidas, sem Erro nem Alerta. | Singular: "A nota com IBS/CBS do filtro foi conferida, sem Erro nem Alerta." Logo abaixo, a 18.25 |
| 18.28 | continuação | P | — | Divergências IBS/CBS · Modelo: {m} · continuação | Topo das páginas 2+ |
| 18.29 | rodapé | P | — | Gerado pelo ProXML v{versão} · {dd/mm/aaaa hh:mm} · Página {x} de {y} | Igual a 9.19 |

### 18.C Coluna Campo do relatório

| Regra | Campo (relatório) |
|-------|-------------------|
| N1-vIBSUF · N1-vIBSMun · N1-vCBS | IBS UF (vIBSUF) · IBS Mun. (vIBSMun) · CBS (vCBS) |
| N1-vIBS | IBS (vIBS) |
| N1-pAliqEfet | Alíq. efetiva {IBS UF / IBS Mun. / CBS} (pAliqEfet) |
| N1-vDif · N1-vDevTrib | Diferimento {esfera} (vDif) · Devolução trib. {esfera} (vDevTrib) |
| N1-vTribReg | Trib. regular IBS UF (vTribRegIBSUF) · Trib. regular IBS Mun. (vTribRegIBSMun) · Trib. regular CBS (vTribRegCBS) (nome real da tag; 11/11/2026, revisão da 7.3) |
| N2 (Item = Total) | Base IBS/CBS (vBCIBSCBS) · IBS UF (vIBSUF) · IBS Mun. (vIBSMun) · IBS (vIBS) · CBS (vCBS) · Diferimento {esfera} (vDif) · Devolução trib. {esfera} (vDevTrib) · Créd. presumido {IBS / CBS} (vCredPres) · Créd. pres. susp. {IBS / CBS} (vCredPresCondSus) · Total IBS/CBS (IBSCBSTot) |
| N2 do Simples Nacional (Item = Total, D17) | N2-vIBSSN: IBS Simples (vIBSSN) · N2-vCBSSN: CBS Simples (vCBSSN) · N2-gTribSN: Total Simples (gTribSN). Dúvida P7-16 |
| N3-vBC | Base IBS/CBS (vBC) |
| N4-pIBSUF · pIBSMun · pCBS | Alíquota IBS UF (pIBSUF) · Alíquota IBS Mun. (pIBSMun) · Alíquota CBS (pCBS) |
| N4-pRedAliq · N4-gRed | Redução {esfera} (pRedAliq) · Redução {esfera} (gRed) |
| N4-gDif · N4-gTribRegular · N4-gIBSCBS | Diferimento {esfera} (gDif) · Trib. regular (gTribRegular) · Grupo IBS/CBS (gIBSCBS) |
| N4-cClassTrib · CSTxcClassTrib · Modelo · Vigência | cClassTrib · cClassTrib × CST · cClassTrib × modelo · cClassTrib × vigência |

Valores das regras de presença e de tabela: `gRed`, `gDif`, `gTribRegular`, `gIBSCBS`, `IBSCBSTot` e `gTribSN` → "ausente" ou "presente" (no `gRed` presente, o percentual: "60%"); cClassTrib × CST → XML "{c}", esperado "do CST {cst}"; cClassTrib × modelo → esperado "só NF-e (55)" ou "só NFC-e (65)"; cClassTrib × vigência → XML "{data de emissão}", esperado "desde {dd/mm/aaaa}" ou "até {dd/mm/aaaa}"; cClassTrib que não existe → esperado "na tabela v{versão}". No Total Simples (gTribSN): total ausente com itens do Simples → XML "ausente", esperado "presente" (910043, 910053); total presente sem itens do Simples → XML "presente", esperado "ausente" (910044). `vIBSSN` e `vCBSSN` em reais: "R$ 1,50" / "R$ 1,20".

## 19. README e site (etapas 7.6 e 7.7)

| # | Onde | Tipo | Texto | Observação |
|---|------|------|-------|------------|
| 19.1 | README e site: aviso sobre Alerta | F | **Alerta não é erro.** O ProXML marca como Alerta o que depende da operação e da regra legal: base de cálculo, alíquota, redução, CST e cClassTrib. É uma indicação para conferir a nota com quem cuida da parte fiscal, não uma afirmação de que a nota está errada. Erro indica uma conta que não fecha com os próprios valores do XML, no item ou nos totais. | Pedido no plano (7.6). Revisão fiscal pelo `nfe-fiscal` antes de publicar (7.7) |
| 19.2 | README e site: o que a conferência faz | F | O ProXML refaz as contas de IBS e CBS de cada item e dos totais das notas autorizadas e mostra o resultado na coluna IBS/CBS da tela Notas, no Resumo e no relatório Divergências IBS/CBS. A conferência só informa: não muda os totais, os cards nem os contadores. Ela segue a NT 2025.002 v1.53, a NT 2026.005 v1.00 (Simples Nacional) e a tabela de cClassTrib v1.71 e não substitui a validação da SEFAZ nem a análise fiscal. | NT 2026.005 incluída em 11/11/2026 (D17) |
| 19.3 | README e site: base de cálculo (nível 3) | F | No nível 3, o ProXML compara a base do item com a soma do valor do produto, frete, seguro e outras despesas, menos o desconto e os tributos que saem da base em 2026 (ICMS, PIS, Cofins, ISS e FCP). Como a regra ainda depende de orientação da SEFAZ e da operação, a diferença aparece como Alerta. | Fórmula da D1 |
| 19.4 | README e site: casos sem conferência | F | Ficam sem conferência na v1.3.0: tributação monofásica, transferência de crédito, ajustes de competência e da ZFM, compras governamentais e as alíquotas que a lei ainda não fixou para o ano. O Resumo informa esses casos, sem contar como divergência. | D9 e D14 |
| 19.4a | README e site: Simples Nacional | F | Nas notas do Simples Nacional com o grupo do Simples (gTribSN, NT 2026.005), o ProXML confere se a soma do IBS e da CBS do Simples dos itens bate com o total da nota e se o grupo do Simples vem nos itens e no total. A alíquota do Simples depende do anexo e da faixa de faturamento e não é conferida. Quando o item também traz o grupo de cálculo do IBS/CBS (gIBSCBS), ele é conferido como nas outras notas, menos a alíquota da CBS quando o item só tem a CBS do Simples. | D17, D20 e D21. Revisão do `nfe-fiscal` na 7.7 |
