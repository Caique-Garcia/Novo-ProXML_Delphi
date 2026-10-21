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

  //info.svg: Sobre (cabeçalho) e dicas visíveis da tela Relatórios
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

  //map.svg: card IBS (estadual + municipal) e Relatório IBS/CBS (tela Relatórios)
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

  //layout-dashboard.svg: menu Resumo
  IconeResumo =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx=' +
    '"1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="1' +
    '6" rx="1"/></svg>';

  //file-text.svg: menu Notas; na tela Relatórios, Relatório de Notas e indicador do filtro
  IconeNotas =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.' +
    '4 0 0 1 20 8v12a2 2 0 0 1-2 2z"/><path d="M14 2v5a1 1 0 0 0 1 1h5"/><path d="M10 9H8"/><pa' +
    'th d="M16 13H8"/><path d="M16 17H8"/></svg>';

  //printer.svg: menu Relatórios e botões "Gerar relatório"
  IconeRelatorios =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><pa' +
    'th d="M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6"/><rect x="6" y="14" width="12" height="8" r' +
    'x="1"/></svg>';

  //send.svg: menu Enviar
  IconeEnviar =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M14.536 21.686a.5.5 0 0 0 .937-.024l6.5-19a.496.496 0 0 0-.635-.635l-19 6.5a.5.5' +
    ' 0 0 0-.024.937l7.93 3.18a2 2 0 0 1 1.112 1.11z"/><path d="m21.854 2.147-10.94 10.939"/></' +
    'svg>';

  //settings.svg: menu Configurações
  IconeConfiguracoes =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M9.671 4.136a2.34 2.34 0 0 1 4.659 0 2.34 2.34 0 0 0 3.319 1.915 2.34 2.34 0 0 1' +
    ' 2.33 4.033 2.34 2.34 0 0 0 0 3.831 2.34 2.34 0 0 1-2.33 4.033 2.34 2.34 0 0 0-3.319 1.915' +
    ' 2.34 2.34 0 0 1-4.659 0 2.34 2.34 0 0 0-3.32-1.915 2.34 2.34 0 0 1-2.33-4.033 2.34 2.34 0' +
    ' 0 0 0-3.831A2.34 2.34 0 0 1 6.35 6.051a2.34 2.34 0 0 0 3.319-1.915"/><circle cx="12" cy="' +
    '12" r="3"/></svg>';

  //triangle-alert.svg: faixa de aviso, contador Ignoradas e linha de aviso do log do Resumo
  IconeAviso =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path' +
    ' d="M12 9v4"/><path d="M12 17h.01"/></svg>';

  //copy.svg: botão Copiar chave (tela Notas)
  IconeCopiar =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><rect width="14" height="14" x="8" y="8" rx="2" ry="2"/><path d="M4 16c-1.1 0-2-.9-2-2V4c0' +
    '-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"/></svg>';

  //file-down.svg: botão Gerar DANFE (tela Notas)
  IconeGerarDanfe =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.' +
    '4 0 0 1 20 8v12a2 2 0 0 1-2 2z"/><path d="M14 2v5a1 1 0 0 0 1 1h5"/><path d="M12 18v-6"/><' +
    'path d="m9 15 3 3 3-3"/></svg>';

  //sheet.svg: botão Exportar CSV (tela Notas)
  IconeExportarCSV =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><rect width="18" height="18" x="3" y="3" rx="2" ry="2"/><line x1="3" x2="21" y1="9" y2="9' +
    '"/><line x1="3" x2="21" y1="15" y2="15"/><line x1="9" x2="9" y1="9" y2="21"/><line x1="15"' +
    ' x2="15" y1="9" y2="21"/></svg>';

  //search.svg: campo Buscar (tela Notas)
  IconeBuscar =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="m21 21-4.34-4.34"/><circle cx="11" cy="11" r="8"/></svg>';

  //search-x.svg: busca sem resultado (tela Notas)
  IconeBuscaVazia =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="m13.5 8.5-5 5"/><path d="m8.5 8.5 5 5"/><circle cx="11" cy="11" r="8"/><path d="' +
    'm21 21-4.3-4.3"/></svg>';

  //inbox.svg: grade vazia (tela Notas)
  IconeGradeVazia =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11 2 12v6a2 2 0 0 ' +
    '0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/></svg>';

  //x.svg: botão Limpar busca (tela Notas) e Cancelar (leitura dos XMLs no Resumo)
  IconeLimpar =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>';

  //check.svg: aviso flutuante "Chave copiada" (tela Notas)
  IconeConfirmar =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="n' +
    'one" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"' +
    '><path d="M20 6 9 17l-5-5"/></svg>';

  //folder-input.svg: estado vazio do Resumo (arrastar a pasta para a janela)
  IconePastaEntrada =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="M2 9V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2' +
    'v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-1"/><path d="M2 13h10"/><path d="m9 16 3-3-3-3"/></svg>';

  //circle-check.svg: sucesso (contador Autorizadas e linha do log do Resumo)
  IconeSucesso =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'circle cx="12" cy="12" r="10"/><path d="m16 9-5.5 5.5L8 12"/></svg>';

  //circle-x.svg: erro (contador Com erro e linha do log do Resumo)
  IconeErro =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'circle cx="12" cy="12" r="10"/><path d="m15 9-6 6"/><path d="m9 9 6 6"/></svg>';

  //clock.svg: tempo do processamento (4º contador do Resumo)
  IconeTempo =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>';

  //loader-circle.svg: botão ocupado ("Enviando…"), estático
  IconeOcupado =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>';

implementation

end.
