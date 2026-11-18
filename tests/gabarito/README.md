# Gabarito de notas (NF-e 55 / NFC-e 65)

`notas.csv` traz os valores esperados que o ProXML deve exibir. O QA compara a saída do app com ele nos filtros Todos / 55 / 65.

## Como regenerar

Na pasta `tests/gabarito/`:

```
python -I gerar_gabarito.py ../../exemple ../../exemple/sinteticos -o notas.csv
```

- Aceita uma ou mais pastas; cada pasta é lida **sem recursão** (só os `*.xml` do próprio nível). Sem `-o`, grava `notas.csv` no diretório atual.
- `gerar_gabarito.py` é independente do app: usa apenas a biblioteca padrão do Python e `decimal.Decimal`.
- Os XMLs de origem **não** são versionados (a pasta `exemple/` é ignorada pelo git):
  - `exemple/`: XMLs reais (NF-e 55 em homologação e NFC-e 65);
  - `exemple/sinteticos/`: NF-e 55 sintéticas geradas pelo `nfe-fiscal` a partir de cópias das reais, com emitente/destinatário fictícios (CNPJ fictício formado por zeros + DV), `nNF` a partir de 900001 e assinatura inválida ou ausente. Cobrem `tpImp=2`, entrada (`tpNF=0`), `vBC`/`vICMS` com centavos, `cStat 150`, `cStat 110` (denegada) e dois casos que separam a regra por `cStat` da regra antiga por texto: nNF 900006 (`cStat 100` com `xMotivo` "Uso autorizado", **somada**) e nNF 900007 (`cStat 204` com `xMotivo` contendo "Autorizado o uso da NF-e", **não somada**).
- O CSV não contém CNPJ, CPF, nomes nem chaves completas. A nota é identificada pelo número e pelos 6 últimos dígitos da chave.

## Formato

- Separador `;`, ponto decimal, 2 casas, UTF-8.
- Ordenação: modelo, depois nNF, depois sufixo.

| Coluna | Origem no XML (namespace `http://www.portalfiscal.inf.br/nfe`) |
|---|---|
| arquivo_sufixo | 6 últimos dígitos de `infNFe/@Id` |
| modelo | `infNFe/ide/mod` |
| nNF | `infNFe/ide/nNF` |
| data | `infNFe/ide/dhEmi` (10 primeiros caracteres, em dd/mm/aaaa) |
| tpNF | `infNFe/ide/tpNF` (0 = entrada, 1 = saída) |
| tpImp | `infNFe/ide/tpImp` (formato do DANFE) |
| autorizada | `S` se `protNFe/infProt/cStat` é `100` ou `150` (o texto de `xMotivo` não é usado). Qualquer outro `cStat` (ex.: `110` denegada) ou XML sem `protNFe` fica `N` |
| cStat | `protNFe/infProt/cStat`; vazio se não houver `protNFe` |
| vNF, vBC, vICMS | `infNFe/total/ICMSTot/*` |
| tem_ibscbs | `S` se existe `infNFe/total/IBSCBSTot` |
| vBCIBSCBS | `total/IBSCBSTot/vBCIBSCBS` |
| vIBSUF | `total/IBSCBSTot/gIBS/gIBSUF/vIBSUF` |
| vIBSMun | `total/IBSCBSTot/gIBS/gIBSMun/vIBSMun` |
| vIBS | `total/IBSCBSTot/gIBS/vIBS` |
| vCBS | `total/IBSCBSTot/gCBS/vCBS` |
| origem | `sintetico` se o XML veio de uma pasta chamada `sinteticos`; senão `real` (vazio nas linhas TOTAL) |

- Quando `IBSCBSTot` existe mas `gIBS` ou `gCBS` estão ausentes (o XSD permite), o valor é gravado como `0.00`.
- Quando `IBSCBSTot` não existe, as colunas de IBS/CBS ficam vazias.

## Linhas TOTAL

As três últimas linhas têm `arquivo_sufixo = TOTAL` e `modelo = Todos | 55 | 65`.

- `vNF`, `vBC` e `vICMS` somam apenas as notas autorizadas.
- As colunas de IBS/CBS somam apenas as notas autorizadas **com** `IBSCBSTot`.
- `nNF` traz a quantidade de notas autorizadas no filtro.
- `tem_ibscbs` traz a quantidade de autorizadas com `IBSCBSTot`.

Os totais incluem notas reais e sintéticas. Notas com `cStat` diferente de 100/150 e XMLs sem `nfeProc`/`protNFe` aparecem como linhas, mas não entram nos totais. Se alguma regra mudar, ajuste o script e regenere o CSV.

---

# Gabarito de divergências de IBS/CBS (Plano 7)

`divergencias.csv` traz as divergências que a conferência de IBS/CBS do ProXML deve apontar (níveis 1 a 4). As regras estão em `docs/planos/plano-7-regras-ibs-cbs.md` (NT 2025.002-RTC v1.53 e LC 214/2025). O QA compara o log e o relatório "Divergências IBS/CBS" do app com este arquivo nos filtros Todos / 55 / 65.

## Como regenerar

Na pasta `tests/gabarito/`:

```
python -I gerar_divergencias.py ../../exemple ../../exemple/sinteticos ../../exemple/sinteticos-ibscbs -o divergencias.csv
```

- Mesmas regras de leitura do `gerar_gabarito.py`: pastas sem recursão, só biblioteca padrão e `decimal.Decimal`, independente do app.
- O script lê as tabelas oficiais `tabela_cst_ibscbs.csv` e `tabela_cclasstrib.csv` da própria pasta. Elas foram exportadas da tabela de Classificação Tributária do Portal SVRS (Informe Técnico 2025.002 v1.71, publicada em 30/10/2026), só com os `cClassTrib` válidos para NF-e ou NFC-e. São dados públicos. Quando a tabela mudar, exporte de novo e regenere o CSV.
- Ao final, o script mostra no console quantas notas foram conferidas e quantas divergências há por modelo e por nível.
- `exemple/sinteticos-ibscbs/` (fora do git): NF-e e NFC-e sintéticas geradas pelo `nfe-fiscal` para a etapa 7.1, com emitente e destinatário fictícios (CNPJ 12345678000100 e CPF 12345678900, ambos com dígitos verificadores inválidos de propósito, para não pertencerem a ninguém), `nNF` 910001 a 910025 (NF-e) e 910030 a 910037 (NFC-e) e assinatura e protocolo fictícios. Há um caso para cada regra dos níveis 1 a 4 e notas corretas: com redução de 60%, com diferimento, com item imune, com item monofásico, de devolução e com mais de um item. Há também uma denegada (910025) e uma NFC-e sem protocolo (910037), que ficam fora. A lista dos casos está no documento de regras (seção 11).
  - Para recriar a pasta: `python -I gerar_sinteticos_ibscbs.py ../../exemple/sinteticos-ibscbs` (na pasta `tests/gabarito/`). O gerador só usa dados fictícios e produz os mesmos arquivos, byte a byte. O gabarito não depende dele.
- Simples Nacional (NT 2026.005, decisão D17, 11/11/2026): `nNF` 910040 a 910047 (NF-e) e 910050 a 910053 (NFC-e), emitidas de 16 a 19/11/2026, com o grupo do item `IBSCBS/gTribSN` e o total `IBSCBSTot/gTribSN`. Cobrem soma certa, soma errada de `vIBSSN` e de `vCBSSN` (inclusive uma diferença de 1 centavo), item com `gTribSN` e total sem `gTribSN`, total com `gTribSN` sem item com `gTribSN`, `gTribSN` junto com `gIBSCBS` (CRT 3 com `tpRegimeIBSCBS` 2 e 3) e nota sem `IBSCBSTot`. As alíquotas do Simples são fictícias.
- Erro e Alerta na mesma nota (bateria B4, 11/11/2026): `nNF` 910060 (NF-e de 20/10/2026, 3 itens), com 1 Erro de nível 1 no item 1 (`N1-vIBSUF`) e 2 Alertas, nível 4 no item 2 (`N4-pCBS`) e nível 3 no item 3 (`N3-vBC`). Serve para a dica 16.7 do glossário com o complemento ", e há {a} indicações para conferir." e para o relatório com os dois tipos. As outras notas do gerador continuaram idênticas, byte a byte.

## O que entra

- Só notas **autorizadas** (`cStat` 100 ou 150) dos modelos 55 e 65 **com IBS/CBS**, ou seja, com algum `det/imposto/IBSCBS` ou com `total/IBSCBSTot`. Notas sem IBS/CBS e notas não autorizadas não aparecem.
- Uma linha por divergência. Nota sem divergência não aparece.
- Os casos "sem conferência" (monofásico, ano sem alíquota fixada etc.) não são divergência e não aparecem.

## Formato

- Separador `;`, ponto decimal, UTF-8. Valores com 2 casas e alíquotas com 4.
- Ordenação: modelo, nNF, chave_final, item (numérico; `total` por último), nível, regra, campo.

| Coluna | Conteúdo |
|---|---|
| modelo | `ide/mod` (55 ou 65) |
| nNF | `ide/nNF` |
| chave_final | 6 últimos dígitos de `infNFe/@Id` |
| item | `det/@nItem`, ou `total` nas divergências do nível 2 |
| nivel | 1, 2, 3 ou 4 |
| tipo | `Erro` (níveis 1 e 2) ou `Alerta` (níveis 3 e 4) |
| regra | código da regra no documento de regras (ex.: `N1-vIBSUF`, `N2-vCBS`, `N3-vBC`, `N4-pRedAliq`) |
| campo | caminho da tag conferida, relativo a `det/imposto/IBSCBS/gIBSCBS` (item) ou a `total` (nível 2). Simples Nacional: `IBSCBSTot/gTribSN`, `IBSCBSTot/gTribSN/vIBSSN` e `IBSCBSTot/gTribSN/vCBSSN` |
| valor_xml | valor lido no XML (`ausente`/`presente` quando o que se confere é a existência de um grupo) |
| valor_esperado | valor calculado pelo script, ou a situação esperada |
| origem | `sintetico` se a pasta lida começa com `sinteticos`; senão `real` |

- Tolerância: R$ 0,01 nos valores dos níveis 1 e 3, **zero no nível 2** (decisões D5 e D17; aplicada no script em 11/11/2026, sem mudar nenhuma linha antiga) e 0,0001 nas alíquotas (`pAliqEfet` e alíquotas do nível 4). Valores calculados com `ROUND_HALF_UP`. A 910042 tem diferença de 1 centavo no `vCBSSN` e só aparece com a tolerância zero.
- Simples Nacional (D17): `vIBSSN` e `vCBSSN` do total são comparados com a soma dos itens só quando `IBSCBSTot/gTribSN` existe. `pIBSSN` e `pCBSSN` não são conferidos. O item com `gTribSN` e sem `gIBSCBS` não gera o alerta N4-gIBSCBS (sugestão da dúvida D20, ainda em aberto; com a opção (b) seriam 13 linhas a mais).
- Contagem em 11/11/2026 (com a 910060): 62 notas conferidas (49 NF-e e 13 NFC-e) e 47 divergências: NF-e 40 (N1 6, N2 11, N3 12, N4 11), NFC-e 7 (N1 1, N2 4, N3 1, N4 1). Notas com Erro: 20 (NF-e 15, NFC-e 5); só com Alerta: 18 (NF-e 16, NFC-e 2). A nota com Erro e Alerta (910060) conta só em Erro. Antes da 910060: 61 notas e 44 divergências, que continuam idênticas.
- O CSV não contém CNPJ, CPF, nomes nem chaves completas.
