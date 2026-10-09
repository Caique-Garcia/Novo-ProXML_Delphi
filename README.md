# Pro XML

Aplicativo desktop para Windows, desenvolvido em **Delphi (VCL)**, que lê uma pasta de XMLs de **NFC-e (modelo 65)**, totaliza os valores das notas autorizadas e facilita a conferência, impressão e envio desses arquivos.

> ⬇️ **[Baixar a versão mais recente (ProXML.rar)](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML.rar)** — ou veja todas as versões na página de [Releases](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases).

---

## Funcionalidades

- **Processamento em lote** de todos os arquivos `*.xml` de uma pasta.
- **Validação** de cada XML:
  - aceita apenas NFC-e **modelo 65**;
  - considera apenas notas com protocolo **"Autorizado o uso da NF-e"**;
  - arquivos inválidos ou não autorizados são listados no log da tela.
- **Totalizadores**: Valor Total, Base de Cálculo do ICMS e Valor do ICMS.
- **Grade de notas** com número, chave, data e valores. Pelo menu de contexto (botão direito):
  - **Copiar Chave** de acesso para a área de transferência;
  - **Gerar DANFe** (DANFCe em PDF via ACBr + FastReport), aberto automaticamente.
- **Relatório** das notas processadas (QuickReport), com totais e quantidade de registros.
- **Envio por e-mail**: compacta os XMLs processados em `NFCe_ProXML.rar` e envia como anexo.
- **Configurações SMTP** (servidor, porta, e-mail, senha, SSL/TLS e mensagem padrão) salvas localmente.

## Instalação (usuário final)

1. Baixe o **[ProXML.rar](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML.rar)** na página de Releases.
2. Extraia o conteúdo para uma pasta (ex.: `C:\ProXML`).
3. Execute **`ProXML.exe`**.

O pacote já contém tudo o que o programa precisa:

```
ProXML\
├── ProXML.exe      # executável
├── sk4d.dll        # runtime do Skia4Delphi (interface/SVG)
├── db\notas.db     # banco SQLite local (criado automaticamente se não existir)
├── Report\         # layouts FastReport (DANFe/DANFCe e outros)
├── Schemas\        # schemas XSD usados pelo ACBr
└── NFCe\           # saída: PDFs de DANFe e arquivos para envio
```

> **Envio por e-mail:** a compactação dos XMLs usa o `WinRAR.exe`, que deve estar **na mesma pasta do `ProXML.exe`**. Sem ele, o anexo `.rar` não é gerado.

## Como usar

1. Clique no ícone de pasta e selecione o diretório com os XMLs de NFC-e.
2. Clique em **Processar**. Os totais aparecem nos cartões do topo e o log mostra os arquivos ignorados.
3. Use o menu lateral:

| Opção             | O que faz                                                            |
|-------------------|----------------------------------------------------------------------|
| **Resumo**        | Log do processamento (arquivos lidos, ignorados e com erro).         |
| **Notas**         | Grade com as notas autorizadas (botão direito: copiar chave / DANFe). |
| **Relatório**     | Grava as notas no banco local e abre a pré-visualização do relatório. |
| **Enviar**        | Compacta os XMLs e envia por e-mail para o destinatário informado.   |
| **Configurações** | Dados do servidor SMTP e mensagem padrão do e-mail.                  |

### Configuração de e-mail

Em **Configurações**, informe SMTP, porta, e-mail, senha e marque **SSL** e/ou **TLS** conforme o provedor. Exemplo para Gmail: `smtp.gmail.com`, porta `465` com SSL (use uma *senha de app*).

> Os dados ficam no arquivo `db\notas.db` **sem criptografia**. Não compartilhe esse arquivo depois de configurado.

## Desenvolvimento

### Requisitos

- **Embarcadero Delphi 10.4 Sydney** ou superior (projeto VCL, Win32)
- Componentes de terceiros:
  - [ACBr](https://projetoacbr.com.br/) — `ACBrNFe`, `ACBrNFeDANFEFR`, `ACBrNFeDANFeFPDF`, `ACBrMail`
  - [FastReport VCL](https://www.fast-report.com/) — impressão do DANFCe
  - [QuickReport](https://www.quickreport.co.uk/) — relatório de notas
  - [Skia4Delphi](https://github.com/skia4delphi/skia4delphi) — ícones SVG e animações
- FireDAC com driver **SQLite** (nativo do Delphi)

### Compilando

1. Instale os componentes acima na IDE.
2. Abra `ProXML.dproj`.
3. Compile. O executável é gerado em `bin\`, onde já estão `Report\`, `Schemas\` e `db\`.
4. Copie `sk4d.dll` (e, opcionalmente, `WinRAR.exe`) para `bin\`.

### Estrutura do código

```
ProXML.dpr                     # programa principal
view/
  ProXML.FormPrincipal.pas     # tela principal: menu, grade, DANFe, e-mail, configurações
  ProXML.FormRelatorios.pas    # relatório de notas (QuickReport)
  ProXML.FrameLoad.pas         # frame de carregamento
lib/
  uCalculadoraXML.pas          # leitura/validação dos XMLs e cálculo dos totais
datamodule/
  DM.pas                       # conexão SQLite (FireDAC) e persistência: notas, config, log
classes/
  ProXML.Classes.pas           # TConfig (configurações de e-mail)
src/                           # imagens, ícones SVG e animações
bin/                           # saída da compilação + Report/, Schemas/, db/
install/                       # instalador
```

### Banco de dados

SQLite em `bin\db\notas.db`, criado automaticamente na primeira execução com as tabelas:

| Tabela   | Conteúdo                                                        |
|----------|-----------------------------------------------------------------|
| `nf`     | Notas processadas (número, chave, valor, data, BC, ICMS, XML)   |
| `config` | Configurações SMTP e mensagem padrão                            |
| `LOG`    | Registro de erros da aplicação                                  |

## Autor

**Caique Garcia** — [GitHub](https://github.com/Caique-Garcia)
