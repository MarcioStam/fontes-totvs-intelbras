/* -------------------------------------------------------------------------------------------------------------
Programa : upc/bas_grp_usuar.p
Funcao   : UPC criada para nao permitir alteraá∆o dos grupos sup e adm
Autor    : Gustavo Eckel
Data     : 10/2013
Alteraá∆o:
Vers∆o   : 001
-------------------------------------------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p-ind-event              AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object             AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object             AS HANDLE        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame              AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table              AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-row-table              AS ROWID         NO-UNDO.

DEFINE VARIABLE i            AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-esconde    AS LOGICAL     NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR h-bt-gera-sec001aa     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h-cod_grp_usuar-sec001 AS WIDGET-HANDLE NO-UNDO.

{esp/es0018.i}
{utp/ut-glob.i}

IF  p-ind-event  = "INITIALIZE" 
AND p-ind-object = "BROWSER" THEN DO:
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "Button",    /*** Type ***/
                  INPUT "bt-formar", /*** Name ***/
                  INPUT NO,          /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,           /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT h-bt-gera-sec001aa).
END.

IF  p-ind-event  = "INITIALIZE" 
AND p-ind-object = "VIEWER" THEN DO:
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",                 /*** Type ***/
                  INPUT "cod_grp_usuar", /*** Name ***/
                  INPUT NO,                        /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,                         /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT h-cod_grp_usuar-sec001).
    
END.

IF  p-ind-event  = "AFTER-OPEN-QUERY" 
AND p-ind-object = "BROWSER" THEN DO:

    RUN esp/es0018p.p (INPUT  "SEC001AA":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FIND FIRST tt-prog-ponto
        WHERE entry(1,tt-prog-ponto.conteudo,";") = h-cod_grp_usuar-sec001:SCREEN-VALUE NO-ERROR.
                 
    IF h-cod_grp_usuar-sec001:SCREEN-VALUE = "sup" 
    OR h-cod_grp_usuar-sec001:SCREEN-VALUE = "adm" THEN
        ASSIGN l-esconde = YES. 
              
    IF AVAIL tt-prog-ponto THEN DO:
        DO i = 2 TO NUM-ENTRIES(tt-prog-ponto.conteudo,";"):
            IF ENTRY(i,tt-prog-ponto.conteudo,";") = c-seg-usuario
            AND h-cod_grp_usuar-sec001:SCREEN-VALUE = ENTRY(1,tt-prog-ponto.conteudo,";") THEN
                ASSIGN l-esconde = NO.
        END.
    END.
              
    IF VALID-HANDLE(h-bt-gera-sec001aa) THEN
        ASSIGN h-bt-gera-sec001aa:HIDDEN = l-esconde.
     
END.

PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

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

RETURN "OK":U.
