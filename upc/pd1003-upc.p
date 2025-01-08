/***********************************************************************
**  Programa..: upc\pd1003-upc.p
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
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-unid-negoc      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-comprim         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-largura         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-altura          AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-unid-negoc      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-des-unid-negoc  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-comprim         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-largura         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-altura          AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-frame           AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-fator-conver      AS WIDGET-HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.

DEFINE VARIABLE c-char AS   CHAR.

assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/*
MESSAGE "Evento " p-ind-event  SKIP
        "Objeto " p-ind-object SKIP
        "Nome   " c-char SKIP
        "Tabela " p-cod-table  SKIP
        "Rowid  " STRING(p-row-table)
    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
*/

IF  p-ind-event  = "DISPLAY"
AND c-char       = "v24in172.w" THEN DO:
    IF NOT VALID-HANDLE(wh-unid-negoc) THEN DO:
        ASSIGN wh-frame = p-wgh-frame. 
        ASSIGN wh-frame:HEIGHT = wh-frame:HEIGHT + 1.
    

        CREATE TEXT tx-unid-negoc
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(19)"
               WIDTH        = 19
               SCREEN-VALUE = "Unidade de Neg¢cio:"
               ROW          = 9.2
               COL          = 8.5
               VISIBLE      = YES.
    
        CREATE FILL-IN wh-unid-negoc
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "CHARACTER"
               FORMAT            = "x(3)" 
               WIDTH             = 5
               HEIGHT            = 0.88
               ROW               = 9
               COL               = 23.4
               VISIBLE           = YES
               SENSITIVE         = NO.

        CREATE FILL-IN wh-des-unid-negoc
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "CHARACTER"
               FORMAT            = "x(40)" 
               WIDTH             = 40
               HEIGHT            = 0.88
               ROW               = 9
               COL               = 29
               VISIBLE           = YES
               SENSITIVE         = NO.
    END.

    FIND FIRST ITEM NO-LOCK
         WHERE ROWID(ITEM) = p-row-table NO-ERROR.

    IF  AVAIL ITEM 
    AND VALID-HANDLE(wh-unid-negoc) THEN DO:

        FIND FIRST unid_negoc NO-LOCK
             WHERE unid_negoc.cod_unid_negoc = item.cod-unid-negoc NO-ERROR.

        ASSIGN wh-unid-negoc:SCREEN-VALUE     = STRING(ITEM.cod-unid-negoc)  
               wh-des-unid-negoc:SCREEN-VALUE = STRING(unid_negoc.des_unid_negoc).      
    END.
END.

IF  p-ind-event  = "DISPLAY"
AND c-char       = "v48in172.w" THEN DO:
    
    IF NOT VALID-HANDLE(wh-comprim) THEN DO:
        ASSIGN wh-frame = p-wgh-frame. 
    
        ASSIGN wh-frame:WIDTH  = 80
               wh-frame:HEIGHT = 10.
        /*
        ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
        ASSIGN h-object = h-object:FIRST-CHILD.
        
        DO WHILE VALID-HANDLE(h-object):
            IF h-object:TYPE <> "field-group" THEN DO:
                MESSAGE h-object:NAME
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                IF h-object:NAME = 'fator-conver' THEN DO:
                    ASSIGN wh-fator-conver = h-object.
                    LEAVE.
                END.
                ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
            END.
            ELSE LEAVE.
        END.
        */
    
        CREATE TEXT tx-comprim
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(15)"
               WIDTH        = 13
               SCREEN-VALUE = "   Comprimento:"
               ROW          = 1.2
               COL          = 53
               VISIBLE      = YES.
        
        CREATE FILL-IN wh-comprim
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>,>>9.999" 
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 1
               COL               = 64
               VISIBLE           = YES
               SENSITIVE         = NO.
    
        IF  VALID-HANDLE(wh-comprim)   AND VALID-HANDLE(tx-comprim) THEN 
            ASSIGN wh-comprim:SCREEN-VALUE  = "0,000". 
        
        CREATE TEXT tx-largura
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(10)"
               WIDTH        = 13
               SCREEN-VALUE = "  Largura:"
               ROW          = 2.2
               COL          = 57
               VISIBLE      = YES.
        
        CREATE FILL-IN wh-largura
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>,>>9.999" 
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 2
               COL               = 64
               VISIBLE           = YES
               SENSITIVE         = NO.
    
        IF  VALID-HANDLE(wh-largura)   AND VALID-HANDLE(tx-largura) THEN
            ASSIGN wh-largura:SCREEN-VALUE  = "0,000". 
        
        CREATE TEXT tx-altura
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(13)"
               WIDTH        = 13
               SCREEN-VALUE = "     Altura:"
               ROW          = 3.2
               COL          = 57
               VISIBLE      = YES.
        
        CREATE FILL-IN wh-altura
        ASSIGN FRAME             = p-wgh-frame
               DATA-TYPE         = "decimal"
               FORMAT            = ">>>,>>9.999" 
               WIDTH             = 10
               HEIGHT            = 0.88
               ROW               = 3
               COL               = 64
               VISIBLE           = YES
               SENSITIVE         = NO.
    END.

    FIND FIRST ITEM NO-LOCK
         WHERE ROWID(ITEM) = p-row-table NO-ERROR.

    IF AVAIL ITEM 
    AND VALID-HANDLE(wh-comprim) THEN
        ASSIGN wh-comprim:SCREEN-VALUE  = STRING(ITEM.comprim,">>>,>>9.999")  
               wh-altura:SCREEN-VALUE   = STRING(ITEM.altura,">>>,>>9.999")       
               wh-largura:SCREEN-VALUE  = STRING(ITEM.largura,">>>,>>9.999").
END.

