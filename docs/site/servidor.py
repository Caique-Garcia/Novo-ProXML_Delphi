"""Servidor local para revisar o site como na Vercel.

Uso (na raiz do repositório):
    python -I docs/site/servidor.py site 8765
e abra http://127.0.0.1:8765/ no navegador. Ctrl+C encerra.

Imita o que o site/vercel.json configura na Vercel:
- cleanUrls: /tutorial serve tutorial.html, e /tutorial.html redireciona (308) para /tutorial;
- trailingSlash false: /tutorial/ redireciona (308) para /tutorial;
- página inexistente responde 404 com o 404.html;
- cabeçalhos "headers" do vercel.json (ex.: Cache-Control), para caminhos que batem com o "source".

Escuta só em 127.0.0.1. Só usa a biblioteca padrão.
"""
import functools
import http.server
import json
import os
import re
import sys


def padrao_para_regex(source):
    # Suporta os padrões usados no vercel.json: caminho literal e grupos regex como "(.*)".
    partes = re.split(r"(\([^)]*\))", source)
    return re.compile("^" + "".join(p if p.startswith("(") else re.escape(p) for p in partes) + "$")


class Handler(http.server.SimpleHTTPRequestHandler):
    raiz = "."
    regras = []

    def _redirecionar(self, destino):
        self.send_response(308)
        self.send_header("Location", destino)
        self.send_header("Content-Length", "0")
        self.end_headers()

    def end_headers(self):
        caminho = self.path.split("?")[0].split("#")[0]
        for regex, cabecalhos in self.regras:
            if regex.match(caminho):
                for c in cabecalhos:
                    self.send_header(c["key"], c["value"])
        super().end_headers()

    def send_head(self):
        caminho, _, consulta = self.path.partition("?")
        caminho = caminho.split("#")[0]
        sufixo = ("?" + consulta) if consulta else ""
        if caminho != "/" and caminho.endswith("/"):
            self._redirecionar(caminho.rstrip("/") + sufixo)
            return None
        if caminho.endswith(".html"):
            limpo = caminho[:-5]
            self._redirecionar(("/" if limpo in ("", "/index") else limpo) + sufixo)
            return None
        arquivo = os.path.join(self.raiz, caminho.lstrip("/"))
        if caminho != "/" and not os.path.isfile(arquivo):
            if os.path.isfile(arquivo + ".html"):
                self.path = caminho + ".html" + sufixo
            else:
                corpo = open(os.path.join(self.raiz, "404.html"), "rb").read()
                self.send_response(404)
                self.send_header("Content-Type", "text/html; charset=utf-8")
                self.send_header("Content-Length", str(len(corpo)))
                self.end_headers()
                self.wfile.write(corpo)
                return None
        return super().send_head()


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    raiz = os.path.abspath(sys.argv[1])
    porta = int(sys.argv[2])
    Handler.raiz = raiz
    config = os.path.join(raiz, "vercel.json")
    if os.path.isfile(config):
        with open(config, encoding="utf-8") as f:
            dados = json.load(f)
        Handler.regras = [(padrao_para_regex(r["source"]), r["headers"]) for r in dados.get("headers", [])]
    servidor = http.server.ThreadingHTTPServer(("127.0.0.1", porta), functools.partial(Handler, directory=raiz))
    print(f"Servindo {raiz} em http://127.0.0.1:{porta}/ (Ctrl+C encerra)")
    try:
        servidor.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
