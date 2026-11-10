/* ProXML · site estático
   1. Links de download (a[data-so-windows]):
      - no celular ou tablet: em vez de baixar, mostra o aviso de que o ProXML é só para Windows;
      - no computador: o download segue normal e aparece, abaixo do botão, como passar pelo SmartScreen.
   2. Prints (figure.print a.print-link): abrem num visualizador sobre a página, com Fechar, Esc e toque no fundo.
   Aprimoramento progressivo: sem JavaScript (ou sem <dialog>), os links baixam direto e os prints abrem
   a imagem sozinha, como antes. Ao mudar este arquivo, troque o ?v= do link nas páginas (cache longo no vercel.json). */
(function () {
  "use strict";

  var LINK = "https://proxml.vercel.app/download";
  var temDialog = typeof HTMLDialogElement === "function";

  // Clique comum (botão principal, sem Ctrl/Cmd/Shift/Alt): os outros abrem em nova aba/janela, sem interceptar.
  function cliqueSimples(e) {
    return e.button === 0 && !e.ctrlKey && !e.metaKey && !e.shiftKey && !e.altKey && !e.defaultPrevented;
  }

  // Fecha só com toque no fundo escurecido: o pointerdown e o click precisam cair no fundo.
  // Assim, tocar no conteúdo ou arrastar uma seleção para fora não fecha.
  function fecharNoFundo(dialogo, ehFundo) {
    var alvoPointerdown = null;
    dialogo.addEventListener("pointerdown", function (e) { alvoPointerdown = e.target; });
    dialogo.addEventListener("click", function (e) {
      var noFundo = ehFundo(e.target) && ehFundo(alvoPointerdown);
      alvoPointerdown = null;
      if (noFundo) dialogo.close();
    });
  }

  function devolverFoco(el) {
    if (el && typeof el.focus === "function") {
      try { el.focus({ preventScroll: true }); } catch (erro) { el.focus(); }
    }
  }

  function ehCelularOuTablet() {
    var uad = navigator.userAgentData;
    if (uad && uad.mobile === true) return true;
    var ua = navigator.userAgent || "";
    if (/Android|iPhone|iPad|iPod/i.test(ua)) return true;
    // iPadOS se apresenta como Mac; o Mac de verdade não tem tela de toque.
    if (navigator.platform === "MacIntel" && navigator.maxTouchPoints > 1) return true;
    return false;
  }

  /* ---------- 1. Downloads ---------- */

  // Computador: não impede o download; só mostra a mensagem logo abaixo do botão (ou do link, no texto).
  function avisoDepoisDoDownload() {
    var timer = null;
    document.addEventListener("click", function (e) {
      var link = e.target.closest && e.target.closest("a[data-so-windows]");
      if (!link) return;
      var lugar = link.closest(".botoes") || link.closest("li") || link.parentNode;
      var msg = lugar.classList.contains("botoes") ? lugar.nextElementSibling : lugar.querySelector(".aviso-download");
      if (!msg || !msg.classList.contains("aviso-download")) {
        msg = document.createElement("p");
        msg.className = "aviso-download";
        msg.setAttribute("role", "status");
        if (lugar.classList.contains("botoes")) lugar.parentNode.insertBefore(msg, lugar.nextSibling);
        else lugar.appendChild(msg);
      }
      msg.textContent = "";
      // A região de status já existe na página quando o texto entra: assim o leitor de tela anuncia.
      // Um timer só: cliques seguidos não anunciam duas vezes.
      window.clearTimeout(timer);
      timer = window.setTimeout(function () {
        msg.innerHTML = "O download deve começar em instantes. Se o navegador ou o Windows mostrar um aviso, " +
          '<a href="/download#smartscreen">veja como continuar</a>.';
      }, 100);
    });
  }

  // Celular ou tablet: aviso "O ProXML é um programa para Windows" no lugar do download.
  function avisoNoCelular() {
    var assunto = "Baixar o ProXML no computador";
    var corpo = "Abra este link no computador com Windows para baixar o ProXML:\r\n" + LINK;
    var mailto = "mailto:?subject=" + encodeURIComponent(assunto) + "&body=" + encodeURIComponent(corpo);

    var dialogo = document.createElement("dialog");
    dialogo.className = "aviso-windows";
    dialogo.setAttribute("aria-labelledby", "aviso-windows-titulo");
    dialogo.setAttribute("aria-describedby", "aviso-windows-texto");
    dialogo.innerHTML =
      '<div class="aviso-windows-corpo">' +
      '<h2 id="aviso-windows-titulo">O ProXML é um programa para Windows</h2>' +
      '<div id="aviso-windows-texto">' +
      "<p>Ele não roda no celular nem no tablet. Abra o link abaixo num computador com Windows 10 ou 11.</p>" +
      "<p>Para não esquecer, guarde o link ou mande para o seu e-mail:</p>" +
      "</div>" +
      '<p class="aviso-windows-link"><code>' + LINK.replace("https://", "") + "</code></p>" +
      '<div class="botoes">' +
      '<button type="button" class="botao botao-primario" data-acao="copiar">Copiar link</button>' +
      '<a class="botao botao-secundario" href="' + mailto + '">Enviar por e-mail</a>' +
      '<button type="button" class="botao botao-secundario" data-acao="fechar">Fechar</button>' +
      "</div>" +
      '<p class="aviso-windows-status" role="status" aria-live="polite"></p>' +
      "</div>";
    document.body.appendChild(dialogo);

    var status = dialogo.querySelector(".aviso-windows-status");
    var origem = null;

    function avisar(texto) {
      status.textContent = "";
      // Pequena pausa para o leitor de tela anunciar de novo se a mensagem se repetir.
      window.setTimeout(function () { status.textContent = texto; }, 50);
    }

    function copiarAntigo() {
      var campo = document.createElement("textarea");
      campo.value = LINK;
      campo.setAttribute("readonly", "");
      campo.style.position = "fixed";
      campo.style.opacity = "0";
      dialogo.appendChild(campo);
      campo.select();
      var ok = false;
      try { ok = document.execCommand("copy"); } catch (erro) { ok = false; }
      dialogo.removeChild(campo);
      return ok;
    }

    function copiar() {
      var falhou = function () {
        avisar(copiarAntigo() ? "Link copiado." : "Não deu para copiar. Anote o endereço acima.");
      };
      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(LINK).then(function () { avisar("Link copiado."); }, falhou);
      } else {
        falhou();
      }
    }

    // O conteúdo fica todo no .aviso-windows-corpo: o fundo é só o próprio <dialog>.
    fecharNoFundo(dialogo, function (alvo) { return alvo === dialogo; });

    dialogo.addEventListener("click", function (e) {
      var botao = e.target.closest("[data-acao]");
      if (!botao) return;
      if (botao.getAttribute("data-acao") === "copiar") copiar();
      else dialogo.close();
    });

    dialogo.addEventListener("close", function () {
      status.textContent = "";
      devolverFoco(origem);
      origem = null;
    });

    document.addEventListener("click", function (e) {
      var link = e.target.closest && e.target.closest("a[data-so-windows]");
      if (!link) return;
      e.preventDefault();
      origem = link;
      dialogo.showModal();
    });
  }

  if (document.querySelector("a[data-so-windows]")) {
    if (!ehCelularOuTablet()) avisoDepoisDoDownload();
    else if (temDialog) avisoNoCelular();
  }

  /* ---------- 2. Visualizador de prints ---------- */

  function visualizador() {
    var dialogo = document.createElement("dialog");
    dialogo.className = "visualizador";
    dialogo.setAttribute("aria-label", "Imagem ampliada");
    dialogo.innerHTML =
      '<button type="button" class="botao botao-primario visualizador-fechar">Fechar</button>' +
      '<div class="visualizador-area">' +
      '<p class="visualizador-status" role="status"></p>' +
      '<img class="visualizador-img" alt="" hidden>' +
      "</div>";
    document.body.appendChild(dialogo);

    var area = dialogo.querySelector(".visualizador-area");
    var img = dialogo.querySelector(".visualizador-img");
    var status = dialogo.querySelector(".visualizador-status");
    var fechar = dialogo.querySelector(".visualizador-fechar");
    var origem = null;

    fecharNoFundo(dialogo, function (alvo) { return alvo === dialogo || alvo === area; });
    fechar.addEventListener("click", function () { dialogo.close(); });

    img.addEventListener("load", function () {
      // Print alto (ex.: DANFE retrato): largura inteira e rolagem, para dar para ler.
      img.classList.toggle("visualizador-img-alta", img.naturalHeight > img.naturalWidth * 1.2);
      status.textContent = "";
      img.hidden = false;
    });
    img.addEventListener("error", function () {
      if (!img.getAttribute("src")) return;
      status.innerHTML = 'Não deu para carregar a imagem. <a href="' + img.getAttribute("src") + '">Abrir a imagem</a>.';
    });

    dialogo.addEventListener("close", function () {
      img.hidden = true;
      img.removeAttribute("src");
      img.alt = "";
      status.textContent = "";
      devolverFoco(origem);
      origem = null;
    });

    document.addEventListener("click", function (e) {
      var link = e.target.closest && e.target.closest("figure.print a.print-link");
      if (!link || !cliqueSimples(e)) return;
      e.preventDefault();
      origem = link;
      var original = link.querySelector("img");
      img.hidden = true;
      img.alt = original ? original.alt : "";
      status.textContent = "Carregando a imagem…";
      dialogo.scrollTop = 0;
      dialogo.showModal();
      fechar.focus();
      // A imagem inteira só é baixada agora, no clique.
      img.src = link.getAttribute("href");
    });
  }

  if (temDialog && document.querySelector("figure.print a.print-link")) visualizador();
})();
