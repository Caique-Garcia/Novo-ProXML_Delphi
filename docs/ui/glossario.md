# ProXML · Glossário de textos da interface (v1.1.0)

> **Etapa:** 4.1 do Plano 4 · **Status:** proposta, **aguardando aprovação do usuário**
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
| 2.3 | `EditCaminho` (novo hint) | H | — | Clique para escolher a pasta (Ctrl+O) | Hint do campo com caminho |
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
| 2.14 | pasta salva que sumiu (novo) | M | — | A pasta não foi encontrada:<br>{pasta}<br><br>Selecione outra pasta. | Última pasta restaurada (4.2) que não existe mais |
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
| 5.6 | `Gauge1` (sem texto) | F | — | {x} de {n} arquivos | P5 |
| 5.7 | processando (novo) | B | — | Cancelar | |
| 5.8 | Cancelar (novo) | H | — | Parar a leitura (Esc) | |
| 5.9 | processando (novo) | F | — | Esc também cancela. As notas só aparecem quando a leitura termina. | Legenda |
| 5.10 | cancelado (novo) | F | — | **Processamento cancelado.** Nenhuma nota foi alterada. | Faixa de aviso (PD-3) |
| 5.11 | cancelado (novo) | F | — | {x} de {n} arquivos tinham sido lidos. Clique em Processar para começar de novo. | |
| 5.12 | contadores (novo) | R | — | Autorizadas · Ignoradas · Com erro | Ignoradas = não autorizadas + outro modelo; Com erro = não foi possível ler |
| 5.13 | contadores (novo) | R | — | {t} s · {n} arquivos lidos | Ex.: "4,2 s · 132 arquivos lidos" |
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
| 5.31 | aviso no Resumo: os dois (novo) | F | — | **Os totais incluem {h} notas de homologação** (ambiente de testes, sem valor fiscal) **e {e} NF-e de entrada.** Confira se a pasta é a certa. | **Aprovado pelo usuário em 20/10/2026.** Exemplo no mockup `resumo.html`, estado "Concluído" |
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
| 8.6 | opção 2 (novo) | F | — | Base IBS/CBS, IBS UF, IBS municipal, IBS e CBS das notas que têm o grupo IBS/CBS. {x} de {n} notas têm IBS/CBS. | |
| 8.7 | botões (novo) | B/H | — | Gerar relatório · *hint:* Gravar as notas e abrir a visualização do relatório | |
| 8.8 | sem notas (novo) | F | — | Processe uma pasta para gerar relatórios. | Dica visível ao lado dos botões desabilitados |
| 8.8a | sem notas no modelo (novo) | F | — | Nenhuma nota do modelo selecionado. Escolha outro modelo na barra de cima. | Há notas carregadas, mas nenhuma no filtro de modelo. Aprovado em 20/10/2026 (4.4). Também no painel da tela Notas (sem busca), aprovado em 21/10/2026 (4.5) |
| 8.9 | `GerarRelatorio` | M | Sem dados para gerar relatório !! | *(substituída pela 8.8)* | Botões desabilitados; se ainda for preciso: "Nenhuma nota para o relatório. Processe uma pasta primeiro." |
| 8.10 | `AbrirRelatorioIBSCBS` | M | Nenhuma nota com IBS/CBS | Nenhuma nota do modelo selecionado tem IBS/CBS. | Vira dica visível com o botão IBS/CBS desabilitado; a caixa só se o botão for acionado mesmo assim |
| 8.11 | rodapé da tela (novo) | F | — | Os relatórios usam as notas do modelo selecionado na barra de cima. A busca da tela Notas não é aplicada. | Depende da decisão D5 |
| 8.12 | `GravarNotasDB` | M | Erro ao gravar as notas no banco de dados. O relatório não foi gerado.<br>{erro} | Não foi possível gravar as notas no banco de dados. O relatório não foi gerado.<br><br>Motivo: {motivo} | Erro |
| 8.13 | `GravarNotasDB` (FinalizaRelatorio) | M | Erro ao gerar o relatório:<br><br>{erro} | Não foi possível gerar o relatório.<br><br>Motivo: {motivo} | Erro |
| 8.14 | `TFormRelatorios` (exceção) | I | Sem registros no banco de dados! | Nenhuma nota para o relatório. | Aparece como `{motivo}` de 8.13 |
| 8.15 | Carregando (novo) | F | *(aba vazia)* | Gerando o Relatório de Notas… · Gerando o Relatório IBS/CBS… | |
| 8.16 | Carregando (novo) | F | — | Gravando {n} notas e montando a visualização. | |

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
| 9.17 | legenda do total (novo) | P | — | NF-e 55: {a} notas · NFC-e 65: {b} notas · notas não autorizadas não entram no relatório | Só no filtro Todos mostra os dois modelos |
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
| 10.15 | legenda do total (novo) | P | — | {n} de {m} notas do filtro têm o grupo IBS/CBS | |
| 10.16 | continuação (novo) | P | — | Relatório IBS/CBS · Modelo: {m} · continuação | |
| 10.17 | `QRSysDataData` + `QRLabelDesenvolvido` + `QRSysDataPagina` | P | {data hora} · Desenvolvido por Caique Garcia \| Email caique.garciatst@gmail.com · {página} | Gerado pelo ProXML v{versão} · {dd/mm/aaaa hh:mm} · Página {x} de {y} | |

## 11. Enviar

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 11.1 | `Label11` | R | `Enviar ` (com espaço) | Enviar por e-mail | Título da tela |
| 11.2 | `Label12` | R | Enviar arquivos por email | *(removido)* | O quadro do anexo explica o envio |
| 11.3 | anexo (novo) | F | — | Anexo: {n} XMLs (.rar) | E3. Singular: "Anexo: 1 XML (.rar)" |
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
| 11.14 | enviando (novo) | F | — | Compactando e enviando {n} XMLs. Isso pode levar alguns segundos. | |
| 11.15 | `btnEnviarEmailClick` / `EnviaArquivo` | M | Sem arquivos para enviar! | Nenhuma nota para enviar. Processe uma pasta primeiro. | Duas ocorrências. Com o botão desabilitado, vira o texto 11.5/11.6 |
| 11.16 | `EnviaArquivo` | M→F | Email enviado com sucesso!! | **E-mail enviado** para {destino} às {hh:mm}. | X2. Faixa de sucesso, sem caixa |
| 11.17 | erro no envio (novo; hoje a exceção sobe sem tratamento) | F | — | **Não foi possível enviar o e-mail.**<br>O servidor respondeu: {motivo}. Confira os dados em Configurações e use Testar conexão. | Faixa de erro + LOG |
| 11.18 | validação (novo) | F | — | Informe um e-mail válido. Exemplo: nome@empresa.com.br | E5. Um só destinatário (decisão de 26/10/2026) |
| 11.19 | SMTP não configurado (novo) | F | — | Configure o e-mail de envio em Configurações antes de enviar. | Faixa informativa; Enviar desabilitado |
| 11.20 | WinRAR ausente (novo) | F | — | **Não foi possível compactar os XMLs.** WinRAR não encontrado em {pasta do ProXML}. | Até o ZIP do Plano 2 |
| 11.20a | .rar não gerado (novo) | F | — | **Não foi possível compactar os XMLs.** O arquivo .rar não foi gerado. Tente de novo; se continuar, confira o espaço em disco e a pasta do ProXML. | Faixa de erro + LOG. WinRAR presente, mas sem o .rar. Aprovado pelo usuário em 26/10/2026 (4.7) |
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

| # | Onde | Tipo | Antes | Depois | Observação |
|---|------|------|-------|--------|------------|
| 13.1 | tela nova | R | — | ProXML v{versão} | Versão do VersionInfo (ex.: 1.1.0) |
| 13.2 | tela nova | F | — | Totalizador de XMLs de NF-e (55) e NFC-e (65) com IBS/CBS, DANFE e relatórios. | Mesma frase da descrição do repositório (aprovada) |
| 13.3 | tela nova (e saindo do relatório) | F | Desenvolvido por Caique Garcia \| Email … (no relatório) | Desenvolvido por Caique Garcia | Sem e-mail |
| 13.4 | tela nova | B | — | github.com/Caique-Garcia/Novo-ProXML_Delphi | Link; abre `https://github.com/Caique-Garcia/Novo-ProXML_Delphi` |
| 13.5 | link (novo) | H | — | Abrir no navegador | |
| 13.6 | tela nova | F | — | Ícones: Lucide (licença ISC) · Componentes: ACBr, Skia4Delphi | Atende à licença dos ícones |

## 14. Banco de dados e mensagens internas

| # | Onde (atual) | Tipo | Antes | Depois | Observação |
|---|--------------|------|-------|--------|------------|
| 14.1 | `DM.pas` (`GravarNotas`, `CreateLog`, `GravarConfig`, `UpdateConfig`) | I | Erro na gravação de dados: {erro} | Erro ao gravar no banco de dados: {erro} | Aparece como `{motivo}` em 8.12 / 12.17 |
| 14.2 | `DM.pas` (leituras: `GetConfig`, consulta de config) | I | Erro na gravação de dados: {erro} | Erro ao ler o banco de dados: {erro} | Hoje a leitura diz "gravação" |
| 14.3 | `DM.pas` (`SetFiltroModelo`) | I | Filtro de modelo inválido: {n} | Filtro de modelo inválido: {n}. | Erro de programação |
| 14.4 | `ErroLog.txt` | I | {data}: {mensagem} | sem mudança | Arquivo de log |
| 14.5 | `TabSheet1`, `TabSheet2`, `Loading`, `Enviar`, `Config` (`Caption` das abas) | I | TabSheet1 · TabSheet2 · Loading · Enviar · Config | sem mudança (abas ocultas) | Opcional renomear os componentes |

## 15. Caixas de mensagem

| # | Item | Antes | Depois | Observação |
|---|------|-------|--------|------------|
| 15.1 | Título das caixas | definido pela VCL (`MessageDlg`) | ProXML | Conferir no app compilado: no Delphi 10.2 o `MessageDlg` pode mostrar títulos e botões em inglês ("Information", "Yes"). Se aparecer, usar um helper único (`TaskDialog` ou `Application.MessageBox`) com título "ProXML" e botões do Windows em português |
| 15.2 | Tipos | `mtInformation`, `mtWarning`, `mtError` | Informação, Aviso, Erro | Mesmo ícone do Windows |
| 15.3 | Botões | OK | OK · Sim / Não (só em 5.28) | |
