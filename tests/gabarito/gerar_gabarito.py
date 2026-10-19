"""Gera o gabarito tests/gabarito/notas.csv a partir de pastas de XMLs NF-e/NFC-e.

Uso:
    python -I gerar_gabarito.py <pasta_xmls> [<pasta_xmls> ...] [-o <arquivo_saida.csv>]

Cada pasta e lida sem recursao (so os *.xml do proprio nivel). A saida
padrao e notas.csv no diretorio atual.

Independente do app Delphi: usa apenas a biblioteca padrao do Python e
decimal.Decimal para todos os valores. Nao contem dados fiscais reais.

Regras (espelham a regra atual do app, sem decidir regra de negocio nova):
- autorizada = 'S' quando protNFe/infProt/cStat e 100 ou 150
  (decisao do usuario; o texto de xMotivo nao e mais usado).
  XML sem protNFe => 'N'.
- origem = 'sintetico' quando a pasta lida se chama 'sinteticos';
  senao 'real'.
- tem_ibscbs = 'S' quando existe infNFe/total/IBSCBSTot.
  Com o grupo presente, subgrupos ausentes (gIBS / gCBS, opcionais no XSD)
  contam como 0.00. Sem o grupo, as colunas de IBS/CBS ficam vazias.
- Linhas TOTAL (Todos / 55 / 65): somam apenas notas autorizadas;
  as colunas de IBS/CBS somam apenas autorizadas com IBSCBSTot.
  Na linha TOTAL, a coluna nNF traz a quantidade de notas autorizadas e a
  coluna tem_ibscbs traz a quantidade de autorizadas com IBSCBSTot.
"""
import csv
import os
import sys
import xml.etree.ElementTree as ET
from decimal import Decimal

NS = '{http://www.portalfiscal.inf.br/nfe}'
CSTAT_AUTORIZADA = ('100', '150')
DUAS_CASAS = Decimal('0.01')

COLUNAS = ['arquivo_sufixo', 'modelo', 'nNF', 'data', 'tpNF', 'tpImp',
           'autorizada', 'cStat', 'vNF', 'vBC', 'vICMS', 'tem_ibscbs',
           'vBCIBSCBS', 'vIBSUF', 'vIBSMun', 'vIBS', 'vCBS', 'origem']
COLS_ICMS = ['vNF', 'vBC', 'vICMS']
COLS_IBSCBS = ['vBCIBSCBS', 'vIBSUF', 'vIBSMun', 'vIBS', 'vCBS']


def achar(el, caminho):
    """Busca por caminho relativo com namespace NF-e ('a/b/c')."""
    if el is None:
        return None
    return el.find('/'.join(NS + p for p in caminho.split('/')))


def texto(el, caminho):
    e = achar(el, caminho)
    return None if e is None or e.text is None else e.text.strip()


def dec(el, caminho):
    t = texto(el, caminho)
    return Decimal('0') if not t else Decimal(t)


def fmt(v):
    return '' if v is None else str(v.quantize(DUAS_CASAS))


def data_br(dh):
    # Mesmo criterio do app: usa os 10 primeiros caracteres (aaaa-mm-dd).
    if not dh or len(dh) < 10:
        return ''
    a, m, d = dh[:10].split('-')
    return '%s/%s/%s' % (d, m, a)


def ler_nota(caminho, origem):
    root = ET.parse(caminho).getroot()
    if root.tag == NS + 'nfeProc':
        inf = achar(root, 'NFe/infNFe')
        prot = achar(root, 'protNFe/infProt')
    elif root.tag == NS + 'NFe':
        inf = achar(root, 'infNFe')
        prot = None
    else:
        raise ValueError('raiz inesperada: %s' % root.tag)

    ide = achar(inf, 'ide')
    cstat = texto(prot, 'cStat') or ''
    autorizada = cstat in CSTAT_AUTORIZADA

    tot = achar(inf, 'total/ICMSTot')
    ibscbs = achar(inf, 'total/IBSCBSTot')

    linha = {
        'arquivo_sufixo': inf.get('Id', '')[-6:],
        'modelo': texto(ide, 'mod'),
        'nNF': texto(ide, 'nNF'),
        'data': data_br(texto(ide, 'dhEmi')),
        'tpNF': texto(ide, 'tpNF'),
        'tpImp': texto(ide, 'tpImp'),
        'autorizada': 'S' if autorizada else 'N',
        'cStat': cstat,
        'vNF': dec(tot, 'vNF'),
        'vBC': dec(tot, 'vBC'),
        'vICMS': dec(tot, 'vICMS'),
        'tem_ibscbs': 'S' if ibscbs is not None else 'N',
        'origem': origem,
    }
    if ibscbs is not None:
        linha['vBCIBSCBS'] = dec(ibscbs, 'vBCIBSCBS')
        linha['vIBSUF'] = dec(ibscbs, 'gIBS/gIBSUF/vIBSUF')
        linha['vIBSMun'] = dec(ibscbs, 'gIBS/gIBSMun/vIBSMun')
        linha['vIBS'] = dec(ibscbs, 'gIBS/vIBS')
        linha['vCBS'] = dec(ibscbs, 'gCBS/vCBS')
    else:
        for c in COLS_IBSCBS:
            linha[c] = None
    return linha


def totalizar(notas, filtro):
    sel = [n for n in notas if n['autorizada'] == 'S'
           and (filtro == 'Todos' or n['modelo'] == filtro)]
    com_grupo = [n for n in sel if n['tem_ibscbs'] == 'S']
    t = {c: '' for c in COLUNAS}
    t['arquivo_sufixo'] = 'TOTAL'
    t['modelo'] = filtro
    t['nNF'] = str(len(sel))
    t['tem_ibscbs'] = str(len(com_grupo))
    for c in COLS_ICMS:
        t[c] = sum((n[c] for n in sel), Decimal('0'))
    for c in COLS_IBSCBS:
        t[c] = sum((n[c] for n in com_grupo), Decimal('0'))
    return t


def main():
    args = sys.argv[1:]
    saida = 'notas.csv'
    if '-o' in args:
        i = args.index('-o')
        saida = args[i + 1]
        del args[i:i + 2]
    if not args:
        print(__doc__)
        sys.exit(1)

    notas = []
    for pasta in args:
        nome_pasta = os.path.basename(os.path.normpath(pasta)).lower()
        origem = 'sintetico' if nome_pasta == 'sinteticos' else 'real'
        for nome in os.listdir(pasta):
            caminho = os.path.join(pasta, nome)
            if nome.lower().endswith('.xml') and os.path.isfile(caminho):
                notas.append(ler_nota(caminho, origem))
    notas.sort(key=lambda n: (n['modelo'], int(n['nNF']), n['arquivo_sufixo']))

    linhas = notas + [totalizar(notas, f) for f in ('Todos', '55', '65')]
    with open(saida, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f, delimiter=';', lineterminator='\n')
        w.writerow(COLUNAS)
        for n in linhas:
            w.writerow([fmt(n[c]) if isinstance(n[c], Decimal) or n[c] is None
                        else n[c] for c in COLUNAS])
    print('%d notas gravadas em %s' % (len(notas), saida))


if __name__ == '__main__':
    main()
