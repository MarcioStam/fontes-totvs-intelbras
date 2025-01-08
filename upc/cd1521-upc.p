/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/
define input parameter p-ind-event  as character.
define input parameter p-ind-object as character.
define input parameter p-wgh-object as handle.
define input parameter p-wgh-frame  as widget-handle.
define input parameter p-cod-table  as character.
define input parameter p-row-table  as rowid.

DEF VAR c-objeto   AS CHAR     NO-UNDO.

define var h-frame                                   as widget-handle no-undo. 
define new global shared var wh-txt-estabel-cd1521   as widget-handle no-undo.
define new global shared VAR wh-cod-estabel-cd1521   as widget-handle no-undo.
define new global shared var wh-cod-canal-cd1521     as widget-handle no-undo.
define new global shared VAR wh-cod-emitente-cd1521  as widget-handle no-undo.
define new global shared var whcod-estabel           as widget-handle no-undo.

assign c-objeto = entry(num-entries(p-wgh-object:private-data, "~/"), p-wgh-object:private-data, "~/").                        

/* MESSAGE "Evento " p-ind-event  SKIP        */
/*         "Objeto " p-ind-object SKIP        */
/*         "Tabela " p-cod-table  SKIP        */
/*         "Rowid  " STRING(p-row-table) SKIP */
/*         "Objeto " c-objeto     SKIP        */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK. */

IF p-ind-object = "VIEWER"              AND
   c-objeto     = "v01di246.w"  THEN DO:

    /* ROTINA PARA DESABILITAR O CAMPO DATA IMPLANTAÄ«O DA TELA */
    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    DO WHILE h-frame <> ?:
          IF h-frame:TYPE <> "field-group" THEN DO:  
             CASE h-frame:NAME:
             END CASE.
             ASSIGN h-frame = h-frame:NEXT-SIBLING.
          END.
          ELSE DO:
             ASSIGN h-frame = h-frame:FIRST-CHILD.
          END.
    END.

    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "cod-canal-venda",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cod-canal-cd1521).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "fill-in",     /*** Type ***/
                      INPUT "cod-emitente",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-cod-emitente-cd1521).
        CREATE TEXT wh-txt-estabel-cd1521
        ASSIGN FRAME        = wh-cod-canal-cd1521:FRAME
               FORMAT       = "x(17)"   
               WIDTH        = 12
               SCREEN-VALUE = "     Estabelecimento:"
               ROW          = 11.6
               COL          = 57
               VISIBLE      = YES.

        CREATE FILL-IN wh-cod-estabel-cd1521
        ASSIGN FRAME             = wh-cod-canal-cd1521:FRAME
               DATA-TYPE         = "character"
               FORMAT            = "x(03)" 
               WIDTH             = wh-cod-canal-cd1521:WIDTH
               HEIGHT            = wh-cod-canal-cd1521:HEIGHT
               ROW               = 11.5
               COL               = 70
               SIDE-LABEL-HANDLE = wh-txt-estabel-cd1521:HANDLE
               VISIBLE           = YES
               SENSITIVE         = NO.
    END.
    ELSE
    IF p-ind-event = "INITIALIZE" THEN DO:
        ASSIGN wh-txt-estabel-cd1521:VISIBLE      = YES
               wh-txt-estabel-cd1521:SCREEN-VALUE = "Estabelecimento:".
        wh-txt-estabel-cd1521:MOVE-TO-TOP().
    END.
    ELSE IF p-ind-event = "after-enable" THEN DO:
        ASSIGN wh-cod-estabel-cd1521:SENSITIVE = TRUE. 
    END.
    ELSE IF p-ind-event = "after-disable" THEN DO:
        ASSIGN wh-cod-estabel-cd1521:SENSITIVE = FALSE.
    END.
    ELSE IF p-ind-event = "display" THEN DO:
        FIND int-canal-cliente
             WHERE int-canal-cliente.cod-canal-venda = int(wh-cod-canal-cd1521:SCREEN-VALUE)
               AND int-canal-cliente.cod-emitente    = int(wh-cod-emitente-cd1521:SCREEN-VALUE)
               NO-LOCK NO-ERROR.
        IF AVAIL int-canal-cliente THEN DO:
           ASSIGN wh-cod-estabel-cd1521:SCREEN-VALUE = STRING(int-canal-cliente.cod-estabel).
        END.
        ELSE
           ASSIGN wh-cod-estabel-cd1521:SCREEN-VALUE = "".
    END.
    ELSE IF p-ind-event = "validate" THEN DO:

        FIND estabelec
             WHERE estabelec.cod-estabel = wh-cod-estabel-cd1521:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAIL estabelec THEN DO:
           run utp/ut-msgs.p (INPUT "show":U, 
                              INPUT 17567, 
                              INPUT "Estabelecimento n∆o encontrado" ).
            APPLY 'entry' TO wh-cod-estabel-cd1521. 
            RETURN "nok".
        END.
    END.
    ELSE IF p-ind-event = "AFTER-END-UPDATE" THEN DO:

        FIND int-canal-cliente
             WHERE int-canal-cliente.cod-canal-venda = int(wh-cod-canal-cd1521:SCREEN-VALUE)
               AND int-canal-cliente.cod-emitente    = int(wh-cod-emitente-cd1521:SCREEN-VALUE)
               exclusive-LOCK NO-ERROR.
        IF NOT AVAIL int-canal-cliente THEN DO:
           CREATE int-canal-cliente.
           ASSIGN int-canal-cliente.cod-canal-venda  = int(wh-cod-canal-cd1521:SCREEN-VALUE)
                  int-canal-cliente.cod-emitente     = int(wh-cod-emitente-cd1521:SCREEN-VALUE).
           
        END.
        ASSIGN int-canal-cliente.cod-estabel = wh-cod-estabel-cd1521:SCREEN-VALUE.


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
