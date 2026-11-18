import sys, os, re, json, glob
import xml.etree.ElementTree as ET
NS='{http://www.portalfiscal.inf.br/nfe}'
def f(e,p):
    x=e.find(p.replace('/', '/'+NS).replace('./','./') if False else None)
def find(e,path):
    cur=e
    for part in path.split('/'):
        if cur is None: return None
        cur=cur.find(NS+part)
    return cur
def txt(e,path,d=None):
    x=find(e,path); return x.text if x is not None and x.text is not None else d
out=[]
for pasta in sys.argv[1:]:
    for fn in sorted(glob.glob(os.path.join(pasta,'*.xml'))):
        try: r=ET.parse(fn).getroot()
        except Exception as ex: out.append({'erro':str(ex)}); continue
        inf=r.find('.//'+NS+'infNFe')
        if inf is None: out.append({'erro':'sem infNFe'}); continue
        prot=r.find('.//'+NS+'protNFe')
        cstat=txt(prot,'infProt/cStat') if prot is not None else None
        tot=find(inf,'total/ICMSTot'); ib=find(inf,'total/IBSCBSTot')
        sn=[d.get('nItem') for d in inf.findall(NS+'det') if d.find(NS+'imposto/'+NS+'IBSCBS/'+NS+'gTribSN') is not None and d.find(NS+'imposto/'+NS+'IBSCBS/'+NS+'gIBSCBS') is None]
        hasitem=any(d.find(NS+'imposto/'+NS+'IBSCBS') is not None for d in inf.findall(NS+'det'))
        out.append(dict(pasta=os.path.basename(os.path.normpath(pasta)), mod=txt(inf,'ide/mod'), nNF=txt(inf,'ide/nNF'),
          dhEmi=txt(inf,'ide/dhEmi','')[:10], tpAmb=txt(inf,'ide/tpAmb'), tpNF=txt(inf,'ide/tpNF'), finNFe=txt(inf,'ide/finNFe'), cStat=cstat,
          vNF=txt(tot,'vNF','0'), vBC=txt(tot,'vBC','0'), vICMS=txt(tot,'vICMS','0'),
          vBCIBSCBS=txt(ib,'vBCIBSCBS','0') if ib is not None else '0',
          vIBS=txt(ib,'gIBS/vIBS','0') if ib is not None else '0', vCBS=txt(ib,'gCBS/vCBS','0') if ib is not None else '0',
          temibs= (ib is not None) or hasitem, temtot=(ib is not None), nitens=len(inf.findall(NS+'det')), sn_itens=sn))
json.dump(out,open(os.path.join(os.path.dirname(__file__),'notas.json'),'w',encoding='utf-8'),ensure_ascii=False,indent=0)
for o in out: print(o.get('pasta'),o.get('mod'),o.get('nNF'),o.get('dhEmi'),o.get('tpAmb'),o.get('cStat'),o.get('vNF'),o.get('vIBS'),o.get('vCBS'),o.get('temibs'),o.get('erro',''))
