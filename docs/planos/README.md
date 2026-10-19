# Planos de execução — ProXML

| Ordem | Plano | Versão | Status |
|-------|-------|--------|--------|
| 1 | [Modelos 55 e 65 + IBS/CBS](plano-1-ibs-cbs.md) | v1.1.0 | Etapa 1.1 concluída — aguardando aprovação para a 1.2 |
| 2 | [Instalador (Inno Setup) + ZIP nativo](plano-2-instalador.md) | v1.2.0 | Aguardando Plano 1 |
| 3 | [Página de apresentação na Vercel](plano-3-site-vercel.md) | — | Aguardando Plano 2 |

Ordem definida: **1 → 2 → 3**. Assim o site já nasce mostrando IBS/CBS e apontando para o instalador.

## Agentes (`.claude/agents/`)

| Agente | Papel |
|--------|-------|
| `delphi-dev` | Implementa em Delphi 10.2 (`.pas`/`.dfm`, FireDAC, QuickReport) e compila via MSBuild |
| `nfe-fiscal` | Mapeia o layout NF-e 55 / NFC-e 65 e IBS/CBS (NT 2025.002), analisa XMLs de teste e gera o gabarito de totais |
| `installer-engineer` | Script Inno Setup, build do setup e testes de instalação/desinstalação |
| `web-landing` | Site estático em `site/`, publicado pela Vercel |
| `qa-reviewer` | Revisa o diff, compila e confere os critérios de aceite; não edita código |
| `release-manager` | README, empacotamento, tag e Release no GitHub |

## Regra geral
Nenhum agente toma decisão de negócio ou de escopo sozinho. Dúvidas voltam para o usuário antes de seguir.
