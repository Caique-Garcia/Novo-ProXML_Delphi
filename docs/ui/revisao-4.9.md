# ProXML · Revisão visual (etapa 4.9)

> **Plano:** `docs/planos/plano-4-ui-ux.md`, etapa 4.9 · **Autor:** `ux-designer` · **Data:** 28/10/2026
> **Base:** app compilado no HEAD `24091f0`, prints automáticos a 100% em 1024×640 e 1366×768 (só a área cliente), comparados com os mockups aprovados (`docs/ui/mockups/*.html`, renderizados em 1024 e 1366), `tokens.md` e `glossario.md`.
> **Status:** **proposta, aguardando aprovação do usuário.** Nada aqui altera `glossario.md`, `tokens.md` ou os mockups. Os textos novos estão marcados como **proposta**.

**Descontado (vem do ambiente de teste):** caminho longo do scratchpad no campo da pasta e nas legendas; `127.0.0.1:<porta>` e respostas do servidor SMTP local (ex.: "530 5.7.0 QA autenticacao obrigatoria", "535 5.7.8 QA senha recusada"); "v1.0.0" no rodapé do relatório A4; ausência da barra de título; mensagem padrão do e-mail vazia nas Configurações de teste; 125%/150% (ficam para a 4.10). Os prints com chaves e nomes reais foram descritos só pelo layout.

**Resultado geral:** o app está muito próximo dos mockups em todas as telas e estados da seção 4.D. Não encontrei nada 🔴. Ficaram 2 itens 🟠 (um deles depende de confirmação na IDE) e ajustes finos 🟡.

Legenda: 🔴 bloqueia a release · 🟠 corrigir antes da 4.10 · 🟡 ajuste fino (pode ser aceito como está).
Pasta dos prints: `…\scratchpad\teste49\capturas\` (abaixo, só o nome do arquivo).

---

## 1. Tabela de ajustes

| # | Tela / estado | Print | O que está diferente (mockup / tokens / glossário) | Ajuste sugerido | Sev. | Resp. |
|---|---------------|-------|----------------------------------------------------|-----------------|------|-------|
| A1 | Barra de pasta, campo vazio (Resumo vazio, Notas vazio, Relatórios sem dados, Enviar sem notas, pasta não encontrada) | `49-resumo-vazio-1024.png`, `49-notas-vazio-1024.png`, `49-relatorios-sem-dados-1024.png`, `49-enviar-sem-notas-1024.png`, `49-resumo-pasta-nao-encontrada-2.14-1024.png` (e os 1366) | O campo da pasta aparece **vazio, sem o `TextHint` 2.2** ("Selecione ou arraste uma pasta com XMLs de Nota Fiscal"). No mockup o hint aparece. Nos mesmos prints outros `TEdit` mostram o hint (Buscar, "Para" desabilitado), então não parece ser falha da captura | Conferir na IDE. Causa provável: o campo recebe o foco ao abrir (o Windows esconde o *cue banner* de campo com foco quando `EM_SETCUEBANNER` é enviado com `wParam = 0`, que é o que a VCL do 10.2 faz). Opções: (a) não dar o foco inicial ao campo da pasta (foco no botão Selecionar… ou no menu); ou (b) reenviar `EM_SETCUEBANNER` com `wParam = 1` (mostra o hint mesmo com foco). Sugestão: **(a)**, mais simples. Se a causa for `ReadOnly` ou outra, avisar antes de mudar | 🟠 | delphi-dev |
| A2 | Notas · com dados / nota selecionada / chave copiada | `49-notas-com-dados-1024.png`, `49-notas-com-dados-1366.png`, `49-notas-selecionada-1024.png` | Com 19 notas e só 10 (1024) ou 15 (1366) linhas visíveis, a faixa da barra de rolagem da grade aparece como uma tira lisa `CorBorda` (#DADDE3), **sem o polegar**. No mockup a barra nativa aparece com o polegar | **Confirmar na IDE** (a captura por `PrintWindow` às vezes não desenha a barra de rolagem). Se no app também faltar o polegar: a grade precisa mostrar a barra vertical nativa (`ScrollBars = ssVertical` ou `ssBoth`) e não pintar por cima dela. Se for só da captura, o item cai | 🟠 (se confirmado) | delphi-dev |
| A3 | Resumo · pasta não encontrada (2.14) | `49-resumo-pasta-nao-encontrada-2.14-1024-faixa-x4.png` | (a) Ícone a 12 px da barra (as outras 12 faixas usam 16 px); ver ponto 3. (b) A primeira frase não está em Semibold (tokens 5.8: "Primeira frase em Semibold", como em 5.10, 11.17, 11.20, 12.21) | (a) Igualar ao componente das outras faixas: ícone em `Left = 20`, texto em `Left = 52`. (b) "**A pasta não foi encontrada:**" em Semibold; o caminho e "Selecione outra pasta." em Regular (sem mudança de texto) | 🟡 | delphi-dev |
| A4 | Resumo · concluído e cancelado com notas (faixa de homologação/entrada 5.29–5.31) | `49-resumo-concluido-aviso-homologacao-entrada-1024-faixa.png`, `49-resumo-cancelado-1024.png` | É a única faixa com **padding vertical de 8 px** (ícone e texto em `y = 8`); tokens 4.1 e o mockup pedem 12 px, como nas outras faixas | Padding vertical 12 (faixa passa de 50 para 58 px em 1024 e de 36 para 44 px em 1366). Se o padding 8 foi escolhido de propósito para sobrar uma linha a mais no log em 1024, o usuário pode **aceitar** como está | 🟡 | delphi-dev |
| A5 | Enviar · WinRAR ausente (11.20) em 1024 | `49-enviar-winrar-ausente-11.20-1024.png` | O caminho da pasta do ProXML não cabe numa linha, é **cortado na borda direita sem "…"** e o ponto final some. Em 1366 cabe. Com o ProXML numa pasta comum (ex.: `C:\ProXML`) não acontece, mas pode acontecer em pastas longas | Montar o caminho cortado **no meio** com "…" para caber na largura da faixa (`MinimizeName` da `Vcl.FileCtrl`, como já é feito na legenda do arquivo atual e no relatório) e manter o ponto final. Caminho completo no hint da faixa | 🟡 | delphi-dev |
| A6 | Resumo · concluído / cancelado em 1024 (log "Detalhes da leitura") | `49-resumo-concluido-1024.png`, `49-resumo-cancelado-1024.png` | Linhas de erro com nome de arquivo longo (o nome padrão é a chave + "-nfe.xml") ficam cortadas com "…" antes do motivo; em 1024 o usuário **não consegue ler o motivo** ("…não é uma Nota Fiscal com protoco…"). O mockup não tinha linhas tão longas | Mostrar a linha inteira no hint ao passar o mouse sobre ela (`OnMouseMove` da lista → `ItemAtPos` → `Hint`, `Application.ActivateHint`). Sem texto novo: o hint é a própria linha. Alternativa: aceitar (em 1366 cabe; o LOG tem o texto inteiro) | 🟡 | delphi-dev |
| A7 | Configurações · todos os estados | `49-config-normal-1024.png` | Espaço entre o título "Configurações" e a legenda "E-mail de envio (SMTP)" ≈ 8 px; no mockup ≈ 16 px | 16 px (grade de 8) | 🟡 | delphi-dev |
| A8 | Relatório A4 (Notas e IBS/CBS) · 1ª página | `48-reuso\48-notas-133-1a.png`, `48-reuso\48-ibscbs-126-1a.png` | Na linha "Período: … · Modelo: … · N notas" o separador "·" fica colado no texto da esquerda e com um espaço maior à direita ("06/10/2026 ·␣␣␣Modelo:"). No mockup o espaço é igual dos dois lados | Mesmo espaço antes e depois de cada "·" (ex.: 6 px de cada lado, ou um só `TQRLabel` por trecho com " · " no texto) | 🟡 | delphi-dev |
| A9 | `tokens.md` (documentação) | `49-medidas-1024.txt` | O código usa `CorTextoSobreMarinho = $FFFFFF` ("Sobre" ativo, branco), que não existe no `tokens.md` (o mockup usa `#FFFFFF` direto) | Registrar no `tokens.md` (proposta): `CorTextoSobreMarinho` · `#FFFFFF` · `RGB(255, 255, 255)` · `$00FFFFFF` · "Sobre" ativo e texto do aviso flutuante · **17,41:1** sobre `CorMarinho`. Sem mudança no app | 🟡 | ux-designer (após aprovação) |
| A10 | `glossario.md` (documentação) | `49-relatorios-sem-ibscbs-1024.png` | O app mostra o singular "0 de 1 nota tem IBS/CBS." (correto), mas a 8.6 não tem a forma singular registrada | Registrar o singular na 8.6 (proposta P3 abaixo). Sem mudança no app | 🟡 | ux-designer (após aprovação) |
| A11 | Resumo · tempo "0,0 s" | (relato; os prints mostram "0,3 s" e "0,1 s") | Ver ponto 2 | Regra de exibição do ponto 2 | 🟡 | delphi-dev |
| A12 | Cabeçalho · "Sobre" desabilitado | `49-cabecalho-bloqueado-*-sobre-x4.png` | Ver ponto 1 | Conforme a opção escolhida no ponto 1 | 🟡 | delphi-dev (só se B) |
| A13 | Enviar · erro (11.17) | `49-enviar-erro-1024-faixa-x4.png` | Ver ponto 4 | Conforme a opção escolhida no ponto 4 | 🟠 | delphi-dev |

---

## 2. Os 4 pontos pendentes

### Ponto 1 · "Sobre" desabilitado no cabeçalho marinho

Contrastes calculados (fórmula WCAG 2.1):

| Par | Contraste | Observação |
|-----|-----------|------------|
| `CorTextoDesabilitado` #8C93A0 sobre `CorMarinho` #171A21 | **5,63:1** | Já passa do AA (4,5:1), embora o estado desabilitado seja isento |
| `CorMarinhoTexto` #C9CED6 (normal) sobre `CorMarinho` | 11,01:1 | |
| Diferença normal × desabilitado (#C9CED6 × #8C93A0) | 1,95:1 | É o que mostra que o link está bloqueado |

A impressão de "pouco visível" vem do tamanho (9 pt), do ClearType sobre fundo escuro e do contraste com o "Sobre" normal, e não de falta de contraste.

| | **A · manter `CorTextoDesabilitado`** (sugestão) | B · token novo `CorMarinhoTextoDesabilitado` |
|---|---|---|
| Cor | #8C93A0 · `RGB(140, 147, 160)` · `$00A0938C` | **#A0A7B3** · `RGB(160, 167, 179)` · `$00B3A7A0` |
| Contraste sobre `CorMarinho` | 5,63:1 | 7,19:1 |
| Diferença para o normal | 1,95:1 (fica claro que está bloqueado) | 1,53:1 (mais legível, mas menos diferente do normal) |
| Custo | nenhum | 1 token no `tokens.md` e no `ProXML.Tema.pas`; usado só no "Sobre" desabilitado (texto e ícone) |

**Recomendação: A (manter).** A cor já passa no AA, e o bloqueio do "Sobre" acontece junto com o menu inteiro desabilitado, então quem olha a tela entende o estado. Se o usuário quiser o "Sobre" mais legível durante o bloqueio, a opção B resolve sem perder a diferença para o estado normal.

### Ponto 2 · Tempo "0,0 s" no Resumo (contador 5.13)

Largura disponível para o número no 4º contador em 1024: **≈ 126 px** (16 pt Semibold). Medidas com a Segoe UI Semibold: "menos de 0,1 s" = 140 px (**não cabe**), "< 0,1 s" = 61 px, "0,1 s" = 40 px.

| | **A · "< 0,1 s"** (sugestão) | B · mínimo de 0,1 s | C · milissegundos |
|---|---|---|---|
| Regra | Tempo menor que 0,1 s → "< 0,1 s"; senão, uma casa decimal arredondada | Tempo menor que 0,1 s → "0,1 s" | Menor que 1 s → "{ms} ms" |
| Prós | Verdadeiro e curto; cabe em 1024 | Nenhum texto novo | Preciso |
| Contras | Usa o símbolo "<" | Mostra um tempo que não aconteceu | Foge do padrão "4,2 s" (regra 6 do glossário) e muda de unidade |

**Recomendação: A.** Texto em **P1** abaixo. Opcional, no mesmo item: tempos de 60 s ou mais como "1 min 05 s" (95 px, cabe), em **P2**.

### Ponto 3 · Alinhamento das faixas (16 × 12 px)

- As 12 faixas da 4.6/4.7 estão **certas**: barra de 4 px, ícone a 16 px da barra (`Left = 20`) e texto a 12 px do ícone (`Left = 52`), como pedem `tokens.md` 4.1 e o mockup (`padding 12 × 16`, `gap 12`). Os 17/13 px medidos na tinta vêm da **margem interna do próprio desenho Lucide** (2 de 24 unidades → ≈ 1,7 px num ícone de 20 px). Essa margem existe em todos os ícones do app (menu, cards, botões), então **não deve ser compensada**.
- A faixa **2.14** (feita na 4.3, antes do componente da 4.6) está 4 px à esquerda: ícone em `Left = 16`, texto em `Left = 48`.

| | **A · igualar a 2.14 às outras** (sugestão) | B · compensar a margem do Lucide em todas |
|---|---|---|
| O que muda | Só a 2.14: ícone `Left = 20`, texto `Left = 52` (de preferência usando a mesma rotina/componente das outras faixas) | As 13 faixas: ícone em `Left = 18` para a tinta cair a 16 px |
| Efeito | As 13 faixas ficam iguais e iguais ao mockup | Desalinha as faixas em relação aos outros ícones do app e ao mockup |

**Recomendação: A**, junto com o Semibold na primeira frase da 2.14 (item A3) e, se o usuário quiser, o padding vertical da faixa de homologação (item A4).

### Ponto 4 · Prefixo do ACBr na faixa de erro do envio (11.17)

Hoje: "O servidor respondeu: **SMTP Error: Unable to send MailFrom.** 530 … Confira os dados em Configurações e use Testar conexão." O trecho em negrito é do ACBr (inglês, não é resposta do servidor). Na tela Configurações, a faixa 12.22 já mostra só a resposta do servidor ("535 …"), então hoje as duas telas mostram a mesma falha de jeitos diferentes.

| | **A · só a resposta do servidor** (sugestão) | B · manter como está | C · dizer a etapa em português |
|---|---|---|---|
| Faixa | "O servidor respondeu: 530 5.7.0 …. Confira os dados…" | Igual ao print | "O servidor recusou o remetente: 530 …" (uma frase por etapa do envio) |
| Regra | `{motivo}` = a última resposta do servidor (o trecho que começa no código de 3 dígitos, ex.: `530 5.7.0 …`). Sem código no texto (ex.: falha de conexão) → mostrar a mensagem original inteira | — | Mapear "MailFrom", "RcptTo", "Data", login… para textos próprios |
| Texto novo | Nenhum (regra de preenchimento, **P4**) | — | Sim, vários (**P5**, só se escolhida) |
| LOG | Mensagem **completa** do ACBr, sem corte | igual | igual |
| Prós | Igual à 12.22; sem inglês; sem texto novo | Nenhum trabalho | Mais explicativo |
| Contras | Depende de achar o código no texto (com fallback) | Inglês na interface; difere da 12.22 | Mais textos, depende das mensagens internas do ACBr, que podem mudar numa atualização |

Detalhe para qualquer opção: o 11.17 acrescenta "." depois de `{motivo}`. Se a resposta do servidor já terminar em ponto, não acrescentar outro (evita "…aceitos..").

**Recomendação: A.**

---

## 3. Textos propostos para o glossário (**proposta**, aguardando aprovação)

| # | Item | Tipo | Texto proposto | Observação |
|---|------|------|----------------|------------|
| P1 | 5.13 (regra nova) | R | **< 0,1 s** · {n} arquivos lidos | Quando o tempo total for menor que 0,1 s. Nos outros casos continua "{t} s" com uma casa decimal (ponto 2, opção A) |
| P2 | 5.13 (opcional) | R | {m} min {ss} s · {n} arquivos lidos | Ex.: "1 min 05 s". Só para 60 s ou mais. Se não for aprovado, continua "{t} s" (ex.: "65,0 s") |
| P3 | 8.6 (singular) | F | … {x} de 1 nota tem IBS/CBS. | Já é o que o app mostra; só registra |
| P4 | 11.17 (regra do `{motivo}`) | F | *(sem texto novo)* `{motivo}` = última resposta do servidor, a partir do código de 3 dígitos; sem código, a mensagem original. Não repetir o ponto final | Ponto 4, opção A. LOG com a mensagem completa |
| P5 | 11.17 por etapa (só se escolhida a opção C do ponto 4) | F | O servidor recusou o remetente: {resposta} · O servidor recusou o destinatário: {resposta} · O servidor recusou a mensagem: {resposta} · O servidor não aceitou o usuário e a senha: {resposta} | Primeira linha "**Não foi possível enviar o e-mail.**" e o final "Confira os dados em Configurações e use Testar conexão." continuam |
| P6 | 2.14 (formatação) | F | **A pasta não foi encontrada:** {pasta} Selecione outra pasta. | Só o Semibold na primeira frase (regra da faixa); o texto não muda |

---

## 4. Itens aceitáveis como estão (para o usuário aceitar)

| # | Tela / estado | Diferença em relação ao mockup | Por que aceitar |
|---|---------------|-------------------------------|-----------------|
| K1 | Todas (cabeçalho) | O logo mostra "Pro XML" com espaço | É o logo vetorial aprovado em 19/10/2026; o nome em texto continua "ProXML" (Sobre, títulos, caixas) |
| K2 | Resumo · processando | Botão Cancelar com o contorno de foco visível sem uso do teclado | `tokens.md` 5.1 permite o contorno sempre visível; ajuda quem usa Esc/Enter |
| K3 | Resumo · processando / cancelado com notas anteriores | Os cards mostram os totais anteriores (o mockup mostra o primeiro uso, com R$ 0,00) | É a regra do PD-3; o print do primeiro uso (`49-resumo-processando-primeiro-uso-*`) bate com o mockup |
| K4 | Resumo · cancelado com notas anteriores | Faixa de cancelado + contadores e log anteriores + faixa de homologação (duas faixas de aviso empilhadas) | Coerente com o PD-3 (nada foi alterado); não há mockup desse caso |
| K5 | Resumo · pasta sem XML (2.15) | Abaixo da faixa continua o estado vazio "Nenhuma pasta processada" | Decisão da 4.6 (grade vazia e cards zerados); o texto do painel orienta a escolher outra pasta |
| K6 | Notas · grade | Faixa branca abaixo da última linha (não mostra linha parcial, o mockup mostra) | Comportamento nativo do `TDBGrid` |
| K7 | Notas · busca sem resultado | Campo Buscar sem o contorno de foco (o mockup mostra o foco) | O foco estava em outro controle no momento da captura; o estado de foco já aparece em outras telas |
| K8 | Notas · busca sem resultado / 8.8a | Exportar CSV desabilitado | Decisão da 4.5 |
| K9 | Relatórios · opção 1 | Descrição "…valor da nota, base de cálculo do ICMS e ICMS…" diferente do mockup | O app segue o glossário 8.4 (vale sobre o mockup) |
| K10 | Enviar · sem notas | Campo "Para" desabilitado mostra o hint "nome@empresa.com.br" | Ajuda a entender o campo; o contraste do hint do sistema passa (≈ 5,17:1) |
| K11 | Enviar · enviando | Link "alterar em Configurações" desabilitado (no mockup, azul) | O app está mais correto: tudo fica bloqueado durante o envio (tokens 5.13) |
| K12 | Configurações | Caixas SSL/TLS com o desenho nativo do Windows | `tokens.md` 5.4 (sem pintura própria) |
| K13 | Carregando · DANFE e relatório | Spinner Lottie recolorido no lugar do anel do mockup; a captura pega um quadro da animação | Decisão D10 revista (4.4); o quadro tracejado do mockup era só marcação |
| K14 | Relatório A4 | Banda do cabeçalho com mais respiro (92 px) e coluna Nº com 64 px | Decisões da 4.8 |
| K15 | Relatório A4 · rodapé | "v1.0.0" | Executável de teste; no ProXML sai "v1.1.0" (conferir na 4.10) |
| K16 | DANFE paisagem e DANFCe A4 | H1 ("Folha 1/1") e H2 (sem a linha cortando "Emissão … Via Consumidor") resolvidos | Nada a ajustar. **Fora do escopo:** no DANFCe A4 o rótulo "Valor Acréscimo R$" aparece cortado no último caractere. É do layout original do ACBr; sugiro registrar como ideia para um plano futuro, sem mexer agora nos `.fr3` |
| K17 | Sobre | Igual ao mockup | Nada a ajustar |

---

## 5. O que o usuário precisa aprovar

1. A lista de ajustes A1–A13 (ou quais itens 🟡 prefere aceitar como estão).
2. Ponto 1: **A (manter #8C93A0, 5,63:1)** ou B (token novo #A0A7B3, 7,19:1).
3. Ponto 2: **A ("< 0,1 s")**, B ou C; e se quer o formato "1 min 05 s" (P2).
4. Ponto 3: **A (igualar a 2.14 a 16/12 pelos controles)** ou B.
5. Ponto 4: **A (só a resposta do servidor, igual à 12.22)**, B ou C.
6. Os textos P1–P6 e o registro de `CorTextoSobreMarinho` no `tokens.md` (A9).
7. Os itens aceitáveis K1–K17.
