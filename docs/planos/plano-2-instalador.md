# Plano 2 — Instalador Inno Setup + compactação ZIP nativa (v1.2.0)

## Objetivo
Distribuir o ProXML com um instalador Windows e eliminar a dependência do `WinRAR.exe`, que não pode ser redistribuído.

## Decisões do usuário
| Tema | Decisão |
|------|---------|
| Ferramenta | Inno Setup 6 (mesma tecnologia do `setupProXML.exe` antigo) |
| Pasta | Por usuário: `%LocalAppData%\ProXML`, sem administrador e sem mudar onde o app grava dados |
| WinRAR | Trocar por ZIP nativo (`System.Zip`). O anexo do e-mail passa a ser `.zip` |
| Distribuição | Release com `ProXML-Setup.exe` (nome fixo, para os links `latest/download`) **e** ~~`ProXML.rar`~~ `ProXML.zip` (ver "Distribuição (06/11/2026)") |
| Setup antigo | Remover `install/setupProXML.rar` do repositório |
| Assinatura | Sem assinatura, aceitando o aviso do SmartScreen |
| **Revisão depois do Plano 4 (06/11/2026)** | O plano foi escrito antes do Plano 4. Decisões novas: **textos do ZIP** propostos pelo `ux-designer` no glossário (11.12, 11.14, 11.20, 11.20a, anexo da tela Enviar, linhas do LOG) e aprovados pelo usuário **antes** da 2.1. **Banco pela pasta do programa:** na 2.1, o `DM.pas` (e o `ErroLog.txt`) deixam o `GetCurrentDir` e passam a usar a pasta do `ProXML.exe`; o atalho continua com `WorkingDir: {app}`. **VersionInfo:** Release **1.2.0** e a configuração Debug alinhada (sai o 2023.1), na 2.1, com o ProXML fechado na IDE. **Limpeza:** `git rm` de `install/setupProXML.rar` **e de `dlls/`** (arquivos de sistema do Windows sem uso no código). **Inno Setup 6:** instalação pelo `winget install JRSoftware.InnoSetup` autorizada para a 2.3. **Setup antigo** (`setupProXML.exe`, outro AppId): só orientar no README e nas notas (desinstalar a versão antiga e, para manter as configurações, copiar o `db\notas.db` para `%LocalAppData%\ProXML\db`) |
| **Distribuição (06/11/2026)** | ~~`ProXML.rar`~~ → o pacote portátil passa a ser **`ProXML.zip`** (abre no Explorer sem WinRAR). Release v1.2.0 com `ProXML-Setup.exe` e `ProXML.zip`, cada um com SHA-256. O pacote e o instalador levam também o `LICENSE-lucide.txt` (exigência da licença dos ícones) e `NFCe\` com `danfePDF\` e `EnvioResposta\` vazias, como na v1.1.0 |
| **Textos do ZIP (06/11/2026)** | Aprovada a proposta do `ux-designer`: sai a **11.20** (WinRAR ausente) e as linhas do LOG do WinRAR; **11.20a** nova e **genérica** para qualquer falha ao criar o `.zip` (motivo técnico só no LOG, sem faixas específicas); **11.3** "Anexo: {n} XMLs (.zip)"; **14.4a** revisada e **14.4b** nova. O anexo continua **`NFCe_ProXML.zip`**. Falha ao criar a pasta temporária `NFCe\ProXML` mostra a **11.20a** (e não a 11.20b). O `NFCe_ProXML.rar` que sobra de quem atualiza da v1.1.0 **fica onde está** |
| **Decisões da 2.1 (06/11/2026)** | Aceitas as escolhas do `delphi-dev`: falha ao apagar a pasta temporária `NFCe\ProXML` anterior também mostra a **11.20a** + LOG 14.4b (antes caía na 11.17); a cópia dos XMLs para `NFCe\ProXML` antes do `.zip` é **mantida** (continua detectando a 11.20b); chave repetida no filtro entra **uma vez só** no `.zip`. O tamanho mostrado na tela Enviar continua sendo a soma dos XMLs (11.4). Bateria reduzida da 2.1 autorizada pelo usuário |
| **Revisão da 2.2 (06/11/2026)** | Sem achados 🔴; build Release sem avisos novos (1.2.0.0); textos iguais ao glossário; o `.zip` abriu no Explorer com os 19 XMLs (teste manual do usuário). **Corrigir antes da 2.3:** falha ao apagar a pasta `NFCe\ProXML` anterior passa a mostrar de fato a **11.20a** + 14.4b (o `TDirectory.Delete` do 10.2 não acusa erro); chaves repetidas tiradas com lista ordenada (sem a lentidão com muitos XMLs; envio típico de até ~5 mil XMLs, segundo o usuário); motivo do LOG 14.4b numa linha só; acima de 65.535 XMLs (limite do ZIP sem Zip64 do 10.2) mostra a **11.20a** em vez de enviar um `.zip` corrompido. Depois, repetir só as seções do ZIP com o filtro 55, chave repetida e pasta temporária presa (autorizado). **Resultado (06/11/2026):** corrigido e retestado (seções do ZIP, 12,6 s, sem falhas). **Decisões de 09/11/2026:** mantida a retirada do atributo somente leitura das **cópias** em `NFCe\ProXML` antes de apagar (um XML de origem somente leitura travaria os envios seguintes na 11.20a); soma dos XMLs acima de **4 GB** (limite do ZIP sem Zip64) também mostra a **11.20a**, com o motivo só no LOG (só compilado, sem teste automático) |
| **Decisões da 2.3 (09/11/2026)** | Inno Setup **6.7.3** instalado pelo winget, por usuário (ISCC em `%LocalAppData%\Programs\Inno Setup 6`). **AppId fixo:** `{E7CB7020-EEB6-475A-8BDB-4B358B48B837}` (não trocar: é ele que faz a atualização substituir a versão anterior). `installer/build.ps1 -Version x.y.z -ExePath <exe Release>` monta o staging a partir do `git archive HEAD` (Report, Schemas, `notas.db` vazio, `LICENSE-lucide.txt`) + exe + `sk4d.dll` e recusa `bin\ProXML.exe`, nomes com 14+ dígitos, `ErroLog.txt`, `WinRAR.exe` e conteúdo em `NFCe\`. **Desinstalação:** mantém `db\`, o conteúdo de `NFCe\` (PDFs, XMLs e `.zip` gerados pelo usuário) e o `ErroLog.txt`. **Textos aprovados:** nome "ProXML" direto em Programas (sem pasta), editor "Caique Garcia", URL do repositório, ícone `ProXML_Icon.ico`, assistente `modern` com os textos padrão do Inno em português, tela de pasta (pulada nas atualizações) e sem `MinVersion`. O compilador mostra "Non-commercial use only": o ProXML desktop é gratuito; conferir a licença do Inno se um dia o setup for usado num produto pago. Teste da 2.4 autorizado |
| **Decisões da 2.5 (09/11/2026)** | Release v1.2.0 com **dois anexos** (`ProXML-Setup.exe` e `ProXML.zip`); **sem** `ProXML.rar` (o link fixo da v1.1.0 continua valendo; o `latest/download/ProXML.rar` deixa de funcionar). O limite de 65.535 XMLs/4 GB por envio **não** entra nas limitações (o app avisa com a 11.20a). Aprovadas as escolhas do `release-manager`: quem usou o setup antigo copia o `db\notas.db` **antes** de desinstalar; orientação para passar do portátil v1.1.0 para o instalador; limitação do `Report\` corrompido com "execute o instalador de novo ou copie o `Report\` do `ProXML.zip`". Agentes `release-manager`, `installer-engineer`, `web-landing` e o Plano 3 atualizados para o `.zip` portátil |
| **Pendências P1/P2 (06/11/2026)** | **P1:** atalho na Área de Trabalho **opcional e já marcado**. **P2:** "Executar ProXML agora" **marcado** na última tela do instalador |

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
- Remover `install/setupProXML.rar` e `dlls/` do repositório (`git rm`).
- Instalar também o `LICENSE-lucide.txt` e criar `NFCe\danfePDF\` e `NFCe\EnvioResposta\` vazias; atalho na Área de Trabalho opcional e marcado; "Executar ProXML agora" marcado no fim.
- **Aceite:** o setup é gerado por `build.ps1` sem passos manuais.

### 2.4 Testes de instalação — `installer-engineer` + `qa-reviewer`
- Instalação silenciosa numa pasta de teste, conferindo arquivos, atalhos e se o app abre e cria/usa o `db\`.
- Reinstalar por cima (atualização) mantendo o `notas.db` e as configurações.
- Desinstalar: os arquivos do app saem e o `db\` fica.
- ✅ **09/11/2026:** roteiro automático executado com autorização (35 s, 0 falhas): instalação silenciosa com os 1925 arquivos + desinstalador, atalhos com "Iniciar em" na pasta do programa, app aberto de outra pasta usando o `db\` instalado, reinstalação por cima lembrando a pasta e mantendo o `notas.db` (mesmo hash), desinstalação mantendo só o `db\`, sem sobras de atalho ou registro. Não testados: desinstalar com arquivos em `NFCe\` (o Inno não apaga o que não instalou) e atualizar com o app aberto.

### 2.5 Release v1.2.0 — `release-manager`
- README: seção de instalação com o setup como opção recomendada e o `ProXML.zip` como portátil; remover a nota sobre o WinRAR e orientar quem usou o `setupProXML.exe` antigo.
- Publicar a Release v1.2.0 com os dois arquivos e os SHA-256, e validar o download anônimo.
- ✅ **Publicada em 09/11/2026** com o OK do usuário: tag `v1.2.0` em `4734db2`, Release "ProXML v1.2.0" (https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/tag/v1.2.0), marcada como latest, com `ProXML-Setup.exe` (SHA-256 `04833ce0286277405ee0bf1cfa0a429edd3791e5ac2c5f1c0b8173b8da70dace`) e `ProXML.zip` (SHA-256 `dc632fb545b3d063dfd1649875f36958586d6c7b22075288cfa41904477fdc08`). Download anônimo pelos links `latest` e da tag conferido com o hash; o `ProXML.rar` da v1.1.0 continua baixável pelo link fixo da tag v1.1.0. Descrição do repositório sem mudança.

## Pendências (decidir com o usuário)
- ~~**P1.** Atalho na Área de Trabalho~~ → opcional e marcado (06/11/2026).
- ~~**P2.** "Executar ProXML agora"~~ → sim, marcado (06/11/2026).

## Riscos
- ~~O app localiza o `db\` por `GetCurrentDir`~~ → resolvido na 2.1: o `db\` e o `ErroLog.txt` são localizados pela pasta do `ProXML.exe`. O atalho continua com `WorkingDir: {app}`.
- Sem assinatura, alguns antivírus podem sinalizar o setup.
