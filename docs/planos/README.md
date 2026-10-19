# Planos de execução — ProXML

| Ordem | Plano | Versão | Status |
|-------|-------|--------|--------|
| 1 | [Modelos 55 e 65 + IBS/CBS](plano-1-ibs-cbs.md) | v1.1.0 | ✅ Concluído e aprovado pelo QA — publicação junto com o Plano 4 |
| 4 | [Redesign de UI/UX](plano-4-ui-ux.md) | v1.1.0 | ▶️ Próximo a executar |
| 2 | [Instalador (Inno Setup) + ZIP nativo](plano-2-instalador.md) | v1.2.0 | Aguardando Plano 4 |
| 3 | [Página de apresentação na Vercel](plano-3-site-vercel.md) | — | Aguardando Plano 2 |

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

## Regra geral
Nenhum agente toma decisão de negócio ou de escopo sozinho. Dúvidas voltam para o usuário antes de seguir.
