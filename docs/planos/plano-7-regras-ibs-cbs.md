# Plano 7, etapa 7.1: regras da conferência de IBS/CBS

Documento do `nfe-fiscal` (11/11/2026). Serve de base para as etapas 7.2 (textos), 7.3 (`lib/uConferenciaIBSCBS.pas`) e 7.5 (QA). **As dúvidas da seção 10 precisam da decisão do usuário antes da 7.3.**

## 1. Fontes e versões usadas

| Fonte | Versão | Uso |
|---|---|---|
| NT 2025.002-RTC (NF-e/NFC-e) | **v1.53, outubro de 2026** (publicada em 30/10/2026; homologação até 09/11/2026, produção em 16/11/2026). Em 11/11/2026 continua sendo a última no Portal Nacional e no Portal SVRS | Leiaute dos grupos UB e W03 e regras de validação UB16-10 a UB72d-10 e W58-10. As fórmulas usadas aqui foram conferidas no texto da v1.53 e são iguais às da v1.50 |
| NT 2026.008 (Valor Líquido) | **v1.01, outubro de 2026** (publicada em 30/10/2026). PDF oficial `NT_2026.008_v1.01_RTC_ValorLiquido.pdf`, o mesmo arquivo no Portal Nacional e no Portal SVRS (SHA-256 `8134a3f1…b50090`). Substitui a v1.00, publicada em 01/10/2026 | A remoção da regra UB16-10 (base de cálculo) **continua**, e a NT diz que "a base de cálculo dos tributos deverá ser determinada de acordo com a legislação aplicável". A v1.01 **retirou** o item "Composição do valor do produto com informações de IBS e CBS": o `vProd` volta a ser informado "desconsiderados os valores de IBS, CBS e IS" (seção 6.3 e dúvida D19). Cria `prod/vUnComLiq` e `prod/vProdLiq` (0-1), `total/vProdLiqTot` e `ICMS/ICMSPrevistoPagtoAntecip/vICMSPrevisto` (só 55). A conferência não usa esses campos |
| NT 2026.005 (Simples Nacional) | v1.00, outubro de 2026 (publicada em 30/10/2026; homologação até 26/10/2026, produção em 16/11/2026) | Cria `emit/tpRegimeIBSCBS`, `det/prod/cAtivSN`, o grupo do item `IBSCBS/gTribSN` (`gIBSSN/pIBSSN`, `vIBSSN`, `gCBSSN/pCBSSN`, `vCBSSN`) e o total `IBSCBSTot/gTribSN` (`vIBSSN`, `vCBSSN`), com as regras W59h-10, W59h-20, W59i-10 e W59j-10. Orienta que o optante do Simples **sem** regime regular (CRT 1, sem `tpRegimeIBSCBS`) não informe o `gIBSCBS` e informe o `gTribSN`. Afeta a D11 (dúvida D17) |
| Tabela de CST e cClassTrib do IBS/CBS | Portal SVRS, IT 2025.002 **v1.71** (30/10/2026). Em 11/11/2026 continua sendo a última no Portal SVRS | Indicadores por CST e percentuais de redução por `cClassTrib`. Exportada para `tests/gabarito/tabela_cst_ibscbs.csv` e `tests/gabarito/tabela_cclasstrib.csv` (104 `cClassTrib` válidos para NF-e ou NFC-e) |
| LC 214/2025 (texto compilado do Planalto, com a LC 227/2026) | — | Art. 12 (base de cálculo), arts. 343, 344, 346 e 347 (alíquotas de 2026 a 2028) e art. 348 (regras de 2026) |
| ACBr local (`D:\COMPONENTE.Delphi\ACBr\Fontes\ACBrDFe`) | changelog até 21/10/2026, leiaute da NT v1.50/1.51. Ainda **não** tem os campos das NT 2026.005 e 2026.008 (`gTribSN`, `tpRegimeIBSCBS`, `cAtivSN`, `vProdLiq`, `vICMSPrevisto`) | Conferência dos caminhos: `ACBrDFe.RTC.XmlReader.pas` (`Ler_IBSCBS`, `Ler_gIBSCBS`, `Ler_IBSCBSTot`) e `ACBrDFe.RTC.XmlWriter.pas` |

**NT × ACBr:** não encontrei divergência nos caminhos usados pela conferência. Há duas diferenças que não afetam a leitura:
- o ACBr grava `pDevTrib` com 2 casas, e a NT pede 3v2-4;
- o ACBr omite `IBSCBSTot/gIBS` e `gCBS` quando todos os valores são zero. A NT permite isso (ocorrência 0-1), e as NFC-e reais vêm assim.

## 2. Mapeamento dos caminhos (modelos 55 e 65)

Namespace `http://www.portalfiscal.inf.br/nfe`. Raiz `nfeProc/NFe/infNFe`. Os caminhos são iguais nos dois modelos. O que muda entre eles são os CST/cClassTrib permitidos (seção 7.2) e alguns grupos que a NFC-e não aceita.

### 2.1 Item: `det[@nItem]/imposto/IBSCBS` (NT UB12, ocorrência 0-1)

| Caminho (relativo a `IBSCBS`) | ID NT | Tipo | Uso na conferência |
|---|---|---|---|
| `CST` | UB13 | 3 dígitos | N4 (indicadores do CST) |
| `cClassTrib` | UB14 | 6 dígitos | N4 (tabela) |
| `indDoacao` | UB14a | 0-1 | não usado |
| `gIBSCBS` | UB15 | grupo, escolha com `gIBSCBSMono`, `gTransfCred`, `gAjusteCompet` etc. | N1, N2, N3 e N4 |
| `gIBSCBS/vBC` | UB16 | 13v2 | base (N1, N2 e N3) |
| `gIBSCBS/gIBSUF/pIBSUF` | UB18 | 3v2-4 | alíquota (N1 e N4) |
| `gIBSCBS/gIBSUF/gDif/pDif`, `vDif` | UB21 a UB23 | 0-1 | N1 (vDif), N2 e N4 |
| `gIBSCBS/gIBSUF/gDevTrib/pDevTrib`, `vDevTrib` | UB24 a UB25 | 0-1 (`pDevTrib` 0-1) | N1, N2 |
| `gIBSCBS/gIBSUF/gRed/pRedAliq`, `pAliqEfet` | UB26 a UB28 | 0-1 | N1 (`pAliqEfet`) e N4 (`pRedAliq`) |
| `gIBSCBS/gIBSUF/vIBSUF` | UB35 | 13v2 | N1, N2 |
| `gIBSCBS/gIBSMun/pIBSMun`, `gDif`, `gDevTrib`, `gRed`, `vIBSMun` | UB36 a UB54 | igual ao `gIBSUF` | N1, N2 e N4 |
| `gIBSCBS/vIBS` | UB54a | 13v2 | N1, N2 |
| `gIBSCBS/gCBS/pCBS`, `gDif`, `gDevTrib`, `gRed`, `vCBS` | UB55 a UB67 | igual ao `gIBSUF` | N1, N2 e N4 |
| `gIBSCBS/gCBS/gALCZFMCBS` (`tpALCZFMCBS`, `nProcSuframa`, `pAliqEfetRegCBS`, `vTribRegCBS`) | UB66a a UB66e | 0-1 | N4 (`pCBS` esperado zero) |
| `gIBSCBS/gTribRegular` (`CSTReg`, `cClassTribReg`, `pAliqEfetRegIBSUF`, `vTribRegIBSUF`, `pAliqEfetRegIBSMun`, `vTribRegIBSMun`, `pAliqEfetRegCBS`, `vTribRegCBS`) | UB68 a UB72d | 0-1 | N1 (valores) e N4 (presença) |
| `gIBSCBS/gTribCompraGov` (`pAliqIBSUF`, `vTribIBSUF`, `pAliqIBSMun`, `vTribIBSMun`, `pAliqCBS`, `vTribCBS`) | UB82a a UB82g | 0-1, só 55 | não conferido (seção 7.4) |
| `gIBSCBSMono` (`gIBSMonoAdRem`, `gIBSMonoAdValorem`, `gCBSMonoAdRem`, `gCBSMonoAdValorem`, `vTotIBSMonoItem`, `vTotCBSMonoItem`) | UB84 a UB105b | escolha, CST 620 | sem conferência |
| `gTransfCred` (`vIBS`, `vCBS`) | UB106 a UB108 | CST 800, só 55 | sem conferência |
| `gAjusteCompet` (`competApur`, `vIBS`, `vCBS`) | UB112 a UB115 | CST 811, só 55 | sem conferência |
| `gEstornoCred` (`vIBSEstCred`, `vCBSEstCred`) | UB116 a UB118 | 0-1 | sem conferência |
| `gCredPresOper` (`vBCCredPres`, `cCredPres`, `gIBSCredPres/pCredPres`, `vCredPres`, `vCredPresCondSus`, `gCBSCredPres/...`) | UB120 a UB130 | 0-1, só 55 | N1 (vIBS) e N2 (vCredPres). Nas versões até a v1.30 o `gIBSCredPres` ficava dentro de `gIBSCBS`; a v1.53 o coloca em `IBSCBS/gCredPresOper` |
| `gCredPresIBSZFM` | UB131 a UB134 | 0-1, só 55 | sem conferência |
| `ide/gCompraGov/pRedutor` | B31 a B34 | 0-1, só 55 | N1 (`pAliqEfet` com redutor) e N4 |
| `gTribSN` | UB115a (NT 2026.005) | grupo 0-1, filho de `IBSCBS`, fora do grupo de escolha (vem depois dele) | N2 (presença) e N4 (dispensa o alerta de `gIBSCBS` ausente, D20) |
| `gTribSN/gIBSSN` | UB115b | 0-1 (o CRT 2 e o `tpRegimeIBSCBS` 3 informam só o `gCBSSN`) | ausente vale 0 na soma |
| `gTribSN/gIBSSN/pIBSSN` | UB115c | 1-1, 3v2-4 | **não conferido** (D17: depende do Anexo do Simples) |
| `gTribSN/gIBSSN/vIBSSN` | UB115d | 1-1, 13v2 | N2 (soma) |
| `gTribSN/gCBSSN` | UB115e | 1-1 | — |
| `gTribSN/gCBSSN/pCBSSN` | UB115f | 1-1, 3v2-4 | **não conferido** (D17) |
| `gTribSN/gCBSSN/vCBSSN` | UB115g | 1-1, 13v2 | N2 (soma) |

Outros campos da NT 2026.005, **não usados** pela conferência (a opção (c) da D17 não foi escolhida): `emit/tpRegimeIBSCBS` (C21a, 0-1, depois de `emit/CRT`) e `det/prod/cAtivSN` (I17d, 0-1, depois de `prod/indTot`). Eles só passam a ser lidos se a D21 for decidida pela opção (b) ou (c). O ACBr local ainda não tem nenhum desses campos, então a 7.3 lê as tags direto do XML, como já faz com o resto do `IBSCBS`.

Campos do item usados na base (nível 3, seção 6), relativos a `det`: `prod/vProd`, `prod/vFrete`, `prod/vSeg`, `prod/vOutro`, `prod/vDesc`, `imposto/ICMS/*/vICMS`, `imposto/ICMS/*/vFCP`, `imposto/ICMS/*/vICMSMono`, `imposto/ICMSUFDest/vICMSUFDest`, `imposto/ICMSUFDest/vFCPUFDest`, `imposto/PIS/*/vPIS`, `imposto/COFINS/*/vCOFINS`, `imposto/PISST/vPIS` e `indSomaPISST`, `imposto/COFINSST/vCOFINS` e `indSomaCOFINSST`, `imposto/II/vII`, `imposto/ISSQN/vISSQN`, `imposto/IS/vIS`. Na nota: `ide/dhEmi` (ano), `ide/finNFe`, `ide/tpNFCredito`, `emit/enderEmit/UF`.

### 2.2 Total: `total/IBSCBSTot` (NT W34, ocorrência 0-1)

| Caminho (relativo a `IBSCBSTot`) | ID | Soma de (item) |
|---|---|---|
| `vBCIBSCBS` | W35 | `gIBSCBS/vBC` |
| `gIBS/gIBSUF/vDif` / `vDevTrib` / `vIBSUF` | W38 a W41 | `gIBSUF/gDif/vDif` / `gIBSUF/gDevTrib/vDevTrib` / `gIBSUF/vIBSUF` |
| `gIBS/gIBSMun/vDif` / `vDevTrib` / `vIBSMun` | W43 a W46 | iguais, do `gIBSMun` |
| `gIBS/vIBS` | W47 | `gIBSCBS/vIBS` |
| `gIBS/vCredPres` / `vCredPresCondSus` | W48 / W48a | `gCredPresOper/gIBSCredPres/vCredPres` / `vCredPresCondSus` |
| `gCBS/vDif` / `vDevTrib` / `vCBS` | W51 a W56 | iguais, do `gCBS` |
| `gCBS/vCredPres` / `vCredPresCondSus` | W56a / W56b | `gCredPresOper/gCBSCredPres/...` |
| `gMono/vIBSMono`, `vCBSMono`, `vIBSMonoReten`, `vCBSMonoReten`, `vIBSMonoRet`, `vCBSMonoRet` | W57 a W59d | monofásico (sem conferência) |
| `gEstornoCred/vIBSEstCred`, `vCBSEstCred` | W59e a W59g | estorno (sem conferência) |
| `gTribSN/vIBSSN` | W59h, W59i (NT 2026.005) | `gTribSN/gIBSSN/vIBSSN` (subgrupo ausente vale 0) |
| `gTribSN/vCBSSN` | W59h, W59j (NT 2026.005) | `gTribSN/gCBSSN/vCBSSN` |
| `total/vNFTot` (fora do `IBSCBSTot`) | W60 | não conferido (a NT marca como implementação futura) |

`gIBS`, `gIBSUF`, `gIBSMun` e `gCBS` do total são opcionais no XSD. Grupo ausente vale 0, como o app já faz hoje. O `gTribSN` do total (0-1) é diferente: a **ausência** dele é conferida (W59h-10), e as somas só são comparadas quando ele vem (W59i-10 e W59j-10).

## 3. Escopo da conferência

- Entram as notas **autorizadas** (`cStat` 100 ou 150), dos modelos 55 e 65, **com IBS/CBS**: algum `det/imposto/IBSCBS` ou `total/IBSCBSTot` (decisão do usuário).
- Por item, os níveis 1 e 3 só rodam quando há `gIBSCBS`. O nível 4 roda em todo item com `IBSCBS`.
- Nota do Simples Nacional com `gTribSN` (NT 2026.005, D17): ver seção 5.1.
- Valor numérico inválido nos grupos de IBS/CBS segue a regra do Plano 1: o arquivo não é processado e o motivo vai para o log.
- A conferência só informa. Não altera totais, cards nem contadores.

## 4. Nível 1: conta do item (Erro)

Notação: `aliq(X)` é `gX/gRed/pAliqEfet` quando o `gRed` existe; senão é a alíquota do grupo (`pIBSUF`, `pIBSMun` ou `pCBS`). A NT (UB37-10, UB54-10, UB67-10, Observação 2) manda usar a `pAliqEfet` **informada**.

| Regra | Conferência | Fonte NT |
|---|---|---|
| N1-vIBSUF | `vIBSUF = vBC × aliq(IBSUF)/100 − vDif − vDevTrib` | UB37-10 (tolerância 0,01) |
| N1-vIBSMun | `vIBSMun = vBC × aliq(IBSMun)/100 − vDif − vDevTrib` | UB54-10 |
| N1-vCBS | `vCBS = vBC × aliq(CBS)/100 − vDif − vDevTrib` | UB67-10 |
| N1-vIBS | `vIBS = vIBSUF + vIBSMun`. Se o item tem `gCredPresOper/gIBSCredPres`, também se aceita `vIBSUF + vIBSMun − vCredPres` (dúvida D10) | UB54a-10 |
| N1-pAliqEfet | `pAliqEfet = p × (1 − pRedAliq/100)`, multiplicado por `(1 − pRedutor/100)` quando há `ide/gCompraGov`, em 4 casas, nas três esferas (dúvida D4) | UB27-10, UB47-10, UB66-10 |
| N1-vDif | `vDif = vBC × aliq/100 × pDif/100`, nas três esferas | UB24-10, UB42-10, UB61-10 |
| N1-vDevTrib | `vDevTrib = vBC × aliq/100 × pDevTrib/100`, só quando `pDevTrib` vem informado | UB63-10 |
| N1-vTribReg | `vTribRegIBSUF/IBSMun/CBS = vBC × pAliqEfetRegX/100` | UB72-10, UB72b-10, UB72d-10 |

Exemplo com redução de 60% (cClassTrib 200034, em 2026):
- IBS UF: pIBSUF 0,1000 → pAliqEfet 0,0400;
- IBS Mun: pIBSMun 0,0000 → pAliqEfet 0,0000;
- CBS: pCBS 0,9000 → pAliqEfet 0,3600;
- com vBC 180,00: vIBSUF 0,07, vIBSMun 0,00 e vCBS 0,65.

## 5. Nível 2: itens × totais (Erro)

| Regra | Conferência | Fonte NT |
|---|---|---|
| N2-IBSCBSTot | Item com `IBSCBS` e nota sem `IBSCBSTot` | W53-10, rejeição 1119 |
| N2-IBSCBSTot | `IBSCBSTot` informado e nenhum item com `IBSCBS` (dúvida D6) | W44-10, rejeição 1118 |
| N2-<campo> | Cada campo da tabela 2.2 é igual à soma do campo correspondente nos itens: `vBCIBSCBS`, `vDif`, `vDevTrib`, `vIBSUF`, `vIBSMun`, `vIBS`, `vCredPres`, `vCredPresCondSus` e `vCBS` | W58-10 e seguintes (rejeições 1076 a 1091) |
| N2-gTribSN | Item com `IBSCBS/gTribSN` e `IBSCBSTot` sem `gTribSN` (D17) | NT 2026.005 W59h-10, rejeição 1275 |
| N2-gTribSN | `IBSCBSTot/gTribSN` informado e nenhum item com `gTribSN` (D17) | NT 2026.005 W59h-20, rejeição 1276 |
| N2-vIBSSN | `IBSCBSTot/gTribSN/vIBSSN` = soma de `IBSCBS/gTribSN/gIBSSN/vIBSSN` dos itens. Só quando o `gTribSN` do total existe (D17) | NT 2026.005 W59i-10, rejeição 1277 |
| N2-vCBSSN | `IBSCBSTot/gTribSN/vCBSSN` = soma de `IBSCBS/gTribSN/gCBSSN/vCBSSN` dos itens. Só quando o `gTribSN` do total existe (D17) | NT 2026.005 W59j-10, rejeição 1284 |

- **`vDif`, `vDevTrib`, `vCredPres` e `vCredPresCondSus` entram.** Todos têm um equivalente direto no item (tabela 2.2), e a soma é simples. Nas notas sem esses grupos, os dois lados valem 0.
- **`gMono` e `gEstornoCred` ficam de fora nesta versão** (dúvida D14).
- Na NT, as regras de total **não** têm tolerância: a soma deve bater exatamente. Decidido na D5 e na D17: **tolerância zero em todo o nível 2**. O `gerar_divergencias.py` passou a usar zero no nível 2 em 11/11/2026; antes usava R$ 0,01, mas nenhuma linha antiga mudou. A 910042 testa a diferença de 1 centavo.
- Sem `IBSCBSTot`, a nota com itens com `gTribSN` gera só a linha N2-IBSCBSTot (W53-10), como a 910010. Não sai uma segunda linha N2-gTribSN (910047).
- `pIBSSN` e `pCBSSN` **não** são conferidos (D17). Como o `gTribSN` não tem base de cálculo, também não há conta de item (nível 1) para o `vIBSSN` e o `vCBSSN`.

### 5.1 Nota do Simples Nacional com `gTribSN` (NT 2026.005, D17)

Pela tabela 2.3 da NT 2026.005, o optante do Simples **sem** regime regular (CRT 1, sem `tpRegimeIBSCBS`) informa o `gTribSN` e **não** informa o `gIBSCBS`. O CRT 2 sem regime regular e o CRT 3 com `tpRegimeIBSCBS` 2 ou 3 informam os dois grupos.

| Nível | Item com `gTribSN` e **sem** `gIBSCBS` (CRT 1 sem regime regular) | Item com `gTribSN` **e** `gIBSCBS` |
|---|---|---|
| 1 | Não roda: não há `gIBSCBS`, e o `gTribSN` não tem base (decorre da seção 3) | Roda normalmente no `gIBSCBS` |
| 2 | Somas do `gTribSN` (N2-vIBSSN, N2-vCBSSN) e presença (N2-gTribSN). Nas somas do `gIBSCBS`, o item vale 0, então o `vBCIBSCBS` do total deve ser 0,00 | Somas do `gIBSCBS` e do `gTribSN` |
| 3 | Não roda (decorre da seção 3) | Roda normalmente |
| 4 | Roda nas regras de `cClassTrib` (tabela, CST, modelo e vigência). **Sugestão (D20):** sem o alerta N4-gIBSCBS "ausente" quando o item tem `gTribSN`. As regras de alíquota, redução e diferimento não rodam (não há `gIBSCBS`) | Roda normalmente. Ver a D21 sobre a alíquota da CBS zerada no CRT 2 |
| Linha informativa (D9) | **Sugestão (D22):** uma linha só, no resumo da conferência, com a quantidade de notas do Simples conferidas só nos totais | Nenhuma |

A nota de CRT 1 que, a partir de 16/11/2026, ainda traz `gIBSCBS` no lugar do `gTribSN` continua sendo conferida como hoje (D11). A opção (c) da D17, que alertaria esse caso, não foi escolhida.

## 6. Nível 3: base de cálculo (Alerta)

### 6.1 Fórmula proposta (por item)

```
vBC esperado = vProd + vFrete + vSeg + vOutro + vII + vIS
             − vDesc − vPIS − vCOFINS − vICMS − vFCP − vICMSMono
             − vICMSUFDest − vFCPUFDest − vISSQN
             − PISST/vPIS     (salvo indSomaPISST = 1)
             − COFINSST/vCOFINS (salvo indSomaCOFINSST = 1)
```

É a composição da **NT 2025.002 regra UB16-10**, aplicada aos campos do item. A NT usa `vServ`, que não existe no item: no item de serviço (ISSQN), o valor do serviço está no próprio `vProd`.

**Situação da regra na NT:** desde a v1.30 a UB16-10 aparece como "Implementação Futura, aguardando orientação normativa" (é assim também na v1.53). A NT 2026.008 a **removeu** na v1.00, e a v1.01 manteve a remoção: a SEFAZ nunca rejeita a nota por isso, e a NT remete à legislação. Por isso o nível 3 é Alerta, e o texto não deve afirmar que a nota está errada.

### 6.2 Base legal (LC 214/2025, art. 12)

- **Caput:** a base é o valor da operação.
- **§ 1º:** o valor da operação inclui:
  - acréscimos e ajustes (I), juros, multas e encargos (II);
  - descontos concedidos **sob condição** (III);
  - transporte cobrado pelo fornecedor (IV) → `vFrete`;
  - tributos e preços públicos, salvo os do § 2º (V) → `vII` e `vIS`;
  - demais importâncias cobradas, inclusive seguros e taxas (VI) → `vSeg` e `vOutro`.
- **§ 2º:** não integram a base:
  - o IBS e a CBS da própria operação (I);
  - o IPI (II). O `vIPI` fica fora do `vProd`, então a fórmula não o soma;
  - os descontos **incondicionais** (III) → `− vDesc`;
  - os reembolsos em operações por conta e ordem de terceiro (IV);
  - de **1º/01/2026 a 31/12/2032**, o ICMS, o ISS, o PIS/Pasep e a Cofins (V) → `− vICMS − vFCP − vICMSMono − vICMSUFDest − vFCPUFDest − vISSQN − vPIS − vCOFINS`.
- **§ 3º:** desconto incondicional é a parcela que consta do documento fiscal e não depende de evento posterior.
- **§ 7º:** na devolução, a base é a mesma da operação original.

O ICMS-ST não aparece na fórmula. Ele fica fora do `vProd` (soma só no `vNF`), então já está fora da base.

### 6.3 Anos de transição

- **2026:** saem ICMS, ISS, PIS e Cofins (todos ainda existem).
- **2027 em diante:** PIS e Cofins deixam de existir, e os campos vêm zerados ou ausentes. A fórmula não muda.
- **2029 a 2032:** ICMS e ISS diminuem, mas continuam saindo da base até 31/12/2032 (§ 2º, V).
- **2033 em diante:** os termos de ICMS e ISS deixam de existir. A tabela de regras deve permitir desligar essa subtração por ano (fica em `uConferenciaIBSCBS.pas`).
- **NT 2026.008 (conferida no PDF oficial da v1.01 em 11/11/2026):** a v1.00 previa somar o IBS e a CBS ao `vProd`. Para os campos novos, ela dava homologação em 05/10/2026 e produção em 03/11/2026. A v1.01 **retirou** essa mudança, e não só a adiou. O histórico diz: "Retirado item 'Composição do valor do produto com informações de IBS e CBS'". A introdução agora diz que o `vProd` é informado "desconsiderados os valores de IBS, CBS e IS", que o `vItem` inclui todos os tributos e que o `vNFTot` é a soma dos `vItem`. A v1.01 também mudou a implantação dos campos novos para homologação até 26/10/2026 e produção em 16/11/2026 (a NB01-30 continua com 01/02/2027 e 01/03/2027) e marcou a VB01-10 e a VB01-20 como "Implementação Futura". **A fórmula do nível 3 não muda.**
- **Trechos da v1.01 que contradizem a introdução (dúvida D19):** a observação do campo I11 (`vProd`) ainda diz que, "a partir de 2027, os valores de IBS, CBS e IS compõem o Valor Total Bruto". A VB01-10 e a VB01-20 ainda dizem "(+) vProd (contém vIBS, vCBS e vIS)", mas somam `vIBS`, `vCBS` e `vIS` mais uma vez a partir de 2027. Se valer a leitura da observação do I11, a fórmula terá de subtrair `vIBS + vCBS` do `vProd` e deixar de somar o `vIS` nas notas emitidas a partir de 2027.
- **Pagamento antecipado (dúvida D18):** a NT 2026.008 cria o `vICMSPrevisto` (só 55, com `tpNFDebito` 06 ou `tpOperGov` 4) para "permitir a correta tributação do IBS e da CBS no pagamento antecipado". Nessas notas, o ICMS a excluir da base seria o previsto, e não o `vICMS` do item.

### 6.4 Rateio de frete, seguro, outras despesas e desconto

Não há rateio a fazer. Na NF-e e na NFC-e, `vFrete`, `vSeg`, `vOutro` e `vDesc` são campos **do item** (`det/prod`), já rateados pelo emissor. O total `ICMSTot` é a soma deles, e a SEFAZ confere essa soma. A conferência usa sempre os campos do item.

### 6.5 Quando o nível 3 não roda

- Item sem `gIBSCBS` (CST 410, 620, 800, 811 etc.).
- CST 222 (redução de base) e 830 (exclusão de base). Hoje nenhum `cClassTrib` desses CST vale para a NFC-e, e o 830001 é de energia elétrica.
- Nota com `finNFe` diferente de 1 (dúvida D3). Na devolução (`finNFe` 4), a base deve ser a da operação original (§ 7º), que o XML da devolução não mostra.

### 6.6 Resultado nas notas reais

Nas NF-e reais 10432 a 10435 (CSOSN 500/102, PIS e Cofins zerados), a fórmula dá `vProd + vFrete + vOutro − vDesc`. O XML traz `vBC = vProd`:

| nNF | Item | vBC no XML | Esperado | Composição |
|---|---|---|---|---|
| 10432 | 1 | 10,00 | 12,00 | 10,00 + 3,00 − 1,00 |
| 10433 | 1 | 50,00 | 58,00 | 50,00 + 13,00 − 5,00 |
| 10434 | 1 | 70,00 | 79,00 | 70,00 + 10,00 + 9,00 − 10,00 |
| 10435 | 1 e 2 | 30,00 | 38,50 | 30,00 + 3,50 + 10,00 − 5,00 |

**As 4 divergências conhecidas se confirmam** (5 linhas, porque a 10435 tem 2 itens). Pela lei chega-se ao mesmo resultado: o frete e as outras despesas cobrados integram o valor da operação (§ 1º, IV e VI), e o desconto incondicional sai (§ 2º, III).

## 7. Nível 4: alíquota e CST (Alerta)

### 7.1 Alíquotas por ano

O ano vem de `ide/dhEmi`.

| Ano | IBS UF (`pIBSUF`) | IBS Mun (`pIBSMun`) | CBS (`pCBS`) | Fonte |
|---|---|---|---|---|
| 2025 e 2026 | **0,1000** | **0,0000** | **0,9000** | LC 214 arts. 343 e 346; NT UB18-10, UB37-10 e UB56-10 |
| 2027 e 2028 | **0,0500** | **0,0500** | alíquota de referência (art. 14) **menos 0,1 ponto percentual** | LC 214 arts. 344 e 347; NT UB18-10 e UB37-10 |
| 2029 a 2032 | parcela da alíquota de referência (transição do ICMS/ISS) | idem | alíquota de referência | resolução do Senado e lei de cada ente (EC 132/2023, ADCT) |
| 2033 em diante | alíquota de referência ou do ente | idem | idem | idem |

O nível 4 confere só as células em negrito. Nos outros anos a alíquota fica **sem conferência** (dúvida D8).

Pelo art. 348, III, as alíquotas de 2026 também se aplicam com as reduções dos regimes diferenciados. A redução vale já em 2026: pAliqEfet da CBS 0,3600 com 60%.

Exceções da NT (UB18-10, UB37-10, UB56-10):
- `cClassTrib` com tributação regular (`trib_regular = S`): `pIBSUF`, `pIBSMun` e `pCBS` esperados **0**, e o valor regular vai para `gTribRegular`;
- `gALCZFMCBS` informado: `pCBS` esperado 0;
- ZFM/ALC (exceção 3 da CBS): `pCBS` 0 aceito quando o emitente está em AC, AM, RO, RR ou AP (simplificação, dúvida D13);
- alíquota **não conferida** quando `finNFe` = 4 (devolução) ou `tpNFCredito` = 03, 04 ou 06.

### 7.2 CST (indicadores da tabela oficial v1.71)

| CST | Descrição | gIBSCBS | Redução | Diferimento | 55 | 65 | No nível 4 |
|---|---|---|---|---|---|---|---|
| 000 | Tributação integral | exige | não permite | não permite | sim | sim (só 000001) | conferido |
| 200 | Alíquota reduzida | exige | **exige** (`pRedAliq` = tabela) | não permite | sim | sim | conferido |
| 410 | Imunidade e não incidência | não permite | — | — | sim | sim | só presença do grupo e cClassTrib |
| 510 | Diferimento | exige | não permite | **exige** | sim | não | conferido (vDif no N1) |
| 515 | Diferimento com redução | exige | exige (60%) | exige | sim | não | conferido |
| 550 | Suspensão | exige | não permite | não permite | sim | não | conferido (tributação regular: alíquotas 0 e `gTribRegular`) |
| 620 | Monofásica | não (usa `gIBSCBSMono`) | — | — | sim | sim (só 620006) | **sem conferência** |
| 800 | Transferência de crédito | não (usa `gTransfCred`) | — | — | sim | não | **sem conferência** |
| 810 | Ajuste de IBS na ZFM | não | — | — | sim | não | **sem conferência** |
| 811 | Ajustes | não (usa `gAjusteCompet`) | — | — | sim | não | **sem conferência** |
| 830 | Exclusão da BC | exige | não permite | não permite | sim | não | N1, N2 e N4; sem N3 |
| 010, 011, 220, 221, 222, 400, 820 | — | — | — | — | não | não | não têm cClassTrib para NF-e/NFC-e na v1.71. Se aparecerem, geram o alerta **N4-cClassTrib** ("cClassTrib não encontrado"), porque a tabela exportada não tem esses códigos (corrigido em 11/11/2026: o texto dizia N4-cClassTribModelo; vale o que o script e a unit fazem) |

### 7.3 cClassTrib com redução (NF-e e NFC-e)

O código marcado com `*` vale só para a NF-e (55).

| Redução IBS / CBS | cClassTrib |
|---|---|
| 100% (alíquota zero) | 200002, 200003, 200004, 200005*, 200006, 200007, 200008*, 200009, 200010, 200011*, 200012, 200013, 200014, 200015, 200020, 200023*, 200053, 200054; com tributação regular: 200022*, 200024* |
| 60% | 200030, 200031, 200032, 200033, 200034, 200035, 200036, 200038, 200039*, 200043*, 515001* |
| 40% | 200047 (bares e restaurantes) |
| sem redução | 000001, 000003*, 000004*, 000005*, 410xxx, 510001*, 550xxx* (tributação regular), 620xxx, 800xxx*, 810001*, 811xxx*, 830001* |

A tabela completa (descrição, vigência e indicadores) está em `tests/gabarito/tabela_cclasstrib.csv`.

### 7.4 Regras do nível 4

| Regra | Conferência |
|---|---|
| N4-cClassTrib | `cClassTrib` existe na tabela |
| N4-CSTxcClassTrib | `cClassTrib` pertence ao CST informado (3 primeiros dígitos e coluna CST da tabela). Se falhar, as regras abaixo não rodam no item |
| N4-cClassTribModelo | `cClassTrib` permitido no modelo (colunas `nfe` e `nfce`) |
| N4-cClassTribVigencia | data de emissão dentro da vigência do `cClassTrib` |
| N4-gIBSCBS | `gIBSCBS` presente quando o CST exige; ausente quando o CST não permite |
| N4-pIBSUF / N4-pIBSMun / N4-pCBS | alíquota do ano (7.1), com as exceções |
| N4-gRed / N4-pRedAliq | CST que exige redução: `gRed` presente em cada esfera, com `pRedAliq` igual a `pRedIBS` (UF e Mun) ou `pRedCBS` (CBS) da tabela. CST que não permite: `gRed` ausente (exceção: compra governamental com `pRedAliq` 0) |
| N4-gDif | CST que exige diferimento: `gDif` presente nas três esferas. CST que não permite: `gDif` ausente. O `pDif` não é conferido, porque a tabela não traz o percentual |
| N4-gTribRegular | `gTribRegular` presente se, e só se, o `cClassTrib` tem tributação regular |

### 7.5 Casos sem conferência e texto sugerido para o log

Não são divergência: não entram no CSV nem mudam a coluna da grade (dúvida D9). Textos para a 7.2 revisar:

| Caso | Texto sugerido |
|---|---|
| CST 620 (monofásico) | `Nota Fiscal 910020, item 1: tributação monofásica (CST 620), cálculo de IBS/CBS não conferido.` |
| CST 800 / 810 / 811 | `Nota Fiscal N, item I: transferência de crédito (CST 800), cálculo de IBS/CBS não conferido.` (troca a descrição pelo CST: "ajuste de IBS na ZFM", "ajuste de competência") |
| Alíquota sem valor fixado em lei para o ano | `Nota Fiscal N, item I: alíquota de CBS de 2027 não conferida (depende da alíquota de referência).` |
| Devolução / nota de crédito 03, 04 ou 06 | `Nota Fiscal N: devolução (finNFe 4), base e alíquotas de IBS/CBS não conferidas.` |
| Compra governamental (`gTribCompraGov`) | `Nota Fiscal N, item I: compra governamental, valores sem o redutor não conferidos.` |
| Totais de monofásico / estorno (`gMono`, `gEstornoCred`) | `Nota Fiscal N: totais de IBS/CBS monofásico não conferidos.` |

### 7.6 Textos sugeridos para as divergências (para a 7.2)

| Regra | Exemplo |
|---|---|
| N1-vIBSUF / vIBSMun / vCBS | `Nota Fiscal 910003, item 1: IBS da UF 0,50, esperado 0,24 (vBC 238,13 × 0,1000%) (erro).` |
| N1-vIBS | `Nota Fiscal 910005, item 1: IBS do item 0,20, esperado 0,09 (IBS UF + IBS Mun) (erro).` |
| N1-pAliqEfet | `Nota Fiscal 910007, item 1: alíquota efetiva da CBS 0,5000%, esperado 0,3600% (0,9000% com redução de 60%) (erro).` |
| N2 | `Nota Fiscal 910009: total de CBS 12,00, soma dos itens 10,05 (erro).` / `Nota Fiscal 910010: itens com IBS/CBS e nota sem o total de IBS/CBS (erro).` |

Textos do `gTribSN` (D17), no formato das linhas 17.7 a 17.9 do glossário. São uma **proposta** para o `ux-designer` incluir no glossário (dúvida D23):

| Regra | Glossário (proposta) | Texto | Exemplo (gabarito) |
|---|---|---|---|
| N2-vIBSSN · N2-vCBSSN | 17.7a, novos `{do campo}` | do IBS do Simples Nacional · da CBS do Simples Nacional | `Nota Fiscal 910041: total do IBS do Simples Nacional R$ 1,50, soma dos itens R$ 1,20 (erro).` / `Nota Fiscal 910042: total da CBS do Simples Nacional R$ 5,34, soma dos itens R$ 5,33 (erro).` |
| N2-gTribSN (total ausente) | 17.8a | `Nota Fiscal {n}: itens com IBS/CBS do Simples Nacional e nota sem o total do Simples Nacional (gTribSN) (erro).` | Nota Fiscal 910043, 910053 |
| N2-gTribSN (sem itens) | 17.9a | `Nota Fiscal {n}: total do Simples Nacional (gTribSN) informado e nenhum item com IBS/CBS do Simples Nacional (erro).` | Nota Fiscal 910044 |
| Relatório, coluna Campo (18.C) | N2 | IBS SN (vIBSSN) · CBS SN (vCBSSN) · Total Simples Nacional (gTribSN) | valores "ausente"/"presente" no N2-gTribSN |
| Resumo (D22, sugestão) | 17.23b | `Conferência de IBS/CBS: {x} notas do Simples Nacional conferidas só nos totais (gTribSN).` | `llAviso`, sem contar como divergência. Singular: "1 nota do Simples Nacional conferida só nos totais (gTribSN)." |
| N3-vBC | `Nota Fiscal 10435, item 1: base IBS/CBS 30,00, esperado 38,50 (alerta).` |
| N4-alíquota | `Nota Fiscal 910014, item 1: alíquota do IBS da UF 0,0500%, esperado 0,1000% em 2026 (alerta).` |
| N4-redução | `Nota Fiscal 910016, item 1: redução da CBS de 40%, esperado 60% para o cClassTrib 200034 (alerta).` |
| N4-CST | `Nota Fiscal 910019, item 1: cClassTrib 200034 não pertence ao CST 000 (alerta).` |

## 8. Arredondamento e tolerância

- **Valores (13v2):** a NT não define o modo de arredondamento. Só manda "aceitar uma tolerância de 0,01 a mais ou a menos" em todas as contas do item (UB37-10, UB54-10, UB67-10, UB24-10, UB72-10 etc.). O ACBr não calcula IBS/CBS: grava o que o emissor informa. O gabarito calcula com `ROUND_HALF_UP` em 2 casas, item a item. Com a tolerância de 0,01, os modos usuais (meio para cima, meio para o par e truncamento) dão o mesmo resultado. Exemplo: o item 2 da 910001 tem vBC 25,00 × 0,1% = 0,025, gravado 0,02, e não gera divergência.
- **Alíquota efetiva:** "4 casas decimais, com arredondamento na última casa" (UB27-10). O gabarito usa `ROUND_HALF_UP` em 4 casas e tolerância 0,0001.
- **A tolerância de R$ 0,01 é adequada para os níveis 1 e 3**: é a da NT, e o arredondamento é por item.
- **No nível 2**, a NT não dá tolerância. A soma de valores de 2 casas é exata, e 0,01 pode esconder um erro de 1 centavo no total (dúvida D5).

## 9. Casos de borda nos XMLs reais (`exemple\`)

| Situação | Notas |
|---|---|
| NF-e 55 com `IBSCBSTot` completo (`gIBS` com `vDif`, `vDevTrib` e `vCredPres` zerados) | 10432 a 10442 (11 notas, homologação, `tpAmb` 2) |
| NFC-e 65 com `IBSCBSTot` **só com `vBCIBSCBS`** (sem `gIBS`/`gCBS`, porque os valores são 0,00) | nNF 20 e 21: `vBC` 0,01 → IBS e CBS 0,00. Nível 2 OK, com os grupos ausentes valendo 0 |
| NFC-e com o mesmo nNF em dois arquivos (um sem `protNFe`) | nNF 21 e 22: fica só a autorizada |
| NFC-e sem nenhum IBS/CBS | nNF 22 (as duas): fora da conferência |
| Todas as reais: CRT 1 (Simples Nacional), CST 000, cClassTrib 000001, sem `gRed`/`gDif`/`gDevTrib`/`gCredPresOper`, alíquotas 0,1000 / 0,0000 / 0,9000 | níveis 1, 2 e 4 OK em todas (dúvida D11) |
| Base = `vProd`, ignorando frete, outras despesas e desconto | 10432 a 10435 → nível 3 (seção 6.6) |
| NFC-e com `PISAliq` com `pPIS` 1,65 e `vPIS` 0,00 | nNF 20 e 21: nada a subtrair |
| Namespaces | todos os XMLs usam o namespace padrão da NF-e, sem prefixo |
| `exemple\sinteticos\` (Plano 1) | 900001 e 900002: base = `vProd` (como as reais). 900003 (CRT 3, ICMS00): vBC 10.289,67, que é `vProd − vDesc` sem tirar o ICMS de 1.234,76 → esperado 9.054,91 (nível 3). 900005 (cStat 110) e 900007 (cStat 204) ficam fora |

## 10. Dúvidas para o usuário decidir

As sugestões estão marcadas com **(sugestão)**. O gabarito atual foi gerado com todas as sugestões.

✅ **Decididas em 11/11/2026:** o usuário aceitou a **sugestão (a) em todas as 16 dúvidas** (D1 a D16). O gabarito não precisa ser gerado de novo. Pela D16, o `nfe-fiscal` confere o PDF oficial da NT 2026.008 v1.01 antes da etapa 7.3.

- **D1. Fórmula da base (nível 3).** (a) Composição da UB16-10 da NT, com a exclusão de ICMS, PIS, Cofins, ISS e FCP do art. 12, § 2º, V **(sugestão)**. (b) Só `vProd + vFrete + vSeg + vOutro − vDesc`, sem tirar tributos. Teria menos alertas, mas contraria a lei em 2026 e não pegaria a 900003. (c) Não conferir a base, já que a NT removeu a regra. *As 4 reais aparecem em (a) e (b).*
- **D2. PIS-ST e Cofins-ST na base.** (a) Seguir a NT ao pé da letra: subtrair, salvo `indSomaPISST`/`indSomaCOFINSST` = 1 **(sugestão: é a única fórmula oficial)**. (b) Nunca subtrair, já que o ST não está no `vProd`. Caso raro.
- **D3. Nível 3 nas notas que não são "normais".** (a) Só `finNFe` = 1 **(sugestão)**: complementar, ajuste, crédito e débito têm base própria, e na devolução a base é a da operação original (art. 12, § 7º). (b) Também na devolução (`finNFe` 4).
- **D4. Nível de `pAliqEfet`, `vDif`, `vDevTrib` e `vTribReg`.** (a) Nível 1 / Erro, porque são contas objetivas com os valores do próprio XML e a NT rejeita **(sugestão)**. (b) Nível 4 / Alerta, como o plano sugeria para o `pAliqEfet`. O `pRedAliq` contra a tabela fica no nível 4 nas duas opções.
- **D5. Tolerância do nível 2.** (a) **Zero** no nível 2, como na NT (W58-10), mantendo R$ 0,01 nos níveis 1 e 3 **(sugestão)**. (b) R$ 0,01 em tudo, o padrão do plano. *O gabarito não muda entre (a) e (b).*
- **D6. `IBSCBSTot` sem nenhum item com `IBSCBS`.** (a) Erro de nível 2, como na NT (rejeição 1118) **(sugestão)**. (b) Ignorar.
- **D7. Uma linha por esfera no nível 4.** Quando o problema aparece no IBS UF, no IBS Mun e na CBS (ex.: `gRed` ausente), (a) uma linha por esfera, como no gabarito **(sugestão: igual às rejeições da NT e mais fácil de comparar)**, ou (b) uma linha só por item.
- **D8. Alíquotas depois de 2026.** (a) Conferir só o que a lei fixa: IBS 0,05 + 0,05 em 2027-2028. A CBS de 2027 em diante e o IBS de 2029 em diante ficam sem conferência até serem publicados, e então a tabela da unit é atualizada **(sugestão)**. (b) Deixar a tabela de alíquotas configurável pelo usuário. (c) Não conferir alíquotas depois de 2026.
- **D9. Casos sem conferência no log.** (a) Uma linha informativa (`llAviso`) **por nota**, listando os itens, sem contar como divergência e sem mudar a coluna da grade **(sugestão)**. (b) Uma linha por item. (c) Nada no log.
- **D10. Crédito presumido no `vIBS`.** A NT subtrai o `vCredPres` só quando o `cCredPres` tem `indDeduzCredPres` = 1, um indicador da tabela cCredPres (Anexo IV) que não temos. (a) Aceitar as duas formas **(sugestão)**. (b) Obter e embutir a tabela cCredPres.
- **D11. Simples Nacional em 2026.** O art. 348, III, diz que as alíquotas de teste não se aplicam aos optantes do Simples. Mesmo assim a NT valida as alíquotas de quem preenche o grupo, e todas as reais são CRT 1. (a) Conferir normalmente **(sugestão)**. (b) Não conferir nota com CRT 1 ou 4. (c) Conferir só os níveis 1 e 2.
- **D12. Valor numérico inválido nos grupos do item.** (a) Manter a regra do Plano 1: arquivo não processado **(sugestão)**. (b) Processar a nota e marcar a conferência como Erro.
- **D13. Exceção ZFM/ALC da CBS.** (a) Simplificada: não alertar `pCBS` 0 quando o emitente está em AC, AM, RO, RR ou AP **(sugestão)**. (b) Completa: municípios de emitente e destinatário e NCM, como na NT.
- **D14. Monofásico, estorno e compras governamentais.** (a) Sem conferência na v1.3.0, com a linha informativa da D9 **(sugestão)**. (b) Conferir já os totais `gMono`/`gEstornoCred` (soma simples) e o `gTribCompraGov` (tolerância de 0,04 da UB82a-20).
- **D15. Desconto.** O XML não diz se o `vDesc` é condicional ou incondicional. (a) Tratar o `vDesc` como incondicional, que sai da base (art. 12, § 3º) **(sugestão)**. (b) Não subtrair. Por isso o nível 3 é Alerta.
- **D16. NT 2026.008 (IBS/CBS dentro do `vProd`).** A v1.00 previa isso, e a v1.01 (30/10/2026) teria retirado, segundo fontes secundárias. (a) Manter a fórmula atual e conferir o PDF da v1.01 antes da 7.3 **(sugestão)**. (b) Já prever no código a subtração do IBS/CBS do `vProd` a partir de 03/2027.
  - **Conferida em 11/11/2026** no PDF oficial da v1.01, que é o mesmo arquivo no Portal Nacional da NF-e e no Portal SVRS: a mudança foi **retirada**, e não adiada, e a remoção da UB16-10 continua. A fórmula atual fica, e o gabarito não muda. Na conferência surgiram as dúvidas D17 a D19, ✅ **decididas em 11/11/2026 com a sugestão (a)**: D17 conferir no nível 2 a soma do `gTribSN` dos itens contra o total, sem tolerância e sem conferir `pIBSSN`/`pCBSSN`; D18 nada a fazer além da linha informativa; D19 seguir a introdução da NT 2026.008 v1.01 (`vProd` sem IBS/CBS/IS) e conferir a próxima versão da NT antes de 01/2027. **Impacto na 7.3:** os sintéticos e o gabarito precisam ganhar casos de `gTribSN` (certo e com soma errada).

✅ **D17 a D19 decididas em 11/11/2026 com a sugestão (a)** (texto original abaixo). A D17 foi aplicada em 11/11/2026: mapeamento (2.1 e 2.2), nível 2 (seção 5 e 5.1), textos (7.6), sintéticos 910040 a 910053 (seção 11) e gabarito (seção 12). D18 e D19 não mudam o gabarito: nenhum XML de teste tem `vICMSPrevisto`, `tpNFDebito` ou `tpOperGov`, e nenhum foi emitido em 2027.

- **D17. Simples Nacional depois da NT 2026.005 (produção em 16/11/2026).** O optante do Simples sem regime regular (CRT 1, como todas as notas reais) passa a informar `IBSCBS/gTribSN` e deixa de informar o `gIBSCBS`. A NT não cria regra que rejeite o `gIBSCBS` nesse caso. (a) Manter a D11 como está (conferir o `gIBSCBS` quando ele vier) e incluir no nível 2 a soma do `gTribSN` dos itens contra o total (W59h-10, W59h-20, W59i-10 e W59j-10, sem tolerância). O `pIBSSN` e o `pCBSSN` não seriam conferidos, porque dependem do Anexo do Simples **(sugestão)**. (b) Manter a D11 e deixar o `gTribSN` para depois da v1.3.0, com a linha informativa da D9. (c) Também alertar quando a nota com CRT 1 e sem `tpRegimeIBSCBS`, emitida a partir de 16/11/2026, trouxer `gIBSCBS`. Em (a) e (c), o `uConferenciaIBSCBS.pas` precisa ler campos que o ACBr local ainda não tem.
- **D18. Pagamento antecipado (`tpNFDebito` 06 ou `tpOperGov` 4).** (a) Nada a fazer: a nota com `tpNFDebito` 06 tem `finNFe` 6 e já fica fora do nível 3 (D3), e a `tpOperGov` 4 é compra governamental (D14). Só registrar o caso na linha informativa **(sugestão)**. (b) No nível 3, usar o `vICMSPrevisto` no lugar do `vICMS` quando o grupo vier.
- **D19. Contradição na NT 2026.008 v1.01.** A introdução diz que o `vProd` não contém IBS, CBS e IS. A observação do campo I11 e as regras VB01-10 e VB01-20 ("vProd contém vIBS, vCBS e vIS") dizem o contrário a partir de 2027. Não decidi. (a) Seguir a introdução e o histórico ("Retirado item"), que são o trecho mais explícito e o que foi revisto na v1.01, e conferir a próxima versão da NT antes de 01/2027 **(sugestão)**. (b) Seguir a observação do I11 e já prever no código a subtração do IBS/CBS do `vProd` a partir de 2027. (c) Desligar o nível 3 nas notas a partir de 2027 até a NT ficar clara.

⚠️ **Em aberto (surgiram na aplicação da D17, em 11/11/2026).** O gabarito foi gerado com as sugestões.

✅ **D20 a D24 decididas em 11/11/2026 com a sugestão (a):** D20 não alertar a ausência do `gIBSCBS` no item com `gTribSN`; D21 não conferir o `pCBS` no item com `gCBSSN` e sem `gIBSSN`; D22 uma menção única na linha de resumo da conferência; D23 o `ux-designer` inclui os textos novos no glossário (padrão do projeto, aplicado sem pergunta); D24 gerador versionado em `tests/gabarito/gerar_sinteticos_ibscbs.py`.

- **D20. Conflito entre a NT 2025.002 e a NT 2026.005 sobre o `gIBSCBS` no Simples.** A UB13-40 da NT 2025.002 v1.53 (rejeição 1022) exige o `gIBSCBS` quando o CST tem `ind_gIBSCBS` = 1, como o CST 000. A tabela 2.3 da NT 2026.005 diz "Não informar" o `gIBSCBS` para o CRT 1 sem regime regular, mas a coluna tem a nota "(\*) informar o grupo gIBSCBS caso seja exigido pelo CST". A NT 2026.005 não muda a UB13-40, e nenhuma das duas cria CST próprio para o Simples. Não decidi qual prevalece. (a) Não alertar a falta do `gIBSCBS` quando o item tem `gTribSN`, seguindo o texto da tabela 2.3 e a D17 ("conferir o `gIBSCBS` quando ele vier") **(sugestão)**. (b) Alertar sempre (N4-gIBSCBS, seguindo a UB13-40 e a nota de rodapé). Nesse caso, toda nota de CRT 1 a partir de 16/11/2026 teria um alerta por item: +13 linhas de nível 4 nos sintéticos novos (910040 ×2, 910041 ×2, 910042, 910043, 910047, 910050 ×2, 910051 ×2, 910052 e 910053).
- **D21. Alíquota da CBS no CRT 2 sem regime regular.** A tabela 2.3 manda informar o `gCBS` "com alíquota zerada" (a CBS vai no `gCBSSN`). No CRT 3 com `tpRegimeIBSCBS` 3, que também informa só o `gCBSSN`, a tabela **não** fala em alíquota zerada. Hoje o N4-pCBS esperaria 0,9000% em 2026 e alertaria o CRT 2. (a) Não conferir o `pCBS` no item que tem `gTribSN/gCBSSN` e não tem `gIBSSN` **(sugestão: evita falso alerta enquanto a NT é ambígua)**. (b) Esperar `pCBS` 0 só no CRT 2 sem `tpRegimeIBSCBS`, ao pé da letra (a 7.3 passa a ler o `emit/CRT` e o `tpRegimeIBSCBS`). (c) Esperar 0 nos dois casos. Nenhum sintético tem CRT 2. A 910046 (`tpRegimeIBSCBS` 3, `pCBS` 0,9000) fica sem divergência em (a) e (b) e ganha um N4-pCBS em (c).
- **D22. Linha informativa do Simples.** Os itens com `gTribSN` e sem `gIBSCBS` ficam sem os níveis 1 e 3 e sem a alíquota do nível 4. Pela D9, isso viraria uma linha por nota, e, a partir de 16/11/2026, quase toda nota de quem é do Simples (todas as reais são CRT 1) teria essa linha. (a) Uma linha só, junto do resumo (17.23), com a quantidade de notas **(sugestão)**. (b) Uma linha por nota (D9), com o motivo "itens {i} (Simples Nacional, gTribSN)". (c) Nada no log. Não muda o gabarito: as linhas informativas não entram no CSV. Os textos ficam com o `ux-designer`.
- **D23. Textos novos no glossário.** (a) O `ux-designer` inclui no glossário (17.7a, 17.8a, 17.9a, 17.23b e 18.C) os textos propostos na seção 7.6 **(sugestão: o glossário é dele)**. (b) O `nfe-fiscal` inclui agora.
- **D24. Onde guardar o gerador dos sintéticos.** O `gen_sint.py` fica só no scratchpad da sessão, que pode se perder. (a) Versionar uma cópia em `tests/gabarito/gerar_sinteticos_ibscbs.py`. O gerador não tem dado real, e os XMLs continuam fora do git **(sugestão)**. (b) Manter só no scratchpad.

## 11. XMLs sintéticos (`exemple\sinteticos-ibscbs\`, fora do git)

Gerados por `tests/gabarito/gerar_sinteticos_ibscbs.py` (versionado pela D24; antes ficava só no scratchpad como `gen_sint.py`), a partir da estrutura das notas reais. Emitente e destinatário fictícios (CNPJ 12345678000100 e CPF 12345678900, ambos com dígitos verificadores inválidos de propósito, para não pertencerem a ninguém; até 18/11/2026 eram números de zeros com DV válido, trocados porque o CNPJ é do Banco do Brasil), assinatura e protocolo fictícios, CRT 3 com ICMS00, PIS e Cofins (salvo indicação). As notas 910001 a 910037 são de 10/2026. As notas 910040 a 910053 (D17) são de 16 a 19/11/2026, depois da entrada em produção da NT 2026.005. Nelas, as alíquotas do Simples são fictícias (`pIBSSN` 0,4000 e `pCBSSN` 1,6000) e o `cAtivSN` é 01. Ao acrescentar essas notas, o gerador continuou produzindo as 33 notas anteriores idênticas, byte a byte. A nota 910060 (11/11/2026, bateria B4) é de 20/10/2026 e junta Erro e Alerta na mesma nota, em itens diferentes, para conferir a dica 16.7 com o complemento ", e há {a} indicações para conferir." (glossário 16.6 e 16.7) e o relatório com os dois tipos. Ao acrescentá-la, as 45 notas anteriores continuaram idênticas, byte a byte. Hoje o gerador versionado é `tests/gabarito/gerar_sinteticos_ibscbs.py`.

| nNF | Mod | Caso | Divergência esperada |
|---|---|---|---|
| 910001 | 55 | 3 itens, frete/desconto/outras; item 2 com 0,025 gravado 0,02 | nenhuma |
| 910002 | 55 | item 1 com redução de 60% (200034) e item 2 integral | nenhuma |
| 910003 | 55 | vIBSUF do item 1 errado | N1-vIBSUF |
| 910004 | 55 | vCBS do item 2 errado | N1-vCBS |
| 910005 | 55 | vIBS ≠ vIBSUF + vIBSMun | N1-vIBS |
| 910006 | 55 | redução de 60%, vCBS com pCBS cheio | N1-vCBS |
| 910007 | 55 | pAliqEfet da CBS 0,5000 (esperado 0,3600) | N1-pAliqEfet |
| 910008 | 55 | total vBCIBSCBS ≠ soma | N2-vBCIBSCBS |
| 910009 | 55 | totais vIBSUF e vCBS ≠ soma | N2-vIBSUF, N2-vCBS |
| 910010 | 55 | itens com IBSCBS e sem IBSCBSTot | N2-IBSCBSTot |
| 910011 | 55 | IBSCBSTot sem gIBS, itens com IBS | N2-vIBSUF, N2-vIBS |
| 910012 | 55 | item 1 com vBC = vProd (frete, outras, desconto, ICMS) | N3-vBC |
| 910013 | 55 | vBC = vProd, com IPI | N3-vBC |
| 910014 | 55 | pIBSUF 0,05 em 2026 | N4-pIBSUF |
| 910015 | 55 | pCBS 0,80 em 2026 | N4-pCBS |
| 910016 | 55 | 200034 com pRedAliq 40 | N4-pRedAliq (×3) |
| 910017 | 55 | CST 000 com gRed no IBS UF | N4-gRed |
| 910018 | 55 | 200034 sem gRed | N4-gRed (×3) |
| 910019 | 55 | cClassTrib 200034 com CST 000 | N4-CSTxcClassTrib |
| 910020 | 55 | item 1 monofásico (620006), item 2 integral | nenhuma (sem conferência) |
| 910021 | 55 | diferimento de 100% (510001) | nenhuma |
| 910022 | 55 | devolução (`finNFe` 4) com pIBSUF 0,05 | nenhuma (exceção da NT) |
| 910023 | 55 | item imune (410999, sem gIBSCBS) e item integral | nenhuma |
| 910024 | 55 | CRT 1 (CSOSN 102), vBC = vProd, como nas reais | N3-vBC |
| 910025 | 55 | denegada (cStat 110) com erro | fora |
| 910030 | 65 | 3 itens com desconto | nenhuma |
| 910031 | 65 | vIBSUF do item 1 errado | N1-vIBSUF |
| 910032 | 65 | total vCBS ≠ soma | N2-vCBS |
| 910033 | 65 | vBC = vProd | N3-vBC |
| 910034 | 65 | pIBSMun 0,05 em 2026 | N4-pIBSMun |
| 910035 | 65 | redução de 60% (200035), 2 itens | nenhuma |
| 910036 | 65 | CRT 1, IBSCBSTot só com vBCIBSCBS, valores zerados | nenhuma |
| 910037 | 65 | sem protocolo, com erro | fora |
| 910040 | 55 | CRT 1 sem regime regular: 2 itens só com `gTribSN` (sem `gIBSCBS`), total com `gTribSN` certo e `vBCIBSCBS` 0,00 | nenhuma (com a D20 (a)) |
| 910041 | 55 | CRT 1, total `vIBSSN` 1,50 e soma 1,20 | N2-vIBSSN |
| 910042 | 55 | CRT 1, total `vCBSSN` 5,34 e soma 5,33 (1 centavo) | N2-vCBSSN (tolerância zero) |
| 910043 | 55 | CRT 1, item com `gTribSN` e `IBSCBSTot` sem `gTribSN` | N2-gTribSN (W59h-10) |
| 910044 | 55 | CRT 3, nenhum item com `gTribSN` e total com `gTribSN` zerado | N2-gTribSN (W59h-20) |
| 910045 | 55 | CRT 3 com `tpRegimeIBSCBS` 2: `gIBSCBS` e `gTribSN` nos 2 itens | nenhuma |
| 910046 | 55 | CRT 3 com `tpRegimeIBSCBS` 3: `gIBSCBS` e `gTribSN` só com `gCBSSN` (total `vIBSSN` 0,00) | nenhuma (ver D21) |
| 910047 | 55 | CRT 1, item com `gTribSN` e nota sem `IBSCBSTot` | só N2-IBSCBSTot |
| 910050 | 65 | CRT 1, 2 itens só com `gTribSN`, `IBSCBSTot` com `vBCIBSCBS` 0,00 e `gTribSN` certo | nenhuma (com a D20 (a)) |
| 910051 | 65 | CRT 1, total `vIBSSN` 0,40 e soma 0,42 | N2-vIBSSN |
| 910052 | 65 | CRT 1, total `vCBSSN` 1,00 e soma 1,04 | N2-vCBSSN |
| 910053 | 65 | CRT 1, item com `gTribSN` e `IBSCBSTot` sem `gTribSN` | N2-gTribSN (W59h-10) |
| 910060 | 55 | Erro e Alerta na mesma nota, 3 itens: item 1 com vIBSUF 0,90 (esperado 0,22); item 2 com pCBS 0,80 em 2026 (contas coerentes); item 3 com vBC = vProd (ignora frete, desconto e tributos); totais = soma dos itens | N1-vIBSUF (item 1), N4-pCBS (item 2), N3-vBC (item 3) |

## 12. Resultado do gabarito (`tests/gabarito/divergencias.csv`)

Gerado de `exemple`, `exemple\sinteticos` e `exemple\sinteticos-ibscbs`. Notas conferidas: 49 NF-e e 13 NFC-e (antes da D17: 40 e 9; antes da 910060: 48 e 13).

| Filtro | N1 | N2 | N3 | N4 | Total | Notas com Erro | Notas só com Alerta |
|---|---|---|---|---|---|---|---|
| 55 | 6 | 11 | 12 | 11 | 40 | 15 | 16 |
| 65 | 1 | 4 | 1 | 1 | 7 | 5 | 2 |
| Todos | 7 | 15 | 13 | 12 | 47 | 20 | 18 |

As reais têm 5 linhas de nível 3 (10432, 10433, 10434 e os 2 itens da 10435). Os sintéticos do Plano 1 têm 3 (900001, 900002 e 900003). Os sintéticos desta etapa têm 39: 28 da 7.1, 8 da D17 e 3 da 910060.

A nota com Erro e Alerta conta só em "Notas com Erro" (como no app). A 910060 é a única nota do gabarito com os dois tipos; por isso "Notas com Erro" sobe para 20 e "Notas só com Alerta" fica em 18.

**D17 (11/11/2026):** antes, o gabarito tinha 36 linhas (N2: 6 na NF-e, 1 na NFC-e). As 36 linhas continuam idênticas e na mesma ordem. Entraram 8 linhas, todas de nível 2 e Erro: 910041 N2-vIBSSN, 910042 N2-vCBSSN, 910043 N2-gTribSN, 910044 N2-gTribSN, 910047 N2-IBSCBSTot, 910051 N2-vIBSSN, 910052 N2-vCBSSN e 910053 N2-gTribSN. Com a D20 (b), seriam +13 linhas de nível 4 (N4-gIBSCBS).

**910060 (11/11/2026, bateria B4):** as 44 linhas anteriores continuam idênticas e na mesma ordem. Entraram 3 linhas da 910060: item 1 N1-vIBSUF (Erro, 0.90 x 0.22), item 2 N4-pCBS (Alerta, 0.8000 x 0.9000) e item 3 N3-vBC (Alerta, 150.00 x 115.34). Linha de resumo 17.23 esperada: "Conferência de IBS/CBS: 62 notas conferidas, 20 com Erro e 18 com Alerta; 9 do Simples Nacional, sem conferir base e alíquota."
