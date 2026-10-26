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

  //info.svg: Sobre (cabeçalho), dicas visíveis da tela Relatórios e faixa informativa (tela Enviar)
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

  //send.svg: menu Enviar e botão Enviar
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

  //check.svg: aviso flutuante "Chave copiada" (tela Notas) e "Configurações salvas"
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

  //circle-check.svg: sucesso (contador Autorizadas, linha do log do Resumo e faixas de sucesso)
  IconeSucesso =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'circle cx="12" cy="12" r="10"/><path d="m16 9-5.5 5.5L8 12"/></svg>';

  //circle-x.svg: erro (contador Com erro, linha do log do Resumo e faixas de erro)
  IconeErro =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'circle cx="12" cy="12" r="10"/><path d="m15 9-6 6"/><path d="m9 9 6 6"/></svg>';

  //clock.svg: tempo do processamento (4º contador do Resumo)
  IconeTempo =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>';

  //loader-circle.svg: botão ocupado ("Enviando…", "Testando…"), estático
  IconeOcupado =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>';

  //paperclip.svg: quadro do anexo da tela Enviar
  IconeAnexo =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="m16 6-8.414 8.586a2 2 0 0 0 2.829 2.829l8.414-8.586a4 4 0 1 0-5.657-5.657l-8.379 8.' +
    '551a6 6 0 1 0 8.485 8.485l8.379-8.551"/></svg>';

  //mail.svg: campos de e-mail (Para, na tela Enviar, e E-mail (usuário), em Configurações)
  IconeEmail =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"/><rect x="2" y="4" width="20" height="16" ' +
    'rx="2"/></svg>';

  //circle-alert.svg: mensagem de erro abaixo do campo (14 px)
  IconeErroCampo =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.0' +
    '1" y1="16" y2="16"/></svg>';

  //eye.svg: mostrar a senha (Configurações)
  IconeMostrarSenha =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10' +
    '.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/></svg>';

  //eye-off.svg: ocultar a senha (Configurações)
  IconeOcultarSenha =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1' +
    '-1.444 2.49"/><path d="M14.084 14.158a3 3 0 0 1-4.242-4.242"/><path d="M17.479 17.499a10.75' +
    ' 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143"/><path d="m2 2 20' +
    ' 20"/></svg>';

  //plug-zap.svg: botão Testar conexão (Configurações)
  IconeTestarConexao =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="M6.3 20.3a2.4 2.4 0 0 0 3.4 0L12 18l-6-6-2.3 2.3a2.4 2.4 0 0 0 0 3.4Z"/><path d="m2' +
    ' 22 3-3"/><path d="M7.5 13.5 10 11"/><path d="M10.5 16.5 13 14"/><path d="m18 3-4 4h6l-4 4"' +
    '/></svg>';

  //save.svg: botão Salvar (Configurações)
  IconeSalvar =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5' +
    'a2 2 0 0 1 2-2z"/><path d="M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7"/><path d="M7 3v4a1 1 ' +
    '0 0 0 1 1h7"/></svg>';

  //external-link.svg: link do GitHub (tela Sobre)
  IconeLinkExterno =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="no' +
    'ne" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><' +
    'path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V' +
    '8a2 2 0 0 1 2-2h6"/></svg>';

  //Logo vetorial para fundo claro (docs/ui/logo/proxml-logo-claro.svg, sem o comentário e sem
  //espaços entre as tags): cabeçalho dos relatórios impressos (etapa 4.8, decisão D7 revista).
  //As cores são as do próprio logo aprovado, não do tema. Mudou o arquivo? Copiar de novo aqui
  LogoClaro =
    '<svg xmlns="http://www.w3.org/2000/svg" width="157" height="32" viewBox="0 0 157 32"><titl' +
    'e>ProXML (para fundo claro)</title><g><circle cx="13" cy="3" r="1.25" fill="#B4BACA"/><cir' +
    'cle cx="18.5" cy="3" r="1.25" fill="#B4BACA"/><circle cx="8.25" cy="7.75" r="1.55" fill="#' +
    '8E97AE"/><circle cx="13" cy="7.75" r="1.8" fill="#55688F"/><circle cx="18.5" cy="7.75" r="' +
    '1.8" fill="#55688F"/><circle cx="23.25" cy="7.75" r="1.55" fill="#8E97AE"/><circle cx="3.5' +
    '" cy="12.75" r="1.25" fill="#B4BACA"/><circle cx="8.25" cy="12.75" r="1.8" fill="#55688F"/' +
    '><circle cx="13" cy="12.75" r="2.1" fill="#2F4A66"/><circle cx="18.5" cy="12.75" r="2.1" f' +
    'ill="#2F4A66"/><circle cx="23.25" cy="12.75" r="1.8" fill="#55688F"/><circle cx="28" cy="1' +
    '2.75" r="1.25" fill="#B4BACA"/><circle cx="3.5" cy="18.25" r="1.25" fill="#B4BACA"/><circl' +
    'e cx="8.25" cy="18.25" r="1.8" fill="#55688F"/><circle cx="13" cy="18.25" r="2.1" fill="#2' +
    'F4A66"/><circle cx="18.5" cy="18.25" r="2.1" fill="#2F4A66"/><circle cx="23.25" cy="18.25"' +
    ' r="1.8" fill="#55688F"/><circle cx="28" cy="18.25" r="1.25" fill="#B4BACA"/><circle cx="8' +
    '.25" cy="23.25" r="1.55" fill="#8E97AE"/><circle cx="13" cy="23.25" r="1.8" fill="#55688F"' +
    '/><circle cx="18.5" cy="23.25" r="1.8" fill="#55688F"/><circle cx="23.25" cy="23.25" r="1.' +
    '55" fill="#8E97AE"/><circle cx="13" cy="28" r="1.25" fill="#B4BACA"/><circle cx="18.5" cy=' +
    '"28" r="1.25" fill="#B4BACA"/></g><path d="M35 25V8.2A2.2 2.2 0 0 1 37.2 6H46A4 4 0 0 1 50' +
    ' 10V14A4 4 0 0 1 46 18H35M55 25V11.8M55 15.6C55.4 13.3 57.4 12.3 60 12.3H62.4M91 5.6L106.2' +
    ' 25M106.4 5.6L91 25M112 25V11.2A5.75 5.75 0 0 1 123.5 11.2V25M123.5 11.2A5.75 5.75 0 0 1 1' +
    '35 11.2V25M140 5.6V22A3 3 0 0 0 143 25H153.2" fill="none" stroke="#171A21" stroke-width="2' +
    '.5" stroke-linecap="round" stroke-linejoin="round"/><ellipse cx="72" cy="18.6" rx="6.7" ry' +
    '="6.4" fill="none" stroke="#171A21" stroke-width="2.5"/></svg>';

implementation

end.
