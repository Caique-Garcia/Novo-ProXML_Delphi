# ProXML

Totalizador de XMLs de NF-e (55) e NFC-e (65) com IBS/CBS, DANFE e relatórios - Delphi VCL.

Aplicativo desktop para Windows que lê uma pasta de XMLs de **NF-e (modelo 55)** e **NFC-e (modelo 65)**, soma os valores das notas autorizadas (incluindo **IBS/CBS** da Reforma Tributária) e facilita a conferência, a impressão e o envio desses arquivos.

> ⬇️ **[Baixar a versão mais recente (ProXML.rar)](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML.rar)** — ou veja todas as versões na página de [Releases](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases).

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
- Layout novo em A4: período das notas, modelo do filtro, pasta de origem, colunas alinhadas, valores em `R$`, linha de total e rodapé "Gerado pelo ProXML v1.1.0 · data e hora · Página X de Y".

### E-mail

- Tela **Enviar** mostra o anexo antes de enviar (quantidade de XMLs e tamanho). Os XMLs só são compactados quando você clica em **Enviar**, e o envio acontece em segundo plano.
- **Configurações** com validação dos campos e **Testar conexão**, que conecta e autentica no servidor **sem enviar e-mail**.

### Interface

- **Visual novo:** janela redimensionável e maximizável, menu lateral (**Resumo**, **Notas**, **Relatórios**, **Enviar**, **Configurações**) e tela **Sobre**.
- **Arrastar e soltar** uma pasta do Explorer na janela.
- Lembra a **última pasta** e o **tamanho e a posição da janela**.
- **Escala do Windows:** 100%, 125%, 150% e dois monitores com escalas diferentes.
- Uso completo pelo teclado (Tab, Enter, Espaço e os atalhos abaixo).

## Instalação

1. Baixe o **[ProXML.rar](https://github.com/Caique-Garcia/Novo-ProXML_Delphi/releases/latest/download/ProXML.rar)**.
2. Extraia o conteúdo para uma pasta (ex.: `C:\ProXML`).
3. Execute o **`ProXML.exe`**.

O pacote traz tudo o que o programa precisa:

```
ProXML\
├── ProXML.exe          # programa
├── sk4d.dll            # Skia4Delphi (ícones e animação)
├── LICENSE-lucide.txt  # licença dos ícones Lucide
├── db\notas.db         # banco local, vazio
├── Report\             # layouts do DANFE e do DANFCe (FastReport)
├── Schemas\            # schemas XSD usados pelo ACBr
└── NFCe\               # saída: PDFs do DANFE e arquivos do envio
```

### Atualizando de uma versão anterior

> **Importante: não substitua a pasta `db\`.** O pacote traz um `notas.db` **vazio**. Se você copiar a pasta `db\` do pacote por cima da sua, **as configurações de e-mail são apagadas**.

Copie os outros arquivos e pastas do pacote por cima da instalação antiga e mantenha a sua pasta `db\`. O banco da versão anterior é atualizado sozinho na primeira execução, sem perder dados.

### Requisitos

- **Windows 10 ou 11** (32 ou 64 bits).
- Para enviar por e-mail: o **`WinRAR.exe`** na mesma pasta do `ProXML.exe` (ele compacta os XMLs). A compactação ZIP sem WinRAR está prevista para a v1.2.0.

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
| Se um layout do DANFE (`Report\`) estiver corrompido, o PDF não sai e o programa só volta para a tela Notas, sem mensagem de erro. | Reinstale a pasta `Report\` a partir do pacote. |
| Ao arrastar a janela para um monitor com escala maior, as caixas de SSL e TLS ficam pequenas. | Continuam funcionando. Para o tamanho certo, feche e abra o ProXML nesse monitor. |
| Na tela **Enviar**, a faixa de erro pode fazer aparecer uma barra de rolagem. | Role a tela: todos os campos e botões continuam acessíveis. |
| O tamanho mínimo da janela cresce com a escala do Windows (1024×640 vezes a escala: 1280×800 em 125%, 1536×960 em 150%), limitado ao tamanho da tela. | Nada: é o espaço que o conteúdo precisa nessa escala. |
| O envio por e-mail depende do `WinRAR.exe` na pasta do ProXML. | Copie o `WinRAR.exe` para a pasta do programa (até a v1.2.0, com ZIP nativo). |
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

### Compilando

1. Instale os componentes acima na IDE.
2. Abra o `ProXML.dproj` e compile na configuração **Release / Win32** (é ela que tem a VersionInfo 1.1.0 e o suporte à escala do Windows). Pela linha de comando:

   ```bat
   call "C:\Program Files (x86)\Embarcadero\Studio\19.0\bin\rsvars.bat"
   msbuild ProXML.dproj /t:Build /p:Config=Release /p:Platform=Win32 /p:DCC_ExeOutput=bin /p:DCC_DcuOutput=<pasta temporária>
   ```

3. Em `bin\` já estão `Report\`, `Schemas\` e `db\`. Copie para lá o `sk4d.dll` (e, para o e-mail, o `WinRAR.exe`).

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
docs/
  planos/                          # planos de cada versão e decisões
  ui/                              # tokens visuais, glossário de textos, ícones, logo e mockups
tests/gabarito/                    # gabarito dos totais usado nos testes
```

### Banco de dados

SQLite em `bin\db\notas.db`, criado na primeira execução se não existir:

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
