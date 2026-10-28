# ProXML · Tokens de design (v1.1.0)

> **Etapa:** 4.1 do Plano 4 (`docs/planos/plano-4-ui-ux.md`)
> **Status:** proposta, **aguardando aprovação do usuário**
> **Mockups:** `docs/ui/mockups/index.html` · **Opções para decidir:** `docs/ui/mockups/opcoes.html`
> **Ícones:** `docs/ui/icones.md` · **Textos:** `docs/ui/glossario.md`

Este arquivo é a fonte única de cores, fontes, medidas e estados dos componentes. A unit `view/ProXML.Tema.pas` (etapa 4.2) deve declarar **exatamente** estes valores, com os mesmos nomes. Nos mockups HTML as cores vêm de variáveis CSS com os mesmos nomes (`var(--CorPrimaria)` = `CorPrimaria`).

---

## 1. Paleta

Só tema claro. Identidade mantida: marinho `#171A21` e azul `#2067CA`.

| Token | Hex | `RGB()` | `TColor` (BGR) | Uso |
|-------|-----|---------|----------------|-----|
| `CorMarinho` | `#171A21` | `RGB(23, 26, 33)` | `$00211A17` | Cabeçalho, linha do cabeçalho do relatório, aviso flutuante |
| `CorMarinhoTexto` | `#C9CED6` | `RGB(201, 206, 214)` | `$00D6CEC9` | Texto secundário sobre o marinho ("Sobre") |
| `CorTextoSobreMarinho` | `#FFFFFF` | `RGB(255, 255, 255)` | `$00FFFFFF` | "Sobre" ativo e texto do aviso flutuante (17,41:1 sobre `CorMarinho`). Registrado na 4.9 (28/10/2026); já usado no app |
| `CorPrimaria` | `#2067CA` | `RGB(32, 103, 202)` | `$00CA6720` | Botão primário, item ativo, foco, links, ícones de ação |
| `CorPrimariaHover` | `#1A56AB` | `RGB(26, 86, 171)` | `$00AB561A` | Hover do primário, título da coluna ordenada |
| `CorPrimariaPressionada` | `#164A93` | `RGB(22, 74, 147)` | `$00934A16` | Botão primário pressionado |
| `CorPrimariaSuave` | `#E8F0FB` | `RGB(232, 240, 251)` | `$00FBF0E8` | Item ativo do menu, linha selecionada, segmento ativo, faixa informativa |
| `CorFundo` | `#F2F3F5` | `RGB(242, 243, 245)` | `$00F5F3F2` | Fundo da janela, título das colunas da grade |
| `CorSuperficie` | `#FFFFFF` | `RGB(255, 255, 255)` | `$00FFFFFF` | Cards, painéis, campos, grade, menu |
| `CorZebra` | `#F7F8FA` | `RGB(247, 248, 250)` | `$00FAF8F7` | Linhas pares da grade e do relatório |
| `CorBorda` | `#DADDE3` | `RGB(218, 221, 227)` | `$00E3DDDA` | Divisórias e contorno de cards/painéis (decorativo) |
| `CorBordaCampo` | `#878E9B` | `RGB(135, 142, 155)` | `$009B8E87` | Borda de campo, botão secundário e segmentado |
| `CorTexto` | `#1F2430` | `RGB(31, 36, 48)` | `$0030241F` | Texto principal e valores dos cards |
| `CorTextoSecundario` | `#5B6270` | `RGB(91, 98, 112)` | `$0070625B` | Rótulos dos cards, legendas, dicas (substitui `#ADADAD`) |
| `CorTextoDesabilitado` | `#8C93A0` | `RGB(140, 147, 160)` | `$00A0938C` | Texto e ícone de controle desabilitado |
| `CorFundoDesabilitado` | `#EDF0F4` | `RGB(237, 240, 244)` | `$00F4F0ED` | Fundo de botão/campo desabilitado |
| `CorSucesso` | `#18793A` | `RGB(24, 121, 58)` | `$003A7918` | Autorizadas, envio OK, conexão OK, "Chave copiada" |
| `CorSucessoSuave` | `#E7F4EA` | `RGB(231, 244, 234)` | `$00EAF4E7` | Fundo da faixa de sucesso |
| `CorAviso` | `#8F5600` | `RGB(143, 86, 0)` | `$0000568F` | Ignoradas, cancelado |
| `CorAvisoSuave` | `#FFF4E0` | `RGB(255, 244, 224)` | `$00E0F4FF` | Fundo da faixa de aviso |
| `CorErro` | `#C62828` | `RGB(198, 40, 40)` | `$002828C6` | Com erro, validação de campo, falha |
| `CorErroSuave` | `#FDECEA` | `RGB(253, 236, 234)` | `$00EAECFD` | Fundo da faixa de erro |
| `CorSucessoSobreMarinho` | `#7FD99A` | `RGB(127, 217, 154)` | `$009AD97F` | Ícone de confirmação no aviso flutuante (fundo marinho) |

Só nos mockups existe também `--CorTextHintSistema: #6D6D6D`, que **não vai para o tema**: representa o cinza que o Windows usa no `TextHint` (não configurável). As outras cores fixas dos HTML (barra de título, barras de rolagem, caixa de seleção e o fundo cinza da página de documentação) só imitam partes nativas do Windows.

> ⚠️ **Delphi:** `TColor` é **BGR**. `RGB()` (de `Winapi.Windows`) é uma **função** e não pode ser usada numa declaração `const`. Na `ProXML.Tema.pas`, declarar as constantes com o literal BGR da coluna `TColor` e deixar o `RGB(r, g, b)` no comentário ao lado (ex.: `CorPrimaria = TColor($00CA6720); // RGB(32, 103, 202) #2067CA`). Quem preferir `RGB()` pode usar `class var`/variáveis inicializadas no `initialization`.

### 1.1 Mudanças em relação à proposta 4.A do plano

| Token | Plano 4.A | Agora | Motivo |
|-------|-----------|-------|--------|
| `CorSucesso` | `#1E8E3E` | `#18793A` | `#1E8E3E` dá **4,21:1** no branco (abaixo de 4,5). Usado como texto nos contadores |
| `CorAviso` | `#B26A00` | `#8F5600` | `#B26A00` dá **4,24:1** no branco |
| `CorBordaCampo` | — (novo) | `#878E9B` | `CorBorda` (`#DADDE3`) tem só 1,36:1: serve para divisórias, mas borda de campo/botão precisa de 3:1 (WCAG 1.4.11) |
| `CorMarinhoTexto`, `CorZebra`, `CorTextoDesabilitado`, `CorFundoDesabilitado`, `*Suave`, `CorPrimariaPressionada`, `CorSucessoSobreMarinho` | — | novos | Estados que o plano não detalhava |

Os demais valores do plano foram mantidos (os contrastes informados no plano conferem: 5,45:1 e 6,13:1).

---

## 2. Contraste (WCAG 2.1)

Fórmula de luminância relativa da WCAG; texto exige **4,5:1** (AA). Valores calculados, não estimados.

### 2.1 Pares de texto

| Texto sobre fundo | Contraste | AA (4,5:1) | Onde |
|-------------------|-----------|------------|------|
| `CorTexto` sobre `CorSuperficie` | 15,52:1 | passa | Texto principal, valores dos cards, grade |
| `CorTexto` sobre `CorFundo` | 13,98:1 | passa | Títulos de tela, título das colunas da grade |
| `CorTexto` sobre `CorZebra` | 14,60:1 | passa | Linha zebrada |
| `CorTexto` sobre `CorPrimariaSuave` | 13,51:1 | passa | Linha selecionada, item ativo do menu, segmento ativo |
| `CorTextoSecundario` sobre `CorSuperficie` | 6,13:1 | passa | Rótulos dos cards, legendas, dicas |
| `CorTextoSecundario` sobre `CorFundo` | 5,52:1 | passa | Legendas sobre o fundo |
| `CorTextoSecundario` sobre `CorZebra` | 5,77:1 | passa | Legenda em linha zebrada |
| `CorTextoSecundario` sobre `CorFundoDesabilitado` | 5,36:1 | passa | Legenda dentro de área desabilitada |
| Branco sobre `CorPrimaria` | 5,45:1 | passa | Botão primário |
| Branco sobre `CorPrimariaHover` | 7,09:1 | passa | Botão primário em hover |
| Branco sobre `CorPrimariaPressionada` | 8,62:1 | passa | Botão primário pressionado |
| `CorPrimaria` sobre `CorSuperficie` | 5,45:1 | passa | Links, ícones de ação |
| `CorPrimaria` sobre `CorFundo` | 4,91:1 | passa | Link sobre o fundo |
| `CorPrimaria` sobre `CorPrimariaSuave` | 4,74:1 | passa | Ícone do item ativo do menu |
| `CorPrimariaHover` sobre `CorPrimariaSuave` | 6,17:1 | passa | (reserva) texto azul sobre fundo suave |
| `CorPrimariaHover` sobre `CorFundo` | 6,38:1 | passa | Título da coluna ordenada |
| Branco sobre `CorMarinho` | 17,41:1 | passa | Texto no cabeçalho e no aviso flutuante |
| `CorMarinhoTexto` sobre `CorMarinho` | 11,01:1 | passa | "Sobre" no cabeçalho |
| `CorSucessoSobreMarinho` sobre `CorMarinho` | 10,19:1 | passa | Ícone do aviso flutuante |
| `CorSucesso` sobre `CorSuperficie` | 5,48:1 | passa | Contador Autorizadas, "Configurações salvas" |
| `CorSucesso` sobre `CorSucessoSuave` | 4,83:1 | passa | Ícone na faixa de sucesso |
| `CorTexto` sobre `CorSucessoSuave` | 13,69:1 | passa | Texto da faixa de sucesso |
| `CorAviso` sobre `CorSuperficie` | 6,00:1 | passa | Contador Ignoradas |
| `CorAviso` sobre `CorAvisoSuave` | 5,51:1 | passa | Ícone na faixa de aviso |
| `CorTexto` sobre `CorAvisoSuave` | 14,24:1 | passa | Texto da faixa de aviso |
| `CorErro` sobre `CorSuperficie` | 5,62:1 | passa | Contador Com erro, mensagem abaixo do campo |
| `CorErro` sobre `CorErroSuave` | 4,92:1 | passa | Ícone na faixa de erro |
| `CorTexto` sobre `CorErroSuave` | 13,57:1 | passa | Texto da faixa de erro |

### 2.2 Componentes não textuais (WCAG 1.4.11, mínimo 3:1) e isenções

| Par | Contraste | Observação |
|-----|-----------|------------|
| `CorBordaCampo` sobre `CorSuperficie` | 3,30:1 | Borda de campo e botão secundário. **Campos sempre sobre `CorSuperficie`**: sobre `CorFundo` cai para 2,97:1 |
| `CorPrimaria` sobre `CorSuperficie` | 5,45:1 | Contorno de foco e borda do campo em foco |
| `CorErro` sobre `CorSuperficie` | 5,62:1 | Borda do campo inválido |
| `CorPrimaria` sobre `CorBorda` | 4,00:1 | Preenchimento × trilho da barra de progresso |
| `CorBorda` sobre `CorSuperficie` | 1,36:1 | Só divisórias e contorno de cards (decorativo, sem mínimo) |
| `CorTextoDesabilitado` sobre `CorFundoDesabilitado` | 2,70:1 | Controle desabilitado: **isento** pela WCAG. Por isso todo desabilitado importante tem dica visível ao lado |
| `CorTextoDesabilitado` sobre `CorSuperficie` | 3,09:1 | Item de menu desabilitado (isento) |
| Cinza do `TextHint` (≈ `#6D6D6D`) sobre branco | ≈ 5,17:1 | O `TextHint` do `TEdit` é desenhado pelo Windows (`EM_SETCUEBANNER`) com a cor do sistema; **não dá para trocar a cor**. Passa mesmo assim |

Para comparação, o rótulo atual `#ADADAD` sobre branco dá **2,24:1** (G4).

---

## 3. Tipografia

Fonte única **Segoe UI** em toda a interface **e** nos relatórios (fim do Tahoma e do Courier New).

| Estilo | `Font.Name` | `Font.Size` | Cor | Uso |
|--------|-------------|-------------|-----|-----|
| Título de tela | `Segoe UI Semibold` | 14 | `CorTexto` | "Notas", "Relatórios", "Enviar por e-mail", "Configurações" |
| Subtítulo / estado vazio | `Segoe UI Semibold` | 12 | `CorTexto` | "Nenhuma nota carregada", "Lendo os XMLs…", títulos das opções da tela Relatórios |
| Valor do card | `Segoe UI Semibold` | **13** | `CorTexto` | `R$ 1.234.567,89` (ver decisão D1: 16 pt não cabe em 1024×640) |
| Número do contador | `Segoe UI Semibold` | 16 | cor do status | 128 / 3 / 1 no Resumo |
| Corpo, campos, grade, menu | `Segoe UI` | 10 | `CorTexto` | Texto corrido, `TEdit`, `TDBGrid`, itens do menu |
| Botão, item ativo do menu, título de coluna | `Segoe UI Semibold` | 10 | conforme o componente | |
| Rótulo de campo | `Segoe UI Semibold` | 9 | `CorTexto` | "Servidor SMTP", "Para" |
| Rótulo do card, legenda, dica, log | `Segoe UI` | 9 | `CorTextoSecundario` (log em `CorTexto`) | "Valor Total", "128 notas" |
| Relatório: título | `Segoe UI Semibold` | 16 | `CorTexto` | "Relatório de Notas" |
| Relatório: dados e títulos de coluna | `Segoe UI` / `Segoe UI Semibold` | 9 | `CorTexto` | |
| Relatório: cabeçalho (período, pasta) e rodapé | `Segoe UI` | 9 / 8 | `CorTextoSecundario` | |

- **Semibold no Delphi:** usar `Font.Name := 'Segoe UI Semibold'` com `Font.Style := []`. `fsBold` em "Segoe UI" vira **Bold** (700), mais pesado que o mockup.
- Números em colunas: a Segoe UI já tem algarismos de largura igual por padrão, então os valores alinham à direita sem ajuste.
- Medidas do mockup a 96 dpi (100%): 9 pt = 12 px, 10 pt ≈ 13 px, 13 pt ≈ 17 px, 14 pt ≈ 19 px.
- Larguras medidas com a própria Segoe UI: `R$ 1.234.567,89` = 117 px em 13 pt Semibold e ~150 px em 16 pt Semibold; chave de 44 dígitos = ~308 px em 10 pt e ~264 px em 9 pt.

---

## 4. Espaçamento e medidas

Grade de **8 px** (8 / 16 / 24 / 32). **4 px** só como meio passo (rótulo → campo, ícone → texto em legenda, respiro interno dos cards).

### 4.1 Esqueleto da janela (100%, medidas da área cliente)

```text
┌────────────────────────────────────────────────────────────────────────────┐
│ CABEÇALHO  48 px  CorMarinho   [logo 152×28]                   (i) Sobre    │
├────────────────────────────────────────────────────────────────────────────┤
│ BARRA DE PASTA  56 px  CorSuperficie   padding 0/16, itens com 32 px        │
│ [📁 caminho………………………] [Selecionar…] Modelo [Todos|NF-e 55|NFC-e 65] [▶ Processar] │
├──────────────┬─────────────────────────────────────────────────────────────┤
│ MENU 200 px  │ CONTEÚDO  padding 16, espaço entre blocos 16                │
│ item 40 px   │ [card][card][card][card][card]  64 px, espaço 8, mesma largura│
│              │ [título 32 px ................ ações / busca]               │
│              │ [grade / painel da tela: cresce com a janela]              │
└──────────────┴─────────────────────────────────────────────────────────────┘
```

| Elemento | Medida | Observação |
|----------|--------|------------|
| Janela mínima | 1024×640 (`Constraints`) | Área cliente útil ≈ 1008×600 no Windows 10 a 100%. Os mockups usam essa área |
| Cabeçalho | 48 px | Antes 113 px (G2) |
| Barra de pasta | 56 px | Itens com 32 px, centralizados; espaço 8 entre itens |
| Menu lateral | 200 px fixo | Itens de 40 px, primeiro item 8 px abaixo do topo |
| Área de conteúdo | `alClient`, padding 16 | Tudo que cresce fica aqui |
| Cards | altura 64, espaço 8, padding 10 (vertical) × 12 (horizontal) | Mesma largura para os 5 (≈149 px em 1024; ≈216 px em 1366) |
| Linha de título da tela | 32 px | Título à esquerda, ações à direita |
| Botão | altura 32, padding horizontal 16, ícone 16 + espaço 8, largura mínima 96 (Processar e Salvar: 120) | |
| Campo | altura 32, padding horizontal 8 | Rótulo 4 px acima; mensagem de erro 4 px abaixo |
| Grade | título 32 px, linha 28 px | Altura definida uma vez (fora do `OnDrawColumnCell`) |
| Faixa de status | padding 12 × 16, barra lateral 4 px | |
| Ícones | 16 px (botões, campos, cards), 20 px (menu, faixas), 24 px (contadores), 48 px (estados vazios) | |

**Grade em 1024×640:** cabem ~8 linhas de dados; em 1366×768, ~13. Maximizado cresce sem limite.

### 4.2 Redimensionamento

| Bloco | `Align` | Comportamento |
|-------|---------|---------------|
| Cabeçalho, barra de pasta | `alTop` | Altura fixa; o campo da pasta estica (os botões ficam `alRight`) |
| Menu | `alLeft` | Largura fixa |
| Faixa de cards | `alTop` dentro do conteúdo | 5 painéis com a mesma largura: recalcular `Width` no `OnResize` (ou `TGridPanel` com 5 colunas de 20%) |
| Grade, log, painéis das telas | `alClient` | Crescem |
| Colunas extras da grade | — | Visíveis só com largura suficiente (decisão D3) |

Usar `Align`/`Margins`/`Padding`/`AlignWithMargins`; nada de coordenadas absolutas (risco de DPI do Delphi 10.2, seção 7 do plano).

---

## 5. Componentes e estados

Notação: **fundo / borda / texto (ícone)**.

### 5.1 Botão (`TProBotao`)

Cantos arredondados de 4 px (desenhados no `Paint` do próprio controle). Fonte 10 pt Semibold. Ícone SVG opcional à esquerda.

| Estado | Primário | Secundário | Link |
|--------|----------|------------|------|
| Normal | `CorPrimaria` / `CorPrimaria` / branco (branco) | `CorSuperficie` / `CorBordaCampo` / `CorTexto` (`CorPrimaria`) | transparente / — / `CorPrimaria`, sublinhado |
| Hover | `CorPrimariaHover` / `CorPrimariaHover` / branco | `CorFundo` / `CorBordaCampo` / `CorTexto` | sublinhado + `CorPrimariaHover` |
| Pressionado | `CorPrimariaPressionada` / idem / branco | `CorBorda` / `CorBordaCampo` / `CorTexto` | `CorPrimariaPressionada` |
| Foco (teclado) | normal + contorno 2 px `CorPrimaria` afastado 2 px do botão | idem | idem |
| Desabilitado | `CorFundoDesabilitado` / `CorBorda` / `CorTextoDesabilitado` (idem) | idem | `CorTextoDesabilitado` |
| Ocupado ("Enviando…", "Testando…") | = desabilitado, com ícone `loader-circle` **estático** e texto no gerúndio | idem | — |

Regras: um único primário por tela; Enter/Espaço acionam; o contorno de foco só aparece por teclado (como no Windows), mas pode aparecer sempre se ficar mais simples.

### 5.2 Seletor de modelo segmentado (decisão D6, sugestão B)

Três `TProBotao` em modo alternância, colados (borda sobreposta em 1 px), cantos de 4 px só nas pontas. Altura 32, padding 12.

| Estado | Visual |
|--------|--------|
| Normal | `CorSuperficie` / `CorBordaCampo` / `CorTexto` 10 pt |
| Selecionado | `CorPrimariaSuave` / `CorPrimaria` / `CorTexto` 10 pt Semibold |
| Hover (não selecionado) | `CorFundo` |
| Foco | contorno 2 px `CorPrimaria` no segmento com foco; setas ←/→ trocam |
| Desabilitado (processando) | todos `CorFundoDesabilitado` / `CorBorda` / `CorTextoDesabilitado` |

Se a decisão for o `TComboBox` (opção A): `Style = csDropDownList`, largura 128; para ter 32 px de altura é preciso `csOwnerDrawFixed` com `ItemHeight` ajustado (a borda continua a do tema do Windows).

### 5.3 Campo (`TEdit`/`TMemo` com borda própria)

Montagem: `TPanel` contêiner (cor = borda) → `TPanel` interno `CorSuperficie` → `TEdit`/`TMemo` com `BorderStyle = bsNone`. Ícone opcional à esquerda (`TSkSvg` 16 px). Sem `TShape` (E4).

| Estado | Borda | Fundo / texto | Observação |
|--------|-------|---------------|------------|
| Normal | 1 px `CorBordaCampo` | `CorSuperficie` / `CorTexto` | Dica no `TextHint` (cor do sistema) |
| Foco | 2 px `CorPrimaria` | idem | Ao passar de 1 para 2 px, reduzir 1 px do padding interno para o texto não "pular" |
| Erro | 2 px `CorErro` | idem | Mensagem 9 pt `CorErro` 4 px abaixo, com ícone `circle-alert` 14 px |
| Desabilitado | 1 px `CorBorda` | `CorFundoDesabilitado` / `CorTextoDesabilitado` | |
| Caminho da pasta (somente leitura) | como Normal | idem | Cursor de mão; clique abre o seletor; texto com reticências no meio se não couber |
| Senha | como Normal | `PasswordChar = '•'` | Ícone `eye`/`eye-off` clicável à direita, com hint |

Validação: ao sair do campo e, depois do primeiro erro, a cada digitação.

### 5.4 Caixa de seleção

`TCheckBox` nativo, 10 pt, `CorTexto`. Sem pintura própria (o Windows desenha a caixa). Rótulos: **SSL** e **TLS**.

### 5.5 Card de total

`TPanel` contêiner com `Color = CorBorda` e `Padding = 1` → `TPanel` interno `CorSuperficie` (borda de 1 px sem `TShape`). Cantos retos.

| Parte | Estilo |
|-------|--------|
| Linha 1 | ícone 16 px `CorPrimaria` + rótulo 9 pt `CorTextoSecundario` ("Valor Total", "Base ICMS", "ICMS", "IBS", "CBS") |
| Linha 2 | valor 13 pt Semibold `CorTexto`, `R$ #.##0,00`, sem quebra |
| Sem dados | valor "R$ 0,00" em 13 pt **Regular** `CorTextoSecundario` |
| Valor maior que o card | (≥ R$ 10.000.000,00 em 1024 px) reduzir para 12 pt; nunca cortar o número |

Os cards refletem **só o filtro de modelo** (PD-1). Durante o processamento ficam como estavam (PD-3).

### 5.6 Item de menu

Recomendação: itens feitos com `TProBotao` em modo "menu" (ou `TPanel` + `TSkSvg` + `TLabel`). O `TCategoryButtons` só chega a esse visual com `OnDrawButton` (pintura própria); o `delphi-dev` escolhe e avisa (plano 4.4).

| Estado | Visual |
|--------|--------|
| Normal | `CorSuperficie`, texto 10 pt `CorTexto`, ícone 20 px `CorTextoSecundario`, barra esquerda 4 px transparente |
| Hover | fundo `CorFundo` |
| Ativo | fundo `CorPrimariaSuave`, **barra esquerda 4 px `CorPrimaria`**, texto Semibold, ícone `CorPrimaria` |
| Foco (teclado) | contorno 2 px `CorPrimaria` por dentro do item; ↑/↓ movem |
| Desabilitado (processando, enviando, gerando) | texto e ícone `CorTextoDesabilitado` |

Itens: Resumo · Notas · Relatórios · Enviar · Configurações. "Sobre" fica no cabeçalho; quando a tela Sobre está aberta, nenhum item fica ativo.

### 5.7 Grade (`TDBGrid`)

| Parte | Estilo |
|-------|--------|
| Título das colunas | 32 px, fundo `CorFundo` (`Column.Title.Color`), 10 pt Semibold `CorTexto`, alinhamento igual ao dado |
| Coluna ordenada | seta ▲ (crescente) ou ▼ (decrescente) no fim do `Title.Caption`, título em `CorPrimariaHover` |
| Linha | 28 px, 10 pt `CorTexto`, divisória inferior 1 px `CorBorda` |
| Zebra | linhas pares `CorZebra` |
| Selecionada | fundo `CorPrimariaSuave` + marca de 3 px `CorPrimaria` na borda esquerda da 1ª célula; texto continua `CorTexto` |
| Valores | alinhados à direita, `R$ #.##0,00` |
| Colunas | Nº (72, direita) · Modelo (64, centro) · Data (88) · Chave (resto, mín. 330) · Valor (120) · Base ICMS (120) · ICMS (104) · IBS (88) · CBS (96) |
| Vazio | painel por cima da grade com ícone `inbox` 48 px, título 12 pt Semibold, texto 10 pt e botão secundário |
| Busca sem resultado | mesmo painel, ícone `search-x`, botão "Limpar busca" |

`DefaultDrawing = False` e pintura no `OnDrawColumnCell` (zebra, seleção, divisória). Tirar `dgColLines` e desenhar só a linha horizontal. A cor das linhas de grade nativas não é configurável no `gdsClassic`.

### 5.8 Faixa de status

`TPanel` com barra esquerda de 4 px (`TPanel` `alLeft`), ícone 20 px e texto 10 pt (`WordWrap`). Primeira frase em Semibold.

| Tipo | Fundo | Barra e ícone | Ícone |
|------|-------|---------------|-------|
| Sucesso | `CorSucessoSuave` | `CorSucesso` | `circle-check` |
| Aviso | `CorAvisoSuave` | `CorAviso` | `triangle-alert` |
| Erro | `CorErroSuave` | `CorErro` | `circle-x` |
| Informação | `CorPrimariaSuave` | `CorPrimaria` | `info` |

### 5.9 Contadores do Resumo

4 painéis iguais (`CorSuperficie`, borda `CorBorda`, **borda superior 4 px** na cor do status): ícone 24 px + número 16 pt Semibold na cor do status + rótulo 9 pt `CorTextoSecundario`. O 4º mostra o tempo total e a quantidade de arquivos lidos (neutro, borda superior `CorBorda`).

### 5.10 Barra de progresso

Não usar `TProgressBar`/`TGauge` (o tema do Windows 10 pinta de verde e ignora a cor). Trilho `TPanel` 8 px `CorBorda` + preenchimento `TPanel` `alLeft` `CorPrimaria` com largura proporcional. Texto "X de N arquivos" 10 pt abaixo.

### 5.11 Aviso flutuante ("Chave copiada")

`TPanel` `CorMarinho`, padding 8 × 16, centralizado na base da grade (16 px acima da borda), ícone `check` 16 px `CorSucessoSobreMarinho` + texto 9 pt Semibold branco. Some sozinho em 2 s (`TTimer`). Para "Configurações salvas", rótulo inline 9 pt Semibold `CorSucesso` ao lado do Salvar, 3 s.

### 5.12 Dica (hint)

Hint nativo do Windows (`ShowHint = True`), texto do glossário. Controles desabilitados não disparam hint na VCL: por isso o motivo do bloqueio aparece **também** em texto visível (tela Relatórios, Enviar) ou o hint fica no painel pai (Processar).

### 5.13 Estados de bloqueio

Durante leitura dos XMLs, envio, teste de conexão e geração de DANFE/relatório: menu, barra de pasta (campo, Selecionar, modelo, Processar) e o "Sobre" do cabeçalho ficam desabilitados. Só o botão Cancelar (quando existir) continua ativo.

### 5.14 Tela Carregando

Animação `TSkAnimatedImage` do `ProXML.FrameLoad` (160×134) centralizada, texto 12 pt Semibold com a operação e legenda 10 pt `CorTextoSecundario`. A animação atual usa ciano `#00BAFF` (decisão D10).

---

## 6. Relatórios A4 (QuickReport)

| Item | Especificação |
|------|---------------|
| Papel | A4 retrato, margens de 10 mm (38 px a 96 dpi); largura útil ≈ 718 px (190 mm) |
| Cabeçalho (só 1ª página) | 84 px (limite 90): título 16 pt Semibold; linha "Período · Modelo · quantidade"; linha "Pasta"; "ProXML" em marinho à direita; linha inferior 2 px `CorMarinho` |
| Continuação (demais páginas) | 24 px: "Relatório de Notas · Modelo: Todos · continuação" + período, 9 pt `CorTextoSecundario` |
| Títulos das colunas | 24 px, fundo `CorFundo`, 9 pt Semibold, linha inferior 1 px `CorBordaCampo`, repetidos em toda página |
| Linhas | 20 px, 9 pt, zebra `CorZebra`, linha inteira na página |
| Colunas (Notas) | Nº 52 · Mod. 36 · Data 68 · Chave ≥ 270 (resto) · Valor (R$) 92 · Base ICMS (R$) 96 · ICMS (R$) 80 |
| Colunas (IBS/CBS) | Modelo 56 · Nº 60 · Data 76 · Base IBS/CBS (R$) resto · IBS UF (R$) 96 · IBS Mun. (R$) 100 · IBS (R$) 88 · CBS (R$) 88 |
| Alinhamento | Título e dado da mesma coluna com o mesmo `Left`/`Width` e o mesmo alinhamento (números à direita) |
| Total | linha alinhada às colunas, 9 pt Semibold, linha superior 2 px `CorMarinho`, "Total · N notas"; abaixo, legenda 8 pt |
| Rodapé | 8 pt `CorTextoSecundario`, centralizado, linha superior 1 px `CorBorda`: "Gerado pelo ProXML v1.1.0 · dd/mm/aaaa hh:mm · Página X de Y" |
| Cores na impressão | só cinzas claros e marinho: legível em impressora monocromática |
| Linhas por página (128 notas) | 45 na 1ª, 48 nas seguintes → 3 páginas |

"Página X de Y" no QuickReport exige saber o total de páginas (preparar o relatório antes da visualização). Se não for viável no 10.2, usar "Página X" e registrar no plano.

---

## 7. Viabilidade em VCL 10.2 (resumo)

| Elemento do mockup | Como fazer | Limitação / alternativa |
|--------------------|-----------|-------------------------|
| Cantos arredondados | Só no `TProBotao` (`Canvas.RoundRect`) | Painéis, cards e campos com cantos retos (já assim no mockup) |
| Sombra | — | Não usada |
| Borda colorida de campo | `TPanel` contêiner com `Padding` | Sem `TShape` |
| Cor do `TextHint` | — | Cor do sistema, não configurável (passa em contraste) |
| `TComboBox` com 32 px | `csOwnerDrawFixed` | Por isso a sugestão é o segmentado (D6) |
| Barra de progresso azul | 2 `TPanel` | `TProgressBar` fica verde no tema do Windows |
| Seta de ordenação | Caractere ▲/▼ no `Title.Caption` | Sem desenho no título (o `TDBGrid` não tem evento de pintura do título) |
| Zebra / seleção / marca lateral | `OnDrawColumnCell` com `DefaultDrawing = False` | |
| Log com ícones coloridos | `TListBox` `lbOwnerDrawFixed`, `ItemHeight = 24` | Alternativa simples: `TMemo` sem ícones |
| Ícones SVG | `TSkSvg` com `Svg.OverrideColor` para pintar o traço (`currentColor` dos SVGs) | Ícone girando não é necessário (estático) |
| Aviso flutuante | `TPanel` + `TTimer` | |
| Menu com barra lateral | `TProBotao` modo menu, ou `TCategoryButtons.OnDrawButton` | `delphi-dev` decide e avisa (4.4) |
| Logo do cabeçalho | `TImage` com o PNG atual (152×28) | É raster: fica borrado em 150%. Ver dúvida "logo vetorial" |

## 8. DPI

- Todas as medidas acima são a 100% (96 dpi). Em 125%/150% a VCL escala fontes e controles; os SVGs (Skia) continuam nítidos.
- Com `PerMonitorV2` no Delphi 10.2, conferir na 4.10 se `Constraints` (1024×640) e as alturas fixas (48/56/40/64/32/28) acompanham a escala; senão, multiplicar por `CurrentPPI / 96` no código.
- O logo PNG (152×28) não escala bem: em 150% vira 228×42 borrado.
