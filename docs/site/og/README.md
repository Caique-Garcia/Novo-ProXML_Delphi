# Imagens de prévia (Open Graph) do site

Modelos HTML das imagens `site/og-image.png` e `site/og-reforma-tributaria.png` (1200×630). Ficam fora de `site/` para não serem publicados.

- `og-base.css`: layout e cores (tokens de `docs/ui/tokens.md`); o logo vem de `docs/ui/logo/proxml-logo-escuro.svg` e o print 7 de `site/img/07-resumo.webp`.
- `og-image.html`: logo, frase e o print 7 inteiro.
- `og-reforma-tributaria.html`: logo, título e os cards IBS e CBS recortados do print 7 por CSS (`.cards` em `og-base.css`: região x 885–1343, y 145–222 do print, ampliada 2x). Se o print 7 mudar de tamanho ou de layout, confira essa região.

Versão da etapa 3.2 (10/11/2026), com o print 7.

## Como regenerar

No Git Bash, a partir da raiz do repositório (troque o nome do modelo e da saída para a outra imagem):

```bash
"/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" --headless --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=1 --window-size=1200,630 --virtual-time-budget=3000 \
  --screenshot="$(pwd -W)/site/og-image.png" "file:///$(pwd -W)/docs/site/og/og-image.html"
```

O `--virtual-time-budget` dá tempo para o WebP do print carregar antes da captura. Depois, confira se o PNG tem 1200×630 e abra a imagem para revisar o texto.
