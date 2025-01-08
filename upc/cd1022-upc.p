/***********************************************************************
**  Programa..: UPC\cd1022-UPC.P
**  Autor.....: Anderson Cenci
**  Data......: Agosto/2013 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 01/08/2013
**                  Desenvolvimento Programa
************************************************************************/
DEF input param p-ind-event-cd1022        as char          no-undo.
DEF input param p-ind-object-cd1022       as char          no-undo.
DEF input param p-wgh-object-cd1022       as handle        no-undo.
DEF input param p-wgh-frame-cd1022        as widget-handle no-undo.
DEF input param p-cod-table-cd1022        as char          no-undo.
DEF input param p-row-table-cd1022        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object-cd1022:FILE-NAME,"~/"), p-wgh-object-cd1022:FILE-NAME,"~/").

DEF NEW GLOBAL SHARED VAR tx-limite-intel-disponivel-cd1022     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-limite-intel-disponivel-cd1022     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-limite-sup-disponivel-cd1022       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-limite-sup-disponivel-cd1022       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-limite-sup-cd1022                  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-limite-sup-cd1022                  AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-tg-declaracao-cd1022               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rt-trib-cd1022                     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-text-trib-cd1022                   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rs-tributacao-cd1022               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-abrev-trans-cd1022            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-emitente-observacoes-cd1022        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rect-12-cd1022                     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-text-1-cd1022                      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE de-val-lim-total-intelbras                      AS DECIMAL       NO-UNDO.
DEFINE VARIABLE de-limite-sup-cd1022                            AS DECIMAL       NO-UNDO.            
DEFINE VARIABLE de-limite-sup-disponivel-cd1022                 AS DECIMAL       NO-UNDO. 
DEFINE VARIABLE de-limite-intel-disponivel-cd1022               AS DECIMAL       NO-UNDO.

DEFINE TEMP-TABLE tt-tb-preco NO-UNDO
    FIELD nr-tabpre        LIKE tb-preco.nr-tabpre
    FIELD ds-descricao     AS CHARACTER FORMAT "x(30)":U
    FIELD cod-rep          LIKE crm-relacionamento-cliente.cod-rep
    FIELD cd-categoria     LIKE crm-relacionamento-cliente.cd-categoria
    FIELD ds-categoria     LIKE crm-categoria.ds-categoria
    FIELD cd-unid-negoc    AS CHARACTER
    FIELD cod-cond-pag     LIKE cond-pagto.cod-cond-pag
    FIELD cod-gr-cli       LIKE emitente.cod-gr-cli
    FIELD ds-gr-cli        LIKE gr-cli.descricao
    FIELD lg-tb-especifica AS INTEGER.

/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table) SKIP */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */

/* IF p-ind-object = "VIEWER"   AND                                                                   */
/*    p-ind-event = "BEFORE-INITIALIZE" THEN DO:                                                      */
/*                                                                                                    */
/*     /*fPage1*/                                                                                     */
/*     RUN tela-upc (INPUT p-wgh-frame,                                                               */
/*                   INPUT p-ind-Event,                                                               */
/*                   INPUT "rectangle",       /*** Type ***/                                          */
/*                   INPUT "rec-29",   /*** Name ***/                                                 */
/*                   INPUT no,            /*** Apresenta Mensagem dos Objetos ***/                    */
/*                   INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/ */
/*                   OUTPUT wh-retangulo).                                                            */
/*                                                                                                    */
/*     message VALID-HANDLE(wh-retangulo) VIEW-AS ALERT-BOX.                                          */
/* END.                                                                                               */



IF p-ind-event-cd1022  = "INITIALIZE":U  AND
   p-ind-object-cd1022 = "VIEWER"        AND
   c-objeto            = "v37ad098.w"    THEN DO:

    ASSIGN p-wgh-frame-cd1022:WIDTH  = p-wgh-frame-cd1022:WIDTH  + 5
           p-wgh-frame-cd1022:HEIGHT = p-wgh-frame-cd1022:HEIGHT + 3.

    CREATE TEXT tx-limite-intel-disponivel-cd1022
                ASSIGN FRAME        = p-wgh-frame-cd1022
                       FORMAT       = "x(26)"
                       WIDTH        = 26
                       SCREEN-VALUE = "Lim.Intelbras Disponivel:"
                       ROW          = 9.40 
                       COL          = 20.5 
                       VISIBLE      = YES.         
    
    CREATE FILL-IN  wh-limite-intel-disponivel-cd1022
                ASSIGN FRAME             = p-wgh-frame-cd1022
                       DATA-TYPE         = "decimal"
                       FORMAT            = "->>>,>>>,>>9.99"
                       WIDTH             = 15.5
                       HEIGHT            = 0.88
                       ROW               = 9.40
                       COL               = 37 
                       VISIBLE           = YES
                       SENSITIVE         = NO.

    CREATE TEXT tx-limite-sup-cd1022
                ASSIGN FRAME        = p-wgh-frame-cd1022
                       FORMAT       = "x(26)"
                       WIDTH        = 26
                       SCREEN-VALUE = "Limite Supplier Card:"
                       ROW          = 10.40 
                       COL          = 23 
                       VISIBLE      = YES.         
    
    CREATE FILL-IN  wh-limite-sup-cd1022
                ASSIGN FRAME             = p-wgh-frame-cd1022
                       DATA-TYPE         = "decimal"
                       FORMAT            = "->>>,>>>,>>9.99"
                       WIDTH             = 15.5
                       HEIGHT            = 0.88
                       ROW               = 10.40
                       COL               = 37 
                       VISIBLE           = YES
                       SENSITIVE         = NO.

    CREATE TEXT tx-limite-sup-disponivel-cd1022
                ASSIGN FRAME        = p-wgh-frame-cd1022
                       FORMAT       = "x(10)"
                       WIDTH        = 10
                       SCREEN-VALUE = "Sup.Disp:"
                       ROW          = 10.40 
                       COL          = 53.5 
                       VISIBLE      = YES.         
    
    CREATE FILL-IN  wh-limite-sup-disponivel-cd1022
                ASSIGN FRAME             = p-wgh-frame-cd1022
                       DATA-TYPE         = "decimal"
                       FORMAT            = "->>>,>>>,>>9.99"
                       WIDTH             = 12.5
                       HEIGHT            = 0.88
                       ROW               = 10.40
                       COL               = 60.5 
                       VISIBLE           = YES
                       SENSITIVE         = NO.
 
    RUN pi-busca-cli-sup IN THIS-PROCEDURE.
END.



IF  p-ind-event-cd1022  = "DISPLAY":U  AND
    p-ind-object-cd1022 = "VIEWER"     AND
    c-objeto            = "v37ad098.w" THEN DO:
    RUN pi-busca-cli-sup IN THIS-PROCEDURE.
END.
IF  p-ind-event-cd1022  = "INITIALIZE":U  AND
    p-ind-object-cd1022 = "VIEWER"        AND
    c-objeto            = "v39ad098.w"    THEN DO:

    RUN tela-upc (INPUT  p-wgh-frame-cd1022,
                  INPUT  p-ind-event-cd1022,
                  INPUT  "editor",
                  INPUT  "observacoes",
                  INPUT  NO,
                  INPUT  1,
                  OUTPUT wh-emitente-observacoes-cd1022).
    IF VALID-HANDLE(wh-emitente-observacoes-cd1022) THEN
       ASSIGN wh-emitente-observacoes-cd1022:HIDDEN = YES.

    RUN tela-upc (INPUT  p-wgh-frame-cd1022,
                  INPUT  p-ind-event-cd1022,
                  INPUT  "rectangle",
                  INPUT  "rect-12",
                  INPUT  NO,
                  INPUT  1,
                  OUTPUT wh-rect-12-cd1022).
    IF VALID-HANDLE(wh-rect-12-cd1022) THEN
       ASSIGN wh-rect-12-cd1022:HIDDEN = YES.

    RUN tela-upc (INPUT  p-wgh-frame-cd1022,
                  INPUT  p-ind-event-cd1022,
                  INPUT  "text",
                  INPUT  "text-1",
                  INPUT  NO,
                  INPUT  1,
                  OUTPUT wh-text-1-cd1022).
    IF VALID-HANDLE(wh-text-1-cd1022) THEN
       ASSIGN wh-text-1-cd1022:HIDDEN = YES.

END.
IF  p-ind-event-cd1022  = "INITIALIZE":U  AND
    p-ind-object-cd1022 = "VIEWER"        AND
    c-objeto            = "v35ad098.w"    THEN DO:

    ASSIGN p-wgh-frame-cd1022:WIDTH = p-wgh-frame-cd1022:WIDTH + 5.

    RUN tela-upc (INPUT  p-wgh-frame-cd1022,
                  INPUT  p-ind-event-cd1022,
                  INPUT  "fill-in",
                  INPUT  "c-nome-abrev-transp",
                  INPUT  NO,
                  INPUT  1,
                  OUTPUT wh-nome-abrev-trans-cd1022).

    IF  VALID-HANDLE(wh-nome-abrev-trans-cd1022) THEN
        ASSIGN wh-nome-abrev-trans-cd1022:WIDTH = wh-nome-abrev-trans-cd1022:WIDTH - 3.



    CREATE TOGGLE-BOX wh-tg-declaracao-cd1022
    ASSIGN FRAME      = p-wgh-frame-cd1022
           WIDTH      = 20
           HEIGHT     = 1
           ROW        = 1
           COL        = 60
           VISIBLE    = YES
           SENSITIVE  = NO
           LABEL      = "Declara‡Æo Entregue?".

    CREATE RECTANGLE     wh-rt-trib-cd1022
    ASSIGN FRAME         = p-wgh-frame-cd1022
           WIDTH         = 18
           HEIGHT        = 3.8
           ROW           = 2.2
           COL           = 59
           GRAPHIC-EDGE  = YES
           EDGE-PIXELS   = 2
           FILLED        = NO
           VISIBLE       = YES
           SENSITIVE     = NO.

    CREATE TEXT          wh-text-trib-cd1022
    ASSIGN FRAME         = p-wgh-frame-cd1022
           WIDTH         = 14
           ROW           = 1.9
           COL           = 61
           FORMAT        = "x(18)"
           SCREEN-VALUE  = "Forma Tributa‡Æo"
           VISIBLE       = YES
           SENSITIVE     = NO.

    CREATE RADIO-SET     wh-rs-tributacao-cd1022
    ASSIGN FRAME         = p-wgh-frame-cd1022
           WIDTH         = 20
           HEIGHT        = 3.3
           ROW           = 2.5
           COL           = 60
           HORIZONTAL    = NO
           RADIO-BUTTONS = "NÆo Cumulativo,1,Cum.todo ou parte,2,Simples,3,Nenhum,4,Isento,5"
           VISIBLE       = YES
           SENSITIVE     = NO.

    RUN pi-busca-cli IN THIS-PROCEDURE.
END.



IF  p-ind-event-cd1022  = "DISPLAY":U  AND
    p-ind-object-cd1022 = "VIEWER"     AND
    c-objeto            = "v35ad098.w" THEN DO:
    RUN pi-busca-cli IN THIS-PROCEDURE.
END.



IF  p-ind-event-cd1022 = "DESTROY" THEN DO:
    IF  VALID-HANDLE(wh-tg-declaracao-cd1022) THEN DO:
        DELETE OBJECT wh-tg-declaracao-cd1022.
        ASSIGN wh-tg-declaracao-cd1022 = ?.
    END.

    IF  VALID-HANDLE(wh-rt-trib-cd1022) THEN DO:
        DELETE OBJECT wh-rt-trib-cd1022.
        ASSIGN wh-rt-trib-cd1022 = ?.
    END.

    IF  VALID-HANDLE(wh-text-trib-cd1022) THEN DO:
        DELETE OBJECT wh-text-trib-cd1022.
        ASSIGN wh-text-trib-cd1022 = ?.
    END.

    IF  VALID-HANDLE(wh-rs-tributacao-cd1022) THEN DO:
        DELETE OBJECT wh-rs-tributacao-cd1022.
        ASSIGN wh-rs-tributacao-cd1022 = ?.
    END.

    IF  VALID-HANDLE(tx-limite-intel-disponivel-cd1022) THEN DO:
        DELETE OBJECT tx-limite-intel-disponivel-cd1022.
        ASSIGN tx-limite-intel-disponivel-cd1022 = ?.
    END.

    IF  VALID-HANDLE(wh-limite-intel-disponivel-cd1022) THEN DO:
        DELETE OBJECT wh-limite-intel-disponivel-cd1022.
        ASSIGN wh-limite-intel-disponivel-cd1022 = ?.
    END.

    IF  VALID-HANDLE(tx-limite-sup-cd1022) THEN DO:
        DELETE OBJECT tx-limite-sup-cd1022.
        ASSIGN tx-limite-sup-cd1022 = ?.
    END.

    IF  VALID-HANDLE(wh-limite-sup-cd1022) THEN DO:
        DELETE OBJECT wh-limite-sup-cd1022.
        ASSIGN wh-limite-sup-cd1022 = ?.
    END.

    IF  VALID-HANDLE(tx-limite-sup-disponivel-cd1022) THEN DO:
        DELETE OBJECT tx-limite-sup-disponivel-cd1022.
        ASSIGN tx-limite-sup-disponivel-cd1022 = ?.
    END.

    IF  VALID-HANDLE(wh-limite-sup-disponivel-cd1022) THEN DO:
        DELETE OBJECT wh-limite-sup-disponivel-cd1022.
        ASSIGN wh-limite-sup-disponivel-cd1022 = ?.
    END.
END.



/*--- Procedure Internas ---*/
PROCEDURE pi-busca-cli:
    IF  VALID-HANDLE(wh-tg-declaracao-cd1022) AND
        VALID-HANDLE(wh-rs-tributacao-cd1022) THEN DO:
        FIND FIRST emitente NO-LOCK
            WHERE  ROWID(emitente) = p-row-table-cd1022 NO-ERROR.
        IF  AVAIL  emitente THEN DO:
            FIND FIRST int-emitente-trib NO-LOCK
                WHERE  int-emitente-trib.raiz-cnpj = SUBSTRING(emitente.cgc,1,8) NO-ERROR.
            ASSIGN wh-tg-declaracao-cd1022:CHECKED = IF AVAIL int-emitente-trib THEN int-emitente-trib.ind-declaracao ELSE NO.
    
            FIND FIRST int-emitente NO-LOCK
                WHERE  int-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            ASSIGN wh-rs-tributacao-cd1022:SCREEN-VALUE = IF AVAIL int-emitente THEN STRING(int-emitente.ind-forma-tributo) ELSE "4".
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-busca-cli-sup:
    IF  VALID-HANDLE(wh-limite-sup-cd1022)              AND
        VALID-HANDLE(wh-limite-sup-disponivel-cd1022)   AND 
        VALID-HANDLE(wh-limite-intel-disponivel-cd1022) THEN DO:
        FIND FIRST emitente NO-LOCK
             WHERE ROWID(emitente) = p-row-table-cd1022 NO-ERROR.
        IF  AVAIL  emitente THEN DO:
            RUN esp/crm/escrm029.p (INPUT  emitente.cod-emitente,
                                    OUTPUT TABLE tt-tb-preco,
                                    OUTPUT de-limite-sup-cd1022,
                                    OUTPUT de-limite-sup-disponivel-cd1022,
                                    OUTPUT de-val-lim-total-intelbras,
                                    OUTPUT de-limite-intel-disponivel-cd1022).
            
            ASSIGN wh-limite-sup-cd1022:SCREEN-VALUE              = STRING(de-limite-sup-cd1022)
                   wh-limite-sup-disponivel-cd1022:SCREEN-VALUE   = STRING(de-limite-sup-disponivel-cd1022)
                   wh-limite-intel-disponivel-cd1022:SCREEN-VALUE = STRING(de-limite-intel-disponivel-cd1022).
        END.
    END.
END PROCEDURE.


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
