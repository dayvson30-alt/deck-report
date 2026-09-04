const CACHE = "deck-v2";
const ASSETS = ["./", "./index.html", "./manifest.webmanifest", "./icon-180.png", "./icon-512.png"];

// addAll passa pelo cache HTTP do navegador; aqui forcamos a rede
self.addEventListener("install", e => {
  e.waitUntil(
    caches.open(CACHE)
      .then(c => Promise.all(ASSETS.map(u =>
        fetch(u, { cache: "reload" })
          .then(r => (r && r.ok ? c.put(u, r) : null))
          .catch(() => null)
      )))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", e => {
  e.waitUntil(caches.keys()
    .then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});

self.addEventListener("message", e => {
  if (e.data === "skipWaiting") self.skipWaiting();
});

/* Rede primeiro, cache como rede de seguranca.
   Para a PROPRIA PAGINA passamos cache:"reload": o GitHub Pages manda
   Cache-Control: max-age=600, e o fetch normal recebia a versao velha
   do cache do navegador - no app da tela de inicio isso prendia numa
   versao antiga sem forma de sair. */
self.addEventListener("fetch", e => {
  if (e.request.method !== "GET") return;

  const isDoc = e.request.mode === "navigate" || e.request.destination === "document";
  const net = isDoc
    ? fetch(e.request.url, { cache: "reload", credentials: "same-origin" })
    : fetch(e.request);

  e.respondWith(
    net.then(r => {
      const copy = r.clone();
      caches.open(CACHE).then(c => c.put(e.request, copy)).catch(() => {});
      return r;
    })
    .catch(() => caches.match(e.request).then(r => r || caches.match("./index.html")))
  );
});
