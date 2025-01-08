/***********************************************************************
**  Programa..: upc\re1001a1-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}
{esp/es0018.i}
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEF VAR h-folder                   AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fpage8    AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fpage7    AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-frame8    AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-frame7    AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fpage1    AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-frame1    AS HANDLE   NO-UNDO.
DEFINE VARIABLE i-num-pedido AS INTEGER     NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-tot-peso                AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tot-peso                AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-tot-peso-it          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-tot-peso-dif         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-peso-bruto-tot          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-tot-peso-bruto-it    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-tot-peso-bruto-dif   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tot-desconto            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-tot-desconto-it      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-tot-desconto-dif     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-despesa-nota            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-despesa-nota-it      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-despesa-nota-dif     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-valor-mercad            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-valor-mercad-it      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-valor-mercad-dif     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-base-ipi                AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-base-ipi-it          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-base-ipi-dif         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ipi-deb-cre             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-ipi-deb-cre-it       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-ipi-deb-cre-dif      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-base-icm                AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-base-icm-it          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-base-icm-dif         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-icm-deb-cre             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-icm-deb-cre-it       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-icm-deb-cre-dif      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tot-valor               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rect-14                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rect-12                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-literal                 AS WIDGET-HANDLE NO-UNDO.
                                                     
DEF NEW GLOBAL SHARED VAR tx-pis                     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-pis                     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-cofins                  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cofins                  AS WIDGET-HANDLE NO-UNDO.
                                                     
DEF NEW GLOBAL SHARED VAR wh-tx-valor-total          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-peso-bruto           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-peso-total           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-total-descto         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-despesas-nota        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-valor-total-merc     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-base-calculo-ipi     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-valor-ipi            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-base-calculo-icms    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-valor-icms           AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-carregamento-re1001a1 AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR p-wgh-frame-aux        as widget-handle no-undo.

DEF NEW GLOBAL SHARED VAR wh-bt-ativo-re1001a1          AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-bt-ok-re1001a1             AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR h-upc-re1001a1                AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-cod-modalid-frete-re1001a1 AS WIDGET-HANDLE NO-UNDO. 

DEFINE VARIABLE c-char AS   CHAR.

DEFINE BUFFER b-docum-est FOR docum-est.
DEFINE BUFFER b-item-doc-est FOR item-doc-est.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").


/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Nome   " c-char SKIP              */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table)      */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */

IF  p-ind-object = "CONTAINER" AND 
    p-ind-event = "BEFORE-INITIALIZE" THEN DO:
    RUN upc/re1001a1-upc.p PERSISTENT SET h-upc-re1001a1(INPUT "",            
                                                         INPUT "",            
                                                         INPUT p-wgh-object,  
                                                         INPUT p-wgh-frame,   
                                                         INPUT "",            
                                                         INPUT p-row-table).  
    
    
END.

IF  p-ind-event  = "BEFORE-INITIALIZE" THEN DO:
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "button",     /*** Type ***/
                  INPUT "btok",         /*** Name ***/
                  INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-bt-ok-re1001a1).

    IF VALID-HANDLE(wh-bt-ok-re1001a1) THEN DO:
        create button wh-bt-ativo-re1001a1  
        assign frame     = wh-bt-ok-re1001a1:FRAME 
               width     = 4.00        
               height    = 1
               row       = wh-bt-ok-re1001a1:ROW + 0.2 
               col       = wh-bt-ok-re1001a1:COL + 50
               visible   = yes
               sensitive = yes
               tooltip   = "Mostra um nro de carregamento Livre"
               TRIGGERS:
                   ON CHOOSE PERSISTENT RUN pi-botao-carregamento IN h-upc-re1001a1.
               END TRIGGERS.                        

        if wh-bt-ativo-re1001a1:load-image("image/im-livro.bmp") then.
   END.
END. 

IF  p-ind-event  = "BEFORE-DISPLAY" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = 'fPage7' THEN 
                ASSIGN h-fpage7 = h-object
                       h-frame7 = h-object.
            IF h-object:NAME = 'fPage1' THEN 
                ASSIGN h-fpage1 = h-object
                       h-frame1 = h-object.
            IF h-object:NAME = 'fPage8' THEN 
                ASSIGN h-fpage8 = h-object
                       h-frame8 = h-object.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-fpage7 = h-fpage7:FIRST-CHILD.
    ASSIGN h-fpage7 = h-fpage7:FIRST-CHILD.
    ASSIGN h-fpage8 = h-fpage8:FIRST-CHILD.
    ASSIGN h-fpage8 = h-fpage8:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-fpage8):
        IF h-fpage8:TYPE <> "field-group" THEN DO:

            CASE h-fpage8:NAME:
                WHEN 'c-cod-modalid-frete' THEN do:
                    ASSIGN wh-cod-modalid-frete-re1001a1 = h-fpage8.
                    /*MESSAGE "entrou " wh-cod-modalid-frete-re1001a1:SCREEN-VALUE
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
                end.
            END CASE.
            ASSIGN h-fpage8 = h-fpage8:NEXT-SIBLING NO-ERROR.

        END.
        ELSE LEAVE.
    END.

    DO WHILE VALID-HANDLE(h-fpage7):
        IF h-fpage7:TYPE <> "field-group" THEN DO:

            CASE h-fpage7:NAME:
                WHEN 'tot-peso'              THEN ASSIGN wh-tot-peso              = h-fpage7.
                WHEN 'de-tot-peso-it'        THEN ASSIGN wh-de-tot-peso-it        = h-fpage7.
                WHEN 'de-tot-peso-dif'       THEN ASSIGN wh-de-tot-peso-dif       = h-fpage7.
                WHEN 'peso-bruto-tot'        THEN ASSIGN wh-peso-bruto-tot        = h-fpage7.
                WHEN 'de-tot-peso-bruto-it'  THEN ASSIGN wh-de-tot-peso-bruto-it  = h-fpage7.
                WHEN 'de-tot-peso-bruto-dif' THEN ASSIGN wh-de-tot-peso-bruto-dif = h-fpage7.
                WHEN 'tot-desconto'          THEN ASSIGN wh-tot-desconto          = h-fpage7.
                WHEN 'de-tot-desconto-it'    THEN ASSIGN wh-de-tot-desconto-it    = h-fpage7.
                WHEN 'de-tot-desconto-dif'   THEN ASSIGN wh-de-tot-desconto-dif   = h-fpage7.
                WHEN 'despesa-nota'          THEN ASSIGN wh-despesa-nota          = h-fpage7.
                WHEN 'de-despesa-nota-it'    THEN ASSIGN wh-de-despesa-nota-it    = h-fpage7.
                WHEN 'de-despesa-nota-dif'   THEN ASSIGN wh-de-despesa-nota-dif   = h-fpage7.
                WHEN 'valor-mercad'          THEN ASSIGN wh-valor-mercad          = h-fpage7.
                WHEN 'de-valor-mercad-it'    THEN ASSIGN wh-de-valor-mercad-it    = h-fpage7.
                WHEN 'de-valor-mercad-dif'   THEN ASSIGN wh-de-valor-mercad-dif   = h-fpage7.
                WHEN 'base-ipi'              THEN ASSIGN wh-base-ipi              = h-fpage7.
                WHEN 'de-base-ipi-it'        THEN ASSIGN wh-de-base-ipi-it        = h-fpage7.
                WHEN 'de-base-ipi-dif'       THEN ASSIGN wh-de-base-ipi-dif       = h-fpage7.
                WHEN 'ipi-deb-cre'           THEN ASSIGN wh-ipi-deb-cre           = h-fpage7.
                WHEN 'de-ipi-deb-cre-it'     THEN ASSIGN wh-de-ipi-deb-cre-it     = h-fpage7.
                WHEN 'de-ipi-deb-cre-dif'    THEN ASSIGN wh-de-ipi-deb-cre-dif    = h-fpage7.
                WHEN 'base-icm'              THEN ASSIGN wh-base-icm              = h-fpage7.
                WHEN 'de-base-icm-it'        THEN ASSIGN wh-de-base-icm-it        = h-fpage7.
                WHEN 'de-base-icm-dif'       THEN ASSIGN wh-de-base-icm-dif       = h-fpage7.
                WHEN 'icm-deb-cre'           THEN ASSIGN wh-icm-deb-cre           = h-fpage7.
                WHEN 'de-icm-deb-cre-it'     THEN ASSIGN wh-de-icm-deb-cre-it     = h-fpage7.
                WHEN 'de-icm-deb-cre-dif'    THEN ASSIGN wh-de-icm-deb-cre-dif    = h-fpage7.
                WHEN 'tot-valor'             THEN ASSIGN wh-tot-valor             = h-fpage7.
                WHEN 'rect-14'               THEN ASSIGN wh-rect-14               = h-fpage7.
                WHEN 'rect-12'               THEN ASSIGN wh-rect-12               = h-fpage7.
                OTHERWISE DO: 
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Valor Total" THEN
                        ASSIGN wh-tx-valor-total = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Total Descto" THEN
                        ASSIGN wh-tx-total-descto = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Peso L°quido Total" THEN
                        ASSIGN wh-tx-peso-total = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Peso Bruto Total" THEN
                        ASSIGN wh-tx-peso-bruto = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Despesas Nota" THEN
                        ASSIGN wh-tx-despesas-nota = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Valor Total Merc" THEN
                        ASSIGN wh-tx-valor-total-merc = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Base C†lculo IPI" THEN
                        ASSIGN wh-tx-base-calculo-ipi = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Valor IPI" THEN
                        ASSIGN wh-tx-valor-ipi = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Base C†lculo ICMS" THEN
                        ASSIGN wh-tx-base-calculo-icms = h-fpage7.
                    ELSE
                    IF TRIM(h-fpage7:SCREEN-VALUE) = "Valor ICMS" THEN
                        ASSIGN wh-tx-valor-icms = h-fpage7.
                END.
            END CASE.
            ASSIGN h-fpage7 = h-fpage7:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.
END.

IF  p-ind-event  = "AFTER-DISPLAY" THEN DO:

    DEF VAR de-pis    AS DEC.
    DEF VAR de-cofins AS DEC.

    ASSIGN h-frame7:ROW                 = 2.5
           h-frame7:HEIGHT              = 14.4
           wh-rect-14:HEIGHT            = 14.2.
/*            wh-tot-peso:ROW              = 2.20                    */
/*            wh-de-tot-peso-it:ROW        = 2.20                    */
/*            wh-de-tot-peso-dif:ROW       = 2.20                    */
/*            wh-tot-desconto:ROW          = wh-tot-peso:ROW +  0.91 */
/*            wh-de-tot-desconto-it:ROW    = wh-tot-peso:ROW +  0.91 */
/*            wh-de-tot-desconto-dif:ROW   = wh-tot-peso:ROW +  0.91 */
/*            wh-peso-bruto-tot:ROW        = wh-tot-peso:ROW +  1.82 */
/*            wh-de-tot-peso-bruto-it:ROW  = wh-tot-peso:ROW +  1.82 */
/*            wh-de-tot-peso-bruto-dif:ROW = wh-tot-peso:ROW +  1.82 */
/*            wh-despesa-nota:ROW          = wh-tot-peso:ROW +  2.73 */
/*            wh-de-despesa-nota-it:ROW    = wh-tot-peso:ROW +  2.73 */
/*            wh-de-despesa-nota-dif:ROW   = wh-tot-peso:ROW +  2.73 */
/*            wh-valor-mercad:ROW          = wh-tot-peso:ROW +  3.64 */
/*            wh-de-valor-mercad-it:ROW    = wh-tot-peso:ROW +  3.64 */
/*            wh-de-valor-mercad-dif:ROW   = wh-tot-peso:ROW +  3.64 */
/*            wh-base-ipi:ROW              = wh-tot-peso:ROW +  4.55 */
/*            wh-de-base-ipi-it:ROW        = wh-tot-peso:ROW +  4.55 */
/*            wh-de-base-ipi-dif:ROW       = wh-tot-peso:ROW +  4.55 */
/*            wh-ipi-deb-cre:ROW           = wh-tot-peso:ROW +  5.46 */
/*            wh-de-ipi-deb-cre-it:ROW     = wh-tot-peso:ROW +  5.46 */
/*            wh-de-ipi-deb-cre-dif:ROW    = wh-tot-peso:ROW +  5.46 */
/*            wh-base-icm:ROW              = wh-tot-peso:ROW +  6.37 */
/*            wh-de-base-icm-it:ROW        = wh-tot-peso:ROW +  6.37 */
/*            wh-de-base-icm-dif:ROW       = wh-tot-peso:ROW +  6.37 */
/*            wh-icm-deb-cre:ROW           = wh-tot-peso:ROW +  7.28 */
/*            wh-de-icm-deb-cre-it:ROW     = wh-tot-peso:ROW +  7.28 */
/*            wh-de-icm-deb-cre-dif:ROW    = wh-tot-peso:ROW +  7.28 */
      ASSIGN  wh-tot-valor:COL             = wh-tot-peso:COL + 39.0
              wh-tx-valor-total:COL        = wh-tx-valor-total:COL + 39.0.
      ASSIGN  wh-tot-valor:ROW             =  wh-tot-valor:ROW + 1
              wh-tx-valor-total:ROW        = wh-tx-valor-total:ROW + 1.
/*            wh-tx-peso-total:ROW         = wh-tot-peso:ROW         */
/*            wh-tx-peso-bruto:ROW         = wh-tot-peso:ROW + 0.91  */
/*            wh-tx-despesas-nota:ROW      = wh-tot-peso:ROW + 1.82  */
/*            wh-tx-total-descto:ROW       = wh-tot-peso:ROW + 2.73  */
/*            wh-tx-valor-total-merc:ROW   = wh-tot-peso:ROW + 3.64  */
/*            wh-tx-base-calculo-ipi:ROW   = wh-tot-peso:ROW + 4.55  */
/*            wh-tx-valor-ipi:ROW          = wh-tot-peso:ROW + 5.46  */
/*            wh-tx-base-calculo-icms:ROW  = wh-tot-peso:ROW + 6.37  */
/*            wh-tx-valor-icms:ROW         = wh-tot-peso:ROW + 7.28. */

    CREATE TEXT tx-pis
    ASSIGN FRAME        = h-frame7
           FORMAT       = "x(15)"
           WIDTH        = 7.00
           SCREEN-VALUE = "Total PIS:"
           ROW          = wh-tx-peso-total:ROW + 11.15
           COL          = 17.72
           VISIBLE      = YES.

    CREATE FILL-IN wh-pis
    ASSIGN FRAME             = h-frame7
           DATA-TYPE         = wh-tot-valor:DATA-TYPE
           FORMAT            = wh-tot-valor:FORMAT
           WIDTH             = wh-tot-valor:WIDTH
           HEIGHT            = wh-tot-valor:HEIGHT
           ROW               = wh-tot-peso:ROW + 11
           COL               = wh-tot-peso:COL
           SIDE-LABEL-HANDLE = tx-pis:HANDLE
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT tx-cofins
    ASSIGN FRAME        = h-frame7
           FORMAT       = "x(15)"
           WIDTH        = 9.00
           SCREEN-VALUE = "Total Cofins:"
           ROW          = tx-pis:ROW + 1
           COL          = tx-pis:COL - 1.6
           VISIBLE      = YES.

    CREATE FILL-IN wh-cofins
    ASSIGN FRAME             = h-frame7
           DATA-TYPE         = wh-tot-valor:DATA-TYPE
           FORMAT            = wh-tot-valor:FORMAT
           WIDTH             = wh-tot-valor:WIDTH
           HEIGHT            = wh-tot-valor:HEIGHT
           ROW               = wh-pis:ROW + 1
           COL               = wh-pis:COL
           SIDE-LABEL-HANDLE = tx-pis:HANDLE
           VISIBLE           = YES
           SENSITIVE         = NO.

    h-frame7:HEIGHT = h-frame7:HEIGHT + 0.5.

    FOR FIRST docum-est NO-LOCK
        WHERE ROWID(docum-est) = p-row-table,
        EACH item-doc-est OF docum-est NO-LOCK:
        ASSIGN de-pis    = de-pis    + item-doc-est.valor-pis
               de-cofins = de-cofins + item-doc-est.val-cofins.
    END.

    ASSIGN wh-pis:SCREEN-VALUE    = STRING(de-pis)
           wh-cofins:SCREEN-VALUE = STRING(de-cofins).
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
            MESSAGE
             "Nome do Objeto" wgh-obj:NAME SKIP             
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
PROCEDURE pi-botao-carregamento:
RUN esp/cxp/escxp002.w. 

END PROCEDURE.
