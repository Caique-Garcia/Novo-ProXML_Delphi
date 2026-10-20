# ProXML · Ícones (v1.1.0)

> **Etapa:** 4.1 do Plano 4 (PD-6) · **Status:** proposta, **aguardando aprovação do usuário**

## Família escolhida: Lucide

| Item | Valor |
|------|-------|
| Biblioteca | **Lucide** (`lucide-static`), uma só família para menu, botões, cards, campos e estados |
| Versão | 1.59.0 (baixada de `https://unpkg.com/lucide-static@1.59.0/icons/` em 19/10/2026) |
| Site | https://lucide.dev |
| Licença | **ISC** (ícones derivados do Feather: **MIT**). Ambas permitem uso, cópia, modificação e distribuição gratuita ou comercial, exigindo só manter o aviso de copyright e a licença |
| Arquivos no repositório | `docs/ui/icones/*.svg` (37 ícones) e `docs/ui/icones/LICENSE-lucide.txt` (texto completo das licenças ISC e MIT) |
| Crédito no app | Tela Sobre: "Ícones: Lucide (licença ISC)" (glossário 13.6). Ao empacotar a release, incluir o `LICENSE-lucide.txt` junto do executável |

**Por que Lucide e não Tabler:** as duas têm licença livre e traço de 2 px em grade de 24 px. A Lucide tem os ícones exatos que o ProXML precisa (`sheet`, `file-down`, `plug-zap`, `folder-input`, `search-x`), traço um pouco mais leve, que combina com a Segoe UI, e é a mais usada hoje (mais fácil achar um ícone novo no mesmo estilo). Tabler seria uma troca equivalente se o usuário preferir.

**Marcas:** a Lucide não tem mais ícones de marcas (GitHub, LinkedIn). Na tela Sobre o link do GitHub usa `external-link` com o texto do endereço.

## Mapa de uso

| Onde | Ícone | Arquivo | Tamanho |
|------|-------|---------|---------|
| Menu · Resumo | layout-dashboard | `layout-dashboard.svg` | 20 |
| Menu · Notas / indicador do filtro e título do Relatório de Notas (tela Relatórios) | file-text | `file-text.svg` | 20 / 16 |
| Menu · Relatórios / botão Gerar relatório | printer | `printer.svg` | 20 / 16 |
| Menu · Enviar / botão Enviar | send | `send.svg` | 20 / 16 |
| Menu · Configurações | settings | `settings.svg` | 20 |
| Cabeçalho · Sobre / faixa informativa / dicas (inclusive as da tela Relatórios) | info | `info.svg` | 16 / 20 / 14 |
| Campo da pasta | folder | `folder.svg` | 16 |
| Botão Selecionar… / Selecionar pasta… | folder-open | `folder-open.svg` | 16 |
| Estado vazio do Resumo (arrastar pasta) | folder-input | `folder-input.svg` | 48 |
| Botão Processar | play | `play.svg` | 16 |
| Botão Cancelar / Limpar busca | x | `x.svg` | 16 |
| Campo Buscar | search | `search.svg` | 16 |
| Busca sem resultado | search-x | `search-x.svg` | 48 |
| Botão Copiar chave | copy | `copy.svg` | 16 |
| Botão Gerar DANFE | file-down | `file-down.svg` | 16 |
| Botão Exportar CSV | sheet | `sheet.svg` | 16 |
| Grade vazia | inbox | `inbox.svg` | 48 |
| Card Valor Total | banknote | `banknote.svg` | 16 |
| Card Base ICMS | layers | `layers.svg` | 16 |
| Card ICMS | percent | `percent.svg` | 16 |
| Card IBS (estadual + municipal) / Relatório IBS/CBS | map | `map.svg` | 16 / 20 |
| Card CBS (federal) | landmark | `landmark.svg` | 16 |
| Sucesso (contador, faixa, log) | circle-check | `circle-check.svg` | 24 / 20 / 16 |
| Aviso (contador, faixa, log) | triangle-alert | `triangle-alert.svg` | 24 / 20 / 16 |
| Erro (contador, faixa, log) | circle-x | `circle-x.svg` | 24 / 20 / 16 |
| Erro de campo | circle-alert | `circle-alert.svg` | 14 |
| Tempo do processamento | clock | `clock.svg` | 24 |
| Confirmação discreta (Chave copiada, Configurações salvas) | check | `check.svg` | 14–16 |
| Botão ocupado (Enviando…, Testando…) | loader-circle | `loader-circle.svg` | 16 (estático) |
| Botão Testar conexão | plug-zap | `plug-zap.svg` | 16 |
| Botão Salvar | save | `save.svg` | 16 |
| Mostrar / ocultar senha | eye / eye-off | `eye.svg`, `eye-off.svg` | 16 |
| Anexo do e-mail | paperclip | `paperclip.svg` | 20 |
| Campos de e-mail | mail | `mail.svg` | 16 |
| Link do GitHub (Sobre) | external-link | `external-link.svg` | 16 |

## Cores

| Contexto | Cor do traço |
|----------|--------------|
| Menu normal | `CorTextoSecundario` |
| Menu ativo | `CorPrimaria` |
| Botão secundário, cards, ícones de ação | `CorPrimaria` |
| Botão primário | branco |
| Campos, estados vazios | `CorTextoSecundario` |
| Desabilitado | `CorTextoDesabilitado` |
| Status | `CorSucesso` / `CorAviso` / `CorErro` |
| Aviso flutuante (fundo marinho) | `CorSucessoSobreMarinho` |

## Uso no Delphi (Skia4Delphi)

- Os SVGs usam `stroke="currentColor"`, `fill="none"` e `stroke-width="2"` em `viewBox 0 0 24 24`. No `TSkSvg`, carregar o arquivo em `Svg.Source` e pintar com **`Svg.OverrideColor`** (cor do token). Sem `OverrideColor` o traço sai preto.
- Para trocar a cor por estado (hover, ativo, desabilitado), só mudar `Svg.OverrideColor`; não é preciso ter um SVG por cor.
- Tamanho: o `TSkSvg` escala o vetor; usar `Width = Height` = tamanho da tabela (a VCL multiplica pela escala de DPI).
- O comentário `<!-- @license lucide-static v1.59.0 - ISC -->` no início de cada arquivo pode ficar (o Skia ignora comentários) e ajuda a manter o aviso de licença.
- Não guardar os SVGs no `.dfm` como texto gigante se der para evitar: preferir carregar de um recurso (`.res`) ou de constantes numa unit (`ProXML.Icones.pas`), decisão do `delphi-dev`.

## Ícones atuais que saem

| Arquivo atual (`src/img`) | Uso hoje | Destino |
|---------------------------|----------|---------|
| `dolar.svg`, `moedas.svg`, `saco-de-dolar.svg` | cards | trocados por `banknote`, `layers`, `percent`, `map`, `landmark` |
| `pasta.svg` | seletor de pasta | `folder` / `folder-open` |
| `procurar.svg`, `Fechar.svg`, `linkedin.svg` | não conferido (os SVGs do `.dfm` estão embutidos no `Svg.Source`) | não entram no visual novo; o olho da senha (`SkSvg5`) passa a ser `eye`/`eye-off` |

A origem e a licença dos SVGs atuais não estão documentadas no repositório (o formato sugere bancos de ícones que exigem atribuição). Usar só Lucide resolve essa pendência. O logo (`src/img/Logo`) não muda.
