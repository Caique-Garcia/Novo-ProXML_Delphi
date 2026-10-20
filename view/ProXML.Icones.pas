unit ProXML.Icones;

{ Ícones SVG da interface (Plano 4, etapa 4.3).

  Cópia dos arquivos de docs/ui/icones (Lucide 1.59.0, licença ISC; ver docs/ui/icones.md
  e LICENSE-lucide.txt), sem comentários e sem espaços, para não depender de arquivo solto
  ao lado do executável. O traço usa "currentColor": a cor vem do Svg.OverrideColor (TSkSvg)
  ou do texto do TProBotao, sempre com as cores de ProXML.Tema.
  Ícone novo: copiar o SVG de docs/ui/icones e registrar o uso em docs/ui/icones.md. }

interface

const
  //folder.svg: campo da pasta
  IconePasta =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.' +
    '93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"/></svg>';

  //folder-open.svg: botão Selecionar…
  IconePastaAberta =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="m6 14 1.5-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.54 6a2 2 0 0 1-1.95 1.5' +
    'H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H18a2 2 0 0 ' +
    '1 2 2v2"/></svg>';

  //play.svg: botão Processar
  IconeProcessar =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M5 5a2 2 0 0 1 3.008-1.728l11.997 6.998a2 2 0 0 1 .003 3.458l-12 7A2 2 0 0 1 5 1' +
    '9z"/></svg>';

  //info.svg: Sobre (cabeçalho)
  IconeInfo =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>';

  //banknote.svg: card Valor Total
  IconeValorTotal =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="' +
    'M6 12h.01M18 12h.01"/></svg>';

  //layers.svg: card Base ICMS
  IconeBaseICMS =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 ' +
    '0l8.58-3.9a1 1 0 0 0 0-1.83z"/><path d="M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8' +
    '.58-3.9A1 1 0 0 0 22 12"/><path d="M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3' +
    '.9A1 1 0 0 0 22 17"/></svg>';

  //percent.svg: card ICMS
  IconeICMS =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><line x1="19" x2="5" y1="5" y2="19"/><circle cx="6.5" cy="6.5" r="2.5"/><circle cx="17.5"' +
    ' cy="17.5" r="2.5"/></svg>';

  //map.svg: card IBS (estadual + municipal)
  IconeIBS =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M14.106 5.553a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619v12.764a1 1 0 0 1-.' +
    '553.894l-4.553 2.277a2 2 0 0 1-1.788 0l-4.212-2.106a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 ' +
    '1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0z"/><path d="M15 5.764v1' +
    '5"/><path d="M9 3.236v15"/></svg>';

  //landmark.svg: card CBS (federal)
  IconeCBS =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M10 18v-7"/><path d="M11.119 2.205a2 2 0 0 1 1.762 0l7.84 3.846A.5.5 0 0 1 20.5 ' +
    '7h-17a.5.5 0 0 1-.22-.949z"/><path d="M14 18v-7"/><path d="M18 18v-7"/><path d="M3 22h18"/' +
    '><path d="M6 18v-7"/></svg>';

  //triangle-alert.svg: faixa de aviso
  IconeAviso =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path' +
    ' d="M12 9v4"/><path d="M12 17h.01"/></svg>';

implementation

end.
