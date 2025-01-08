/*------------------------------------------------------------------------
    File        : CD0140-UPC.P
    Purpose     : UPC do programa CD0140.
    Syntax      : <none>
    Description : <none>

    Created     : Maio de 2013
    Notes       : 001 - 02/05/2013 - Restriá∆o de alteraá∆o do campo
                  "Situaá∆o" (Fabiano Sakae Ribeiro - Exponencial TI).
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

/* Definiá∆o da temp-table "tt-prog-ponto" */
{esp/es0018.i}

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p-row-table  AS ROWID         NO-UNDO.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER   NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-objeto        AS CHARACTER     NO-UNDO.
DEFINE VARIABLE wh-objeto       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-fPage1       AS WIDGET-HANDLE NO-UNDO.
define variable wh-fPage-nova   as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh-cd-cod-obsol AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-unid-neg AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-txt-esp      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-observ-esp   AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h-objeto AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-tx-label-cd0140 AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE v-it-codigo   LIKE item-uni-estab.it-codigo   NO-UNDO.
DEFINE VARIABLE v-cod-estabel LIKE item-uni-estab.cod-estabel NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-log-antidump-esp-cd0140 AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-obs-antidump-cd0140  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-obs-antidumping-cd0140  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-origem-cd0140        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-codigo-orig-cd0140      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-cd0140-upc               AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-ressup-fabri-cd0140     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-res-for-comp-cd0140     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-res-cq-fabri-cd0140     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-res-int-comp-cd0140     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-motivo-situacao-cd0140  AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-cd0140     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-bt-ok-cd0140 AS WIDGET-HANDLE NO-UNDO.

define variable wh-fPage-seop   as widget-handle no-undo.
DEF NEW GLOBAL SHARED VAR wh-log-planejamento-vendas-cd0140 AS WIDGET-HANDLE NO-UNDO.



def new global shared var h-facelift as handle no-undo.

/* ***************************  Main Block  *************************** */

/* Identificar o objeto de tela */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).

/*Mensagem para verificar o ponto UPC do programa*/
/* OUTPUT TO c:/temp/eventos-cd0140.txt NO-CONVERT APPEND. */
/* PUT UNFORMATTED                                         */
/*         "Evento....: ":U   p-ind-event      SPACE(10)   */
/*         "Objeto....: ":U   p-ind-object     SPACE(10)   */
/*         "Nome Obj..: ":U   c-objeto         SPACE(10)   */
/*         "Frame.....: ":U   p-wgh-frame:NAME SPACE(10)   */
/*         "Tabela....: ":U   p-cod-table      SPACE(10)   */
/*         "Rowid.....: ":U   STRING(p-row-table) SKIP.    */
/* OUTPUT CLOSE.                                           */

/**************************** UPC inclus∆o campo Observaá∆o ************************************/
If  p-ind-event = "AFTER-DISPLAY" THEN DO:
    DO:
        ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD.
        ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        DO  WHILE VALID-HANDLE(wh-objeto):
            IF  wh-objeto:TYPE <> "field-group" THEN DO:
                IF  wh-objeto:NAME = "it-codigo" THEN DO:
                    ASSIGN v-it-codigo = wh-objeto:SCREEN-VALUE.
                END.
                IF  wh-objeto:NAME = "cod-estabel" THEN DO:
                    ASSIGN v-cod-estabel = wh-objeto:SCREEN-VALUE.
                END.
                ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
            END.
            ELSE DO:
                LEAVE.
            END.
        END.
    END.
    
    IF  VALID-HANDLE(wh-log-antidump-esp-cd0140) AND
        VALID-HANDLE(wh-obs-antidumping-cd0140) THEN DO:
        FIND FIRST int-item NO-LOCK
             WHERE int-item.it-codigo = v-it-codigo NO-ERROR.
        IF AVAIL int-item THEN
            ASSIGN wh-log-antidump-esp-cd0140:CHECKED     = int-item.log-antidumping
                   wh-obs-antidumping-cd0140:SCREEN-VALUE = int-item.obs-antidumping.
        ELSE
            ASSIGN wh-log-antidump-esp-cd0140:CHECKED     = NO
                   wh-obs-antidumping-cd0140:SCREEN-VALUE = "".
    END.

    IF  VALID-HANDLE(wh-codigo-orig-cd0140) THEN DO:
        FIND FIRST int-item-uni-estab NO-LOCK
             WHERE int-item-uni-estab.it-codigo    = v-it-codigo  
               AND int-item-uni-estab.cod-estabel  = v-cod-estabel NO-ERROR.

        IF AVAIL int-item-uni-estab 
        THEN ASSIGN wh-codigo-orig-cd0140:SCREEN-VALUE = string(int-item-uni-estab.codigo-orig).
        ELSE ASSIGN wh-codigo-orig-cd0140:SCREEN-VALUE = "0".
    END.

end.

IF p-ind-event  = "BEFORE-INITIALIZE" AND 
   p-ind-object = "CONTAINER"  THEN DO:
    RUN upc/cd0140-upc.p PERSISTENT SET h-cd0140-upc (INPUT "",            
                                                      INPUT "",            
                                                      INPUT p-wgh-object,  
                                                      INPUT p-wgh-frame,   
                                                      INPUT "",            
                                                      INPUT p-row-table).  
END. /* IF p-ind-event  = "BEFORE-INITIALIZE" AND ... */

if p-ind-event  = "AFTER-INITIALIZE" and
   p-ind-object = "CONTAINER"  then do:

    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.

    DO WHILE wh-objeto <> ?:
        IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE wh-objeto:NAME:
                WHEN "fPage1":U THEN
                    ASSIGN wh-fPage1 = wh-objeto.
                WHEN "it-codigo" THEN
                    ASSIGN v-it-codigo = wh-objeto:SCREEN-VALUE.
                WHEN "cod-estabel":U THEN
                    ASSIGN v-cod-estabel = wh-objeto:SCREEN-VALUE.
                WHEN "btSave" THEN DO:
                    ASSIGN wh-bt-ok-cd0140 = wh-objeto:HANDLE.

                    IF NOT VALID-HANDLE (h-cd0140-upc) THEN
                       RUN upc/cd0140-upc.p PERSISTENT SET h-cd0140-upc (INPUT "",
                                                                          INPUT "",
                                                                          INPUT p-wgh-object,
                                                                          INPUT p-wgh-frame,
                                                                          INPUT "",
                                                                          INPUT p-row-table).
            
                    CREATE BUTTON wh-new-bt-ok-cd0140
                    ASSIGN FRAME       = wh-bt-ok-cd0140:FRAME
                           WIDTH       = wh-bt-ok-cd0140:WIDTH
                           HEIGHT      = wh-bt-ok-cd0140:HEIGHT
                           LABEL       = wh-bt-ok-cd0140:LABEL
                           ROW         = wh-bt-ok-cd0140:ROW
                           COL         = wh-bt-ok-cd0140:COL 
                           TOOLTIP     = wh-bt-ok-cd0140:TOOLTIP
                           FLAT-BUTTON = wh-bt-ok-cd0140:FLAT-BUTTON
                           VISIBLE     = wh-bt-ok-cd0140:VISIBLE
                           SENSITIVE   = wh-bt-ok-cd0140:SENSITIVE.
                    ON "CHOOSE" OF wh-new-bt-ok-cd0140 PERSISTENT RUN pi-bt-ok IN h-cd0140-upc.
            
                    wh-new-bt-ok-cd0140:LOAD-IMAGE(wh-bt-ok-cd0140:IMAGE).
                    wh-new-bt-ok-cd0140:LOAD-IMAGE-INSENSITIVE(wh-bt-ok-cd0140:IMAGE-INSENSITIVE).
                    wh-new-bt-ok-cd0140:MOVE-TO-TOP().
                    wh-bt-ok-cd0140:VISIBLE = NO.

                END.
            END CASE.

            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.

           
        END.
        ELSE
            ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.

    IF VALID-HANDLE(wh-fPage1) THEN DO:
        ASSIGN wh-objeto = wh-fPage1:FIRST-CHILD
               wh-objeto = wh-objeto:FIRST-CHILD.

        DO WHILE wh-objeto <> ?:
            IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE wh-objeto:NAME:
                    WHEN "ressup-fabri":U THEN
                        ASSIGN wh-ressup-fabri-cd0140 = wh-objeto:HANDLE.
                    WHEN "res-for-comp":U THEN
                        ASSIGN wh-res-for-comp-cd0140 = wh-objeto:HANDLE.
                    WHEN "res-cq-fabri":U THEN
                        ASSIGN wh-res-cq-fabri-cd0140 = wh-objeto:HANDLE.
                    WHEN "res-int-comp":U THEN
                        ASSIGN wh-res-int-comp-cd0140 = wh-objeto:HANDLE.
                END CASE.
        
                ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        END.
    END.

    IF VALID-HANDLE(wh-fPage1) THEN DO:

        CREATE FRAME wh-fpage-nova
        ASSIGN FRAME       = p-wgh-frame
               COL         = wh-fpage1:COL
               ROW         = wh-fpage1:ROW
               WIDTH       = wh-fpage1:WIDTH
               HEIGHT      = wh-fpage1:HEIGHT
               NAME        = "fPage2"
               SIDE-LABELS = YES
               SENSITIVE   = YES
               OVERLAY     = YES
               BGCOLOR     = wh-fpage1:BGCOLOR
               BOX         = NO
               THREE-D     = YES.

        CREATE FRAME wh-fpage-seop
        ASSIGN FRAME       = p-wgh-frame
               COL         = wh-fpage1:COL
               ROW         = wh-fpage1:ROW
               WIDTH       = wh-fpage1:WIDTH
               HEIGHT      = wh-fpage1:HEIGHT
               NAME        = "fPage3"
               SIDE-LABELS = YES
               SENSITIVE   = YES
               OVERLAY     = YES
               BGCOLOR     = wh-fpage1:BGCOLOR
               BOX         = NO
               THREE-D     = YES.


        assign h-objeto = p-wgh-object.
        do  while valid-handle(h-objeto):

            if  h-objeto:FILE-NAME = "utp/thinFolder.w" THEN LEAVE.
            assign h-objeto = h-objeto:NEXT-SIBLING.

        end.

        IF valid-handle(h-objeto) THEN RUN setFolder IN h-objeto (INPUT 1) .

        IF valid-handle(h-objeto) THEN RUN insertFolder IN h-objeto (INPUT ?,
                                                                     INPUT p-wgh-frame,
                                                                     INPUT wh-fpage-nova,
                                                                     INPUT "Antidumping").        

        create toggle-box wh-log-antidump-esp-cd0140
        ASSIGN FRAME      = wh-fPage-nova
               WIDTH      = 15.14
               HEIGHT     = 0.88
               ROW        = 1.2
               HELP       = "Tem antidumping?"
               LABEL      = "Tem Antidumping"
               COL        = 3
               NAME       = "v_log_antidumping_esp"
               FORMAT     = "YES/NO"
               sensitive  = FALSE.
        
        CREATE TEXT wh-tx-obs-antidump-cd0140
        ASSIGN FRAME        = wh-fPage-nova
               FORMAT       = "x(25)"   
               WIDTH        = 30
               SCREEN-VALUE = "Observaá∆o Antidumping:"
               ROW          = wh-log-antidump-esp-cd0140:ROW + 1
               COL          = wh-log-antidump-esp-cd0140:COL
               VISIBLE      = YES.
        
        CREATE EDITOR wh-obs-antidumping-cd0140
        ASSIGN FRAME              = wh-fPage-nova
               DATA-TYPE          = "character"
               INNER-CHARS        = 60
               INNER-LINES        = 5.5
               ROW                = wh-log-antidump-esp-cd0140:ROW + 1.6
               COL                = wh-log-antidump-esp-cd0140:COL
               SCROLLBAR-VERTICAL = YES
               MAX-CHARS          = 1999
               VISIBLE            = YES
               SENSITIVE          = NO
               .

        CREATE TEXT wh-tx-origem-cd0140
        ASSIGN FRAME        = wh-fPage-nova
               FORMAT       = "x(7)"   
               WIDTH        = 5
               HEIGHT       = 0.88
               SCREEN-VALUE = "Origem:"
               ROW          = 7.5
               COL          = 3
               VISIBLE      = YES.

        CREATE FILL-IN wh-codigo-orig-cd0140
        ASSIGN FRAME             = wh-fPage-nova
               DATA-TYPE         = "INTEGER"
               FORMAT            = ">9" 
               WIDTH             = 4
               HEIGHT            = 0.88
               ROW               = 7.5
               COL               = 8.43
               VISIBLE           = YES
               SENSITIVE         = NO
               TAB-STOP          = NO.

        FIND FIRST int-item NO-LOCK
             WHERE int-item.it-codigo = v-it-codigo NO-ERROR.

        IF  AVAIL int-item THEN DO:
            ASSIGN wh-log-antidump-esp-cd0140:CHECKED     = int-item.log-antidumping
                   wh-obs-antidumping-cd0140:SCREEN-VALUE = int-item.obs-antidumping.
        END.
        ELSE ASSIGN wh-log-antidump-esp-cd0140:CHECKED     = NO
                    wh-obs-antidumping-cd0140:SCREEN-VALUE = "".

        FIND FIRST int-item-uni-estab NO-LOCK
             WHERE int-item-uni-estab.it-codigo    = v-it-codigo  
               AND int-item-uni-estab.cod-estabel  = v-cod-estabel NO-ERROR.

        IF AVAIL int-item-uni-estab THEN
            ASSIGN wh-codigo-orig-cd0140:SCREEN-VALUE = string(int-item-uni-estab.codigo-orig).
        ELSE                                          
            ASSIGN wh-codigo-orig-cd0140:SCREEN-VALUE = "0".

        IF NOT VALID-HANDLE(h-facelift) THEN RUN btb/btb901zo.p PERSISTENT SET h-facelift.
        
        IF valid-handle(h-facelift) THEN RUN pi_aplica_facelift_thin IN h-facelift (INPUT  wh-fPage-nova).

        IF valid-handle(h-objeto) THEN RUN insertFolder IN h-objeto (INPUT ?,
                                                                     INPUT p-wgh-frame,
                                                                     INPUT wh-fPage-seop,
                                                                     INPUT "S&OP").

        IF valid-handle(h-facelift) THEN RUN pi_aplica_facelift_thin IN h-facelift (INPUT  wh-fPage-seop).

        create toggle-box wh-log-planejamento-vendas-cd0140
        ASSIGN FRAME      = wh-fPage-seop
               WIDTH      = 20
               HEIGHT     = 0.88
               ROW        = 1.2
               HELP       = "Planejamento de Vendas?"
               LABEL      = "Planejamento de Vendas?"
               COL        = 3
               NAME       = "v_log_planejamento_vendas_esp"
               FORMAT     = "YES/NO"
               sensitive  = FALSE.

        IF AVAIL int-item-uni-estab THEN
            ASSIGN wh-log-planejamento-vendas-cd0140:CHECKED = int-item-uni-estab.log-planejamento-vendas.
        ELSE                                          
            ASSIGN wh-log-planejamento-vendas-cd0140:CHECKED = NO.

        IF valid-handle(h-objeto) THEN RUN setFolder IN h-objeto (INPUT 1) .
    
    END.
end.

IF p-ind-event  = "AFTER-DISPLAY":U AND
   p-ind-object = "CONTAINER":U    THEN DO:
    
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.

    DO WHILE wh-objeto <> ?:
        IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE wh-objeto:NAME:
                WHEN "it-codigo":U THEN
                    ASSIGN v-it-codigo = wh-objeto:SCREEN-VALUE.
                WHEN "cod-estabel":U THEN
                    ASSIGN v-cod-estabel = wh-objeto:SCREEN-VALUE.
                WHEN "fPage1":U THEN
                    ASSIGN wh-fPage1 = wh-objeto.
            END CASE.

            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
        END.
        ELSE
            ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.
    
    IF VALID-HANDLE(wh-fPage1) THEN DO:
        ASSIGN wh-objeto = wh-fPage1:FIRST-CHILD
               wh-objeto = wh-objeto:FIRST-CHILD.

        DO WHILE wh-objeto <> ?:
            IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE wh-objeto:NAME:
                    WHEN "c-cod-unid-negoc":U THEN
                        ASSIGN wh-cod-unid-neg = wh-objeto.
                    WHEN "observacao":U THEN
                        ASSIGN wh-observ-esp = wh-objeto.
                END CASE.
        
                ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        END.
    END.

    if VALID-HANDLE(wh-cod-unid-neg) and
       NOT valid-handle(wh-observ-esp) then do:
        create text wh-txt-esp
        assign frame         = wh-fPage1
               format        = "x(11)"
               width         = 10
               height        = 0.75
               screen-value  = "Observaá∆o:":U
               row           = wh-cod-unid-neg:ROW + 1
               col           = wh-cod-unid-neg:COL - 9
               fgcolor       = 0
               visible       = yes.

        create fill-in wh-observ-esp
        assign frame         = wh-fPage1
               width         = 40
               height        = wh-cod-unid-neg:height
               row           = wh-cod-unid-neg:ROW + 1
               help          = "Observaá∆o"
               col           = wh-cod-unid-neg:col
               name          = "observacao"
               data-type     = "character"
               format        = "x(200)"
               visible       = yes
               sensitive     = false
               tooltip       = "Observaá∆o".

        CREATE COMBO-BOX wh-motivo-situacao-cd0140
        ASSIGN FRAME             = wh-fPage1
               FORMAT            = "X(18)" 
               WIDTH             = 15
               ROW               = 8.5
               COL               = 42
               FONT               = 1
               INNER-LINES        = 5
               VISIBLE           = YES
               SENSITIVE         = NO
               LIST-ITEM-PAIRS   = ",0,Alteraá∆o de estrutura,1,Phase out produto,2,Item EOL,3,Bloqueado compra,4".

    end.

    FIND FIRST int-item-uni-estab NO-LOCK
         WHERE int-item-uni-estab.it-codigo    = v-it-codigo  
           AND int-item-uni-estab.cod-estabel  = v-cod-estabel NO-ERROR.

    IF VALID-HANDLE(wh-motivo-situacao-cd0140) THEN DO:
       ASSIGN wh-motivo-situacao-cd0140:SCREEN-VALUE = '0'.
       
       IF AVAIL int-item-uni-estab THEN DO:
          ASSIGN wh-motivo-situacao-cd0140:SCREEN-VALUE = STRING(int-item-uni-estab.int-1).
       END.
    END.   
    IF VALID-HANDLE(wh-log-planejamento-vendas-cd0140) THEN DO:
        IF AVAIL int-item-uni-estab THEN
            ASSIGN wh-log-planejamento-vendas-cd0140:CHECKED = int-item-uni-estab.log-planejamento-vendas.
        ELSE                                          
            ASSIGN wh-log-planejamento-vendas-cd0140:CHECKED = NO.
    END.

    IF VALID-HANDLE(wh-observ-esp) THEN DO:
        IF AVAIL int-item-uni-estab THEN DO:
            ASSIGN wh-observ-esp:SCREEN-VALUE = int-item-uni-estab.observacao.
        END.
        ELSE 
            ASSIGN wh-observ-esp:SCREEN-VALUE = "".
    END.

    /*
    FIND FIRST int-item NO-LOCK
         WHERE int-item.it-codigo = v-it-codigo NO-ERROR.

    IF AVAIL int-item THEN
        ASSIGN wh-motivo-situacao-cd0140:SCREEN-VALUE = IF int-item.motivo-situacao = 1 THEN "Alt. Estrutura" ELSE IF int-item.motivo-situacao = 2 THEN "Phase out" ELSE "".
    ELSE
        ASSIGN wh-motivo-situacao-cd0140:SCREEN-VALUE = "".*/


end.

IF p-ind-event  = "AFTER-ENABLE":U AND
   p-ind-object = "CONTAINER":U    THEN DO:

    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.

    DO WHILE wh-objeto <> ?:
        IF  wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE wh-objeto:NAME:
                WHEN "fPage1":U THEN ASSIGN wh-fPage1 = wh-objeto.
            END CASE.
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
        END.
        ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.
    
    IF VALID-HANDLE(wh-fPage1) THEN DO:
        ASSIGN wh-objeto = wh-fPage1:FIRST-CHILD
               wh-objeto = wh-objeto:FIRST-CHILD.

        DO WHILE wh-objeto <> ?:
            IF  wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE wh-objeto:NAME:
                    WHEN "observacao":U THEN ASSIGN wh-observ-esp = wh-objeto.
                END CASE.
                ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
            END.
            ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        END.
    end.

    /*Verifica se usu†rio ou grupo tem permiss∆o para alterar observaá∆o*/
    IF VALID-HANDLE(wh-observ-esp) THEN DO:
        ASSIGN wh-observ-esp:SENSITIVE = FALSE.

        RUN esp/es0018p.p (INPUT "cd0140":U, INPUT 2, INPUT 0, INPUT "":U, OUTPUT TABLE tt-prog-ponto).

        blk_observacao:
        FOR EACH tt-prog-ponto:
            
            FIND FIRST usuar_grp_usuar NO-LOCK
                 WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                   AND usuar_grp_usuar.cod_usuar     = c-seg-usuario NO-ERROR.

            IF AVAIL usuar_grp_usuar 
            OR c-seg-usuario = tt-prog-ponto.conteudo THEN DO:
                ASSIGN wh-observ-esp:SENSITIVE = TRUE.
                LEAVE blk_observacao.
            END.
        END.
    END.
    

    /*---[ Habilitaá∆o do campo Origem ]----------------------------------------------------*/
    EMPTY TEMP-TABLE tt-prog-ponto.
    
    RUN esp/es0018p.p (INPUT "cd0140":U,
                       INPUT 4,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    IF  CAN-FIND(FIRST tt-prog-ponto         
                 WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:
        IF valid-handle(wh-cod-unid-neg) THEN ASSIGN wh-codigo-orig-cd0140:SENSITIVE = TRUE.
    END.
    ELSE DO:
        FOR EACH tt-prog-ponto:

            IF  CAN-FIND(FIRST usuar_grp_usuar
                         WHERE usuar_grp_usuar.cod_usuario   = c-seg-usuario
                         AND   usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo) THEN DO:
                IF VALID-HANDLE(wh-codigo-orig-cd0140) THEN ASSIGN wh-codigo-orig-cd0140:SENSITIVE = TRUE.
                LEAVE.
            END. /* IF  CAN-FIND(FIRST usuar_grp_usuar */
            ELSE DO:
                IF VALID-HANDLE(wh-codigo-orig-cd0140) THEN ASSIGN wh-codigo-orig-cd0140:SENSITIVE = FALSE.
                LEAVE.
            END. /* ELSE DO: */
        END. /* FOR EACH tt-prog-ponto: */
    END. /* ELSE DO: */
    EMPTY TEMP-TABLE tt-prog-ponto.
    /*----------------------------------------------------[ Habilitaá∆o do campo Origem ]---*/

   

    IF VALID-HANDLE(wh-log-planejamento-vendas-cd0140) THEN
        ASSIGN wh-log-planejamento-vendas-cd0140:SENSITIVE = YES.


end.

IF p-ind-event  = "AFTER-DISABLE":U AND
   p-ind-object = "CONTAINER":U    THEN DO:
    
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.

    DO WHILE wh-objeto <> ?:
        IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE wh-objeto:NAME:
                WHEN "fPage1":U THEN ASSIGN wh-fPage1 = wh-objeto.
            END CASE.
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
        END.
        ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.
    
    IF VALID-HANDLE(wh-fPage1) THEN DO:
        ASSIGN wh-objeto = wh-fPage1:FIRST-CHILD
               wh-objeto = wh-objeto:FIRST-CHILD.

        DO WHILE wh-objeto <> ?:
            IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE wh-objeto:NAME:
                    WHEN "observacao":U THEN ASSIGN wh-observ-esp = wh-objeto.
                END CASE.
                ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
            END.
            ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        END.
    end.

    IF VALID-HANDLE(wh-observ-esp)         THEN ASSIGN wh-observ-esp:SENSITIVE = NO.
    IF VALID-HANDLE(wh-codigo-orig-cd0140) THEN ASSIGN wh-codigo-orig-cd0140:SENSITIVE = NO.
     
    IF VALID-HANDLE(wh-motivo-situacao-cd0140) THEN ASSIGN wh-motivo-situacao-cd0140:SENSITIVE = NO.

    IF VALID-HANDLE(wh-log-planejamento-vendas-cd0140) THEN
        ASSIGN wh-log-planejamento-vendas-cd0140:SENSITIVE = NO.
end.

IF p-ind-event  = "AFTER-ASSIGN":U AND
   p-ind-object = "CONTAINER":U    THEN DO:
    
   ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
          wh-objeto = wh-objeto:FIRST-CHILD.

   DO WHILE wh-objeto <> ?:
       IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
           CASE wh-objeto:NAME:
               WHEN "it-codigo":U   THEN ASSIGN v-it-codigo = wh-objeto:SCREEN-VALUE.
               WHEN "cod-estabel":U THEN ASSIGN v-cod-estabel = wh-objeto:SCREEN-VALUE.
               WHEN "fPage1":U      THEN ASSIGN wh-fPage1 = wh-objeto.
           END CASE.
           ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
       END.
       ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
   END.
   
   IF  VALID-HANDLE(wh-fPage1) THEN DO:
       ASSIGN wh-objeto = wh-fPage1:FIRST-CHILD
              wh-objeto = wh-objeto:FIRST-CHILD.

       DO WHILE wh-objeto <> ?:
           IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
               CASE wh-objeto:NAME:
                   WHEN "observacao":U THEN ASSIGN wh-observ-esp = wh-objeto.
               END CASE.
               ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
           END.
           ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
       END.
   end.
   
   
   /*
   IF  wh-cd-cod-obsol:SCREEN-VALUE = "Obsoleto Ordens Autom†ticas" 
   AND wh-motivo-situacao-cd0140:SCREEN-VALUE   = "0" THEN DO:
       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 17006,
                          INPUT "Informe o motivo da situaá∆o Obsoleto Ordens Autom†ticas.").
   END.*/


   IF VALID-HANDLE(wh-observ-esp) THEN DO:
       FIND FIRST int-item-uni-estab EXCLUSIVE-LOCK
            WHERE int-item-uni-estab.it-codigo    = v-it-codigo  
              AND int-item-uni-estab.cod-estabel  = v-cod-estabel NO-ERROR.
       IF NOT AVAIL int-item-uni-estab THEN DO:
           CREATE int-item-uni-estab.
           ASSIGN int-item-uni-estab.it-codigo    = v-it-codigo  
                  int-item-uni-estab.cod-estabel  = v-cod-estabel.       
       END.
       ASSIGN int-item-uni-estab.observacao = wh-observ-esp:SCREEN-VALUE.
       
       IF VALID-HANDLE(wh-motivo-situacao-cd0140) THEN DO:
           FIND FIRST item-uni-estab EXCLUSIVE-LOCK
                WHERE item-uni-estab.it-codigo    = v-it-codigo  
                  AND item-uni-estab.cod-estabel  = v-cod-estabel NO-ERROR.
    
           IF AVAIL item-uni-estab THEN DO:
           
              IF item-uni-estab.cod-obsoleto = 2 THEN DO: //Obsoleto 
                 CASE wh-motivo-situacao-cd0140:SCREEN-VALUE:
                     WHEN "1" THEN //"Alteraá∆o de estrutura"
                        ASSIGN int-item-uni-estab.int-1 = 1.
                     WHEN "2" THEN //"Phase out produto" 
                        ASSIGN int-item-uni-estab.int-1 = 2.
                     WHEN "3"  THEN //"Item EOL"
                        ASSIGN int-item-uni-estab.int-1 = 3.
                     WHEN "4"  THEN //"Bloqueado para compra"
                        ASSIGN int-item-uni-estab.int-1 = 4.
                 END CASE.                                 
              END.
              ELSE 
                ASSIGN int-item-uni-estab.int-1 = 0.
           END.
       END.

   END.

    IF  VALID-HANDLE(wh-codigo-orig-cd0140) THEN DO:
        IF AVAIL int-item-uni-estab 
        THEN ASSIGN int-item-uni-estab.codigo-orig = INT(wh-codigo-orig-cd0140:SCREEN-VALUE).
        ELSE ASSIGN int-item-uni-estab.codigo-orig = 0.
    END. /* IF  VALID-HANDLE(wh-codigo-orig-cd0140) */

    IF VALID-HANDLE(wh-log-planejamento-vendas-cd0140) THEN DO:
        IF AVAIL int-item-uni-estab THEN
            ASSIGN int-item-uni-estab.log-planejamento-vendas = wh-log-planejamento-vendas-cd0140:CHECKED.
    END.
end.
/********************** Fim UPC inclus∆o campo Observaá∆o ************************************/


IF p-ind-event  = "AFTER-ENABLE":U AND
   p-ind-object = "CONTAINER":U    THEN DO:
    /*Busca Handles*/
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.

    DO WHILE wh-objeto <> ?:
        IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
            CASE wh-objeto:NAME:
                WHEN "fPage1":U THEN ASSIGN wh-fPage1 = wh-objeto.
            END CASE.
            ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
        END.
        ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
    END.

    IF VALID-HANDLE(wh-fPage1) THEN DO:
        ASSIGN wh-objeto = wh-fPage1:FIRST-CHILD
               wh-objeto = wh-objeto:FIRST-CHILD.

        DO WHILE wh-objeto <> ?:
            IF wh-objeto:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE wh-objeto:NAME:
                    WHEN "cb-cod-obsol":U THEN DO:
                        ASSIGN wh-cd-cod-obsol = wh-objeto.
                        
                        IF NOT VALID-HANDLE (h-cd0140-upc) THEN
                            RUN upc/cd0140-upc.p PERSISTENT SET h-cd0140-upc (INPUT "",
                                                                              INPUT "",
                                                                              INPUT p-wgh-object,
                                                                              INPUT p-wgh-frame,
                                                                              INPUT "",
                                                                              INPUT p-row-table).

                        ON "VALUE-CHANGED":U OF wh-cd-cod-obsol PERSISTENT RUN pi-value-change-cod-obsoleto IN h-cd0140-upc.
                    END.
                END CASE.
                ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING.
            END.
            ELSE ASSIGN wh-objeto = wh-objeto:FIRST-CHILD.
        END.
    END.
    /**/


    IF VALID-HANDLE(wh-cd-cod-obsol)           AND 
        VALID-HANDLE(wh-motivo-situacao-cd0140) THEN DO:

       IF wh-cd-cod-obsol:SENSITIVE THEN DO:
          IF wh-cd-cod-obsol:SCREEN-VALUE = "Obsoleto Ordens Autom†ticas" THEN DO:
              ASSIGN wh-motivo-situacao-cd0140:SENSITIVE = YES NO-ERROR.
          END.
          ELSE DO:
              ASSIGN wh-motivo-situacao-cd0140:SENSITIVE    = NO
                     wh-motivo-situacao-cd0140:SCREEN-VALUE = "0" NO-ERROR.
          END.
       END.
    END.

    IF  VALID-HANDLE(wh-cd-cod-obsol) THEN DO:

        ASSIGN wh-cd-cod-obsol:SENSITIVE = NO.

        /*Verifica se o usu†rio tem permiss∆o para alterar situaá∆o*/
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "cd0140":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        IF CAN-FIND(FIRST tt-prog-ponto
                    WHERE tt-prog-ponto.conteudo = c-seg-usuario) THEN DO:

            ASSIGN wh-cd-cod-obsol:SENSITIVE = YES.
            
        END.
        /**/
    
        /*Verifica se o grupo tem ermiss∆o para alterar situaá∆o*/
        EMPTY TEMP-TABLE tt-prog-ponto.

        RUN esp/es0018p.p (INPUT "cd0140":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        blk_situacao:
        FOR EACH tt-prog-ponto:
            FIND FIRST usuar_grp_usuar NO-LOCK
                 WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                   AND usuar_grp_usuar.cod_usuar     = c-seg-usuario NO-ERROR.
    
            IF AVAIL usuar_grp_usuar THEN DO:
                ASSIGN wh-cd-cod-obsol:SENSITIVE = YES.
                LEAVE blk_situacao.
            END.
        END.
    
        EMPTY TEMP-TABLE tt-prog-ponto.
    END.

    ASSIGN wh-objeto       = ?
           wh-fPage1       = ?.
           //wh-cd-cod-obsol = ?.
END.

IF p-ind-event  = "BEFORE-DESTROY-INTERFACE":U AND
   p-ind-object = "CONTAINER":U                THEN DO:

    ASSIGN wh-objeto       = ?
           wh-fPage1       = ?
           wh-cd-cod-obsol = ?
           h-cd0140-upc     = ?.

    IF VALID-HANDLE(h-cd0140-upc) THEN
       DELETE WIDGET h-cd0140-upc.





END.

IF  p-ind-event = "AFTER-UPDATE":U AND 
    p-ind-object = "CONTAINER":U THEN DO:

    EMPTY TEMP-TABLE tt-prog-ponto.
    
    RUN esp/es0018p.p (INPUT "cd0140":U,
                       INPUT 3,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN wh-cod-unid-neg:SENSITIVE = FALSE.

    /*Verifica se o grupo tem permiss∆o para editar a Unidade de neg¢cio*/
    blk_unid_negoc:
    FOR EACH tt-prog-ponto:
        
        FIND FIRST usuar_grp_usuar NO-LOCK
             WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
               AND usuar_grp_usuar.cod_usuar     = c-seg-usuario NO-ERROR.

        IF AVAIL usuar_grp_usuar
        OR c-seg-usuario = tt-prog-ponto.conteudo THEN DO:
            ASSIGN wh-cod-unid-neg:SENSITIVE = TRUE.
            LEAVE blk_unid_negoc.
        END.
    END.

    EMPTY TEMP-TABLE tt-prog-ponto.
END.

IF VALID-HANDLE(wh-new-bt-ok-cd0140) AND 
   VALID-HANDLE(wh-bt-ok-cd0140) THEN 
    ASSIGN wh-new-bt-ok-cd0140:SENSITIVE = wh-bt-ok-cd0140:SENSITIVE.


PROCEDURE pi-value-change-cod-obsoleto:
   
    /*
    MESSAGE 'passou' SKIP 
            VALID-HANDLE(wh-cd-cod-obsol) SKIP 
            VALID-HANDLE(wh-motivo-situacao-cd0140)
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

    /*S¢ habilita o motivo situaá∆o para quem tem o situaá∆o ativo*/

    IF  VALID-HANDLE(wh-cd-cod-obsol) THEN DO:
    
        IF wh-cd-cod-obsol:SENSITIVE THEN DO:
    
            IF wh-cd-cod-obsol:SCREEN-VALUE = "Obsoleto Ordens Autom†ticas" THEN DO:
                ASSIGN wh-motivo-situacao-cd0140:SENSITIVE = YES NO-ERROR.
            END.
            ELSE DO:
                ASSIGN wh-motivo-situacao-cd0140:SENSITIVE    = NO
                       wh-motivo-situacao-cd0140:SCREEN-VALUE = "0" NO-ERROR.
            END.
        END.
        ELSE 
            ASSIGN wh-motivo-situacao-cd0140:SENSITIVE = NO NO-ERROR.
    END.
END.


PROCEDURE pi-bt-ok:

    IF  wh-cd-cod-obsol:SCREEN-VALUE = "Obsoleto Ordens Autom†ticas" 
    AND wh-motivo-situacao-cd0140:SCREEN-VALUE   = "0" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Informe o motivo da situaá∆o Obsoleto Ordens Autom†ticas.").
        RETURN "NOK".
    END.

     APPLY "CHOOSE" to wh-bt-ok-cd0140.

END PROCEDURE.


RETURN "OK":U.
