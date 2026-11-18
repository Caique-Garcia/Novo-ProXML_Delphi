# Viabilidade fiscal: Antecipação e DIFAL de ICMS nas entradas interestaduais (destino MG)

Base: RICMS/MG 2023 (Dec. 48.589/2023) consolidado até o Dec. 49.270/2026 (regulamento), 49.281/2026 (Anexo VII) e 49.292/2026 (Anexo VIII); Anexo I consolidado até o Dec. 48.782/2024. Os textos foram extraídos dos PDFs oficiais da SEF/MG em 17/11/2026.

## Conclusão geral
Viável para MG como destino, desde que o escopo inicial seja: (a) antecipação do Simples Nacional; (b) DIFAL de uso/consumo e ativo para SN e regime normal; (c) ST apenas como alerta. As duas fórmulas de MG são idênticas: base dupla, "por dentro" (RICMS art. 12, VI; o §8º estende ao inciso VII). O exemplo do docs/funcionalidade_nova.md (R$ 60,00) usa a fórmula anterior a 2016 e está DESATUALIZADO: o correto é R$ 73,17.

## 1. DIFAL para contribuinte destinatário
- Hipótese: RICMS/MG art. 3º, III; contribuinte = art. 24, VI; LC 87/96 art. 12, XV, e art. 13, IX, com §6º (base dupla: interestadual na origem e interna no destino), e §1º, I (imposto por dentro), redação da LC 190/2022.
- Fórmula (RICMS art. 12, VI, "a" a "c"):
  - ICMSorig = V × alíq_inter (teórico: "alíquota interestadual sobre o valor da operação", alínea "c")
  - Base = (V − ICMSorig) / (1 − alíq_interna_CF)
  - DIFAL = máx(0; Base × alíq_interna − ICMSorig)
- Exemplo (V 1.000, interna 18%, inter 12%): ICMSorig 120,00; Base 880/0,82 = 1.073,17; débito 193,17; DIFAL = 73,17 (a fórmula simples daria 60,00).
- Anexo VII, art. 22, II, traz a mesma fórmula para ST/DIFAL: "ICMS ST DIFAL = [(V oper − ICMS origem)/(1 − ALQ interna)] × ALQ interna − (V oper × ALQ interestadual)". Ali, "V oper" inclui frete, seguro, impostos e encargos.
- Benefícios (art. 12, §§7º, 14, 15, 16):
  - §7º, I: isenção ou redução na origem convalidada pela LC 160 calcula-se pela regra geral (ICMSorig teórico).
  - §7º, II: redução interna em MG aplica o % de redução sobre a base por dentro.
  - §7º, III: isenção interna em MG zera o DIFAL.
  - §14 e §16: benefício irregular na origem usa a carga efetivamente cobrada.
  - §15: benefício condicionado à produção em MG é ignorado.
- FCP de MG = FEM (Lei 6.763/75, art. 12-A): +2 p.p. sobre produtos supérfluos. O Anexo I mostra cervejas e chopes 23%; cigarros/tabacaria, bebidas alcoólicas (exceto cerveja e aguardente), armas e munições, fogos, embarcações de recreio e perfumes/cosméticos (NCM 33.03–33.07) 25%. A lista do FEM inclui ainda refrigerantes, isotônicos, energéticos, ração pet, celulares, câmeras etc.; confirmar a lista vigente na lei. A Lei 24.471/2023 restabeleceu o FEM de 01/01/2024 a 31/12/2026. O PL 6.209/2026 (prorrogação até 2030) foi aprovado na CCJ em 27/10/2026, sem votação em plenário localizada. No DIFAL, o FEM entra somado à alíquota interna. Ex.: cosmético 25+2 = 27%: Base 880/0,73 = 1.205,48; débito 325,48; DIFAL 205,48. Segundo a Orientação DOLT/SUTRI 003/2016 (feita sob o Dec. 46.927/2015, hoje revogado), o destinatário mineiro contribuinte é o devedor do FEM na entrada interestadual. Confirmar no regulamento atual.
- SN (CRT 1/4) x regime normal:
  - O DIFAL é devido pelos dois. Para o SN: LC 123/2006, art. 13, §1º, XIII, "h", com §5º (alíquotas de não optante); constitucionalidade confirmada no STF, Tema 517.
  - O RICMS/2023 não traz dispensa para ME/EPP (não encontrei).
  - Recolhimento: regime normal em DAE distinto (art. 110), no prazo das operações próprias (art. 112, §5º, I). SN: informado na DeSTDA, recolhido até o dia 2 do 2º mês subsequente (art. 112, §7º, II, "c").
  - Crédito: regime normal credita o ativo via CIAP (1/48), mas não credita uso/consumo antes de 2033 (LC 87, art. 33, I). O SN não se credita.

## 2. Antecipação em MG
- Hipótese: art. 3º, VII. Sujeito passivo: art. 24, XII. Lei 6.763, art. 6º, §5º, "f". LC 123, art. 13, §1º, XIII, "g", item 2 (sem encerramento de tributação, "vedada a agregação de qualquer valor"), com §5º.
  - Abrange ME/EPP (Simples Nacional) que compre em outra UF para comercialização, industrialização, beneficiamento/acondicionamento ou uso na prestação de serviço.
  - Vigente: o RICMS/2023 está em vigor e o CC/MG confirmou a exigência no Acórdão 25.321/26/1ª (DJe 21/08/2026). STF Tema 456: exige lei em sentido estrito, e MG tem a Lei 6.763.
- Base: art. 12, XII, combinado com §8º (aplica o inciso VI e o §7º). A fórmula é igual à do DIFAL. IN SUTRI 01/2016, art. 2º: ICMS = i × V(1 − a)/(1 − i) − a × V.
- Fato gerador: data de emissão da NF de aquisição (IN SUTRI 01/2016, art. 2º, §4º; art. 7º do RICMS). Prazo: dia 20 do 2º mês subsequente (art. 112, §7º, III).
- Exemplos (V 1.000, interna 18%):
  - Interestadual 12%: 73,17 (Nota Técnica SEF/MG da malha SN, p. 6).
  - Interestadual 4%: 170,73.
  - Interna 12%, como arroz e feijão (Anexo I, 4.2): 0,00.
- Não há antecipação:
  - em mercadoria sujeita a ST (IN SUTRI 01/2016, art. 3º); o parágrafo único remete às inaplicabilidades da ST, que ficam sujeitas à antecipação;
  - quando há isenção interna em MG (§7º, III);
  - quando a diferença não é positiva (alíquota interestadual ≥ interna; art. 1º da IN);
  - em uso/consumo/ativo, que caem no DIFAL (art. 3º, III).
- Redução de base interna: §7º, II (ver dúvida D5).
- Devoluções: a SEF deduz o ICMS das devoluções (Nota Técnica, item 3.2).
- Regime normal, fora da ST: NÃO existe antecipação geral em MG, porque o art. 3º, VII, alcança só ME/EPP. Há apenas regimes setoriais (Anexo VIII, arts. 337 e 340: ferro-gusa e aço importados; prazo no art. 112, §8º) e a ST do Anexo VII (art. 15).

## 3. ICMS-ST nas entradas (Anexo VII, e não VIII como diz o doc)
- Requisitos:
  - item na Parte 2 do Anexo VII (capítulo/item, CEST + NCM);
  - coluna "Âmbito de Aplicação": UFs com protocolo/convênio (art. 13, §§1º e 2º);
  - MVA original, MVA ajustada (art. 20, §5º: [(1+MVA)×(1−ALQinter)/(1−ALQintra)]−1; §6º: não ajusta se o remetente for ME/EPP);
  - PMPF ou preço fixado (art. 20, I, "a" e "b.1");
  - inaplicabilidades (art. 18);
  - responsável: remetente (arts. 13 e 14), destinatário quando não houver retenção (arts. 15 e 16).
  - ICMS-ST de uso/consumo: art. 20, II, e art. 22, II.
- Avaliação: cálculo completo NÃO é viável no escopo inicial. A tabela é extensa e muda a cada decreto (houve 3 decretos em 2026 só no Anexo VII), a MVA depende de alíquota/redução do item e há PMPF. Recomendação: só ALERTAR. CEST/NCM presente sem vICMSST, com CST 00/20 ou CSOSN 101/102, indica possível ST a recolher pelo destinatário (art. 15). Excluir esses itens da antecipação (IN 01/2016, art. 3º) com status "verificar ST".

## 4. Alíquota interestadual
- Res. SF 22/1989: 7% somente de S/SE (exceto ES) para N/NE/CO/ES. Com destino MG, a alíquota é SEMPRE 12% (ou 4%), venha de qualquer UF. Isso coincide com a malha SEF (12% ou 4%) e com o Anexo I, Parte 2.
- Res. SF 13/2012 (Anexo I, Parte 2, item 1.2): 4% para importados com orig 1, 2, 3 ou 8. Não se aplica a orig 6/7 (sem similar, Camex), a orig 4 (PPB) e a gás natural (subitem 1.2.2). orig 0, 4, 5, 6 e 7 = 12%. A SEF força 4% quando orig ∈ {1,2,3,8}, mesmo se a nota destacar outra alíquota.
- Interna de MG (Anexo I, Parte 1): geral 18% (7.1); 7% (2.x); 12% (4.x: arroz, feijão, genéricos, veículos do Anexo VII etc.); 13,08% (AEHC); 15% (diesel); 23% (cerveja); 25% (item 9); 31% (solvente). Some +2 p.p. do FEM nos itens alcançados, até 31/12/2026.
  - Os subitens 4.13 a 4.15 dependem de quem vende (industrial). No DIFAL, decidir se vale a alíquota "a consumidor final".
- Tabela das 27 UFs: desnecessária enquanto só MG for destino, porque a alíquota interna da UF de origem não entra no cálculo. Não a incluí para não fixar números sem verificação oficial de 2026.

## 5. Dados do XML (somente modelo 55; NFC-e 65 é sempre idDest=1, nunca interestadual)
| Dado | Caminho | Uso |
|---|---|---|
| UF origem/destino | emit/enderEmit/UF, dest/enderDest/UF; ide/idDest=2 | filtro |
| IE / tipo destinatário | dest/IE, dest/indIEDest (1 = contribuinte), ide/indFinal | DIFAL só se indIEDest=1; indFinal=1 é indício de uso/consumo |
| CRT fornecedor | emit/CRT (1 ou 4 = SN, 2 ou 3 = normal) | ICMS de origem teórico |
| orig | det/imposto/ICMS/*/orig | 4% x 12% |
| CST/CSOSN | ICMS/*/CST ou CSOSN | ST (10, 30, 60, 70; 201, 202, 203, 500), isenção (40, 41) |
| vBC, pICMS, vICMS, pRedBC | ICMS/* | conferência (o cálculo usa o valor teórico) |
| vBCST, vICMSST | ICMS/* | ST retida |
| vProd, vFrete, vSeg, vOutro, vDesc | det/prod | base |
| vIPI | det/imposto/IPI/IPITrib/vIPI | base do DIFAL |
| CFOP, NCM, CEST | det/prod | indício de finalidade/ST; alíquota interna |
| pCredSN | ICMS/ICMSSN101 ou 201 | ignorar (não é o ICMS de origem) |
- Composição da base:
  - Antecipação (revenda/industrialização): vProd + vFrete + vSeg + vOutro − vDesc, SEM IPI (RICMS art. 17, I; LC 87, art. 13, §2º; fórmula da malha SEF, item 3.3.3).
  - DIFAL (uso/consumo/ativo): o mesmo valor + vIPI (o IPI só fica fora quando o destino é industrialização ou comercialização) + outros encargos (art. 19, I; Anexo VII, art. 22, II, "b").
  - Desconto: só o incondicional sai (art. 19, I, "b"); o XML não distingue.
  - Frete FOB por CT-e: fica fora da NF. É outro DIFAL (art. 4º, II), fora do escopo.
- Fornecedor SN (CRT 1/4): não há ICMS destacado. Usa-se alíquota interestadual × V (12% ou 4%), conforme LC 123, §5º, e Acórdão 25.321/26/1ª ("substitui-se o ICMS destacado ... pela aplicação da alíquota interestadual"). O art. 12, VI, "c", já manda usar o valor teórico em qualquer caso.
- O XML NÃO fornece: regime do destinatário (não existe dest/CRT; vem do cadastro da empresa usuária), finalidade, benefícios fiscais/redução interna em MG, inclusão do item no Anexo VII, se o desconto é incondicional, data de entrada, frete FOB.
- Código: o leitor de itens do Plano 7 (lib/uCalculadoraXML.pas, LerNotaIBSCBS) ignora itens sem o grupo IBSCBS. Notas de fornecedor sem IBS/CBS ficariam sem itens, então o módulo novo precisa de leitura de det própria.

## 6. Reforma Tributária
EC 132/2023, ADCT art. 128: alíquotas de ICMS em 90% (2029), 80% (2030), 70% (2031) e 60% (2032), com extinção em 2033; benefícios reduzidos na mesma proporção. Interna e interestadual caem juntas, então DIFAL e antecipação caem proporcionalmente, sem mudar a estrutura. Consequência: regras com dtInicio/dtFim e alíquotas versionadas, ou um "fator de transição" por ano. LC 214/2025 não altera a antecipação do ICMS. Prazo mais próximo: o FEM vence em 31/12/2026, salvo prorrogação.

## 7. XMLs de exemplo
Varredura (python -I) de 92 XMLs em exemple/ e subpastas:
- todos com idDest=1;
- emitente e destinatário na mesma UF (MG→MG, ou SP→SP em sinteticos-site);
- orig sempre 0;
- só 1 entrada (tpNF=0, CFOP 1403, MG→MG).

Nenhum serve para entrada interestadual. Cenários sintéticos mínimos (todos modelo 55, emit fora de MG, dest MG, idDest=2), com valor esperado:
1. SP→MG, CRT 3, orig 0, CST 00, 12%; destinatário SN, revenda → antecipação 73,17
2. Igual ao 1, destinatário regime normal → 0 / "não aplicável"
3. orig 1 (e variantes 2, 3, 8) a 4% → 170,73
4. orig 6 ou 7 (sem similar) e orig 5 → 12% (73,17); nota com pICMS=4 e orig 0 → alerta
5. Fornecedor CRT 1 (CSOSN 102, sem vICMS, com pCredSN) → ICMS teórico 120 → 73,17
6. Fornecedor CRT 4 (MEI)
7. Item com ST retida (CST 10 / CSOSN 202, vICMSST>0, CEST) → sem antecipação
8. Item com CEST do Anexo VII, sem retenção → alerta "ST art. 15"
9. Uso/consumo, destinatário normal, com frete, seguro, outras, desconto e IPI → DIFAL com IPI (V 1.100 → 80,49)
10. Ativo, destinatário SN → DIFAL
11. Cosmético NCM 3304 (25+2) → 205,48; mesmo item com dhEmi em 2027 (FEM vencido?)
12. Item com redução interna (Anexo II) → 34,54 ou 55,61 (dúvida D5)
13. Item isento internamente → 0; item a 12% interno → 0
14. Origem com redução de base (CST 20) convalidada → ICMS teórico x destacado
15. Nota mista (revenda + uso/consumo) com frete rateado
16. Destinatário sem IE (indIEDest=9) com ICMSUFDest → fora (EC 87)
17. Devolução de compra (MG→UF origem, CFOP 6202) referenciando o 1 → dedução
18. Controles: interna MG→MG; NFC-e 65; nota cancelada; nota sem IBSCBS
Gabarito por modelo: 65 = 0 em todos.

## 8. Dúvidas para o usuário/contador
- D1 Escopo de regimes. (a) só SN; (b) SN antecipação + DIFAL de SN e normal; (c) tudo + ST. Rec.: (b).
- D2 Regime do destinatário. (a) cadastro da empresa com vigência; (b) consulta externa de CNPJ; (c) informado por nota. Rec.: (a).
- D3 Finalidade. (a) cadastro por produto (NCM/código do fornecedor); (b) padrão da empresa + exceção manual; (c) heurística CFOP/indFinal, só como sugestão. Rec.: (a) + (b); (c) apenas sugere e nunca encerra o item.
- D4 ICMS de origem. (a) teórico, alíq_inter × V (RICMS art. 12, VI, "c"; LC 123, §5º); (b) vICMS destacado (texto da IN e do acórdão); (c) destacado, com teórico só se ausente. Rec.: (a), exibindo o destacado para conferência. É divergência normativa: o contador decide.
- D5 Redução interna (§7º, II). (a) literal: inclui o imposto sobre V sem excluir o interestadual → 55,61; (b) Nota Técnica SEF: exclui antes → 34,54. Rec.: marcar "pendente" até o contador decidir. É divergência entre o regulamento e a SEF.
- D6 FEM após 31/12/2026. (a) dtFim 31/12/2026 e atualizar se o PL passar; (b) presumir prorrogação. Rec.: (a).
- D7 ST. (a) só alerta; (b) cálculo completo. Rec.: (a).
- D8 Base. (a) fixa conforme a lei (antecipação sem IPI; DIFAL com IPI); (b) configurável por regra (tipoBase), com (a) como padrão. Rec.: (b).
- D9 Arredondamento. (a) base e imposto por item com 2 casas (half-up), total = soma; (b) cálculo por nota. Rec.: (a).
- D10 Devoluções. (a) ignorar na fase 1; (b) deduzir no período. Rec.: (a), com (b) na fase 2.
- D11 MEI destinatário. (a) igual ao SN; (b) excluir. Rec.: perguntar ao contador; padrão (a).
- D12 Período. (a) dhEmi para tudo; (b) data de entrada informada pelo usuário no DIFAL. Rec.: (a) na fase 1; o DIFAL usa a entrada pelo art. 7º.
- D13 Alíquota interestadual. (a) derivada de orig + UF; (b) pICMS do XML; (c) derivada, com alerta se diferir. Rec.: (c).
- D14 Alíquota interna. (a) 18% + tabela de exceções por NCM mantida pelo usuário; (b) Anexo I completo embutido. Rec.: (a), com carga inicial dos itens 8, 9, 10 e do FEM.
- D15 Subitens 4.13 a 4.15 (12% só para saída de industrial). (a) usar 18% no DIFAL; (b) 12%. Rec.: contador.
