/***************************************************************************
** Programa: gtupc/upc-re1001h1.p
** Vers∆o..: 1.00.00.000
** Obs.....: UPC usado para desabilitar e carregar os campos de documento e
             serie do re1001h1 quando ele for chamado pelo importador, para
             ue o usuario utilize as mesmas informaá‰es ja contidas no XML
** Autor...: Oliver Fagionato
***************************************************************************/

{include/i-prgvrs.i UPC-RE1001H1 2.00.00.000}

DEFINE INPUT PARAM p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAM p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAM p-row-table  AS ROWID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-serie-comp-re1001h1 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nro-comp-re1001h1   AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-i-chave-uf          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-chave-data        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-chave-cgc         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-chave-modelo      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-chave-serie       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-i-chave-nro-docto   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-i-chave-nr-nfe      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-i-chave-digito      AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR g-nro-docto   LIKE docum-est.nro-docto   NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-serie-docto LIKE docum-est.serie-docto NO-UNDO.
DEF NEW GLOBAL SHARED VAR g-chave-acesso  AS CHARACTER             NO-UNDO.

{INCLUDE/VER-HDLS.I &ATIVA-GERACAO-LISTA=NO
                    &TELA-DISCO='D'
                    &NOME-ARQUIVO='c:/tmp/zz.LST'
                    &LISTA-FRAMES=''
                    &LISTA-TIPOS-OBJS=''}
                    
IF p-ind-event = "AFTER-INITIALIZE" AND
   PROGRAM-NAME(3) MATCHES("*gati0102e*") THEN DO:

    ASSIGN wh-serie-comp-re1001h1 = fc-all-hdl("fpage0", "serie-comp", 000)
           wh-nro-comp-re1001h1   = fc-all-hdl("fpage0", "nro-comp", 000).
  
    ASSIGN wh-serie-comp-re1001h1:SENSITIVE = NO
           wh-nro-comp-re1001h1:SENSITIVE   = NO.

    ASSIGN wh-serie-comp-re1001h1:SCREEN-VALUE = STRING(g-serie-docto)
           wh-nro-comp-re1001h1:SCREEN-VALUE   = STRING(g-nro-docto).


    /* --- Colocando a Chave de Acesso na Tela ---*/
    run atrib_handle.
    assign wh-i-chave-uf:screen-value           = substr(g-chave-acesso,1,2)
           wh-c-chave-data:screen-value         = substr(g-chave-acesso,3,4)
           wh-c-chave-cgc:screen-value          = substr(g-chave-acesso,7,14)
           wh-c-chave-modelo:screen-value       = substr(g-chave-acesso,21,2)
           wh-c-chave-serie:screen-value        = substr(g-chave-acesso,23,3)
           wh-i-chave-nro-docto:screen-value    = substr(g-chave-acesso,26,9)
           wh-i-chave-nr-nfe:screen-value       = substr(g-chave-acesso,35,9)
           wh-i-chave-digito:screen-value       = substr(g-chave-acesso,44,2). 
END.

IF p-ind-event = "AFTER-DESTROY-INTERFACE" THEN DO:
    ASSIGN wh-serie-comp-re1001h1 = ?
           wh-nro-comp-re1001h1   = ?.

    assign wh-i-chave-uf           = ?
           wh-c-chave-data         = ?
           wh-c-chave-cgc          = ?
           wh-c-chave-modelo       = ?
           wh-c-chave-serie        = ?
           wh-i-chave-nro-docto    = ?
           wh-i-chave-nr-nfe       = ?
           wh-i-chave-digito       = ?.
END.


/* --------------------   PROCEDURES INTERNAS   ------------------------------ */
PROCEDURE atrib_handle:

    DEFINE VARIABLE wh-objeto AS WIDGET-HANDLE NO-UNDO.

    ASSIGN wh-objeto = ?.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FILL-IN ",
                  INPUT "i-chave-uf",
                  INPUT NO,
                  INPUT 1,
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-i-chave-uf = wh-objeto
               wh-objeto     = ?.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FILL-IN ",
                  INPUT "c-chave-data",
                  INPUT NO,
                  INPUT 1,
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-c-chave-data = wh-objeto
               wh-objeto       = ?.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FILL-IN ",
                  INPUT "c-chave-cgc",
                  INPUT NO,
                  INPUT 1,
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-c-chave-cgc = wh-objeto
               wh-objeto      = ?.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FILL-IN ",
                  INPUT "c-chave-modelo",
                  INPUT NO,
                  INPUT 1,
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-c-chave-modelo = wh-objeto
               wh-objeto         = ?.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FILL-IN ",
                  INPUT "c-chave-serie",
                  INPUT NO,
                  INPUT 1,
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-c-chave-serie = wh-objeto
               wh-objeto        = ?.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FILL-IN ",
                  INPUT "i-chave-nro-docto",
                  INPUT NO,
                  INPUT 1,
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-i-chave-nro-docto = wh-objeto
               wh-objeto            = ?.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FILL-IN ",
                  INPUT "i-chave-nr-nfe",
                  INPUT NO,
                  INPUT 1,
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-i-chave-nr-nfe = wh-objeto
               wh-objeto         = ?.

    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-event,
                  INPUT "FILL-IN ",
                  INPUT "i-chave-digito",
                  INPUT NO,
                  INPUT 1,
                  OUTPUT wh-objeto).
    IF VALID-HANDLE(wh-objeto) THEN
        ASSIGN wh-i-chave-digito = wh-objeto
               wh-objeto         = ?.

END PROCEDURE.

          
PROCEDURE tela-upc:

    Define INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    Define INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    Define INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    Define INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    Define INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    Define INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    Define OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.
    
    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):              
        
        IF pApresMsg = YES THEN
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP
                    "Type do Objeto" wgh-obj:TYPE SKIP
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE 
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.

END PROCEDURE.
