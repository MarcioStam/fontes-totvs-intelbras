/* ---------------------------------------------------------------------------
Programa : ft4003b-upc.p
Funcao   : Validar e alertar caso n∆o seja informado o n£mero de volumes
Autor    : Giovane Oliveira
Data     : 08/2007
Alteraá∆o:
--------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER p-ind-event      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object     AS HANDLE           NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame      AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER p-row-table      AS ROWID            NO-UNDO.

DEFINE VARIABLE i-cod-mensagem AS INTEGER     NO-UNDO.
/* Variable Definitions *****************************************************/
define var c-folder                as character no-undo.
define var c-objects               as character no-undo.
define var h-object                as handle    no-undo.
define var i-objects               as integer   no-undo.
define var l-record                as logical   no-undo initial no.
define var l-group-assign          as logical   no-undo initial no.
define var l-state                 as logical   no-undo initial no.
define var h-frame                 as widget-handle no-undo. DEF VAR c-objeto   AS CHAR     NO-UNDO.
DEFINE VAR var-c-cod-modalid-frete AS CHARACTER   NO-UNDO.
/*{esp\ShowMsg.i}*/
{utp/ut-glob.i}

def var i-nr-volumes as int no-undo.
def var l-msg as logi no-undo.
assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").

/*MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table) SKIP
        "Objeto " c-objeto     SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

DEF NEW GLOBAL SHARED VAR vAtualizaNfSeparada   AS LOG NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtExecutarUpc       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR whBtExecutarTela      AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-fpage0                            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fpage1                            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fpage2                            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-integrador                        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-integrador                        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fpage3-ft4003b-upc                AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fpage4-ft4003b-upc                AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-ft4003b-upc                        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-transp-ft4003-upc            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nome-transp-aux-ft4003-upc        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-nome-transp-ft4003-upc            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-desc-transp-ft4003-upc          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-c-cod-modalidad-frete-ft4003b-upc AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vl-embalagem-inf-ft4003-upc       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-canal-venda-upc               AS WIDGET-HANDLE NO-UNDO. 
DEF NEW GLOBAL SHARED VAR wh-bt-ok-ft4003a-upc                 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-ok-ft4003a-upc-new             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nat-operacao-ft4003b-upc          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-volume-inf-ft4003-upc          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-volume-inf-aux-ft4003-upc      AS WIDGET-HANDLE NO-UNDO.
 
DEFINE VARIABLE h-objeto AS HANDLE NO-UNDO.


IF p-ind-event = "BEFORE-ASSIGN" AND p-ind-object = "CONTAINER" THEN DO:

    IF VALID-HANDLE(wh-nat-operacao-ft4003b-upc) THEN DO:

        FIND FIRST usuar-nat-operacao
            WHERE usuar-nat-operacao.cod-usuario           = v_cod_usuar_corren
            AND   wh-nat-operacao-ft4003b-upc:SCREEN-VALUE BEGINS usuar-nat-operacao.nat-operacao NO-LOCK NO-ERROR.

        IF NOT AVAIL usuar-nat-operacao THEN DO:

            FIND FIRST usuar-nat-operacao
                WHERE usuar-nat-operacao.cod-usuario  = v_cod_usuar_corren
                AND   usuar-nat-operacao.nat-operacao = "*" NO-LOCK NO-ERROR.

            IF NOT AVAIL usuar-nat-operacao THEN DO:

                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17567,
                                   INPUT "Solicite para o grupo.fiscal liberaá∆o da natureza de operaá∆o " + wh-nat-operacao-ft4003b-upc:SCREEN-VALUE + " para o usu†rio: " + v_cod_usuar_corren + "." ).
                RETURN ERROR.
            END.
        END.
    END.
END.


IF p-ind-event = "AFTER-save-fields" AND VALID-HANDLE(wh-integrador) THEN DO:

    FIND FIRST wt-docto NO-LOCK                        
        WHERE ROWID(wt-docto) = p-row-table NO-ERROR.  
    IF  NOT AVAIL wt-docto THEN                            
        RETURN "OK".                                   
   
    FIND int-wt-docto                                            
         WHERE int-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto 
         EXCLUSIVE-LOCK NO-ERROR.                                
    IF NOT AVAIL INT-wt-docto THEN DO:                           
        CREATE int-wt-docto.                                     
        ASSIGN int-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto.
    END.

    IF valid-handle(wh-integrador) THEN
        ASSIGN int-wt-docto.integrador = wh-integrador:SCREEN-VALUE.
END.


IF p-ind-event = "AFTER-INITIALIZE" AND p-ind-object = "CONTAINER"  THEN DO:

    /*RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "nat-operacao",
                     OUTPUT wh-nat-operacao-ft4003b-upc).*/

    IF  NOT VALID-HANDLE(h-ft4003b-upc) THEN
        RUN upc/ft4003b-upc.p PERSISTENT SET h-ft4003b-upc(INPUT "",
                                                           INPUT "",
                                                           INPUT p-wgh-object,
                                                           INPUT p-wgh-frame,
                                                           INPUT "",
                                                           INPUT p-row-table).

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-frame = h-frame:FIRST-CHILD.

    DO  WHILE VALID-HANDLE(h-frame):
        IF  h-frame:TYPE <> "field-group" THEN DO:
            CASE h-frame:NAME:
                WHEN "fpage1" THEN ASSIGN wh-fpage1             = h-frame.
                WHEN "fpage2" THEN ASSIGN wh-fpage2             = h-frame.
                WHEN "fpage3" THEN ASSIGN wh-fpage3-ft4003b-upc = h-frame.
                WHEN "fpage4" THEN ASSIGN wh-fpage4-ft4003b-upc = h-frame.
                WHEN "btOk"   THEN ASSIGN wh-bt-ok-ft4003a-upc  = h-frame.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.
    END.

    IF  VALID-HANDLE (p-wgh-frame) THEN DO:

        IF  VALID-HANDLE(wh-bt-ok-ft4003a-upc) THEN DO:
            CREATE BUTTON  wh-bt-ok-ft4003a-upc-new
                ASSIGN FRAME        = wh-bt-ok-ft4003a-upc:FRAME
                       WIDTH        = wh-bt-ok-ft4003a-upc:WIDTH
                       HEIGHT       = wh-bt-ok-ft4003a-upc:HEIGHT
                       ROW          = wh-bt-ok-ft4003a-upc:ROW
                       LABEL        = "OK"
                       COLUMN       = wh-bt-ok-ft4003a-upc:COLUMN
                       SENSITIVE    = YES
                       VISIBLE      = YES
                       TOOLTIP      = 'OK'
                    TRIGGERS:
                       ON CHOOSE PERSISTENT RUN pi-valida IN h-ft4003b-upc.
                    END TRIGGERS.
        END.
    END.

    IF  VALID-HANDLE(wh-fpage1) THEN DO:
        ASSIGN h-frame = wh-fpage1:FIRST-CHILD
               h-frame = h-frame:FIRST-CHILD.

        DO WHILE VALID-HANDLE (h-frame):
            IF h-frame:TYPE <> "field-group" THEN DO:
                CASE h-frame:NAME:
                    WHEN "cod-canal-venda" THEN ASSIGN wh-cod-canal-venda-upc      = h-frame.
                    WHEN "nat-operacao"    THEN ASSIGN wh-nat-operacao-ft4003b-upc = h-frame.
                END CASE.
            END.
            ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
        END.

        IF  VALID-HANDLE(wh-cod-canal-venda-upc) AND wh-cod-canal-venda-upc:SCREEN-VALUE = "12" THEN
            ASSIGN wh-cod-canal-venda-upc:SENSITIVE = NO.

    END.

    IF  VALID-HANDLE(wh-fpage2) THEN DO:
    
        CREATE TEXT tx-integrador
        ASSIGN FRAME        = wh-fpage2
               WIDTH        = 7.57
               FORMAT       = "x(14)"
               SCREEN-VALUE = "Integrador: "
    
               ROW          = 4.38
               COLUMN       = 61.29
    
               VISIBLE      = YES.
    
    
        CREATE FILL-IN wh-integrador
        ASSIGN FRAME        = wh-fpage2
               DATA-TYPE    = "CHARACTER"
               WIDTH        = 14.43
               HEIGHT       = 0.88
               FORMAT       = "x(12)"
               SCREEN-VALUE = ""
               ROW          = 4.26
               COLUMN       = 69
               SENSITIVE    = YES
               VISIBLE      = YES.


        FIND FIRST wt-docto NO-LOCK
            WHERE ROWID(wt-docto) = p-row-table NO-ERROR.
        IF  NOT AVAIL wt-docto THEN 
            RETURN "OK".

        FIND int-wt-docto
             WHERE int-wt-docto.seq-wt-docto = wt-docto.seq-wt-docto
             EXCLUSIVE-LOCK NO-ERROR.

        /* Verifica se foi informado no pedido */
        FIND FIRST ped-venda NO-LOCK
            WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
              AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli NO-ERROR.

        IF  AVAIL ped-venda THEN DO:
            FIND FIRST int-ped-venda NO-LOCK
                WHERE int-ped-venda.nr-pedido  = ped-venda.nr-pedido NO-ERROR.
    
            IF  AVAIL int-ped-venda AND substr(int-ped-venda.char-1, 41, 12) <> "" THEN
                ASSIGN wh-integrador:SCREEN-VALUE = substr(int-ped-venda.char-1, 41, 12)
                       wh-integrador:SENSITIVE = NO.
            ELSE
                IF  AVAIL int-wt-docto THEN
                    wh-integrador:SCREEN-VALUE = int-wt-docto.integrador.
                ELSE
                    wh-integrador:SCREEN-VALUE = "".
        END.
        ELSE
            IF  AVAIL int-wt-docto THEN
                wh-integrador:SCREEN-VALUE = int-wt-docto.integrador.
            ELSE
                wh-integrador:SCREEN-VALUE = "".
    
    END.

    ASSIGN h-objeto = p-wgh-object.

    DO WHILE VALID-HANDLE(h-objeto):
        IF h-objeto:FILE-NAME = "utp/thinFolder.w" THEN LEAVE.
        ASSIGN h-objeto = h-objeto:NEXT-SIBLING.
    END.

    RUN setFolder IN h-objeto (INPUT 1).


   /*********************************************************************************/

    IF  VALID-HANDLE (wh-fpage3-ft4003b-upc) THEN DO:
         ASSIGN h-frame = wh-fpage3-ft4003b-upc:FIRST-CHILD
                h-frame = h-frame:FIRST-CHILD.

         DO WHILE VALID-HANDLE (h-frame):
             IF h-frame:TYPE <> "field-group" THEN DO:
                 CASE h-frame:NAME:
                     WHEN "nome-transp" THEN
                         ASSIGN wh-nome-transp-ft4003-upc = h-frame.
                     WHEN "c-desc-transp" THEN
                         ASSIGN wh-c-desc-transp-ft4003-upc = h-frame.
                     WHEN "vl-embalagem-inf" THEN
                         ASSIGN wh-vl-embalagem-inf-ft4003-upc = h-frame.
                     /*WHEN "nr-volumes" THEN 
                         ASSIGN wh-nr-volume-inf-ft4003-upc = h-frame. */
                 END CASE.
             END.
             ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
         END.
     END.

     wh-nome-transp-ft4003-upc:SENSITIVE = NO.
     wh-nome-transp-ft4003-upc:VISIBLE   = NO.

    /* CREATE FILL-IN                   wh-nr-volume-inf-aux-ft4003-upc
     ASSIGN FRAME                   = wh-nr-volume-inf-ft4003-upc:FRAME
            DATA-TYPE               = wh-nr-volume-inf-ft4003-upc:DATA-TYPE
            WIDTH                   = wh-nr-volume-inf-ft4003-upc:WIDTH
            HEIGHT                  = wh-nr-volume-inf-ft4003-upc:HEIGHT
            FORMAT                  = wh-nr-volume-inf-ft4003-upc:FORMAT
            SCREEN-VALUE            = wh-nr-volume-inf-ft4003-upc:SCREEN-VALUE
            ROW                     = wh-nr-volume-inf-ft4003-upc:ROW
            COLUMN                  = wh-nr-volume-inf-ft4003-upc:COLUMN
           // SIDE-LABEL-HANDLE       = tx-nome-transp-ft4003-upc
            SENSITIVE               = NO. 

     IF VALID-HANDLE(wh-nr-volume-inf-aux-ft4003-upc) THEN 
        ASSIGN wh-nr-volume-inf-aux-ft4003-upc:SCREEN-VALUE = "0"
               wh-nr-volume-inf-ft4003-upc:SCREEN-VALUE = wh-nr-volume-inf-aux-ft4003-upc:SCREEN-VALUE. */


     CREATE TEXT                      tx-nome-transp-ft4003-upc     
     ASSIGN FRAME                   = wh-nome-transp-ft4003-upc:SIDE-LABEL-HANDLE:FRAME 
            WIDTH                   = wh-nome-transp-ft4003-upc:SIDE-LABEL-HANDLE:WIDTH 
            HEIGHT                  = wh-nome-transp-ft4003-upc:SIDE-LABEL-HANDLE:HEIGHT
            FORMAT                  = "x(12)"  
            SCREEN-VALUE            = "Transporte:"
            ROW                     = wh-nome-transp-ft4003-upc:SIDE-LABEL-HANDLE:ROW         
            COLUMN                  = wh-nome-transp-ft4003-upc:SIDE-LABEL-HANDLE:COLUMN + 3.6.
            
     CREATE FILL-IN                   wh-nome-transp-aux-ft4003-upc
     ASSIGN FRAME                   = wh-nome-transp-ft4003-upc:FRAME
            DATA-TYPE               = wh-nome-transp-ft4003-upc:DATA-TYPE
            WIDTH                   = wh-nome-transp-ft4003-upc:WIDTH
            HEIGHT                  = wh-nome-transp-ft4003-upc:HEIGHT
            FORMAT                  = wh-nome-transp-ft4003-upc:FORMAT
            SCREEN-VALUE            = wh-nome-transp-ft4003-upc:SCREEN-VALUE
            ROW                     = wh-nome-transp-ft4003-upc:ROW
            COLUMN                  = wh-nome-transp-ft4003-upc:COLUMN
            SIDE-LABEL-HANDLE       = tx-nome-transp-ft4003-upc
            SENSITIVE               = YES
            TRIGGERS:
                ON "LEAVE":U PERSISTENT RUN pi-leave-nome-transp IN h-ft4003b-upc.
                ON 'MOUSE-SELECT-DBLCLICK':U PERSISTENT RUN upc/ft4003b-upca.p.
                ON 'F5':U PERSISTENT RUN upc/ft4003b-upca.p.
            END TRIGGERS.
           
     wh-nome-transp-aux-ft4003-upc:LOAD-MOUSE-POINTER("image/lupa.cur":U).
     wh-nome-transp-aux-ft4003-upc:MOVE-AFTER-TAB-ITEM(wh-vl-embalagem-inf-ft4003-upc:HANDLE).

     IF VALID-HANDLE (wh-fpage4-ft4003b-upc) THEN DO:
          ASSIGN h-frame = wh-fpage4-ft4003b-upc:FIRST-CHILD
                 h-frame = h-frame:FIRST-CHILD.
    
          DO WHILE VALID-HANDLE (h-frame):
              IF h-frame:TYPE <> "field-group" THEN DO:
                  CASE h-frame:NAME:
                      WHEN "c-cod-modalid-frete" THEN
                          ASSIGN wh-c-cod-modalidad-frete-ft4003b-upc = h-frame.
                  END CASE.
              END.
             ASSIGN h-frame = h-frame:NEXT-SIBLING NO-ERROR.
          END.
      END.

       IF wh-c-cod-modalidad-frete-ft4003b-upc:SCREEN-VALUE = "1" THEN
          wh-c-cod-modalidad-frete-ft4003b-upc:SENSITIVE = NO.
END.

RETURN "OK".

PROCEDURE pi-leave-nome-transp:
   
    IF valid-handle(wh-c-cod-modalidad-frete-ft4003b-upc) THEN ASSIGN var-c-cod-modalid-frete = wh-c-cod-modalidad-frete-ft4003b-upc:SCREEN-VALUE.
    IF valid-handle(wh-nome-transp-aux-ft4003-upc)        THEN ASSIGN wh-nome-transp-ft4003-upc:SCREEN-VALUE = wh-nome-transp-aux-ft4003-upc:SCREEN-VALUE.
    
    APPLY "LEAVE" TO wh-nome-transp-ft4003-upc.


    IF  valid-handle(wh-nome-transp-ft4003-upc) 
    AND wh-nome-transp-ft4003-upc:SCREEN-VALUE = "RETIRA" THEN
        ASSIGN wh-c-cod-modalidad-frete-ft4003b-upc:SENSITIVE = NO
               wh-c-cod-modalidad-frete-ft4003b-upc:SCREEN-VALUE = "1".
    ELSE
        ASSIGN wh-c-cod-modalidad-frete-ft4003b-upc:SENSITIVE = YES
               wh-c-cod-modalidad-frete-ft4003b-upc:SCREEN-VALUE = var-c-cod-modalid-frete.

    APPLY "LEAVE" TO wh-c-cod-modalidad-frete-ft4003b-upc.

    RETURN "ok":U.

END PROCEDURE.

PROCEDURE pi-valida:

    IF  VALID-HANDLE (wh-cod-canal-venda-upc) 
    AND wh-cod-canal-venda-upc:SCREEN-VALUE = "12"
    AND wh-cod-canal-venda-upc:SENSITIVE THEN DO:
        RUN utp/ut-msgs ("show",
                         17006,
                         "Canal de venda 12 n∆o Ç permitido atravÇs deste programa. ").
        RETURN "OK".
    END.

    APPLY "choose" TO wh-bt-ok-ft4003a-upc.

END.

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
