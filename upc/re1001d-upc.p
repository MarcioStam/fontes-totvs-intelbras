/***********************************************************************
**  Programa..: upc\re1001d-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-fpage1            AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-fpage2            AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nat-oper         AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-especie          AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-natur-frete      AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-valor-desp    AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rs-trib-pis      AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-aliq-pis      AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-base-pis      AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-valor-pis     AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rs-trib-cofins   AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-aliq-cofins   AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-base-cofins   AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-de-valor-cofins  AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cb-tipo-cte      AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btcheck          AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btok             AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-btsave           AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cod-emitente-ace AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-serie-ace        AS HANDLE   NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nro-docto-ace    AS HANDLE   NO-UNDO.

/*
DEFINE VARIABLE c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").


MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

IF  p-ind-event  = "BEFORE-INITIALIZE" 
THEN DO:
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" 
        THEN DO:
            IF h-object:NAME = 'btok' 
            THEN 
                ASSIGN wh-btok = h-object. 

            IF h-object:NAME = 'btsave' 
            THEN 
                ASSIGN wh-btsave = h-object. 

            IF h-object:NAME = 'fPage1' 
            THEN 
                ASSIGN h-fpage1 = h-object. 

            IF h-object:NAME = 'fPage2' 
            THEN 
                ASSIGN h-fpage2 = h-object. 

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-fpage1 = h-fpage1:FIRST-CHILD.
    ASSIGN h-fpage1 = h-fpage1:FIRST-CHILD.
    DO WHILE VALID-HANDLE(h-fpage1):
        IF h-fpage1:TYPE <> "field-group" 
        THEN DO:
            IF  h-fpage1:NAME = 'nat-oper-ac' 
            THEN 
                ASSIGN wh-nat-oper = h-fpage1.

            IF  h-fpage1:NAME = 'cod-forn-ac' 
            THEN 
                ASSIGN wh-cod-emitente-ace = h-fpage1.

            IF  h-fpage1:NAME = 'ser-docto-ac' 
            THEN 
                ASSIGN wh-serie-ace = h-fpage1.

            IF  h-fpage1:NAME = 'nro-docto-ac' 
            THEN 
                ASSIGN wh-nro-docto-ace = h-fpage1.

            IF  h-fpage1:NAME = "cod-esp"
            THEN
                ASSIGN wh-especie = h-fpage1.

            IF  h-fpage1:NAME = "rs-natur-frete"
            THEN
                ASSIGN wh-natur-frete = h-fpage1.

            IF  h-fpage1:NAME = "valor"
            THEN
               ASSIGN wh-de-valor-desp = h-fpage1.

            IF  h-fpage1:NAME = "btcheck"
            THEN
                ASSIGN wh-btcheck = h-fpage1.

            IF  h-fpage1:NAME = "cb-tipo-cte"
            THEN
                ASSIGN wh-cb-tipo-cte = h-fpage1.

            ASSIGN h-fpage1 = h-fpage1:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    ASSIGN h-fpage2 = h-fpage2:FIRST-CHILD.
    ASSIGN h-fpage2 = h-fpage2:FIRST-CHILD.
    DO WHILE VALID-HANDLE(h-fpage2):
        IF h-fpage2:TYPE <> "field-group" 
        THEN DO:
            IF h-fpage2:NAME = 'rs-trib-pis' 
            THEN
                ASSIGN wh-rs-trib-pis = h-fpage2.

            IF h-fpage2:NAME = 'de-aliq-pis' 
            THEN
                ASSIGN wh-de-aliq-pis = h-fpage2.

            IF h-fpage2:NAME = 'de-base-pis' 
            THEN
                ASSIGN wh-de-base-pis = h-fpage2.

            IF h-fpage2:NAME = 'de-valor-pis' 
            THEN
                ASSIGN wh-de-valor-pis = h-fpage2.

            IF h-fpage2:NAME = 'rs-trib-cofins' 
            THEN
                ASSIGN wh-rs-trib-cofins = h-fpage2.

            IF h-fpage2:NAME = 'de-aliq-cofins' 
            THEN
                ASSIGN wh-de-aliq-cofins = h-fpage2.

            IF h-fpage2:NAME = 'de-base-cofins' 
            THEN
                ASSIGN wh-de-base-cofins = h-fpage2.

            IF h-fpage2:NAME = 'de-valor-cofins' 
            THEN
                ASSIGN wh-de-valor-cofins = h-fpage2.

            ASSIGN h-fpage2 = h-fpage2:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

END.

IF  p-ind-event = "AFTER-INITIALIZE"
THEN DO:
    IF  VALID-HANDLE(wh-natur-frete)
    THEN
        ASSIGN wh-natur-frete:SENSITIVE = NO.

    IF  VALID-HANDLE(wh-rs-trib-pis)
    THEN
        ASSIGN wh-rs-trib-pis:SENSITIVE     = NO 
               wh-de-aliq-pis:SENSITIVE     = NO
               wh-de-base-pis:SENSITIVE     = NO
               wh-de-valor-pis:SENSITIVE    = NO
               wh-rs-trib-cofins:SENSITIVE  = NO
               wh-de-aliq-cofins:SENSITIVE  = NO
               wh-de-base-cofins:SENSITIVE  = NO
               wh-de-valor-cofins:SENSITIVE = NO.

    IF  VALID-HANDLE(wh-nat-oper) AND
        VALID-HANDLE(wh-especie)
    THEN
        ON 'ENTRY':U OF wh-especie PERSISTENT RUN upc/re1001d-upca.p (INPUT 1).

    IF  VALID-HANDLE(wh-btok)
    THEN DO:
        ON 'ENTRY' OF wh-btok   PERSISTENT RUN upc/re1001d-upca.p (INPUT 2).
        ON 'ENTRY' OF wh-btsave PERSISTENT RUN upc/re1001d-upca.p (INPUT 2).
    END.
        
END.

IF  p-ind-event = "BEFORE-ASSIGN"
THEN DO:

    FIND FIRST despesa-aces USE-INDEX despesa-aces WHERE
               despesa-aces.ser-docto-ac = wh-serie-ace:SCREEN-VALUE             AND
               despesa-aces.nro-docto-ac = wh-nro-docto-ace:SCREEN-VALUE         AND
               despesa-aces.cod-forn-ac  = INT(wh-cod-emitente-ace:SCREEN-VALUE) AND
               despesa-aces.nat-oper-ac <> wh-nat-oper:SCREEN-VALUE
               NO-LOCK NO-ERROR.

    IF AVAIL despesa-aces 
    THEN DO: 
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 27100,
                           INPUT "Foi encontrada outra despesa com natureza diferente em outra NF. Deseja continuar?~~Segue abaixo identificaá∆o da NF: " + CHR(13)
                                  + "Emitente: " + string(despesa-aces.cod-emitente) + CHR(13)
                                  + "Serie: " + STRING(despesa-aces.serie-docto)     + CHR(13)
                                  + "Nr Doc: " + STRING(despesa-aces.nro-docto)      + CHR(13)
                                  + "Nat: " + STRING(despesa-aces.nat-operacao)
                                  ).
        IF RETURN-VALUE = "NO" THEN RETURN ERROR.

    END.
END.

IF  p-ind-event = "AFTER-DESTROY-INTERFACE"
THEN
    ASSIGN h-fpage1            = ?
           h-fpage2            = ?
           wh-nat-oper         = ?
           wh-especie          = ?
           wh-natur-frete      = ?
           wh-rs-trib-pis      = ?
           wh-de-aliq-pis      = ?
           wh-de-base-pis      = ?
           wh-de-valor-pis     = ?
           wh-rs-trib-cofins   = ?
           wh-de-aliq-cofins   = ?
           wh-de-base-cofins   = ?
           wh-de-valor-cofins  = ?
           wh-cb-tipo-cte      = ?
           wh-btcheck          = ?
           wh-btok             = ?
           wh-btsave           = ?
           wh-cod-emitente-ace = ?
           wh-serie-ace        = ?
           wh-nro-docto-ace    = ?.

