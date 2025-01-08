/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: upc/cd0904-upc.p
**  Objetivo.: Espec°fico do programa Atualizaá∆o Unidades Federaá∆o - CD0904
**  Criaá∆o..: 06/05/2010
**  Vers∆o...: 00001 - 06/05/2010 - Inserir o campo
**             int-unid-feder.cod-transp-padrao (Transportador Padr∆o) - Fabiano
**             Sakae Ribeiro (SQL Works).
**
*******************************************************************************/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE          NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER       NO-UNDO.
DEFINE INPUT PARAMETER p-row-table  AS ROWID           NO-UNDO.

DEFINE VARIABLE c-object AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-object AS HANDLE      NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE tx-cod-transp-padrao AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-transp-padrao AS WIDGET-HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-moeda-icms        AS WIDGET-HANDLE   NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-perc-red-subst-simples AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-perc-red-subst-simples AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-quebra-nota      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-simples-red-base AS WIDGET-HANDLE NO-UNDO.


ASSIGN c-object = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME, "/":U), p-wgh-object:FILE-NAME, "/":U).

/* Mensagem com os eventos UPC do programa (Comentar quando n∆o estiver usando) */
/*MESSAGE "Evento: ":U p-ind-event         SKIP
        "Objeto: ":U p-ind-object        SKIP
        "Nome: ":U   c-object            SKIP
        "Tabela: ":U p-cod-table         SKIP
        "Rowid: ":U  string(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

/* Gerar arquivo com os eventos UPC do programa (Comentar quando n∆o estiver usando) */
/*OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "/eventos-upc-cd0904.txt":U) APPEND CONVERT TARGET SESSION:CHARSET.
PUT UNFORMATTED
    "Evento.: ":U p-ind-event         SKIP
    "Objeto.: ":U p-ind-object        SKIP
    "Nome...: ":U c-object            SKIP
    "Tabela.: ":U p-cod-table         SKIP
    "Rowid..: ":U STRING(p-row-table) SKIP
    FILL("-":U, 50)                   SKIP.
OUTPUT CLOSE.*/


IF p-ind-event = "INITIALIZE":U THEN DO:

    IF c-object = "v03un007.w":U THEN DO:
        CREATE TOGGLE-BOX wh-quebra-nota
        ASSIGN FRAME             = p-wgh-frame
               WIDTH             = 24
               HEIGHT            = 0.88
               ROW               = 3.54
               COL               = 65
               VISIBLE           = YES
               SENSITIVE         = NO
               LABEL             = "Quebra Nota - Protocolo ICMS"
               HELP              = "Estado quebra pedido em mais notas, de acordo com protocolo de ICMS do item"
               TOOLTIP           = "Estado Quebra Pedido, Protocolo de ICMS".

        CREATE TOGGLE-BOX wh-simples-red-base
        ASSIGN FRAME             = p-wgh-frame
               WIDTH             = 18
               HEIGHT            = 0.88
               ROW               = 3.65
               COL               = 4.4
               VISIBLE           = YES
               SENSITIVE         = NO
               LABEL             = "Simples n∆o Red. Base"
               HELP              = "Venda para optante do Simples, n∆o Reduzir Base de c†lculo"
               TOOLTIP           = "Simples n∆o Reduz Base Calc".
    END.

    IF c-object = "v02un007.w":U THEN DO:

        ASSIGN h-object = p-wgh-frame:FIRST-CHILD
               h-object = h-object:FIRST-CHILD.

        DO WHILE VALID-HANDLE(h-object):
            IF h-object:TYPE <> "field-group":U THEN DO:
                IF h-object:NAME = "int-2":U THEN
                    ASSIGN wh-moeda-icms = h-object.
                ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
            END.
            ELSE LEAVE.
        END.

        CREATE TEXT tx-cod-transp-padrao
        ASSIGN FRAME             = p-wgh-frame
               FORMAT            = "x(15)":U
               WIDTH             = 15
               SCREEN-VALUE      = "Transp. Padr∆o:":U
               ROW               = 1.39
               COLUMN            = 29.5
               VISIBLE           = YES.
               
        CREATE FILL-IN wh-cod-transp-padrao
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "Integer":U
               FORMAT            = ">>>>>>>9":U
               WIDTH             = 8
               HEIGHT            = 0.89
               ROW               = tx-cod-transp-padrao:ROW - 0.17
               COLUMN            = tx-cod-transp-padrao:COLUMN + 11.3
               VISIBLE           = YES
               SENSITIVE         = NO
               TRIGGERS:
                    ON "F5":U PERSISTENT RUN upc/cd0904-upczoom.p.
                    ON "MOUSE-SELECT-DBLCLICK":U PERSISTENT RUN upc/cd0904-upczoom.p.
               END TRIGGERS.

        wh-cod-transp-padrao:LOAD-MOUSE-POINTER("image/lupa.cur":U).
        wh-cod-transp-padrao:MOVE-AFTER-TAB-ITEM(wh-moeda-icms).


        CREATE TEXT tx-perc-red-subst-simples
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(11)"
               WIDTH        = 11
               SCREEN-VALUE = "% Red  SN:"
               ROW          = 3.60
               COL          = 33.0
               VISIBLE      = YES.

        CREATE FILL-IN wh-perc-red-subst-simples
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "Decimal"
               /* FORMAT            = "Dec" */
               WIDTH             = 5
               HEIGHT            = 0.98
               ROW               = 3.39
               COL               = 41
               VISIBLE           = YES
               SENSITIVE         = NO

               SIDE-LABEL-HANDLE = tx-perc-red-subst-simples:HANDLE.

    END. /* IF c-object = "v02un007.w":U THEN DO: */

END. /* IF p-ind-event = "INITIALIZE":U THEN DO: */

IF p-ind-event  = "DISPLAY":U AND
   p-ind-object = "VIEWER":U  THEN DO:
    
    FIND FIRST unid-feder
        WHERE ROWID(unid-feder) = p-row-table NO-LOCK NO-ERROR.
        
    IF AVAILABLE(unid-feder) THEN DO:
        FIND FIRST int-unid-feder
            WHERE int-unid-feder.pais   = unid-feder.pais
              AND int-unid-feder.estado = unid-feder.estado NO-LOCK NO-ERROR.
            
        IF  AVAILABLE(int-unid-feder) THEN DO:
        
            IF  VALID-HANDLE(wh-cod-transp-padrao) THEN
                ASSIGN wh-cod-transp-padrao:SCREEN-VALUE = STRING(int-unid-feder.cod-transp-padrao, ">>>>>>>9":U)
                       wh-perc-red-subst-simples:SCREEN-VALUE = STRING(int-unid-feder.perc-red-subst-simples, ">>9.99":U).
            
            IF  VALID-HANDLE(wh-quebra-nota) 
            AND VALID-HANDLE(wh-simples-red-base) THEN
                ASSIGN wh-quebra-nota:SCREEN-VALUE      = string(int-unid-feder.quebra-nota-protoc-icms)
                       wh-simples-red-base:SCREEN-VALUE = string(int-unid-feder.simples-nao-red-base).
        END.
        ELSE DO:
        
            IF  VALID-HANDLE(wh-cod-transp-padrao) THEN
                ASSIGN wh-cod-transp-padrao:SCREEN-VALUE = "":U
                      wh-perc-red-subst-simples:SCREEN-VALUE = "":U.

            IF  VALID-HANDLE(wh-quebra-nota) THEN
                ASSIGN wh-quebra-nota:SCREEN-VALUE      = "NO"
                       wh-simples-red-base:SCREEN-VALUE = "NO".
        END.
    END.
    ELSE DO:

        IF  VALID-HANDLE(wh-cod-transp-padrao) THEN    
            ASSIGN wh-cod-transp-padrao:SCREEN-VALUE = "":U
                   wh-perc-red-subst-simples:SCREEN-VALUE = "":U.
        IF  VALID-HANDLE(wh-quebra-nota) THEN
            ASSIGN wh-quebra-nota:SCREEN-VALUE      = "NO"
                   wh-simples-red-base:SCREEN-VALUE = "NO".
    END.
    
    
END. /* IF p-ind-event = "DISPLAY":U AND p-ind-object = "VIEWER":U THEN DO: */

IF p-ind-event  = "AFTER-VALIDATE":U AND
   p-ind-object = "VIEWER":U         THEN DO:

   IF  VALID-HANDLE(wh-cod-transp-padrao) THEN DO:
      
       FIND FIRST transporte
           WHERE transporte.cod-transp = INTEGER(wh-cod-transp-padrao:SCREEN-VALUE) NO-LOCK NO-ERROR.
      
       IF NOT AVAILABLE(transporte) THEN DO:
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 158,
                              INPUT "Transportador":U).
           APPLY "ENTRY":U TO wh-cod-transp-padrao.
           RETURN "NOK":U.
       END.
   END.
END.

IF p-ind-event  = "ASSIGN":U AND
   p-ind-object = "VIEWER":U     THEN DO:
    
    IF VALID-HANDLE(wh-cod-transp-padrao) THEN DO:

        FIND FIRST unid-feder
            WHERE ROWID(unid-feder) = p-row-table NO-LOCK NO-ERROR.
            
        IF AVAILABLE unid-feder THEN DO:
            
            FIND FIRST int-unid-feder
                WHERE int-unid-feder.pais   = unid-feder.pais
                  AND int-unid-feder.estado = unid-feder.estado EXCLUSIVE-LOCK NO-ERROR.
                
            IF NOT AVAILABLE int-unid-feder THEN DO:
                CREATE int-unid-feder.
                ASSIGN int-unid-feder.pais   = unid-feder.pais
                       int-unid-feder.estado = unid-feder.estado.
            END.
                
            ASSIGN int-unid-feder.cod-transp-padrao       = INTEGER(wh-cod-transp-padrao:SCREEN-VALUE)
                   int-unid-feder.perc-red-subst-simples  = dec(wh-perc-red-subst-simples:SCREEN-VALUE).

            ASSIGN int-unid-feder.quebra-nota-protoc-icms = IF  wh-quebra-nota:SCREEN-VALUE      = "yes" THEN YES ELSE NO
                   int-unid-feder.simples-nao-red-base    = IF  wh-simples-red-base:SCREEN-VALUE = "yes" THEN YES ELSE NO.
            
         END.

    END. /* IF VALID-HANDLE(wh-cod-transp-padrao) THEN DO: */
        
END. /* IF p-ind-event = "END-UPDATE":U AND p-ind-object = "VIEWER":U THEN DO: */


IF p-ind-event  = "DELETE":U AND
   p-ind-object = "VIEWER":U THEN DO:
    
    IF VALID-HANDLE(wh-cod-transp-padrao) THEN DO:
        
        FIND FIRST unid-feder
            WHERE ROWID(unid-feder) = p-row-table NO-LOCK NO-ERROR.
            
        IF AVAILABLE unid-feder THEN DO:
            
            FIND FIRST int-unid-feder
                WHERE int-unid-feder.pais   = unid-feder.pais
                  AND int-unid-feder.estado = unid-feder.estado EXCLUSIVE-LOCK NO-ERROR.
                
            IF AVAILABLE int-unid-feder THEN
                DELETE int-unid-feder.
        END.

    END. /* IF VALID-HANDLE(wh-cod-transp-padrao) THEN DO: */
    
END. /* IF p-ind-event = "DELETE":U AND p-ind-object = "VIEWER":U THEN DO: */

IF p-ind-event  = "ADD":U    AND
   p-ind-object = "VIEWER":U THEN DO:
    
    IF VALID-HANDLE(wh-cod-transp-padrao) THEN
        ASSIGN wh-cod-transp-padrao:SENSITIVE      = YES
               tx-cod-transp-padrao:SCREEN-VALUE   = "Transp. Padr∆o:":U
               wh-perc-red-subst-simples:SENSITIVE = YES.

    IF  VALID-HANDLE(wh-quebra-nota) THEN
        ASSIGN wh-quebra-nota:SENSITIVE      = YES
               wh-simples-red-base:SENSITIVE = YES.
    
END. /* IF p-ind-event = "ADD":U AND p-ind-object = "VIEWER":U THEN DO: */

IF p-ind-event  = "AFTER-ENABLE":U AND
   p-ind-object = "VIEWER":U       THEN DO:
    
    IF  VALID-HANDLE(wh-cod-transp-padrao) THEN
        ASSIGN wh-cod-transp-padrao:SENSITIVE      = YES
               tx-cod-transp-padrao:SCREEN-VALUE   = "Transp. Padr∆o:":U
               wh-perc-red-subst-simples:SENSITIVE = YES.

    IF  VALID-HANDLE(wh-quebra-nota) THEN
        ASSIGN wh-quebra-nota:SENSITIVE      = YES
               wh-simples-red-base:SENSITIVE = YES.

END. /* IF p-ind-event = "AFTER-ENABLE":U AND p-ind-object = "VIEWER":U THEN DO: */

IF p-ind-event  = "AFTER-DISABLE":U AND
   p-ind-object = "VIEWER":U        THEN DO:
    
    IF  VALID-HANDLE(wh-cod-transp-padrao) THEN
        ASSIGN wh-cod-transp-padrao:SENSITIVE      = NO
               wh-perc-red-subst-simples:SENSITIVE = NO.
        
    IF  VALID-HANDLE(wh-quebra-nota) THEN
        ASSIGN wh-quebra-nota:SENSITIVE      = NO
               wh-simples-red-base:SENSITIVE = NO.
    
END. /* IF p-ind-event = "AFTER-DISABLE":U AND p-ind-object = "VIEWER":U THEN DO: */

IF p-ind-event  = "AFTER-CANCEL":U AND
   p-ind-object = "VIEWER":U       THEN DO:
    
    IF  VALID-HANDLE(wh-cod-transp-padrao) THEN
        ASSIGN wh-cod-transp-padrao:SENSITIVE      = NO
               wh-perc-red-subst-simples:SENSITIVE = NO.

    IF  VALID-HANDLE(wh-quebra-nota) THEN
        ASSIGN wh-quebra-nota:SENSITIVE      = NO
               wh-simples-red-base:SENSITIVE = NO.
    
END. /* IF p-ind-event = "AFTER-CANCEL":U AND p-ind-object = "VIEWER":U THEN DO: */

RETURN "Ok".
