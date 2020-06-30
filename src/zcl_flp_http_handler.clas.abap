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
    DATA week TYPE scal-week.
    CALL METHOD super->if_http_extension~handle_request
      EXPORTING
        server = server.

    CALL FUNCTION 'DATE_GET_WEEK'
      EXPORTING
        date = sy-datum
      IMPORTING
        week = week.

    DATA(response) = server->response->get_cdata( ).

    DATA(add) =
    `<script>` &&
    `if ('serviceWorker' in navigator) {` &&
    `  window.addEventListener('load', function() {` &&
    |    navigator.serviceWorker.register(`/sap/zsw?${ week }2`);| &&
    `  })` &&
    `}` &&
    `</script>` &&
    `</head>`.

    REPLACE '</head>' IN response WITH add.

    server->response->set_cdata( response ).
  ENDMETHOD.
ENDCLASS.
