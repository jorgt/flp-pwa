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
    DATA(n) = CL_ABAP_CHAR_UTILITIES=>NEWLINE.
    DATA(s) = '/sap/opu/odata/sap/SEPMRA_PO_APV/'.
    SELECT SINGLE cache_bust_token FROM /ui5/appidx WHERE bsp_appl_name = 'ZTEST_APPR_PO' INTO @DATA(cache).

    DATA(p) = |'/sap/bc/ui5_ui5/sap/ztest_appr_po/{ cache }/Component-preload.js'|.
    p = |{ p }, "{ s }$metadata?sap-client=001&sap-language=EN"|.
    p = |{ p }, "{ s }PurchaseOrders?sap-client=001&$skip=0&$top=100&$orderby=ChangedAt desc,POId asc&$select=POId%2cOrderedByName%2cSupplierName%2cGrossAmount%2cCurrencyCode%2cChangedAt%2cItemCount&$inlinecount=allpages"|.
    p = |{ p }, "{ s }PurchaseOrders('300000038')?sap-client=001&$select=POId%2cOrderedByName%2cSupplierName%2cGrossAmount%2cCurrencyCode%2cChangedAt%2cDeliveryDateEarliest%2cLaterDelivDateExist%2cDeliveryAddress%2cItemCount"|.
    p = |{ p }, "{ s }PurchaseOrders('300000038')/PurchaseOrderItems?sap-client=001&$skip=0&$top=100&$select=POId%2cPOItemPos%2cProduct%2cPrice%2cPriceCurrency%2cGrossAmount%2cGrossAmountCurrency%2cQuantity%2cDeliveryDate&$inlinecount=allpages"|.

    server->response->set_header_field(
      name  = 'Service-Worker-Allowed'
      value = '/' ).

    server->response->set_header_field( name = 'Content-Type' value = 'application/x-javascript; charset=UTF-8' ).
    server->response->set_cdata(
`(function () {` && n &&
`  'use strict';` && n &&
`` && n &&
`  const offlineFirst = async (event, cache) => {` && n &&
`` && n &&
`    const cacheResponse = await cache.match(event.request);` && n &&
`` && n &&
`    if (cacheResponse) console.log('[SW OFFLINE FIRST: FETCHED FROM CACHE]', event.request.url);` && n &&
`    if (cacheResponse) return cacheResponse;` && n &&
`` && n &&
`    const onlineResponse = await fetch(event.request);` && n &&
`    cache.put(event.request, onlineResponse.clone());` && n &&
`` && n &&
`    return onlineResponse;` && n &&
`  };` && n &&
`` && n &&
`  const onlineFirst = async (event, cache) => {` && n &&
`    let response;` && n &&
`` && n &&
`    try {` && n &&
`      response = await fetch(event.request);` && n &&
`      if (response) console.log('[SW ONLINE FIRST: FETCHED FROM SOURCE]', event.request.url);` && n &&
`      if (response) cache.put(event.request, response.clone());` && n &&
`    } catch (e) {` && n &&
`      response = await cache.match(event.request);` && n &&
`      if (response) console.log('[SW ONLINE FIRST: FETCHED FROM CACHE]', event.request.url);` && n &&
`    }` && n &&
`` && n &&
`    return response;` && n &&
`  };` && n &&
`` && n &&
`  const DATA_CACHE_NAME = 'launchpad-data';` && n &&
`  const APP_CACHE_NAME = 'launchpad-libraries';` && n &&
`  const applicationRegex = /(^\/sap\/bc\/ui5_ui5\/(.*)~([.a-z0-9]*)~(.*))/i;` && n &&
`  const toPrecache = [` && n &&
|    { p }| && n &&
`  ];` && n &&
`` && n &&
`  const getRequest = event => {` && n &&
`    const url = new URL(event.request.url);` && n &&
`    const cacheName = applicationRegex.test(url.pathname) ? APP_CACHE_NAME : DATA_CACHE_NAME;` && n &&
`    const cacheFunction = applicationRegex.test(url.pathname) ? offlineFirst : onlineFirst;` && n &&
`` && n &&
`    event.respondWith(` && n &&
`      caches` && n &&
`        .open(cacheName)` && n &&
`        .then(cache => cacheFunction(event, cache))` && n &&
`    );` && n &&
`  };` && n &&
`` && n &&
`  const install = event => {` && n &&
`    console.log('[SW INSTALL] Clearing caches');` && n &&
`    ` && n &&
`    event.waitUntil(` && n &&
`      caches.keys().then(list =>` && n &&
`        list` && n &&
`          .filter(l => [DATA_CACHE_NAME, APP_CACHE_NAME].indexOf(l) < 0)` && n &&
`          .forEach(l => caches.delete(l)))` && n &&
`    );` && n &&
`  };` && n &&
`` && n &&
`  const activate = event => {` && n &&
`    console.log('[SW ACTIVATE] Preloading files');` && n &&
`    event.waitUntil(` && n &&
`      caches` && n &&
`        .open(APP_CACHE_NAME)` && n &&
`        .then(cache => cache.addAll(toPrecache))` && n &&
`        .then(() => {` && n &&
`          self.skipWaiting();` && n &&
`        })` && n &&
`    );` && n &&
`  };` && n &&
`` && n &&
`  const fetchRequest = async event => {` && n &&
`    const url = new URL(event.request.url);` && n &&
`    if (!url.protocol.startsWith('http')) return;` && n &&
`    if (event.request.method !== 'GET') return;` && n &&
`    getRequest(event);` && n &&
`  };` && n &&
`` && n &&
`  self.addEventListener('activate', event => activate(event));` && n &&
`  self.addEventListener('install', event => install(event));` && n &&
`  self.addEventListener('fetch', async event => await fetchRequest(event));` && n &&
`` && n &&
`}());` && n &&
`` && n
    ).
ENDMETHOD.
ENDCLASS.
