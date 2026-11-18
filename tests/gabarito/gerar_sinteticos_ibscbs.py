"""Gera XMLs sinteticos de NF-e (55) e NFC-e (65) para a conferencia de IBS/CBS (Plano 7, etapa 7.1).

Uso (na pasta tests/gabarito/): python -I gerar_sinteticos_ibscbs.py ../../exemple/sinteticos-ibscbs

A estrutura (ordem das tags) segue as notas reais de exemple\\ (NF-e nNF 10435 e NFC-e nNF 20) e o
leiaute da NT 2025.002-RTC v1.53. Emitente e destinatario ficticios (CNPJ 12345678000100, CPF
12345678900, ambos com digitos verificadores INVALIDOS de proposito, para nao pertencerem a ninguem;
decisao do Plano 3 aplicada em 18/11/2026), nNF a partir de 910001, assinatura ficticia, protocolo
ficticio. Nenhum dado real.

11/11/2026 (D17): notas 910040 a 910053 com o grupo IBSCBS/gTribSN e o total IBSCBSTot/gTribSN da
NT 2026.005 v1.00 (Simples Nacional), emitidas a partir de 16/11/2026 (entrada em producao da NT).
Os campos emit/tpRegimeIBSCBS, prod/cAtivSN e gTribSN so aparecem nessas notas: as notas 910001 a
910037 continuam identicas, byte a byte.

11/11/2026 (Plano 7, bateria B4): nota 910060 com Erro e Alerta na mesma nota (1 Erro de nivel 1 no
item 1 e 2 Alertas, nivel 4 no item 2 e nivel 3 no item 3), para a dica 16.7 com o complemento
", e ha {a} indicacoes para conferir." e o relatorio com os dois tipos. As demais continuam identicas.

Cada nota e montada com valores corretos e depois recebe as alteracoes de proposito ("erros")
descritas em CASOS. O gabarito (tests/gabarito/gerar_divergencias.py) NAO usa este arquivo.
"""
import os
import sys
from decimal import Decimal as D, ROUND_HALF_UP

C2 = D('0.01')
C4 = D('0.0001')
CNPJ = '12345678000100'   # DV invalido de proposito (o correto seria 95)
CPF = '12345678900'        # DV invalido de proposito (o correto seria 09)


def r2(v):
    return v.quantize(C2, ROUND_HALF_UP)


def r4(v):
    return v.quantize(C4, ROUND_HALF_UP)


def f2(v):
    return str(r2(D(v)))


def f4(v):
    return str(r4(D(v)))


def dv_chave(c43):
    pesos = [2, 3, 4, 5, 6, 7, 8, 9]
    s = sum(int(d) * pesos[i % 8] for i, d in enumerate(reversed(c43)))
    r = s % 11
    return '0' if r < 2 else str(11 - r)


def chave(mod, nnf, aamm='2610'):
    c43 = '31' + aamm + CNPJ + mod + '001' + '%09d' % nnf + '1' + '%08d' % (nnf % 100000000)
    return c43 + dv_chave(c43)


# ---------------------------------------------------------------- itens
def novo_item(vprod, frete='0', seg='0', desc='0', outro='0', crt=3, picms='18', ppis='1.65',
              pcofins='7.60', pipi=None, cst='000', cclass='000001', red=None, pdif=None,
              mono=False, sem_gibscbs=False, ncm='21069010', base_modo='lei', aliq=None, sn=None,
              cativsn=None):
    """Item com valores corretos. base_modo='lei' usa a composicao da NT (UB16-10).

    sn: grupo IBSCBS/gTribSN da NT 2026.005 (D17). Dicionario com 'IBS' e/ou 'CBS' = aliquota
    efetiva ficticia do Simples (pIBSSN/pCBSSN). A esfera que nao vier nao gera o subgrupo
    (gIBSSN e 0-1). O valor (vIBSSN/vCBSSN) e calculado sobre vProd + frete + seguro + outras -
    desconto so para ter um numero coerente: o gabarito confere apenas a soma dos itens x total.
    cativsn: prod/cAtivSN (NT 2026.005, I17d)."""
    it = dict(vProd=D(vprod), vFrete=D(frete), vSeg=D(seg), vDesc=D(desc), vOutro=D(outro),
              crt=crt, cst=cst, cClassTrib=cclass, ncm=ncm, mono=mono, sem_gibscbs=sem_gibscbs)
    if cativsn:
        it['cAtivSN'] = cativsn
    it['sn'] = None
    if sn:
        receita = it['vProd'] + it['vFrete'] + it['vSeg'] + it['vOutro'] - it['vDesc']
        it['sn'] = {k: (D(p), r2(receita * D(p) / 100)) for k, p in sn.items()}
    bc_icms = it['vProd'] + it['vFrete'] + it['vSeg'] + it['vOutro'] - it['vDesc']
    if crt == 3:
        it['vBCICMS'] = bc_icms
        it['pICMS'] = D(picms)
        it['vICMS'] = r2(bc_icms * it['pICMS'] / 100)
        bc_pis = bc_icms - it['vICMS']
        it['vBCPIS'] = bc_pis
        it['pPIS'] = D(ppis)
        it['vPIS'] = r2(bc_pis * it['pPIS'] / 100)
        it['pCOFINS'] = D(pcofins)
        it['vCOFINS'] = r2(bc_pis * it['pCOFINS'] / 100)
    else:
        it['vICMS'] = it['vPIS'] = it['vCOFINS'] = D('0')
    it['pIPI'] = D(pipi) if pipi else None
    it['vIPI'] = r2(bc_icms * it['pIPI'] / 100) if pipi else D('0')
    base = bc_icms - it['vICMS'] - it['vPIS'] - it['vCOFINS']
    it['vBC'] = base if base_modo == 'lei' else it['vProd']
    a = dict(UF=D('0.1000'), Mun=D('0.0000'), CBS=D('0.9000'))
    if aliq:
        a.update({k: D(v) for k, v in aliq.items()})
    it['p'] = a
    it['red'] = None
    if red:
        it['red'] = {k: D(v) for k, v in red.items()}   # pRedAliq por esfera
    it['pDif'] = D(pdif) if pdif else None
    calcular_ibscbs(it)
    return it


def calcular_ibscbs(it):
    it['ef'] = {}
    it['v'] = {}
    it['vDif'] = {}
    for esf in ('UF', 'Mun', 'CBS'):
        p = it['p'][esf]
        ef = p
        if it['red'] is not None:
            ef = r4(p * (1 - it['red'][esf] / 100))
        it['ef'][esf] = ef
        bruto = it['vBC'] * ef / 100
        vdif = r2(bruto * it['pDif'] / 100) if it['pDif'] is not None else D('0')
        it['vDif'][esf] = vdif
        it['v'][esf] = r2(bruto - vdif)
    it['vIBS'] = it['v']['UF'] + it['v']['Mun']


def vibs_xml(it):
    """vIBS gravado: o informado de proposito ou vIBSUF + vIBSMun do proprio XML."""
    if 'xvIBS' in it:
        return it['xvIBS']
    return f2(num(it, 'vIBSUF') + num(it, 'vIBSMun'))


def xml_item(n, it, mod):
    o = []
    o.append('<det nItem="%d"><prod><cProd>9%02d</cProd><cEAN>SEM GTIN</cEAN>' % (n, n))
    o.append('<xProd>ITEM SINTETICO %d - SEM VALOR FISCAL</xProd><NCM>%s</NCM>' % (n, it['ncm']))
    o.append('<CFOP>5102</CFOP><uCom>UN</uCom><qCom>1.0000</qCom><vUnCom>%s00000000</vUnCom>' % f2(it['vProd']))
    o.append('<vProd>%s</vProd><cEANTrib>SEM GTIN</cEANTrib><uTrib>UN</uTrib><qTrib>1.0000</qTrib>' % f2(it['vProd']))
    o.append('<vUnTrib>%s00000000</vUnTrib>' % f2(it['vProd']))
    for t in ('vFrete', 'vSeg', 'vDesc', 'vOutro'):
        if it[t]:
            o.append('<%s>%s</%s>' % (t, f2(it[t]), t))
    o.append('<indTot>1</indTot>')
    if it.get('cAtivSN'):
        o.append('<cAtivSN>%s</cAtivSN>' % it['cAtivSN'])
    o.append('</prod><imposto>')
    if it['crt'] == 3:
        o.append('<ICMS><ICMS00><orig>0</orig><CST>00</CST><modBC>3</modBC><vBC>%s</vBC>'
                 '<pICMS>%s</pICMS><vICMS>%s</vICMS></ICMS00></ICMS>'
                 % (f2(it['vBCICMS']), f4(it['pICMS']), f2(it['vICMS'])))
    else:
        o.append('<ICMS><ICMSSN102><orig>0</orig><CSOSN>102</CSOSN></ICMSSN102></ICMS>')
    if it['pIPI'] is not None and mod == '55':
        o.append('<IPI><cEnq>999</cEnq><IPITrib><CST>50</CST><vBC>%s</vBC><pIPI>%s</pIPI>'
                 '<vIPI>%s</vIPI></IPITrib></IPI>' % (f2(it['vBCICMS']), f4(it['pIPI']), f2(it['vIPI'])))
    if it['crt'] == 3:
        o.append('<PIS><PISAliq><CST>01</CST><vBC>%s</vBC><pPIS>%s</pPIS><vPIS>%s</vPIS></PISAliq></PIS>'
                 % (f2(it['vBCPIS']), f4(it['pPIS']), f2(it['vPIS'])))
        o.append('<COFINS><COFINSAliq><CST>01</CST><vBC>%s</vBC><pCOFINS>%s</pCOFINS><vCOFINS>%s'
                 '</vCOFINS></COFINSAliq></COFINS>' % (f2(it['vBCPIS']), f4(it['pCOFINS']), f2(it['vCOFINS'])))
    else:
        o.append('<PIS><PISOutr><CST>99</CST><vBC>0.00</vBC><pPIS>0.0000</pPIS><vPIS>0.00</vPIS></PISOutr></PIS>')
        o.append('<COFINS><COFINSOutr><CST>99</CST><vBC>0.00</vBC><pCOFINS>0.0000</pCOFINS>'
                 '<vCOFINS>0.00</vCOFINS></COFINSOutr></COFINS>')
    o.append('<IBSCBS><CST>%s</CST><cClassTrib>%s</cClassTrib>' % (it['cst'], it['cClassTrib']))
    if it['mono']:
        o.append('<gIBSCBSMono><gIBSMonoAdRem><gMonoRet><vIBSMonoRet>1.20</vIBSMonoRet></gMonoRet>'
                 '</gIBSMonoAdRem><gCBSMonoAdRem><gMonoRet><vCBSMonoRet>10.80</vCBSMonoRet></gMonoRet>'
                 '</gCBSMonoAdRem><vTotIBSMonoItem>0.00</vTotIBSMonoItem><vTotCBSMonoItem>0.00'
                 '</vTotCBSMonoItem></gIBSCBSMono>')
    elif not it['sem_gibscbs']:
        o.append('<gIBSCBS><vBC>%s</vBC>' % it.get('xvBC', f2(it['vBC'])))
        for esf, grp, tp, tv in (('UF', 'gIBSUF', 'pIBSUF', 'vIBSUF'), ('Mun', 'gIBSMun', 'pIBSMun', 'vIBSMun'),
                                 ('CBS', 'gCBS', 'pCBS', 'vCBS')):
            if esf == 'CBS':
                o.append('<vIBS>%s</vIBS>' % vibs_xml(it))
            o.append('<%s><%s>%s</%s>' % (grp, tp, it.get('x' + tp, f4(it['p'][esf])), tp))
            if it['pDif'] is not None:
                o.append('<gDif><pDif>%s</pDif><vDif>%s</vDif></gDif>' % (f4(it['pDif']), f2(it['vDif'][esf])))
            if it['red'] is not None or it.get('xgRed_' + esf):
                pr = it['red'][esf] if it['red'] is not None else D(it['xgRed_' + esf][0])
                pe = it['ef'][esf] if it['red'] is not None else D(it['xgRed_' + esf][1])
                o.append('<gRed><pRedAliq>%s</pRedAliq><pAliqEfet>%s</pAliqEfet></gRed>'
                         % (it.get('xpRedAliq_' + esf, f4(pr)), it.get('xpAliqEfet_' + esf, f4(pe))))
            o.append('<%s>%s</%s></%s>' % (tv, it.get('x' + tv, f2(it['v'][esf])), tv, grp))
        o.append('</gIBSCBS>')
    if it['sn']:
        # NT 2026.005 UB115a (pai UB12): depois do grupo de escolha gIBSCBS/gIBSCBSMono/...
        o.append('<gTribSN>')
        for esf in ('IBS', 'CBS'):
            if esf in it['sn']:
                p, v = it['sn'][esf]
                o.append('<g%sSN><p%sSN>%s</p%sSN><v%sSN>%s</v%sSN></g%sSN>'
                         % (esf, esf, f4(p), esf, esf, it.get('xv%sSN' % esf, f2(v)), esf, esf))
        o.append('</gTribSN>')
    o.append('</IBSCBS></imposto></det>')
    return ''.join(o)


def num_sn(it, esf):
    """vIBSSN/vCBSSN gravado no item (0 quando o item nao tem o subgrupo)."""
    if not it['sn'] or esf not in it['sn']:
        return D('0')
    return D(it.get('xv%sSN' % esf, f2(it['sn'][esf][1])))


def num(it, campo):
    """Valor efetivamente gravado no XML (com o erro de proposito, se houver)."""
    if campo == 'vIBS' and not (it['mono'] or it['sem_gibscbs']):
        return D(vibs_xml(it))
    mapa = {'vBC': 'xvBC', 'vIBSUF': 'xvIBSUF', 'vIBSMun': 'xvIBSMun', 'vCBS': 'xvCBS'}
    if campo in mapa and mapa[campo] in it:
        return D(it[mapa[campo]])
    if campo == 'vBC':
        return D('0') if (it['mono'] or it['sem_gibscbs']) else r2(it['vBC'])
    if it['mono'] or it['sem_gibscbs']:
        return D('0')
    return {'vIBSUF': it['v']['UF'], 'vIBSMun': it['v']['Mun'], 'vCBS': it['v']['CBS'],
            'vIBS': it['vIBS']}[campo]


def xml_total(itens, mod, tot_over, sem_tot=False, so_vbc=False, sem_gIBS=False, tot_sn='auto'):
    """tot_sn: 'auto' = IBSCBSTot/gTribSN quando algum item tem gTribSN; 'sem' = nunca;
    'forca' = sempre (W59h-20). tot_over aceita tambem 'vIBSSN' e 'vCBSSN'."""
    s = lambda k: sum((it[k] for it in itens), D('0'))
    vprod, vfrete, vseg, vdesc, voutro = s('vProd'), s('vFrete'), s('vSeg'), s('vDesc'), s('vOutro')
    vicms, vpis, vcofins, vipi = s('vICMS'), s('vPIS'), s('vCOFINS'), s('vIPI')
    vbc_icms = sum((it.get('vBCICMS', D('0')) for it in itens), D('0'))
    vnf = vprod - vdesc + vfrete + vseg + voutro + vipi
    o = ['<total><ICMSTot><vBC>%s</vBC><vICMS>%s</vICMS><vICMSDeson>0.00</vICMSDeson><vFCP>0.00</vFCP>'
         '<vBCST>0.00</vBCST><vST>0.00</vST><vFCPST>0.00</vFCPST><vFCPSTRet>0.00</vFCPSTRet>'
         '<vProd>%s</vProd><vFrete>%s</vFrete><vSeg>%s</vSeg><vDesc>%s</vDesc><vII>0.00</vII>'
         '<vIPI>%s</vIPI><vIPIDevol>0.00</vIPIDevol><vPIS>%s</vPIS><vCOFINS>%s</vCOFINS>'
         '<vOutro>%s</vOutro><vNF>%s</vNF></ICMSTot>'
         % tuple(f2(x) for x in (vbc_icms, vicms, vprod, vfrete, vseg, vdesc, vipi, vpis, vcofins, voutro, vnf))]
    if not sem_tot:
        t = dict(vBCIBSCBS=sum((num(it, 'vBC') for it in itens), D('0')),
                 vIBSUF=sum((num(it, 'vIBSUF') for it in itens), D('0')),
                 vIBSMun=sum((num(it, 'vIBSMun') for it in itens), D('0')),
                 vIBS=sum((num(it, 'vIBS') for it in itens), D('0')),
                 vCBS=sum((num(it, 'vCBS') for it in itens), D('0')))
        dif = {e: sum((it['vDif'][e] for it in itens if not (it['mono'] or it['sem_gibscbs'])), D('0'))
               for e in ('UF', 'Mun', 'CBS')}
        t.update({k: D(v) for k, v in tot_over.items() if k not in ('vIBSSN', 'vCBSSN')})
        o.append('<IBSCBSTot><vBCIBSCBS>%s</vBCIBSCBS>' % f2(t['vBCIBSCBS']))
        if not so_vbc:
            if not sem_gIBS:
                o.append('<gIBS><gIBSUF><vDif>%s</vDif><vDevTrib>0.00</vDevTrib><vIBSUF>%s</vIBSUF></gIBSUF>'
                         '<gIBSMun><vDif>%s</vDif><vDevTrib>0.00</vDevTrib><vIBSMun>%s</vIBSMun></gIBSMun>'
                         '<vIBS>%s</vIBS><vCredPres>0.00</vCredPres><vCredPresCondSus>0.00</vCredPresCondSus>'
                         '</gIBS>' % (f2(dif['UF']), f2(t['vIBSUF']), f2(dif['Mun']), f2(t['vIBSMun']), f2(t['vIBS'])))
            o.append('<gCBS><vDif>%s</vDif><vDevTrib>0.00</vDevTrib><vCBS>%s</vCBS><vCredPres>0.00</vCredPres>'
                     '<vCredPresCondSus>0.00</vCredPresCondSus></gCBS>' % (f2(dif['CBS']), f2(t['vCBS'])))
            if any(it['mono'] for it in itens):
                o.append('<gMono><vIBSMono>0.00</vIBSMono><vCBSMono>0.00</vCBSMono><vIBSMonoReten>0.00'
                         '</vIBSMonoReten><vCBSMonoReten>0.00</vCBSMonoReten><vIBSMonoRet>1.20</vIBSMonoRet>'
                         '<vCBSMonoRet>10.80</vCBSMonoRet></gMono>')
        tem_sn = any(it['sn'] for it in itens)
        if tot_sn == 'forca' or (tot_sn == 'auto' and tem_sn):
            sn = {e: sum((num_sn(it, e) for it in itens), D('0')) for e in ('IBS', 'CBS')}
            sn.update({k[1:4]: D(v) for k, v in tot_over.items() if k in ('vIBSSN', 'vCBSSN')})
            o.append('<gTribSN><vIBSSN>%s</vIBSSN><vCBSSN>%s</vCBSSN></gTribSN>' % (f2(sn['IBS']), f2(sn['CBS'])))
        o.append('</IBSCBSTot>')
    o.append('<vNFTot>%s</vNFTot></total>' % f2(vnf))
    return ''.join(o), vnf


def xml_nota(mod, nnf, itens, dia='15', fin='1', crt=3, cstat='100', com_prot=True, tot_over=None,
             sem_tot=False, so_vbc=False, sem_gIBS=False, refnfe=None, mes='10', tp_regime=None,
             tot_sn='auto'):
    ch = chave(mod, nnf, '26' + mes)
    tpimp = '4' if mod == '65' else '1'
    tot, vnf = xml_total(itens, mod, tot_over or {}, sem_tot, so_vbc, sem_gIBS, tot_sn)
    o = ['<?xml version="1.0" encoding="UTF-8"?><nfeProc versao="4.00" xmlns="http://www.portalfiscal.inf.br/nfe">',
         '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe Id="NFe%s" versao="4.00"><ide><cUF>31</cUF>' % ch,
         '<cNF>%08d</cNF><natOp>VENDA - DOCUMENTO SINTETICO</natOp><mod>%s</mod><serie>1</serie>' % (nnf % 100000000, mod),
         '<nNF>%d</nNF><dhEmi>2026-%s-%sT10:00:00-03:00</dhEmi>' % (nnf, mes, dia)]
    if mod == '55':
        o.append('<dhSaiEnt>2026-%s-%sT10:00:00-03:00</dhSaiEnt>' % (mes, dia))
    o.append('<tpNF>1</tpNF><idDest>1</idDest><cMunFG>3106200</cMunFG><tpImp>%s</tpImp><tpEmis>1</tpEmis>'
             '<cDV>%s</cDV><tpAmb>2</tpAmb><finNFe>%s</finNFe><indFinal>1</indFinal><indPres>1</indPres>'
             '<indIntermed>0</indIntermed><procEmi>0</procEmi><verProc>SINTETICO-7.1</verProc>' % (tpimp, ch[-1], fin))
    if refnfe:
        o.append('<NFref><refNFe>%s</refNFe></NFref>' % refnfe)
    o.append('</ide><emit><CNPJ>%s</CNPJ><xNome>EMPRESA FICTICIA LTDA</xNome><xFant>EMPRESA FICTICIA</xFant>'
             '<enderEmit><xLgr>RUA FICTICIA</xLgr><nro>100</nro><xBairro>CENTRO</xBairro><cMun>3106200</cMun>'
             '<xMun>Belo Horizonte</xMun><UF>MG</UF><CEP>30000000</CEP><cPais>1058</cPais><xPais>BRASIL</xPais>'
             '</enderEmit><IE>0000000000000</IE><CRT>%d</CRT>' % (CNPJ, crt))
    if tp_regime:
        o.append('<tpRegimeIBSCBS>%s</tpRegimeIBSCBS>' % tp_regime)   # NT 2026.005 C21a
    o.append('</emit>')
    o.append('<dest><CPF>%s</CPF><xNome>NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome>' % CPF)
    if mod == '55':
        o.append('<enderDest><xLgr>RUA FICTICIA</xLgr><nro>100</nro><xBairro>CENTRO</xBairro><cMun>3106200</cMun>'
                 '<xMun>Belo Horizonte</xMun><UF>MG</UF><CEP>30000000</CEP><cPais>1058</cPais><xPais>BRASIL'
                 '</xPais></enderDest>')
    o.append('<indIEDest>9</indIEDest></dest>')
    for i, it in enumerate(itens, 1):
        o.append(xml_item(i, it, mod))
    o.append(tot)
    o.append('<transp><modFrete>9</modFrete></transp><pag><detPag><tPag>01</tPag><vPag>%s</vPag></detPag></pag>' % f2(vnf))
    o.append('<infAdic><infCpl>DOCUMENTO SINTETICO PARA TESTES DA CONFERENCIA IBS/CBS - SEM VALOR FISCAL</infCpl>'
             '</infAdic></infNFe>')
    if mod == '65':
        o.append('<infNFeSupl><qrCode>https://exemplo.invalido/qrcode?p=%s|2|2|1|0</qrCode>'
                 '<urlChave>https://exemplo.invalido/consulta</urlChave></infNFeSupl>' % ch)
    o.append('<Signature xmlns="http://www.w3.org/2000/09/xmldsig#"><SignedInfo><CanonicalizationMethod '
             'Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></CanonicalizationMethod><SignatureMethod '
             'Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></SignatureMethod><Reference URI="#NFe%s">'
             '<Transforms><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></Transform>'
             '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></Transform></Transforms>'
             '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></DigestMethod><DigestValue>'
             'AAAAAAAAAAAAAAAAAAAAAAAAAAA=</DigestValue></Reference></SignedInfo><SignatureValue>'
             'AAAAAAAAAAAAAAAAAAAAAAAAAAA=</SignatureValue><KeyInfo><X509Data><X509Certificate>'
             'AAAAAAAAAAAAAAAAAAAAAAAAAAA=</X509Certificate></X509Data></KeyInfo></Signature></NFe>' % ch)
    if com_prot:
        o.append('<protNFe versao="4.00"><infProt><tpAmb>2</tpAmb><verAplic>SINTETICO</verAplic><chNFe>%s</chNFe>'
                 '<dhRecbto>2026-%s-%sT10:00:05-03:00</dhRecbto><nProt>13126%010d</nProt><digVal>'
                 'AAAAAAAAAAAAAAAAAAAAAAAAAAA=</digVal><cStat>%s</cStat><xMotivo>%s</xMotivo></infProt></protNFe>'
                 % (ch, mes, dia, nnf, cstat, 'Autorizado o uso da NF-e' if cstat == '100' else 'Denegado o uso da NF-e'))
    o.append('</nfeProc>')
    return ch, ''.join(o)


# ---------------------------------------------------------------- casos
RED60 = dict(UF='60', Mun='60', CBS='60')


def casos():
    I = novo_item
    L = []

    def add(mod, nnf, itens, desc, **kw):
        L.append((mod, nnf, itens, desc, kw))

    # ------------------------- NF-e (55) -------------------------
    it = I('25.00', picms='0', ppis='0', pcofins='0'); it['xvIBSUF'] = '0.02'
    add('55', 910001, [I('100.00', frete='10.00', desc='5.00', outro='2.50'), it, I('15.00')],
        'correta, 3 itens, frete/desconto/outras; item 2: vBC 25,00 x 0,1% = 0,025 gravado 0,02 (dentro da tolerancia)')
    add('55', 910002, [I('200.00', desc='10.00', cclass='200034', cst='200', red=RED60, ncm='04070000'),
                       I('80.00', frete='5.00')],
        'correta, item 1 com reducao de 60% (cClassTrib 200034), item 2 integral')
    it = I('300.00', frete='20.00'); it['xvIBSUF'] = '0.50'
    add('55', 910003, [it, I('40.00')], 'N1: vIBSUF do item 1 errado')
    it = I('300.00', desc='15.00'); it['xvCBS'] = '3.00'
    add('55', 910004, [I('40.00'), it], 'N1: vCBS do item 2 errado')
    it = I('120.00'); it['xvIBS'] = '0.20'
    add('55', 910005, [it], 'N1: vIBS diferente de vIBSUF + vIBSMun')
    it = I('500.00', cclass='200035', cst='200', red=RED60, ncm='34011190')
    it['xvCBS'] = f2(r2(it['vBC'] * D('0.9') / 100))
    add('55', 910006, [it], 'N1: reducao 60%, vCBS calculado com pCBS cheio (ignora pAliqEfet)')
    it = I('500.00', cclass='200035', cst='200', red=RED60, ncm='34011190')
    it['xpAliqEfet_CBS'] = '0.5000'; it['xvCBS'] = f2(r2(it['vBC'] * D('0.5') / 100))
    add('55', 910007, [it], 'N1: pAliqEfet da CBS incoerente com pCBS x (1 - pRedAliq) (vCBS coerente com ela)')
    add('55', 910008, [I('60.00'), I('90.00')], 'N2: total vBCIBSCBS diferente da soma dos itens',
        tot_over={'vBCIBSCBS': '150.00'})
    add('55', 910009, [I('1000.00'), I('500.00')], 'N2: total vIBSUF e vCBS diferentes da soma dos itens',
        tot_over={'vIBSUF': '1.50', 'vCBS': '12.00'})
    add('55', 910010, [I('250.00')], 'N2: itens com IBSCBS e nota sem IBSCBSTot', sem_tot=True)
    add('55', 910011, [I('800.00')], 'N2: IBSCBSTot sem gIBS com itens com vIBSUF > 0', sem_gIBS=True)
    add('55', 910012, [I('400.00', frete='30.00', desc='20.00', outro='10.00', base_modo='vprod'),
                       I('100.00')],
        'N3: item 1 com vBC = vProd (ignora frete, outras, desconto e ICMS/PIS/COFINS); contas e totais coerentes')
    add('55', 910013, [I('1000.00', desc='50.00', pipi='10', base_modo='vprod')],
        'N3: vBC = vProd com IPI no item (base esperada exclui ICMS/PIS/COFINS e nao soma IPI)')
    add('55', 910014, [I('200.00', aliq={'UF': '0.05'})], 'N4: pIBSUF 0,05% em 2026 (esperado 0,10%)')
    add('55', 910015, [I('200.00', aliq={'CBS': '0.80'})], 'N4: pCBS 0,80% em 2026 (esperado 0,90%)')
    add('55', 910016, [I('300.00', cclass='200034', cst='200', red=dict(UF='40', Mun='40', CBS='40'),
                         ncm='04070000')],
        'N4: cClassTrib 200034 (reducao 60%) com pRedAliq 40%; contas coerentes com 40%')
    it = I('300.00')
    it['xgRed_UF'] = ('60', '0.0400'); it['xvIBSUF'] = f2(r2(it['vBC'] * D('0.04') / 100))
    add('55', 910017, [it], 'N4: CST 000 com gRed 60% no IBS UF (CST nao permite reducao); vIBSUF coerente com o gRed')
    add('55', 910018, [I('300.00', cclass='200034', cst='200', ncm='04070000')],
        'N4: cClassTrib 200034 exige reducao e o item nao tem gRed (aliquotas cheias)')
    add('55', 910019, [I('150.00', cclass='200034', cst='000')],
        'N4: cClassTrib 200034 informado com CST 000 (cClassTrib de outro CST)')
    add('55', 910020, [I('100.00', cst='620', cclass='620006', mono=True, ncm='27101259'), I('50.00')],
        'sem conferencia: item 1 monofasico (CST 620); item 2 correto')
    add('55', 910021, [I('1000.00', cst='510', cclass='510001', pdif='100', ncm='27160000')],
        'correta com diferimento 100% (CST 510): vIBSUF = vBC x p - vDif = 0')
    add('55', 910022, [I('200.00', aliq={'UF': '0.05'})], 'devolucao (finNFe 4) com pIBSUF 0,05%: N4 nao confere',
        fin='4', refnfe=chave('55', 910001))
    add('55', 910023, [I('90.00', cst='410', cclass='410999', sem_gibscbs=True), I('10.00')],
        'correta: item 1 imune (CST 410, sem gIBSCBS), item 2 integral')
    add('55', 910024, [I('70.00', crt=1, frete='5.00', desc='3.00', base_modo='vprod')],
        'N3 como nas reais 10432-10435: Simples Nacional (CSOSN 102), vBC = vProd', crt=1)
    it = I('500.00', cclass='200035', cst='200', red=RED60, ncm='34011190'); it['xvIBSUF'] = '0.00'
    add('55', 910025, [it], 'denegada (cStat 110) com erro de N1: fica fora da conferencia', cstat='110')

    # ------------------------- NFC-e (65) -------------------------
    add('65', 910030, [I('49.90', desc='4.90'), I('12.35'), I('7.00')], 'NFC-e correta, 3 itens com desconto')
    it = I('89.90'); it['xvIBSUF'] = '0.20'
    add('65', 910031, [it, I('10.00')], 'NFC-e N1: vIBSUF do item 1 errado')
    add('65', 910032, [I('150.00'), I('75.00')], 'NFC-e N2: total vCBS diferente da soma', tot_over={'vCBS': '2.50'})
    add('65', 910033, [I('59.90', desc='5.00', base_modo='vprod')], 'NFC-e N3: vBC = vProd (ignora desconto e tributos)')
    add('65', 910034, [I('120.00', aliq={'Mun': '0.05'})], 'NFC-e N4: pIBSMun 0,05% em 2026 (esperado 0%)')
    add('65', 910035, [I('35.00', cclass='200035', cst='200', red=RED60, ncm='34011190'), I('20.00')],
        'NFC-e correta com reducao 60% (cClassTrib 200035) e 2 itens')
    add('65', 910036, [I('0.50', crt=1)], 'NFC-e correta com IBSCBSTot so com vBCIBSCBS (valores zerados)', so_vbc=True, crt=1)
    it = I('99.00'); it['xvCBS'] = '5.00'
    add('65', 910037, [it], 'NFC-e sem protocolo (nao autorizada) com erro: fica fora da conferencia', com_prot=False)

    # ------------- D17: Simples Nacional, NT 2026.005 (gTribSN), emissao a partir de 16/11/2026 -------------
    # Aliquotas do Simples ficticias (o gabarito nao confere pIBSSN/pCBSSN). CRT 1 sem tpRegimeIBSCBS:
    # sem gIBSCBS e com gTribSN (tabela 2.3 da NT). CRT 3 com tpRegimeIBSCBS 2 ou 3: gIBSCBS e gTribSN.
    SN = dict(IBS='0.4000', CBS='1.6000')
    SN1 = dict(crt=1, sem_gibscbs=True, sn=SN, cativsn='01')
    N11 = dict(mes='11', crt=1)
    add('55', 910040, [I('180.00', frete='12.00', desc='6.00', **SN1), I('45.50', **SN1)],
        'D17 correta: CRT 1 sem regime regular, 2 itens so com gTribSN, soma = IBSCBSTot/gTribSN',
        dia='16', **N11)
    add('55', 910041, [I('230.00', **SN1), I('70.00', **SN1)],
        'D17 N2-vIBSSN: total vIBSSN diferente da soma dos itens', dia='16', tot_over={'vIBSSN': '1.50'}, **N11)
    add('55', 910042, [I('333.33', **SN1)],
        'D17 N2-vCBSSN: total vCBSSN 1 centavo acima da soma (tolerancia zero no nivel 2)', dia='17',
        tot_over={'vCBSSN': '5.34'}, **N11)
    add('55', 910043, [I('150.00', **SN1)],
        'D17 N2-gTribSN (W59h-10): item com gTribSN e IBSCBSTot sem gTribSN', dia='17', tot_sn='sem', **N11)
    add('55', 910044, [I('120.00')],
        'D17 N2-gTribSN (W59h-20): CRT 3, nenhum item com gTribSN e IBSCBSTot com gTribSN (zerado)',
        mes='11', dia='18', tot_sn='forca')
    add('55', 910045, [I('400.00', frete='20.00', sn=SN, cativsn='01'), I('60.00', sn=SN, cativsn='01')],
        'D17 correta: CRT 3 com tpRegimeIBSCBS 2 (opcao pendente pelo SN), gIBSCBS e gTribSN nos 2 itens',
        mes='11', dia='18', tp_regime='2')
    add('55', 910046, [I('250.00', sn=dict(CBS='1.6000'), cativsn='01')],
        'D17 correta: CRT 3 com tpRegimeIBSCBS 3, gTribSN so com gCBSSN (gIBSSN ausente vale 0; total vIBSSN 0,00)',
        mes='11', dia='19', tp_regime='3')
    add('55', 910047, [I('90.00', **SN1)],
        'D17 item com gTribSN e nota sem IBSCBSTot: so N2-IBSCBSTot', dia='19', sem_tot=True, **N11)
    add('65', 910050, [I('39.90', desc='2.00', **SN1), I('15.10', **SN1)],
        'D17 NFC-e correta: CRT 1, 2 itens so com gTribSN, IBSCBSTot com vBCIBSCBS 0,00 e gTribSN',
        dia='16', so_vbc=True, **N11)
    add('65', 910051, [I('80.00', **SN1), I('25.00', **SN1)],
        'D17 NFC-e N2-vIBSSN: total vIBSSN diferente da soma', dia='16', so_vbc=True,
        tot_over={'vIBSSN': '0.40'}, **N11)
    add('65', 910052, [I('64.90', **SN1)],
        'D17 NFC-e N2-vCBSSN: total vCBSSN diferente da soma', dia='17', so_vbc=True,
        tot_over={'vCBSSN': '1.00'}, **N11)
    add('65', 910053, [I('22.00', **SN1)],
        'D17 NFC-e N2-gTribSN (W59h-10): item com gTribSN e IBSCBSTot sem gTribSN', dia='17', so_vbc=True,
        tot_sn='sem', **N11)

    # ------------- B4: Erro e Alerta na mesma nota (dica 16.7 com o complemento da 16.6) -------------
    it1 = I('300.00'); it1['xvIBSUF'] = '0.90'
    add('55', 910060, [it1, I('200.00', aliq={'CBS': '0.80'}),
                       I('150.00', frete='8.00', desc='3.00', base_modo='vprod')],
        'Erro e Alerta: item 1 N1 (vIBSUF errado), item 2 N4 (pCBS 0,80%), item 3 N3 (vBC = vProd); '
        'totais coerentes com os itens', dia='20')
    return L


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(1)
    pasta = sys.argv[1]
    os.makedirs(pasta, exist_ok=True)
    for mod, nnf, itens, desc, kw in casos():
        ch, xml = xml_nota(mod, nnf, itens, **kw)
        with open(os.path.join(pasta, ch + '-nfe.xml'), 'w', encoding='utf-8', newline='') as f:
            f.write(xml)
        print(mod, nnf, ch[-6:], '-', desc)


if __name__ == '__main__':
    main()
