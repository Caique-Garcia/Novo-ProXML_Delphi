# Plano 8 — Apuração de Antecipação e DIFAL de ICMS nas entradas interestaduais (MG)

> **Status:** 📝 Aprovado em 17/11/2026. É um plano **separado da sequência**: começa só **depois do Plano 7** (v1.3.0) ser concluído. A versão de saída será definida na abertura (provável v1.4.0, empurrando o chat do Plano 5).
>
> **Origem:** proposta em [`docs/funcionalidade_nova.md`](../funcionalidade_nova.md). **Análise fiscal** (fontes, fórmulas, cenários e dúvidas): [plano-8-analise-fiscal-icms-mg.md](plano-8-analise-fiscal-icms-mg.md).

## Objetivo
Ao processar uma pasta, o ProXML identifica as **NF-e (55) de compra interestadual** destinadas à empresa do usuário em **MG**, classifica cada item pela **finalidade** (revenda, industrialização, uso e consumo, ativo imobilizado), calcula por item a **antecipação** (Simples Nacional) e o **DIFAL** (todos os regimes), gera a **memória de cálculo** e apresenta tela, totais e relatórios para conferência.

**Princípio (igual ao Plano 7):** o ProXML **indica valores para conferência**, não substitui o contador. Toda conta mostra a regra aplicada e os parâmetros usados.

## Correções em relação ao documento da proposta
| Documento | Correto (ver análise fiscal) |
|---|---|
| Exemplo dá R$ 60,00 (fórmula "base simples") | MG usa **base "por dentro"** desde 2016: **R$ 73,17** para DIFAL e antecipação (RICMS/MG art. 12, VI e XII, §8º) |
| Banco MariaDB | O app usa **SQLite** local (`notas.db`, FireDAC) + **Supabase** só para as regras (decisão abaixo) |
| ST no Anexo VIII | No RICMS/2023 a ST está no **Anexo VII** |
| Antecipação para todos os regimes | Em MG a antecipação geral vale **só para ME/EPP do Simples Nacional** (art. 3º, VII). Regime normal: só DIFAL |
| Classes `uICMS*.pas` com DAO | Mantidas como ideia; nomes finais seguem o padrão do projeto (abaixo) |

## Decisões do usuário (17/11/2026)
| Tema | Decisão |
|---|---|
| Abrangência | **Só destinatário em MG.** Outras UFs ficam para um próximo plano |
| Regimes | **Simples Nacional, Lucro Presumido e Lucro Real** (MEI tratado como Simples) |
| ICMS-ST | **Só identificar e alertar** (CST/CSOSN, `vICMSST`, CEST/NCM do Anexo VII); item com ST sai da antecipação/DIFAL. Cálculo de ST fica para outro plano |
| Finalidade | **Sugestão por CFOP** (+ `indFinal`) e **classificação gravada** por *CNPJ do fornecedor + código do produto* (`cProd`); na próxima importação já vem classificado. Sem certeza → "Necessita de classificação" |
| Empresa | **Cadastro em Configurações:** CNPJ, UF e regime da empresa usuária |
| Persistência local | Tabelas novas no `notas.db`: classificação de produtos (permanente) e resultado da apuração (refeito a cada processamento, com memória de cálculo) |
| Regras e tabelas | **Supabase, somente leitura** (RLS + chave publicável). Notas e dados das notas **ficam só no computador**; ao Supabase vão apenas consultas de regras |
| Sem internet | **Cópia local só de leitura** da última consulta bem-sucedida, com versão e data; sem conexão a apuração roda com a cópia e avisa "tabelas de DD/MM/AAAA". O instalador traz uma cópia inicial |
| Manutenção das regras | **O usuário (autor)**, pelo painel do Supabase ou por scripts de carga versionados no repo. O app nunca escreve no Supabase |
| Tela | **Nova tela "Apuração ICMS"** no menu lateral + quadros novos na tela **Relatórios** |
| ICMS de origem | **Teórico** (alíquota interestadual × V, art. 12, VI, "c"), mostrando o `vICMS` destacado ao lado e alertando quando diferem |
| Redução de base interna (Anexo II) | **Mostrar as duas contas, identificadas:** "Nota Técnica SEF" e "RICMS literal". **Totais e relatórios usam a da Nota Técnica SEF** |
| FEM (+2 p.p.) | Vigência **até 31/12/2026** (Lei 24.471/2023). Se a prorrogação passar, só a data muda no Supabase |
| Devoluções | **Fora da fase 1** (só aviso no log) |
| Período | **Data de emissão** (data de entrada fica para a fase 2) |

### Padrões adotados (podem ser revistos na 8.1)
- Arredondamento **por item, 2 casas, meio para cima**, em cada etapa; total = soma dos itens.
- **Composição da base configurável por regra**; padrão: antecipação = vProd + vFrete + vSeg + vOutro − vDesc (**sem IPI**); DIFAL = a mesma soma **+ IPI**.
- **Alíquota interestadual derivada** de `orig` (1, 2, 3, 8 → 4%; demais → 12%; com destino MG nunca 7%), com **alerta** quando o `pICMS` do XML for diferente.
- Alíquota interna: **18% + exceções por NCM** vindas do Supabase (Anexo I grupos 2, 4, 8, 9, 10 e FEM).
- DIFAL só com `dest/indIEDest = 1`. NFC-e (65), MG→MG, notas não autorizadas e saídas ficam fora da apuração.
- A apuração **não muda** os totais, cards e contadores atuais. Ela só soma os seus próprios totais (antecipação e DIFAL).

### Dúvidas que ficam para o contador (8.1)
Marcadas como **Pendente** até decisão; não bloqueiam o desenvolvimento: D11 (MEI), D15 (subitens 4.13 a 4.15 do Anexo I), lista exata dos NCM do FEM, e se o desconto do XML pode ser tratado como incondicional. Detalhes na [análise fiscal](plano-8-analise-fiscal-icms-mg.md), seção 8.

## Fórmula (MG, art. 12, VI, aplicada também à antecipação pelo §8º)
```text
ICMS origem  = aliqInterestadual × V            (teórico)
Base         = (V − ICMS origem) ÷ (1 − aliqInterna)
Valor        = max(0, Base × aliqInterna − ICMS origem)
aliqInterna  = alíquota do Anexo I (+ 2 p.p. do FEM quando vigente)
```
Exemplo: V 1.000; interna 18%; interestadual 12% → origem 120,00; base 1.073,17; **73,17**.

## Arquitetura

```text
Supabase (só leitura, RLS)          notas.db (SQLite local)
 regra_icms, aliquota_ncm,           empresa (Configurações)
 fem_ncm, st_cest_ncm,               classificacao_produto (permanente)
 versao_tabelas                      cache_regras_* (cópia só leitura)
        │ REST (THTTPClient)         apuracao_icms_item (refeita a cada leitura)
        ▼                                     ▲
 lib/uRegrasICMSRemoto.pas  ──►  lib/uRegrasICMS.pas (cache + seleção da regra
                                   por especificidade e vigência)
                                            │
 lib/uCalculadoraXML.pas (thread de leitura)│
   └─ leitura própria dos itens ICMS ──► lib/uApuracaoICMS.pas
        (independe do grupo IBSCBS)          (classifica, calcula, memória;
                                              sem tela e sem banco)
                                            │
 view/ProXML.FormPrincipal (tela "Apuração ICMS")
 view/ProXML.FormRelatorioAntecipacao / RelatorioDIFAL / ResumoICMS (QuickReport)
```

- `uApuracaoICMS.pas` segue o padrão de `uConferenciaIBSCBS.pas`: **sem acesso à tela nem ao FireDAC**, testável por um verificador de console.
- A consulta ao Supabase **não roda na thread de leitura**: as regras são carregadas (remoto → cache) **antes** de iniciar a leitura e passadas como snapshot.
- A chave publicável do Supabase vai em configuração do build (não versionada em claro no repo; `.env` local). Nenhum dado de nota, CNPJ ou chave sai do computador.

## Etapas

### 8.1 Regras fiscais, cenários e gabarito — `nfe-fiscal`
- Partir da [análise fiscal](plano-8-analise-fiscal-icms-mg.md). Reconfirmar a legislação vigente na data de início (RICMS/MG, Anexos I, II e VII, status do FEM).
- Escrever `plano-8-regras-icms-mg.md`: mapeamento de tags do item (orig, CST/CSOSN, vBC, pICMS, vICMS, vICMSST, vFrete, vSeg, vOutro, vDesc, vIPI, CFOP, NCM, CEST, indIEDest, indFinal, idDest), árvore de decisão (fora / ST / DIFAL / antecipação / pendente), tabela CFOP → finalidade sugerida, textos de situação (Pendente, Calculado, Conferido, Ignorado, Sem regra, Necessita de classificação, Verificar ST).
- Montar os **dados iniciais** das tabelas (CSV em `tests/gabarito/icms/` ou `supabase/seed/`): alíquotas internas de MG por NCM, NCM do FEM com vigência, CEST/NCM do Anexo VII para o alerta, regras AN/DI por regime e finalidade.
- Gerar os **21 XMLs sintéticos** da análise (seção 7) em `exemple\sinteticos-icms\` (fora do git), com script `gerar_sinteticos_icms.py`.
- Gerar o gabarito `tests/gabarito/apuracao_icms.csv` (nota, item, tipo, finalidade, base, alíquotas, origem teórico/destacado, valor, valor alternativo da redução, situação) com `gerar_apuracao_icms.py` (`python -I`, `Decimal`).
- **Aceite:** regras, textos e dúvidas pendentes aprovados pelo usuário; gabarito reproduz 73,17 / 170,73 / 80,49 / 205,48 e os casos zero.

### 8.2 Supabase: esquema, segurança e carga — `supabase-data` (novo)
- Projeto Supabase criado **pelo usuário** (o agente não cria conta nem guarda segredos).
- Migrações SQL versionadas em `supabase/migrations/`: `regra_icms` (tipo AN/DI, uf_destino, regime, finalidade, ncm, cfop, cst, aliq_interna, aliq_interestadual, tipo_base, modo_icms_origem, prioridade, dt_inicio, dt_fim, ativo, fundamento_legal), `aliquota_ncm`, `fem_ncm`, `st_cest_ncm`, `versao_tabelas`.
- **RLS:** `select` liberado para `anon` só nas linhas ativas; nenhuma política de escrita para `anon`. Carga por script com a chave de serviço **local** (nunca no app nem no git).
- Scripts de carga a partir dos CSVs da 8.1 e um comando de verificação (`curl` na API REST) que confirma leitura e bloqueio de escrita.
- Gerar o **arquivo de cópia inicial** (JSON) que o instalador leva.
- **Aceite:** consulta REST com a chave publicável devolve as tabelas; tentativa de `insert/update/delete` com a chave publicável é recusada; versão registrada em `versao_tabelas`.

### 8.3 Textos e tela — `ux-designer`
- Glossário: menu "Apuração ICMS", situações, mensagens (sem internet, tabelas de DD/MM, empresa não configurada, Verificar ST, Pendente do contador), memória de cálculo (com as duas contas da redução identificadas "Nota Técnica SEF" e "RICMS literal").
- Mockups: tela Apuração ICMS (resumo com totais de antecipação e DIFAL; grade por item com filtros por situação/tipo; painel da memória de cálculo; classificação da finalidade em massa e por item), campos novos em Configurações (CNPJ, UF, regime), quadros novos na tela Relatórios e os 3 relatórios A4 (antecipação, DIFAL, resumo por período/fornecedor/UF/documento/tipo).
- **Aceite:** textos e mockups aprovados pelo usuário.

### 8.4 Regras remotas e cache — `delphi-dev`
- `lib/uRegrasICMSRemoto.pas`: leitura REST com `System.Net.HttpClient` (THTTPClient, TLS 1.2), timeout curto, sem bloquear a tela.
- `lib/uRegrasICMS.pas`: modelo das regras, seleção por **vigência + especificidade + prioridade**, cópia local só de leitura no `notas.db` (`cache_*` + versão/data), fallback para a cópia e para a cópia inicial do instalador.
- `DM.pas`: migração idempotente das tabelas `empresa`, `classificacao_produto`, `apuracao_icms_item` e `cache_*`; `DeleteDados` **não** apaga `classificacao_produto` nem o cache.
- Configurações: CNPJ, UF e regime da empresa, com validação.
- **Aceite:** build sem erros nem avisos novos; com e sem internet as regras carregam (aviso com a data quando vier do cache); banco antigo migra.

### 8.5 Motor da apuração — `delphi-dev`
- `uCalculadoraXML.pas`: **leitura própria dos itens para o ICMS** (hoje `LerNotaIBSCBS` pula itens sem `IBSCBS`), na thread de leitura, só para NF-e 55 com `idDest=2`, destinatário = empresa configurada, UF destino MG.
- `lib/uApuracaoICMS.pas`: árvore de decisão da 8.1, classificação (gravada → sugerida por CFOP → pendente), fórmula de MG em inteiros/centavos, ICMS de origem teórico + destacado, as duas contas da redução, alertas (ST, alíquota divergente, devolução), memória de cálculo como texto estruturado.
- `tests/conferencia/`: verificador de console da apuração (mesmo padrão do Plano 7), comparando com `apuracao_icms.csv`.
- **Aceite:** build OK; verificador **igual ao gabarito**; totais atuais continuam iguais a `notas.csv` e `divergencias.csv`.

### 8.6 Tela, classificação e relatórios — `delphi-dev`
- Tela "Apuração ICMS" conforme mockups: resumo, grade por item, filtros, memória de cálculo, classificação da finalidade (por item e em massa) gravando em `classificacao_produto` e recalculando na hora.
- Cards de antecipação e DIFAL no Resumo; linhas no log.
- Relatórios QuickReport: `FormRelatorioAntecipacao`, `FormRelatorioDIFAL`, `FormRelatorioResumoICMS`, como quadros da tela Relatórios; CSV da apuração.
- **Aceite:** build OK; tela e relatórios mostram o que está no gabarito; reclassificar um item muda o resultado e persiste após reprocessar.

### 8.7 Revisão e testes — `qa-reviewer`
- Revisão do diff (regras × 8.1, RLS/segurança: nenhuma chave de serviço no exe/repo, nenhum dado de nota enviado; migração; `.dfm`; textos do glossário).
- Testes **só com o OK do usuário** ([regra do projeto](../../.claude/agents/qa-reviewer.md)), baterias pequenas e sequenciais, cada uma com estimativa de tempo:
  | # | Bateria | O que confere |
  |---|---|---|
  | B1 | Banco e regras | banco antigo/novo; Supabase on/off (cache e cópia inicial); Configurações |
  | B2 | Apuração | sintéticos × `apuracao_icms.csv`; regressão `notas.csv`/`divergencias.csv` |
  | B3 | Tela e classificação | grade, filtros, memória, reclassificação persistente |
  | B4 | Relatórios e CSV | 3 relatórios e CSV contra o gabarito |
- **Aceite:** baterias aprovadas; sem defeitos abertos de severidade média ou alta.

### 8.8 Validação com o contador — usuário (+ `nfe-fiscal`)
- Rodar com XMLs reais de compra de uma empresa de MG; o contador confere a memória de cálculo de uma amostra; dúvidas Pendentes viram regra no Supabase.
- **Aceite:** amostra conferida sem divergência não explicada.

### 8.9 Release — `release-manager`
- README (apuração, limites: só MG, ST só alerta, devoluções fora, "indicação para conferência"), cópia inicial das regras no setup (`installer-engineer` se o `.iss` mudar), VersionInfo com confirmação, Release. **Publicação só com o OK do usuário.**

### 8.10 Site — `web-landing` (+ `ux-designer` para prints)
- Card "Apuração de antecipação e DIFAL (MG)" e página explicativa, sem prometer apuração fiscal completa.

## Agentes
| Agente | Etapas |
|---|---|
| `nfe-fiscal` | 8.1, apoio na 8.8 |
| `supabase-data` (**novo**, `.claude/agents/supabase-data.md`) | 8.2 |
| `ux-designer` | 8.3, prints da 8.10 |
| `delphi-dev` | 8.4, 8.5, 8.6 |
| `qa-reviewer` | 8.7 |
| `installer-engineer` | 8.9 (cópia inicial das regras no setup) |
| `release-manager` | 8.9 |
| `web-landing` | 8.10 |

## Fora do escopo (próximos planos)
Outras UFs de destino; cálculo de ICMS-ST (MVA, protocolos); dedução de devoluções; data de entrada; frete FOB por CT-e; DIFAL do remetente (EC 87, destinatário não contribuinte); histórico de apurações por período; crédito do ativo via CIAP.

## Regra geral
Nenhum agente decide regra fiscal ou escopo sozinho. Divergência normativa vira dúvida para o usuário/contador, com a sugestão do agente destacada.
