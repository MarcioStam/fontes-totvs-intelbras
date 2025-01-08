/****************************************************************************
** Programa : UPC_CP0511A
** Descricao: Inclusao filtro por Planejador 
**     Autor: Isac Nilton Abrahao
**      Data: 04/02/2021
*****************************************************************************/
/***  Parametros de recepao da UPC **/

{utp\ut-glob.i}

/*** Parƒmetros de Recep‡Æo da UPC ***/
Def Input Param p-ind-event      As Char            No-Undo.
Def Input Param p-ind-object     As Char            No-Undo.
Def Input Param p-wgh-object     As Handle          No-Undo.
Def Input Param p-wgh-frame      As Widget-Handle   No-Undo.
Def Input Param p-cod-table      As Char            No-Undo.
Def Input Param p-row-table      As Rowid           No-Undo.
 
/*** Defini‡Æo de Vari veis Globais ***/
Def New Global Shared Var wh-objeto       As Widget-Handle No-Undo.
Def New Global Shared Var wh-aux-objeto   As Widget-Handle No-Undo.
Def New Global Shared Var wh-page1        As Widget-Handle No-Undo.

Def New Global Shared Var wh-rec1      As Widget-Handle No-Undo.
Def New Global Shared Var wh-rec2      As Widget-Handle No-Undo.

DEF NEW GLOBAL SHARED VAR wh-txt-plan-cp0511 AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-plan-cp0511     AS HANDLE NO-UNDO.

/*** Defini‡Æo de Vari veis Locais ***/
Def Var c-objeto  As Char No-Undo.
Assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name, "~/").


DEF VAR wh-objeto                AS WIDGET-HANDLE   NO-UNDO.

DEF VAR wh-objeto2               AS WIDGET-HANDLE   NO-UNDO.
DEF VAR wh-objeto3               AS WIDGET-HANDLE   NO-UNDO.
 
DEF NEW GLOBAL SHARED VAR wh-browse-cp0511  AS HANDLE NO-UNDO.


IF p-ind-event  = "AFTER-INITIALIZE" THEN 
DO:
    ASSIGN wh-objeto = p-wgh-frame:FIRST-CHILD
           wh-objeto = wh-objeto:FIRST-CHILD.
     
    DO WHILE VALID-HANDLE(wh-objeto):
       
        IF wh-objeto:TYPE <> "field-group" THEN 
        DO: 
            IF wh-objeto:TYPE = 'TOGGLE-BOX' THEN
               ASSIGN wh-objeto:ROW = wh-objeto:ROW - 0.5.

            IF wh-objeto:TYPE = 'FILL-IN' THEN
               ASSIGN wh-objeto:ROW = wh-objeto:ROW + 0.5.

            IF wh-objeto:TYPE = 'LITERAL' THEN
               ASSIGN wh-objeto:ROW = wh-objeto:ROW + 0.5.

            IF wh-objeto:TYPE = 'IMAGE' THEN
               ASSIGN wh-objeto:ROW = wh-objeto:ROW + 0.5.

            IF wh-objeto:NAME = 'Inicio-ini' THEN 
            DO:
                Create Text wh-txt-plan-cp0511
                Assign frame           = wh-objeto:frame
                       FGCOLOR         = 9  
                       Format          = "x(12)"
                       width           = 10
                       Screen-value    = "Planejador:"
                       row             = 7.7
                       col             = wh-objeto:COL - 8
                       visible         = yes.

                Create fill-in wh-plan-cp0511
                assign frame           = wh-objeto:frame   
                       SIDE-LABEL-HANDLE =  wh-txt-plan-cp0511:HANDLE
                       DATA-TYPE       = 'character'
                       format          = "x(12)"
                       width           = wh-objeto:WIDTH
                       height          = wh-objeto:height 
                       row             = 7
                       col             = wh-objeto:COL
                       Visible         = YES           
                       sensitive       = YES.
            END.
    
          IF wh-objeto:NAME = 'RECT-15' THEN
              ASSIGN wh-rec2  = wh-objeto:HANDLE
                     wh-rec2:ROW = wh-rec2:ROW - 1
                     wh-rec2:HEIGHT = wh-rec2:HEIGHT + 1.
        END.
    
        ASSIGN wh-objeto = wh-objeto:NEXT-SIBLING NO-ERROR.
    END.

END.


IF VALID-HANDLE(wh-txt-plan-cp0511) THEN
   ASSIGN wh-txt-plan-cp0511:SCREEN-VALUE = 'Planejador:'.



IF p-ind-event = 'AFTER-DESTROY-INTERFACE' THEN
DO:
    IF VALID-HANDLE(wh-browse-cp0511) THEN
          APPLY 'entry' TO wh-browse-cp0511.
END.

/*
message "Evento    " p-ind-event  skip        
        "Objeto    " p-ind-object skip        
        "nome obj  " c-objeto     skip        
        "Frame     " p-wgh-frame  skip        
        "Tabela    " p-cod-table  skip        
        "ROWID     " string(p-row-table) SKIP 
        view-as alert-box information.        
        */
