# -*- coding: utf-8 -*-
"""Gera os mockups do Plano 7 (etapa 7.2) dentro de docs/ui/mockups. Idempotente: o bloco novo
fica entre <!-- P7:INICIO --> e <!-- P7:FIM --> e é trocado a cada execução."""
import os, re, sys, html
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dados as D

MOCK = os.path.join(D.REPO, 'docs', 'ui', 'mockups')
ICONES = os.path.join(D.REPO, 'docs', 'ui', 'icones')
INI, FIM = '<!-- P7:INICIO -->', '<!-- P7:FIM -->'
CSS_INI, CSS_FIM = '/* P7:INICIO */', '/* P7:FIM */'

def ler(nome):
    return open(os.path.join(MOCK, nome), encoding='utf-8').read()

def gravar(nome, txt):
    open(os.path.join(MOCK, nome), 'w', encoding='utf-8', newline='\n').write(txt)

def ic(nome, tam=16, extra=''):
    s = open(os.path.join(ICONES, nome + '.svg'), encoding='utf-8').read()
    corpo = re.search(r'>\s*(.*?)\s*</svg>', s[s.find('<svg'):], re.S).group(1)
    corpo = ' '.join(l.strip() for l in corpo.splitlines() if l.strip())
    return (f'<svg class="ic {extra}" width="{tam}" height="{tam}" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" '
            f'viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" > {corpo} </svg>')

def tirar_bloco(txt):
    txt = re.sub(re.escape(INI) + r'.*?' + re.escape(FIM) + r'\n?', '', txt, flags=re.S)
    txt = re.sub(re.escape(CSS_INI) + r'.*?' + re.escape(CSS_FIM) + r'\n?', '', txt, flags=re.S)
    return txt

def por_css(txt, css):
    return txt.replace('</style>', CSS_INI + '\n' + css.strip() + '\n' + CSS_FIM + '\n</style>', 1)

def por_corpo(txt, bloco):
    i = txt.rfind('</div>\n</body>')
    return txt[:i] + INI + '\n' + bloco + '\n' + FIM + '\n' + txt[i:]

def por_toc(txt, links):
    # acrescenta links ao fim do .toc
    m = re.search(r'(<div class="toc">.*?)(</div>)', txt)
    return txt[:m.end(1)] + INI + links + FIM + txt[m.end(1):]

CSS_COMUM = """
.p7tag{display:inline-block;font-size:8pt;font-weight:600;color:#FFFFFF;background:var(--CorPrimaria);padding:1px 6px;margin-left:8px;vertical-align:middle}
.st{display:flex;align-items:center;gap:6px}
.st.ok{color:var(--CorSucesso)}.st.av{color:var(--CorAviso)}.st.er{color:var(--CorErro)}
.st .ic{flex:none}
.opt{display:flex;gap:16px;flex-wrap:wrap;margin:8px 0 16px}
.opt>div{background:#FFFFFF;border:1px solid #A8ADB6;padding:12px 16px;min-width:300px;flex:1}
.opt>div.sug{border:2px solid var(--CorPrimaria)}
.opt h4{margin:0 0 8px;font-size:10pt;font-weight:600}
.opt .sugl{font-size:8pt;font-weight:600;color:var(--CorPrimariaHover)}
.logfull{background:var(--CorSuperficie);border:1px solid var(--CorBorda);max-width:1008px;padding:4px 0}
.logfull div{display:flex;gap:8px;align-items:center;padding:3px 12px;font-size:9pt}
.logfull .lav .ic{color:var(--CorAviso)}.logfull .ler .ic{color:var(--CorErro)}.logfull .lok .ic{color:var(--CorSucesso)}
.logfull .sep{border-top:1px dashed var(--CorBorda);margin:4px 0;padding:0}
"""

ST = {'OK': ('ok', 'circle-check'), 'Alerta': ('av', 'triangle-alert'), 'Erro': ('er', 'circle-x')}

def celula_st(s, icone_alerta='triangle-alert'):
    if not s:
        return ''
    cls, nome = ST[s]
    if s == 'Alerta':
        nome = icone_alerta
    return f'<span class="st {cls}">{ic(nome, 16)}{s}</span>'

# ------------------------------------------------------------------ NOTAS
def linhas_notas(ordem):
    ls = []
    for x in D.AUTORIZADAS:
        s = D.situacao(x['mod'], x['nNF'], x['temibs'])
        ls.append(dict(x=x, s=s))
    if ordem == 'num':
        ls.sort(key=lambda d: int(d['x']['nNF']))
    else:
        g = {'Erro': 0, 'Alerta': 1, 'OK': 2, '': 3}
        ls.sort(key=lambda d: (g[d['s']], int(d['x']['nNF'])))
    return ls

def grade(tam, ordem, sel=None, dica=None, nlin=14):
    larga = tam == 1366
    cols = [('Nº', 'r', 72), ('Modelo', 'c', 64), ('Data', '', 88), ('Chave', '', None), ('Valor', 'r', 120)]
    if larga:
        cols += [('ICMS', 'r', 104), ('IBS', 'r', 88), ('CBS', 'r', 96)]
    cols += [('IBS/CBS', '', 80)]
    th = ''
    for nome, al, w in cols:
        tit = nome
        cls = al
        if ordem == 'num' and nome == 'Nº':
            tit += ' ▲'; cls += ' ord'
        if ordem == 'sit' and nome == 'IBS/CBS':
            tit += ' ▼'; cls += ' ord'
        st = f' style="width:{w}px"' if w else ''
        th += f'<th class="{cls.strip()}"{st}>{tit}</th>'
    body = ''
    for k, d in enumerate(linhas_notas(ordem)[:nlin]):
        x = d['x']
        trc = 'sel' if sel == x['nNF'] else ''
        tds = (f'<td class="r mono">{x["nNF"]}</td><td class="c">{x["mod"]}</td><td class="mono">{D.data_br(x["dhEmi"])}</td>'
               f'<td class="mono">{D.chave_ficticia(x)}</td><td class="r mono">{D.rs(x["vNF"])}</td>')
        if larga:
            tds += f'<td class="r mono">{D.rs(x["vICMS"])}</td><td class="r mono">{D.rs(x["vIBS"])}</td><td class="r mono">{D.rs(x["vCBS"])}</td>'
        tds += f'<td>{celula_st(d["s"])}</td>'
        body += f'<tr class="{trc}">{tds}</tr>'
    tip = ''
    if dica:
        idx = [d['x']['nNF'] for d in linhas_notas(ordem)].index(sel)
        top = 32 + 28 * (idx + 1) + 2
        tip = f'<div class="tip" style="right:40px;top:{top}px;white-space:nowrap;line-height:1.35">{dica}</div>'
    return f'<div class="grid"><table><thead><tr>{th}</tr></thead><tbody>{body}</tbody></table>{tip}<div class="sb"><i></i></div></div>'

def trocar_cards(linha, t):
    vals = [D.rs(t['vNF']), D.rs(t['vBC']), D.rs(t['vICMS']), D.rs(t['vIBS']), D.rs(t['vCBS'])]
    it = iter(vals)
    return re.sub(r'<div class="val mono">[^<]*</div>', lambda m: f'<div class="val mono">{next(it)}</div>', linha, count=5)

def janela_notas(linha_base, tam, ordem, sel=None, dica=None):
    i = linha_base.find('<div class="grid">')
    assert linha_base.endswith('</div>' * 5)
    j = len(linha_base) - len('</div>') * 4   # depois da grade: fecham main, body, client e win
    corpo = linha_base[:i] + grade(tam, ordem, sel, dica) + linha_base[j:]
    corpo = trocar_cards(corpo, D.totais(D.AUTORIZADAS))
    corpo = re.sub(r'<span class="cont">\d+ notas</span>', f'<span class="cont">{len(D.AUTORIZADAS)} notas</span>', corpo)
    corpo = re.sub(r'<div class="seg">.*?</div>', '<div class="seg"><span class="on">Todos</span><span class="">NF-e 55</span><span class="">NFC-e 65</span></div>', corpo, count=1)
    return corpo

def gerar_notas():
    txt = tirar_bloco(ler('notas.html'))
    ls = txt.split('\n')
    base = {1024: None, 1366: None}
    basesel = {1024: None, 1366: None}
    for k, l in enumerate(ls):
        if l.startswith('<h2 id="dados">'):
            base[1024], base[1366] = ls[k + 3], ls[k + 5]
        if l.startswith('<h2 id="selecionada">'):
            basesel[1024], basesel[1366] = ls[k + 3], ls[k + 5]
    assert all(base.values()) and all(basesel.values())
    c = D.contagem()
    dica = ('Erro: 2 contas de IBS/CBS não fecham com os valores do XML.<br>'
            'Detalhes no Resumo e no relatório Divergências IBS/CBS.')
    b = []
    b.append('<h2 id="p7-conferencia">Estado: Com dados e coluna IBS/CBS <span class="p7tag">Plano 7 · v1.3.0</span></h2>')
    b.append('<div class="nota"><ul>'
             '<li>Coluna nova <b>IBS/CBS</b> (campo <code>conf_ibscbs</code>), 80 px, <b>sempre visível e por último</b> (decisão P7-3). Ícone Lucide 16 px + texto 10 pt na cor do status: OK (<code>circle-check</code>, CorSucesso), Alerta (<code>triangle-alert</code>, CorAviso), Erro (<code>circle-x</code>, CorErro). Nota sem IBS/CBS: célula vazia.</li>'
             '<li>Em 1024×640 cabem Nº, Modelo, Data, Chave (333 px, acima do mínimo de 330) e Valor + IBS/CBS.</li>'
             '<li>Em 1366×768 a coluna nova não deixa caber as 4 colunas extras (faltam 63 px). Decisão P7-4: as extras entram por prioridade (IBS, CBS, ICMS e só depois Base ICMS). Em 1366 a Base ICMS fica oculta.</li>'
             f'<li>Dados do gabarito (<code>tests/gabarito</code>): {len(D.AUTORIZADAS)} notas autorizadas, {c["conferidas"]} conferidas. Chaves fictícias (CNPJ com DV inválido), valores dos XMLs de exemplo.</li>'
             '</ul></div>')
    b.append('<h3>1024×640</h3>')
    b.append(janela_notas(base[1024], 1024, 'num'))
    b.append('<h3>1366×768</h3>')
    b.append(janela_notas(base[1366], 1366, 'num'))
    b.append('<h2 id="p7-erro-selecionada">Estado: Ordenado por IBS/CBS, nota com Erro selecionada e dica <span class="p7tag">Plano 7 · v1.3.0</span></h2>')
    b.append('<div class="nota"><ul>'
             '<li>Clique no título IBS/CBS ordena por gravidade (Erro, Alerta, OK, vazia) e, no empate, por Nº. O 1º clique já põe o Erro no topo (▼), decisão P7-5.</li>'
             '<li>Linha selecionada (CorPrimariaSuave): os textos de status continuam acima de 4,5:1 (Erro 4,90:1, Alerta 5,23:1, OK 4,77:1).</li>'
             '<li>Dica por célula: <code>TDBGrid.OnMouseMove</code> + <code>MouseCoord</code> troca o <code>Hint</code> e chama <code>Application.CancelHint</code> quando muda a célula (o TDBGrid não tem hint por coluna). Texto do glossário 16.7, em duas linhas.</li>'
             '</ul></div>')
    b.append('<h3>1024×640</h3>')
    b.append(janela_notas(basesel[1024], 1024, 'sit', '910009', dica))
    b.append('<h3>1366×768</h3>')
    b.append(janela_notas(basesel[1366], 1366, 'sit', '910009', dica))
    # opções
    amostra = lambda nome_alerta: (
        '<table style="border-collapse:collapse;font-size:10pt;width:100%"><tbody>' +
        ''.join(f'<tr><td style="padding:4px 8px;border-bottom:1px solid var(--CorBorda)">{n}</td>'
                f'<td style="padding:4px 8px;border-bottom:1px solid var(--CorBorda);width:90px">{celula_st(s, nome_alerta)}</td></tr>'
                for n, s in (('910009', 'Erro'), ('10435', 'Alerta'), ('10436', 'OK'), ('22', ''))) + '</tbody></table>')
    b.append('<h2 id="p7-opcoes">Opções avaliadas da coluna IBS/CBS (decididas em 11/11/2026) <span class="p7tag">Plano 7 · v1.3.0</span></h2>')
    b.append('<h3>P7-2 · Ícone do Alerta</h3><div class="opt">'
             f'<div class="sug"><h4>A · triangle-alert <span class="sugl">ESCOLHIDA (P7-2)</span></h4>{amostra("triangle-alert")}<p class="help">Mesmo trio do Resumo (contadores, faixas e log): o usuário vê o mesmo ícone na grade e no log. O triângulo também difere do círculo pela forma, sem depender da cor.</p></div>'
             f'<div><h4>B · circle-alert</h4>{amostra("circle-alert")}<p class="help">Três círculos, visual mais uniforme. Mas no app o circle-alert é o ícone de erro de campo, e o log usa o triângulo para o mesmo Alerta.</p></div></div>')
    b.append('<h3>P7-3 · Posição da coluna</h3><div class="opt">'
             '<div class="sug"><h4>A · Última coluna, sempre visível <span class="sugl">ESCOLHIDA (P7-3)</span></h4><p class="help">Nº · Modelo · Data · Chave · Valor · [extras] · <b>IBS/CBS</b>. Fica ao lado dos valores de IBS e CBS quando eles aparecem. Em 1024 a posição é a mesma das outras opções.</p></div>'
             '<div><h4>B · Depois da Data</h4><p class="help">Nº · Modelo · Data · <b>IBS/CBS</b> · Chave · Valor… A situação fica perto da identificação da nota, mas separa a chave do número.</p></div>'
             '<div><h4>C · Primeira coluna, só o ícone (32 px)</h4><p class="help">Economiza 48 px, mas o texto só aparece na dica, e o título “IBS/CBS” não cabe em 32 px.</p></div></div>')
    # Simples Nacional: dica da célula OK (glossário 16.5a, dúvida P7-17)
    mini = lambda n, s: (f'<tr><td class="r mono" style="padding:4px 8px;border-bottom:1px solid var(--CorBorda)">{n}</td>'
                         f'<td class="c" style="padding:4px 8px;border-bottom:1px solid var(--CorBorda)">55</td>'
                         f'<td style="padding:4px 8px;border-bottom:1px solid var(--CorBorda);width:90px">{celula_st(s)}</td></tr>')
    tabela_sn = lambda dica: ('<div style="position:relative;padding-bottom:64px"><table style="border-collapse:collapse;font-size:10pt;width:100%"><tbody>' +
                              mini("910041", "Erro") + mini("910040", "OK") + "</tbody></table>" +
                              f'<div class="tip" style="right:24px;top:60px;white-space:nowrap;line-height:1.35">{dica}</div></div>')
    b.append('<h2 id="p7-simples">Opções para decidir: dica da célula OK de nota do Simples Nacional <span class="p7tag">Plano 7 · v1.3.0</span></h2>')
    b.append('<div class="nota"><ul><li>Nota do Simples com itens só com <code>gTribSN</code> (D22): a célula fica <b>OK</b> quando os totais batem, mas base e alíquota dos itens não foram conferidas. A célula de Erro (910041) usa a dica 16.7, sem mudança.</li></ul></div>')
    b.append('<div class="opt">'
             '<div class="sug"><h4>A · Dica própria (16.5a) <span class="sugl">SUGESTÃO</span></h4>' +
             tabela_sn('Totais de IBS/CBS conferidos, sem divergência.<br>Nota do Simples Nacional (gTribSN): base e alíquota dos itens não são conferidas.') +
             '<p class="help">O OK não dá a entender que a nota inteira foi conferida. Mesmo padrão da 16.5 (itens sem conferência).</p></div>'
             '<div><h4>B · Dica comum do OK (16.4)</h4>' +
             tabela_sn('Cálculos de IBS/CBS conferidos, sem divergência.') +
             '<p class="help">Nada novo no código da dica; a informação do Simples fica só na linha de resumo do log (17.23b).</p></div></div>')
    txt = por_css(txt, CSS_COMUM)
    txt = por_toc(txt, '<a href="#p7-conferencia">Com dados e coluna IBS/CBS (v1.3.0)</a><a href="#p7-erro-selecionada">Ordenado por IBS/CBS + dica (v1.3.0)</a><a href="#p7-opcoes">Opções avaliadas da coluna (v1.3.0)</a><a href="#p7-simples">Opções: dica do Simples (v1.3.0)</a>')
    txt = por_corpo(txt, '\n'.join(b))
    gravar('notas.html', txt)

# ------------------------------------------------------------------ RESUMO
def log_conferencia():
    """(classe, texto) das linhas da conferência, agrupadas no fim do log (sugestão P7-7)."""
    c = D.contagem()
    out = [('lok', f'{len(D.AUTORIZADAS)} notas autorizadas carregadas.'),
           ('ler', resumo_conf(c))]
    feitos = set()
    por_nota = {}
    for l in D.LINHAS:
        por_nota.setdefault(l['n'], []).append(l)
    numeros = sorted(set(list(por_nota) + list(D.INFO)), key=int)
    for n in numeros:
        for l in por_nota.get(n, []):
            out.append(('ler' if l['tipo'] == 'Erro' else 'lav', l['log']))
        if n in D.INFO:
            out.append(('lav', D.INFO[n]))
    return out

def mencao_simples(x, k):
    """Glossário 17.23b: complemento da linha de resumo (D22), uma menção só, sem linha por nota."""
    if not x:
        return ''
    if x == k:
        if k == 1:
            return '; do Simples Nacional, sem conferir base e alíquota'
        return '; todas do Simples Nacional, sem conferir base e alíquota'
    return f'; {x} do Simples Nacional, sem conferir base e alíquota'

def resumo_conf(c):
    k = c['conferidas']
    base = f'Conferência de IBS/CBS: {k} ' + ('nota conferida' if k == 1 else 'notas conferidas')
    if c['erro'] and c['alerta']:
        base += f', {c["erro"]} com Erro e {c["alerta"]} com Alerta'
    elif c['erro']:
        base += f', {c["erro"]} com Erro'
    elif c['alerta']:
        base += f', {c["alerta"]} com Alerta'
    else:
        base += ', sem divergência'
    return base + mencao_simples(c.get('simples', 0), k) + '.'

def li(cls, texto):
    nome = {'lok': 'circle-check', 'lav': 'triangle-alert', 'ler': 'circle-x'}[cls]
    return f'<div class="{cls}">{ic(nome, 16)}<span>{html.escape(texto, quote=False)}</span></div>'

def janela_resumo(base, linhas_log):
    t = D.totais(D.AUTORIZADAS)
    s = trocar_cards(base, t)
    s = re.sub(r'<div class="n">128</div>', f'<div class="n">{len(D.AUTORIZADAS)}</div>', s)
    s = re.sub(r'<div class="n">3</div>', f'<div class="n">{len(D.IGNORADAS)}</div>', s)
    s = re.sub(r'<div class="n">1</div>', '<div class="n">0</div>', s)
    s = s.replace('4,2 s</div>', '0,6 s</div>').replace('132 arquivos lidos', f'{D.ARQUIVOS} arquivos lidos')
    hom = sum(1 for x in D.AUTORIZADAS if x['tpAmb'] == '2')
    ent = sum(1 for x in D.AUTORIZADAS if x['tpNF'] == '0')
    s = re.sub(r'<b>Os totais incluem 2 notas de homologação</b>(.*?)<b>e 5 NF-e de entrada.</b>',
               lambda m: f'<b>Os totais incluem {hom} notas de homologação</b>{m.group(1)}<b>e {ent} NF-e de entrada.</b>', s)
    s = s.replace('Processado em 19/10/2026 14:32', 'Processado em 20/11/2026 14:32')
    i = s.find('<div class="log">')
    j = s.find('<div class="panel"', i) if False else s.rfind('</span></div>', i, s.find('</div></div></div></div></div></div></div>', i) + 50)
    j = j + len('</span></div>') + len('</div>')
    novo = '<div class="log" style="position:relative;padding-right:17px">' + ''.join(li(c, t) for c, t in linhas_log) + \
           '<div style="position:absolute;right:0;top:0;bottom:0;width:17px;background:#F0F0F0;border-left:1px solid #E3E3E3;padding:0"><i style="position:absolute;left:4px;right:4px;bottom:24px;height:40px;background:#C2C2C2;display:block"></i></div></div>'
    return s[:i] + novo + s[j:]

def gerar_resumo():
    txt = tirar_bloco(ler('resumo.html'))
    ls = txt.split('\n')
    for k, l in enumerate(ls):
        if l.startswith('<h2 id="concluido">'):
            b1024, b1366 = ls[k + 3], ls[k + 5]
    lc = log_conferencia()
    hom_ult = ('lav', 'Nota Fiscal 910036: homologação (tpAmb 2), somada aos totais.')
    # 1024: começo do bloco da conferência; 1366: trecho do meio, com Erro, Alerta e linha informativa
    t1024 = [hom_ult] + lc[:9]
    t1366 = lc[-15:]   # fim do log: Erros do Simples Nacional (910041 a 910053)
    b = ['<h2 id="p7-conferencia">Estado: Concluído, com a conferência de IBS/CBS <span class="p7tag">Plano 7 · v1.3.0</span></h2>',
         '<div class="nota"><ul>'
         '<li>A conferência não muda cards nem contadores (Autorizadas, Ignoradas, Com erro).</li>'
         '<li>Uma linha por divergência: Erro → <code>llErro</code> (<code>circle-x</code>), Alerta → <code>llAviso</code> (<code>triangle-alert</code>). Uma linha por esfera (D7).</li>'
         '<li>Casos sem conferência: uma linha por nota, <code>llAviso</code>, sem contar como divergência (D9). Ex.: 910020 e 910022.</li>'
         '<li>Decisão P7-7: as linhas da conferência vêm <b>juntas no fim do log</b>, depois de “N notas autorizadas carregadas.”, abertas por uma linha de resumo (glossário 17.23, decisão P7-11) e ordenadas por Nº, item e nível. </li>'
         '<li><b>Simples Nacional (D22):</b> os itens com <code>gTribSN</code> e sem <code>gIBSCBS</code> não ganham linha por nota. A linha de resumo diz quantas notas conferidas são do Simples (glossário 17.23b; 9 no gabarito: 910040 a 910043, 910047 e 910050 a 910053). Os Erros do <code>gTribSN</code> (17.7b, 17.8a e 17.9a) saem como os outros, uma linha por divergência.</li>'
         '<li>Os quadros mostram o log rolado: 1024 no começo do bloco da conferência (com a linha de resumo), 1366 no fim do log (Erros do Simples Nacional). A lista completa está logo abaixo.</li>'
         f'<li>Dados do gabarito: pastas <code>exemple</code>, <code>exemple\\sinteticos</code> e <code>exemple\\sinteticos-ibscbs</code> lidas juntas ({D.ARQUIVOS} arquivos, {len(D.AUTORIZADAS)} autorizadas, {D.contagem()["conferidas"]} conferidas).</li>'
         '</ul></div>',
         '<h3>1024×640</h3>', janela_resumo(b1024, t1024),
         '<h3>1366×768</h3>', janela_resumo(b1366, t1366),
         '<h3>Todas as linhas da conferência (gabarito, filtro Todos)</h3>',
         '<div class="logfull">' + ''.join(li(c, t) for c, t in lc) + '</div>',
         '<h3>Linha de resumo em outros cenários (17.23, 17.23a e 17.23b)</h3>',
         '<p class="help">Sem divergência e sem nota do Simples:</p>',
         '<div class="logfull">' + li('lok', '3 notas autorizadas carregadas.') + li('lok', resumo_conf(dict(conferidas=2, erro=0, alerta=0, simples=0))) + '</div>',
         '<p class="help">Pasta só com as 2 notas do Simples sem divergência (910040 e 910050):</p>',
         '<div class="logfull">' + li('lok', '2 notas autorizadas carregadas.') + li('lok', resumo_conf(dict(conferidas=2, erro=0, alerta=0, simples=2))) + '</div>',
         '<p class="help">Pasta sem nenhuma nota com IBS/CBS: não sai a linha de resumo da conferência (decisão de 11/11/2026, revisão da 7.3).</p>',
         '<div class="logfull">' + li('lok', '3 notas autorizadas carregadas.') + '</div>',
         '<div class="nota"><ul><li><b>O log não muda com o filtro de modelo</b> (decisão de 11/11/2026, revisão da 7.3): ele descreve a leitura da pasta inteira, então a linha de resumo e as linhas por nota são as mesmas em Todos, NF-e 55 e NFC-e 65. A grade (coluna IBS/CBS) e o relatório Divergências IBS/CBS respeitam o filtro.</li>'
         '<li>Nota com item monofásico e <code>gMono</code> no total (910020): os dois motivos na mesma linha “sem conferência” (glossário 17.21 e 17.22i), depois das divergências da mesma nota, se houver.</li></ul></div>',
         '<h2 id="p7-simples-opcoes">Opções para decidir: onde fica a menção do Simples Nacional (D22) <span class="p7tag">Plano 7 · v1.3.0</span></h2>',
         '<div class="opt"><div class="sug"><h4>A · Na própria linha de resumo <span class="sugl">SUGESTÃO</span></h4><div class="logfull">' +
         li('ler', resumo_conf(D.contagem())) +
         '</div><p class="help">Uma linha só, como diz a D22, no mesmo molde de “19 com Erro”. O complemento só aparece quando há nota do Simples e fica com o ícone da linha de resumo (Erro, se houver Erro). Cabe na largura do log em 1024 px (por isso sem a tag gTribSN, que já está nas linhas de Erro).</p></div>'
         '<div><h4>B · Linha própria logo abaixo do resumo (texto do nfe-fiscal)</h4><div class="logfull">' +
         li('ler', resumo_conf(dict(D.contagem(), simples=0))) +
         li('lav', f'Conferência de IBS/CBS: {D.contagem()["simples"]} notas do Simples Nacional conferidas só nos totais (gTribSN).') +
         '</div><p class="help">Mais fácil de achar, com o ícone de aviso. Mas são duas linhas que começam com “Conferência de IBS/CBS:”, e “só nos totais” não é exato: o cClassTrib (nível 4) também é conferido nesses itens.</p></div></div>']
    txt = por_css(txt, CSS_COMUM)
    txt = por_toc(txt, '<a href="#p7-conferencia">Concluído com a conferência de IBS/CBS (v1.3.0)</a><a href="#p7-simples-opcoes">Opções: menção do Simples (v1.3.0)</a>')
    txt = por_corpo(txt, '\n'.join(b))
    gravar('resumo.html', txt)

# ------------------------------------------------------------------ RELATÓRIOS
def gerar_relatorios():
    txt = tirar_bloco(ler('relatorios.html'))
    ls = txt.split('\n')
    for k, l in enumerate(ls):
        if l.startswith('<h2 id="com-dados">'):
            b1024, b1366 = ls[k + 3], ls[k + 5]
        if l.startswith('<h2 id="sem-dados">'):
            v1024, v1366 = ls[k + 3], ls[k + 5]
    c = D.contagem()
    # Quadro "Relatório IBS/CBS" (8.6): conta só as notas com o grupo total/IBSCBSTot (decisão do usuário, B3).
    # O quadro "Divergências" conta as conferidas (temibs: IBSCBSTot ou IBS/CBS nos itens).
    ib = sum(1 for x in D.AUTORIZADAS if x['temtot'])
    def janela(base, cenario):
        if cenario == 'div':
            notas = D.AUTORIZADAS; nt = len(notas); modelo = 'Todos'
            od3 = (f'Erros e alertas da conferência de IBS/CBS, um por linha: nota, item, nível, campo, valor no XML e valor esperado. '
                   f'{c["erro"]} notas com Erro e {c["alerta"]} com Alerta.')
            od2 = f'Base IBS/CBS, IBS UF, IBS municipal, IBS e CBS das notas que têm o grupo IBS/CBS. {ib} de {nt} notas têm IBS/CBS.'
        else:
            notas = [x for x in D.AUTORIZADAS if x['pasta'] == 'exemple' and x['mod'] == '65']; nt = len(notas); modelo = 'NFC-e 65'
            conf2 = sum(1 for x in notas if x['temibs'])
            ib2 = sum(1 for x in notas if x['temtot'])
            od3 = f'Erros e alertas da conferência de IBS/CBS, um por linha: nota, item, nível, campo, valor no XML e valor esperado. Nenhuma divergência nas {conf2} notas conferidas.'
            od2 = f'Base IBS/CBS, IBS UF, IBS municipal, IBS e CBS das notas que têm o grupo IBS/CBS. {ib2} de {nt} notas têm IBS/CBS.'
        s = trocar_cards(base, D.totais(notas))
        s = s.replace('Modelo: Todos · 128 notas', f'Modelo: {modelo} · {nt} notas')
        if modelo != 'Todos':
            s = s.replace('<span class="on">Todos</span><span class="">NF-e 55</span><span class="">NFC-e 65</span>',
                          '<span class="">Todos</span><span class="">NF-e 55</span><span class="on">NFC-e 65</span>')
            s = s.replace('C:\\XMLs\\Empresa Exemplo\\2026-10', 'C:\\XMLs\\Loja Exemplo\\2026-09')
        s = re.sub(r'(Relatório IBS/CBS</div><div class="od">)[^<]*', lambda m: m.group(1) + od2, s)
        quadro3 = (f'<div class="opc"><div class="ot">{ic("list-checks", 20)} Divergências IBS/CBS</div><div class="od">{od3}</div>'
                   f'<div class="rod"><span class="btn pri">{ic("printer", 16)} Gerar relatório</span></div></div>')
        k = s.find('</div></div></div><div class="help">')
        s = s[:k] + '</div></div>' + quadro3 + s[k + len('</div></div>'):]
        return s
    menu_b = ('<div style="width:200px;background:var(--CorSuperficie);border:1px solid var(--CorBorda);padding-top:8px">' +
              ''.join(f'<div class="mi{" on" if on else ""}" style="{"padding-left:36px" if sub else ""}">{ic(i, 20)}<span>{t}</span></div>'
                      for t, i, on, sub in (('Resumo', 'layout-dashboard', False, False), ('Notas', 'file-text', False, False),
                                            ('Relatórios', 'printer', False, False), ('Divergências IBS/CBS', 'list-checks', True, False),
                                            ('Enviar', 'send', False, False), ('Configurações', 'settings', False, False))) + '</div>')
    b = ['<h2 id="p7-divergencias">Estado: Com dados e o relatório Divergências IBS/CBS <span class="p7tag">Plano 7 · v1.3.0</span></h2>',
         '<div class="nota"><ul>'
         '<li><b>Decisão P7-1 (11/11/2026):</b> o relatório Divergências IBS/CBS é o <b>3º quadro desta tela</b>, depois do Relatório IBS/CBS. O menu lateral não muda (5 itens, só navega), como na decisão N6 do Plano 4.</li>'
         '<li>Com divergências: botão habilitado e contagem de notas com Erro e com Alerta. Sem divergência: botão continua habilitado e o relatório sai com a mensagem “Nenhuma divergência de IBS/CBS” (decisão P7-9). Sem nota com IBS/CBS no filtro: botão desabilitado com a dica 8.10, como no Relatório IBS/CBS.</li>'
         '<li>Três quadros lado a lado: em 1024 cada um fica com ~248 px e o texto quebra em mais linhas, sem rolagem.</li>'
         '<li>Ícone novo <code>list-checks</code> (Lucide 1.59.0, ISC), 20 px, CorPrimaria. Ver icones.md.</li>'
         '</ul></div>',
         '<h3>1024×640</h3>', janela(b1024, 'div'),
         '<h3>1366×768</h3>', janela(b1366, 'div'),
         '<h2 id="p7-sem-divergencia">Estado: Conferência sem divergência <span class="p7tag">Plano 7 · v1.3.0</span></h2>',
         '<div class="nota"><ul><li>Pasta só com as NFC-e reais (nNF 20, 21 e 22), filtro NFC-e 65: 2 notas conferidas, nenhuma divergência; a 22 não tem IBS/CBS.</li></ul></div>',
         '<h3>1024×640</h3>', janela(b1024, 'ok'),
         '<h3>1366×768</h3>', janela(b1366, 'ok')]
    b += bloco_desabilitado(b1024, b1366, v1024, v1366)
    txt = por_css(txt, CSS_COMUM + CSS_DESAB)
    txt = por_toc(txt, '<a href="#p7-divergencias">Com o relatório Divergências IBS/CBS (v1.3.0)</a><a href="#p7-sem-divergencia">Conferência sem divergência (v1.3.0)</a>'
                       '<a href="#p7-desabilitado">Quadros desabilitados: dica abaixo do botão (D2, v1.3.0)</a>')
    txt = por_corpo(txt, '\n'.join(b))
    gravar('relatorios.html', txt)

# ------------------------------------------------------------------ RELATÓRIOS: estado desabilitado (defeito D2 da B3)
CSS_DESAB = """
.rod.ab{flex-direction:column;align-items:flex-start;gap:8px}
.rod.ab .dica{align-items:flex-start;gap:4px;line-height:16px;width:100%;white-space:normal}
.rod.ab .dica .ic{margin-top:1px}
.rod.ab .dica.res{visibility:hidden}
.cota{font-size:9pt;color:#3A4050;background:#FFFFFF;border:1px dashed #A8ADB6;padding:8px 12px;max-width:1000px;margin:8px 0 16px;line-height:1.5}
"""
TXT_88 = 'Processe uma pasta para gerar relatórios.'
TXT_88A = 'Nenhuma nota do modelo selecionado. Escolha outro modelo na barra de cima.'
TXT_184 = 'Nenhuma nota do modelo selecionado tem IBS/CBS.'
OD_IBS = 'Base IBS/CBS, IBS UF, IBS municipal, IBS e CBS das notas que têm o grupo IBS/CBS.'
OD_DIV = 'Erros e alertas da conferência de IBS/CBS, um por linha: nota, item, nível, campo, valor no XML e valor esperado.'

def rod_ab(hab, dica, reserva):
    """Botão em cima; dica abaixo, na largura interna toda do quadro. Quadro sem dica reserva a mesma altura
    (cópia invisível da dica mais longa da faixa) para os 3 botões ficarem na mesma linha."""
    btn = f'<span class="btn pri{"" if hab else " dis"}">{ic("printer", 16)} Gerar relatório</span>'
    if dica:
        d = f'<span class="dica">{ic("info", 14)}<span>{dica}</span></span>'
    elif reserva:
        d = f'<span class="dica res" aria-hidden="true">{ic("info", 14)}<span>{reserva}</span></span>'
    else:
        d = ''
    return f'<div class="rod ab">{btn}{d}</div>'

def janela_desab(base, estado):
    sem_ibs = [x for x in D.AUTORIZADAS if x['pasta'] == 'exemple' and x['mod'] == '65' and not x['temibs']]
    if estado == 'semdados':
        s = base; dicas = (TXT_88, TXT_88, TXT_88); habs = (False, False, False); od2 = OD_IBS + ' '
    elif estado == 'semmodelo':
        s = trocar_cards(base, D.totais([]))
        s = s.replace('Modelo: Todos · 128 notas', 'Modelo: NF-e 55 · 0 notas')
        s = s.replace('<span class="on">Todos</span><span class="">NF-e 55</span><span class="">NFC-e 65</span>',
                      '<span class="">Todos</span><span class="on">NF-e 55</span><span class="">NFC-e 65</span>')
        dicas = (TXT_88A, TXT_88A, TXT_88A); habs = (False, False, False); od2 = OD_IBS
    else:  # semibs: pasta com 1 NFC-e sem IBS/CBS, filtro Todos
        n = len(sem_ibs)
        s = trocar_cards(base, D.totais(sem_ibs))
        s = s.replace('Modelo: Todos · 128 notas', f'Modelo: Todos · {n} nota{"" if n == 1 else "s"}')
        dicas = (None, TXT_184, TXT_184); habs = (True, False, False)
        od2 = OD_IBS + (f' 0 de {n} nota tem IBS/CBS.' if n == 1 else f' 0 de {n} notas têm IBS/CBS.')
    if estado != 'semdados':
        s = s.replace('C:\\XMLs\\Empresa Exemplo\\2026-10', 'C:\\XMLs\\Loja Exemplo\\2025-12')
        s = s.replace('<div class="val mono">R$ 0,00</div>', '<div class="val zero mono">R$ 0,00</div>')
    longa = max((d for d in dicas if d), key=len)
    rods = iter([rod_ab(h, d, longa) for h, d in zip(habs, dicas)])
    s = re.sub(r'<div class="rod">.*?</div>', lambda m: next(rods), s, count=2)
    s = re.sub(r'(Relatório IBS/CBS</div><div class="od">)[^<]*', lambda m: m.group(1) + od2, s)
    quadro3 = (f'<div class="opc"><div class="ot">{ic("list-checks", 20)} Divergências IBS/CBS</div><div class="od">{OD_DIV}</div>'
               + next(rods) + '</div>')
    k = s.find('</div></div></div><div class="help">')
    s = s[:k] + '</div></div>' + quadro3 + s[k + len('</div></div>'):]
    return s

def bloco_desabilitado(b1024, b1366, v1024, v1366):
    return [
        '<h2 id="p7-desabilitado">Estado: Quadros desabilitados, dica abaixo do botão <span class="p7tag">Plano 7 · v1.3.0 · D2</span></h2>',
        '<div class="nota"><ul>'
        '<li><b>Defeito D2 da B3 (11/11/2026):</b> com 3 quadros, em 1024 a dica ao lado do botão desabilitado ficava com ~40 px e era cortada. '
        '<b>Regra:</b> a dica vai <b>sempre abaixo do botão</b>, em qualquer largura, ocupando a largura interna toda do quadro. Especificação em tokens.md, 5.16.</li>'
        '<li>Os 3 botões ficam na mesma linha: o quadro sem dica (Relatório de Notas no último exemplo) reserva a altura da dica mais longa da faixa. '
        'Os 3 quadros têm sempre a mesma altura.</li>'
        '<li>Substitui a dica ao lado do botão dos estados “Sem dados” e “Com dados, sem IBS/CBS no filtro” acima (desenhados com 2 quadros, no Plano 4).</li>'
        '</ul></div>',
        '<div class="cota"><b>Medidas a 100%</b> (largura interna = quadro − 2 de borda − 2 × 16 de padding; largura do texto da dica = interna − 14 do ícone − 4 de espaço):<br>'
        '1024×640: quadro 248 px · interna 214 · texto 196 → 18.4 em 2 linhas, 8.8a em 3, 8.8 em 2 (reserva de até 48 px).<br>'
        '1366×768: quadro 362 px · interna 328 · texto 310 → 18.4 em 1 linha, 8.8a em 2, 8.8 em 1.<br>'
        'Rodapé do quadro = botão 32 + 8 + linhas × 16 (só o botão, 32, se nenhum quadro da faixa tiver dica).</div>',
        '<h3>Sem dados (8.8) · 1024×640</h3>', janela_desab(v1024, 'semdados'),
        '<h3>Sem dados (8.8) · 1366×768</h3>', janela_desab(v1366, 'semdados'),
        '<h3>Sem notas no modelo, filtro NF-e 55 (8.8a) · 1024×640</h3>', janela_desab(b1024, 'semmodelo'),
        '<h3>Sem notas no modelo, filtro NF-e 55 (8.8a) · 1366×768</h3>', janela_desab(b1366, 'semmodelo'),
        '<h3>Sem nota com IBS/CBS no filtro (8.10 / 18.4) · 1024×640</h3>', janela_desab(b1024, 'semibs'),
        '<h3>Sem nota com IBS/CBS no filtro (8.10 / 18.4) · 1366×768</h3>', janela_desab(b1366, 'semibs'),
    ]

# ------------------------------------------------------------------ A4
COLS_A4 = [('Nº', 'r', 52), ('Mod.', 'c', 36), ('Data', '', 68), ('Item', 'c', 40), ('Nível', 'c', 40), ('Tipo', '', 48),
           ('Campo', '', None), ('Valor no XML', 'r', 96), ('Esperado', 'r', 96)]

def thead_a4():
    return '<thead><tr>' + ''.join(f'<th class="{a}"' + (f' style="width:{w}px"' if w else '') + f'>{n}</th>' for n, a, w in COLS_A4) + '</tr></thead>'

def tr_a4(l):
    tipo = f'<b style="font-weight:600">{l["tipo"]}</b>' if l['tipo'] == 'Erro' else l['tipo']
    return (f'<tr><td class="r">{l["n"]}</td><td class="c">{l["mod"]}</td><td>{l["data"]}</td><td class="c">{l["item"]}</td>'
            f'<td class="c">{l["nivel"]}</td><td>{tipo}</td><td>{l["campo"]}</td><td class="r">{l["xml"]}</td><td class="r">{l["esp"]}</td></tr>')

def plural(n, s, p):
    return f'{n} {s if n == 1 else p}'

def totais_a4(c):
    k = c['erro'] + c['alerta']
    return (f'<tr class="tot"><td colspan="9">Total · {plural(c["div"], "divergência", "divergências")} em {plural(k, "nota", "notas")}</td></tr>'
            f'<tr class="tot2"><td colspan="9"><b style="font-weight:600;color:var(--CorTexto)">Notas com Erro: {c["erro"]} · Notas com Alerta: {c["alerta"]} · Notas sem divergência: {c["ok"]}</b> · a nota com Erro e Alerta conta só em Erro</td></tr>'
            '<tr class="tot2"><td colspan="9">Nível 1: conta do item · Nível 2: itens × totais · Nível 3: base de cálculo · Nível 4: alíquota, redução e CST. Níveis 1 e 2 são Erro; 3 e 4, Alerta.</td></tr>'
            '<tr class="tot2"><td colspan="9">Erro: conta que não fecha com os valores do próprio XML. Alerta: indicação para conferir; depende da operação e da regra legal e não afirma que a nota está errada.</td></tr>'
            '<tr class="tot2"><td colspan="9">Não entram: notas sem IBS/CBS e itens sem conferência (monofásico, transferência de crédito, ajustes, compra governamental; veja o Resumo). Nos itens do Simples Nacional (gTribSN), só os totais e o cClassTrib são conferidos.</td></tr>'
            '<tr class="tot2"><td colspan="9">Regras da NT 2025.002 v1.53, da NT 2026.005 v1.00 (Simples Nacional) e da tabela de cClassTrib v1.71. A conferência não muda os totais do ProXML.</td></tr>')

def cab_a4(logo, modelo_txt, c, periodo, pasta):
    sub = (f'<b>Período:</b> {periodo} · <b>Modelo:</b> {modelo_txt} · <b>{c["conferidas"]}</b> {"nota conferida" if c["conferidas"] == 1 else "notas conferidas"} · '
           f'<b>{c["div"]}</b> {"divergência" if c["div"] == 1 else "divergências"}')
    return (f'<div class="rh"><div><div class="t">Divergências IBS/CBS</div><div class="m">{sub}</div>'
            f'<div class="m"><b>Pasta:</b> {pasta}</div></div><div class="wm">{logo}</div></div>')

def rodape(p, t):
    return f'<div class="rf">Gerado pelo ProXML v1.3.0 · 20/11/2026 14:32 · Página {p} de {t}</div>'

def gerar_a4():
    base = ler('relatorio-a4.html')
    head = base[:base.find('</style>')]
    logo = re.search(r'<div class="wm">(<img [^>]*>)</div>', base).group(1)
    nav = re.search(r'<nav>.*?</nav>', base).group(0)
    nav = nav.replace('<a href="relatorio-a4.html">Relatório A4</a>', '<a href="relatorio-a4.html">Relatório A4</a><a href="relatorio-divergencias-a4.html">Divergências A4</a>')
    head = head.replace('<title>ProXML – Relatórios A4 (mockup)</title>', '<title>ProXML – Relatório Divergências IBS/CBS A4 (mockup)</title>')
    css = CSS_COMUM + """
.a4.corte{height:auto;min-height:0;padding-bottom:64px}
.vazioa4{margin:48px auto 0;width:520px;text-align:center;border:1px solid var(--CorBorda);padding:24px}
.vazioa4 .t1{font-size:12pt;font-weight:600;margin-bottom:6px}
.vazioa4 .t2{font-size:9pt;color:var(--CorTextoSecundario)}
.rt tr.tot2 td{white-space:normal}
"""
    pasta = 'C:\\XMLs\\Empresa Exemplo\\2026-10'
    def periodo(mod=None):
        ds = sorted(x['dhEmi'] for x in D.AUTORIZADAS if x['temibs'] and (mod is None or x['mod'] == mod))
        return D.data_br(ds[0]) + ' a ' + D.data_br(ds[-1])
    per = periodo()
    cT, c65 = D.contagem(), D.contagem('65')
    l65 = [l for l in D.LINHAS if l['mod'] == '65']
    body = [nav, '<h1>Relatório Divergências IBS/CBS (QuickReport, A4) <span class="p7tag">Plano 7 · v1.3.0</span></h1>',
            '<p class="help">A4 retrato a 96 dpi (794×1123 px), margens de 10 mm, mesmo padrão do Relatório de Notas e do Relatório IBS/CBS (<a href="relatorio-a4.html">relatorio-a4.html</a>). '
            f'Dados do gabarito <code>tests/gabarito/divergencias.csv</code>: {cT["div"]} divergências em {cT["conferidas"]} notas conferidas (pastas exemple, exemple\\sinteticos e exemple\\sinteticos-ibscbs). Sem CNPJ, CPF, nomes nem chaves.</p>',
            '<div class="nota"><ul>'
            '<li>Colunas: Nº 52 · Mod. 36 · Data 68 · Item 40 · Nível 40 · Tipo 48 · Campo (resto, 242) · Valor no XML 96 · Esperado 96 = 718 px. Ordem Nº antes de Mod., como nos outros relatórios (decisão D9 do Plano 4; decisão P7-10).</li>'
            '<li>Uma linha por divergência, ordenada por Nº, item (Total por último) e nível; esferas na ordem IBS UF, IBS Mun., CBS. Sem agrupar por nota (decisão P7-8).</li>'
            '<li>Item “Total” = divergência de nível 2 (soma dos itens × total da nota).</li>'
            '<li>Valores com a unidade na própria célula (R$, %, “ausente”), porque a coluna mistura tipos. Por isso não há “(R$)” no título.</li>'
            '<li>Tipo “Erro” em Semibold, sem cor: o relatório continua legível em impressora monocromática (tokens, seção 6).</li>'
            f'<li>Cabem 45 linhas por página. Com as {cT["div"]} linhas do gabarito, a 1ª página fica cheia e o rodapé de totais (6 linhas, algumas em 2 linhas) não cabe: o QuickReport passa a banda de resumo para a página 2, que sai só com a continuação, os títulos das colunas e os totais. A paginação segue o Relatório IBS/CBS.</li>'
            '<li>Simples Nacional (NT 2026.005): campos IBS Simples (vIBSSN), CBS Simples (vCBSSN) e Total Simples (gTribSN), glossário 18.C. Exemplos: 910041 a 910044 e 910051 a 910053.</li>'
            '</ul></div>',
            '<div class="toc"><a href="#todos">Todos · 1ª página</a><a href="#todos-ultima">Todos · última página (totais)</a><a href="#nfce">Filtro NFC-e 65 (página única)</a><a href="#vazio">Sem divergência</a></div>',
            '<h2 id="todos">Filtro Todos · página 1 de 2</h2>',
            '<div class="a4">' + cab_a4(logo, 'Todos (NF-e 55 e NFC-e 65)', cT, per, pasta) + '<table class="rt">' + thead_a4() + '<tbody>' +
            ''.join(tr_a4(l) for l in D.LINHAS[:45]) + '</tbody></table>' + rodape(1, 2) + '</div>',
            '<h2 id="todos-ultima">Filtro Todos · página 2 de 2 (última, com totais)</h2>',
            '<div class="nota"><ul><li>Linha de continuação no topo e títulos das colunas repetidos (banda ColumnHeader). Sem linhas de detalhe: todas couberam na página 1.</li></ul></div>',
            '<div class="a4 corte" style="min-height:420px"><div class="run"><span>Divergências IBS/CBS · Modelo: Todos · continuação</span><span>' + per + '</span></div><table class="rt">' + thead_a4() + '<tbody>' +
            ''.join(tr_a4(l) for l in D.LINHAS[45:]) + totais_a4(cT) + '</tbody></table>' + rodape(2, 2) + '</div>',
            '<h2 id="nfce">Filtro NFC-e 65</h2>',
            '<div class="a4 corte" style="min-height:560px">' + cab_a4(logo, 'NFC-e 65', c65, periodo('65'), pasta) + '<table class="rt">' + thead_a4() + '<tbody>' +
            ''.join(tr_a4(l) for l in l65) + totais_a4(c65) + '</tbody></table>' + rodape(1, 1) + '</div>',
            '<h2 id="vazio">Sem divergência</h2>',
            '<div class="nota"><ul><li>Decisão P7-9: o relatório sai mesmo sem divergência (serve de registro de que a conferência foi feita). Exemplo: só as NFC-e reais, filtro NFC-e 65.</li><li>Sem nenhuma nota com IBS/CBS no filtro, o botão fica desabilitado (dica 8.10) e o relatório não é gerado.</li></ul></div>',
            '<div class="a4 corte" style="min-height:420px">' + cab_a4(logo, 'NFC-e 65', dict(conferidas=2, div=0), '24/09/2026', 'C:\\XMLs\\Loja Exemplo\\2026-09') +
            '<div class="vazioa4"><div class="t1">Nenhuma divergência de IBS/CBS</div><div class="t2">As 2 notas com IBS/CBS do filtro foram conferidas, sem Erro nem Alerta.<br>Regras da NT 2025.002 v1.53, da NT 2026.005 v1.00 (Simples Nacional) e da tabela de cClassTrib v1.71.</div></div>' +
            rodape(1, 1) + '</div>']
    out = head + CSS_INI + '\n' + css.strip() + '\n' + CSS_FIM + '\n</style>\n</head>\n<body>\n<div class="doc">\n' + '\n'.join(body) + '\n</div>\n</body>\n</html>\n'
    gravar('relatorio-divergencias-a4.html', out)
    # link no relatorio-a4.html e no index
    base = tirar_bloco(base)
    base = por_toc(base, '<a href="relatorio-divergencias-a4.html">Divergências IBS/CBS (v1.3.0, arquivo próprio)</a>')
    gravar('relatorio-a4.html', base)

def gerar_index():
    txt = tirar_bloco(ler('index.html'))
    linha = ('<tr><td style="padding:6px 12px"><a href="relatorio-divergencias-a4.html">Divergências A4</a></td><td style="padding:6px 12px">'
             'Plano 7 (v1.3.0): relatório Divergências IBS/CBS · filtro Todos (1ª e última página), NFC-e 65 e sem divergência, com o Simples Nacional (gTribSN). '
             'Também: <a href="notas.html#p7-conferencia">Notas com a coluna IBS/CBS</a> · <a href="resumo.html#p7-conferencia">Resumo com a conferência</a> · '
             '<a href="relatorios.html#p7-divergencias">Relatórios com o 3º quadro</a></td></tr>')
    k = txt.find('<tr><td style="padding:6px 12px"><a href="opcoes.html">')
    txt = txt[:k] + INI + linha + FIM + '\n' + txt[k:]
    gravar('index.html', txt)

if __name__ == '__main__':
    gerar_notas(); gerar_resumo(); gerar_relatorios(); gerar_a4(); gerar_index()
    print('ok')
