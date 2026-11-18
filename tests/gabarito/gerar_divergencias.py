"""Gera o gabarito tests/gabarito/divergencias.csv (conferencia de IBS/CBS, Plano 7).

Uso:
    python -I gerar_divergencias.py <pasta_xmls> [<pasta_xmls> ...] [-o <arquivo_saida.csv>]

Cada pasta e lida sem recursao (so os *.xml do proprio nivel). A saida padrao e
divergencias.csv no diretorio atual. As tabelas oficiais de CST e cClassTrib
(tabela_cst_ibscbs.csv e tabela_cclasstrib.csv) sao lidas da pasta deste script.

Independente do app Delphi: usa apenas a biblioteca padrao do Python e
decimal.Decimal para todos os valores. Nao contem dados fiscais reais.

Regras (docs/planos/plano-7-regras-ibs-cbs.md, NT 2025.002-RTC v1.53):
- Entram so as notas autorizadas (protNFe/infProt/cStat 100 ou 150), modelos
  55 e 65, que tenham IBS/CBS (algum det/imposto/IBSCBS ou total/IBSCBSTot).
- Nivel 1 (Erro): contas do item (vIBSUF, vIBSMun, vCBS, vIBS, pAliqEfet,
  vDif, vDevTrib, gTribRegular). Nivel 2 (Erro): soma dos itens x IBSCBSTot,
  inclusive o grupo gTribSN do Simples Nacional (NT 2026.005 v1.00, regras
  W59h-10, W59h-20, W59i-10 e W59j-10; decisao D17). Nivel 3 (Alerta): vBC x
  composicao do item (UB16-10). Nivel 4 (Alerta): aliquota do ano, CST x
  cClassTrib, reducao, diferimento, tributacao regular.
- Item com gTribSN e sem gIBSCBS (Simples Nacional sem regime regular): niveis
  1 e 3 nao rodam (nao ha gIBSCBS) e o nivel 4 nao aponta a falta do gIBSCBS
  (sugestao S1 do documento de regras, tabela 2.3 da NT 2026.005).
- Tolerancia: R$ 0,01 nos valores dos niveis 1 e 3, zero no nivel 2 (D5 e
  D17) e 0,0001 nas aliquotas efetivas. Valores calculados arredondados com
  ROUND_HALF_UP. pIBSSN e pCBSSN nao sao conferidos (D17).
- Uma linha por divergencia. Sem divergencia, a nota nao aparece no CSV.
"""
import csv
import os
import sys
import xml.etree.ElementTree as ET
from decimal import Decimal, ROUND_HALF_UP, InvalidOperation

NS = '{http://www.portalfiscal.inf.br/nfe}'
CSTAT_AUTORIZADA = ('100', '150')
DUAS = Decimal('0.01')
QUATRO = Decimal('0.0001')
ZERO = Decimal('0')
TOL_VALOR = Decimal('0.01')       # niveis 1 e 3 (NT: tolerancia de 0,01 nas contas do item)
TOL_N2 = ZERO                     # nivel 2: soma exata, como na NT (decisoes D5 e D17)
TOL_ALIQ = Decimal('0.0001')      # pAliqEfet e aliquotas (4 casas)

COLUNAS = ['modelo', 'nNF', 'chave_final', 'item', 'nivel', 'tipo', 'regra', 'campo',
           'valor_xml', 'valor_esperado', 'origem']

# Aliquotas fixadas na LC 214/2025 (arts. 343, 344 e 346) e na NT (UB18-10, UB37-10, UB56-10).
# Ano sem entrada = aliquota nao conferida (depende de resolucao do Senado / lei do ente).
ALIQ_ANO = {
    'UF': {'2025': Decimal('0.1000'), '2026': Decimal('0.1000'),
           '2027': Decimal('0.0500'), '2028': Decimal('0.0500')},
    'Mun': {'2025': Decimal('0.0000'), '2026': Decimal('0.0000'),
            '2027': Decimal('0.0500'), '2028': Decimal('0.0500')},
    'CBS': {'2025': Decimal('0.9000'), '2026': Decimal('0.9000')},
}
ESFERAS = (('UF', 'gIBSUF', 'pIBSUF', 'vIBSUF'),
           ('Mun', 'gIBSMun', 'pIBSMun', 'vIBSMun'),
           ('CBS', 'gCBS', 'pCBS', 'vCBS'))
UF_ZFM_ALC = ('AC', 'AM', 'RO', 'RR', 'AP')     # NT UB56-10, excecao 3 (simplificada)
CST_SEM_N3 = ('222', '830')                    # base reduzida / exclusao de base: sem nivel 3
FIN_COM_N3 = ('1',)                            # nivel 3 so em nota normal (duvida D3)
TPNFCRED_SEM_N4 = ('03', '04', '06')           # NT UB18-10 excecao 2


def achar(el, caminho):
    if el is None:
        return None
    return el.find('/'.join(NS + p for p in caminho.split('/')))


def texto(el, caminho):
    e = achar(el, caminho)
    return None if e is None or e.text is None else e.text.strip()


def dec(el, caminho):
    t = texto(el, caminho)
    if not t:
        return ZERO
    try:
        return Decimal(t)
    except InvalidOperation:
        raise ValueError('valor numerico invalido em %s: %r' % (caminho, t))


def dec_filho(el, nome):
    """Valor da tag 'nome' dentro do unico filho de 'el' (ex.: ICMS/ICMS00/vICMS)."""
    if el is None:
        return ZERO
    total = ZERO
    for sub in el:
        total += dec(sub, nome)
    return total


def r2(v):
    return v.quantize(DUAS, ROUND_HALF_UP)


def r4(v):
    return v.quantize(QUATRO, ROUND_HALF_UP)


def f2(v):
    return str(r2(v))


def f4(v):
    return str(r4(v))


def ler_tabelas(pasta):
    cst, ccl = {}, {}
    with open(os.path.join(pasta, 'tabela_cst_ibscbs.csv'), encoding='utf-8') as f:
        for r in csv.DictReader(f, delimiter=';'):
            cst[r['CST']] = r
    with open(os.path.join(pasta, 'tabela_cclasstrib.csv'), encoding='utf-8') as f:
        for r in csv.DictReader(f, delimiter=';'):
            ccl[r['cClassTrib']] = r
    return cst, ccl


class Nota:
    def __init__(self, base):
        self.base = base
        self.linhas = []

    def add(self, item, nivel, regra, campo, xml, esperado):
        tipo = 'Erro' if nivel in (1, 2) else 'Alerta'
        d = dict(self.base)
        d.update(item=item, nivel=str(nivel), tipo=tipo, regra=regra, campo=campo,
                 valor_xml=xml, valor_esperado=esperado)
        self.linhas.append(d)


# ------------------------------------------------------------------ nivel 1
def nivel1(nota, it, g, ibscbs, ide):
    vbc = dec(g, 'vBC')
    redutor = dec(ide, 'gCompraGov/pRedutor')
    valores = {}
    for esf, grp_nome, tag_p, tag_v in ESFERAS:
        grp = achar(g, grp_nome)
        if grp is None:
            valores[esf] = ZERO
            continue
        p = dec(grp, tag_p)
        aliq = p
        red = achar(grp, 'gRed')
        if red is not None:
            pred = dec(red, 'pRedAliq')
            pef = dec(red, 'pAliqEfet')
            esp_ef = r4(p * (1 - pred / 100) * (1 - redutor / 100))
            if abs(pef - esp_ef) > TOL_ALIQ:
                nota.add(it, 1, 'N1-pAliqEfet', '%s/gRed/pAliqEfet' % grp_nome, f4(pef), f4(esp_ef))
            aliq = pef                         # NT: usar a aliquota efetiva informada
        vdif = vdev = ZERO
        gdif = achar(grp, 'gDif')
        if gdif is not None:
            vdif = dec(gdif, 'vDif')
            esp = r2(vbc * aliq / 100 * dec(gdif, 'pDif') / 100)
            if abs(vdif - esp) > TOL_VALOR:
                nota.add(it, 1, 'N1-vDif', '%s/gDif/vDif' % grp_nome, f2(vdif), f2(esp))
        gdev = achar(grp, 'gDevTrib')
        if gdev is not None:
            vdev = dec(gdev, 'vDevTrib')
            if texto(gdev, 'pDevTrib'):
                esp = r2(vbc * aliq / 100 * dec(gdev, 'pDevTrib') / 100)
                if abs(vdev - esp) > TOL_VALOR:
                    nota.add(it, 1, 'N1-vDevTrib', '%s/gDevTrib/vDevTrib' % grp_nome, f2(vdev), f2(esp))
        v = dec(grp, tag_v)
        esp = r2(vbc * aliq / 100 - vdif - vdev)
        if abs(v - esp) > TOL_VALOR:
            nota.add(it, 1, 'N1-' + tag_v, '%s/%s' % (grp_nome, tag_v), f2(v), f2(esp))
        valores[esf] = v

    vibs = dec(g, 'vIBS')
    esp = valores['UF'] + valores['Mun']
    cred = dec(ibscbs, 'gCredPresOper/gIBSCredPres/vCredPres')
    ok = abs(vibs - esp) <= TOL_VALOR or (cred and abs(vibs - (esp - cred)) <= TOL_VALOR)
    if not ok:
        nota.add(it, 1, 'N1-vIBS', 'gIBSCBS/vIBS', f2(vibs), f2(esp))

    reg = achar(g, 'gTribRegular')
    if reg is not None:
        for sufixo in ('IBSUF', 'IBSMun', 'CBS'):
            v = dec(reg, 'vTribReg' + sufixo)
            esp = r2(vbc * dec(reg, 'pAliqEfetReg' + sufixo) / 100)
            if abs(v - esp) > TOL_VALOR:
                nota.add(it, 1, 'N1-vTribReg', 'gTribRegular/vTribReg' + sufixo, f2(v), f2(esp))


# ------------------------------------------------------------------ nivel 3
def base_esperada(prod, imp):
    """NT 2025.002 UB16-10 (composicao da base), por item."""
    soma = (dec(prod, 'vProd') + dec(prod, 'vFrete') + dec(prod, 'vSeg') + dec(prod, 'vOutro')
            + dec(imp, 'II/vII') + dec(imp, 'IS/vIS'))
    icms = achar(imp, 'ICMS')
    soma -= dec(prod, 'vDesc')
    soma -= dec_filho(achar(imp, 'PIS'), 'vPIS')
    soma -= dec_filho(achar(imp, 'COFINS'), 'vCOFINS')
    soma -= dec_filho(icms, 'vICMS')
    soma -= dec_filho(icms, 'vFCP')
    soma -= dec_filho(icms, 'vICMSMono')
    soma -= dec(imp, 'ICMSUFDest/vICMSUFDest') + dec(imp, 'ICMSUFDest/vFCPUFDest')
    soma -= dec(imp, 'ISSQN/vISSQN')
    pisst = achar(imp, 'PISST')
    if pisst is not None and texto(pisst, 'indSomaPISST') != '1':
        soma -= dec(pisst, 'vPIS')
    cofst = achar(imp, 'COFINSST')
    if cofst is not None and texto(cofst, 'indSomaCOFINSST') != '1':
        soma -= dec(cofst, 'vCOFINS')
    return soma


# ------------------------------------------------------------------ nivel 4
def nivel4(nota, it, cst, ccl_cod, g, ibscbs, ide, emit_uf, modelo, data, tab_cst, tab_ccl, tem_sn=False):
    linha_ccl = tab_ccl.get(ccl_cod)
    if linha_ccl is None:
        nota.add(it, 4, 'N4-cClassTrib', 'IBSCBS/cClassTrib', ccl_cod, 'codigo da tabela cClassTrib')
        return
    if ccl_cod[:3] != cst or linha_ccl['CST'] != cst:
        nota.add(it, 4, 'N4-CSTxcClassTrib', 'IBSCBS/cClassTrib', '%s (CST %s)' % (ccl_cod, cst),
                 'cClassTrib do CST %s' % cst)
        return
    if (modelo == '55' and linha_ccl['nfe'] != 'S') or (modelo == '65' and linha_ccl['nfce'] != 'S'):
        nota.add(it, 4, 'N4-cClassTribModelo', 'IBSCBS/cClassTrib', ccl_cod,
                 'cClassTrib permitido no modelo %s' % modelo)
    if data < linha_ccl['ini_vig'] or (linha_ccl['fim_vig'] and data > linha_ccl['fim_vig']):
        nota.add(it, 4, 'N4-cClassTribVigencia', 'IBSCBS/cClassTrib', ccl_cod,
                 'vigente de %s a %s' % (linha_ccl['ini_vig'], linha_ccl['fim_vig'] or '-'))
    ind = tab_cst.get(cst)
    if ind is None:
        return
    if ind['exige_gIBSCBS'] == 'S' and g is None:
        # Sugestao S1 (D17): o Simples Nacional sem regime regular informa gTribSN no lugar
        # do gIBSCBS (NT 2026.005, tabela 2.3). Sem alerta nesse caso.
        if not tem_sn:
            nota.add(it, 4, 'N4-gIBSCBS', 'IBSCBS/gIBSCBS', 'ausente', 'presente')
        return
    if ind['exige_gIBSCBS'] != 'S' and g is not None:
        nota.add(it, 4, 'N4-gIBSCBS', 'IBSCBS/gIBSCBS', 'presente', 'ausente')
    if g is None:
        return

    trib_reg = linha_ccl['trib_regular'] == 'S'
    fin = texto(ide, 'finNFe') or '1'
    confere_aliq = fin != '4' and (texto(ide, 'tpNFCredito') or '') not in TPNFCRED_SEM_N4
    compra_gov = achar(ide, 'gCompraGov') is not None
    ano = data[:4]
    for esf, grp_nome, tag_p, _ in ESFERAS:
        grp = achar(g, grp_nome)
        if grp is None:
            continue
        p = dec(grp, tag_p)
        if confere_aliq:
            esp = ZERO if trib_reg else ALIQ_ANO[esf].get(ano)
            if esf == 'CBS' and achar(grp, 'gALCZFMCBS') is not None:
                esp = ZERO
            if esf == 'CBS' and p == ZERO and emit_uf in UF_ZFM_ALC:
                esp = None
            # D21 (a): item so com a CBS do Simples (gTribSN/gCBSSN sem gIBSSN): pCBS nao conferido
            if (esf == 'CBS' and achar(ibscbs, 'gTribSN/gCBSSN') is not None
                    and achar(ibscbs, 'gTribSN/gIBSSN') is None):
                esp = None
            if esp is not None and abs(p - esp) > TOL_ALIQ:
                nota.add(it, 4, 'N4-' + tag_p, '%s/%s' % (grp_nome, tag_p), f4(p), f4(esp))
        red = achar(grp, 'gRed')
        pred_tab = Decimal(linha_ccl['pRedCBS' if esf == 'CBS' else 'pRedIBS'])
        if ind['reducao_aliquota'] == 'S':
            if red is None:
                nota.add(it, 4, 'N4-gRed', '%s/gRed' % grp_nome, 'ausente', 'pRedAliq %s' % f4(pred_tab))
            elif abs(dec(red, 'pRedAliq') - pred_tab) > TOL_ALIQ:
                nota.add(it, 4, 'N4-pRedAliq', '%s/gRed/pRedAliq' % grp_nome, f4(dec(red, 'pRedAliq')),
                         f4(pred_tab))
        elif red is not None and not (compra_gov and dec(red, 'pRedAliq') == ZERO):
            nota.add(it, 4, 'N4-gRed', '%s/gRed' % grp_nome, 'pRedAliq %s' % f4(dec(red, 'pRedAliq')),
                     'ausente (CST %s nao permite reducao)' % cst)
        gdif = achar(grp, 'gDif')
        if ind['diferimento'] == 'S' and gdif is None:
            nota.add(it, 4, 'N4-gDif', '%s/gDif' % grp_nome, 'ausente', 'presente')
        elif ind['diferimento'] != 'S' and gdif is not None:
            nota.add(it, 4, 'N4-gDif', '%s/gDif' % grp_nome, 'presente',
                     'ausente (CST %s nao permite diferimento)' % cst)
    tem_reg = achar(g, 'gTribRegular') is not None
    if trib_reg != tem_reg:
        nota.add(it, 4, 'N4-gTribRegular', 'gIBSCBS/gTribRegular', 'presente' if tem_reg else 'ausente',
                 'presente' if trib_reg else 'ausente')


# ------------------------------------------------------------------ nivel 2
TOTAIS = [
    ('vBCIBSCBS', lambda ib: dec(ib, 'gIBSCBS/vBC')),
    ('gIBS/gIBSUF/vDif', lambda ib: dec(ib, 'gIBSCBS/gIBSUF/gDif/vDif')),
    ('gIBS/gIBSUF/vDevTrib', lambda ib: dec(ib, 'gIBSCBS/gIBSUF/gDevTrib/vDevTrib')),
    ('gIBS/gIBSUF/vIBSUF', lambda ib: dec(ib, 'gIBSCBS/gIBSUF/vIBSUF')),
    ('gIBS/gIBSMun/vDif', lambda ib: dec(ib, 'gIBSCBS/gIBSMun/gDif/vDif')),
    ('gIBS/gIBSMun/vDevTrib', lambda ib: dec(ib, 'gIBSCBS/gIBSMun/gDevTrib/vDevTrib')),
    ('gIBS/gIBSMun/vIBSMun', lambda ib: dec(ib, 'gIBSCBS/gIBSMun/vIBSMun')),
    ('gIBS/vIBS', lambda ib: dec(ib, 'gIBSCBS/vIBS')),
    ('gIBS/vCredPres', lambda ib: dec(ib, 'gCredPresOper/gIBSCredPres/vCredPres')),
    ('gIBS/vCredPresCondSus', lambda ib: dec(ib, 'gCredPresOper/gIBSCredPres/vCredPresCondSus')),
    ('gCBS/vDif', lambda ib: dec(ib, 'gIBSCBS/gCBS/gDif/vDif')),
    ('gCBS/vDevTrib', lambda ib: dec(ib, 'gIBSCBS/gCBS/gDevTrib/vDevTrib')),
    ('gCBS/vCBS', lambda ib: dec(ib, 'gIBSCBS/gCBS/vCBS')),
    ('gCBS/vCredPres', lambda ib: dec(ib, 'gCredPresOper/gCBSCredPres/vCredPres')),
    ('gCBS/vCredPresCondSus', lambda ib: dec(ib, 'gCredPresOper/gCBSCredPres/vCredPresCondSus')),
]
# NT 2026.005 v1.00 (D17): conferidos so quando IBSCBSTot/gTribSN existe (W59i-10 e W59j-10).
# gIBSSN e 0-1 no item: subgrupo ausente vale 0.
TOTAIS_SN = [
    ('gTribSN/vIBSSN', lambda ib: dec(ib, 'gTribSN/gIBSSN/vIBSSN')),
    ('gTribSN/vCBSSN', lambda ib: dec(ib, 'gTribSN/gCBSSN/vCBSSN')),
]


def conferir(caminho, origem, tab_cst, tab_ccl):
    root = ET.parse(caminho).getroot()
    if root.tag != NS + 'nfeProc':
        return None                                   # o app nao processa XML sem nfeProc
    inf = achar(root, 'NFe/infNFe')
    ide = achar(inf, 'ide')
    modelo = texto(ide, 'mod')
    if modelo not in ('55', '65') or (texto(root, 'protNFe/infProt/cStat') or '') not in CSTAT_AUTORIZADA:
        return None
    dets = inf.findall(NS + 'det')
    com_ibscbs = [(d.get('nItem'), d) for d in dets if achar(d, 'imposto/IBSCBS') is not None]
    tot = achar(inf, 'total/IBSCBSTot')
    if not com_ibscbs and tot is None:
        return None                                   # nota sem IBS/CBS: fora da conferencia
    nota = Nota(dict(modelo=modelo, nNF=texto(ide, 'nNF'), chave_final=inf.get('Id', '')[-6:],
                     origem=origem))
    data = (texto(ide, 'dhEmi') or '')[:10]
    fin = texto(ide, 'finNFe') or '1'
    emit_uf = texto(inf, 'emit/enderEmit/UF') or ''

    for n_item, det in com_ibscbs:
        imp = achar(det, 'imposto')
        ib = achar(imp, 'IBSCBS')
        cst = texto(ib, 'CST') or ''
        g = achar(ib, 'gIBSCBS')
        if g is not None:
            nivel1(nota, n_item, g, ib, ide)
            if cst not in CST_SEM_N3 and fin in FIN_COM_N3:
                esp = base_esperada(achar(det, 'prod'), imp)
                vbc = dec(g, 'vBC')
                if abs(vbc - esp) > TOL_VALOR:
                    nota.add(n_item, 3, 'N3-vBC', 'gIBSCBS/vBC', f2(vbc), f2(esp))
        nivel4(nota, n_item, cst, texto(ib, 'cClassTrib') or '', g, ib, ide, emit_uf, modelo,
               data, tab_cst, tab_ccl, tem_sn=achar(ib, 'gTribSN') is not None)

    if com_ibscbs and tot is None:
        nota.add('total', 2, 'N2-IBSCBSTot', 'total/IBSCBSTot', 'ausente', 'presente')
    elif tot is not None and not com_ibscbs:
        nota.add('total', 2, 'N2-IBSCBSTot', 'total/IBSCBSTot', 'presente', 'ausente')
    elif tot is not None:
        for campo, extrair in TOTAIS:
            soma = sum((extrair(achar(d, 'imposto/IBSCBS')) for _, d in com_ibscbs), ZERO)
            v = dec(tot, campo)                        # grupo ausente vale 0 (como no app)
            if abs(v - soma) > TOL_N2:
                nota.add('total', 2, 'N2-' + campo.split('/')[-1], 'IBSCBSTot/' + campo, f2(v), f2(soma))
        # D17: Simples Nacional (NT 2026.005). Sem IBSCBSTot, vale so a linha N2-IBSCBSTot acima.
        itens_sn = [d for _, d in com_ibscbs if achar(d, 'imposto/IBSCBS/gTribSN') is not None]
        tot_sn = achar(tot, 'gTribSN')
        if itens_sn and tot_sn is None:                # W59h-10, rejeicao 1275
            nota.add('total', 2, 'N2-gTribSN', 'IBSCBSTot/gTribSN', 'ausente', 'presente')
        elif tot_sn is not None and not itens_sn:      # W59h-20, rejeicao 1276
            nota.add('total', 2, 'N2-gTribSN', 'IBSCBSTot/gTribSN', 'presente', 'ausente')
        elif tot_sn is not None:                       # W59i-10 (1277) e W59j-10 (1284)
            for campo, extrair in TOTAIS_SN:
                soma = sum((extrair(achar(d, 'imposto/IBSCBS')) for d in itens_sn), ZERO)
                v = dec(tot, campo)
                if abs(v - soma) > TOL_N2:
                    nota.add('total', 2, 'N2-' + campo.split('/')[-1], 'IBSCBSTot/' + campo, f2(v), f2(soma))
    return nota


def ordem(l):
    item = 10 ** 6 if l['item'] == 'total' else int(l['item'])
    return (l['modelo'], int(l['nNF']), l['chave_final'], item, l['nivel'], l['regra'], l['campo'])


def main():
    args = sys.argv[1:]
    saida = 'divergencias.csv'
    if '-o' in args:
        i = args.index('-o')
        saida = args[i + 1]
        del args[i:i + 2]
    if not args:
        print(__doc__)
        sys.exit(1)
    tab_cst, tab_ccl = ler_tabelas(os.path.dirname(os.path.abspath(__file__)))

    linhas, conferidas = [], {'55': 0, '65': 0}
    for pasta in args:
        origem = 'sintetico' if os.path.basename(os.path.normpath(pasta)).lower().startswith('sinteticos') else 'real'
        for nome in sorted(os.listdir(pasta)):
            caminho = os.path.join(pasta, nome)
            if not (nome.lower().endswith('.xml') and os.path.isfile(caminho)):
                continue
            try:
                nota = conferir(caminho, origem, tab_cst, tab_ccl)
            except (ValueError, ET.ParseError) as e:
                print('AVISO: %s nao processado (%s)' % (nome, e), file=sys.stderr)
                continue
            if nota is not None:
                conferidas[nota.base['modelo']] += 1
                linhas.extend(nota.linhas)
    linhas.sort(key=ordem)

    with open(saida, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f, delimiter=';', lineterminator='\n')
        w.writerow(COLUNAS)
        for l in linhas:
            w.writerow([l[c] for c in COLUNAS])

    print('Notas conferidas: 55=%d, 65=%d, total=%d' % (conferidas['55'], conferidas['65'],
                                                         conferidas['55'] + conferidas['65']))
    for mod in ('55', '65', 'Todos'):
        sel = [l for l in linhas if mod == 'Todos' or l['modelo'] == mod]
        por_nivel = ', '.join('N%s=%d' % (n, sum(1 for l in sel if l['nivel'] == n)) for n in '1234')
        notas = {(l['modelo'], l['nNF'], l['chave_final']) for l in sel}
        com_erro = {(l['modelo'], l['nNF'], l['chave_final']) for l in sel if l['tipo'] == 'Erro'}
        print('%-5s divergencias=%d (%s); notas com Erro=%d, so com Alerta=%d'
              % (mod, len(sel), por_nivel, len(com_erro), len(notas - com_erro)))
    print('Gravado em %s' % saida)


if __name__ == '__main__':
    main()
