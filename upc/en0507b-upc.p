/***********************************************************************
**  Programa..: upc\en0507b-upc.p
**  Autor.....: Maicon Correa - Sensus
**  Data......: Maráo/2014 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - Desenvolvimento Programa
**  Vers∆o....: 002 - 
************************************************************************/

{esp/es0018.i}
{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE c-objeto AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-folder as char      no-undo.
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

DEFINE VARIABLE wh-gm-codigo       AS WIDGET-HANDLE NO-UNDO. 
DEFINE VARIABLE wh-tipo-oper       AS WIDGET-HANDLE NO-UNDO. 
DEFINE VARIABLE h-frame            AS HANDLE        NO-UNDO.
DEFINE VARIABLE hCurrentWidget     AS WIDGET-HANDLE NO-UNDO.

define new global shared VARIABLE adm-broker-hdl             as handle        no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE wh-v-unidades-en0507b      AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cb-un-med-tempo-en0507b AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-descricao-en0507b       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-oper-pad-en0507b     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-oper-pad-new-en0507b AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-data-inicio-en0507b     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-numero-homem            AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-homem                AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-container-en0507b       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-op-codigo               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo               AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-new-en0507b              AS LOGICAL       NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-en0507b-upc              AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-folder-en0507b-upc       as handle        no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE lg-aux-en0507b-upc         AS LOGICAL       NO-UNDO.
define new global shared variable lg-adic-en0507b-upc        as logical       no-undo.

DEFINE VARIABLE wh-nr-homem-en0507b     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-nr-homem-new-en0507b AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-nr-homem-txt-en0507b AS WIDGET-HANDLE NO-UNDO.

DEFINE TEMP-TABLE widgets NO-UNDO
    FIELD wg-handle    AS WIDGET-HANDLE
    FIELD wg-name      AS CHARACTER
    FIELD wg-type      AS CHARACTER
    FIELD wg-parent    AS WIDGET-HANDLE.

DEF NEW GLOBAL SHARED TEMP-TABLE tt-en0507b-upc NO-UNDO
    FIELD wg-frame     AS HANDLE
    FIELD wg-nr-hom    AS HANDLE
    FIELD wg-container AS HANDLE
    FIELD wg-folder    AS HANDLE
    FIELD wg-txt       AS HANDLE.

/* message "P-ind-event  = " p-ind-event         skip */
/*         "P-ind-object = " p-ind-object        skip */
/*         "P-wgh-object = " p-wgh-object        skip */
/*         "C-objeto     = " c-objeto            SKIP */
/*         "p-wgh-frame  = " p-wgh-frame         skip */
/*         "P-cod-table  = " p-cod-table         skip */
/*         "p-row-table  = " string(p-row-table) skip */
/*         view-as alert-box.                         */

IF  p-ind-event  = "BEFORE-INITIALIZE"
AND p-ind-object = "CONTAINER"
THEN ASSIGN wh-container-en0507b = p-wgh-object
            lg-aux-en0507b-upc   = NO
            lg-adic-en0507b-upc  = no
            h-folder-en0507b-upc = ?.

IF  p-ind-event  = "INITIALIZE"
AND p-ind-object = "CONTAINER"
AND VALID-HANDLE(adm-broker-hdl)
THEN DO:
     run get-link-handle in adm-broker-hdl(input  p-wgh-object,
                                           input  "PAGE-SOURCE":U,
                                           output c-folder).
     
     assign h-folder-en0507b-upc = handle(c-folder) no-error.
END.

IF p-ind-event  = "AFTER-CHANGE-PAGE" AND
   p-ind-object = "CONTAINER"     AND 
   c-objeto     = "folder.w" THEN DO:
    IF VALID-HANDLE(wh-v-unidades-en0507b) AND
       VALID-HANDLE(wh-cb-un-med-tempo-en0507b) /*AND 
       VALID-HANDLE(wh-numero-homem)*/ THEN DO:

        ASSIGN wh-v-unidades-en0507b:SCREEN-VALUE      = "1"
               wh-cb-un-med-tempo-en0507b:SCREEN-VALUE = "Minutos"
               /*wh-numero-homem:VISIBLE                 = NO*/ .

        ASSIGN wh-v-unidades-en0507b      = ?
               wh-cb-un-med-tempo-en0507b = ?
               /*wh-numero-homem            = ?*/ .

    END.  

    IF lg-aux-en0507b-upc
    THEN FOR FIRST tt-en0507b-upc
             WHERE tt-en0507b-upc.wg-folder = p-wgh-object:
            IF  NOT VALID-HANDLE(tt-en0507b-upc.wg-txt)
            AND tt-en0507b-upc.wg-nr-hom:VISIBLE 
            THEN DO:
                 create TEXT wh-nr-homem-txt-en0507b
                 assign frame        = tt-en0507b-upc.wg-nr-hom:frame
                        WIDTH        = 12.7
                        HEIGHT       = 0.88
                        row          = tt-en0507b-upc.wg-nr-hom:row
                        col          = tt-en0507b-upc.wg-nr-hom:col - 13
                        BGCOLOR      = ?
                        VISIBLE      = YES
                        SENSITIVE    = YES
                        format       = "x(16)"
                        screen-value = "Nro. Homens APS:".
                 ASSIGN tt-en0507b-upc.wg-txt = wh-nr-homem-txt-en0507b.
            END.
         END. /* FOR FIRST tt-en0507b-upc */
END.

IF  p-ind-event  = "AFTER-ENABLE"
AND p-ind-object = "VIEWER"
AND c-objeto     = "v03in263.w" THEN DO:

    RUN upc/en0507b-upc.p PERSISTENT SET h-en0507b-upc (INPUT "",
                                                        INPUT "",
                                                        INPUT p-wgh-object,
                                                        INPUT p-wgh-frame,
                                                        INPUT "",
                                                        INPUT p-row-table).

    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "descricao",
                      OUTPUT wh-descricao-en0507b).

    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "nr-oper-pad",
                      OUTPUT wh-nr-oper-pad-en0507b).

    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "data-inicio",
                      OUTPUT wh-data-inicio-en0507b).

    IF NOT VALID-HANDLE (wh-nr-oper-pad-new-en0507b) THEN DO:

        ASSIGN wh-nr-oper-pad-en0507b:SENSITIVE = NO
               wh-nr-oper-pad-en0507b:HIDDEN = YES.

        CREATE FILL-IN wh-nr-oper-pad-new-en0507b
        ASSIGN FRAME             = wh-nr-oper-pad-en0507b:FRAME
               DATA-TYPE         = wh-nr-oper-pad-en0507b:DATA-TYPE
               FORMAT            = wh-nr-oper-pad-en0507b:FORMAT
               WIDTH             = wh-nr-oper-pad-en0507b:WIDTH
               HEIGHT            = wh-nr-oper-pad-en0507b:HEIGHT
               ROW               = wh-nr-oper-pad-en0507b:ROW
               COLUMN            = wh-nr-oper-pad-en0507b:COLUMN
               HIDDEN            = wh-nr-oper-pad-en0507b:HIDDEN
               SIDE-LABEL-HANDLE = wh-nr-oper-pad-en0507b:SIDE-LABEL-HANDLE
               HELP              = wh-nr-oper-pad-en0507b:HELP
               TOOLTIP           = wh-nr-oper-pad-en0507b:TOOLTIP
               SENSITIVE         = YES
               VISIBLE           = YES.

        
        wh-nr-oper-pad-new-en0507b:LOAD-MOUSE-POINTER('image/lupa.cur').

        ON "LEAVE":U OF wh-nr-oper-pad-new-en0507b PERSISTENT RUN pi-nr-oper-pad-new IN h-en0507b-upc.

        ON "F5":U OF wh-nr-oper-pad-new-en0507b PERSISTENT RUN upc/en0507bzoom-upc.p.
        ON "MOUSE-SELECT-DBLCLICK":U OF wh-nr-oper-pad-new-en0507b PERSISTENT RUN upc/en0507bzoom-upc.p.

        ASSIGN wh-nr-oper-pad-new-en0507b:SCREEN-VALUE = wh-nr-oper-pad-en0507b:SCREEN-VALUE.

        IF wh-nr-oper-pad-new-en0507b:SCREEN-VALUE = "0" 
        OR wh-nr-oper-pad-new-en0507b:SCREEN-VALUE = "" THEN
            ASSIGN wh-descricao-en0507b:SENSITIVE = YES.
        ELSE 
            ASSIGN wh-descricao-en0507b:SENSITIVE = no.

        APPLY 'LEAVE' TO wh-nr-oper-pad-new-en0507b.
        APPLY 'ENTRY' TO wh-nr-oper-pad-new-en0507b.
    END.
    wh-descricao-en0507b:MOVE-AFTER-TAB-ITEM(wh-nr-oper-pad-new-en0507b).

END.

/*IF p-ind-event  = "INITIALIZE":U AND       
   p-ind-object = "CONTAINER":U  THEN DO:*/

/*MESSAGE p-ind-event SKIP p-ind-object
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

IF p-ind-event  = "ADD"        AND
   p-ind-object = "VIEWER"     AND 
   c-objeto     = "v09in263.w" THEN DO:
/*     run select-page in wh-container-en0507b (input 2). */

    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "v-unidades",
                      OUTPUT wh-v-unidades-en0507b).

    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "cb-un-med-tempo",
                      OUTPUT wh-cb-un-med-tempo-en0507b).

/*     RUN pi-nr-homem.                                   */
/*                                                        */
/*     run select-page in wh-container-en0507b (input 1). */

    ASSIGN l-new-en0507b = YES.
END. 

/* Na situaá∆o atual, o £ltimo ponto EPC em cada situaá∆o */
IF (p-ind-event  = "ADD"
AND p-ind-object = "VIEWER" 
AND c-objeto     = "v12in263.w")
OR (p-ind-event  = "AFTER-ENABLE"
AND p-ind-object = "VIEWER"
AND c-objeto     = "v08in263.w")
THEN ASSIGN lg-aux-en0507b-upc = YES.

IF  p-ind-event = "AFTER-ENABLE"
AND p-ind-object = "VIEWER"
AND c-objeto = "v09in263.w"
AND NOT CAN-FIND(FIRST tt-en0507b-upc WHERE
                       tt-en0507b-upc.wg-frame = p-wgh-frame)
THEN DO:
     run select-page in wh-container-en0507b (input 2).
     RUN pi-nr-homem.
     run select-page in wh-container-en0507b (input 1).
END.

IF p-ind-event  = "ADD" AND 
   p-ind-object = "VIEWER" AND
   c-objeto     = "v03in263.w" THEN DO:

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
   c-objeto     = "v03in263.w" THEN DO:
    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "tipo-oper",
                      OUTPUT wh-tipo-oper).

    if  valid-handle(wh-tipo-oper)
    and inte(wh-tipo-oper:screen-value) <> 2 /* Externa */
    then do:
         RUN busca-handle (INPUT p-wgh-frame,
                           INPUT "gm-codigo",
                           OUTPUT wh-gm-codigo).
        
         if valid-handle(wh-gm-codigo)
         then do:
              if not can-find (first grup-maquina where
                                     grup-maquina.gm-codigo      = wh-gm-codigo:screen-value
                                 and grup-maquina.cod-area-prod <> ""
                                     no-lock)
              then do:
                   run utp/ut-msgs.p (input "show":U, input 17567, input "Grupo de M†quina " + trim(wh-gm-codigo:screen-value) + " n∆o possui relacionamento com µrea de Produá∆o, favor procurar o PCP").
                   return "NOK".
              end.

              if not can-find (first int-gm-operador where
                                     int-gm-operador.gm-codigo = wh-gm-codigo:screen-value
                                     no-lock)
              then do:
                   run utp/ut-msgs.p (input "show":U, input 17567, input "Grupo de M†quina " + trim(wh-gm-codigo:screen-value) + " n∆o possui relacionamento com Cargo UEP, favor procurar a Engenharia de Processo").
                   return "NOK".
              end.
         end. /* if valid-handle(wh-gm-codigo) */
    end. /* if valid-handle(wh-tipo-oper) */

    IF VALID-HANDLE(wh-nr-oper-pad-en0507b) THEN DO:

        RUN esp/es0018p.p (INPUT "en0507":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR EACH tt-prog-ponto:
            IF tt-prog-ponto.conteudo = wh-nr-oper-pad-en0507b:SCREEN-VALUE THEN DO:
               run utp/ut-msgs.p (input "show":U, input 17006, input "Operaá∆o padr∆o escolhida fora da lista v†lida para TOTVS/SAP~~Favor escolher uma Operaá∆o v†lida da lista TOTVS/SAP").   
    
               APPLY 'entry' TO wh-nr-oper-pad-en0507b.
               return "NOK".
            END.
        END.

        IF wh-nr-oper-pad-en0507b:SCREEN-VALUE = '0' THEN DO:
           run utp/ut-msgs.p (input "show":U, input 17006, input "Operaá∆o padr∆o inexistente~~Favor escolher uma Operaá∆o v†lida da lista TOTVS/SAP").   

           APPLY 'entry' TO wh-nr-oper-pad-en0507b.
           return "NOK".
        END.
    END.

    RUN pi-valida-gm-codigo.
END.

IF  p-ind-event  = "ASSIGN"
AND p-ind-object = "VIEWER"
AND c-objeto     = "v09in263.w"
then do:
     assign lg-adic-en0507b-upc = no.

     run get-attribute in p-wgh-object ('adm-new-record').

     IF RETURN-VALUE = 'YES'
     THEN assign lg-adic-en0507b-upc = yes.
end.

IF  p-ind-event  = "AFTER-END-UPDATE"
AND p-ind-object = "VIEWER"
AND c-objeto     = "v09in263.w"
THEN FOR FIRST tt-en0507b-upc
         WHERE tt-en0507b-upc.wg-frame = p-wgh-frame:
         IF tt-en0507b-upc.wg-nr-hom:SCREEN-VALUE = "?"
         THEN ASSIGN tt-en0507b-upc.wg-nr-hom:SCREEN-VALUE = "".

         FOR FIRST operacao NO-LOCK
             WHERE ROWID(operacao) = p-row-table:
             FOR FIRST int-ext-operacao USE-INDEX index2
                 WHERE int-ext-operacao.num-id-operacao = operacao.num-id-operacao
                       EXCLUSIVE-LOCK: END.
    
             IF  NOT AVAIL int-ext-operacao
             THEN DO:
                  CREATE int-ext-operacao.
                  ASSIGN int-ext-operacao.num-id-operacao = operacao.num-id-operacao.
             END.
            
             IF AVAIL int-ext-operacao
             THEN ASSIGN int-ext-operacao.it-codigo     = operacao.it-codigo
                         int-ext-operacao.cod-roteiro   = operacao.cod-roteiro
                         int-ext-operacao.op-codigo     = operacao.op-codigo
                         int-ext-operacao.nro-homem-aps = DECI(tt-en0507b-upc.wg-nr-hom:SCREEN-VALUE).
             FIND CURRENT int-ext-operacao NO-LOCK NO-ERROR.

             if lg-adic-en0507b-upc
             then run pi-inclui-op-ferram.
         END.
     END. /* FOR FIRST tt-en0507b-upc */

IF p-ind-event  = "DESTROY" AND 
   p-ind-object = "CONTAINER" AND
   c-objeto     = "en0507b.w" THEN DO:
    FOR FIRST tt-en0507b-upc
        WHERE tt-en0507b-upc.wg-container = p-wgh-object:
        DELETE tt-en0507b-upc.
    END.

    IF TODAY <= 03/31/2023 THEN DO:
        MESSAGE "Atená∆o aos seguintes cadastros: " SKIP(1)
                "*** N£mero de homens e Recursos Secund†rios ***"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    
END.

PROCEDURE pi-nr-homem:
    RUN busca-handle (INPUT p-wgh-frame,
                      INPUT "numero-homem",
                      OUTPUT wh-nr-homem-en0507b).

    IF  VALID-HANDLE(wh-nr-homem-en0507b)
    THEN DO:
         CREATE FILL-IN wh-nr-homem-new-en0507b
         ASSIGN FRAME             = wh-nr-homem-en0507b:FRAME
                DATA-TYPE         = "Decimal"
                FORMAT            = ">>9.9"
                WIDTH             = wh-nr-homem-en0507b:WIDTH + 2
                HEIGHT            = wh-nr-homem-en0507b:HEIGHT
                ROW               = wh-nr-homem-en0507b:ROW   + 1
                COLUMN            = wh-nr-homem-en0507b:COLUMN
/*                 HIDDEN            = wh-nr-homem-en0507b:HIDDEN            */
/*                 SIDE-LABEL-HANDLE = wh-nr-homem-en0507b:SIDE-LABEL-HANDLE */
/*                 HELP              = wh-nr-homem-en0507b:HELP              */
/*                 TOOLTIP           = wh-nr-homem-en0507b:TOOLTIP           */
                SENSITIVE         = YES
                VISIBLE           = YES.
    
         wh-nr-homem-new-en0507b:MOVE-AFTER-TAB-ITEM(wh-nr-homem-en0507b).
    
         CREATE tt-en0507b-upc.
         ASSIGN tt-en0507b-upc.wg-frame     = wh-nr-homem-en0507b:FRAME
                tt-en0507b-upc.wg-nr-hom    = wh-nr-homem-new-en0507b
                tt-en0507b-upc.wg-container = wh-container-en0507b
                tt-en0507b-upc.wg-folder    = h-folder-en0507b-upc.
         FIND CURRENT tt-en0507b-upc NO-ERROR.
    
         FOR FIRST operacao NO-LOCK
             WHERE ROWID(operacao) = p-row-table,
             FIRST int-ext-operacao USE-INDEX index2 NO-LOCK
             WHERE int-ext-operacao.num-id-operacao = operacao.num-id-operacao:
             ASSIGN tt-en0507b-upc.wg-nr-hom:SCREEN-VALUE = STRING(int-ext-operacao.nro-homem-aps) NO-ERROR.
         END. /* FOR FIRST operacao */
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

IF p-ind-event = "DESTROY" THEN DO:
    ASSIGN l-new-en0507b = NO.
END.

/*PROCEDURE pi-numero-homem.
DEFINE INPUT PARAMETER p-event AS CHARACTER NO-UNDO.

    IF NOT VALID-HANDLE(wh-nr-homem) THEN DO:

        CREATE FILL-IN wh-nr-homem
        ASSIGN NAME       = 'wh-nr-homem':U
               FRAME      = p-wgh-frame
               ROW        = 6.6
               COLUMN     = 74
               HEIGHT     = 0.88
               WIDTH      = 12
               DATA-TYPE  = "Decimal"
               FORMAT     = ">>,9"
               TOOLTIP    = "N£mero Homem"
               HELP       = "N£mero Homem"
               VISIBLE    = TRUE
               SENSITIVE  = YES.

        IF p-event = "ADD" THEN DO:
            FIND FIRST operacao WHERE ROWID(operacao) = p-row-table NO-LOCK NO-ERROR.
            IF AVAIL operacao THEN DO:
                FIND FIRST int-operacao-item
                     WHERE int-operacao-item.op-codigo = operacao.op-codigo 
                       AND int-operacao-item.it-codigo = operacao.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL int-operacao-item THEN
                    ASSIGN int-operacao-item.numero-homem = DEC(REPLACE(wh-nr-homem:SCREEN-VALUE,".", ",")).
                ELSE DO:
                    CREATE int-operacao-item.
                    ASSIGN int-operacao-item.op-codigo    = operacao.op-codigo
                           int-operacao-item.it-codigo    = operacao.it-codigo
                           int-operacao-item.numero-homem = DEC(REPLACE(wh-nr-homem:SCREEN-VALUE,".", ",")).
                END.
            END. 
        END.

        IF p-event = "DISPLAY" THEN DO:
            FIND FIRST operacao WHERE ROWID(operacao) = p-row-table NO-LOCK NO-ERROR.
            IF AVAIL operacao THEN DO:
                FIND FIRST int-operacao-item
                     WHERE int-operacao-item.op-codigo = operacao.op-codigo 
                       AND int-operacao-item.it-codigo = operacao.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL int-operacao-item THEN
                    ASSIGN wh-nr-homem:SCREEN-VALUE = STRING(int-operacao-item.numero-homem).
                ELSE DO:
                    CREATE int-operacao-item.
                    ASSIGN int-operacao-item.op-codigo    = operacao.op-codigo
                           int-operacao-item.it-codigo    = operacao.it-codigo
                           int-operacao-item.numero-homem = DEC(REPLACE(wh-nr-homem:SCREEN-VALUE,".", ",")).
                END.
            END. 

        END.
        
    END.

END PROCEDURE.*/

PROCEDURE pi-nr-oper-pad-new:
    ASSIGN wh-nr-oper-pad-en0507b:SCREEN-VALUE = wh-nr-oper-pad-new-en0507b:SCREEN-VALUE.

    FIND FIRST oper-pad NO-LOCK
         WHERE oper-pad.nr-oper-pad = int(wh-nr-oper-pad-en0507b:SCREEN-VALUE) NO-ERROR.

    IF AVAIL oper-pad THEN
        ASSIGN wh-descricao-en0507b:SCREEN-VALUE = oper-pad.descricao.

    IF wh-nr-oper-pad-new-en0507b:SCREEN-VALUE = "0" 
    OR wh-nr-oper-pad-new-en0507b:SCREEN-VALUE = "" THEN
        ASSIGN wh-descricao-en0507b:SENSITIVE = YES.
    ELSE 
        ASSIGN wh-descricao-en0507b:SENSITIVE = no.

    APPLY "leave" TO wh-nr-oper-pad-en0507b.

    IF l-new-en0507b THEN
        ASSIGN wh-data-inicio-en0507b:SCREEN-VALUE = string(TODAY).
END PROCEDURE.

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
                MESSAGE "O grupo m†quina " grup-maquina.gm-codigo " encontra-se " skip
                        "Desativado no cadastro de Grupo de M†quinas. "
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

procedure pi-inclui-op-ferram:
/*     if not can-find(first grup-maquina where                          */
/*                           grup-maquina.gm-codigo = operacao.gm-codigo */
/* /*                       and grup-maquina.log-1     = no */           */
/*                       and grup-maquina.log-2     = yes                */
/*                           no-lock)                                    */
/*     then return "OK".                                                 */

    if not can-find(first grup-maquina where
                          grup-maquina.gm-codigo = operacao.gm-codigo
                          no-lock)
    then return "OK".

    if not can-find(first int-gm-recurso where
                          int-gm-recurso.gm-codigo   = operacao.gm-codigo
                      and int-gm-recurso.obrigatoria
                          no-lock)
    then return "OK".

    for each int-gm-recurso no-lock
       where int-gm-recurso.gm-codigo = operacao.gm-codigo
         and int-gm-recurso.obrigatoria,
       first ferr-prod fields(cod-ferr-prod un-ciclo) no-lock
       where ferr-prod.cod-ferr-prod = int-gm-recurso.cod-ferr-prod:
        if can-find(first op-ferram where
                          op-ferram.num-id-operacao = operacao.num-id-operacao
                      and op-ferram.op-altern       = 0
                      and op-ferram.ferramenta      = ferr-prod.cod-ferr-prod
                          no-lock)
        then next.

        /* Cria Ferramenta OperaáÖo */
        create op-ferram.
        assign op-ferram.ferramenta      = ferr-prod.cod-ferr-prod
               op-ferram.num-id-operacao = operacao.num-id-operacao
               op-ferram.un-ciclo        = ferr-prod.un-ciclo.

        overlay(op-ferram.char-1,1,1) = "0". /* Sequància */

        overlay(op-ferram.char-1,4,3)   = fill("0",3). /* Tempo Espera */
        overlay(op-ferram.char-1,7,15)  = fill("0",12)
                                        + ",00".       /* Lote M†x */
        overlay(op-ferram.char-1,22,15) = fill("0",12)
                                        + ",00".       /* Lote Ide */
        overlay(op-ferram.char-1,37,6)  = fill("0",3)
                                        + ",00".       /* Ajuste Ex */
           
        find current op-ferram no-lock no-error.
    end. /* for each int-gm-recurso */

    return "OK".
end procedure. /* procedure pi-inclui-op-ferram */

