"""Gera o JSON-LD FAQPage das páginas do site a partir das perguntas visíveis.

Uso (na raiz do repositório):
    python -I docs/site/gerar_faq.py site/reforma-tributaria.html site/perguntas-frequentes.html

O que faz:
- Lê cada página e pega cada pergunta no formato
      <details id="..."><summary><h3>Pergunta</h3></summary><div class="resposta">Resposta</div></details>
- Monta um bloco <script type="application/ld+json"> com @type FAQPage, com o texto da pergunta e
  da resposta iguais aos visíveis. Na resposta ficam só as tags aceitas pelo Google (p, ul, ol, li,
  a, strong, em, br); as outras tags (ex.: code, kbd) são retiradas e o texto delas fica. Comentários
  HTML são ignorados. Links relativos viram absolutos com base no <link rel="canonical"> da página.
- Substitui o bloco FAQPage que já existe na página ou, se não houver, insere antes de </head>.
- Para com erro se a mesma pergunta aparecer em duas das páginas informadas (cada pergunta só pode
  ser marcada em uma página).

Rode de novo sempre que mudar o texto de uma pergunta ou resposta. Só usa a biblioteca padrão.
"""
import json
import re
import sys
from pathlib import Path

PERMITIDAS = {"p", "ul", "ol", "li", "a", "strong", "em", "br"}
RE_PERGUNTA = re.compile(
    r'<details id="([^"]+)"[^>]*>\s*<summary><h3>(.*?)</h3></summary>\s*'
    r'<div class="resposta">(.*?)</div>\s*</details>', re.S)
RE_FAQ = re.compile(r'<script type="application/ld\+json">\n(?:(?!</script>).)*?"@type": "FAQPage".*?</script>\n', re.S)


def absoluto(href, canonical):
    base = re.match(r"https?://[^/]+", canonical).group(0)
    if href.startswith("#"):
        return canonical + href
    if href.startswith("/"):
        return base + href
    return href


def limpar_resposta(html, canonical):
    html = re.sub(r"<!--.*?-->", "", html, flags=re.S)

    def tag(m):
        fecha, nome, attrs = m.group(1), m.group(2).lower(), m.group(3)
        if nome not in PERMITIDAS:
            return ""
        if nome == "a" and not fecha:
            href = re.search(r'href="([^"]*)"', attrs).group(1)
            return f'<a href="{absoluto(href, canonical)}">'
        return f"<{fecha}{nome}>"

    html = re.sub(r"<(/?)([a-zA-Z0-9]+)([^>]*)>", tag, html)
    html = re.sub(r"\s+", " ", html).strip()
    return re.sub(r">\s+<", "><", html)


def texto(html):
    import html as h
    return re.sub(r"\s+", " ", h.unescape(re.sub(r"<[^>]+>", "", html))).strip()


def gerar(caminho):
    pagina = caminho.read_text(encoding="utf-8")
    canonical = re.search(r'<link rel="canonical" href="([^"]+)">', pagina).group(1)
    itens = []
    for m in RE_PERGUNTA.finditer(pagina):
        itens.append({
            "@type": "Question",
            "name": texto(m.group(2)),
            "acceptedAnswer": {"@type": "Answer", "text": limpar_resposta(m.group(3), canonical)},
        })
    if not itens:
        sys.exit(f"{caminho}: nenhuma pergunta encontrada")
    faq = {"@context": "https://schema.org", "@type": "FAQPage", "mainEntity": itens}
    bloco = ('<script type="application/ld+json">\n'
             + json.dumps(faq, ensure_ascii=False, indent=2).replace("</", "<\\/")
             + "\n</script>\n")
    if RE_FAQ.search(pagina):
        pagina = RE_FAQ.sub(lambda _: bloco, pagina, count=1)
    else:
        pagina = pagina.replace("</head>", bloco + "</head>", 1)
    caminho.write_text(pagina, encoding="utf-8", newline="\n")
    return [i["name"] for i in itens]


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    vistas = {}
    for arg in sys.argv[1:]:
        caminho = Path(arg)
        nomes = gerar(caminho)
        for n in nomes:
            if n in vistas:
                sys.exit(f"Pergunta repetida em {vistas[n]} e {caminho}: {n}")
            vistas[n] = caminho
        print(f"{caminho}: FAQPage com {len(nomes)} perguntas")


if __name__ == "__main__":
    main()
