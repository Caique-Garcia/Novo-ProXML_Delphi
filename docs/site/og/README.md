# Imagens de prévia (Open Graph) do site

Modelos HTML das imagens `site/og-image.png` e `site/og-reforma-tributaria.png` (1200×630). Ficam fora de `site/` para não serem publicados.

- `og-base.css`: layout e cores (tokens de `docs/ui/tokens.md`); o logo vem de `docs/ui/logo/proxml-logo-escuro.svg`.
- `og-image.html` e `og-reforma-tributaria.html`: texto de cada imagem.

Versão provisória da etapa 3.1 (logo + frase). Na 3.2 entra o print 7.

## Como regenerar

No Git Bash, a partir da raiz do repositório (troque o nome do modelo e da saída para a outra imagem):

```bash
"/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" --headless --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=1 --window-size=1200,630 \
  --screenshot="$(pwd -W)/site/og-image.png" "file:///$(pwd -W)/docs/site/og/og-image.html"
```

Depois, confira se o PNG tem 1200×630 e abra a imagem para revisar o texto.
