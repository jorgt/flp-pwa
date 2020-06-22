class ZCL_FLP_HTTP_HANDLER definition
  public
  inheriting from /UI2/CL_FLP_HTTP_HANDLER
  create public .

public section.

  methods IF_HTTP_EXTENSION~HANDLE_REQUEST
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FLP_HTTP_HANDLER IMPLEMENTATION.


  METHOD if_http_extension~handle_request.
    CALL METHOD super->if_http_extension~handle_request
      EXPORTING
        server = server.

    DATA(response) = server->response->get_cdata( ).

    DATA(add) =
    `<script>` &&
    ` const week = date => {` &&
    `   date = date || new Date();` &&
    `   date.setHours(0, 0, 0, 0);` &&
    `   date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);` &&
    `   var week1 = new Date(date.getFullYear(), 0, 4);` &&
    `   return 1 + Math.round(((date.getTime() - week1.getTime()) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7);` &&
    ` };` &&
    ` ` &&
    ` const weekYear = date => {` &&
    `   date = date || new Date();` &&
    `   date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);` &&
    `   return date.getFullYear();` &&
    ` };` &&
    `if ('serviceWorker' in navigator) {` &&
    `  window.addEventListener('load', function() {` &&
    '    navigator.serviceWorker.register(`/sap/zsw?${week(new Date())}${weekYear(new Date())}`);' &&
    `  })` &&
    `}` &&
    `</script>` &&
    `</head>`.

    REPLACE '</head>' IN response WITH add.

    server->response->set_cdata( response ).
  ENDMETHOD.
ENDCLASS.
