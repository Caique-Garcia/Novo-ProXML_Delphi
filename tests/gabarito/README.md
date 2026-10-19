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
