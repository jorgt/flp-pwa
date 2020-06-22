class ZCL_PWA_SERVICE_WORKER definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PWA_SERVICE_WORKER IMPLEMENTATION.


  METHOD if_http_extension~handle_request.
    server->response->set_header_field(
      name  = 'Service-Worker-Allowed'
      value = '/' ).

    server->response->set_header_field( name = 'Content-Type' value = 'application/x-javascript; charset=UTF-8' ).
    server->response->set_cdata(
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const week = (date = new Date()) => {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  date.setHours(0, 0, 0, 0);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  var week1 = new Date(date.getFullYear(), 0, 4);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  return 1 + Math.round(((date.getTime() - week1.getTime()) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`};` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const weekYear = (date = new Date()) => {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  return date.getFullYear();` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`};` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const month = date => (date || new Date()).getMonth();` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const deleteCaches = event => {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  console.log('[SW MAINTENANCE]');` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  event.waitUntil(` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`    caches.keys().then(list =>` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`      list` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`        .filter(l => [DATA_CACHE_NAME, APP_CACHE_NAME].indexOf(l) < 0)` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`        .forEach(l => caches.delete(l)))` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  )` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`};` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const precache = event => {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  deleteCaches(event);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  const files = ['/sap/bc/ui5_ui5/sap/ztest_appr_po/~4760485A586159B175CBFEE234AFBF6F~C/Component-preload.js']` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  event.waitUntil(` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`    caches` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`      .open(APP_CACHE_NAME)` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`      .then(cache => cache.addAll(files))` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`      .then(() => {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`        self.skipWaiting();` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`      })` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  );` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`}` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const offlineFirst = async (event, cache) => {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  const cacheResponse = await cache.match(event.request);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  if (cacheResponse) console.log('[SW IN CACHE]', event.request.url);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  if (cacheResponse) return cacheResponse;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  const onlineResponse = await fetch(event.request);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  cache.put(event.request, onlineResponse.clone());` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  return onlineResponse;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`};` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const onlineFirst = async (event, cache) => {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  let response;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  try {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`    response = await fetch(event.request);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`    if (response) console.log('[SW FETCHED FROM SOURCE]', event.request.url);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`    if (response) cache.put(event.request, response.clone());` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  } catch (e) {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`    response = await cache.match(event.request);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`    if (response) console.log('[SW FETCHED FROM CACHE]', event.request.url);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  }` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  return response;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`};` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const DATA_CACHE_NAME = 'data' + week() + weekYear();` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const APP_CACHE_NAME = 'cache' + month();` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const TEST_CACHE_NAME = 'test'` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const applicationRegex = /(^\/sap\/bc\/ui5_ui5\/(.*)~([.a-z0-9]*)~(.*))/i;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`const fetchListener = async event => {` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  const url = new URL(event.request.url);` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  const cacheName = applicationRegex.test(url.pathname) ? APP_CACHE_NAME : DATA_CACHE_NAME;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  const cacheFunction = applicationRegex.test(url.pathname) ? offlineFirst : onlineFirst;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  if (event.request.method !== 'GET' || event.request.headers.has('range')) return;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  if (!url.protocol.startsWith('http')) return;` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  event.respondWith(` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`    caches` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`      .open(cacheName)` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`      .then(cache => cacheFunction(event, cache))` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`  )` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`};` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`self.addEventListener('activate', event => deleteCaches(event));` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`self.addEventListener('install', event => deleteCaches(event));` && CL_ABAP_CHAR_UTILITIES=>NEWLINE &&
`self.addEventListener('fetch', async event => await fetchListener(event));`
    ).
  ENDMETHOD.
ENDCLASS.
