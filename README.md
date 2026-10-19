# Pro XML

Aplicativo desktop para Windows, desenvolvido em **Delphi (VCL)**, que lê uma pasta de XMLs de **NF-e (modelo 55)** e **NFC-e (modelo 65)**, totaliza os valores das notas autorizadas (incluindo **IBS/CBS** da Reforma Tributária) e facilita a conferência, impressão e envio desses arquivos.

> ⬇️ **[Baixar a versão mais recente (ProXML.rar)](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML.rar)** — ou veja todas as versões na página de [Releases](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases).

---

## Funcionalidades

- **Processamento em lote** de todos os arquivos `*.xml` de uma pasta. A cada clique em **Processar**, a grade é limpa e mostra só a pasta atual.
- **Validação** de cada XML:
  - aceita **NF-e modelo 55** e **NFC-e modelo 65** (outros modelos são ignorados e listados no log);
  - considera autorizada a nota com `cStat` **100** (autorizado o uso) ou **150** (autorizado fora de prazo), lido do protocolo (`protNFe`);
  - notas não autorizadas (ex.: denegadas) ficam fora de todos os totais e aparecem no log com o código, por exemplo `Nota Fiscal 123 - não autorizada (cStat 110)`;
  - arquivos inválidos ou sem protocolo são listados no log da tela.
- **Filtro por modelo**: seletor **Todos / NF-e 55 / NFC-e 65** ao lado do botão Processar. A grade, os cartões de totais e os dois relatórios respeitam o filtro.
- **Totalizadores**: Valor Total, Base de Cálculo do ICMS, Valor do ICMS, **Total IBS** e **Total CBS**.
- **IBS/CBS (NT 2025.002)**: quando o XML tem o grupo `IBSCBSTot`, são lidos Base IBS/CBS (`vBCIBSCBS`), IBS UF (`vIBSUF`), IBS Município (`vIBSMun`), IBS total (`vIBS`) e CBS (`vCBS`).
- **Grade de notas** com modelo, número, chave, data e valores. Pelo menu de contexto (botão direito):
  - **Copiar Chave** de acesso para a área de transferência;
  - **Gerar DANFe** em PDF (ACBr + FastReport), aberto automaticamente. O layout é escolhido por nota:
    - NFC-e (65) → DANFCe A4;
    - NF-e (55) com `tpImp=1` → DANFE **retrato**;
    - NF-e (55) com `tpImp=2` → DANFE **paisagem**;
    - outros `tpImp` (ex.: DANFE simplificado) não são suportados e geram uma mensagem.
- **Relatório** das notas processadas (QuickReport), com coluna Modelo, totais e quantidade de registros.
- **Relatório IBS/CBS**: lista só as notas que têm IBS/CBS (Modelo, Número, Data, Base IBS/CBS, IBS UF, IBS Mun., IBS e CBS), com os somatórios no rodapé.
- **Envio por e-mail**: compacta os XMLs processados (respeitando o filtro de modelo) em `NFCe_ProXML.rar` e envia como anexo.
- **Configurações SMTP** (servidor, porta, e-mail, senha, SSL/TLS e mensagem padrão) salvas localmente.

> **Atenção (NF-e 55):** as notas de **entrada** (`tpNF=0`) e de **saída** (`tpNF=1`) são **somadas juntas**, sem distinção. Se a pasta tiver compras e vendas misturadas, os totais misturam as duas. Para conferir só vendas, processe uma pasta que contenha apenas as notas de saída.

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

### Atualizando de uma versão anterior

Substitua os arquivos da pasta do programa pelos do novo pacote, **mantendo a sua pasta `db\`** (ela guarda as configurações de e-mail). O banco da versão anterior é atualizado automaticamente na primeira execução.

## Como usar

1. Clique no ícone de pasta e selecione o diretório com os XMLs de NF-e/NFC-e.
2. Clique em **Processar**. Os totais aparecem nos cartões do topo e o log mostra os arquivos ignorados.
3. Se quiser, escolha **Todos**, **NF-e 55** ou **NFC-e 65** no filtro de modelo: grade e cartões são recalculados na hora.
4. Use o menu lateral:

| Opção                 | O que faz                                                                  |
|-----------------------|----------------------------------------------------------------------------|
| **Resumo**            | Log do processamento (arquivos lidos, ignorados e com erro).               |
| **Notas**             | Grade com as notas autorizadas (botão direito: copiar chave / DANFe).      |
| **Relatório**         | Grava as notas no banco local e abre a pré-visualização do relatório.      |
| **Relatório IBS/CBS** | Pré-visualização só das notas com IBS/CBS, respeitando o filtro de modelo. |
| **Enviar**            | Compacta os XMLs e envia por e-mail para o destinatário informado.         |
| **Configurações**     | Dados do servidor SMTP e mensagem padrão do e-mail.                        |

### Configuração de e-mail

Em **Configurações**, informe SMTP, porta, e-mail, senha e marque **SSL** e/ou **TLS** conforme o provedor. Exemplo para Gmail: `smtp.gmail.com`, porta `465` com SSL (use uma *senha de app*).

> Os dados ficam no arquivo `db\notas.db` **sem criptografia**. Não compartilhe esse arquivo depois de configurado.

## Desenvolvimento

### Requisitos

- **Embarcadero Delphi 10.2 Tokyo** (projeto VCL, Win32)
- Componentes de terceiros:
  - [ACBr](https://projetoacbr.com.br/) — `ACBrNFe`, `ACBrNFeDANFEFR`, `ACBrNFeDANFeFPDF`, `ACBrMail`
  - [FastReport VCL](https://www.fast-report.com/) — impressão do DANFe/DANFCe
  - [QuickReport](https://www.quickreport.co.uk/) — relatórios de notas e de IBS/CBS
  - [Skia4Delphi](https://github.com/skia4delphi/skia4delphi) — ícones SVG e animações
- FireDAC com driver **SQLite** (nativo do Delphi)

### Compilando

1. Instale os componentes acima na IDE.
2. Abra `ProXML.dproj`.
3. Compile. O executável é gerado em `bin\`, onde já estão `Report\`, `Schemas\` e `db\`.
4. Copie `sk4d.dll` (e, opcionalmente, `WinRAR.exe`) para `bin\`.

### Estrutura do código

```
ProXML.dpr                         # programa principal
view/
  ProXML.FormPrincipal.pas         # tela principal: menu, filtro, grade, DANFe, e-mail, configurações
  ProXML.FormRelatorios.pas        # relatório de notas (QuickReport)
  ProXML.FormRelatorioIBSCBS.pas   # relatório IBS/CBS (QuickReport)
  ProXML.FrameLoad.pas             # frame de carregamento
lib/
  uCalculadoraXML.pas              # leitura/validação dos XMLs (55 e 65, IBS/CBS) e conversão numérica
datamodule/
  DM.pas                           # conexão SQLite (FireDAC), migração do banco e persistência: notas, config, log
classes/
  ProXML.Classes.pas               # TConfig (configurações de e-mail)
src/                               # imagens, ícones SVG e animações
bin/                               # saída da compilação + Report/, Schemas/, db/
install/                           # instalador
```

### Banco de dados

SQLite em `bin\db\notas.db`, criado automaticamente na primeira execução com as tabelas:

| Tabela   | Conteúdo                                                                                  |
|----------|-------------------------------------------------------------------------------------------|
| `nf`     | Notas processadas (número, chave, valor, data, BC, ICMS, XML, modelo e campos de IBS/CBS) |
| `config` | Configurações SMTP e mensagem padrão                                                      |
| `LOG`    | Registro de erros da aplicação                                                            |

Colunas adicionadas na v1.1.0 à tabela `nf`: `MODELO`, `TEM_IBSCBS`, `VBCIBSCBS`, `VIBSUF`, `VIBSMUN`, `VIBS` e `VCBS`. Ao abrir um banco da v1.0.0, o programa cria essas colunas automaticamente (`ALTER TABLE`), sem perder os dados existentes. A gravação das notas é feita em uma única transação.

## Autor

**Caique Garcia** — [GitHub](https://github.com/Caique-Garcia)
