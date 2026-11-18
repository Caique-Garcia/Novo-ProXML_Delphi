# Planejamento Técnico — Apuração de Antecipação e DIFAL de ICMS

## 1. Objetivo do projeto

O objetivo é ampliar o sistema atual de conciliação de XMLs de documentos fiscais, desenvolvido em Delphi 10.2, para permitir o cálculo de:

- Antecipação tributária do ICMS.
- Diferencial de Alíquota (DIFAL) do ICMS.

Atualmente, o sistema já realiza:

- Importação e conciliação de XMLs de NF-e.
- Apresentação dos valores dos documentos fiscais.
- Apuração e apresentação dos impostos ICMS, IBS e CBS.
- Geração de relatórios fiscais.

A nova funcionalidade deverá identificar operações interestaduais, classificar os produtos conforme sua finalidade e aplicar as regras tributárias correspondentes.

O objetivo final é transformar o conciliador de XML em uma ferramenta de conferência tributária, permitindo identificar valores adicionais de ICMS que possam ser devidos pela empresa.

## 2. Conceitos tributários

### 2.1. Antecipação tributária do ICMS

A antecipação tributária ocorre em determinadas operações nas quais o contribuinte precisa recolher antecipadamente o ICMS relativo à operação subsequente, conforme as regras da legislação estadual.

Uma fórmula simplificada utilizada em determinadas hipóteses é:

**Antecipação = (Base de cálculo × Alíquota interna) − ICMS de origem**

Exemplo:

- Base de cálculo: R$ 1.000,00
- Alíquota interna: 18%
- ICMS destacado na nota: R$ 120,00

Cálculo:

- ICMS interno: R$ 1.000,00 × 18% = R$ 180,00
- ICMS de origem: R$ 120,00
- Antecipação: R$ 60,00

Essa fórmula é ilustrativa. Existem modalidades de antecipação com bases, deduções e condições específicas.

### 2.2. Diferencial de alíquota (DIFAL)

O DIFAL corresponde à diferença entre a alíquota interna do estado de destino e a alíquota interestadual, nas hipóteses previstas na legislação.

É especialmente relevante nas aquisições interestaduais destinadas a:

- Uso e consumo.
- Ativo imobilizado.

Fórmula simplificada:

**DIFAL = Base de cálculo × (Alíquota interna − Alíquota interestadual)**

Exemplo:

- Base de cálculo: R$ 1.000,00
- Alíquota interna: 18%
- Alíquota interestadual: 12%

Cálculo:

- DIFAL: R$ 1.000,00 × (18% − 12%)
- DIFAL: R$ 60,00

A fórmula definitiva deverá considerar a composição da base de cálculo, o regime tributário, eventuais benefícios fiscais e as particularidades da legislação estadual.

### 2.3. Diferença entre antecipação e DIFAL

Os dois cálculos não devem ser tratados como uma única operação.

| Característica | Antecipação | DIFAL |
|---|---|---|
| Finalidade | Antecipação do ICMS | Recolhimento da diferença entre alíquotas |
| Operações | Conforme hipótese legal | Conforme hipótese legal |
| Destinação | Pode envolver revenda e industrialização | Uso, consumo e ativo imobilizado, entre outras hipóteses específicas |
| Fórmula | Depende da modalidade | Depende da operação e da base aplicável |

O sistema deverá manter classificações e regras independentes.

## 3. Identificação das operações pelo XML

O sistema já realiza a leitura dos XMLs. Portanto, diversas informações necessárias poderão ser aproveitadas.

### 3.1. Informações necessárias

| Informação | Origem no XML |
|---|---|
| UF do fornecedor | emit/enderEmit/UF |
| UF do destinatário | dest/enderDest/UF |
| CRT do fornecedor | emit/CRT |
| CFOP | det/prod/CFOP |
| NCM | det/prod/NCM |
| CEST | det/prod/CEST |
| CST/CSOSN | det/imposto/ICMS |
| Base ICMS | Grupo ICMS do item |
| Alíquota ICMS | Grupo ICMS do item |
| Valor ICMS | Grupo ICMS do item |
| Valor do produto | det/prod/vProd |
| Frete | Valores do documento e rateios |
| Despesas acessórias | Valores do documento e rateios |

### 3.2. Informações complementares

Nem todas as informações necessárias estão presentes no XML.

O sistema precisará identificar a finalidade da aquisição:

- Revenda.
- Industrialização.
- Uso e consumo.
- Ativo imobilizado.

Essa classificação poderá ser obtida por meio de:

1. Cadastro de finalidade no produto.
2. Configuração por CFOP, sujeita à confirmação.
3. Classificação manual pelo usuário na entrada.
4. Regras de classificação automática com possibilidade de correção.

**Importante:** o CFOP não deve ser utilizado isoladamente para determinar o enquadramento tributário.

## 4. Classificação tributária dos produtos

Sugestão de classificação:

| Classificação | Tratamento |
|---|---|
| Revenda | Verificar antecipação |
| Industrialização | Verificar antecipação |
| Uso e consumo | Verificar DIFAL |
| Ativo imobilizado | Verificar DIFAL |
| Produto sujeito à ST | Verificar regras de ICMS-ST |
| Isento/não tributado | Verificar tratamento específico |

O sistema deverá permitir que o usuário identifique produtos sem classificação ou com enquadramento tributário pendente.

## 5. Regras tributárias

As regras não devem ficar fixas no código Delphi.

Recomenda-se criar um cadastro de regras tributárias com:

- Tipo de apuração.
- UF de origem.
- UF de destino.
- Regime tributário.
- Finalidade da mercadoria.
- NCM, quando aplicável.
- CFOP, quando aplicável.
- CST/CSOSN, quando aplicável.
- Alíquota interna.
- Alíquota interestadual.
- Composição da base de cálculo.
- Forma de dedução do ICMS de origem.
- Benefícios fiscais.
- Data inicial de vigência.
- Data final de vigência.

### 5.1. Cuidados com regimes tributários

O sistema deverá considerar as diferenças entre:

- Simples Nacional.
- Lucro Presumido.
- Lucro Real.

O Simples Nacional possui hipóteses específicas de antecipação, inclusive em operações destinadas à comercialização e industrialização.

Não se deve aplicar automaticamente a mesma fórmula e o mesmo tratamento a todos os regimes.

### 5.2. ICMS-ST

A substituição tributária precisa ser tratada separadamente.

O sistema deverá verificar:

- Se a mercadoria está sujeita à ST.
- Se houve retenção na origem.
- Se existe obrigação de recolhimento complementar.
- Se há convênio ou protocolo aplicável.
- Se a operação possui alguma exceção.

Não confundir ICMS-ST com antecipação do ICMS próprio ou DIFAL.

### 5.3. Alíquotas interestaduais

A identificação da alíquota interestadual deverá considerar:

- UF de origem.
- UF de destino.
- Origem da mercadoria.
- Regras aplicáveis às mercadorias importadas.
- Alíquota interestadual de 4%, quando aplicável.

## 6. Estrutura do banco de dados MariaDB

Recomenda-se criar tabelas específicas para armazenar as regras e os resultados das apurações.

### 6.1. Tabela icmsRegraApuracao

Armazena as regras tributárias.

| Campo | Tipo | Finalidade |
|---|---|---|
| id | INT | Identificador |
| descricao | VARCHAR(100) | Descrição da regra |
| tipo | VARCHAR(2) | AN = Antecipação / DI = DIFAL |
| ufOrigem | CHAR(2) | UF de origem |
| ufDestino | CHAR(2) | UF de destino |
| regimeTributario | VARCHAR(2) | Regime do destinatário |
| finalidade | VARCHAR(2) | Finalidade da aquisição |
| ncm | VARCHAR(8) | NCM específico |
| cfop | VARCHAR(4) | CFOP específico |
| aliquotaInterna | DECIMAL(9,4) | Alíquota interna |
| aliquotaInterestadual | DECIMAL(9,4) | Alíquota interestadual |
| tipoBase | VARCHAR(2) | Tipo de composição da base |
| ativo | CHAR(1) | Regra ativa |
| dtInicio | DATE | Início da vigência |
| dtFim | DATE | Fim da vigência |

Os campos de classificação poderão aceitar valores genéricos quando a regra não depender de uma característica específica.

A estrutura definitiva deverá contemplar também critérios de prioridade e especificidade das regras.

### 6.2. Tabela icmsApuracaoEntrada

Armazena os resultados dos cálculos por documento e item.

| Campo | Tipo | Finalidade |
|---|---|---|
| id | INT | Identificador |
| nnota | VARCHAR(32) | Referência da nota |
| idItem | INT | Referência do item |
| tipoApuracao | VARCHAR(2) | AN / DI |
| baseCalculo | DECIMAL(18,6) | Base utilizada |
| aliquotaInterna | DECIMAL(9,4) | Alíquota interna |
| aliquotaInterestadual | DECIMAL(9,4) | Alíquota interestadual |
| icmsOrigem | DECIMAL(18,6) | ICMS de origem |
| valorApurado | DECIMAL(18,6) | Valor calculado |
| idRegra | INT | Regra aplicada |
| status | CHAR(1) | Situação da apuração |
| justificativa | VARCHAR(255) | Observações |

Recomenda-se preservar os parâmetros e os valores utilizados no cálculo, permitindo reproduzir a memória de cálculo mesmo quando as regras tributárias forem atualizadas.

## 7. Arquitetura no Delphi 10.2

A lógica tributária deverá ficar separada das telas VCL.

Sugestão de organização:

```text
uICMSApuracao.pas
    TICMSApuracao

uICMSRegra.pas
    TICMSRegra
    TICMSRegraDAO

uICMSAntecipacao.pas
    TICMSAntecipacao

uICMSDIFAL.pas
    TICMSDIFAL

uICMSApuracaoDAO.pas
    TICMSApuracaoDAO
```

### 7.1. Tipos e parâmetros

Exemplo de estrutura:

```delphi
type
  TTipoApuracaoICMS = (
    taAntecipacao,
    taDIFAL
  );

  TFinalidadeCompra = (
    fcRevenda,
    fcIndustrializacao,
    fcUsoConsumo,
    fcAtivoImobilizado
  );

  TICMSApuracaoParams = record
    UFOrigem: string;
    UFDestino: string;

    CRTFornecedor: Integer;
    RegimeDestinatario: Integer;

    CFOP: string;
    NCM: string;
    CST: string;

    Finalidade: TFinalidadeCompra;

    ValorOperacao: Currency;
    BaseICMS: Currency;
    ValorICMS: Currency;

    AliquotaInterna: Double;
    AliquotaInterestadual: Double;
  end;

  TICMSApuracaoResultado = record
    Tipo: TTipoApuracaoICMS;
    BaseCalculo: Currency;
    ValorICMSOrigem: Currency;
    ValorApurado: Currency;
    Mensagem: string;
  end;
```

### 7.2. Fluxo principal

O processo deverá:

1. Receber os dados do item do XML.
2. Identificar a empresa destinatária e seu regime tributário.
3. Identificar a UF de origem e destino.
4. Identificar a finalidade da aquisição.
5. Consultar as regras tributárias vigentes.
6. Validar o enquadramento.
7. Executar o cálculo correspondente.
8. Gerar a memória de cálculo.
9. Gravar o resultado no banco de dados.

O exemplo abaixo representa somente o direcionamento inicial:

```delphi
function TICMSApuracao.Calcular(
  const AParams: TICMSApuracaoParams
): TICMSApuracaoResultado;
begin
  Result.ValorApurado := 0;

  if AParams.Finalidade in
    [fcUsoConsumo, fcAtivoImobilizado] then
  begin
    Result := CalcularDIFAL(AParams);
  end
  else
  begin
    Result := CalcularAntecipacao(AParams);
  end;
end;
```

Na implementação definitiva, o direcionamento deverá consultar as regras cadastradas. Não basta verificar a finalidade da compra para determinar a obrigação tributária.

## 8. Memória de cálculo

Cada apuração deverá apresentar os valores utilizados.

Exemplo:

```text
Documento: 000012345
Item: 001
Produto: Produto A

Tipo: Antecipação

Valor da operação:       R$ 1.000,00
Base de cálculo:         R$ 1.000,00
Alíquota interna:        18,00%
Alíquota interestadual:  12,00%
ICMS de origem:          R$ 120,00

ICMS interno:            R$ 180,00
ICMS antecipado:         R$  60,00
```

Esse detalhamento permitirá que o contador confira os resultados e identifique divergências.

## 9. Interface do sistema

A funcionalidade deverá ser integrada à tela atual de conciliação de XMLs.

Sugestão de organização:

### 9.1. Resumo da apuração

Apresentar:

- Quantidade de documentos importados.
- Total de ICMS.
- Total de IBS.
- Total de CBS.
- Total de antecipação.
- Total de DIFAL.

### 9.2. Situação da apuração

Cada documento ou item poderá apresentar:

- Pendente.
- Calculado.
- Conferido.
- Ignorado.
- Sem regra tributária.
- Necessita de classificação.

### 9.3. Detalhamento

O usuário deverá conseguir consultar:

- Documento fiscal.
- Fornecedor.
- UF de origem.
- Produto.
- NCM.
- CFOP.
- Finalidade.
- Tipo de apuração.
- Base de cálculo.
- Alíquotas utilizadas.
- ICMS de origem.
- Valor apurado.
- Regra tributária aplicada.

## 10. Relatórios

Recomenda-se desenvolver três relatórios principais.

### 10.1. Relatório de antecipação

Deverá apresentar:

- Número da nota.
- Fornecedor.
- Data de emissão.
- Produto.
- NCM.
- CFOP.
- Base de cálculo.
- Alíquota interna.
- ICMS de origem.
- Valor da antecipação.

### 10.2. Relatório de DIFAL

Deverá apresentar:

- Número da nota.
- Fornecedor.
- Produto.
- Finalidade da aquisição.
- Base de cálculo.
- Alíquota interna.
- Alíquota interestadual.
- Valor do DIFAL.

### 10.3. Resumo por período

Deverá permitir agrupamentos por:

- Período.
- Fornecedor.
- UF de origem.
- Documento fiscal.
- Tipo de apuração.

Também deverá apresentar o total geral de antecipação e DIFAL.

## 11. Cuidados tributários e legais

Antes de liberar a funcionalidade, é necessário validar:

1. Regime tributário do destinatário.
2. UF de origem e destino.
3. Finalidade da mercadoria.
4. CFOP e CST/CSOSN.
5. NCM e CEST.
6. Existência de ICMS-ST.
7. Benefícios fiscais.
8. Reduções de base de cálculo.
9. Composição da base de cálculo.
10. Vigência das regras.
11. Tratamento das mercadorias importadas.
12. Regras específicas de recolhimento e obrigações acessórias.

### Referências normativas para Minas Gerais

- RICMS/MG — Decreto 48.589/2023.
- Art. 3º — Hipóteses de incidência e operações relacionadas ao DIFAL e antecipação.
- Art. 12 — Regras de base de cálculo.
- Anexo VIII — Regras de substituição tributária e antecipação.

As referências devem ser verificadas na legislação consolidada e vigente na data de cada operação.

## 12. Etapas de desenvolvimento

Sugestão de divisão do projeto:

| Etapa | Desenvolvimento |
|---|---|
| 1 | Definição das regras tributárias com o contador |
| 2 | Criação das tabelas MariaDB |
| 3 | Desenvolvimento do cadastro de regras |
| 4 | Classificação automática dos itens dos XMLs |
| 5 | Implementação do cálculo de antecipação |
| 6 | Implementação do cálculo de DIFAL |
| 7 | Desenvolvimento da memória de cálculo |
| 8 | Integração com a conciliação existente |
| 9 | Desenvolvimento dos relatórios |
| 10 | Testes e validação com o contador |

## 13. Informações necessárias para iniciar a implementação

Antes de desenvolver as regras definitivas, é necessário confirmar:

1. **Estado da empresa destinatária:** a legislação de Minas Gerais será a referência?
2. **Regime tributário:** o sistema atenderá empresas do Simples Nacional, Lucro Presumido e Lucro Real?
3. **Operações abrangidas:** serão calculadas antecipação para revenda e industrialização, além de DIFAL para uso, consumo e ativo imobilizado?
4. **ICMS-ST:** o sistema também deverá identificar e calcular operações sujeitas à substituição tributária?
5. **Abrangência geográfica:** o sistema atenderá somente empresas de MG ou empresas de outros estados também?

## 14. Recomendação final

A recomendação é desenvolver um módulo independente de apuração de ICMS, integrado ao conciliador de XMLs.

As regras tributárias deverão ser armazenadas no banco de dados, permitindo atualização sem recompilação do sistema.

Os cálculos deverão ser realizados por item da nota, com memória de cálculo e histórico da regra aplicada.

O desenvolvimento deve começar pela definição das regras tributárias com o contador, evitando implementar fórmulas genéricas que possam gerar recolhimentos incorretos.

**Objetivo final:** permitir que o sistema identifique automaticamente operações interestaduais, determine o tratamento tributário aplicável, calcule os valores de antecipação e DIFAL e apresente relatórios para conferência fiscal.
