# Gerador dos mockups do Plano 7

Refaz os blocos do Plano 7 (entre `<!-- P7:INICIO -->` e `<!-- P7:FIM -->`) em `docs/ui/mockups/` a partir dos XMLs de `exemple/` e do gabarito `tests/gabarito/divergencias.csv`. Idempotente.

Nesta pasta:

```
python -I ler.py ../../../../exemple ../../../../exemple/sinteticos ../../../../exemple/sinteticos-ibscbs
python -I gerar.py
```

- `ler.py` grava `notas.json` só com número, datas, valores e indicadores (sem nome de arquivo, chave, CNPJ, CPF ou nomes). O `notas.json` fica fora do git.
- As chaves que aparecem nos mockups são fictícias, geradas em `dados.py`.
