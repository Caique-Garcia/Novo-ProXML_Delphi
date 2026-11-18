# Planos de execução — ProXML

| Ordem | Plano | Versão | Status |
|-------|-------|--------|--------|
| 1 | [Modelos 55 e 65 + IBS/CBS](plano-1-ibs-cbs.md) | v1.1.0 | ✅ Publicado na v1.1.0 (06/11/2026) |
| 4 | [Redesign de UI/UX](plano-4-ui-ux.md) | v1.1.0 | ✅ Publicado na v1.1.0 (06/11/2026) |
| 2 | [Instalador (Inno Setup) + ZIP nativo](plano-2-instalador.md) | v1.2.0 | ✅ Publicado na v1.2.0 (09/11/2026) |
| 3 | [Página de apresentação na Vercel](plano-3-site-vercel.md) | — | ▶️ Em execução: site publicado em <https://proxml.vercel.app> (10/11/2026); faltam 3.3 e Search Console/Bing; a 3.5 (tela Sobre) está implementada e sai na v1.3.0, com o Plano 7 |
| 7 | [Conferência dos cálculos de IBS/CBS](plano-7-conferencia-ibs-cbs.md) | v1.3.0 | ✅ **Concluído em 18/11/2026:** v1.3.0 publicada (com a etapa 3.5 do Plano 3) e site atualizado (7.7), revisado e aprovado pelo usuário |
| 5 | [Chat com IA sobre os XMLs (Groq e Gemini)](plano-5-chat-ia.md) | v1.4.0 | 📝 Aguardando aprovação (10/11/2026); passou para depois do Plano 7 em 11/11/2026 |
| 8 | [Apuração de Antecipação e DIFAL de ICMS (MG)](plano-8-apuracao-icms-mg.md) | a definir | 📝 Aprovado em 17/11/2026; plano separado, começa depois do Plano 7. [Análise fiscal](plano-8-analise-fiscal-icms-mg.md) |

Ordem definida (atualizada em 19/10/2026): **1 → 4 → 2 → 3**. Os Planos 1 e 4 saem juntos na **v1.1.0**. O instalador sai na v1.2.0 e o site já nasce com o visual novo, apontando para o instalador.

## Agentes (`.claude/agents/`)

| Agente | Papel |
|--------|-------|
| `delphi-dev` | Implementa em Delphi 10.2 (`.pas`/`.dfm`, FireDAC, QuickReport) e compila via MSBuild |
| `nfe-fiscal` | Mapeia o layout NF-e 55 / NFC-e 65 e IBS/CBS (NT 2025.002), analisa XMLs de teste e gera o gabarito de totais |
| `installer-engineer` | Script Inno Setup, build do setup e testes de instalação/desinstalação |
| `web-landing` | Site estático em `site/`, publicado pela Vercel |
| `qa-reviewer` | Revisa o diff, compila e confere os critérios de aceite; não edita código |
| `ux-designer` | Tokens de design, mockups HTML, glossário de textos e revisão visual (Plano 4); não edita código Delphi |
| `release-manager` | README, empacotamento, tag e Release no GitHub |
| `supabase-data` | Esquema, RLS somente leitura, carga e verificação das tabelas de regras no Supabase (Plano 8); não edita código Delphi |

## Regra geral
Nenhum agente toma decisão de negócio ou de escopo sozinho. Dúvidas voltam para o usuário antes de seguir.
