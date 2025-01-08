/***********************************************************************
**  Programa..: UPC\ft0312-UPC.P
**  Autor.....: Anderson Cenci
**  Data......: Mar‡o/2010 - Desenvolvimento
**  Descricao.: 
**  VersÆo....: 001 01/03/2010
**                  Desenvolvimento Programa
************************************************************************/
DEF input param p-ind-event        as char          no-undo.
DEF input param p-ind-object       as char          no-undo.
DEF input param p-wgh-object       as handle        no-undo.
DEF input param p-wgh-frame        as widget-handle no-undo.
DEF input param p-cod-table        as char          no-undo.
DEF input param p-row-table        as rowid         no-undo.
DEF BUFFER b-nota-fiscal FOR nota-fiscal.

{cdp/cdcfgdis.i}
{utp/ut-glob.i}

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR wgh-grupo AS WIDGET-HANDLE   NO-UNDO.
DEF VAR d-peso-cubado AS DEC         NO-UNDO.
DEF VAR d-peso-cubado-cd1117  AS DEC NO-UNDO.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Námero" column-label "Námero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistªncia".

def NEW GLOBAL SHARED var wh-browse         as handle        no-undo.
def new global shared var wh-query          as widget-handle no-undo.
def new global shared var h-objeto          as widget-handle no-undo.
def new global shared var wh-buffer         as widget-handle no-undo.

def new global shared var h-objeto-window   as widget-handle no-undo.

DEFINE NEW GLOBAL SHARED temp-table tt-ped-curva
    field it-codigo   as char format 'x(16)' label "item"
    field codigo      AS CHARACTER FORMAT "x(20)" 
    field desc-conta  AS CHARACTER FORMAT "x(32)" 
    FIELD ccusto      AS CHARACTER FORMAT "x(20)" 
    FIELD desc-centro AS CHARACTER FORMAT "x(32)" 
    field serie       like it-nota-fisc.serie
    field nr-nota-fis like it-nota-fisc.nr-nota-fis
    field cont        as int
    field dec-1       as dec format '>>>>>>>>>>>9.99'
    field vl-credito  as dec format '>>>>>>>>>>>9.99' label 'Crýdito'
    field vl-debito   as dec format '>>>>>>>>>>>9.99' label 'Dýbito'
    &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN
    FIELD cod-unid-negoc LIKE unid-negoc.cod-unid-negoc
    &ENDIF.
    
define variable h-campo as handle  extent 10   no-undo.

DEF VAR c-desc-centro AS CHAR NO-UNDO.
def var h_api_ccust         as handle no-undo.

ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

DEFINE NEW GLOBAL SHARED VARIABLE h-upc-ft0904        AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-atendente-ft0904      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-atendente-ft0904      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-atendente-ft0904 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-grupo-cliente-ft0904  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-grupo-cliente-ft0904  AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-data-prev-ft0904      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-data-prev-ft0904      AS WIDGET-HANDLE NO-UNDO.

/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table) SKIP */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */
  

/**************************************************************************************/
/***************************** ft0904-upcnfse.p ***************************************/
/**************************************************************************************/
DEF NEW GLOBAL SHARED VAR adm-broker-hdl    AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-folder          AS HANDLE        NO-UNDO.                                 
DEF NEW GLOBAL SHARED VAR h-handle          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-sea_ft0904  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label-3_ft0904 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-Ccusto_ft0904  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label-4_ft0904 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-Solic_ft0904   AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-label_ft0904-peso-cub AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-peso-cub_ft0904       AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-bt-carta-correc-ft0904 AS WIDGET-HANDLE NO-UNDO.
 
DEF NEW GLOBAL SHARED VAR wh-data-ft0904 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-data-ft0904-2 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-data-ft0904 AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-hr-entr-real-ft0904 AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-bt-cfg-trib-ft0904 AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR r-nota-fiscal_ft0502 AS ROWID      NO-UNDO.

 {cdp/cdcfgdis.i}   
 {upc/ft0904-upc.i} 

DEF VAR c-folder         AS CHARACTER     NO-UNDO.                                                      
DEF VAR h_upc-ft0904-b01 AS HANDLE        NO-UNDO.
DEF VAR i-objeto         AS INTEGER       NO-UNDO.
DEF VAR h-query          AS HANDLE        NO-UNDO.
DEF VAR c-handle-obj     AS CHARACTER     NO-UNDO.


ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/"). 

IF  c-objeto = "v02di135.w":U      
AND p-ind-event = "BEFORE-DISPLAY" THEN DO:

    FOR FIRST nota-fiscal
        WHERE ROWID(nota-fiscal) = p-row-table NO-LOCK:

        ASSIGN r-nota-fiscal_ft0502 = ROWID(nota-fiscal).

    END.
END.

IF  c-objeto = "v02di135.w":U  AND
    p-ind-event = "INITIALIZE" THEN DO:

    ASSIGN c-handle-obj = fc-handle-obj("c-desc-sit",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).

    IF  VALID-HANDLE(h-handle) THEN
        h-handle:WIDTH = h-handle:WIDTH - 1.1.

    /*Reposicionar campos para 206 em diante*/
    
    /*Estabelecimento da nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("cod-estabel",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 3
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 3.

    /*Serie da nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("serie",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 3
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 3.

    /*Numero da nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("nr-nota-fis",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 3
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 3.

    /*Situacao nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("c-desc-sit",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 8
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 8.
    
    /*Data emissao nota fiscal*/
    ASSIGN c-handle-obj = fc-handle-obj("dt-emis-nota",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 8
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 8.
    
    /*Codigo do cliente*/
    ASSIGN c-handle-obj = fc-handle-obj("i-cod-emitente",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 8
               h-handle:SIDE-LABEL-HANDLE:COL = h-handle:SIDE-LABEL-HANDLE:COL - 8.
    
    /*Nome do cliente*/
    ASSIGN c-handle-obj = fc-handle-obj("nome-ab-cli",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).
    IF  VALID-HANDLE(h-handle) THEN
        ASSIGN h-handle:COL = h-handle:COL - 8.

END.
/**************************************************************************************/
/**************************************************************************************/
/**************************************************************************************/


if  p-ind-event  = "DESTROY" THEN
    DELETE PROCEDURE h-upc-ft0904.

IF  p-ind-event  = "INITIALIZE":U 
AND c-objeto = "ft0904.w" THEN DO:
    IF NOT VALID-HANDLE(h-upc-ft0904) THEN DO:
        RUN upc/ft0904-upc.p PERSISTENT SET h-upc-ft0904 (INPUT "",
                                                          INPUT "",
                                                          INPUT p-wgh-object,
                                                          INPUT p-wgh-frame,
                                                          INPUT "",
                                                          INPUT p-row-table).
    END.

    RUN busca-handle(INPUT p-wgh-frame ,
                     INPUT "bt-cfg-trib",
                     OUTPUT wh-bt-cfg-trib-ft0904). 
    
    CREATE BUTTON wh-bt-carta-correc-ft0904
    ASSIGN FRAME       = wh-bt-cfg-trib-ft0904:FRAME
           WIDTH       = wh-bt-cfg-trib-ft0904:WIDTH
           HEIGHT      = wh-bt-cfg-trib-ft0904:HEIGHT
           LABEL       = wh-bt-cfg-trib-ft0904:LABEL
           ROW         = wh-bt-cfg-trib-ft0904:ROW
           COL         = 28
           TOOLTIP     = "Carta de Corre‡Æo"
           FLAT-BUTTON = wh-bt-cfg-trib-ft0904:FLAT-BUTTON
           VISIBLE     = YES
           SENSITIVE   = YES.
    ON "CHOOSE" OF wh-bt-carta-correc-ft0904 PERSISTENT RUN pi-bt-carta IN h-upc-ft0904.

    wh-bt-carta-correc-ft0904:LOAD-IMAGE ('image/im-clr1.bmp').
    wh-bt-carta-correc-ft0904:MOVE-TO-TOP().
    
END.
IF  p-ind-event  = "INITIALIZE":U  AND
    p-ind-object = "VIEWER"        AND
    c-objeto     = "v03di135.w"    THEN DO:

    /*ASSIGN p-wgh-frame:WIDTH = p-wgh-frame:WIDTH + 6.*/
    CREATE TEXT tx-atendente-ft0904
                ASSIGN FRAME        = p-wgh-frame
                       FORMAT       = "x(14)"
                       WIDTH        = 12
                       SCREEN-VALUE = "Atend.:"
                       ROW          = 6.40 /*11.40*/
                       COL          = 61.95 /*47*/
                       VISIBLE      = YES.

    CREATE TEXT tx-grupo-cliente-ft0904
                ASSIGN FRAME        = p-wgh-frame
                       FORMAT       = "x(14)"
                       WIDTH        = 12
                       SCREEN-VALUE = "Grupo Cli.:"
                       ROW          = 7.40 
                       COL          = 64.95 
                       VISIBLE      = YES.

    CREATE FILL-IN wh-grupo-cliente-ft0904
                ASSIGN FRAME             = p-wgh-frame
                       DATA-TYPE         = "integer"
                       FORMAT            = ">>9"
                       WIDTH             = 3.00
                       HEIGHT            = 0.88
                       ROW               = 7.25 /*11.33*/
                       COL               = 71.95 /*55*/
                       VISIBLE           = YES
                       SENSITIVE         = NO.
    
    CREATE FILL-IN  wh-atendente-ft0904
                ASSIGN FRAME             = p-wgh-frame
                       DATA-TYPE         = "integer"
                       FORMAT            = ">>9"
                       WIDTH             = 3.5
                       HEIGHT            = 0.88
                       ROW               = 6.25 /*11.33*/
                       COL               = 72 /*55*/
                       VISIBLE           = YES
                       SENSITIVE         = NO.

    CREATE FILL-IN  wh-nome-atendente-ft0904
                ASSIGN FRAME             = p-wgh-frame
                       FORMAT            = "x(15)"
                       WIDTH             = 11
                       HEIGHT            = 0.88
                       ROW               = 6.25 /*11.33*/
                       COL               = 66.95 /*60*/
                       VISIBLE           = YES
                       SENSITIVE         = NO.    
    
END.

IF  p-ind-event  = "BEFORE-DISPLAY":U  AND
    p-ind-object = "VIEWER" AND
    c-objeto     = "v03di135.w" THEN DO:

    RUN busca-handle(INPUT p-wgh-frame ,
                     INPUT "dt-entr-cli",
                     OUTPUT wh-data-ft0904). 
 
    RUN busca-handle(INPUT p-wgh-frame ,
                     INPUT "hr-entr-real",
                     OUTPUT wh-hr-entr-real-ft0904). 

    IF NOT VALID-HANDLE(wh-data-prev-ft0904) THEN DO:
        
        CREATE FILL-IN wh-data-prev-ft0904
            ASSIGN FRAME      = p-wgh-frame
            DATA-TYPE         = "CHARACTER"
            FORMAT            = "x(10)"
            WIDTH             = wh-data-ft0904:WIDTH  
            HEIGHT            = wh-data-ft0904:HEIGHT 
            ROW               = wh-data-ft0904:ROW    
            COL               = wh-data-ft0904:COLUMN 
            VISIBLE           = YES
            SENSITIVE         = NO. 

        CREATE FILL-IN wh-data-ft0904-2 
            ASSIGN FRAME = p-wgh-frame
            DATA-TYPE  = "DATE"
            FORMAT     = "99/99/9999" 
            WIDTH      = 9.57    
            HEIGHT     = 0.88    
            ROW        = 9.23    
            COL        = 31.00
            VISIBLE    = YES     
            SENSITIVE  = NO.
         
         CREATE TEXT tx-data-ft0904
             ASSIGN FRAME = p-wgh-frame
             FORMAT       = "x(20)"
             WIDTH        = 14
             SCREEN-VALUE = "Dt Prevista/Entrega:"
             ROW          = 9.38 
             COL          = 6.00 
             VISIBLE      = YES.

         ASSIGN wh-data-ft0904:VISIBLE = NO
                wh-hr-entr-real-ft0904:VISIBLE = NO.
 
    END.   

    IF  p-row-table <> ? THEN DO:
        FIND FIRST nota-fiscal
             WHERE rowid(nota-fiscal) = p-row-table NO-LOCK NO-ERROR.

        FIND FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR. 

        IF AVAIL nota-fiscal THEN DO:
            IF  VALID-HANDLE(wh-atendente-ft0904)      AND
                VALID-HANDLE(wh-nome-atendente-ft0904)    THEN DO:
                
                
                IF nota-fiscal.nr-pedcli <> "" THEN DO:

                    FIND int-nota-fiscal NO-LOCK
                         WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                           AND int-nota-fiscal.serie       = nota-fiscal.serie
                           AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
                    
                    IF AVAIL int-nota-fiscal AND SUBSTRING(int-nota-fiscal.char-1,28,2) <> "" THEN DO:
                        
                        FIND FIRST atendente
                              WHERE atendente.cd-oper = int(SUBSTRING(int-nota-fiscal.char-1,28,2)) NO-LOCK NO-ERROR.
                   
                    END. /* IF AVAIL INT-nota-fiscal AND SUBSTRING(int-nota-fiscal.char-1,28,2) <> "" THEN DO: */
                    ELSE DO:
                        
                        FIND ped-venda
                            WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli  
                              AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR.
                        IF AVAIL ped-venda THEN DO:

                            FIND FIRST atendente
                                WHERE atendente.cd-oper = int(ped-venda.tp-pedido) NO-LOCK NO-ERROR.

                        END. /* IF AVAIL ped-venda THEN DO: */

                        
                    END. /* IF NOT AVAIL INT-nota-fiscal AND SUBSTRING(int-nota-fiscal.char-1,28,2) <> "" THEN DO: */

                    IF AVAIL atendente THEN
                        ASSIGN wh-atendente-ft0904:SCREEN-VALUE      = STRING(atendente.cd-oper)
                               wh-nome-atendente-ft0904:SCREEN-VALUE = atendente.nm-oper.
                               
                    ELSE 
                        ASSIGN wh-atendente-ft0904:SCREEN-VALUE      = ""
                               wh-nome-atendente-ft0904:SCREEN-VALUE = "".

                    IF AVAIL emitente THEN
                        ASSIGN wh-grupo-cliente-ft0904:SCREEN-VALUE  = STRING(emitente.cod-gr-cli).
                                   
                    ELSE
                        ASSIGN wh-grupo-cliente-ft0904:SCREEN-VALUE  = "".
                        
                   
                END. /*IF nota-fiscal.nr-pedcli <> "" THEN DO: */
                ELSE IF nota-fiscal.nr-pedcli  = "" THEN DO: 
                    ASSIGN wh-atendente-ft0904:SCREEN-VALUE      = ""
                           wh-nome-atendente-ft0904:SCREEN-VALUE = ""
                           wh-grupo-cliente-ft0904:SCREEN-VALUE  = "".
                END.
                
                FIND int-nota-fiscal NO-LOCK
                    WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                      AND int-nota-fiscal.serie       = nota-fiscal.serie
                      AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR. 

                IF AVAIL int-nota-fiscal THEN
                    ASSIGN wh-data-prev-ft0904:SCREEN-VALUE = SUBSTRING(int-nota-fiscal.char-1,50,10).
                ELSE
                    ASSIGN 
                           wh-data-prev-ft0904:SCREEN-VALUE = "".

                IF VALID-HANDLE(wh-data-ft0904-2) THEN DO:
                    ASSIGN wh-data-ft0904-2:SCREEN-VALUE = STRING(nota-fiscal.dt-entr-cli).
                END.
                ELSE DO:
                    ASSIGN wh-data-ft0904-2:SCREEN-VALUE  = "".
                END. 
            END.
        END.
    END.

/*     IF VALID-HANDLE(h-objeto-window) THEN DO:         */
/*         RUN select-page IN h-objeto-window (INPUT 1). */
/*     END.                                              */
END.

IF  p-ind-event   = 'after-value-changed'
AND p-ind-object  = 'browser'
AND p-cod-table   = 't-conta'
AND c-objeto      = 'b29in090.w' THEN DO:

    ASSIGN c-handle-obj = ''
           h-handle     = ?
           c-handle-obj = fc-handle-obj("bt-param",p-wgh-frame)
           h-handle     = WIDGET-HANDLE(ENTRY(1,c-handle-obj)).

    CREATE TEXT tx-label-4_ft0904
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "X(16)"
           VISIBLE      = yes
           ROW          = h-handle:ROW
           COL          = h-handle:COL + 15
           WIDTH        = h-handle:WIDTH 
           HEIGHT       = 0.75
           FONT         = 1
           SCREEN-VALUE = "Solicitacao NF:".

    CREATE FILL-IN wh-Solic_ft0904
    ASSIGN FRAME     = p-wgh-frame
           format    = "x(10)"
           WIDTH     = h-handle:WIDTH 
           HEIGHT    = 0.88
           ROW       = h-handle:ROW    
           COL       = h-handle:COL + 25
           FGCOLOR   = 12
           SIDE-LABEL-HANDLE = tx-label-4_ft0904:HANDLE
           VISIBLE   = YES
           SENSITIVE = NO.

    CREATE TEXT tx-label-3_ft0904
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "X(7)"
           VISIBLE      = yes
           ROW          = h-handle:ROW
           COL          = h-handle:COL + 41
           WIDTH        = h-handle:WIDTH + 2
           HEIGHT       = 0.75
           FONT         = 1
           SCREEN-VALUE = "Ccusto:".

    CREATE FILL-IN wh-ccusto_ft0904
    ASSIGN FRAME     = p-wgh-frame
           format    = "x(12)"
           WIDTH     = h-handle:WIDTH + 2
           HEIGHT    = 0.88
           ROW       = h-handle:ROW    
           COL       = h-handle:COL + 46
           FGCOLOR   = 12
           SIDE-LABEL-HANDLE = tx-label-3_ft0904:HANDLE
           VISIBLE   = YES
           SENSITIVE = NO.

    CREATE TEXT tx-label_ft0904-peso-cub
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "X(7)"
           VISIBLE      = yes
           ROW          = h-handle:ROW
           COL          = h-handle:COL + 63
           WIDTH        = h-handle:WIDTH + 2
           HEIGHT       = 0.75
           FONT         = 1
           SCREEN-VALUE = "Peso Cub:".

    CREATE FILL-IN wh-peso-cub_ft0904
    ASSIGN FRAME     = p-wgh-frame
           format    = "x(10)"
           WIDTH     = h-handle:WIDTH + 2
           HEIGHT    = 0.88
           ROW       = h-handle:ROW    
           COL       = h-handle:COL +  68
           FGCOLOR   = 12
           TOOLTIP   = "Peso Cubado"
           SIDE-LABEL-HANDLE = tx-label_ft0904-peso-cub:HANDLE
           VISIBLE   = YES
           SENSITIVE = NO.

    
    IF  VALID-HANDLE(wh-ccusto_ft0904)
    AND VALID-HANDLE(wh-Solic_ft0904) THEN
        ASSIGN wh-ccusto_ft0904:SCREEN-VALUE = ""
               wh-Solic_ft0904 :SCREEN-VALUE = "".

    FIND FIRST nota-fiscal
        WHERE ROWID(nota-fiscal) = r-nota-fiscal_ft0502 NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:

        FIND FIRST ped-fiscal
            WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
              AND ped-fiscal.serie       = nota-fiscal.serie      
              AND ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
        IF AVAIL ped-fiscal THEN DO:

            ASSIGN wh-ccusto_ft0904:SCREEN-VALUE = ped-fiscal.sc-codigo
                   wh-Solic_ft0904 :SCREEN-VALUE = string(ped-fiscal.nr-pedido).

        END.
    END.

    IF VALID-HANDLE(wh-peso-cub_ft0904) THEN DO:

        ASSIGN d-peso-cubado = 0.
        FIND FIRST nota-fiscal
             WHERE ROWID(nota-fiscal) = r-nota-fiscal_ft0502 NO-LOCK NO-ERROR.
        IF AVAIL nota-fiscal THEN DO:

            FOR EACH it-nota-fisc OF nota-fisca NO-LOCK:
                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                
                IF AVAIL ITEM THEN DO:
                    FIND FIRST fat-ser-lote OF it-nota-fisc NO-ERROR.
           
                    IF ITEM.cod-unid-negoc = "ENS" AND AVAIL fat-ser-lote AND fat-ser-lote.cod-depos = "FAT" THEN DO:
                        for each volume-nf of nota-fiscal no-lock:
                           FIND FIRST embalag NO-LOCK
                                WHERE embalag.sigla-emb = volume-nf.sigla-emb NO-ERROR.
                           if avail embalag then 
                              assign d-peso-cubado = d-peso-cubado + (embalag.volume) .  
                        end. 
                    END.
                    ELSE DO:
                       FOR FIRST volume-nf OF nota-fiscal
                            WHERE volume-nf.it-codigo = it-nota-fisc.it-codigo NO-LOCK:

                             ASSIGN d-peso-cubado-cd1117 = 0.
                             FIND FIRST ITEM-caixa NO-LOCK
                                  WHERE item-caixa.it-codigo = volume-nf.it-codigo NO-ERROR.
                             IF AVAIL item-caixa THEN 
                                 ASSIGN d-peso-cubado-cd1117 = it-nota-fisc.qt-faturada[1] / item-caixa.qt-item.
                          
                             FIND FIRST embalag NO-LOCK
                                  WHERE embalag.sigla-emb = volume-nf.sigla-emb NO-ERROR.
                             if avail embalag then 
                                 ASSIGN d-peso-cubado = d-peso-cubado + ( ((embalag.altura / 1000) * (embalag.largura / 1000) * (embalag.comprim / 1000)) * d-peso-cubado-cd1117).
                                 //ASSIGN d-peso-cubado = d-peso-cubado + ( ((item.altura / 1000) * (item.largura / 1000) * (item.comprim / 1000)) * it-nota-fisc.qt-faturada[1]).
                        END.
                    END.
                END.
            END.
            ASSIGN wh-peso-cub_ft0904:SCREEN-VALUE = string(d-peso-cubado).
        END.
    END.


END.

IF  p-ind-event   = 'AFTER-OPEN-QUERY'
AND p-ind-object  = 'browser'
AND p-cod-table   = 't-conta'
AND c-objeto      = 'b29in090.w' THEN DO:

    IF  VALID-HANDLE(wh-ccusto_ft0904)
    AND VALID-HANDLE(wh-Solic_ft0904) THEN
        ASSIGN wh-ccusto_ft0904:SCREEN-VALUE = ""
               wh-Solic_ft0904 :SCREEN-VALUE = "".


    FIND FIRST nota-fiscal
        WHERE ROWID(nota-fiscal) = r-nota-fiscal_ft0502 NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:

        FIND FIRST ped-fiscal
            WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
              AND ped-fiscal.serie       = nota-fiscal.serie      
              AND ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
        IF AVAIL ped-fiscal THEN DO:

            IF  VALID-HANDLE(wh-ccusto_ft0904)
            AND VALID-HANDLE(wh-Solic_ft0904) THEN
                ASSIGN wh-ccusto_ft0904:SCREEN-VALUE = ped-fiscal.sc-codigo
                       wh-Solic_ft0904 :SCREEN-VALUE = string(ped-fiscal.nr-pedido).

        END.
    END.

    IF VALID-HANDLE(wh-peso-cub_ft0904) THEN DO:
        ASSIGN d-peso-cubado = 0.
        FIND FIRST nota-fiscal
             WHERE ROWID(nota-fiscal) = r-nota-fiscal_ft0502 NO-LOCK NO-ERROR.
        IF AVAIL nota-fiscal THEN DO:

            FOR EACH it-nota-fisc OF nota-fisca NO-LOCK:
                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.
                
                IF AVAIL ITEM THEN DO:
                    FIND FIRST fat-ser-lote OF it-nota-fisc NO-ERROR.
           
                    IF ITEM.cod-unid-negoc = "ENS" AND AVAIL fat-ser-lote AND fat-ser-lote.cod-depos = "FAT" THEN DO:
                        for each volume-nf of nota-fiscal no-lock:
                           FIND FIRST embalag NO-LOCK
                                WHERE embalag.sigla-emb = volume-nf.sigla-emb NO-ERROR.
                           if avail embalag then 
                              assign d-peso-cubado = d-peso-cubado + (embalag.volume) .  
                        end. 
                    END.
                    ELSE
                        ASSIGN d-peso-cubado = d-peso-cubado + ( ((item.altura / 100) * (item.largura / 100) * (item.comprim / 100)) * it-nota-fisc.qt-faturada[1]).
                END.
            END.
            ASSIGN wh-peso-cub_ft0904:SCREEN-VALUE = string(d-peso-cubado).
        END.
    END.
END.

IF  p-ind-event = "BEFORE-OPEN-QUERY":U  AND
    p-ind-object = "BROWSER" AND
    c-objeto = "b32di135.w" THEN DO:

    IF  NOT VALID-HANDLE(h_api_ccust) THEN
        run prgint/utb/utb742za.py persistent set h_api_ccust.

    FIND FIRST nota-fiscal
        WHERE ROWID(nota-fiscal) = r-nota-fiscal_ft0502 NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        
       
        FOR EACH tt-ped-curva.
            IF tt-ped-curva.ccusto <> '' THEN DO:
               FIND FIRST int-unid-neg-natur NO-LOCK
                    WHERE int-unid-neg-natur.cod-estabel  = nota-fiscal.cod-estabel
                      AND int-unid-neg-natur.cod-unid-neg = tt-ped-curva.cod-unid-neg
                      AND int-unid-neg-natur.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.          
    
                 IF  AVAIL int-unid-neg-natur THEN DO:
                     FIND FIRST centro-custo
                         WHERE cc-codigo = int-unid-neg-natur.sc-codigo NO-LOCK NO-ERROR.
                     IF AVAIL centro-custo THEN 
                         ASSIGN tt-ped-curva.desc-centro = centro-custo.descricao.
                    
                     ASSIGN tt-ped-curva.ccusto = int-unid-neg-natur.sc-codigo.
                 END.
            END.
        END.

        FIND FIRST ped-fiscal
             WHERE ped-fiscal.cod-estabel = nota-fiscal.cod-estabel
               AND ped-fiscal.serie       = nota-fiscal.serie      
               AND ped-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
        IF  AVAIL ped-fiscal THEN DO:
           FOR EACH tt-ped-curva:

                IF tt-ped-curva.ccusto <> "" THEN DO:

                    ASSIGN tt-ped-curva.ccusto = ped-fiscal.sc-codigo.

                    run pi_busca_dados_ccusto in h_api_ccust (input  i-ep-codigo-usuario,          /* EMPRESA EMS2 */
                                                      input  "",                 /* CODIGO DO PLANO CCUSTO */
                                                      input  ped-fiscal.sc-codigo,/* CCUSTO */
                                                      input  IF nota-fiscal.dt-confirma <> ? THEN nota-fiscal.dt-confirma ELSE TODAY,           /* DATA DE TRANSACAO */
                                                      output c-desc-centro,       /* DESCRICAO DO CCUSTO */
                                                      output table tt_log_erro). /* ERROS */ 
                    IF RETURN-VALUE = "OK" THEN
                       ASSIGN tt-ped-curva.desc-centro = c-desc-centro.

                    ASSIGN c-desc-centro = "".

                END.
            END.
        END.
    END.

    IF  VALID-HANDLE(h_api_ccust) THEN
        DELETE PROCEDURE h_api_ccust.
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

PROCEDURE busca-handle:
    
    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

        DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.


        /* Frame Principal */
        ASSIGN h-aux = p-wgh-frame.

        /* field-group */
        ASSIGN h-aux = h-aux:FIRST-CHILD.

        /* Primeiro componente da Frame */
        ASSIGN h-aux = h-aux:FIRST-CHILD.

        REPEAT:

            IF h-aux:NAME <> p-nome-obj THEN DO:

                ASSIGN h-aux = h-aux:NEXT-SIBLING.
                IF NOT VALID-HANDLE(h-aux) THEN DO:
                    ASSIGN p-handl-obj = ?.
                    LEAVE.
                END.
            END.
            ELSE DO:
                ASSIGN p-handl-obj = h-aux.
                LEAVE.
            END. 
        
        END.

END. 

PROCEDURE pi-bt-carta:
    DEFINE VARIABLE h-ft0909f AS HANDLE      NO-UNDO.

     FIND FIRST nota-fiscal
          WHERE ROWID(nota-fiscal) = r-nota-fiscal_ft0502 NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        RUN ftp/ft0909f.w PERSISTENT SET h-ft0909f (INPUT ROWID(nota-fiscal), INPUT 2).
        IF  VALID-HANDLE(h-ft0909f) THEN
            RUN initializeInterface IN h-ft0909f.
    
        if valid-handle(h-ft0909f) then
             wait-for close of h-ft0909f.                            
    
        IF VALID-HANDLE(h-ft0909f) THEN DO:
           DELETE PROCEDURE h-ft0909f.
           ASSIGN h-ft0909f = ?.
        END.
    END.
END.
