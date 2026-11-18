# Plano 7 — Conferência dos cálculos de IBS/CBS nos XMLs (v1.3.0)

## Objetivo
Ao processar uma pasta, o ProXML confere se os cálculos de IBS e CBS de cada nota autorizada estão corretos e aponta as divergências na grade, no log do Resumo e num relatório próprio.

Hoje o app lê só os **totais** (`total/IBSCBSTot`). A conferência passa a ler também **cada item** (`det/imposto/IBSCBS`) e refaz as contas.

**Por que vale a pena:** em 2026 (ano de teste da Reforma) a SEFAZ ainda não rejeita boa parte das regras de IBS/CBS, então uma nota **autorizada** pode ter erro de cálculo. Na análise de 11/11/2026, 4 das 11 NF-e reais de `exemple\` (nNF 10432 a 10435) têm a base de IBS/CBS igual ao `vProd`, sem considerar desconto, frete e outras despesas.

## Decisões do usuário (11/11/2026)
| Tema | Decisão |
|------|---------|
| Conferências | **Níveis 1, 2, 3 e 4** (ver tabela abaixo) |
| Classificação | Níveis 1 e 2 (contas objetivas) = **Erro**. Níveis 3 e 4 (dependem da operação e da regra legal) = **Alerta** |
| Onde aparece | Coluna **IBS/CBS** na grade (OK / Alerta / Erro), **uma linha por divergência** no log do Resumo e novo relatório **"Divergências IBS/CBS"** como **3º quadro da tela Relatórios** (P7-1, 11/11/2026; o plano original dizia menu lateral, mas desde o Plano 4 os relatórios são quadros dessa tela) |
| Roteiro | Plano novo, executado **antes do chat**: sai na **v1.3.0**. O chat (Plano 5) passa para a **v1.4.0**. O número 6 continua reservado para a continuação do chat |
| Site | Depois da release, **atualizar o site** com a nova funcionalidade (etapa 7.7) |
| Regras fiscais (7.1) | As 16 dúvidas da 7.1 foram decididas com a sugestão do `nfe-fiscal` (ver [regras](plano-7-regras-ibs-cbs.md), seção 10). Entre elas: base pela composição completa da UB16-10 (D1), nível 3 só em `finNFe` 1 (D3), `pAliqEfet`/`vDif`/`vDevTrib`/`vTribReg` como Erro de nível 1 (D4), tolerância zero no nível 2 (D5), Simples Nacional conferido normalmente (D11), monofásico/estorno/compras governamentais sem conferência na v1.3.0 (D14). D17 a D19 (NT 2026.005 e 2026.008 v1.01): soma do `gTribSN` no nível 2 (D17), pagamento antecipado só no log (D18), `vProd` sem IBS/CBS/IS conforme a introdução da NT 2026.008 v1.01 (D19) |
| Tela e textos (7.2) | As 14 dúvidas P7-1 a P7-14 foram decididas com a sugestão do `ux-designer` (11/11/2026): relatório como 3º quadro da tela Relatórios; coluna **IBS/CBS** como **última, sempre visível**; em 1366 px as colunas extras entram por prioridade (IBS, CBS, ICMS e por último Base ICMS); Alerta com `triangle-alert`; ordenação da coluna por gravidade (Erro primeiro); casos sem conferência como `llAviso`; linhas da conferência **juntas no fim do log**, por número de nota, com uma linha de resumo no início do bloco; relatório com uma linha por divergência, Nº antes de Mod., campo como "nome (tag)" e emitido mesmo sem divergência ("Nenhuma divergência de IBS/CBS"); nota OK com itens não conferidos continua OK, com dica |
| Tela e textos do Simples (11/11/2026) | P7-15 a menção do Simples Nacional fica **no fim da linha de resumo** da conferência ("…; 9 do Simples Nacional, sem conferir base e alíquota."); P7-16 nomes no relatório **IBS Simples (vIBSSN) / CBS Simples (vCBSSN) / Total Simples (gTribSN)**; P7-17 dica própria na célula OK de nota do Simples (glossário 16.5a). O gerador dos mockups ficou versionado em `docs/ui/mockups/gerador-p7/` (sem nome de arquivo nem chave; o `notas.json` fica fora do git) |
| Tela Sobre (Plano 3, etapa 3.5) | **Entra na v1.3.0** (decisão de 11/11/2026): a v1.2.1 separada foi cancelada. O código da 3.5 já está pronto (build sem erros nem avisos novos); a bateria reduzida da tela Sobre roda **junto com a 7.5**, no fim do Plano 7, e a 7.6 inclui os links da tela Sobre no README e nas notas da Release |

### Níveis de conferência
| Nível | O que confere | Resultado |
|-------|---------------|-----------|
| **1. Conta do item** | `vIBSUF = vBC × pIBSUF`, `vIBSMun = vBC × pIBSMun`, `vCBS = vBC × pCBS` (com a alíquota efetiva quando houver redução) e `vIBS = vIBSUF + vIBSMun` | Erro |
| **2. Itens × totais** | A soma dos itens bate com `IBSCBSTot` (`vBCIBSCBS`, `vIBSUF`, `vIBSMun`, `vIBS`, `vCBS`) e, no Simples Nacional, com `IBSCBSTot/gTribSN` (`vIBSSN`, `vCBSSN`, D17). Item com IBS/CBS e nota sem `IBSCBSTot` também é Erro, assim como o `gTribSN` só no item ou só no total | Erro |
| **3. Base de cálculo** | `vBC` do item comparado com a composição do item (vProd + frete + seguro + outras despesas − desconto − tributos excluídos), com a fórmula confirmada na 7.1 | Alerta |
| **4. Alíquota e CST** | Alíquota esperada para o ano da emissão, redução coerente com o CST/`cClassTrib` (`gRed`/`pAliqEfet`), diferimento e outros casos mapeados na 7.1 | Alerta |

### Padrões adotados (podem ser revistos na 7.1)
- Tolerância de **R$ 0,01** por valor comparado (arredondamento).
- Nota **sem** IBS/CBS (sem `IBSCBSTot` e sem itens com `IBSCBS`): fora da conferência, com a coluna vazia na grade.
- Nota não autorizada: continua **fora de tudo**, como hoje.
- A conferência **não muda** os totais, os cards nem os contadores do Resumo. Ela só informa.
- Uma nota com Erro e Alerta ao mesmo tempo aparece como **Erro** na grade. O log e o relatório listam todas as divergências.

## Etapas

### 7.1 Regras fiscais e gabarito — `nfe-fiscal`
- Confirmar na LC 214/2025 e na NT 2025.002 (versão vigente), com o ACBr local como apoio:
  - os caminhos dos grupos do item (`IBSCBS/CST`, `cClassTrib`, `gIBSCBS/vBC`, `gIBSUF`, `gIBSMun`, `gCBS`, `gRed`, `pAliqEfet`, `gDif`, `gDevTrib`, `gIBSCBSMono`, `gTribRegular`, `gCredPres` etc.) nos modelos 55 e 65;
  - a **fórmula da base de cálculo** do nível 3, incluindo quais tributos saem da base em 2026 e nos anos de transição;
  - a **tabela de alíquotas por ano** (2026: IBS UF 0,1% e CBS 0,9%) e como tratar os anos seguintes;
  - a **tabela de CST/`cClassTrib`** com o percentual de redução de cada caso. Indicar quais casos o nível 4 cobre e quais ficam sem conferência (ex.: monofásico, diferimento), e qual texto vai para o log nesses casos.
- Como o arredondamento funciona (por item, `ROUND_HALF_UP` ou outro), para calibrar a tolerância.
- Gerar XMLs **sintéticos com erros de propósito** em `exemple\sinteticos-ibscbs\` (fora do git): um caso para cada regra dos níveis 1 a 4, mais notas corretas com redução e com mais de um item.
- Gerar o gabarito `tests/gabarito/divergencias.csv` (por nota: número, final da chave, item, nível, Erro/Alerta, valor no XML e valor esperado) com um script Python independente do app, no mesmo padrão do `gerar_gabarito.py`.
- **Aceite:** tabela de regras e textos do log aprovados pelo usuário; o gabarito confirma as 4 divergências já conhecidas (nNF 10432 a 10435, nível 3).
- ✅ 11/11/2026: regras em [plano-7-regras-ibs-cbs.md](plano-7-regras-ibs-cbs.md) (NT 2025.002 v1.53, tabela cClassTrib v1.71, LC 214/2025); 33 sintéticos (nNF 910001 a 910037); gabarito com 36 divergências em 49 notas, confirmando as 4 conhecidas (10432 a 10435, nível 3); 16 dúvidas decididas. **Falta:** conferir o PDF da NT 2026.008 v1.01 antes da 7.3 (D16).

### 7.2 Textos e tela — `ux-designer`
- Glossário dos textos novos: valores da coluna (OK / Alerta / Erro), linha do log por regra (ex.: `Nota Fiscal 10435, item 1: base IBS/CBS 30,00, esperado 38,50 (alerta).`), título e mensagens do relatório (ex.: "Nenhuma divergência de IBS/CBS").
- Ícone e cor da coluna na grade com os tokens do Plano 4 (sucesso, aviso, erro).
- Mockup do relatório "Divergências IBS/CBS" em A4: colunas Modelo, Número, Data, Item, Nível, Tipo, Campo, Valor no XML, Esperado; rodapé com a quantidade de notas com Erro e com Alerta.
- **Aceite:** textos e mockups aprovados pelo usuário.
- ✅ 11/11/2026: glossário (seções 16 a 19), `tokens.md` 5.15, `icones.md` (+ `list-checks.svg`), mockups `notas.html#p7-conferencia`, `resumo.html#p7-conferencia`, `relatorios.html#p7-divergencias` e `relatorio-divergencias-a4.html`; dúvidas P7-1 a P7-14 decididas. Textos e mockups **aprovados pelo usuário em 11/11/2026**.

### Pendências antes da 7.3 — `nfe-fiscal`
- D17: acrescentar aos sintéticos casos de `gTribSN` (soma certa e soma errada) e gerar o gabarito de novo.
  - ✅ 11/11/2026: regras atualizadas (mapeamento 2.1 e 2.2, nível 2 com N2-gTribSN, N2-vIBSSN e N2-vCBSSN, seção 5.1 sobre os níveis 1, 3 e 4, e textos na 7.6). Foram criados 12 sintéticos (nNF 910040 a 910047 e 910050 a 910053, emitidos de 16 a 19/11/2026). O gabarito foi gerado de novo: 44 divergências em 61 notas (antes, 36 em 49). As 36 linhas antigas não mudaram, e as 8 novas são de nível 2. O nível 2 do script passou a ter tolerância zero (D5). **Em aberto:** D20 a D24 (seção 10 das regras).
- Confirmar os nomes das finalidades 5 e 6 (nota de crédito e de débito) usados no texto 17.22f do glossário.
  - ✅ 11/11/2026: a NT 2025.002 v1.53 (campo B25) diz "5=Nota de crédito" e "6=Nota de débito". O texto 17.22f estava certo, e só a observação do glossário mudou.

### 7.3 Leitura e conferência — `delphi-dev`
- `uCalculadoraXML.pas`:
  - ler os itens (`det`) com `IBSCBS` e os campos do item necessários para a base (vProd, vFrete, vSeg, vOutro, vDesc e os tributos definidos na 7.1);
  - nova unit `lib/uConferenciaIBSCBS.pas`, sem acesso à tela nem ao banco, com as regras dos níveis 1 a 4 e a tabela de alíquotas/CST da 7.1;
  - `TDadosNotaXML` ganha a situação da conferência e a lista de divergências; `TResultadoLeitura` gera as linhas do log (Erro → `llErro`, Alerta → `llAviso`).
- A conferência roda na thread de leitura que já existe, sem travar a tela com 1000+ XMLs.
- Item com valor numérico inválido nos grupos de IBS/CBS do item: segue a regra do Plano 1 (arquivo não processado com o motivo no log), salvo decisão diferente na 7.1.
- **Aceite:** build OK; a conferência dos XMLs de `exemple\`, `exemple\sinteticos\` e `exemple\sinteticos-ibscbs\` bate com `divergencias.csv`; os totais continuam batendo com `notas.csv`.

- ✅ 11/11/2026: `lib/uConferenciaIBSCBS.pas` (regras dos níveis 1 a 4 e do Simples, tabelas v1.71 embutidas, contas em inteiros), leitura dos itens em `uCalculadoraXML.pas` (na thread de leitura), bloco da conferência no fim do log e verificador de console em `tests/conferencia/`. Builds do ProXML e do verificador sem erros nem avisos novos; **o verificador ainda não foi executado** (roda na 7.5).
- Decisões de 11/11/2026 na revisão da 7.3: **D21** aplicada também no `gerar_divergencias.py` e na constante `IGNORAR_PCBS_SO_CBSSN = True` (gabarito sem mudança); CST sem cClassTrib na tabela (010, 011, 220…) gera **N4-cClassTrib** (documento de regras corrigido); a nota com item monofásico e `gMono` no total cita os dois na linha "sem conferência" (glossário 17.22i; o mockup será ajustado); o **log do Resumo não muda com o filtro** de modelo (o mockup será ajustado). Pontos que o glossário não definia, aceitos como o `delphi-dev` fez: a linha "sem conferência" sai depois das divergências da mesma nota; sem nota conferida não sai a linha de resumo; no relatório a tag da tributação regular usa o nome real (`vTribRegIBSUF` etc.).

### 7.4 Banco, grade e relatório — `delphi-dev`
- `FDMemTable1`: campo `conf_ibscbs` (vazio / OK / Alerta / Erro) e a lista de divergências guardada para o relatório.
- `DM.pas`: migração idempotente da tabela `nf` (coluna da situação) e tabela nova para as divergências (nota, item, nível, tipo, campo, valor no XML, esperado), gravadas na mesma transação de `GravarNotasDB`.
- Grade: coluna **IBS/CBS** com ícone e texto, respeitando o filtro de modelo.
- Novo form `view/ProXML.FormRelatorioDivergencias.pas/.dfm` (QuickReport), no padrão do `FormRelatorioIBSCBS`, aberto pelo **3º quadro da tela Relatórios** ("Divergências IBS/CBS", P7-1). Respeita o filtro de modelo.
- Exportar CSV: incluir a coluna da situação.
- **Aceite:** o app abre e grava com um `notas.db` antigo e com um novo; grade, log e relatório mostram o que está no gabarito nos filtros Todos / 55 / 65.

- ✅ 11/11/2026: banco (`CONF_IBSCBS` em `nf` + tabela `divergencia_ibscbs`, migração idempotente, gravação na mesma transação), coluna IBS/CBS na grade (ícone, dica por célula, ordenação por gravidade, colunas extras por prioridade), 3º quadro e `view/ProXML.FormRelatorioDivergencias.pas/.dfm`, coluna no CSV, nota que falha ao entrar na grade sai também do bloco da conferência. Build sem erros nem avisos novos; codificação conferida (CRLF, sem LF solto). **O app ainda não foi executado.**
- Decisões de 11/11/2026 na revisão da 7.4: colunas extras com **IBS e CBS juntas** (depois ICMS e por último Base ICMS), coluna Nº do relatório com **64 px** (Campo 230 px), nota OK do Simples com partes sem conferência mostra a dica **16.5a**; dica 16.5 passou a "Alguns itens ou totais não foram conferidos; veja o Resumo.".

### 7.5 Revisão e testes — `qa-reviewer`
- Revisão do diff (regras contra a tabela da 7.1, codificação, `.dfm`, migração, textos do glossário).
- Testes **só com o OK do usuário**, no fim das alterações, com a bateria reduzida ao mínimo: build, comparação com `notas.csv` e `divergencias.csv` nos 3 filtros, banco antigo e novo, relatório novo.
- ✅ 11/11/2026, autorizado pelo usuário: **verificador de console** (`tests/conferencia/`) compilado e executado — 68 XMLs lidos, 61 notas conferidas, **44 divergências iguais ao `divergencias.csv`** (comparar.ps1 OK) e linha de resumo do log conforme o glossário 17.23. A bateria de tela fica para depois, quando o usuário autorizar.
- Na mesma bateria: os itens da tela Sobre da etapa 3.5 do Plano 3 (links do site, do GitHub e do Apoia.se em 1024×640 e 1366×768), que entrou na v1.3.0.

#### Bateria de tela dividida em 5 (decisão do usuário, 11/11/2026)
Cada bateria roda só com a aprovação do usuário e **só começa depois que a anterior terminar e for aprovada**. Sempre com cópias do banco (nunca o `notas.db` do usuário), app compilado fora do repositório e as pastas `exemple`, `exemple\sinteticos` e `exemple\sinteticos-ibscbs`.

| # | Bateria | O que confere | Tempo estimado |
|---|---------|---------------|----------------|
| B1 | Abertura, banco e leitura | App abre com `notas.db` **antigo** (migração cria `CONF_IBSCBS` e `divergencia_ibscbs`) e com banco **novo**; processar as 3 pastas; contadores (62 autorizadas / 4 ignoradas / 2 com erro; corrigido em 11/11/2026, era "62/6/0") e cards iguais ao `notas.csv`; bloco da conferência no fim do log igual ao log do verificador; log não muda com o filtro; gravação no banco sem erro | ~6 min |
| B2 | Grade: coluna IBS/CBS | Em 1366×768, filtros Todos/55/65: situação de cada nota igual ao `divergencias.csv`; ícones e cores (normal, zebra, selecionada); dicas 16.3 a 16.8, 16.5 (910020) e 16.5a (910040/910050); ordenação por gravidade (▼/▲) | ~7 min |
| B3 | Layout e tela Relatórios | Colunas extras por prioridade em 1024×640 e 1366×768 (IBS+CBS, ICMS, Base ICMS); coluna IBS/CBS sempre visível; tela Relatórios com os 3 quadros; quadro desabilitado e dica 18.4 sem nota com IBS/CBS | ~5 min |
| B4 | Relatório Divergências e CSV | Relatório nos 3 filtros (linhas, ordem, "Total", página 2 só com os totais), caso sem divergência (ex.: só NFC-e reais); CSV com a coluna "Conferência IBS/CBS" no fim | ~7 min |
| B5 | Tela Sobre (Plano 3, etapa 3.5) | Ordem dos itens e centralização em 1024×640 e 1366×768; Tab (site, GitHub, Apoiar) e foco; dicas; links abrem no navegador; hover/pressionado; espaço dos créditos | ~3 min |

- ✅ **B1 aprovada pela bateria em 11/11/2026** (~10 min): banco antigo (desde o esquema da v1.0, `installer
otas-vazio.db`) migrado e idempotente; banco novo criado; 68 XMLs com 62/4/2; cards iguais ao gabarito nos 3 filtros; bloco da conferência (47 linhas) idêntico ao verificador e sem mudar com o filtro; `nf` com 62 linhas (OK 24, Alerta 18, Erro 19, 1 vazia) e `divergencia_ibscbs` com 44 linhas. Nenhum defeito.
- ✅ **B2 aprovada pela bateria em 11/11/2026** (~12 min): situação das 62 notas igual ao gabarito nos 3 filtros (Erro 19, Alerta 18, OK 24, vazio 1); coluna última e visível, ícones e cores iguais ao tokens 5.15 (normal, zebra, selecionada); dicas 16.3 a 16.8, 16.5 e 16.5a com o texto exato do glossário; ordenação por gravidade ▼/▲ e troca de filtro corretas. Nenhum defeito. **Não testado:** a dica 16.7 com a parte ", e há {a} indicações para conferir." (nenhuma nota de teste tem Erro e Alerta ao mesmo tempo).
- 11/11/2026: criada a NF-e sintética **910060** (1 Erro N1 + 2 Alertas N3/N4) para testar essa dica na B4. Gabarito agora com **47 divergências em 62 notas conferidas** (69 XMLs; Todos: Erro 20, só Alerta 18); as 44 linhas antigas ficaram idênticas. Verificador rodado de novo: **igual ao gabarito**. Mockups do Resumo e do relatório e exemplos do glossário atualizados para os números novos.
- ⚠️ **B3 em 11/11/2026** (~15 min): colunas extras por prioridade OK em 12 larguras (IBS+CBS juntas, ICMS, Base ICMS), sem rolagem horizontal; tela Relatórios com os 3 quadros, textos 18.1/18.2/18.2a/18.3/18.4 exatos e Tab correto; quadros desabilitados sem nota com IBS/CBS. **Defeitos:** **D2** (média) — em 1024×640 a dica ao lado do botão desabilitado (18.4 / 8.8a) fica espremida em ~40 px e cortada; **D1** (baixa) — em 1205, 1309 e 1429 px a Chave fica com 328 px (mínimo 330), sem corte visível. **Decisões do usuário:** corrigir D2 e D1 **antes da release** (o `ux-designer` define o layout da D2 e o `delphi-dev` corrige); manter os dois números diferentes nos quadros ("59 de 62 notas têm IBS/CBS" conta só notas com `IBSCBSTot`; "61 conferidas" inclui notas com IBS/CBS só nos itens) e corrigir só o mockup; a **B4 roda depois das correções**, reconferindo D2 e D1.
- 11/11/2026: layout da D2 **aprovado** — a dica do botão desabilitado (8.8, 8.8a, 18.4) fica **sempre abaixo do botão**, na largura interna toda do quadro, com os 3 quadros na mesma altura (`tokens.md` 5.16, mockup `relatorios.html#p7-desabilitado`); estados antigos do Plano 4 ficam no mockup como histórico. Mockup do quadro "Relatório IBS/CBS" corrigido para "60 de 63 notas têm IBS/CBS" (69 XMLs). Correção de D2 e D1 com o `delphi-dev`.
- 11/11/2026: D2 e D1 **corrigidos** (build sem erros nem avisos novos; ainda sem teste na tela). Decisões: o texto da dica também vai para o `Hint` do painel do quadro (tokens 5.16); a sobra de até 1 px por linha na dica de várias linhas é aceita. **A B4 fica para 12/11/2026**, com aprovação do usuário, e reconfere D2 (1024×640 e 1366×768, dicas 8.8, 8.8a e 18.4) e D1 (1205, 1309, 1429 px e 2 px acima de cada).
- 17/11/2026: a 1ª tentativa da B4 não compilou porque o Skia4Delphi do Delphi 10.2 tinha perdido `Source\` e os `.dcu` (ambiente, não código); o usuário restaurou e a B4 rodou em seguida.
- ✅ **B4 em 17/11/2026** (~17 min): relatório Divergências igual ao gabarito nos 3 filtros (47/40/7 linhas, campos "nome (tag)", totais, legendas, paginação); relatório sem divergência com a mensagem 18.26/18.27; dica da 910060 = "Erro: 1 conta de IBS/CBS não fecha com os valores do XML, e há 2 indicações para conferir." + 2ª linha; CSV com 63 linhas e a coluna no fim, igual ao gabarito; **D2 e Hint confirmados** (alturas 72/88 px em 1024 e 56/72 px em 1366, botões alinhados, hint = dica); **D1 confirmado** (Chave 330 px nos limiares e 332 px 2 px acima). Defeitos novos, todos de baixa gravidade e visuais: **D3** a legenda da tela Relatórios não sobe ao alargar a janela de uma vez (corrige ao redimensionar devagar ou trocar o filtro); **D4** a linha de contagem do relatório sai em Regular e cinza (mockup: Semibold e `CorTexto`) e há 1 linha vazia entre as legendas 18.22 e 18.23; **D5** no filtro 55 a página 2 repete os títulos das colunas sem nenhuma linha embaixo, antes do Total.
- 17/11/2026: o usuário decidiu **corrigir D3, D4 e D5 antes da release** e rodar a **B5 depois das correções**, reconferindo os três. D3, D4 e D5 **corrigidos** em 17/11/2026 (build sem erros nem avisos novos; sem teste de tela). Decisões de 18/11/2026: legendas do relatório ficam com 13 px por linha (só muda se aparecer corte); B5 aprovada.
- ⚠️ **B5 em 18/11/2026** (~20 min): **tela Sobre OK** (ordem, textos 13.7–13.8c, centralização, Tab, dicas, hover/pressionado, créditos a 16 px, URLs lançadas corretas: proxml.vercel.app, GitHub e apoia.se/proxmlferramenta); **D3 OK** (legenda sempre 20 px abaixo dos quadros); **D5 OK**; regressões OK (relatório sem divergência e cabeçalho do Relatório de Notas iguais aos de antes; 125% não testado para não mudar a escala da sessão do usuário). **D4 parcialmente OK** (Semibold/cor e espaçamento das legendas certos) mas gerou o **D6** (média): a linha de contagem sai cortada — em Todos some o "24" e o "Erro" final; em 55 e 65 somem "divergência: N" e "Erro" — porque os dois rótulos ficam mais estreitos que o texto e quebram linha escondida.
- ✅ **D6 corrigido e reconferido em 18/11/2026** (autorizado pelo usuário): rótulos da contagem sem quebra de linha e posicionados pela largura real de cada fonte (`PosicionarContagem`); linha inteira e legível nos filtros Todos (20/18/24), 55 (15/16/18) e 65 (5/2/6), a 100% e 195%; D5 continua OK. Sobra ~1–2 px a mais antes do "·" da observação (aceitável). **Não testado:** impressão em papel, PDF e escala 125%.
- ✅ **Etapa 7.5 concluída em 18/11/2026**: B1 a B5 aprovadas; defeitos D1 a D6 corrigidos e reconferidos.

### 7.6 Release v1.3.0 — `release-manager`
- README: conferência de IBS/CBS (níveis, Erro × Alerta, onde aparece) e o aviso de que Alerta é uma indicação para conferir, não uma afirmação de erro fiscal.
- VersionInfo **1.3.0** (com confirmação), setup, `ProXML.zip`, SHA-256 e Release v1.3.0. **Publicação só com o OK do usuário.**
- 18/11/2026: **preparada, aguardando a revisão do usuário** (sem commit, tag nem Release). VersionInfo 1.3.0.0 nas configurações Release e Debug (confirmado pelo usuário); build Release fora do repositório sem erros nem avisos novos e `ProXML.res` restaurado; setup (`ProXML-Setup.exe`, 13.446.205 bytes, SHA-256 `8394a89eff7bd380028d8728bd0e28c16c0e5b26e750254e5f5829146d37aa71`) e `ProXML.zip` (19.450.747 bytes, SHA-256 `083cbfa4a619277c13128278cdf7219877c5a3690976359bd5ceb151a7e95f3f`), com as mesmas 2278 entradas da v1.2.0 e o `notas.db` vazio do modelo `installer\notas-vazio.db`; README com a conferência de IBS/CBS e os links da tela Sobre; rascunho das notas da Release.
- Decisões de 18/11/2026 na revisão da 7.6: **3 commits** (1: código e docs do Plano 7 + etapa 3.5; 2: release v1.3.0 — VersionInfo, README, plano e índice; 3: Planos 5 e 8, agente `supabase-data` e `.env` no `.gitignore`); trocar antes do commit o CNPJ/CPF dos sintéticos (o CNPJ de zeros com DV válido, raiz 00.000.000, é do Banco do Brasil) por números com DV inválido de propósito, como no Plano 3 (feito em 18/11/2026: CNPJ 12345678000100 e CPF 12345678900, com gerador, XMLs, gabarito e mockups refeitos); **publicar sem teste de instalação** (script do setup igual ao da v1.2.0); README só cita o botão do Apoia.se da tela Sobre, sem link; a melhoria da dica da tela Relatórios (D2) não entra nas notas; `bin\ProXML.exe` atualizado só depois de publicar.
- ✅ **Publicada em 18/11/2026**: tag `v1.3.0` e Release "ProXML v1.3.0" no GitHub, com `ProXML-Setup.exe` (SHA-256 `8394a89eff7bd380028d8728bd0e28c16c0e5b26e750254e5f5829146d37aa71`) e `ProXML.zip` (SHA-256 `083cbfa4a619277c13128278cdf7219877c5a3690976359bd5ceb151a7e95f3f`). Commits separados: Plano 7 + etapa 3.5; release; Planos 5 e 8.

### 7.7 Atualização do site — `web-landing` (+ `ux-designer` para os prints)
Depois da Release v1.3.0 publicada:
- `index.html`: descrição, meta tags (`description`, `og:description`, `twitter:description`), JSON-LD (`description` e `softwareVersion` 1.3.0) e um card de recurso "Conferência de IBS/CBS".
- `ibs-cbs.html` e `reforma-tributaria.html`: seção explicando o que o ProXML confere (níveis 1 a 4, Erro × Alerta), sem prometer validação fiscal completa.
- `tutorial.html` e `perguntas-frequentes.html`: como ler a coluna IBS/CBS, o log e o relatório de divergências; perguntas como "O ProXML diz que a minha nota tem erro de IBS/CBS. E agora?".
- Prints: refazer o `08-notas` (grade com a coluna nova) e incluir um do relatório de divergências, com os XMLs sintéticos do site (`exemple\sinteticos-site\`, incluindo alguns com divergência).
- `download.html`: versão, tamanho e SHA-256 da v1.3.0. `sitemap.xml`: `lastmod` das páginas alteradas.
- Revisão fiscal dos textos novos pelo `nfe-fiscal` antes do commit.
- **Aceite:** site publicado na Vercel com a v1.3.0; usuário revisa as páginas alteradas.

## Melhorias anotadas para um plano futuro
- (18/11/2026, revisão fiscal da 7.7) **Alíquota da CBS de 2027:** o Senado decide a alíquota de referência até 15/12/2026 (o TCU propôs 11,3% em 28/10/2026; sem decisão do Senado vale o número do TCU). Depois da resolução, rever a D8 e a tabela `ALIQ_ANO_CBS` de `lib/uConferenciaIBSCBS.pas` (hoje 2027+ fica sem conferência de alíquota) e os textos do site e do README sobre "alíquotas que ainda dependem da alíquota de referência". O usuário decidiu tratar numa v1.3.x ou no próximo plano.
- (18/11/2026, achado da correção do D5) O Relatório de Notas e o Relatório IBS/CBS podem imprimir os títulos das colunas numa página sem linhas (só com os totais), como era o D5 do relatório Divergências. Não conferido; o usuário decidiu ver depois da v1.3.0.
- (11/11/2026, achado da B1) Com filtro 55 ou 65, os contadores e o aviso "Os totais incluem N notas de homologação… e N NF-e de entrada" do Resumo continuam valendo para a pasta inteira, enquanto os cards seguem o filtro. Comportamento existente desde a v1.1.0; o usuário decidiu **manter na v1.3.0** e avaliar depois.

## Pendências (decidir com o usuário)
- Nenhuma no momento. As dúvidas que surgirem na 7.1 (fórmula da base, casos de CST sem conferência) voltam para o usuário antes da 7.3.

## Riscos
- **Regra legal ainda em ajuste:** a NT 2025.002 e as tabelas de `cClassTrib` mudam com frequência. A tabela de regras fica isolada em `uConferenciaIBSCBS.pas` para facilitar a atualização, e o README informa a versão da NT usada.
- **Falsos positivos nos níveis 3 e 4:** por isso são Alerta. Os textos não devem afirmar que a nota está errada.
- **Desempenho:** ler todos os itens deixa a leitura mais lenta em notas com muitos itens. Medir com uma pasta de 1000+ XMLs na 7.5.
- O build pela linha de comando com o Delphi 10.2 continua sujeito aos riscos já registrados no Plano 1.
