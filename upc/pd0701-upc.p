/***********************************************************************
**  Programa..: UPC\PD0701-UPC.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Implantaá∆o Batch Pedidos
**  Vers∆o....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF NEW GLOBAL SHARED VAR vLogLimpaDesc     AS LOGICAL       NO-UNDO.

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").
  
/****************************  Variaveis    ****************************/
IF  p-ind-object  = "CONTAINER"         AND 
    c-objeto      = "PD0701.W"         THEN DO:
    IF  p-ind-event   = "INITIALIZE" THEN 
        ASSIGN vLogLimpaDesc = YES.
END.
