/***********************************************************************
**  Programa..: UPC\eq0506A-UPC.P
**  Autor.....: Giovane Alves - Sys Developer
**  Data......: JANEIRO/2008 - Desenvolvimento
**  Descricao.: UPC Manuten‡Æo Prepara‡Æo Faturamento Manual
**  VersÆo....: 001 14/01/2008
**                  Desenvolvimento Programa
**               Bloqueia o acesso a embarques que nÆo sejam do      
**               estabelecimento do usu rio logado                     
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

def var h-frame                                 as widget-handle no-undo.
def new global SHARED VAR wh-btok-eq0506b2                        as widget-handle no-undo.
def new global SHARED VAR wh-btok-customizado-eq0506b2            as widget-handle no-undo.

def new global shared var h-upc-eq0506b2-upc    as handle no-undo.
DEF new global shared VAR h-dt-entrega-fim-eq0506b2               as widget-handle no-undo.
{upc/btb910za-upc.i}
DEF VAR c-objeto        AS CHAR                     NO-UNDO.
def var h-object        as handle                   no-undo. 

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").



/*     MESSAGE "Evento " p-ind-event  SKIP    */
/*             "Objeto " p-ind-object SKIP    */
/*             "Nome   " c-objeto SKIP        */
/*             "Tabela " p-cod-table  SKIP    */
/*             "Rowid  " STRING(p-row-table)  */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */


  

IF p-ind-object = "container"              AND 
   c-objeto     = "eq0506B2.W"  AND 
   p-ind-event = "BEFORE-INITIALIZE" THEN DO:

  ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
  ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
  RUN tela-upc (INPUT p-wgh-frame,
                INPUT p-ind-Event,
                INPUT "BUTTON",     /*** Type ***/
                INPUT "bt-ok",         /*** Name ***/
                INPUT no,            /*** Apresenta Mensagem dos Objetos ***/
                INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                OUTPUT wh-btok-eq0506b2).

  run tela-upc (input p-wgh-frame,
                input p-ind-Event,
                input 'fill-in':U,
                input 'dt-entrega-fim':U,
                input NO,
                INPUT 1,
                output h-dt-entrega-fim-eq0506b2).

  ASSIGN wh-btok-eq0506b2:SENSITIVE = NO.

    IF VALID-HANDLE(wh-btok-eq0506b2) THEN DO:
      run upc/eq0506b2-upc.p persistent set h-upc-eq0506b2-upc (input '':U        ,
                                                                input '':U        ,
                                                                input p-wgh-object,
                                                                input p-wgh-frame ,
                                                                input '':U        ,
                                                                input p-row-table).

      create button wh-btok-customizado-eq0506b2
      assign frame     = wh-btok-eq0506b2:frame
             width     = wh-btok-eq0506b2:width
             height    = wh-btok-eq0506b2:height
             label     = wh-btok-eq0506b2:LABEL
             tooltip   = wh-btok-eq0506b2:TOOLTIP
             row       = wh-btok-eq0506b2:row
             col       = wh-btok-eq0506b2:COL
             visible   = yes
             sensitive = yes
             triggers:
                 on choose persistent run pi-tratar-operacao in h-upc-eq0506b2-upc.
             end triggers.
       
  END.

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

PROCEDURE pi-tratar-operacao:
    
    IF date(h-dt-entrega-fim-eq0506b2:SCREEN-VALUE) > TODAY THEN DO:
        MESSAGE "Data entrega final superior a data atual"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE
        APPLY 'choose':U TO wh-btok-eq0506b2.
END PROCEDURE.
