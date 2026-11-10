/* ProXML · site estático
   Links de download (a[data-so-windows]):
   - no celular ou tablet: em vez de baixar, mostra o aviso de que o ProXML é só para Windows;
   - no computador: o download segue normal e aparece, abaixo do botão, como passar pelo SmartScreen.
   Aprimoramento progressivo: sem JavaScript (ou sem <dialog>), os links baixam direto, como antes. Ao mudar este arquivo, troque o ?v= do link nas páginas (cache longo no vercel.json). */
(function () {
  "use strict";

  var LINK = "https://proxml.vercel.app/download";

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

  function ehCelularOuTablet() {
    var uad = navigator.userAgentData;
    if (uad && uad.mobile === true) return true;
    var ua = navigator.userAgent || "";
    if (/Android|iPhone|iPad|iPod/i.test(ua)) return true;
    // iPadOS se apresenta como Mac; o Mac de verdade não tem tela de toque.
    if (navigator.platform === "MacIntel" && navigator.maxTouchPoints > 1) return true;
    return false;
  }

  if (!ehCelularOuTablet()) {
    avisoDepoisDoDownload();
    return;
  }
  if (typeof HTMLDialogElement !== "function") return;

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
    try { ok = document.execCommand("copy"); } catch (e) { ok = false; }
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

  // Fecha só com toque no fundo escurecido: o pointerdown e o click precisam cair no próprio <dialog>
  // (o conteúdo fica todo no .aviso-windows-corpo). Assim, arrastar uma seleção para fora não fecha.
  var alvoPointerdown = null;
  dialogo.addEventListener("pointerdown", function (e) { alvoPointerdown = e.target; });

  dialogo.addEventListener("click", function (e) {
    var noFundo = e.target === dialogo && alvoPointerdown === dialogo;
    alvoPointerdown = null;
    if (noFundo) { dialogo.close(); return; }
    var botao = e.target.closest("[data-acao]");
    if (!botao) return;
    if (botao.getAttribute("data-acao") === "copiar") copiar();
    else dialogo.close();
  });

  dialogo.addEventListener("close", function () {
    status.textContent = "";
    if (origem && typeof origem.focus === "function") origem.focus();
    origem = null;
  });

  document.addEventListener("click", function (e) {
    var link = e.target.closest && e.target.closest("a[data-so-windows]");
    if (!link) return;
    e.preventDefault();
    origem = link;
    dialogo.showModal();
  });
})();
