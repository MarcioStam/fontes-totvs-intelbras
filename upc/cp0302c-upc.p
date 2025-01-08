/***********************************************************************
**  Programa..: UPC\CP0301D1-UPC.P
**  Autor.....: Giovane Alves - Gestech
**  Data......: OUTUBRO/2007 - Desenvolvimento
**  Descricao.: Implementação do controle de CDB para Nova
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE r-ord-prod-cp0301-upc        AS ROWID NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-cp0302c-upc-val            AS LOGICAL NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-cp0302c-upc         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-save-cp0302c-upc       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-orig-cp0302c-upc    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-save-orig-cp0302c-upc  AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-container-cp0302c         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-homem-txt-cp0302c      AS WIDGET-HANDLE NO-UNDO.

DEF VAR wh-nro-homem-cp0302c     AS WIDGET-HANDLE NO-UNDO.
DEF VAR wh-nro-homem-aps-cp0302c AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-gm-codigo       AS WIDGET-HANDLE NO-UNDO. 
DEFINE VARIABLE h-frame            AS HANDLE        NO-UNDO.
DEFINE VARIABLE hCurrentWidget     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE iMsg               AS INTEGER       NO-UNDO.

DEF VAR c-objeto  AS CHAR            NO-UNDO.

DEFINE TEMP-TABLE widgets NO-UNDO
    FIELD wg-handle    AS WIDGET-HANDLE
    FIELD wg-name      AS CHARACTER
    FIELD wg-type      AS CHARACTER
    FIELD wg-parent    AS WIDGET-HANDLE.  

DEF NEW GLOBAL SHARED TEMP-TABLE tt-cp0302c-upc NO-UNDO
    FIELD wg-frame       AS HANDLE
    FIELD wg-nro-hom-aps AS HANDLE
    FIELD wg-container   AS HANDLE.

{cdp/cd0666.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEFINE BUFFER b-ord FOR ord-prod.

DEFINE BUFFER bff1-oper-ord FOR oper-ord.

DEF VAR wh-aux AS WIDGET-HANDLE NO-UNDO.

        

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

          /*
MESSAGE "event" p-ind-event SKIP
        "obj type" p-ind-object SKIP
        "obj" c-objeto SKIP
        "table" p-cod-table VIEW-AS ALERT-BOX.*/

IF  p-ind-event  = "BEFORE-INITIALIZE"
AND p-ind-object = "CONTAINER"
THEN ASSIGN wh-container-cp0302c    = p-wgh-object
            wh-nr-homem-txt-cp0302c = ?.

if p-ind-event  = "INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:

    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "bt-ok",
                      OUTPUT wh-bt-ok-orig-cp0302c-upc).
    
    create button wh-bt-ok-cp0302c-upc
    assign flat-button   = NO
           frame         = p-wgh-frame 
           width         = wh-bt-ok-orig-cp0302c-upc:WIDTH
           height        = wh-bt-ok-orig-cp0302c-upc:HEIGHT
           row           = wh-bt-ok-orig-cp0302c-upc:ROW
           col           = wh-bt-ok-orig-cp0302c-upc:COLUMN
           visible       = yes
           sensitive     = yes
           tooltip       = wh-bt-ok-orig-cp0302c-upc:TOOLTIP
           LABEL         = "Ok"
           triggers:
                on choose persistent run upc/cp0302c-trg01-upc.p.
           end triggers .
    
    wh-bt-ok-cp0302c-upc:MOVE-TO-TOP().
    
    ASSIGN wh-bt-ok-orig-cp0302c-upc:VISIBLE = FALSE.
    
    /**/
    
    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "bt-save",
                      OUTPUT wh-bt-save-orig-cp0302c-upc).
    
    create button wh-bt-save-cp0302c-upc
    assign flat-button   = NO
           frame         = p-wgh-frame 
           width         = wh-bt-save-orig-cp0302c-upc:WIDTH
           height        = wh-bt-save-orig-cp0302c-upc:HEIGHT
           row           = wh-bt-save-orig-cp0302c-upc:ROW
           col           = wh-bt-save-orig-cp0302c-upc:COLUMN 
           visible       = yes
           sensitive     = YES
           tooltip       = wh-bt-save-orig-cp0302c-upc:TOOLTIP
           LABEL         = "Salvar"
           triggers:
                on choose persistent run upc/cp0302c-trg02-upc.p.
           end triggers.
    
    wh-bt-save-cp0302c-upc:MOVE-TO-TOP().
    
    ASSIGN wh-bt-save-orig-cp0302c-upc:VISIBLE = FALSE.
end.


IF c-objeto = "v09in260.w" AND 
    p-ind-event = "AFTER-ENABLE" THEN DO:

    RUN GET-ATTRIBUTE IN p-wgh-object ('adm-new-record').

    IF VALID-HANDLE(wh-bt-save-cp0302c-upc) THEN DO:

        IF RETURN-VALUE = "YES" THEN
            wh-bt-save-cp0302c-upc:SENSITIVE = TRUE.
        ELSE
            wh-bt-save-cp0302c-upc:SENSITIVE = FALSE.

    END.
END.

IF  p-ind-event  = "AFTER-ENABLE"
AND p-ind-object = "VIEWER"
AND c-objeto     = "v10in260.w" 
AND NOT CAN-FIND(FIRST tt-cp0302c-upc WHERE
                       tt-cp0302c-upc.wg-frame = p-wgh-frame)
THEN DO:
     run select-page in wh-container-cp0302c (input 2).
     RUN busca-handle (INPUT p-wgh-frame,
                       INPUT "numero-homem",
                       OUTPUT wh-nro-homem-cp0302c).

     IF VALID-HANDLE(wh-nro-homem-cp0302c)
     THEN DO:
          CREATE FILL-IN wh-nro-homem-aps-cp0302c
          ASSIGN FRAME             = wh-nro-homem-cp0302c:FRAME
                 DATA-TYPE         = "Decimal"
                 FORMAT            = ">>9.9"
                 WIDTH             = wh-nro-homem-cp0302c:WIDTH + 2
                 HEIGHT            = wh-nro-homem-cp0302c:HEIGHT
                 ROW               = wh-nro-homem-cp0302c:ROW
                 COLUMN            = wh-nro-homem-cp0302c:COLUMN + 17
                //HIDDEN            = wh-nro-homem-cp0302c:HIDDEN
                //SIDE-LABEL-HANDLE = wh-nro-homem-cp0302c:SIDE-LABEL-HANDLE
                //HELP              = wh-nro-homem-cp0302c:HELP
                //TOOLTIP           = wh-nro-homem-cp0302c:TOOLTIP
                 SENSITIVE         = YES
                 VISIBLE           = YES.
      
          create TEXT wh-nr-homem-txt-cp0302c
          assign frame        = wh-nro-homem-aps-cp0302c:frame
                 WIDTH        = 9.5
                 HEIGHT       = 0.88
                 row          = wh-nro-homem-aps-cp0302c:row
                 col          = wh-nro-homem-aps-cp0302c:col - 9.7
                 BGCOLOR      = ?
                 VISIBLE      = YES
                 SENSITIVE    = YES
                 format       = "x(12)"
                 screen-value = "Nr. Hom APS:".
    
          wh-nro-homem-aps-cp0302c:MOVE-AFTER-TAB-ITEM(wh-nro-homem-cp0302c).
    
          CREATE tt-cp0302c-upc.
          ASSIGN tt-cp0302c-upc.wg-frame       = wh-nro-homem-cp0302c:FRAME
                 tt-cp0302c-upc.wg-nro-hom-aps = wh-nro-homem-aps-cp0302c
                 tt-cp0302c-upc.wg-container   = wh-container-cp0302c.
          FIND CURRENT tt-cp0302c-upc NO-ERROR.
    
          FOR FIRST oper-ord NO-LOCK
              WHERE ROWID(oper-ord) = p-row-table,
              FIRST int-oper-ord NO-LOCK
              WHERE int-oper-ord.nr-ord-produ = oper-ord.nr-ord-produ
                AND int-oper-ord.it-codigo    = oper-ord.it-codigo
                AND int-oper-ord.cod-roteiro  = oper-ord.cod-roteiro
                AND int-oper-ord.op-codigo    = oper-ord.op-codigo:
              ASSIGN tt-cp0302c-upc.wg-nro-hom-aps:SCREEN-VALUE = STRING(int-oper-ord.nro-homem-aps) NO-ERROR.
          END. /* FOR FIRST operacao */
    END.
    run select-page in wh-container-cp0302c (input 1).
END.

IF p-ind-event  = "ADD" AND 
   p-ind-object = "VIEWER" AND
   c-objeto     = "v09in260.w" THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.

    IF h-frame:TYPE <> "field-group":U THEN DO:
        CASE h-frame:NAME:
            WHEN "gm-codigo":U THEN ASSIGN wh-gm-codigo = h-frame.
        END CASE.

        ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        
    END.
    ELSE LEAVE.
END.

IF p-ind-event  = "VALIDATE" AND 
   p-ind-object = "VIEWER" AND
   c-objeto     = "v09in260.w" THEN DO:

    RUN pi-valida-gm-codigo.

END.

IF  p-ind-event  = "AFTER-END-UPDATE"
AND p-ind-object = "VIEWER"
AND c-objeto     = "v10in260.w"
THEN FOR FIRST tt-cp0302c-upc
         WHERE tt-cp0302c-upc.wg-frame = p-wgh-frame:
         IF tt-cp0302c-upc.wg-nro-hom-aps:SCREEN-VALUE = "?"
         THEN ASSIGN tt-cp0302c-upc.wg-nro-hom-aps:SCREEN-VALUE = "".

         FOR FIRST oper-ord NO-LOCK
             WHERE ROWID(oper-ord) = p-row-table:
             FOR FIRST int-oper-ord
                 WHERE int-oper-ord.nr-ord-produ = oper-ord.nr-ord-produ
                   AND int-oper-ord.it-codigo    = oper-ord.it-codigo
                   AND int-oper-ord.cod-roteiro  = oper-ord.cod-roteiro
                   AND int-oper-ord.op-codigo    = oper-ord.op-codigo
                       EXCLUSIVE-LOCK: END.
    
             IF  NOT AVAIL int-oper-ord
             THEN DO:
                  CREATE int-oper-ord.
                  ASSIGN int-oper-ord.nr-ord-produ = oper-ord.nr-ord-produ
                         int-oper-ord.it-codigo    = oper-ord.it-codigo   
                         int-oper-ord.cod-roteiro  = oper-ord.cod-roteiro 
                         int-oper-ord.op-codigo    = oper-ord.op-codigo.
             END.
            
             IF AVAIL int-oper-ord
             THEN ASSIGN int-oper-ord.nro-homem-aps = DECI(tt-cp0302c-upc.wg-nro-hom-aps:SCREEN-VALUE).
             FIND CURRENT int-oper-ord NO-LOCK NO-ERROR.
         END.
     END. /* FOR FIRST tt-cp0302c-upc */

IF p-ind-event  = "DESTROY" AND 
   p-ind-object = "CONTAINER" AND
   c-objeto     = "cp0302c.w" THEN
    FOR FIRST tt-cp0302c-upc
        WHERE tt-cp0302c-upc.wg-container = p-wgh-object:
        DELETE tt-cp0302c-upc.
    END.

IF VALID-HANDLE(wh-nr-homem-txt-cp0302c)
THEN ASSIGN wh-nr-homem-txt-cp0302c:SCREEN-VALUE = "Nr. Hom APS:" NO-ERROR.

PROCEDURE pi-valida-gm-codigo.

    ASSIGN hCurrentWidget = SESSION:HANDLE.

    RUN pi-wg-lista(hCurrentWidget).
    
    FIND FIRST widgets
         WHERE widgets.wg-name = 'gm-codigo' NO-LOCK NO-ERROR.
    IF AVAIL widgets THEN DO:
        ASSIGN wh-gm-codigo = widgets.wg-handle.

        FIND FIRST grup-maquina
             WHERE grup-maquina.gm-codigo = wh-gm-codigo:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAIL grup-maquina THEN DO:
            IF grup-maquina.log-1 THEN DO:
                MESSAGE "O grupo m quina " grup-maquina.gm-codigo " encontra-se " skip
                        "Desativado no cadastro de Grupo de M quinas. "
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.
        END. 
        
    END.                

END PROCEDURE.

PROCEDURE pi-wg-lista:

DEFINE INPUT  PARAMETER hWidgetScope AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE hCurrentWidget       AS WIDGET-HANDLE NO-UNDO.

    ASSIGN hCurrentWidget = hWidgetScope:FIRST-CHILD NO-ERROR.
    
    DO WHILE VALID-HANDLE(hCurrentWidget):
    
        CREATE widgets.
        ASSIGN widgets.wg-handle = hCurrentWidget
               widgets.wg-name   = hCurrentWidget:NAME
               widgets.wg-type   = hCurrentWidget:TYPE
               widgets.wg-parent = hCurrentWidget:PARENT.
        
        RUN pi-wg-lista(hCurrentWidget).
        
        ASSIGN hCurrentWidget = hCurrentWidget:NEXT-SIBLING.
    
    END.

END PROCEDURE.

    
PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE h-prox AS HANDLE     NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF NOT valid-handle(h-aux) AND
           NOT VALID-HANDLE(h-prox) THEN DO:

            ASSIGN h-aux = ?.
            LEAVE.

        END.

        IF NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF h-aux:NAME = "panel-frame" THEN DO:

            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
            
        END.

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.

        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

        

    END.

END.

