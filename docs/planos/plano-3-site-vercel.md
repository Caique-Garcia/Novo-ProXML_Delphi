# Plano 3 — Página de apresentação na Vercel

## Objetivo
Página pública que apresenta o ProXML, ensina a usar o app e leva ao download.

## Decisões do usuário
| Tema | Decisão |
|------|---------|
| Tecnologia | HTML/CSS estático, sem build |
| Código | Pasta `site/` neste repositório |
| Deploy | Integração GitHub da Vercel (Root Directory = `site`); cada push na `main` publica |
| Imagens | Prints fornecidos pelo usuário |

## Etapas

### 3.1 Estrutura e conteúdo — `web-landing`
- `site/index.html`, `site/styles.css`, `site/img/`.
- Seções: Hero com download, Funcionalidades (NF-e 55 e NFC-e 65 com filtro por modelo, IBS/CBS e instalador), Tutorial passo a passo, aviso do SmartScreen, Download (setup recomendado + `.rar` portátil), rodapé com o GitHub.
- Links: `releases/latest/download/ProXML-Setup.exe` e `releases/latest/download/ProXML.rar`.
- Espaços reservados marcados onde entram os prints.
- **Aceite:** página aprovada pelo usuário localmente (`python -m http.server` em `site/`).

### 3.2 Prints — usuário → `web-landing`
- O usuário entrega os prints (com dados fictícios). O agente otimiza as imagens (WebP/PNG) e substitui os espaços reservados.

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
| 7 | `07-resumo.png` | **Imagem principal do site**: após Processar, com os cards (Valor Total, BC ICMS, ICMS, IBS, CBS) preenchidos e o log na aba Resumo |
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

### 3.4 Publicação — usuário + `release-manager`
- O `release-manager` faz o commit/push da pasta `site/` (após aprovação).
- **Usuário:** na Vercel, *Add New → Project → Import* do repositório e Root Directory `site` (Framework: Other). Esse passo é manual, feito no painel.
- O `release-manager` adiciona a URL do site ao README e à descrição do repositório.

## Pendências (decidir com o usuário)
- **P1.** Pasta onde você vai colocar os prints.
- **P2.** Nome do projeto na Vercel / subdomínio (ex.: `proxml.vercel.app`, se estiver livre) ou domínio próprio?
