# Plano 3 — Página de apresentação na Vercel

## Objetivo
Site público que apresenta o ProXML, ensina a usar o app, leva ao download e aparece bem nas buscas do Google.

## Decisões do usuário
| Tema | Decisão |
|------|---------|
| Tecnologia | HTML/CSS estático, sem build |
| Código | Pasta `site/` neste repositório |
| Deploy | Integração GitHub da Vercel (Root Directory = `site`); cada push na `main` publica |
| Imagens | Prints fornecidos pelo usuário |
| SEO | Site com várias páginas, cada uma focada numa busca, e SEO técnico completo (ver 3.1) |
| Monetização | **Sem anúncios.** Só o link de doação do Apoia.se: <https://apoia.se/proxmlferramenta> |

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
| `site/ibs-cbs.html` | `/ibs-cbs` | Guia de IBS/CBS no XML da NF-e e como o ProXML soma esses valores. Texto revisado pelo `nfe-fiscal` | "IBS CBS no XML da NF-e", "Reforma Tributária NT 2025.002" |
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
  - Redirecionamento permanente de `www` para o domínio principal (se houver domínio próprio).
  - Cache longo para `img/`, `styles.css` e favicons.
- CSS em um único arquivo, sem frameworks e sem fontes externas pesadas (usar fontes do sistema ou uma fonte só, com `font-display: swap`).

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
- Texto de `/ibs-cbs` revisado pelo `nfe-fiscal`.

### 3.4 Publicação — usuário + `release-manager`
- O `release-manager` faz o commit/push da pasta `site/` (após aprovação).
- **Usuário:** na Vercel, *Add New → Project → Import* do repositório e Root Directory `site` (Framework: Other). Esse passo é manual, feito no painel.
- **Usuário (se houver domínio próprio):** em *Settings → Domains* da Vercel, adicionar o domínio e configurar o DNS no registrador.
- **Usuário:** no [Google Search Console](https://search.google.com/search-console), adicionar a propriedade do site, verificar a posse e enviar o `sitemap.xml`. Repetir no [Bing Webmaster Tools](https://www.bing.com/webmasters) (dá para importar direto do Search Console).
- O `release-manager` adiciona a URL do site ao README, à descrição e aos tópicos do repositório e às notas das próximas Releases. Esses links apontando para o site são o sinal de SEO que mais pesa no começo.

## Pendências (decidir com o usuário)
- **P1.** Pasta onde você vai colocar os prints.
- **P2.** Nome do projeto na Vercel / subdomínio (ex.: `proxml.vercel.app`, se estiver livre) ou domínio próprio? Sem anúncios, o subdomínio da Vercel funciona. Um domínio próprio (ex.: `proxml.com.br`, ~R$ 40/ano no Registro.br) é recomendado para SEO e confiança. As URLs do `canonical`, do `sitemap.xml` e do Open Graph dependem dessa escolha.

## Pendências resolvidas
- **P3.** Plataforma de doação: **Apoia.se** (decidido em 20/10/2026), link <https://apoia.se/proxmlferramenta>. Entra no rodapé de todas as páginas, na seção "Apoie o projeto" da página inicial, no README e na tela Sobre do app.
