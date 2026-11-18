# ProXML · Ícones (v1.1.0)

> **Etapa:** 4.1 do Plano 4 (PD-6) · **Status:** proposta, **aguardando aprovação do usuário**

## Família escolhida: Lucide

| Item | Valor |
|------|-------|
| Biblioteca | **Lucide** (`lucide-static`), uma só família para menu, botões, cards, campos e estados |
| Versão | 1.59.0 (baixada de `https://unpkg.com/lucide-static@1.59.0/icons/` em 19/10/2026) |
| Site | https://lucide.dev |
| Licença | **ISC** (ícones derivados do Feather: **MIT**). Ambas permitem uso, cópia, modificação e distribuição gratuita ou comercial, exigindo só manter o aviso de copyright e a licença |
| Arquivos no repositório | `docs/ui/icones/*.svg` (37 ícones; 38 com o `list-checks` do Plano 7) e `docs/ui/icones/LICENSE-lucide.txt` (texto completo das licenças ISC e MIT) |
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
| Link do site (Sobre, Plano 3, v1.2.1) | external-link | `external-link.svg` | 16 |
| Botão "Apoiar no Apoia.se" (Sobre, Plano 3, v1.2.1) | heart (sugestão; alternativa `hand-heart`, só no mockup) | `heart.svg` | 16 |
| Coluna IBS/CBS da grade · OK (Plano 7) | circle-check | `circle-check.svg` | 16 |
| Coluna IBS/CBS da grade · Alerta (Plano 7) | triangle-alert (decisão P7-2) | `triangle-alert.svg` | 16 |
| Coluna IBS/CBS da grade · Erro (Plano 7) | circle-x | `circle-x.svg` | 16 |
| Log do Resumo · divergência Erro / Alerta / sem conferência (Plano 7) | circle-x / triangle-alert / triangle-alert | já existentes (`llErro`, `llAviso`) | 16 |
| Quadro "Divergências IBS/CBS" da tela Relatórios (Plano 7, novo) | list-checks | `list-checks.svg` | 20 |

**Plano 7 (v1.3.0, 11/11/2026):** o único ícone novo é o `list-checks`, baixado de `https://unpkg.com/lucide-static@1.59.0/icons/list-checks.svg` (mesma versão e licença ISC dos outros). Total: 38 ícones. A coluna IBS/CBS reaproveita o trio de status do Resumo (`circle-check`, `triangle-alert`, `circle-x`): o usuário vê o mesmo ícone na grade e no log para a mesma situação, e o triângulo do Alerta se distingue dos círculos pela forma, não só pela cor. **Aguardando aprovação do usuário.**

**Plano 3, etapa 3.5 (v1.2.1, 11/11/2026):** ícone novo `heart`, baixado de `https://unpkg.com/lucide-static@1.59.0/icons/heart.svg` (mesma versão e licença ISC dos outros; o aviso `@license` ficou no arquivo). Total: 39 ícones. A alternativa `hand-heart` (mesma origem) aparece só no mockup `sobre.html` (opção C) e não foi adicionada à pasta. **Aguardando aprovação do usuário.**

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

## Site (`site/`)

Os cards de funcionalidades da página inicial (`site/index.html`) usam os mesmos ícones Lucide (`lucide-static` v1.59.0, licença ISC), colocados como SVG inline com `stroke="currentColor"`, 24 px, cor `--link` e `aria-hidden="true"`. Não há arquivo SVG separado para o site.

| Card | Ícone Lucide |
|------|--------------|
| NF-e e NFC-e na mesma pasta | `folder-open` |
| Filtro por modelo | `layers` |
| Só notas autorizadas nos totais | `circle-check` |
| Totais de ICMS, IBS e CBS | `percent` |
| DANFE e DANFCe em PDF | `file-text` |
| Relatórios e CSV para o Excel | `sheet` |
| Envio dos XMLs por e-mail | `mail` |
| Instala sem administrador | `file-down` |
| Seus XMLs ficam no seu computador | `hard-drive` (não existe em `docs/ui/icones`, só no site) |
