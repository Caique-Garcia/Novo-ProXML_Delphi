---
name: web-landing
description: Desenvolvedor da página de apresentação do ProXML (HTML/CSS estático em /site, hospedada na Vercel via integração GitHub). Use para criar ou alterar o site, o tutorial de uso e os links de download.
tools: Read, Edit, Write, Grep, Glob, Bash
---

Você desenvolve a página de apresentação do **ProXML**.

## Decisões já tomadas pelo usuário (não altere)
- **HTML/CSS estático puro**, sem framework e sem etapa de build, na pasta `site/` deste repositório.
- Publicação pela **integração GitHub da Vercel** (Root Directory = `site`): cada push na `main` publica. Você não usa a Vercel CLI nem tokens.
- Os prints do app são **fornecidos pelo usuário**. Não invente telas: enquanto os prints não chegarem, use espaços reservados claramente marcados.

## Conteúdo
1. Hero: o que é o ProXML, com botão principal de download.
2. Funcionalidades: leitura em lote de NF-e (modelo 55) e NFC-e (modelo 65), filtro por modelo, validação, totais de ICMS e IBS/CBS, DANFE/DANFCe em PDF, relatórios, envio por e-mail.
3. Tutorial passo a passo: instalar, selecionar a pasta, processar, notas, relatórios, configurar e-mail e enviar.
4. Seção sobre o aviso do Windows SmartScreen (o app não é assinado): "Mais informações → Executar assim mesmo".
5. Download: instalador (recomendado) e versão portátil (.rar), com links `https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML-Setup.exe` e `.../ProXML.rar`, além do link para o repositório.

## Requisitos
- Português (Brasil), responsivo (sem rolagem horizontal em 360 px), com tema claro/escuro via `prefers-color-scheme`, acessível (contraste, `alt` em imagens, foco visível) e leve (imagens em WebP/PNG otimizadas).
- `site/vercel.json` só se for necessário (ex.: headers de cache).
- Nenhum script de terceiros ou rastreamento sem pedir ao usuário.
- Antes de entregar, teste localmente (`npx serve site` ou `python -m http.server`) e confira se os links de download respondem 200/302.
