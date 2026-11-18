# -*- coding: utf-8 -*-
"""Dados comuns dos mockups do Plano 7 (etapa 7.2). Lê notas.json (resumo dos XMLs de exemple/,
sem CNPJ/CPF/nomes/chaves) e tests/gabarito/divergencias.csv. Chaves geradas são fictícias."""
import json, csv, os, random
from decimal import Decimal

AQUI = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.normpath(os.path.join(AQUI, '..', '..', '..', '..'))

def br(v, casas=2):
    v = Decimal(str(v))
    s = f'{v:,.{casas}f}'
    return s.replace(',', '#').replace('.', ',').replace('#', '.')

def rs(v):
    return 'R$ ' + br(v)

def pct4(v):
    return br(v, 4) + '%'

def pct_int(v):
    d = Decimal(str(v)).normalize()
    if d == d.to_integral():
        return f'{int(d)}%'
    return br(d, 4).rstrip('0').rstrip(',') + '%'

def data_br(iso):
    a, m, d = iso.split('-')
    return f'{d}/{m}/{a}'

# ---------------- notas ----------------
_notas = json.load(open(os.path.join(AQUI, 'notas.json'), encoding='utf-8'))
AUTORIZADAS = []
vistos = set()
for x in _notas:
    if x.get('erro'):
        continue
    if x['cStat'] in ('100', '150'):
        AUTORIZADAS.append(x)
IGNORADAS = [x for x in _notas if not x.get('erro') and x['cStat'] not in ('100', '150')]
ARQUIVOS = len(_notas)

# ---------------- divergências ----------------
DIV = list(csv.DictReader(open(os.path.join(REPO, 'tests', 'gabarito', 'divergencias.csv'), encoding='utf-8'), delimiter=';'))

ESF = {'gIBSUF': ('IBS UF', 'do IBS UF', 'IBS UF'), 'gIBSMun': ('IBS Mun.', 'do IBS municipal', 'IBS municipal'),
       'gCBS': ('CBS', 'da CBS', 'CBS')}

def esfera(campo):
    for k in ESF:
        if k in campo:
            return k
    return None

def ordem_campo(campo):
    if campo.endswith('vBC') or 'vBCIBSCBS' in campo:
        return 0
    if 'IBSUF' in campo:
        return 1
    if 'IBSMun' in campo:
        return 2
    if campo.endswith('/vIBS'):
        return 3
    if 'CBS' in campo and 'IBSCBS' not in campo.replace('gIBSCBS', ''):
        return 4
    return 5

DATAS = {(x['mod'], x['nNF']): data_br(x['dhEmi']) for x in AUTORIZADAS}

# detalhes de conta dos XMLs sintéticos (lidos dos próprios XMLs fictícios)
CONTA_N1 = {('910003', '1'): '(R$ 238,13 × 0,1000%)', ('910004', '2'): '(R$ 212,08 × 0,9000%)',
            ('910006', '1'): '(R$ 372,07 × 0,3600%, alíquota efetiva)', ('910031', '1'): '(R$ 66,90 × 0,1000%)',
            ('910060', '1'): '(R$ 223,24 × 0,1000%)'}
CCLASS = {'910016': '200034', '910017': '200034', '910018': '200034'}

def montar(r):
    regra, campo, x, e = r['regra'], r['campo'], r['valor_xml'], r['valor_esperado']
    n, i, tipo = r['nNF'], r['item'], r['tipo']
    k = esfera(campo)
    curto, do_esf, prosa = ESF[k] if k else ('', '', '')
    tag = campo.split('/')[-1]
    item = 'Total' if i == 'total' else i
    if regra == 'N3-vBC':
        c = 'Base IBS/CBS (vBC)'; vx, ve = rs(x), rs(e)
        log = f'Nota Fiscal {n}, item {i}: base de IBS/CBS {vx} no XML e {ve} pela composição do item; confira (alerta).'
    elif regra in ('N1-vIBSUF', 'N1-vCBS', 'N1-vIBSMun'):
        c = f'{curto} ({tag})'; vx, ve = rs(x), rs(e)
        log = f'Nota Fiscal {n}, item {i}: {prosa} {vx}, esperado {ve} {CONTA_N1[(n, i)]} (erro).'
    elif regra == 'N1-vIBS':
        c = 'IBS (vIBS)'; vx, ve = rs(x), rs(e)
        log = f'Nota Fiscal {n}, item {i}: IBS {vx}, esperado {ve} (IBS UF + IBS municipal) (erro).'
    elif regra == 'N1-pAliqEfet':
        c = f'Alíq. efetiva {curto} (pAliqEfet)'; vx, ve = pct4(x), pct4(e)
        log = f'Nota Fiscal {n}, item {i}: alíquota efetiva {do_esf} {vx}, esperado {ve} (0,9000% com redução de 60%) (erro).'
    elif regra == 'N2-IBSCBSTot':
        c = 'Total IBS/CBS (IBSCBSTot)'; vx, ve = x, e
        log = f'Nota Fiscal {n}: itens com IBS/CBS e nota sem o total de IBS/CBS (IBSCBSTot) (erro).'
    elif regra == 'N2-gTribSN':
        c = 'Total Simples (gTribSN)'; vx, ve = x, e
        if x == 'ausente':
            log = f'Nota Fiscal {n}: itens com IBS/CBS do Simples Nacional e nota sem o total do Simples Nacional (gTribSN) (erro).'
        else:
            log = f'Nota Fiscal {n}: total do Simples Nacional (gTribSN) informado e nenhum item com IBS/CBS do Simples Nacional (erro).'
    elif regra in ('N2-vIBSSN', 'N2-vCBSSN'):
        vx, ve = rs(x), rs(e)
        if tag == 'vIBSSN':
            c = 'IBS Simples (vIBSSN)'; do = 'do IBS do Simples Nacional'
        else:
            c = 'CBS Simples (vCBSSN)'; do = 'da CBS do Simples Nacional'
        log = f'Nota Fiscal {n}: total {do} {vx}, soma dos itens {ve} (erro).'
    elif regra.startswith('N2-'):
        vx, ve = rs(x), rs(e)
        if tag == 'vBCIBSCBS':
            c = 'Base IBS/CBS (vBCIBSCBS)'; do = 'da base de IBS/CBS'
        elif tag == 'vIBS':
            c = 'IBS (vIBS)'; do = 'do IBS'
        else:
            c = f'{curto} ({tag})'; do = do_esf
        log = f'Nota Fiscal {n}: total {do} {vx}, soma dos itens {ve} (erro).'
    elif regra in ('N4-pIBSUF', 'N4-pIBSMun', 'N4-pCBS'):
        c = f'Alíquota {curto} ({tag})'; vx, ve = pct4(x), pct4(e)
        log = f'Nota Fiscal {n}, item {i}: alíquota {do_esf} {vx} no XML e {ve} para 2026; confira (alerta).'
    elif regra == 'N4-pRedAliq':
        c = f'Redução {curto} (pRedAliq)'; vx, ve = pct_int(x), pct_int(e)
        log = f'Nota Fiscal {n}, item {i}: redução {do_esf} de {vx} no XML e {ve} pela tabela do cClassTrib {CCLASS[n]}; confira (alerta).'
    elif regra == 'N4-gRed':
        c = f'Redução {curto} (gRed)'
        if x == 'ausente':
            vx, ve = 'ausente', pct_int(e.split()[-1])
            log = f'Nota Fiscal {n}, item {i}: sem redução {do_esf} no XML, e a tabela prevê {ve} para o cClassTrib {CCLASS[n]}; confira (alerta).'
        else:
            vx, ve = pct_int(x.split()[-1]), 'ausente'
            log = f'Nota Fiscal {n}, item {i}: redução {do_esf} de {vx} no XML, e o CST 000 não prevê redução; confira (alerta).'
    elif regra == 'N4-CSTxcClassTrib':
        c = 'cClassTrib × CST'; vx = x.split()[0]; ve = 'do CST ' + x.split('CST ')[1].rstrip(')')
        log = f'Nota Fiscal {n}, item {i}: pela tabela oficial, o cClassTrib {vx} não pertence ao CST 000; confira (alerta).'
    else:
        raise ValueError(regra)
    return dict(mod=r['modelo'], n=n, data=DATAS[(r['modelo'], n)], item=item, nivel=r['nivel'], tipo=tipo,
                campo=c, xml=vx, esp=ve, log=log, ord=(int(n), 999 if i == 'total' else int(i), int(r['nivel']), ordem_campo(campo)))

LINHAS = sorted((montar(r) for r in DIV), key=lambda d: d['ord'])

INFO = {  # casos sem conferência (D9): uma linha por nota
    '910020': 'Nota Fiscal 910020, sem conferência de IBS/CBS: item 1 (tributação monofásica, CST 620); totais de IBS/CBS monofásico (gMono).',
    '910022': 'Nota Fiscal 910022, sem conferência de IBS/CBS: base e alíquotas (devolução, finNFe 4).',
}

def situacao(mod, n, temibs):
    if not temibs:
        return ''
    tipos = {l['tipo'] for l in LINHAS if l['mod'] == mod and l['n'] == n}
    if 'Erro' in tipos:
        return 'Erro'
    if 'Alerta' in tipos:
        return 'Alerta'
    return 'OK'

def contagem(mod=None):
    notas = [x for x in AUTORIZADAS if x['temibs'] and (mod is None or x['mod'] == mod)]
    sit = [situacao(x['mod'], x['nNF'], True) for x in notas]
    return dict(conferidas=len(notas), erro=sit.count('Erro'), alerta=sit.count('Alerta'), ok=sit.count('OK'),
                simples=sum(1 for x in notas if x.get('sn_itens')),
                div=len([l for l in LINHAS if mod is None or l['mod'] == mod]))

def chave_ficticia(x):
    a, m = x['dhEmi'][2:4], x['dhEmi'][5:7]
    rnd = random.Random(int(x['nNF']) * 7 + int(x['mod']))
    base = f"35{a}{m}12345678000100{x['mod']}{'001' if x['mod']=='55' else '002'}{int(x['nNF']):09d}1{rnd.randrange(10**7, 10**8)}"
    pesos = [2, 3, 4, 5, 6, 7, 8, 9]
    s = sum(int(d) * pesos[k % 8] for k, d in enumerate(reversed(base)))
    dv = 11 - s % 11
    return base + str(0 if dv >= 10 else dv)

def totais(lista):
    t = dict(vNF=Decimal(0), vBC=Decimal(0), vICMS=Decimal(0), vIBS=Decimal(0), vCBS=Decimal(0))
    for x in lista:
        for k in t:
            t[k] += Decimal(x[k])
    return t
