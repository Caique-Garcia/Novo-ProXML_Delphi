# ProXML

Totalizador de XMLs de NF-e (55) e NFC-e (65) com IBS/CBS, DANFE e relatórios - Delphi VCL.

Aplicativo desktop para Windows que lê uma pasta de XMLs de **NF-e (modelo 55)** e **NFC-e (modelo 65)**, soma os valores das notas autorizadas (incluindo **IBS/CBS** da Reforma Tributária) e facilita a conferência, a impressão e o envio desses arquivos.

> ⬇️ **[Baixar o instalador (ProXML-Setup.exe)](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML-Setup.exe)** (recomendado) — ou a versão portátil **[ProXML.zip](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML.zip)**. Todas as versões estão na página de [Releases](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases).

> 🌐 **Site:** <https://proxml.vercel.app>, com tutorial passo a passo, como gerar o DANFE e dúvidas sobre a Reforma Tributária (IBS e CBS).

---

## Funcionalidades

### Leitura e totais

- **NF-e (55) e NFC-e (65)** na mesma pasta. Outros modelos são ignorados e aparecem nos detalhes da leitura.
- **Só notas autorizadas** entram nos totais: `cStat` **100** (autorizado o uso) ou **150** (autorizado fora de prazo), lido do protocolo de autorização. Notas não autorizadas (ex.: denegadas) e arquivos que não são Nota Fiscal ficam de fora e são listados com o motivo.
- **5 cards de totais:** Valor Total, Base ICMS, ICMS, IBS e CBS, no formato `R$ 1.234,56`.
- **IBS/CBS (NT 2025.002):** quando o XML tem o grupo `IBSCBSTot`, são lidos Base IBS/CBS, IBS UF, IBS municipal, IBS e CBS.
- **Filtro de modelo** em botões: **Todos**, **NF-e 55** ou **NFC-e 65**. Vale para os cards, a grade, o CSV, os dois relatórios e o e-mail.
- **Processamento em segundo plano:** a janela continua respondendo, com progresso "X de N arquivos" e botão **Cancelar**. No fim, o Resumo mostra os contadores (Autorizadas, Ignoradas, Com erro), o tempo e os **Detalhes da leitura**, arquivo por arquivo.
- **Aviso no Resumo** quando os totais incluem notas de **homologação** (ambiente de testes) ou **NF-e de entrada**.

> **Atenção (NF-e 55):** as notas de **entrada** e de **saída** são **somadas juntas**, sem distinção. Se a pasta tiver compras e vendas misturadas, os totais misturam as duas. Para conferir só as vendas, processe uma pasta que tenha apenas as notas de saída.

### Notas

- **Grade** com Nº, Modelo, Data, Chave (44 dígitos) e valores. As colunas de Base ICMS, ICMS, IBS e CBS aparecem conforme a largura da janela.
- **Busca** por número ou chave enquanto você digita, e **ordenação** pelo clique no título da coluna.
- **Barra de ações:** **Copiar chave**, **Gerar DANFE** e **Exportar CSV**. O duplo clique numa linha também gera o DANFE, e o botão direito continua com Copiar chave e Gerar DANFE.
- **DANFE em PDF** (ACBr + FastReport), aberto automaticamente, com o layout escolhido por nota:
  - NFC-e (65) → DANFCe A4;
  - NF-e (55) com `tpImp` 1 → DANFE **retrato**;
  - NF-e (55) com `tpImp` 2 → DANFE **paisagem**;
  - outros layouts (ex.: DANFE simplificado) não são gerados e mostram um aviso.
- **CSV para o Excel em português:** separado por `;`, valores com vírgula decimal e acentos corretos. Exporta as notas visíveis na lista (filtro e busca).

### Relatórios

- Tela **Relatórios** com o **Relatório de Notas** e o **Relatório IBS/CBS** (este só com as notas que têm o grupo IBS/CBS).
- Layout novo em A4: período das notas, modelo do filtro, pasta de origem, colunas alinhadas, valores em `R$`, linha de total e rodapé "Gerado pelo ProXML v1.2.0 · data e hora · Página X de Y".

### E-mail

- Tela **Enviar** mostra o anexo antes de enviar (quantidade de XMLs e tamanho). Os XMLs só são compactados quando você clica em **Enviar**, e o envio acontece em segundo plano.
- **Anexo `NFCe_ProXML.zip`**, criado pelo próprio ProXML: não precisa do WinRAR. Se não for possível montar o anexo (ex.: arquivo em uso ou disco cheio), aparece uma mensagem e o e-mail não é enviado.
- **Configurações** com validação dos campos e **Testar conexão**, que conecta e autentica no servidor **sem enviar e-mail**.

### Interface

- **Visual novo:** janela redimensionável e maximizável, menu lateral (**Resumo**, **Notas**, **Relatórios**, **Enviar**, **Configurações**) e tela **Sobre**.
- **Arrastar e soltar** uma pasta do Explorer na janela.
- Lembra a **última pasta** e o **tamanho e a posição da janela**.
- **Escala do Windows:** 100%, 125%, 150% e dois monitores com escalas diferentes.
- Uso completo pelo teclado (Tab, Enter, Espaço e os atalhos abaixo).

## Instalação

Há duas formas de instalar, com o mesmo programa: o **instalador** (recomendado) e a versão **portátil** (`.zip`).

### Com o instalador (recomendado)

1. Baixe o **[ProXML-Setup.exe](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML-Setup.exe)**.
2. Execute o setup e siga as telas. O ProXML é instalado **só para o seu usuário**, em `%LocalAppData%\ProXML`, **sem pedir administrador**.
3. Abra o ProXML pelo atalho no **Menu Iniciar** ou na **Área de Trabalho** (atalho opcional, já marcado no setup).

> **Aviso do Windows (SmartScreen):** o instalador não tem assinatura digital, então o Windows pode mostrar "O Windows protegeu o computador". Clique em **Mais informações** e depois em **Executar assim mesmo**.

- **Atualizar:** baixe e execute o setup da versão nova. Ele substitui o programa e **mantém a pasta `db\`**, com as suas configurações.
- **Desinstalar:** pelo Windows, em **Configurações → Aplicativos**. A pasta `db\` (configurações) e o que estiver em `NFCe\` (PDFs e arquivos do envio) **ficam** em `%LocalAppData%\ProXML`; apague essa pasta se não quiser mais esses arquivos.

### Versão portátil (ProXML.zip)

1. Baixe o **[ProXML.zip](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML.zip)**.
2. Extraia o conteúdo para uma pasta (ex.: `C:\ProXML`). O próprio Windows abre o `.zip`: clique com o botão direito e escolha **Extrair tudo**.
3. Execute o **`ProXML.exe`**.

O instalador e o `.zip` trazem tudo o que o programa precisa:

```text
ProXML\
├── ProXML.exe          # programa
├── sk4d.dll            # Skia4Delphi (ícones e animação)
├── LICENSE-lucide.txt  # licença dos ícones Lucide
├── db\notas.db         # banco local, vazio
├── Report\             # layouts do DANFE e do DANFCe (FastReport)
├── Schemas\            # schemas XSD usados pelo ACBr
└── NFCe\               # saída do programa
    ├── danfePDF\       # PDFs do DANFE
    └── EnvioResposta\  # arquivos do envio
```

### Atualizando a versão portátil

> **Importante: não substitua a pasta `db\`.** O pacote traz um `notas.db` **vazio**. Se você copiar a pasta `db\` do pacote por cima da sua, **as configurações de e-mail são apagadas**.

Copie os outros arquivos e pastas do pacote por cima da instalação antiga e mantenha a sua pasta `db\`. O banco da versão anterior é atualizado sozinho na primeira execução, sem perder dados.

Para trocar a versão portátil pelo instalador: instale com o `ProXML-Setup.exe` e, com o ProXML fechado, copie o `db\notas.db` da pasta portátil para `%LocalAppData%\ProXML\db`, substituindo o arquivo que está lá.

### Quem usou o instalador antigo (setupProXML.exe)

O instalador novo não substitui o antigo `setupProXML.exe`. Para trocar:

1. Se quiser manter as configurações, copie antes o `db\notas.db` da pasta onde o ProXML antigo está instalado para um lugar seguro.
2. Desinstale a versão antiga pelo Windows, em **Configurações → Aplicativos**.
3. Instale com o **`ProXML-Setup.exe`**.
4. Com o ProXML fechado, copie o `notas.db` guardado para `%LocalAppData%\ProXML\db`, substituindo o arquivo que está lá. O banco antigo é atualizado sozinho na primeira execução.

### Requisitos

- **Windows 10 ou 11** (32 ou 64 bits).

## Como usar

1. Clique em **Selecionar…** (ou no campo da pasta) e escolha a pasta com os XMLs. Você também pode arrastar a pasta para a janela.
2. Clique em **Processar**. Acompanhe o progresso e, se quiser, clique em **Cancelar**.
3. Veja os totais nos cards e, no **Resumo**, os contadores e os **Detalhes da leitura**.
4. Escolha **Todos**, **NF-e 55** ou **NFC-e 65** na barra de cima: cards, grade, relatórios e e-mail mudam na hora.
5. Use o menu lateral:

| Tela              | O que faz                                                                                                  |
|-------------------|------------------------------------------------------------------------------------------------------------|
| **Resumo**        | Contadores, tempo, avisos e detalhes da última leitura.                                                    |
| **Notas**         | Grade com busca e ordenação; **Copiar chave**, **Gerar DANFE** e **Exportar CSV**.                         |
| **Relatórios**    | **Relatório de Notas** e **Relatório IBS/CBS**: **Gerar relatório** grava as notas e abre a visualização.  |
| **Enviar**        | Mostra o anexo e envia os XMLs por e-mail para o endereço em **Para**.                                     |
| **Configurações** | Servidor SMTP, porta, SSL/TLS, e-mail, senha e mensagem padrão; **Testar conexão** e **Salvar**.           |

O link **Sobre**, no canto do cabeçalho, mostra a versão, o autor e os créditos.

### Atalhos de teclado

| Atalho                         | Ação                                         |
|--------------------------------|----------------------------------------------|
| **Ctrl+O**                     | Selecionar a pasta                           |
| **F5**                         | Processar                                    |
| **Esc**                        | Cancelar a leitura (durante o processamento) |
| **Ctrl+F**                     | Ir para a busca da tela Notas                |
| **Esc** (no campo Buscar)      | Limpar a busca                               |
| **Ctrl+C** (na grade)          | Copiar a chave da nota selecionada           |
| **Ctrl+D** ou duplo clique     | Gerar o DANFE da nota selecionada            |
| **Tab**, **Enter**, **Espaço** | Navegar entre os controles e acionar botões  |

### Configuração de e-mail

Em **Configurações**, informe o **Servidor SMTP**, a **Porta**, marque **SSL** e/ou **TLS** conforme o provedor e preencha **E-mail (usuário)** e **Senha**. Use **Testar conexão** para conferir antes de salvar. Exemplo para Gmail: `smtp.gmail.com`, porta `465` com SSL ou `587` com TLS, usando uma *senha de app*.

> A senha fica gravada **sem criptografia** no arquivo `db\notas.db`. Não compartilhe esse arquivo depois de configurado.

## Limitações conhecidas

| O que acontece | O que fazer |
|----------------|-------------|
| XMLs em caminhos com **mais de 259 caracteres** (pasta + nome do arquivo) não são lidos. | Use uma pasta com caminho mais curto (ex.: `C:\XMLs`). |
| Caracteres fora do padrão do Windows em português no nome da pasta (ex.: emoji, alguns idiomas) se perdem, e a pasta não é encontrada. | Renomeie a pasta usando só letras, números e acentos comuns. |
| Se um layout do DANFE (`Report\`) estiver corrompido, o PDF não sai e o programa só volta para a tela Notas, sem mensagem de erro. | Execute o instalador de novo ou, na versão portátil, copie a pasta `Report\` do `ProXML.zip`. |
| Ao arrastar a janela para um monitor com escala maior, as caixas de SSL e TLS ficam pequenas. | Continuam funcionando. Para o tamanho certo, feche e abra o ProXML nesse monitor. |
| Na tela **Enviar**, a faixa de erro pode fazer aparecer uma barra de rolagem. | Role a tela: todos os campos e botões continuam acessíveis. |
| O tamanho mínimo da janela cresce com a escala do Windows (1024×640 vezes a escala: 1280×800 em 125%, 1536×960 em 150%), limitado ao tamanho da tela. | Nada: é o espaço que o conteúdo precisa nessa escala. |
| **Nota cancelada continua somada.** O cancelamento é um evento separado e o XML da nota continua autorizado. | Retire da pasta os XMLs das notas canceladas antes de processar. |
| Com a janela no tamanho mínimo, a Chave pode aparecer cortada com "…" na grade. | **Copiar chave** copia a chave inteira. Para vê-la na grade, aumente a janela. |
| Fora da escala de 100%, a visualização do relatório na tela pode ficar um pouco diferente do PDF. | O PDF não depende da escala: use o PDF como referência. |
| A senha do e-mail fica sem criptografia no `db\notas.db`. | Não compartilhe o arquivo `db\notas.db`. |

## Desenvolvimento

### Ferramentas

- **Embarcadero Delphi 10.2 Tokyo** (projeto VCL, Win32)
- Componentes de terceiros:
  - [ACBr](https://projetoacbr.com.br/) — `ACBrNFe`, `ACBrNFeDANFEFR`, `ACBrMail`
  - [FastReport VCL](https://www.fast-report.com/) — DANFE e DANFCe
  - [QuickReport](https://www.quickreport.co.uk/) — Relatório de Notas e Relatório IBS/CBS
  - [Skia4Delphi](https://github.com/skia4delphi/skia4delphi) — ícones SVG, logo e animação
- FireDAC com driver **SQLite** (nativo do Delphi)
- [Inno Setup 6](https://jrsoftware.org/isinfo.php) — instalador (`winget install JRSoftware.InnoSetup`)

### Compilando

1. Instale os componentes acima na IDE.
2. Abra o `ProXML.dproj` e compile na configuração **Release / Win32** (é ela que tem a VersionInfo 1.2.0 e o suporte à escala do Windows). Pela linha de comando:

   ```bat
   call "C:\Program Files (x86)\Embarcadero\Studio\19.0\bin\rsvars.bat"
   msbuild ProXML.dproj /t:Build /p:Config=Release /p:Platform=Win32 /p:DCC_ExeOutput=bin /p:DCC_DcuOutput=<pasta temporária>
   ```

3. Em `bin\` já estão `Report\`, `Schemas\` e `db\`. Copie para lá o `sk4d.dll`.

### Gerando o instalador

O script fica em `installer/`: `ProXML.iss` (Inno Setup 6) e `build.ps1`, que monta a pasta de staging e chama o compilador do Inno (`ISCC.exe`).

1. Compile o exe **Release** numa pasta fora de `bin\` (o `build.ps1` recusa o `bin\ProXML.exe`), com a VersionInfo da versão que vai ser gerada.
2. Rode:

   ```bat
   powershell -NoProfile -ExecutionPolicy Bypass -File installer\build.ps1 -Version 1.2.0 -ExePath <pasta do build>\ProXML.exe
   ```

O `build.ps1` confere se a FileVersion do exe é a mesma de `-Version`, pega `Report\`, `Schemas\`, o `db\notas.db` vazio e o `LICENSE-lucide.txt` do `HEAD` do git (só o que está versionado), junta o exe e o `bin\sk4d.dll` e recusa `ErroLog.txt`, `WinRAR.exe`, conteúdo em `NFCe\` e nomes de arquivo com 14 ou mais dígitos seguidos. O setup sai em `installer\Output\ProXML-Setup.exe` (fora do git), com o tamanho e o SHA-256 no fim da execução. O `AppId` do `ProXML.iss` é fixo: não o altere, senão a atualização deixa de substituir a versão instalada.

### Estrutura do código

```text
ProXML.dpr                         # programa principal
view/
  ProXML.FormPrincipal.pas         # tela principal: menu, barra de pasta, cards, Resumo, Notas,
                                   #   Relatórios, Enviar, Configurações, Sobre, DANFE e e-mail
  ProXML.FormRelatorios.pas        # Relatório de Notas (QuickReport)
  ProXML.FormRelatorioIBSCBS.pas   # Relatório IBS/CBS (QuickReport)
  ProXML.Tema.pas                  # cores, fontes e medidas da interface (fonte única do tema)
  ProXML.Botao.pas                 # TProBotao: botão próprio (foco, hover, desabilitado, modo menu)
  ProXML.Icones.pas                # ícones SVG Lucide usados na interface
  ProXML.FrameLoad.pas             # animação da tela Carregando
lib/
  uCalculadoraXML.pas              # leitura e validação dos XMLs (55 e 65, IBS/CBS) em thread
datamodule/
  DM.pas                           # conexão SQLite (FireDAC), migração do banco, notas, config e LOG
classes/
  ProXML.Classes.pas               # TConfig (configurações de e-mail)
src/                               # imagens, ícones e animações
bin/                               # Report/, Schemas/ e db/ (saída da compilação)
installer/
  ProXML.iss                       # script do instalador (Inno Setup 6)
  build.ps1                        # gera installer\Output\ProXML-Setup.exe
docs/
  planos/                          # planos de cada versão e decisões
  ui/                              # tokens visuais, glossário de textos, ícones, logo e mockups
tests/gabarito/                    # gabarito dos totais usado nos testes
```

### Banco de dados

SQLite em `db\notas.db`, na pasta do `ProXML.exe` (não depende da pasta de trabalho do atalho), criado na primeira execução se não existir. No repositório fica em `bin\db\notas.db`; no instalador, em `%LocalAppData%\ProXML\db\notas.db`. Tabelas:

| Tabela   | Conteúdo                                                                                        |
|----------|-------------------------------------------------------------------------------------------------|
| `nf`     | Notas gravadas para os relatórios (número, chave, valor, data, BC, ICMS, XML, modelo e IBS/CBS) |
| `config` | Configurações SMTP, mensagem padrão e preferências da tela                                      |
| `LOG`    | Registro de erros da aplicação                                                                  |

Colunas novas da v1.1.0:

- `nf`: `MODELO`, `TEM_IBSCBS`, `VBCIBSCBS`, `VIBSUF`, `VIBSMUN`, `VIBS` e `VCBS`;
- `config`: `ULTIMA_PASTA`, `JANELA_ESQUERDA`, `JANELA_TOPO`, `JANELA_LARGURA`, `JANELA_ALTURA` e `JANELA_MAXIMIZADA`.

Ao abrir um banco da v1.0.0, o programa cria as colunas que faltam (`ALTER TABLE`), sem perder os dados. A gravação das notas é feita numa única transação.

## Créditos e licenças

- Ícones: [Lucide](https://lucide.dev) (licença ISC; ícones derivados do Feather, licença MIT). O texto das licenças vai no pacote, em `LICENSE-lucide.txt`.
- Componentes: [ACBr](https://projetoacbr.com.br/) e [Skia4Delphi](https://github.com/skia4delphi/skia4delphi).

## Autor

**Caique Garcia** — [GitHub](https://github.com/Caique-Garcia)
