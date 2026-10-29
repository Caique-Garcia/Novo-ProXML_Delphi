# Plano 3 — Página de apresentação na Vercel

## Objetivo
Site público que apresenta o ProXML, ensina a usar o app, leva ao download e aparece bem nas buscas do Google.

## Decisões do usuário
| Tema | Decisão |
|------|---------|
| Tecnologia | HTML/CSS estático, sem build |
| Código | Pasta `site/` neste repositório |
| Deploy | Integração GitHub da Vercel (Root Directory = `site`); cada push na `main` publica |
| Endereço | Subdomínio grátis da Vercel (ex.: `proxml.vercel.app`), sem domínio próprio |
| Imagens | Prints fornecidos pelo usuário |
| SEO | Site com várias páginas, cada uma focada numa busca, e SEO técnico completo (ver 3.1) |
| Monetização | **Sem anúncios.** Só o link de doação do Apoia.se: <https://apoia.se/proxmlferramenta> |
| Reforma Tributária | Nova seção **"Reforma Tributária"** em destaque no menu, com página própria de dúvidas frequentes sobre o IVA dual (IBS e CBS), em linguagem simples, mostrando como o ProXML ajuda (ver "Seção Reforma Tributária" em 3.1) |

> Atualizado em 29/10/2026: incluída a seção Reforma Tributária (IBS e CBS), com página de perguntas frequentes e foco de SEO nas buscas sobre a reforma.

> Atualizado em 20/10/2026: sem anúncios, o site continua no plano Hobby (grátis) da Vercel. A política de uso justo da Vercel proíbe anúncios no Hobby, mas permite pedir doações.

## Etapas

### 3.1 Estrutura e conteúdo — `web-landing`

#### Páginas
O Google mostra uma página para poucos termos. Por isso, cada página cobre uma busca que o usuário faz (o problema, não o nome "ProXML"). Cabeçalho e rodapé são repetidos à mão em cada página (sem build).

| Arquivo | URL | Conteúdo | Buscas-alvo |
|---------|-----|----------|-------------|
| `site/index.html` | `/` | Hero com download, Funcionalidades (NF-e 55 e NFC-e 65 com filtro por modelo, IBS/CBS e instalador), resumo do tutorial, seção "Apoie o projeto" | "leitor de XML NF-e grátis", "visualizador XML NFC-e" |
| `site/tutorial.html` | `/tutorial` | Passo a passo completo, com **texto descritivo em cada passo** (não só prints) | "como abrir arquivo XML de nota fiscal", "somar valores XML NF-e" |
| `site/gerar-danfe-xml.html` | `/gerar-danfe-xml` | Como gerar DANFE (55) e DANFCe (65) a partir do XML | "gerar DANFE a partir do XML grátis", "imprimir DANFCe pelo XML" |
| `site/reforma-tributaria.html` | `/reforma-tributaria` | **Página principal da seção Reforma Tributária**: o que é o IVA dual, IBS e CBS, cronograma, o que muda na nota fiscal, perguntas frequentes e como o ProXML ajuda (ver "Seção Reforma Tributária") | "reforma tributária IBS CBS", "o que é IBS e CBS", "IVA dual", "CBS 0,9% IBS 0,1% 2026", "cronograma reforma tributária" |
| `site/ibs-cbs.html` | `/ibs-cbs` | Página técnica da seção: onde ficam IBS/CBS no XML da NF-e/NFC-e (grupos `IBSCBS` e `IBSCBSTot`) e como o ProXML soma esses valores. Linka para `/reforma-tributaria` e é linkada por ela. Texto revisado pelo `nfe-fiscal` | "IBS CBS no XML da NF-e", "IBSCBSTot", "NT 2025.002" |
| `site/download.html` | `/download` | Setup recomendado + `.rar` portátil, aviso do SmartScreen com os prints 1–2 | "baixar ProXML" |
| `site/perguntas-frequentes.html` | `/perguntas-frequentes` | Dúvidas comuns ("é seguro?", "funciona com NFC-e?", "precisa de internet?") | Buscas longas em formato de pergunta |
| `site/404.html` | — | Página de erro com links para as principais | — |

Arquivos de apoio: `site/styles.css`, `site/img/`, `site/favicon.ico` (+ `favicon.svg` e `apple-touch-icon.png`), `site/og-image.png`.

- Links de download: `releases/latest/download/ProXML-Setup.exe` e `releases/latest/download/ProXML.rar`.
- Rodapé em todas as páginas: GitHub, link de doação e links internos para as outras páginas.
- Espaços reservados marcados onde entram os prints.

#### SEO técnico (em todas as páginas)
- `<html lang="pt-BR">`, `<meta charset>` e `<meta name="viewport">`.
- `<title>` único (até ~60 caracteres) e `<meta name="description">` única (até ~155 caracteres).
- `<link rel="canonical">` com a URL final, sem `.html`.
- Um único `<h1>` por página e hierarquia de títulos `h2`/`h3` correta.
- Open Graph (`og:title`, `og:description`, `og:image`, `og:url`, `og:type`, `og:locale=pt_BR`) e Twitter Card (`summary_large_image`), com `og-image.png` em 1200×630. Assim o link fica com prévia no WhatsApp e no LinkedIn.
- Na página inicial, dados estruturados JSON-LD `SoftwareApplication` (`name`, `operatingSystem: Windows`, `applicationCategory: BusinessApplication`, `offers.price: 0`, `offers.priceCurrency: BRL`, `downloadUrl`, `softwareVersion`). **Não incluir notas ou avaliações inventadas.**
- Em todas as páginas internas, JSON-LD `BreadcrumbList`.
- Imagens: WebP com `width` e `height` explícitos (evita saltos de layout), `loading="lazy"` abaixo da primeira tela e `alt` descritivo, que fala do que a tela mostra e não só "print 7".
- Links internos com texto descritivo ("veja como gerar o DANFE"), não "clique aqui".
- `site/robots.txt` liberando tudo e apontando para o sitemap.
- `site/sitemap.xml` com as URLs finais (sem `.html`) e `lastmod`.
- `site/vercel.json`:
  - `cleanUrls: true` (URLs sem `.html`) e `trailingSlash: false`.
  - Cache longo para `img/`, `styles.css` e favicons.
- CSS em um único arquivo, sem frameworks e sem fontes externas pesadas (usar fontes do sistema ou uma fonte só, com `font-display: swap`).

#### Seção Reforma Tributária (IBS e CBS)
Objetivo: ser a resposta clara para quem pesquisa a reforma no Google e mostrar que o ProXML já lê IBS e CBS das notas. As duas páginas (`/reforma-tributaria` e `/ibs-cbs`) formam um grupo de conteúdo: a primeira responde às dúvidas gerais e a segunda, às técnicas. Elas não repetem as mesmas perguntas, para não disputarem a mesma busca.

**Destaque no site**
- Item **"Reforma Tributária"** no menu de todas as páginas, com selo "Novo" (texto, não imagem) por 6 meses a partir da publicação. Depois disso, o selo é retirado.
- Na página inicial, faixa logo abaixo do hero: "Reforma Tributária: o ProXML já soma IBS e CBS das suas notas", com link para `/reforma-tributaria` e para o download.
- Links para `/reforma-tributaria` no rodapé, em `/perguntas-frequentes`, no `/tutorial` (passo dos cards) e em `/ibs-cbs`.

**Estrutura de `/reforma-tributaria`** (nesta ordem)
1. `<h1>`: "Reforma Tributária: IBS e CBS explicados de forma simples".
2. Resposta curta logo abaixo (40–60 palavras) dizendo o que são IBS e CBS. É o formato que o Google costuma usar no trecho em destaque.
3. "Atualizado em dd/mm/aaaa" visível, com o mesmo valor no JSON-LD e no `lastmod` do sitemap.
4. Sumário com links âncora para cada bloco.
5. **"Como o ProXML ajuda"**: caixa em destaque, com o print 7 (cards IBS e CBS), o print 14 (relatório IBS/CBS) e o botão de download. Pontos:
   - Lê o grupo `IBSCBSTot` dos XMLs de NF-e (55) e NFC-e (65) e mostra os totais de IBS e CBS em cards.
   - Soma Base IBS/CBS, IBS UF, IBS Município, IBS total e CBS de uma pasta inteira em segundos.
   - Relatório IBS/CBS pronto para imprimir ou salvar em PDF, e exportação CSV com essas colunas.
   - Filtro por modelo (Todos, NF-e 55, NFC-e 65).
   - Grátis, roda no Windows e funciona sem internet: os XMLs não saem do computador.
   - **Limite dito com clareza:** o ProXML soma os valores que estão no XML. Ele não calcula o imposto nem confere se a alíquota está certa.
6. Linha do tempo 2026–2033 em `<table>` (ano e o que muda).
7. Perguntas frequentes em blocos (ver abaixo).
8. Glossário curto: IVA dual, IBS, CBS, Imposto Seletivo, split payment, cashback, `cClassTrib`, CST do IBS/CBS.
9. Fontes oficiais com link (Receita Federal, LC 214/2025, Portal da NF-e com a NT 2025.002) e o aviso "Conteúdo informativo. Para decisões da sua empresa, consulte seu contador."
10. Chamada final para baixar o ProXML.

**Perguntas frequentes** (lista inicial; o `web-landing` escreve e o `nfe-fiscal` confere cada dado nas fontes oficiais antes de publicar)

| Bloco | Perguntas |
|-------|-----------|
| O básico | O que é a reforma tributária do consumo? · O que é IVA dual? · O que é o IBS? · O que é a CBS? · Qual a diferença entre IBS e CBS? · Quais impostos vão acabar (PIS, Cofins, IPI, ICMS e ISS)? · O que é o Imposto Seletivo? |
| Prazos | Quando a reforma começa? · O que muda em 2026 (ano de teste com CBS 0,9% e IBS 0,1%)? · Preciso pagar IBS e CBS em 2026? · Quando ICMS e ISS deixam de existir? |
| Nota fiscal | O que muda na NF-e e na NFC-e? · O que é a NT 2025.002? · Onde aparecem IBS e CBS no XML? (resposta curta com link para `/ibs-cbs`) · O que é cClassTrib? (resposta curta com link para `/ibs-cbs`, onde fica o detalhe técnico) · Empresa do Simples Nacional precisa informar IBS e CBS na nota? · MEI precisa informar IBS e CBS na nota? |
| Alíquotas e pagamento | Qual vai ser a alíquota do IBS e da CBS? · Quais produtos têm alíquota reduzida ou zero (ex.: cesta básica)? · O que é split payment? · O que é o cashback para famílias de baixa renda? · Os preços vão subir com a reforma? (só o que a lei prevê e estimativas oficiais, com data; sem opinião nem previsão própria) |
| ProXML | Como conferir o total de IBS e CBS das minhas notas? · O ProXML calcula o IBS e a CBS? · Funciona com notas antigas, sem IBS/CBS? |

Privacidade ("meus XMLs vão para a internet?") e preço ("quanto custa?") não viram perguntas aqui, porque já estão em `/perguntas-frequentes`. Aparecem como pontos na caixa "Como o ProXML ajuda", com link para lá.

Regras de escrita:
- Linguagem para quem não é contador: frases curtas, sem juridiquês, termos técnicos explicados na primeira vez e números com exemplo ("numa venda de R$ 100,00…").
- Cada resposta começa pela resposta direta (sim, não, data ou valor) em 1–2 frases e depois detalha.
- As perguntas usam as palavras que o usuário digita na busca.
- Nenhum prazo, alíquota ou regra sem fonte oficial conferida. O que ainda depende de regulamentação aparece como "previsto" ou "estimado", com a data da informação.

**HTML e SEO da seção**
- Cada pergunta em `<details>`, com um `<h3>` dentro do `<summary>` e um `id` próprio (ex.: `#o-que-e-ibs`) para links diretos e compartilhamento. O conteúdo fechado continua no HTML, então o Google o indexa. A primeira pergunta de cada bloco fica aberta.
- Cada bloco tem um `<h2>` com a palavra-chave (ex.: "Prazos da reforma tributária").
- JSON-LD na página: `FAQPage` (só com perguntas e respostas **iguais** às visíveis), `Article` (`headline`, `datePublished`, `dateModified`, `author` Caique Garcia) e `BreadcrumbList` (Início › Reforma Tributária). Em `/ibs-cbs`, o breadcrumb fica Início › Reforma Tributária › IBS e CBS no XML.
- O Google hoje só mostra o resultado em formato de FAQ para sites de governo e de saúde. A marcação `FAQPage` continua valendo para o Bing e para respostas de IA, mas o ganho no Google vem do texto claro, dos títulos e do trecho em destaque.
- Cada pergunta é marcada com `FAQPage` em **uma só** página. `/perguntas-frequentes` fica com as dúvidas sobre o app e linka para a seção da reforma.
- Imagem de prévia própria `og-reforma-tributaria.png` (1200×630, título "IBS e CBS: tire suas dúvidas" + print dos cards), para o compartilhamento no WhatsApp.
- `title` sugerido: "Reforma Tributária: IBS e CBS, dúvidas frequentes | ProXML" (ajustar para ~60 caracteres). `description`: o que são IBS e CBS, o que muda em 2026 e como conferir nas suas notas.
- **Manutenção:** o `nfe-fiscal` revisa a seção a cada nova Nota Técnica ou lei sobre IBS/CBS e, no mínimo, a cada 3 meses. A cada revisão, atualizar "Atualizado em", `dateModified` e `lastmod`.

- **Aceite:** páginas aprovadas pelo usuário localmente (`python -m http.server` em `site/`) e checklist de SEO técnico completo em todas as páginas.

### 3.2 Prints — usuário → `web-landing`
- O usuário entrega os prints (com dados fictícios). O agente otimiza as imagens (WebP/PNG), substitui os espaços reservados e distribui os prints entre as páginas (ex.: 1–4 em `/download`, 11–12 em `/gerar-danfe-xml`, 14 em `/ibs-cbs`).

#### Lista de prints (tirar **depois** dos Planos 1, 4 e 2, já com o visual novo do Plano 4)

> Atualizado em 19/10/2026: o redesign (Plano 4) vem antes do site, então a antiga etapa 4.11 ("prints do site") virou parte deste plano. As telas abaixo podem mudar de nome com o redesign (ex.: a tela "Relatórios" com 2 botões substitui os itens "Relatório" e "Relatório IBS/CBS"); o `web-landing` ajusta a lista conforme os mockups aprovados em `docs/ui/`.
> Ao publicar o site, incluir o link dele na **tela Sobre** do app (combinado no Plano 4).

| # | Arquivo | O que capturar |
|---|---------|----------------|
| 1 | `01-smartscreen.png` | Aviso "O Windows protegeu o computador" ao abrir o `ProXML-Setup.exe` |
| 2 | `02-smartscreen-executar.png` | O mesmo aviso depois de clicar em "Mais informações", com o botão "Executar assim mesmo" |
| 3 | `03-instalador.png` | Tela de boas-vindas do instalador |
| 4 | `04-instalador-atalhos.png` | Tela de tarefas do instalador (atalho na Área de Trabalho) |
| 5 | `05-tela-inicial.png` | App recém-aberto, sem pasta selecionada |
| 6 | `06-selecionar-pasta.png` | Janela de seleção da pasta de XMLs |
| 7 | `07-resumo.png` | **Imagem principal do site**: após Processar, com os cards (Valor Total, BC ICMS, ICMS, IBS, CBS) preenchidos e o log na aba Resumo. Também serve de base para o `og-image.png` |
| 8 | `08-notas.png` | Aba Notas com a grade e a coluna Modelo, filtro em "Todos" |
| 9 | `09-filtro-modelo.png` | Seletor de modelo aberto (ou filtrado em "NF-e 55", com os cards recalculados) |
| 10 | `10-menu-contexto.png` | Botão direito na grade mostrando "Copiar Chave" e "Gerar DANFe" |
| 11 | `11-danfe-nfce.png` | PDF do DANFCe (modelo 65) aberto |
| 12 | `12-danfe-nfe.png` | PDF do DANFE retrato (modelo 55) aberto |
| 13 | `13-relatorio-notas.png` | Pré-visualização do relatório de notas |
| 14 | `14-relatorio-ibscbs.png` | Pré-visualização do relatório IBS/CBS |
| 15 | `15-configuracoes.png` | Tela Configurações com dados SMTP de exemplo e a senha oculta |
| 16 | `16-enviar.png` | Tela Enviar com destinatário e mensagem de exemplo |

Cuidados:
- **Dados fictícios:** a chave de acesso contém o CNPJ do emitente, e o DANFE mostra CNPJ, nome, endereço e CPF do consumidor. Use XMLs de homologação ou borre esses dados antes de enviar. No e-mail, use algo como `contato@exemplo.com.br`.
- Capture **só a janela** (`Alt+PrtSc` ou `Win+Shift+S`), em PNG, com o Windows em escala 100% e a janela do app sempre do mesmo tamanho.
- Os prints 1–4 dependem do Plano 2, e os prints 7, 8, 9, 12 e 14 dependem do Plano 1. Os demais (5, 6, 10, 11, 13, 15 e 16) já podem ser tirados, mas é melhor tirar tudo junto no final para o visual ficar uniforme.

### 3.3 Revisão — `qa-reviewer`
- Responsividade (360 px, 768 px, desktop), tema claro/escuro, links de download respondendo, `alt` nas imagens e nenhum dado real nos prints.
- Lighthouse (mobile) com nota **≥ 95 em SEO, Performance e Acessibilidade** em todas as páginas.
- `title`, `description` e `canonical` únicos por página; um `<h1>` por página; nenhum link interno quebrado.
- JSON-LD validado no [Teste de pesquisa aprimorada](https://search.google.com/test/rich-results) do Google, sem erros.
- `robots.txt`, `sitemap.xml` e `404.html` respondendo; URLs sem `.html` funcionando.
- Prévia do link conferida (Open Graph) colando a URL no WhatsApp ou no [opengraph.xyz](https://www.opengraph.xyz).
- Textos de `/ibs-cbs` e de `/reforma-tributaria` revisados pelo `nfe-fiscal`, com cada prazo, alíquota e regra conferidos em fonte oficial e datados.
- `FAQPage` e `Article` de `/reforma-tributaria` validados no Teste de pesquisa aprimorada, com as perguntas da marcação iguais às da página e nenhuma pergunta marcada em duas páginas.
- Item "Reforma Tributária" no menu de todas as páginas, faixa de destaque na página inicial e links âncora das perguntas funcionando.

### 3.4 Publicação — usuário + `release-manager`
- O `release-manager` faz o commit/push da pasta `site/` (após aprovação).
- **Usuário:** na Vercel, *Add New → Project → Import* do repositório e Root Directory `site` (Framework: Other). Esse passo é manual, feito no painel.
- **Usuário:** no [Google Search Console](https://search.google.com/search-console), adicionar a propriedade do tipo **Prefixo do URL** (o tipo "Domínio" exige acesso ao DNS, que não existe no subdomínio da Vercel), verificar a posse pela meta tag ou pelo arquivo HTML que o Google fornece (o `web-landing` coloca em `site/`) e enviar o `sitemap.xml`. Repetir no [Bing Webmaster Tools](https://www.bing.com/webmasters) (dá para importar direto do Search Console).
- O `release-manager` adiciona a URL do site ao README, à descrição e aos tópicos do repositório e às notas das próximas Releases. Esses links apontando para o site são o sinal de SEO que mais pesa no começo.

## Pendências (decidir com o usuário)
- **P1.** Pasta onde você vai colocar os prints.

## Pendências resolvidas
- **P4.** Perguntas da seção Reforma Tributária (decidido em 29/10/2026):
  - Mantidos os blocos O básico (7), Prazos (4), Nota fiscal e Alíquotas e pagamento, sem cortes.
  - Incluídas: "MEI precisa informar IBS e CBS?", "O que é cClassTrib?" e "Os preços vão subir com a reforma?".
  - Bloco ProXML reduzido a 3 perguntas; privacidade e preço ficam em `/perguntas-frequentes`, com link.
  - Item de menu "Reforma Tributária", com selo "Novo" por 6 meses.
- **P2.** Endereço do site: **subdomínio da Vercel** (decidido em 20/10/2026), sem domínio próprio. O nome exato (ex.: `proxml.vercel.app`, se estiver livre) sai na criação do projeto na Vercel (3.4). Até lá, as URLs do `canonical`, do `sitemap.xml` e do Open Graph usam `https://proxml.vercel.app` e são corrigidas se o nome mudar.
- **P3.** Plataforma de doação: **Apoia.se** (decidido em 20/10/2026), link <https://apoia.se/proxmlferramenta>. Entra no rodapé de todas as páginas, na seção "Apoie o projeto" da página inicial, no README e na tela Sobre do app.
