# Plano 2 — Instalador Inno Setup + compactação ZIP nativa (v1.2.0)

## Objetivo
Distribuir o ProXML com um instalador Windows e eliminar a dependência do `WinRAR.exe`, que não pode ser redistribuído.

## Decisões do usuário
| Tema | Decisão |
|------|---------|
| Ferramenta | Inno Setup 6 (mesma tecnologia do `setupProXML.exe` antigo) |
| Pasta | Por usuário: `%LocalAppData%\ProXML`, sem administrador e sem mudar onde o app grava dados |
| WinRAR | Trocar por ZIP nativo (`System.Zip`). O anexo do e-mail passa a ser `.zip` |
| Distribuição | Release com `ProXML-Setup.exe` (nome fixo, para os links `latest/download`) **e** `ProXML.rar` |
| Setup antigo | Remover `install/setupProXML.rar` do repositório |
| Assinatura | Sem assinatura, aceitando o aviso do SmartScreen |

## Etapas

### 2.1 Compactação ZIP nativa — `delphi-dev`
- `ProXML.FormPrincipal.pas`, `ComprimirArquivos`: substituir a chamada `cmd.exe /c WinRAR.exe` por `TZipFile` (`System.Zip`), gerando `NFCe\NFCe_ProXML.zip`.
- `EnviaArquivo`: anexar o `.zip`. Remover `CreateProcessSimple` se ficar sem uso.
- **Aceite:** build OK; o envio de e-mail anexa um `.zip` válido com os XMLs, numa máquina **sem** WinRAR.

### 2.2 Revisão do ZIP — `qa-reviewer`
- Diff, build e verificação de que o `.zip` abre no Windows Explorer.

### 2.3 Script do instalador — `installer-engineer`
- Instalar o Inno Setup 6 (**com autorização do usuário**).
- Criar `installer/ProXML.iss` e `installer/build.ps1`: instalação por usuário, `AppId` fixo, pt-BR, atalhos com `WorkingDir: {app}`, `db\` preservado na atualização e na desinstalação, e versão por parâmetro.
- Adicionar `installer/Output/` ao `.gitignore`.
- Remover `install/setupProXML.rar` do repositório (`git rm`).
- **Aceite:** o setup é gerado por `build.ps1` sem passos manuais.

### 2.4 Testes de instalação — `installer-engineer` + `qa-reviewer`
- Instalação silenciosa numa pasta de teste, conferindo arquivos, atalhos e se o app abre e cria/usa o `db\`.
- Reinstalar por cima (atualização) mantendo o `notas.db` e as configurações.
- Desinstalar: os arquivos do app saem e o `db\` fica.

### 2.5 Release v1.2.0 — `release-manager`
- README: seção de instalação com o setup como opção recomendada e o `.rar` como portátil; remover a nota sobre o WinRAR.
- Publicar a Release v1.2.0 com os dois arquivos e os SHA-256, e validar o download anônimo.

## Pendências (decidir com o usuário)
- **P1.** Atalho na Área de Trabalho: criado por padrão, opcional (caixa desmarcada) ou não criar?
- **P2.** Ao final da instalação, oferecer "Executar ProXML agora"?

## Riscos
- O app localiza o `db\` por `GetCurrentDir`. Se for aberto sem o atalho (ex.: por outro programa), o diretório de trabalho pode ser outro. O atalho com `WorkingDir` resolve o caso comum; a correção definitiva seria uma alteração de código e fica fora do escopo decidido.
- Sem assinatura, alguns antivírus podem sinalizar o setup.
